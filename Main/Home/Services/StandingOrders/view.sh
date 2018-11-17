#!/bin/bash
servSo_title="STAŁE_ZLECENIA"
servSo_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servSo_dir" ]]; then servSo_dir="$PWD"; fi

. $servSo_dir/controller.sh



servSo_show() {
    local action

    ui_header "$serv_title" "$servSo_title"
    servSo_showList
    __servSo_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __servSo_handleAction $action

    return 0
}


__servSo_showMenu() {
    echo "1 - Dodaj" 
    echo "2 - Usuń" 
    echo "0 - Powrót"

    return 0
}


__servSo_handleAction() {
    case $1 in
        "1") __servSo_add;;
        "2") __servSo_delete;;
        *) home_skipPause=true;;
    esac

    return 0
}