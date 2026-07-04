# State remoto do Terraform

## Estado atual

Backend S3 (em `terraform/environments/dev/backend.tf`):

```hcl
terraform {
  backend "s3" {
    bucket         = "bookloop-tfstate-ledds-us-east-1"
    key            = "environments/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "bookloop-tf-lock"
    encrypt        = true
  }
}
```

- **State** versionado no bucket S3 (criptografado).
- **Lock** via tabela DynamoDB `bookloop-tf-lock` (evita apply concorrente).
- Recursos do state provisionados pelo `terraform/bootstrap`.

## Risco / aviso

A partir do **Terraform 1.11+**, o argumento `dynamodb_table` no backend S3 está **depreciado**.
O mecanismo recomendado passou a ser o **lock nativo do S3** via `use_lockfile = true` (S3 conditional
writes), dispensando o DynamoDB. Hoje aparece apenas como **warning** — o lock continua funcionando.

**Não alteramos o backend nesta versão.** Trocar o mecanismo de lock exige `terraform init -reconfigure`
e coordenação (ninguém aplicando durante a transição), sob risco de dois locks divergentes.

## Estratégia de migração (v1.2, planejada)

1. Anunciar janela sem `apply` concorrente.
2. Adicionar `use_lockfile = true` **mantendo** `dynamodb_table` temporariamente:
   ```hcl
   backend "s3" {
     bucket       = "bookloop-tfstate-ledds-us-east-1"
     key          = "environments/dev/terraform.tfstate"
     region       = "us-east-1"
     encrypt      = true
     use_lockfile = true
     # dynamodb_table = "bookloop-tf-lock"  # remover após validar o lock nativo
   }
   ```
3. `terraform init -reconfigure`; validar `plan` (lock nativo funcionando).
4. Remover `dynamodb_table` e, depois, a tabela DynamoDB no `bootstrap` (opcional, economia).
5. O **state em si não muda** — só o mecanismo de lock. Sem impacto em recursos provisionados.
