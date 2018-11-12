#!/bin/bash


db_createTransaction() {
    local date="$1"
    local sourceAccountID="$2"
    local sourceName="$3"
    local targetAccountID="$4"
    local targetName="$5"
    local title="$6"
    local amount="$7"

    # create file
    local transactionID=$(ls $DB/Transactions/ | tail --lines=1 | grep -Po ".*(?=\.)")
    if [ "$transactionID" == "" ]; then
        transactionID="0"
    fi
    ((transactionID++))
    transactionFile="$DB/Transactions/$transactionID.$DB_EXT"
    touch $transactionFile

    # print stuff to files
    echo "{"  > $transactionFile
    echo "  \"date\": \"$date\"," >> $transactionFile
    echo "  \"title\": \"$title\"," >> $transactionFile
    echo "  \"amount\": \"$amount\"," >> $transactionFile
    echo "  \"sourceAccountID\": \"$sourceAccountID\"," >> $transactionFile
    echo "  \"sourceName\": \"$sourceName\"," >> $transactionFile
    echo "  \"targetAccountID\": \"$targetAccountID\"," >> $transactionFile
    echo "  \"targetName\": \"$targetName\"" >> $transactionFile
    echo "}" >> $transactionFile
   
    # print transactionID
    echo "$transactionID"
    return 0
}