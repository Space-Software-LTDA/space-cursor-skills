# Modelo-alvo — Fase 6 Setup

> Vivo: `.docs/setup.md`  
> Leis genéricas: [`reference-space-defaults.md`](reference-space-defaults.md)  
> Anexos reais: [`examples/README.md`](examples/README.md) (mapas de pasta dos projetos-base)

## Fontes

| Fonte | O que extrair |
|-------|---------------|
| [`reference-space-defaults.md`](reference-space-defaults.md) | Nomes + lei da extensão + ponteiros dos projetos-base |
| [`examples/anexos/`](examples/anexos/) | Mapa mínimo de pasta por peça (servidor, site, extensão) |
| boilerplate-back-elysia / boilerplate-front-nextjs | Só o link de origem |
| `po-techlead-scrum` / Forge / `qa-space` | Ponteiros — não duplicar |

## Mínimos da fase

1. Dicionário  
2. Peças = contrato  
3. Nomes de repositório no formato `<cliente>-<produto>-<o-que-é>` (`backend` / `frontend` / `extension`)  
4. Decisão de Git (A/B/C) fechada ou adiada com risco  
5. Origem de cada peça (projeto-base ou lei da extensão + mapa de pasta)  
6. Quem cria os repositórios: **o dev, ao iniciar** (escrito)  
7. Ambientes: local / homologação / produção  
8. Lista de contas externas  
9. Ponteiros para as Fases 7 e 11 e para `qa-space`  
10. Confirmado · Hipótese · Aberto · Gate

## Critérios de aceitação

| # | CA | Barra |
|---|-----|-------|
| S1 | Dicionário | Leigo entende |
| S2 | Peças = contrato | |
| S2b | Nomes no formato `<cliente>-<produto>-<o-que-é>` | |
| S2c | Se existe extensão: TypeScript + webpack + Manifest V3; JavaScript puro proibido | |
| S2d | “O dev cria ao iniciar” escrito | Setup não cria repositório no GitHub |
| S3 | Decisão de Git | |
| S4 | Origem de cada peça com link ou lei | |
| S5 | Ambientes | |
| S6 | Lista de contas | |
| S7 | Só ponteiros (sem despejo de banco ou de Design System) | |
| S8 | Gate gravado | |
| **S.CL** | **CL0–CL5** — `shared/docs-clarity.md` | Homologação por extenso; sem `qtd.` / `TBD` solto |

## Anti-padrões

| Anti-padrão | Sintoma |
|-------------|---------|
| Mini-PO | Banco (DBML) / Apidog no setup |
| Árvore inventada | `src/...` de memória |
| Produto fixo na skill | Skill cita um produto real de cliente como padrão |
| Nome fora do formato | Sem `<cliente>`; `api` / `web` sem confirmar o padrão Space `backend` / `frontend` |
| Extensão em JavaScript puro | “vamos de JS puro / um script” |
| Meta de conversa / abreviação | `qtd.`, `TBD`, títulos com cara de prompt |
| Mini-Forge / mini-QA | Cor ou auditoria visual aqui |
| DevOps fantasma | Agente cria repositório ou publica |
