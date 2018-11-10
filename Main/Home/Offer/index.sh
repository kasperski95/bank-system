#!/bin/bash
ofr_title="OFERTA"
ofr_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$ofr_dir" ]]; then ofr_dir="$PWD"; fi



ofr_show() {
    local action

    ui_printHeader "$home_title -> $ofr_title"
    __ofr_showMenu && echo ""
    ui_printLine
    read -p "Wybierz akcję: " action
    __ofr_handleAction $action

    return 0
}


__ofr_showMenu() {
    echo "1 - Konto osobiste"
    echo "2 - Oszczędności"
    echo "3 - Kredyty i pożyczki"
    echo "4 - Karty i płatności telefonem"
    echo "5 - Emerytura"
    echo "6 - Ubezpieczenie"
    echo "7 - Rozliczenie z ZUS"
    echo "8 - Leasing"
    echo "9 - Terminale płatnicze"
    echo "0 - Powrót"

    return 0
}


__ofr_handleAction() {
    case $1 in
        *) home_skipPause=true
    esac

    return 0
}