# Passo a passo — da ideia à tarefa

> Mapa oficial das fases do fluxo **product-from-idea**.  
> Cada fase tem módulo em `modules/NN-*/` (`AGENT.md` · `playbook.md` · `target-model.md` · `examples/anexos/` reais).

**Linha de corte:** agente + cliente definem **tudo** até a **tarefa no ClickUp** pronta.  
**Código:** responsabilidade dos **devs** (fora deste fluxo).

Base: academia (discovery → MVP → contract-first) + operação Space (Apidog, Design System, boilerplates **na spec**, ClickUp).

---

## Metodologia (em uma frase)

**Problema validado → pesquisa de alternativas → solução em papel → MVP → contrato → setup → Design System → telas aprovadas → protótipo navegável → revisão → manual comercial → tarefas → devs.**

---

## Fases (nosso escopo)

```text
0.  Posicionamento / mapa
1.  Discovery (problema + usuário)          → docs/discovery.md
2.  Pesquisa de mercado (alternativas)      → docs/pesquisa-mercado.md
3.  Solução em papel (protótipo)            → docs/prototipo.md
4.  Escopo do MVP + fora de escopo          → docs/mvp.md
5.  Arquitetura mínima + contrato           → docs/contrato.md
6.  Setup especificado                      → docs/setup.md
7.  Design System (marca + DS + canvas)     → docs/DESIGN_SYSTEM.md
8.  Telas (uma por vez, aprovadas)          → docs/telas.md + canvas
8.5 Protótipo navegável (para apresentar)  → prototipo/ (fora do docs/) + seção em docs/telas.md
9.  Revisão (Revisor)                       → docs/revisao.md
10. Manual comercial                        → docs/{slug}.md
11. Tarefas por fatia                       → docs/tarefas.md + .task/  ← FIM
+   Brief interno (vago)                    → docs/produto.md (NÃO é o manual)
```

**Tamanho:** um arquivo **por** fase, enxuto, nas fases 1–9 e 11.  
**Exceção Fase 10:** manual comercial **completo** (história + tudo) — tom comercial; não é cópia crua dos documentos.  
`produto.md` = brief interno curto.

### Depois do nosso corte (devs)

```text
·  Implementação back + front + extensão
·  Homologação e prova de pronto pelos devs
·  Lançamento + aprendizado
·  Memória do produto (project-context-doc) — opcional
```

---

## Leis de todas as fases

- **Gate humano** em cada fase (fechado · adiado com risco · bloqueado). Sem gate, não avança.  
- **Chat ≠ verdade:** o que não está em `docs/` não está fechado.  
- **Foco por etapa:** só o que serve o objetivo da fase atual; assunto de outra fase = 1 linha “fica na fase X”.  
- **Limpar contexto a cada passo:** gate fechado → **subagente novo** + handoff (`docs/` = ônibus). O subagente da fase **encerra**.  
- **Arquitetura:** Controlador no chat principal; um subagente por fase.  
- **Clareza:** todo documento passa no teste do leigo (`shared/docs-clarity.md`, CL0–CL5).  
- **Anti-pressa:** ler o arquivo inteiro antes de gravar; nunca colapsar critérios (`shared/anti-rush.md`).  
- **Exemplos:** só anexos reais em `examples/anexos/` + `target-model.md`. Proibido “exemplo ilustrativo”.  
- **Formações:** `reference/formacoes.md`; máx. 1–2 ON; gates com **F6**.  
- **Propagação:** decisão nova que mexe em fase anterior (tela, dado, regra, escopo) → replace no arquivo dono na mesma rodada (`reference/rules.md` → Propagação). O gate da fase dona não reabre.  
- **Perguntar só o necessário:** decisão de produto = cliente; o que o Design System, o contrato ou uma regra escrita já responde = o agente resolve e informa (`reference/rules.md` → Perguntar só o necessário).

---

## Passo a passo — até a tarefa

### Fase 0 — Posicionamento e mapa
- Fixar papéis + linha de corte.
- **Casa do produto:** o workspace é um repositório git **próprio** (não dentro de outro repositório). Se não for, o Controlador propõe criar (nome `<cliente>_<produto>`, ou com hífen se o cliente já usa — `../docs/nomenclatura.md`) e só cria com o OK do cliente; commit/push só quando o cliente pedir. Pastas: `docs/` (oficial, versionada) · `design/` (canvas e imagens; cópias e capturas locais) · `prototipo/` · `.docs/`, `.task/`, `.cursor/` locais no `.gitignore` · repositórios de código como submódulos. No piloto a pasta estava dentro de um repositório alheio e o canvas existiu meses num arquivo só.
- **Gate:** cliente aprova o mapa.

### Fase 1 — Discovery
- Problema, persona, por que agora, métrica, o que **não** é o produto.
- Forçar críticos (regra de “mesmo produto”, nome de trabalho, entradas, canais…) com F6 — não estacionar.
- **Persistir:** `docs/discovery.md`
- **ON:** F1 + F8 (+ F6 nos gates)
- **Gate:** pacote discovery no arquivo + F6.
- **Proibido:** pesquisa ampla de concorrentes aqui (isso é Fase 2); no máximo o cliente citar 1–2 nomes como contexto.

### Fase 2 — Pesquisa de mercado
- Roteiro **obrigatório:** `modules/02-market/playbook.md`
- Qualidade: `modules/02-market/target-model.md` + PDFs em `examples/anexos/` (Airbnb + Deliveroo)
- Inclui: definição · tamanho de mercado (TAM/SAM/SOM) com **conta explícita** · segmentos · concorrentes com **preço/escala** · lacunas · implicações
- **Navegador** quando necessário (preços, lojas, páginas)
- **Persistir:** `docs/pesquisa-mercado.md`
- **ON:** F10 + F1 (+ F6 no gate)
- **Gate:** checklist do roteiro; raso = **bloqueado**
- **Proibido:** pesquisa rasa; pular sem adiado + risco; inventar tamanho de mercado

### Fase 3 — Solução em papel (protótipo)
- Opções → escolher 1; telas com nome humano, campos, ações e estados (sem cor).
- Lacunas da Fase 2 como entrada (diferencial).
- Pedido de funcionalidade do cliente → **eco + confirmação** → só então gravar (não batizar sozinho).
- **Persistir:** `docs/prototipo.md`
- **ON:** F1 + F2 (+ F3); **F9** se monetização/crédito entrar no desenho
- **Gate:** fluxo compreensível + arquivo.

### Fase 4 — MVP
- Jornadas do dia 1 + fora de escopo + sucesso.
- **F9** se necessário (quem paga / monetização / créditos).
- Cliente não sabe preço → pode **adiar com risco** (valores fora) **só se** o mecanismo estiver claro e o risco escrito no gate.
- **Persistir:** `docs/mvp.md` (enxuto). Após o gate: criar/atualizar `docs/produto.md` (brief).
- **Gate:** escopo fechado + arquivo.

### Fase 5 — Arquitetura mínima + contrato
- Seguir `modules/05-contract/playbook.md`. Uma decisão por vez; **eco → confirma → grava**.
- “Fechado” explicado: corte × lista completa × depois (tarefa).
- Inventário externo (`data.md` etc.) → traduzir para `docs/contrato.md`.
- **ON:** F5 + F6 (+ F9 se crédito/pagamento)
- **Gate:** o time entende o que guardar e quem faz o quê.

### Fase 6 — Setup especificado
- **Objetivo:** peças → repositórios + **boilerplates Space** + ambientes + contas externas. Especificado no documento; devs executam.
- **Não é:** banco detalhado / Apidog / árvore de pastas / Design System / QA — isso é Fase 11, Fase 7 e `qa-space`.
- Boilerplates: `boilerplate-back-elysia` · `boilerplate-front-nextjs`; extensão = **TypeScript + webpack** (proibido JavaScript puro).
- Módulo: `modules/06-setup/` · **Persistir:** `docs/setup.md`
- **Gate:** peças + Git A/B/C + boilerplate por peça + ambientes + contas + ponteiros.

### Fase 7 — Design System (marca + documento + canvas)
- **Objetivo:** criar a linguagem visual do produto: manual da marca, `DESIGN_SYSTEM.md` e componentes oficiais no canvas.
- Skill: **`design-system-forge`** — roteiro único em `roteiro.md`:
  - **Parte A — Marca:** essência, logo, cores, fontes, regras de uso (prancha no canvas);
  - **Parte B — Documento:** fundamentos, peças do domínio, lista fechada de componentes por faixa, matriz de estados, padrões de tela `P-…`;
  - **Parte C — Canvas:** variáveis → Fundamentos → Componentes no tema principal → Oficial × Rascunho.
- **Nível essencial** por padrão; **ouro** (PDF do manual, segundo tema, capítulos do deck) só se o cliente pedir.
- Módulo: `modules/07-design-system/` · referência de estrutura: deck de Design System real em slides (`examples/anexos/bateubet-design-system-estrutura.md`; só estrutura, nunca cor).
- **Persistir:** `docs/DESIGN_SYSTEM.md` + `tokens.dtcg.json` + `design-system-forge/EXTRACTION_NOTES.md` + canvas
- **Gate:** PASS / PASS COM RESSALVAS / REPROVADO → fechado | adiado com risco | bloqueado
- **Botão principal decidido aqui:** mostrar lado a lado texto claro × texto escuro sobre a cor da marca, com o contraste medido (mínimo 4,5 : 1), e o cliente escolhe **antes** de construir os componentes. No piloto essa escolha só apareceu na Fase 8 e mudou a cor da marca no meio das telas.
- **Proibido:** telas existentes como lei; copiar cor de outro produto; montar telas nesta fase (é a 8).

### Fase 8 — Telas
- **Objetivo:** montar e aprovar as telas do produto no canvas, **uma por vez**, só com peças oficiais.
- Ferramenta: skill **`design-system-apply`** (conferência com o gosto, varredura, correção no canvas). A **sequência** abaixo é regra **desta fase** e vale por cima da ordem própria do Apply:
  1. lista de telas do protótipo em `telas.md` (montar ou corrigir; essencial ou não);
  2. conferência do Design System com o gosto (Fase A do Apply), **uma vez** → OK;
  3. **Home no tema principal** (tela-prova) → OK do cliente → **Apply só na Home** → achou algo: corrigir e mostrar de novo → novo OK;
  4. próxima tela (o cliente escolhe), **mesmo ciclo**: montar ou corrigir → OK → Apply na tela → novo OK se mudou;
  5. estados, janelas, segundo tema (se houver) no mesmo ciclo; conferência cruzada no fim.
- **Site = computador**; celular só se o cliente pedir. Extensão e app no tamanho real.
- **Dados de exemplo nas telas = mockup:** produto, preço, nota, data e foto de exemplo não são conferidos entre telas. Placeholder explícito (“X”, “Lorem”) é proibido → valor fictício plausível, aprovado pelo cliente uma vez e usado igual em todas as telas.
- **Texto de tela passa no teste do leigo:** palavra de especialista (“ranking”, “match”, “dashboard”) vira português do público (“ordem”, “resultado”, “painel”).
- **Canvas protegido:** um só editor aberto com o arquivo do canvas; cópia com data em `{pasta do canvas}/copias/` antes e depois de cada rodada; depois de cada edição, conferir que o arquivo mudou no disco. Prints e relatórios de cada rodada são o que permite refazer o aprovado se o arquivo for sobrescrito.
- **Aprovação em lote (exceção):** só quando o cliente pedir explicitamente; cada tela do lote passa pelo ciclo completo (prints antes, Apply, re-conferência cega, prints depois, relatório próprio) e `telas.md` registra “aprovada em lote” com a data.
- Telas só com peças **ligadas** aos componentes oficiais do canvas + variáveis.
- Peça ou regra faltando → nova versão do `DESIGN_SYSTEM.md` com motivo e OK (o gate da Fase 7 **não** reabre).
- Telas prontas feitas fora do fluxo passam pela mesma sequência — tela pronta ≠ tela aprovada.
- Tela mudada **depois** da Fase 8.5 → atualizar o protótipo navegável na mesma rodada.
- Módulo: `modules/08-screens/` · **Persistir:** `docs/telas.md` + canvas + relatórios
- **ON:** F2 + F6
- **Gate:** telas essenciais aprovadas uma a uma, cada uma com o Apply sem pendência; estados cobertos ou pendentes por escrito.
- **Proibido:** telas em lote sem pedido explícito do cliente; pular a Home; pular o Apply; celular sem o cliente pedir; peça desenhada à parte; remendo só na tela; editar código; decisão de produto revelada pela tela sem propagar para protótipo, MVP e contrato.

### Fase 8.5 — Protótipo navegável
- **Objetivo:** as telas aprovadas viram um **site clicável** para apresentar (reunião, parceiro, investidor), antes de existir código. Abre no **Manual da marca** com o botão **“Iniciar protótipo”**; lista lateral com a documentação (Manual, Fundamentos, Componentes, Rascunho) e as telas agrupadas como no canvas; troca **Computador | Celular** na mesma tela; modal/gaveta fecha para a tela de trás.
- **Molde pronto** em `modules/08b-prototipo-navegavel/molde/`: o motor (shell, navegação, servidor, scripts) é igual em todo produto; a fase preenche só `screens.js` (quais telas) e `rotas.js` (o que cada botão abre).
- Sequência: copiar o molde para `prototipo/` (raiz do workspace, **fora** do `docs/`) + scripts `prototipo:*` no `package.json` da raiz → inventário dos frames do canvas → `screens.js` → exportar cada frame como HTML + Tailwind → `npm run prototipo:preparar` → `rotas.js` (a partir do `--inventario` e do `prototipo.md`) → `npm run prototipo:verificar` sem erro → `npm run prototipo:start` + conferência visual com prints → cliente.
- **Telas só exportadas:** defeito de tela volta para a Fase 8 (canvas) e é reexportado; nunca remendo no HTML. Melhoria do motor vai para a skill (`/skill-update`).
- **Atualizar:** o protótipo acompanha o canvas — tela alterada, nova, removida ou mudança do Design System → reexportar + `preparar` + `verificar` na mesma rodada (tabela no playbook do módulo).
- Módulo: `modules/08b-prototipo-navegavel/` · **Persistir:** `prototipo/` + seção “Protótipo navegável” em `docs/telas.md`
- **ON:** F2 (+ F6 no gate)
- **Gate:** todas as telas aprovadas navegáveis; `verificar` sem destino inválido nem tela isolada; conferência visual ok; cliente aprovou.
- **Proibido:** protótipo dentro de `docs/`; editar tela no HTML; mexer no motor dentro do produto; botão para tela “parecida”; mostrar sem verificar.

### Fase 9 — Revisão (Revisor)
- **Não** refazer o produto do zero.
- Seguir `modules/09-review/playbook.md` + `shared/acceptance-criteria.md` + `shared/docs-clarity.md` + `shared/anti-rush.md`.
- Duas passagens por arquivo (conteúdo · clareza), **uma linha por critério**, busca residual anotada; telas conferidas abrindo os prints (R15).
- **Persistir:** `docs/revisao.md`
- **ON:** F4 + F6
- **Gate:** liberar a **Fase 10 (manual)**? fechado / adiado com risco / bloqueado. (**Não** pula para tarefas.)

### Fase 10 — Manual comercial (`{slug}.md`)
- **Objetivo:** um documento **completo** e **comercial** que conta a história e reúne todas as fases — para **usuário** e para **negócio**.
- **Arquivo:** `docs/{slug}.md` — template `templates/manual-produto.md`. **Não é** o brief `produto.md`.
- Módulo: `modules/10-product-manual/` · anexos reais Stripe · Notion · Linear · Apple · Airbnb · Shape Up.
- Jornada e destaques batem com as telas aprovadas na Fase 8 (imagem = só print de tela aprovada).
- **ON:** F1 + F2 + F7 (+ F6)
- **Gate:** o manual sozinho explica o produto; teste do estranho estrito; dívidas da revisão aparecem honestas.
- **Proibido:** cópia crua dos documentos; inventar preço ou cor; ir à tarefa sem este arquivo.

### Extra (sob pedido) — Material comercial derivado
- **Quando:** o cliente pede um material para apresentar a terceiros (parceiros, investidores) depois do manual. Fora das fases; não tem gate próprio e não bloqueia a Fase 11.
- **Fonte única:** o manual `{slug}.md` + prints de telas aprovadas + Design System (logo, cores, tom de voz).
- **Sequência:** público e objetivo confirmados → roteiro slide a slide aprovado → slides no canvas (área própria, telas **copiadas**, não ligadas) → OK → exportar PDF (versão leve para e-mail e WhatsApp).
- **Proibido:** número de usuários, depoimentos, receita, tamanho de mercado em R$, preço de crédito ou plano que o manual não tem; “em breve” se o cliente decidiu apresentar como no ar.
- **Persistir:** `docs/apresentacao-comercial.md` (roteiro + onde estão os arquivos) + PDF em `docs/apresentacao-comercial/`.

### Fase 11 — Tarefas por fatia
- Exigir: revisão liberada, manual fechado ou adiado com risco, telas essenciais aprovadas.
- **Plano de fatias** em `docs/tarefas.md` (toda jornada do dia 1 coberta) → OK → **uma fatia por vez** pelo pipeline `po-techlead-scrum` (objetivo → regra → banco → Apidog → tarefa).
- Tarefa de tela usa **print da tela aprovada** na Fase 8.
- Módulo: `modules/11-task/` (anexos: tarefas reais de front e back) · **Persistir:** `docs/tarefas.md` + `.task/` → ClickUp após OK
- **ON:** F7 + F5 (+ F6)
- **Gate:** tarefa para júnior sem adivinhar, em todas as fatias.
- **FIM da linha agente + cliente.**
