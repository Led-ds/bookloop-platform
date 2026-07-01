# Ambiente: homolog

Espelha `dev` com dimensionamento intermediário. Copie os arquivos de `../dev`, ajuste:
- `backend.tf` → `key = "environments/homolog/terraform.tfstate"`;
- `environment = "homolog"`;
- CIDRs próprios da VPC (ex.: `10.1.0.0/16`);
- RDS um pouco maior, se necessário.

Promoção `dev → homolog` sempre via PR (GitOps).
