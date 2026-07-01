# Criar um novo serviço

1. **Scaffolding**
   ```bash
   ./scripts/new-project.sh pagamentos springboot
   # ou: react
   ```
2. **Padrões**: confira `docs/standards` e os configs em `/standards`.
3. **CI**: copie `templates/github-actions/backend-caller.yml` (ou `frontend-caller.yml`) para
   `.github/workflows/ci.yml` do novo repo e ajuste os inputs.
4. **Imagem**: garanta o `Dockerfile` (base em `templates/docker`).
5. **Infra**: em `terraform/environments/dev`, adicione a instância dos módulos para o serviço;
   `terraform init && terraform plan`.
6. **Deploy**: promova `dev → homolog → prod` por PR.
7. **Observabilidade**: valide logs no CloudWatch e crie alarmes mínimos.
8. **Decisões**: registre escolhas relevantes como ADR.
