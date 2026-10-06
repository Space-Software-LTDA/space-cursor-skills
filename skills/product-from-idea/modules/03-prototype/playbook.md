# Playbook — Fase 3 Protótipo

> Roteiro curto. Barra completa: [`target-model.md`](target-model.md) + anexos reais listados em [`examples/README.md`](examples/README.md).

**Template:** `templates/prototipo.md`  
**Agente:** [`AGENT.md`](AGENT.md)

## Cabeçalho

```text
**Fase 3 — Protótipo**
**Objetivo:** fluxo usável em papel (telas, campos, ações)
**ON:** F1 + F2 (+ F3; F9 se monetização entrar)
```

## Sequência

1. Confirmar que o gate de mercado está fechado (ou adiado com risco).  
1.1. **Produto que já existe:** para cada tela do sistema atual que a Discovery não cita, perguntar ao cliente **para que serve** antes de propor que entre ou saia (o nome da tela pode esconder outro propósito). Mudança de comportamento que é preferência (não defeito) vira pergunta — não entra embutida na tela.  
2. Levar as entradas do discovery para telas com **nome humano**.  
2.1. **Limite ou regra de operação:** ao propor qualquer limite, teto ou regra, perguntar junto **em qual canal vale** (integração, painel, os dois) e **o que acontece ao violar** (erro na hora, fila de aprovação, bloqueio com mensagem). Sem essas duas respostas a regra não está decidida. Número citado pelo cliente na regra (“40%”, “R$ 1.000”): perguntar se é **exemplo ou fixo**; se configurável, quem define e qual o valor inicial.  
2.2. **Papéis:** perguntar como os usuários são criados e como recebem e recuperam a senha; montar a seção **Papéis e permissões** (matriz papel × tela) antes dos cartões de tela.  
2.3. **Situações e tipos:** a situação nunca leva o tipo no nome (“Processando”, não “Saque em processamento”); listas que misturam tipos ganham a coluna **Tipo** (ícone + nome). Perguntar ao cliente **todos os tipos** de movimentação (pela integração, manuais pelo painel, meios de pagamento) — o agente tende a listar só os da API. Avisos/eventos de integração: um evento de mudança de situação com **tipo + situação**, não um nome por combinação.  
3. Em cada tela: objetivo + campos + ações + carregando / vazio / erro.  
4. Alinhar com as lacunas do mercado (diferencial).  
4.1. **Telas do futuro:** se a Discovery ou o mercado apontam uma expansão futura, perguntar se o cliente quer essas telas desenhadas já (para apresentação ou parcerias). Se sim, entram na seção **Telas da expansão futura**, marcadas como futuro — não viram MVP nem tarefa.  
5. Pedido de funcionalidade do cliente → eco → confirma → grava. Decisão tomada vira **Regras decididas** (sem as opções A/B/C); divergência entre fontes já resolvida sai do arquivo.  
6. Gate F6 → registrar em `docs/prototipo.md`.

## Fora agora

Cor, medidas do Design System, Apidog, contratos de API detalhados.
