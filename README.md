# 🛠️ bookloop-platform

> Plataforma de Engenharia reutilizável para projetos **Java + React**, começando pelo ecossistema **BookLoop**.

Este repositório **não é uma aplicação**. É a fundação de _Platform Engineering_ que
os repositórios de aplicação consomem: módulos de infraestrutura (Terraform), pipelines
de CI/CD (GitHub Actions reutilizáveis), padrões de engenharia, templates de projeto e a
documentação dos agentes de IA e prompts reutilizáveis.

O objetivo é que criar um novo serviço Java+React seja uma questão de **reutilizar**, não
de reinventar: mesmos padrões, mesma esteira, mesma infra, com o mínimo de esforço e de
custo.

---

## 🎯 Objetivo

- Padronizar como serviços **Spring Boot** (Java 21) e **React 19 + TypeScript** são
  construídos, empacotados, testados, publicados e implantados.
- Prover **infraestrutura como código** reutilizável para AWS (App Runner + RDS PostgreSQL).
- Prover **CI/CD** reutilizável (GitHub Actions `workflow_call`) com publicação no DockerHub.
- Documentar **agentes de IA** especializados e uma **biblioteca de prompts** para acelerar
  o desenvolvimento sem perder consistência.
- Servir de fonte única de **padrões e decisões** (Documentation as Code + ADRs).

## 🧭 Visão geral

```
┌────────────────────────┐     consome (uses / module)      ┌──────────────────────────┐
│   repos de aplicação    │ ───────────────────────────────▶ │   bookloop-platform (este) │
│  (bookloop, futuros...) │                                   │  workflows • módulos TF    │
└───────────┬────────────┘                                   │  padrões • templates       │
            │ build & push (GitHub Actions)                  │  agentes • prompts • docs  │
            ▼                                                 └──────────────────────────┘
      ┌───────────┐   pull image    ┌─────────────────────────────────────────────┐
      │ DockerHub  │ ──────────────▶ │                    AWS                        │
      └───────────┘                 │  App Runner (backend) ── VPC Connector ──┐    │
                                     │  App Runner (frontend)                    ▼    │
                                     │  Secrets Manager   RDS PostgreSQL (subnets    │
                                     │  CloudWatch        privadas)                  │
                                     └─────────────────────────────────────────────┘
```

## 🏛️ Arquitetura proposta

- **Runtime:** AWS **App Runner** para backend e frontend — container runtime gerenciado,
  autoscaling, escala para baixo. Sem cluster para operar (sem Kubernetes nesta v1).
- **Banco:** AWS **RDS PostgreSQL** em subnets privadas. App Runner alcança o banco por um
  **VPC Connector**.
- **Registry:** **DockerHub** (imagens públicas ou privadas). A esteira builda e faz push;
  o App Runner puxa a imagem.
- **CI/CD:** **GitHub Actions** com _reusable workflows_ (`workflow_call`). Os apps chamam
  os pipelines com poucas linhas de YAML.
- **IaC:** **Terraform** com `modules/` (blocos reutilizáveis) compostos em
  `environments/{dev,homolog,prod}`. State remoto em **S3 + DynamoDB** (lock), provisionado
  pelo `bootstrap/`.
- **Config & Segredos:** **Secrets Manager** (credenciais do banco, JWT) injetados no App
  Runner via variáveis de ambiente — Twelve-Factor.
- **Observabilidade:** **CloudWatch** (logs nativos do App Runner + alarmes).
- **Segurança:** IAM de privilégio mínimo, Security Groups restritos, segredos fora do
  código, checagens no CI (DevSecOps).

Detalhes e diagramas: [`docs/architecture`](docs/architecture) · Decisões: [`docs/decisions`](docs/decisions).

## 📂 Organização dos diretórios

| Diretório | Finalidade |
|-----------|------------|
| `docs/` | Documentação como código: arquitetura, decisões (ADRs), diagramas, padrões, onboarding, runbooks. **Fonte canônica de prosa.** |
| `agents/` | Agentes de IA especializados (Architect, Backend, Frontend, DevOps, Cloud, Security, QA), cada um com objetivo, I/O, limitações e prompt de uso. |
| `prompts/` | Biblioteca de prompts reutilizáveis por área (backend, frontend, terraform, aws, github, docker, architecture). |
| `templates/` | Templates iniciais de projeto (Spring Boot, React, Docker, GitHub Actions, Terraform). |
| `terraform/` | IaC: `modules/`, `environments/`, `bootstrap/` (state remoto) e `shared/`. |
| `github/workflows/` | Definições dos _reusable workflows_ de CI/CD. |
| `docker/` | Ativos Docker compartilhados (base images, `.dockerignore`, convenções). |
| `scripts/` | Scripts utilitários (bootstrap de state, scaffolding de novo projeto). |
| `standards/` | Artefatos que **aplicam** os padrões (editorconfig, commitlint, checkstyle, eslint, PR template). |
| `architecture/` | Ponto de entrada de arquitetura + diagrama de referência (aponta para `docs/`). |
| `examples/` | Exemplo prático de um repo de app consumindo a plataforma. |

## 🧰 Ferramentas utilizadas

Terraform · AWS (App Runner, RDS, IAM, VPC, Security Groups, Secrets Manager, CloudWatch,
S3, DynamoDB) · GitHub Actions · Docker · DockerHub · Java 21 / Spring Boot · React 19 /
TypeScript · Markdown (Documentation as Code).

> **Fora do escopo da v1 (por decisão):** Ansible e Kubernetes. Ver
> [ADR-0006](docs/decisions/0006-sem-ansible-e-kubernetes-na-v1.md).

## 🔄 Fluxo de trabalho recomendado

1. **Padrão primeiro:** consulte `docs/standards/` e os artefatos em `standards/`.
2. **Novo serviço:** parta de `templates/springboot` ou `templates/react`.
3. **CI/CD:** adicione um workflow no app que **chama** o reusable workflow da plataforma.
4. **Infra:** instancie os módulos em `terraform/environments/<env>`; aplique via `dev` →
   `homolog` → `prod` (GitOps: mudança via PR).
5. **Decisões:** registre escolhas relevantes como ADR em `docs/decisions/`.
6. **Aceleração com IA:** use os `agents/` e `prompts/` para gerar código/infra dentro do padrão.

## 🚀 Como iniciar um novo projeto

Resumo (guia completo em [`docs/onboarding`](docs/onboarding)):

```bash
# 1. Scaffolding a partir de um template
./scripts/new-project.sh meu-servico springboot

# 2. Adicionar CI que chama o workflow reutilizável da plataforma
#    (ver templates/github-actions/)

# 3. Provisionar infra do ambiente dev
cd terraform/environments/dev
terraform init && terraform plan
```

## ♻️ Como reutilizar templates

- **App:** copie `templates/springboot` ou `templates/react` para o novo repo e ajuste nomes.
- **CI:** use `templates/github-actions/*-caller.yml` — poucas linhas apontando para
  `org/bookloop-platform/.github/workflows/*.yml@v1`.
- **Infra:** referencie os módulos: `source = "git::https://.../bookloop-platform.git//terraform/modules/app-runner?ref=v1"`.

## 📈 Como evoluir a infraestrutura

- Toda mudança de infra entra por **PR** (GitOps) e é aplicada `dev → homolog → prod`.
- Novos recursos viram **novos módulos** em `terraform/modules/` (um recurso coeso por módulo).
- Versione a plataforma por **tag semântica** (`v1.2.0`); apps fixam a versão que consomem.

## 🗺️ Roadmap

- **v1 (atual):** fundação — Terraform + App Runner + RDS + GitHub Actions + DockerHub +
  documentação + agentes + prompts.
- **v1.x:** módulos Terraform com resources completos e testados (`terraform validate`/`plan`
  em CI), workflow de deploy AWS acionando o App Runner, scan de imagem e de dependências.
- **v2 (se necessário):** alternativas de runtime (EC2 + Docker Compose + Nginx + Portainer)
  — aí sim **Ansible** entra em cena; possivelmente ECR no lugar do DockerHub.
- **Futuro:** observabilidade avançada (OpenTelemetry), múltiplas contas AWS, ambientes efêmeros por PR.

---

Mantido como **Documentation as Code**. Contribuições via PR seguindo os padrões em `standards/`.

---

## Infraestrutura AWS (v1.1)

Visão geral, operação e troubleshooting do provisionamento em `terraform/`. Detalhes por tema em
`docs/operations/` e procedimentos em `docs/runbooks/`.

### Visão geral

Região `us-east-1`. Terraform com **state remoto** (S3 `bookloop-tfstate-ledds-us-east-1`) e **lock**
(DynamoDB `bookloop-tf-lock`). Ambiente `dev` compõe os módulos: `vpc`, `security-groups`, `secrets-manager`,
`iam`, `rds-postgresql`, `ecr`, `app-runner` (backend + frontend) e `cloudwatch`. Backend e frontend rodam
em **App Runner** (imagens no **ECR**); backend alcança o **RDS** privado via **VPC connector**.

> App Runner está fechado para novos clientes desde 30/04/2026 (ADR-0007). Não migramos nesta versão;
> a estratégia para **ECS Express Mode** está no ADR-0008. O Terraform é modular para facilitar a troca.

### Pré-requisitos

- Terraform >= 1.9, AWS CLI v2, Docker.
- Credenciais AWS (preferir SSO/temporárias, não Access Key fixa).
- Bucket/tabela de state já provisionados pelo `terraform/bootstrap`.

### Bootstrap (uma vez por conta)

```bash
cd terraform/bootstrap
terraform init && terraform apply    # cria bucket S3 do state + tabela de lock
```

### Fluxo dev: init / validate / plan

```bash
scripts/terraform-validate-dev.sh                 # fmt -recursive + init -backend=false + validate
export TF_VAR_db_password='...' TF_VAR_jwt_secret='...(>=32 bytes)'
scripts/terraform-plan-dev.sh                     # init + plan -out=tfplan (revise!)
scripts/terraform-apply-dev.sh                    # aplica o tfplan revisado (confirmação explícita)
```

Nunca rode `terraform apply` sem revisar o `plan`. Se o plan indicar destruição do RDS ou recriação
de serviços, **pare** e investigue (ver runbooks).

### Variáveis (dev)

Copie e ajuste — segredos nunca versionados (estão no `.gitignore`):

```bash
cd terraform/environments/dev
cp terraform.tfvars.example terraform.tfvars
```

Principais: `app_cors_allowed_origins` (injetada no backend como `APP_CORS_ALLOWED_ORIGINS`),
`db_password`/`jwt_secret` (via `TF_VAR_*`), `backend_image`/`frontend_image` (override opcional;
por padrão usa o repositório ECR do ambiente `:latest`).

### Deploy (manual)

1. Build da imagem no repo de aplicação → `docker build` (frontend com `--build-arg VITE_API_URL=...`).
2. `scripts/ecr-login.sh` e `docker push` para o ECR.
3. `aws apprunner start-deployment --service-arn <arn>` (ou redeploy pelo console).

> **`VITE_API_URL` é variável de _build_ do frontend, não de runtime.** Ela é "assada" no bundle
> durante o `docker build` (por isso vai como `--build-arg`, já feito no workflow reutilizável
> `github/workflows/frontend-react.yml`). Trocar a URL da API exige **rebuild** da imagem do frontend —
> não adianta setar env no App Runner do frontend.

### ECR

Módulo `ecr`: `scan_on_push`, lifecycle (mantém as últimas N imagens), encryption AES256, tags e
outputs (`repository_urls`/`arns`/`names`). Repositórios: `bookloop-api`, `bookloop-web`.

### App Runner

Módulo `app-runner` parametrizável: `image_identifier`, `access_role_arn` (pull ECR privado),
`instance_role_arn`, `runtime_env`, `runtime_secrets`, `health_check_path` (**default `/actuator/health`**),
`vpc_connector_arn` (opcional), `auto_deployments_enabled` (default `false`). Backend porta 8080,
frontend porta 80.

### RDS PostgreSQL

Módulo `rds-postgresql`: `storage_encrypted = true`, `publicly_accessible = false`, `deletion_protection`
e `skip_final_snapshot` por ambiente. Ajustes operacionais **in-place** disponíveis (backup, autoscaling,
PI, logs exports) — ver `docs/runbooks/rds.md`. Em dev: `db.t4g.micro`, PI off, retenção curta.

### Secrets Manager

`DB_PASSWORD` e `JWT_SECRET` no Secrets Manager, injetados como **secrets** no App Runner. Os outputs
expõem apenas **ARNs**, nunca valores. Ver `docs/operations/iam-and-oidc.md`.

### CloudWatch

Log groups do App Runner (`.../service` e `.../application`) e como investigar CREATE_FAILED, health
check e CORS: `docs/operations/cloudwatch.md`.

Plano de **upload real** (avatar/capa/documentos via S3 + URLs assinadas), ainda não implementado:
`docs/operations/storage-uploads.md`.

### Troubleshooting (runbooks)

`deploy` · `rollback` · `incident-db-connection` · `ecr-token-expired` · `apprunner-health-check` ·
`cors` · `terraform-lock` · `rds` · `destroy-dev` — em `docs/runbooks/`.

### Segurança

`.gitignore` cobre `.terraform/`, `*.tfstate*`, `terraform.tfvars*`, `*.pem/*.key/.env*`, credenciais e
segredos. Nenhum segredo é versionado; senhas vêm de `TF_VAR_*`/Secrets Manager.

### Destruir ambiente DEV

Camada segura para destruir o **dev** com poucos comandos, sem rodar no ambiente errado e sem tocar
no bootstrap (state/lock). Runbook completo: `docs/runbooks/destroy-dev.md`.

**Quando usar:** encerrar o dev para economizar custo ou recriar do zero, sempre após revisar o preview.
**Quando NÃO usar:** em prod (os scripts recusam se `var.environment != dev`); se precisar dos dados
do RDS (dev usa `skip_final_snapshot = true`, sem snapshot final); para "limpar" o state (o bootstrap
não é tocado).

```bash
# 1) PREVIEW — não destrói nada, só lista o que seria removido
scripts/terraform-plan-destroy-dev.sh

# 2) DESTROY real — mostra avisos, valida o ambiente e exige a frase exata
scripts/terraform-destroy-dev.sh
#    confirmação exigida (digite exatamente):  destroy bookloop dev
```

**Proteções:** os scripts só rodam em `terraform/environments/dev`, recusam caminhos com `prod`,
resolvem `var.environment` via `terraform console` e abortam se não for `dev`; o destroy real ainda
exige a frase `destroy bookloop dev`. Nenhuma credencial é embutida.

**Riscos:** RDS dev é destruído **sem snapshot final** (perda de dados — tire snapshot manual antes se
precisar); Secrets somem com **janela de recuperação de 30 dias**; ECR só é removido se os repositórios
estiverem **vazios** (o destroy falha se houver imagens — esvazie antes; ver runbook).

**DEV × bootstrap:** destruir o dev remove os recursos de aplicação/rede do ambiente. O **bootstrap**
(bucket de state S3 + tabela de lock DynamoDB, em `terraform/bootstrap`) é um root **separado** e
**não** é destruído pelos scripts. Removê-lo apagaria o histórico de state — só ao descomissionar tudo.

_Evolução opcional (não aplicada):_ para o destroy do dev funcionar mesmo com imagens no ECR, dá para
habilitar `force_delete` **somente em dev** no módulo `ecr`. É uma mudança de `.tf` (in-place, requer
`apply` revisado) e está documentada como opção — não vem ligada por padrão, para manter o comportamento seguro.
