#!/bin/bash


__tnst_makeTransfer() {
    ui_header $tnst_title "PRZELEW_ZWYKŁY"
    return 0
}

__tnst_makeExpressTransfer() {
    ui_header $tnst_title "PRZELEW_EKSPRESS"
    return 0
}

__tnst_makeMonetaryTransfer() {
    ui_header $tnst_title "PRZELEW_WALUTOWY"
    return 0
}