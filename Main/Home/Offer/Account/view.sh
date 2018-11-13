#!/bin/bash
ofrAct_title="KONTO I RACHUNKI BANKOWE"
ofrAct_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$ofrAct_dir" ]]; then ofrAct_dir="$PWD"; fi

. $ofrAct_dir/controller.sh



ofrAct_show() {
    local action

    ui_header "$ofr_title" "$ofrAct_title"
    __ofrAct_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __ofrAct_handleAction $action

    return 0
}


__ofrAct_showMenu() {
    echo "1 - Informacje o koncie"
    echo "2 - Nowy rachunek bankowy"
    echo "0 - Powrót"

    return 0
}


__ofrAct_handleAction() {
    case $1 in
        "1") ofrAct_showInfo;;
        "2") ofrAct_create;;
        *) home_skipPause=true
    esac

    return 0
}