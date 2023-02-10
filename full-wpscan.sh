# !/bin/bash

unset user opt

# capturar token de api
token=$(awk -F'"' '/^wpscan_token=/ {print $2}' .secrets/secrets.sh )

echo "-----------------------------------------"
echo "\nESCANEO GENERAL DE VULNERABILIDADES"
echo "Se escaneara sitio web $url"
echo "Escaneo iniciado: $(date +%d_%b_%H_%M)"
echo "-----------------------------------------"

# verificar carpeta de informes
echo "Verificando directorio de informes"
if [ -d "informes" ];
then
    echo "Carpeta de informes ya existe. Accediendo a carpeta"
    echo "Iniciando ataque. Por favor espere a que el proceso termine. Se generara un archivo .txt con el resultado de la operacion en la carpeta informes"
else
	echo "Carpeta de informes no existe. Creando carpeta informes."
    mkdir informes/
    chmod 766 informes/
    echo "Iniciando ataque. Por favor espere a que el proceso termine. Se generara un archivo .txt con el resultado de la operacion en la carpeta informes"
fi

# iniciar escaneo general de sitio web
echo "-----------------------------------------"
while :;do for s in / - \\ \|; do printf "\r$s";sleep 1;done;done &
wpscan --url $url -e u --api-token $token --random-user-agent -v > informes/informe-$url-$(date +%d_%b).txt
kill $!; trap 'kill $!' INT TERM

# guardar informe de escaneo en carpeta de informes
echo "Escaneo finalizado el $(date +%d-%b-%H_%M) y guardado como informe-$url-$user-$(date +%d_%b).txt"
sleep 3

# buscar usuarios en informe
echo "-----------------------------------------"
echo "Se buscaran usuarios en el informe generado del sitio web $url"
users=$(grep -w informes/informe-$url-$(date +%d_%b).txt -e 'User(s) Identified')
echo "-----------------------------------------"
if [ -z "$users" ]
	then
		echo "No se han identificado usuarios por el momento."
		echo "[$(date +%d_%b_%H_%M)] Sitio escaneado: $url | No se encontraron usuarios durante este analisis" >> logs/log-$(date +%d_%b).log
		echo "Log registrado"
		echo "-----------------------------------------"
		sleep 3
	else
		echo "Se han identificado usuarios en $url."
		echo "[$(date +%d_%b_%H_%M)] Sitio escaneado: $url | Se encontraron usuarios en la instalacion de Wordpress" >> logs/log-$(date +%d_%b).log
		echo "Log registrado"
		echo "-----------------------------------------"
		sleep 3
fi

