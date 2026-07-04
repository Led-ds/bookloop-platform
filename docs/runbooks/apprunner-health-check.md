# Runbook — App Runner: health check falhando

**Sintoma:** serviço em `CREATE_FAILED`/`OPERATION_IN_PROGRESS` prolongado, ou health check vermelho.

**Backend** deve usar **`/actuator/health`** (público, 200). Nunca usar endpoint de negócio.
Configurado em `terraform/environments/dev/main.tf` (`module "backend".health_check_path`).

**Checklist:**

1. O container sobe? Ver logs `.../application` (CloudWatch) — erro de boot (DB, secret ausente) faz
   o health check falhar mesmo com path correto.
2. O path responde 200? `/actuator/health` exige o `spring-boot-starter-actuator` (presente na v1.1)
   e liberação no SecurityConfig (já feito).
3. Porta correta? Backend `8080`, frontend `80` (ver `port` no módulo).
4. RDS acessível? O backend precisa do **VPC connector** (`vpc_connector_arn`) para o RDS privado —
   sem ele, o boot trava na conexão e o health check nunca passa. Ver `runbooks/incident-db-connection.md`.
5. Após corrigir, um novo deploy recria o health check. Mudança só de `health_check_path` é **in-place**.
