#!/bin/bash

# Funcio que mostra cóm s'ha d'emprar l'script
function usage () {
    echo "$1"
    echo "Ús de l'script:"
    echo "  $0 [-k] [-D] fitxer1 [fitxer2] ... fitxer.tar"
}

# Funcio comproba l'ordre de les opcions
function check_order () {
    echo "OPTIND: $1"
    echo "Cursor: $cursor"
    if [[ $1 -gt $cursor ]]; then
        echo mal orden;
    else
        if [[ $1 == $cursor ]]; then
            (($cursor+1))
        fi
    fi
}

# date +%Y%m%d
SAFEDUP_MODE=0
DRYRUN_MODE=0

OPTSTR=":kD"

# Controlar nom d'arguments
if [[ $# -lt 2 ]]; then 
    usage "[!] - Hi falten arguments."
    exit 1
fi

cursor=1
files_init=1
while getopts $OPTSTR OPT; do
    case $OPT in
        "k")
            SAFEDUP_MODE=1
            # echo k
            # check_order $((OPTIND-1))
            ((files_init++))
            ;;
        "D")
            DRYRUN_MODE=1
            # echo D
            # check_order $((OPTIND-1))
            ((files_init++))
            ;;
        "?")
            usage "[!] - Parametre desconegut $OPTARG"
            exit 1
            ;;
    esac
done
echo $files_init
ARCHIVOS=${@:files_init:$#-$files_init}
echo ${ARCHIVOS[@]}
# echo "$@" $#