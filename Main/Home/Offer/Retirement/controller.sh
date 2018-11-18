#!/bin/bash

ofrRet_show() {
    ui_header "$ofr_title" "EMERYTURA"

    # get accounts
    local accounts=$(db_getUserAccounts)

    # aggregate transaction
    local transactions=()
    for i in ${accounts[@]}; do
        transactions+=("$(utl_parseToArray $(db_get "transactionsID" "$i.$DB_EXT" "Accounts" true))")
    done

    # calculate total transfers to ZUS
    local sumTotal="0"
    for i in ${transactions[@]}; do
        local targetName=$(db_get "targetName" "$i.$DB_EXT" "Transactions")
        if [ "$targetName" == "ZUS" ]; then
            local receivedSum=$(db_get "receivedSum" "$i.$DB_EXT" "Transactions")
            sumTotal=$(echo "scale=0; $sumTotal+$receivedSum" | bc)
        fi
    done

    # calculate & retirement
    local retirement=$(echo "scale=2;$sumTotal/218400" | bc | sed "s/^\./0./")
    sumTotal=$(echo "scale=2;$sumTotal/100" | bc | sed "s/^\./0./")
    echo "Suma wpłaconych składek: $sumTotal PLN"
    echo "Prognozowana emerytura: $retirement PLN"
    echo ""
    return 0
}