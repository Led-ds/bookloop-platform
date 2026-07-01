# Ambientes

Cada ambiente **compõe** os módulos e mantém seu próprio `state` (key distinta no backend remoto).

- `dev/` — exemplo completo e comentado (referência para os demais).
- `homolog/` e `prod/` — espelham `dev` com dimensionamentos e proteções maiores.

Fluxo: alterar via PR → `terraform plan` no PR → `apply` após merge.
