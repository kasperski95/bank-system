#!/bin/bash


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


    read -p "---------DB----------" x
    read -p "date: $date" x
    read -p "time: $time" x
    read -p "type: $type" x
    read -p "sourceAccountID: $sourceAccountID" x
    read -p "sourceName: $sourceName" x
    read -p "targetAccountID: $targetAccountID" x
    read -p "title: $title" x
    read -p "sum: $sum" x
    read -p "sumCurrency: $sumCurrency" x
    read -p "receivedSum: $receivedSum" x
    read -p "receivedSumCurrency: $receivedSumCurrency" x
    read -p "---------------------" x

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