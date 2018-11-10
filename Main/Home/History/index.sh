#!/bin/bash
hist_title="HISTORIA"

hist_show() {
    local action

    ui_printHeader "$home_title -> $hist_title"
    __hist_printList && echo ""
    __hist_showMenu && echo ""
    ui_printLine
    read -p "Wybierz akcję: " action

    case $action in
        "1") __hist_export;;
        *) home_skipPause=true;;
    esac

    return 0
}


__hist_printList() {
    #TODO
    # (Data, numer konta, kwota, do kogo, możliwośd generowania .txt do katalogu Konto na pulpicie wraz z nazwą pliku 
    echo "TODO"
    return 0
}

__hist_showMenu() {
    echo "1 - Eksportuj do plików"
    echo "0 - Powrót"
    return 0
}

# Generate files
__hist_export() {
    ui_printHeader "$home_title -> $hist_title -> EKSPORT"
    echo -e "TODO\n"
    return 0
}


