#!/bin/bash
home_title="STRONA_GŁÓWNA"
home_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$home_dir" ]]; then home_dir="$PWD"; fi

. $home_dir/utils.sh
. $home_dir/Finance/index.sh
. $home_dir/History/index.sh
. $home_dir/Services/index.sh
. $home_dir/Offer/index.sh
. $home_dir/Transactions/index.sh



home_show() {
    while isLogIn; do
        local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
        local action

        ui_printHeader $home_title
        home_showMoney $accounts && echo ""
        __home_showMenu && echo ""
        ui_printLine
        read -p "Wybierz akcję: " action  
        __home_handleAction $action
        
    done

    return 0
}


__home_showMenu() {
    echo "1 - Transakcje"
    echo "2 - Historia"
    echo "3 - Finanse"
    echo "4 - Usługi"
    echo "5 - Oferta"
    echo "0 - Wyloguj"
    return 0
}


__home_handleAction() {
    home_skipPause=false
    local action=$1
    
    case $action in
        "1") tnst_show;;
        "2") hist_show;;
        "3") fin_show;;
        "4") serv_show;;
        "5") ofr_show;;
        "0") logOut && home_skipPause=true;;
        *) home_skipPause=true;;
    esac

    if ! $home_skipPause; then
        ui_printLine
        read -n 1 -s -r -p "wciśnij dowolny klawisz aby wrócić do menu..."
    fi
    return 0
}