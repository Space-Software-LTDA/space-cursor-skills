# Playbook — Fase 8 Telas

> Ferramenta = skill **`design-system-apply`** (conferência com o gosto, varredura, correção, re-conferência cega, relatórios). Este playbook **não** repete o método do Apply; ele define a **sequência** da fase 8, que vale por cima da ordem própria do Apply:
> - a Fase A do Apply (Design System × gosto) roda **uma vez**, antes da Home;
> - depois, **cada tela** passa por: montar ou corrigir → OK do cliente → **Apply só nessa tela** (varredura + correção) → novo OK se algo mudou → próxima tela;
> - o OK do cliente na tela autoriza a correção daquela tela (o Apply sozinho pediria a varredura de todas as telas antes de qualquer correção);
> - tela que ainda não existe é **montada** a partir do protótipo (o Apply sozinho só corrige telas existentes).  
> Barra: [`target-model.md`](target-model.md)

**Agent:** [`AGENT.md`](AGENT.md)

## Header

```text
**Fase 8 — Telas**
**Objetivo:** montar e aprovar as telas do produto no canvas, uma por vez, só com o Design System aprovado
**ON:** F2 + F6
**Skill:** design-system-apply (ferramenta)
```

## Pré-requisitos

- Fase 7 **fechada** (ou adiada com risco): `DESIGN_SYSTEM.md` com padrões de tela `P-…`, lista fechada de componentes e matriz de estados; canvas com manual da marca, variáveis e componentes oficiais  
- `prototipo.md` com telas de nome humano e estados; `mvp.md` com o que é essencial no dia 1; `setup.md` com as superfícies (site, extensão, app)  
- Canvas conectado (ver `design-system-forge/canvas-ferramentas.md`)  
- Sem isso → voltar à Fase 7 ou pedir a conexão; não montar tela no vazio

## Superfícies e tamanhos (lei)

| Superfície | Tamanhos obrigatórios |
|------------|-----------------------|
| Site | **computador**; celular só se o cliente pedir (registrado na lista de telas) |
| Extensão de navegador | tamanho real da janela da extensão |
| App | tamanho real do aparelho definido no setup |
| Superfície publicada por ferramenta pronta (portal de documentação, página de situação…) | layout da ferramenta |

**Ferramenta pronta (ver `setup.md`):** a superfície não é desenho livre. Na lista de telas e no ciclo, decide-se só conteúdo, ordem, logo e cores dentro do que a ferramenta permite; não montar layout próprio no canvas que a ferramenta não consegue reproduzir.

## Sequência (Controlador → subagente Telas)

### 0) Lista de telas

Gravar em `docs/telas.md` todas as telas do protótipo — nome humano, superfície e tamanho, essencial (sim/não) e situação hoje:

| Situação | Ação |
|----------|------|
| Não existe em lugar nenhum (caso normal logo após a Fase 7) | **montar** |
| Existe no canvas | **corrigir** |
| Existe só no site, na extensão ou num construtor de app | espelhar no Rascunho do canvas (o “antes”) → **corrigir** |

A lista serve para saber o que falta; não tem parada própria. A **Home** vem primeiro; a ordem das demais o cliente escolhe a cada tela aprovada.

### 1) Conferência do Design System com o gosto (uma vez)

Fase A do Apply: confronto do `DESIGN_SYSTEM.md` com `ui-gosto.md` (parte geral + tipo do produto). Só documento. **PARAR** → OK do cliente.

### 2) Ciclo de cada tela

```text
Tela da vez (a primeira é a Home, no tema principal)
  a. Montar ou corrigir — só peças ligadas aos componentes oficiais + variáveis
  b. Prints desta sessão (todos os tamanhos da superfície) → PARAR
     → cliente: aprova | pede ajuste (volta para a)
  c. Aprovada → rodar o Apply só nesta tela
     (varredura com prints + relatório …-rN)
  d. Apply achou algo → corrigir → re-conferência cega → prints
     → PARAR → novo OK do cliente (repetir c–d até o Apply não achar nada)
  e. Registrar em telas.md: data do OK do cliente + relatório do Apply sem pendência
     + propagar para prototipo.md / mvp.md / contrato.md o que a tela revelou de novo
  f. Próxima tela: cliente escolhe (sugestão: ordem de uso da pessoa no protótipo)
  g. Se o protótipo navegável já existe (Fase 8.5), reexportar a tela e atualizar
     (08b-prototipo-navegavel/playbook.md → “Atualizar o protótipo”)
```

**Proteção do canvas (toda rodada):**

1. Antes de editar: cópia com data em `{pasta do canvas}/copias/` (ex.: `produto-20260930-130142-antes-minha-conta.pen`).  
2. Um só editor aberto com o arquivo — duas janelas ou abas com o mesmo canvas podem gravar a versão antiga por cima.  
3. Depois de cada edição: conferir que o arquivo mudou no disco; se não mudou, parar e avisar.  
4. Ao fechar a rodada: nova cópia + prints “depois” da versão aprovada (é com eles que se refaz uma tela perdida).

**Conferência de conteúdo:** dados de exemplo (produto, preço, nota, data, foto) são mockup e não se conferem entre telas. Confere-se: peças oficiais, variáveis, regras do DS, texto cortado ou estourado, tamanho da superfície, o que o protótipo pede (bloco, campo, ação, estado) e o texto de tela no teste do leigo. Placeholder explícito (“X”) → valor fictício aprovado pelo cliente.

**Aprovação em lote (só se o cliente pedir):** cada tela passa por a–e sem parar no OK; o cliente aprova o lote de uma vez, olhando os prints de cada tela. Cada tela continua com relatório próprio; `telas.md` registra “aprovada em lote” com a data.

**Montar (tela que não existe):** cada bloco, campo, ação e texto sai do protótipo e do contrato; peças = cópias ligadas aos componentes oficiais do canvas (mudou o componente, muda na tela); cor, fonte e medida só por variável; posição e espaçamento pelo padrão de tela `P-…`. Não há espelho a fazer (não existe “antes”).

**Corrigir (tela que existe):** trocar peça desenhada à parte por cópia ligada ao componente oficial; cor ou medida digitada por variável; estrutura sem conserto → redesenhar (a versão antiga vai para o Rascunho).

**Falta peça ou regra** no meio de uma tela → mini-A: acrescentar no `DESIGN_SYSTEM.md` (nova versão + motivo) + componente no canvas → **PARAR** → OK → continuar a tela. Registrar a versão em `telas.md`.

### 3) Depois das telas essenciais

Estados de tela (vazio, carregando, erro, sem resultado…), janelas, segundo tema (se o Design System tiver) — cada um no **mesmo ciclo** do passo 2. Por último, conferência cruzada: a mesma coisa com a mesma medida em todas as telas.

Telas da expansão futura (só se estão no protótipo): mesmo ciclo, depois das essenciais, com marca visível de futuro na tela; ficam separadas em `telas.md` e não contam para o gate.

### 4) Gate de fase (produto)

No chat (Controlador):

| Resultado | Significado |
|-----------|-------------|
| **fechado** | Todas as telas essenciais aprovadas uma a uma, cada uma com o Apply sem pendência; estados cobertos |
| **adiado com risco** | Cliente aceita seguir com telas ou estados pendentes listados em `telas.md` |
| **bloqueado** | Tela essencial reprovada sem saída / DS sem peça crítica / canvas indisponível |

Atualizar `docs/README.md` status. Subagente **encerra**.

### 5) O que NÃO fazer

- Começar por outra tela que não a Home (salvo indicação do cliente)  
- Montar a tela seguinte antes do OK da anterior **e** do Apply sem pendência nela  
- Rodar o Apply antes do OK do cliente na tela, ou pular o Apply depois do OK  
- Corrigir o que o Apply achou e seguir sem mostrar de novo ao cliente  
- Montar versão de celular que o cliente não pediu, ou esticar a extensão para o tamanho de computador  
- Peça desenhada à parte em vez de cópia ligada ao componente oficial; componente novo sem mini-A  
- Tratar a mini-A como “reabrir a Fase 7” — é nova versão do DS, registrada aqui  
- Deixar decisão de produto revelada pela tela só em `telas.md` (sem propagar)  
- Editar o canvas sem cópia de segurança, ou com o arquivo aberto em mais de uma janela  
- Perguntar ao cliente o que o Design System já responde  
- Rodar a fase inteira num subagente só por dias — o Controlador abre um subagente novo por tela ou quando a conversa ficar longa  
- Abrir a Fase 9 (Revisão) na mesma thread

## Produto que já tem telas feitas fora do fluxo

Quando o cliente chega com telas prontas (feitas em outro chat, construtor ou canvas):

1. Lista de telas com a situação de cada uma (passo 0).  
2. Conferência do Design System com o gosto (passo 1).  
3. Cada tela pronta passa pelo **mesmo ciclo** (passo 2), começando pela Home, com ação **corrigir** — inclusive as que “já estavam prontas”. Tela pronta **não** é tela aprovada até passar pelo ciclo.  
4. Telas que faltam: ação **montar**, no mesmo ciclo.

## Fora de escopo (apontar)

| Pedido | Para |
|--------|------|
| “Cria o DS / muda a marca” | Fase 7 · `design-system-forge` |
| “Implementa a tela no código” | Devs (tarefas da Fase 11) |
| “Audita o staging” | `qa-space` |
| “Escreve a tarefa” | Fase 11 · `po-techlead-scrum` |
