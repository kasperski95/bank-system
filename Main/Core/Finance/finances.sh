#!/bin/bash


__fin_sumarize() {
    ui_printHeader "$fin_title > PODSUMOWANIE"
    return 0
}


__fin_showSubaccount() {
    ui_printHeader "$fin_title > SUBKONTO"
    return 0
}


__fin_showSavingAccounts() {
    ui_printHeader "$fin_title > KONTA OSZCZĘDNOŚCIOWE"
    return 0
}


__fin_showCreditCards() {
    ui_printHeader "$fin_title > KARTY KREDYTOWE"
    return 0
}


__fin_showLoans() {
    ui_printHeader "$fin_title > POŻYCZKI"
    return 0
}