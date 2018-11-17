#!/bin/bash

ofrCre_show() {
    local ofrCre_title="KREDYTY I POŻYCZKI"

    ui_form "$ofr_title" "$ofrCre_title"\
        2 "Lista" "Wniosek o kredyt"\
        2 _ofrCre_list _ofrCre_new

    return 0
}


_ofrCre_list() {
    # get users loans
    local loans=$(utl_parseToArray $(db_get "loansID" "$USERNAME.$DB_EXT" "Users" true))

    ui_header "$ofrCre_title" "LISTA"

    if [ -z "${loans[@]}" ]; then
        echo "Brak niespłaconych pożyczek / kredytów."
        echo ""
        return 0
    fi
    
    # loop through loans and echo only ones with type == POŻYCZKA | KREDYT
    for i in ${loans[@]}; do
        if [ "$(db_get "type" "$i.$DB_EXT" "Loans")" == "POŻYCZKA" ] || [ "$(db_get "type" "$i.$DB_EXT" "Loans")" == "KREDYT" ]; then
            local type="$(db_get "type" "$i.$DB_EXT" "Loans")"
            local loanDate="$(db_get "date" "$i.$DB_EXT" "Loans")"
            local bank="$(db_get "bank" "$i.$DB_EXT" "Loans")"
            local location="$(db_get "location" "$i.$DB_EXT" "Loans")"
            local paid="$(db_get "paidSum" "$i.$DB_EXT" "Loans")"
            local toBePaid="$(db_get "expectedSum" "$i.$DB_EXT" "Loans")"
            local currency="$(db_get "currency" "$i.$DB_EXT" "Loans")"
            local goal="$(db_get "goal" "$i.$DB_EXT" "Loans")"
            
            if [ -n "$goal" ]; then
                goal="na $goal"
            fi

            ui_alignRight "$type $goal" "$paid / $toBePaid $currency" "s" "s" && echo ""
            echo "$loanDate | $bank - $location"
            echo ""
        fi
    done
        
        
    return 0
}


_ofrCre_new() {
    db_loanMoney "KREDYT" "$ofrCre_title" "WNIOSEK O KREDYT" "1.06" "Kasperski Bank" true true true true
    return 0
}