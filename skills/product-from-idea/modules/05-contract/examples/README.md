# Exemplos — Fase 5 Contrato

> Caso **real**. Documento vivo do produto: `.docs/contrato.md` (não estes arquivos).  
> Barra (estrutura + critérios de aceite + anti-padrões): [`../target-model.md`](../target-model.md)

## Ler primeiro

| Documento | Papel |
|-----------|-------|
| [`../target-model.md`](../target-model.md) | O que o `contrato.md` precisa ter |
| [`../playbook.md`](../playbook.md) | Sequência da fase (uma decisão por vez) |

## Anexos (abrir)

| Anexo | O que é | O que extrair |
|-------|---------|----------------|
| [`anexos/openapi-petstore-v3.yaml`](anexos/openapi-petstore-v3.yaml) | Contrato de API real no padrão OpenAPI 3 (Swagger Petstore) | Recursos com nome, operações, campos e obrigatoriedade — a barra de clareza de um contrato |

O contrato do produto (Fase 5) é escrito em **português** (entidades, pedidos ao servidor, quem faz o quê). O formato OpenAPI detalhado entra depois, na tarefa (Fase 11).

## Proibido

- Colar o YAML do anexo no `contrato.md`.  
- Detalhar banco ou endpoints nesta fase (isso é a Fase 11).
