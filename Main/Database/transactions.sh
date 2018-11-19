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
    local bVirtual=${15}


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
    echo "  \"virtual\": \"$bVirtual\"," >> $transactionFile
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
    local bVirtual=${10}
    local bSrcVirtual=${11}

    

    # validate
    if [ "$sum" -lt "0" ]; then
        return 1
    fi

    # calculate source account balance
    if ! $bSrcVirtual; then
        local sourceAccountBalance=$(db_getAccountRawBalance $sourceAccountID)
    else
        local sourceAccountBalance=$(db_get "balance" "$sourceAccountID.$DB_EXT" "VirtualAccounts")
    fi
    local newSourceAccountBalance=$(($sourceAccountBalance-$sum))

    
    #validate
    # if [ "$(($sourceAccountBalance-$sum-10000))" -lt "0" ]; then
    #     return 1
    # fi

    if ! $bVirtual; then
        local targetAccountCurrency=$(db_getAccountCurrency $targetAccountID)
    else
        local targetAccountCurrency="PLN"
    fi

    # exchangeSum
    if ! $bSrcVirtual; then
        local sourceAccountCurrency=$(db_getAccountCurrency $sourceAccountID)
        local sourceExchangeRate=$(db_getExchangeRate $sourceAccountCurrency) 
        local targetExchangeRate=$(db_getExchangeRate $targetAccountCurrency)
        local receivedSum=$(echo "scale=4;$sum/($targetExchangeRate/$sourceExchangeRate)" | bc)
        receivedSum=$(echo "scale=0;($receivedSum+0.4999)/1" | bc)
    else
        local sourceAccountCurrency="PLN"
        local receivedSum=$(echo "scale=0;($sum+0.4999)/1" | bc)
    fi

    # calculate target account balance
    if ! $bVirtual; then
        local targetAccountBalance=$(db_getAccountRawBalance $targetAccountID)
    else
        local targetAccountBalance=$(db_get "balance" "$targetAccountID.$DB_EXT" "VirtualAccounts")
    fi
    local newTargetAccountBalance=$(($targetAccountBalance+$receivedSum))

    # update db
    if ! $bSrcVirtual; then
        dbAccounts_set "balance" $newSourceAccountBalance $sourceAccountID
    else
        db_set "balance" "$newSourceAccountBalance" "$sourceAccountID.$DB_EXT" "VirtualAccounts"
    fi

    if ! $bVirtual; then
        dbAccounts_set "balance" $newTargetAccountBalance $targetAccountID
    else
        db_set "balance" "$newTargetAccountBalance" "$targetAccountID.$DB_EXT" "VirtualAccounts"
    fi

    # create transaction
    userInfo=$(echo "$(dbUsers_get "firstname") $(dbUsers_get "lastname")")
    local transactionID=$(db_createTransaction "$(echo $(utl_getDate))" "$(echo $(utl_getTime))" "$type" $sourceAccountID "$userInfo" $targetAccountID "$name" "$title" $sum $sourceAccountCurrency $receivedSum $targetAccountCurrency "$transactionSum" "$transactionCurrency" $bVirtual)

    # push transactionID to both accounts
    if ! $bSrcVirtual; then
        db_addTransactionToAccount $transactionID $sourceAccountID false
    fi
    db_addTransactionToAccount $transactionID $targetAccountID $bVirtual


    echo "$transactionID"
    return 0
}


db_loanMoney() {
    local type="$1"
    local subtitle="$2"
    local title="$3"
    local rrso="$4"
    local sourceName="$5"
    local bMakeTransfer=$6
    local bAskLoansGoal=$7
    local bAuthenticateByPhone=$8    
    local bAuthenticateByPesel=$9    

    local sum
    local expectedSum    
    local nInstallments    
    local endDate
    local loansGoal=""       

    # extract data from user: loanSum, loanInstallments
    ui_header "$subtitle" "$title"
    read -p "Kwota [PLN]: " sum

    if [ "$sum" == "" ]; then
        echo "Niepoprawne dane wejściowe."
        echo ""
        return 1
    fi

    sum=$(echo $sum | tr "," ".")
    sum=$(echo "scale=0;($sum*100)/1" | bc)
    if [ "$sum" -le 0 ]; then
        echo "Kwota musi być większa od zera."
        echo ""
        return 1
    fi

   
    
    expectedSum="$sum"

    read -p "Czas spłaty [w miesiącach]: " nInstallments
    if [ "$nInstallments" == "" ]; then
        echo "Niepoprawne dane wejściowe."
        echo ""
        return 1
    fi

    if [ "$nInstallments" -le 0 ]; then
        echo "Ilość miesięcy musi być większa 0."
        echo ""
        return 1
    fi

    if ($bAskLoansGoal); then
        read -p "Cel: " loansGoal
    fi

    # calculate: endDate, expectedSum, monthlySum
    endDate=`date '+%Y-%m-%d' -d "$(date)+$nInstallments months"`
    local nYears=$(echo "scale=0;($nInstallments-1)/12" | bc)
    ((nYears++))
    while [ "$nYears" -gt 0 ]; do
        expectedSum=$(echo "scale=0;($rrso*$expectedSum)/1" | bc)
        ((nYears--))
    done

    local monthlySum=$(echo "scale=2;($expectedSum/$nInstallments)/100" | bc)
    local expectedSumPrint=$(echo "scale=2;$expectedSum/100" | bc)


    # confirm
    echo ""
    echo "Całkowita suma do spłaty: $expectedSumPrint PLN"
    echo "Miesięczna rata: $monthlySum PLN"
    echo ""
    echo "1 - Potwierdź"
    echo "0 - Anuluj"
    echo ""
    ui_line
    local action
    read -p "Wybierz akcję: " action
    if [ "$action" != "1" ]; then
        home_skipPause=true
        return 1
    fi

    # auth
    if $bAuthenticateByPhone; then
        ui_header "$subtitle" "$title"
        echo "<wysyłanie kodu na telefon (123456)>"
        echo ""
        read -p "Podaj kod autoryzacyjny: " code
        
        if [ "$code" != "123456" ]; then
            ui_header "$subtitle" "$title"
            printf $RED
            echo "Kod autoryzacyjny niepoprawny."
            echo "Operacja zakończyła się niepowodzeniem."
            printf $DEFAULT_COLOR
            echo ""
            return 1
        fi
    fi

    if $bAuthenticateByPesel; then
        ui_header "$subtitle" "$title"
        read -p "Podaj numer pesel: " pesel
        
        if [ "$pesel" != "$(dbUsers_get "pesel")" ]; then
            ui_header "$subtitle" "$title"
            printf $RED
            echo "Pesel niepoprawny."
            echo "Operacja zakończyła się niepowodzeniem."
            printf $DEFAULT_COLOR
            echo ""
            return 1
        fi
    fi


    # create file: sum, expectedSum, paidSum, endDate
    local fileDir="$DB/Loans"
    local fileID=$(utl_getNextIndex "$fileDir" "3")
    local file="$(echo $fileDir/$fileID.$DB_EXT)"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"type\": \"$type\"," >> $file
    echo -e "\t\"sum\": \"$sum\"," >> $file
    echo -e "\t\"expectedSum\": \"$expectedSum\"," >> $file
    echo -e "\t\"paidSum\": \"0\"," >> $file
    echo -e "\t\"currency\": \"PLN\"," >> $file
    echo -e "\t\"date\": \"$(utl_getDate)\"," >> $file
    echo -e "\t\"endDate\": \"$endDate\"," >> $file
    echo -e "\t\"goal\": \"$loansGoal\"," >> $file
    echo -e "\t\"bank\": \"$sourceName\"," >> $file
    echo -e "\t\"location\": \"Online\"" >> $file
    echo -e "}" >> $file

    # add to user
    db_add "loansID" "$fileID" "$USERNAME.$DB_EXT" "Users"

    # makeTransfer
    local typeLabel
    case "$type" in
        "POŻYCZKA") typeLabel="Pożyczka" ;;
        "KREDYT") typeLabel="Kredyt" ;;
        "LEASING") typeLabel="Leasing" ;;
    esac
    
    if $bMakeTransfer; then
        local transactionID=$(db_makeTransfer "PRZELEW ZWYKŁY" "000" "$(db_getUsersAccount)" "$(echo "$(dbUsers_get "firstname") $(dbUsers_get "lastname")")" "" "$typeLabel: $fileID" "$sum" "$sum" "PLN" false false)
    fi

    # feedback
    ui_header "$subtitle" "$title"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0
}