---
name: design-system-apply
description: >-
  Aplica o Design System já aprovado (criado pelo design-system-forge) nas telas do produto.
  Diagnostica onde as telas estão (site/código, construtor, canvas) e o que usa só peças
  oficiais. Fase A confronta o DS com ui-gosto (geral + tipo) e PARA para OK. Fase B varre
  as telas cabo a rabo (browser no site, prints via MCP no canvas), recria no canvas as telas
  que só existem no site/construtor e entrega relatório — PARA para OK. Fase C corrige e
  redesenha as telas no canvas (Pencil por padrão) usando só peças oficiais, em loop com
  re-Scan cego, até ALIGNED com OK humano + lista de diferenças para os devs. Construtor de
  app (ex.: Lovable) = alvo secundário para projetos antigos. Use com /design-system-apply,
  "IKEA", "aplicar DS", "limpar gosto", "aplicar nas telas".
disable-model-invocation: true
---

# Design System Apply / IKEA

> **No fluxo `product-from-idea`:** onde esta skill cita `.docs/`, ler `docs/` (a pasta de documentos do workspace de produto é visível e versionada desde 2026-10-06). Em repositórios de código, `.docs/` continua valendo.

> ⚠️ **COPIA:** destino = `SKILLS_DEST_PATH` do `.env` **desta maquina** (PC ≠ Coders).  
> **Altere em** `space-cursor-skills/skills/design-system-apply/` → **obrigatorio rodar** `npm run sync` na raiz (maquina alvo). Sem Sync a copia nao atualiza.  
> Ver `00-COPIA-LEIA-ME.md`. Hub pack: **`/skill-update`**. Fluxo repo: **`AGENTS.md`**.

**Trigger:** `/design-system-apply` · “IKEA” · “aplicar DS” · “limpar gosto” · “aplicar nas telas”  
**Idioma:** português.  
**Par:** `design-system-forge` **cria** a base (manual, DS escrito, variáveis, Fundamentos, componentes no canvas). Esta skill **confronta**, **varre** e **corrige telas**.

## Conteúdo genérico

Serve **qualquer produto**. Sem ID/URL/default de cliente. Hub: `/skill-update`.

## Onde gravar artefatos

| Situação | O que fazer |
|----------|-------------|
| Fora de git repo | Criar `.docs/` e gravar |
| Dentro de git repo | Idem + `.docs/` no **`.gitignore`** se faltar |

| Artefato | Path |
|----------|------|
| DS (Fase A / mini-A edita) | `.docs/DESIGN_SYSTEM.md` |
| Notes | `.docs/design-system-forge/EXTRACTION_NOTES.md` |
| Relatório Fase B / re-Scan | `.docs/design-system-forge/QA_REPORTS/YYYY-MM-DD-<slug>[-rN].md` |
| Diferenças para os devs (código/construtor ≠ canvas) | `.docs/design-system-forge/DIFERENCAS_PARA_DEVS.md` |
| Telas | Arquivo de canvas do produto (área “Telas” oficial + “Rascunho · espelho …”) |

Nunca sobrescrever relatório — sempre `…-rN.md`.

## Constituição (obrigatório)

1. [`../docs/README.md`](../docs/README.md) — seção `design-system-apply`  
2. `.docs/DESIGN_SYSTEM.md` do produto  
3. [`../docs/ui-gosto.md`](../docs/ui-gosto.md): parte geral **inteira** + seção do tipo do produto em §11  
4. [`../docs/design-system.md`](../docs/design-system.md) — apoio; **marca do produto manda**  
5. [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md) · [report-template.md](report-template.md) · [reference-anti-slop.md](reference-anti-slop.md)  
6. Conexão com o canvas: [`../design-system-forge/canvas-ferramentas.md`](../design-system-forge/canvas-ferramentas.md)

**Não** é `qa-space`. Visual only.

---

## Método de execução

Segue [`../docs/metodo-agentes.md`](../docs/metodo-agentes.md): Controlador + subagente por etapa · Pronto quando + exemplo real · revisor sem contexto · toda correção → lista de correções → `/skill-update` (registro em [`CORRECOES.md`](CORRECOES.md)). Exemplos: [`exemplos/README.md`](exemplos/README.md).

**Âncora:** ao ser chamada, criar ou atualizar `.docs/design-system-apply/ANCORA.md` (modelo em `../docs/metodo-agentes.md` §5) — aponta para este `SKILL.md`, etapa atual e próximo passo; nunca copia as regras. Reler a âncora e este arquivo no começo de cada etapa. Não escrever no `AGENTS.md` do repositório.

| Etapa | Subagente | Entrega | Pronto quando | Exemplo real | Quem aprova |
|-------|-----------|---------|---------------|--------------|-------------|
| 0 — Diagnóstico das telas | Sim | Tabela no chat e no relatório | Cada tela/estado com onde existe e se usa só peças oficiais; superfícies e tamanhos que o produto tem confirmados | — | Humano vê |
| A — DS × gosto | Sim — **revisor sem contexto** | DS + `EXTRACTION_NOTES` atualizados | Parte geral + tipo do produto, uma linha por item | — | Humano (OK A) |
| B — Varredura + espelho | Sim — um por tela ou grupo de telas (em paralelo) | `QA_REPORTS/…` + espelhos no Rascunho | Todo alvo do inventário aberto nesta sessão, com print; overlays clicados; não coberto listado | [`exemplos/relatorio-real-buscai-home-sem-login-r1.md`](exemplos/relatorio-real-buscai-home-sem-login-r1.md) | Humano (OK B) |
| C — Correção no canvas | Sim — um por tela | Tela corrigida + relatório `…-rN` | Só peças oficiais + variáveis; cópia com data do canvas antes e depois; arquivo conferido no disco | [`exemplos/relatorio-real-buscai-home-sem-login-r2.md`](exemplos/relatorio-real-buscai-home-sem-login-r2.md) | Humano |
| C2 — Re-conferência cega | Sim — **subagente novo, sem a lista de correções** | Novo relatório `…-rN` | Prints desta sessão de cada tela tocada; achados anteriores tratados como FAIL até prova | — | Controlador |
| ALIGNED | Não — Controlador | `DIFERENCAS_PARA_DEVS.md` (se houver código) | Pré-flight + conferência cruzada + OK humano explícito | Falta exemplo real (`DIFERENCAS_PARA_DEVS`) | Humano |

**Revisor sem contexto:** a Fase A e a re-conferência cega rodam em subagente novo que não viu a correção nem a conversa — recebe só o DS, o gosto, os prints e o relatório anterior **depois** de fazer a própria varredura (VISUAL_QA_METHOD: cego → cruzar).

---

## Alvos de correção (Fase C)

| Alvo | Quando | Como corrige | Saída extra |
|------|--------|--------------|-------------|
| **Canvas** (padrão) | Sempre que o produto tem canvas (Pencil ou outra ferramenta conectada) | Edita / redesenha as telas oficiais no canvas, só com peças oficiais | — |
| **Código** (site, app, extensão) | Projeto com telas em código | **Não** edita código. Corrige no canvas (telas recriadas na Fase B) | `DIFERENCAS_PARA_DEVS.md` |
| **Construtor de app** (secundário) | Projeto antigo cujas telas vivem num construtor com IA, **e** o humano escolhe corrigir lá | Edição completa pelo construtor (mensagem fechada, sem “resto igual”) | Se também houver canvas: manter canvas e construtor iguais |

Sem canvas conectado e sem escolha de construtor → Fase C **bloqueada** (reportar; ver `canvas-ferramentas.md`).

---

## As três fases (travado)

```text
Forge → base aprovada (DS + componentes no canvas)
        ↓
Etapa 0 — Diagnóstico das telas (tem × falta)
        ↓
┌──────────────────────────────────────────────┐
│ FASE A — DS × gosto (documento)              │
│ PARAR → humano valida                        │
└──────────────────────────────────────────────┘
        ↓ OK A
┌──────────────────────────────────────────────┐
│ FASE B — Scan cabo a rabo                    │
│ site/construtor (browser) + canvas (prints)  │
│ Espelho no canvas das telas que faltam       │
│ Relatório de gaps / anti-padrões             │
│ PARAR → humano valida (faltou algo?)         │
└──────────────────────────────────────────────┘
        ↓ OK B (autoriza Fix)
┌──────────────────────────────────────────────┐
│ FASE C — Fix no canvas + loop                │
│ Tela-prova → demais telas → estados          │
│ Fix → re-Scan cego → relatório …-rN          │
│ Se DS mudar → mini-A + OK                    │
│ até ALIGNED + DIFERENCAS_PARA_DEVS           │
└──────────────────────────────────────────────┘
```

### Regras de autorização (obrigatório)

| Transição | Permitido? |
|-----------|------------|
| A → **PARAR** humano | **Sim** — sempre |
| A → B | Só com **OK explícito** do humano na Fase A |
| A → C (Fix) | **PROIBIDO** |
| B → **PARAR** humano | **Sim** — sempre (humano confere se faltou algo no Scan) |
| B → C | Só com **OK explícito** liberando Fix |
| C sem A e B aprovados nesta Apply | **PROIBIDO** |

Frases do humano que **não** pulam B: “aplica”, “pode seguir”, “IKEA” — se ainda não houve OK na A, fazer A; se A ok e B não, fazer B e parar.  
Só “OK A” / “Fase A aprovada” libera B.  
Só “OK B” / “pode Fix” / “autorizo C” libera C.

Se o humano disser de uma vez **“Aprova A e B; pode C / aplica até ALIGNED”** → encadear, mas **ainda executar B completo com relatório** antes do primeiro Fix (não inventar Scan).

---

## Gate inicial

1. Existe `.docs/DESIGN_SYSTEM.md` com `P-…`, lista fechada de componentes e matriz de estados (senão → Forge).  
2. Existe canvas com variáveis e componentes oficiais (senão → Forge, Parte C) — **exceto** se o alvo escolhido for o construtor.  
3. Humano pediu Apply / IKEA / aplicar nas telas.

## Etapa 0 — Diagnóstico das telas

Tabela no chat **e** no relatório da Fase B:

| Tela / estado | Onde existe (site/código · construtor · canvas) | No canvas usa só peças oficiais? | Observação |
|---------------|-------------------------------------------------|----------------------------------|------------|
| | | | |

Mais: tipo de produto (ui-gosto §11), alvo de correção (canvas | construtor), superfícies e tamanhos reais **que o produto tem** (computador, celular, popup…). Superfície que o humano disse que não existe (ex.: “só computador por enquanto”) não entra. Dúvida → perguntar.

---

## FASE A — Confrontar o DS com o gosto

**Só documento.** URL não obrigatória.

1. Ler DS + `ui-gosto.md` (geral + seção do tipo).  
2. Diff tokens / `P-…` / anti-padrões vs gosto. Seções de outros tipos → “não se aplica” com motivo.  
3. Editar `.docs/DESIGN_SYSTEM.md` (nova versão):
   - Fora do gosto → Apêndice rejeitado (salvo **exceção humana** já confirmada — não reverter)  
   - Reforçar DO (Primary da marca na ação real, tipos não se misturam, …)  
4. Bloco em `EXTRACTION_NOTES`: **“Confronto com o gosto (Apply Fase A)”**.  
5. **PARAR.** Resumo do diff + pedir **OK A**.  
6. Sem OK A → **não** iniciar B nem C.

**Marca > gosto > mock.** Não inventar Primary da marca.

---

## FASE B — Scan + espelho no canvas + relatório

**Só depois do OK A.** Sem Fix nas telas oficiais.

Método: [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md). Template: [report-template.md](report-template.md).

### Princípio

> **Régua = DS + gosto. Crime = tela (site, construtor ou canvas).**  
> Se existir **review humano** no workspace/chat → checklist obrigatória (VISUAL_QA_METHOD §1.1).  
> DS sozinho **não** detecta espaço vazio, poço, overflow, CTA morto, layout quebrado.

### Obrigatório

0. **Review humano** — se houver `observacoes.md` / prints / clip / bullets no chat: ler inteiro; virar tabela PASS/FAIL no relatório.  
1. **Inventário de alvos** — VISUAL_QA_METHOD §3.0:  
   - bases/URLs/rotas/estados de sessão (site/construtor) **e** telas/pranchas do canvas  
   - **popups/overlays** (modal, sheet, drawer, dialog, toast bloqueante, welcome, confirm…) — descobrir por código + gatilhos de UI + pranchas  
   Listar tudo; scaneado vs Não coberto; dúvida → perguntar.  
2. Abrir cada alvo **nesta sessão**: site/construtor no browser; canvas por **print via MCP** de cada tela. **Proibido** inventar Scan.  
3. Cada superfície do diagnóstico (computador e celular quando o produto tiver as duas). Admin/B2B: **~1300×800**. Canvas: tamanho real da superfície.  
4. Roteiro completo (dobra → scroll footer → **cada overlay** → shell → estados → CDP no site). **Clicar** affordances no site — presença no DOM ≠ PASS.  
5. Caçar: vazio, quebrado, cortado, hit morto — **e voids intra-card** (VISUAL_QA_METHOD §3.3).  
6. **Espelho no canvas** (projeto de código ou construtor): **toda** tela do inventário que não existe no canvas é recriada numa área **“Rascunho · espelho do site”**, copiando estrutura e conteúdo como estão (evidência do “antes”). Marcar onde não há peça oficial equivalente. O espelho **não** é tela oficial e **não** é apagado depois.  
   - Overlay: copiar o que o usuário vê a partir da tela (modal/gaveta), não a rota aberta direto; medidas do código, não do print (VISUAL_QA_METHOD §3.0b).  
   - Cada tela espelhada ou montada vai para o relatório como imagem combinada **real × canvas**.  
7. Relatório **inteiro** (diagnóstico + review humano × tela + prints/círculos do chat + inventário de alvos + inventário de overlays + telas espelhadas + P0/P1/P2 + não coberto).  
8. **PARAR.** Path do relatório + resumo. Pedir **OK B**.  
9. Sem OK B → **não** iniciar C.

**Scan inválido:** código-only; só home sem inventário; só auth/pagamento “óbvios” ignorando outros overlays; template com `…`; omitir rotas / logado / popup sem registrar em Não coberto; PASS em ⋯/menu sem click; canvas “scaneado” sem print desta sessão; tela do inventário sem espelho e sem motivo; ALIGNED com review humano ALTA em FAIL; **PASS “espaços vazios” só medindo vão entre seções**; **ignorar print/círculo do humano**.

---

## FASE C — Fix no canvas + loop até ALIGNED

**Só depois do OK B** (autorização de Fix).

### Ordem das telas (validação com telas)

1. **Tela-prova:** a tela mais importante (normalmente a Home) montada/ajustada **só** com componentes oficiais, no tema principal, em cada superfície do diagnóstico. Ela revela buracos do DS (margem real, ponto de quebra, peça que não existia).  
2. **Demais telas e estados:** telas restantes, estados de tela (vazio, carregando, erro, falha parcial, sem permissão/saldo, sem resultado), janelas e cada superfície no tamanho real.  
3. **Conferência cruzada:** comparar medidas entre telas do mesmo tipo e fechar um valor único no DS (mesma coisa, mesma medida).

### Como corrigir

- **Canvas (padrão):** ajustar a tela oficial; **redesenhar** quando a estrutura não tiver conserto (espelho fica no Rascunho). Só instâncias de componentes oficiais e variáveis — nada de cor digitada, peça solta ou componente novo sem lei.  
- **Peça que já existe no Draft:** promover (mover para a seção existente dos essenciais, com a matriz), nunca recriar — roteiro do Forge, passo 23.  
- **Trocar o componente de uma instância:** substituir o nó por instância do outro componente, mesmo tamanho; peça antiga só sai depois de zero instância apontando para ela.  
- **Mídia nas telas:** posição de banner, capa ou arte = instância da amostra de proporção com a medida do lugar, não imagem de exemplo (roteiro do Forge, passo 18.1).  
- **Telas irmãs:** mesma medida para a mesma coisa (overlays irmãos com a mesma altura e a mesma proporção de mídia).  
- **Organização:** telas oficiais em fileiras por fluxo com rótulo “Seção · …”; referências do site (navegador, capturas) separadas e removidas depois da validação humana.  
- **Peça faltando / regra faltando:** **mini-A** — acrescentar no DS (lista fechada + matriz de estados + versão) **e** criar o componente no canvas seguindo o roteiro do Forge (passos 12, 13 e 18) → **PARAR OK** → continuar. Nunca “remendo só na tela”.  
- **Arquivo do canvas protegido:** cópia com data numa pasta `copias/` ao lado do arquivo **antes e depois** de cada rodada; um só editor aberto com o arquivo (duas janelas podem gravar a versão antiga por cima); depois de cada edição, conferir que o arquivo mudou no disco — se não mudou, parar e avisar. Os prints “depois” de cada rodada são o que permite refazer uma tela aprovada.  
- **Dados de exemplo são mockup:** produto, preço, nota, data e foto de exemplo não se conferem entre telas. Placeholder explícito (“X”, “Lorem”) é achado → valor fictício plausível, aprovado pelo humano uma vez e igual em todas as telas.  
- **Texto de tela para o público:** o texto que o usuário lê passa no teste do leigo (palavra de especialista como “ranking” ou “match” é achado P1).  
- **Perguntar só o necessário:** o que o DS já responde (peso, medida, variável, peça solta, contraste) se corrige e se informa no relatório; ao humano vai só decisão de produto ou de gosto sem regra, em bloco, com opções e recomendação.  
- **Decisão de produto revelada pela tela** (bloco, estado ou dado novo aprovado pelo humano): registrar também na fonte de produto do projeto (protótipo, especificação), não só no relatório.  
- **Construtor (secundário):** edição completa pelo construtor; sem `// ...` / “resto igual”.  
- **Código:** não editar. Cada diferença entre a tela em código e a tela alinhada no canvas vai para `DIFERENCAS_PARA_DEVS.md` — inclusive melhorias que o canvas trouxe e o código ainda não tem (ex.: marca oficial de terceiro no botão social, overlays irmãos com a mesma altura, arte a reexportar em outra proporção).

### Ciclo do loop

```text
C1. Fix (prioridade impacto) — edição completa no alvo (canvas padrão)
C2. Re-Scan **cego** (T1) → cruzamento (T2) → GATE SCAN + novo …-rN.md
    — canvas: prints desta sessão de cada tela tocada + telas do review humano
    — NÃO ler lista de fixes / relatório anterior durante T1
    — Assumir que TODOS os pontos negativos do review ainda são FAIL até prova
C3. Se o re-Scan exigir mudança de lei no DS → mini-A + PARAR OK humano → depois continua
C4. Pre-flight anti-slop + conferência cruzada → **ALIGNED candidato** (VISUAL_QA_METHOD §5.0) ou voltar a C1
C5. Atualizar DIFERENCAS_PARA_DEVS.md (projeto de código/construtor)
C6. ALIGNED **final** só com OK humano explícito — nunca só porque o pré-flight interno passou
```

No loop C, o humano **já** autorizou Fix; novos relatórios `…-rN` são entregues a cada volta.  
Se surgir **mudança de DS** (mini-A), **PARAR** de novo para OK antes do próximo Fix.  
Se o humano pedir “para o loop”, parar.  
Se o review humano ALTA ainda tiver FAIL → **proibido** escrever ALIGNED (mesmo candidato).

### Critério de ALIGNED

- Telas oficiais do canvas alinhadas ao DS + gosto (checklist §5.0 do método).  
- Projeto de código ou construtor: `DIFERENCAS_PARA_DEVS.md` completo (tela, rota/arquivo, como está, como deve ficar com referência à tela do canvas, peça/token, prioridade).  
- OK humano explícito.

### Prioridade de Fix

1. Cor / Primary na ação real  
2. Hover/focus / contraste / par CTA  
3. Layout / nested / spacing / vazio estrutural (**intra-card primeiro**: AP-GRID-HOLE, AP-CTA-SPREAD, AP-META-BASELINE)  
4. Cara de IA / componentes fora do oficial  
5. Empty / loading / error / skeleton  

### Imparcialidade no re-Scan (cego → cruzar)

Detalhe: [VISUAL_QA_METHOD.md](VISUAL_QA_METHOD.md) § Imparcialidade.

| Tempo | O quê |
|-------|--------|
| **T1 cego** | Checklist **negativa** completa (`observacoes` ALTA/MÉDIA + APs + crimes do B). Caçar na tela **como se tudo ainda falhasse**. **Proibido** abrir relatório anterior / notas de Fix / diff / “já corrigimos X”. |
| **T2 cruzamento** | Só **depois** de T1 escrito: comparar com rodada anterior (sanado / ainda FAIL / regrediu / novo). |

**Proibido:** re-Scan que “valida o patch”; PASS porque o arquivo mudou; pular item porque o rN anterior já tinha PASS.

### Regras do tipo de produto

Regras que só valem para um tipo (ex.: prova social global × contextual em cassino — ui-gosto §11.1.5; tabela/badge em admin — §11.2) vêm do **gosto**, não desta skill. Aplicar só a seção do tipo do produto.

---

## Pós-ALIGNED / pedido que muda pattern

ALIGNED **não** é licença para edição livre. Se o humano pedir mudança que:

- recoloca componente removido no Fix,
- cria superfície nova (faixa, CTA, chrome, peça de domínio),
- altera interpretação de `P-…` / gosto,

então:

1. **Mini-A** — editar `.docs/DESIGN_SYSTEM.md` (novo `P-…` ou exceção nomeada) + componente no canvas se for peça nova + bloco em EXTRACTION_NOTES  
2. **PARAR** → OK humano no diff do DS — **exceto** se a mesma mensagem já disser “atualiza o DS e aplica” / “mini-A ok, pode Fix”  
3. Fix + re-Scan `…-rN` — o ALIGNED anterior **quebra** até novo pre-flight PASS  

“Pode continuar” / “faz aí” **sem** nomear mudança de lei → ainda assim mini-A se o pedido conflitar com o gosto ou com um FAIL que o Apply sanou.

---

## Checklist rápido (achados)

**P0:** touch/CTA morto; texto cortado; lazy sem skeleton; poço/quebrado bloqueante; **AP-META-BASELINE / AP-CTA-SPREAD em form crítico**; tela maior que a superfície  
**P1:** `P-…` violado; Primary fora da ação real; nested; AI tell; spacing; par CTA; peça fora do oficial; **AP-GRID-HOLE**  
**P2:** logos; densidades; chrome duplicado; medidas diferentes entre telas do mesmo tipo  

**Fora de escopo:** badge/watermark do host do construtor — anotar, não corrigir.

## O que NÃO fazer

- Criar o DS do zero (Forge)  
- **Pular B** e ir de A para C  
- **Fix sem OK B**  
- Scan incompleto ou relatório pela metade  
- **Inventar Scan** / ALIGNED sem abrir as telas (browser ou print do canvas) nesta sessão  
- Editar código do produto (projeto de código → canvas + `DIFERENCAS_PARA_DEVS.md`)  
- Usar peça, cor ou medida fora do oficial nas telas oficiais; criar componente sem mini-A  
- Apagar o espelho, telas antigas ou opções (vão para o Rascunho)  
- Ignorar `observacoes.md` / review humano / prints quando existirem  
- Marcar ⋯ / menu / CTA como PASS sem clicar (affordance morta)  
- Declarar **ALIGNED** com itens ALTA do review humano ainda FAIL, ou com rotas do review em “Não coberto”  
- Declarar ALIGNED final só com pré-flight interno (falta OK humano §5.0)  
- Abrir **só** a home e ignorar outras rotas/telas **sem** inventário + Não coberto  
- Inventariar só overlays “óbvios” e **calar** welcome / confirm / busca / notificações / componentes órfãos  
- “Diagnose” só pelo DS/código  
- **Marcar “espaços vazios” PASS** só com gap entre seções (sem caça §3.3 intra-card)  
- **Ignorar círculo/print** do humano no chat  
- **Re-Scan manipulado**: ler Fix/relatório anterior **antes** de caçar; “validar o patch”; pular ALTA porque o rN anterior já era PASS  
- Reverter exceção humana sem perguntar  
- Aplicar regra de um tipo de produto em outro (ui-gosto §11)  
- Edição pós-ALIGNED que muda pattern **sem** mini-A / OK  
- Fundir com `qa-space` / AP-FE  
- Output incompleto / placeholders
