#!/bin/bash
. Main/globals.sh
. Main/Utils/index.sh

generationDate=$(utl_getDate)
generationTime=$(utl_getTime)
file_userFoo="$DB/Users/foo.$DB_EXT"
file_userBar="$DB/Users/bar.$DB_EXT"
file_account000="$DB/Accounts/000.$DB_EXT"
file_account001="$DB/Accounts/001.$DB_EXT"
file_account002="$DB/Accounts/002.$DB_EXT"
file_account003="$DB/Accounts/003.$DB_EXT"
file_transaction0="$DB/Transactions/000000.$DB_EXT"
file_transaction1="$DB/Transactions/000001.$DB_EXT"

touch $file_userFoo
touch $file_userBar
touch $file_account000
touch $file_account001
touch $file_account002
touch $file_account003
touch $file_transaction0
touch $file_transaction1


echo "{" > $file_userFoo
echo "    \"password\": \"1234\"," >> $file_userFoo
echo "    \"accountsID\": [\"000\",\"001\"]," >> $file_userFoo
echo "    \"firstname\": \"Jan\"," >> $file_userFoo
echo "    \"lastname\": \"Kowalski\"," >> $file_userFoo
echo "    \"city\": \"Warszawa\"," >> $file_userFoo
echo "    \"street\": \"Słoneczna\"," >> $file_userFoo
echo "    \"streetNumber\": \"42\"," >> $file_userFoo
echo "    \"phoneNumber\": \"+48790123456\"" >> $file_userFoo
echo "}" >> $file_userFoo

echo "{" > $file_userBar
echo "    \"password\": \"1234\"," >> $file_userBar
echo "    \"accountsID\": [\"002\",\"003\"]," >> $file_userBar
echo "    \"firstname\": \"Jan\"," >> $file_userBar
echo "    \"lastname\": \"Nowak\"," >> $file_userBar
echo "    \"city\": \"Kraków\"," >> $file_userBar
echo "    \"street\": \"Kamienna\"," >> $file_userBar
echo "    \"streetNumber\": \"24\"," >> $file_userBar
echo "    \"phoneNumber\": \"+48790123457\"" >> $file_userBar
echo "}" >> $file_userBar


echo "{" > $file_account000
echo "   \"balance\": \"100000\"," >> $file_account000
echo "   \"type\": \"checking\"," >> $file_account000
echo "   \"transactionsID\": [\"000000\"]," >> $file_account000
echo "   \"currency\": \"PLN\"" >> $file_account000
echo "}" >> $file_account000

echo "{" > $file_account001
echo "   \"balance\": \"0\"," >> $file_account001
echo "   \"type\": \"saving\"," >> $file_account001
echo "   \"transactionsID\": []," >> $file_account001
echo "   \"currency\": \"USD\"" >> $file_account001
echo "}" >> $file_account001

echo "{" > $file_account002
echo "   \"balance\": \"100000\"," >> $file_account002
echo "   \"type\": \"checking\"," >> $file_account002
echo "   \"transactionsID\": [\"000001\"]," >> $file_account002
echo "   \"currency\": \"PLN\"" >> $file_account002
echo "}" >> $file_account002

echo "{" > $file_account003
echo "   \"balance\": \"0\"," >> $file_account003
echo "   \"type\": \"saving\"," >> $file_account003
echo "   \"transactionsID\": []," >> $file_account003
echo "   \"currency\": \"PLN\"" >> $file_account003
echo "}" >> $file_account003


echo "{" > $file_transaction0
echo "  \"date\": \"$generationDate\"," >> $file_transaction0
echo "  \"time\": \"$generationTime\"," >> $file_transaction0
echo "  \"title\": \"Przelew testowy\"," >> $file_transaction0
echo "  \"sum\": \"100000\"," >> $file_transaction0
echo "  \"sumCurrency\": \"PLN\"," >> $file_transaction0
echo "  \"receivedSum\": \"100000\"," >> $file_transaction0
echo "  \"receivedSumCurrency\": \"PLN\"," >> $file_transaction0
echo "  \"sourceAccountID\": \"bank\"," >> $file_transaction0
echo "  \"sourceName\": \"Bank\"," >> $file_transaction0
echo "  \"targetAccountID\": \"000\"," >> $file_transaction0
echo "  \"targetName\": \"Jan Kowalski\"" >> $file_transaction0
echo "}" >> $file_transaction0

echo "{" > $file_transaction1
echo "  \"date\": \"$generationDate\"," >> $file_transaction1
echo "  \"time\": \"$generationTime\"," >> $file_transaction1
echo "  \"title\": \"Przelew testowy\"," >> $file_transaction1
echo "  \"sum\": \"100000\"," >> $file_transaction1
echo "  \"sumCurrency\": \"PLN\"," >> $file_transaction1
echo "  \"receivedSum\": \"100000\"," >> $file_transaction1
echo "  \"receivedSumCurrency\": \"PLN\"," >> $file_transaction1
echo "  \"sourceAccountID\": \"bank\"," >> $file_transaction1
echo "  \"sourceName\": \"Bank\"," >> $file_transaction1
echo "  \"targetAccountID\": \"001\"," >> $file_transaction1
echo "  \"targetName\": \"Jan Nowak\"" >> $file_transaction1
echo "}" >> $file_transaction1