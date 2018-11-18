#!/bin/bash
home_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$home_dir" ]]; then home_dir="$PWD"; fi

. $home_dir/../Database/accounts.sh
. $home_dir/../Database/misc.sh



home_showBalance() {
    local total=0
    local totalSavings=0
    local totalChecking=0


    # extract data and convert to PLN
    for i in $@; do
        local currency=$(dbAccounts_get "currency" $i)
        local exchangeRate=$(db_getExchangeRate $currency)
        local balance=$(dbAccounts_get "balance" $i)
        
        if [ "$(dbAccounts_get "type" $i)" == "checking" ]; then
            totalChecking=$(echo "$totalChecking + $balance * $exchangeRate" | bc)
        elif [ "$(dbAccounts_get "type" $i)" == "saving" ]; then
            totalSavings=$(echo "$totalSavings + $balance * $exchangeRate" | bc)
        fi
    done;


    # saving goals
    local goalsID=$(utl_parseToArray $(db_get "virtualAccountsID" "$USERNAME.$DB_EXT" "Users" true))

    for i in ${goalsID[@]}; do
        totalSavings=$(echo $totalSavings + $(db_get "balance" "$i.$DB_EXT" "VirtualAccounts") | bc)
    done


    # balance is stored as integers
    total=$(echo "scale=2;($totalChecking+$totalSavings) / 100" | bc)
    totalChecking=$(echo "scale=2;$totalChecking / 100" | bc)
    totalSavings=$(echo "scale=2;$totalSavings / 100" | bc)
    
    

    local format=".2f"
    ui_alignRight "Saldo:" "$totalChecking" "s" "$format" "4" && echo " PLN"
    ui_alignRight "Oszczędności:" $totalSavings "s" $format "4" && echo " PLN"
    ui_alignRight "W sumie:" $total "s" $format "4" && echo " PLN"

    return 0
}