#!/bin/bash

ofrTrm_show() {
    ui_header "$ofr_title" "TERMINALE PŁATNICZE"

    # get user's city
    local city=$(db_get "city" "$USERNAME.$DB_EXT" "Users")
    echo "Szukam w okolicy miasta: $city." && sleep 0.5 && ui_header "$ofr_title" "TERMINALE PŁATNICZE"
    echo "Szukam w okolicy miasta: $city.." && sleep 0.5 && ui_header "$ofr_title" "TERMINALE PŁATNICZE"
    echo "Szukam w okolicy miasta: $city..." && sleep 0.5 && ui_header "$ofr_title" "TERMINALE PŁATNICZE"

    # city not found
    if [ ! -f "$DB/Terminals/$city.$DB_EXT" ]; then
        echo "Nie znaleziono terminali w twojej okolicy."
        echo ""
        return 1
    fi

    # get terminals' names
    local terminalsID=$(utl_parseToArray $(db_get "terminalsID" "$city.$DB_EXT" "Terminals" true))

    # print all terminals: name ... address
    for i in ${terminalsID[@]}; do
        local name=$(db_get "name" "$i.$DB_EXT" "TerminalsInfo")
        local street=$(db_get "street" "$i.$DB_EXT" "TerminalsInfo")
        local streetNumber=$(db_get "streetNumber" "$i.$DB_EXT" "TerminalsInfo")
        ui_alignRight "$name" "$street $streetNumber" "s" "s"
        echo ""
    done

    echo ""
    return 0
}