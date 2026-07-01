# ADR-0005: Secrets Manager para configuração sensível

- **Status:** Aceito
- **Data:** 2026-01-01
- **Decisores:** Arquitetura de Plataforma / Segurança

## Contexto

Credenciais de banco e chaves (ex.: JWT) não podem estar em código nem em texto plano.

## Decisão

Usar **AWS Secrets Manager** como fonte de segredos, injetados no App Runner como variáveis
de ambiente em tempo de deploy (Twelve-Factor).

## Consequências

- **Positivas:** segredos centralizados, rotacionáveis, auditáveis; fora do repositório.
- **Trade-offs:** custo por segredo; IAM precisa permitir leitura pelo App Runner.
- **Ações:** módulo `secrets-manager` cria os segredos; módulo `iam` concede leitura mínima.
