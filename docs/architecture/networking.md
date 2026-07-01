# Rede

## Objetivo

Manter o banco **inacessível pela internet** e permitir que o App Runner o alcance de forma
privada.

## Topologia

- **VPC** dedicada por ambiente (CIDR próprio).
- **Subnets públicas**: apenas para recursos que precisem de rota de saída (NAT), quando aplicável.
- **Subnets privadas**: RDS e o **VPC Connector** do App Runner.
- **VPC Connector (App Runner)**: dá ao serviço App Runner uma interface de rede nas subnets
  privadas, permitindo egress para o RDS.
- **Security Groups**:
  - `sg-apprunner-connector`: egress liberado.
  - `sg-rds`: ingress **somente** na porta `5432` a partir do `sg-apprunner-connector`.

```
App Runner (backend) ──▶ VPC Connector ──▶ [sg-apprunner-connector] ──▶ :5432 ──▶ [sg-rds] ──▶ RDS
```

## Regras

- RDS **nunca** com `publicly_accessible = true`.
- Sem `0.0.0.0/0` em ingress de banco.
- Egress do RDS restrito ao necessário.
