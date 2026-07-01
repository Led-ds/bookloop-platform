# ADR-0002: DockerHub como registry de imagens

- **Status:** Aceito
- **Data:** 2026-01-01
- **Decisores:** Arquitetura de Plataforma

> ⚠️ **Atualização (2026-07-01):** App Runner e ECS Express Mode consomem imagem de **ECR /
> ECR Public**, não do DockerHub diretamente. A imagem publicada no DockerHub deve ser
> **espelhada para o ECR** antes do deploy, ou adote o ECR como registry primário.

## Contexto

As imagens de container precisam ser publicadas e consumidas pelo App Runner. Opções: DockerHub ou Amazon ECR.

## Decisão

Usar **DockerHub** na v1, com login por _secrets_ no GitHub Actions e push automatizado.

## Alternativas consideradas

- **Amazon ECR:** integração nativa com IAM/App Runner, porém adiciona setup e acoplamento
  à AWS já na fundação. Reservado para a v1.x/v2.

## Consequências

- **Positivas:** simples, portável, independente de conta AWS para publicar.
- **Trade-offs:** para imagens privadas, o App Runner precisa de credenciais de pull; atenção
  a limites de rate do DockerHub.
- **Ações:** documentar migração para ECR como evolução (ADR futura).
