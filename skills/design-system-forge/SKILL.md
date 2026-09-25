---
name: design-system-forge
description: >-
  Compõe um Design System de produto a partir de fonte visual (URL, Lovable, prints,
  código, brief): observar, interpretar intenção, questionar o humano, definir padrões
  pretendidos (não inventariar o mock), normalizar com Space DS + Laws of UX, gerar
  DESIGN_SYSTEM.md + tokens DTCG + EXTRACTION_NOTES sob `.docs/`. Gates: fonte insuficiente
  = PARAR; Q1–Q10 abertas = NÃO gravar DS final. Para na aprovação humana. NÃO aplica no
  produto (use design-system-apply). Use com /design-system-forge, "forjar DS", "extrair
  design system", "criar padrões P-".
disable-model-invocation: true
---

# Design System Forge

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/design-system-forge/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

**Trigger:** `/design-system-forge`  
**Idioma:** português.  
**Par:** Apply / IKEA = skill `design-system-apply` — **Fase A** limpa o DS vs [`../docs/ui-gosto.md`](../docs/ui-gosto.md); **Fase B** aplica no front. Forge **não** aplica gosto SpaceBET no lugar da marca.

## Conteúdo genérico

Serve **qualquer produto**. Sem ID/URL/default de cliente nas regras. Hub: `/skill-update`.

## Onde gravar artefatos (`.docs/`)

**Toda documentação desta skill fica em `.docs/`** — sem exceção.

| Situação | O que fazer |
|----------|-------------|
| Workspace **fora** de um git repo | Criar `.docs/` e gravar ali |
| Workspace **dentro** de um git repo | Idem **e** garantir **`.docs/`** no **`.gitignore`** — **adicionar se faltar** |

| Artefato | Path |
|----------|------|
| DS do produto | `.docs/DESIGN_SYSTEM.md` |
| Tokens | `.docs/tokens.dtcg.json` |
| Notes | `.docs/design-system-forge/EXTRACTION_NOTES.md` |

Proibido: DS/notes na raiz, em `.task/` como verdade, ou fora de `.docs/`.  
Screenshots auxiliares em `.task/` só se o humano pedir mídia — a verdade continua em `.docs/`.

## Constituição (obrigatório)

1. Ler **[`../docs/README.md`](../docs/README.md)** — seção `design-system-forge`.  
2. Ler **[`../docs/design-system.md`](../docs/design-system.md)** **inteiro** como **método/gosto** (não copiar tokens do Space como se fossem do produto).  
3. Laws of UX: https://lawsofux.com/llms.txt (abrir; não resumir de memória).

| Arquivo da skill | Quando |
|------------------|--------|
| [template-design-system.md](template-design-system.md) | Wireframe a copiar/preencher no produto |
| [reference-ux-psychology.md](reference-ux-psychology.md) | Mapear leis → decisões do DS |

**Não** resumir o Space DS neste `SKILL.md`. Specs concretas vivem **só** no `.docs/DESIGN_SYSTEM.md` do produto.

## Princípio #1 — Padrões

> **O que não tem padrão está errado *ou* o padrão ainda precisa ser definido.**  
> A fonte visual **não é constituição**. Inventariar mock/Lovable como lei = DS fotografia do erro.

Forge = **interpretar intenção + questionar + definir o padrão pretendido**. Fora-do-padrão → Apêndice (rejeitado / dívida), **não** catálogo.

| Camada | Conteúdo |
|--------|----------|
| **Skill** (genérica) | Método + gates + Q obrigatórias → IDs `P-…` → DS em `.docs/` |
| **DESIGN_SYSTEM.md do produto** | Specs concretas — **não** hardcodar na skill |

## Papel

1. `.docs/DESIGN_SYSTEM.md` (tokens + componentes + **catálogo de padrões**)  
2. `.docs/tokens.dtcg.json`  
3. `.docs/design-system-forge/EXTRACTION_NOTES.md` (GATE 0 + Q1–Q10 + fonte vs decidido)  
4. Apêndice: extraído → normalizado → rejeitado  

**Não faz:** corrigir produto / Lovable · QA de aceite · Apply · ClickUp · sync do pack.

## Fontes (multi)

URL publicada · Lovable · prints/Figma · código local · doc de gosto (Space DS) · brief.  
Segmento-agnóstico: B2B admin, B2C, marketing, híbrido.

---

## GATE 0 — Fonte suficiente (antes de interpretar)

Se falhar → **PARAR**. Não inventar DS “completo” com evidência fraca.

| Nível | Critério | Pode gerar DS? |
|-------|----------|----------------|
| **F** | Só brief / 1 print / 1 tela sem código | **Não** — pedir mais fonte |
| **D** | URL/Lovable sem mobile e sem tokens/código | Rascunho parcial **só** se o humano autorizar |
| **C** | Desktop + mobile **ou** desktop + CSS/tokens | Sim, com Q abertas fechadas depois |
| **B** | Desktop + mobile + código/tokens + ≥3 superfícies | Sim |
| **A** | B + Space DS + brief de intenção | Sim (melhor caso) |

**Superfície distinta** = lista/home + 1 fluxo crítico + 1 overlay — ou equivalente no segmento.

### PARAR e pedir

- Sem URL **e** sem Lovable **e** sem prints **e** sem path de código  
- Sem cor/token mensurável **e** humano não define Primary/Surface  
- Fonte errada para o job (ex.: só marketing estático para app/dashboard)  
- Bloqueio de acesso (auth, link morto, MCP) → reportar, não inventar  

Ao parar: (1) o que falta (2) o que já dá para ver (3) **não** entregar DS completo.  
Pode gravar só notes com `FONTE_INSUFICIENTE`.

---

## Wizard (contexto)

1. Fonte(s)  
2. Path do Space DS / gosto (default constituição após sync)  
3. Contexto: B2B | B2C | híbrido  
4. Path de saída (default sob `.docs/`)  
5. Incluir mobile? (se não → documentar risco)  
6. Rigor P2/P3 na dívida?

Primary/Surface → **GATE Q**, não opcional do wizard.

## Loop cognitivo

```text
0. GATE 0 — fonte suficiente? Senão PARAR
1. Visualizar (desktop + mobile quando o gate exigir)
2. Repetição vs ruído / exceção / bug visual
3. Hipótese de padrão (Space DS + Laws = método, não cópia)
4. GATE Q — checklist; sem resposta = NÃO gravar DS final
5. Padrão pretendido → lei; fora → Apêndice rejeitado
6. Gerar sob .docs/ + EXTRACTION_NOTES com Q
7. PARAR — aprovação humana
8. Só então: `design-system-apply` (limpa DS pelo gosto → front) / knowledge / etc.
```

---

## GATE Q — Perguntas obrigatórias

Cada item: **humano** **ou** **inferido** com evidência (token/código / repetição ≥3×) e confiança alta.  
Ambíguo → perguntar. Checklist incompleto → **proibido** `DESIGN_SYSTEM.md` / tokens “finais”.

| ID | Pergunta | Status | Resposta / evidência |
|----|----------|--------|----------------------|
| Q1 | … | humano \| inferido \| **ABERTO** | … |

| ID | Pergunta |
|----|----------|
| **Q1** | Primary único (hex/token)? Accent secundário ou ruído? |
| **Q2** | Surfaces (bg / card / surface-2…) e regra de empilhar? |
| **Q3** | Tipografia: famílias + hierarquia mínima? |
| **Q4** | Radius + espaçamento base? |
| **Q5** | Chrome **mobile:** 1 CTA Primary onde? Outline/ghost? |
| **Q6** | Chrome **desktop:** o que muda vs mobile? |
| **Q7** | Feedback (sucesso / erro / live / disabled)? |
| **Q8** | O que na fonte é acidente / dívida vs lei? |
| **Q9** | Segmento/tom e implicação no DS? |
| **Q10** | Escopo v1: o que entra vs fora de escopo? |

### Inferência

- Inferir só com token/código **ou** ≥3 repetições alinhadas ao gosto.  
- Perguntar se 1×, conflito entre telas, ou Primary/CTA ambíguo.  
- Nunca inventar Primary/Surface se código/humano já definiu.  
- **ABERTO** → não promover a lei (hipótese só no notes).

---

## EXTRACTION_NOTES — blocos obrigatórios

1. Fonte + nível GATE 0 (F–A)  
2. Tabela Q1–Q10  
3. Fonte vs decidido/questionado  
4. Rejeitado / dívida  

## Prioridade de verdade

1. Decisões humanas / escopo  
2. Código/tokens do produto  
3. Space DS + Laws of UX (método)  
4. Mock/fonte visual (hierarquia/campos — não neon/ruído como lei)

## O que NÃO fazer

- Inventário Lovable = DS final  
- DS “completo” com GATE 0 insuficiente ou Q abertas  
- “Tudo que vi” sem hipótese + pergunta quando ambíguo  
- Corrigir o produto (isso é `design-system-apply`)  
- Hardcodar cliente na skill  
- Resumir Laws of UX de memória  
- Pular mobile sem documentar risco  
