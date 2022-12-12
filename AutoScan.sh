#!/usr/bin/bash

#** Colores
verde="\e[0;32m\033[1m"
NC="\033[0m\e[0m"
rojo="\e[0;31m\033[1m"
azul="\e[0;34m\033[1m"
amarillo="\e[0;33m\033[1m"
morado="\e[0;35m\033[1m"
turquesa="\e[0;36m\033[1m"
gris="\e[0;37m\033[1m"

#** Verifica que Nmap esta instalado
function DependenciaA() {
    sleep 1.5
    counter=0
    echo -e "\n${amarillo} ${NC}${gris} Comprobando programas necesarios...\n${NC}"
    sleep 1
    programa="nmap"
    if [ "$(command -v $programa)" ]; then
        echo -e "\t${verde}${NC}${gris} La herramienta${NC}${amarillo} $programa${NC}${gris} se encuentra instalada"
        let counter+=1
    else
        echo -e "\t${rojo}${NC}${gris} La herramienta${NC}${amarillo} $programa${NC}${gris} no se encuentra instalada"
    fi
    sleep 0.4

    if [ "$(echo $counter)" == "1" ]; then
        echo -e "\t\n${amarillo}${NC}${verde} Comenzando...\n${NC}"
        sleep 3
    else
        echo -e "\n${rojo}${NC}${turquesa} Es necesario contar con la herramienta nmap instalada para ejecutar este script${NC}\n"
        echo -e "${azul}Se instalará nmap cuando finalice vuelva a ejecutar la herramienta${NC}"
        apt install nmap -y
        exit 1
    fi
}
#** Verifica que gobuster esta instalado
function DependenciaB() {
    sleep 1.5
    counter=0
    echo -e "\n${amarillo} ${NC}${gris} Comprobando programas necesarios...\n${NC}"
    sleep 1
    programa="gobuster"
    if [ "$(command -v $programa)" ]; then
        echo -e "\t${verde}${NC}${gris} La herramienta${NC}${amarillo} $programa${NC}${gris} se encuentra instalada"
        let counter+=1
    else
        echo -e "\t${rojo}${NC}${gris} La herramienta${NC}${amarillo} $programa${NC}${gris} no se encuentra instalada"
    fi
    sleep 0.4

    if [ "$(echo $counter)" == "1" ]; then
        echo -e "\t\n${amarillo}${NC}${verde} Comenzando...\n${NC}"
        sleep 2
    else
        echo -e "\n${rojo}${NC}${turquesa} Es necesario contar con la herramienta gobuster instalada para ejecutar este script${NC}\n"
        echo -e "${azul}Se instalará gobuster cuando finalice vuelva a ejecutar la herramienta${NC}"
        apt install gobuster -y
        exit 1
    fi
}

#** Logo de la Herramienta
function banner() {
    echo -e "${rojo}░█████╗░██╗░░░██╗████████╗░█████╗░░██████╗░█████╗░░█████╗░███╗░░██╗░░░░██████╗██╗░░██╗"
    sleep 0.05
    echo -e "██╔══██╗██║░░░██║╚══██╔══╝██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║░░░██╔════╝██║░░██║"
    sleep 0.05
    echo -e "███████║██║░░░██║░░░██║░░░██║░░██║╚█████╗░██║░░╚═╝███████║██╔██╗██║░░░╚█████╗░███████║"
    sleep 0.05
    echo -e "██╔══██║██║░░░██║░░░██║░░░██║░░██║░╚═══██╗██║░░██╗██╔══██║██║╚████║░░░░╚═══██╗██╔══██║"
    sleep 0.05
    echo -e "██║░░██║╚██████╔╝░░░██║░░░╚█████╔╝██████╔╝╚█████╔╝██║░░██║██║░╚███║██╗██████╔╝██║░░██║"
    sleep 0.05
    echo -e "╚═╝░░╚═╝░╚═════╝░░░░╚═╝░░░░╚════╝░╚═════╝░░╚════╝░╚═╝░░╚═╝╚═╝░░╚══╝╚═╝╚═════╝░╚═╝░░╚═╝"
    sleep 0.05
    echo -e "╔══╗──────╔═══╗─────╔╗─────────╔═══╗─────────────────╔╗─╔═══╗"
    sleep 0.05
    echo -e "║╔╗║──────║╔═╗║─────║║─────────╚╗╔╗║────────────────╔╝║─║╔═╗║"
    sleep 0.05
    echo -e "║╚╝╚╗╔╗─╔╗║║─╚╝╔╗─╔╗║╚═╗╔══╗╔═╗─║║║║╔══╗╔╗╔╗╔══╗╔═╗─╚╗║─║╚═╝║"
    sleep 0.05
    echo -e "║╔═╗║║║─║║║║─╔╗║║─║║║╔╗║║║═╣║╔╝─║║║║║║═╣║╚╝║║╔╗║║╔╗╗─║║─╚══╗║"
    sleep 0.05
    echo -e "║╚═╝║║╚═╝║║╚═╝║║╚═╝║║╚╝║║║═╣║║─╔╝╚╝║║║═╣║║║║║╚╝║║║║║╔╝╚╗╔══╝║"
    sleep 0.05
    echo -e "╚═══╝╚═╗╔╝╚═══╝╚═╗╔╝╚══╝╚══╝╚╝─╚═══╝╚══╝╚╩╩╝╚══╝╚╝╚╝╚══╝╚═══╝"
    sleep 0.05
    echo -e "─────╔═╝║──────╔═╝║"
    sleep 0.05
    echo -e "─────╚══╝──────╚══╝${NC}"
    sleep 0.05
}

#** Panel de ayuda
function helpPanel() {
    banner
    echo -e "${turquesa}[USO]\nPonerte como root y ejecutar ./AutoScan.sh -m [Modo]\n\tModos:\n\tTCP \t\tEscaneo por TCP\n\tUDP  \t\tEscaneo por UDP\n\tSCTP  \t\tEscaneo por SCTP\n\tGOBUSCAN  \tFuzzing web\n\tIPSCAN  \tEscaneo de Host activos (/dev/tcp/)\n\tSISTEMA  \tTe indica el sistema mediante el ttl\n\tPROCMON \tMonitor de procesos${NC}"
}

#** Función de escaneo de hosts activos
function IPscan() {
    echo -e "\n${morado}Enumerando IPs activas para 192.168.1.0/24\nSi quieres cambiarlo busca en el codigo ${NC}\n"
    ip=192.168.1. #Cambia esta IP manteniendo el formato
    for i in $(seq 1 254); do
        bash -c "ping -c 1 -W 1 $ip${i[@]}" &>/dev/null && echo -e "\t ${verde}$ip$i \tACTIVO ${NC}" &
    done
    wait
}
#**Función Monitor de Procesos
function procmon() {
    proceso_viejo=$(ps -eo command)
    while true; do
        proceso_nuevo=$(ps -eo command)
        diff <(echo "$proceso_viejo") <(echo "$proceso_nuevo") | grep "[\>\<]" | grep -vE "procmon|command|kworker"
        proceso_viejo=$proceso_nuevo
    done
}
#** Función ¿QUE SISTEMA ES?
function Sistema() {
    echo -e "${morado}Ingresa la IP para averiguar si es Windows o Linux\nMediante su ttl:\n${NC}"
    read IP
    ttl=$(ping -c 1 -W 1 $IP | grep "64" | awk '{print $6}' | sed 's/ttl=//g')
    if [ "$ttl" -ge "0" ] && [ "$ttl" -le "64" ]; then
        echo -e "${verde}\nEl sistema es Linux${NC}"
    elif [ "$ttl" -ge "65" ] && [ "$ttl" -le "128" ]; then
        echo -e "${verde}\nEl sistema es Windows${NC}"
    else
        echo -e "${rojo}\nSistema no contemplado${NC}"
    fi
}

#** Función Escaneo de nmap por protocolo TCP
function TCPscan() {
    echo -e "${morado}Metodo ${NC}${amarillo}[TCP]${NC}\n${morado}Ingrese la IP a escanear: \n${NC}"
    read IP
    echo -e "${morado}Ingrese el --min-rate (tasa de paquetes 'minimos' por segundo 1000-5000${NC})"
    read paquetes
    echo -e "\n${amarillo}[*]${NC}${verde} Iniciando escaneo de puertos abiertos...\n${NC}"
    nmap -sS -Pn -p- --open -vvv --min-rate $paquetes $IP -oG TCPPorts
    wait
    echo -e "\n${amarillo}[*]${NC}${verde} Iniciando escaneo de servicios de los puertos abiertos encontrados...\n${NC}"
    ports="$(cat TCPPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    nmap -sCV -p$ports -v $IP -oN targetedTCP
}

#** Función Escaneo nmap por protocolo UDP
function UDPscan() {
    echo -e "${morado}Metodo ${NC}${amarillo}[UDP]${NC}\n${morado}Ingrese la IP a escanear:${NC}"
    read IP
    echo -e "${morado}Ingrese el --min-rate (tasa de paquetes 'minimos' por segundo 1000-5000${NC})"
    read paquetes
    echo -e "\n${amarillo}[*]${NC}${verde} Iniciando escaneo de puertos abiertos...\n${NC}"
    nmap -sS -Pn -p- --open -vvv --min-rate $paquetes $IP -sU -oG UDPPorts
    wait
    echo -e "\n${amarillo}[*]${NC}${verde} Iniciando escaneo de servicios de los puertos abiertos encontrados...\n${NC}"
    ports="$(cat UDPPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    nmap -sCV -sU -p$ports -v $IP -oN targetedUDP
}

#** Función Escaneo nmap por protocolo SCTP
function SCTPscan() {
    echo -e "${morado}Metodo ${NC}${amarillo}[SCTP]${NC}\n${morado}Ingrese la IP a escanear:${NC}"
    read IP
    echo -e "${morado}Ingrese el --min-rate (tasa de paquetes 'minimos' por segundo 1000-5000${NC})"
    read paquetes
    echo -e "\n${amarillo}[*]${NC}${verde} Iniciando escaneo de puertos abiertos...\n${NC}"
    nmap -sS -Pn -p- --open -vvv --min-rate $paquetes $IP -sY -oG SCTPPorts
    wait
    echo -e "\n${amarillo}[*]${NC}${verde} Iniciando escaneo de servicios de los puertos abiertos encontrados...\n${NC}"
    ports="$(cat SCTPPorts | grep -oP '\d{1,5}/open' | awk '{print $1}' FS='/' | xargs | tr ' ' ',')"
    nmap -sCV -sY -p$ports -v $IP -oN targetedSCTP
}

#** Función Fuzzing web con gobuster
function GobuScan() {
    echo -e "${morado}Ingrese la URL a fuzzear${NC}"
    read URL
    echo -e "${morado}Ingrese la ruta/path del diccionario${NC}"
    read RUTA
    echo -e "${morado}Quiere buscar archivos de alguna extensión en específico?\nS/N${NC}"
    read RES
    if [ "$RES" == "S" ] || [ "$RES" == "Si" ] || [ "$RES" == "SI" ] || [ "$RES" == "si" ]; then
        echo -e "${morado}Ingrese la extensión a buscar\nEjemplo: html, php, htm, yml ${NC}"
        read EXT
        gobuster dir -u $URL -w $RUTA -x $EXT -o Gobuscan
    elif [ "$RES" == "N" ] || [ "$RES" == "No" ] || [ "$RES" == "NO" ] || [ "$RES" == "no" ]; then
        gobuster dir -u $URL -w $RUTA -o Gobuscan
    else
        echo -e "${rojo}Indique Si o No / S o N ${NC}"
    fi
}

#** SALIDA MANUAL
trap ctrl_c INT

function ctrl_c() {
    echo -e "\n${amarillo} ${NC}${rojo} Saliendo...${NC}"
    exit 1
}

#** Main / Principal
#** Si no eres root no puedes ejecutarla
if [ "$(id -u)" == "0" ]; then
    declare -i parametros=0
    while getopts ":m:h:" arg; do
        case $arg in
        m) modo=$OPTARG && let parametros+=1 ;;
        h) helpPanel ;;
        esac
    done
    if [ $parametros -ne 1 ]; then
        helpPanel
    else #** Dependiendo del modo ejecuta cada escaneo
        if [ "$modo" == "TCP" ] || [ "$modo" == "Tcp" ] || [ "$modo" == "tcp" ]; then
            banner
            DependenciaA
            TCPscan
        elif [ "$modo" == "UDP" ] || [ "$modo" == "Udp" ] || [ "$modo" == "udp" ]; then
            banner
            DependenciaA
            UDPscan
        elif [ "$modo" == "Sistema" ] || [ "$modo" == "SISTEMA" ] || [ "$modo" == "sistema" ]; then
            banner
            Sistema
        elif [ "$modo" == "SCTP" ] || [ "$modo" == "Sctp" ] || [ "$modo" == "sctp" ]; then
            banner
            DependenciaA
            SCTPscan
        elif [ "$modo" == "GOBUSCAN" ] || [ "$modo" == "Gobuscan" ] || [ "$modo" == "gobuscan" ]; then
            banner
            DependenciaB
            GobuScan
        elif [ "$modo" == "IPSCAN" ] || [ "$modo" == "IPscan" ] || [ "$modo" == "ipscan" ]; then
            banner
            IPscan
        elif [ "$modo" == "Procmon" ] || [ "$modo" == "PROCMON" ] || [ "$modo" == "procmon" ]; then
            banner
            procmon
        else
            echo -e "Modo no conocido"
            exit 1
        fi
    fi
else
    echo -e "\n${rojo}  Es necesario ser root para ejecutar la herramienta ${NC}"
    ctrl_c
fi
