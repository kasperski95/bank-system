#!/bin/bash
. Main/globals.sh
. Main/Utils/index.sh

usersDir="$DB/Users"
if [ ! -d "$usersDir" ]; then
    mkdir $usersDir
fi

accountsDir="$DB/Accounts"
if [ ! -d "$accountsDir" ]; then
    mkdir $accountsDir
fi

transactionsDir="$DB/Transactions"
if [ ! -d "$transactionsDir" ]; then
    mkdir $transactionsDir
fi

fooReceiversDir="$DB/Receivers/foo"
if [ ! -d "$fooReceiversDir" ]; then
    mkdir $fooReceiversDir
fi

barReceiversDir="$DB/Receivers/bar"
if [ ! -d "$barReceiversDir" ]; then
    mkdir $barReceiversDir
fi

cardsDir="$DB/Cards"
if [ ! -d "$cardsDir" ]; then
    mkdir $cardsDir
fi

generationDate=$(utl_getDate)
generationTime=$(utl_getTime)
file_userBank="$usersDir/bank.$DB_EXT"
file_userFoo="$usersDir/foo.$DB_EXT"
file_userBar="$usersDir/bar.$DB_EXT"
file_account000="$accountsDir/000.$DB_EXT"
file_account001="$accountsDir/001.$DB_EXT"
file_account002="$accountsDir/002.$DB_EXT"
file_account003="$accountsDir/003.$DB_EXT"
file_account004="$accountsDir/004.$DB_EXT"
file_account005="$accountsDir/005.$DB_EXT"
file_transaction0="$transactionsDir/000000.$DB_EXT"
file_transaction1="$transactionsDir/000001.$DB_EXT"
file_zusFoo="$fooReceiversDir/000.$DB_EXT"
file_zusBar="$barReceiversDir/000.$DB_EXT"

touch $file_userBank
touch $file_userFoo
touch $file_userBar
touch $file_account000
touch $file_account001
touch $file_account002
touch $file_account003
touch $file_transaction0
touch $file_transaction1


echo "{" > $file_userBank
echo "    \"password\": \"1234\"," >> $file_userBank
echo "    \"accountsID\": [\"000\",\"001\"]," >> $file_userBank
echo "    \"insurancesID\": []," >> $file_userBank
echo "    \"firstname\": \"Bank\"," >> $file_userBank
echo "    \"lastname\": \"Owners\"," >> $file_userBank
echo "    \"city\": \"Warszawa\"," >> $file_userBank
echo "    \"street\": \"Żydowska\"," >> $file_userBank
echo "    \"streetNumber\": \"39\"," >> $file_userBank
echo "    \"phoneNumber\": \"+4879012344" >> $file_userBank
echo "}" >> $file_userBank

echo "{" > $file_userFoo
echo "    \"password\": \"1234\"," >> $file_userFoo
echo "    \"accountsID\": [\"002\",\"003\"]," >> $file_userFoo
echo "    \"insurancesID\": []," >> $file_userFoo
echo "    \"firstname\": \"John\"," >> $file_userFoo
echo "    \"lastname\": \"Doe\"," >> $file_userFoo
echo "    \"city\": \"Warszawa\"," >> $file_userFoo
echo "    \"street\": \"Słoneczna\"," >> $file_userFoo
echo "    \"streetNumber\": \"42\"," >> $file_userFoo
echo "    \"phoneNumber\": \"+48790123456\"" >> $file_userFoo
echo "}" >> $file_userFoo

echo "{" > $file_userBar
echo "    \"password\": \"1234\"," >> $file_userBar
echo "    \"accountsID\": [\"004\",\"005\"]," >> $file_userBar
echo "    \"insurancesID\": []," >> $file_userBar
echo "    \"firstname\": \"Jan\"," >> $file_userBar
echo "    \"lastname\": \"Nowak\"," >> $file_userBar
echo "    \"city\": \"Kraków\"," >> $file_userBar
echo "    \"street\": \"Kamienna\"," >> $file_userBar
echo "    \"streetNumber\": \"24\"," >> $file_userBar
echo "    \"phoneNumber\": \"+48790123457\"" >> $file_userBar
echo "}" >> $file_userBar


echo "{" > $file_account000
echo "   \"balance\": \"10000000\"," >> $file_account000
echo "   \"type\": \"checking\"," >> $file_account000
echo "   \"transactionsID\": [\"000000\", \"000001\"]," >> $file_account000
echo "   \"cardsID\": []," >> $file_account000
echo "   \"currency\": \"PLN\"" >> $file_account000
echo "}" >> $file_account000

echo "{" > $file_account001
echo "   \"balance\": \"0\"," >> $file_account001
echo "   \"type\": \"saving\"," >> $file_account001
echo "   \"transactionsID\": []," >> $file_account001
echo "   \"cardsID\": []," >> $file_account001
echo "   \"currency\": \"PLN\"" >> $file_account001
echo "}" >> $file_account001

echo "{" > $file_account002
echo "   \"balance\": \"100000\"," >> $file_account002
echo "   \"type\": \"checking\"," >> $file_account002
echo "   \"transactionsID\": [\"000000\"]," >> $file_account002
echo "   \"cardsID\": []," >> $file_account002
echo "   \"currency\": \"PLN\"" >> $file_account002
echo "}" >> $file_account002

echo "{" > $file_account003
echo "   \"balance\": \"0\"," >> $file_account003
echo "   \"type\": \"saving\"," >> $file_account003
echo "   \"transactionsID\": []," >> $file_account003
echo "   \"cardsID\": []," >> $file_account003
echo "   \"currency\": \"PLN\"" >> $file_account003
echo "}" >> $file_account003

echo "{" > $file_account004
echo "   \"balance\": \"100000\"," >> $file_account004
echo "   \"type\": \"checking\"," >> $file_account004
echo "   \"transactionsID\": [\"000001\"]," >> $file_account004
echo "   \"cardsID\": []," >> $file_account004
echo "   \"currency\": \"PLN\"" >> $file_account004
echo "}" >> $file_account004

echo "{" > $file_account005
echo "   \"balance\": \"0\"," >> $file_account005
echo "   \"type\": \"saving\"," >> $file_account005
echo "   \"transactionsID\": []," >> $file_account005
echo "   \"cardsID\": []," >> $file_account005
echo "   \"currency\": \"PLN\"" >> $file_account005
echo "}" >> $file_account005


echo "{" > $file_transaction0
echo "  \"date\": \"$generationDate\"," >> $file_transaction0
echo "  \"time\": \"$generationTime\"," >> $file_transaction0
echo "  \"title\": \"Przelew testowy\"," >> $file_transaction0
echo "  \"type\": \"PRZELEW ZWYKŁY\"," >> $file_transaction0
echo "  \"sum\": \"100000\"," >> $file_transaction0
echo "  \"sumCurrency\": \"PLN\"," >> $file_transaction0
echo "  \"transactionSum\": \"100000\"," >> $file_transaction0
echo "  \"transactionCurrency\": \"PLN\"," >> $file_transaction0
echo "  \"receivedSum\": \"100000\"," >> $file_transaction0
echo "  \"receivedSumCurrency\": \"PLN\"," >> $file_transaction0
echo "  \"sourceAccountID\": \"000\"," >> $file_transaction0
echo "  \"sourceName\": \"Bank\"," >> $file_transaction0
echo "  \"targetAccountID\": \"002\"," >> $file_transaction0
echo "  \"targetName\": \"Jan Kowalski\"" >> $file_transaction0
echo "}" >> $file_transaction0

echo "{" > $file_transaction1
echo "  \"date\": \"$generationDate\"," >> $file_transaction1
echo "  \"time\": \"$generationTime\"," >> $file_transaction1
echo "  \"title\": \"Przelew testowy\"," >> $file_transaction1
echo "  \"type\": \"PRZELEW ZWYKŁY\"," >> $file_transaction1
echo "  \"sum\": \"100000\"," >> $file_transaction1
echo "  \"sumCurrency\": \"PLN\"," >> $file_transaction1
echo "  \"transactionSum\": \"100000\"," >> $file_transaction1
echo "  \"transactionCurrency\": \"PLN\"," >> $file_transaction1
echo "  \"receivedSum\": \"100000\"," >> $file_transaction1
echo "  \"receivedSumCurrency\": \"PLN\"," >> $file_transaction1
echo "  \"sourceAccountID\": \"000\"," >> $file_transaction1
echo "  \"sourceName\": \"Bank\"," >> $file_transaction1
echo "  \"targetAccountID\": \"004\"," >> $file_transaction1
echo "  \"targetName\": \"Jan Nowak\"" >> $file_transaction1
echo "}" >> $file_transaction1


echo "{" > $file_zusFoo
echo "  \"name\": \"ZUS\"," >> $file_zusFoo
echo "  \"address\": \"ul. Senatorska 6, Warszawa\"," >> $file_zusFoo
echo "  \"accountID\": \"000\"," >> $file_zusFoo
echo "  \"hidden\": \"false\"" >> $file_zusFoo
echo "}" >> $file_zusFoo

echo "{" > $file_zusBar
echo "  \"name\": \"ZUS\"," >> $file_zusBar
echo "  \"address\": \"ul. Senatorska 6, Warszawa\"," >> $file_zusBar
echo "  \"accountID\": \"000\"," >> $file_zusBar
echo "  \"hidden\": \"false\"" >> $file_zusBar
echo "}" >> $file_zusBar