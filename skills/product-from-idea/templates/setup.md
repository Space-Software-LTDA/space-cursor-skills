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
| **Nomenclatura de repo** | `<cliente>-<produto>-<o-que-é>` |

---

## Nomenclatura de repos (lei)

```text
<cliente>-<produto>-<o-que-é>
```

| Parte | Valor neste produto |
|-------|---------------------|
| cliente | |
| produto | |
| o-que-é | `backend` / `frontend` / `extension` |

Org: `Space-Software-LTDA/` + nome. Agente aplica a lei e confirma.

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

---

## Ambientes

| Ambiente | Quem usa | O que precisa existir | URL (se souber) |
|----------|----------|------------------------|-----------------|
| Local | | | |
| Homologação | | | |
| Produção | | | |

---

## Contas / ferramentas externas

| # | Conta / ferramenta | Para quê | MVP? |
|---|--------------------|----------|------|
| | | | |

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
