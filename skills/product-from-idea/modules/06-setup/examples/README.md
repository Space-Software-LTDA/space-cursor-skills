# Exemplos — Fase 6 Setup

> Fontes **reais** da Space (projetos-base oficiais). Documento vivo do produto: `docs/setup.md` (não estes arquivos).  
> Barra (estrutura + critérios de aceite + anti-padrões): [`../target-model.md`](../target-model.md)

## Ler primeiro

| Documento | Papel |
|-----------|-------|
| [`../target-model.md`](../target-model.md) | O que o `setup.md` precisa ter |
| [`../playbook.md`](../playbook.md) | Sequência da fase |
| [`../reference-space-defaults.md`](../reference-space-defaults.md) | Leis da Space para setup (projetos-base, extensão em TypeScript + webpack) |

## Anexos (abrir o da peça em questão)

Mapas mínimos de pasta, tirados dos projetos-base oficiais. **Não** substituem clonar o projeto-base; servem de mapa rápido no setup. Índice: [`anexos/README.md`](anexos/README.md).

| Anexo | O que é | O que extrair |
|-------|---------|----------------|
| [`anexos/backend-STRUCTURE.md`](anexos/backend-STRUCTURE.md) | Estrutura do projeto-base de servidor [boilerplate-back-elysia](https://github.com/Space-Software-LTDA/boilerplate-back-elysia) | Onde fica cada coisa no servidor; o que o dev ganha ao clonar |
| [`anexos/frontend-STRUCTURE.md`](anexos/frontend-STRUCTURE.md) | Estrutura do projeto-base de site [boilerplate-front-nextjs](https://github.com/Space-Software-LTDA/boilerplate-front-nextjs) | Organização por funcionalidade; o que o dev ganha ao clonar |
| [`anexos/extension-STRUCTURE.md`](anexos/extension-STRUCTURE.md) | Estrutura de extensão de navegador no padrão Space (espelho do site + TypeScript, webpack, Manifest V3) | Como a extensão se organiza quando não há projeto-base próprio |

## Referência sem anexo (abrir no GitHub)

| Referência | O que é | O que extrair |
|------------|---------|----------------|
| [space-bet-integrations](https://github.com/Space-Software-LTDA/space-bet-integrations) | Camada de integração com fornecedores externos da Space | Pasta por fornecedor com adaptadores, módulos normalizados, catálogo único de erros, fornecedor falso para simulação. Ferramenta (framework) conferida no código antes de citar |

## Proibido

- Nome de produto concreto nestes arquivos.  
- Detalhar banco, API ou árvore completa de pastas no `setup.md` (isso é a Fase 11).
