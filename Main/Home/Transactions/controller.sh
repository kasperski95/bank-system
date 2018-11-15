#!/bin/bash
tnst_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$tnst_dir" ]]; then tnst_dir="$PWD"; fi

. $tnst_dir/../../Database/users.sh
. $tnst_dir/../../Database/accounts.sh
. $tnst_dir/../../Database/misc.sh
. $tnst_dir/../../Database/transactions.sh



tnst_handleTransfer() {
    __tnst_handleTransfer "PRZELEW ZWYKŁY" "0" "300" "false"
    return 0
}

tnst_handleExpressTransfer() {
    __tnst_handleTransfer "PRZELEW EKSPRESS" "1000" "500" "false"
    return 0
}

tnst_handleMonetaryTransfer() {
    __tnst_handleTransfer "PRZELEW WALUTOWY" "2000" "1000" "true"
    return 0
}

#--------------------------------------------------------

__tnst_handleTransfer() {
    local transactionCost="$2"
    local sumToSave="$3"
    local monetaryTransfer="$4"

    local sourceAccountID=""
    local targetAccountID=""
    local name=""
    local address=""
    local title=""
    local currency=""
    local sum=""
    local error=" "

    # extract information from the user
    while [ "$error" != "" ]; do
        ui_header "$tnst_title" "$1"

        

        # sourceAccount
        if [ "$sourceAccountID" == "" ]; then
            local _accounts=$(db_getUserAccounts)
            local id=1           
            local accounts=()
            for i in $_accounts; do
                if [ "$(db_getAccountsType $i)" != "saving" ]; then
                    echo "$id - $i"
                    accounts+=("$i")
                    ((id++))
                fi
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
                ui_header "$tnst_title" "$1"
                sourceAccountID=${accounts[$sourceAccountSelection]}

                sourceAccountBalance=$(db_getAccountRawBalance_PLN $sourceAccountID)
                sourceAccountBalance=$(echo "$sourceAccountBalance" | sed "s/\.[0-9]*//")
                local sourceAccountCurrency=$(db_getAccountCurrency $sourceAccountID)
                if [ "$sourceAccountBalance" -lt "$(($transactionCost+$sumToSave))" ]; then
                    echo "Nie wystarczające środki."
                    echo ""
                    return 1
                fi
                
                echo "Przelew z rachunku: $sourceAccountID"   
            fi
            continue
 
        fi


        # currency
        if [ "$currency" == "" ]; then
            if [ "$monetaryTransfer" == "true" ]; then
                local chosenCurrency
                __tnst_showCurrencies
                read -p "Wybierz walutę: " chosenCurrency
                
                if [ "$chosenCurrency" == "" ]; then
                    error=" "
                    continue
                fi

                currency=$(__tnst_getCurrencyFromNumber $chosenCurrency)
                local exchangeRate=$(echo "scale=4; $(db_getExchangeRate $currency)/$(db_getExchangeRate $sourceAccountCurrency)" | bc | sed "s/^\./0\./")
                
                transactionCost=$(echo "scale=4; $transactionCost*$(db_getExchangeRate $sourceAccountCurrency)" | bc )
                transactionCost=$(echo "scale=0; ($transactionCost+0.4999)/1" | bc )
                sumToSave=$(echo "scale=4; $sumToSave*$(db_getExchangeRate $sourceAccountCurrency)" | bc)
                sumToSave=$(echo "scale=0; ($sumToSave+0.4999)/1" | bc )

            else
                currency=$sourceAccountCurrency
                local exchangeRate=1
            fi
        fi


        # user's receivers
        if [ "$targetAccountID" == "" ]; then
            local receiversFilesRaw=$(db_getReceivers)
            local receiversFiles=()
            local j=1
            for i in ${receiversFilesRaw[@]}; do
                echo "$j - $(utl_getFromJson "name" "$(dbReceivers_getPath)/$i")"
                receiversFiles+=("$i")
            done
            echo "0 - Pomiń"
            echo ""
            ui_line
            local receiverIndex
            read -p "Wybierz odbiorcę: " receiverIndex
            

            if [ "$receiverIndex" != "0" ]; then
                ((receiverIndex--))
                name=$(utl_getFromJson "name" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
                address=$(utl_getFromJson "address" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
                targetAccountID=$(utl_getFromJson "accountID" "$(dbReceivers_getPath)/${receiversFiles[$receiverIndex]}")
            fi   
        fi


        ui_header "$tnst_title" "$1"
        if [ "$error" != " " ]; then
            echo $error
            error=""
            echo ""
        fi

        echo "Przelew z rachunku: $sourceAccountID"   
        
        if [ "$monetaryTransfer" == "true" ]; then
            echo "Waluta przelewu: $currency"   
            echo "Kurs: $exchangeRate"
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
            read -p "Kwota przelewu [$currency]: " sum
            sum=$(echo $sum | tr "," ".")
            if [[ ! "$sum" =~ ^[0-9]+\.[0-9][0-9]$ ]]; then
                sum=""
                error="Kwota przelewu musi być w formacie: 0.00"
            else
                sum=$(echo "scale=0;($sum * 100)/1" | bc)
                if [ "$sum" == "" ]; then
                    error="Kwota przelewu nie może być pusta."
                elif [ "$sum" -lt 0 ]; then
                    sum=""
                    error="Kwota przelewu nie może być ujemna."
                elif [ "$sum" -gt "$sourceAccountBalance" ]; then
                    sum=""
                    error="Nie wystarczające środki."
                else 
                    error=" "
                fi
            fi
            continue
        else
            echo "Kwota przelewu [$currency]: $(echo "scale=2;$sum/100" | bc)"
        fi


        if [ "$monetaryTransfer" == "true" ]; then
            
            sum=$(echo "scale=4;$exchangeRate*$sum" | bc)
            sum=$(echo "scale=0;($sum+0.4999)/1" | bc)
            echo "Kwota przelewu [$sourceAccountCurrency]: $(echo "scale=2;$sum/100" | bc)"      
        fi


        if [ "$sum" -gt "5000" ]; then
            local code

            echo ""
            echo "<wysyłanie kodu na telefon: 123456>"
            read -p "Wprowadź kod: " code

            if [ "$code" -eq "123456" ]; then
                error=""
            else
                error="Kod jest nieprawidłowy."
            fi

        else
            error=""
        fi

    done

    echo ""
    echo "1 - Potwierdź"
    echo "0 - Anuluj"
    echo ""
    ui_line
    
    local action
    read -p "Wybierz akcję: " action


    # make transfers
    if [ "$action" == "1" ]; then
        local transactionID=$(db_makeTransfer "$1" $sourceAccountID $targetAccountID "$name" "$address" "$title" $sum)
        
        if [ "$transactionCost" -gt "0" ]; then
            local bankTransactionID=$( db_makeTransfer "PRZELEW ZWYKŁY" $sourceAccountID "000" "$name" "$address" "Koszt przelewu: $transactionID" $transactionCost)
        fi

        if [ "$sumToSave" -gt "0" ]; then
            local usersSavingAccount=$(db_getUsersSavingAccount)
            local internalTransactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" $sourceAccountID $usersSavingAccount "$name" "$address" "Przelew wewnętrzny" $sumToSave)
        fi

        ui_header "$tnst_title" "$1"
        echo "Przelew został zrealizowany."
        echo ""
        return 0
    fi

    home_skipPause=true
    return 1
}



__tnst_showCurrencies() {
    ui_header "$tnst_title" "PRZELEW WALUTOWY"
    echo "1 - USD"
    echo "2 - EUR"
    echo "3 - CHF"
    echo "4 - GBP"
    echo "5 - AUD"
    echo "6 - UAH"
    echo "7 - CZK"
    echo "8 - HRK"
    echo "9 - RUB"
    echo ""
    ui_line

    return 0
}


__tnst_getCurrencyFromNumber() {
    case $1 in
        "1") echo "USD";;
        "2") echo "EUR";;
        "3") echo "CHF";;
        "4") echo "GBP";;
        "5") echo "AUD";;
        "6") echo "UAH";;
        "7") echo "CZK";;
        "8") echo "HRK";;
        "9") echo "RUB";;
    esac

    return 0
}