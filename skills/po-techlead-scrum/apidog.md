# Apidog — contrato de rotas (PO)

Vale para **qualquer produto**. Nada daqui é de um cliente específico.

**Doc oficial da API:** [openapi.apidog.io](https://openapi.apidog.io/)  
**Base:** `https://api.apidog.com` (header `X-Apidog-Api-Version: 2024-03-28`)  
**Auth:** `Authorization: Bearer {APIDOG_ACCESS_TOKEN}` (só o token fica no `.env` do pack)

MCP do Apidog (se existir) é **só leitura**. Publicar = **REST import**.

---

## Quando usar

Task com **API nova ou alterada**. Front-only sem endpoint novo: pular.

## Pipeline

1. Objetivo → 2. Regra de negócio → 3. DB → 4. Rotas no Apidog → 5. Task ClickUp

---

## IDs — sempre perguntar

**Project ID** e **moduleId** são do **projeto Apidog daquele produto**. Mudam quando o produto muda. **Não** vão no `.env` do pack.

Antes de importar, perguntar (se ainda não estiver nesta conversa):

| ID | Onde o PO acha |
|----|----------------|
| **Project ID** | Apidog → Project Settings → Basic Settings |
| **moduleId** | Módulo dentro desse projeto |
| **URL do docs** | Link público/share do Apidog daquele módulo (para o grid da task) |

Não inventar. Não reusar ID da conversa anterior / de outro workspace.

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
4. Tags + `x-apidog-folder`
5. Envelope e auth iguais ao padrão **já existente naquele back**

---

## Import

`POST /v1/projects/{projectId}/import-openapi`

| Option | Valor |
|--------|--------|
| `endpointOverwriteBehavior` / `schemaOverwriteBehavior` | `AUTO_MERGE` |
| `updateFolderOfChangedEndpoint` | `true` |
| `prependBasePath` | `false` |
| `moduleId` | o que o PO passou **agora** |
| `deleteUnmatchedResources` | **`false`** |

```bash
python scripts/apidog_import_openapi.py --file spec.yaml --project-id {ID} --module-id {ID}
python scripts/apidog_import_openapi.py --file spec.yaml --project-id {ID} --module-id {ID} --dry-run
```

Sem os dois IDs o script aborta.

---

## Na task ClickUp

Grid **Contrato API (Apidog)** = URL de docs **que o PO passou** + pasta. Sem path local.

Critérios: seguir o Apidog; o PO já publicou.

---

## O que NÃO fazer

- Gravar Project ID / moduleId / docs URL no `.env` do pack
- Reusar ID de outro produto
- Importar sem perguntar os IDs
- `deleteUnmatchedResources: true` em módulo compartilhado
- Token no git ou na task
