# Modelo-alvo — Fase 8 Telas

> Vivo: `.docs/telas.md` (índice + gate) + telas oficiais no canvas + relatórios do Apply  
> Ferramenta: skill **`design-system-apply`** (varredura, correção, re-Scan) · Sequência: [`playbook.md`](playbook.md) deste módulo (conferência com o gosto uma vez; por tela: OK do cliente → Apply na tela → novo OK se mudou)

## Fontes reais (anexadas)

| Arquivo | O que é | O que extrair |
|---------|---------|----------------|
| [`examples/anexos/buscai-telas.pen`](examples/anexos/buscai-telas.pen) | Canvas real com 13 telas de um produto (site no computador + popup de extensão), tema escuro, junto das pranchas do Design System | Uma prancha por tela com nome humano e superfície no nome; nenhuma cor digitada; estados numa prancha própria; extensão no tamanho real |
| [`examples/anexos/buscai-home-sem-login-computador-escuro.png`](examples/anexos/buscai-home-sem-login-computador-escuro.png) · [`buscai-home-logado-computador-escuro.png`](examples/anexos/buscai-home-logado-computador-escuro.png) | Imagem das duas Homes do arquivo acima (site no computador, tema escuro) | Nível visual esperado da primeira tela da fase: hierarquia, densidade, ritmo das seções |
| [`../07-design-system/examples/anexos/bateubet-design-system-estrutura.md`](../07-design-system/examples/anexos/bateubet-design-system-estrutura.md) (o PDF, 37 MB, fica fora do pacote — pedir ao humano se precisar das imagens) | Deck de Design System real — slide 43 “Tudo junto na prática” | Tela real montada **só** com tokens e componentes do guia = a barra da tela-prova |
| [`../07-design-system/examples/anexos/polaris-multi-surface.md`](../07-design-system/examples/anexos/polaris-multi-surface.md) | Shopify Polaris — várias superfícies, um sistema | Cada superfície (site, popup de extensão, celular) com seu tamanho e subconjunto de peças |

Formato do relatório de cada rodada: `design-system-apply/report-template.md` (régua do processo, não exemplo de produto). A lista de telas, o OK do cliente e o resultado do Apply por tela ficam em `.docs/telas.md`, não no relatório do Apply.

## Mínimos que os modelos reais exigem

1. Tela montada só com peças do sistema — cópias ligadas aos componentes, sem cor digitada nem peça solta.  
2. Cada superfície no tamanho real.  
3. Estados de tela visíveis (vazio, carregando, erro), não só o caminho feliz.  
4. O que a tela revelou de falta volta para o sistema, não vira exceção na tela.

## Nosso modelo-alvo (`.docs/telas.md`)

1. Dicionário (tela-prova, tema principal, lista de telas, peça ligada ao componente, conferência do Apply, telas alinhadas, mini-A traduzida, superfície)  
2. Onde estão as telas (arquivo de canvas + nome da área oficial)  
3. Lista de telas — uma linha por tela: ordem em que foi feita, nome humano, superfície e tamanhos, ação (montar · corrigir), conteúdo vem de, essencial (sim/não), OK do cliente (data), Apply sem pendência (relatório)  
4. Estados de tela — uma linha por estado do protótipo: coberto em qual tela ou pendente  
5. Versões do Design System geradas nesta fase (versão, o que entrou, motivo, tela que revelou)  
6. Diferenças para os devs (resumo + link), se já existe código ou construtor  
7. Confirmado · Hipótese · Aberto · Gate

## Critérios de aceitação

| # | CA | Barra |
|---|-----|--------|
| T1 | Dicionário no topo | Termos da skill Apply traduzidos (ALIGNED, mini-A, re-Scan) |
| T2 | Lista de telas cobre **todas** as telas do protótipo | Nome humano; ação montar/corrigir; superfície e tamanhos |
| T3 | Tela 1 = Home no tema principal, aprovada **antes** das demais | Site: computador (celular só se o cliente pedir); extensão/app: tamanho real |
| T4 | Cada tela essencial com OK do cliente **e** Apply sem pendência, uma por vez | Data do OK + relatório por linha; correção do Apply mostrada de novo ao cliente; “em lote” só com pedido explícito do cliente, ciclo completo e relatório por tela |
| T5 | Telas só com peças oficiais | Cópias **ligadas** aos componentes do canvas + variáveis; falta resolvida por mini-A, não por peça solta |
| T6 | Toda mudança no DS nesta fase = nova versão com motivo | Tabela de versões do `DESIGN_SYSTEM.md` + seção em `telas.md` |
| T7 | Estados do protótipo cobertos ou pendentes por escrito | Vazio, carregando, erro, sem resultado, sem saldo… |
| T8 | Telas batem com protótipo, MVP e contrato | Nada novo sem eco → confirma; dado mostrado existe no contrato |
| T9 | Onde estão as telas + relatórios linkados | Arquivo de canvas, área oficial, relatórios `…-rN` |
| T10 | Gate gravado | fechado · adiado com risco · bloqueado |
| T11 | Propagação feita | Tudo que as telas revelaram (tela, estado, dado, regra) está também em `prototipo.md`, `mvp.md` e `contrato.md` |
| T12 | Canvas protegido | Cópias com data em `copias/` por rodada; prints “depois” da versão aprovada de cada tela |
| T13 | Texto de tela e valores de exemplo | Texto de tela no teste do leigo; nenhum placeholder “X”; valores fictícios aprovados e iguais em todas as telas |
| **T.CL** | **CL0–CL5** — `shared/docs-clarity.md` | Sem jargão do Apply cru; sem meta de chat |

## Anti-padrões (Telas)

| Anti-padrão | Sintoma |
|-------------|---------|
| Telas em lote | Agente entrega 6 telas novas de uma vez “para o cliente ver tudo”, sem o cliente ter pedido lote |
| Decisão presa em `telas.md` | Tela ganha vitrine, estado ou dado novo e o protótipo, o MVP e o contrato não sabem (a Revisão do piloto corrigiu 3 fases por isso) |
| Canvas sem cópia | Editar sem cópia com data; arquivo aberto em duas janelas sobrescreve o trabalho com a versão antiga |
| Conferir mockup | Apontar que o mesmo produto de exemplo tem preço diferente em duas telas |
| Placeholder na tela | “X créditos”, “R$ X”, “Lorem ipsum” numa tela levada para aprovação |
| Jargão no texto de tela | “Quer melhor ranking?” num texto para o público geral |
| Pular a Home | Começa por tela secundária; margens e pontos de quebra nunca conferidos |
| Tela desenhada à parte | Usa as variáveis, mas as peças não são cópias ligadas aos componentes — mudar o componente não muda a tela |
| Superfície fora do combinado | Tela num tamanho que o cliente não pediu (ex.: celular sem pedido) ou extensão esticada para computador |
| Apply pulado ou fora de hora | Próxima tela sem rodar o Apply na anterior; Apply antes do OK do cliente; correção do Apply sem novo OK |
| Remendo só na tela | Cor digitada / peça solta / componente novo sem entrar no DS |
| Tela inventada | Bloco ou funcionalidade que não está no protótipo nem foi confirmado |
| Tela pronta = aprovada | Telas feitas fora do fluxo tratadas como aprovadas sem passar pela sequência |
| Reabrir a Fase 7 | Mudança de DS tratada como nova rodada do Forge em vez de versão registrada |
| Varredura inventada | OK sem print desta sessão |
| Jargão cru no documento | “ALIGNED”, “mini-A”, “AP-GRID-HOLE” sem tradução em `telas.md` |
| Meta de chat / abreviação | `qtd.`, “não inventar”, “cliente corrigiu” |
