# Template mínimo — frontend

> Derivado de `boilerplate-front-nextjs` (FDD + `AGENTS.md`).  
> Produto novo: **clonar o boilerplate**; não recriar na mão.

## Quem cria

DEV, ao iniciar a peça `…-frontend`.

## Árvore mínima (mapa)

```text
.
├── AGENTS.md
├── package.json              # Next.js
├── tsconfig.json
├── next.config.ts
├── Dockerfile
├── .env.example
├── docs/
│   └── SPACE_DESIGN_SYSTEM.md   # se vier no boilerplate
├── app/                      # rotas / layouts (App Router)
│   ├── layout.tsx
│   ├── page.tsx
│   ├── (publics)/
│   └── (privates)/
├── features/                 # domínio (FDD)
│   └── {feature}/
│       ├── components/       # UI “burra”
│       ├── hooks/            # lógica + React Query
│       ├── service.ts        # HTTP tipado (só aqui)
│       ├── actions.ts
│       ├── schemas/
│       ├── types.ts
│       └── index.ts
├── shared/                   # reuso cross-feature
│   ├── components/
│   ├── hooks/
│   ├── lib/                  # api client, auth, utils
│   ├── providers/
│   ├── store/
│   └── types/
├── public/
└── tests/
```

## Leis FDD (resumo)

| Lei | Barra |
|-----|--------|
| Feature vs shared | Não misturar contextos de features |
| UI burra | Lógica em **hooks**, não na view |
| React Query | Só dentro de hooks — nunca na view |
| HTTP | Só em `service.ts` da feature — sem `fetch` solto |
| TypeScript | Sem `any` (exceto `catch`) |
