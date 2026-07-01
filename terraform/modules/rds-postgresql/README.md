# Módulo: rds-postgresql

**Finalidade:** RDS PostgreSQL **privado** (nunca público), criptografado, em subnets privadas.

**Quando usar:** persistência relacional de um ambiente.

**Como evoluir:** `multi_az = true` e `deletion_protection = true` em prod; senha vinda do
`secrets-manager` (não em `.tfvars`); ajustar backups/retention por ambiente.

**Segurança:** `publicly_accessible = false`, acesso só via `sg-rds`.
