# Runbook — Backend não conecta no RDS

## Sintomas
- Erros de conexão/timeout nos logs do backend; health check falhando.

## Diagnóstico
1. RDS está `available`? (console/CloudWatch)
2. O **VPC Connector** do App Runner está ativo e nas subnets privadas corretas?
3. O `sg-rds` permite ingress `5432` a partir do `sg-apprunner-connector`?
4. As credenciais no **Secrets Manager** estão corretas e sendo injetadas?
5. `DB_URL` aponta para o endpoint certo do RDS?

## Correção
- Ajuste o SG/VPC Connector via Terraform (PR).
- Corrija/rotacione o segredo no Secrets Manager.
- Reimplante o serviço.

## Prevenção
- Alarme de conexões do RDS e de falha de health check.
