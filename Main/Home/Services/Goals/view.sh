#!/bin/bash

# Saving goals (virtual account, monthly transfer, calcaulate time)

servGls_title="CELE OSZCZĘDNOŚCIOWE"
servGls_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servGls_dir" ]]; then servGls_dir="$PWD"; fi

. $servGls_dir/controller.sh



servGls_show() {
    local action

    ui_header "$serv_title" "$servGls_title"
    servGls_showList
    __servGls_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __servGls_handleAction $action

    return 0
}


__servGls_showMenu() {
    echo "1 - Dodaj"
    echo "2 - Usuń"
    echo "0 - Powrót"

    return 0
}


__servGls_handleAction() {
    case $1 in
        "1") __servGls_add;;
        "2") __servGls_delete;;
        *) home_skipPause=true
    esac

    return 0
}

