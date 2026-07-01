# Módulos Terraform

Um recurso coeso por módulo, sem `provider` hardcoded. Cada módulo tem
`main/variables/outputs/versions/README`.

| Módulo | Provisiona |
|--------|-----------|
| `vpc` | VPC, subnets públicas/privadas, IGW, rotas |
| `security-groups` | SGs do App Runner connector e do RDS |
| `rds-postgresql` | Instância RDS PostgreSQL em subnets privadas |
| `secrets-manager` | Segredos (DB, JWT) |
| `iam` | Roles de acesso/instância do App Runner (privilégio mínimo) |
| `app-runner` | Serviços App Runner (backend/frontend) + VPC Connector |
| `cloudwatch` | Log group e alarmes |
