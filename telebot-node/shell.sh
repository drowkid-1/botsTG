#!/bin/bash
# -*- ENCODING: UTF-8 -*-

arg=$1
id=$2

LINE="━━━━━━━━━━━━━━━━━━━━━━━━"

#HORA Y FECHA
hora_fecha(){
	unset _hora
	unset _fecha
	_hora=$(printf '%(%H:%M:%S)T') 
	_fecha=$(printf '%(%D)T')
}

#PROCESSADOR
cpu(){
		unset _core
		unset _usop
		_core=$(printf '%-1s' "$(grep -c cpu[0-9] /proc/stat)")
		_usop=$(printf '%-1s' "$(top -bn1 | awk '/Cpu/ { cpu = "" 100 - $8 "%" }; END { print cpu }')")
}

#MEMORIA RAM
ram(){
		unset ram1
		unset ram2
		unset ram3
		ram1=$(free -h | grep -i mem | awk {'print $2'})
		ram2=$(free -h | grep -i mem | awk {'print $4'})
		ram3=$(free -h | grep -i mem | awk {'print $3'})

		unset _ram
		unset _usor
		_ram=$(printf ' %-9s' "$(free -h | grep -i mem | awk {'print $2'})")
		_usor=$(printf '%-8s' "$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')")
}

#SISTEMA
sistema(){
		unset os_sys
		os_sys=$(echo $(cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/      //')) && echo $system|awk '{print $1, $2}'
}

meu_ip () {
		MIP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
		MIP2=$(wget -qO- ipv4.icanhazip.com)
		[[ "$MIP" != "$MIP2" ]] && echo "$MIP2" || echo "$MIP"
}

ofus () {
	unset server
	server=$(echo ${txt_ofuscatw}|cut -d':' -f1)
	unset txtofus
	number=$(expr length $1)
	for((i=1; i<$number+1; i++)); do
	txt[$i]=$(echo "$1" | cut -b $i)
	case ${txt[$i]} in
	".")txt[$i]="*";;
	"*")txt[$i]=".";;
	"1")txt[$i]="@";;
	"@")txt[$i]="1";;
	"2")txt[$i]="?";;
	"?")txt[$i]="2";;
	"4")txt[$i]="%";;
	"%")txt[$i]="4";;
	"-")txt[$i]="K";;
	"K")txt[$i]="-";;
	esac
	txtofus+="${txt[$i]}"
	done
	echo "$txtofus" | rev
}

fun_list () {	
	rm ${SCPT_DIR}/*.x.c &> /dev/null
	unset KEY
	KEY="$1"
	#CRIA DIR
	[[ ! -e ${DIR} ]] && mkdir ${DIR}
	#ENVIA ARQS
	i=0
	VALUE+="gerar.sh instgerador.sh http-server.py lista-arq $BASICINST"
	for arqx in `ls ${SCPT_DIR}`; do
	[[ $(echo $VALUE|grep -w "${arqx}") ]] && continue 
	echo -e "[$i] -> ${arqx}"
	arq_list[$i]="${arqx}"
	let i++
	done
	#CRIA KEY
	[[ ! -e ${DIR}/${KEY} ]] && mkdir ${DIR}/${KEY}
	#PASSA ARQS
	nombrevalue="${id}"
	#ADM BASIC
	arqslist="$BASICINST"
	for arqx in `echo "${arqslist}"`; do
	[[ -e ${DIR}/${KEY}/$arqx ]] && continue #ANULA ARQUIVO CASO EXISTA
	cp ${SCPT_DIR}/$arqx ${DIR}/${KEY}/
	echo "$arqx" >> ${DIR}/${KEY}/${LIST}
	done
	rm ${SCPT_DIR}/*.x.c &> /dev/null
	echo "$nombrevalue" > ${DIR}/${KEY}.name
	[[ ! -z $IPFIX ]] && echo "$IPFIX" > ${DIR}/${KEY}/keyfixa
	at now +4 hours <<< "rm -rf ${DIR}/${KEY} && rm -rf ${DIR}/${KEY}.name"
}

menu_fun(){
	       hora_fecha
	       cpu
	       ram
	       sistema

	       unset PID_GEN
		   PID_GEN=$(ps x|grep -v grep|grep "http-server.sh")
		   [[ ! $PID_GEN ]] && PID_GEN='(Offline) ❌' || PID_GEN='(Online) ✅'

		   unset usadas
		   usadas="$(cat /etc/http-instas)"
		   [[ ! $usadas ]] && k_used="0" || k_used="$usadas"
		  
	       bot_retorno="$LINE\n"
	       bot_retorno+="Gen $PID_GEN | Keys Used [$k_used]\n"
	       bot_retorno+="$LINE\n"
	       bot_retorno+="S.O: $os_sys\n"
	       bot_retorno+="Su IP es: $(meu_ip)\n"
	       bot_retorno+="$LINE\n"
	       bot_retorno+="Ram: $ram1 || En Uso: $_usor\n"
	       bot_retorno+="USADA: $ram3 || LIBRE: $ram2\n"
	       bot_retorno+="$LINE\n"
	       bot_retorno+="CPU: $_core || En Uso: $_usop\n"
	       bot_retorno+="$LINE\n"
	       bot_retorno+="FECHA: $_fecha\n"
	       bot_retorno+="HORA: $_hora\n"
	       bot_retorno+="$LINE"
}

case $arg in
	admin)
		   menu_fun
		;;
	 user)
		   hora_fecha

	       bot_retorno="━━━━━━━ COMANDOS ━━━━━━━\n"
	       bot_retorno+="/menu (menu principal)\n"
	       bot_retorno+="/keygen (generan un key)\n"
	       bot_retorno+="$LINE"
		;;
  no_user)
	       bot_retorno="━━━━━━━ COMANDOS ━━━━━━━\n"
	       bot_retorno+="/ask (Pedir autorización)\n"
	       bot_retorno+="$LINE"
		;;
	 on/off)

		   unset PIDGEN
		   PIDGEN=$(ps aux|grep -v grep|grep "http-server.sh")
		   if [[ ! $PIDGEN ]]; then
		   screen -dmS generador /bin/http-server.sh -start
		   else
		   killall http-server.sh
		   fi

		   menu_fun
		;;
	refresh)
		   sync
		   sysctl -w vm.drop_caches=3 &>/dev/null

		   ram

		   bot_retorno="<u>Ram refrescada.</u>\n\n"
		   bot_retorno+="━━━━━ Estado  actual ━━━━━\n"
		   bot_retorno+="  Ram: $ram1 || EN Uso: $_usor\n"
		   bot_retorno+="  USADA: $ram3 || LIBRE: $ram2\n"
		   bot_retorno+="━━━━━━━━━━━━━━━━━━━━━"
		;;
	keygen)
		   [[ -e /etc/newadm-instalacao ]] && BASICINST="$(cat /etc/newadm-instalacao)" || BASICINST="ADMbot.sh C-SSR.sh Crear-Demo.sh PDirect.py PGet.py POpen.py PPriv.py PPub.py Shadowsocks-R.sh Shadowsocks-libev.sh Unlock-Pass-VULTR.sh apacheon.sh blockBT.sh budp.sh dns-netflix.sh dropbear.sh fai2ban.sh gestor.sh menu message.txt openvpn.sh paysnd.sh ports.sh shadowsocks.sh sockspy.sh speed.sh speedtest.py squid.sh squidpass.sh ssl.sh tcp.sh ultrahost usercodes utils.sh v2ray.sh Proxy.sh"
		   SCPT_DIR="/etc/SCRIPT"
		   [[ ! -e ${SCPT_DIR} ]] && mkdir ${SCPT_DIR}
		   DIR="/etc/http-shell"
		   LIST="lista-arq"

		   valuekey="$(date | md5sum | head -c10)"
		   valuekey+="$(echo $(($RANDOM*10))|head -c 5)"
		   fun_list "$valuekey"
		   keyfinal=$(ofus "$(meu_ip):8888/$valuekey/$LIST")

		   bot_retorno="$LINE\n"
		   bot_retorno+="✅ Key Generada Con Exito! ✅\n"
		   bot_retorno+="$LINE\n"
		   bot_retorno+="${keyfinal}\n"
		   bot_retorno+="$LINE\n"
		   bot_retorno+="sudo apt update -y; apt upgrade -y; wget https://raw.githubusercontent.com/rudi9999/VPS-MX-8.0/master/instalscript.sh; chmod 777 instalscript.sh; ./instalscript.sh\n"
		   bot_retorno+="$LINE\n"
		   bot_retorno+="Esta key se autodestruira en 4hs\npasado este tiempo deve generar una nueva key.\n"
		   bot_retorno+="$LINE\n"

		   [[ ! -d ./keytxt ]] && mkdir ./keytxt

		   echo -e $bot_retorno >> ./keytxt/key_${id}.txt

		;;
	pattern )
		;;
esac

echo -e "<i>$bot_retorno</i>"
