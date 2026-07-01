# architecture — Ponto de entrada

**Finalidade:** porta de entrada para entender a arquitetura da plataforma. O conteúdo
canônico (aprofundado) vive em [`docs/architecture`](../docs/architecture) e os diagramas em
[`docs/diagrams`](../docs/diagrams). Aqui fica o mapa de referência.

**Quando usar:** primeira parada de quem quer a visão macro antes de mergulhar nos detalhes.

**Como evoluir:** manter só o essencial aqui (sem duplicar `docs/`); atualizar o diagrama de
referência quando a topologia mudar.

## Referência rápida

```mermaid
flowchart LR
    subgraph Plataforma[bookloop-platform]
      wf[Reusable Workflows]
      mod[Módulos Terraform]
      std[Padrões]
      tmpl[Templates]
      ai[Agentes + Prompts]
    end
    app[Repos de app] -->|uses/module/@v1| Plataforma
    app -->|build/push| dh[(DockerHub)]
    Plataforma -->|provisiona| aws[(AWS: App Runner*/RDS/VPC/Secrets/CloudWatch)]
    dh -.espelhar.-> ecr[(ECR)] --> aws
```

\* App Runner está fechado para novos clientes desde 30/04/2026 — para novas contas, o alvo é
**ECS Express Mode** (ver `docs/decisions/0007-app-runner-fechado-para-novos-clientes.md`).

Aprofunde em: [visão geral](../docs/architecture/overview.md) · [deploy](../docs/architecture/deployment.md) · [rede](../docs/architecture/networking.md) · [decisões](../docs/decisions).
