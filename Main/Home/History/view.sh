#!/bin/bash
hist_title="HISTORIA"
hist_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$hist_dir" ]]; then hist_dir="$PWD"; fi

. $hist_dir/controller.sh



hist_show() {
    local action

    ui_header $home_title $hist_title
    hist_printList && echo ""
    __hist_showMenu && echo ""
    ui_line
    read -p "Wybierz akcję: " action

    case $action in
        "1") hist_export;;
        *) home_skipPause=true;;
    esac

    return 0
}


__hist_showMenu() {
    echo "1 - Eksportuj"
    echo "0 - Powrót"

    return 0
}