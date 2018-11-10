#!/bin/bash

# Saving goals (virtual account, monthly transfer, calcaulate time)

servGls_title="CELE OSZCZĘDNOŚCIOWE"
servGls_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servGls_dir" ]]; then servGls_dir="$PWD"; fi

. $servGls_dir/utils.sh



servGls_show() {
    local action

    ui_printHeader "$serv_title -> $servGls_title"
    __servGls_showMenu && echo ""
    ui_printLine
    read -p "Wybierz akcję: " action
    __servGls_handleAction $action

    return 0
}


__servGls_showMenu() {
    echo "1 - Lista"
    echo "2 - Dodaj"
    echo "3 - Usuń"
    echo "0 - Powrót"

    return 0
}


__servGls_handleAction() {
    case $1 in
        "1") __servGls_showList;;
        "2") __servGls_add;;
        "3") __servGls_delete;;
        *) home_skipPause=true
    esac

    return 0
}

