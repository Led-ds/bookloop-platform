variable "project" {
  type = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "secret_names" {
  type        = set(string)
  description = "Nomes dos secrets que serão criados."
}

variable "secret_values" {
  type        = map(string)
  description = "Valores sensíveis dos secrets."
  sensitive   = true
}

