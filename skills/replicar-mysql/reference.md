# Referência — replicar-mysql

## Conceitos curtos
- **Binlog (formato ROW):** o diário de alterações da origem; a réplica lê esse diário e repete cada mudança de linha.
- **GTID:** um número de identificação por transação (`uuid:n`). Com `SOURCE_AUTO_POSITION=1` a réplica pede "tudo que ainda não tenho", sem precisar saber arquivo e posição do binlog.
- **Thread IO:** busca o binlog na origem. **Thread SQL:** aplica na réplica. A réplica saudável tem as duas em `Yes` e atraso (`Seconds_Behind_Source`) perto de 0.
- **`read_only` + `super_read_only`:** a réplica não aceita gravação de ninguém (só da replicação). Evita divergência.

## Roteiro manual equivalente (o que o `montar` automatiza)
Pré-requisitos (à mão): Tailscale no host dos dois servidores (sem expirar a chave), porta 3306 publicada no serviço de origem, serviço MySQL padrão no destino com versão igual ou mais nova que a origem e sem porta publicada.

1. **Diagnóstico da origem:** `SELECT VERSION()`; variáveis `server_id, log_bin, binlog_format, gtid_mode, enforce_gtid_consistency`; tabelas por engine e tamanho; `SHOW BINARY LOGS`.
2. **Origem:** `CREATE USER 'repl'@'%' IDENTIFIED BY '<senha>' REQUIRE SSL; GRANT REPLICATION SLAVE ON *.* TO 'repl'@'%';` (`'%'` porque o Swarm troca o IP de origem).
3. **Destino (como root):** `SET PERSIST server_id = N; SET PERSIST enforce_gtid_consistency = ON;` degraus `gtid_mode` (`OFF_PERMISSIVE`, `ON_PERMISSIVE`, `ON`; erro 1788 = já estava acima, seguir); `SET PERSIST_ONLY relay_log_recovery = ON; SET PERSIST_ONLY skip_replica_start = ON;`; reiniciar e conferir.
4. **Cópia:** no destino `RESET BINARY LOGS AND GTIDS;` (8.0: `RESET MASTER;`); de dentro do container de destino `mysqldump -h <origem> -P 3306 -uroot --single-transaction --source-data=2 --set-gtid-purged=ON --routines --triggers --events --databases <banco>` com a senha por `MYSQL_PWD`; importar. Antes do dump, `SHOW FULL PROCESSLIST` na origem (nada em "Waiting for global read lock"). Com MyISAM gravada com frequência, `--lock-all-tables`.
5. **Travar o destino:** `SET PERSIST read_only = ON; SET PERSIST super_read_only = ON;`
6. **Ligar:** `CHANGE REPLICATION SOURCE TO SOURCE_HOST=..., SOURCE_PORT=3306, SOURCE_USER='repl', SOURCE_PASSWORD=..., SOURCE_AUTO_POSITION=1, SOURCE_SSL=1, GET_SOURCE_PUBLIC_KEY=1; START REPLICA;` depois `RESET PERSIST IF EXISTS skip_replica_start;`.
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
| Porta 3306 aberta na internet | Publicar a porta no Swarm ignora o firewall do host | `bloquear-porta` (regra no `DOCKER-USER`, persistida) |

## Troca (promover a réplica a banco principal)
1. Parar as gravações na origem (manutenção) e esperar `status` com atraso 0 e `gtid_executed` igual.
2. No destino: `STOP REPLICA; RESET REPLICA ALL; SET PERSIST super_read_only = OFF; SET PERSIST read_only = OFF;`
3. Apontar as aplicações para o destino. Conferir gravação e leitura.
5. Lembrar que **os usuários da aplicação só existem na réplica se estavam na origem quando o `montar` rodou** (a skill copia os usuários nessa hora; criados depois replicam pelo binlog). Conferir os logins das aplicações antes de apontá-las. Depois, `RESET PERSIST read_only; RESET PERSIST super_read_only;` se quiser tirar os valores persistidos, e reabilitar eventos agendados (`event_scheduler`) se a aplicação usa.
4. A origem antiga fica desligada. Para inverter os papéis, monte a réplica nova a partir do servidor promovido num serviço MySQL novo (ou na origem antiga já limpa); `--refazer` só vale para destino que já seja réplica ou cópia da origem em questão e é recusado fora disso.

## Teste da skill
Roda em containers de teste (origem, duas réplicas e um servidor avulso) na mesma rede Docker (`mysql` com `--log-bin --gtid-mode=ON --enforce-gtid-consistency=ON` na origem), com `--origem-ssh local --destino-ssh local --origem-host <nome do container de origem>` e `REPLICAR_DIR_BASE` apontando para uma pasta temporária (sem precisar de root).

## Decisões e limites (revisão de 2026-10-25)
- **Um usuário de replicação por destino** (`repl_<destino sanitizado>`, até 32 caracteres), criado na origem com `sql_log_bin=0` para não ir ao binlog (assim não quebra outras réplicas). A skill nunca altera um usuário que não seja o seu; réplicas feitas à mão com outro usuário não são tocadas.
- **Replica-se o servidor inteiro:** o binlog leva todos os bancos de usuário; por isso o padrão é copiar todos e `--banco` só vale se a origem não tem outros. Contas `root`, `mysql.*` e `repl_*` não são copiadas; mudança futura na senha do `root` da origem replica para o `root` do destino.
- **Contagem de linhas:** exata só em tabelas com até 1 milhão de linhas estimadas; acima disso só `table_rows` (estimativa), para não varrer tabela grande em produção.
- **TLS:** `SOURCE_SSL=1` não verifica o certificado do servidor (aceitável dentro do Tailscale). **`MYSQL_PWD`** está obsoleto no MySQL 8+/9 (ainda funciona na 9.7); é o que evita senha em argumento. Arquivo de senha criado no Windows (CRLF) é tratado (`\r` removido).
- **`--refazer` que aborta antes de ligar** deixa a réplica parada (de propósito, `skip_replica_start=ON`); rode `montar --refazer` de novo ou `START REPLICA`.
- **`docker restart` do destino espera até 120 s** antes de matar o mysqld. No Swarm o container pode trocar de id: o script o procura de novo (não testado em Swarm).
