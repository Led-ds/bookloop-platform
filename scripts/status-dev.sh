#!/usr/bin/env bash
# Resumo do estado do ambiente dev (App Runner, RDS) — somente leitura.
set -euo pipefail
REGION="${AWS_REGION:-us-east-1}"
echo "== App Runner services =="
aws apprunner list-services --region "$REGION" \
  --query "ServiceSummaryList[?starts_with(ServiceName, 'bookloop-dev')].{Name:ServiceName,Status:Status,URL:ServiceUrl}" \
  --output table 2>/dev/null || echo "(sem permissão ou nenhum serviço)"
echo
echo "== RDS instances =="
aws rds describe-db-instances --region "$REGION" \
  --query "DBInstances[?starts_with(DBInstanceIdentifier, 'bookloop-dev')].{Id:DBInstanceIdentifier,Status:DBInstanceStatus,AZ:AvailabilityZone,Encrypted:StorageEncrypted}" \
  --output table 2>/dev/null || echo "(sem permissão ou nenhuma instância)"
