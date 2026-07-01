#!/usr/bin/env bash
# Scaffolding simples de um novo serviço a partir dos templates da plataforma.
# Uso: ./scripts/new-project.sh <nome> <springboot|react> [destino]
set -euo pipefail

NAME="${1:-}"
KIND="${2:-}"
DEST="${3:-../$NAME}"

if [[ -z "$NAME" || -z "$KIND" ]]; then
  echo "Uso: $0 <nome> <springboot|react> [destino]" >&2
  exit 1
fi

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/templates/$KIND"

if [[ ! -d "$SRC" ]]; then
  echo "Template '$KIND' não encontrado em templates/." >&2
  exit 1
fi

mkdir -p "$DEST"
cp -r "$SRC/." "$DEST/"
# Dockerfile e configs comuns
cp "$ROOT/templates/docker/.dockerignore" "$DEST/.dockerignore" 2>/dev/null || true
cp "$ROOT/standards/.editorconfig" "$DEST/.editorconfig" 2>/dev/null || true

echo "Serviço '$NAME' ($KIND) criado em: $DEST"
echo "Próximos passos:"
echo "  1) Adicione o CI: copie templates/github-actions/${KIND/springboot/backend}-caller.yml para .github/workflows/ci.yml"
echo "  2) Ajuste nomes/imagens e configure os secrets do DockerHub."
echo "  3) Instancie a infra em terraform/environments/dev."
