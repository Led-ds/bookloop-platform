output "apprunner_instance_role_arn" {
  description = "ARN da role de instância do App Runner."
  value       = aws_iam_role.apprunner_instance.arn
}

output "apprunner_ecr_access_role_arn" {
  value = aws_iam_role.apprunner_ecr_access.arn
}
