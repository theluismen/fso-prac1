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

# Sacar info de la linea de comandos
gz=${@:$#}
files=${@:files_bgn+1:$#-files_bgn-1}

# Comprobar si el comprimido existe
if [[ ! -e $gz ]]; then
    if [[ $D -eq 1 ]]; then # Se tendría que crear
        echo "[-D] - Se crearia el archivo comprimido: $gz."
    else
        for file in ${files[@]}; do [[ ! -e $file ]] && echo "$file no existe. Abortando..." && exit 1; done
        tar zcf $gz $files  # Se crea
    fi
    exit 0
fi

filestoadd=()
tmpdir=$(mktemp -d) # Directorio temporal para la descompresion y posterior compresion 

# Si el comp. existe => selecciono los archivos que quiero añadir
for file in ${files[@]}; do
    # Si el archivo existe => miro de que se use -k
    if tar ztf $gz | grep $file > /dev/null; then
        if [[ $K -eq 1 ]]; then
            if [[ $D -eq 1 ]]; then
                echo "[-D] - Se crearia duplicado con fecha de: $file"
                echo "[-D] - $file: Archivo marcado para añadir a $gz."
            else
                datedfile="$file.$(date +%Y.%m.%d:%H.%M.%S)"
                cp -r $file $datedfile
                mv $datedfile $tmpdir
                filestoadd+=($datedfile)
            fi
        else
            echo "$file existeix a: $gz. Usa -k per a crear una copia amb data."
        fi
    else
        if [[ $D -eq 1 ]]; then
            echo "[-D] - $file: Archivo marcado para añadir a $gz."
        else
            cp -r $file $tmpdir
            filestoadd+=($file)
        fi
    fi
done

# de los archivos que añadir => los añado 
[[ $D -eq 1 ]] && echo "[-D] - Se descomprime el contenido de $gz en $tmpdir"
[[ $D -eq 1 ]] && echo "[-D] - Se comprime el contenido de $tmpdir en $gz ( con los archivos por añadir )"
if [[ ! -z $filestoadd ]]; then  
    tar zxf $gz -C $tmpdir
    tar zcf $gz -C $tmpdir .    
fi
rm -rf $tmpdir
