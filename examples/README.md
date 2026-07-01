# examples — Exemplo de consumo da plataforma

**Finalidade:** mostrar, de forma mínima e realista, como um repositório de aplicação **consome**
a plataforma (CI reutilizável + módulos Terraform). Não é um app completo — é o "contrato de uso".

**Quando usar:** como referência ao ligar um serviço novo à plataforma.

**Como evoluir:** manter enxuto; um exemplo por padrão de uso, sem duplicar os templates.

Conteúdo:
- `app-repo-ci.yml` — o `.github/workflows/ci.yml` que um app backend teria.
- `app-infra.tf` — como um app instancia os módulos de infra por referência versionada.
