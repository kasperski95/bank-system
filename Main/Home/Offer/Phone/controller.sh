#!/bin/bash
ofrPho_title="KARTY I PŁATNOŚCI TELEFONEM"


ofrPho_show() {
    local handlers=(_handleNewCard _handleNewBinding _handleBindingList)

    ui_form "$ofr_title" "$ofrPho_title"\
        3 "Nowa karta" "Powiązanie telefonu z kartą" "Lista powiązań"\
        ${#handlers[@]} ${handlers[@]}
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
    local fileID=$(utl_getNextIndex "$fileDir" "3")
    local file="$(echo $fileDir/$fileID.$DB_EXT)"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"cardType\": \"${cardTypes[$cardTypeIndex]}\"," >> $file
    echo -e "\t\"accountID\": \"${accounts[$accountIndex]}\"" >> $file
    echo -e "}" >> $file

    # add cardID to account
    db_add "cardsID" "$fileID" "${accounts[$accountIndex]}.$DB_EXT" "Accounts"

    return 0
}

_handleNewBinding () {
    echo "test2"
    return 0
}

_handleBindingList () {
    echo "test3"
    return 0
}