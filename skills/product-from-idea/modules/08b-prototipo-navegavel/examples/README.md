# Exemplos — Fase 8.5 Protótipo navegável

> Caso **real** (piloto em que o molde nasceu). O protótipo vivo do produto fica em `prototipo/` no workspace, não nestes arquivos.  
> Barra (critérios + anti-padrões): [`../target-model.md`](../target-model.md) · Molde: [`../molde/`](../molde/)

## Ler primeiro

| Documento | Papel |
|-----------|-------|
| [`../target-model.md`](../target-model.md) | O que o protótipo e o registro em `telas.md` precisam ter |
| [`../playbook.md`](../playbook.md) | Passo a passo, atualização e armadilhas |

## A — O que a fase preenche (obrigatório abrir)

| Anexo | O que é | O que extrair |
|-------|---------|----------------|
| [`anexos/pixreals-screens.js`](anexos/pixreals-screens.js) | Manifesto de um site de cassino: 68 telas (computador 1440 + celular 390) + 5 páginas de documentação, em 11 grupos | `PR_CONFIG` completo (destaque = cor do DS, abertura no Manual, Home deslogado/logado por dispositivo, 404 só pela lista); grupos na ordem do canvas; títulos curtos; tela de trás em todo modal/gaveta/menu; gêmea computador ⇄ celular; `" *"` em tela que ainda não existe no produto |
| [`anexos/pixreals-rotas.js`](anexos/pixreals-rotas.js) | Rotas do mesmo produto | A maioria por **texto**; por **nome** só header (logo, menu, busca, saldo, conta), navegação inferior, cards, abas, botões só-ícone; `"toast:…"` para copiar código/link e reenviar e-mail; regras que dependem da tela (`S.id`) — “Entrar” do botão principal × da aba; “Voltar” de cada tela no celular; 2 telas “gerando” que avançam sozinhas |
| [`anexos/pixreals-verificar.txt`](anexos/pixreals-verificar.txt) | Saída real do `verificar` para 6 telas típicas (Home, Login, popup do jogo, PIX, Minha conta no celular, Promoções no celular) + resumo | Como fica uma tela pronta: o fundo escurecido e o X voltando para a tela de trás, o header e a navegação ligados, nada atrás do modal |

## B — Defeitos que a conferência visual pegou (o que não pode aparecer)

| Anexo | Defeito | Causa | Onde ficou resolvido |
|-------|---------|-------|----------------------|
| [`anexos/pixreals-defeito-scroll-horizontal.png`](anexos/pixreals-defeito-scroll-horizontal.png) | Barra de rolagem horizontal na tela do computador | A barra vertical dentro da tela come ~15px dos 1440 | Motor (`nav.js`) esconde as barras e trava o eixo X |
| [`anexos/pixreals-defeito-botao-cortado.png`](anexos/pixreals-defeito-botao-cortado.png) | Botão de tela cheia cortado na borda da barra do jogo | Export do canvas com `box-sizing: content-box` (padding somado por fora) — afetava 31 telas | `scripts/preparar.mjs` troca por `box-border` |
| [`anexos/pixreals-defeito-menu-lateral.png`](anexos/pixreals-defeito-menu-lateral.png) | ☰ escondia a lista e a tela sumia junto | Grade do shell ficava com coluna de 0px | `index.html` do molde |

## Proibido

- Copiar ids, textos, cores ou nomes deste produto para outro — só a estrutura.  
- Fabricar “exemplo ilustrativo” de manifesto ou rotas.
