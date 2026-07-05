#!/usr/bin/env bash
# Destroy SEGURO do ambiente DEV do BookLoop.
# Proteções: só roda em environments/dev, só se var.environment=='dev', e exige
# a confirmação exata "destroy bookloop dev". NUNCA roda em prod.
# NÃO remove o bootstrap (bucket de state S3 nem tabela de lock DynamoDB).
set -euo pipefail

cd "$(dirname "$0")/../terraform/environments/dev"

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
# -lock=false: leitura, não trava o state. O grep isola o token puro (ex.: 'dev'),
# descartando mensagens de lock ("Acquiring state lock...") que o console possa imprimir.
ENV="$(printf 'var.environment\n' | terraform console -lock=false 2>/dev/null \
       | tr -d '"' | grep -E '^[a-z0-9_-]+$' | tail -n1 || true)"
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
