# Template — Spring Boot (Java 21)

Ponto de partida para um backend seguindo `docs/standards/backend.md`.

## Estrutura recomendada (por domínio)
```
src/main/java/<pkg>/
  shared/{domain,application,exception,config}
  security/
  <dominio>/{domain,application,api,infrastructure}
src/main/resources/
  application.yml
  db/migration/   # Flyway: V1__init.sql, ...
```

## Checklist do novo serviço
- [ ] Java 21 + Spring Boot 3.x, empacotado com o `Dockerfile` (ver `../docker`).
- [ ] `spring-boot-starter-actuator` e `/actuator/health` expostos (health check do App Runner).
- [ ] Flyway com `ddl-auto=validate`.
- [ ] Config por ambiente; segredos por variável (Secrets Manager em prod).
- [ ] CI a partir de `../github-actions/backend-caller.yml`.

> A referência viva de convenções é o repositório **BookLoop**.
