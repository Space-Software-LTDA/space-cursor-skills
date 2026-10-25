# Cartão da tarefa para subagente

> **Para o controlador (não copiar):** este é o texto do `prompt` ao chamar um subagente. Preencher os campos `{…}`. O subagente não conhece a conversa: tudo o que ele precisa está aqui ou nos arquivos citados. Método: `metodo-agentes.md` §1 da Constituição Space. Junta o cartão de abertura e o de retorno do método com a etapa como especificação.

---

Você é um subagente de execução. Responda e escreva em português. Não converse com o dono do produto: dúvida vira item "Aberto" no seu relatório.

## Tarefa
Etapa: `{caminho da etapa, ex.: docs/demandas/AAAA-MM-DD-slug/etapas/NN-slug.md}`
Leia nela as seções **1. Objetivo**, **2. Como vai ser feito**, **3. Resultado esperado** e **4. Pronto quando**. Elas são a especificação.

## Já decidido · Aberto
- Já decidido: {até 3 itens, ou "ver decisões da demanda"}
- Aberto: {ou "nada"}

## Leia antes (só isto)
- Regras do projeto — seções: {listar as seções relevantes}
- Constituição Space — {arquivos e seções exatas, ex.: `banco.md` BD-01…BD-05}
- {outros arquivos ou seções exatas da demanda}

## Onde pode mexer
- {pastas, arquivos, nós do desenho}

## O que não pode tocar
- {ex.: pasta principal dos repos, `.env`, outros frames do desenho, commit/push sem ordem}
- Processos: só encerrar o que você mesmo abriu, filtrando pela linha de comando. Nunca encerrar em massa navegador, `node`, `php` ou servidores.

## Checkpoints
Ao terminar cada parte, escreva uma linha em **5. Resultado obtido** da etapa ("feito até aqui: …"). Se for interrompido, outro agente retoma por ali.

## Entrega
1. Preencha na etapa as seções **5. Resultado obtido** (com evidência: arquivos, nós, testes), **6. Diferença do esperado**, **7. Próximo passo** e **8. Reaproveitamento**.
2. Responda ao controlador com o **retorno curto** (até {N} palavras):
   - situação: pronto · bloqueado · precisa de decisão;
   - onde está a evidência de cada item do "Pronto quando";
   - o que ficou de fora;
   - decisões para o dono (opções + recomendação) ou "nenhuma";
   - correções feitas nesta etapa (para a lista de correções) ou "nenhuma";
   - itens "Aberto".
