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

# --- Ajustes operacionais (todos aplicados IN-PLACE; nenhum recria a instância) ---
variable "backup_retention_period" {
  type        = number
  description = "Dias de retenção de backup automático (0 desativa)."
  default     = 7
}

variable "backup_window" {
  type        = string
  description = "Janela UTC de backup (hh:mm-hh:mm)."
  default     = "03:00-04:00"
}

variable "auto_minor_version_upgrade" {
  type        = bool
  description = "Aplicar upgrades menores automaticamente na janela de manutenção."
  default     = true
}

variable "max_allocated_storage" {
  type        = number
  description = "Teto do storage autoscaling em GB (0 desativa o autoscaling)."
  default     = 0
}

variable "performance_insights_enabled" {
  type        = bool
  description = "Habilita Performance Insights (custa em algumas classes; off em dev)."
  default     = false
}

variable "enabled_cloudwatch_logs_exports" {
  type        = list(string)
  description = "Logs exportados para o CloudWatch (ex.: [\"postgresql\"]). Vazio = nenhum."
  default     = []
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
