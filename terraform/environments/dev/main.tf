# ============================================================
# Ambiente DEV — compõe os módulos da plataforma.
# NOTA: App Runner está fechado para novos clientes (ADR-0007).
#       Para novas contas, troque o módulo app-runner por ecs-express (v1.x).
# ============================================================

module "vpc" {
  source               = "../../modules/vpc"
  project              = var.project
  environment          = var.environment
  azs                  = var.azs
  public_subnet_cidrs  = ["10.0.0.0/24", "10.0.1.0/24"]
  private_subnet_cidrs = ["10.0.10.0/24", "10.0.11.0/24"]
}

module "security_groups" {
  source      = "../../modules/security-groups"
  project     = var.project
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "secrets" {
  source       = "../../modules/secrets-manager"
  project      = var.project
  environment  = var.environment
  secret_names = ["DB_PASSWORD", "JWT_SECRET"]

  secret_values = {
    DB_PASSWORD = var.db_password
    JWT_SECRET  = var.jwt_secret
  }
}

module "iam" {
  source      = "../../modules/iam"
  project     = var.project
  environment = var.environment
  secret_arns = values(module.secrets.secret_arns)
}

module "rds" {
  source                 = "../../modules/rds-postgresql"
  project                = var.project
  environment            = var.environment
  private_subnet_ids     = module.vpc.private_subnet_ids
  vpc_security_group_ids = [module.security_groups.rds_sg_id]
  password               = var.db_password
  multi_az               = false

  backup_retention_period    = 1
  auto_minor_version_upgrade = true
  max_allocated_storage      = 50
}

# VPC Connector para o App Runner alcançar o RDS privado.
resource "aws_apprunner_vpc_connector" "this" {
  vpc_connector_name = "${var.project}-${var.environment}-connector"
  subnets            = module.vpc.private_subnet_ids
  security_groups    = [module.security_groups.apprunner_connector_sg_id]
}

module "ecr" {
  source      = "../../modules/ecr"
  project     = var.project
  environment = var.environment

  repositories = {
    backend = {
      name             = "bookloop-api"
      scan_on_push     = true
      keep_last_images = 10
    }

    frontend = {
      name             = "bookloop-web"
      scan_on_push     = true
      keep_last_images = 10
    }
  }
}

module "backend" {
  source            = "../../modules/app-runner"
  project           = var.project
  environment       = var.environment
  service_name      = "backend"
  image_identifier  = var.backend_image != "" ? var.backend_image : "${module.ecr.repository_urls["backend"]}:latest"
  access_role_arn   = module.iam.apprunner_ecr_access_role_arn
  instance_role_arn = module.iam.apprunner_instance_role_arn
  port              = 8080
  health_check_path = "/actuator/health"
  vpc_connector_arn = aws_apprunner_vpc_connector.this.arn
  runtime_env = {
    DB_URL                   = "jdbc:postgresql://${module.rds.address}:5432/${module.rds.db_name}"
    DB_USER                  = "bookloop"
    APP_CORS_ALLOWED_ORIGINS = var.app_cors_allowed_origins
  }
  runtime_secrets = {
    DB_PASSWORD = module.secrets.secret_arns["DB_PASSWORD"]
    JWT_SECRET  = module.secrets.secret_arns["JWT_SECRET"]
  }
}

module "frontend" {
  source            = "../../modules/app-runner"
  project           = var.project
  environment       = var.environment
  service_name      = "frontend"
  image_identifier  = var.frontend_image != "" ? var.frontend_image : "${module.ecr.repository_urls["frontend"]}:latest"
  access_role_arn   = module.iam.apprunner_ecr_access_role_arn
  instance_role_arn = module.iam.apprunner_instance_role_arn
  port              = 80
  health_check_path = "/"
}

module "observability_backend" {
  source       = "../../modules/cloudwatch"
  project      = var.project
  environment  = var.environment
  service_name = "backend"
}
