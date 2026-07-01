# ADR-0004: GitHub Actions com reusable workflows

- **Status:** Aceito
- **Data:** 2026-01-01
- **Decisores:** Arquitetura de Plataforma

## Contexto

Vários repositórios de app repetirão os mesmos passos de CI/CD. Duplicar YAML fere DRY.

## Decisão

Centralizar os pipelines como **reusable workflows** (`on: workflow_call`) neste repositório.
Os apps chamam com `uses: org/bookloop-platform/.github/workflows/<wf>.yml@v1`.

## Consequências

- **Positivas:** um lugar para evoluir a esteira; apps ficam com YAML mínimo.
- **Trace-offs:** mudanças na plataforma afetam consumidores — mitigado por versionamento por tag.
- **Ações:** manter `github/workflows/` versionado; apps fixam `@vX`.

> Nota: em um repositório GitHub real, os reusable workflows devem residir em
> `.github/workflows/`. Neste scaffold usamos `github/workflows/` conforme a estrutura pedida;
> ao publicar, renomeie para `.github/workflows/`.
