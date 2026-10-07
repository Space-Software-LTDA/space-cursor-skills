# Apidog — contrato de rotas (PO)

Vale para **qualquer produto**. Nada daqui é de um cliente específico.

**Doc oficial da API:** [openapi.apidog.io](https://openapi.apidog.io/)  
**Base:** `https://api.apidog.com` (header `X-Apidog-Api-Version: 2024-03-28`)  
**Auth:** `Authorization: Bearer {APIDOG_ACCESS_TOKEN}` (só o token fica no `.env` do pack)

**Ferramentas:**

| Ferramenta | Para quê |
|---|---|
| `apidog-cli` (`npx -y apidog-cli@latest`) | **Descobrir IDs** (projetos, módulos, pastas, endpoints) e **gerenciar pastas** (criar, mover, apagar). Escrita só funciona se o projeto liberou *Permissões de edição de IA externa* (Settings); sem isso, o CLI só escreve numa branch de IA |
| REST `import-openapi` (script) | **Publicar o contrato** (endpoints e schemas a partir do OpenAPI) |
| MCP do Apidog (`apidog-mcp-server`) | Ler a documentação enquanto se escreve código. Não publica |

---

## Quando usar

Task com **API nova ou alterada**. Front-only sem endpoint novo: pular.

## Pipeline

1. Objetivo → 2. Regra de negócio → 3. DB → 4. Rotas no Apidog → 5. Task ClickUp

---

## IDs — descobrir pelo nome, perguntar só se ambíguo

**Project ID**, **moduleId** e **id da pasta** são do **projeto Apidog daquele produto** e mudam quando o produto muda. **Não** vão no `.env` do pack e **não** precisam ser pedidos ao PO: o script busca na hora, pelo nome.

```bash
python scripts/apidog_resolve_ids.py                                    # projetos da conta
python scripts/apidog_resolve_ids.py --project "{produto}"              # módulos do projeto
python scripts/apidog_resolve_ids.py --project "{produto}" --module "{módulo}"   # pastas + id da Root
```

1. Use o nome do produto/repo que está aberto para achar o projeto e o módulo (nome exato ou trecho).
2. **Ambíguo ou não encontrado** (código de saída 2, com a lista de opções): mostre as opções e **pergunte ao PO** qual é. Não escolha sozinho.
3. Confirme em uma linha antes de importar: “vou importar em *Projeto › Módulo* (ids X/Y)”.
4. **URL do docs** (grid da task): essa continua vindo do PO.

Não inventar. Não reusar ID de outra conversa / outro produto sem buscar de novo.

---

## Credenciais (só conta)

`.env` do pack → sync gera `apidog.env`:

| Variável | Papel |
|----------|--------|
| `APIDOG_ACCESS_TOKEN` | Token da **conta** (`adgp_…`) |
| `APIDOG_API_BASE` | Default `https://api.apidog.com` |
| `APIDOG_API_VERSION` | Default `2024-03-28` |

Não commitar `apidog.env` / token.

---

## OpenAPI local (espelho)

1. `openapi-{slug}.yaml` (+ `.json`) no workspace **deste** produto
2. OpenAPI **3.0.x**
3. Paths reais daquele back
4. Tags + `x-apidog-folder` em cada operação com o **caminho completo a partir da raiz do módulo** (ex.: `KYC/Sessões`), porque o import usa a pasta **Root** do módulo como destino (ver Import). O caminho é relativo ao destino: nunca começar por `Root`/`Raiz`
5. Envelope e auth iguais ao padrão **já existente naquele back**

---

## Import

`POST /v1/projects/{projectId}/import-openapi`

| Option | Valor |
|--------|--------|
| `endpointOverwriteBehavior` / `schemaOverwriteBehavior` | `AUTO_MERGE` |
| `updateFolderOfChangedEndpoint` | **`false`** — rota que já existe fica onde o PO deixou (`--move-existing` liga, só para reorganizar de propósito) |
| `targetEndpointFolderId` | **sempre** o id da pasta **Root** do módulo (o resolve devolve em `folderId` quando roda sem `--folder`). **Nunca 0** |
| `targetSchemaFolderId` | opcional (`--schema-folder-id`) |
| `prependBasePath` | `false` |
| `moduleId` | o que o resolve encontrou **agora** |
| `deleteUnmatchedResources` | **`false`** |

```bash
python scripts/apidog_resolve_ids.py --project "{produto}" --module "{módulo}"   # última linha: folderId da Root
python scripts/apidog_import_openapi.py --file spec.yaml --project-id {ID} --module-id {ID} --folder-id {ID da Root} --dry-run
python scripts/apidog_import_openapi.py --file spec.yaml --project-id {ID} --module-id {ID} --folder-id {ID da Root}
```

Sem Project ID, moduleId e `--folder-id` (diferente de 0) o script aborta.

### Pasta “Root” × pasta “Raiz”

Todo módulo tem uma pasta **Root** de verdade (aparece no `folder list`, oculta na interface). Importar com `targetEndpointFolderId` **0** ou sem pasta faz o Apidog criar uma pasta **nova** chamada “Raiz” e jogar tudo dentro dela. Por isso:

1. Destino do import = id da **Root** do módulo; a organização vem do `x-apidog-folder` de cada rota.
2. Reimportar **não** tira rota do lugar (`updateFolderOfChangedEndpoint: false`). Com `true`, cada reimportação desfaz a organização do PO.
3. Se aparecer uma “Raiz” (import antigo): conferir com `apidog endpoint list` (paginar: `--page`, `--page-size 500`) que ela está **vazia**, mostrar ao PO e só então `apidog folder delete {id} --project {ID} --type endpoint`.

Criar, mover ou apagar pasta = **escrita** no Apidog do produto: mostrar o comando ao PO e esperar o OK. Não “consertar” a árvore com outra importação.

---

## Na task ClickUp

Grid **Contrato API (Apidog)** = URL de docs **que o PO passou** + pasta. Sem path local.

Critérios: seguir o Apidog; o PO já publicou.

---

## O que NÃO fazer

- Gravar Project ID / moduleId / id de pasta / docs URL no `.env` do pack
- Reusar ID de outro produto ou de outra conversa sem buscar de novo
- Escolher sozinho quando o nome do projeto/módulo é ambíguo
- `targetEndpointFolderId: 0` ou import sem pasta (cria a pasta “Raiz”)
- Apagar/mover pasta no Apidog sem mostrar ao PO e sem conferir que está vazia
- `deleteUnmatchedResources: true` em módulo compartilhado
- `updateFolderOfChangedEndpoint: true` sem o PO pedir para reorganizar (devolve rotas para Root/Raiz)
- Token no git ou na task
