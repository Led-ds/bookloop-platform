# Template — React 19 + TypeScript

Ponto de partida para um frontend seguindo `docs/standards/frontend.md`.

## Checklist
- [ ] React 19 + TS strict, Vite.
- [ ] `VITE_API_URL` como base única da API.
- [ ] TanStack Query para dados; Zustand se precisar de estado global.
- [ ] Tipos espelham o backend (enums idênticos).
- [ ] Build servido por Nginx com fallback SPA (ver `../docker`).
- [ ] CI a partir de `../github-actions/frontend-caller.yml`.
