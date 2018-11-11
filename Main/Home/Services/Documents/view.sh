#!/bin/bash
servDoc_title="DOKUMENTY"
servDoc_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servDoc_dir" ]]; then servDoc_dir="$PWD"; fi

. $servDoc_dir/controller.sh


servDoc_show() {
    local action

    ui_header $serv_title $servDoc_title
    __servDoc_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __servDoc_handleAction $action

    return 0
}


__servDoc_showMenu() {
    echo "1 - Lista"
    echo "2 - Dodaj"
    echo "3 - Usuń"
    echo "0 - Powrót"

    return 0
}


__servDoc_handleAction() {
    case $1 in
        "1") __servDoc_showList;;
        "2") __servDoc_add;;
        "3") __servDoc_delete;;
        *) home_skipPause=true
    esac

    return 0
}
