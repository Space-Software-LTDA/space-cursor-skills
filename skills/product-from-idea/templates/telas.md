# Telas — template

> Fase: 8 — Telas  
> Status: rascunho  
> Última atualização: YYYY-MM-DD  
> Âncoras: `.docs/prototipo.md` · `.docs/mvp.md` · `.docs/DESIGN_SYSTEM.md` · `.docs/contrato.md`  
> **Para o agente (não copiar para o arquivo final):** qualidade = `modules/08-screens/target-model.md` + anexos reais listados em `08-screens/examples/README.md`
---

## Dicionário

| Termo | O que é |
|-------|---------|
| **Tela** | Uma superfície que a pessoa vê, com nome humano (a mesma do protótipo) |
| **Canvas** | O arquivo de design onde as telas oficiais ficam desenhadas |
| **Tema principal** | O visual padrão do produto (normalmente escuro); o outro tema vem depois |
| **Tela-prova** | A primeira tela montada (normalmente a Home); mostra o que ainda falta no Design System |
| **Lista de telas** | Todas as telas do protótipo, com o que fazer em cada uma (montar ou corrigir) e o andamento |
| **Peça ligada ao componente** | Cópia de um componente oficial do canvas; se o componente muda, a tela muda junto |
| **Conferência do Design System** | A ferramenta que confere a tela contra o Design System e o gosto, depois que o cliente aprova a tela; o que ela acha é corrigido e mostrado de novo ao cliente |
| **Montar / corrigir** | Montar = a tela ainda não existe; corrigir = ela existe e precisa seguir o Design System |
| **Telas alinhadas** | Todas as telas seguindo o Design System, cada uma aprovada pelo cliente |
| **Nova versão do Design System** | Peça ou regra que uma tela revelou faltando e que entrou no documento do Design System, com motivo |
| **Superfície** | Onde a tela aparece e em que tamanho: site (computador; celular só se o cliente pedir), janela da extensão, app… |
| | |

---

## Onde estão as telas

| Item | Valor |
|------|-------|
| Arquivo de canvas | |
| Área oficial | |
| Área de rascunho | |
| Relatórios de cada rodada | `.docs/design-system-forge/QA_REPORTS/` |

## Conferência do Design System com o gosto

| Item | Valor |
|------|-------|
| Feita em | |
| Aprovada pelo cliente em | |
| Relatório | |

## Lista de telas

> Uma linha por tela do protótipo. A Home vem primeiro. Cada tela seguinte só começa depois do OK do cliente **e** da conferência do Design System sem pendência na anterior.

| Ordem | Tela | Superfície e tamanhos | Ação (montar · corrigir) | Conteúdo vem de | Essencial? | Aprovada pelo cliente em | Conferência do Design System (relatório) |
|-------|------|-----------------------|--------------------------|-----------------|------------|--------------------------|------------------------------------------|
| 1 | Home — tema principal | site: computador | | | sim | | |
| 2 | | | | | | | |

## Estados de tela

| Estado (do protótipo) | Em qual tela | Situação (aprovado · pendente) |
|-----------------------|--------------|--------------------------------|
| Vazio | | |
| Carregando | | |
| Erro | | |
| | | |

## Versões do Design System geradas nesta fase

| Versão | O que entrou | Motivo | Tela que revelou | Aprovada em |
|--------|--------------|--------|------------------|-------------|
| | | | | |

## Diferenças para os devs

> Só quando já existe tela em código ou num construtor de app. Detalhe em `.docs/design-system-forge/DIFERENCAS_PARA_DEVS.md`.

| Tela | Como está hoje | Como deve ficar (tela do canvas) | Prioridade |
|------|----------------|----------------------------------|------------|
| | | | |

## Protótipo navegável (Fase 8.5)

> Preenchida na Fase 8.5. O protótipo navegável é um site que roda no computador e mostra as telas aprovadas com os botões funcionando. Ele fica na pasta `prototipo/` do projeto (fora destes documentos).

| Item | Valor |
|------|-------|
| Como abrir | Na pasta principal do projeto, rodar `npm run prototipo:start` (sobe o site no próprio computador) e abrir http://localhost:4173 |
| Abre em | Manual da marca, com o botão “Iniciar protótipo” |
| Telas no protótipo | {n} no computador · {n} no celular · {n} páginas da marca e do Design System (Manual da marca, Fundamentos, Componentes, Rascunho) |
| Telas aprovadas que ficaram de fora | {tela — por quê} |
| Botões que mostram só um aviso (não há tela desenhada para eles) | {botão — aviso; ex.: “Copiar código” — aparece “Código copiado”} |
| Teste automático dos botões | {data} — nenhum botão leva a lugar errado e nenhuma tela ficou sem caminho |
| Conferência visual | {data} — fotos da tela (prints) em: {onde} |
| Versão do motor do protótipo (informação técnica) | {versão que aparece no rodapé da lista} |
| Atualizado pela última vez | {data — o que mudou} |

## Confirmado

-  

## Hipótese

-  

## Aberto

-  

## Decisão da fase (gate)

| Resultado | fechado / adiado com risco / bloqueado |
|-----------|----------------------------------------|
| Data | |
| Telas essenciais aprovadas | ___ de ___ |
| Pendências aceitas pelo cliente | |
