# 💬 prompts — Biblioteca de prompts reutilizáveis

**Finalidade:** prompts parametrizáveis que produzem resultados dentro dos padrões da
plataforma, por área.

**Quando usar:** ao pedir a um assistente de IA para gerar código/infra/docs. Copie o prompt,
preencha os `<placeholders>` e forneça o contexto mínimo indicado pelo agente correspondente.

**Como evoluir:** mantenha prompts curtos, específicos e alinhados aos `docs/standards`.
Novos prompts entram por PR.

Convenções:
- `<placeholder>` = você substitui.
- Todo prompt assume: "siga `docs/standards`, mantenha KISS/YAGNI, explicite suposições".

| Área | Pasta |
|------|-------|
| Backend | [`backend/`](backend/) |
| Frontend | [`frontend/`](frontend/) |
| Terraform | [`terraform/`](terraform/) |
| AWS | [`aws/`](aws/) |
| GitHub | [`github/`](github/) |
| Docker | [`docker/`](docker/) |
| Arquitetura | [`architecture/`](architecture/) |
