# Getting Started

## Pré-requisitos

- Git, Docker, Java 21 + Maven, Node 20+.
- Terraform ≥ 1.6, AWS CLI configurada (perfil com permissão adequada).
- Contas: GitHub (com acesso ao repo da plataforma) e DockerHub.

## Passos iniciais

1. Leia o [README principal](../../README.md) e a [visão de arquitetura](../architecture/overview.md).
2. Configure os secrets do CI (ver `github/workflows/README.md`): `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`.
3. Provisione o backend de state (uma vez por conta): `terraform/bootstrap`.
4. Para um novo serviço, siga [`new-service.md`](new-service.md).
