# Template RN-xxx, G-xxx e DA-xxx

RN e G devem referenciar **FL-xxx** quando fazem parte de jornada critica — regras isoladas confundem o dev.

**Formato abaixo e OBRIGATORIO na Fase 4** — nao usar variante compacta (Fluxo + Regra + Por que de 1 linha).

Ver exemplos preenchidos em [pedagogical-examples.md](pedagogical-examples.md).

---

## RN-xxx — Regra de Negocio (obrigatorio)

```markdown
<a id="rn-001"></a>
### RN-001: [Titulo descritivo]

**Fluxo relacionado:** [FL-001 Nome](#fl-001) passos 2–5

**Cenario (caso de uso)** — [Narrativa **5+ frases** — persona, acao, resultado. Sem links RT/RN no paragrafo.]

**O que o sistema faz**
- [passo 1 observavel — frase completa com verbo, nunca fragmento "Dashboard → GA4"]
- [passo 2]

**Proibido em bullets RN:** fragmentos telegraficos com seta (`Metricas → GA4`) ou menos de 5 palavras.

**Regra em uma frase** — [Enunciado tecnico claro]

**Por que existe assim** — [Minimo 2 frases]

**Exemplo concreto** — [Dados ficticios realistas]

**Erro comum de dev novo** — [O que implementam errado + consequencia]

**Onde esta no codigo** — `[caminho/arquivo.ext]`

**Referencias** — [FL-001](#fl-001) · [TB-001](#tb-001)
```

**ClickUp:** evitar `####` com linha vazia — usar `**Label** — texto` (ver [clickup-markdown-guide.md](clickup-markdown-guide.md)).

Diagrama sequencia (PNG mermaid.ink) quando fluxo for complexo e ainda nao coberto por FL-xxx.

**Meta de tamanho:** RN critica ≥ 15 linhas uteis. Cenario ≥ 5 frases (ver [pedagogical-examples.md](pedagogical-examples.md)).

---

## G-xxx — Guardrail (obrigatorio)

```markdown
<a id="g-001"></a>
### G-001: [Titulo — o que e proibido]

**Aplica-se em:** [FL-001](#fl-001) passo 2 · `[core]`

**Proibido** — [Acao concreta — o que NUNCA fazer, 1–2 frases completas]

**Cenario de violacao** — [4+ frases — o que o dev tenta, passo a passo, consequencia imediata. Persona + URLs reais da Fase 3.]

**Por que** — [Minimo 2 frases — tenant, seguranca, delegacao, white-label.]

**Se violar** — [Erro HTTP, bug silencioso, corrupcao de dados]

**Enforced em** — `[arquivo/middleware]` ou convencao documentada

**Referencias** — [RN-001](#rn-001) · [FL-001](#fl-001)
```

**ClickUp:** nao usar `#### Proibido` com linha vazia — gera espaco enorme entre titulo e texto (ver [clickup-markdown-guide.md](clickup-markdown-guide.md)). Preferir `**Label** — paragrafo` inline.

---

## DA-xxx — Decisao Arquitetural

```markdown
<a id="da-001"></a>
### DA-001: [Titulo da decisao]

**Decisao:** [o que foi escolhido]

**Alternativas rejeitadas:** [outras opcoes consideradas]

**Motivo:** [por que esta opcao — 2+ frases, nao fragmento]

**Consequencia:** [impacto em manutencao, deploy, novos devs — exemplos concretos]

**Ver tambem:** [FL-xxx](#fl-xxx) · [RN-xxx](#rn-xxx) se aplicavel
```

---

## Quando criar cada tipo

| Situacao | Tipo |
|----------|------|
| Fluxo contra-intuitivo de negocio | RN (+ FL-xxx) |
| Header/campo obrigatorio enforced | G (+ FL passo) |
| Delegacao para servico externo | RN (+ FL-xxx) |
| Proibicao de implementacao alternativa | G |
| Decisao estrutural de repos/padroes | DA |
| Regra em CLAUDE.md / AGENTS.md | G |

---

## Cross-links (obrigatorio)

| De | Para | Formato |
|----|------|---------|
| FL passo Ref | RN/G/RT/TB | `[RN-008](#rn-008)` — link clicavel |
| RN Ver tambem | FL, G, TB, RT | Lista com · separador |
| G Ver tambem | RN, FL | Idem |
| Erros classicos (Contexto) | RN/G | `[RN-008](#rn-008)` na coluna "O que fazer" |

Convencao de anchors: ver [language-guide.md](language-guide.md#indice-e-hyperlinks-obrigatorio).

---

## [CONFIRMAR]

Usar quando inferencia veio so do codigo:

```markdown
#### Por que existe assim

[CONFIRMAR] [texto provisorio — ainda assim 2 frases, nao telegrafico]
```

Listar todos em **Revisao pendente** no final do doc.

---

## Proibido na Fase 4

```markdown
### RN-008: Titulo

**Fluxo:** FL-001
**Regra:** uma linha
**Por que:** uma linha
```

Este formato **nao e aceitavel** — reescrever com template completo acima.
