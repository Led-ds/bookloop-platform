variable "project" {
  type        = string
  description = "Prefixo de nomeação."
}

variable "environment" {
  type        = string
  description = "dev | homolog | prod."
}

variable "cidr_block" {
  type        = string
  description = "CIDR da VPC."
  default     = "10.0.0.0/16"
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones."
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs das subnets públicas."
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDRs das subnets privadas."
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}
