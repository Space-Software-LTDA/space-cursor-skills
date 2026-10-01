# Roteiro operacional — Fase 5 Contrato

> **Genérico.** Contrato = o que o sistema **guarda** e **quem faz o quê** (sem código).  
> Cliente = leigo. Eco → confirma → grava. Um gate por vez.

**Template:** `templates/contrato.md`  
**Target-model + CA:** [`target-model.md`](target-model.md)  
**Anexo real:** [`examples/anexos/openapi-petstore-v3.yaml`](examples/anexos/openapi-petstore-v3.yaml)  
**Formação:** F5 (+ F6 no gate; F9 se monetização/crédito)

---

## Cabeçalho

```text
**Fase 5 — Contrato**
**Objetivo:** dados + responsabilidades (extensão/app/site/servidor) claros pro time
**ON:** F5 (+ F6)
```

---

## Ordem das decisões (seguir)

Uma **decisão por mensagem**, A/B/C + recomendação:

1. **Onde mora a verdade** depois de coletado (servidor vs só no aparelho)  
2. **Fonte primária** dos dados externos (se houver coleta)  
3. **Entrar na conta** (como)  
4. **Regras de crédito/pagamento** se existirem (quando debita / devolve) — sem inventar preço  
5. **O quê guardar** (lista do *quê*, não o *como* raspar)  
6. **Fluxo de ida e volta** (quem manda o quê; evitar protocolo “tagarela”)  
7. **Quem decide matching/ordem/IA** (cliente vs servidor)  
8. **Conteúdo de home/vitrine** se existir  

Só então **gate** da fase.

---

## Leis da fase

### 1) “Fechado” ≠ “nunca mais detalha”

No chat, deixar explícito:

| Tipo de fechamento | Significa |
|--------------------|-----------|
| **Corte fechado** | Acordo do *quê* / *quem* (ex.: “quase tudo útil da página”) |
| **Lista completa** | Campos/famílias já suficientes pro time |
| **Depois (task/setup)** | *Como* pegar por canal (seletor, anti-bot…) |

Se o cliente pergunta “isso não detalha mais?” → **não** diga só “fechado”. Explique o tipo.  
Se ele diz que **falta lista** → **reabre** o bloco; não force gate.

### 2) Inventário externo (`data.md` etc.)

Cliente pode trazer lista de **outro agente** ou doc técnico.

1. Ler o arquivo.  
2. **Eco em português** (sem colar `CamelCase` / rotas).  
3. Apontar **buracos** (ex.: 4 lojas no inventário vs 9 no MVP; falta dado de pessoa).  
4. Confirmar → traduzir para `.docs/contrato.md`.  
5. Inventário fora de `.docs/` **não** é verdade até migrar/resumir no contrato.

### 3) Cliente “não entendi”

Reescrever do zero em bullets simples. **Não** defender o jargão anterior.

### 4) Resposta ambígua (`2`, `Sj]`, áudio cortado)

Confirmar: “Entendi a opção **B** — confirma?” Antes de gravar.

### 5) Não inventar protocolo tagarela

Preferir o modelo mental do cliente (ex.: “mando lote já tratado; o envio já carrega progresso”).  
Se você propôs status contínuo e o cliente disse **over** → replace limpo no doc.

### Padronização do arquivo (lei)

- Uma lista de campos quando for o mesmo tipo de dado (coluna “onde aparece”: semente / card).  
- Mesmo rótulo em todo o contrato.  
- Se o arquivo ficou remendado → **reescrever inteiro** a partir do template + conteúdo confirmado.  
- Cliente reclamar de bagunça → prioridade **reorganizar**, não nova seção.

---

## Gate

Só **fechado** se:

- [ ] Verdade / fonte primária claras  
- [ ] Conta / auth  
- [ ] O *quê* guardar (pessoa + entidades de negócio) sem buraco que o cliente já avisou  
- [ ] Quem faz matching/ordem (se aplicável)  
- [ ] Pedidos úteis ao servidor em português  
- [ ] Aberto explícito só com **adiado com risco** do cliente  

**Seletores / implementação por canal** → task/setup, desde que o *quê* esteja no contrato.
