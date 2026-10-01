# Roteiro operacional — Fase 1 Discovery

> **Genérico** — qualquer produto.  
> **Target-model + CA:** [`target-model.md`](target-model.md)  
> **Anexos reais:** [`examples/anexos/`](examples/anexos/) (PSU + interview toolkit)  
> Persistência: `.docs/discovery.md` (template: `templates/discovery.md`).

## Cabeçalho de toda mensagem

```text
**Fase 1 — Discovery**
**Objetivo:** …
**ON:** F1 + F8 (+ F6 no gate)
```

## Sequência de camadas (não pular)

| # | Camada | Pergunta-núcleo | Pronto quando |
|---|--------|-----------------|---------------|
| 1 | Situação / dor | O que está ruim? Frequência / custo? | Dor concreta, não feature |
| 2 | Quem | Papel + **momento** (não “todo mundo”) | Persona MVP + “não é” |
| 3 | Por que agora | Gatilho | Motivo recente ou pressão |
| 4 | Sucesso | Hoje vs depois (métrica) | Critério mensurável rough |
| 5 | Critérios de “bom” | Ordem do que manda na decisão | Lista curta ordenada (se couber ao domínio) |
| 6 | Corte | O que o produto **não** resolve | Sim explícito do cliente |
| 7 | Entrada / gatilho de uso | Como a pessoa começa no dia 1 | 1+ formas fechadas |
| 8 | Escopo de canais / superfícies | Onde o MVP vive (e o que fica fora) | Tabela no `.docs/` |
| 9 | Definições críticas do domínio | O que não pode ficar “Aberto” (matching, estados, regras…) | F6 com A/B/C |
| 10 | Nome de trabalho | Codinome ou nome | Fechado ou adiado com risco |
| 11 | Gate F6 | Virada de fase | Resultado **no arquivo** |

Camadas 5 e 8–9 adaptam ao domínio: e-commerce, B2B, ops interno, etc. — sempre a partir do que o cliente falou.

## Manobras (genéricas)

### Persona vaga (“pessoas que querem…”)
→ Pedir **momento / contexto / frequência**, não sentimento.

### Cliente despeja solução (stack, scrap, IA, telas)
→ “Hipótese de solução — detalha na fase de protótipo. Agora fecho X da discovery.”

### Sucesso vago (“melhorou”, “achou”)
→ Pedir critério comparável (tempo, erro, % , custo, volume…).

### Dois públicos
→ Forçar **um** primário no MVP; o outro = hipótese ou depois.

### Crítico no “Aberto / decide depois”
→ **Proibido** sem F6. Opções A/B/C + recomendação + fechado ou adiado **com risco explícito**.

### Correção no chat (sigla, lista, fato)
→ **Replace** no `.docs/` com valor canônico.  
→ Sem “(X = …)”, “cliente corrigiu”, histórico do mal-entendido.

### Cliente enrola
→ Repetir **uma** vez a mesma decisão, opções mais fechadas.

## Após cada resposta útil

1. Atualizar `.docs/discovery.md` (Confirmado / Hipótese / Aberto).  
2. Próxima pergunta (1 camada).  
3. Gate → bloco F6 no arquivo.

## Pacote mínimo no gate

- [ ] Problem statement  
- [ ] Persona + não-persona  
- [ ] Dor  
- [ ] Fora de escopo  
- [ ] Sucesso mensurável  
- [ ] Critérios ordenados (se aplicável)  
- [ ] Entradas / gatilho de uso  
- [ ] Canais / superfícies MVP  
- [ ] Definições críticas do domínio (F6 feito)  
- [ ] Nome de trabalho (ou adiado com risco)  
- [ ] Hipótese de solução só como hipótese (se houver)  
- [ ] Gate F6 de virada gravado  
