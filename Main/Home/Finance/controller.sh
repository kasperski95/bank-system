#!/bin/bash


__fin_sumarize() {
    ui_header $fin_title "WSZYSTKIE RACHUNKI BANKOWE"
    local accounts=$(db_getUserAccounts)

    echo "Rachunki rozliczeniowe:"
    for i in $accounts; do
        if [ $(dbAccounts_get "type" $i) == "checking" ]; then
            local currency=$(dbAccounts_get "currency" $i)
            ui_alignRight $i $(db_getAccountBalance $i) "s" ".2f" "4" && echo " $currency"
        fi
    done
    echo ""

    echo "Rachunki oszczędnościowe:"
    for i in $accounts; do
        if [ $(dbAccounts_get "type" $i) == "saving" ]; then
            local currency=$(dbAccounts_get "currency" $i)
            ui_alignRight $i $(db_getAccountBalance $i) "s" ".2f" "4" && echo " $currency"
        fi
    done
    echo ""

    return 0
}


__fin_showSubaccount() {
    ui_header $fin_title "RACHUNKI ROZLICZENIOWE"
    local accounts=$(db_getUserAccounts)

    for i in $accounts; do
        if [ $(dbAccounts_get "type" $i) == "checking" ]; then
            local currency=$(dbAccounts_get "currency" $i)
            ui_alignRight $i $(db_getAccountBalance $i) "s" ".2f" "4" && echo " $currency"
        fi
    done
    echo ""

    return 0
}


__fin_showSavingAccounts() {
    ui_header "$fin_title" "RACHUNKI OSZCZĘDNOŚCIOWE"
    local accounts=$(db_getUserAccounts)

    for i in $accounts; do
        if [ $(dbAccounts_get "type" $i) == "saving" ]; then
            local currency=$(dbAccounts_get "currency" $i)
            ui_alignRight $i $(db_getAccountBalance $i) "s" ".2f" "4" && echo " $currency"
        fi
    done
    echo ""

    return 0
}


__fin_showCreditCards() {
    ui_header "$fin_title" "KARTY PŁATNICZE"

    # get all accounts
    local _accounts=$(db_getUserAccounts)
    local cardsIDs

    # loop through accounts and aggregate cardsIDs
    for i in ${_accounts[@]}; do
        local _cardsIDs=$(utl_parseToArray $(db_get "cardsID" "$i.$DB_EXT" "Accounts" true))
        _cardsIDs=$(echo "$_cardsIDs" | tr "\n" " ")
        for j in ${_cardsIDs[@]}; do
            cardsIDs+=("$j")
        done
    done

    if [ "${#cardsIDs[@]}" == "0" ]; then
        echo "Brak kart płatniczych."
        echo ""
        return 0
    fi

    # loop through cardsIDs and print: <cardType>: <cardID> ~ <accountID>   <balance> <currency>
    for i in ${cardsIDs[@]}; do
        local accountID=$(db_get "accountID" "$i.$DB_EXT" "Cards")
        local accountBalance=$(db_get "balance" "$accountID.$DB_EXT" "Accounts")
        local accountCurrency=$(db_get "currency" "$accountID.$DB_EXT" "Accounts")
        local cardType=$(db_get "cardType" "$i.$DB_EXT" "Cards")
        accountBalance=$(echo "scale=2;$accountBalance/100" | bc)
        local protectedCardID=$(echo $i | sed "s/.\{7\}$/*******/")
        ui_alignRight "$cardType: $protectedCardID ~> $accountID" "$accountBalance $accountCurrency" "s" "s" && echo ""
    done
    echo ""
    return 0
}


__fin_showLoans() {
    db_loanMoney "POŻYCZKA" "$fin_title" "POŻYCZKI" "1.06" "Kasperski Bank" true false false false
    return $?
}