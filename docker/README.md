# docker — Ativos Docker compartilhados

**Finalidade:** convenções e ativos comuns de container reutilizados pelos serviços. Os
Dockerfiles-modelo por stack ficam em [`templates/docker`](../templates/docker); aqui ficam as
convenções gerais e um `.dockerignore` base.

**Quando usar:** ao padronizar imagens entre serviços.

**Como evoluir:** se adotarmos uma base image própria (hardening), ela é versionada e
documentada aqui.

## Convenções (resumo — ver `docs/standards/docker.md`)
- Multistage; imagem final mínima; usuário não-root.
- Backend: `eclipse-temurin:21-jre-jammy` no runtime.
- Frontend: `nginx:1.27-alpine` servindo o build com fallback SPA.
- Tag = `sha` do commit + `latest` no branch principal.
- Sem segredos em build args/env.
