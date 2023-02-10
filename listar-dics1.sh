# !/bin/bash

unset options i

while IFS= read -r -d $'\0' f; do
  options[i++]="$f"
done < $(find .secrets/dics -maxdepth 1 -type f -name "*.txt" -print0 )

select opt in "${options[@]}" "Cancelar"; do
  case $opt in
    *.txt)
      echo "Diccionario seleccionado > $opt"
      # processing
      ;;
    "Cancelar")
      echo "Saliendo..."
      break
      ;;
    *)
      echo "Seleccion incorrecta"
      ;;
  esac
done