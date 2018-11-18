#!/bin/bash


ofrSvg_show() {
    ui_header "$ofr_title" "OSZCZĘDNOŚCI"

    _ofrSvg_showList
    echo ""
    
    # menu
    echo "1 - Kalkulator oszczędności"
    echo "0 - Powrót"
    echo ""
    ui_line
    read -p "Wybierz akcję: " action
    if [ "$action" != "1" ]; then
        home_skipPause=true
        return 0
    fi
    
    _ofrSvg_calculate
    
    echo ""
    return 0
}


_ofrSvg_showList() {
    # get accounts
    local accounts=$(db_getUserAccounts)
        if [ "${accounts[@]}" != "" ]; then
        # print saving accounts
        echo "Konta oszczędnościowe:"
        for i in ${accounts[@]}; do
            local type=$(db_get "type" "$i.$DB_EXT" "Accounts")
            if [ "$type" == "saving" ]; then
                local balance=$(db_get "balance" "$i.$DB_EXT" "Accounts") 
                local currency=$(db_get "currency" "$i.$DB_EXT" "Accounts")
                balance=$(echo "scale=2;$balance/100" | bc | sed "s/^\./0./")
                ui_alignRight "$i" "$balance $currency" "s" "s" && echo ""
            fi
        done
    fi


    # get virtual accounts
    local virtualAccounts=$(utl_parseToArray $(db_get "virtualAccountsID" "$USERNAME.$DB_EXT" "Users" true))
    if [ "${virtualAccounts[@]}" != "" ]; then
        echo ""
        echo "Cele oszczędnościowe:"
        # print virtual accounts
        
        for i in ${virtualAccounts[@]}; do
            local name=$(db_get "name" "$i.$DB_EXT" "VirtualAccounts")
            local balance=$(db_get "balance" "$i.$DB_EXT" "VirtualAccounts")
            local currency=$(db_get "currency" "$i.$DB_EXT" "VirtualAccounts")
            ui_alignRight "$i" "$balance $currency" "s" "s" && echo ""
        done
    fi


    if [ "${accounts[@]}" == "" ] && [ "${virtualAccounts[@]}" == "" ]; then
        echo "Brak oszczędności."
    fi

    return 0
}


_ofrSvg_calculate() {
    ui_header "OSZCZĘDNOŚCI" "KALKULATOR"

    # extract data from user: targetSum, monthlySum
    local targetSum
    local monthlySum

    read -p "Kwota docelowa [PLN]: " targetSum
    targetSum=$(echo $targetSum | tr "," ".")
    targetSum=$(echo "scale=0;($targetSum*100)/1" | bc)

    read -p "Miesięczna składka [PLN]: " monthlySum
    monthlySum=$(echo $monthlySum | tr "," ".")
    monthlySum=$(echo "scale=0;($monthlySum*100)/1" | bc)

    local months=$(echo "scale=0;$targetSum/$monthlySum" | bc)
    ((months++))

    echo ""
    echo "Czas oszczędzania: $months miesięcy"

    return 0
}