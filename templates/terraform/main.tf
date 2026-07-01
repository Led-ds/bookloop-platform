# main.tf — defina aqui os resources coesos deste módulo.
# Sem provider hardcoded: o provider vem do ambiente que compõe o módulo.

locals {
  name = "${var.project}-${var.environment}-<recurso>"
  tags = merge(var.tags, {
    Project   = var.project
    Env       = var.environment
    ManagedBy = "terraform"
  })
}

# resource "aws_..." "this" {
#   tags = local.tags
# }
