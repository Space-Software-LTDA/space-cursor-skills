# Referência — SuperAgente Scrum Ritter (ClickUp)

Este arquivo descreve o que o SuperAgente do ClickUp espera ao ler a descrição que você produz. Use para calibrar o nível de detalhe.

## Hierarquia SCRUM

```
Epic → Feature → PBI (User Story) → Tasks
```

O SuperAgente quebra a descrição do usuário nessa hierarquia. Sua descrição deve dar contexto suficiente para ele classificar corretamente.

## Convenções de nomenclatura (geradas pelo SuperAgente)

| Nível | Padrão |
|-------|--------|
| Epic | `EPIC \| <Módulo principal>` |
| Feature | `FEATURE \| <Módulo> \| <Funcionalidade>` |
| PBI | `PBI \| <Módulo> \| <Ação/resultado>` |
| Task | `[FRONTEND]` ou `[BACKEND]` + descrição |

## O que o SuperAgente extrai da sua descrição

### Para PBIs
- **Contexto** — de `## 📌 Contexto`
- **Objetivo** — de `## 🎯 Objetivo`
- **Escopo** — de `## 🔧 Alterações Necessárias`
- **Fora de escopo** — implícito ou em Observações (deixar explícito quando houver)
- **Critérios de aceitação** — de `## ✅ Critérios de Aceitação` (formato Dado/Quando/Então)

### Para Tasks
O SuperAgente cria subtarefas por camada:

| Camada | Quando criar |
|--------|--------------|
| Só FRONTEND | Alterações apenas em UI (componentes, páginas, estilos) |
| Só BACKEND | Alterações em API, serviços, jobs, banco, integrações |
| Ambos | Mudanças em front e back, ou escopo compartilhado |

Cada PBI gera tasks dos tipos:
- **Implementação**
- **Testes**
- **Documentação**
- **Code Review**

Prefixo obrigatório: `[FRONTEND]` ou `[BACKEND]`

## O que você DEVE deixar explícito na descrição

Para o SuperAgente não interpretar errado:

1. **Seção Backend** — tudo que é API, banco, fila, cron, integração externa, regra de negócio server-side
2. **Seção Frontend** — tudo que é tela, formulário, estado, chamada HTTP do client, UX
3. **Critérios de Aceitação** — comportamento verificável; sem mencionar classes, arquivos ou padrões de código
4. **Observações** — delays, retries, env vars, dados fixos vs configuráveis, estrutura antiga vs nova

## Exemplo de separação Back/Front

**Backend:**
- Receber body de cadastro com campos X, Y, Z
- Extrair `aff_id` da `btag`
- Consultar banco para config de troca
- Criar fila + cron a cada 1 min
- Integrar API Smartico (auth + swap)

**Frontend:**
- Trocar campo "BTags de destino" por "deal_id de destino"
- Remover interceptação JS de troca de BTag no body

**Critérios de Aceitação:**
- Dado usuário cadastrado com btag válida, Quando o cron processar após disponibilidade na Smartico, Então o registro é marcado como migrado no banco

## Projetos e contexto

Códigos: MONITOR, SPACEBET, SPACEPAY, SPACEAPI, ONESET, ACTION, IA-SAGA

Cada projeto pode ter múltiplos repositórios (front + back). Quando souber o projeto, mencionar na conversa para calibrar vocabulário e módulos.

## Frontend boilerplate de referência

Para tasks de front, o SuperAgente alinha convenções ao boilerplate:
`https://github.com/Space-Software-LTDA/boilerplate-front-nextjs`

Ao descrever alterações de front, usar nomenclatura compatível (componentes, páginas, hooks, etc.).
