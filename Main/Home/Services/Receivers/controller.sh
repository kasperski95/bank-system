#!/bin/bash

# add personal data & account number
__servRec_add() {
    local name
    local address
    local accountID

    ui_header "$servRec_title" "DODAJ"

    read -p "Nazwa: " name
    read -p "Adres: " address
    read -p "Numer konta: " accountID

    while (! db_doesAccountExists $accountID); do
        ui_header "$servRec_title" "DODAJ"
        echo "Podane konto nie istnieje."
        echo ""
        echo "Nazwa: $name"
        echo "Adres: $address"

        read -p "Numer konta: " accountID
    done;

    db_createReceiver $name $address $accountID

    echo ""
    return 0
}


__servRec_delete() {
    ui_header "$servRec_title" "USUŃ"

    local receiversFilesRaw=$(db_getReceivers)
    local receiversFiles=()
    local j=1
    for i in ${receiversFilesRaw[@]}; do
        local bHidden=$(utl_getFromJson "hidden" "$(dbReceivers_getPath)/$i")
        if ! $bHidden; then
            echo "$j - $(utl_getFromJson "name" "$(dbReceivers_getPath)/$i")"
            ((j++))
            receiversFiles+=("$i")
        fi
    done
    echo ""
    ui_line
    local receiverIndex
    read -p "Wybierz odbiorcę: " receiverIndex
    ((receiverIndex--))

    rm "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}"

    ui_header "$servRec_title" "USUŃ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""

    return 0
}