output "repository_urls" {
  description = "URLs dos repositórios ECR."
  value = {
    for key, repo in aws_ecr_repository.this :
    key => repo.repository_url
  }
}

output "repository_arns" {
  description = "ARNs dos repositórios ECR."
  value = {
    for key, repo in aws_ecr_repository.this :
    key => repo.arn
  }
}

output "repository_names" {
  description = "Nomes dos repositórios ECR."
  value = {
    for key, repo in aws_ecr_repository.this :
    key => repo.name
  }
}

