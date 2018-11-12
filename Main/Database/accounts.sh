#!/bin/bash
db_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$db_dir" ]]; then db_dir="$PWD"; fi

. $db_dir/misc.sh



dbAccounts_get() {
    utl_getFromJson "$1" "$DB/Accounts/$2.$DB_EXT"
    return 0
}


dbAccounts_set() {
    #FIXME: last property
    local key=$1
    local val=$2
    local accountID=$3

    firstValueCharacter="$(echo $val | head -c 1)"

    if [ "$firstValueCharacter" == "[" ]; then
        sed -i "s/\($key\":\).*$/\1 $val,/" "$DB/Accounts/$accountID.$DB_EXT"
    else
        sed -i "s/\($key\":\).*$/\1 \"$val\",/" "$DB/Accounts/$accountID.$DB_EXT"
    fi

    return $?
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
    touch $newAccountFile

echo -e "{
    \"balance\": \"0\",
    \"type\": \"$accountType\",
    \"transactionsID\": [],
    \"currency\": \"$currency\"
}" > $newAccountFile

    echo $newAccountID
    return 0
}


db_addTransactionToAccount() {
    local transactionID=$1
    local accountID=$2
    local transactions=$(utl_parseToArray $(utl_getRawArrayFromJson "transactionsID" $DB/Accounts/$accountID.$DB_EXT))
    
    transactions+=($transactionID)
    local transactionsJson=$(utl_parseArrayToJson ${transactions[@]})
    
    dbAccounts_set "transactionsID" "$transactionsJson" "$accountID" true

    return 0
}


db_doesAccountExists() {
    if [ -f "$DB/Accounts/$1.$DB_EXT" ]; then
        return 0
    else
        return 1
    fi
}


db_getAccountBalance() {
    local accountID=$1
    local balance=$(dbAccounts_get "balance" $accountID)
    echo "$balance/100" | bc
    return 0
}

db_getAccountRawBalance_PLN() {
    local accountID=$1
    local balance=$(dbAccounts_get "balance" $accountID)
    local currency=$(db_getAccountCurrency $accountID)
    local exchangeRate=$(db_getExchangeRate $currency)
    echo "$balance*$exchangeRate" | bc
    return 0
}


db_getAccountBalance_PLN() {
    local accountID=$1
    local balance=$(dbAccounts_get "balance" $accountID)
    local currency=$(db_getAccountCurrency $accountID)
    local exchangeRate=$(db_getExchangeRate $currency)
    balance=$(echo "$balance*$exchangeRate" | bc)
    echo "$balance/100" | bc
    return 0
}

db_getAccountCurrency() {
    local accountID=$1
    local currency=$(dbAccounts_get "currency" $accountID)
    echo $currency
    return 0
}


db_printAccountBalance() {
    local accountID=$1
    local balance=$(db_getAccountBalance $accountID)
    local currency=$(db_getAccountCurrency $accountID)
    printf "%.2f %s" $balance $currency
    return 0
}


db_printAccountBalance_PLN() {
    local accountID=$1
    local balance=$(db_getAccountBalance $accountID)
    local currency=$(db_getAccountCurrency $accountID)
    local exchangeRate=$(db_getExchangeRate $currency)
    balance=$(echo "$balance*$exchangeRate" | bc)
    printf "%.2f PLN" $balance
    return 0
}