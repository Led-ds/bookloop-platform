# Módulo: security-groups

**Finalidade:** isolar o RDS. O `sg-rds` só aceita ingress na porta do banco a partir do
`sg-apprunner-connector`. Ver `docs/architecture/networking.md`.

**Quando usar:** sempre que houver App Runner acessando RDS privado.

**Como evoluir:** restringir egress; adicionar SGs para outros consumidores privados.
