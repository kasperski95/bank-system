#!/bin/bash



serv_showInstallements() {
    ui_header "$serv_title" "RATY"

    return 0
}


serv_showTopUpPhone() {
    ui_form "$serv_title" "DOŁADOWANIE TELEFONU"\
        1 "Potwierdź"\
        0\
        _serv_handleTopUpPhone
        

    if [ "$?" == "0" ]; then
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


_serv_handleTopUpPhone() {
    #TODO: validation
    read -p "Numer telefonu: " phoneNumber
    read -p "Kwota doładowania: " sum
    echo ""
}


_serv_topUpPhone() {
    local transactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" "$(db_getUsersAccount)" "000" "Play" "Warszawa" "Doładowanie telefonu: $1" $2 $2 "PLN")   

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