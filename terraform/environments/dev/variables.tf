variable "project" {
  type    = string
  default = "bookloop"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "azs" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b"]
}

variable "db_password" {
  type        = string
  description = "Senha do RDS (injete via TF_VAR_db_password, NÃO versione)."
  sensitive   = true
}

variable "jwt_secret" {
  type        = string
  description = "Segredo JWT (>= 32 bytes)."
  sensitive   = true
}

variable "backend_image" {
  type        = string
  description = "URI da imagem do backend no ECR (ver ADR-0002/0007)."
}

variable "frontend_image" {
  type        = string
  description = "URI da imagem do frontend no ECR."
}

variable "apprunner_access_role_arn" {
  type        = string
  description = "Access role para ECR privado (vazio se ECR Public)."
  default     = ""
}
