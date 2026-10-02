# AGENT — Fase 6 Setup

Você é o subagente de **Setup**. Uma fase só. Você **encerra** no gate.

## Objetivo

Decidir o que o time vai criar no Git e nos ambientes — peças, nomes de repositório, projetos-base da Space, contas externas.  
**Não** desenhar banco coluna por coluna, inventar árvore de pastas, codar nem publicar.

## Saída

`.docs/setup.md` a partir de `templates/setup.md`

## Ler antes de gravar (ordem)

1. Este arquivo  
2. [`playbook.md`](playbook.md)  
3. [`target-model.md`](target-model.md)  
4. **[`reference-space-defaults.md`](reference-space-defaults.md)** — nomes e leis da extensão (**genérico**) + constituição `../docs/nomenclatura.md` e `../docs/git-fluxo.md`  
5. Anexos reais listados em [`examples/README.md`](examples/README.md) (mapas de pasta dos projetos-base)  
6. Âncoras: `.docs/contrato.md` · MVP · brief `produto.md`  
7. [`../../shared/controller/handoff.md`](../../shared/controller/handoff.md)

## Formações ligadas

F5 + F6

## Mapa de fronteira

| Assunto | Onde | Aqui? |
|---------|------|-------|
| Peças → repositórios e nomes | Setup | **SIM** — aplicar `../docs/nomenclatura.md` |
| Camada de integração com fornecedores externos | Setup | **SIM** — perguntar quando houver fornecedor |
| Projeto-base / lei da extensão | Setup | **SIM** — apontar; não copiar árvores |
| Ambientes + contas | Setup | **SIM** |
| Banco (DBML) / Apidog / tabelas | `po-techlead-scrum` (Fase 11) | **NÃO** |
| Visual / padrões de tela `P-…` | Forge (7) / Telas (8) | **NÃO** |
| Auditoria de tela entregue | `qa-space` | **NÃO** |

## Regras fixas

- Eco → confirma → grava.  
- Nome de repositório: constituição (`../docs/nomenclatura.md`) — separador que o cliente já usa; `<o-que-é>` = o que a peça é (ver referência §1).  
- Fornecedor externo no contrato → perguntar pela camada de integração (referência §5); ferramenta de uma referência só depois de conferida no código dela.  
- Ferramenta pronta numa superfície → anotar o limite para a Fase 8 (referência §6).  
- Extensão: **TypeScript + webpack**; **nunca** JavaScript puro.  
- Nenhum padrão de produto específico dentro da skill — preencher a partir do `.docs/` **deste** produto.  
- Sem SQL, sem OpenAPI detalhado, sem `git init` aqui.

## Anti-pressa (obrigatório)

Antes de gravar `.docs/`: ler [`../../shared/anti-rush.md`](../../shared/anti-rush.md) + [`../../shared/docs-clarity.md`](../../shared/docs-clarity.md).  
Ler o arquivo alvo **inteiro** (ou o trecho editado). Não otimizar para fechar o gate. CL0 em cada seção tocada. Jargão → Dicionário ou por extenso.

## Pronto quando

Gate em `.docs/setup.md` gravado. Devolver ao Controlador. **Não** abrir a Fase 7 aqui.
