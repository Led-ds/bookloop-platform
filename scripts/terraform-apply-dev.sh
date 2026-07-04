#!/usr/bin/env bash
# Aplica o plano do ambiente dev — exige confirmação explícita.
# Só aplica o tfplan gerado por terraform-plan-dev.sh (revisado).
set -euo pipefail
cd "$(dirname "$0")/../terraform/environments/dev"
if [ ! -f tfplan ]; then
  echo "ERRO: tfplan não encontrado. Rode scripts/terraform-plan-dev.sh e revise antes." >&2
  exit 1
fi
read -r -p "Aplicar o plano REVISADO no ambiente DEV? Digite 'apply-dev' para confirmar: " ans
[ "$ans" = "apply-dev" ] || { echo "Cancelado."; exit 1; }
terraform apply -input=false tfplan
rm -f tfplan
