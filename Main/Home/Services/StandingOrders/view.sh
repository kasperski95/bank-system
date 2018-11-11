#!/bin/bash
servSo_title="STAŁE_ZLECENIA"
servSo_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servSo_dir" ]]; then servSo_dir="$PWD"; fi

. $servSo_dir/controller.sh



servSo_show() {
    local action

    ui_printHeader "$serv_title -> $servSo_title"
    __servSo_showMenu && echo ""
    ui_printLine
    read -p "Wybierz akcję: " action
    __servSo_handleAction $action

    return 0
}


__servSo_showMenu() {
    echo "1 - Lista" 
    echo "2 - Dodaj" 
    echo "3 - Usuń" 

    return 0
}


__servSo_handleAction() {
    case $1 in
        "1") __servSo_showList;;
        "2") __servSo_add;;
        "3") __servSo_delete;;
        *) home_skipPause=true;;
    esac

    return 0
}