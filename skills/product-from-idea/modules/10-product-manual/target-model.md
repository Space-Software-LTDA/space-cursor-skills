# Modelo-alvo — Fase 10 Manual comercial do produto

> Derivado de casos **reais** (PDF/HTML em `examples/anexos/`).  
> Extrações de leitura: `examples/_extracts/` (só apoio — o anexo original é a lei).  
> Vivo: `.docs/{slug}.md` · Template: `templates/manual-produto.md`  
> Densidade: [`examples/density-reference.md`](examples/density-reference.md)

---

## Fontes reais (abrir o arquivo)

| Arquivo | O que é | O que extrair (lógica — **não** copiar domínio/números) |
|---------|---------|--------------------------------------------------------|
| [`anexos/airbnb-pitch-deck.pdf`](examples/anexos/airbnb-pitch-deck.pdf) | Deck seed AirBed&Breakfast | Promessa em 1 linha · Problem · Solution (3 benefícios) · Validation **com números nomeados** · Market size com unidade · Product (fluxo) · Business model (taxa + conta) · Competition (eixos) · Advantages |
| [`anexos/stripe-2021-update.pdf`](examples/anexos/stripe-2021-update.pdf) | Carta anual Stripe (oficial) | Missão · prova com contexto · “ajudamos em N caminhos” · seções por público · tendências · tom de carta (prosa, não bullet soup) · honestidade (“2022 não vai repetir o mesmo crescimento”) |
| [`anexos/shape-up.pdf`](examples/anexos/shape-up.pdf) | Basecamp *Shape Up* | **Pitch = 5 ingredientes:** Problem · Appetite · Solution · Rabbit holes · **No-gos** · “melhor problema = uma história específica do status quo” · solução sem problema = perigo · problema sem solução = não está pronto |
| [`anexos/stripe-payments.html`](examples/anexos/stripe-payments.html) | Página produto Stripe Payments | Hero → pilares de benefício → “várias formas de começar” → prova citada → confiança/infra |
| [`anexos/apple-airpods-pro.html`](examples/anexos/apple-airpods-pro.html) | Página produto Apple | Headline de resultado · **Get the highlights** · **Take a closer look** · deep dives · values (trust) · footnotes/honestidade de claim |
| [`anexos/linear-homepage.html`](examples/anexos/linear-homepage.html) | Home Linear | Posicionamento (“sistema”) · **capítulos da jornada** (Intake → Plan → AI → Build/Ship) · quotes curtas |
| [`anexos/linear-method-introduction.html`](examples/anexos/linear-method-introduction.html) | Linear Method — Principles & Practices | Clareza de linguagem · “simple first” · specs curtas (why/what/how) · changelog · dono nomeado |
| [`anexos/notion-product.html`](examples/anexos/notion-product.html) | Notion /product | Uma linha · trust line · blocos de capacidade · “See what it can do” (jobs concretos) · quotes |

**Proibido:** fabricar anexo `.md` fino no lugar destes; copiar GMV Stripe / trips Airbnb / claims Apple para o produto do cliente.

---

## O que os modelos reais exigem (mínimos)

### Do Airbnb deck (história comercial)
1. **Uma frase** que um estranho repete (“Book rooms with locals, rather than hotels”).  
2. **Problema** em 2–3 dores concretas (não “mercado grande”).  
3. **Solução** como benefícios claros (Save / Make / Share — padrão ternário).  
4. **Validação** com evidência nomeada **antes** de falar tamanho.  
5. **Tamanho** com unidade (trips, £, users…) + funil.  
6. **Produto** como fluxo (Search → Review → Book), não lista de features.  
7. **Modelo de dinheiro** explícito (taxa + conta ilustrativa se houver dado).  
8. **Concorrência** em eixos (não só lista de nomes).  
9. **Vantagens** curtas e testáveis.

### Da carta Stripe (prosa de negócio)
10. **Missão** em 1–2 frases.  
11. **Prova** com número **e** contexto/ressalva.  
12. **N caminhos** pelos quais o produto ajuda (pilares).  
13. Seções que falam com **públicos diferentes** (startup vs enterprise — no nosso caso: usuário vs decisor).  
14. Tendências / por que agora.  
15. Tom de **carta**: parágrafos que se leem; sem “GATE / CA / Confirmado”.

### Do Shape Up — *Write the Pitch* (estrutura obrigatória do miolo)
16. Sempre **Problem + Solution juntos**.  
17. **Appetite** = quanto esforço/escopo cabe no dia 1 (MVP = appetite).  
18. Solution em nível que o leitor **vê** sem wireframe hex.  
19. **Rabbit holes** = riscos técnicos/produto já conhecidos (nossas dívidas da revisão).  
20. **No-gos** = fora de escopo **intencional** (não “esquecemos”).

### Da Apple (Parte A — usuário)
21. Headline = **resultado** (“best ANC”), não stack.  
22. **Highlights** escaneáveis primeiro.  
23. **Closer look** para quem quer profundidade.  
24. Deep sections com “o que mudou + por que você sente”.  
25. **Values / trust** no fim (privacidade, honestidade) — sem processo interno.  
26. Claims com **nota/honestidade** quando frágil (nossa versão: “ainda em aberto”).

### Do Stripe Payments + Notion (página produto)
27. Pilares de benefício (não inventário).  
28. **Várias formas de começar** (ex.: a partir de uma página ou colando um link; modo normal ou com IA).  
29. Jobs concretos (“See what X can do”).  
30. Prova citada **só** se for real nas fases.

### Do Linear home + Method (sistema + clareza)
31. Nomear o **sistema** e narrar em **capítulos de jornada**.  
32. Princípios de clareza: não inventar jargão; simple first; spec curta why/what/how.  
33. Changelog / versão do produto no manual (o que é v1).

---

## Nosso modelo-alvo (estrutura do `.docs/{slug}.md`)

> Ordem fixa. Seções vazias = `N/A` + por quê — **não** sumir com o fato.

### 0. Meta (cabeçalho comercial)
- Nome do produto · data · uma linha do que o arquivo é  
- **Sem** checklist de agente, caminhos de arquivo da skill (`modules/…`), lista de PDFs abertos  
- **Dicionário** (Termo \| O que é) — leigo; **sem** termos de método (Appetite, Gate, Shape Up)  
- Lei de clareza: [`../../shared/docs-clarity.md`](../../shared/docs-clarity.md)

### 1. Parte A — Para quem usa *(Apple + Notion + Linear journey)*

| # | Seção (título no arquivo = português humano) | Barra (inspiração do agente — não no corpo) |
|---|--------|-------------------|
| A1 | **Em uma frase** | Airbnb slide 1 / Notion hero |
| A2 | **Para quem é / não é** | Airbnb problem audience |
| A3 | **O problema na vida real** | História específica do status quo |
| A4 | **A promessa** | Airbnb Solution ternário |
| A5 | **Em destaque** | Apple “Get the highlights” |
| A6 | **Como funciona** | Airbnb Product flow · Linear Intake→… |
| A7 | **Olhada de perto** (telas em português humano) | Apple deep + proto |
| A8 | **O que entra no dia 1** (entra / fica de fora) | Escopo MVP |
| A9 | **Por que não só o status quo** | Stripe pilares / gap do mercado |
| A10 | **Perguntas frequentes** | Apple honesty |

Parte A deve ser legível **sozinha** (como landing outline).

### 2. Parte B — Para quem decide / vende / investe *(Airbnb + Stripe letter)*

| # | Seção | Barra |
|---|--------|-------|
| B1 | **Por que este produto existe** | Stripe letter opening |
| B2 | **Missão** | Stripe mission → nossa frase |
| B3 | **Mercado** | Unidade + conta (do `pesquisa-mercado.md`); TAM/SAM/SOM por extenso na 1ª vez |
| B4 | **Sinais de validação** | ≥2 sinais **já no mercado doc** |
| B5 | **Alternativas e eixos** | Eixos + rivais da fase 2 |
| B6 | **O buraco que preenchemos** | Gaps da pesquisa |
| B7 | **Como ganha dinheiro** | Pendências em português (“ainda não definido”) |
| B8 | **Por que agora** | Timing |
| B9 | **O que já sabemos do mercado** | Só fatos; ressalva se preciso |
| B10 | **Escopo do dia 1 (visão de negócio)** | Corte MVP |

Parte B deve ser legível **sozinha** (como one-pager de negócio).

### 3. Parte C — O produto completo *(sistema + fases)*

| # | Seção | Barra |
|---|--------|-------|
| C1 | **Mapa do sistema** | Linear: Intake / Plan / Build… → nossas etapas |
| C2 | **Regras que o produto obedece** | Matching, ranking, créditos, selos… |
| C3 | **O que guarda e quem faz o quê** | Contrato em português comercial |
| C4 | **Marca e visual (essência)** | DS sem dump de tokens |
| C5 | **Peças e repositórios** | Setup leve |
| C6 | **Riscos conhecidos** | Dívidas da revisão/DS/afiliado… |
| C7 | **Fora de propósito** | Cortes intencionais do MVP |
| C8 | **O que é a primeira versão** | Changelog spirit |

### 4. Pendências
Tabela Item \| Situação — vem de revisão + fases. Tom honesto — **não** tom de CA / “não inventar”.

### 5. Apêndice — Documentos internos (time)
Só links. O corpo do manual **não** depende deles.

### 6. Uso interno — decisão do manual
fechado \| adiado com risco \| bloqueado + data + riscos em português. **Não** misturar com a narrativa comercial (cabeçalho limpo).

---

## Critérios de aceitação

| # | CA | Barra | Inspirado em |
|---|-----|--------|--------------|
| M1 | `.docs/{slug}.md` existe (nome do produto) | Não só `produto.md` | — |
| M2 | Meta + Dicionário | Leigo | Linear Method “Aim for clarity” |
| M3 | A1 Em uma frase | Repetível | Airbnb / Notion |
| M4 | A3 Problema = história do status quo | Não abstrato | Shape Up Problem |
| M5 | A4 Promessa com 2–3 benefícios claros | Ternário ok | Airbnb Solution |
| M6 | A5 Highlights + A6 jornada | Scan + passos | Apple + Linear |
| M7 | A8 Dentro/fora dia 1 | Escopo MVP claro | Shape Up + MVP |
| M8 | Parte A legível sozinha | Sem “ver proto” | Apple page |
| M9 | B1–B2 História + missão | Prosa | Stripe letter |
| M10 | B3 Mercado com unidade + conta | Do fase 2 | Airbnb Size |
| M11 | B4 Validação com sinais nomeados | Do fase 2 | Airbnb Validation |
| M12 | B5–B6 Alternativas + gap | Eixos / buraco | Airbnb Competition |
| M13 | B7 Monetização honesta | “ainda não definido” ok | Airbnb Model |
| M14 | Parte B legível sozinha | | Stripe letter |
| M15 | C1 Sistema em capítulos | Jornada completa | Linear |
| M16 | C2–C3 Regras + dados/quem | Cobertura absoluta dos fechados | Contrato |
| M17 | C4 Visual essência | Sem hex soup | DS |
| M18 | C6 Riscos + C7 Fora de propósito | Dívidas e cortes | Shape Up |
| M19 | Pendências honestas | Sem sumir | Stripe caveat |
| M20 | Tom comercial no corpo | Zero “GATE/CA/Confirmado/Shape Up” | Todos |
| M21 | ≥1 PDF **ou** HTML denso aberto (agente) | Airbnb/Stripe/Shape Up/Apple… | Lei anexo |
| M22 | Sem inventar métrica/preço/hex/feature | | — |
| M23 | Sem dump cru dos `.docs/` | Síntese | Shape Up “see it” |
| M24 | Decisão gravada em **Uso interno** | | F6 |
| M25 | Pronto para Fase 11 só após este arquivo | | Fluxo |
| M26 | Passa no **teste do estranho** (`docs-clarity.md`) | Apresentável a cliente sem Cursor | Lei clareza |
| M27 | Sem `qtd.` / `TBD` / abreviação preguiçosa | | Lei clareza |
| M28 | Sigla só após por extenso na 1ª menção | | Lei leigo |
| M29 | Jornada e destaques batem com as telas aprovadas (Fase 8); imagem só de tela aprovada | Nome da tela igual ao de `telas.md` | Fluxo |

---

## Anti-padrões

| Anti-padrão | Sintoma | Contra-exemplo real |
|-------------|---------|---------------------|
| Brief disfarçado | &lt;100 linhas + “ver discovery” | Airbnb deck / Apple page |
| Dump Frankenstein | Cola discovery+mercado+proto | Shape Up: pitch ≠ pasta de docs |
| Só investidor | Usuário não aprende a usar | Apple Parte A |
| Só landing | Sem regras/MVP/riscos | Airbnb model + Shape Up no-gos |
| Solução sem problema | Feature tour | Shape Up Ingredient 1 |
| Problema sem solução | “Dói mas não diz o que é” | Shape Up: unshaped |
| Sem appetite/no-gos | MVP infinito | Shape Up 2 e 5 |
| Jargão interno | “CA 1.5 OK”, “GATE 0 A”, “só o que for real nas fases” | Linear Method clarity / Stripe letter |
| Métrica inventada | “2× como Stripe” | Stripe: número + ressalva; nós: só fase 2 |
| Copiar copy Airbnb/Stripe/Apple | Outro produto | Lei anexo |
| Pular manual → task | Fase 11 sem `{slug}.md` | Passo-a-passo |
| Tela que não existe | Manual descreve ou mostra tela diferente da aprovada, ou mockup inventado | `telas.md` |
| Riscos escondidos | Revisão tinha dívida e sumiu | Shape Up Ingredient 4 |
| Meta de chat no corpo | Shape Up no título; caminhos de arquivo da skill no cabeçalho; “nesta thread” | `docs-clarity.md` |
| Abreviação preguiçosa | `qtd. de crédito`, `TBD`, `A DEFINIR` gritando | Português claro: “ainda não definido” |
| Assume que o leitor sabe | SAM, matching, heatmap sem dicionário | Extenso + (sigla) + o que é |

---

## Checklist do agente (antes do gate)

1. Abrir **Airbnb PDF** — marcar A1–A4, B3–B7.  
2. Abrir **Stripe letter PDF** — marcar B1–B2, B8–B9, tom.  
3. Abrir **Shape Up** (cap. Write the Pitch) — cobrir problema / escopo / solução / riscos / fora — **sem** colar esses nomes no arquivo.  
4. Abrir **Apple HTML** — marcar A5–A7, trust.  
5. Abrir **Linear** (home e/ou Method) — marcar C1, clareza.  
6. Ler **todas** as fases fechadas/adiadas → tecer fatos.  
7. Preencher template **inteiro**.  
8. Density: Parte A e B sozinhas; C cobre matching/lojas/crédito/superfícies/repos.  
9. Passar no **teste do estranho** (`docs-clarity.md`) — zero `qtd.` / meta de chat.  
10. Gravar decisão em **Uso interno**.

---

## Relação com outros arquivos

| Arquivo | Papel |
|---------|--------|
| `.docs/produto.md` | Brief **interno** vago — **não** substitui `{slug}.md` |
| `.docs/{slug}.md` | **Este** modelo-alvo |
| Fases 1–8 | Fonte de fatos — nunca dump |
| Fase 11 | Só depois do gate deste manual |
