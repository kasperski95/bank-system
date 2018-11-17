#!/bin/bash



servSo_showList() {
    # get standingOrdersID
    local standingOrdersID=$(utl_parseToArray $(db_get "standingOrdersID" "$USERNAME.$DB_EXT" "Users" true))

    # print

    if [ "${standingOrdersID[@]}" == "" ]; then
        echo "Brak stałych zleceń."
        return 0
    fi

    for i in ${standingOrdersID[@]}; do
        local sourceAccountID=$(db_get "sourceAccountID" "$i.$DB_EXT" "StandingOrders")
        local targetAccountID=$(db_get "targetAccountID" "$i.$DB_EXT" "StandingOrders")
        local name=$(db_get "name" "$i.$DB_EXT" "StandingOrders")
        local sum=$(db_get "sum" "$i.$DB_EXT" "StandingOrders")
        local initialDate=$(db_get "initialDate" "$i.$DB_EXT" "StandingOrders")
        local interval=$(db_get "interval" "$i.$DB_EXT" "StandingOrders")
        local title=$(db_get "title" "$i.$DB_EXT" "StandingOrders")
        sum=$(echo "scale=2;$sum/100" | bc)
        ui_alignRight "$name" "od $initialDate co $interval miesiąc(e)" "s" "s" && echo ""
        ui_alignRight "" "$sourceAccountID -> $targetAccountID | $title | $sum PLN" "s" "s" && echo ""
        echo ""
    done

    return 0
}


__servSo_add() {
    local servSoAdd_title="DODAJ STAŁY PRZELEW"
    local sourceAccountID=""
    local targetAccountID="init"
    local name=""
    local address=""
    local title=""
    local currency=""
    local sum=""
    local transactionDate=""
    local interval=""
    local bVirtual=false
    local error=" "

    # extract information from the user
    while [ "$error" != "" ]; do

        # - account
        if [ "$sourceAccountID" == "" ]; then
            ui_header "$servSoAdd_title" "RACHUNEK ŹRÓDŁOWY"

            local _accounts=$(utl_parseToArray $(db_get "accountsID" "$USERNAME.$DB_EXT" "Users" true))
            local accounts=()
            local accountIndex=1;
            for i in ${_accounts[@]}; do
                if [ "$(db_getAccountsType $i)" == "checking" ]; then
                    echo "$accountIndex - $i"
                    accounts+=("$i")
                    ((accountIndex++))
                fi
            done
            echo "0 - Powrót"
            echo ""
            ui_line
            read -p "Wybierz konto: " accountIndex
            
            if [ "$accountIndex" == "0" ]; then
                home_skipPause=true
                return 1
            fi

            ((accountIndex--))
            sourceAccountID="${accounts[$accountIndex]}"
            error=" "   
        fi


        # - receiver
        if [ "$targetAccountID" == "init" ]; then
            ui_header "$servSoAdd_title" "ODBIORCA"

            local receiversFilesRaw=$(db_getReceivers)
            local receiversFiles=()
            local j=1
            for i in ${receiversFilesRaw[@]}; do
                echo "$j - $(utl_getFromJson "name" "$(dbReceivers_getPath)/$i")"
                receiversFiles+=("$i")
            done
            echo "0 - Pomiń"
            echo ""
            ui_line
            local receiverIndex
            read -p "Wybierz odbiorcę: " receiverIndex
            

            if [ "$receiverIndex" != "0" ]; then
                ((receiverIndex--))
                targetName=$(utl_getFromJson "name" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
                address=$(utl_getFromJson "address" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
                targetAccountID=$(utl_getFromJson "accountID" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
                bVirtual==$(utl_getFromJson "hidden" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
            else
                targetAccountID=""
            fi
        fi

        #---------------------------------------------------------------------------------------------

        ui_header "$servSoAdd_title" "FORMULARZ"
 

        if [ "$error" != " " ]; then
            echo $error
            error=""
            echo ""
        fi

        echo "Przelew z rachunku: $sourceAccountID"  


        # - targetAccountID
        if [ "$targetAccountID" == "" ]; then
            read -p "Rachunek odbiorcy: " targetAccountID
            if [ "$targetAccountID" == "" ]; then
                error="Rachunek odbiorcy nie może być pusty."
            elif (! db_doesAccountExists $targetAccountID); then
                targetAccountID=""
                error="Nie znaleziono podanego rachunku bankowego."
            elif [ "$sourceAccountID" == "$targetAccountID" ]; then
                targetAccountID=""
                error="Nie można dokonywać przelewu na te konto."
            else
                error=" "
            fi
            continue
        else
            echo "Rachunek odbiorcy: $targetAccountID"
        fi


        # - targetName
        if [ "$targetName" == "" ]; then
            read -p "Nazwa odbiorcy: " targetName
            if [ "$targetName" == "" ]; then
                error="Nazwa odbiorcy nie może być pusta."
            else
                error=" "
            fi
            continue
        else
            echo "Nazwa odbiorcy: $targetName"
        fi


        # - name 
        if [ "$name" == "" ]; then
            read -p "Nazwa stałego przelewu: " name
        else
            echo "Nazwa stałego przelewu: $name" 
        fi


        # title
        if [ "$title" == "" ]; then
            read -p "Tytuł przelewów: " title
            if [ "$title" == "" ]; then
                error="Tytuł przelewów nie może być pusty."
            else
                error=" "
            fi
            continue
        else
            echo "Tytuł przelewów: $title"
        fi


        # sum
        if [ "$sum" == "" ]; then
            read -p "Kwota przelewów [PLN]: " sum
            sum=$(echo $sum | tr "," ".")
            if [[ ! "$sum" =~ ^[0-9]+\.[0-9][0-9]$ ]]; then
                sum=""
                error="Kwota przelewów musi być w formacie: 0.00"
            else
                sum=$(echo "scale=0;($sum * 100)/1" | bc)
                if [ "$sum" == "" ]; then
                    error="Kwota przelewów nie może być pusta."
                elif [ "$sum" -lt 0 ]; then
                    sum=""
                    error="Kwota przelewów nie może być ujemna."
                else
                    error=" "
                fi
            fi
            continue
        else
            echo "Kwota przelewów [PLN]: $(echo "scale=2;$sum/100" | bc)"
        fi


        # data
        if [ "$transactionDate" == "" ]; then
            read -p "Data początkowa [yyyy-mm-dd]: " transactionDate
            if [[ ! "$transactionDate" =~ ^[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]$ ]]; then
                transactionDate=""
                error="Niepoprawny format daty."
            else
                error=" "
            fi
            continue
        else
            echo "Data początkowa [yyyy-mm-dd]: $transactionDate" 
        fi


        #interval
        if [ "$interval" == "" ]; then
            read -p "Odstęp w miesiącach między przelewami: " interval
            if [[ ! "$interval" =~ ^[0-9]*$ ]]; then
                interval=""
                error="Niepoprawny odstęp."
            else
                error=""
            fi
            continue
        else
            echo "Odstęp w miesiącach między przelewami: $interval" 
        fi

    done


    # create file
    local fileDir="$DB/StandingOrders"
    local fileID=$(utl_getNextIndex "$fileDir" "3")
    local file="$(echo $fileDir/$fileID.$DB_EXT)"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"sourceAccountID\": \"$sourceAccountID\"," >> $file
    echo -e "\t\"targetAccountID\": \"$targetAccountID\"," >> $file
    echo -e "\t\"targetName\": \"$targetName\"," >> $file
    echo -e "\t\"name\": \"$name\"," >> $file
    echo -e "\t\"title\": \"$title\"," >> $file
    echo -e "\t\"sum\": \"$sum\"," >> $file
    echo -e "\t\"initialDate\": \"$transactionDate\"," >> $file
    echo -e "\t\"interval\": \"$interval\"" >> $file
    echo -e "\t\"virtual\": \"$bVirtual\"" >> $file
    echo -e "}" >> $file

    # add to user
    db_add "standingOrdersID" "$fileID" "$USERNAME.$DB_EXT" "Users"

    # feedback
    ui_header "$servSoAdd_title" "FORMULARZ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""

    return 0
}


__servSo_delete() {
    ui_header "$servSo_title" "USUŃ"

    # get standingOrdersID
    local _standingOrdersID=$(utl_parseToArray $(db_get "standingOrdersID" "$USERNAME.$DB_EXT" "Users" true))

    # print
    if [ "${_standingOrdersID[@]}" == "" ]; then
        echo "Brak stałych zleceń do usunięcia."
        return 0
    fi

    local standingOrdersID=()
    local standingOrdersIndex="1"
    for i in ${_standingOrdersID[@]}; do
        standingOrdersID+=($i)
        local name=$(db_get "name" "$i.$DB_EXT" "StandingOrders")
        echo "$standingOrdersIndex - $name"
        ((standingOrdersIndex++))
    done
    echo ""
    ui_line

    # handle input
    read -p "Wybierz stałe zlecenie: " standingOrdersIndex
    ((standingOrdersIndex--))

    # delete file
    rm "$DB/StandingOrders/${standingOrdersID[$standingOrdersIndex]}.$DB_EXT"

    # delete from user
    db_subtract "standingOrdersID" "${standingOrdersID[$standingOrdersIndex]}" "$USERNAME.$DB_EXT" "Users" 

    return 0
}