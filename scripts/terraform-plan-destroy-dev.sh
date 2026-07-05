#!/usr/bin/env bash
# Preview do destroy do ambiente DEV. NÃO destrói nada — só mostra o plano de remoção.
# Use para revisar a lista de recursos antes de rodar o destroy real.
set -euo pipefail

cd "$(dirname "$0")/../terraform/environments/dev"

# Secrets obrigatórios (mesmo para planejar/destruir o Terraform avalia toda a config).
# Nunca versionados — venha de TF_VAR_* no seu ambiente, igual ao terraform-plan-dev.sh.
: "${TF_VAR_db_password:?defina TF_VAR_db_password (ex.: export TF_VAR_db_password=...)}"
: "${TF_VAR_jwt_secret:?defina TF_VAR_jwt_secret (min. 32 bytes)}"

# Guard 1: precisa estar no diretório do dev.
case "$PWD" in
  */environments/dev) : ;;
  *) echo "ERRO: não estou em environments/dev (PWD=$PWD). Abortando." >&2; exit 1 ;;
esac

terraform init -reconfigure -input=false >/dev/null
terraform validate

# Guard 2: o environment resolvido precisa ser 'dev'.
# Resolve o environment SEM state/lock/console (robusto entre versões do Terraform):
# 1) usa TF_VAR_environment, se exportado; 2) senão, lê o default de variables.tf.
ENV="${TF_VAR_environment:-}"
if [ -z "$ENV" ]; then
  ENV="$(grep -A3 'variable "environment"' variables.tf \
         | grep -E 'default[[:space:]]*=' | head -n1 \
         | sed -E 's/.*default[[:space:]]*=[[:space:]]*"?([a-z0-9_-]+)"?.*/\1/')"
fi
if [ "$ENV" != "dev" ]; then
  echo "ERRO: var.environment='${ENV:-?}' (esperado 'dev'). Abortando por segurança." >&2
  exit 1
fi

echo ">>> PREVIEW de destroy do ambiente DEV (nenhum recurso será alterado):"
echo
terraform plan -destroy -input=false
echo
echo ">>> Fim do preview. Nada foi destruído. Para destruir de fato: scripts/terraform-destroy-dev.sh"
