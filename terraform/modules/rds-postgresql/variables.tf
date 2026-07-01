variable "project" {
  type        = string
  description = "Prefixo de nomeação."
}

variable "environment" {
  type        = string
  description = "dev | homolog | prod."
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Subnets privadas para o subnet group."
}

variable "vpc_security_group_ids" {
  type        = list(string)
  description = "SGs de acesso (ex.: sg-rds)."
}

variable "db_name" {
  type        = string
  description = "Nome do database."
  default     = "bookloop"
}

variable "username" {
  type        = string
  description = "Usuário master."
  default     = "bookloop"
}

variable "password" {
  type        = string
  description = "Senha master (injete via Secrets Manager / variável sensível)."
  sensitive   = true
}

variable "instance_class" {
  type        = string
  description = "Classe da instância."
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  type        = number
  description = "Storage em GB."
  default     = 20
}

variable "multi_az" {
  type        = bool
  description = "Multi-AZ (true em prod)."
  default     = false
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
