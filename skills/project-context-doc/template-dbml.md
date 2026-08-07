# Template DBML — dbdiagram.io

Um bloco DBML **por repo com banco**, colavel em [dbdiagram.io](https://dbdiagram.io).

---

## Cabecalho

```dbml
// Repo: [nome-do-repo]
// Produto: [nome-produto]
// Gerado por project-context-doc

Project [nome_produto] {
  database_type: 'PostgreSQL'
  Note: 'Ajustar database_type conforme stack (MySQL, SQLite, ...)'
}
```

---

## Mapeamento ORM → DBML

| ORM / padrao | DBML |
|--------------|------|
| PK uuid/int | `[pk]` |
| FK + relation | coluna + `Ref:` |
| not null / nullable | `[not null]` ou omitir |
| json/jsonb | `json` |
| soft delete column | note explicando |
| virtual/computed | note "runtime / nao persiste" |

---

## Notes por coluna (obrigatorio)

```dbml
Table [nome_tabela] {
  id uuid [pk, note: 'Para que: identificador interno. Por que: PK da entidade.']
  [campo] varchar [note: 'Para que: [...]. Por que: [...]']
}
```

Inferencia incerta: `[CONFIRMAR]` no inicio da note.

---

## Note por tabela

```dbml
Table [nome] {
  ...
  Note: '''
  Para que: [papel da tabela no dominio].
  Por que existe: [razao de negocio ou tecnica].
  '''
}
```

---

## Relacionamentos

```dbml
Ref: [tabela_filha].[fk] > [tabela_pai].id
```

---

## Dicionario humano TB-xxx (ClickUp)

Agrupar sob subsecao do repo: `### `[core]` — [nome-pasta]``

**DBML:** somente no [Apendice](document-layout.md) — no corpo, link `[DBML completo no Apendice](#dbml-core)`.

```markdown
<a id="tb-001"></a>
#### TB-001: [nome_tabela]

**Repo:** `[core]` ([nome-da-pasta])

**Para que:** [papel no dominio — frase completa]
**Por que existe:** [2 frases quando tabela e critica; linkar RN se aplicavel — ex. ver [RN-008](#rn-008)]

| Coluna | Para que | Por que |
|--------|----------|---------|
| [col] | [...] | [frase completa — evitar "auditoria" generico] |
```

**Todas as colunas** documentadas. **Sem coluna Tipo** — tipo fica no DBML.

Incluir TB criticas no **Indice de artefatos** do documento master (ver checklist em [index-grouping-guide.md](index-grouping-guide.md)).

---

## Colunas JSON

Sub-tabela de chaves relevantes:

```markdown
| Chave JSON | Para que | Por que |
|------------|----------|---------|
| [chave] | [...] | [...] |
```

---

## Ordem

Core → transacional → config → auxiliar.

---

## Validacao

- [ ] DBML valido no dbdiagram.io
- [ ] Toda coluna com note
- [ ] Dicionario TB espelha DBML (sem coluna Tipo)
- [ ] TB agrupados por repo (alias no titulo)
- [ ] Indices longos passaram pelo checklist ([index-grouping-guide.md](index-grouping-guide.md))
- [ ] Anchors `tb-xxx` em tabelas criticas; link no Indice global
- [ ] Sem valores de secret
