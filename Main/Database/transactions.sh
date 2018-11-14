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
    local sourceAccountID="$3"
    local sourceName="$4"
    local targetAccountID="$5"
    local targetName="$6"
    local title="$7"
    local sum="$8"
    local sumCurrency="$9"
    local receivedSum="${10}"
    local receivedSumCurrency="${11}"

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