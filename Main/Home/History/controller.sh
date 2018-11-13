#!/bin/bash
hist_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$hist_dir" ]]; then hist_dir="$PWD"; fi

. $hist_dir/../../Database/users.sh

hist_printList() {
    # (Data, numer konta, kwota, do kogo, możliwość generowania .txt do katalogu Konto na pulpicie wraz z nazwą pliku 
    
    # get users accounts
    local -a accounts=$(echo $(db_getUserAccounts))

    # aggregate transactions from all users accounts
    local transactions
    for i in ${accounts[@]}; do
        transactions+=($(db_getAccountTransactions $i))
    done

    # sort transactions
    local sortedTransactions=$(utl_sortR ${transactions[@]} | tr "\n" " ")
    sortedTransactions=$(utl_removeDoubles $sortedTransactions)

    # print list
    for i in ${sortedTransactions[@]}; do
        local transactionDate=$(dbTransactions_get "date" $i)
        local sourceAccountID=$(dbTransactions_get "sourceAccountID" $i)
        local targetAccountID=$(dbTransactions_get "targetAccountID" $i)
        local sum=$(dbTransactions_get "sum" $i)
        sum=$(echo "scale=2;$sum/100" | bc)

        local left="${transactionDate} | ${sourceAccountID}_->_${targetAccountID}"
        local right="${sum}_PLN"

        local doesSourceBelongsToUser=$(db_isUsersAccount $sourceAccountID)
        local doesTargetBelongsToUser=$(db_isUsersAccount $targetAccountID)
        if [ "$doesSourceBelongsToUser" == "true" ] && [ "$doesTargetBelongsToUser" == "true" ]; then
            printf $DEFAULT_COLOR;
        elif [ "$doesSourceBelongsToUser" == "true" ]; then
            printf $RED;
        elif [ "$doesTargetBelongsToUser" == "true" ]; then
            printf $GREEN;
        fi

        ui_alignRight "$left" "$right" "s" "s"
        printf $DEFAULT_COLOR;
        echo ""
    done

    return 0
}


# Generate files date_transactionID.txt
hist_export() {
    ui_header $hist_title "EKSPORT"
    
    return 0
}
