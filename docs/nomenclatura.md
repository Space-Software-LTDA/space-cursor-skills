> Constituição Space. **Não resumir.** Skills leem [README.md](README.md) **primeiro**. Editar no repo `space-cursor-skills/docs/`; destino Cursor é cópia (`npm run sync`).

# Nomenclatura

Isto **é** documento de padrão (manufatura do time), não apêndice de RH. GO-12 em [padrao-ouro.md](padrao-ouro.md). Violações: AP-NAM-04 (repo/branch/commit), AP-NAM-05 (banco), AP-NAM-06 (EasyPanel) em [anti-padroes.md](anti-padroes.md).

Nomes de **código** (arquivo que mente, `prepare`/`handle`) continuam em [entry-point.md](entry-point.md) §12 e AP-NAM-01…03.

Como cada skill usa este arquivo: [README.md](README.md).

**PO:** se a task cria repo, branch, tabela, coluna, usuário de banco, serviço no EasyPanel ou só um commit de exemplo — este arquivo é **obrigatório**, não “se sobrar tempo”.

---

## Repositórios no GitHub

Cada cliente e cada projeto têm repositórios separados. Tudo em **minúsculas** com underscore. **Nunca** letra maiúscula nem CamelCase no nome do repo.

Dentro da organização Space:

```text
[nome-do-cliente]_[nome-do-projeto]_[tipo-do-projeto]
```

Exemplo: `space_cardapius_backend`.

Se o repositório nascer **na organização do cliente**:

```text
[nome-do-projeto]_[tipo-do-projeto]
```

`tipo-do-projeto` típico: `backend`, `frontend`, `dashboard`, `integrations`. O identificador do módulo no código, a chave no banco e o nome da pasta **são o mesmo** ([GO-02](padrao-ouro.md)).

Não use hífen no nome do repo Space se o padrão do time naquele cliente já é underscore. Não use espaço. Não use `v2` no nome do repo “porque o antigo existe” — o tipo (`backend`) já distingue; versão é tag/release, não o nome do remoto.

---

## Branches de feature

A partir de `main` (ver [git-fluxo.md](git-fluxo.md)):

```text
PBI-{id-customizado-clickup}
```

Exemplo: `PBI-2304`. Não usar `feat/foo`, `dev-joao` ou o título da task no nome da branch.

Hotfix: `hotfix_{descricao-curta}` a partir de `main`.

Título de Pull Request:

```text
PBI-2304 - O que está sendo ajustado
```

---

## Commits

```text
tipo: o que mudou
```

Exemplos: `feat: adicionar webhook de pagamento`, `fix: não retentar 401 no client HTTP`.

---

## EasyPanel / servidores

Nome do **projeto** no painel:

```text
[nome-do-cliente]_[nome-do-projeto]
```

Nome da **aplicação** (serviço):

```text
[nome-do-servico]
```

---

## Banco de dados (PostgreSQL)

| Coisa | Padrão |
| --- | --- |
| Usuário do banco | `space_[nomedocliente]` |
| Senha | Aleatória, **sem** caracteres especiais |
| Nome de tabela / database | `snake_case` com underscore |
| Colunas | **camelCase** |
| Auditoria | `createdAt` e `updatedAt` **obrigatórias** em toda tabela |

Exemplo:

```sql
CREATE TABLE cliente_pedidos (
    id SERIAL PRIMARY KEY,
    nomeCliente VARCHAR(255),
    dataPedido TIMESTAMP,
    createdAt TIMESTAMP NOT NULL,
    updatedAt TIMESTAMP NOT NULL
);
```

O onboarding antigo escrevia `createAt` — o nome correto da coluna é **`createdAt`**.

TypeScript da entity e a migration precisam contar a **mesma** história ([AP-DB-04](anti-padroes.md)). Rename de coluna/tabela persistida é migração com alias, não search-replace.

Banco da empresa = **PostgreSQL**. Não abrir MySQL/Mongo “só para essa feature” sem o PO escrever isso na task.

Backup de banco e de arquivos: local seguro, rotina — não “quando der”. Isso vale junto com o nome no EasyPanel.

---

## Código

- Arquivo e pasta: intenção, não implementação (`vendorHttpClient.ts`, não `axiosClient.ts` se não usa Axios).
- Zero ` copy` no nome de arquivo (cópia do Explorer não é versionamento).
- Contrato público (JSON, coluna, query param): sem typo (`expiration`, não `experiation`). Corrigir grafia em campo já publicado é breaking change — só com task explícita e versionamento.
- IDs: um conceito, um nome. Proibido `id`, `id2`, `data` genérico, mistura PT+EN no mesmo contrato (`userId` e `idUsuario` para a mesma coisa).
- Função de passo no entry: Intention-Revealing. Proibido `prepare`, `handle`, `process`, `persist` como nome do passo — ver [entry-point.md](entry-point.md) §12.
