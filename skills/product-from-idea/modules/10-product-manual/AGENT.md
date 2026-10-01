# AGENT — Fase 10 Manual comercial

Você é o subagente do **Manual comercial**. Uma fase só. Você **encerra** no gate.

## Objetivo (leigo)

Escrever o **manual comercial completo** do produto — a história inteira, em português claro, para **quem usa** e para **quem decide, vende ou investe**.  
Não é brief. Não é cópia dos documentos de fase. É **um documento só** que reúne tudo e explica e vende o produto.

## Saída

`.docs/{slug}.md`  
- `{slug}` = nome do produto em minúsculas, sem acento (ex.: “Meu Produto” → `meu-produto.md`)  
- Template: `templates/manual-produto.md`

**`produto.md`** = brief interno curto — **não** substitui este manual.

## Ler antes de gravar (ordem)

1. Este arquivo  
2. [`playbook.md`](playbook.md)  
3. [`target-model.md`](target-model.md)  
4. [`examples/density-reference.md`](examples/density-reference.md) + **pelo menos um** anexo real listado em [`examples/README.md`](examples/README.md)  
5. **[`../../shared/docs-clarity.md`](../../shared/docs-clarity.md)** — teste do estranho (obrigatório no manual)  
6. Todos os documentos de fase fechados: discovery → mercado → protótipo → MVP → contrato → setup → Design System → telas → revisão (+ `produto.md` só como índice)  
7. [`../../shared/controller/handoff.md`](../../shared/controller/handoff.md)

## Formações ligadas

F1 + F2 + F7 (+ F6 no gate)

## Regras fixas

- Tom **comercial** — documento que dá para **apresentar a um cliente** sem Cursor (`shared/docs-clarity.md`).  
- **Duas audiências** no mesmo arquivo: quem usa · quem decide, vende ou investe.  
- Estrutura = [`target-model.md`](target-model.md).  
- Cobrir os fatos das fases — sintetizado, não copiado.  
- No miolo (conceito, sem jargão no título): problema · escopo do dia 1 · solução · riscos conhecidos · o que o produto não é.  
- Pendências honestas em português claro (“ainda não definido”), **nunca** “A DEFINIR / TBD / qtd.”.  
- Imagem de tela = só print de tela aprovada na Fase 8.  
- Proibido inventar funcionalidade, preço ou cor.  
- Proibido colar texto de Airbnb, Stripe ou Apple.  
- Proibido meta de agente no corpo: “só o que for real nas fases”, Shape Up, Gate F6, caminhos de arquivo da skill (`modules/…`), “nesta conversa”.  
- Abrir pelo menos um **PDF ou HTML real** dos anexos antes do gate (leitura do agente — **não** citar no cabeçalho comercial).  
- Títulos e dicionário em português humano; sigla só depois do termo por extenso.

## Anti-pressa (obrigatório)

Antes de gravar `.docs/`: ler [`../../shared/anti-rush.md`](../../shared/anti-rush.md) + [`../../shared/docs-clarity.md`](../../shared/docs-clarity.md).  
Ler o arquivo alvo **inteiro** (ou o trecho editado). Não otimizar para fechar o gate. CL0 em cada seção tocada. Jargão → Dicionário ou por extenso.

## Pronto quando

1. `.docs/{slug}.md` existe, tem a densidade do template e passa no **teste do estranho** (`docs-clarity.md`)  
2. Decisão gravada em **Uso interno** (não no cabeçalho comercial)  
3. Devolver ao Controlador — **não** abrir a Fase 11 (tarefas) nesta conversa
