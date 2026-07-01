# Prompt — Criar/evoluir módulo Terraform

Contexto: siga `docs/standards/terraform.md` e `aws.md`. Um recurso coeso por módulo, sem
provider hardcoded, com `main/variables/outputs/versions/README`. Tags padrão. Privilégio mínimo.

Tarefa:
> Módulo: `<nome>` para provisionar `<recurso AWS>`.
> Variáveis: `<lista>`. Outputs: `<lista>`. Restrições: `<custo/segurança/rede>`.
> Entregue o HCL dos arquivos, o README do módulo e um exemplo de uso em `environments/dev`.
> Mostre o `terraform plan` esperado (resumo).
