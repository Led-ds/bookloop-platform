# Padrões — Segurança (DevSecOps)

- Segredos **fora do código**; Secrets Manager em runtime; `.env` só local e ignorado no Git.
- IAM de privilégio mínimo; SGs restritos; banco privado.
- Dependências: revisão e atualização; scan de vulnerabilidades no CI (evolução v1.x).
- Imagens: base oficial e enxuta; scan de imagem (evolução v1.x); rodar como não-root.
- HTTPS ponta a ponta (App Runner provê TLS gerenciado).
- Princípio do menor privilégio também para tokens de CI (secrets do GitHub com escopo mínimo).
- Autenticação/JWT: segredo forte (≥ 32 bytes), tokens de acesso curtos; refresh revogável (evolução).
