# Prompt — Workflow "caller" (GitHub Actions)

Contexto: siga `docs/standards/git-and-ci.md`. Os apps chamam reusable workflows da plataforma
via `uses: <org>/bookloop-platform/.github/workflows/<wf>.yml@<tag>`.

Tarefa:
> Gere o `.github/workflows/ci.yml` para um serviço `<backend|frontend>` chamado `<nome>`,
> que builda, testa e publica a imagem `<repo/imagem>` no DockerHub.
> Liste os secrets necessários e explique cada input passado ao reusable workflow.
