# 🤖 agents — Agentes de IA documentados

**Finalidade:** descrever agentes especializados que aceleram o trabalho na plataforma
mantendo consistência com os padrões. Aqui documentamos **papéis, contratos e limites** —
não implementações.

**Quando usar:** ao delegar uma tarefa a um assistente de IA, escolha o agente cujo escopo
corresponde e forneça o contexto mínimo indicado.

**Como evoluir:** cada agente tem um `AGENT.md`. Ajuste responsabilidades e prompts conforme
os padrões mudam. Prompts concretos reutilizáveis ficam em [`/prompts`](../prompts).

| Agente | Foco |
|--------|------|
| [architect-agent](architect-agent/AGENT.md) | Arquitetura, ADRs, trade-offs |
| [backend-agent](backend-agent/AGENT.md) | Spring Boot / Java |
| [frontend-agent](frontend-agent/AGENT.md) | React / TypeScript |
| [devops-agent](devops-agent/AGENT.md) | CI/CD, Docker, GitHub Actions |
| [cloud-agent](cloud-agent/AGENT.md) | Terraform / AWS |
| [security-agent](security-agent/AGENT.md) | DevSecOps |
| [qa-agent](qa-agent/AGENT.md) | Testes e qualidade |

Todos operam sob uma regra comum: **seguir os padrões em `docs/standards`, não introduzir
complexidade desnecessária e explicitar suposições.**
