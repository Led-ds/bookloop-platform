# ADR-0008 — Estratégia de runtime: App Runner → ECS Express Mode

- **Status:** Aceito (estratégia; sem migração nesta versão) · **Data:** 2026-07 · **Contexto:** v1.1

## Contexto

O Go Live v1.0 usou **AWS App Runner** por simplicidade (sem cluster para operar, HTTPS gerenciado,
scale-to/from baixo). A AWS comunicou que o **App Runner não aceita novos clientes desde 30/04/2026**
e recomenda o **Amazon ECS Express Mode**. Contas que já usam o serviço **continuam funcionando**,
mas não haverá novos recursos relevantes. Ver ADR-0007.

## Decisão

1. **Nesta versão (v1.1) NÃO migrar.** O ecossistema já é cliente do App Runner; os serviços dev
   continuam estáveis.
2. Manter o Terraform **modular**: o ambiente compõe um módulo de runtime (`app-runner`) atrás de
   uma interface estável (imagem, env, secrets, health check, VPC connector). Trocar o runtime é
   trocar o módulo, sem tocar em RDS, VPC, IAM, ECR ou Secrets.
3. Planejar a migração para **ECS Express Mode** como item de **v1.2**, quando houver necessidade
   (novo ambiente/conta, novos recursos, ou fim de suporte).

## Consequências

- (+) Estabilidade agora, sem retrabalho apressado.
- (+) A modularidade já existente reduz o custo da futura troca.
- (−) Débito técnico consciente: um runtime que não recebe novidades.

## Caminho de migração (esboço para v1.2)

1. Criar `terraform/modules/ecs-express` com a **mesma interface** do módulo `app-runner`
   (image_identifier, runtime_env, runtime_secrets, health_check_path, vpc_connector/subnets, roles).
2. Em um ambiente novo (ou `homolog`), trocar `module "backend"`/`"frontend"` de `app-runner` para
   `ecs-express` e validar health check `/actuator/health`, CORS e conectividade com o RDS.
3. Cutover por DNS/URL; manter o App Runner até a validação. Rollback = reverter o módulo.
4. RDS, VPC, SGs, IAM, ECR e Secrets **permanecem** — só o runtime muda.
