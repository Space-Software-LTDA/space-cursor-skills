# Correções — subir-app-easypanel

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F). Sem dado de cliente: descrever o padrão.
> Mais recente em cima. Origem: primeiro uso real (2026-10-27); o detalhe do produto está em `exemplos/bet.md` ("Histórico do primeiro uso").

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde |
|------|--------------------|-------|---------------------|------|
| 2026-10-27 | Skill nascia presa a um produto | Criada a partir do primeiro uso, com scripts, apps e branches do produto no texto | Generalizada: renomeada `subir-app-easypanel`; `SKILL.md` e `reference.md` só com o processo comum; produto em `exemplos/` | SKILL.md, reference.md, exemplos/ |
| 2026-10-27 | Réplica: porta 3306 da origem publicada por minutos em `0.0.0.0` | Seguiu-se uma cópia antiga da `replicar-mysql`, que listava "porta publicada na origem" como pré-requisito | Nunca publicar a 3306; usar o clone atualizado, que cria ponte `socat` só na rede privada. Desfeito despublicando a porta e conferido com `ss -ltn` | SKILL.md (leis, etapa 12) |
| 2026-10-27 | Senhas do MySQL apareceram na tela | A resposta da criação do serviço e o erro da troca de credenciais ecoam as senhas | Nunca imprimir corpo de resposta das rotas de serviço; só código HTTP. Serviço vazado apagado e recriado | SKILL.md (leis), reference.md |
| 2026-10-27 | App preso na tela de carregamento | O app exige um cadastro (ex.: logo) que a inicialização zera | Cadastros que o produto exige são passo obrigatório logo após o deploy; avisar antes de dizer "no ar" | SKILL.md (etapa 9), exemplos/ |
| 2026-10-27 | Domínio de um app deu 404 | O usuário criou um subdomínio; o padrão usado era outro | Perguntar os nomes exatos dos subdomínios (ou ler o DNS) antes de criar; sempre cadastrar o `www` | SKILL.md (etapa 1) |
| 2026-10-27 | Apps em 500 (tabela de sessões não existe) | A primeira tentativa não passava as variáveis de sessão, fila e log que a casa modelo usa | Comparar variáveis com uma casa no ar (`docker service inspect`): sessão, fila, log, manutenção e prefixo do Redis por app | SKILL.md (leis), exemplos/ |
| 2026-10-27 | `deployService` falhou com `pull access denied` | O EasyPanel faz *pull* em todo deploy de app; imagem só local não serve | Registry local `127.0.0.1:5000` (`registry:2`); `docker push` e `updateSourceImage` | SKILL.md, exemplos/ |
| 2026-10-27 | Apps criados por `createFromSchema` não subiram | A rota só cria | `deployService` de cada app depois | SKILL.md, reference.md |
| 2026-10-27 | Serviço Compose descartado (não usar) | O usuário não conseguia abrir porta do MySQL nem ver volumes no painel | Serviços nativos (`mysql`, `redis`, `app` no `createFromSchema`) | SKILL.md (leis) |
| 2026-10-27 | Admin novo não era criado pela inicialização | O serviço do botão de criar administrador exige SuperAdmin logado; arquivo 600 copiado ilegível pelo usuário do serviço web | A inicialização do produto cria o admin rodando como o usuário do serviço web, senha pela entrada padrão | SKILL.md, exemplos/ |
| 2026-10-27 | Cópia do modelo passou de 14 min | Os dados passavam pela máquina do agente | Cópia direta entre servidores por agente SSH encaminhado temporário (segundos) | SKILL.md, reference.md |
| 2026-10-27 | Senha do root do MySQL visível na lista de processos do container | Senha na linha de comando do cliente no gerador | Passar a senha por variável de ambiente (`docker exec -e`) | SKILL.md (leis), exemplos/ |
| 2026-10-27 | Skill `replicar-mysql` da máquina estava velha, sem correções e sem permissão de execução | Cópia sincronizada não atualizada | Usar o clone atualizado do pacote ou `npm run sync` antes | SKILL.md (cabeçalho) |

## Pendências (sugestões do primeiro uso, ainda não feitas)
- A inicialização do produto cadastrar o logo informado, para o app não travar na primeira abertura.
- Produto: não travar a tela de carregamento quando não há logo.
- `replicar-mysql`: criar o MySQL de destino sozinha quando não existir (pedindo o token do painel de destino), em vez de parar no "SEM PAR".
- Primeira rodada completa do orquestrador do produto de ponta a ponta (no primeiro uso os passos foram feitos um a um).
