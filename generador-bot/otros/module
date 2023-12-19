#!/bin/bash
export _hora=$(printf '%(%H:%M:%S)T');export _fecha=$(printf '%(%D)T')
export numero='^[0-9]+$'
export texto='^[A-Za-z]+$'
export txt_num='^[A-Za-z0-9]+$'
color[0]="\e[1;30m";color[1]="\e[1;31m";color[2]="\e[1;32m";color[3]="\e[1;33m";color[4]="\e[1;34m";color[5]="\e[1;35m";color[6]="\e[1;36m";color[7]="\e[1;37m";color[8]="\e[2m";color[9]="\e[5m"
color[sn]="\e[0m"
msg(){
  case $1 in
    -nazu) cor="${color[6]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nverd)cor="${color[2]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -nama) cor="${color[3]}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
    -ama)  cor="${color[3]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -verm) cor="${color[3]}${NEGRITO}[!] ${color[1]}" && echo -e "${cor}${2}${SEMCOR}";;
    -verm2)cor="${color[1]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -verm3)cor="${color[1]}" && echo -e "${cor}${2}${SEMCOR}";;
    -teal) cor="${color[7]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -teal2)cor="${color[7]}" && echo -e "${cor}${2}${SEMCOR}";;
    -blak) cor="${color[8]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -blak2)cor="${color[8]}" && echo -e "${cor}${2}${SEMCOR}";;
    -azu)  cor="${color[6]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -blu)  cor="${color[9]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -blu1) cor="${color[9]}" && echo -e "${cor}${2}${SEMCOR}";;
    -verd) cor="${color[2]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -bra)  cor="${color[0]}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
    -bar) echo -e "\e[1;30m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" ;;
    -ne) echo -ne "   \e[1;30m[${color[6]}•\e[1;30m] ${color[6]}$2\e[1;30m "; read $3 ;;
    -e)echo -e "$2";;
  esac
}

# centrado de texto
print_center(){
  if [[ -z $2 ]]; then
    text="$1"
  else
    col="$1"
    text="$2"
  fi

  while read line; do
    unset space
    x=$(( ( 54 - ${#line}) / 2))
    for (( i = 0; i < $x; i++ )); do
      space+=' '
    done
    space+="$line"
    if [[ -z $2 ]]; then
      msg -azu "$space"
    else
      msg "$col" "$space"
    fi
  done <<< $(echo -e "$text")
}
title(){
    clear
    msg -bar
    if [[ -z $2 ]]; then
      print_center -azu "$1"
    else
      print_center "$1" "$2"
    fi
    msg -bar
 }

# finalizacion de tareas
 enter(){
  msg -bar
  text="►► ${a_enter:-Presione enter para continuar} ◄◄"
  if [[ -z $1 ]]; then
    print_center -ama "$text"
  else
    print_center "$1" "$text"
  fi
  read
 }


# menu maker (opciones 1, 2, 3,.....)
menu_func(){
  local options=${#@}
  local array
  for((num=1; num<=$options; num++)); do
    echo -ne "$(msg -verd " [$num]") $(msg -verm2 ">") "
    array=(${!num})
    case ${array[0]} in
      "-vd")echo -e "\033[1;33m[!]\033[1;32m ${array[@]:1}";;
      "-vm")echo -e "\033[1;33m[!]\033[1;31m ${array[@]:1}";;
      "-fi")echo -e "${array[@]:2} ${array[1]}";;
      -bar|-bar2|-bar3|-bar4)echo -e "\033[1;37m${array[@]:1}\n$(msg ${array[0]})";;
      *)echo -e "\033[1;37m${array[@]}";;
    esac
  done
 }

# opcion de seleccion numerica
selection_fun(){
  local selection="null"
  local range
  if [[ -z $2 ]]; then
    opcion=$1
    col="-nazu"
  else
    opcion=$2
    col=$1
  fi
  for((i=0; i<=$opcion; i++)); do range[$i]="$i "; done
  while [[ ! $(echo ${range[*]}|grep -w "$selection") ]]; do
    msg "$col" " ${a_selection_fun:-Seleccione una opción}: " >&2
    read selection
    tput cuu1 >&2 && tput dl1 >&2
  done
  echo $selection
}

in_opcion(){
  unset opcion
  if [[ -z $2 ]]; then
      msg -nazu " $1: " >&2
  else
      msg $1 " $2: " >&2
  fi
  read opcion
  echo "$opcion"
}

in_opcion_down(){
  dat=$1
  length=${#dat}
  cal=$(( 22 - $length / 2 ))
  line=''
  for (( i = 0; i < $cal; i++ )); do
    line+='╼'
  done
  echo -e " $(msg -verm3 "╭$line╼[")$(msg -azu "$dat")$(msg -verm3 "]")"
  echo -ne " $(msg -verm3 "╰╼")\033[37;1m> " && read opcion
}
export -f msg
export -f selection_fun
export -f menu_func
export -f print_center
export -f title
export -f enter
export -f in_opcion
export -f in_opcion_down


