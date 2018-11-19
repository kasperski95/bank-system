#!/bin/bash



serv_showInstallements() {
    ui_header "$serv_title" "RATY"

    # get installmentsID from user
    local installmentsID=$(utl_parseToArray $(db_get "installmentsID" "$USERNAME.$DB_EXT" "Users" true))

    if [ "${installmentsID[@]}" == "" ]; then
        echo "Brak rat."
        echo ""
        return 0
    fi

    # print
    for i in ${installmentsID[@]}; do
        local name=$(db_get "name" "$i.$DB_EXT" "Installments")
        local location=$(db_get "location" "$i.$DB_EXT" "Installments")
        local date=$(db_get "date" "$i.$DB_EXT" "Installments")
        local installment=$(db_get "installment" "$i.$DB_EXT" "Installments")
        local period=$(db_get "period" "$i.$DB_EXT" "Installments")
        local totalSum=$(db_get "totalSum" "$i.$DB_EXT" "Installments")
        local currency=$(db_get "currency" "$i.$DB_EXT" "Installments")

        ui_alignRight "$name" "$location, $date" "s" "s" && echo ""
        ui_alignRight "$(utl_printMoney $totalSum) $currency" "$(utl_printMoney $installment) $currency co $period miesiąc" "s" "s" -1
        echo ""
        echo ""
    done

    echo ""
    return 0
}


serv_showTopUpPhone() {
    ui_header "$serv_title" "DOŁADOWANIE TELEFONU"

    local phoneNumber
    read -p "Numer telefonu: " phoneNumber
    while [[ ! "$phoneNumber" =~ ^[0-9]{9}$ ]]; do
        ui_header "$serv_title" "DOŁADOWANIE TELEFONU"
        echo "Niepoprawny numer telefonu."
        echo ""
        read -p "Numer telefonu: " phoneNumber
    done

    local sum
    read -p "Kwota doładowania [PLN]: " sum
    sum=$(echo "$sum" | tr "," ".")
    while [[ ! "$sum" =~ [0-9]* ]] && [[ ! "$sum" =~ ^[0-9]*\.[0-9]{2}$ ]]; do
        echo "Niepoprawna kwota."
        echo ""
        read -p "Kwota doładowania [PLN]: " sum
        sum=$(echo "$sum" | tr "," ".")
    done
    echo ""
    echo "1 - Potwierdź"
    echo "0 - Anuluj"
    echo ""
    ui_line

    local action
    read -p "Wybierz akcję: " action
    
    if [ "$action" == "1" ]; then
        sum=$(echo "$sum*100" | bc)
        sum=$(echo "scale=0;$sum/1" | bc )
        _serv_topUpPhone $phoneNumber $sum
        return 0
    fi

    home_skipPause=true
    return 1
}


serv_showPlannedPayments() {
    ui_header "$serv_title" "ZAPLANOWANE_PŁATNOŚCI"
    
    # get all standingOrders
    local standingOrdersID=$(utl_parseToArray $(db_get "standingOrdersID" "$USERNAME.$DB_EXT" "Users" true))

    for j in ${standingOrdersID[@]}; do
        local initialDate="$(db_get "initialDate" "$j.$DB_EXT" "StandingOrders")"
        local interval="$(db_get "interval" "$j.$DB_EXT" "StandingOrders")"
        local name="$(db_get "name" "$j.$DB_EXT" "StandingOrders")"
        local sum="$(db_get "sum" "$j.$DB_EXT" "StandingOrders")"
        local currency="$(db_get "currency" "$j.$DB_EXT" "StandingOrders")"
        
        # calculate closest date in future
        local dateInFuture="$(_serv_findClosestDateInFuture "$initialDate" "$interval")"

        # print
        sum=$(echo "scale=2;$sum/100" | bc)
        ui_alignRight "$name ($sum $currency)" "$dateInFuture" "s" "s" && echo ""
    done
    echo ""

    return 0
}


_serv_findClosestDateInFuture() {
    local initialDate="$1"
    local interval="$2"

    local result="$initialDate"
    local offset="0"
    local i="1"
    while [[ "$result" < "$(utl_getDate)" ]]; do
        offset=$(echo "$interval*$i" | bc)
        result=$(date '+%Y-%m-%d' -d "$initialDate + $offset months")
        ((i++))
    done
    echo "$result"
    return 0
}



_serv_topUpPhone() {
    local transactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" "$(db_getUsersAccount)" "000" "Play" "Warszawa" "Doładowanie telefonu: $1" $2 $2 "PLN" false false)   

    ui_header "$serv_title" "DOŁADOWANIE TELEFONU"
    if [ "$?" == "0" ]; then
        echo "Operacja zakończyła się powodzeniem."
        echo ""
        return 0
    else
        echo "Operacja nie powiodła się."
    fi
    echo ""
    return 1
}