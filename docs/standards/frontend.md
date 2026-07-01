# Padrões — Frontend (React / TypeScript)

- **React 19 + TypeScript** (strict), build com Vite.
- Estado servidor com TanStack Query; estado global leve com Zustand.
- Estrutura por feature (`features/<dominio>`); componentes de UI reutilizáveis isolados.
- Tipos compartilhados espelham os contratos do backend (envelope `ApiResponse`, enums).
  **Enums devem bater exatamente com o backend** (ex.: `Genre`).
- `VITE_API_URL` como única fonte da base da API (Twelve-Factor).
- Sem `localStorage` para segredos; tokens tratados com cuidado.
- Lint/format via ESLint + Prettier (config em `/standards`).
- Build de produção servido por container Nginx com fallback SPA.
