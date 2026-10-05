# Playbook — Fase 7 Design System

> Execução densa = skill **`design-system-forge`** (roteiro passo a passo, nível essencial/ouro, canvas). Este playbook = só como a **fase 7 do product-from-idea** orquestra o Forge — **não** repete o roteiro.  
> Leis: [`reference-forge-handoff.md`](reference-forge-handoff.md) · barra: [`target-model.md`](target-model.md)  
> Roteiro único: `design-system-forge/roteiro.md` (Partes A marca · B documento · C canvas). A Parte D (telas) é a **Fase 8** (`design-system-apply`).

**Agent:** [`AGENT.md`](AGENT.md)

## Header

```text
**Fase 7 — Design System**
**Objetivo:** criar manual da marca + DS do produto (.docs/) + Fundamentos e componentes no canvas — nível essencial
**ON:** F2 + F5 + F6
**Skill:** design-system-forge
```

## Pré-requisitos

- Setup **fechado** (ou adiado com risco) — superfícies conhecidas (frontend / extension / …)  
- Proto + MVP existem (telas humanas, fluxos)  
- Sem isso → pedir âncoras; não forjar no vazio

## Sequência (Controlador → subagente Forge)

### 0) Diagnóstico + modo (Forge Etapa 0 e GATE 0)

O Forge lista o que existe e o que falta (manual da marca, DS, tokens, canvas, componentes) e escolhe o modo:

| Modo | Quando | Fonte típica |
|------|--------|--------------|
| **Extrair** | Produto já tem telas (site, construtor, código, prints) | URL, código, prints, tokens existentes |
| **Criar** | Produto novo, sem telas | Brief de intenção, proto (`.docs/prototipo.md`), manual da marca se houver |

Mapear **superfícies do produto** a partir de setup + proto (site, extensão popup, overlays…).  
GATE 0 bloqueado → **PARAR** (não inventar DS completo).

### 1) Barra e referências

- Barra da fase = **nível essencial** do Forge (`design-system-forge/nivel-ouro.md`). Ouro só se o cliente pedir no STOP.  
- Canvas padrão = Pencil (`design-system-forge/canvas-ferramentas.md`).  
- Anexos reais para densidade do documento: [`examples/density-reference.md`](examples/density-reference.md) + [`examples/anexos/spacebet-pixreals-DESIGN_SYSTEM.md`](examples/anexos/spacebet-pixreals-DESIGN_SYSTEM.md) (estrutura; **proibido** colar hex). Teoria: Polaris se extensão; Carbon/Atlassian para tokens/papéis.  
- Space `design-system.md` + `ui-gosto.md` = método e gosto — **não** copiar primary do Space para o produto.

### 2) Fluxo (resumo — detalhe no Forge)

```text
Diagnóstico → modo + GATE 0
→ manual da marca (prancha no canvas; logo = designer)
→ DS documento: wizard + GATE Q (Q1–Q19) → template inteiro
→ canvas: variáveis → prancha Fundamentos → componentes (lista por faixa + matriz de estados)
→ GATE ACCEPT + anti-contradição
→ confronto com ui-gosto (geral + tipo do produto)
→ gravar .docs/ + EXTRACTION_NOTES
→ STOP: PASS | PASS COM RESSALVAS | REPROVADO → pergunta se evolui para ouro
```

### 3) Cobertura mínima de superfícies (product-from-idea)

Além do GATE ACCEPT do Forge, garantir que o DS **fala** das superfícies do setup:

| Se o setup tem… | DS deve cobrir (lei ou P-…) |
|-----------------|------------------------------|
| `frontend` | Chrome web, páginas, overlays/sheets do proto |
| `extension` | UI da extensão (popup/sidepanel), densidade, contraste; **não** confundir com página Next |
| Auth compartilhada | Padrão de login/sheet coerente entre canais |
| Estados de busca / progresso | Loading / empty / error (alinhado ao proto) |

Detalhe de selos/scores de domínio → `P-…` de produto (não inventar nome sem eco).

**Decisões de gosto que não podem esperar a Fase 8** (no piloto, as duas apareceram só nas telas e geraram versões novas do DS):

| Decisão | Como levar ao cliente |
|---------|-----------------------|
| Texto do botão principal sobre a cor da marca (claro × escuro) | Comparação lado a lado no canvas, contraste medido de cada opção (mínimo 4,5 : 1); se nenhuma passa, propor um tom da cor da marca para o botão |
| Peso do rótulo dos botões (semi-negrito × negrito) | Mesma comparação, num botão real do produto |
| Cor da peça de domínio “melhor” (selo, nota, destaque) | Usar a cor da marca para o que é bom; vermelho/alerta só para o que é ruim |

**Inspeção do canvas sem pressa:** ao listar ou auditar componentes, abrir **todos** os quadros (inclusive o segundo tema) e contar as peças; amostra de um quadro não vale como “olhei tudo”.

### 3.1) Perguntas que evitam retrabalho (fazer cedo)

- O logo escolhido é **final** ou haverá designer? (não assumir “conceito”).
- O projeto terá **tema claro**? Em quais superfícies? (sem tema claro → claro só como reserva).
- Situações e tipos do produto conferidos com o cliente antes de desenhar selos (ver Fase 3, 2.3).

### 4) Gate de fase (produto)

No chat (Controlador):

| Resultado | Significado |
|-----------|-------------|
| **fechado** | PASS (ou PASS COM RESSALVAS com Qs humanas fechadas / risco explícito) |
| **adiado com risco** | Cliente assume buracos listados |
| **bloqueado** | REPROVADO / fonte insuficiente / Qs abertas críticas |

Atualizar `.docs/README.md` status. Subagente **encerra**.

### 5) O que NÃO fazer depois do STOP

- Não rodar `design-system-apply` nesta fase — ele é a Fase 8 (Telas), em subagente novo  
- Não abrir a Fase 8 (Telas) na mesma thread  
- Não “passar” omitindo ressalvas  
- Não apagar pranchas/componentes do canvas (versões antigas vão para área de rascunho)

## Fora de escopo (apontar)

| Pedido | Para |
|--------|------|
| “Aplica o DS nas telas” / “cria a Home” (canvas, construtor ou código) | Fase 8 · `design-system-apply` |
| “Audita o staging” | `qa-space` |
| “Cria o repo” | Setup / DEV |
| “DBML / task” | Fase 11 · `po-techlead-scrum` |
