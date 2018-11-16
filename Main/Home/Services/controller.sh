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