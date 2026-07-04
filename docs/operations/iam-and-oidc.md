# IAM e GitHub Actions OIDC

## Papéis atuais (módulo `iam`)

| Papel | Função | Escopo |
|-------|--------|--------|
| **App Runner ECR Access Role** | Permite ao App Runner **puxar imagem** do ECR privado | `AWSAppRunnerServicePolicyForECRAccess` (leitura ECR) |
| **App Runner Instance Role** | Permissões do container em runtime | Leitura dos **segredos específicos** (ARNs de `DB_PASSWORD`, `JWT_SECRET`) via Secrets Manager |

A Instance Role recebe apenas os ARNs dos segredos do ambiente (`values(module.secrets.secret_arns)`),
não `secretsmanager:*` amplo — já é least-privilege para o runtime.

## Evolução para least privilege (recomendação)

Durante o Go Live, é comum ter usado uma identidade humana com permissões amplas (Administrator) para
`terraform apply`. Recomendações:

- Trocar chaves de longa duração por **credenciais temporárias** (SSO / `aws sso login`).
- Separar uma role de **execução do Terraform** com permissões restritas aos serviços usados
  (App Runner, RDS, ECR, IAM limitado, Secrets, VPC, CloudWatch, S3/DynamoDB do state).
- Não remover permissões existentes sem validar `plan` — fazer de forma incremental.

## GitHub Actions → AWS via OIDC (proposto para v1.2)

Objetivo: o CI assume uma role na AWS **sem Access Key fixa**, via OIDC federation.

Esboço de Terraform (novo módulo `iam-oidc`, aplicar em etapa dedicada):

```hcl
# Provider OIDC do GitHub (uma vez por conta)
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["<thumbprint atual do GitHub>"]
}

# Role assumida apenas pelos repos/branches autorizados
data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:Led-ds/bookloop-api:ref:refs/heads/main",
                  "repo:Led-ds/bookloop-web:ref:refs/heads/main"]
    }
  }
}
```

Permissões da role de CI (mínimas): `ecr:GetAuthorizationToken`, push no repositório ECR do serviço,
e `apprunner:StartDeployment` no serviço-alvo. **Não** conceder admin.

Fluxo alvo do pipeline: build+test → docker build (frontend com `--build-arg VITE_API_URL`) →
push ECR → `apprunner start-deployment`. Ver `examples/app-repo-ci.yml`.

Motivo de adiar: exige criar o provider OIDC na conta e validar as trust conditions — incremental,
mas melhor em uma etapa própria (v1.2) com `plan` revisado.
