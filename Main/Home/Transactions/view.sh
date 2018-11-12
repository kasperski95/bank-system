#!/bin/bash
tnst_title="TRANSAKCJE"
tnst_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$tnst_dir" ]]; then tnst_dir="$PWD"; fi

. $tnst_dir/controller.sh



tnst_show() {
    local action
    
    ui_header $home_title $tnst_title
    __tnst_showMenu && echo ""
     ui_line
    read -p "Wybierz akcję: " action
    __tnst_handleAction $action

    return 0
}


__tnst_showMenu() {
    echo "1 - Przelew zwykły"
    printf "$RED"
    echo "2 - Przelew ekspress"
    echo "3 - Przelew walutowy"
    printf "$DEFAULT_COLOR"
    echo "0 - Powrót"
    return 0
}


__tnst_handleAction() {
    case $1 in
        "1") tnst_handleTransfer;;
        "2") tnst_handleExpressTransfer;;
        "3") tnst_handleMonetaryTransfer;;
        *) home_skipPause=true
    esac

    return 0
}