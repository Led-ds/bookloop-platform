variable "project" {
  type        = string
  description = "Prefixo de nomeação."
}

variable "environment" {
  type        = string
  description = "dev | homolog | prod."
}

variable "vpc_id" {
  type        = string
  description = "ID da VPC."
}

variable "db_port" {
  type        = number
  description = "Porta do banco."
  default     = 5432
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
