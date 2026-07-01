variable "project" {
  type        = string
  description = "Prefixo de nomeação."
}

variable "environment" {
  type        = string
  description = "dev | homolog | prod."
}

variable "service_name" {
  type        = string
  description = "Nome lógico do serviço (ex.: backend, frontend)."
}

variable "image_identifier" {
  type        = string
  description = "URI da imagem no ECR (ex.: <acct>.dkr.ecr.<region>.amazonaws.com/app:tag) ou ECR Public."
}

variable "image_repository_type" {
  type        = string
  description = "ECR | ECR_PUBLIC. App Runner NAO suporta DockerHub diretamente."
  default     = "ECR"
}

variable "port" {
  type        = number
  description = "Porta que o container expõe."
  default     = 8080
}

variable "cpu" {
  type        = string
  description = "vCPU (ex.: 1024)."
  default     = "1024"
}

variable "memory" {
  type        = string
  description = "Memória em MB (ex.: 2048)."
  default     = "2048"
}

variable "runtime_env" {
  type        = map(string)
  description = "Variáveis de ambiente do runtime (não-sensíveis)."
  default     = {}
}

variable "runtime_secrets" {
  type        = map(string)
  description = "Mapa nome->ARN de segredos do Secrets Manager injetados como env."
  default     = {}
}

variable "instance_role_arn" {
  type        = string
  description = "Role de instância (permite ler segredos)."
}

variable "access_role_arn" {
  type        = string
  description = "Access role para pull de imagem em ECR privado. Vazio para ECR_PUBLIC."
  default     = ""
}

variable "health_check_path" {
  type        = string
  description = "Path do health check HTTP."
  default     = "/actuator/health"
}

variable "vpc_connector_arn" {
  type        = string
  description = "ARN do VPC Connector (para acessar o RDS privado). Vazio = sem egress na VPC."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
