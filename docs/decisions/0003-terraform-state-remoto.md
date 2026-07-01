# ADR-0003: Terraform com state remoto em S3 + DynamoDB

- **Status:** Aceito
- **Data:** 2026-01-01
- **Decisores:** Arquitetura de Plataforma

## Contexto

O state do Terraform precisa ser compartilhado, versionado e protegido contra escrita concorrente.

## Decisão

Armazenar o state em **S3** (versionado e criptografado) com **lock via DynamoDB**. O
`terraform/bootstrap/` provisiona esse backend uma única vez por conta.

## Consequências

- **Positivas:** colaboração segura, histórico, lock contra corrida.
- **Trade-offs:** dependência circular resolvida pelo bootstrap (local state apenas nele).
- **Ações:** cada `environments/<env>/backend.tf` referencia o bucket/tabela com chave própria.
