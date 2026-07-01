# 🌍 terraform — Infraestrutura como Código

**Finalidade:** provisionar a infra AWS da plataforma de forma reutilizável e versionada.

**Quando usar:** para criar/evoluir ambientes (dev/homolog/prod) e recursos compartilhados.

**Como evoluir:** novos recursos viram **módulos** coesos; ambientes **compõem** módulos.
Mudanças por PR (GitOps). Ver `docs/standards/terraform.md`.

## Organização
```
terraform/
├── modules/        # blocos reutilizáveis (1 recurso coeso por módulo)
├── environments/   # dev | homolog | prod — compõem os módulos
├── bootstrap/      # cria o backend de state (S3 + DynamoDB) — roda 1x por conta
└── shared/         # versões/locais comuns
```

## Ordem de uso
1. `bootstrap/` (uma vez) → cria bucket S3 + tabela DynamoDB de lock.
2. `environments/dev` → `init` (usa o backend remoto) → `plan` → `apply` (via PR).
3. Promova para `homolog` e `prod` por PR.

> Os módulos desta v1 trazem uma base **realista** (variáveis, outputs, resources principais)
> pronta para evoluir. Revise dimensionamentos e políticas antes de `apply` em prod.
