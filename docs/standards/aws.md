# Padrões — AWS

- **Privilégio mínimo** em IAM: roles específicas por função, sem `*` amplo.
- Recursos **privados por padrão**; exposição pública é exceção justificada.
- RDS nunca público; acesso só via VPC/SG.
- Segredos no **Secrets Manager**; nada de credencial em variável de código.
- Tags obrigatórias: `Project`, `Env`, `Owner`, `ManagedBy`.
- Custos: preferir tiers pequenos (`t4g.micro`), escala para baixo, e desligar o que não é usado em dev.
- Observabilidade via CloudWatch; alarmes para erros e saturação.
