#!/bin/bash
home_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$home_dir" ]]; then home_dir="$PWD"; fi

. $home_dir/../Database/accounts.sh
. $home_dir/../Database/misc.sh



home_showMoney() {
    local total=0
    local totalSavings=0
    local totalChecking=0


    # extract data and convert to PLN
    for i in $@; do
        local currency=$(dbAccounts_get "currency" $i)
        local exchangeRate=$(db_getExchangeRate $currency)
        local money=$(dbAccounts_get "money" $i)

        if [ "$(dbAccounts_get "type" $i)" == "checking" ]; then
            totalChecking=$(echo "$totalChecking + $money * $exchangeRate" | bc)
        elif [ "$(dbAccounts_get "type" $i)" == "saving" ]; then
            totalSavings=$(echo "$totalSavings + $money * $exchangeRate" | bc)
        fi
        total=$(echo "$total + $money * $exchangeRate" | bc)
    done;

    totalChecking=$(echo " $totalChecking / 100" | bc)
    totalSavings=$(echo "$totalSavings / 100" | bc)
    total=$(echo "$total / 100" | bc)

    printf "Saldo:        %.2f PLN\n" $totalChecking
    printf "Oszczędności: %.2f PLN\n" $totalSavings
    printf "W sumie:      %.2f PLN\n" $total

    return 0
}