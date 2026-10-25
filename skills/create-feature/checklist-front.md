# Checklist de front — create-feature

> Ponteiros, não regras: cada item diz **onde** a regra mora. Marcar com evidência (Parte A: nó/ID do canvas · Parte B: `arquivo:linha` · Parte C: print). Item que não se aplica → "não se aplica" + motivo.  
> **Ordem de verdade visual** (não inverter): marca e DS do produto → [`../docs/ui-gosto.md`](../docs/ui-gosto.md) → [`../docs/design-system.md`](../docs/design-system.md) → mock só para campos e ações ([`../docs/ui-gosto.md`](../docs/ui-gosto.md) §0 "Prioridade de verdade"; [`../docs/frontend.md`](../docs/frontend.md) "Prioridade visual"). Quando o DS do produto ou as regras do projeto fixam um valor (canto, peso de fonte, linhas por página), ele vence o número genérico daqui. Entre `ui-gosto.md` e `design-system.md`, vale `ui-gosto.md` (§0 "Prioridade de verdade").

## Parte A — Desenho (Fase 5)

| # | Item | Onde está a regra |
|---|------|-------------------|
| A1 | Componente do DS do produto instanciado; criado só o que não existe, como componente do DS | `ui-gosto.md` §0.1 item 4 |
| A2 | Versão antiga no rascunho (frame de topo); nova = cópia melhorada | `ui-gosto.md` §0.1 item 5 |
| A3 | Um exemplo por componente repetido + tabela de casos na demanda | `ui-gosto.md` §0.1 item 6 |
| A4 | Todo popup desenhado, inclusive item de menu ⋮ | `ui-gosto.md` §0.1 item 7 |
| A5 | Cores só por variável; superfícies em degraus; primária rara | `ui-gosto.md` §3.1–§3.4 · `design-system.md` §3 |
| A6 | Multi-cliente: tudo que é marca deriva da primária; tema trocado sem sobra | `ui-gosto.md` §3.5 |
| A7 | Tipografia na escala; pesos permitidos; hierarquia de card | `design-system.md` §4 · `ui-gosto.md` §4 |
| A8 | Espaçamento na escala de 4 | `design-system.md` §6 "Escala de spacing" |
| A9 | Cantos: controle, card, modal | DS do produto · `ui-gosto.md` §8.1 · `design-system.md` §5. Padrão Space: controle 8, card 12, modal 16 (decisão do usuário, 2026-10-25); o DS do produto pode ter outra escala (exceção registrada nas regras do projeto) |
| A10 | Bordas 1 px do token; seleção por borda primária ou fundo suave, nunca brilho | `ui-gosto.md` §6.5, §8.2, §8.3, G6–G7 · `design-system.md` §7 |
| A11 | Botão pelo significado; um Primário por seção | `ui-gosto.md` §6.7 · `design-system.md` §10.1 |
| A12 | Badge = ícone + texto; chip = selecionável; toast × alerta | `ui-gosto.md` §6.8 · `design-system.md` §9 |
| A13 | Ícone e selo na linha do título | `ui-gosto.md` §6.6 · `design-system.md` §8 |
| A14 | Estados desenhados: carregando (skeleton no formato), vazio, erro | `design-system.md` §16 · `ui-gosto.md` §7.3 |
| A15 | Datas de transação pelo evento, nunca a data de atualização genérica | `ui-gosto.md` §6.9 |
| A16 | Painel admin: estrutura de tela | `ui-gosto.md` §11.2 "Estrutura de tela de admin" (`GP-SAVE-TOP` … `GP-LESS-TEXT`) e "Anti-padrões" |
| A17 | Tabela de admin | `ui-gosto.md` §11.2 (`GP-TABLE-*`, `GP-FILTER-ALL`, `GP-COLUMN-PICKER`, `GP-ROW-CLICK`) · `design-system.md` §11. Linhas por página: 10 · 25 · 50, padrão 10, nunca mais que 50 (`GP-TABLE-PAGESIZE`, igual ao `design-system.md` §11) |
| A18 | Rótulos e fórmulas de métrica iguais ao dicionário do projeto | `metodo-agentes.md` §6 "Métrica num dicionário só" |
| A19 | Sem glow, gradiente decorativo, neon, card dentro de card | `design-system.md` §18 · `ui-gosto.md` §12 |
| A20 | Tipo do produto: só as regras do tipo (cassino §11.1, admin §11.2) | `ui-gosto.md` §0 "Tipo de produto" |

## Parte B — Código (Fase 8)

| # | Item | Onde está a regra |
|---|------|-------------------|
| B1 | Partiu do que o canvas exporta; valores do DS vencem o padrão do framework | `ui-gosto.md` §0.1 item 9 |
| B2 | Um componente por padrão do desenho, alimentado pela tabela de casos | `ui-gosto.md` §0.1 item 6 · `padrao-ouro.md` GO-08 |
| B3 | Tokens/variáveis CSS, nenhum hex digitado; marca pela primária | `ui-gosto.md` §3.5 · `anti-padroes.md` AP-FE-08 |
| B4 | Só endpoint que existe; detalhe por `GET /:id`; paginação e filtro no servidor | `frontend.md` "Contrato com a API" · `anti-padroes.md` AP-FE-01…04 |
| B5 | HTTP e regra fora da view; permissão com guarda de rota | `frontend.md` "Onde mora o HTTP e a regra" · AP-FE-05…07 |
| B6 | Três estados com erro visível da API | `padrao-ouro.md` GO-11 · `anti-padroes.md` AP-FE-09, AP-FE-12 |
| B7 | Skeleton na hora do clique, sem atraso no indicador; um componente de skeleton por front | `ui-gosto.md` §7.4 |
| B8 | Lista lembra o estado: ordem, colunas e linhas por pessoa no servidor; filtros, aba e página na URL; busca nunca guardada | `ui-gosto.md` §7.5 (mecanismo do framework nas regras do projeto) |
| B9 | Data mostrada no fuso de quem vê; filtro de período convertido para UTC | `banco.md` BD-02 · `ui-gosto.md` §6.9 |
| B10 | Valor guardado em centavos, formatado só na exibição | `banco.md` BD-01 |
| B11 | Motion curto, `prefers-reduced-motion`, sem pulsar | `ui-gosto.md` §7.1–§7.2 · `design-system.md` §7 "Motion" |
| B12 | Acessibilidade: contraste AA, foco visível, rótulo associado, status não só por cor, nome acessível em botão só com ícone | `design-system.md` §17 |
| B13 | Sem URL, token ou id fixo; credencial fora do git | `anti-padroes.md` AP-FE-10, AP-SEC-01 · `padrao-ouro.md` GO-09 |
| B14 | Checklist de PR de front colado e marcado | `anti-padroes.md` "Checklist de PR — Frontend" |

## Parte C — Conferência (Fase 9)

| # | Item | Onde está a regra |
|---|------|-------------------|
| C1 | Print do navegador × PNG do canvas, mesma largura e tela, logado com quem vê todas as ações | `ui-gosto.md` §0.1 item 10 |
| C2 | Larguras 1280, 1536 e 1920 px CSS | `ui-gosto.md` §11.2 "Viewport de QA" (`GP-QA-3-WIDTHS`) |
| C3 | Posição de bloco, fonte (tamanho e peso), cantos, espaçamento, cor de botão, badge e switch iguais | `ui-gosto.md` §0.1 item 10 |
| C4 | Nenhuma tabela passa do card; texto longo com reticências e `title` | `ui-gosto.md` §11.2 `GP-TABLE-FIT` |
| C5 | Cada popup aberto e conferido; estados vazio, carregando e erro vistos | `ui-gosto.md` §0.1 item 7 · `design-system.md` §16 |
| C6 | Clique mostra skeleton na hora; voltar da edição devolve a lista como estava | `ui-gosto.md` §7.4–§7.5 |
| C7 | Checklist geral e do tipo do produto | `ui-gosto.md` §10 · §11.1.8 ou "Checklist admin" do §11.2 |

Caminhos curtos (`ui-gosto.md`, `banco.md`…) = `../docs/<arquivo>` na cópia sincronizada.
