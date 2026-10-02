# Padrões Space — Fase 6 (genérico)

> **100% genérico.** Sem nome de produto, cliente ou URL de um piloto.  
> O agente da Fase 6 **aplica** estas leis e preenche `.docs/setup.md` do produto da vez.

---

## 1. Nomenclatura de repositório (lei)

**Lei = constituição:** `../docs/nomenclatura.md` (seção Repositórios). Ler antes de nomear; em conflito, vale a constituição.

```text
<cliente>_<produto>_<o-que-é>     padrão da constituição
<cliente>-<produto>-<o-que-é>     quando o cliente já usa hífen
```

| Parte | O que é | Regras |
|-------|---------|--------|
| **cliente** | Slug do cliente / marca dona | minúsculo |
| **produto** | Slug do nome de trabalho do produto | minúsculo |
| **o-que-é** | Tipo da peça | ver tabela abaixo |

**Separador:** vale o padrão que o cliente **já usa** nos repositórios dele; cliente sem repositório → underscore. Um separador só em todos os repositórios do produto.

**Repo completo:** `Space-Software-LTDA/<nome>` (repositório na organização do cliente → sem `<cliente>`, como diz a constituição).

### Valores de `<o-que-é>`

| Peça | `<o-que-é>` |
|------|-------------|
| API / servidor | `backend` |
| Site / app web (Next) | `frontend` |
| Extensão de browser | `extension` |
| Outra peça (painel interno, camada de integrações, etc.) | O que a peça **é**, em uma palavra, como na constituição (ex.: `dashboard`, `backoffice`, `integrations`) — eco + confirma |

**Proibido:** omitir `<cliente>` em repositório da organização Space; maiúscula ou camelCase; misturar `_` e `-` no mesmo produto; `v2` no nome; inventar `api`/`web` no lugar de `backend`/`frontend` sem eco+confirma.

**Quem nomeia:** subagente da Fase 6 (eco → confirma → grava). Antes do eco, perguntar ao cliente se já existem repositórios dele e qual separador usam. Controlador não inventa slug.

---

## 2. Origem por tipo de peça

| Peça | Origem canônica | O que o setup grava |
|------|-----------------|---------------------|
| **backend** | [boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia) | “Nasce deste boilerplate” + link; pastas = AGENTS do repo |
| **frontend** | [boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs) | Idem (+ DS do boilerplate se existir) |
| **extension** | Sem boilerplate Git público Space (ainda) | Segue **lei da extensão** abaixo — não “JS puro” |
| **integrations** | Referência Space (§5), não boilerplate | Link da referência + “um adaptador por fornecedor” |

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
| Nome do repo | `<cliente>_<produto>_extension` (ou com hífen — §1) |
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

## 5. Camada de integração com fornecedores externos

Quando o contrato tem fornecedor externo (pagamento, provedor de serviço, parceiro com API própria), **perguntar** antes de recomendar a organização: “o produto terá uma camada que conversa com os fornecedores e devolve tudo num formato só?”. Não presumir tudo num servidor só.

| Item | Lei |
|------|-----|
| O que é | Peça própria (`integrations`): **um adaptador por fornecedor**; o servidor principal sempre pede e recebe no **mesmo formato**, seja qual for o fornecedor |
| Referência Space | [`space-bet-integrations`](https://github.com/Space-Software-LTDA/space-bet-integrations): pasta por fornecedor com adaptadores, módulos normalizados, catálogo único de erros, fornecedor falso para simulação |
| Fornecedor falso | Pode servir de **simulador** na homologação e no ambiente de testes oferecido aos clientes do produto (se houver) — anotar no setup |
| Citar referência | Conferir no código da referência a ferramenta real (framework, linguagem) antes de escrevê-la no setup; não repetir de memória nem do cartão |

---

## 6. Ferramenta pronta numa superfície (consequência a anotar)

Quando o setup escolhe ferramenta de terceiros para uma superfície (portal de documentação publicado por ferramenta de documentação, página de situação do serviço por ferramenta de monitoramento…), anotar no `setup.md`: **na Fase 8 essa superfície não é desenho livre** — cabe só conteúdo, ordem, logo e cores dentro do layout da ferramenta.

| Ferramenta | Limite conhecido |
|------------|------------------|
| Apidog (“Publicar documentação”) | Publica o **projeto inteiro**. Produto com API pública + rotas internas → a API pública fica num **projeto separado** no Apidog (gravar no setup; a Fase 11 importa cada rota no projeto certo) |

---

## 7. Git e ambientes (lembrete genérico)

- Default Space: **1 repo por peça** (A), salvo monorepo pedido e fechado em gate.  
- Branches: seguir `../docs/git-fluxo.md` da constituição: `hml` + `main` sempre; `dev` **só quando houver ambiente de desenvolvimento compartilhado** (perguntar; sem esse ambiente, a promoção começa no PR para `hml`).  
- App: Dockerfile / EasyPanel; banco = serviço separado (quando deploy entrar no mapa).

---

## 8. O que NÃO vai neste arquivo de skill

| Assunto | Onde |
|---------|------|
| DBML, colunas, GO-12 de tabela | `po-techlead-scrum` + `docs/nomenclatura.md` |
| OpenAPI / rotas no Apidog | Fase 11 (tarefas) — o setup só decide quantos projetos no Apidog (§6) |
| Tokens / `P-…` | `design-system-forge` |
| Auditoria do front feito | `qa-space` |
| Nome concreto de um produto | `.docs/setup.md` **daquele** workspace |
| Criar repo no GitHub | **DEV** na hora de iniciar — não o Agent de setup |