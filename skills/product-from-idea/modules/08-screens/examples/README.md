# Exemplos — Fase 8 Telas

> Casos **reais**. Documento vivo do produto: `docs/telas.md` + telas no canvas (não estes arquivos).  
> Barra (estrutura + critérios de aceite + anti-padrões): [`../target-model.md`](../target-model.md)

## Ler primeiro

| Documento | Papel |
|-----------|-------|
| [`../target-model.md`](../target-model.md) | O que o `telas.md` e as telas precisam ter |
| [`../playbook.md`](../playbook.md) | Sequência da fase (Home primeiro, uma tela por vez com OK) |

## Como abrir um `.pen`

Mesmo método da Fase 7: [`../../07-design-system/examples/README.md`](../../07-design-system/examples/README.md#como-abrir-um-pen) — por prancha, pelo Pencil (preferido) ou lendo o JSON por partes. Para conferir se uma tela usa peças ligadas aos componentes, contar os nós `"type": "ref"` dentro da prancha da tela (zero = peças desenhadas à parte).

## A — Saída da fase (obrigatório abrir)

| Anexo | O que é |
|-------|---------|
| [`anexos/buscai-telas.pen`](anexos/buscai-telas.pen) | Canvas real com as telas de um produto (site + extensão de navegador), tema escuro, montadas a partir do Design System que está no mesmo arquivo |
| [`anexos/buscai-home-sem-login-computador-escuro.png`](anexos/buscai-home-sem-login-computador-escuro.png) | Imagem da tela **Home sem login**, site no computador, tema escuro |
| [`anexos/buscai-home-logado-computador-escuro.png`](anexos/buscai-home-logado-computador-escuro.png) | Imagem da tela **Home logado**, site no computador, tema escuro |

As duas Homes mostram o nível esperado da primeira tela da fase (a Home). As demais telas existem só no `.pen`.

Telas do arquivo (nome humano, superfície):

| Tela | Superfície |
|------|------------|
| Home sem login | site, computador 1440 |
| Home logado | site, computador 1440 |
| Início de busca | site, computador 1440 |
| Busca instantânea | site, computador 1440 |
| Tela da pesquisa | site, computador 1440 |
| Resultado da busca nos produtos | site, computador 1440 |
| Produto da vitrine | site, computador 1440 |
| Minhas pesquisas | site, computador 1440 |
| Créditos de IA | site, computador 1440 |
| Minha conta | site, computador 1440 |
| Entrar, criar conta e recuperar senha | site, computador 1440 |
| Estados do site (vazio, carregando, erro…) | site, computador 1440 |
| Extensão | popup da extensão, 360 de largura |

O arquivo também traz as pranchas do Design System (Manual da marca, Fundamentos, Componentes) — são a base das telas, não telas.

O que extrair:

- Toda tela com **nome humano**, uma prancha por tela, superfície e tamanho no nome.  
- Nenhuma cor digitada nas telas: tudo por variável do Design System.  
- **Estados** numa prancha própria, não esquecidos.  
- A extensão no **tamanho real** do popup, não esticada para computador.  
- As imagens de dentro do `.pen` apontam para uma pasta local da máquina de origem e não abrem aqui; para ver as Homes, usar os PNG acima.

O que **não** copiar deste arquivo (fica abaixo da barra da fase):

- Neste anexo, as telas foram copiadas do canvas original sem os componentes; por isso as peças aparecem soltas (zero cópias ligadas). Não tomar isso como modelo: na fase 8, toda peça é cópia ligada ao componente oficial.

## B — Referência de apoio (pasta da Fase 7)

| Anexo | Para quê |
|-------|----------|
| Deck BateuBet — slide 43 “Tudo junto na prática”: índice em [`bateubet-design-system-estrutura.md`](../../07-design-system/examples/anexos/bateubet-design-system-estrutura.md) (o PDF, 37 MB, fica fora do pacote — pedir ao humano se precisar das imagens) | Uma tela real montada só com o guia |
| Shopify Polaris — superfícies: [`polaris-multi-surface.md`](../../07-design-system/examples/anexos/polaris-multi-surface.md) | Cada superfície com tamanho e peças próprias |

## Proibido

- Colar cores, logo, textos ou nome buscaí em outro produto — só a estrutura.  
- Fabricar “exemplo ilustrativo” de `telas.md`.
