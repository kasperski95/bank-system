#!/bin/bash
hist_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$hist_dir" ]]; then hist_dir="$PWD"; fi

. $hist_dir/../../Database/users.sh

hist_printList() {    
    local transactions=$(__hist_getUsersTransactions)

    for i in ${transactions[@]}; do
        local transactionDate=$(dbTransactions_get "date" $i)
        local transactionTime=$(dbTransactions_get "time" $i)
        local sourceAccountID=$(dbTransactions_get "sourceAccountID" $i)
        local targetAccountID=$(dbTransactions_get "targetAccountID" $i)
        local sum=$(dbTransactions_get "sum" $i)
        sum=$(echo "scale=2;$sum/100" | bc)
        local sign=""

        local doesSourceBelongsToUser=$(db_isUsersAccount $sourceAccountID)
        local doesTargetBelongsToUser=$(db_isUsersAccount $targetAccountID)
        if [ "$doesSourceBelongsToUser" == "true" ] && [ "$doesTargetBelongsToUser" == "true" ]; then
            printf $DEFAULT_COLOR;
        elif [ "$doesSourceBelongsToUser" == "true" ]; then
            printf $RED;
            sign="-"
        elif [ "$doesTargetBelongsToUser" == "true" ]; then
            printf $GREEN;
        fi

        local left="${transactionDate} ${transactionTime} | ${sourceAccountID} -> ${targetAccountID}"
        local right="${sign}${sum} PLN"
        ui_alignRight "$left" "$right" "s" "s"

        printf $DEFAULT_COLOR;
        echo ""
    done

    return 0
}


# Generate files date_transactionID.txt on ~/Pulpit/Konto
hist_export() {
    ui_header $hist_title "EKSPORT"
    
    local desktopPath=$(eval echo "~/Pulpit")
    if [ -d "$desktopPath" ]; then
        local outputPath="$desktopPath/Konto"
        local transactions=$(__hist_getUsersTransactions)

        if [ ! -d "$outputPath" ]; then
            mkdir $outputPath
        fi

        # print all
        for i in $transactions; do
            local transactionDate=$(dbTransactions_get "date" $i)
            local transactionTime=$(dbTransactions_get "time" $i)
            local sourceAccountID=$(dbTransactions_get "sourceAccountID" $i)
            local targetAccountID=$(dbTransactions_get "targetAccountID" $i)
            local targetAccountID=$(dbTransactions_get "targetAccountID" $i)
            local sum=$(dbTransactions_get "sum" $i)


            sum=$(echo "scale=2;$sum/100" | bc)

            local outputFile="$outputPath/${transactionDate}_${i}.txt"
            touch $outputFile
            echo "Data: $transactionDate" > $outputFile
            echo "Czas: $transactionTime" >> $outputFile
            echo "Rachunek nadawcy: $sourceAccountID" >> $outputFile
            echo "Rachunek odbiorcy: $targetAccountID" >> $outputFile
            echo "Kwota przelewu: $sum PLN" >> $outputFile
        done;

        echo "Eksport zakończył się powodzeniem."

    else
        echo "Niepowodzenie."
        echo "Ścieżka: \"~/Pulpit\" nie istnieje."
    fi
    echo ""

    return 0
}


__hist_getUsersTransactions() {
    # get users accounts
    local -a accounts=$(echo $(db_getUserAccounts))

    # aggregate transactions from all users accounts
    local transactions
    for i in ${accounts[@]}; do
        transactions+=($(db_getAccountTransactions $i))
    done

    # reverse sort transactions
    local sortedTransactions=$(utl_sortR ${transactions[@]} | tr "\n" " ")
    sortedTransactions=$(utl_removeDoubles $sortedTransactions)

    echo $sortedTransactions

    return 0
}