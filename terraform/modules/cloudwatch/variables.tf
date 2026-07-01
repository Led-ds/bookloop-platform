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
  description = "Serviço monitorado (ex.: backend)."
}

variable "log_retention_days" {
  type        = number
  description = "Retenção dos logs."
  default     = 14
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
