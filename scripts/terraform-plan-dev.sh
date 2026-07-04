#!/usr/bin/env bash
# Gera o plano do ambiente dev. Requer credenciais AWS e backend S3 configurado.
# NÃO aplica nada. Salva o plano em tfplan para revisão.
set -euo pipefail
cd "$(dirname "$0")/../terraform/environments/dev"
: "${TF_VAR_db_password:?defina TF_VAR_db_password}"
: "${TF_VAR_jwt_secret:?defina TF_VAR_jwt_secret}"
terraform init -input=false
terraform plan -input=false -out=tfplan
echo
echo ">> Revise o plano acima. Para aplicar: scripts/terraform-apply-dev.sh"
