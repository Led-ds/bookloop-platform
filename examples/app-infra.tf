# Exemplo: como um app referencia os módulos da plataforma por tag versionada.
# (No app real, isto viveria em infra/ do próprio repositório.)

module "rds" {
  source = "git::https://github.com/bookloop-org/bookloop-platform.git//terraform/modules/rds-postgresql?ref=v1"

  project                = "bookloop"
  environment            = "dev"
  private_subnet_ids     = var.private_subnet_ids
  vpc_security_group_ids = [var.rds_sg_id]
  password               = var.db_password
}

# Ver terraform/environments/dev para a composição completa (VPC, SG, IAM, secrets,
# app-runner/ecs-express, cloudwatch).
