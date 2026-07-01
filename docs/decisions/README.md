# Decisões de Arquitetura (ADRs)

**Finalidade:** registrar decisões técnicas relevantes e seu contexto, para que o "porquê"
não se perca.

**Quando usar:** sempre que uma escolha tiver impacto arquitetural, de custo, de segurança
ou de processo, e não for trivialmente reversível.

**Como evoluir:** copie [`0000-template.md`](0000-template.md), incremente o número, abra PR.
ADRs são imutáveis após aceitos; para mudar uma decisão, crie uma nova ADR que _supersede_ a anterior.

Formato: MADR-lite (Contexto → Decisão → Consequências).

| # | Decisão | Status |
|---|---------|--------|
| 0001 | App Runner como runtime (sem Kubernetes) | Aceito ⚠️ ver ADR-0007 |
| 0002 | DockerHub como registry de imagens | Aceito ⚠️ App Runner/ECS exigem ECR |
| 0003 | Terraform com state remoto em S3 + DynamoDB | Aceito |
| 0004 | GitHub Actions com reusable workflows | Aceito |
| 0005 | Secrets Manager para configuração sensível | Aceito |
| 0006 | Sem Ansible e sem Kubernetes na v1 | Aceito |
| 0007 | App Runner fechado para novos clientes — contingência (ECS Express Mode) | Aceito |
