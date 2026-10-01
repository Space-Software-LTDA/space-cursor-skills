# Padrões Space — Fase 6 (genérico)

> **100% genérico.** Sem nome de produto, cliente ou URL de um piloto.  
> O agente da Fase 6 **aplica** estas leis e preenche `.docs/setup.md` do produto da vez.

---

## 1. Nomenclatura de repositório (lei)

```text
<cliente>-<produto>-<o-que-é>
```

| Parte | O que é | Regras |
|-------|---------|--------|
| **cliente** | Slug do cliente / marca dona | minúsculo; hífen se composto |
| **produto** | Slug do nome de trabalho do produto | minúsculo; hífen se composto |
| **o-que-é** | Tipo da peça | ver tabela abaixo |

**Repo completo:** `Space-Software-LTDA/<cliente>-<produto>-<o-que-é>`

### Valores canônicos de `<o-que-é>`

| Peça | `<o-que-é>` |
|------|-------------|
| API / servidor | `backend` |
| Site / app web (Next) | `frontend` |
| Extensão de browser | `extension` |
| Outra (rara) | slug curto acordado com o cliente — ainda no mesmo schema |

**Proibido:** omitir `<cliente>`; camelCase; underscore; inventar `api`/`web` no lugar de `backend`/`frontend` sem eco+confirma do padrão Space.

**Quem nomeia:** subagente da Fase 6 (eco → confirma → grava). Controlador não inventa slug.

**Formato do nome (o que está entre `< >` sai da conversa com o cliente):**

```text
<cliente>-<produto>-backend
<cliente>-<produto>-frontend
<cliente>-<produto>-extension
```

---

## 2. Origem por tipo de peça

| Peça | Origem canônica | O que o setup grava |
|------|-----------------|---------------------|
| **backend** | [boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia) | “Nasce deste boilerplate” + link; pastas = AGENTS do repo |
| **frontend** | [boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs) | Idem (+ DS do boilerplate se existir) |
| **extension** | Sem boilerplate Git público Space (ainda) | Segue **lei da extensão** abaixo — não “JS puro” |

Não copiar árvore de pastas para dentro do `setup.md`.

---

## 3. Extensão de browser (lei Space)

Não há boilerplate Git público como o Next/Elysia, mas a **barra espelha o frontend** (TypeScript, features/shared, build).

| Lei | Barra |
|-----|--------|
| Linguagem | **TypeScript obrigatório** |
| **Proibido** | Extensão em **JavaScript puro** |
| Build | **webpack** |
| Manifest | Preferir **V3** (Chrome atual); V2 só com risco explícito |
| Estrutura | Ver template mínimo [`examples/anexos/extension-STRUCTURE.md`](examples/anexos/extension-STRUCTURE.md) |
| Nome do repo | `<cliente>-<produto>-extension` |
| Auth | Mesma conta / JWT do backend quando houver login compartilhado |
| Quem cria o repo | **DEV**, ao iniciar a peça |

No `.docs/setup.md`: uma linha (TS + webpack + V3 + proibido JS puro). Detalhe de seletores = Fase 11 (tarefas).

---

## 4. Quem cria o repo · ordem

| Item | Lei |
|------|-----|
| **Quem cria** | O **DEV** da peça, **quando for iniciar** (clone boilerplate / scaffold extensão). Setup só nomeia. |
| **Ordem** | Sem ordem fixa no gate. Prática: backend antes se front/extensão dependerem de API — não bloqueia. |

Templates mínimos (mapas, não código): [`examples/anexos/`](examples/anexos/).

---

## 5. Git e ambientes (lembrete genérico)

- Default Space: **1 repo por peça** (A), salvo monorepo pedido e fechado em gate.  
- Branches: seguir `git-fluxo.md` da constituição (tipicamente `hml` + `main`; **sem** inventar `dev` se a lei da empresa não tiver).  
- App: Dockerfile / EasyPanel; banco = serviço separado (quando deploy entrar no mapa).

---

## 6. O que NÃO vai neste arquivo de skill

| Assunto | Onde |
|---------|------|
| DBML, colunas, GO-12 de tabela | `po-techlead-scrum` + `docs/nomenclatura.md` |
| OpenAPI / Apidog | Fase 11 (tarefas) |
| Tokens / `P-…` | `design-system-forge` |
| Auditoria do front feito | `qa-space` |
| Nome concreto de um produto | `.docs/setup.md` **daquele** workspace |
| Criar repo no GitHub | **DEV** na hora de iniciar — não o Agent de setup |