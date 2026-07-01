# Módulo: vpc

**Finalidade:** VPC com subnets públicas e privadas. O RDS e o VPC Connector do App Runner
ficam nas **privadas**.

**Quando usar:** base de rede de cada ambiente.

**Como evoluir:** adicionar NAT Gateway se recursos privados precisarem de egress à internet;
adicionar VPC endpoints (S3/Secrets Manager) para reduzir custo/exposição.

**Exemplo:** ver `environments/dev/main.tf`.
