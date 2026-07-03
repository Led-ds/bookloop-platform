output "backend_url" {
  description = "URL do backend."
  value       = module.backend.service_url
}

output "frontend_url" {
  description = "URL do frontend."
  value       = module.frontend.service_url
}

output "rds_endpoint" {
  description = "Endpoint do RDS."
  value       = module.rds.endpoint
}

output "ecr_backend_url" {
  description = "URL do repositório ECR do backend."
  value       = module.ecr.repository_urls["backend"]
}

output "ecr_frontend_url" {
  description = "URL do repositório ECR do frontend."
  value       = module.ecr.repository_urls["frontend"]
}

