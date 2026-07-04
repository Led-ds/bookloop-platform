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
  description = "Override da imagem do backend no ECR. Vazio = usa o repositório ECR do ambiente:latest."
  default     = ""
}

variable "frontend_image" {
  type        = string
  description = "Override da imagem do frontend no ECR. Vazio = usa o repositório ECR do ambiente:latest."
  default     = ""
}

variable "app_cors_allowed_origins" {
  type        = string
  description = "Origens CORS do backend (APP_CORS_ALLOWED_ORIGINS), separadas por vírgula."
  default     = "http://localhost:5173,https://kehmmmut47.us-east-1.awsapprunner.com"
}

variable "apprunner_access_role_arn" {
  type        = string
  description = "Access role para ECR privado (vazio se ECR Public)."
  default     = ""
}
