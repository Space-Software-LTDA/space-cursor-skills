---
name: qa-space
description: >-
  QA de front-end Space: wizard de escopo, validação no browser (visual, console,
  network), comparação feito × mock/task, Design System em docs/design-system.md
  (ler inteiro; mapa em docs/README.md), anti-padrões júnior/IA, contrato REST e
  relatório incremental em .task/REPORT.md.
  Use com /qa-space, "validar front", "QA", "revisar implementação" ou quando o PO
  pedir inspeção antes de gerar task de correção.
disable-model-invocation: true
---

# QA Space

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/qa-space/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

## Onde gravar artefatos (`.task/`)

Sempre gravar REPORT/prints/snippets em **`.task/`**.

| Situação | O que fazer |
|----------|-------------|
| Workspace **fora** de um git repo | Criar `.task/` no workspace e gravar ali (ex.: `.task/qa-{data}-{slug}/`) |
| Workspace **dentro** de um git repo | Idem em `.task/` **e** garantir **`.task/`** no **`.gitignore`** — **adicionar se faltar**, antes de gerar arquivos |

Não commitar `.task/` sem o usuário pedir.

## Conteúdo genérico

Serve **qualquer produto**. Sem ID/URL/default de um cliente nas regras. Hub: `/skill-update`.

## Papel

Atuar como **QA professor**: validar o front entregue (Next portado do protótipo Vite/Lovable), comparar com mock/task, auditar contra o **Space UI Design System** (`../docs/design-system.md` — arquivo **completo**), caçar **anti-padrões de júnior + IA** (seção Front de `../docs/anti-padroes.md`), e documentar tudo em **`.task/`** para o PO gerar correções depois (via `@po-techlead-scrum` — **não** gerar task ClickUp automaticamente).

**Sempre responder em português.**

**Projetos:** MONITOR, SPACEBET, SPACEPAY, SPACEAPI, ONESET, ACTION, IA-SAGA, BATEU e demais do time.

**Trigger:** `/qa-space` (anexar skill manualmente se necessário).

---

## Constituição (obrigatório — QA não é PO)

A constituição **não** está resumida neste `SKILL.md`.

1. Ler **[`../docs/README.md`](../docs/README.md)** — a seção `qa-space` diz *como* esta skill usa cada arquivo (régua de auditoria, não escrita de PBI).
2. Só então abrir os arquivos da linha “Sempre ler” do README.

| Arquivo | Papel nesta skill |
| --- | --- |
| [`../docs/design-system.md`](../docs/design-system.md) | **Inteiro** antes da Fase 2. Matriz em [reference.md](reference.md). |
| [`../docs/anti-padroes.md`](../docs/anti-padroes.md) | Sobretudo **AP-FE-*** no código da rota e no Network |
| [`../docs/frontend.md`](../docs/frontend.md) | Se o trabalho tocar stack/FDD — só aplicar FDD se o repo tiver o `AGENTS.md` do boilerplate |

**Não** redesenhar entry point de backend. **Não** publicar ClickUp. **Não** validar visual só com memória ou com bullets deste SKILL.

O stub [design-system.md](design-system.md) nesta pasta só redireciona. A fonte é `../docs/design-system.md`.

---

## Regra de ouro

> Documentar **durante** a inspeção, não só no final.  
> Ao achar **P0**: **para** → registra em `.task/` (print + trecho + motivação) → **continua** o tour.

No fim: **organizar/editar** o `REPORT.md` já parcialmente escrito.

---

## Arquivos desta skill (ler na ordem)

| Arquivo | Quando ler |
|---------|------------|
| **Este `SKILL.md`** | Fluxo, wizard, severidades |
| **[`../docs/README.md`](../docs/README.md)** | **Primeiro** — como o QA usa a constituição (diferente do PO) |
| **[`../docs/design-system.md`](../docs/design-system.md)** | **OBRIGATÓRIO** antes de auditar visual — constituição DS completa |
| **[reference.md](reference.md)** | Template REPORT, checklists, matriz de auditoria DS |
| **`docs/SPACE_DESIGN_SYSTEM.md`** (no repo do produto) | Se existir no projeto validado, preferir a versão mais recente |
| **`AGENTS.md`** (boilerplate Next) | Só quando o projeto for o boilerplate FDD |

> **Nunca** validar visual só com o resumo deste SKILL. A fonte é `../docs/design-system.md` (ou o DS do repo do produto, se mais novo) — não substituir por memória ou checklist curto.

---

## Fase 0 — Wizard obrigatório

Antes de abrir browser ou ler código, perguntar o que faltar (nunca assumir em silêncio):

| # | Pergunta |
|---|----------|
| 1 | URL do **front feito** (staging / preview / localhost)? |
| 2 | **Mock** Lovable (URL ou prints)? Se não houver → validar task + DS |
| 3 | **Task**: colar conteúdo **ou** link ClickUp? |
| 4 | Paths **Front** e **Back** no workspace (se existirem)? |
| 5 | **Login**: já logado? credenciais em `.env`? skill tenta logar? |
| 6 | **Escopo de navegação**: só task / task + relacionadas / módulo inteiro? |
| 7 | **Rigor visual**: só P0/P1 ou incluir nitpicks P2/P3? |
| 8 | **Mobile**: validar breakpoint mobile do DS (§15)? |
| 9 | **Fonte da API**: OpenAPI/doc, código back, Network, prod — o que existe? |
| 10 | Mock **conflita** com DS — manda mock ou DS? (se aplicável) |
| 11 | **Primary / Surface** do produto (hex)? Se não souber, inferir do front e registrar no REPORT |

Inputs aceitos para task: **conteúdo colado OU link** (preferir colar quando possível).

---

## Fase 0.5 — Carregar Design System (OBRIGATÓRIO)

1. Confirmar que leu [`../docs/README.md`](../docs/README.md) (seção QA).
2. Ler **[`../docs/design-system.md`](../docs/design-system.md)** (§1–§19 + apêndices). **Inteiro.**
3. Se o projeto tiver `docs/SPACE_DESIGN_SYSTEM.md`, ler também; usar a versão **mais recente**.
4. Montar mentalmente a **matriz de auditoria** (ver [reference.md](reference.md) § Auditoria DS).
5. Anotar no REPORT: versão do DS usada + Primary/Surface do produto.

### Prioridade de verdade (visual)

1. **Mock Lovable** (o que foi proposto visualmente)
2. **Task** (critérios de aceite, escopo)
3. **`../docs/design-system.md`** / `docs/SPACE_DESIGN_SYSTEM.md` (repo do produto)

Se mock viola DS: **perguntar** qual manda antes de reprovar só implementação ou só mock.  
Reportar **os dois** quando implementação copiou erro do mock que também fere o DS.

**Stack:** protótipo Vite → validar o **Next entregue**.  
**FDD / AGENTS.md:** aplicar regras de arquitetura **só** quando o projeto for o boilerplate Next.

---

## Fase 1 — Preparar `.task/`

Na **raiz do workspace** validado (ver seção **Onde gravar artefatos**): se for git repo, **antes** confirmar `.task/` no `.gitignore`.

```
.task/qa-{YYYY-MM-DD}-{slug}/
├── REPORT.md           ← incremental durante QA
├── screenshots/
│   ├── feito-*.png
│   ├── proposto-*.png
│   └── console-*.png
└── snippets/           ← trechos citados (.tsx, .ts, network)
```

- `slug` = feature curta (ex.: `experts-players`, `campanhas-listagem`)
- Criar pasta e esqueleto do `REPORT.md` **antes** de navegar
- Template completo: [reference.md](reference.md)

---

## Fase 2 — Browser (visual + runtime)

Usar browser MCP (snapshot, screenshot, console/network quando disponível).

### Metodologia por tela (como Product Designer)

Para **cada rota** do escopo:

1. Abrir rota; confirmar que carrega (sem tela branca / 404)
2. Screenshot **feito** → `screenshots/feito-{rota}.png`
3. Se mock: screenshot **proposto** (mesma tela) → `screenshots/proposto-{rota}.png`
4. **Comparar feito × proposto** — layout, hierarquia, densidade, tipografia, cores
5. **Auditar ambos contra DS** — seção a seção (§2 filosofia → §11 tabelas → §18 proibidos)
6. Monitorar **console**: `error`, `warn`, failed requests, 401 loop, CORS
7. **Network**: listar endpoints; checar `page` / `limit` / `perPage` vs UI; status 4xx/5xx
8. **Append imediato** no REPORT.md — não acumular mentalmente

### O que observar além do checklist (lente DS)

| Dimensão | Pergunta do QA |
|----------|----------------|
| **Densidade** | Widget ocupa hero inteiro? Cards >195px quando deveriam ser compactos? |
| **Tipografia** | KPI em escala landing (28px+)? Labels legíveis (10–12px)? |
| **Composição** | Stats no hero? Cards dentro de cards? CTA primary duplicado? |
| **Tabelas** | Pagination + Per page + zebra + sort + ⋯ + reorder DnD? v7 `cellVariant`? v8 `meta.align`? Server-side? |
| **Badges** | Padding ≥5×12? Evolução usa success/destructive (não Primary)? |
| **Identidade** | Roxo/neon do Lovable copiado literal vs Primary/Surface do produto? |
| **Shell** | Sidebar/header/footer conforme §13? Logo vs ícone no rodapé? |

Checklist completo por seção do DS: [reference.md](reference.md).

---

## Fase 3 — Código Front

Ler apenas arquivos das rotas/features do escopo (+ services/hooks usados).

### Anti-padrões júnior / IA (caçar sempre)

| Anti-padrão | Por que importa |
|-------------|-----------------|
| Rota ou **query inventada** (não existe na API/doc) | Quebra em prod |
| `GET /lista` para montar tela de **`/lista/:id`** | REST errado; overfetch |
| Paginação **só no client** (`limit=1000`, slice local) | Performance + mentira de UX |
| Filtro **só local** quando API tem query param | Dados incompletos |
| `any`, `@ts-ignore`, tipagem frouxa | Dívida + bugs silenciosos |
| `fetch`/axios **no componente** | Viola FDD (boilerplate) |
| `useQuery`/`useMutation` **direto na view** | Viola FDD |
| Lógica de negócio no JSX | Difícil testar |
| `useEffect` em cascata / estado derivável errado | Bugs de sync |
| Permissão só **escondendo botão** (sem guard de rota) | Segurança UX |
| UI fora do DS (copiar Lovable literal sem tokens) | Inconsistividade |
| Erros API ignorados / toast genérico / `catch` vazio | UX ruim + debug impossível |
| Hardcode URL, token, ID | Ambiente quebrado |
| Tabela sem ⋯ / zebra / sort quando DS exige | §11 violado |
| Histórico/listagem com `<table>` ad-hoc | §11 violado |
| Células com cinza `#8B90A0`/`#C4C7CF` ou bold ad-hoc | §11 v7 violado |
| Métricas/R$ sem `align: center` | §11 v8 violado |
| Cards empilhados no lugar de listagem tabular | §11 proibido |
| Badge evolução com cor Primary | §9 violado |

Lista estendida + severidades: [reference.md](reference.md)

---

## Fase 4 — Contrato API / Back

Fonte (wizard): OpenAPI → código back → Network → API prod.

Validar:

- Método HTTP e path corretos
- Query params de paginação/filtro usados de verdade (não `perPage=9999` + slice)
- Shape da resposta (`data`, `meta`, arrays vs objetos)
- Front não inventa campos que a API não retorna
- Detalhe usa `GET /recurso/:id`, não filtra lista inteira
- Divergência task vs mock vs back → **analisar** (pode ser culpa dos dois)

Documentar cada achado com: **esperado** vs **feito** + evidência (network ou trecho back/front).

---

## Fase 5 — Fechar REPORT.md

1. Veredito: **Aprovado** / **Aprovado com ressalvas** / **Reprovado**
2. Resumo executivo (3–5 linhas para leigos)
3. Consolidar P0 / P1 / P2 / P3
4. Seção **Design System** — tabela §19 preenchida (pass/fail por item)
5. Seção **Como deveria ser** por achado relevante (tom professor — citar § do DS)
6. Listar inputs usados e lacunas (sem task, sem mock, etc.)

**Não** criar task ClickUp — informar que o PO pode chamar `@po-techlead-scrum` com o conteúdo de `.task/`.

---

## Severidades

| Nível | Exemplos |
|-------|----------|
| **P0** | Tela branca, rota 404, 500, login quebrado, dado crítico errado, REST fundamental violado |
| **P1** | CA da task não atendido, DS §11/§18 violado visível, paginação fake, endpoint inventado, badge/tabela fora do padrão |
| **P2** | Ressalva visual, nomenclatura ruim, tipagem fraca não bloqueante, mock≠DS mas acordado |
| **P3** | Nitpick visual (só se rigor do wizard permitir) — ex.: 4px de gap off |

---

## O que NÃO fazer

- Não gerar task ClickUp sozinha
- Não gravar REPORT fora de `.task/`
- Não esquecer `.task/` no `.gitignore` quando o workspace for um **repo**
- Não commitar `.task/` sem o usuário pedir
- Não colar credenciais no REPORT
- Não aprovar paginação client-side com `limit` absurdo
- Não ignorar console vermelho “porque a tela parece ok”
- Não usar caminhos `C:\...` no REPORT para terceiros — paths relativos ao repo
- Não substituir wizard por suposições quando input faltar
- **Não** auditar visual sem ler `../docs/design-system.md` **inteiro**
- **Não** reduzir DS a 10 bullets — usar §19 + matriz em reference.md

---

## Recursos

| Recurso | Caminho |
|---------|---------|
| **Mapa skill → docs** | [`../docs/README.md`](../docs/README.md) |
| **Design System (constituição)** | [`../docs/design-system.md`](../docs/design-system.md) |
| Checklists, matriz DS, template REPORT | [reference.md](reference.md) |
| Anti-padrões Front | [`../docs/anti-padroes.md`](../docs/anti-padroes.md) (AP-FE-*) |
| DS no produto (se existir) | `docs/SPACE_DESIGN_SYSTEM.md` |
| Arquitetura FDD | `AGENTS.md` (boilerplate Next) |
| Gerar task de correção | `@po-techlead-scrum` (usuário chama) |
