#!/bin/bash
serv_title="USŁUGI"
serv_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$serv_dir" ]]; then serv_dir="$PWD"; fi

. $serv_dir/Cantor/view.sh
. $serv_dir/Documents/view.sh
. $serv_dir/Certificates/view.sh
. $serv_dir/Goals/view.sh
. $serv_dir/Receivers/view.sh
. $serv_dir/StandingOrders/view.sh
. $serv_dir/../../Database/transactions.sh

. $serv_dir/controller.sh



serv_show() {
    local action

    ui_header "$home_title" "$serv_title"
    __serv_showMenu && echo ""
    ui_line
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
    echo "6 - Dokumenty"
    echo "7 - Zaświadczenia"
    echo "8 - Doładowanie telefonu"
    echo "9 - Kantor"
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
        "7") servCer_show;;
        "8") serv_showTopUpPhone;;
        "9") servCan_handleExchange;;
        *) home_skipPause=true;;
    esac

    return 0
}