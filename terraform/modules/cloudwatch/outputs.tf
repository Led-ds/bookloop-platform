output "log_group_name" {
  description = "Nome do log group da aplicação."
  value       = aws_cloudwatch_log_group.app.name
}
