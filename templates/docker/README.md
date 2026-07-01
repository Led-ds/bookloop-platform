# Template — Docker

Dockerfiles multistage padrão (`docs/standards/docker.md`): imagem final mínima, não-root, `.dockerignore`.

- `Dockerfile.backend` — Spring Boot.
- `Dockerfile.frontend` — React/Vite servido por Nginx.
- `nginx.conf` — fallback SPA.
- `.dockerignore` — evita enviar lixo ao contexto de build.
