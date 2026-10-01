# Template mínimo — backend

> Derivado de `boilerplate-back-elysia` (`STRUCTURE.md` + `AGENTS.md`).  
> Produto novo: **clonar o boilerplate**; não recriar na mão.

## Quem cria

DEV, ao iniciar a peça `…-backend`.

## Árvore mínima (mapa)

```text
.
├── AGENTS.md                 # leis do agente (controller / service / repository)
├── STRUCTURE.md
├── package.json              # Bun + Elysia
├── tsconfig.json
├── Dockerfile
├── .env.example
├── scripts/
│   ├── generate-module.ts
│   └── generate-migration.ts
└── src/
    ├── index.ts              # entry: Elysia, DB, tracing
    ├── routes.ts             # registro de rotas
    ├── modules/              # domínio (feature)
    │   └── {feature}/
    │       ├── controller.ts
    │       ├── service.ts
    │       ├── repositories/
    │       ├── entities/
    │       ├── schemas/
    │       └── __tests__/
    ├── common/
    │   ├── errors/
    │   └── middlewares/
    ├── infra/
    │   ├── database/
    │   │   ├── datasource/
    │   │   ├── migrations/
    │   │   └── seeds/
    │   └── tracing/
    └── lib/
```

## Camadas (não misturar)

| Camada | Faz | Não faz |
|--------|-----|---------|
| Controller | HTTP, schema, chama service | DB, regra de negócio |
| Service | Regra, orquestra | HTTP, query direta |
| Repository | TypeORM / dados | HTTP, regra |

Testes: **nunca** DB real — mock TypeORM (`AGENTS.md` do boilerplate).
