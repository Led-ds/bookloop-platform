# Módulo: app-runner

> ⚠️ **Leia antes de usar (fatos verificados em 2026):**
> 1. **AWS App Runner deixou de aceitar novos clientes em 30/04/2026.** Contas que não se
>    inscreveram antes dessa data não conseguem criar serviços. Caminho recomendado pela AWS:
>    **Amazon ECS Express Mode**. Ver [ADR-0007](../../../docs/decisions/0007-app-runner-fechado-para-novos-clientes.md).
> 2. **App Runner só puxa imagem de ECR / ECR Public** — **não** do DockerHub. A imagem
>    publicada no DockerHub (nossa CI) precisa ser **espelhada para o ECR** antes do deploy,
>    ou adote o ECR como registry (ver ADR-0002).

**Finalidade:** provisionar um serviço App Runner (backend ou frontend) a partir de uma imagem
de container, com egress opcional para a VPC (acesso ao RDS) e segredos do Secrets Manager.

**Quando usar:** enquanto App Runner for viável para a conta (cliente existente). Para novas
contas, prefira o módulo equivalente de **ECS Express Mode** (evolução v1.x — ver roadmap).

**Como evoluir:** parametrizar autoscaling, min instances (prod), e criar o módulo
`ecs-express` como substituto direto.

**Exemplo:** ver `environments/dev/main.tf`.
