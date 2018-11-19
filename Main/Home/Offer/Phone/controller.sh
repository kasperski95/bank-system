#!/bin/bash
ofrPho_title="KARTY I PŁATNOŚCI TELEFONEM"


ofrPho_show() {
    local handlers=(_handleNewCard _handleNewBinding _handleBindingList)

    if ! ui_form "$ofr_title" "$ofrPho_title"\
        3 "Nowa karta" "Powiązanie telefonu z usługą BLIK" "Lista powiązanych telefonów"\
        ${#handlers[@]} ${handlers[@]}
    then
        home_skipPause=true
        return 1
    fi

}


_handleNewCard () {
    local title="NOWA KARTA"
    ui_header "$ofrPho_title" "$title"

    # get account type
    local cardTypes=("Karta debetowa" "Karta kredytowa")
    local cardTypeIndex
    echo "1 - Karta debetowa"
    echo "2 - Karta kredytowa"
    echo "0 - Powrót"
    echo ""
    ui_line
    read -p "Wybierz akcję: " cardTypeIndex
    
    ((cardTypeIndex--))

    # choose account to which card should be binded
    ui_header "$ofrPho_title" "$title"
    local _accounts=$(db_getUserAccounts)
    local accountIndex=1
    local accounts=()
    for i in ${_accounts[@]}; do
        if [ "$(db_getAccountsType $i)" == "checking" ]; then
            accounts+=("$i")
            echo "$accountIndex - $i"
            ((accountIndex++))
        fi
    done
    echo "0 - Powrót"
    echo ""
    ui_line
    read -p "Wybierz akcję: " accountIndex
    ((accountIndex--))


    # create card
    local fileDir="$DB/Cards"
    local fileID=$(utl_getNextIndex "$fileDir" "13")
    local file="$(echo $fileDir/$fileID.$DB_EXT)"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"cardType\": \"${cardTypes[$cardTypeIndex]}\"," >> $file
    echo -e "\t\"accountID\": \"${accounts[$accountIndex]}\"" >> $file
    echo -e "}" >> $file

    # add cardID to account
    db_add "cardsID" "$fileID" "${accounts[$accountIndex]}.$DB_EXT" "Accounts"

    ui_header "$ofrPho_title" "$title"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0
}


_handleNewBinding () {
    local ofrPhoNbtitle="POWIĄZANIE"
    local phoneNumber
    local _accounts=$(db_getUserAccounts)
    local accounts=()
    local accountIndex=1

    # enter phone number
    ui_header "$ofrPho_title" "$ofrPhoNbtitle"
    read -p "Numer telefonu: " phoneNumber

    while [[ ! "$phoneNumber" =~ [0-9]{9} ]]; do
        ui_header "$ofrPho_title" "$ofrPhoNbtitle"
        echo "Niepoprawny numer telefonu."
        echo ""
        read -p "Numer telefonu: " phoneNumber
    done

    echo "<wysyłanie kodu potwierdzającego (123456)>"
    read -p "Podaj kod potwierdzający: " code

    if [ "$code" != "123456" ]; then
        echo "Nieprawidłowy kod aktywujący."
        echo ""
        return 1
    fi

    # choose account
    ui_header "$ofrPho_title" "$ofrPhoNbtitle"
    
    for i in ${_accounts[@]}; do
        if [ "$(db_getAccountsType $i)" == "checking" ]; then
            accounts+=("$i")
            echo "$accountIndex - $i"
            ((accountIndex++))
        fi
    done
    echo ""
    ui_line
    read -p "Wybierz rachunek: " accountIndex
    ((accountIndex--))

    # create binding file
    local fileDir="$DB/Phones"
    local fileID="$phoneNumber"
    local file="$(echo $fileDir/$fileID.$DB_EXT)"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"accountID\": \"${accounts[$accountIndex]}\"" >> $file
    echo -e "}" >> $file

    # add to user
    db_add "phonesID" "$phoneNumber" "$USERNAME.$DB_EXT" "Users"

    # feedback
    ui_header "$ofrPho_title" "$ofrPhoNbtitle"
    echo "Operacja zakończyła się powodzeniem."
    echo ""

    return 0
}


_handleBindingList () {
    ui_header "$ofrPho_title" "LISTA POWIĄZAŃ"

    # get array of bindings
    phonesID=$(utl_parseToArray $(db_get "phonesID" "$USERNAME.$DB_EXT" "Users" true))

    if [ "${phonesID[@]}" == "" ]; then
        echo "Brak powiązanych telefonów."
        echo ""
        return 0
    fi

    # print: <phone number> ~> <accountID>
    for i in ${phonesID[@]}; do
        local accountID=$(db_get "accountID" "$i.$DB_EXT" "Phones")
        local protectedPhone=$(echo $i | sed "s/.\{6\}$/******/")
        echo "$protectedPhone <~> $accountID"
    done
    echo ""

    return 0
}
