#!/usr/bin/env bash
# Destroy SEGURO do ambiente DEV do BookLoop.
# Proteções: só roda em environments/dev, só se var.environment=='dev', e exige
# a confirmação exata "destroy bookloop dev". NUNCA roda em prod.
# NÃO remove o bootstrap (bucket de state S3 nem tabela de lock DynamoDB).
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

# Guard 2: nunca em prod (checagem defensiva pelo caminho).
case "$PWD" in
  *prod*) echo "ERRO: caminho contém 'prod'. Este script é EXCLUSIVO de dev. Abortando." >&2; exit 1 ;;
esac

terraform init -reconfigure -input=false >/dev/null
terraform validate

# Guard 3: o environment resolvido precisa ser 'dev' (falha fechado).
# Resolve o environment SEM state/lock/console (robusto entre versões do Terraform):
# 1) usa TF_VAR_environment, se exportado; 2) senão, lê o default de variables.tf.
ENV="${TF_VAR_environment:-}"
if [ -z "$ENV" ]; then
  ENV="$(grep -A3 'variable "environment"' variables.tf \
         | grep -E 'default[[:space:]]*=' | head -n1 \
         | sed -E 's/.*default[[:space:]]*=[[:space:]]*"?([a-z0-9_-]+)"?.*/\1/')"
fi
if [ "$ENV" != "dev" ]; then
  echo "ERRO: var.environment='${ENV:-?}' (esperado 'dev'). NUNCA rode este script fora de dev. Abortando." >&2
  exit 1
fi

cat <<'WARN'

############################################################
#  ATENCAO: DESTRUICAO DO AMBIENTE *DEV* DO BOOKLOOP       #
#                                                          #
#  Sera DESTRUIDO (irreversivel):                          #
#    - RDS PostgreSQL  -> SEM final snapshot (perda de     #
#      dados; tire um snapshot manual antes se precisar)   #
#    - App Runner Backend e Frontend                       #
#    - VPC, Security Groups e VPC Connector                #
#    - Secrets Manager (janela de recuperacao de 30 dias)  #
#    - ECR (repositorios; falha se houver imagens)         #
#    - CloudWatch log groups                               #
#                                                          #
#  NAO sera destruido: bucket de state (S3) e tabela de    #
#  lock (DynamoDB) do bootstrap — sao um root separado.    #
############################################################

WARN

echo ">>> Gerando o plano de destroy para revisao final:"
echo
terraform plan -destroy -input=false
echo

echo "Para confirmar a DESTRUICAO do ambiente DEV, digite exatamente:"
echo "    destroy bookloop dev"
read -r -p "> " CONFIRM
if [ "$CONFIRM" != "destroy bookloop dev" ]; then
  echo "Confirmacao incorreta. Cancelado. NADA foi destruido."
  exit 1
fi

terraform destroy -auto-approve -input=false
echo
echo ">>> Destroy do DEV concluido. Valide a remocao conforme docs/runbooks/destroy-dev.md."
echo ">>> Lembrete: o state remoto (bucket/lock do bootstrap) foi preservado."
