#!/bin/bash
servRec_title="ODBIORCY"
servRec_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servRec_dir" ]]; then servRec_dir="$PWD"; fi

. $servRec_dir/controller.sh



servRec_show() {
    local action

    ui_header $serv_title $servRec_title
    __servRec_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __servRec_handleAction $action

    return 0
}


__servRec_showMenu() {
    printf $RED
    echo "1 - Lista"
    echo "2 - Dodaj"
    echo "3 - Usuń"
    printf $DEFAULT_COLOR
    echo "0 - Powrót"

    return 0
}


__servRec_handleAction() {
    case $1 in
        "1") __servRec_showList;;
        "2") __servRec_add;;
        "3") __servRec_delete;;
        *) home_skipPause=true
    esac

    return 0
}



