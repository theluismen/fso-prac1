#!/bin/bash

function usage () {
    echo "Ús Dolent:"
    echo "  $0 [-D] fitxer.tgz file.txt [ files.txt ... ] directori"
}

# Variables d'opcions
D_MODE=0

# Comprobar que el nombre d'args es apropiat 
if [[ $# -lt 3 ]]; then
    usage
    exit 1
fi

# On comencen els arxius a extreure
files_bgn=1 

# Parsejar opcions
while getopts ":D" OPT; do
    case $OPT in
        "D") 
            D_MODE=1
            ((files_bgn++))
            ;;
        "?") 
            usage
            exit 1
        ;;
    esac
done

# Agafar informacio de la cli
gz=${@:files_bgn:1}
files=${@:files_bgn+1:$#-files_bgn-1}
dir=${@:$#}

# Comprobar que existe el comprimido
if [[ ! -e $gz ]]; then
    echo "No s'ha trobat el fitxer: $gz"
    exit 1
fi 

# Comprobar que el directori existeix i sino crearlo
if [[ ! -d $dir ]]; then
    echo "El directorio destino $dir no existe"
    if [[ $D_MODE -eq 1 ]]; then
        echo "[-D] - Se crearia el directorio destino: $dir"
    else 
        mkdir $dir
        echo "Directorio destino $dir creado"
    fi
fi

# Para cada archivo, compruebo si esta, si existe en el directorio destino i si es asi lo etiqueto con la fecha
for file in $files; do 
    # Si el fitxer es troba al comprimit
    if ! tar --list -zf $gz $file &> /dev/null; then
        echo "No existeix $file a $gz"
    else 
        [[ $D_MODE -eq 1 ]] && echo "[-D] - Se extraeria $file de $gz" || tar -zxf $gz $file

        if [[ -e "$dir/$file" ]]; then
            filefecha="$file.$(date +%Y.%m.%d:%H.%M.%S)"
            [[ $D_MODE -eq 1 ]] && echo "[-D] - Fichero repetido. $file -> $filefecha"
            file=$filefecha
        fi
        [[ $D_MODE -eq 1 ]] && echo "[-D] - Se moveria $file a $dir" || mv $file $dir
    fi
done