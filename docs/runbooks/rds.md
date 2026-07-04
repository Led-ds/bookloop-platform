# Runbook — RDS PostgreSQL

**Conexão:** o RDS é **privado** (`publicly_accessible = false`). Acesso só de dentro da VPC
(App Runner via VPC connector) ou por bastion/port-forward. Ver `runbooks/incident-db-connection.md`.

**Credenciais:** senha master vem do **Secrets Manager** (`DB_PASSWORD`), injetada como secret no
App Runner. Nunca em texto no Terraform/logs.

**Mudanças seguras (in-place, não recriam a instância):** `backup_retention_period`, `backup_window`,
`auto_minor_version_upgrade`, `max_allocated_storage` (autoscaling), `performance_insights_enabled`,
`enabled_cloudwatch_logs_exports`, `deletion_protection`, `multi_az`.

**Mudanças que RECRIAM (parar e planejar):** `storage_encrypted` (já é `true` — não desabilitar),
mudança de `engine`/major version sem estratégia, renomear `identifier`, trocar `db_subnet_group`
para AZs incompatíveis. Se o `plan` mostrar `-/+ destroy and then create` no `aws_db_instance`, **pare**.

**Backups/restore:** com retenção habilitada, use snapshots automáticos (point-in-time). Em prod,
`skip_final_snapshot = false` garante snapshot final na destruição.

**Custo em dev:** `db.t4g.micro`, PI desligado, logs exports vazios, retenção curta (1 dia).
