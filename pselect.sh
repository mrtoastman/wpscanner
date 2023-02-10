# !/bin/bash
contar_archivos=$(cat /tmp/contar_archivos.$PPID) && rm /tmp/contar_archivos.$PPID
archivos=$(cat /tmp/archivos.$PPID) && rm /tmp/archivos.$PPID
echo "contar_archivos=${archivos}"
echo "archivos=${archivos}"