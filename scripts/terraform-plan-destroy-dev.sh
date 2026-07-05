#!/usr/bin/env bash
# Preview do destroy do ambiente DEV. NÃO destrói nada — só mostra o plano de remoção.
# Use para revisar a lista de recursos antes de rodar o destroy real.
set -euo pipefail

cd "$(dirname "$0")/../terraform/environments/dev"

# Guard 1: precisa estar no diretório do dev.
case "$PWD" in
  */environments/dev) : ;;
  *) echo "ERRO: não estou em environments/dev (PWD=$PWD). Abortando." >&2; exit 1 ;;
esac

terraform init -reconfigure -input=false >/dev/null
terraform validate

# Guard 2: o environment resolvido precisa ser 'dev'.
# -lock=false: leitura, não trava o state. O grep isola o token puro (ex.: 'dev'),
# descartando mensagens de lock ("Acquiring state lock...") que o console possa imprimir.
ENV="$(printf 'var.environment\n' | terraform console -lock=false 2>/dev/null \
       | tr -d '"' | grep -E '^[a-z0-9_-]+$' | tail -n1 || true)"
if [ "$ENV" != "dev" ]; then
  echo "ERRO: var.environment='${ENV:-?}' (esperado 'dev'). Abortando por segurança." >&2
  exit 1
fi

echo ">>> PREVIEW de destroy do ambiente DEV (nenhum recurso será alterado):"
echo
terraform plan -destroy -input=false
echo
echo ">>> Fim do preview. Nada foi destruído. Para destruir de fato: scripts/terraform-destroy-dev.sh"
