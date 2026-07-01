# Módulo: secrets-manager

**Finalidade:** criar segredos (credenciais do banco, JWT) para injeção no App Runner.

**Quando usar:** toda configuração sensível de um ambiente. Ver ADR-0005.

**Como evoluir:** habilitar rotação automática; separar segredos por serviço; nunca versionar valores.

**Uso:** passe um mapa `{ DB_PASSWORD = "...", JWT_SECRET = "..." }` — de preferência vindo de
variáveis sensíveis do pipeline, não de `.tfvars` versionado.
