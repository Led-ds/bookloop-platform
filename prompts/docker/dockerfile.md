# Prompt — Dockerfile multistage

Contexto: siga `docs/standards/docker.md`. Multistage, imagem final mínima, não-root, `.dockerignore`.

Tarefa:
> Gere o `Dockerfile` para um serviço `<backend Spring Boot | frontend React/Vite>`.
> Backend: build Maven+JDK21 → runtime JRE21. Frontend: build Node → runtime Nginx com fallback SPA.
> Inclua `.dockerignore`. Explique as escolhas de base image e as camadas de cache.
