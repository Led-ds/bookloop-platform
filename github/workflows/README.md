# Reusable workflows

Chamados pelos apps via `uses: <org>/bookloop-platform/.github/workflows/<wf>.yml@<tag>`
(ver `templates/github-actions/`).

| Workflow | Para | Inputs principais | Secrets |
|----------|------|-------------------|---------|
| `backend-java.yml` | Serviços Spring Boot | `image_name`, `java_version` | `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` |
| `frontend-react.yml` | Serviços React/Vite | `image_name`, `node_version`, `vite_api_url` | `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN` |

Ambos: checkout → setup+cache → build → test → docker build → login+push DockerHub.
A etapa de **deploy AWS (App Runner)** está marcada como evolução (v1.x) e roda apenas no branch principal.
