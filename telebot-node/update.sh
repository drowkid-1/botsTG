#!/bin/bash

update () {
	[[ -e bot-db/bot.js ]] && rm bot-db/bot.js
	[[ -e bot-db/shell.sh ]] && rm bot-db/shell.sh
	[[ -e bot-db/package.json ]] && rm bot-db/package.json
	[[ -e confbot ]] && rm confbot

	[[ ! -e "bot-db/package.json" ]] && wget -O "bot-db/package.json" https://raw.githubusercontent.com/rudi9999/TeleBotGen-node/main/package.json &>/dev/null
	[[ ! -e "bot-db/bot.js" ]] && wget -O "bot-db/bot.js" https://raw.githubusercontent.com/rudi9999/TeleBotGen-node/main/bot.js &>/dev/null
	[[ ! -e "bot-db/shell.sh" ]] && wget -O "bot-db/shell.sh" https://raw.githubusercontent.com/rudi9999/TeleBotGen-node/main/shell.sh &>/dev/null
	[[ ! -e "confbot" ]] && wget -O "confbot" https://raw.githubusercontent.com/rudi9999/TeleBotGen-node/main/confbot &>/dev/null
	chmod +x bot-db/package.json
	chmod +x bot-db/bot.js
	chmod +x bot-db/shell.sh
	chmod +x confbot
}

bot_off () {
	unset PIDGEN
	PIDGEN=$(ps x|grep -v grep|grep "teleBotGen")
	[[ $PIDGEN ]] && {
		bot=$(ps x|grep -v grep|grep "teleBotGen" | awk {'print $1'})
		kill $bot
	}
}

mensaje () {
	if [[ $1 = "off" ]]; then
		MENSAJE="Deteniendo BotGen..."
	elif [[ $1 = "up" ]]; then
		MENSAJE="Actualizando BotGen..."
	elif [[ $1 = "start" ]]; then
		MENSAJE="Iniciando BotGen..."
	elif [[ $1 = "del" ]]; then
		MENSAJE="Rmoviendo actualizador..."
	else
		MENSAJE="BotGen actualizado..."
	fi

	TOKEN="$(cat bot-db/token)"
	ID="$(cat bot-db/adminID)"
	URL="https://api.telegram.org/bot$TOKEN/sendMessage"
	curl -s -X POST $URL -d chat_id=$ID -d text="$MENSAJE" &>/dev/null
}

mensaje off && bot_off
mensaje up && update
mensaje start && cd bot-db && screen -dmS teleBotGen ./bot.js && cd ../
mensaje del && rm update.sh
mensaje
