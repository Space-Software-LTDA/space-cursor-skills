# Template mínimo — extension

> **Espelho** da disciplina do frontend (TypeScript, features/shared, sem lógica na UI).  
> Sem boilerplate Git público Space ainda — scaffold pelo DEV ao iniciar `…-extension`.  
> Build: **webpack**. Linguagem: **TypeScript**. **Proibido JavaScript puro.**

## Quem cria

DEV, ao iniciar a peça `…-extension`.

## Manifest

Preferir **Manifest V3** (Chrome atual).  
V2 = legado; só se o cliente pedir e o risco for explícito no setup/task.

## Árvore mínima (mapa)

```text
.
├── AGENTS.md                 # copiar leis: TS only, webpack, FDD-lite
├── package.json
├── tsconfig.json
├── webpack.config.ts         # bundle background / content / UI
├── .env.example              # URL da API por ambiente
├── manifest.json             # Manifest V3
├── public/                   # ícones, assets estáticos
└── src/
    ├── background/           # service worker (V3)
    │   └── index.ts
    ├── content/              # scripts injetados nas páginas (coleta)
    │   └── index.ts
    ├── ui/                   # popup / sidepanel / options (React ou HTML+TS)
    │   ├── popup/
    │   └── components/       # UI burra
    ├── features/             # domínio (espelho frontend)
    │   └── {feature}/
    │       ├── hooks/
    │       ├── service.ts    # chama backend; sem fetch solto na UI
    │       ├── types.ts
    │       └── index.ts
    └── shared/
        ├── lib/              # api client, auth/JWT storage, utils
        ├── types/
        └── messaging/        # tipos de mensagem background ↔ content ↔ ui
```

## Leis (espelho frontend + extensão)

| Lei | Barra |
|-----|--------|
| TypeScript | Obrigatório em todo o `src/` |
| JS puro | **Proibido** |
| Build | **webpack** (saídas no que o manifest aponta) |
| UI | Componentes burros; lógica em hooks / background |
| HTTP | Só em `features/*/service.ts` (ou `shared/lib`) |
| Auth | Mesma conta / JWT do backend quando o produto compartilhar login com o site |
| Seletores / scrapers por site | Tarefas (Fase 11) — não densificar no setup |

## Diff vs frontend Next

| Frontend | Extension |
|----------|-----------|
| `app/` rotas Next | `background/` + `content/` + `ui/` |
| SSR / RSC | Bundle webpack → arquivos estáticos da extensão |
| boilerplate-front-nextjs | Scaffold próprio com esta árvore |
