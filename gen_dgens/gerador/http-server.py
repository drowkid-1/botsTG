#!/bin/bash
# >&2
# INSTALACAO
IVAR="/etc/http-instas"

install_fun () {
apt-get install netcat -y
}

fun_ip () {
MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MIP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MIP" != "$MIP2" ]] && IP="$MIP2" || IP="$MIP"
}

# LISTEN
listen_fun () {
PORTA="8888"
PROGRAMA="/bin/http-server.sh"
while true; do
 nc.traditional -l -p "$PORTA" -e "$PROGRAMA"
done
}

# SERVER
server_fun () {
DIR="/etc/http-shell"
unset ENV_ARQ
if [[ ! -d $DIR ]]; then
mkdir $DIR
fi
read URL
KEYZ=($(echo $URL|awk -F "/" '{print $2, $3}'))
KEY=$(echo ${KEYZ[0]}) && [[ ! $KEY ]] && KEY="ERRO"
ARQ=$(echo ${KEYZ[1]}) && [[ ! $ARQ ]] && ARQ="ERRO"
FILE2="${DIR}/${KEY}"
FILE="${DIR}/${KEY}/$ARQ"
if [[ -e ${FILE} ]]; then
STATUS_NUMBER="200"
STATUS_NAME="Found"
ENV_ARQ="True"
else
FILE="${DIR}/ERROR-KEY"
 if [[ ! -e ${FILE} ]]; then
 echo "KEY INVALIDA!" > ${FILE}
 fi
STATUS_NUMBER="404"
STATUS_NAME="NotFound"
ENV_ARQ="False"
fi
cat << EOF
HTTP/1.1 $STATUS_NUMBER - $STATUS_NAME
Date: $(date)
Server: ShellHTTP
Content-Length: $(wc --bytes "$FILE" | cut -d " " -f1)
Connection: close
Content-Type: text/html; charset=utf-8

$(cat "$FILE")
EOF
if [[ $ENV_ARQ = "True" ]]; then
(
mkdir /var/www/$KEY
mkdir /var/www/html/$KEY
TIME="10+"
  for arqs in `cat $FILE`; do
  cp ${FILE2}/$arqs /var/www/$KEY/
  cp ${FILE2}/$arqs /var/www/html/$KEY/ 
  TIME+="3+"
  done
TIME=$(echo "${TIME}0"|bc)
sleep ${TIME}s
rm -rf /var/www/$KEY
rm -rf /var/www/html/$KEY
if [[ -d $FILE2 ]]; then
rm -rf "$FILE2"
num=$(cat ${IVAR})
 if [[ $num = "" ]]; then
 num=0
 fi
let num++
echo $num > $IVAR
fi
) & > /dev/null
fi
}

[[ $1 = @(-[Ss]tart|-[Ss]|-[Ii]niciar) ]] && listen_fun && exit
[[ $1 = @(-[Ii]stall|-[Ii]|-[Ii]stalar) ]] && listen_fun && exit
# [[ $IP != "204.48.25.208" ]] && exit
# nc.traditional -vvn -l -p ${PORT} -w 10 < "${arqs}"
server_fun



