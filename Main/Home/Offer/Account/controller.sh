#!/bin/bash#
ofrAct_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$ofrAct_dir" ]]; then ofrAct_dir="$PWD"; fi

. $ofrAct_dir/../../../Database/users.sh
. $ofrAct_dir/../../../Database/accounts.sh


ofrAct_showInfo() {
    ui_header "$ofrAct_title" "INFORMACJE"

    echo "Imię: $(dbUsers_get "firstname")"
    echo "Nazwisko: $(dbUsers_get "lastname")"
    echo "Adres: $(dbUsers_get "city"), ul. $(dbUsers_get "street") $(dbUsers_get "streetNumber")"
    echo "Telefon: $(dbUsers_get "phoneNumber")"
    

    local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
    echo "Rachunki roczlieniowe:"
    for i in $accounts; do
        if [ "$(dbAccounts_get "type" $i)" == "checking" ]; then
            printf "    $i\n"
        fi
    done;
    echo "Rachunki oszczędnościowe:"
    for i in $accounts; do
        if [ "$(dbAccounts_get "type" $i)" == "saving" ]; then
            printf "    $i\n"
        fi
    done;
    echo ""

    return 0
}


ofrAct_create() {
    local accountID accountType currency confirmation

    __ofrActCr_showTypes
    read -p "Wybierz typ konta: " accountType 
 
    __ofrActCr_showCurrencies
    read -p "Wybierz walutę: " currency 

    __ofrActCr_showConfirmation $accountType $currency
    read -p "Wybierz akcję: " confirmation 


    if [ "$confirmation" == "1" ]; then
        __ofrActCr_createAccount $accountType $currency
        return 0
    fi
    home_skipPause=true
    return 1
}


#————————————————————————————————————————————————————————


ofrActCr_title="NOWY RACHUNEK"

__ofrActCr_createAccount() {
    local accountType=$1
    local currency=$2

    accountType=$(__ofrActCr_getAccountTypeFromNumber $accountType)
    currency=$(__ofrActCr_getCurrencyFromNumber $currency)
    accountID=$(db_createAccount $accountType $currency)
    db_addAccount $accountID
    
    ui_header "$ofrActCr_title" "UTWORZONO KONTO"
    echo "Konto zostało utworzone."
    echo "Numer konta: $accountID"
    echo ""

    return 0
}


__ofrActCr_showTypes() {
    ui_header "$ofrActCr_title" "TYP"
    echo "1 - Rachunek rozliczeniowy"
    echo "2 - Rachunek oszczędnościowy"
    echo ""
    ui_line

    return 0
}


__ofrActCr_showCurrencies() {
    ui_header "$ofrActCr_title" "WALUTA"
    echo "1 - PLN"
    echo "2 - USD"
    echo "3 - EUR"
    echo "4 - CHF"
    echo "5 - GBP"
    echo "6 - AUD"
    echo "7 - UAH"
    echo "8 - CZK"
    echo "9 - HRK"
    echo "0 - RUB"
    echo ""
    ui_line

    return 0
}


__ofrActCr_showConfirmation() {
    ui_header "$ofrActCr_title" "POTWIERDZENIE"
    echo "Typ: $(__ofrActCr_getAccountNameFromNumber $1)"
    echo "Waluta: $(__ofrActCr_getCurrencyFromNumber $2)"
    echo ""
    echo "1 - Utwórz"
    echo "0 - Anuluj"
    echo ""
    ui_line

    return 0
}


__ofrActCr_getAccountNameFromNumber() {
    case $1 in
        "1") echo "Rachunek rozliczeniowy";;
        "2") echo "Rachunek oszczędnościowy";;
    esac

    return 0
}


__ofrActCr_getAccountTypeFromNumber() {
    case $1 in
        "1") echo "checking";;
        "2") echo "saving";;
    esac

    return 0
}


__ofrActCr_getCurrencyFromNumber() {
    case $1 in
        "1") echo "PLN";;
        "2") echo "USD";;
        "3") echo "EUR";;
        "4") echo "CHF";;
        "5") echo "GBP";;
        "6") echo "AUD";;
        "7") echo "UAH";;
        "8") echo "CZK";;
        "9") echo "HRK";;
        "0") echo "RUB";;
    esac

    return 0
}