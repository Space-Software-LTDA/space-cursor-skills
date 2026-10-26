#!/usr/bin/env bash
# replicar-mysql.sh — monta e confere replicação MySQL (origem -> réplica) entre dois hosts.
# Subcomandos: ssh | listar | verificar | ponte | montar | status | bloquear-porta
# Regra dura: nenhuma senha em tela, argumento, log ou arquivo versionado. Nunca usar `set -x`.
set -euo pipefail

BASE="${REPLICAR_DIR_BASE:-/root}"   # onde ficam .replicacao/ e backups/ no host de destino (testes: outro caminho)
SSH_OPTS=(-o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new)
SISTEMA="'mysql','sys','information_schema','performance_schema'"
MIN_VERSAO=8.0.26
LIMITE_CONTAGEM=1000000   # tabelas com mais linhas estimadas que isto não têm COUNT(*) exato
FAIXA_INI=29901 FAIXA_FIM=29999   # portas reservadas às pontes (faixa 29900-29999)
IMG_SOCAT="alpine/socat:1.8.0.3"

OSSH="" OSERV="" DSSH="" DSERV="" BANCOS="" OHOST="" PORTA="" SID=""
PORTA_FORCADA=0 FORCAR_PORTA=0 PONTE_IP="" DRY_RUN=0 PORTAS_FW=""
TRAVAR=0 REFAZER=0 CONFIRMO=0 OPWF="" DPWF="" SEGUIR_LONGA=0 BANCO_INFORMADO=0
OCONT="" DCONT="" CANDS="" CANDS_N=0
FALHAS=0 AVISOS=0
OVERS="" OSID="" OUUID="" DVERS="" DUUID="" TAMANHO=0 SRC_UUID=""
PRECISA_PONTE=0
O_SERVICO="" O_PUBLICADA="" O_PONTE="" O_PONTE_BIND="" O_USADAS="" O_REDES=""
P_REDE="" P_ALVO=""
TS_ESTADO=""
ACESSIVEIS=()

uso() {
  cat <<'USO'
Uso: replicar-mysql.sh <ssh|listar|verificar|ponte|montar|status|bloquear-porta> [opções]
  ssh             confere o acesso SSH; se faltar, tenta as chaves que já existem nesta máquina e instala a chave da skill sozinha; só pede para colar onde nada funcionou
  listar          lista os serviços MySQL/MariaDB de cada host e sugere o par origem -> destino
  verificar       confere origem, rede e destino (não altera nada)
  ponte           cria (ou reaproveita) a ponte da origem: container socat só no IP do Tailscale, porta 29901-29999
  montar          faz o dump, importa e liga a replicação (cria a ponte se a origem não tiver porta)
  status          estado da réplica (aceita só o destino: descobre a origem pelo Source_Host/Port)
  bloquear-porta  fecha para a internet as portas de MySQL publicadas (script + serviço systemd, sobrevive ao reboot)
  --origem-ssh   root@ip | local     --origem-servico  nome do serviço (ex. projeto_servico)
  --destino-ssh  root@ip | local     --destino-servico nome do serviço
  --banco a,b    (opcional) padrão: TODOS os bancos de usuário da origem; só aceito se a origem não tiver outros
  --origem-host  host/IP que o DESTINO usa para falar com a origem (padrão: IP da ponte ou tailscale ip -4 da origem)
  --porta N      força a porta da origem (padrão: descoberta no serviço ou na ponte da casa)
  --ponte-ip IP  IP em que a ponte escuta (padrão: tailscale ip -4 da origem; testes usam outro IP local)
  --forcar-porta aceita porta de ponte fora da faixa 29900-29999
  --server-id N  (padrão: aleatório, diferente da origem e das outras réplicas)
  --travar-tudo  dump com --lock-all-tables (TRAVA AS GRAVAÇÕES da origem durante o dump inteiro)
  --seguir-com-consulta-longa  não parar por consulta longa rodando na origem
  --refazer      refaz réplica existente (só se o destino já for réplica desta origem, cópia dela ou vazio)
  --portas a,b   (bloquear-porta) portas a fechar; padrão: todas as de MySQL publicadas em 0.0.0.0/:: na origem
  --dry-run      (bloquear-porta) mostra o que faria, sem mudar nada
  --confirmo     obrigatório em montar, ponte (quando for criar) e bloquear-porta (sem --dry-run)
  --origem-senha-arquivo / --destino-senha-arquivo  caminho (no host remoto) com a senha root, se o container não tiver MYSQL_ROOT_PASSWORD
Variável: REPLICAR_DIR_BASE (padrão /root) — base de .replicacao/ e backups/ no host de destino.
USO
}

ok() { printf 'OK     %s\n' "$*"; }
av() { printf 'AVISO  %s\n' "$*"; AVISOS=$((AVISOS + 1)); }
fa() { printf 'FALHA  %s\n' "$*"; FALHAS=$((FALHAS + 1)); }
passo() { printf '\n[%s/8] %s\n' "$1" "$2"; }
morrer() { printf 'ERRO   %s\n' "$*" >&2; exit 1; }

# ---------- execução nos hosts ----------
hexec() { # lado(o|d) comando — o stdin passa para o comando remoto
  local lado=$1 cmd=$2 tgt
  if [ "$lado" = o ]; then tgt=$OSSH; else tgt=$DSSH; fi
  if [ "$tgt" = local ]; then bash -c "$cmd"; else ssh "${SSH_OPTS[@]}" "$tgt" "$cmd"; fi
}

rscript() { # lado "script sh" [args...] — roda um script POSIX no host (script pelo stdin; argumentos já validados)
  local lado=$1 script=$2 a args=""
  shift 2
  for a in "$@"; do args="$args '$a'"; done
  printf '%s\n' "$script" | hexec "$lado" "sh -s --$args"
}

eh_ip_ts() { # IP 100.64.0.0/10 é do Tailscale
  local b
  b=$(printf '%s' "$1" | sed -n 's/^100\.\([0-9]\{1,3\}\)\.[0-9]\{1,3\}\.[0-9]\{1,3\}$/\1/p')
  [ -n "$b" ] && [ "$b" -ge 64 ] && [ "$b" -le 127 ]
}

# ---------- SSH ----------
garantir_chave() { # garante ~/.ssh/id_ed25519(.pub) da máquina que roda a skill; nunca sobrescreve
  local k="$HOME/.ssh/id_ed25519"
  if [ -f "$k.pub" ]; then return 0; fi
  if [ -f "$k" ]; then
    echo "FALHA  existe a chave privada $k mas falta $k.pub. Gere a pública com: ssh-keygen -y -f $k > $k.pub"
    return 1
  fi
  mkdir -p "$HOME/.ssh"; chmod 700 "$HOME/.ssh"
  ssh-keygen -q -t ed25519 -N "" -C "replicar-mysql@$(hostname)" -f "$k" >/dev/null || { echo "FALHA  ssh-keygen falhou"; return 1; }
  echo "INFO   chave nova criada em $k.pub (a privada fica só nesta máquina)"
}

pub_da_skill() { awk '{print $1" "$2" replicar-mysql"; exit}' "$HOME/.ssh/id_ed25519.pub"; }

cmd_instalar_chave() { # chave pública -> comando remoto que a instala em ~/.ssh/authorized_keys (idempotente; sem aspas no transporte)
  local s b
  s="umask 077; mkdir -p ~/.ssh; chmod 700 ~/.ssh; touch ~/.ssh/authorized_keys; grep -qxF '$1' ~/.ssh/authorized_keys || printf '%s\\n' '$1' >> ~/.ssh/authorized_keys; chmod 600 ~/.ssh/authorized_keys; echo chave-instalada"
  b=$(printf '%s' "$s" | base64 | tr -d '\n')
  printf 'echo %s | base64 -d | sh' "$b"
}

estado_tailscale() { # lê o Tailscale desta máquina UMA vez: ausente | desligado | ligado
  local ts=""
  [ -z "$TS_ESTADO" ] || return 0
  if command -v tailscale >/dev/null 2>&1; then ts=tailscale
  elif [ -x "/c/Program Files/Tailscale/tailscale.exe" ]; then ts="/c/Program Files/Tailscale/tailscale.exe"; fi
  if [ -z "$ts" ]; then TS_ESTADO=ausente
  elif "$ts" status >/dev/null 2>&1; then TS_ESTADO=ligado
  else TS_ESTADO=desligado; fi
}

aviso_tailscale_local() { # IP 100.64.0.0/10 é do Tailscale: esta máquina precisa estar na mesma rede (mesmo texto para todos os hosts)
  local ip=${1#*@}
  ip=${ip%%:*}
  eh_ip_ts "$ip" || return 0
  estado_tailscale
  case $TS_ESTADO in
    ausente)
      echo "       $ip é um IP do Tailscale e esta máquina não tem o Tailscale. Instale e entre com a mesma conta dos servidores"
      echo "       (Windows: winget install Tailscale.Tailscale; Linux: curl -fsSL https://tailscale.com/install.sh | sh && tailscale up), ou use o IP público do servidor." ;;
    desligado)
      echo "       $ip é um IP do Tailscale e o Tailscale desta máquina está desligado ou sem login. Rode 'tailscale up' (ou abra o app) e tente de novo." ;;
    *)
      echo "       $ip é um IP do Tailscale e esta máquina está no Tailscale: confira se o servidor aparece em 'tailscale status' (mesma conta)." ;;
  esac
}

SSH_MOTIVO="" SSH_ERR=""
testar_ssh() { # host -> 0 se acessa; senão SSH_MOTIVO=rede|chave|hostkey|mudou e SSH_ERR
  local tgt=$1
  SSH_MOTIVO="" SSH_ERR=""
  if SSH_ERR=$(ssh "${SSH_OPTS[@]}" "$tgt" true 2>&1 >/dev/null); then return 0; fi
  if printf '%s' "$SSH_ERR" | grep -qi 'REMOTE HOST IDENTIFICATION HAS CHANGED'; then SSH_MOTIVO=mudou
  elif printf '%s' "$SSH_ERR" | grep -qi 'Host key verification failed'; then SSH_MOTIVO=hostkey
  elif printf '%s' "$SSH_ERR" | grep -qi 'Permission denied'; then SSH_MOTIVO=chave
  else SSH_MOTIVO=rede; fi
  return 1
}

chaves_candidatas() { # chaves privadas de ~/.ssh e IdentityFile do ~/.ssh/config (só caminhos; nunca o conteúdo)
  local d="$HOME/.ssh" f first
  {
    for f in "$d"/*; do
      [ -f "$f" ] || continue
      case "${f##*/}" in *.pub|known_hosts*|authorized_keys*|config|*.old|*.bak|id_ed25519) continue ;; esac
      first=$(head -n1 "$f" 2>/dev/null | head -c 80 || true)
      case "$first" in *"PRIVATE KEY"*) echo "$f" ;; esac
    done
    if [ -f "$d/config" ]; then
      sed -n 's/^[[:space:]]*[Ii]dentity[Ff]ile[[:space:]]\{1,\}//p' "$d/config" | tr -d '"' | sed "s|^~|$HOME|" | while IFS= read -r f; do
        if [ -f "$f" ]; then case "${f##*/}" in *.pub) ;; *) echo "$f" ;; esac; fi
      done
    fi
  } | sort -u || true
}

autorizar_sozinho() { # host -> 0 se conseguiu instalar a chave da skill (chave antiga ou salto por outro host)
  local tgt=$1 k pub inst h
  garantir_chave >/dev/null || return 1
  pub=$(pub_da_skill)
  inst=$(cmd_instalar_chave "$pub")
  while IFS= read -r k; do
    [ -n "$k" ] || continue
    if ssh -n -i "$k" -o IdentitiesOnly=yes "${SSH_OPTS[@]}" "$tgt" true >/dev/null 2>&1; then
      if ssh -n -i "$k" -o IdentitiesOnly=yes "${SSH_OPTS[@]}" "$tgt" "$inst" >/dev/null 2>&1 && testar_ssh "$tgt"; then
        echo "INFO   $tgt: a chave da skill foi instalada sozinha (entrei com a chave existente ${k##*/})"
        return 0
      fi
    fi
  done < <(chaves_candidatas)
  for h in ${ACESSIVEIS[@]+"${ACESSIVEIS[@]}"}; do
    [ "$h" != "$tgt" ] || continue
    if ssh -n "${SSH_OPTS[@]}" "$h" "ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new '$tgt' true" >/dev/null 2>&1; then
      if ssh -n "${SSH_OPTS[@]}" "$h" "ssh -o BatchMode=yes -o ConnectTimeout=10 -o StrictHostKeyChecking=accept-new '$tgt' '$inst'" >/dev/null 2>&1 && testar_ssh "$tgt"; then
        echo "INFO   $tgt: a chave da skill foi instalada sozinha (pulando por $h, que já era acessível)"
        return 0
      fi
    fi
  done
  return 1
}

instrucao_colar() { # host: último recurso — o usuário cola a chave no servidor
  local tgt=$1
  garantir_chave || return 1
  echo "FALHA  sem acesso SSH a $tgt: permissão negada, e nenhuma chave existente nesta máquina (nem outro servidor já acessível) entrou."
  echo "       Entre em $tgt como root (console ou terminal do provedor da VPS) e cole:"
  echo
  echo "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$(pub_da_skill)' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
  echo
  echo "       Depois rode este comando de novo."
}

acesso_ssh() { # confere origem e destino (pula local); 0 só se todos acessam
  local alvos=() falhou=() motivos=() errs=() t h i rc=0 ts_ip=0
  echo "== SSH =="
  [ -z "$OSSH" ] || alvos+=("$OSSH")
  if [ -n "$DSSH" ] && [ "$DSSH" != "$OSSH" ]; then alvos+=("$DSSH"); fi
  ACESSIVEIS=()
  for t in "${alvos[@]}"; do
    h=${t#*@}; h=${h%%:*}
    if eh_ip_ts "$h"; then ts_ip=1; fi
  done
  if [ "$ts_ip" = 1 ]; then
    estado_tailscale
    case $TS_ESTADO in
      ligado) echo "INFO   Tailscale desta máquina: ligado" ;;
      desligado) echo "INFO   Tailscale desta máquina: desligado ou sem login" ;;
      *) echo "INFO   Tailscale desta máquina: não instalado" ;;
    esac
  fi
  for t in "${alvos[@]}"; do
    if [ "$t" = local ]; then echo "INFO   $t: pulado (roda nesta máquina)"; continue; fi
    if testar_ssh "$t"; then ok "acesso SSH a $t"; ACESSIVEIS+=("$t"); else falhou+=("$t"); motivos+=("$SSH_MOTIVO"); errs+=("$(printf '%s' "$SSH_ERR" | head -n1)"); fi
  done
  for i in ${falhou[@]+"${!falhou[@]}"}; do
    t=${falhou[$i]}
    case ${motivos[$i]} in
      rede)
        echo "FALHA  sem acesso SSH a $t: o servidor não respondeu (tempo esgotado, host inalcançável, porta 22 fechada ou IP errado)."
        echo "       Confira o IP, o firewall (porta 22) e se o servidor está ligado. Detalhe: ${errs[$i]}"
        aviso_tailscale_local "$t"
        rc=1 ;;
      mudou)
        echo "FALHA  sem acesso SSH a $t: a chave do servidor MUDOU desde a última conexão (reinstalação do servidor ou alguém no meio do caminho)."
        echo "       A skill nunca aceita isso sozinha. Se você sabe que o servidor foi reinstalado, remova a linha antiga com: ssh-keygen -R ${t#*@}"
        rc=1 ;;
      hostkey)
        echo "FALHA  sem acesso SSH a $t: a chave do servidor não foi aceita (Host key verification failed). Detalhe: ${errs[$i]}"
        rc=1 ;;
      chave)
        if autorizar_sozinho "$t"; then ok "acesso SSH a $t"; ACESSIVEIS+=("$t"); else instrucao_colar "$t" || true; rc=1; fi ;;
    esac
  done
  return $rc
}

# ---------- containers ----------
setcont() { # lado -> preenche OCONT/DCONT; falha (1) se não achar exatamente um (CANDS/CANDS_N = o que achou)
  local lado=$1 serv out n
  if [ "$lado" = o ]; then serv=$OSERV; else serv=$DSERV; fi
  out=$(hexec "$lado" "docker ps --filter 'label=com.docker.swarm.service.name=$serv' --format '{{.Names}}'" 2>/dev/null) || out=""
  n=$(printf '%s' "$out" | grep -c . || true)
  if [ "$n" -eq 0 ]; then
    out=$(hexec "$lado" "docker ps --format '{{.Names}}'" 2>/dev/null | grep -E "^${serv//./\\.}(\\.|\$)" || true)
    n=$(printf '%s' "$out" | grep -c . || true)
  fi
  if [ "$n" -ne 1 ]; then CANDS=$(printf '%s' "$out" | tr '\n' ' '); CANDS_N=$n; return 1; fi
  if [ "$lado" = o ]; then OCONT=$out; else DCONT=$out; fi
}

msg_containers() { # serviço -> texto do problema (nenhum × vários)
  if [ "${CANDS_N:-0}" -gt 1 ]; then
    printf "há %s containers rodando para '%s': %s. Pare os que sobram (docker stop <nome>; o certo é o que 'docker service ps' mostra como Running) e rode de novo" "$CANDS_N" "$1" "$CANDS"
  else
    printf "container não achado (exatamente um) para '%s'. Candidatos: %s" "$1" "${CANDS:-nenhum}"
  fi
}

guarda() { # re-acha os dois containers antes de cada passo; nenhum ou mais de um = para (antes de qualquer escrita do passo)
  setcont o || morrer "origem: $(msg_containers "$OSERV")"
  setcont d || morrer "destino: $(msg_containers "$DSERV")"
}

mcmd() { # lado [flags] -> comando de host que lê SQL do stdin, como root; senha vem do container (nunca em argumento)
  local lado=$1 fl=${2:--N -B} c f
  if [ "$lado" = o ]; then c=$OCONT; f=$OPWF; else c=$DCONT; f=$DPWF; fi
  if [ -n "$f" ]; then
    printf "MYSQL_PWD=\"\$(tr -d '\\\\r' < '%s')\" docker exec -i -e MYSQL_PWD %s mysql -uroot %s" "$f" "$c" "$fl"
  else
    printf "docker exec -i %s sh -c 'MYSQL_PWD=\"\$MYSQL_ROOT_PASSWORD\" exec mysql -uroot %s'" "$c" "$fl"
  fi
}
q()  { printf '%s\n' "$2" | hexec "$1" "$(mcmd "$1")" 2>/dev/null; }          # silencioso, devolve linhas (tab)
qr() { printf '%s\n' "$2" | hexec "$1" "$(mcmd "$1" '-N -B -r')" 2>/dev/null; } # sem escape (SHOW CREATE USER etc.)
qe() { printf '%s\n' "$2" | hexec "$1" "$(mcmd "$1")"; }                      # mostra os erros do MySQL

pwcmd() { # comando, no host de origem, que imprime a senha root da origem numa linha
  if [ -n "$OPWF" ]; then printf "{ tr -d '\\\\r' < '%s'; echo; }" "$OPWF"; else printf "{ docker exec %s printenv MYSQL_ROOT_PASSWORD; echo; }" "$OCONT"; fi
}

via_tcp() { # SQL no stdin; roda mysql DE DENTRO do container de destino contra origem-host:porta (o caminho do dump)
  { hexec o "$(pwcmd)" </dev/null; cat; } |
    hexec d "docker exec -i $DCONT sh -c 'IFS= read -r MYSQL_PWD; export MYSQL_PWD; exec mysql -h $OHOST -P $PORTA -uroot -N -B'" 2>/dev/null
}

esperar_mysql() { # lado, segundos
  local lado=$1 max=${2:-120} t=0
  while [ "$t" -lt "$max" ]; do
    if setcont "$lado" 2>/dev/null && q "$lado" 'SELECT 1' >/dev/null; then return 0; fi
    sleep 3; t=$((t + 3))
  done
  return 1
}

ver_ge() { # a >= b ?
  local a=${1%%-*} b=${2%%-*}
  [ "$(printf '%s\n%s\n' "$b" "$a" | sort -V | head -n1)" = "$b" ]
}

lista_sql() {
  local out="" b arr
  IFS=, read -ra arr <<<"$BANCOS"
  for b in "${arr[@]}"; do out="$out${out:+,}'$b'"; done
  printf '%s' "$out"
}

# ---------- scripts que rodam no host (POSIX sh, pelo stdin) ----------
# Funções comuns: achar a ponte de um conjunto de nomes e listar os MySQL do host.
IFS= read -r -d '' RS_COMUM <<'RSEOF' || true
eh_mysql() {
  case "$1" in
    mysql|mysql:*|*/mysql|*/mysql:*|mariadb|mariadb:*|*/mariadb|*/mariadb:*|percona|percona:*|*/percona|*/percona:*) return 0 ;;
  esac
  return 1
}
achar_ponte() { # nomes (separados por espaço) -> nome do container da ponte que aponta para algum deles
  for p in $(docker ps --format '{{.Names}}' </dev/null | grep -E '^replicacao-.*-ponte-[0-9]+$'); do
    alvo=$(docker inspect "$p" --format '{{range .Args}}{{.}} {{end}}' </dev/null | sed -n 's/.*[Tt][Cc][Pp]:\([^: ]*\):[0-9]*.*/\1/p' | tr 'A-Z' 'a-z')
    [ -n "$alvo" ] || continue
    for a in $1; do
      a=$(printf '%s' "$a" | tr 'A-Z' 'a-z')
      if [ "$a" = "$alvo" ]; then echo "$p"; return 0; fi
    done
  done
  return 1
}
nomes_da() { # id nome servico -> serviço + aliases (ou nome do container)
  if [ -n "$3" ]; then
    printf '%s ' "$3"
    docker service inspect "$3" --format '{{range .Spec.TaskTemplate.Networks}}{{range .Aliases}}{{.}} {{end}}{{end}}' </dev/null 2>/dev/null
  else
    printf '%s' "$2"
  fi
}
lista_mysql() { # rep|norep -> linhas TSV: servico nome imagem publicada ponte(porta) aliases(vírgula) replica(host:porta|nao|?)
  docker ps --format '{{.ID}}|{{.Names}}|{{.Image}}|{{.Label "com.docker.swarm.service.name"}}' </dev/null | while IFS='|' read -r id nm img sv; do
    eh_mysql "$img" || continue
    svc=${sv:-$nm}
    if [ -n "$sv" ]; then
      pub=$(docker service inspect "$sv" --format '{{range .Endpoint.Ports}}{{if eq .TargetPort 3306}}{{.PublishedPort}} {{end}}{{end}}' </dev/null 2>/dev/null | awk '{print $1}')
    else
      pub=$(docker port "$id" 3306/tcp </dev/null 2>/dev/null | head -n1 | sed 's/.*://')
    fi
    al=$(nomes_da "$id" "$nm" "$sv")
    pt=$(achar_ponte "$al" | sed 's/.*-ponte-//')
    rep=-
    if [ "$1" = rep ]; then
      if out=$(docker exec "$id" sh -c 'MYSQL_PWD="$MYSQL_ROOT_PASSWORD" mysql -uroot -N -B -e "SELECT CONCAT(host,\":\",port) FROM performance_schema.replication_connection_configuration LIMIT 1" 2>/dev/null' </dev/null); then
        rep=${out:-nao}
      else
        rep='?'
      fi
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$svc" "$nm" "$img" "${pub:--}" "${pt:--}" "$(printf '%s' "$al" | tr -s ' ' ',' | sed 's/,$//')" "$rep"
  done
}
RSEOF

# $1 = nome do container MySQL; imprime SERVICO=, PUBLICADA=, REDE=, PONTE=, PONTE_BIND=, USADAS=
IFS= read -r -d '' RS_DESC <<'RSEOF' || true
cont="$1"
sv=$(docker inspect -f '{{index .Config.Labels "com.docker.swarm.service.name"}}' "$cont" </dev/null 2>/dev/null)
echo "SERVICO=$sv"
nm=$(docker inspect -f '{{.Name}}' "$cont" </dev/null | sed 's#^/##')
if [ -n "$sv" ]; then
  echo "PUBLICADA=$(docker service inspect "$sv" --format '{{range .Endpoint.Ports}}{{if eq .TargetPort 3306}}{{.PublishedPort}} {{end}}{{end}}' </dev/null 2>/dev/null | awk '{print $1}')"
  docker service inspect "$sv" --format '{{range .Spec.TaskTemplate.Networks}}{{.Target}} {{range .Aliases}}{{.}} {{end}}{{"\n"}}{{end}}' </dev/null 2>/dev/null | while read -r nid al; do
    [ -n "$nid" ] || continue
    inf=$(docker network inspect "$nid" --format '{{.Name}} {{.Attachable}}' </dev/null 2>/dev/null) || continue
    echo "REDE=$inf $al"
  done
else
  echo "PUBLICADA=$(docker port "$cont" 3306/tcp </dev/null 2>/dev/null | head -n1 | sed 's/.*://')"
  docker inspect "$cont" --format '{{range $k,$v := .NetworkSettings.Networks}}{{$k}}{{"\n"}}{{end}}' </dev/null | while read -r rn; do
    case "$rn" in ''|bridge|host|none) continue ;; esac
    echo "REDE=$rn true $nm"
  done
fi
al=$(nomes_da "$cont" "$nm" "$sv")
p=$(achar_ponte "$al")
if [ -n "$p" ]; then
  echo "PONTE=$p"
  echo "PONTE_BIND=$(docker port "$p" 3306/tcp </dev/null 2>/dev/null | head -n1)"
fi
usadas=$( { ss -Hltn 2>/dev/null | awk '{n=split($4,a,":"); print a[n]}'
  docker ps --format '{{.Ports}}' </dev/null 2>/dev/null | tr ',' '\n' | sed -n 's/.*:\([0-9][0-9]*\)->.*/\1/p'
  for s in $(docker service ls -q </dev/null 2>/dev/null); do docker service inspect "$s" --format '{{range .Endpoint.Ports}}{{.PublishedPort}} {{end}}' </dev/null 2>/dev/null | tr ' ' '\n'; done; } | grep -E '^[0-9]+$' | sort -un | tr '\n' ' ')
echo "USADAS=$usadas"
RSEOF

# ---------- descoberta da origem (P6) e ponte (P7/P12) ----------
descobrir_origem() { # preenche O_* a partir do container da origem (OCONT)
  local l k v
  O_SERVICO="" O_PUBLICADA="" O_PONTE="" O_PONTE_BIND="" O_USADAS="" O_REDES=""
  while IFS= read -r l; do
    k=${l%%=*}; v=${l#*=}
    case $k in
      SERVICO) O_SERVICO=$v ;;
      PUBLICADA) O_PUBLICADA=$v ;;
      PONTE) O_PONTE=$v ;;
      PONTE_BIND) O_PONTE_BIND=$v ;;
      USADAS) O_USADAS=$v ;;
      REDE) O_REDES="$O_REDES$v"$'\n' ;;
    esac
  done < <(rscript o "$RS_COMUM
$RS_DESC" "$OCONT" || true)
}

porta_em_uso() { case " $O_USADAS " in *" $1 "*) return 0 ;; esac; return 1; }

proxima_porta_livre() {
  local p
  for p in $(seq "$FAIXA_INI" "$FAIXA_FIM"); do
    if ! porta_em_uso "$p"; then echo "$p"; return 0; fi
  done
  return 1
}

casa_nome() { printf '%s' "${O_SERVICO:-$OSERV}" | tr 'A-Z' 'a-z' | tr -c 'a-z0-9\n-' '-' | sed 's/^-*//; s/-*$//'; }

escolher_rede() { # preenche P_REDE e P_ALVO a partir de O_REDES (linhas: nome attachable alias...)
  local l n att al melhor="" outro="" fallback=""
  P_REDE="" P_ALVO=""
  while IFS= read -r l; do
    [ -n "$l" ] || continue
    # shellcheck disable=SC2086
    set -- $l
    n=$1; att=${2:-false}; al=${3:-${O_SERVICO:-$OSERV}}
    if [ "$att" != true ]; then fallback=${fallback:-$n}; continue; fi
    case $n in
      easypanel-*) [ -n "$melhor" ] || melhor="$n $al" ;;
      *) [ -n "$outro" ] || outro="$n $al" ;;
    esac
  done <<<"$O_REDES"
  melhor=${melhor:-$outro}
  if [ -z "$melhor" ]; then
    if [ -n "$fallback" ]; then
      morrer "a rede '$fallback' do serviço de origem não é 'attachable': a ponte não consegue entrar nela. Marque a rede como attachable ou publique a porta pelo EasyPanel (Exposed Port, reinicia o MySQL)"
    fi
    morrer "não achei rede do container de origem para ligar a ponte (container só na rede bridge padrão não é suportado)"
  fi
  P_REDE=${melhor%% *}; P_ALVO=${melhor#* }
}

testar_porta_host() { # lado ip porta -> 0 se abre conexão TCP (a partir do próprio host)
  hexec "$1" "timeout 5 bash -c 'exec 3<>/dev/tcp/$2/$3' 2>/dev/null" </dev/null
}

ip_tailscale_origem() { hexec o "tailscale ip -4 2>/dev/null | head -n1" </dev/null 2>/dev/null || true; }

fazer_ponte() { # cria (ou reaproveita) a ponte da casa; preenche PORTA e OHOST (se vazio)
  local ip porta casa nome bind
  if [ -n "$O_PONTE" ]; then
    porta=${O_PONTE##*-ponte-}
    ip=${O_PONTE_BIND%:*}
    if testar_porta_host o "$ip" "$porta"; then
      ok "ponte da casa já existe e responde: $O_PONTE ($ip:$porta)"
      PORTA=$porta; [ -n "$OHOST" ] || OHOST=$ip
      return 0
    fi
    morrer "a ponte $O_PONTE existe mas não responde em $ip:$porta (o Tailscale subiu depois do Docker? veja 'docker logs $O_PONTE' e 'docker restart $O_PONTE')"
  fi
  [ "$CONFIRMO" = 1 ] || morrer "criar a ponte mexe no host de origem e exige --confirmo"
  ip=${PONTE_IP:-$(ip_tailscale_origem)}
  [ -n "$ip" ] || morrer "não achei o IP do Tailscale da origem para a ponte; passe --ponte-ip"
  if [ "$PORTA_FORCADA" = 1 ]; then
    porta=$PORTA
    if { [ "$porta" -lt 29900 ] || [ "$porta" -gt 29999 ]; } && [ "$FORCAR_PORTA" != 1 ]; then
      morrer "porta $porta fora da faixa 29900-29999 reservada às pontes. Use uma da faixa ou --forcar-porta"
    fi
    if porta_em_uso "$porta"; then morrer "porta $porta já está em uso no host de origem"; fi
  else
    porta=$(proxima_porta_livre) || morrer "nenhuma porta livre na faixa $FAIXA_INI-$FAIXA_FIM"
  fi
  escolher_rede
  casa=$(casa_nome)
  [[ $casa =~ ^[a-z0-9][a-z0-9-]*$ ]] || morrer "nome de casa inválido para a ponte: '$casa'"
  nome="replicacao-$casa-ponte-$porta"
  echo "       criando a ponte $nome: $ip:$porta -> $P_ALVO:3306 na rede $P_REDE (imagem $IMG_SOCAT, reinício automático)"
  hexec o "docker run -d --name '$nome' --restart unless-stopped --network '$P_REDE' --label replicacao.casa='$casa' -p '$ip:$porta:3306' '$IMG_SOCAT' 'TCP-LISTEN:3306,fork,reuseaddr' 'TCP:$P_ALVO:3306'" </dev/null >/dev/null ||
    morrer "docker run da ponte falhou (porta $ip:$porta ocupada ou IP $ip não existe no host?)"
  sleep 2
  bind=$(hexec o "docker port '$nome' 3306/tcp 2>/dev/null | head -n1" </dev/null || true)
  [ "${bind%:*}" = "$ip" ] || morrer "a ponte $nome não ficou presa ao IP $ip (bind: ${bind:-nenhum})"
  testar_porta_host o "$ip" "$porta" || morrer "a ponte $nome subiu mas não responde em $ip:$porta"
  ok "ponte criada: $nome escutando só em $ip:$porta (sem reiniciar o MySQL e sem abrir a internet)"
  PORTA=$porta; O_PONTE=$nome; O_PONTE_BIND="$ip:$porta"
  [ -n "$OHOST" ] || OHOST=$ip
}

relatorio_acesso() { # P11: o que o usuário precisa saber sobre a porta da origem
  echo
  echo "Porta da origem e acesso:"
  if [ -n "$O_PONTE" ]; then
    echo "  - A porta ${O_PONTE##*-ponte-} é da PONTE da réplica ($O_PONTE): reservada. Não use essa porta no EasyPanel (Exposed Port)."
    echo "  - Para acessar o banco da origem pelo Tailscale: ${O_PONTE_BIND:-${OHOST:-<ip-tailscale>}:$PORTA} (usuário e senha da aplicação, como sempre)."
  else
    echo "  - A réplica usa a porta publicada $PORTA em ${OHOST:-<ip-tailscale>}. Não troque essa porta no EasyPanel sem refazer o CHANGE REPLICATION SOURCE do destino."
    echo "  - Para acessar o banco pelo Tailscale: ${OHOST:-<ip-tailscale>}:$PORTA."
  fi
  echo "  - Reiniciar ou fazer deploy do MySQL pelo EasyPanel NÃO quebra a réplica: ela reconecta sozinha (confira com 'status')."
  echo "  - Se o servidor de origem reiniciar e o Tailscale subir depois do Docker, a ponte pode falhar o bind: 'status' mostra; 'docker restart <ponte>' resolve."
}

# ---------- validação de argumentos ----------
validar() {
  local re_ssh='^(local|[A-Za-z0-9_.-]+@[A-Za-z0-9_.:-]+|[A-Za-z0-9_.-]+)$' re_n='^[A-Za-z0-9_.-]+$' b arr
  [[ $OSSH =~ $re_ssh ]] || [ -z "$OSSH" ] || morrer "--origem-ssh inválido"
  [[ $DSSH =~ $re_ssh ]] || [ -z "$DSSH" ] || morrer "--destino-ssh inválido"
  [[ $OSERV =~ $re_n ]] || [ -z "$OSERV" ] || morrer "--origem-servico inválido"
  [[ $DSERV =~ $re_n ]] || [ -z "$DSERV" ] || morrer "--destino-servico inválido"
  [[ $OHOST =~ ^[A-Za-z0-9_.:-]*$ ]] || morrer "--origem-host inválido"
  [[ $PONTE_IP =~ ^[0-9.]*$ ]] || morrer "--ponte-ip inválido (use um IPv4)"
  [[ $PORTA =~ ^[0-9]*$ ]] || morrer "--porta inválida"
  [[ $SID =~ ^[0-9]*$ ]] || morrer "--server-id inválido"
  [[ $PORTAS_FW =~ ^[0-9,]*$ ]] || morrer "--portas inválido (números separados por vírgula)"
  [[ $BANCOS =~ ^[A-Za-z0-9_,]*$ ]] || morrer "--banco inválido (use letras, números, _ e vírgula)"
  if [ -n "$BANCOS" ]; then
    IFS=, read -ra arr <<<"$BANCOS"
    for b in "${arr[@]}"; do [ -n "$b" ] || morrer "--banco com item vazio"; done
    BANCO_INFORMADO=1
  fi
  [[ $OPWF =~ ^[A-Za-z0-9_./-]*$ ]] || morrer "--origem-senha-arquivo inválido"
  [[ $DPWF =~ ^[A-Za-z0-9_./-]*$ ]] || morrer "--destino-senha-arquivo inválido"
  if [ -n "$PORTA" ]; then PORTA_FORCADA=1; fi
}

exigir() { local v; for v in "$@"; do [ -n "${!v}" ] || morrer "falta opção: $v"; done; }

repl_usuario() { # um usuário de replicação por destino: repl_<destino sanitizado>, até 32 caracteres
  local s
  s=$(printf '%s' "$DSERV" | tr 'A-Z' 'a-z' | tr -c 'a-z0-9_' '_')
  printf 'repl_%s' "$s" | cut -c1-32
}

consultas_longas() { # limite em segundos -> quantidade na origem
  q o "SELECT COUNT(*) FROM performance_schema.processlist WHERE command<>'Sleep' AND time>$1 AND ID<>CONNECTION_ID() AND command NOT LIKE 'Binlog Dump%' AND user NOT IN ('system user','event_scheduler') AND (info IS NULL OR info NOT LIKE '%processlist%')" || echo 0
}

# ---------- listar (P5) ----------
nome_casa_tokens() { # nome do serviço -> palavras da casa, sem as genéricas de banco
  printf '%s' "$1" | tr 'A-Z' 'a-z' | tr '_.-' '\n\n\n' | grep -vxE 'database|databasse|databases|db|bd|banco|mysql|mariadb|[0-9]*' | grep -E '.{3,}' | sort -u || true
}

pontuacao_casa() { # serviço-a serviço-b -> quantas palavras de casa coincidem (iguais ou uma prefixo da outra, >= 4 letras)
  local a b ta tb n=0
  ta=$(nome_casa_tokens "$1"); tb=$(nome_casa_tokens "$2")
  for a in $ta; do
    for b in $tb; do
      if [ "$a" = "$b" ]; then n=$((n + 1)); continue; fi
      if [ "${#a}" -ge 4 ] && [ "${#b}" -ge 4 ] && { [[ $a == "$b"* ]] || [[ $b == "$a"* ]]; }; then n=$((n + 1)); fi
    done
  done
  echo "$n"
}

listar() {
  local lado alvo lbl svc img pub pt al rep nota
  local os=() ds=() o d best bestn sc cnt
  acesso_ssh || return 1
  for lado in o d; do
    if [ "$lado" = o ]; then alvo=$OSSH; lbl=ORIGEM; else alvo=$DSSH; lbl=DESTINO; fi
    [ -n "$alvo" ] || continue
    echo
    echo "== $lbl ($alvo): serviços MySQL/MariaDB =="
    printf '%-42s %-14s %-9s %-8s %s\n' "SERVICO" "IMAGEM" "PORTA" "PONTE" "REPLICA?"
    while IFS=$'\t' read -r svc _ img pub pt al rep; do
      [ -n "$svc" ] || continue
      case $rep in nao) nota="não" ;; '?') nota="? (sem root no container)" ;; *) nota="SIM, de $rep" ;; esac
      printf '%-42s %-14s %-9s %-8s %s\n' "$svc" "$img" "$pub" "$pt" "$nota"
      if [ "$lado" = o ]; then os+=("$svc"); else ds+=("$svc"); fi
    done < <(rscript "$lado" "$RS_COMUM
lista_mysql rep" || true)
    if [ "$lado" = o ] && [ "${#os[@]}" -eq 0 ]; then echo "(nenhum serviço MySQL/MariaDB achado)"; fi
    if [ "$lado" = d ] && [ "${#ds[@]}" -eq 0 ]; then echo "(nenhum serviço MySQL/MariaDB achado)"; fi
  done
  if [ "${#os[@]}" -gt 0 ] && [ "${#ds[@]}" -gt 0 ]; then
    echo
    echo "== Sugestão de pares (pelo nome da casa; CONFIRME a casa com o usuário antes de 'verificar') =="
    for o in "${os[@]}"; do
      best="" bestn=0 cnt=0
      for d in "${ds[@]}"; do
        sc=$(pontuacao_casa "$o" "$d")
        if [ "$sc" -gt "$bestn" ]; then best=$d; bestn=$sc; cnt=1; elif [ "$sc" -eq "$bestn" ] && [ "$sc" -gt 0 ]; then cnt=$((cnt + 1)); fi
      done
      if [ "$cnt" -eq 1 ] && [ "$bestn" -gt 0 ]; then echo "SUGESTAO  origem $o  ->  destino $best"
      elif [ "$cnt" -gt 1 ]; then echo "AMBIGUO   origem $o: mais de um destino parecido; pergunte ao usuário"
      else echo "SEM PAR   origem $o: nenhum destino com o mesmo nome de casa"; fi
    done
  fi
}

# ---------- rede ----------
checar_rede() { # login root de dentro do destino em OHOST:PORTA chega na origem (server_uuid confere)
  local tcp tuuid cipher
  if [ -n "$OHOST" ] && [ -n "$PORTA" ] && tcp=$(printf "SELECT @@server_uuid;\nSHOW STATUS LIKE 'Ssl_cipher';\n" | via_tcp) && [ -n "$tcp" ]; then
    tuuid=$(printf '%s\n' "$tcp" | sed -n '1p'); cipher=$(printf '%s\n' "$tcp" | sed -n 's/^Ssl_cipher\t//p')
    if [ "$tuuid" = "$OUUID" ]; then ok "login root de dentro do destino em $OHOST:$PORTA chega na origem (server_uuid confere)"; else
      fa "$OHOST:$PORTA visto de dentro do destino NÃO é a origem informada (server_uuid diferente). Confira --origem-host e --porta"; fi
    if [ -n "$cipher" ]; then ok "conexão do dump usa TLS"; else av "conexão do dump sem TLS"; fi
  else fa "container do destino não conseguiu logar como root em $OHOST:${PORTA:-?} (rede/Tailscale, porta publicada, root@'%' ou senha)"; fi
}

avaliar_porta() { # P8: onde a porta da origem escuta (ss) e se está exposta
  local listen addrs a wild=0 ts="" outro="" regra
  listen=$(hexec o "ss -Hltn 2>/dev/null | awk '{print \$4}'" </dev/null 2>/dev/null || true)
  addrs=$(printf '%s\n' "$listen" | grep -E ":${PORTA}\$" | sed -E 's/%[^:]*:/:/; s/:[0-9]+$//; s/^\[(.*)\]$/\1/' | sort -u || true)
  if [ -z "$addrs" ]; then
    av "porta $PORTA não aparece escutando no host de origem (ss); não consegui avaliar a exposição"
    return 0
  fi
  while IFS= read -r a; do
    [ -n "$a" ] || continue
    case $a in
      0.0.0.0|::|'*') wild=1 ;;
      *) if eh_ip_ts "$a"; then ts="$ts$a "; else outro="$outro$a "; fi ;;
    esac
  done <<<"$addrs"
  if [ "$wild" = 0 ] && [ -z "$outro" ]; then ok "porta $PORTA só no Tailscale (escuta em ${ts% })"; return 0; fi
  if [ "$wild" = 0 ]; then av "porta $PORTA escuta só em ${outro% } (não é IP do Tailscale): confirme que esse IP não é público"; return 0; fi
  if regra=$(hexec o "iptables -S DOCKER-USER 2>/dev/null" </dev/null 2>/dev/null) && [ -n "$regra" ]; then
    if printf '%s\n' "$regra" | grep -q -- "ctorigdstport $PORTA .*DROP"; then ok "porta $PORTA bloqueada para a internet (DOCKER-USER)"; else
      av "porta $PORTA aberta na internet (escuta em 0.0.0.0/:: e sem regra DROP no DOCKER-USER). Use: bloquear-porta --confirmo"; fi
  else av "não foi possível ler o iptables do host de origem (sem root ou sem iptables); porta $PORTA não verificada"; fi
}

# ---------- verificar ----------
verificar() {
  FALHAS=0; AVISOS=0; PRECISA_PONTE=0
  local row overs olog ofmt ogtid oenf osid ouuid dvers rotulo_host
  acesso_ssh || return 1
  echo "== Origem =="
  if setcont o; then ok "container da origem: $OCONT"; else
    fa "origem: $(msg_containers "$OSERV")"; fi
  if [ -n "$OCONT" ]; then
    if row=$(q o 'SELECT @@version,@@log_bin,@@binlog_format,@@gtid_mode,@@enforce_gtid_consistency,@@server_id,@@server_uuid'); then
      IFS=$'\t' read -r overs olog ofmt ogtid oenf osid ouuid <<<"$row"
      ok "root da origem funciona (MySQL $overs)"
      if ver_ge "$overs" "$MIN_VERSAO"; then ok "versão da origem >= $MIN_VERSAO"; else fa "versão da origem $overs < $MIN_VERSAO"; fi
      if [ "$olog" = 1 ]; then ok "log_bin=ON"; else fa "log_bin desligado na origem. Ligue (--log-bin) e reinicie; a skill não mexe na origem"; fi
      if [ "$ofmt" = ROW ]; then ok "binlog_format=ROW"; else fa "binlog_format=$ofmt (precisa ROW). Ajuste na origem; a skill não mexe nela"; fi
      if [ "$ogtid" = ON ]; then ok "gtid_mode=ON"; else fa "gtid_mode=$ogtid na origem (precisa ON, via OFF_PERMISSIVE, ON_PERMISSIVE, ON). A skill não mexe na origem"; fi
      if [ "$oenf" = ON ]; then ok "enforce_gtid_consistency=ON"; else fa "enforce_gtid_consistency=$oenf na origem (precisa ON). A skill não mexe na origem"; fi
      ok "server_id da origem = $osid"
      OVERS=$overs; OSID=$osid; OUUID=$ouuid
      local todos outros n_ok tot lista ntab myi big lock
      todos=$(q o "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ($SISTEMA) ORDER BY 1" | tr '\n' ',' | sed 's/,$//' || true)
      if [ "$BANCO_INFORMADO" = 0 ]; then
        BANCOS=$todos
        if [ -z "$BANCOS" ]; then fa "a origem não tem bancos de usuário"; else ok "bancos a replicar (todos os de usuário da origem): $BANCOS"; fi
        if [ -n "$BANCOS" ] && ! [[ $BANCOS =~ ^[A-Za-z0-9_,]+$ ]]; then fa "a origem tem banco com nome fora de [A-Za-z0-9_] (não suportado pela skill): $BANCOS"; BANCOS=""; fi
      fi
      if [ -n "$BANCOS" ]; then
        lista=$(lista_sql)
        outros=$(q o "SELECT schema_name FROM information_schema.schemata WHERE schema_name NOT IN ($SISTEMA) AND schema_name NOT IN ($lista) ORDER BY 1" | tr '\n' ' ' || true)
        if [ -n "$outros" ]; then
          fa "a origem tem outros bancos de usuário além de --banco: $outros. A réplica recebe o binlog de TODOS (pararia com erro na primeira gravação). Omita --banco para replicar todos"
        fi
        n_ok=$(q o "SELECT COUNT(*) FROM information_schema.schemata WHERE schema_name IN ($lista)" || echo 0)
        tot=$(printf '%s' "$BANCOS" | tr ',' '\n' | grep -c .)
        if [ "$n_ok" = "$tot" ]; then ok "banco(s) existem na origem: $BANCOS"; else fa "banco(s) não encontrados na origem ($n_ok de $tot): $BANCOS"; fi
        ntab=$(q o "SELECT CONCAT(COALESCE(engine,'?'),'=',COUNT(*)) FROM information_schema.tables WHERE table_schema IN ($lista) AND table_type='BASE TABLE' GROUP BY engine" | tr '\n' ' ' || true)
        ok "tabelas por engine: ${ntab:-nenhuma}"
        myi=$(q o "SELECT CONCAT(table_schema,'.',table_name) FROM information_schema.tables WHERE table_schema IN ($lista) AND engine='MyISAM'" | tr '\n' ' ' || true)
        if [ -n "$myi" ]; then av "tabelas MyISAM (sem transação; --travar-tudo dá consistência mas TRAVA AS GRAVAÇÕES da origem durante o dump inteiro): $myi"; fi
        TAMANHO=$(q o "SELECT COALESCE(SUM(data_length+index_length),0) FROM information_schema.tables WHERE table_schema IN ($lista)" || echo 0)
        ok "tamanho dos dados: $((TAMANHO / 1048576)) MB"
      fi
      big=$(consultas_longas 60)
      if [ "${big:-0}" -gt 0 ]; then
        if [ "$SEGUIR_LONGA" = 1 ]; then av "$big consulta(s) há mais de 60 s na origem (seguindo por --seguir-com-consulta-longa)"; else
          fa "$big consulta(s) rodando há mais de 60 s na origem: o dump espera por elas segurando as gravações. Espere ou use --seguir-com-consulta-longa"; fi
      else ok "nenhuma consulta longa na origem"; fi
      lock=$(q o "SELECT COUNT(*) FROM performance_schema.processlist WHERE state LIKE 'Waiting for global read lock%'" || echo 0)
      if [ "${lock:-0}" -gt 0 ]; then fa "origem com espera de trava global ($lock). Aguarde e rode de novo"; fi
    else fa "root da origem não conectou (confira MYSQL_ROOT_PASSWORD do container ou --origem-senha-arquivo)"; fi

    # porta da origem (P6): --porta só força; senão ponte da casa, depois porta publicada do serviço, senão ponte nova
    echo "== Porta da origem =="
    descobrir_origem
    if [ "$PORTA_FORCADA" = 1 ]; then
      ok "porta $PORTA informada por --porta (forçada)"
    elif [ -n "$O_PONTE" ]; then
      PORTA=${O_PONTE##*-ponte-}
      [ -n "$OHOST" ] || OHOST=${O_PONTE_BIND%:*}
      ok "ponte da casa: $O_PONTE ($O_PONTE_BIND)"
    elif [ -n "$O_PUBLICADA" ]; then
      PORTA=$O_PUBLICADA
      ok "porta publicada do serviço de origem: $PORTA"
    else
      PRECISA_PONTE=1
      PORTA=$(proxima_porta_livre || true)
      av "o serviço de origem não tem porta publicada. O 'montar' cria a ponte (container socat só no IP do Tailscale, porta ${PORTA:-?} da faixa 29900-29999): sem reiniciar o MySQL e sem abrir a internet. Rede ainda não testada"
    fi
  fi
  if [ "$PRECISA_PONTE" = 1 ]; then
    echo "INFO   exposição da porta será avaliada depois que a ponte existir"
  elif [ -n "$PORTA" ]; then
    avaliar_porta
  fi

  echo "== Rede =="
  if [ -z "$OHOST" ]; then
    if [ -n "$PONTE_IP" ]; then OHOST=$PONTE_IP; rotulo_host="--ponte-ip"; else OHOST=$(ip_tailscale_origem); rotulo_host="tailscale"; fi
    if [ -n "$OHOST" ]; then ok "origem-host ($rotulo_host): $OHOST"; else fa "não achei o IP do Tailscale da origem; passe --origem-host"; fi
  else ok "origem-host: $OHOST"; fi

  echo "== Destino =="
  if setcont d; then ok "container do destino: $DCONT"; else
    fa "destino: $(msg_containers "$DSERV")"; fi
  if [ -n "$DCONT" ]; then
    if row=$(q d 'SELECT @@version,@@server_uuid,@@server_id'); then
      local dsid
      IFS=$'\t' read -r dvers DUUID dsid <<<"$row"
      ok "root do destino funciona (MySQL $dvers)"
      DVERS=$dvers
      if ver_ge "$dvers" "$MIN_VERSAO"; then ok "versão do destino >= $MIN_VERSAO"; else fa "versão do destino $dvers < $MIN_VERSAO"; fi
      if [ -n "$OVERS" ]; then
        if ver_ge "$dvers" "$OVERS"; then ok "versão do destino ($dvers) >= origem ($OVERS)"; else fa "versão do destino ($dvers) < origem ($OVERS)"; fi
        if [ "${dvers%.*}" != "${OVERS%.*}" ]; then av "séries diferentes (origem ${OVERS%.*}, destino ${dvers%.*}): a Oracle só suporta réplica entre séries vizinhas"; fi
      fi
      # identidade: destino nunca pode ser a origem
      if [ -n "$OUUID" ]; then
        local ids
        if [ "$DUUID" = "$OUUID" ]; then
          fa "o destino É a origem (mesmo server_uuid). Destino errado: nada será alterado"
        else ok "destino e origem são servidores diferentes (server_uuid)"; fi
        if [ "$PRECISA_PONTE" = 1 ]; then
          av "rede origem -> destino não testada (a ponte ainda não existe); o 'montar' testa logo depois de criá-la"
        else
          checar_rede
        fi
        ids=$(q o 'SHOW REPLICAS' | cut -f1 | tr '\n' ' ' || true)
        if [ -n "$SID" ]; then
          if [ "$SID" = "$OSID" ]; then fa "--server-id $SID é o da origem"; fi
          if [ "$SID" != "$dsid" ] && printf '%s\n' "$ids" | tr ' ' '\n' | grep -qx "$SID"; then fa "--server-id $SID já é de outra réplica desta origem"; fi
        fi
      fi
      local rs lista dtab_lista dtab_all copia
      if [ -z "$BANCOS" ]; then lista="''"; else lista=$(lista_sql); fi
      if ! rs=$(printf 'SHOW REPLICA STATUS;\n' | hexec d "$(mcmd d '-E')" 2>/dev/null); then
        fa "não consegui consultar SHOW REPLICA STATUS no destino"; rs=""; fi
      dtab_lista=$(q d "SELECT COUNT(*) FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_schema IN ($lista)" || echo 0)
      dtab_all=$(q d "SELECT COUNT(*) FROM information_schema.tables WHERE table_type='BASE TABLE' AND table_schema NOT IN ($SISTEMA)" || echo 0)
      copia=0
      if [ -n "$OUUID" ] && [ "$(q d "SELECT GTID_SUBSET('$OUUID:1', @@GLOBAL.gtid_executed)" || echo 0)" = 1 ]; then copia=1; fi
      SRC_UUID=$(printf '%s\n' "$rs" | sed -n 's/^ *Source_UUID: //p' | head -n1)
      if [ -n "$rs" ]; then
        if [ "$REFAZER" = 1 ]; then
          if [ -n "$OUUID" ] && [ "$SRC_UUID" = "$OUUID" ]; then av "destino já é réplica desta origem; será refeita (--refazer)"; else
            fa "destino é réplica de OUTRA origem (Source_UUID diferente). --refazer recusado"; fi
        else fa "destino já é réplica. Use --refazer para refazer"; fi
      else ok "destino ainda não é réplica"; fi
      if [ "${dtab_lista:-0}" -gt 0 ] || [ "${dtab_all:-0}" -gt 0 ]; then
        if [ "$REFAZER" = 1 ]; then
          if [ -n "$rs" ] && [ "$SRC_UUID" = "$OUUID" ]; then :; elif [ "$copia" = 1 ]; then
            av "destino tem cópia anterior desta origem (sobra de montagem interrompida); será apagada (--refazer)"; else
            fa "destino tem tabelas que NÃO vêm desta origem. --refazer só vale para réplica/cópia desta origem ou destino vazio; nada será apagado"; fi
        elif [ "${dtab_lista:-0}" -gt 0 ]; then fa "o destino já tem tabelas nos bancos a replicar. Use --refazer (se for cópia/réplica desta origem)"; else
          av "o destino tem outros bancos com tabelas (o RESET dos GTIDs afeta o servidor todo)"; fi
      else ok "destino sem tabelas de usuário"; fi
      local av_kb bk_kb sz
      av_kb=$(hexec d "df -Pk /var/lib/docker 2>/dev/null | awk 'NR==2{print \$4}'" 2>/dev/null || true)
      bk_kb=$(hexec d "d='$BASE'; while [ ! -d \"\$d\" ]; do d=\$(dirname \"\$d\"); done; df -Pk \"\$d\" | awk 'NR==2{print \$4}'" 2>/dev/null || true)
      sz=${TAMANHO:-0}
      if [ -n "$av_kb" ]; then
        if [ $((av_kb * 1024)) -ge $((sz * 3)) ]; then ok "disco livre do Docker no destino $((av_kb / 1024)) MB >= 3x dados"; else fa "disco livre do Docker no destino $((av_kb / 1024)) MB < 3x dados ($((sz * 3 / 1048576)) MB)"; fi
      else av "não consegui medir o disco do Docker no destino"; fi
      if [ -n "$bk_kb" ]; then
        if [ $((bk_kb * 1024)) -ge $((sz * 2)) ]; then ok "disco livre para o dump em $BASE/backups: $((bk_kb / 1024)) MB >= 2x dados"; else fa "disco livre para o dump em $BASE: $((bk_kb / 1024)) MB < 2x dados ($((sz * 2 / 1048576)) MB)"; fi
      else av "não consegui medir o disco de $BASE/backups"; fi
    else fa "root do destino não conectou (confira MYSQL_ROOT_PASSWORD do container ou --destino-senha-arquivo)"; fi
  fi
  printf '\nResumo: %s falha(s), %s aviso(s)\n' "$FALHAS" "$AVISOS"
  [ "$FALHAS" -eq 0 ]
}

# ---------- ponte (subcomando) ----------
ponte() {
  acesso_ssh || exit 1
  setcont o || morrer "origem: $(msg_containers "$OSERV")"
  descobrir_origem
  if [ -z "$O_PONTE" ] && [ -n "$O_PUBLICADA" ] && [ "$PORTA_FORCADA" = 0 ]; then
    echo "INFO   o serviço já publica a porta $O_PUBLICADA; a ponte só é necessária quando ele não tem porta publicada. Criando a ponte mesmo assim (--confirmo dado)."
  fi
  fazer_ponte
  avaliar_porta
  relatorio_acesso
}

# ---------- status (P10) ----------
ler_status_replica() { # destino -> saída vertical (mysql -E, SQL pela entrada padrão); vazio se não é réplica
  printf 'SHOW REPLICA STATUS;\n' | hexec d "$(mcmd d '-E')" 2>/dev/null
}

servico_por_porta() { # porta -> serviço MySQL da origem que a publica (ou tem a ponte dela)
  { rscript o "$RS_COMUM
lista_mysql norep" || true; } | awk -F'\t' -v p="$1" '$4==p || $5==p {print $1; exit}'
}

rstatus() {
  local st io sql lag e1 e2 rc=0 sh sp suuid gd go pscount rcs
  setcont d || morrer "destino: $(msg_containers "$DSERV")"
  if st=$(ler_status_replica); then rcs=0; else rcs=$?; fi
  if [ -z "$st" ]; then
    if [ "$rcs" -ne 0 ]; then echo "FALHA  não consegui consultar o destino (mysql saiu com código $rcs; confira a senha root do container)"; return 1; fi
    pscount=$(q d "SELECT COUNT(*) FROM performance_schema.replication_connection_configuration" || echo 0)
    if [ "${pscount:-0}" -gt 0 ]; then
      echo "FALHA  SHOW REPLICA STATUS veio vazio, mas o performance_schema tem configuração de réplica. A leitura falhou; rode de novo."
      return 1
    fi
    echo "FALHA  o destino não é réplica (sem configuração de replicação)"; return 1
  fi
  g() { printf '%s\n' "$st" | sed -n "s/^ *$1: //p" | head -n1; }
  io=$(g Replica_IO_Running); sql=$(g Replica_SQL_Running); lag=$(g Seconds_Behind_Source)
  e1=$(g Last_IO_Error); e2=$(g Last_SQL_Error)
  sh=$(g Source_Host); sp=$(g Source_Port); suuid=$(g Source_UUID)
  echo "Origem (Source_Host:Port): ${sh:-?}:${sp:-?}"
  echo "Source_UUID:  ${suuid:-?}"
  echo "IO running:  $io"; echo "SQL running: $sql"; echo "Atraso (s):  ${lag:-NULL}"
  [ -z "$e1" ] || echo "Último erro IO:  $e1"
  [ -z "$e2" ] || echo "Último erro SQL: $e2"
  gd=$(q d 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n ' | head -c 300)
  echo "gtid_executed destino: $gd"
  # origem: informada, ou descoberta pelo Source_Host/Port
  if [ -z "$OSSH" ] && [[ $sh =~ ^[0-9.]+$ ]] && ssh "${SSH_OPTS[@]}" "root@$sh" true >/dev/null 2>&1; then
    OSSH="root@$sh"; echo "INFO   origem descoberta pelo Source_Host: $OSSH"
  fi
  if [ -n "$OSSH" ] && [ -z "$OSERV" ] && [[ $sp =~ ^[0-9]+$ ]]; then
    OSERV=$(servico_por_porta "$sp" || true)
    if [ -n "$OSERV" ]; then echo "INFO   serviço da origem descoberto pela porta $sp: $OSERV"; fi
  fi
  if [ -n "$OSSH" ] && [ -n "$OSERV" ] && setcont o 2>/dev/null; then
    go=$(q o 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n ' | head -c 300)
    echo "gtid_executed origem:  $go"
    if [ -n "$go" ] && [ "$go" = "$gd" ]; then echo "GTID igual nos dois lados"; else echo "GTID diferente (normal se a origem está gravando; o atraso acima manda)"; fi
  else
    echo "INFO   origem não informada nem descoberta: passe --origem-ssh e --origem-servico para comparar o GTID"
  fi
  if [ "$io" != Yes ] || [ "$sql" != Yes ]; then rc=1; fi
  if [ -z "$lag" ] || [ "$lag" = NULL ] || ! [[ $lag =~ ^[0-9]+$ ]] || [ "$lag" -gt 60 ]; then rc=1; fi
  if [ "$rc" -eq 0 ]; then echo "OK     réplica saudável"; else echo "FALHA  réplica parada ou atrasada (> 60 s)"; fi
  return $rc
}

# ---------- contagens ----------
contagens() { # lado -> linhas "db.tabela<TAB>n" só das tabelas pequenas (<= LIMITE_CONTAGEM linhas estimadas na origem)
  local lado=$1 lista sql="" db tb first=1 tabs
  lista=$(lista_sql)
  tabs=$(q o "SELECT table_schema,table_name FROM information_schema.tables WHERE table_schema IN ($lista) AND table_type='BASE TABLE' AND COALESCE(table_rows,0)<=$LIMITE_CONTAGEM ORDER BY 1,2") || return 1
  while IFS=$'\t' read -r db tb; do
    [ -n "$db" ] || continue
    [ "$first" = 1 ] || sql="$sql UNION ALL "
    first=0
    sql="${sql}SELECT '$db.$tb', COUNT(*) FROM \`$db\`.\`$tb\`"
  done <<<"$tabs"
  [ -n "$sql" ] || return 0
  q "$lado" "$sql" | sort
}

grandes() { # tabelas grandes: só estimativa (table_rows)
  local lado=$1 lista
  lista=$(lista_sql)
  q "$lado" "SELECT CONCAT(table_schema,'.',table_name,'~',COALESCE(table_rows,0)) FROM information_schema.tables WHERE table_schema IN ($lista) AND table_type='BASE TABLE' AND COALESCE(table_rows,0)>$LIMITE_CONTAGEM ORDER BY 1" | tr '\n' ' '
}

# ---------- copiar usuários da origem ----------
copiar_usuarios() {
  local lista u h sql="" cs gr n=0 pul=0 ex
  lista=$(qr o "SELECT user,host FROM mysql.user WHERE user<>'' AND user<>'root' AND user<>'debian-sys-maint' AND LEFT(user,6)<>'mysql.' AND LEFT(user,5)<>'repl_' ORDER BY 1,2") || { av "não consegui listar usuários da origem"; return 0; }
  while IFS=$'\t' read -r u h; do
    [ -n "$u" ] || continue
    if ! [[ $u =~ ^[A-Za-z0-9_.-]+$ ]] || ! [[ $h =~ ^[A-Za-z0-9_.%:-]+$ ]]; then av "usuário '$u'@'$h' com nome fora do padrão simples; não copiado"; pul=$((pul + 1)); continue; fi
    ex=$(q d "SELECT COUNT(*) FROM mysql.user WHERE user='$u' AND host='$h'" || echo 0)
    if [ "${ex:-0}" -gt 0 ]; then av "usuário '$u'@'$h' já existe no destino; pulado"; pul=$((pul + 1)); continue; fi
    cs=$(qr o "SHOW CREATE USER '$u'@'$h'") || { av "SHOW CREATE USER falhou para '$u'@'$h'; pulado"; pul=$((pul + 1)); continue; }
    gr=$(qr o "SHOW GRANTS FOR '$u'@'$h'") || gr=""
    sql="${sql}$(printf '%s;\n' "$cs")
$(printf '%s\n' "$gr" | sed '/^$/d; s/$/;/')
"
    n=$((n + 1))
  done <<<"$lista"
  if [ "$n" -gt 0 ]; then
    { echo 'SET SESSION sql_log_bin=0;'; printf '%s' "$sql"; } | hexec d "$(mcmd d)" || morrer "falha ao criar os usuários no destino"
  fi
  echo "       usuários copiados da origem: $n (pulados: $pul); excluídos root, mysql.* e repl_*"
}

# ---------- reinício do destino (P9) ----------
reiniciar_destino() { # serviço Swarm: docker service update --force + esperar a task nova; container comum: docker restart
  local svc antigo i
  antigo=$DCONT
  svc=$(hexec d "docker inspect -f '{{index .Config.Labels \"com.docker.swarm.service.name\"}}' '$DCONT' 2>/dev/null" </dev/null || true)
  if [ -n "$svc" ]; then
    echo "       destino é serviço Swarm ($svc): reinício por 'docker service update --force' (nunca 'docker restart' em container de Swarm)"
    hexec d "docker service update --force --detach '$svc'" </dev/null >/dev/null ||
      morrer "docker service update --force $svc falhou (este host é manager do Swarm? Reinicie o serviço pelo EasyPanel e rode de novo)"
    for i in $(seq 1 60); do
      sleep 3
      if setcont d 2>/dev/null && [ "$DCONT" != "$antigo" ] && q d 'SELECT 1' >/dev/null; then
        echo "       task nova no ar: $DCONT (substituiu $antigo; um container só)"
        return 0
      fi
    done
    morrer "a task nova do serviço $svc não ficou pronta em 180 s (veja: docker service ps $svc). Nada além da configuração do passo 2 foi alterado"
  fi
  hexec d "docker restart -t 120 $DCONT" </dev/null >/dev/null || morrer "docker restart do destino falhou"
  esperar_mysql d 180 || morrer "destino não voltou em 180 s"
}

# ---------- montar ----------
montar() {
  [ "$CONFIRMO" = 1 ] || morrer "montar exige --confirmo (rode 'verificar' e peça o OK do usuário antes)"
  local repl_env repl_pw ru stamp arq dumpcmd opt st conf go gd co cd b arr err tag cur ids n

  passo 1 "verificar"
  verificar || morrer "verificar falhou; nada foi alterado"
  if [ "$PRECISA_PONTE" = 1 ]; then
    echo
    echo "       origem sem porta publicada: criando a ponte (único ajuste no host de origem)"
    fazer_ponte
    descobrir_origem
    PRECISA_PONTE=0; FALHAS=0
    avaliar_porta
    checar_rede
    [ "$FALHAS" -eq 0 ] || morrer "a ponte existe mas o destino não chega na origem por ela (nada mais foi alterado)"
  fi
  ru=$(repl_usuario)
  if [ -z "$SID" ]; then
    cur=$(q d 'SELECT @@server_id')
    ids=$(q o 'SHOW REPLICAS' | cut -f1 | tr '\n' ' ' || true)
    if [ "${cur:-1}" -gt 1 ] && [ "$cur" != "$OSID" ]; then SID=$cur; else
      while :; do
        SID=$(( ((RANDOM << 15 | RANDOM) % 2000000000) + 2 ))
        if [ "$SID" != "$OSID" ] && ! printf '%s\n' "$ids" | tr ' ' '\n' | grep -qx "$SID"; then break; fi
      done
    fi
  fi
  [ "$SID" != "$OSID" ] || morrer "server-id do destino não pode ser igual ao da origem ($OSID)"

  passo 2 "configurar o destino (server_id=$SID, GTID, relay_log_recovery, skip_replica_start) e reiniciar"
  guarda
  qe d "SET PERSIST server_id = $SID;" || morrer "falha ao definir server_id"
  qe d "SET PERSIST enforce_gtid_consistency = ON;" || morrer "falha em enforce_gtid_consistency"
  for st in OFF_PERMISSIVE ON_PERMISSIVE ON; do
    if ! err=$(qe d "SET PERSIST gtid_mode = $st;" 2>&1); then
      if printf '%s' "$err" | grep -q '1788'; then echo "       (gtid_mode=$st ignorado: GTID já estava em outro degrau, erro 1788 esperado)"; else
        morrer "SET PERSIST gtid_mode=$st falhou: $err"; fi
    fi
  done
  qe d "SET PERSIST_ONLY relay_log_recovery = ON;" || morrer "falha em relay_log_recovery"
  qe d "SET PERSIST_ONLY skip_replica_start = ON;" || morrer "falha em skip_replica_start"
  reiniciar_destino
  guarda
  conf=$(q d 'SELECT @@server_id,@@gtid_mode,@@enforce_gtid_consistency,@@relay_log_recovery,@@skip_replica_start' | tr '\t' ' ')
  [ "$conf" = "$SID ON ON 1 1" ] || morrer "configuração do destino não bateu após reiniciar: '$conf' (esperado '$SID ON ON 1 1')"
  echo "       destino configurado: $conf (server_id gtid_mode enforce relay_log_recovery skip_replica_start)"

  passo 3 "origem: usuário de replicação '$ru' (um por destino, REQUIRE SSL, sem ir para o binlog)"
  guarda
  repl_env="$BASE/.replicacao/$DSERV.env"
  hexec d "umask 077; mkdir -p '$BASE/.replicacao'; if ! grep -Eq '^REPL_SENHA=[A-Za-z0-9]{32}\$' '$repl_env' 2>/dev/null; then p=\$(LC_ALL=C tr -dc 'A-Za-z0-9' </dev/urandom | head -c 32); printf 'REPL_SENHA=%s\n' \"\$p\" > '$repl_env'; fi; chmod 600 '$repl_env'" || morrer "não consegui guardar a senha de replicação no destino"
  repl_pw=$(hexec d "sed -n 's/^REPL_SENHA=//p' '$repl_env' | head -n1")
  [ "${#repl_pw}" -eq 32 ] || morrer "senha de replicação inválida em $repl_env"
  printf "SET SESSION sql_log_bin=0;\nCREATE USER IF NOT EXISTS '%s'@'%%' IDENTIFIED BY '%s' REQUIRE SSL;\nALTER USER '%s'@'%%' IDENTIFIED BY '%s' REQUIRE SSL;\nGRANT REPLICATION SLAVE ON *.* TO '%s'@'%%';\n" "$ru" "$repl_pw" "$ru" "$repl_pw" "$ru" |
    hexec o "$(mcmd o)" || morrer "falha ao criar o usuário $ru na origem"
  echo "       usuário '$ru'@'%' pronto (senha em $repl_env no destino); nenhum outro usuário da origem foi alterado"

  passo 4 "dump da origem (de dentro do container de destino)"
  guarda
  n=0
  while [ "$(consultas_longas 10)" -gt 0 ]; do
    n=$((n + 1))
    if [ "$SEGUIR_LONGA" = 1 ]; then echo "       (consulta longa na origem; seguindo por --seguir-com-consulta-longa)"; break; fi
    [ "$n" -lt 4 ] || morrer "consulta com mais de 10 s rodando na origem: o dump seguraria as gravações. Abortei antes do dump"
    echo "       consulta longa na origem; esperando 5 s (tentativa $n/3)"; sleep 5
  done
  [ "$(q o "SELECT COUNT(*) FROM performance_schema.processlist WHERE state LIKE 'Waiting for global read lock%'" || echo 0)" -eq 0 ] || morrer "origem com espera de trava global; abortei antes do dump"
  stamp=$(date -u +%Y%m%d-%H%M%S)
  n=$(printf '%s' "$BANCOS" | tr ',' '\n' | grep -c .)
  if [ "$n" -le 3 ]; then tag=${BANCOS//,/+}; else tag="${n}bancos"; fi
  arq="$BASE/backups/${DSERV}-${tag}-$stamp.sql"
  if [ "$TRAVAR" = 1 ]; then opt="--lock-all-tables"; else opt="--single-transaction"; fi
  dumpcmd="IFS= read -r MYSQL_PWD; export MYSQL_PWD; exec mysqldump -h $OHOST -P $PORTA -uroot $opt --source-data=2 --set-gtid-purged=ON --routines --triggers --events --databases ${BANCOS//,/ }"
  hexec o "$(pwcmd)" </dev/null | hexec d "umask 077; mkdir -p '$BASE/backups'; docker exec -i $DCONT sh -c '$dumpcmd' > '$arq.parcial'" ||
    morrer "dump falhou (o parcial, se existir, fica em $arq.parcial no destino)"
  hexec d "tail -c 400 '$arq.parcial' | grep -q 'Dump completed'" || morrer "dump incompleto em $arq.parcial"
  hexec d "if [ -e '$arq' ]; then exit 1; fi; mv '$arq.parcial' '$arq'; chmod 600 '$arq'" || morrer "não consegui finalizar o dump (arquivo $arq já existe?)"
  echo "       dump salvo no destino: $arq (nunca apagar)"

  passo 5 "destino: limpar GTIDs, importar e copiar os usuários da origem"
  guarda
  if [ "$REFAZER" = 1 ]; then
    qe d "STOP REPLICA;" 2>/dev/null || true
    qe d "RESET REPLICA ALL;" 2>/dev/null || true
    qe d "SET PERSIST super_read_only = OFF;" || true
    qe d "SET PERSIST read_only = OFF;" || true
    IFS=, read -ra arr <<<"$BANCOS"
    for b in "${arr[@]}"; do qe d "DROP DATABASE IF EXISTS \`$b\`;" || morrer "DROP DATABASE $b falhou"; done
  fi
  if ver_ge "$DVERS" 8.4.0; then qe d "RESET BINARY LOGS AND GTIDS;" || morrer "RESET falhou"; else qe d "RESET MASTER;" || morrer "RESET MASTER falhou"; fi
  hexec d "$(mcmd d) < '$arq'" || morrer "import do dump falhou"
  echo "       import concluído"
  copiar_usuarios

  passo 6 "destino: somente leitura"
  guarda
  qe d "SET PERSIST read_only = ON;" || morrer "read_only"
  qe d "SET PERSIST super_read_only = ON;" || morrer "super_read_only"

  passo 7 "ligar a replicação"
  guarda
  printf "CHANGE REPLICATION SOURCE TO SOURCE_HOST='%s', SOURCE_PORT=%s, SOURCE_USER='%s', SOURCE_PASSWORD='%s', SOURCE_AUTO_POSITION=1, SOURCE_SSL=1, GET_SOURCE_PUBLIC_KEY=1;\nSTART REPLICA;\n" "$OHOST" "$PORTA" "$ru" "$repl_pw" |
    hexec d "$(mcmd d)" || morrer "CHANGE REPLICATION SOURCE / START REPLICA falhou"
  st=""
  for _ in $(seq 1 30); do
    st=$(q d "SELECT CONCAT((SELECT COALESCE(MAX(service_state),'?') FROM performance_schema.replication_connection_status),'/',(SELECT COALESCE(MAX(service_state),'?') FROM performance_schema.replication_applier_status))" || true)
    [ "$st" = "ON/ON" ] && break
    sleep 2
  done
  [ "$st" = "ON/ON" ] || { rstatus || true; morrer "IO/SQL não ficaram Yes em 60 s"; }
  qe d "RESET PERSIST IF EXISTS skip_replica_start;" || true

  passo 8 "conferência final"
  guarda
  go=""; gd=""
  for _ in $(seq 1 15); do
    go=$(q o 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n ' || true); gd=$(q d 'SELECT @@GLOBAL.gtid_executed' | tr -d '\n ' || true)
    [ "$go" = "$gd" ] && break
    sleep 2
  done
  if [ "$go" = "$gd" ]; then ok "gtid_executed igual nos dois"; else av "gtid_executed difere (a origem segue gravando)"; fi
  co=$(contagens o || true); cd=$(contagens d || true)
  if [ "$co" = "$cd" ]; then ok "contagem exata de linhas igual nas tabelas até $LIMITE_CONTAGEM linhas"; else
    av "contagem de linhas difere (a origem segue mudando?)"; diff <(printf '%s\n' "$co") <(printf '%s\n' "$cd") | head -n 20 || true; fi
  go=$(grandes o || true); gd=$(grandes d || true)
  if [ -n "$go" ]; then echo "INFO   tabelas grandes, só ESTIMATIVA (table_rows, sem COUNT exato). origem: $go | destino: $gd"; fi
  if ! rstatus; then
    morrer "a réplica NÃO está saudável no fim (veja o status acima). Dump em: $arq"
  fi
  echo
  echo "Réplica montada. Dump em: $arq  | Senha de '$ru' em: $repl_env (host do destino)"
  relatorio_acesso
  echo
  echo "Próximo: 'status' periódico; se o aviso da porta apareceu, 'bloquear-porta --confirmo'."
}

# ---------- bloquear-porta (P13) ----------
fw_script() { # $1 = portas separadas por espaço
  cat <<'FWEOF' | sed "s/@PORTAS@/$1/"
#!/bin/sh
# Fecha para a internet as portas de banco publicadas pelo Docker/EasyPanel.
# Tailscale (tailscale0) e a rede interna do Docker continuam liberados.
# Gerado pela skill replicar-mysql (bloquear-porta). Idempotente; novas portas são somadas, nunca removidas.
PORTAS="@PORTAS@"
IFACE=$(ip route show default 2>/dev/null | awk '{print $5; exit}')
[ -n "$IFACE" ] || { echo "replicacao-firewall: sem interface default" >&2; exit 1; }
for ipt in iptables ip6tables; do
  command -v "$ipt" >/dev/null 2>&1 || continue
  $ipt -S DOCKER-USER >/dev/null 2>&1 || $ipt -N DOCKER-USER
  for p in $PORTAS; do
    $ipt -C DOCKER-USER -i "$IFACE" -p tcp -m conntrack --ctorigdstport "$p" --ctdir ORIGINAL -j DROP 2>/dev/null ||
      $ipt -I DOCKER-USER -i "$IFACE" -p tcp -m conntrack --ctorigdstport "$p" --ctdir ORIGINAL -j DROP
  done
done
exit 0
FWEOF
}

fw_unit() {
  cat <<'FWEOF'
[Unit]
Description=Fecha portas de banco para a internet (DOCKER-USER)
After=docker.service
Requires=docker.service
PartOf=docker.service

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/replicacao-firewall.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target docker.service
FWEOF
}

portas_mysql_expostas() { # portas de MySQL publicadas em 0.0.0.0/:: no host de origem (todas as casas do host)
  local listen svc img pub pt al rep out=""
  listen=$(hexec o "ss -Hltn 2>/dev/null | awk '{print \$4}'" </dev/null 2>/dev/null || true)
  while IFS=$'\t' read -r svc _ img pub pt al rep; do
    [ "${pub:--}" != "-" ] || continue
    if printf '%s\n' "$listen" | grep -qE "^(0\.0\.0\.0|\[::\]|\*):${pub}\$"; then out="$out$pub "; fi
  done < <(rscript o "$RS_COMUM
lista_mysql norep" || true)
  printf '%s' "$out" | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -un | tr '\n' ' ' | sed 's/ $//' || true
}

bloquear_porta() {
  [ "$CONFIRMO" = 1 ] || [ "$DRY_RUN" = 1 ] || morrer "bloquear-porta exige --confirmo (ou --dry-run para só ver)"
  local novas atuais todas p estado iface conteudo ts_ip tem_systemd faltam=""
  acesso_ssh || exit 1
  if [ -n "$PORTAS_FW" ]; then novas=$(printf '%s' "$PORTAS_FW" | tr ',' ' '); else
    novas=$(portas_mysql_expostas)
    echo "INFO   portas de MySQL publicadas em 0.0.0.0/:: no host de origem: ${novas:-nenhuma}"
  fi
  atuais=$(hexec o "sed -n 's/^PORTAS=\"\\(.*\\)\"\$/\\1/p' /usr/local/sbin/replicacao-firewall.sh 2>/dev/null; true" </dev/null || true)
  # shellcheck disable=SC2086
  todas=$(printf '%s\n' $atuais $novas | grep -E '^[0-9]+$' | sort -un | tr '\n' ' ' | sed 's/ $//' || true)
  [ -n "$todas" ] || { echo "OK     nenhuma porta de MySQL exposta e nenhuma no script: nada a fazer"; return 0; }
  echo "INFO   portas no script depois desta execução: $todas (já no script: ${atuais:-nenhuma})"
  iface=$(hexec o "ip route show default 2>/dev/null | awk '{print \$5; exit}'" </dev/null || true)
  [ -n "$iface" ] || morrer "o host de origem não tem interface default (ip route)"
  echo "INFO   interface de internet do host de origem: $iface"
  for p in $todas; do
    if hexec o "iptables -C DOCKER-USER -i '$iface' -p tcp -m conntrack --ctorigdstport '$p' --ctdir ORIGINAL -j DROP" </dev/null >/dev/null 2>&1; then
      estado="regra já ativa"
    else estado="regra FALTA"; faltam="$faltam$p "; fi
    echo "       porta $p: $estado"
  done
  conteudo=$(fw_script "$todas")
  tem_systemd=$(hexec o "command -v systemctl >/dev/null 2>&1 && echo sim || echo nao" </dev/null || echo nao)
  if [ "$DRY_RUN" = 1 ]; then
    if [ "$(hexec o "cat /usr/local/sbin/replicacao-firewall.sh 2>/dev/null" </dev/null || true)" = "$conteudo" ]; then
      echo "DRY    script /usr/local/sbin/replicacao-firewall.sh já está igual: nada a mudar"
    elif [ "$atuais" = "$todas" ]; then
      echo "DRY    script /usr/local/sbin/replicacao-firewall.sh já tem as mesmas portas ($todas); só o texto seria regravado com o modelo atual"
    else echo "DRY    atualizaria /usr/local/sbin/replicacao-firewall.sh com as portas: $todas"; fi
    if [ "$tem_systemd" = sim ]; then
      if hexec o "systemctl is-enabled replicacao-firewall.service" </dev/null >/dev/null 2>&1; then echo "DRY    replicacao-firewall.service já está habilitado"; else
        echo "DRY    instalaria e habilitaria replicacao-firewall.service (After/Requires/PartOf docker.service)"; fi
    else echo "DRY    sem systemd neste host: só aplicaria as regras agora (não sobreviveriam ao reboot)"; fi
    if [ -z "$faltam" ]; then echo "OK     dry-run: tudo já está fechado ($todas); nenhuma regra seria inserida"; else echo "DRY    inseriria as regras das portas: $faltam"; fi
    return 0
  fi
  printf '%s\n' "$conteudo" | hexec o "umask 022; cat > /usr/local/sbin/replicacao-firewall.sh.novo && chmod 755 /usr/local/sbin/replicacao-firewall.sh.novo && mv /usr/local/sbin/replicacao-firewall.sh.novo /usr/local/sbin/replicacao-firewall.sh" ||
    morrer "não consegui gravar /usr/local/sbin/replicacao-firewall.sh no host de origem"
  ok "script /usr/local/sbin/replicacao-firewall.sh gravado (portas: $todas)"
  if [ "$tem_systemd" = sim ]; then
    fw_unit | hexec o "umask 022; cat > /etc/systemd/system/replicacao-firewall.service" || morrer "não consegui gravar o serviço systemd"
    hexec o "systemctl daemon-reload && systemctl enable replicacao-firewall.service >/dev/null 2>&1 && systemctl restart replicacao-firewall.service" </dev/null ||
      morrer "systemctl falhou ao habilitar/rodar replicacao-firewall.service (veja: systemctl status replicacao-firewall.service)"
    ok "replicacao-firewall.service habilitado (roda de novo quando o Docker sobe; sobrevive ao reboot)"
  else
    hexec o "/usr/local/sbin/replicacao-firewall.sh" </dev/null || morrer "o script de firewall falhou"
    av "sem systemd neste host: regras aplicadas agora, mas NÃO sobrevivem ao reboot (rode o script no boot)"
  fi
  for p in $todas; do
    if hexec o "iptables -C DOCKER-USER -i '$iface' -p tcp -m conntrack --ctorigdstport '$p' --ctdir ORIGINAL -j DROP" </dev/null >/dev/null 2>&1; then ok "porta $p fechada para a internet em $iface (DOCKER-USER)"; else fa "porta $p: a regra não ficou ativa"; fi
  done
  # por dentro: de dentro do destino, pelo Tailscale, a porta ainda abre
  ts_ip=${OHOST:-$(ip_tailscale_origem)}
  if [ -n "$DSSH" ] && [ -n "$ts_ip" ] && [ -n "$novas" ]; then
    for p in $novas; do
      if hexec d "timeout 5 bash -c 'exec 3<>/dev/tcp/$ts_ip/$p' 2>/dev/null" </dev/null; then ok "por dentro: do destino, $ts_ip:$p continua abrindo pelo Tailscale"; else
        fa "por dentro: do destino, $ts_ip:$p NÃO abre (o bloqueio pegou o Tailscale? desfaça com: iptables -D DOCKER-USER -i $iface -p tcp -m conntrack --ctorigdstport $p --ctdir ORIGINAL -j DROP)"; fi
    done
  else
    echo "INFO   teste por dentro pulado: passe --destino-ssh para testar, do destino, a porta pelo Tailscale"
  fi
  echo "INFO   confira POR FORA (outra rede, sem Tailscale) que as portas $todas não respondem mais"
  if [ -n "$DSSH" ] && [ -n "$DSERV" ]; then
    echo "== réplica depois do bloqueio =="
    rstatus || fa "a réplica não está saudável depois do bloqueio"
  else
    echo "INFO   confira as réplicas depois: status --destino-ssh ... --destino-servico ..."
  fi
  [ "$FALHAS" -eq 0 ]
}

# ---------- main ----------
[ $# -ge 1 ] || { uso; exit 2; }
SUB=$1; shift
while [ $# -gt 0 ]; do
  case "$1" in
    --origem-ssh) OSSH=$2; shift 2 ;;
    --origem-servico) OSERV=$2; shift 2 ;;
    --destino-ssh) DSSH=$2; shift 2 ;;
    --destino-servico) DSERV=$2; shift 2 ;;
    --banco) BANCOS=$2; shift 2 ;;
    --origem-host) OHOST=$2; shift 2 ;;
    --porta) PORTA=$2; shift 2 ;;
    --ponte-ip) PONTE_IP=$2; shift 2 ;;
    --portas) PORTAS_FW=$2; shift 2 ;;
    --server-id) SID=$2; shift 2 ;;
    --origem-senha-arquivo) OPWF=$2; shift 2 ;;
    --destino-senha-arquivo) DPWF=$2; shift 2 ;;
    --travar-tudo) TRAVAR=1; shift ;;
    --refazer) REFAZER=1; shift ;;
    --confirmo) CONFIRMO=1; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --forcar-porta) FORCAR_PORTA=1; shift ;;
    --seguir-com-consulta-longa) SEGUIR_LONGA=1; shift ;;
    -h|--ajuda|--help) uso; exit 0 ;;
    *) morrer "opção desconhecida: $1" ;;
  esac
done
validar
case "$SUB" in
  ssh) [ -n "$OSSH$DSSH" ] || morrer "falta --origem-ssh e/ou --destino-ssh"; acesso_ssh ;;
  listar) [ -n "$OSSH$DSSH" ] || morrer "falta --origem-ssh e/ou --destino-ssh"; listar ;;
  verificar) exigir OSSH OSERV DSSH DSERV; verificar ;;
  ponte) exigir OSSH OSERV; ponte ;;
  montar) exigir OSSH OSERV DSSH DSERV; montar ;;
  status) exigir DSSH DSERV; rstatus ;;
  bloquear-porta) exigir OSSH; bloquear_porta ;;
  *) uso; exit 2 ;;
esac
