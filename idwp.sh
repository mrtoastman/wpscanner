# !/bin/bash

unset url
echo "-----------------------------------------"
echo "ID WP - Analisis de instalaciones de Wordpress"
echo "-----------------------------------------"
# pedir datos de web a analizar
read -p "Ingrese la web a analizar > " url
echo "Se analizara la web $url para buscar instalaciones activas de Wordpress"
echo "-----------------------------------------"

# verificar que carpeta logs exista
if [ -d "logs" ];
then
    echo "Carpeta de logs ya existe. Registrando en log"
    touch logs/log-$(date +%d_%b).log
    echo "[$(date +%d_%b_%H_%M)] Escaneo inicial: $url" >> logs/log-$(date +%d_%b).log
    echo "Escaneo registrado"
    sleep 3
else
    echo "Carpeta de logs no existe. Creando carpeta ."
    mkdir logs
    chmod 766 logs/    
    touch logs/log-$(date +%d_%b).log
    echo "[$(date +%d_%b_%H_%M)] Escaneo inicial: $url" >> logs/log-$(date +%d_%b).log
    echo "Escaneo registrado"
    sleep 3
fi

# bajar codigo fuente de web y guardarlo en carpeta html
if [ -d "html" ];
then
	echo "Carpeta html ya existe. Guardando codigo fuente de index"
else
	mkdir html
	chmod 766 html/
fi
wget -O html/$url-$(date +%d_%b_%H_%M).html $url

# leer archivo guardado y buscar coincidencia
id=$(grep -w html/$url-$(date +%d_%b_%H_%M).html -e 'wp-content')
if [ -z "$id" ]
then
      echo "$url no tiene instalaciones de Wordpress activas"
      echo "[$(date +%d_%b_%H_%M)] No se encontraron instalaciones de Wordpress activas en $url" >> logs/log-$(date +%d_%b).log
else
      echo "Se identificaron instalaciones de Wordpress en $url"
      echo "[$(date +%d_%b_%H_%M)] Instalaciones de Wordpress identificadas en $url. Se inicia escaneo de vulnerabilidades" >> logs/log-$(date +%d_%b).log
fi

# iniciar escaneo completo del sitio web
echo "-----------------------------------------"
echo "Procediendo a analisis de vulnerabilidades de $url"
. ./full-wpscan.sh
echo "-----------------------------------------"
sleep 5