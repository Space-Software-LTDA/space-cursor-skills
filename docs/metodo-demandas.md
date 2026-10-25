> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor/Claude Code é cópia (`npm run sync`).

# Método de demandas — toda solicitação vira registro

> Vale para **todo projeto** Space que guarda o trabalho em `docs/` versionado. Junta-se ao [metodo-agentes.md](metodo-agentes.md) (quem executa: controlador + subagentes) e ao [tom-professor.md](tom-professor.md) (como escrever).
> Origem: framework de documentação de um projeto real (outubro de 2026), que nasceu das skills `po-techlead-scrum` ("já existe?", "Pronto quando") e `product-from-idea` (índice com status, Confirmado/Hipótese/Aberto, teste do estranho) e acrescentou foco na dor, mapa de impactos, snapshot e reaproveitamento.
> Moldes: [`_moldes/`](_moldes/) (`demanda.md`, `snapshot.md`, `etapa.md`, `tarefa-subagente.md`). O projeto copia os moldes para o próprio `docs/_moldes/` (ou aponta para cá) e pode acrescentar campos dele.

## Dicionário

| Termo | O que é |
|-------|---------|
| **Demanda** | Uma solicitação do dono do produto (pedido, correção, ideia). Vira uma pasta `docs/demandas/AAAA-MM-DD-slug/` |
| **Pedido literal** | O texto do pedido copiado **sem edição** (`solicitacao-original.md`). O resumo vai na ficha, nunca no lugar do literal |
| **Snapshot** | Foto documentada e congelada do estado do problema: **antes** de mexer e **depois** da entrega, com os mesmos números |
| **Dor (`D1…`)** | Quem sofre + o que acontece + por que é ruim |
| **Causa (`C1…`)** | Por que a dor acontece. Sempre marcada como **fato** (com evidência) ou **hipótese** (com como confirmar) |
| **Etapa** | Um pedaço executável da demanda (levantamento, desenho, código, migration). Arquivo `etapas/NN-slug.md`: plano **antes**, resultado **depois** |
| **Regras do projeto** | O arquivo de regras sempre ativo do repositório (ex.: `.claude/CLAUDE.md`, `AGENTS.md`), escrito pelo dono. Guarda só o que é **do projeto** e as exceções a esta constituição |
| **Sistema** | `docs/sistema/` do projeto: como o sistema funciona **hoje** (vivo, atualizado no fechamento de cada demanda) |
| **Tag** | Rótulo de busca (`#minusculo-com-hifen`) que liga demandas do mesmo assunto |

---

## 1. Por que existe

O trabalho atravessa várias conversas e vários agentes. O que não está escrito se perde: o próximo agente pergunta de novo o que já foi decidido, refaz um levantamento ou muda uma regra sem saber que ela existia.

**Se não está em `docs/`, não aconteceu; se não está nas regras (do projeto ou nesta constituição), não é regra.**

## 2. Onde cada coisa mora (três camadas)

Cada informação mora em **um** lugar; os outros apontam com link.

| Camada | Onde | O que tem | Exemplo |
|--------|------|-----------|---------|
| **1. Geral** (vale para qualquer projeto Space) | Esta constituição (`space-cursor-skills/docs/`) + skills | Método de trabalho, padrões de código, banco, git, telas | "Dinheiro no banco é inteiro, em centavos" |
| **2. Projeto** | Regras do projeto (ex.: `.claude/CLAUDE.md`) | Lei que só vale ali + exceções a esta constituição, com o motivo | "Este projeto usa MySQL (legado); código novo vai no serviço em Postgres" |
| **3. Sistema** | `docs/` do projeto: `sistema/`, dicionários (métricas, design system), demandas | Como funciona hoje, histórico, dicionários | "A tela X lê a tabela Y" |

| O quê | Onde (no projeto) |
|-------|-------------------|
| Contexto de uma solicitação (pedido, dor, causas, plano, resultado) | `docs/demandas/AAAA-MM-DD-slug/` |
| Snapshot do problema | `docs/demandas/<demanda>/snapshots/` |
| Conhecimento do sistema | `docs/sistema/` |
| Dicionários globais (métricas, design system) | `docs/` (um arquivo por dicionário) |
| Moldes | `docs/_moldes/` |
| Tags (vocabulário + índice por assunto) | `docs/TAGS.md` |
| Índice geral (demandas, status, pendências, reaproveitamento) | `docs/README.md` |
| Material de fora usado como referência | `docs/referencias/` |
| Rascunho local, nunca versionado | `.docs/`, `.task/` |

**Projeto com `docs/` versionado:** o artefato final das skills (DS do produto, relatório de QA, tarefa) vai para o lugar certo dentro de `docs/`; `.docs/` e `.task/` ficam só como rascunho.

**Plano aprovado mora no repositório**, dentro da demanda, nunca só na pasta de planos da ferramenta (ex.: `~/.claude/plans/`). Caso real: um plano aprovado foi sobrescrito ali e se perdeu.

## 3. Organização de pastas

```text
<arquivo de regras do projeto>         regras, leis, exceções à constituição
README.md                              o repositório (aponta para docs/README.md)
docs/
├── README.md                          ÍNDICE GERAL: mapa, demandas, status, reaproveitamento, pendências
├── TAGS.md                            vocabulário de tags + índice por assunto
├── <dicionários globais>.md           ex.: METRICAS.md, DESIGN_SYSTEM.md
├── _moldes/                           demanda · snapshot · etapa · tarefa-subagente
├── demandas/
│   └── AAAA-MM-DD-slug/               uma pasta por solicitação (data de abertura + nome curto)
│       ├── README.md                  ficha: resumo, dicionário, dores, causas, impactos, decisões, etapas, reaproveitamento, pendências
│       ├── solicitacao-original.md    pedido literal
│       ├── snapshots/                 AAAA-MM-DD-antes.md · AAAA-MM-DD-depois.md
│       ├── etapas/                    NN-slug.md (plano antes, resultado depois)
│       └── anexos/                    prints, exportações, consultas usadas
├── sistema/                           como o sistema funciona HOJE
└── referencias/                       material de fora usado como exemplo
```

- **Pasta da demanda:** `AAAA-MM-DD` da abertura + slug curto em português, minúsculo, com hífen (`2026-10-20-catalogo-jogos`).
- **Etapas** com dois dígitos, na ordem em que foram planejadas (`01-levantamento-estado-atual.md`).
- **Snapshots** com a data em que foram tirados + `antes`/`depois` (ou `durante-<motivo>` se o estado mudar no meio).
- **Nada solto** na raiz do repositório nem em `docs/`. Arquivo novo cabe numa destas salas; se não couber, criar a sala no mapa primeiro.
- Documentação sempre em `docs/` (nunca `doc/`).

## 4. O ciclo de uma solicitação

```text
1. Registrar        → pasta da demanda + pedido literal + tags + linha no índice geral
2. Snapshot antes   → foto do estado atual do problema, ANTES de solução, desenho ou código
3. Dor              → o que dói, para quem, como se nota hoje
4. Causas           → fato (com evidência) ou hipótese (com como confirmar)
   ↳ Já existe?     → antes de propor: tags, catálogo de reaproveitamento, código
5. Impactos         → o que mais muda se mexermos aqui
6. Decisões         → o que o dono fechou, com data e motivo
7. Etapas           → antes: COMO + RESULTADO ESPERADO + PRONTO QUANDO
                      depois: RESULTADO OBTIDO + diferença + próximo passo + reaproveitamento
8. Fechamento       → snapshot depois, status final, pendências, regras novas, docs/sistema/ atualizado
9. Reaproveitamento → o que a demanda deixou para outras
```

### 4.1 Registrar

- Criar a pasta a partir de [`_moldes/demanda.md`](_moldes/demanda.md).
- Copiar o pedido **literal** para `solicitacao-original.md`. Não resumir, não corrigir.
- Pôr as tags no cabeçalho; linha da demanda no índice geral e nas tags dela em `TAGS.md`.
- Demanda pequena (uma etapa, sem banco, sem tela): pode ficar tudo num `README.md` só.

### 4.2 Snapshot antes (obrigatório antes de iniciar)

Antes de discutir solução, desenhar ou codar, tirar a foto do estado atual a partir de [`_moldes/snapshot.md`](_moldes/snapshot.md), em `snapshots/AAAA-MM-DD-antes.md`.

- **Por quê:** dor e causas se apoiam em fatos, não em memória; no fim, antes × depois prova o que mudou.
- **O que tem:** resumo em tópicos; **números que medem o problema**, com a consulta ou o comando que os produz (para repetir depois); exemplos reais (o caso concreto, com IDs); como funciona hoje (banco, código, telas), com caminho de arquivo e nome de tabela; riscos achados no caminho; fontes (branch, data do dump, arquivo de desenho).
- **Só leitura e congelado:** tirar o snapshot não altera código, banco nem desenho; depois de pronto não é editado. Estado mudou no meio → snapshot novo, com data.
- Demanda só de documento pode ter um snapshot curto dentro do `README.md`.
- **Snapshot depois** (no fechamento): mesma estrutura, mesmos números, medidos do mesmo jeito, com a coluna "antes" ao lado.

### 4.3 Dor (o foco)

Uma solução sem dor declarada não entra. Escrever cada dor como **quem sofre + o que acontece + por que é ruim** e numerar (`D1`, `D2`…). Exemplo: "O jogador busca um jogo e vê três cards iguais; não sabe qual abrir e às vezes abre um que não funciona."

### 4.4 Causas

- Para cada dor, as causas (`C1`, `C2`…). Uma causa pode servir a várias dores.
- **Fato** (onde foi visto: arquivo, tabela, tela) ou **hipótese** (a confirmar, e como).
- Só se propõe solução para causa. A tabela "dor → causa → onde aplicar a solução" mostra onde mexer e o que resolve o quê.

### 4.5 Já existe? (antes de propor solução)

Mesma regra do passo "checar o que já existe" do `po-techlead-scrum`: não pedir para criar o que já existe.

1. Abrir em `TAGS.md` as tags da demanda e ler o que as demandas antigas decidiram e deixaram.
2. Olhar o catálogo de reaproveitamento do índice geral.
3. Procurar no código (serviço, tabela, componente, comando).
4. Achou → reaproveitar ou ajustar, dizendo onde está. Não achou → segue.

### 4.6 Impactos (sempre antes de mexer)

Antes de propor ou executar, perguntar: **"se eu mudar isto, o que mais muda?"** O projeto mantém a **lista de áreas** dele (nas regras do projeto ou no `docs/`). Lista mínima genérica:

| Área | Pergunta |
|------|----------|
| Cada front (site, app, painéis, forks de cliente) | Muda listagem, busca, URL, página, histórico do usuário? A mudança chega aos forks? |
| Cálculo de dinheiro | Muda saldo, depósito, saque, comissão, custo de fornecedor? |
| Métricas | A fórmula de alguma entrada do dicionário de métricas muda? |
| Banco | Migration em todos os repos que usam a coluna? Dado antigo precisa ser convertido? |
| Integrações | O que muda no serviço que fala com o mundo de fora? |
| Multi-tenant | Vale para todos os clientes/casas? Cada um configura diferente? |
| Operação | Quem opera precisa de nova tela, novo hábito, treino? |

Impacto vira linha na tabela de impactos da demanda, com o que fazer a respeito.

### 4.7 Decisões

- Toda decisão do dono entra na tabela de decisões da demanda: data, decisão, motivo, quem decidiu.
- Correção do dono **troca o texto errado** pelo certo (sem "corrigido depois de…") **e** vira regra no lugar certo ([metodo-agentes.md](metodo-agentes.md) §4: geral → constituição/skill; do projeto → regras do projeto; fato → `docs/sistema/`).
- O que o agente concluiu sozinho fica marcado como "proposta" até o dono confirmar.

### 4.8 Etapas (plano antes, resultado depois)

Toda execução — levantamento, desenho, código, migration, teste — tem um arquivo de etapa a partir de [`_moldes/etapa.md`](_moldes/etapa.md), **escrito antes de começar**:

1. **Objetivo** — que dor/causa a etapa ataca.
2. **Como vai ser feito** — passos.
3. **Resultado esperado** — o que tem de existir no fim, verificável.
4. **Pronto quando** — critério objetivo, com evidência ([metodo-agentes.md](metodo-agentes.md) §2).

Depois de executar, na mesma etapa:

5. **Resultado obtido** — com evidência (arquivo, print, saída de teste, link). Checkpoints ("feito até aqui") ao longo do trabalho, para outro agente poder retomar.
6. **Diferença do esperado** — e o porquê.
7. **Próximo passo**.
8. **Reaproveitamento** — o que a etapa deixou para outros casos e onde está.

Etapa nunca é apagada. Etapa abandonada fica com status "abandonada" e o motivo.

Quem executa: o controlador escreve 1–4 e chama um subagente com o cartão [`_moldes/tarefa-subagente.md`](_moldes/tarefa-subagente.md); o subagente preenche 5–8 ([metodo-agentes.md](metodo-agentes.md) §1).

### 4.9 Fechamento

- Snapshot depois.
- Status final na ficha da demanda e no índice geral.
- Pendências que sobraram: na demanda **e** no índice geral.
- Conhecimento que vale além da demanda → `docs/sistema/`.
- Regra nova → constituição (se geral) ou regras do projeto (se do projeto).
- **A cada resposta que mudou algo:** status e próximo passo atualizados na ficha da demanda e no índice geral.

### 4.10 Reaproveitamento

Toda demanda deixa peças que outras vão usar. Escrever **o que é, onde está e para quais casos futuros serve**.

| Tipo de peça | Exemplo |
|--------------|---------|
| Código | serviço, comando agendado, componente do DS, migration modelo |
| Dado / tabela | tabela global que outros sistemas podem ler |
| Padrão / regra | "cascata de prioridade", "conta de teste fica fora do dinheiro" |
| Levantamento | mapa do estado atual de uma área (vira `docs/sistema/`) |
| Desenho | tela ou componente que serve para outra tela |
| Lição | o que deu errado e como evitar |

- Cada etapa diz o que dela pode ser reaproveitado (seção 8).
- A demanda junta tudo na seção **Reaproveitamento**; as peças principais ganham linha no catálogo do índice geral.
- Pensar nisso **ao planejar**: se a peça pode servir a outros casos sem custo extra, a etapa diz no "como vai ser feito".

## 5. Tags

Servem para achar tudo o que já foi feito sobre um assunto, mesmo espalhado em demandas diferentes.

- Formato `#minusculo-com-hifen`, na linha **Tags** do cabeçalho da demanda (e de cada arquivo de `docs/sistema/`).
- Três grupos, pelo menos uma de cada quando fizer sentido: **sistema** (onde mexe: `#site`, `#painel`, `#api`…), **assunto** (do que trata: `#pagamentos`, `#comissao`…), **tipo** (que trabalho é: `#tela`, `#integracao`, `#migration`, `#bug`, `#documentacao`).
- **Usar tag que já existe.** Tag nova entra no `TAGS.md` do projeto **primeiro**, com o significado (um assunto, um nome); a demanda entra na linha da tag.
- O **vocabulário** é do projeto; o **mecanismo** é este.
- Buscar: `grep -rl "#pagamentos" docs/`.

## 6. Status possíveis

| Status | Significa |
|--------|-----------|
| aberta | registrada, ainda sem levantamento |
| em levantamento | entendendo o estado atual e as causas |
| em definição | regras, telas e métricas sendo decididas (só docs e desenho, sem código) |
| aguardando aprovação | esperando o dono decidir |
| em execução | o dono disse "pode codar" (ou equivalente) e o trabalho está sendo feito |
| validação local | código pronto no ambiente de desenvolvimento, esperando o dono testar |
| concluída | entregue e validada |
| pausada / abandonada | com o motivo escrito |

## 7. Leis de escrita

- **Português claro.** Termo técnico na primeira vez com explicação, ou no dicionário da demanda ([tom-professor.md](tom-professor.md)).
- **Teste do estranho:** quem nunca viu a conversa entende o arquivo sozinho?
- **Confirmado · Hipótese · Aberto** sempre separados.
- **Mesmo fato, mesmo nome** em todos os arquivos. Renomeou → varrer `docs/`.
- **Datas absolutas** (2026-10-20), nunca "ontem" ou "semana que vem".
- **Sem resíduo de conversa** ("como falamos", "o usuário corrigiu"). A frase certa substitui a errada.
- **Evidência no resultado:** caminho do arquivo, nome da tabela, print, saída de comando.
- **Credencial nunca** em `docs/` nem no git: na demanda, só o nome do serviço e onde a credencial está guardada.

## 8. Quando a demanda vira tarefa para um dev

Usar a skill `po-techlead-scrum` a partir da pasta da demanda: ela lê a ficha, as decisões e o snapshot e escreve a tarefa.
