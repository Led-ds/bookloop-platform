# Padrões — Docker

- **Multistage build**: estágio de build separado do runtime; imagem final mínima.
- Backend: `maven:3.9-eclipse-temurin-21` → `eclipse-temurin:21-jre-jammy`.
- Frontend: `node:20-alpine` (build) → `nginx:1.27-alpine` (runtime).
- Rodar como usuário **não-root**.
- `.dockerignore` sempre presente (evita enviar `node_modules`, `target`, `.git`).
- Tag de imagem = `sha` curto do commit **e** `latest` no branch principal.
- Sem segredos em `ARG`/`ENV` de build.
