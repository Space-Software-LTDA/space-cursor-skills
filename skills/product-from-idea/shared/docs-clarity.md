# Lei — documentos legíveis por humano (cliente / mercado)

> Vale para **todo** `.docs/`. Mais rígida no **manual comercial** (`.docs/{slug}.md`).

## Teste do estranho

Antes de gravar qualquer arquivo, perguntar:

> “Se eu imprimir isto e entregar a um cliente / investidor / sócio **sem** abrir o Cursor, a pessoa entende — ou parece conversa com a IA?”

Se parece conversa com a IA → **reescrever**.

## Posicionamento do leigo (obrigatório — especialmente no Revisor)

Em **todo** trecho / tabela / seção de **todo** `.docs/`, o Revisor (e qualquer agente que grava) assume:

> **“Se eu fosse um leigo lendo esta informação, eu ficaria confuso? Isso esclarece?”**

| Resposta | Ação |
|----------|------|
| Ficaria confuso / não esclarece | **Falhou clareza** → reescrever em português humano (por extenso, contexto, sem assumir jargão) |
| Esclarece na 1ª leitura | Segue |

Isso vale **arquivo a arquivo**, não só no manual. Discovery, mercado, proto, MVP, contrato, setup, DS, brief e `{slug}.md` passam pelo mesmo filtro.

### CL0 não é só “tirar qtd.”

| Ainda confunde o leigo (falha CL0) | Correção |
|------------------------------------|----------|
| “Scraper” sem dizer o que é | Dicionário: “leitura automática da página da loja” |
| “→ proto/DS” / “fase certa” | Português: “detalhe visual fica para a definição de telas / marca” |
| Von Restorff, Postel, a11y, Fitts sem tradução | Por extenso + o que significa **ou** apêndice “leis UX (time)” |
| Forge, GATE 0, Apply no corpo vivo do DS | Português: “aprovado com ressalvas”, “ainda não definido” |
| Cabeçalho “especialista → leigo” | Remover — é meta de processo |

**DS pode ser denso** — mas o leigo precisa achar o termo no **Dicionário** ou na 1ª menção. “Técnico mas legível” **sem** isso = Falhou clareza.

## Proibido no corpo do documento (especialmente no manual)

| Proibido | Por quê | Preferir |
|----------|---------|----------|
| Instrução de agente no título | “só o que for real nas fases”, “abrir anexo”, “barra target-model” | Título humano: “Provas no mercado”, “O que já sabemos” |
| Meta de processo | Shape Up, Appetite, Rabbit holes, Gate F6, CA, GATE 0, PASS COM RESSALVAS, “Controlador”, “subagente”, “nesta thread” | Fatos do produto. Processo fica no skill / chat |
| Jargão de fase sem tradução | “fechado nas fases”, “adiado com risco”, “DS gate B” | “Ainda não definido”, “Decisão pendente”, “Risco conhecido” |
| Abreviação sem por extenso | `qtd.`, `TBD`, `HML` sozinho, `MVP` sem explicar na 1ª vez | **quantidade**, **ainda a definir**, **homologação**, **primeira versão** |
| Assumir que o leitor sabe | ML, SAM, matching, heatmap, Brand Manual, unit economics | Extenso + (sigla) + o que significa na 1ª menção |
| Resíduo de chat | “não inventar”, “humano confirmou”, “rodada anterior”, “ruído de chat” | Frase afirmativa limpa |
| Caminhos de skill no cabeçalho comercial | `modules/...`, lista de PDFs abertos | Só no apêndice interno do **time**, se precisar |
| Inglês de método no dicionário comercial | Appetite, No-gos, Rabbit holes como termos do produto | Traduzir: escopo do dia 1, fora de propósito, riscos conhecidos |

## Manual comercial (`{slug}.md`) — regra extra

O arquivo deve servir para **lançar / apresentar**.  

- Cabeçalho: nome do produto + data + uma linha do que o arquivo é.  
- **Sem** checklist de agente, anexos da skill, Gate F6 no meio da narrativa.  
- Gate / riscos para o time → seção final curta **“Pendências”** em português claro, ou apêndice “Uso interno”.  
- Números e limites: escrever por extenso (“preço e quantidade de créditos ainda não definidos”).

## Documentos de fase (discovery → revisão)

Podem ter Confirmado / Hipótese / Aberto e Gate — mas:

- Ainda assim **sem** abreviação preguiçosa (`qtd.`).  
- Ainda assim **sem** “não inventar heatmap” como se fosse nota para a IA.  
- Gate em português: **fechado** · **adiado com risco** · **bloqueado** + o que isso significa para o leitor.

## Jargão que mais vazou no piloto (procurar antes de gravar)

A Revisão do piloto precisou acrescentar cerca de 70 termos nos Dicionários das fases 2 a 7. Os agentes de cada fase escreveram o termo técnico sem explicar. Antes de gravar, procurar no arquivo:

| Área | Termos | Fazer |
|------|--------|-------|
| Produto / mercado | job, match, matching, ranking, take, CPA, publisher, 1P/3P, landscape, dashboard, breadcrumb, cupões | Português (“pesquisa”, “selo igual/similar”, “ordem”, “comissão”, “painel”, “caminho de categorias”, “cupons”) ou Dicionário |
| Técnica | scraper, parse, debug, seletor, URL, HTML, endpoint, payload | Dicionário com o que é para o leigo (“leitura automática da página da loja”) |
| Setup | branch, PR, Dockerfile, JWT, OAuth, Manifest V3, CI, DNS, `.env`, QA, HML | Dicionário (o setup do piloto tinha 7 termos e precisava de 20) |
| Design | token, variável, H1/H3, 16/600, mini-A, ALIGNED, re-Scan, P0/P1/P2 | Dicionário; números de fonte explicados (“tamanho/peso”) |

**Texto de tela** (o que o usuário final lê no produto) passa pelo mesmo teste: “ranking” numa tela para o público geral é falha.

## Notas “para o agente” nos templates

Linhas marcadas **“Para o agente (não copiar para o arquivo final)”** nos templates são instrução de trabalho. Nunca vão para o `.docs/`. No piloto, a linha “Qualidade: `…`” do template foi copiada para `telas.md` e a Revisão teve de apagar.

## Checklist rápido (todo Write)

1. [ ] Tem `qtd.` / `TBD` / sigla solta? → expandir  
2. [ ] Título parece prompt? → renomear  
3. [ ] Frase só faz sentido no Cursor? → apagar ou reescrever  
4. [ ] Manual: daria para colar num PDF de pitch? → se não, falhou  
5. [ ] Algum termo da tabela de jargão acima sem Dicionário? → explicar  
6. [ ] Copiou nota “para o agente” do template? → apagar  

**Filtro conversa → arquivo** (já era lei): correção no chat **substitui** o texto; zero “cliente corrigiu”, “atualizado após…”.

## Onde isso vira critério de aceitação

| Lugar | O que exige |
|-------|-------------|
| **Cada** `modules/*/target-model.md` | Linha **\*.CL** (CL0–CL5) |
| [`acceptance-criteria.md`](acceptance-criteria.md) | Bloco **CLAREZA** + **\*.CL** + Revisor **R6–R15** |
| [`anti-rush.md`](anti-rush.md) | Duas passagens · zero CA colapsado · residual com evidência |
| Fase 8 Telas | T.CL / 8.CL — termos da skill Apply (ALIGNED, mini-A, re-Scan) traduzidos em `telas.md` |
| Fase 9 Revisor | Clareza humana + Busca residual; Controlador rejeita colapso |
| Fase 10 Manual | M26–M28 + 10.CL — barra máxima |
