#!/bin/bash
home_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$home_dir" ]]; then home_dir="$PWD"; fi

. $home_dir/../../Database/accounts.sh



home_show() {
    while isLogIn; do
        local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
        local action
        clear
        echo -e "STRONA GŁÓWNA"
        ui_printLine
        echo ""
        __home_showInfo $accounts
        echo ""
        __home_showMenu
        echo ""
        read -p "Wybierz akcję: " action
        __home_handleAction $action
        
    done

    return 0
}


# Money in total
__home_showInfo() {
    local total=0
    local totalSavings=0
    local totalChecking=0

    # extract data
    for i in $@; do
        if [ "$(db_getFromAccount "type" $i)" == "checking" ]; then
            (( totalChecking+=$(db_getFromAccount "money" $i) ))
        elif [ "$(db_getFromAccount "type" $i)" == "saving" ]; then
            (( totalSavings+=$(db_getFromAccount "money" $i) ))
        fi
        (( total+=$(db_getFromAccount "money" $i) ))
    done;

    echo "Saldo:        $totalChecking"
    echo "Oszczędności: $totalSavings"
    echo "W sumie:      $total"

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
    local action=$1
    local skipPause=false

    case $action in
        "1") echo "Implement transactions";;
        "2") echo "Implement history";;
        "3") echo "Implement finance";;
        "4") echo "Implement services";;
        "5") echo "Implement offer";;
        "0") logOut && skipPause=true;;
    esac

    if ! $skipPause; then
        ui_printLine
        echo ""
        read -n 1 -s -r -p "wciśnij dowolny klawisz aby kontynuować..."
    fi
    return 0
}