# Correções — subir-app-easypanel

> Erros corrigidos que viraram regra. Registrado pelo `/skill-update` (fluxo F). Sem dado de cliente: descrever o padrão.
> Mais recente em cima. Origem: primeiro uso real (2026-10-27); o detalhe do produto está em `exemplos/bet.md` ("Histórico do primeiro uso").

| Data | O que estava errado | Causa | Regra nova / ajuste | Onde |
|------|--------------------|-------|---------------------|------|
| 2026-10-29 | `domains.createDomain` deu 400 `id Required` | A referência não citava o `id` nem o formato completo | Formato completo na tabela da API, copiado de um `listDomains` | reference.md |
| 2026-10-29 | `services.app.updateMounts` deu 404 | Rota inexistente | `mounts.createMount {projectName, serviceName, values}` e `mounts.listMounts` | reference.md |
| 2026-10-29 | Arquivo do volume servido como página do site (200 `text/html`) | Só o app que grava montava a pasta; o que serve não | Montar a subpasta compartilhada nos dois apps e fazer o deploy | reference.md (tropeços) |
| 2026-10-29 | Não havia roteiro para atualizar projeto antigo subido por *upload* | A skill cobria só projeto novo e atualização de projeto criado por ela | Roteiro "Projeto antigo": só lendo primeiro, migrations no plano, imagem e ENV antigas guardadas, ENV conferida (só nomes) com projeto novo e com o código, apoio por `createFromSchema`, arquivos de volume só com `--ignore-existing`, um app por vez, como voltar atrás | reference.md, SKILL.md (papel, leis) |
| 2026-10-29 | (revisão sem contexto) Roteiro de atualização deixava migrations, cópia de arquivos e volta atrás implícitas | Primeira versão do roteiro | Migrations listadas antes do deploy; item de arquivos de volume; lista explícita de valores que podem aparecer; passo "Voltar atrás" | reference.md |
| 2026-10-27 | O "servidor novo" já hospedava outro projeto; o `listProjects` não veio `[]` | A skill presumia servidor limpo | Reconhecer mostra os projetos que existem; confirmar projeto separado e slug único; reaproveitar Tailscale, registry e modelo; nunca tocar nos outros | SKILL.md (etapa 2, leis), reference.md |
| 2026-10-27 | O destino da réplica já existia com dados de teste antigos; `verificar` deu FALHA e `--refazer` não servia | Serviço criado antes, fora deste fluxo | Investigar só lendo, perguntar; com OK explícito no chat, dump em `<base>/backups/` conferido e `DROP DATABASE`; sem OK, destino com outro nome | SKILL.md (etapa 11), reference.md |
| 2026-10-27 | O usuário colou os tokens dos painéis no chat | Mais rápido para ele | Gravar em arquivo 600 sem repetir o valor; recomendar gerar token novo no relatório | SKILL.md (etapa 1) |
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

## Pendências (sugestões dos usos, ainda não feitas)
- A inicialização do produto cadastrar o logo informado, para o app não travar na primeira abertura.
- Produto: não travar a tela de carregamento quando não há logo.
