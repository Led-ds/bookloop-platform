variable "project" {
  type        = string
  description = "Nome do projeto (prefixo de nomeação)."
}

variable "environment" {
  type        = string
  description = "Ambiente: dev | homolog | prod."
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
