# bootstrap — backend de state (S3 + DynamoDB)

**Finalidade:** criar, **uma única vez por conta**, o bucket S3 (state versionado e
criptografado) e a tabela DynamoDB (lock). Ver ADR-0003.

**Quando usar:** antes de qualquer `environments/*`.

**Como usar:**
```bash
cd terraform/bootstrap
terraform init         # state LOCAL apenas aqui (resolve o "ovo e galinha")
terraform apply
# anote os outputs: bucket e tabela -> use em environments/*/backend.tf
```

**Como evoluir:** habilitar replicação/òbject lock se exigido por compliance.
