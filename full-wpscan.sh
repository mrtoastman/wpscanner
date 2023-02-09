# !/bin/bash
url=""
user=""
opt=0
token=$(awk -F'"' '/^wpscan_token=/ {print $2}' .secrets/secrets.sh )
dics=$(awk -F'"' '/^dicsdispo=/ {print $2}' .secrets/dics/listar-dics.sh )

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
        1) echo "\nESCANEO GENERAL"
		   echo "Se escaneara sitio web $url"
		   echo "Escaneo iniciado: $(date +%d_%b_%H_%M)"
		   echo "-----------------------------------------"
		   echo "Verificando directorio de informes"
		   DIR=informes
			if [ -d "$DIR" ];
			then
			    echo "Carpeta de informes ya existe. Accediendo a carpeta"
			    cd informes/
			    echo "Iniciando ataque. Por favor espere a que el proceso termine. Se generara un archivo .txt con el resultado de la operacion en $DIR"
			else
				echo "Carpeta de informes no existe. Creando carpeta $DIR ."
			    mkdir informes/
			    chmod 766 informes/
			    cd informes/
			    echo "Iniciando ataque. Por favor espere a que el proceso termine. Se generara un archivo .txt con el resultado de la operacion en $DIR"
			fi
		   echo "-----------------------------------------"
		   while :;do for s in / - \\ \|; do printf "\r$s";sleep 1;done;done &
		   wpscan --url $url -e u --api-token $token --random-user-agent -v > informe-$url-$(date +%d_%b_%H_%M).txt
		   kill $!; trap 'kill $!' INT TERM
		   echo "Escaneo finalizado el $(date +%d-%b-%H_%M) y guardado como informe-$url-$user-$(date +%d_%b_%H_%M).txt"
           sleep 10
           exit 0
           ;;
        2) echo "\nATACAR USUARIO"
		   read -p "Ingrese el usuario a atacar > " user
		   echo "Se escaneara sitio web $url y atacara al usuario $user"
		   echo "Ataque iniciado: $(date +%d_%b_%H-%M)" 
		   echo "-----------------------------------------"
		   echo "Verificando directorio de informes"
		   DIR=informes
			if [ -d "$DIR" ];
			then
			    echo "Carpeta de informes ya existe. Accediendo a carpeta"
			    cd informes/
			    echo "Iniciando ataque. Por favor espere a que el proceso termine. Se generara un archivo .txt con el resultado de la operacion en $DIR"
			else
				echo "Carpeta de informes no existe. Creando carpeta $DIR ."
			    mkdir informes/
			    chmod 766 informes/
			    cd informes/
			    echo "Iniciando ataque. Por favor espere a que el proceso termine. Se generara un archivo .txt con el resultado de la operacion en $DIR"
			fi
		   echo "-----------------------------------------"
		   while :;do for s in / - \\ \|; do printf "\r$s";sleep 1;done;done &
		   wpscan --url $url --passwords ../.secrets/dics/pw1.txt --usernames $user --api-token $token --random-user-agent -v > informe-$url-$user-$(date +%d_%b_%H_%M).txt
		   kill $!; trap 'kill $!' INT TERM
		   echo "Escaneo finalizado el $(date +%d-%b-%H_%M) y guardado como informe-$url-$user-$(date +%d-%b_%H-%M).txt"
           sleep 10
           exit 0
           ;;
        3) echo "Salir del programa..."
           exit 0
           ;;
    esac
done