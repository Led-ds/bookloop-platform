# ADR-0001: App Runner como runtime (sem Kubernetes)

- **Status:** Aceito
- **Data:** 2026-01-01
- **Decisores:** Arquitetura de Plataforma

> ⚠️ **Atualização (2026-07-01):** a AWS fechou o App Runner para novos clientes em
> 30/04/2026. Esta decisão permanece válida para clientes existentes; para novas contas, ver
> [ADR-0007](0007-app-runner-fechado-para-novos-clientes.md) (ECS Express Mode).

## Contexto

Precisamos executar containers de backend e frontend na AWS com baixo custo, pouca operação
e escala automática. As opções principais são EKS (Kubernetes), ECS/Fargate e App Runner.

## Decisão

Usar **AWS App Runner** como runtime na v1. Ele executa containers a partir de uma imagem,
faz autoscaling (inclusive escala para baixo) e não exige gestão de cluster.

## Alternativas consideradas

- **EKS (Kubernetes):** poderoso, mas caro e operacionalmente pesado — fere KISS/YAGNI para o estágio atual.
- **ECS/Fargate:** bom meio-termo, porém exige mais peças (task defs, ALB, service discovery) do que App Runner.

## Consequências

- **Positivas:** menor custo e carga operacional; deploy simples por imagem.
- **Trade-offs:** menos controle fino de rede/scheduling; acesso a recursos privados (RDS)
  exige VPC Connector.
- **Ações:** módulo `app-runner` provê o serviço + VPC Connector; migração para ECS/EKS fica como opção futura.
