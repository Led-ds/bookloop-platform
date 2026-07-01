# Visão geral de arquitetura

## Princípios

- **Clean Architecture / SOLID** nos serviços (domínio no centro, infra nas bordas).
- **Twelve-Factor App**: config por ambiente, sem estado local, logs como stream.
- **DRY/KISS/YAGNI**: reutilização via módulos e workflows; sem complexidade prematura.
- **GitOps + IaC**: toda mudança de ambiente/infra por PR e Terraform.
- **DevSecOps**: segurança como parte da esteira, não etapa final.
- **Platform Engineering**: a plataforma reduz carga cognitiva dos times de produto.

## Componentes

| Componente | Papel | Tecnologia |
|------------|-------|------------|
| Serviço backend | API REST do produto | Spring Boot 3 / Java 21, empacotado em container |
| Serviço frontend | SPA servida por container | React 19 + TS (build estático via Nginx) |
| Registry | Distribuição de imagens | DockerHub |
| Runtime | Execução dos containers | AWS App Runner (backend + frontend) |
| Banco | Persistência relacional | AWS RDS PostgreSQL |
| Segredos | Credenciais e chaves | AWS Secrets Manager |
| Observabilidade | Logs, métricas, alarmes | AWS CloudWatch |
| CI/CD | Build, teste, publish, deploy | GitHub Actions (reusable workflows) |
| IaC | Provisionamento | Terraform (modules + environments) |

## Fluxo ponta a ponta

1. Push no repo de app → GitHub Actions builda, testa, gera imagem e faz push no DockerHub.
2. Terraform (via PR) provisiona/atualiza App Runner, RDS, rede, segredos e observabilidade.
3. App Runner puxa a imagem e sobe o serviço, lendo segredos do Secrets Manager.
4. Backend acessa o RDS pela rede privada via VPC Connector.
5. CloudWatch coleta logs/métricas; alarmes notificam anomalias.
