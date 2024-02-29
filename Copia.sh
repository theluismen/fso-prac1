#!/bin/bash

echo "[+] - Running" ${@:$#}

OPTSTR=":kD"

while getopts $OPTSTR opt; do
    case $opt in
        "k")
            echo "-k mode on"
            ;;
        "D")
            echo "-D mode on"
            ;;
        "?")
            echo "unknown mode. Exitting..."
            exit 1
            ;;
    esac
done