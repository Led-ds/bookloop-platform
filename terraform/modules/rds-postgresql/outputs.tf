output "endpoint" {
  description = "Endpoint do RDS (host:porta)."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Host do RDS."
  value       = aws_db_instance.this.address
}

output "db_name" {
  value = aws_db_instance.this.db_name
}
