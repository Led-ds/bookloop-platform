# Runbook — Destruir o ambiente dev com segurança

> **Destrutivo.** Remove App Runner, RDS (dev), VPC, SGs, ECR (repos vazios) e o VPC connector do dev.
> **Não** afeta o state remoto (bucket/lock do bootstrap) nem outros ambientes.

**Pré-checagem:**

1. Confirme que é o **dev** (`terraform/environments/dev`) e que ninguém depende dele.
2. Imagens no ECR: `keep_last_images` mantém histórico; repositório só é removido se vazio (o Terraform
   pode falhar se houver imagens — remova-as antes se quiser destruir os repos).
3. RDS dev tem `skip_final_snapshot = true` → **não** haverá snapshot final. Se precisar dos dados,
   tire um snapshot manual antes.

**Execução (com confirmação):**

```bash
cd terraform/environments/dev
terraform plan -destroy -out=tfdestroy      # REVISE a lista de destruição
terraform apply tfdestroy                    # aplica o destroy revisado
```

**Não** existe script de destroy automático — é intencional. O `scripts/terraform-apply-dev.sh` só
aplica planos de criação/alteração revisados, nunca destroy silencioso.

**Bootstrap (state):** o bucket S3 e a tabela de lock ficam no `terraform/bootstrap` e **não** são
destruídos aqui. Removê-los apagaria o histórico de state — faça apenas se for descomissionar tudo.
