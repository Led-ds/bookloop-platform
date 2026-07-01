# Padrões — Git, Commits, PRs e Versionamento

- **Git Flow leve**: `main` (estável) + branches curtas `feat/`, `fix/`, `chore/`, `docs/`.
- **Conventional Commits**: `tipo(escopo): descrição` (ex.: `feat(rental): renovação com aprovação`).
- **Versionamento semântico** (SemVer) por tag: `MAJOR.MINOR.PATCH`. A plataforma é consumida por tag.
- **Pull Requests**: pequenos, com descrição de motivação e impacto; CI verde obrigatório;
  ao menos 1 revisão. Template em `/standards/pull_request_template.md`.
- CI roda em todo push/PR: build, testes, lint/format, build de imagem.
- Deploy é **GitOps**: promoção `dev → homolog → prod` via PR no Terraform.
