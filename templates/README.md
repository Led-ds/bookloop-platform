# 🧩 templates — Pontos de partida

**Finalidade:** starters mínimos e limpos para novos serviços e artefatos, já dentro dos padrões.

**Quando usar:** ao iniciar um novo serviço ou adicionar CI/infra a um existente.

**Como evoluir:** manter templates enxutos (KISS). O que for específico de um serviço fica no
próprio serviço; o que for comum sobe para cá.

| Template | Uso |
|----------|-----|
| `springboot/` | Novo backend Java 21 / Spring Boot. |
| `react/` | Novo frontend React 19 + TS. |
| `docker/` | Dockerfiles multistage padrão. |
| `github-actions/` | Workflows "caller" que chamam os reusable da plataforma. |
| `terraform/` | Esqueleto de módulo Terraform. |
