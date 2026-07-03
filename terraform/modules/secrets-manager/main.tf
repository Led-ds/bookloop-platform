locals {
  name = "${var.project}-${var.environment}"
  tags = merge(var.tags, {
    Project   = var.project
    Env       = var.environment
    ManagedBy = "terraform"
  })
}

resource "aws_secretsmanager_secret" "this" {
  for_each = var.secret_names

  name = "${local.name}/${each.key}"
  tags = local.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  for_each = var.secret_names

  secret_id     = aws_secretsmanager_secret.this[each.key].id
  secret_string = var.secret_values[each.key]
}


