#!/bin/bash
db_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$db_dir" ]]; then db_dir="$PWD"; fi

. $db_dir/accounts.sh
. $db_dir/misc.sh
. $db_dir/users.sh


dbTransactions_get() {
    if [ -z ${3+x} ]; then
        utl_getFromJson "$1" "$DB/Transactions/$2.$DB_EXT"
    else
        # array
        utl_getRawArrayFromJson "$1" "$DB/Transactions/$2.$DB_EXT"
    fi
    return 0
}


db_createTransaction() {
    local date="$1"
    local time="$2"
    local type="$3"
    local sourceAccountID="$4"
    local sourceName="$5"
    local targetAccountID="$6"
    local targetName="$7"
    local title="$8"
    local sum="$9"
    local sumCurrency="${10}"
    local receivedSum="${11}"
    local receivedSumCurrency="${12}"
    local transactionSum="${13}"
    local transactionCurrency="${14}"


    # read -p "---------DB----------" x
    # read -p "date: $date" x
    # read -p "time: $time" x
    # read -p "type: $type" x
    # read -p "sourceAccountID: $sourceAccountID" x
    # read -p "sourceName: $sourceName" x
    # read -p "targetAccountID: $targetAccountID" x
    # read -p "title: $title" x
    # read -p "sum: $sum" x
    # read -p "sumCurrency: $sumCurrency" x
    # read -p "receivedSum: $receivedSum" x
    # read -p "receivedSumCurrency: $receivedSumCurrency" x
    # read -p "---------------------" x

    # create file
    local transactionID=$(ls $DB/Transactions/ | tail --lines=1 | grep -Po ".*(?=\.)")
    if [ "$transactionID" == "" ]; then
        transactionID="-1"
    fi

    # remove 0 from the beginning because of octal bullshit
    transactionID=$(echo $transactionID | sed 's/^0*//') 



    ((transactionID++))
    transactionID=$(printf "%06d\n" $transactionID)

    transactionFile="$DB/Transactions/$transactionID.$DB_EXT"
    touch $transactionFile

    # print stuff to files
    echo "{"  > $transactionFile
    echo "  \"date\": \"$date\"," >> $transactionFile
    echo "  \"time\": \"$time\"," >> $transactionFile
    echo "  \"type\": \"$type\"," >> $transactionFile
    echo "  \"title\": \"$title\"," >> $transactionFile
    echo "  \"sum\": \"$sum\"," >> $transactionFile
    echo "  \"sumCurrency\": \"$sumCurrency\"," >> $transactionFile
    echo "  \"transactionSum\": \"$transactionSum\"," >> $transactionFile
    echo "  \"transactionCurrency\": \"$transactionCurrency\"," >> $transactionFile
    echo "  \"receivedSum\": \"$receivedSum\"," >> $transactionFile
    echo "  \"receivedSumCurrency\": \"$receivedSumCurrency\"," >> $transactionFile
    echo "  \"sourceAccountID\": \"$sourceAccountID\"," >> $transactionFile
    echo "  \"sourceName\": \"$sourceName\"," >> $transactionFile
    echo "  \"targetAccountID\": \"$targetAccountID\"," >> $transactionFile
    echo "  \"targetName\": \"$targetName\"" >> $transactionFile
    echo "}" >> $transactionFile
   
    # print transactionID
    echo "$transactionID"
    return 0
}


db_makeTransfer() {
    #ui_header "$tnst_title" "$1"
    local type="$1"
    local sourceAccountID="$2"
    local targetAccountID="$3"
    local name="$4"
    local address="$5"
    local title="$6"
    local sum="$7"
    local transactionSum="$8"
    local transactionCurrency="$9"

    # validate
    if [ "$sum" -lt "0" ]; then
        return 1
    fi

    # calculate source account balance
    local sourceAccountBalance=$(db_getAccountRawBalance $sourceAccountID)
    local newSourceAccountBalance=$(($sourceAccountBalance-$sum))

    
    # validate
    if [ "$sum" -gt "$sourceAccountBalance" ]; then
        return 1
    fi

    # exchangeSum
    local sourceAccountCurrency=$(db_getAccountCurrency $sourceAccountID)
    local sourceExchangeRate=$(db_getExchangeRate $sourceAccountCurrency) 
    local targetAccountCurrency=$(db_getAccountCurrency $targetAccountID)
    local targetExchangeRate=$(db_getExchangeRate $targetAccountCurrency)
    local receivedSum=$(echo "scale=4;$sum/($targetExchangeRate/$sourceExchangeRate)" | bc)
    receivedSum=$(echo "scale=0;($receivedSum+0.4999)/1" | bc)

    # calculate target account balance
    local targetAccountBalance=$(db_getAccountRawBalance $targetAccountID)
    local newTargetAccountBalance=$(($targetAccountBalance+$receivedSum))

    # update db
    dbAccounts_set "balance" $newSourceAccountBalance $sourceAccountID
    dbAccounts_set "balance" $newTargetAccountBalance $targetAccountID

    # create transaction
    userInfo=$(echo "$(dbUsers_get "firstname") $(dbUsers_get "lastname")")
    local transactionID=$(db_createTransaction "$(echo $(utl_getDate))" "$(echo $(utl_getTime))" "$type" $sourceAccountID "$userInfo" $targetAccountID "$name" "$title" $sum $sourceAccountCurrency $receivedSum $targetAccountCurrency "$transactionSum" "$transactionCurrency")

    # push transactionID to both accounts
    db_addTransactionToAccount $transactionID $sourceAccountID
    db_addTransactionToAccount $transactionID $targetAccountID


    echo "$transactionID"
    return 0
}