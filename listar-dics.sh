# !/bin/bash
dics=""
dicsel=0
export archivos=$(ls .secrets/dics/*.txt)
export contar_archivos=$(ls .secrets/dics/*.txt  | wc -l)
# exportar variables archivos y contar_archivos a un directorio temporal
printf %s "$archivos" > /tmp/archivos.$PPID
printf %s "$contar_archivos" > /tmp/contar_archivos.$PPID
contador=1

while : 
do
	echo " SELECCION DE DICCIONARIO "
    echo "-----------------------------------------"
    echo "En total, existen $contar_archivos diccionarios disponibles:"
    echo "-----------------------------------------"
	while [ $contador -le $contar_archivos ]; do
		for dic in $archivos
			do
				echo "$contador - $dic"
				contador=$(( contador+1 ))
			done
	done
	echo "-----------------------------------------"
	#leer datos ingresados
    read -p "Seleccione el diccionario que desea usar > " dicsel
    echo "El diccionario a utilizar es $dicsel"
    sleep 3
    exit 0
done