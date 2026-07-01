# Padrões — Logging e Observabilidade

- **Logs estruturados** (chave=valor), em `stdout` (Twelve-Factor); coletados pelo CloudWatch.
- Sem PII/segredos em log. Erros com contexto suficiente para diagnóstico.
- Correlação por request id quando aplicável.
- Métricas essenciais: latência, taxa de erro, saturação (CPU/mem do App Runner), conexões do RDS.
- **Alarmes** no CloudWatch para: erros 5xx acima do limiar, CPU/mem alta, falha de health check.
- Runbooks (`docs/runbooks`) devem referenciar os alarmes correspondentes.
