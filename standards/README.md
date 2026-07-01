# standards — Artefatos de enforcement

**Finalidade:** arquivos que **aplicam** os padrões automaticamente (lint, format, commits, PRs).
A *prosa* dos padrões vive em [`docs/standards`](../docs/standards); aqui ficam os configs.

**Quando usar:** copie os relevantes para o repositório de cada serviço (ou referencie).

**Como evoluir:** mudança de regra entra por PR e, se relevante, vira ADR. Mantenha alinhado
à prosa em `docs/standards`.

| Arquivo | Aplica |
|---------|--------|
| `.editorconfig` | Estilo base (indentação, EOL) para qualquer editor |
| `commitlint.config.js` | Conventional Commits |
| `.eslintrc.base.json` | Lint TypeScript/React |
| `.prettierrc.json` | Formatação frontend |
| `checkstyle.xml` | Convenções Java (placeholder enxuto) |
| `pull_request_template.md` | Template de PR |
