# Docs do produto — {Nome do produto}

> **Para o agente (não copiar para o arquivo final):** este arquivo é o índice e o “onde estamos” do Controlador. Atualizar a linha de status a cada gate e a seção “Status atual” a cada fase aberta.

Se não está nesta pasta, não está decidido. Cada fase tem um arquivo; este índice diz onde está cada um e em que situação.

## Como ler este índice

| Fase | Arquivo | Em uma frase |
|------|---------|--------------|
| 1 | `discovery.md` | Qual o problema e para quem |
| 2 | `pesquisa-mercado.md` | Tamanho do mercado, alternativas, se vale seguir |
| 3 | `prototipo.md` | Como a pessoa usa (telas e caminho) |
| 4 | `mvp.md` | O que entra e o que fica fora da primeira versão |
| 5 | `contrato.md` | O que guardar e quem faz o quê (sem código) |
| 6 | `setup.md` | Repositórios, projetos-base, ambientes e contas |
| 7 | `DESIGN_SYSTEM.md` | Marca e linguagem visual do produto |
| 8 | `telas.md` | Telas aprovadas pelo cliente, uma a uma |
| 8.5 | `telas.md` (seção) + `prototipo/` | Protótipo navegável para apresentar (`npm run prototipo:start`) |
| 9 | `revisao.md` | Conferência dos documentos contra os critérios |
| 10 | `{slug}.md` | Manual comercial do produto |
| 11 | `tarefas.md` | Plano de fatias e tarefas para os devs |
| Brief interno | `produto.md` | Resumo curto para o time (não é o manual) |

## Status atual

> **Fase aberta:** {N — nome}

| Arquivo | Status | Mudanças depois do gate (data · o que mudou) |
|---------|--------|----------------------------------------------|
| `discovery.md` | ainda não criado | |
| `pesquisa-mercado.md` | ainda não criado | |
| `prototipo.md` | ainda não criado | |
| `mvp.md` | ainda não criado | |
| `contrato.md` | ainda não criado | |
| `setup.md` | ainda não criado | |
| `DESIGN_SYSTEM.md` | ainda não criado | |
| `telas.md` | ainda não criado | |
| `revisao.md` | ainda não criado | |
| `{slug}.md` | ainda não criado | |
| `tarefas.md` | ainda não criado | |
| `produto.md` | ainda não criado | |

Status possíveis: ainda não criado · rascunho · em validação · **fechado** · adiado com risco · bloqueado.  
A coluna “Mudanças depois do gate” recebe as decisões tardias propagadas para o arquivo (a fase não reabre).

## Leis que todo arquivo daqui obedece

| Lei | Significado |
|-----|-------------|
| Um arquivo por fase | Não misturar fases num arquivo só |
| Dicionário no topo | Termo · o que é, em português claro |
| Confirmado · Hipótese · Aberto | Separados em todo arquivo de fase |
| Correção = troca limpa | O valor certo substitui o errado, sem histórico de conversa |
| Conta nos números | Toda estimativa de mercado mostra a conta |
| Mesmo fato, mesmo nome | Um nome canônico por coisa em todos os arquivos |
| Decisão da fase | fechado · adiado com risco · bloqueado — gravada no arquivo |
