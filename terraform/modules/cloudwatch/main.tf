locals {
  name = "${var.project}-${var.environment}-${var.service_name}"
  tags = merge(var.tags, { Project = var.project, Env = var.environment, ManagedBy = "terraform" })
}

# Log group da aplicação (App Runner também cria grupos próprios; este serve para logs custom).
resource "aws_cloudwatch_log_group" "app" {
  name              = "/${var.project}/${var.environment}/${var.service_name}"
  retention_in_days = var.log_retention_days
  tags              = local.tags
}
