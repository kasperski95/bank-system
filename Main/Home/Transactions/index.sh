#!/bin/bash
tnst_title="TRANSAKCJE"
tnst_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$tnst_dir" ]]; then tnst_dir="$PWD"; fi

. $tnst_dir/utils.sh



tnst_show() {
    local action
    
    ui_printHeader "$home_title -> $tnst_title"
    __tnst_showMenu && echo ""
     ui_printLine
    read -p "Wybierz akcję: " action
    __tnst_handleAction $action

    return 0
}


__tnst_showMenu() {
    echo "1 - Przelew zwykły"
    echo "2 - Przelew ekspress"
    echo "3 - Przelew walutowy"
    echo "0 - Powrót"
    return 0
}


__tnst_handleAction() {
    case $1 in
        "1") __tnst_makeTransfer;;
        "2") __tnst_makeExpressTransfer;;
        "3") __tnst_makeMonetaryTransfer;;
        *) home_skipPause=true
    esac

    return 0
}