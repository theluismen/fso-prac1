#!/bin/bash
# Funció per mostrar l'ús del script
function usage () {
    echo "Ús Dolent:"
    echo "  $0 dia hora script parametres"
    exit 1
}

# Si falten parametres de $0
if [[ $# -lt 3 ]]; then
    usage
fi

dia=$1
hora=$2
script=${@:3:$#}

# Comprobar si los datos de hora y hora son correctos
if [[ $hora -lt 0 ]] || [[ $hora -gt 23 ]] || [[ $dia -lt 1 ]] || [[ $dia -gt 31 ]]; then
    echo "Dia o hora incorrectas."
    usage
fi

# Metemos la info en un archivo del dir personal del usuario
echo "* $hora $dia * * $script" > "$HOME/.crontab"

# Si crontab se ejecuta sin errores perfect
if crontab -u $(whoami) "$HOME/.crontab"; then
    echo "Comanda afegida a crontab"
else
    echo "Comanda no afegida a crontab"
fi

