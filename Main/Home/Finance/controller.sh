#!/bin/bash


__fin_sumarize() {
    ui_header $fin_title "WSZYSTKIE_RACHUNKI_BANKOWE"
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
    ui_header $fin_title "RACHUNKI_ROZLICZENIOWE"

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
    ui_header $fin_title "RACHUNKI_OSZCZĘDNOŚCIOWE"

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
    ui_header $fin_title "KARTY_KREDYTOWE"
    return 0
}


__fin_showLoans() {
    ui_header $fin_title "POŻYCZKI"
    return 0
}