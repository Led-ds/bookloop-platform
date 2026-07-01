variable "project" {
  type        = string
  description = "Prefixo de nomeação."
  default     = "bookloop"
}

variable "region" {
  type        = string
  description = "Região AWS."
  default     = "us-east-1"
}

variable "state_bucket_name" {
  type        = string
  description = "Nome global único do bucket de state."
}
