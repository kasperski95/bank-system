#!/bin/bash
ofr_title="OFERTA"
ofr_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$ofr_dir" ]]; then ofr_dir="$PWD"; fi

. $ofr_dir/Account/view.sh
. $ofr_dir/Insurances/controller.sh
. $ofr_dir/Phone/controller.sh

. $ofr_dir/../../Database/accounts.sh
. $ofr_dir/../../Database/misc.sh
. $ofr_dir/../../Database/receivers.sh
. $ofr_dir/../../Database/transactions.sh
. $ofr_dir/../../Database/users.sh



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
    printf $RED
    echo "2 - Oszczędności"
    echo "3 - Kredyty i pożyczki"
    printf $GREEN
    echo "4 - Karty i płatności telefonem"
    printf $DEFAULT_COLOR
    echo "5 - Emerytura"
    printf $DEFAULT_COLOR
    echo "6 - Ubezpieczenie"
    printf $RED
    echo "7 - Rozliczenie z ZUS"
    echo "8 - Leasing"
    echo "9 - Terminale płatnicze"
    printf $DEFAULT_COLOR
    echo "0 - Powrót"


    return 0
}


__ofr_handleAction() {
    case $1 in
        "1") ofrAct_show;;
        "4") ofrPho_show;;
        "6") ofrIns_show;;
        *) home_skipPause=true
    esac

    return 0
}