# Método de execução das skills Space

> Vale para **todas** as skills do pack. Cada skill aplica este método às próprias etapas (seção **“Método de execução”** do `SKILL.md`) — sem copiar este texto.  
> Origem: piloto de criação de produto (setembro de 2026), em que estas quatro práticas foram as que mais seguraram a qualidade; ampliado em 2026-10-24 com as regras de execução de um projeto real (modelo pela tarefa, checkpoints, processos, roteamento de correção).  
> Fora das skills, o mesmo método vale para o trabalho do dia a dia num projeto: cada solicitação vira demanda ([metodo-demandas.md](metodo-demandas.md)) e cada etapa é executada por subagente com o cartão [`_moldes/tarefa-subagente.md`](_moldes/tarefa-subagente.md).

## Dicionário

| Termo | O que é |
|-------|---------|
| **Controlador** | O chat principal. Conduz as etapas, abre os subagentes, valida o que eles entregam e pede o OK do humano. Não faz o trabalho pesado da etapa |
| **Subagente** | Um agente novo, com contexto limpo, aberto para **uma** etapa (ou um item de uma etapa longa). Entrega o artefato e encerra |
| **Cartão** | O texto curto que o Controlador passa ao subagente ao abrir (e que o subagente devolve ao terminar). Substitui o histórico do chat |
| **Artefato** | O arquivo que a etapa produz (`.docs/…`, `.task/…`, canvas). É a verdade; o chat não é |
| **Pronto quando (DoD)** | O critério verificável de que a etapa terminou — com evidência (arquivo, print, linha), não opinião |
| **Revisor sem contexto** | Subagente novo que confere o artefato **sem** ter visto a conversa: recebe só o artefato, os critérios e as leis |
| **Lista de correções** | Tabela do que foi corrigido na sessão, com a causa e o que muda na skill |
| **Checkpoint** | Linha "feito até aqui: …" que o subagente grava no artefato (ou na etapa) ao terminar cada parte. Permite retomar se ele for interrompido |
| **Regras do projeto** | Arquivo de regras sempre ativo do repositório (ex.: `.claude/CLAUDE.md`, `AGENTS.md`), escrito pelo dono do repositório |

---

## 1. Controlador + um subagente por etapa

**Por quê:** conversa longa degrada o agente (contexto sujo, decisões esquecidas, gravação interrompida). Contexto limpo a cada etapa + verdade em arquivo resolve.

| Papel | Faz | Não faz |
|-------|-----|---------|
| **Controlador** | Declara a etapa; abre o subagente com o cartão; valida o artefato contra o “Pronto quando”; leva ao humano só as decisões dele; encerra o subagente; abre o próximo | Trabalho denso da etapa; misturar duas etapas no próprio contexto |
| **Subagente** | Lê o cartão e os arquivos indicados; executa só aquela etapa; grava o artefato; devolve o cartão de retorno | Continuar para a etapa seguinte; decidir pelo humano |

**Regras:**

1. **Ônibus = artefato em disco.** O próximo subagente lê o arquivo, nunca o histórico do anterior.  
2. **Etapa longa** (muitas telas, fatias, rotas, módulos): subagente novo **por item**, ou quando a conversa do subagente ficar longa. Não reaproveitar o mesmo por dias.  
3. **Paralelo** quando os itens são independentes (ex.: varrer várias telas, revisar vários arquivos). Decisões do humano continuam **uma por vez**.  
4. **Quando não precisa:** pedido de uma etapa só e curto (ex.: um sync, uma pergunta). O chat resolve direto.  
5. **Sem ferramenta de subagente:** um chat novo por etapa, colando o mesmo cartão.
6. **Modelo pela tarefa, sem tabela fixa:** quando a ferramenta deixar escolher o modelo, o Controlador escolhe **pela complexidade e pelo risco da tarefa**. Referência: varredura, leitura e troca mecânica → o mais leve; implementação e desenho seguindo regra escrita → intermediário; revisão de dinheiro, de regra de negócio ou caso ambíguo → o mais forte. Nomes de modelo mudam por ferramenta e por época: não fixar uma tabela de modelos em skill nem em regra de projeto.  
7. **Correção pequena** (1 ou 2 passos: um texto, um botão) o Controlador faz direto, sem abrir subagente — cada subagente relê tudo do zero e custaria mais.  
8. **O contexto do subagente são os documentos:** o artefato da etapa (objetivo, como, resultado esperado, pronto quando) + as seções exatas das regras e da constituição. Nunca a conversa.  
9. **Subagente não pergunta ao humano.** Dúvida volta como "Aberto" no cartão de retorno; o Controlador decide ou pergunta.  
10. **Checkpoints e retomada:** o subagente grava um checkpoint ao terminar cada parte. Subagente interrompido (limite de uso, erro) é retomado pela ferramenta, quando ela permitir, ou um novo continua a partir do último checkpoint.  
11. **Paralelo só com fronteira clara:** dois subagentes nunca editam o mesmo arquivo; no canvas (Pencil, Figma), um editor por vez.  
12. **Processos:** o subagente só encerra processo que **ele mesmo** abriu, filtrando pela linha de comando (ex.: o diretório de perfil próprio do navegador automatizado). Proibido encerrar em massa (`taskkill`, `Stop-Process`, `pkill` geral de navegador, `node`, `php`): isso fecha o navegador do humano e os servidores locais. Caso real: 2026-10-21.

Em projeto com [método de demandas](metodo-demandas.md), o cartão é o molde [`_moldes/tarefa-subagente.md`](_moldes/tarefa-subagente.md): a etapa da demanda vira a especificação e o subagente preenche nela o resultado. Os dois cartões abaixo são a forma curta, usada pelas skills.

**Cartão de abertura (Controlador → subagente):**

```text
Você é o subagente da etapa {N — nome} da skill {skill}.
Objetivo: {1 linha}.
Artefato: {caminho} (criar do template se não existir)
Ler antes: {SKILL.md da skill} · {arquivos da etapa} · {exemplos reais da etapa} · ../docs/metodo-agentes.md
Já decidido: {3 bullets} | Aberto: {ou “nada”}
Pronto quando: {DoD da etapa, copiado da tabela da skill}
Ao terminar: devolver o cartão de retorno. Não seguir para a próxima etapa.
```

**Cartão de retorno (subagente → Controlador):**

```text
Etapa {N} — situação: pronto | bloqueado | precisa de decisão
Artefato: {caminho}
Evidência do “Pronto quando”: {onde está cada item}
Decisões para o humano: {opções + recomendação} | nenhuma
Correções feitas nesta etapa: {lista} | nenhuma
```

---

## 2. Etapas com “Pronto quando” e exemplos reais

**Por quê:** etapa sem critério de fim vira “parece bom”; exemplo inventado vira padrão inventado.

Toda skill tem, no `SKILL.md`, uma tabela de etapas:

| Coluna | O que vai |
|--------|-----------|
| Etapa | Nome humano da etapa |
| Subagente | Sim (qual) · Não (o próprio Controlador) |
| Entrega | O artefato e onde fica |
| Pronto quando | Critério verificável, com evidência |
| Exemplo real | Arquivo em `exemplos/` (caso real) ou “falta exemplo real” |
| Quem aprova | Humano · Controlador · Revisor |

**Regras:**

1. **Pronto quando verificável:** “arquivo X com seções A, B, C”, “print desta sessão de cada tela”, “PO respondeu ‘pode publicar’”. Proibido: “bem feito”, “completo”, “revisado”.  
2. **Exemplo real, nunca ilustrativo:** caso real de um produto (em `exemplos/`, com dado de cliente só lá) ou referência pública baixada. Sem exemplo real → escrever “falta exemplo real” na tabela; é pendência da skill, não licença para inventar.  
3. **Exemplo é de forma, não de conteúdo:** copiar a estrutura e a densidade, nunca o domínio do caso.  
4. **Anti-padrões da etapa** ficam ao lado (o erro típico que já aconteceu).

---

## 3. Revisor sem contexto

**Por quê:** quem fez o trabalho “aprova o próprio conserto” e entende o que um leitor de fora não entenderia. Um agente que nunca viu a conversa enxerga o que falta no artefato.

**Quando:** ao fim da skill (antes da entrega ao humano) e em etapas críticas que a skill marcar.

**Como:**

1. O Controlador abre um **subagente novo** e passa só: o artefato, os critérios (“Pronto quando” + critérios de aceite da skill), as leis da constituição que se aplicam e as evidências (prints, relatórios). **Nunca** o histórico do chat.  
2. **Duas passagens:** A — conteúdo (cada critério numa linha própria, com evidência de onde está); B — clareza (“um leitor de fora entenderia sem a conversa?”).  
3. **Proibido colapsar critérios** (`1–7 OK`). Uma linha por critério.  
4. **Busca residual com evidência:** procurar no artefato os erros típicos (recado de processo, abreviação, termo sem explicação, placeholder) e anotar o que achou ou “zero ocorrências”.  
5. **Visual se confere abrindo o print** (ou o canvas), não lendo a descrição.  
6. O revisor **lista** as correções; o Controlador decide com o humano o que aplicar. Revisão rasa (sem evidência por critério) → o Controlador devolve.

A re-conferência cega do `design-system-apply` (conferir de novo sem olhar a lista do que foi corrigido) é a mesma ideia aplicada a cada rodada.

---

## 4. Toda correção vira atualização da skill

**Por quê:** erro corrigido só na conversa volta na próxima vez. A skill aprende quando a correção é registrada nela.

**Gatilhos:** o humano corrigiu o agente · o revisor achou uma falha · o agente percebeu um erro próprio · o humano deu uma diretriz que vale além desta tarefa.

**Fluxo:**

1. **Na hora:** corrigir o artefato (troca limpa, sem nota de “corrigido”).  
2. **Ao fim da etapa ou da sessão:** montar a **lista de correções** no chat:

   | # | O que estava errado | Por que aconteceu (causa) | Correção no artefato | O que muda na skill |
   |---|--------------------|---------------------------|----------------------|---------------------|

3. **Chamar `/skill-update`** (fluxo “Registrar correção”): editar a skill no repo de forma **genérica**, registrar no `CORRECOES.md` da skill e rodar o sync.  
4. **Não vai para a skill:** dado do produto (preço, nome, ID) e preferência pontual do humano que não vale para outros produtos — fica no artefato.

**Para onde vai cada correção (roteador):**

| A correção é… | Vai para | Como |
|---------------|----------|------|
| Regra geral de trabalho (vale para qualquer projeto Space) | Esta constituição (`docs/`) ou a skill | `/skill-update`, de forma genérica; o caso do projeto pode entrar como exemplo curto |
| Regra que só vale num projeto, ou exceção do projeto à constituição | Regras do projeto (ex.: `.claude/CLAUDE.md`), na seção do assunto, como regra afirmativa | Edição direta pelo Controlador, com o motivo e a data |
| Fato de como o sistema funciona hoje | `docs/sistema/` do projeto | No fechamento da demanda |
| Decisão de uma demanda | Tabela de decisões da demanda | Na hora |

Na dúvida, geral, com a parte particular como exemplo. Correção geral presa nas regras de um projeto não chega aos outros (caso real, outubro de 2026: regras de banco e de tela de um projeto ficaram semanas só nele).  
5. Skill ainda em rascunho local (não promovida): o registro vai para o arquivo de lições do rascunho; ao promover, as lições viram regra.

---

## 5. Âncora no projeto (o agente não perde o papel)

**Por quê:** o conteúdo de uma skill entra na conversa uma vez, quando ela é chamada. Em conversa longa o histórico é resumido e as regras da skill podem sair do que o agente vê — ele esquece o papel, pula etapa, pergunta de novo o que já foi decidido. Regra sempre ativa e `AGENTS.md` são reinjetados a cada mensagem; o texto da skill, não.

**Regra:** ao ser chamada, a skill cria (ou atualiza) uma **âncora curta** no projeto. A âncora **aponta** para a skill — nunca copia as regras dela (cópia envelhece e vira segunda fonte da verdade).

```markdown
# Âncora — {skill}
Skill: {caminho do SKILL.md lido nesta máquina} (sync de {data})
Papel: {1 linha: o que faz e o que não faz}
Etapa atual: {etapa · item}
Verdade: {artefatos onde está o trabalho}
Leis duras: {3 a 5, em uma linha cada}
Próximo passo: {1 linha}
```

| Onde a skill roda | Onde fica a âncora |
|-------------------|--------------------|
| **Workspace dedicado** ao trabalho da skill (ex.: workspace de criação de produto) | Regra `.cursor/rules/{skill}.mdc` sempre ativa e curta + `AGENTS.md` curto, gerados do modelo da skill. A pasta inteira existe para aquilo |
| **Repositório de código** (PO, QA, contexto, Apply num produto existente) | Só o arquivo `ANCORA.md` dentro da pasta de artefatos (`.task/{projeto}/` ou `.docs/{skill}/`), já fora do git. **Proibido** a skill escrever no `AGENTS.md` do repositório ou criar regra sempre ativa nele |

A proibição é para a **âncora da skill**. As **regras do projeto**, escritas pelo dono do repositório (ex.: `.claude/CLAUDE.md`), podem e devem existir: guardam o que é do projeto e as exceções a esta constituição, e começam mandando ler a constituição. A skill não escreve nelas; correção de regra do projeto segue o roteador do §4.

**Uso:**

1. O Controlador lê a âncora no começo de cada etapa e, por ela, **relê o `SKILL.md` original** antes de agir.  
2. Ao fechar uma etapa, atualiza “Etapa atual” e “Próximo passo”.  
3. Ao terminar a skill, marca a âncora como concluída (não apaga — vira registro).  
4. Âncora com “sync de {data}” mais antiga que a skill instalada → reler a skill e regravar a âncora.

## 6. Leis comuns (curtas)

| Lei | Em uma frase |
|-----|--------------|
| Artefato é a verdade | O que não está gravado não está decidido |
| Eco → confirma → grava | Repetir em português claro o que entendeu e confirmar antes de gravar algo novo |
| Perguntar só o necessário | Decisão de produto ou de gosto sem regra → humano; o que uma regra escrita já responde → o agente resolve e informa |
| Propagação | Decisão nova que mexe num artefato anterior → atualizar o artefato dono na mesma rodada |
| Sem pressa | Ler o arquivo inteiro antes de editar; inspecionar **tudo** (todas as telas, todos os quadros), não uma amostra |
| Clareza para leigo | Termo técnico explicado na primeira vez; nada de recado de processo ou de conversa dentro do artefato |
| Nada apagado sem OK | Versão antiga vai para uma área de rascunho |
| Arquivo de trabalho protegido | Canvas e arquivos grandes: cópia com data antes e depois de cada rodada; um só editor aberto; conferir que o arquivo mudou no disco |
| Responder em português | Toda resposta, explicação, documento e comentário de script em português (pt-BR), desde a primeira mensagem |
| Ideia não é ordem | Quando o humano diz "mas passa", "já é opinião minha" ou comenta uma alternativa, é conversa: responder e perguntar se quer mudar. Não sair alterando |
| Impactos antes de mexer | Antes de propor ou executar, listar o que mais muda (cada front, dinheiro, métricas, banco, integrações, multi-tenant, operação). A lista de áreas é do projeto; o passo está em [metodo-demandas.md](metodo-demandas.md) §4.6 |
| Métrica num dicionário só | Antes de pôr métrica em tela ou relatório, procurar no dicionário de métricas do projeto: existe → mesmo nome e mesma fórmula; não existe → criar a entrada (nome, definição, fórmula, fonte, data) e só depois usar. Nada de dois nomes para a mesma coisa. Toda informação de uma página segue o filtro de período de cima, salvo valor "agora", sempre marcado |
| Plano aprovado mora no repositório | Dentro da demanda (`docs/demandas/…`), nunca só na pasta de planos da ferramenta |
| Bases de usuários nunca apagadas | Em qualquer limpeza (PC, servidor, pasta): arquivo com dado de usuário (dump, banco, planilha, CSV, JSON de base, ZIP de base, texto com e-mail ou telefone) é salvo e agrupado num lugar só, com a origem anotada, mesmo dentro de pasta marcada para apagar. Não copiar o conteúdo para o chat nem para docs: só nome, tamanho e tipo de dado |
| Marca do humano é dele | Em lista que o humano marcou, só preencher item em branco; conferir as marcas antes e depois de editar |
| Credencial fora do texto | Credencial nunca vai para o git, para `docs/` nem para o chat: só o nome do serviço e onde está guardada ([padrao-ouro.md](padrao-ouro.md) GO-09) |
