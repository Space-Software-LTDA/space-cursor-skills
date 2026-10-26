# Referência — replicar-mysql

## Conceitos curtos
- **Binlog (formato ROW):** o diário de alterações da origem; a réplica lê esse diário e repete cada mudança de linha.
- **GTID:** um número de identificação por transação (`uuid:n`). Com `SOURCE_AUTO_POSITION=1` a réplica pede "tudo que ainda não tenho", sem precisar saber arquivo e posição do binlog.
- **Thread IO:** busca o binlog na origem. **Thread SQL:** aplica na réplica. A réplica saudável tem as duas em `Yes` e atraso (`Seconds_Behind_Source`) perto de 0.
- **`read_only` + `super_read_only`:** a réplica não aceita gravação de ninguém (só da replicação). Evita divergência.

## Roteiro manual equivalente (o que o `montar` automatiza)
Pré-requisitos (à mão): Tailscale no host dos dois servidores (sem expirar a chave) e serviço MySQL padrão no destino com versão igual ou mais nova que a origem e sem porta publicada. A porta da origem: se o serviço publica uma, ela é usada; senão a skill cria a ponte (seção abaixo).

1. **Diagnóstico da origem:** `SELECT VERSION()`; variáveis `server_id, log_bin, binlog_format, gtid_mode, enforce_gtid_consistency`; tabelas por engine e tamanho; `SHOW BINARY LOGS`.
2. **Origem:** `CREATE USER 'repl_<destino>'@'%' IDENTIFIED BY '<senha>' REQUIRE SSL; GRANT REPLICATION SLAVE ON *.* TO 'repl_<destino>'@'%';` (`'%'` porque o Swarm troca o IP de origem).
3. **Destino (como root):** `SET PERSIST server_id = N; SET PERSIST enforce_gtid_consistency = ON;` degraus `gtid_mode` (`OFF_PERMISSIVE`, `ON_PERMISSIVE`, `ON`; erro 1788 = já estava acima, seguir); `SET PERSIST_ONLY relay_log_recovery = ON; SET PERSIST_ONLY skip_replica_start = ON;`; reiniciar e conferir.
4. **Cópia:** no destino `RESET BINARY LOGS AND GTIDS;` (8.0: `RESET MASTER;`); de dentro do container de destino `mysqldump -h <origem> -P 3306 -uroot --single-transaction --source-data=2 --set-gtid-purged=ON --routines --triggers --events --databases <banco>` com a senha por `MYSQL_PWD`; importar. Antes do dump, `SHOW FULL PROCESSLIST` na origem (nada em "Waiting for global read lock"). Com MyISAM gravada com frequência, `--lock-all-tables`.
5. **Travar o destino:** `SET PERSIST read_only = ON; SET PERSIST super_read_only = ON;`
6. **Ligar:** `CHANGE REPLICATION SOURCE TO SOURCE_HOST=..., SOURCE_PORT=3306, SOURCE_USER='repl_<destino>', SOURCE_PASSWORD=..., SOURCE_AUTO_POSITION=1, SOURCE_SSL=1, GET_SOURCE_PUBLIC_KEY=1; START REPLICA;` depois `RESET PERSIST IF EXISTS skip_replica_start;`.
7. **Prova:** `SHOW REPLICA STATUS\G` (IO e SQL Yes) e `SELECT @@GLOBAL.gtid_executed;` igual nos dois.
8. **Guardar o dump** no destino (`chmod 600`, nunca apagar, nunca no git).

## Tropeços conhecidos
| Tropeço | Causa | Como evitar |
|---|---|---|
| `Access denied ... SYSTEM_VARIABLES_ADMIN` | Console entrou com o usuário padrão do EasyPanel, não com root | Usar root (`MYSQL_ROOT_PASSWORD` do container); o script já faz |
| Dump "travado" | `-p` esperando senha no terminal | Senha por `MYSQL_PWD`, nunca prompt; o script passa pela entrada padrão |
| `ERROR 1788` no `OFF_PERMISSIVE` | GTID já estava num degrau acima | Tolerar e seguir os degraus; o script confere o valor final |
| Versão do destino diferente (tag mais nova puxada) | EasyPanel baixou imagem mais nova | Destino >= origem; `verificar` confere |
| CLONE descartado | Tabelas MyISAM chegam vazias no CLONE | Usar dump |
| `'repl'@'100.%'` não serve | O Swarm troca o IP de origem | `'repl'@'%'` + porta bloqueada + senha forte |
| `ERROR 3056 ... replication user exceeds the maximum length of 32 characters` | Senha do `repl` com mais de 32 caracteres | Gerar exatamente 32 letras e números |
| `\G` dá "Unknown command" | O cliente `mysql` em modo batch (`-B`) não aceita `\G` | Usar `mysql -E` para saída vertical |
| `docker exec -i` "engole" o resto de um script lido da entrada padrão | Ele herda o stdin | Redirecionar `</dev/null` nos comandos que não precisam de entrada |
| Porta de MySQL aberta na internet | Publicar a porta no Swarm ignora o firewall do host | `bloquear-porta` (script + serviço systemd; ver Firewall) |
| `Host key verification failed` na primeira conexão | O servidor ainda não está no `known_hosts` | O script usa `StrictHostKeyChecking=accept-new`: aceita chave nova sozinho; chave que MUDOU é recusada (FALHA) |
| Serviço Swarm com dois MySQL no mesmo volume | `docker restart` no container de um serviço: o Swarm marca a task como encerrada e sobe outra no mesmo volume; o antigo também volta (a trava do InnoDB, `Unable to lock ./ibdata1`, impede dano) | Em Swarm usar `docker service update --force` e esperar a task nova; o script faz isso e re-acha o container antes de cada passo |
| `status` dizia "não é réplica" com a réplica rodando | Leitura do `SHOW REPLICA STATUS` sem distinguir erro de vazio | `mysql -E` pela entrada padrão; erro de leitura é FALHA própria; "vazio" só vale se o `performance_schema` também não tem réplica |
| Primeira conexão SSH com chave já existente na máquina | A chave existente não tem o nome padrão e o ssh não a tenta sozinho | `ssh` da skill testa cada chave de `~/.ssh` e instala a da skill |

## Troca (promover a réplica a banco principal)
1. Parar as gravações na origem (manutenção) e esperar `status` com atraso 0 e `gtid_executed` igual.
2. No destino: `STOP REPLICA; RESET REPLICA ALL; SET PERSIST super_read_only = OFF; SET PERSIST read_only = OFF;`
3. Apontar as aplicações para o destino. Conferir gravação e leitura.
4. A origem antiga fica desligada. Para inverter os papéis, monte a réplica nova a partir do servidor promovido num serviço MySQL novo (ou na origem antiga já limpa); `--refazer` só vale para destino que já seja réplica ou cópia da origem em questão e é recusado fora disso.
5. Lembrar que **os usuários da aplicação só existem na réplica se estavam na origem quando o `montar` rodou** (a skill copia os usuários nessa hora; criados depois replicam pelo binlog). Conferir os logins das aplicações antes de apontá-las. Depois, `RESET PERSIST read_only; RESET PERSIST super_read_only;` se quiser tirar os valores persistidos, e reabilitar eventos agendados (`event_scheduler`) se a aplicação usa.

## Teste da skill
Roda em containers de teste (origem, duas réplicas e um servidor avulso) na mesma rede Docker (`mysql` com `--log-bin --gtid-mode=ON --enforce-gtid-consistency=ON` na origem), com `--origem-ssh local --destino-ssh local --origem-host <nome do container de origem>` e `REPLICAR_DIR_BASE` apontando para uma pasta temporária (sem precisar de root).
- **Ponte:** origem sem porta publicada, `--ponte-ip` com um IP local do host de teste.
- **Swarm (P9):** dentro de um container `docker:dind` privilegiado criado só para o teste (`docker swarm init` lá dentro, nunca no Docker da máquina), origem e destino como serviços (`--endpoint-mode dnsrr` se o IP virtual não rotear), `montar` e conferir que o serviço destino fica com um container só.
- **SSH:** containers com `sshd` (`alpine` + `openssh`) em portas locais, `~/.ssh` de teste (variável `HOME` diferente + um `ssh` embrulhado com `-F`), cobrindo chave desconhecida, chave existente, `IdentityFile` do config, salto por outro servidor e chave do servidor mudada.
- **Firewall:** `bloquear-porta` dentro do `docker:dind` (tem `iptables` e `DOCKER-USER` próprios).

## Decisões e limites (revisão de 2026-10-25)
- **Um usuário de replicação por destino** (`repl_` + até 18 letras do serviço + `_` + 8 hex de hash do host de destino (`/etc/machine-id`) + serviço, 32 caracteres; o nome fica em `<base>/.replicacao/<servico>.env` como `REPL_USUARIO`). Se o usuário já existe na origem e o `.env` deste destino não tem a senha dele, `verificar` dá FALHA e a skill nunca troca a senha (pode ser de outra réplica). `.env` antigo só com `REPL_SENHA` e usuário no formato antigo (`repl_<serviço>`) existente: é reaproveitado. Antes: `repl_<destino sanitizado>`, criado na origem com `sql_log_bin=0` para não ir ao binlog (assim não quebra outras réplicas). A skill nunca altera um usuário que não seja o seu; réplicas feitas à mão com outro usuário não são tocadas.
- **Replica-se o servidor inteiro:** o binlog leva todos os bancos de usuário; por isso o padrão é copiar todos e `--banco` só vale se a origem não tem outros. Contas `root`, `mysql.*` e `repl_*` não são copiadas; mudança futura na senha do `root` da origem replica para o `root` do destino.
- **Contagem de linhas:** exata só em tabelas com até 1 milhão de linhas estimadas; acima disso só `table_rows` (estimativa), para não varrer tabela grande em produção.
- **TLS:** `SOURCE_SSL=1` não verifica o certificado do servidor (aceitável dentro do Tailscale). **`MYSQL_PWD`** está obsoleto no MySQL 8+/9 (ainda funciona na 9.7); é o que evita senha em argumento. Arquivo de senha criado no Windows (CRLF) é tratado (`\r` removido).
- **`--refazer` que aborta antes de ligar** deixa a réplica parada (de propósito, `skip_replica_start=ON`); rode `montar --refazer` de novo ou `START REPLICA`.
- **Reinício do destino:** container comum usa `docker restart -t 120` (espera até 120 s antes de matar o mysqld). Serviço Swarm usa `docker service update --force --detach <servico>` e espera (até 180 s) o container NOVO responder `SELECT 1` com um container só no serviço. Testado em Swarm de verdade (dentro de um `docker:dind`). Em Swarm com IPVS ausente (dind) o IP virtual do serviço não roteia; o teste usou `--endpoint-mode dnsrr`. No EasyPanel real o IP virtual funciona.

## Ponte (origem sem porta publicada)
- **Por que:** publicar a porta pelo EasyPanel reinicia o MySQL de produção e abre a porta na internet. A ponte não reinicia nada e não abre a internet.
- **O que é:** container `replicacao-<casa>-ponte-<porta>` (`<casa>` = nome do serviço em minúsculas, só letras, números e hífen), imagem `alpine/socat:1.8.0.3`, `--restart unless-stopped`, na rede overlay do serviço (a rede `easypanel-<projeto>` quando existe; precisa ser *attachable*), publicando `-p <ip-tailscale>:<porta>:3306` e encaminhando para o alias do serviço na rede. Rótulo `replicacao.casa`.
- **Porta:** sempre na faixa **29900–29999** (a próxima livre, olhando `ss -ltn`, containers e portas publicadas de todos os serviços). `--porta` fora da faixa é recusada, salvo `--forcar-porta`. A porta fica reservada à réplica: não usar no EasyPanel.
- **Rótulos e alvo:** a ponte nova leva os rótulos `replicacao.origem-servico=<serviço>` e `replicacao.porta=<porta>` e é achada por eles (não pelo alias). Aponta para o alias **mais específico** do serviço na rede (o `<projeto>-<serviço>`), nunca para o curto, que pode existir em outra casa. Ponte antiga, sem rótulo, é reconhecida pelo nome `replicacao-*-ponte-<porta>` + destino do `socat` (nome do serviço ou alias específico) e reaproveitada sem recriar.
- **Idempotente:** se a ponte da casa já existe (rodando ou parada) e responde, é reaproveitada. Ponte **parada** (o risco abaixo): o `verificar` dá FALHA (AVISO dentro do `montar`/`ponte` com `--confirmo`), o `ponte`/`montar --confirmo` roda `docker start`, e se o bind falhar mostra o log e a pista do Tailscale; o `listar` marca `(parada)` e o `status` avisa quando a porta da origem é de uma ponte parada.
- **Risco conhecido:** se o Tailscale subir depois do Docker no boot, o `bind` no IP do Tailscale falha e a ponte não escuta. `status`/`verificar` mostram; `docker restart <ponte>` resolve.
- **IP da ponte:** `--ponte-ip` só aceita IP 100.64.0.0/10 (Tailscale). Para teste, `--forcar-ponte-ip` aceita IP privado (10/8, 172.16/12, 192.168/16, 127/8) com AVISO. `0.0.0.0`, `::` e IP público são recusados sempre.
- O `verificar` nunca cria a ponte; só avisa. O `montar --confirmo` (ou `ponte --confirmo`) cria.

## Descoberta da porta e do par origem → destino
- `listar` usa o rótulo `com.docker.swarm.service.name` dos containers de imagem `mysql`/`mariadb`/`percona`, a porta publicada (`docker service inspect`, `TargetPort` 3306), a ponte (pelo alvo do `socat`) e consulta o `performance_schema` para saber se já é réplica. A sugestão compara as palavras do nome (sem `database`, `db`, `mysql`...); igual ou prefixo de 4+ letras. Sempre confirmar com o usuário.
- Porta da origem no `verificar`/`montar`: `--porta` (força) → ponte da casa → porta publicada → ponte nova.
- Aviso de exposição (`ss -ltn`): só IP 100.64.0.0/10 = OK; 0.0.0.0/:: com regra DROP no `DOCKER-USER` = OK; 0.0.0.0/:: sem DROP = AVISO.

## Firewall (`bloquear-porta`)
- Instala no host de origem `/usr/local/sbin/replicacao-firewall.sh` (lista `PORTAS`; `iptables` e `ip6tables`; `-C` antes de `-I`; `--ctdir ORIGINAL`; interface do `ip route` default) e `replicacao-firewall.service` (`After=`/`Requires=`/`PartOf=docker.service`, `WantedBy=multi-user.target docker.service`, `Type=oneshot`, `RemainAfterExit=yes`). Só a regra no `iptables` some no reboot, e `netfilter-persistent save` também salvaria as regras do próprio Docker, por isso o script próprio.
- Padrão: fecha **todas** as portas de MySQL publicadas em 0.0.0.0/:: no host. `--portas a,b` escolhe. As portas se **somam** às que já estão no script (nunca remove).
- Testa **por dentro**: do destino (`--destino-ssh`), a porta pelo IP do Tailscale continua abrindo; depois confere a réplica. **Por fora** (outra rede, sem Tailscale) é conferido pelo usuário.
- `--dry-run` lê tudo e mostra o que faria, sem mudar nada. Sem systemd o script só aplica as regras agora (AVISO: não sobrevivem ao reboot).
- Não testado: a ativação real do serviço no systemd (o ambiente de teste não tem systemd); o texto do serviço é idêntico ao que funcionou à mão num servidor real.
