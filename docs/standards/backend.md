# Padrões — Backend (Java / Spring Boot)

- **Java 21**, Spring Boot 3.x. Clean Architecture: domínio no centro, sem dependência de framework.
- Camadas por domínio: `domain` / `application` / `api` / `infrastructure` (ver BookLoop).
- **Rich Domain Model**: regras de negócio nas entidades; services orquestram.
- DTOs como `record`; mapeamento com MapStruct; boilerplate com Lombok.
- Validação com Jakarta Validation nas bordas (`@Valid` nos controllers).
- Erros centralizados em `@RestControllerAdvice`, resposta no envelope `ApiResponse<T>`.
- Persistência: JPA/Hibernate; **schema versionado por Flyway** (`ddl-auto=validate`).
- Config por ambiente (Twelve-Factor); segredos via env (Secrets Manager em prod).
- **Health check**: incluir `spring-boot-starter-actuator` e expor `/actuator/health` (usado pelo App Runner).
- Testes: JUnit 5; para integração, Testcontainers com PostgreSQL.
- Observabilidade: logs estruturados (ver `observability.md`).
