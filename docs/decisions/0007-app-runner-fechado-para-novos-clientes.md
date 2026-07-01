# ADR-0007: App Runner fechado para novos clientes — plano de contingência

- **Status:** Aceito
- **Data:** 2026-07-01
- **Decisores:** Arquitetura de Plataforma

## Contexto

A v1 escolheu App Runner como runtime (ADR-0001). Verificação em 2026 na documentação
oficial da AWS mostrou dois fatos que impactam essa base:

1. **A AWS deixou de aceitar novos clientes no App Runner a partir de 30/04/2026.** Serviços
   existentes continuam funcionando e podem criar novos recursos, mas **não há novas
   funcionalidades** e a AWS recomenda migração. Caminho recomendado: **Amazon ECS Express Mode**.
2. **App Runner só consome imagem de ECR / ECR Public**, não do DockerHub diretamente
   (ver ADR-0002).

## Decisão

- Manter os artefatos de App Runner na v1 **para contas que já são clientes** (grandfathered)
  e como referência de topologia.
- Tratar **Amazon ECS Express Mode** como o **alvo de runtime recomendado** para contas novas,
  a ser implementado como módulo `ecs-express` na v1.x. Ele oferece a mesma simplicidade
  (provisiona cluster, serviço, ALB, autoscaling e CloudWatch) exigindo imagem pré-construída.
- Manter a esteira de build/push inalterada; o ponto de deploy passa a apontar para ECS Express
  Mode quando o módulo estiver pronto.

## Alternativas consideradas

- **Insistir só em App Runner:** inviável para novas contas após 30/04/2026.
- **ECS/Fargate "clássico":** mais peças para montar; Express Mode é o meio-termo recomendado pela AWS.

## Consequências

- **Positivas:** decisão de runtime deixa de depender de um serviço em modo de manutenção.
- **Trade-offs:** ECS Express Mode exige imagem em ECR (reforça a decisão de espelhar/adotar ECR).
- **Ações:** criar módulo `terraform/modules/ecs-express`; atualizar `environments/*`; reavaliar
  ADR-0001 e ADR-0002; documentar migração no roadmap.
