#!/bin/bash
ofr_title="OFERTA"
ofr_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$ofr_dir" ]]; then ofr_dir="$PWD"; fi


. $ofr_dir/../../Database/accounts.sh
. $ofr_dir/../../Database/misc.sh
. $ofr_dir/../../Database/receivers.sh
. $ofr_dir/../../Database/transactions.sh
. $ofr_dir/../../Database/users.sh

. $ofr_dir/Account/view.sh
. $ofr_dir/Insurances/controller.sh
. $ofr_dir/Phone/controller.sh
. $ofr_dir/Credits/controller.sh
. $ofr_dir/Leasing/controller.sh
. $ofr_dir/Zus/controller.sh
. $ofr_dir/Retirement/controller.sh
. $ofr_dir/Savings/controller.sh
. $ofr_dir/Terminals/controller.sh


ofr_show() {
    local action

    ui_header "$home_title" "$ofr_title"
    __ofr_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __ofr_handleAction $action

    return 0
}


__ofr_showMenu() {
    echo "1 - Konto i rachunki bankowe"
    echo "2 - Oszczędności"
    echo "3 - Kredyty i pożyczki"
    echo "4 - Karty i płatności telefonem"
    echo "5 - Emerytura"
    echo "6 - Ubezpieczenia"
    echo "7 - Rozliczenie z ZUS"
    echo "8 - Leasing"
    echo "9 - Terminale płatnicze"
    echo "0 - Powrót"

    return 0
}


__ofr_handleAction() {
    case $1 in
        "1") ofrAct_show;;
        "2") ofrSvg_show;;
        "3") ofrCre_show;;
        "4") ofrPho_show;;
        "5") ofrRet_show;;
        "6") ofrIns_show;;
        "7") ofrZus_show;;
        "8") ofrLsg_show;;
        "9") ofrTrm_show;;
        *) home_skipPause=true
    esac

    return 0
}