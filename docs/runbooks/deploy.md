# Runbook — Deploy / Promoção

## Pré-condições
- CI verde no commit-alvo; imagem publicada no DockerHub.

## Passos
1. Confirme a tag da imagem (sha do commit) no DockerHub.
2. Abra PR no `terraform/environments/<env>` atualizando a referência da imagem.
3. Revise o `terraform plan` no PR.
4. Merge → aplicação do Terraform → App Runner faz o deploy da nova imagem.
5. Valide `/actuator/health` (backend) e o carregamento do frontend.
6. Acompanhe métricas/erros no CloudWatch por alguns minutos.

## Se falhar
- Ver [`rollback.md`](rollback.md).
