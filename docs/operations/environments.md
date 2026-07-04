# Ambientes: dev, homolog, prod

## Situação atual

Apenas **dev** existe (`terraform/environments/dev`). `homolog` e `prod` **não** são criados nesta
versão para não gerar custo (cada ambiente = RDS + App Runner + VPC dedicados).

## Estratégia (quando criar homolog/prod)

Cada ambiente é um diretório próprio compondo os **mesmos módulos**, com seu **state isolado**
(key distinta no S3) e seu `terraform.tfvars`:

```
terraform/environments/
  dev/       # existe
  homolog/   # futuro
  prod/      # futuro
```

Diferenças por ambiente (via variáveis, sem duplicar módulo):

| Aspecto | dev | homolog | prod |
|---------|-----|---------|------|
| `multi_az` (RDS) | false | false | **true** |
| `instance_class` | db.t4g.micro | db.t4g.micro | db.t4g.small+ |
| `deletion_protection` | false | false | **true** (já é `env=="prod"`) |
| `backup_retention_period` | 1 | 7 | 7–14 |
| `performance_insights` | off | off | on |
| `max_allocated_storage` | 50 | 100 | 100+ |
| `skip_final_snapshot` | true | true | **false** (já é `env!="prod"`) |

O módulo `rds-postgresql` já resolve `deletion_protection` e `skip_final_snapshot` por `environment`,
então prod nasce protegido por padrão.

## Passos para criar um ambiente novo (resumo)

1. Copiar `environments/dev` para `environments/homolog` (ou `prod`).
2. Ajustar `backend.tf` (nova `key` no S3), `variables.tf`/`tfvars` (CIDRs, classe, flags acima).
3. `terraform init` + `plan` revisado + `apply` (com autorização).
4. Publicar imagens no ECR e configurar `APP_CORS_ALLOWED_ORIGINS`/`VITE_API_URL` do ambiente.
