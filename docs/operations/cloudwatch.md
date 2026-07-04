# Observabilidade — CloudWatch

## Log groups do App Runner

Cada serviço App Runner gera dois grupos:

- `/aws/apprunner/<service>/<id>/service` — logs da **plataforma** (build/deploy, health check).
- `/aws/apprunner/<service>/<id>/application` — logs da **aplicação** (stdout/stderr do container).

Backend (`bookloop-dev-backend`): os logs estruturados do Spring (login, cadastro, aluguel, erros 500
com stack trace) saem no grupo `.../application`.

Frontend (`bookloop-dev-frontend`): logs do Nginx no grupo `.../application`.

## Como acessar

Console → CloudWatch → Log groups → filtre por `bookloop-dev`. Ou via CLI:

```bash
aws logs tail "/aws/apprunner/bookloop-dev-backend" --follow --region us-east-1
```

(O `list-log-groups`/`describe-log-groups` ajuda a achar o sufixo `<id>`.)

## Troubleshooting rápido

- **CREATE_FAILED no App Runner:** ver o grupo `.../service`. Causas comuns: imagem inexistente no
  ECR, access role sem permissão de pull, porta errada, health check falhando no start.
- **Health check falhando:** ver runbook `runbooks/apprunner-health-check.md`.
- **CORS:** ver runbook `runbooks/cors.md`.
- **Erro 500 no backend:** procure `ERROR` no grupo `.../application`; o handler global loga a causa.

## Dashboards e alarmes

O módulo `cloudwatch` cria o log group base. Alarmes (5xx, CPU, memória, health) e dashboards são
**opcionais** e têm custo — ficam propostos para v1.2, habilitáveis por variável, para não gerar
gasto sem aprovação.
