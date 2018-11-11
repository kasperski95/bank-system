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
        local currency=$(db_getFromAccount "currency" $i)
        local exchangeRate=$(db_getExchangeRate $currency)
        local money=$(db_getFromAccount "money" $i)

        if [ "$(db_getFromAccount "type" $i)" == "checking" ]; then
            totalChecking=$(echo "$totalChecking + $money * $exchangeRate" | bc)
        elif [ "$(db_getFromAccount "type" $i)" == "saving" ]; then
            totalSavings=$(echo "$totalSavings + $money * $exchangeRate" | bc)
        fi
        total=$(echo "$total + $money * $exchangeRate" | bc)
    done;

    totalChecking=$(echo "scale=2; $totalChecking / 100" | bc)
    totalSavings=$(echo "scale=2; $totalSavings / 100" | bc)
    total=$(echo "scale=2; $total / 100" | bc)

    echo "Saldo:        $totalChecking PLN"
    echo "Oszczędności: $totalSavings PLN"
    echo "W sumie:      $total PLN"

    return 0
}