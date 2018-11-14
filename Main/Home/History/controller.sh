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
        local receivedSum=$(dbTransactions_get "receivedSum" $i)
        local sumCurrency=$(dbTransactions_get "sumCurrency" $i)
        local receivedSumCurrency=$(dbTransactions_get "receivedSumCurrency" $i)
        sum=$(echo "scale=2;$sum/100" | bc | sed "s/^\./0\./")
        receivedSum=$(echo "scale=2;$receivedSum/100" | bc | sed "s/^\./0\./")


        if [ "$(db_isUsersAccount $targetAccountID)" == "true" ]; then
            printf $GREEN;
            __hist_printHistoryEntry $transactionDate $transactionTime $sourceAccountID $targetAccountID $receivedSum $receivedSumCurrency
        fi

        if [ "$(db_isUsersAccount $sourceAccountID)" == "true" ]; then
            printf $RED;
            __hist_printHistoryEntry $transactionDate $transactionTime $sourceAccountID $targetAccountID "-$sum" $sumCurrency
        fi


        printf $DEFAULT_COLOR;
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
            local sum=$(dbTransactions_get "sum" $i)
            local sumCurrency=$(dbTransactions_get "sumCurrency" $i)
            local receivedSum=$(dbTransactions_get "receivedSum" $i)
            local receivedSumCurrency=$(dbTransactions_get "receivedSumCurrency" $i)
            local title=$(dbTransactions_get "title" $i)

            sum=$(echo "scale=2;$sum/100" | bc | sed "s/^\./0\./")
            receivedSum=$(echo "scale=2;$receivedSum/100" | bc | sed "s/^\./0\./")

            local outputFile="$outputPath/${transactionDate}_${i}.txt"
            touch $outputFile
            echo "Tytuł przelewu: $title" > $outputFile
            echo "Data: $transactionDate" >> $outputFile
            echo "Czas: $transactionTime" >> $outputFile
            echo "Rachunek nadawcy: $sourceAccountID" >> $outputFile
            echo "Rachunek odbiorcy: $targetAccountID" >> $outputFile
            echo "Kwota przelewu: $sum $sumCurrency" >> $outputFile
            echo "Otrzymana kwota: $receivedSum $receivedSumCurrency" >> $outputFile
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


__hist_printHistoryEntry() {
    local transactionDate="$1"
    local transactionTime="$2"
    local sourceAccountID="$3"
    local targetAccountID="$4"
    local sum="$5"
    local currency="$6"

    local left="${transactionDate} ${transactionTime} | ${sourceAccountID} -> ${targetAccountID}"
    local right="${sum} ${currency}"
    ui_alignRight "$left" "$right" "s" "s"

    echo ""

    return 0
}