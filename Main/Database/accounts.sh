#!/bin/bash


dbAccounts_get() {
    utl_getFromJson "$1" "$DB/Accounts/$2.$DB_EXT"
    return 0
}


db_createAccount() {
    local accountType=$1
    local currency=$2
    newAccountID=$(ls $DB/Accounts/ | tail --lines=1 | grep -Po ".*(?=\.)")

    # remove 0 from the beginning because of octal bullshit
    newAccountID=$(echo $newAccountID | sed 's/^0*//') 

    ((newAccountID++))
    newAccountID=$(printf "%03d\n" $newAccountID)

    newAccountFile="$DB/Accounts/$newAccountID.$DB_EXT"
    touch newAccountFile

echo -e "{
    \"money\": \"0\",
    \"type\": \"$accountType\",
    \"currency\": \"$currency\"
}" > $newAccountFile

    echo $newAccountID
    return 0
}
