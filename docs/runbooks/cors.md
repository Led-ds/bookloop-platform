# Runbook — CORS bloqueando o frontend

**Sintoma:** no browser, `blocked by CORS policy: No 'Access-Control-Allow-Origin'` ou preflight
`OPTIONS` 403.

**Como funciona:** o backend lê **`APP_CORS_ALLOWED_ORIGINS`** (lista separada por vírgula) e libera
essas origens. Na infra, essa env é injetada em `module "backend".runtime_env` no ambiente dev.

**Correção:**

1. Confira o valor atual da env no serviço backend (App Runner → Configuration → Environment).
2. Garanta que a **origem exata do frontend** está na lista (esquema+host, sem barra final):
   `https://SEU-FRONT.awsapprunner.com`. Localhost de dev (`http://localhost:5173`) pode conviver.
3. Ajuste `app_cors_allowed_origins` no `terraform.tfvars` do dev e `plan`/`apply` (mudança in-place).
4. `OPTIONS` deve responder 200 — já habilitado no backend v1.1. Se falhar só o preflight, quase
   sempre é origem divergente (http vs https, porta, barra final).
