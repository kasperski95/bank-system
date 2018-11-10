#!/bin/bash



__servRec_showList() {
    ui_printHeader "$servRec_title -> LISTA"
    return 0
}


# add personal data & account number
__servRec_add() {
    ui_printHeader "$servRec_title -> DODAJ"
    return 0
}


__servRec_delete() {
    ui_printHeader "$servRec_title -> USUŃ"
    return 0
}