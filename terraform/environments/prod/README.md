# Ambiente: prod

Espelha `dev` com proteções de produção. Ajuste ao copiar de `../dev`:
- `backend.tf` → `key = "environments/prod/terraform.tfstate"`;
- `environment = "prod"`; CIDRs próprios (ex.: `10.2.0.0/16`);
- RDS `multi_az = true`, `deletion_protection = true`, instância maior;
- App Runner com `min instances >= 1` (evolução) e alarmes CloudWatch ativos.

Promoção `homolog → prod` sempre via PR, com revisão obrigatória.
