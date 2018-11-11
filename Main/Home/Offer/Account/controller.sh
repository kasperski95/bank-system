#!/bin/bash#
ofrAct_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$ofrAct_dir" ]]; then ofrAct_dir="$PWD"; fi

. $ofrAct_dir/../../../Database/users.sh
. $ofrAct_dir/../../../Database/accounts.sh


ofrAct_showInfo() {
    ui_header $ofrAct_title "INFORMACJE"

    echo "Imię: $(db_getFromUser "firstname")"
    echo "Nazwisko: $(db_getFromUser "surname")"
    echo "Adres: $(db_getFromUser "city"), ul. $(db_getFromUser "street") $(db_getFromUser "streetNumber")"
    echo "Telefon: $(db_getFromUser "phoneNumber")"
    

    local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
    echo "Rachunki roczlieniowe:"
    for i in $accounts; do
        if [ "$(db_getFromAccount "type" $i)" == "checking" ]; then
            printf "    $i\n"
        fi
    done;
    echo "Rachunki oszczędnościowe:"
    for i in $accounts; do
        if [ "$(db_getFromAccount "type" $i)" == "saving" ]; then
            printf "    $i\n"
        fi
    done;
    echo ""

    return 0
}

ofrAct_create() {
    return 0
}