variable "project" {
  type        = string
  description = "Prefixo de nomeação."
}

variable "environment" {
  type        = string
  description = "dev | homolog | prod."
}

variable "secret_arns" {
  type        = list(string)
  description = "ARNs de segredos que o serviço pode ler (privilégio mínimo)."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
