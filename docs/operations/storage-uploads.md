# Plano de storage para uploads (avatar, capa, documentos)

> **Status: PLANO — não implementado.** Nenhum recurso é criado nesta versão. Hoje `avatarUrl`
> e `coverUrl` são **URLs externas** informadas pelo usuário (sem upload). Este documento define
> como evoluir para upload real quando aprovado, de forma incremental e sem impacto no que existe.

## Motivação

O backend/frontend v1.2 já preveem imagens via URL (`avatarUrl`, `coverUrl`). O passo futuro é
permitir **upload real** de: avatar de usuário, capa de livro e, adiante, documentos digitais
(ex.: termo de responsabilidade assinado). Isso exige armazenamento de objetos — **Amazon S3**.

## Princípio: upload direto do browser via URL assinada

O container do App Runner **não** recebe/streama o arquivo. O fluxo recomendado:

1. Browser pede ao backend uma **URL pré-assinada** (`presigned PUT`) para uma key específica.
2. Backend valida (tipo, tamanho, dono) e responde com a URL assinada (expira em minutos).
3. Browser faz `PUT` do arquivo **direto no S3**.
4. Backend guarda apenas a **key/URL** no banco (ex.: `users.avatar_url`, `books.cover_url`).
5. Leitura: bucket **privado** + `presigned GET` (ou CloudFront com OAC, numa etapa posterior).

Vantagens: não passa bytes pelo App Runner (custo/CPU), permissão temporária e escopada, bucket
nunca público.

## Recursos a criar (quando aprovado)

### Bucket privado

- Um bucket por ambiente (ex.: `bookloop-dev-uploads-<sufixo>`), **Block Public Access = ON**.
- `versioning` habilitado; `server_side_encryption` AES256 (ou KMS se exigido).
- **CORS** no bucket liberando `PUT`/`GET` apenas para as origens do frontend
  (as mesmas de `APP_CORS_ALLOWED_ORIGINS`).
- `lifecycle`: expirar uploads incompletos (multipart) em 7 dias; opcional mover versões antigas
  para IA após 30 dias.
- Organização por prefixo: `avatars/<userId>/...`, `covers/<bookId>/...`, `documents/<rentalId>/...`.

### Política IAM mínima (na Instance Role do App Runner backend)

Escopada ao bucket e às ações necessárias — **sem** `s3:*`:

```hcl
# Sketch (NÃO aplicar sem aprovação). Anexar à apprunner_instance role existente.
data "aws_iam_policy_document" "uploads" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:DeleteObject"]
    resources = ["${aws_s3_bucket.uploads.arn}/*"]
  }
  statement {
    actions   = ["s3:ListBucket"]
    resources = [aws_s3_bucket.uploads.arn]
  }
}
```

A geração de presigned URL usa as credenciais da própria Instance Role — **nenhum novo secret**
(sem access key). Nada a acrescentar no Secrets Manager.

### Módulo Terraform sugerido

`terraform/modules/s3-uploads` com a **mesma disciplina** dos módulos atuais: `Block Public Access`,
encryption, CORS por variável (origens), outputs só de nome/ARN (nunca conteúdo). Composto no
`environments/dev` e injetado no backend como `runtime_env` (ex.: `UPLOADS_BUCKET=<nome>`).

## Integração no backend (resumo)

- Endpoints novos (ex.): `POST /api/v1/uploads/avatar-url`, `POST /api/v1/uploads/cover-url`
  → retornam `{ uploadUrl, publicKey }`.
- Validação: tipo MIME permitido (imagens), tamanho máximo, e **propriedade** (só o dono do
  recurso pede URL para aquela key).
- Persistir apenas a key/URL final; servir leitura via presigned GET.
- Documentos digitais (fase posterior): mesmo mecanismo, com retenção/lifecycle próprios e,
  se necessário, KMS + trilha de auditoria.

## CI/CD

Nenhum **secret** novo. Quando o bucket existir, o backend recebe o **nome do bucket** (não sensível)
como env via Terraform (`runtime_env`). O frontend não muda (upload é direto browser→S3 via URL
assinada; nada em build time). `VITE_API_URL` continua sendo a única variável de build do frontend.

## Riscos e cuidados

- **Bucket nunca público** — sempre Block Public Access + presigned. Um bucket público seria
  vazamento de dados.
- **CORS do bucket** deve casar com as origens reais do frontend, senão o `PUT` do browser falha.
- **Validação de tipo/tamanho** no backend antes de assinar, para evitar abuso.
- **Custo**: S3 é barato, mas versionamento + saída de dados têm custo; definir lifecycle.
- Introduzir S3 é **aditivo** (novos recursos) — não recria RDS/App Runner nem altera o state
  além de adicionar recursos. Ainda assim, aplicar via `plan` revisado (ver `README` / scripts).

## Próximo passo

Quando aprovado: criar o módulo `s3-uploads`, compor no `dev`, anexar a policy mínima à Instance
Role, e implementar os endpoints de presigned URL no backend — numa branch dedicada, com
`terraform plan` revisado antes do apply.
