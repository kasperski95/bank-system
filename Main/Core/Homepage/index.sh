#!/bin/bash

home_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$home_dir" ]]; then home_dir="$PWD"; fi

. $home_dir/../../Database/accounts.sh



home_show() {
    local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
    
    echo -e "STRONA GŁÓWNA\n"
    _home_showInfo $accounts
    _home_showMenu
    return 0
}


# Money in total
_home_showInfo() {
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


# Show menu and handle interaction
_home_showMenu() {
    return 0
}




# MENU
# Transactions
# History
# Finance
# Services
# Offer