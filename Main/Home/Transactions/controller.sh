#!/bin/bash
tnst_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$tnst_dir" ]]; then tnst_dir="$PWD"; fi

. $tnst_dir/../../Database/users.sh
. $tnst_dir/../../Database/accounts.sh
. $tnst_dir/../../Database/misc.sh
. $tnst_dir/../../Database/transactions.sh



tnst_handleTransfer() {
    __tnst_handleTransfer "PRZELEW_ZWYKŁY"
    return 0
}

tnst_handleExpressTransfer() {
    ui_header $tnst_title "PRZELEW_EKSPRESS"
    return 0
}

tnst_handleMonetaryTransfer() {
    ui_header $tnst_title "PRZELEW_WALUTOWY"
    return 0
}

#--------------------------------------------------------

__tnst_handleTransfer() {
    local sourceAccountID=""
    local targetAccountID=""
    local name=""
    local address=""
    local title=""
    local sum=""
    local error=" "

    while [ "$error" != "" ]; do
        ui_header $tnst_title ${1}

        if [ "$error" != " " ]; then
            echo $error
            error=""
            echo ""
        fi

        # sourceAccount
        if [ "$sourceAccountID" == "" ]; then
            local _accounts=$(db_getUserAccounts)
            local id=1           
            local accounts=()
            for i in $_accounts; do
                echo "$id - $i"
                accounts+=("$i")
                ((id++))
            done
            echo "0 - Powrót"
            echo ""
            ui_line

            read -p "Wybierz rachunek: " sourceAccountSelection
            ((sourceAccountSelection--))
            if [ "$sourceAccountSelection" == "" ]; then
                error=" "
                continue
            elif [ "$sourceAccountSelection" == "-1" ]; then
                home_skipPause=true
                return 1
            else
                error=" "
                ui_header $tnst_title ${1}
                sourceAccountID=${accounts[$sourceAccountSelection]}

                sourceAccountBalance=$(db_getAccountRawBalance_PLN $sourceAccountID)
                sourceAccountBalance=$(echo "$sourceAccountBalance" | sed "s/\.[0-9]*//")
                if [ "$sourceAccountBalance" == "0" ]; then
                    echo "Nie wystarczające środki."
                    echo ""
                    return 1
                fi
                
                echo "Przelew z rachunku: $sourceAccountID"   
            fi
            continue
        else
            echo "Przelew z rachunku: $sourceAccountID"   
        fi

        # targetAccount
        if [ "$targetAccountID" == "" ]; then
            read -p "Rachunek odbiorcy: " targetAccountID
            if [ "$targetAccountID" == "" ]; then
                error="Rachunek odbiorcy nie może być pusty."
            elif (! db_doesAccountExists $targetAccountID); then
                targetAccountID=""
                error="Nie znaleziono podanego rachunku bankowego."
            elif [ "$sourceAccountID" == "$targetAccountID" ]; then
                targetAccountID=""
                error="Nie można dokonać przelewu na te konto."
            else
                error=" "
            fi
            continue
        else
            echo "Rachunek odbiorcy: $targetAccountID"
        fi

        # name
        if [ "$name" == "" ]; then
            read -p "Nazwa odbiorcy: " name
            if [ "$name" == "" ]; then
                error="Nazwa odbiorcy nie może być pusta."
            else
                error=" "
            fi
            continue
        else
            echo "Nazwa odbiorcy: $name"
        fi

        # address
        if [ "$address" == "" ]; then
            read -p "Adres odbiorcy: " address
            if [ "$address" == "" ]; then
                error="Adres odbiorcy nie może być pusty."
            else
                error=" "
            fi
            continue
        else
            echo "Adres odbiorcy: $address"
        fi

        # title
        if [ "$title" == "" ]; then
            read -p "Tytuł przelewu: " title
            if [ "$title" == "" ]; then
                error="Tytuł przelewu nie może być pusty."
            else
                error=" "
            fi
            continue
        else
            echo "Tytuł przelewu: $title"
        fi

        # sum
        if [ "$sum" == "" ]; then
            read -p "Kwota przelewu: " sum
            sum=$(echo "scale=0;($sum * 100)/1" | bc)
            if [ "$sum" == "" ]; then
                error="Kwota przelewu nie może być pusta."
                continue
            elif [ "$sum" -lt 0 ]; then
                sum=""
                error="Kwota przelewu nie może być ujemna."
            elif [ "$sum" -gt "$sourceAccountBalance" ]; then
                sum=""
                error="Nie wystarczające środki."
            else 
                error=""
            fi
            continue
        else
            echo "Kwota przelewu: $sum"
        fi
    done

    echo ""
    echo "1 - Potwierdź"
    echo "0 - Anuluj"
    ui_line
    
    local action
    read -p "Wybierz akcję: " action

    if [ "$action" == "1" ]; then
        __tnst_makeTransfer $1 $sourceAccountID $targetAccountID $name $address $title $sum
        return 0
    fi

    home_skipPause=true
    return 1
}


__tnst_makeTransfer() {
    ui_header $tnst_title $1

    local sourceAccountID=$2
    local targetAccountID=$3
    local name=$4
    local address=$5
    local title=$6
    local sum=$7

    # calculate source account balance
    local sourceAccountBalance=$(db_getAccountRawBalance_PLN $sourceAccountID)
    local sourceAccountCurrency=$(db_getAccountCurrency $sourceAccountID)
    local sourceExchangeRate=$(db_getExchangeRate $sourceAccountCurrency)
    local newSourceAccountBalance=$(echo "scale=4;($sourceAccountBalance-$sum)/$sourceExchangeRate" | bc)
    newSourceAccountBalance=$(echo "scale=0;($newSourceAccountBalance+0.4999)/1" | bc)

    # calculate target account balance
    local targetAccountBalance=$(db_getAccountRawBalance_PLN $targetAccountID)
    local targetAccountCurrency=$(db_getAccountCurrency $targetAccountID)
    local targetExchangeRate=$(db_getExchangeRate $targetAccountCurrency)
    local newTargetAccountBalance=$(echo "scale=4;($targetAccountBalance+$sum)/$targetExchangeRate" | bc -l)
    newTargetAccountBalance=$(echo "scale=0;($newTargetAccountBalance+0.4999)/1" | bc)

    #-----------------------------------------------
    # echo "sum: $sum"
    # echo "SOURCE"
    # echo "sourceAccountBalance: $sourceAccountBalance"
    # echo "sourceExchangeRate: $sourceExchangeRate"
    # echo "newSourceAccountBalance: $newSourceAccountBalance"
    # echo "TARGET"
    # echo "targetAccountBalance: $targetAccountBalance"
    # echo "targetExchangeRate: $targetExchangeRate"
    # echo "newTargetAccountBalance: $newTargetAccountBalance"
    #-----------------------------------------------


    dbAccounts_set "balance" $newSourceAccountBalance $sourceAccountID
    dbAccounts_set "balance" $newTargetAccountBalance $targetAccountID


    #TODO: transaction source name
    local transactionID=$(db_createTransaction "$(echo $(utl_getDateAndTime))" $sourceAccountID "<srcName>" $targetAccountID $name $title $sum)


    # push transactionID to both accounts
    db_addTransactionToAccount $transactionID $sourceAccountID
    db_addTransactionToAccount $transactionID $targetAccountID

    echo "Przelew został zrealizowany."
    echo ""
    return 0
}