#!/bin/bash

ofrLsg_show() {
    local ofrLsg_title="LEASING"

    ui_form "$ofr_title" "$ofrLsg_title"\
        2 "Lista" "Wniosek o leasing"\
        2 _ofrLsg_list _ofrLsg_new

    return 0
}


_ofrLsg_list() {
    # get users loans
    local loans=$(utl_parseToArray $(db_get "loansID" "$USERNAME.$DB_EXT" "Users" true))

    ui_header "$ofrLsg_title" "LISTA"

    if [ -z "${loans[@]}" ]; then
        echo "Brak niespłaconych leasingów."
        echo ""
        return 0
    fi

    # loop through loans and echo only ones with type == POŻYCZKA | KREDYT
    for i in ${loans[@]}; do
        if [ "$(db_get "type" "$i.$DB_EXT" "Loans")" == "LEASING" ]; then
            local type="$(db_get "type" "$i.$DB_EXT" "Loans")"
            local loanDate="$(db_get "date" "$i.$DB_EXT" "Loans")"
            local bank="$(db_get "bank" "$i.$DB_EXT" "Loans")"
            local location="$(db_get "location" "$i.$DB_EXT" "Loans")"
            local paid="$(db_get "paidSum" "$i.$DB_EXT" "Loans")"
            local toBePaid="$(db_get "expectedSum" "$i.$DB_EXT" "Loans")"
            local currency="$(db_get "currency" "$i.$DB_EXT" "Loans")"
            local goal="$(db_get "goal" "$i.$DB_EXT" "Loans")"
            

            ui_alignRight "$type: $goal" "$paid / $toBePaid $currency" "s" "s" && echo ""
            echo "$loanDate | $bank - $location"
            echo ""
        fi
    done
        
        
    return 0
}


_ofrLsg_new() {
    db_loanMoney "LEASING" "$ofrLsg_title" "WNIOSEK O LEASING" "1.09" "Kasperski Bank" false true true true
    return 0
}