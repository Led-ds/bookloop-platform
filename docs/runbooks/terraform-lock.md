# Runbook — Terraform: state travado (lock)

**Sintoma:** `Error acquiring the state lock` — outro processo/apply anterior não liberou o lock.

**Antes de forçar:** confirme que **ninguém** está aplicando (CI ou colega). Quebrar um lock ativo
corrompe o state.

**Correção:**

1. A mensagem traz o `ID` do lock. Se tiver certeza de que está órfão:
   ```bash
   cd terraform/environments/dev
   terraform force-unlock <LOCK_ID>
   ```
2. Se o lock é em **DynamoDB** (`bookloop-tf-lock`), o item também pode ser inspecionado no console
   DynamoDB (chave `LockID`). Não delete manualmente sem necessidade — prefira `force-unlock`.
3. Reduza recorrência: evite `Ctrl-C` durante `apply`; use os scripts (`terraform-plan-dev.sh`).

Ver também `docs/operations/terraform-state.md` (migração futura para lock nativo do S3).
