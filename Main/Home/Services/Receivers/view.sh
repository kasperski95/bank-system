#!/bin/bash
servRec_title="ODBIORCY"
servRec_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$servRec_dir" ]]; then servRec_dir="$PWD"; fi

. $servRec_dir/../../../Database/receivers.sh
. $servRec_dir/controller.sh



servRec_show() {
    local action

    ui_header "$serv_title" "$servRec_title"
    __servRec_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action
    __servRec_handleAction $action

    return 0
}


__servRec_showMenu() {
    if (db_receiversExists); then
        local receiversFilesRaw=$(db_getReceivers)
        local receiversFiles=()
        local j=1
        for i in ${receiversFilesRaw[@]}; do
            local name=$(utl_getFromJson "name" "$(dbReceivers_getPath)/$i")
            local accountID=$(utl_getFromJson "accountID" "$(dbReceivers_getPath)/$i")
            ui_alignRight "$name" "$accountID" "s" "s" && echo ""
            receiversFiles+=("$i")
        done
        echo ""
    fi
    echo "1 - Dodaj"
    if (db_receiversExists); then
        echo "2 - Usuń"
    fi
    echo "0 - Powrót"

    return 0
}


__servRec_handleAction() {
    case $1 in
        "1") __servRec_add;;
        "2") __servRec_delete;;
        *) home_skipPause=true
    esac

    return 0
}



