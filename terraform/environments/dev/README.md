# Ambiente: dev

Compõe os módulos da plataforma para o ambiente de desenvolvimento.

## Uso
```bash
# 1) segredos por variável de ambiente (não versione)
export TF_VAR_db_password="..." TF_VAR_jwt_secret="min-32-bytes..."

# 2) ajuste backend.tf com o bucket do bootstrap
terraform init
terraform plan
terraform apply   # via PR (GitOps)
```

## Observações
- **App Runner fechado para novos clientes (ADR-0007):** para contas novas, substitua os
  módulos `backend`/`frontend` pelo módulo `ecs-express` (v1.x).
- **Imagens no ECR (ADR-0002):** publique/espelhe a imagem no ECR; App Runner não puxa do DockerHub.
- `homolog` e `prod` espelham este ambiente com dimensionamento/proteções maiores.
