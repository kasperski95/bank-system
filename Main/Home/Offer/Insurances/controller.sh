#!/bin/bash

ofrIns_dbName="Insurances"

ofrIns_show () {
    ui_form "$ofr_title" "UBEZPIECZENIA"\
        2 "Wykupione" "Nowe"\
        2 ofrIns_handleList ofrIns_handleNew
}

ofrIns_handleList() {
    local insuranceTransactionID=$(utl_parseToArray $(db_get "insurancesID" "$USERNAME.$DB_EXT" "Users" true))

    ui_header "UBEZPIECZENIA" "WYKUPIONE"

    if [ "${insuranceTransactionID[@]}" == "" ]; then
        echo "Brak ubezpieczeń."
        echo ""
        return 0
    fi

    for i in ${insuranceTransactionID[@]}; do
        local insuranceID=$(db_get "insuranceID" "$i.$DB_EXT" "$ofrIns_dbName/Transactions")
        local insuranceName=$(db_get "name" "$insuranceID.$DB_EXT" "$ofrIns_dbName/Info") 
        ui_alignRight "$insuranceName" "$(db_get "endDate" "$i.$DB_EXT" "$ofrIns_dbName/Transactions")" "s" "s"
        echo ""
    done
    echo ""

    return 0
}





ofrIns_handleNew() {
    local insuranceFiles=$(db_getFiles "$ofrIns_dbName/Info")

    # store names
    local insuranceNames
    for i in ${insuranceFiles[@]}; do
        insuranceNames+=("$(db_get "name" "$i" "$ofrIns_dbName/Info")")
    done

    # pass names
    ui_form "$ofr_title" "NOWE UBEZPIECZENIE"\
        ${#insuranceNames[@]} "${insuranceNames[@]}"\
        1 ofrIns_handleInssuranceChoice ${#insuranceFiles[@]} "${insuranceFiles[@]}"


    return 0
}


ofrIns_handleInssuranceChoice() {
    local index=$(($1+2))
    local insuranceID=$(echo ${!index} | sed s/\.$DB_EXT// )
    local insuranceName=$(db_get "name" "${!index}" "$ofrIns_dbName/Info")
    local insuranceCost=$(db_get "cost" "${!index}" "$ofrIns_dbName/Info")
    local insuranceCostToPrint=$(echo "scale=2;$insuranceCost/100" | bc)
    local endDate=`date '+%d.%m.%y' -d "$(date)+1 year"`


    # show info
    ui_header "UBEZPIECZENIA" "POTWIERDZENIE"
    
    echo "Nazwa: $insuranceName"
    echo "Cena: $insuranceCostToPrint PLN"
    echo ""
    echo "1 - Potwierdź"
    echo "0 - Anuluj"
    echo ""
    ui_line
    read -p "Wybierz akcję: " action

    if [ "$action" == "1" ]; then
        local transactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" "$(db_getUsersAccount)" "000" "PZU" "Warszawa" "$insuranceName" $insuranceCost $insuranceCost "PLN")   

        # echo properties: username, inssuranceID, transactionDate, transactionCost
        local file="$(echo $DB/$ofrIns_dbName/Transactions/$(utl_getNextIndex $DB/$ofrIns_dbName/Transactions "3").$DB_EXT)"
        touch $file
        echo -e "{" > $file
        echo -e "\t\"insuranceID\": \"$insuranceID\"," >> $file
        echo -e "\t\"endDate\": \"$endDate\"" >> $file
        echo -e "}" >> $file

        # push info to user
        db_add "insurancesID" "$insuranceID" "$USERNAME.$DB_EXT" "Users"

        # feedback
        ui_header "UBEZPIECZENIA" "POTWIERDZENIE"
        echo "Operacja zakończyła się powodzeniem."
        echo ""
        return 0
    fi

    home_skipPause=true
    return 1
}
