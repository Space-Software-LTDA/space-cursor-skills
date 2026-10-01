# Método de execução das skills Space

> Vale para **todas** as skills do pack. Cada skill aplica este método às próprias etapas (seção **“Método de execução”** do `SKILL.md`) — sem copiar este texto.  
> Origem: piloto de criação de produto (setembro de 2026), em que estas quatro práticas foram as que mais seguraram a qualidade.

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
| **Repositório de código** (PO, QA, contexto, Apply num produto existente) | Só o arquivo `ANCORA.md` dentro da pasta de artefatos (`.task/{projeto}/` ou `.docs/{skill}/`), já fora do git. **Proibido** escrever no `AGENTS.md` do repositório ou criar regra sempre ativa nele |

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
