#!/bin/bash

# Funció per mostrar l'ús del script
function usage () {
    echo "Ús Dolent:"
    echo "  $0 [-k] [-D] fitxer.tgz file.txt [ files.txt ... ] directori"
    exit 1
}

# Comprova els arguments
if [ $# -lt 2 ]; then
    usage
fi

# Variables per opcions
K=0
D=0
file_bgn=1
# Processa les opcions
while getopts ":kD" OPT; do
    case $OPT in
        k) K=1; ((files_bgn++));;
        D) D=1; ((files_bgn++));;
        *) usage ;;
    esac
done

# Nom del fitxer de sortida L'arxiu $fitxer_sortida ja existeix.
gz=${@:$#}
files=${@:files_bgn+1:$#-files_bgn-1}
if [[ ! -e $gz ]]; then
    if [[ $D -eq 1 ]]; then
        echo "[-D] - Se crearia el archivo comprimido: $gz."
    else 
        tar zcf $gz $files
    fi
    exit 1
fi

# # Itera pels fitxers i directoris d'entrada
for fitxer in $files; do
    if ! tar --list -zf $gz $file &> /dev/null; then
        
    else
    
    fi
    # Comprova si el fitxer és un directori
    if [ -d "$fitxer" ]; then
        if [ $K -eq 1 ]; then
            tar rf "$fitxer_sortida" --transform="s|^\./|$fitxer.$(date +%Y.%m.%d:%H.%M.%S)/|" "$fitxer"
        else
            tar rf "$fitxer_sortida" "$fitxer"
        fi
    else
        # Comprova si el fitxer ja existeix a l'arxiu comprimit
        if tar tf "$fitxer_sortida" | grep -q "$fitxer"; then
            if [ $K -eq 1 ]; then
                nom_fitxer=$(basename "$fitxer")
                data_modificacio=$(date -r "$fitxer" +%Y.%m.%d:%H.%M.%S)
                tar rf "$fitxer_sortida" --transform="s|^\./|$nom_fitxer.$data_modificacio/|" "$fitxer"
            else
                echo "El fitxer $fitxer ja existeix a l'arxiu comprimit."
            fi
        else
            tar rf "$fitxer_sortida" "$fitxer"
        fi
    fi
done

# echo "S'ha afegit correctament tots els fitxers a l'arxiu comprimit."

