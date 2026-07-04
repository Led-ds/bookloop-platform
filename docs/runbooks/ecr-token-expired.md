# Runbook — ECR: token de login expirado

**Sintoma:** `docker push` falha com `denied: Your authorization token has expired` ou
`no basic auth credentials`.

**Causa:** o token do `docker login` no ECR dura ~12h.

**Correção:**

```bash
scripts/ecr-login.sh          # refaz o login (usa AWS_REGION, default us-east-1)
# ou, manualmente:
aws ecr get-login-password --region us-east-1 \
  | docker login --username AWS --password-stdin <acct>.dkr.ecr.us-east-1.amazonaws.com
```

Depois, repita o `docker push`. Se persistir: confirme `aws sts get-caller-identity` (credenciais
válidas) e se o repositório existe (`aws ecr describe-repositories --region us-east-1`).
