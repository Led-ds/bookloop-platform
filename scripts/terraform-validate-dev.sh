#!/usr/bin/env bash
# Formata e valida a configuração do ambiente dev. Não acessa a AWS além do init.
set -euo pipefail
cd "$(dirname "$0")/../terraform/environments/dev"
echo ">> terraform fmt -recursive (raiz)"
terraform -chdir=../../.. fmt -recursive
echo ">> terraform init -backend=false"
terraform init -backend=false -input=false >/dev/null
echo ">> terraform validate"
terraform validate
