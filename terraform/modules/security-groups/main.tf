locals {
  name = "${var.project}-${var.environment}"
  tags = merge(var.tags, { Project = var.project, Env = var.environment, ManagedBy = "terraform" })
}

# SG associado ao VPC Connector do App Runner (egress liberado).
resource "aws_security_group" "apprunner_connector" {
  name        = "${local.name}-apprunner-connector"
  description = "App Runner VPC connector egress"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.tags, { Name = "${local.name}-apprunner-connector" })
}

# SG do RDS: ingress SOMENTE do SG do connector, na porta do banco.
resource "aws_security_group" "rds" {
  name        = "${local.name}-rds"
  description = "RDS ingress from App Runner connector only"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = [aws_security_group.apprunner_connector.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.tags, { Name = "${local.name}-rds" })
}
