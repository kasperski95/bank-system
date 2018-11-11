#!/bin/bash
serv_title="USŁUGI"
serv_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$serv_dir" ]]; then serv_dir="$PWD"; fi

. $serv_dir/utils.sh
. $serv_dir/Cantor/index.sh
. $serv_dir/Documents/index.sh
. $serv_dir/Goals/index.sh
. $serv_dir/Receivers/index.sh
. $serv_dir/StandingOrders/index.sh



serv_show() {
    local action

    ui_printHeader "$home_title -> $serv_title"
    __serv_showMenu && echo ""
    ui_printLine
    read -p "Wybierz akcję: " action
    __serv_handleAction $action

    return 0
}


__serv_showMenu() {
    echo "1 - Odbiorcy"
    echo "2 - Zaplanowane płatności"
    echo "3 - Stałe zlecenia"
    echo "4 - Cele oszczędnościowe"
    echo "5 - Raty"
    echo "6 - Dokumenty i zaświadczenia"
    echo "7 - Doładowanie telefonu"
    echo "8 - Kantor"
    echo "0 - Powrót"

    return 0
}


__serv_handleAction() {
    case $1 in
        "1") servRec_show;;
        "2") serv_showPlannedPayments;;
        "3") servSo_show;;
        "4") servGls_show;;
        "5") serv_showInstallements;;
        "6") servDoc_show;;
        "7") serv_showTopUpPhone;;
        "8") servCan_handleExchange;;
        *) home_skipPause=true;;
    esac

    return 0
}