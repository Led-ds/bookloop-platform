locals {
  name = "${var.project}-${var.environment}"
  tags = merge(var.tags, { Project = var.project, Env = var.environment, ManagedBy = "terraform" })
}

resource "aws_db_subnet_group" "this" {
  name       = "${local.name}-db-subnets"
  subnet_ids = var.private_subnet_ids
  tags       = local.tags
}

resource "aws_db_instance" "this" {
  identifier             = "${local.name}-pg"
  engine                 = "postgres"
  engine_version         = "16"
  instance_class         = var.instance_class
  allocated_storage      = var.allocated_storage
  db_name                = var.db_name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.vpc_security_group_ids
  multi_az               = var.multi_az
  publicly_accessible    = false
  storage_encrypted      = true
  skip_final_snapshot    = var.environment != "prod"
  deletion_protection    = var.environment == "prod"

  backup_retention_period         = var.backup_retention_period
  backup_window                   = var.backup_window
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  max_allocated_storage           = var.max_allocated_storage > 0 ? var.max_allocated_storage : null
  performance_insights_enabled    = var.performance_insights_enabled
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  tags = merge(local.tags, { Name = "${local.name}-pg" })
}
