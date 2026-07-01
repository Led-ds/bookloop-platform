output "service_arn" {
  description = "ARN do serviço App Runner."
  value       = aws_apprunner_service.this.arn
}

output "service_url" {
  description = "URL pública do serviço."
  value       = aws_apprunner_service.this.service_url
}
