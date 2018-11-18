#!/bin/bash

ofrZus_show() {
    ui_header "$ofr_title" "ZUS"

    # get receivers
    if [ "$(db_receiversExists)" == "1" ]; then
        echo "Nie znaleziono odbiorcy: \"ZUS\"."
        echo ""
        return 1
    fi
    local receivers=$(db_getReceivers)


    # find one called ZUS
    local zusReceiverFilename
    for i in ${receivers[@]}; do
        local targetName=$(db_get "name" "$i" "Receivers/$USERNAME")
        if [ "$targetName" == "ZUS" ]; then
            zusReceiverFilename="$i"
            break
        fi
    done


    # if couldn't find, exit
    if [ -n "$zusReceiverID" ]; then
        echo "Nie znaleziono odbiorcy: \"ZUS\"."
        echo ""
        return 1
    fi


    # extract "Podstawa wymiaru składek" from the user
    local assessmentBasis
    read -p "Podstawa wymiaru składek [PLN]: " assessmentBasis
    assessmentBasis=$(echo "$assessmentBasis" | tr "," ".")
    while [[ ! $assessmentBasis =~ [0-9]* ]] && [[ ! $assessmentBasis =~ [0-9]*\.[0-9][0-9] ]]; do
        ui_header "$ofr_title" "ZUS"
        echo "Niepoprawne dane wejściowe."
        echo ""
        read -p "Podstawa wymiaru składek [PLN]: " assessmentBasis
    done

    # calculate transfer
    local sum="$(echo "scale=0;($assessmentBasis*100)/2.32" | bc)"

    
    # get transfer's details
    local targetAddress=$(db_get "address" "$zusReceiverFilename" "Receivers/$USERNAME")
    local targetAccountID=$(db_get "accountID" "$zusReceiverFilename" "Receivers/$USERNAME")
    local sourceAccountID="$(db_getUsersAccount)"
    local sourceAccountName="$(db_get "firstname" "$USERNAME.$DB_EXT" "Users") $(db_get "lastname" "$USERNAME.$DB_EXT" "Users")"
    local sourceAccountAddress="$(db_get "street" "$USERNAME.$DB_EXT" "Users") $(db_get "streetNumber" "$USERNAME.$DB_EXT" "Users"), $(db_get "city" "$USERNAME.$DB_EXT" "Users")"
    local title="Przelew do ZUS"

    # print info about transfer
    echo "Rachunek źródłowy: $sourceAccountID"
    echo "Rachunek odbiorcy: $targetAccountID"
    echo "Nazwa odbiorcy: $targetName"
    echo "Adres odbiorcy: $targetAddress"
    echo "Tytuł: $title"
    echo "Kwota: $(echo "scale=2;$sum/100" | bc) PLN"

    # confirm
    echo ""
    echo "1 - Potwierdź"
    echo "0 - Anuluj"
    echo ""
    ui_line
    read -p "Wybierz akcję: " action
    if [ "$action" != "1" ]; then
        home_skipPause=true
        return 1
    fi

    # make transfer
    local transactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" "$sourceAccountID" "$targetAccountID" "$targetName" "$targetAddress" "$title" "$sum" "$sum" "PLN" false false)


    # feedback
    ui_header "$ofr_title" "ZUS" 
    echo "Operacja zakończyła się powodzeniem."

    echo ""
    return 0
}