# Setup — template (generic)

> Fase: 6 — Setup  
> Status: rascunho  
> Última atualização: YYYY-MM-DD  
> Âncora: `.docs/contrato.md`  
> **Para o agente (não copiar para o arquivo final):** qualidade = `modules/06-setup/target-model.md`
> **Para o agente (não copiar para o arquivo final):** leis Space = `modules/06-setup/reference-space-defaults.md`
---

## Dicionário

| Termo | O que é |
|-------|---------|
| **Repositório (repo)** | Projeto no Git onde mora o código de uma peça |
| **Boilerplate** | Projeto-base Space que o time copia pra começar |
| **Ambiente** | Local, homologação (HML) ou produção |
| **Homologação (HML)** | Ambiente de teste parecido com produção |
| **Apidog** | Pedidos ao servidor (detalhe na Fase 11 / PO) |
| **Nomenclatura de repo** | `<cliente>_<produto>_<o-que-é>` (ou com hífen, se o cliente já usa hífen) |

---

## Sistema atual (opcional — só se o produto está sendo refeito)

| Item | O que é | Destino |
|------|---------|---------|
| O que existe | | |
| Reaproveitado | | |
| Vira só consulta | | |
| Arquivar | | |
| Segredos expostos encontrados | Onde (sem copiar o valor) | Trocar antes de |

> **Para o agente (não copiar para o arquivo final):** produto novo → apagar esta seção.

---

## Nomenclatura de repos (lei)

```text
<cliente>_<produto>_<o-que-é>
```

| Parte | Valor neste produto |
|-------|---------------------|
| cliente | |
| produto | |
| separador | `_` ou `-` (o que o cliente já usa) |
| o-que-é | `backend` / `frontend` / `extension` / o que a peça é |

Org: `Space-Software-LTDA/` + nome. Agente aplica a lei e confirma.
> **Para o agente (não copiar para o arquivo final):** lei = `../docs/nomenclatura.md` + `modules/06-setup/reference-space-defaults.md` §1.

---

## Peças a criar

| # | Peça | Para que serve | Nome do repo |
|---|------|----------------|--------------|
| | | | |

---

## Quem cria os repos

| Campo | Valor |
|-------|--------|
| Quem | **DEV**, ao iniciar a peça |
| Setup | Só nomeia — não cria GitHub |

---

## Organização Git

| Opção | Escolha |
|-------|---------|
| A — 1 repo por peça | |
| B — monorepo | |
| C — outro | |

---

## Origem / boilerplate por peça

| Peça | Origem | Nota |
|------|--------|------|
| backend | boilerplate-back-elysia | https://github.com/Space-Software-LTDA/boilerplate-back-elysia |
| frontend | boilerplate-front-nextjs | https://github.com/Space-Software-LTDA/boilerplate-front-nextjs |
| extension | Lei Space: **TypeScript + webpack**; Manifest **V3**; **proibido JS puro** | Estrutura mínima: modelo de extensão da Space (`extension-STRUCTURE.md`) · **DEV** cria ao iniciar |
| integrations (se houver) | Referência Space: https://github.com/Space-Software-LTDA/space-bet-integrations | Um adaptador por fornecedor; o servidor principal pede e recebe sempre no mesmo formato |

---

## Ambientes

| Ambiente | Quem usa | O que precisa existir | URL (se souber) |
|----------|----------|------------------------|-----------------|
| Local | | | |
| Desenvolvimento (`dev`, só se houver ambiente compartilhado) | | | |
| Homologação | | | |
| Produção | | | |

---

## Contas / ferramentas externas

| # | Conta / ferramenta | Para quê | MVP? | Limite para as telas |
|---|--------------------|----------|------|----------------------|
| | | | | |

> **Para o agente (não copiar para o arquivo final):** ferramenta que publica uma superfície (portal de documentação, página de situação) → coluna “Limite”: só conteúdo, ordem, logo e cores no layout dela. Apidog publica o projeto inteiro → API pública com rotas internas = projeto separado.

---

## Mapa leve ao nascer (sem schema)

| Peça | Precisa de | Não faz neste doc |
|------|------------|-------------------|
| | | DBML · Apidog · seletores · hex |

---

## Ponteiros

| Assunto | Onde |
|---------|------|
| DB, Apidog, task | Fase 11 · `po-techlead-scrum` |
| Visual / tokens | Fase 7 · `design-system-forge` |
| Auditoria do front | `qa-space` |

---

## Confirmado · Hipótese · Aberto

### Confirmado
-

### Hipótese
-

### Aberto
-

---

## Decisão da fase (gate)

| Campo | Valor |
|-------|--------|
| Resultado | |
| Data | |
| Critério | Peças + nomes na lei + origem + ambientes + contas |
