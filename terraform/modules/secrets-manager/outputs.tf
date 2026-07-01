output "secret_arns" {
  description = "ARNs dos segredos criados (nome -> arn)."
  value       = { for k, s in aws_secretsmanager_secret.this : k => s.arn }
}
