# Template Master — Documento ClickUp

Omitir secoes condicionais quando nao houver conteudo (ver [language-guide.md](language-guide.md)).

**Layout:** [document-layout.md](document-layout.md) — **util primeiro, catalogo no apendice**.

**Destino do arquivo:** `.docs/contexto-[slug-produto].md` na raiz do workspace — **somente na Fase 4**, apos Fase 0b confirmada e Fase 3 respondida (ver [SKILL.md](SKILL.md) Gates).

**Tom:** professor paciente — ver [pedagogical-examples.md](pedagogical-examples.md). RN/G/FL **nunca** no formato telegrafico.

---

```markdown
> ⚠️ Este documento foi gerado com auxilio de IA com base na analise do codigo e nas informacoes fornecidas pelo time. Podem existir interpretacoes incorretas ou incompletas. Valide com o Tech Lead antes de tomar decisoes baseadas neste conteudo.

---

# 📘 [Nome do Produto] — Contexto para Desenvolvedores

**Validado em:** Fase 0b + Fase 3 · **Idioma:** PT-BR

---

<a id="referencia-rapida"></a>
## ⚡ Referencia rapida

| Item | Valor |
|------|-------|
| App / tenant teste | `https://[domain]` |
| API principal | `https://[api]` |
| Header tenant | `x-application-domain: [domain]` |
| Integration / dashboard | URLs Fase 3 |
| Credenciais teste | [usuario] / [CONFIRMAR senha se nao informado] |
| Repo `[core]` | [git remote URL] |
| Repo `[front]` | [git remote URL] |

---

<a id="indice"></a>
## 📑 Indice

- [Referencia rapida](#referencia-rapida)
- [Contexto](#contexto)
- [Erros classicos de dev novo](#erros-classicos)
- [Por que N repos](#por-que-n-repos)
- [Referencias Apidog](#referencias-apidog)
- [Mapa do Sistema](#mapa-do-sistema)
- [Glossario](#glossario)
- [Fluxos (FL-xxx)](#fluxos-end-to-end)
- [Regras de Negocio (RN-xxx)](#regras-de-negocio)
- [Guardrails (G-xxx)](#guardrails)
- [Banco de Dados (TB-xxx)](#banco-de-dados)
- [Catalogo de Rotas (RT-xxx)](#catalogo-de-rotas)
- [Autenticacao](#autenticacao)
- [Integracoes (INT-xxx)](#integracoes)
- [Webhooks (WH-xxx)](#webhooks)
- [Setup Rapido](#setup-rapido)
- [Apendice — indices completos](#apendice)

[1 paragrafo: como ler — FL primeiro, RT/TB sao referencia, Apendice para busca]

---

<a id="contexto"></a>
## 📌 Contexto

[Problema de negocio em prosa — 2–3 paragrafos. Usuarios.]

<a id="erros-classicos"></a>
### Erros classicos de dev novo

| Erro | Por que acontece | O que fazer |
|------|------------------|-------------|
| [erro] | [intuicao errada] | Ver [RN-xxx](#rn-xxx) |

---

<a id="por-que-n-repos"></a>
## Por que N repositorios

| Repo (alias) | Papel | Por que separado (2+ frases) |
|--------------|-------|------------------------------|
| `[core]` | [...] | [...] |

---

<a id="referencias-apidog"></a>
## 🔗 Referencias — Documentacao API (Apidog)

<!-- Omitir secao se "sem apidog" -->

| Repo (alias) | Link Apidog | O que documenta la vs aqui |
|--------------|-------------|----------------------------|
| `[core]` | [Abrir](URL) | Contratos HTTP — **nao** explica cenarios |
| PK Node / gateway | [Abrir](URL) | PIX planos — **separado** de deposito cassino |

> Apidog = **o que** enviar/receber. Este doc = **por que**, **para que** e **casos de uso**.

---

<a id="mapa-do-sistema"></a>
## 🎯 Mapa do Sistema

![Arquitetura](URL_mermaid_ink)

### Aliases de repositorio

| Alias | Repo (pasta) | Git | Papel | Por que existe |
|-------|--------------|-----|-------|----------------|
| `[front]` | [nome-pasta] | [URL] | Cliente UI | [1 frase] |

---

<a id="glossario"></a>
## 📖 Glossario

| Termo | Significado | Por que importa |
|-------|-------------|-----------------|
| [termo] | [definicao] | [consequencia pratica + link FL/RN] |

---

<!-- FL, RN, G — formato expandido completo no corpo (ver templates) -->

<a id="fluxos-end-to-end"></a>
## 🔄 Fluxos End-to-End (FL-xxx)

<a id="indice-fluxos"></a>
#### Indice deste modulo — Fluxos

- [FL-001 Login](#fl-001)
- [FL-002 Cadastro](#fl-002)
- ...

<a id="fl-001"></a>
### FL-001: [Nome]

#### Por que este fluxo importa · Cenario · O que acontece passo a passo · Pre-condicoes · Tabela · Referencias

<a id="banco-de-dados"></a>
## 🗄️ Banco de Dados

> DBML completo: [Apendice — DBML](#dbml-core)

<a id="tb-001"></a>
#### TB-001: [tabela]

**Para que:** [...] · **Por que existe:** [...]

| Coluna | Para que | Por que |
|--------|----------|---------|
| [col] | [...] | [...] |

---

<a id="catalogo-de-rotas"></a>
## 🛣️ Catalogo de Rotas

### Estatisticas por repo

| Repo | Total | Faixa RT |
|------|-------|----------|
| `[core]` | N | RT-001 … |

### Tier 1 — Resumo (ficha completa no [Apendice](#rt-tier-1-expandido))

| RT | Path | Caso de uso | Fluxo | Ficha |
|----|------|-------------|-------|-------|
| RT-001 | POST /path | [...] | [FL-001](#fl-001) | [#rt-001](#rt-001) |

### Tier 2 — Agrupado por modulo

#### core — Modulo players
- [RT-071](#rt-071) POST /players/login — [FL-001](#fl-001)

<!-- Secoes condicionais: Auth, Tenant, INT, WH, CR, ENV, DA, Setup -->

---

<a id="apendice"></a>
## 📎 Apendice

### Indice completo de artefatos

| ID | Titulo | Link |
|----|--------|------|
| FL-001 | [...] | [#fl-001](#fl-001) |

### Indice TB (exemplo agrupado — checklist passou)

Ver [index-grouping-guide.md](index-grouping-guide.md). Dimensao: cluster natural (ex. repo).

##### `core` — backend (TB-001–NNN)

- [TB-002 `player`](#tb-002)

##### `integration` — integrations (TB-0XX–NNN)

- [TB-027 `players`](#tb-027)

### Indice RT (exemplo agrupado — checklist passou)

#### core — Modulo players (exemplo)
- [RT-071](#rt-071) POST /players/login

<a id="dbml-core"></a>
### DBML — core

\`\`\`dbml
...
\`\`\`

<a id="rt-tier-1-expandido"></a>
### RT Tier 1 — Fichas tecnicas expandidas

<a id="rt-001"></a>
#### RT-001: POST /path

**Narrativa completa:** Ver [FL-001](#fl-001).

| Campo | Valor |
|-------|-------|
| Repo | `[core]` |
| curl | ... |

---

<a id="revisao-pendente"></a>
## Revisao pendente

- [ ] [CONFIRMAR] ...
```

---

## Ordem das secoes

**Fixas:** Aviso → Titulo → **Referencia rapida** → **Indice curto** → Como ler → Contexto → Erros classicos → Por que N repos → Apidog → Mapa → Glossario → FL → RN → G → DB (sem DBML) → RT (resumo + agrupado) → Auth/Tenant/INT/WH/CR/ENV/DA/Setup → **Apendice** → Revisao

**Proibido:** `<details>`, indice com 200+ RT no topo, DBML antes das tabelas TB, RT Tier 1 repetindo cenario FL.
