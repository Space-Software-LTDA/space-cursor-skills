# Decomposição tom professor — regra GLOBAL (OBRIGATÓRIO)

**Toda task** gerada por `po-techlead-scrum` segue este arquivo — **não** só telas com abas, **não** só ONESET, **não** só Front.

Se o júnior precisar abrir o protótipo ou adivinhar o que um campo faz → **task incompleta**.

---

## ❌ Erro a nunca repetir

| Atalho proibido | Por que falha |
| --- | --- |
| Tabela de 1 linha por tela/aba/KPI | Omite campos, tokens, estados, Back vs Front |
| "Implementar CRUD" / "Ver protótipo" | Júnior não tem spec |
| "Dev back é crítico" → resumir UI | PO flexibiliza **schema/rotas**, não **didática** |
| Um parágrafo para módulo inteiro | SuperAgente quebra PBIs vagos |
| CA genérico ("funciona como protótipo") | Não testável |

### Regra de ouro

| PO flexibiliza | Task **ainda** explica tintim por tintim |
| --- | --- |
| Schema, rotas, shape JSON final | Comportamento, campos, fluxos, tooltips, mocks |
| Dev sênior propõe arquitetura | Júnior implementa com spec na task |

---

## 🔁 Regra GLOBAL de decomposição

**Unidade mínima de escrita** = **1 bloco autônomo** que o júnior implementa ou testa sozinho.

| Tipo de escopo | Unidade mínima | Nunca agrupar como |
| --- | --- | --- |
| **Tela / rota** | 1 seção `#### Tela — Nome` | "Implementar admin" |
| **Aba / sub-aba** | 1 seção por aba (e por sub-aba) | Tabela N linhas |
| **Modal / drawer** | Seção própria | Mencionar só em passing |
| **KPI / métrica** | 1 subseção com Back + Front + tooltip | Lista sem explicação |
| **Endpoint** | Comportamento + query/body + exemplo | "CRUD users" |
| **Coluna / campo DB** | Linha na tabela coluna-a-coluna | Só DBML sem Notes |
| **Token / placeholder** | Linha no glossário + exemplo antes→depois | Citado uma vez no texto |
| **Integração / mock** | O que é real vs 🎭 mock | Misturar sem marcar |
| **Fluxo (impersonate, webhook)** | Passos numerados ou diagrama imagem | Só diagrama sem prosa |

**Contagem:** 3 abas = **3 seções completas**. 12 KPIs = **12 explicações** (ou tabela 12 linhas **com** colunas Back / Front / tooltip). 5 sub-abas ficha usuário = **5 seções**.

---

## ClickUp — hierarquia de títulos (OBRIGATÓRIO)

O editor do ClickUp renderiza `#####` (h5) e `######` (h6) **minúsculos** — ilegíveis.

| Nível | Markdown | Uso |
| --- | --- | --- |
| Título da task | `#` | Uma vez no topo |
| Seções principais | `##` | Contexto, Objetivo, Alterações, CA |
| Módulos / camadas | `###` | Backend, Frontend, Referência visual |
| Blocos (KPI, aba, tela) | `####` | **Máximo de heading** — 1 por unidade mínima |
| Sub-partes do bloco | `**Negrito**` | "Para que serve", "Backend", "Front" — **sem** `#` extra |

**Proibido:** `#####` e `######` em tasks coladas no ClickUp.

---

## 📋 Template GLOBAL — bloco autônomo

Copiar **para cada** unidade mínima (tela, aba, KPI, endpoint crítico):

```markdown
#### [Tipo] — [Nome exato no protótipo/código]

**Para que serve (negócio):** [Quem usa, quando, por quê existe]

**Print:** ![legenda didática](url-space-assets) *(se Front)*

**O que o júnior deve observar no print**
- [bullets: campos, badges, contadores, empty state]

**Campos / controles / colunas**

| Nome | Tipo | Obrigatório | Comportamento | Back | Front |
| --- | --- | --- | --- | --- | --- |
| … | … | sim/não | … | … | … |

**Tokens / variáveis** *(se houver — senão omitir)*

| Token | Significado | Origem do valor | Exemplo resolvido |
| --- | --- | --- | --- |

**Backend — comportamento esperado**
- Persistência / query / regra
- Código existente a reutilizar *(path/service)*
- ⚠️ Mock ou lacuna

**Frontend — comportamento esperado**
- Layout, interações, validação
- Estados: loading, vazio, erro, 403
- Formatação (R$, %, data)

**Exemplo didático**
> Exemplo: o [persona] faz [ação]. O sistema …
> No DDD **não** usar este bloco hipotético — lá é ordem: Faça login / Abra / Confirme.

**⚠️ Armadilhas**
- Protótipo **dark** vs app **light** — copiar layout, não paleta (validar dark mode no repo na execução)
- …
```

**Proibido** pular subseções relevantes com "idem aba anterior" — repetir o que muda.

---

## 🖥️ Front — checklist por task com UI

- [ ] **Cada rota** do escopo tem seção própria
- [ ] **Cada aba/sub-aba** tem seção própria
- [ ] **Cada modal** (criar, editar, confirmar) documentado
- [ ] Filtros globais da tela — o que enviam à API
- [ ] Botões de ação — o que chamam, redirect, toast
- [ ] Tooltips ⓘ — **texto completo** copiado ou definido
- [ ] Empty states e contadores `(N)` nas tabs
- [ ] Prints space-assets **com legenda** por bloco

---

## 🖥️ Back — checklist por task com API

- [ ] **Cada endpoint** do escopo: método, path, query/body, response mínimo
- [ ] Tabela **coluna a coluna** (não só DBML)
- [ ] DBML + Notes em JSONB/enums
- [ ] curl de exemplo por endpoint crítico
- [ ] O que é mock 🎭 vs dado real
- [ ] Audit log / auth / guard quando sensível
- [ ] Edge cases (404, 403, validação, omitir campo)

---

## 📊 KPIs e métricas — regra GLOBAL

**Nunca** listar KPI em uma linha. **Cada métrica** exige:

| Coluna | Conteúdo |
| --- | --- |
| Nome | Como no protótipo |
| Significado negócio | 1 frase simples |
| Backend | Como calcular; tabelas; mock ⚠️ |
| Frontend | Card, formato, delta, tooltip ⓘ |
| Exemplo | Valor fictício |

Dashboard com 12 KPIs → **12 linhas completas** ou **12 subseções**.

---

## 🧩 Tokens e placeholders — regra GLOBAL

Sempre que o protótipo ou código tiver `{variavel}`, `{{mustache}}`, `{KeyWord:…}`, chips, pills de preview:

1. **Glossário** no início do módulo (não no fim)
2. **Por token:** significado, origem, onde aparece, exemplo antes→depois
3. **Persistência vs runtime** — o que grava no DB vs o que resolve na campanha/request
4. Citar **engine existente** no repo se houver

Exemplo concreto ONESET Profissões: ver [exemplos/oneset-profissoes-tokens.md](exemplos/oneset-profissoes-tokens.md).

---

## 🔍 Fluxo do agente (antes de entregar)

1. Inventariar **todas** unidades mínimas (telas, abas, KPIs, endpoints)
2. [lovable-vs-local.md](lovable-vs-local.md) — matriz lacunas
3. [playwright-capture.md](playwright-capture.md) — prints
4. Escrever **1 bloco template por unidade** — Backend e Front na mesma task
5. CA **BE-n / FE-n** — pelo menos 1 CA testável **por bloco crítico**
6. Revisar checklist anti-rasa abaixo

---

## ✅ Checklist anti-task-rasa (GLOBAL)

- [ ] Zero módulos descritos em **1 parágrafo** ou **1 linha de tabela**
- [ ] Cada aba/sub-aba/modal/KPI principal = seção própria
- [ ] Glossário de termos **e** tokens (quando existirem)
- [ ] Back e Front descritos **por bloco**, não fundidos
- [ ] Exemplo didático com persona fictícia **por módulo complexo**
- [ ] Código/repo existente citado (grep feito)
- [ ] PO **não** precisaria abrir Lovable só para entender escopo
- [ ] Visual: repo (tema atual) > DS (buraco) > mock (campos/ações) — print neon **não** vira critério
- [ ] Critérios de aceitação específicos (não "conforme protótipo")

---

## 📎 Exemplos por tipo de task

| Tipo | Decomposição mínima |
| --- | --- |
| Admin / painel multi-módulo | 1 seção por módulo + KPI/aba/modal dentro de cada |
| CRUD simples | Listagem + Criar + Editar + Detalhe (mesmo 1 entidade) |
| Integração webhook | Payload campo a campo + idempotência + retries |
| Job/cron | Schedule + query + efeito colateral + log |
| Só Back | Endpoint a endpoint + coluna a coluna |
| Só Front | Tela a tela + estados |
