#!/bin/bash
servCan_title="KANTOR"
servCan_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servCan_dir" ]]; then servCan_dir="$PWD"; fi

. $servCan_dir/../../../Database/misc.sh



servCan_handleExchange() {
    local action

    # choose src currency
    __servCan_showCurrencies

    # handle user input
    read -p "Wybierz walutę: " action
    local currency=$(__servCan_getCurrencyFromNumber $action)

    local sum
    ui_header "$servCan_title" "Kwota"
    read -p "Podaj kwotę: " sum
    

    # print relative exchange rates 
    ui_header "$servCan_title" "$sum $currency"
    local srcExchangeRate=$(db_getExchangeRate $currency)
    local currencies=("PLN" "USD" "EUR" "CHF" "GBP" "AUD" "UAH" "CZK" "HRK" "RUB")
    for i in ${currencies[@]}; do
        if [ "$i" != "$currency" ]; then
            echo "$i: $(printf "%.2f" "$(echo "scale=2;($(echo "scale=4;$sum / ($(db_getExchangeRate $i)/$(db_getExchangeRate $currency))" | bc) +0.0049)/1" | bc)")"
        fi
    done
    echo ""

    return 0
}



__servCan_showCurrencies() {
    ui_header "$serv_title" "$servCan_title"
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


__servCan_getCurrencyFromNumber() {
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