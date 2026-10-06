# Modelo-alvo — Fase 8.5 Protótipo navegável

> Vivo: `prototipo/` na raiz do workspace (fora do `docs/`) + seção “Protótipo navegável” em `docs/telas.md`  
> Molde: [`molde/`](molde/) · Sequência: [`playbook.md`](playbook.md)

## Fontes reais (anexadas)

| Arquivo | O que é | O que extrair |
|---------|---------|----------------|
| [`examples/anexos/pixreals-screens.js`](examples/anexos/pixreals-screens.js) | Manifesto real: 68 telas (computador + celular) + 5 páginas de documentação em 11 grupos | Grupos = seções do canvas; título curto; tela de trás de cada modal/gaveta; gêmea computador ⇄ celular; documentação primeiro |
| [`examples/anexos/pixreals-rotas.js`](examples/anexos/pixreals-rotas.js) | Rotas reais: ~80 regras por texto, regras por nome (header, navegação inferior, cards, abas) e 2 telas que avançam sozinhas | Maioria por texto; por nome só o que não tem texto; aviso para ação sem tela; regras que dependem da tela (`S.id`) |
| [`examples/anexos/pixreals-verificar.txt`](examples/anexos/pixreals-verificar.txt) | Saída real do `verificar` (resumo + áreas de telas típicas) | Como fica a lista de áreas de uma tela pronta: botão principal, fechar, clique fora, header, navegação |
| `examples/anexos/pixreals-defeito-*.png` | Prints reais de defeitos achados na conferência visual do piloto | O que a conferência visual precisa pegar (ver anti-padrões) |

## Mínimos

1. Abre no Manual da marca com “Iniciar protótipo”; documentação primeiro na lista.  
2. Toda tela aprovada da Fase 8 navegável, nos dispositivos aprovados.  
3. Cada botão faz o que o protótipo (`prototipo.md`) diz; ação sem tela = aviso.  
4. Modal/gaveta abre sobre a tela de trás (desenhada no canvas ou, na janela solta, montada pelo shell) e fecha para ela; troca de dispositivo cai na mesma tela.  
5. Zero link quebrado, zero tela isolada (fora as listadas), zero defeito visual do export.  
6. Sobe com um comando (`npm run prototipo:start`), sem passo manual.

## Nosso modelo-alvo (seção “Protótipo navegável” em `docs/telas.md`)

1. Onde está e como rodar (pasta, comando, porta)  
2. Telas cobertas: quantas por dispositivo + páginas de documentação; telas aprovadas que ficaram de fora e por quê  
3. Ações que viraram aviso (sem tela desenhada)  
4. Resultado do `verificar` (data) e da conferência visual (prints)  
5. Versão do molde usada  
6. Gate

## Critérios de aceitação

| # | CA | Barra |
|---|-----|--------|
| P1 | Molde intacto | Só `screens.js`, `rotas.js`, `telas/`, `images/` (e `package-lock.json`) são do produto; `prototipo:verificar -- --motor …` sem diferença |
| P2 | Fora do `docs/` | `prototipo/` na raiz; scripts `prototipo:*` no `package.json` da raiz |
| P3 | Abertura | Manual da marca + “Iniciar protótipo”; documentação (Manual, Fundamentos, Componentes, Rascunho) no topo da lista |
| P4 | Cobertura | Toda tela aprovada em `telas.md` está no manifesto, no grupo da sua seção, nos dispositivos aprovados |
| P5 | Navegação certa | Lista de áreas de cada tela bate com `prototipo.md`; nenhuma ida para tela “parecida”; ação sem tela = aviso |
| P6 | Verificar limpo | Nenhum destino inválido; toda tela alcançável (fora `semLinkChegando`); `--soltos` só com peça que leva à própria tela |
| P7 | Conferência visual | Checklist do passo 9 com prints desta sessão |
| P8 | Telas só exportadas | Nenhuma tela editada à mão no HTML; defeito de tela voltou para a Fase 8 |
| P9 | Registro + gate | Seção em `telas.md` + status em `docs/README.md` |
| **P.CL** | **CL0–CL5** — `shared/docs-clarity.md` | Registro em português de leigo (“aviso”, não “toast”; “tela de trás”, não “base”) |

## Anti-padrões

| Anti-padrão | Sintoma |
|-------------|---------|
| Scroll horizontal | Barra de rolagem embaixo da tela do computador (print real: `pixreals-defeito-scroll-horizontal.png`) |
| Peça vazando | Botão cortado na borda direita de uma barra (print real: `pixreals-defeito-botao-cortado.png`) — export com `content-box` sem `preparar` |
| Lista que derruba a tela | ☰ esconde a lista e a tela some junto (print real: `pixreals-defeito-menu-lateral.png`) |
| Protótipo em `docs/` | Pasta do protótipo dentro dos documentos do produto |
| HTML remendado | Tela consertada no arquivo exportado; o canvas continua errado e a próxima exportação desfaz |
| Motor customizado no produto | `nav.js`/`index.html` diferentes do molde sem passar pela skill |
| Link “parecido” | Botão leva a uma tela que não é a dele porque a certa não existe |
| Fundo clicável | Atrás do modal, header e cards ainda navegam |
| Janela isolada | O modal abre sozinho, sem a tela de trás (janela solta sem tela de trás no `screens.js`) |
| Sem Manual | Protótipo abre direto numa tela, sem a marca e sem “Iniciar” |
| Mostrado sem verificar | Cliente acha link quebrado na apresentação |
