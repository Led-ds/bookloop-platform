# Topologia de implantação (AWS)

## Por que App Runner

- **Baixo custo/baixa operação:** sem cluster (EKS) nem control plane; escala automática e
  para baixo. Atende KISS e YAGNI (sem Kubernetes na v1 — ver ADR-0001 e ADR-0006).
- **Deploy por imagem:** integra direto com um registry de containers (DockerHub).

## Ambientes

`dev`, `homolog`, `prod` — mesma topologia, dimensionamentos diferentes:

| Recurso | dev | homolog | prod |
|---------|-----|---------|------|
| App Runner (CPU/mem) | mínimo | médio | dimensionado + min instances ≥ 1 |
| RDS | `db.t4g.micro`, single-AZ | `db.t4g.micro`, single-AZ | `db.t4g.small`+, Multi-AZ |
| Backups | curtos | médios | retenção estendida |

## Pipeline de promoção

```
commit → CI (build/test/push) → deploy dev → validação → PR promove homolog → PR promove prod
```

Promoção é sempre via PR no Terraform (GitOps). Nenhuma mudança manual no console.

## Health checks

App Runner monitora o serviço backend via HTTP em `/actuator/health` (requer
`spring-boot-starter-actuator` no serviço — ver padrões de backend). Frontend responde `/`.
