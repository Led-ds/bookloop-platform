# Runbook — Destruir o ambiente DEV com segurança

> **Destrutivo e irreversível.** Remove App Runner (backend/frontend), RDS (dev), VPC, Security
> Groups, VPC Connector, Secrets Manager, ECR (repos) e CloudWatch log groups do **dev**.
> **Não** afeta o state remoto (bucket S3 + tabela de lock do bootstrap) nem qualquer outro ambiente.

## Objetivo

Destruir o ambiente **dev** de forma controlada, com poucos comandos, sem executar no ambiente
errado e sem apagar o bootstrap (state/lock). Existem dois scripts:

- `scripts/terraform-plan-destroy-dev.sh` — **preview**: só mostra o que seria destruído. Não altera nada.
- `scripts/terraform-destroy-dev.sh` — **destroy real**: com avisos, checagem de ambiente e
  confirmação por frase exata.

## Quando usar

- Encerrar o dev para economizar custo, ou recriar o ambiente do zero.
- Sempre **depois** de revisar o preview e confirmar que ninguém depende do dev.

## Quando NÃO usar

- Em **prod** (os scripts recusam se `var.environment != dev`).
- Se você precisa dos dados do RDS (dev usa `skip_final_snapshot = true` → **sem snapshot final**).
- Para "limpar" o state: os scripts **não** tocam no bucket/lock do bootstrap.

## Pré-requisitos

- AWS CLI autenticado na conta correta (`aws sts get-caller-identity`).
- Terraform instalado; acesso ao backend S3/DynamoDB do dev.
- Ter rodado o **preview** e revisado a lista de remoção.

## Checklist ANTES do destroy

1. [ ] `aws sts get-caller-identity` → confirma a conta certa.
2. [ ] Confirmou que é **dev** e que ninguém depende dele.
3. [ ] **RDS:** se precisar dos dados, tire um snapshot manual antes:
   `aws rds create-db-snapshot --db-instance-identifier <id> --db-snapshot-identifier bookloop-dev-manual-$(date +%F)`.
4. [ ] **ECR:** os repositórios só são removidos **vazios**. O destroy **falha** se houver imagens
   (o módulo não usa `force_delete`). Esvazie antes, se for o caso (ver "ECR" abaixo).
5. [ ] Rodou o preview: `scripts/terraform-plan-destroy-dev.sh` e revisou.

## Comandos

```bash
# 1) PREVIEW — não destrói nada
scripts/terraform-plan-destroy-dev.sh

# 2) DESTROY real — pede a frase exata de confirmação
scripts/terraform-destroy-dev.sh
#    ... revise o plano exibido e digite exatamente:
#    destroy bookloop dev
```

As proteções dos scripts: (a) só rodam em `terraform/environments/dev`; (b) recusam se o caminho
contém `prod`; (c) resolvem `var.environment` via `terraform console` e abortam se não for `dev`;
(d) o destroy real exige a frase **`destroy bookloop dev`**.

## Checklist DEPOIS do destroy

1. [ ] App Runner: `aws apprunner list-services --region us-east-1` → não deve listar `bookloop-dev-*`.
2. [ ] RDS: `aws rds describe-db-instances --region us-east-1` → sem a instância do dev.
3. [ ] VPC/SG: `aws ec2 describe-vpcs` / `describe-security-groups` → sem os recursos do dev.
4. [ ] Secrets: `aws secretsmanager list-secrets` → `DB_PASSWORD`/`JWT_SECRET` marcados para
   deleção (ver "Secrets Manager").
5. [ ] ECR: `aws ecr describe-repositories` → `bookloop-api`/`bookloop-web` removidos (se estavam vazios).
6. [ ] `terraform plan` no dev → deve propor recriar tudo (prova de que o state está limpo).

## Comportamento por recurso

### RDS (decisão dev)
- `deletion_protection = var.environment == "prod"` → em **dev é `false`** (destroy permitido);
  em prod fica protegido.
- `skip_final_snapshot = var.environment != "prod"` → em **dev é `true`** → **não há snapshot final**;
  os backups automáticos somem com a instância. **Risco de perda de dados** — tire snapshot manual antes se precisar.

### ECR
- O módulo **não** define `force_delete` (default `false`): repositórios com imagens **não** são
  destruídos e o `terraform destroy` **falha** ali. Opções:
  - **Esvaziar antes** (recomendado para manter o padrão seguro):
    ```bash
    for R in bookloop-api bookloop-web; do
      IDS=$(aws ecr list-images --repository-name "$R" --region us-east-1 \
            --query 'imageIds[*]' --output json)
      [ "$IDS" != "[]" ] && aws ecr batch-delete-image --repository-name "$R" \
            --region us-east-1 --image-ids "$IDS"
    done
    ```
  - **Ou** habilitar `force_delete` **somente em dev** (mudança de `.tf`, requer apply e revisão de
    plano) — ver "Evolução opcional" no README. Não está habilitado por padrão de propósito.

### App Runner
- O destroy remove `bookloop-dev-backend` e `bookloop-dev-frontend` e o VPC Connector. A remoção
  leva alguns minutos; confirme no checklist pós-destroy.

### Secrets Manager
- Os secrets (`DB_PASSWORD`, `JWT_SECRET`) são deletados com **janela de recuperação padrão de 30 dias**
  (não são apagados na hora). Consequência: se você **recriar o dev antes de 30 dias**, pode haver
  conflito de "secret agendado para deleção". Para recriar imediatamente, force a deleção:
  `aws secretsmanager delete-secret --secret-id <nome> --force-delete-without-recovery --region us-east-1`
  (ou restaure: `restore-secret`).

## O que NÃO é destruído (bootstrap é separado)

O **bucket de state S3** (`bookloop-tfstate-ledds-us-east-1`) e a **tabela de lock DynamoDB**
(`bookloop-tf-lock`) vivem no root `terraform/bootstrap`, em state próprio. **Nenhum** dos scripts
os remove. Apagá-los destruiria o histórico de state de todos os ambientes — só faça isso ao
descomissionar a plataforma inteira, manualmente e com backup.

## Como recriar o ambiente depois

```bash
# (bootstrap já existe; não precisa recriar)
scripts/terraform-plan-dev.sh     # gera e revisa o plano de criação
scripts/terraform-apply-dev.sh    # aplica o plano revisado
# Depois, publique as imagens no ECR e rode o deploy (ver docs/runbooks/deploy.md).
```

Se os secrets ainda estiverem na janela de recuperação, restaure-os ou recrie com `force-delete`
antes (ver "Secrets Manager").
