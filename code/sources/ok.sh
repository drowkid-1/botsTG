#!/bin/bash
dir="patoBot";downScript="${dir}/downScript";downShell="${dir}/downShell";dataU="${dir}/dataUser"
rekuest="https://raw.githubusercontent.com/drowkid-1/botsTG/main/code/rbot/source"
[[ ! -d ${dir} ]] && {
mkdir -p ${dir}/{downScript,downShell,dataUser,extras/} &> /dev/null
lista="BotGen.sh botScript.sh ShellBot.sh"
	for arqx in $lista; do
	wget -O ${dir}/$arqx ${rekuest}/$arqx &> /dev/null
	chmod +x ${dir}/$arqx
	done
	wget -O ${dir}/colores https://raw.githubusercontent.com/drowkid-1/botsTG/main/code/sources/colores &> /dev/null
	source ${dir}/colores
clear;msg -bar;msg -ne "token:" token;msg -ne "id:" idd
jq --arg a "${idd}" --arg b "${token}" '{token: $b, data:{ admin:{ id: $a, username: "drowkid01" } } }' -n
msg -bar;print_center -nverd "[✓]datos guardados[✓]"
}

