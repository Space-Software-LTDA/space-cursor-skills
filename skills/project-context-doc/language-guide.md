# Linguagem Space — Documento de Contexto (ClickUp)

Convencoes compartilhadas com a skill `po-techlead-scrum`. Este doc e **conhecimento do sistema existente**, nao tarefa de implementacao.

**Sempre responder e gerar documentacao em portugues (PT-BR), salvo pedido contrario.**

Ver tambem [pedagogical-examples.md](pedagogical-examples.md) para estruturas detalhadas e checklist de clareza.

---

## Tom — professor, nao telegrafico

**Publico-alvo:** dev junior que **nunca viu** o produto e vai ler o doc para entender e tirar duvidas — nao para decidir em 30 segundos.

| Fazer | Nao fazer |
|-------|-----------|
| Explicar como um **professor paciente** — contexto, cenario, exemplo, consequencia | Jogar informacao solta ("Unique email+app. Por que: white-label.") |
| Secoes longas quando **ensinam** (FL, RN, G criticos) | Resumir RN/G/FL para "caber" catalogo enorme |
| Exemplos concretos do produto (URLs, domains, emails ficticios mas realistas) | Abstracoes sem ancoragem ("o tenant", "a bet") |
| Casos de uso narrativos antes de tabelas tecnicas | Ir direto para tabela sem cenario |
| Cross-links clicaveis entre artefatos ([RN-008](#rn-008)) | Referenciar `RN-008` como texto morto |

### "Nao ser redundante" ≠ "nao ser explicativo"

Importado de `po-techlead-scrum` — regra central desta skill:

- **Redundante** = repetir a mesma decisao 3 vezes **sem agregar informacao**
- **Explicativo** = dar contexto, exemplo e regra para o junior executar **sem adivinhar**
- Em duvida, **prefira mais exemplo** (curl, JSON, cenario, certo vs errado) a menos texto abstrato

### Verboso ≠ ambiguo

- **Verboso:** cada parágrafo desenvolve **uma ideia** com exemplo ou consequência prática
- **Ambiguo:** frases vagas que permitem duas interpretações opostas
- Um RN bem escrito tem **15+ linhas uteis** — nao 3 linhas telegraficas

---

## Narrativa antes, referencias depois (obrigatorio)

Ordem fixa em **FL, RN e G**:

1. **Por que importa** — paragrafo(s) explicando o risco de nao entender
2. **Cenario** — narrativa com persona (Maria/Joao), URLs/paths reais da Fase 3
3. **O que acontece passo a passo** — 5+ passos numerados, 1–2 frases cada (fluxos complexos)
4. **Pre-condicoes** / **Comportamento** — bullets tecnicos **depois** do paragrafo narrativo
5. **Diagrama** / **Tabela tecnica** — metadados por repo
6. **Referencias** — RT, RN, G, TB, INT, WH — **sempre por ultimo**

### Proibido (anti-telegrafico)

| Proibido | Por que |
|----------|---------|
| Frases encadeadas com `;` no lugar de paragrafos | Parece nota de sprint — dev conclui errado |
| Bullets de 3–5 palavras onde deveria haver explicacao | Nao ensina — so lista |
| Links `[RT-xxx](#rt-xxx)` no meio do paragrafo narrativo | Distrai antes de absorver o fluxo |
| Coluna **Ref** na tabela FL | Referencias vao no bloco **Referencias** apos a tabela |

### Permitido no corpo narrativo

- Paths (`/game/[id]`, `/players/login`)
- URLs e domains da Fase 3
- Nomes de telas, rotas em texto plano ("rota de start-kyc")
- **Sem** hyperlinks de catalogo RT/RN/TB no paragrafo — esses ficam em **Referencias**

---

## Minimos obrigatorios por artefato

| Artefato | Minimo didatico | Proibido |
|----------|-----------------|----------|
| **FL-xxx** | Cenario + passo a passo (5+ passos ou paragrafo longo) + tabela sem coluna Ref + **Referencias** no final | Uma frase com `;` encadeando tudo; tabela seca |
| **FL Por que importa** | 3+ frases em fluxos contra-intuitivos (KYC, proxy, PIX) | 1 frase generica |
| **RN-xxx** | Cenario 5+ frases + comportamento + regra + Por que (2+ frases) + exemplo + erro comum + **Referencias** | Bullets secos antes do paragrafo |
| **G-xxx** | Cenario de violacao 4+ frases + consequencia + **Referencias** | So titulo + 1 linha |
| **TB coluna** | Para que + Por que (frase completa, nao fragmento) | "Auditoria" / "ORM" como unico Por que |
| **RT Tier 1** | Ficha tecnica no Apendice — narrativa so em FL/RN | Repetir cenario Maria no RT |
| **RT Tier 2** | Por que ≥ 1 frase + link para FL/RN | Por que de 3 palavras genericas |

---

## Antes vs Depois — exemplo canonico (RN-008)

Use este padrao mental ao escrever **qualquer** RN contra-intuitiva.

### Ruim (telegrafico — nao entrega)

```markdown
### RN-008: Mesmo email, senhas diferentes por Application

**Fluxo:** FL-001

**Regra:** Unique (email, applicationId). Tenants distintos = registros distintos.

**Por que:** white-label — apps sao marcas separadas.
```

**Problema:** quem le nao entende *o que acontece na pratica* nem *o que o dev erra*.

### Bom (professor — esclarecedor)

Ver estrutura completa em [template-rn-guardrail.md](template-rn-guardrail.md) e exemplo preenchido em [pedagogical-examples.md](pedagogical-examples.md#exemplo-rn-008).

Resumo do que o bom inclui a mais:

- **Cenario:** Joao usa `joao@gmail.com` no App A e no App B — sao dois Players, duas senhas
- **Exemplo concreto:** headers, domains, o que o banco guarda
- **Erro comum:** dev assume SSO e tenta merge de contas cross-tenant
- **Ver tambem:** links para [FL-001](#fl-001), [TB-002](#tb-002), [G-002](#g-002)

---

## Indice e hyperlinks (obrigatorio)

Layout ClickUp: ver [document-layout.md](document-layout.md).

### Indice curto vs Apendice

| Onde | Conteudo |
|------|----------|
| **Topo** | Indice curto (~15 links de secao) + Referencia rapida |
| **Apendice** | Tabela completa FL/RN/G/TB/RT, indices TB/RT, DBML, RT Tier 1 expandido |

**Proibido no topo:** listagem individual de 200+ RT/TB; blocos DBML; `<details>`/acordeon (nao renderiza no ClickUp).

### Anti-duplicacao FL vs RT

- **FL/RN** = unica narrativa longa (cenario Maria/Joao)
- **RT Tier 1 corpo** = tabela resumo + link ficha no Apendice
- **RT Tier 1 Apendice** = ficha tecnica (curl, headers) + "Ver [FL-001](#fl-001) para narrativa"

Todo documento final deve ter **Indice curto** logo apos Referencia rapida — ver [template-clickup.md](template-clickup.md).

### Convencao de anchors

Usar anchor HTML **explicito** antes de cada heading numerado (compatibilidade ClickUp):

```markdown
<a id="rn-008"></a>
### RN-008: Mesmo email, senhas diferentes por Application
```

| Prefixo | Formato ID | Exemplo link |
|---------|------------|--------------|
| FL | `fl-001` | `[FL-001 Login](#fl-001)` |
| RN | `rn-008` | `[RN-008](#rn-008)` |
| G | `g-002` | `[G-002](#g-002)` |
| TB | `tb-002` | `[TB-002 player](#tb-002)` |
| RT | `rt-001` | `[RT-001](#rt-001)` |
| WH | `wh-003` | `[WH-003](#wh-003)` |
| DA | `da-001` | `[DA-001](#da-001)` |

**Regra:** coluna **Ref** em FL e secao **Ver tambem** em RN/G usam links markdown, nao texto solto `RN-008`.

Validar no ClickUp apos colar — se slug automatico falhar, anchor HTML `<a id="...">` e o fallback.

---

## Regra de inclusao condicional (nao negativa)

**Buscar sempre. Incluir so o que existe.**

| Acao | Regra |
|------|-------|
| Achou no codigo | Inclui secao completa |
| Nao achou | **Omite a secao inteira** — nunca escrever "Nao tem X" |
| Ausencia relevante | Documentar so quando a falta ensina algo (ex.: API 100% publica sem auth) |

**Nunca incluir:**
- "Nao identificado neste projeto"
- "N/A" para dominios ausentes (webhooks, crons, multi-tenant)
- Secoes vazias ou placeholders negativos

**Excecoes validas (documentar ausencia):**
- Projeto sem autenticacao alguma
- Single-tenant por design quando se esperaria multi-tenant
- Decisao arquitetural explicita de nao ter integracao externa

---

## Formato ClickUp

### Aviso de IA (sempre no topo)

```markdown
> ⚠️ Este documento foi gerado com auxilio de IA com base na analise do codigo e nas informacoes fornecidas pelo time. Podem existir interpretacoes incorretas ou incompletas. Valide com o Tech Lead antes de tomar decisoes baseadas neste conteudo.
```

### Emojis nos titulos de secao

| Secao | Emoji |
|-------|-------|
| Indice | 📑 |
| Contexto | 📌 |
| Referencias / Apidog | 🔗 |
| Mapa do sistema | 🎯 |
| Glossario | 📖 |
| Regras de negocio | 📋 |
| Guardrails | 🚫 |
| Banco de dados | 🗄️ |
| Rotas | 🛣️ |
| Auth | 🔐 |
| Multi-tenant | 🏢 |
| Integracoes | 🔌 |
| Webhooks | 📥 |
| Crons / jobs | ⏱️ |
| Variaveis de ambiente | ⚙️ |
| Fluxos end-to-end | 🔄 |
| Decisoes arquiteturais | 🏗️ |
| Referencia por repo | 📦 |
| Ambientes | 🌍 |
| Setup rapido | 🚀 |
| Observacoes | ⚠️ |

Use separadores `---` entre blocos grandes.

### Tabelas

Preferir tabelas para: campos, ENV, rotas Tier 2, mapeamentos, sucesso vs falha.

RN, G e FL criticos: **prosa + subsecoes** antes de tabelas — nao substituir narrativa por tabela.

### Vocabulario

Glossario = termos **encontrados no codigo** e confirmados na Fase 3. Manter o mesmo termo em todo o doc (nao alternar sinonimos para a mesma coisa).

---

## Prefixos numerados

| Prefixo | Uso |
|---------|-----|
| FL-xxx | Fluxo end-to-end multi-repo (eixo primario de leitura) |
| RN-xxx | Regra de negocio |
| G-xxx | Guardrail (proibido) |
| RT-xxx | Rota / endpoint / page |
| TB-xxx | Tabela de banco |
| DA-xxx | Decisao arquitetural |
| INT-xxx | Integracao externa (servico terceiro, adapter, SDK) |
| WH-xxx | Webhook |
| CR-xxx | Cron / job / worker |

Numeracao sequencial por tipo, sem duplicatas.

---

## Aliases de repositorio

Definidos na **Fase 0b** e publicados na secao **Mapa do Sistema**. Fonte unica da verdade.

| Alias | Deriva de | Exemplo |
|-------|-----------|---------|
| `[front]` | Papel Cliente UI | Next.js, React Native |
| `[core]` | Papel API principal | Express, Nest, FastAPI |
| `[adapters]` | Papel integracao externa | adapters/, providers/ |
| `[mobile]` | App mobile quando separado do web | Flutter, RN standalone |

Regras:

- Alias = tag curta pelo **papel inferido no recon**, nao pelo nome comercial.
- Usar alias em **toda** linha de FL, RT, TB, INT, WH, CR, ENV.
- Formato: coluna **Repo** = `` `[core]` (nome-da-pasta) `` ou inline no passo do fluxo.
- Monorepo: um alias por pacote/app mapeado no recon.

---

## Hierarquia flow-first

```text
Didatico antes de exaustivo — RN/FL/G bem escritos valem mais que catalogo comprimido.
Fluxo end-to-end e o eixo de leitura.
Repo e metadado inline (badge/alias), nunca o eixo principal.
Catalogos (RT, TB, INT) sao referencia — passam pelo checklist de agrupamento ([index-grouping-guide.md](index-grouping-guide.md)), linkados aos fluxos.
```

O dev deve entender jornadas criticas lendo **FL-xxx** antes de mergulhar em catalogos.

---

## Dicionario TB (colunas)

Tabela humano **sem coluna Tipo** — tipo fica no DBML (dbdiagram.io):

| Coluna | Para que | Por que |
|--------|----------|---------|
| [nome] | [papel no dominio — frase completa] | [razao de existir — frase completa] |

Evitar Por que generico ("auditoria", "padrao ORM") sem explicar **por que este produto** precisa da coluna.

---

## Diagramas

**Nunca** incluir blocos ` ```mermaid ` no documento ClickUp.

1. Escrever codigo Mermaid internamente
2. Gerar PNG via [mermaid.ink](https://mermaid.ink) com `scripts/render-mermaid.sh`
3. Validar HTTP 200
4. Inserir somente `![descricao](url)` com `bgColor=!white`

Ver tambem `diagrams.md` em `po-techlead-scrum` para detalhes da API.

---

## Marcadores especiais

| Marcador | Uso |
|----------|-----|
| `[CONFIRMAR]` | Inferencia do codigo nao validada pelo humano |
| `⚠️` | Risco, edge case, divergencia Apidog vs codigo |

Listar todos os `[CONFIRMAR]` em secao final **Revisao pendente** antes de entregar.

---

## Seguranca no doc

- **Nunca** colar valores reais de secrets, tokens ou senhas
- ENV: documentar nome, para que, por que — nunca o valor de `JWT_TOKEN_SECRET`, `WEBHOOK_SECRET`, etc.

---

## Divisao Apidog vs este doc

| Apidog | Este documento |
|--------|----------------|
| Payload, response, params | Por que existe + cenario de uso |
| Contrato HTTP | Para que serve + exemplo concreto |
| Status codes | Regras de negocio (RN) com contexto |
| Exemplos request | Guardrails (G) + certo vs errado |
| — | DBML + dicionario de colunas + casos de uso |

---

## Destino do arquivo

| Aspecto | Comportamento |
|---------|---------------|
| Onde salvar | `.docs/` na raiz do workspace |
| Nome | `.docs/contexto-[slug-produto].md` |
| Conteudo | Markdown formatado para ClickUp (copiar/colar valido) |
| Git | Nao commitar automaticamente |

---

## O que NAO fazer

- Nao gravar `.docs/contexto-*.md` antes da Fase 4 (gate humano)
- Nao pular Fase 0b ou Fase 3 por pedido generico ("implemente", "teste agora", "execute plano")
- Nao commitar automaticamente — salvar sempre em `.docs/` so na Fase 4
- Nao usar bloco Mermaid inline
- Nao omitir Por que/ Para que em colunas ou rotas
- Nao incluir coluna Tipo no dicionario TB (fica no DBML)
- Nao organizar leitura primaria por repo (fluxo primeiro, repo como tag)
- Nao encher o doc com secoes "nao tem"
- Nao copiar README de setup como foco principal (setup rapido = 1 pagina no final)
- Nao assumir confirmacao silenciosa do usuario — aguardar resposta na 0b e na 3
- **Nao enxugar RN/G/FL** para caber catalogo — usar Tier 1/Tier 2 para rotas (ver [template-routes.md](template-routes.md))
- **Nao gerar doc via script em massa** com Por que generico de 1 linha para RN/FL/G
- **Nao entregar doc sem Indice global** com links para FL/RN/G principais
- **Nao escrever RN sem caso de uso** — ver [pedagogical-examples.md](pedagogical-examples.md)
