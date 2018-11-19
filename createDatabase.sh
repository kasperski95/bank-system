#!/bin/bash
. Main/globals.sh

rm -r "$DB"

if [ ! -d "$DB" ]; then
    mkdir "$DB"
fi

. Main/Utils/index.sh

#TODO: DRY
#TODO: Separate creating and mocking database


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

receiversDir="$DB/Receivers"
if [ ! -d "$receiversDir" ]; then
    mkdir $receiversDir
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

phonesDir="$DB/Phones"
if [ ! -d "$phonesDir" ]; then
    mkdir $phonesDir
fi

loansDir="$DB/Loans"
if [ ! -d "$loansDir" ]; then
    mkdir $loansDir
fi

standingOrdersDir="$DB/StandingOrders"
if [ ! -d "$standingOrdersDir" ]; then
    mkdir $standingOrdersDir
fi

virtualAccountsDir="$DB/VirtualAccounts"
if [ ! -d "$virtualAccountsDir" ]; then
    mkdir $virtualAccountsDir
fi

miscDir="$DB/Misc"
if [ ! -d "$miscDir" ]; then
    mkdir $miscDir
fi

documentsDir="$DB/Documents"
if [ ! -d "$documentsDir" ]; then
    mkdir $documentsDir
fi

certificatesDir="$DB/Certificates"
if [ ! -d "$certificatesDir" ]; then
    mkdir $certificatesDir
fi

installmentsDir="$DB/Installments"
if [ ! -d "$installmentsDir" ]; then
    mkdir $installmentsDir
fi

terminalsDir="$DB/Terminals"
if [ ! -d "$terminalsDir" ]; then
    mkdir $terminalsDir
fi

terminalsInfoDir="$DB/TerminalsInfo"
if [ ! -d "$terminalsInfoDir" ]; then
    mkdir $terminalsInfoDir
fi


insurancesDir="$DB/Insurances"
if [ ! -d "$insurancesDir" ]; then
    mkdir $insurancesDir
fi

insurancesInfoDir="$DB/Insurances/Info"
if [ ! -d "$insurancesInfoDir" ]; then
    mkdir $insurancesInfoDir
fi

insurancesTransactionsDir="$DB/Insurances/Transactions"
if [ ! -d "$insurancesTransactionsDir" ]; then
    mkdir $insurancesTransactionsDir
fi

generationDate=$(utl_getDate)
generationTime=$(utl_getTime)
file_userBank="$usersDir/bank.$DB_EXT"
file_userZus="$usersDir/zus.$DB_EXT"
file_userFoo="$usersDir/foo.$DB_EXT"
file_userBar="$usersDir/bar.$DB_EXT"
file_account000="$accountsDir/000.$DB_EXT"
file_account001="$accountsDir/001.$DB_EXT"
file_account002="$accountsDir/002.$DB_EXT"
file_account003="$accountsDir/003.$DB_EXT"
file_account004="$accountsDir/004.$DB_EXT"
file_account005="$accountsDir/005.$DB_EXT"
file_account006="$accountsDir/006.$DB_EXT"
file_account007="$accountsDir/007.$DB_EXT"
file_transaction0="$transactionsDir/000000.$DB_EXT"
file_transaction1="$transactionsDir/000001.$DB_EXT"
file_zusFoo="$fooReceiversDir/000.$DB_EXT"
file_zusBar="$barReceiversDir/000.$DB_EXT"
file_exchangeRates="$miscDir/exchangeRates.$DB_EXT"
file_installment000="$installmentsDir/000.$DB_EXT"
file_installment001="$installmentsDir/001.$DB_EXT"
file_termianalsWarsaw="$terminalsDir/Warszawa.$DB_EXT"
file_termianal000="$terminalsInfoDir/000.$DB_EXT"
file_termianal001="$terminalsInfoDir/001.$DB_EXT"
file_insurance000="$insurancesInfoDir/000.$DB_EXT"
file_insurance001="$insurancesInfoDir/001.$DB_EXT"
file_insurance002="$insurancesInfoDir/002.$DB_EXT"
file_insurance003="$insurancesInfoDir/003.$DB_EXT"
file_insurance004="$insurancesInfoDir/004.$DB_EXT"
file_insurance005="$insurancesInfoDir/005.$DB_EXT"
file_insurance006="$insurancesInfoDir/006.$DB_EXT"
file_insurance007="$insurancesInfoDir/007.$DB_EXT"
file_insurance008="$insurancesInfoDir/008.$DB_EXT"
file_insurance009="$insurancesInfoDir/009.$DB_EXT"

touch $file_userBank
touch $file_userFoo
touch $file_userBar
touch $file_account000
touch $file_account001
touch $file_account002
touch $file_account003
touch $file_account004
touch $file_account005
touch $file_account006
touch $file_account007
touch $file_transaction0
touch $file_transaction1
touch $file_exchangeRates
touch $file_installment000
touch $file_installment001
touch $file_termianalsWarsaw
touch $file_termianal000
touch $file_termianal001
touch $file_insurance000
touch $file_insurance001
touch $file_insurance002
touch $file_insurance003
touch $file_insurance004
touch $file_insurance005
touch $file_insurance006
touch $file_insurance007
touch $file_insurance008
touch $file_insurance009

echo "{" > $file_userBank
echo "    \"password\": \"1234\"," >> $file_userBank
echo "    \"accountsID\": [\"000\",\"001\"]," >> $file_userBank
echo "    \"virtualAccountsID\": []," >> $file_userBank
echo "    \"insurancesID\": []," >> $file_userBank
echo "    \"phonesID\": []," >> $file_userBank
echo "    \"loansID\": []," >> $file_userBank
echo "    \"standingOrdersID\": []," >> $file_userBank
echo "    \"installmentsID\": []," >> $file_userBank
echo "    \"firstname\": \"Kasperski\"," >> $file_userBank
echo "    \"lastname\": \"Bank\"," >> $file_userBank
echo "    \"pesel\": \"000\"," >> $file_userBank
echo "    \"city\": \"Warszawa\"," >> $file_userBank
echo "    \"street\": \"Słoneczna\"," >> $file_userBank
echo "    \"streetNumber\": \"1\"," >> $file_userBank
echo "    \"phoneNumber\": \"+4879012344" >> $file_userBank
echo "}" >> $file_userBank

echo "{" > $file_userZus
echo "    \"password\": \"1234\"," >> $file_userZus
echo "    \"accountsID\": [\"002\",\"003\"]," >> $file_userZus
echo "    \"virtualAccountsID\": []," >> $file_userZus
echo "    \"insurancesID\": []," >> $file_userZus
echo "    \"phonesID\": []," >> $file_userZus
echo "    \"loansID\": []," >> $file_userZus
echo "    \"standingOrdersID\": []," >> $file_userZus
echo "    \"installmentsID\": []," >> $file_userZus
echo "    \"firstname\": \"Konto\"," >> $file_userZus
echo "    \"lastname\": \"ZUS\"," >> $file_userZus
echo "    \"pesel\": \"000\"," >> $file_userZus
echo "    \"city\": \"Warszawa\"," >> $file_userZus
echo "    \"street\": \"Senatorska\"," >> $file_userZus
echo "    \"streetNumber\": \"6\"," >> $file_userZus
echo "    \"phoneNumber\": \"+4879012300" >> $file_userZus
echo "}" >> $file_userZus

echo "{" > $file_userFoo
echo "    \"password\": \"1234\"," >> $file_userFoo
echo "    \"accountsID\": [\"004\",\"005\"]," >> $file_userFoo
echo "    \"virtualAccountsID\": []," >> $file_userFoo
echo "    \"insurancesID\": []," >> $file_userFoo
echo "    \"phonesID\": []," >> $file_userFoo
echo "    \"loansID\": []," >> $file_userFoo
echo "    \"standingOrdersID\": []," >> $file_userFoo
echo "    \"installmentsID\": [\"000\",\"001\"]," >> $file_userFoo
echo "    \"firstname\": \"John\"," >> $file_userFoo
echo "    \"lastname\": \"Foo\"," >> $file_userFoo
echo "    \"pesel\": \"001\"," >> $file_userFoo
echo "    \"city\": \"Warszawa\"," >> $file_userFoo
echo "    \"street\": \"Słoneczna\"," >> $file_userFoo
echo "    \"streetNumber\": \"42\"," >> $file_userFoo
echo "    \"phoneNumber\": \"+48790123456\"" >> $file_userFoo
echo "}" >> $file_userFoo

echo "{" > $file_userBar
echo "    \"password\": \"1234\"," >> $file_userBar
echo "    \"accountsID\": [\"006\",\"007\"]," >> $file_userBar
echo "    \"virtualAccountsID\": []," >> $file_userBar
echo "    \"insurancesID\": []," >> $file_userBar
echo "    \"phonesID\": []," >> $file_userBar
echo "    \"loansID\": []," >> $file_userBar
echo "    \"standingOrdersID\": []," >> $file_userBar
echo "    \"installmentsID\": []," >> $file_userBar
echo "    \"firstname\": \"Jan\"," >> $file_userBar
echo "    \"lastname\": \"Bar\"," >> $file_userBar
echo "    \"pesel\": \"002\"," >> $file_userBar
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
echo "   \"balance\": \"1000000\"," >> $file_account002
echo "   \"type\": \"checking\"," >> $file_account002
echo "   \"transactionsID\": []," >> $file_account002
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
echo "   \"transactionsID\": [\"000000\"]," >> $file_account004
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

echo "{" > $file_account006
echo "   \"balance\": \"100000\"," >> $file_account006
echo "   \"type\": \"checking\"," >> $file_account006
echo "   \"transactionsID\": [\"000001\"]," >> $file_account006
echo "   \"cardsID\": []," >> $file_account006
echo "   \"currency\": \"PLN\"" >> $file_account006
echo "}" >> $file_account006

echo "{" > $file_account007
echo "   \"balance\": \"0\"," >> $file_account007
echo "   \"type\": \"saving\"," >> $file_account007
echo "   \"transactionsID\": []," >> $file_account007
echo "   \"cardsID\": []," >> $file_account007
echo "   \"currency\": \"PLN\"" >> $file_account007
echo "}" >> $file_account007


echo "{" > $file_transaction0
echo "  \"virtual\": \"false\"," >> $file_transaction0
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
echo "  \"targetAccountID\": \"004\"," >> $file_transaction0
echo "  \"targetName\": \"John Foo\"" >> $file_transaction0
echo "}" >> $file_transaction0

echo "{" > $file_transaction1
echo "  \"virtual\": \"false\"," >> $file_transaction1
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
echo "  \"targetAccountID\": \"006\"," >> $file_transaction1
echo "  \"targetName\": \"Jan Bar\"" >> $file_transaction1
echo "}" >> $file_transaction1


echo "{" > $file_zusFoo
echo "  \"name\": \"ZUS\"," >> $file_zusFoo
echo "  \"address\": \"ul. Senatorska 6, Warszawa\"," >> $file_zusFoo
echo "  \"accountID\": \"002\"," >> $file_zusFoo
echo "  \"hidden\": \"false\"" >> $file_zusFoo
echo "}" >> $file_zusFoo

echo "{" > $file_zusBar
echo "  \"name\": \"ZUS\"," >> $file_zusBar
echo "  \"address\": \"ul. Senatorska 6, Warszawa\"," >> $file_zusBar
echo "  \"accountID\": \"002\"," >> $file_zusBar
echo "  \"hidden\": \"false\"" >> $file_zusBar
echo "}" >> $file_zusBar


echo -e "{" > $file_exchangeRates
echo -e "\t\"PLN\": \"1\"," >> $file_exchangeRates
echo -e "\t\"USD\": \"3.7838\"," >> $file_exchangeRates
echo -e "\t\"EUR\": \"4.2901\"," >> $file_exchangeRates
echo -e "\t\"CHF\": \"3.7535\"," >> $file_exchangeRates
echo -e "\t\"GBP\": \"4.9221\"," >> $file_exchangeRates
echo -e "\t\"AUD\": \"2.7401\"," >> $file_exchangeRates
echo -e "\t\"UAH\": \"0.1358\"," >> $file_exchangeRates
echo -e "\t\"CZK\": \"0.1653\"," >> $file_exchangeRates
echo -e "\t\"HRK\": \"0.5774\"," >> $file_exchangeRates
echo -e "\t\"RUB\": \"0.0565\"" >> $file_exchangeRates
echo -e "}" >> $file_exchangeRates


echo -e "{" > $file_installment000
echo -e "\t\"name\": \"Telewizor\"," >> $file_installment000
echo -e "\t\"location\": \"MediaSklep\"," >> $file_installment000
echo -e "\t\"date\": \"2018-10-12\"," >> $file_installment000
echo -e "\t\"nInstallments\": \"12\"," >> $file_installment000
echo -e "\t\"installment\": \"35000\"," >> $file_installment000
echo -e "\t\"period\": \"1\"," >> $file_installment000
echo -e "\t\"totalSum\": \"400000\"," >> $file_installment000
echo -e "\t\"currency\": \"PLN\"" >> $file_installment000
echo -e "}" >> $file_installment000

echo -e "{" > $file_installment001
echo -e "\t\"name\": \"Nvidia RTX 2080\"," >> $file_installment001
echo -e "\t\"location\": \"GamerShop\"," >> $file_installment001
echo -e "\t\"date\": \"2018-11-18\"," >> $file_installment001
echo -e "\t\"nInstallments\": \"12\"," >> $file_installment001
echo -e "\t\"installment\": \"45000\"," >> $file_installment001
echo -e "\t\"period\": \"1\"," >> $file_installment001
echo -e "\t\"totalSum\": \"500000\"," >> $file_installment001
echo -e "\t\"currency\": \"PLN\"" >> $file_installment001
echo -e "}" >> $file_installment001


echo -e "{" > $file_termianalsWarsaw
echo -e "\t\"terminalsID\": [\"000\", \"001\"]" >> $file_termianalsWarsaw
echo -e "}" >> $file_termianalsWarsaw

echo -e "{" > $file_termianal000
echo -e "\t\"name\": \"Terminal X\"," >> $file_termianal000
echo -e "\t\"city\": \"Warszawa\"," >> $file_termianal000
echo -e "\t\"street\": \"ul. Słoneczna\"," >> $file_termianal000
echo -e "\t\"streetNumber\": \"4\"" >> $file_termianal000
echo -e "}" >> $file_termianal000

echo -e "{" > $file_termianal001
echo -e "\t\"name\": \"Terminal Y\"," >> $file_termianal001
echo -e "\t\"city\": \"Warszawa\"," >> $file_termianal001
echo -e "\t\"street\": \"ul. Spacerowa\"," >> $file_termianal001
echo -e "\t\"streetNumber\": \"2\"" >> $file_termianal001
echo -e "}" >> $file_termianal001

echo -e "{" > $file_insurance000
echo -e "\t\"name\": \"Ubezpieczenie od utraty pracy\"," >> $file_insurance000
echo -e "\t\"cost\": \"10000\"" >> $file_insurance000
echo -e "}" >> $file_insurance000

echo -e "{" > $file_insurance001
echo -e "\t\"name\": \"Ubezpieczenie od śmierci\"," >> $file_insurance001
echo -e "\t\"cost\": \"10000\"" >> $file_insurance001
echo -e "}" >> $file_insurance001

echo -e "{" > $file_insurance002
echo -e "\t\"name\": \"Ubezpieczenie od wypadku\"," >> $file_insurance002
echo -e "\t\"cost\": \"10000\"" >> $file_insurance002
echo -e "}" >> $file_insurance002

echo -e "{" > $file_insurance003
echo -e "\t\"name\": \"Ubezpieczenie od utraty dochodu\"," >> $file_insurance003
echo -e "\t\"cost\": \"10000\"" >> $file_insurance003
echo -e "}" >> $file_insurance003

echo -e "{" > $file_insurance004
echo -e "\t\"name\": \"Ubezpieczenie od ognia i innych ryzyk\"," >> $file_insurance004
echo -e "\t\"cost\": \"10000\"" >> $file_insurance004
echo -e "}" >> $file_insurance004

echo -e "{" > $file_insurance005
echo -e "\t\"name\": \"Ubezpieczenie auta od kradzieży\"," >> $file_insurance005
echo -e "\t\"cost\": \"10000\"" >> $file_insurance005
echo -e "}" >> $file_insurance005

echo -e "{" > $file_insurance006
echo -e "\t\"name\": \"Ubezpieczenie od żywiołów\"," >> $file_insurance006
echo -e "\t\"cost\": \"10000\"" >> $file_insurance006
echo -e "}" >> $file_insurance006

echo -e "{" > $file_insurance007
echo -e "\t\"name\": \"Ubezpieczenie od odwołanego lotu\"," >> $file_insurance007
echo -e "\t\"cost\": \"10000\"" >> $file_insurance007
echo -e "}" >> $file_insurance007

echo -e "{" > $file_insurance008
echo -e "\t\"name\": \"Ubezpieczenie od wszystkich ryzyk\"," >> $file_insurance008
echo -e "\t\"cost\": \"10000\"" >> $file_insurance008
echo -e "}" >> $file_insurance008

echo -e "{" > $file_insurance009
echo -e "\t\"name\": \"Ubezpieczenie od powodzi\"," >> $file_insurance009
echo -e "\t\"cost\": \"10000\"" >> $file_insurance009
echo -e "}" >> $file_insurance009
