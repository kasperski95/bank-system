#!/bin/bash
fin_title="FINANSE"
fin_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$fin_dir" ]]; then fin_dir="$PWD"; fi

. $fin_dir/finances.sh



fin_show() {
    local action

    ui_printHeader "$home_title -> $fin_title"
    __fin_showMenu && echo ""
    ui_printLine
    read -p "Wybierz akcję: " action
    __fin_handleAction $action

    return 0
}


__fin_showMenu() {
    echo "1 - Podsumowanie"
    echo "2 - Subkonto"
    echo "3 - Konta oszczędnościowe"
    echo "4 - Karty kredytowe"
    echo "5 - Pożyczki"
    echo "0 - Powrót"
    return 0
}


__fin_handleAction() {
    case $action in
        "1") __fin_sumarize;;
        "2") __fin_showSubaccount;;
        "3") __fin_showSavingAccounts;;
        "4") __fin_showCreditCards;;
        "5") __fin_showLoans;;
        *) home_skipPause=true
    esac
    return 0
}