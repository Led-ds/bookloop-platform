variable "project" {
  type        = string
  description = "Nome do projeto."
}

variable "environment" {
  type        = string
  description = "Ambiente."
}

variable "tags" {
  type        = map(string)
  description = "Tags adicionais."
  default     = {}
}

variable "repositories" {
  description = "Repositórios ECR que serão criados."
  type = map(object({
    name                 = string
    image_tag_mutability = optional(string, "MUTABLE")
    scan_on_push         = optional(bool, true)
    keep_last_images     = optional(number, 10)
  }))
}
