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
