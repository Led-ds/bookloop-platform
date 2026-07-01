# ADR-0006: Sem Ansible e sem Kubernetes na v1

- **Status:** Aceito
- **Data:** 2026-01-01
- **Decisores:** Arquitetura de Plataforma

## Contexto

Há tentação de já incluir Ansible (config de máquinas) e Kubernetes (orquestração). Ambos
adicionam complexidade que o estágio atual não exige.

## Decisão

**Não** usar Ansible nem Kubernetes na v1. O runtime é App Runner (gerenciado) e não há
máquinas Linux para configurar.

## Consequências

- **Positivas:** fundação simples, barata e enxuta (KISS/YAGNI).
- **Trade-offs:** cenários de VM/Compose/Nginx não são cobertos agora.
- **Ações:** reavaliar em v2 caso o projeto evolua para EC2 + Docker Compose + Nginx +
  Portainer — aí Ansible passa a fazer sentido.
