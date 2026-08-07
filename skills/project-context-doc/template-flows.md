# Template Fluxos End-to-End — FL-xxx

Eixo **primario** de leitura do documento. Catalogos (RT, TB, INT) sao referencia secundaria linkada aos fluxos.

Ver [language-guide.md](language-guide.md) (tom professor verboso) · [pedagogical-examples.md](pedagogical-examples.md) (exemplo FL-008) · [template-clickup.md](template-clickup.md) (ordem das secoes).

---

## Principio

```text
FL/RN = fonte canonica de narrativa (cenario Maria/Joao no corpo).
Narrativa antes, referencias depois — bloco Referencias SEMPRE apos tabela/diagrama.
RT Tier 1 Apendice = ficha tecnica + link FL — nao repetir cenario.
Didatico antes de exaustivo — verboso, nao telegrafico.
Fluxo end-to-end e o eixo de leitura.
Repo e metadado inline (badge/alias), nunca o eixo principal.
```

Ver [document-layout.md](document-layout.md).

O dev deve entender a jornada completa (ex.: Login) lendo **apenas FL-001**, sem saltar entre secoes siloed por repo.

---

## FL-xxx — Fluxo end-to-end (obrigatorio)

```markdown
<a id="fl-001"></a>
### FL-001: [Nome do fluxo — ex.: Login]

**Repos:** `[front]` · `[core]` · `[adapters]` · [externo se houver]

#### Por que este fluxo importa
[3+ frases quando contra-intuitivo — o que o dev erra se nao ler este fluxo inteiro antes de debugar. Sem linha vazia entre titulo e 1a frase.]

#### Cenario
[Paragrafo narrativo: persona, URL, acao, resultado. Minimo 4 frases em fluxos simples.]

#### O que acontece passo a passo

1. [Passo 1 — 1–2 frases completas]
2. [Passo 2 — o que o front/core/integration faz e por que]
3. [Passo 3 — ...]
4. [Passo 4 — ...]
5. [Passo 5 — resultado final para o usuario]

#### Pre-condicoes

- Header `x-application-domain: [exemplo]`
- ENV `[NOME]=[proposito]` (sem valor secret)
- Estado DB ou sessao necessario

**Diagrama:** ![FL-001 Login](url_mermaid_ink_sequence)

| Passo | Repo | O que acontece | Para que | Por que |
|-------|------|----------------|----------|---------|
| 1 | `[front]` | [acao concreta] | [objetivo do passo] | [frase completa — nao telegrafar] |
| 2 | `[core]` | [acao concreta] | [...] | [...] |
| 3 | `[core]` → `[adapters]` | HTTP [METODO] [path] | [...] | [...] |

**Referencias** — [RT-001](#rt-001) · [RN-001](#rn-001) · [G-001](#g-001) · [TB-001](#tb-001) · [WH-001](#wh-001)
```

**Sem coluna Ref na tabela** — todas as referencias ficam no bloco **Referencias** apos diagrama/tabela.

---

## Regras

| Regra | Detalhe |
|-------|---------|
| Anchor obrigatorio | `<a id="fl-001"></a>` antes do heading |
| Narrativa antes da tabela | Cenario + passo a passo — nunca tabela seca |
| Um FL por jornada critica | login, cadastro, deposito, webhook inbound, job async multi-repo |
| Passos numerados (passo a passo) | Minimo 5 em fluxos multi-repo ou KYC/proxy |
| Setas `→` na tabela | quando ha chamada HTTP entre repos |
| Coluna **Repo** | sempre alias definido no Mapa |
| Coluna **Por que** | minimo 1 frase completa por passo |
| **Referencias** no final | RT/RN/G/TB/INT — nunca no meio do paragrafo narrativo |
| Secoes narrativas FL | `#### Por que` / `#### Cenario` / `#### Pre-condicoes` — **nao** bold solto |
| Diagrama sequencia PNG | obrigatorio para fluxos com 3+ repos ou delegacao externa |
| Anti-telegrafico | Proibido `;` encadeando passos no Cenario |

---

## Validacao

- [ ] Anchor `fl-xxx` presente
- [ ] Secoes "Por que importa", "Cenario", "O que acontece passo a passo", "Pre-condicoes"
- [ ] Cenario ≥ 4 frases OU passo a passo ≥ 5 itens
- [ ] Tabela **sem** coluna Ref
- [ ] Bloco **Referencias** apos tabela/diagrama
- [ ] Nenhum link RT/RN no paragrafo narrativo
- [ ] Diagrama PNG quando aplicavel
- [ ] FL listado no sub-indice do modulo Fluxos
