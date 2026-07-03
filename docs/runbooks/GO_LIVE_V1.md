# BookLoop — Go Live v1.0.0

Data: 03/07/2026  
Versão: v1.0.0  
Ambiente: dev  
Região AWS: us-east-1

## Repositórios

- bookloop-api
- bookloop-web
- bookloop-platform

## Infraestrutura

- AWS App Runner — Backend
- AWS App Runner — Frontend
- Amazon RDS PostgreSQL
- Amazon ECR
- AWS Secrets Manager
- AWS CloudWatch
- VPC e Security Groups
- Terraform com state remoto em S3 e lock via DynamoDB

## URLs

Frontend:
https://kehmmmut47.us-east-1.awsapprunner.com

Backend:
https://vpcu66nnmz.us-east-1.awsapprunner.com

Swagger:
https://vpcu66nnmz.us-east-1.awsapprunner.com/swagger-ui.html

## Validações realizadas

- Login
- Cadastro de usuário
- Listagem do acervo
- Meus aluguéis
- Empréstimos
- Cadastro de livro
- Integração frontend/backend
- Conexão com RDS
- Deploy via imagens ECR
- Provisionamento via Terraform

## Observações

O deploy v1.0.0 foi realizado com infraestrutura provisionada por Terraform e aplicações publicadas via AWS App Runner.

## Próximos pontos

- Logo logo 