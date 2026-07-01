# ================================================================
# ATENÇÃO (fato verificado em 2026):
#  - AWS App Runner deixou de aceitar NOVOS clientes em 30/04/2026.
#    Recomendação oficial: Amazon ECS Express Mode. Ver ADR-0007.
#  - App Runner só aceita imagem de ECR / ECR Public (NÃO DockerHub).
#    A imagem publicada no DockerHub deve ser espelhada para o ECR.
# ================================================================

locals {
  name = "${var.project}-${var.environment}-${var.service_name}"
  tags = merge(var.tags, { Project = var.project, Env = var.environment, ManagedBy = "terraform" })
}

resource "aws_apprunner_service" "this" {
  service_name = local.name

  source_configuration {
    image_repository {
      image_identifier      = var.image_identifier
      image_repository_type = var.image_repository_type

      image_configuration {
        port                          = tostring(var.port)
        runtime_environment_variables = var.runtime_env
        runtime_environment_secrets   = var.runtime_secrets
      }
    }

    # Access role só é necessária para ECR privado.
    dynamic "authentication_configuration" {
      for_each = var.access_role_arn != "" ? [1] : []
      content {
        access_role_arn = var.access_role_arn
      }
    }

    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu               = var.cpu
    memory            = var.memory
    instance_role_arn = var.instance_role_arn
  }

  health_check_configuration {
    protocol = "HTTP"
    path     = var.health_check_path
  }

  # Egress na VPC para alcançar o RDS privado (quando informado).
  dynamic "network_configuration" {
    for_each = var.vpc_connector_arn != "" ? [1] : []
    content {
      egress_configuration {
        egress_type       = "VPC"
        vpc_connector_arn = var.vpc_connector_arn
      }
    }
  }

  tags = local.tags
}
