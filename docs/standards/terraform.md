# Padrões — Terraform

- Um **recurso coeso por módulo**; módulos sem `provider` hardcoded.
- Todo módulo com `main.tf`, `variables.tf`, `outputs.tf`, `README.md`, `versions.tf`.
- Ambientes em `environments/<env>` **compõem** módulos; nada de recurso solto no ambiente.
- **State remoto** (S3+DynamoDB); uma `key` por ambiente.
- Nomeação: `${project}-${env}-${recurso}`. Tags padrão em todo recurso (`Project`, `Env`, `ManagedBy=terraform`).
- Variáveis tipadas e com descrição; sem valores sensíveis em `.tfvars` versionado.
- `terraform fmt` + `terraform validate` no CI. Mudanças por **PR** (GitOps); nunca no console.
