#!/bin/bash
. Main/globals.sh

generationDate=$(echo $(date))
file_userFoo="$DB/Users/foo.json"
file_userBar="$DB/Users/bar.json"
file_account000="$DB/Accounts/000.json"
file_account001="$DB/Accounts/001.json"
file_account002="$DB/Accounts/002.json"
file_account003="$DB/Accounts/003.json"
file_transaction0="$DB/Transactions/0.json"
file_transaction1="$DB/Transactions/1.json"

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
echo "   \"transactionsID\": [\"0\"]," >> $file_account000
echo "   \"currency\": \"PLN\"" >> $file_account000
echo "}" >> $file_account000

echo "{" > $file_account001
echo "   \"balance\": \"0\"," >> $file_account001
echo "   \"type\": \"checking\"," >> $file_account001
echo "   \"transactionsID\": []," >> $file_account001
echo "   \"currency\": \"USD\"" >> $file_account001
echo "}" >> $file_account001

echo "{" > $file_account002
echo "   \"balance\": \"100000\"," >> $file_account002
echo "   \"type\": \"checking\"," >> $file_account002
echo "   \"transactionsID\": [\"1\"]," >> $file_account002
echo "   \"currency\": \"PLN\"" >> $file_account002
echo "}" >> $file_account002

echo "{" > $file_account003
echo "   \"balance\": \"0\"," >> $file_account003
echo "   \"type\": \"checking\"," >> $file_account003
echo "   \"transactionsID\": []," >> $file_account003
echo "   \"currency\": \"USD\"" >> $file_account003
echo "}" >> $file_account003


echo "{" > $file_transaction0
echo "  \"date\": \"$generationDate\"," >> $file_transaction0
echo "  \"title\": \"Przelew testowy\"," >> $file_transaction0
echo "  \"amount\": \"100000\"," >> $file_transaction0
echo "  \"sourceAccountID\": \"001\"," >> $file_transaction0
echo "  \"sourceName\": \"Bank\"," >> $file_transaction0
echo "  \"targetAccountID\": \"000\"," >> $file_transaction0
echo "  \"targetName\": \"Jan Kowalski\"" >> $file_transaction0
echo "}" >> $file_transaction0

echo "{" > $file_transaction1
echo "  \"date\": \"$generationDate\"," >> $file_transaction1
echo "  \"title\": \"Przelew testowy\"," >> $file_transaction1
echo "  \"amount\": \"100000\"," >> $file_transaction1
echo "  \"sourceAccountID\": \"000\"," >> $file_transaction1
echo "  \"sourceName\": \"Bank\"," >> $file_transaction1
echo "  \"targetAccountID\": \"001\"," >> $file_transaction1
echo "  \"targetName\": \"Jan Nowak\"" >> $file_transaction1
echo "}" >> $file_transaction1