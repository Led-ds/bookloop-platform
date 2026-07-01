# Módulo: cloudwatch

**Finalidade:** observabilidade — log group da aplicação (base para alarmes).

**Quando usar:** em todo serviço, para logs custom e futuros alarmes.

**Como evoluir:** adicionar `aws_cloudwatch_metric_alarm` para 5xx, CPU/memória e falha de
health check (ver `docs/standards/observability.md`); integrar com notificação (SNS).
