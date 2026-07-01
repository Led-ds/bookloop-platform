variable "project" {
  type        = string
  description = "Prefixo de nomeação."
}

variable "environment" {
  type        = string
  description = "dev | homolog | prod."
}

variable "secrets" {
  type        = map(string)
  description = "Mapa nome->valor dos segredos (ex.: DB_PASSWORD, JWT_SECRET)."
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
