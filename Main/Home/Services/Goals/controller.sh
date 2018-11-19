#!/bin/bash



servGls_showList() {
    # get goalsID from user
    local goalsID=$(utl_parseToArray $(db_get "virtualAccountsID" "$USERNAME.$DB_EXT" "Users" true))

    if [ "${goalsID[@]}" == "" ]; then
        echo "Brak celów oszędnościowych."
        echo ""
        return 0
    fi

    local standingOrdersID=$(utl_parseToArray $(db_get "standingOrdersID" "$USERNAME.$DB_EXT" "Users" true))

    # print: name ... sum / target PLN
    for i in ${goalsID[@]}; do
        local name="$(db_get "name" "$i.$DB_EXT" "VirtualAccounts")"
        local balance="$(db_get "balance" "$i.$DB_EXT" "VirtualAccounts")"
        local targetSum="$(db_get "targetSum" "$i.$DB_EXT" "VirtualAccounts")"
        local currency="$(db_get "currency" "$i.$DB_EXT" "VirtualAccounts")"
        local estTime=""
        
        # estimate time
        for j in ${standingOrdersID[@]}; do
            local virtual=$(db_get "virtual" "$j.$DB_EXT" "StandingOrders")
            if $virtual; then
                local targetAccountID=$(db_get "targetAccountID" "$j.$DB_EXT" "StandingOrders")
                if [ "$targetAccountID" == "$i" ]; then
                    local interval=$(db_get "interval" "$j.$DB_EXT" "StandingOrders")
                    local intervalSum=$(db_get "sum" "$j.$DB_EXT" "StandingOrders")
                    estTime=$(echo "scale=0;($targetSum-$balance)/$intervalSum" | bc)
                    estTime=$(echo "scale=0; $estTime*$interval " | bc)
                    estTime=" (za ~$estTime mc)"
                fi
            fi
        done

        balance=$(echo "scale=2;$balance/100" | bc)
        targetSum=$(echo "scale=2;$targetSum/100" | bc)
        ui_alignRight "$name$estTime" "$balance / $targetSum $currency" "s" "s" && echo ""
    done
    echo ""

    return 0
}


__servGls_add() {
    local name
    local targetSum

    ui_header "$servGls_title" "DODAJ"
    # extract data from user:
    # - name
    read -p "Cel: " name
    while [ "$name" == "" ]; do
        ui_header "$servGls_title" "DODAJ"
        echo "Cel nie może być pusty."
        echo ""
        read -p "Cel: " name
    done

    # - target
    read -p "Docelowa kwota [PLN]: " targetSum
    while [[ ! "$targetSum" =~ ^[0-9]*$ ]] && [[ ! "$targetSum" =~ ^[0-9]*(\.|,)[0-9]{2}$ ]]; do
        ui_header "$servGls_title" "DODAJ"
        echo "Niepoprawna kwota."
        echo ""
        echo "Cel: $name"
        read -p "Docelowa kwota [PLN]: " targetSum
    done

    targetSum=$(utl_convertMoney $targetSum)

    # create receivers as hidden
    local usersAddress="$(db_get "street" "$USERNAME.$DB_EXT" "Users") $(db_get "streetNumber" "$USERNAME.$DB_EXT" "Users"), $(db_get "city" "$USERNAME.$DB_EXT" "Users")"
    local receiverID="$(db_createReceiver "$name" "$usersAddress" "" true)"


    # create virtual account
    local fileDir="$DB/VirtualAccounts"
    local fileID=$(utl_getNextIndex "$fileDir" "3")
    local file="$(echo $fileDir/$fileID.$DB_EXT)"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"name\": \"$name\"," >> $file
    echo -e "\t\"targetSum\": \"$targetSum\"," >> $file
    echo -e "\t\"balance\": \"0\"," >> $file
    echo -e "\t\"transactionsID\": []," >> $file
    echo -e "\t\"currency\": \"PLN\"," >> $file
    echo -e "\t\"receiverID\": \"$receiverID\"" >> $file
    echo -e "}" >> $file

    # add to user
    db_add "virtualAccountsID" "$fileID" "$USERNAME.$DB_EXT" "Users"


    # update receiver's accountID
    db_set "accountID" "$fileID" "$receiverID.$DB_EXT" "Receivers/$USERNAME"


    # feedback
    ui_header "$servGls_title" "DODAJ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""

    return 0
}


__servGls_delete() {
    ui_header "$servGls_title" "USUŃ"

    # get virtual accounts from user & print
    local _virtualAccountsID=$(utl_parseToArray $(db_get "virtualAccountsID" "$USERNAME.$DB_EXT" "Users" true))
    
    if [ "${_virtualAccountsID[@]}" == "" ]; then
        echo "Brak celów oszędnościowych."
        echo ""
        return 0
    fi
    
    local virtualAccountsID=()
    local virtualAccountIndex=1
    for i in ${_virtualAccountsID[@]}; do
        local name=$(db_get "name" "$i.$DB_EXT" "VirtualAccounts")
        virtualAccountsID+=("$i")
        echo "$virtualAccountIndex - $name"
        ((virtualAccountIndex++))
    done
    echo ""
    ui_line

    # handle input
    read -p "Wybierz cel: " virtualAccountIndex

    ((virtualAccountIndex--))
    
    
    # makeTransfer
    local sum=$(db_get "balance" "${virtualAccountsID[$virtualAccountIndex]}.$DB_EXT" "VirtualAccounts")
    local transactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" ${virtualAccountsID[$virtualAccountIndex]} $(db_getUsersAccount) "$USERNAME" "nie dotyczy" "Usunięcie celu oszczędnościowego" $sum $sum "PLN" false true)

    # rm receiver
    local receiverID=$(db_get "receiverID" "${virtualAccountsID[$virtualAccountIndex]}.$DB_EXT" "VirtualAccounts")
    rm "$DB/Receivers/$USERNAME/$receiverID.$DB_EXT"

    # rm virtual account
    rm "$DB/VirtualAccounts/${virtualAccountsID[$virtualAccountIndex]}.$DB_EXT"

    # subtract from user's file
    db_subtract "virtualAccountsID" "${virtualAccountsID[$virtualAccountIndex]}" "$USERNAME.$DB_EXT" "Users"

    ui_header "$servGls_title" "USUŃ"
    echo "Operacja zakończyła się powodzeniem."
    echo "Środki zostały zwrócone na główny rachunek bankowy."
    echo ""

    return 0
}