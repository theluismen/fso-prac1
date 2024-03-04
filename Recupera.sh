#!/bin/bash

function usage () {
    echo "Ús Dolent:"
    echo "  $0 [-D] fitxer.tgz file.txt [ files.txt ... ] directory"
}

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

# Comprobar que el fitxer comprimir existeix 
if [[ ! -e $gz ]]; then
    echo "No s'ha trobat el fitxer: $gz"
    exit 1
fi 

# Comprobar que el directori existeix i sino crearlo
if [[ ! -d $dir ]]; then
    mkdir $dir
    echo creat $dir
fi

for file in $files; do 
    if ! tar --list -zf $gz $file &> /dev/null; then
        echo $file not exists in $gz
    else 
        tar -zxf $gz $file
        mv $file $dir        
    fi
done