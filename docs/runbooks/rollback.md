# Runbook — Rollback

## Quando
- Erros 5xx acima do normal, falha de health check, regressão funcional grave.

## Passos
1. Identifique a última imagem estável (tag/sha anterior).
2. Abra PR no `terraform/environments/<env>` apontando para a tag estável.
3. Aplique; o App Runner reimplanta a versão anterior.
4. Valide health e métricas.
5. Registre o ocorrido e atualize o runbook/ADR se necessário.

> Observação: mudanças de schema (Flyway) podem exigir migração compatível com rollback.
> Prefira migrações aditivas.
