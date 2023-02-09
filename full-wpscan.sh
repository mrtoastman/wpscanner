# !/bin/bash
url=""
user=""
opt=0
.secrets/ ./secrets.sh

while :
do
    #limpiar pantalla
    clear
    #desplegar menu de opciones
    echo "-----------------------------------------"
    echo "FULL WP SCAN - Script de analisis de vulnerabilidades de Wordpress"
    echo "-----------------------------------------"
    echo " MENU PRINCIPAL "
    echo "-----------------------------------------"
    read -p "Ingrese la url a escanear > " url
	echo "Se escaneara sitio web $url"
    echo "-----------------------------------------"
    echo "1. Escaneo general y busqueda de usuarios"
    echo "2. Atacar usuario"
    echo "3. Salir"


    #leer datos ingresados
    read -p "Ingrese una opción: " opt
    
    #validar opcion ingresada
    case $opt in
        1) echo "\nEscaneo general"
		   echo "Se escaneara sitio web $url"
		   echo "Escaneo iniciado: $(date +%d-%b - %H-%M)" 
		   while :;do for s in / - \\ \|; do printf "\r$s";sleep 1;done;done &
		   wpscan --url $url -e u --api-token $wpscan_token --random-user-agent -v > informe-$url-$(date +%d-%b-%H_%M).txt
		   kill $!; trap 'kill $!' SIGTERM
		   echo "Escaneo finalizado el $(date +%d-%b-%H_%M) y guardado como informe-$url-$user-$(date +%d-%b_%H-%M).txt"
           sleep 10
           exit 0
           ;;
        2) echo "\nAtacar usuario"
		   read -p "Ingrese el usuario a atacar > " user
		   echo "Se escaneara sitio web $url y atacara al usuario $user"
		   echo "Ataque iniciado: $(date +%d-%b - %H-%M)" 
		   while :;do for s in / - \\ \|; do printf "\r$s";sleep 1;done;done &
		   wpscan --url $url --passwords .secrets/dics/*.txt --usernames $user --api-token $wpscan_token --random-user-agent -v > informe-$url-$user-$(date +%d-%b-%H_%M).txt
		   kill $!; trap 'kill $!' SIGTERM
		   echo "Escaneo finalizado el $(date +%d-%b-%H_%M) y guardado como informe-$url-$user-$(date +%d-%b_%H-%M).txt"
           sleep 10
           exit 0
           ;;
        3) echo "Salir del programa..."
           exit 0
           ;;
    esac
done