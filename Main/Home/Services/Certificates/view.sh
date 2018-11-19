#!/bin/bash
servCer_title="ZAŚWIADCZENIA"
servCer_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servCer_dir" ]]; then servCer_dir="$PWD"; fi

. $servCer_dir/controller.sh


servCer_show() {
    local action

    ui_header "$serv_title" "$servCer_title"
    __servCer_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __servCer_handleAction $action

    return 0
}


__servCer_showMenu() {
    echo "1 - Lista i edycja"
    echo "2 - Dodaj"
    echo "3 - Usuń"
    echo "0 - Powrót"
    return 0
}


__servCer_handleAction() {
    case $1 in
        "1") __servCer_showList;;
        "2") __servCer_add;;
        "3") __servCer_delete;;
        *) home_skipPause=true
    esac

    return 0
}
