#!/bin/bash


__servDoc_showList() {
    ui_header "$servDoc_title" "EDYCJA"

    # if ! -d usersDir; report & exit
    if [ ! -d "$DB/Documents/$USERNAME" ] ; then
        echo "Brak dokumentów."
        echo ""
        return 0
    fi

    # get files
    local _docs=$(db_getFiles "Documents/$USERNAME")

    # if no files
    if [ "${_docs[@]}" == "" ] ; then
        echo "Brak dokumentów."
        echo ""
        return 0
    fi

    # print files' names and store in numeric array
    local docs=()
    local docsIndex=1
    for i in ${_docs[@]}; do
        echo "$docsIndex - $i"
        docs+=("$i")
        ((docsIndex++))
    done
    echo "0 - Powrót"
    echo ""
    ui_line

    # handle input
    read -p "Wybierz plik do edycji: " docsIndex
    
    if [ "$docsIndex" == "0" ]; then
        home_skipPause=true
        return 1
    fi
    ((docsIndex--))

    # open in vi
    vi "$DB/Documents/$USERNAME/${docs[$docsIndex]}"

    # feedback
    ui_header "$servDoc_title" "EDYCJA"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0
}


__servDoc_add() {
    ui_header "$servDoc_title" "DODAJ"

    # extract data from user: filename
    local filename
    read -p "Nazwa nowego pliku: " filename

    # if ! -d usersDir; create
    if [ ! -d "$DB/Documents/$USERNAME" ]; then
        mkdir "$DB/Documents/$USERNAME"
    fi

    # if file exists; error
    if [ -f "$DB/Documents/$USERNAME/$filename.txt" ]; then
        ui_header "$servDoc_title" "DODAJ"
        printf "$RED"
        echo "Dokument o podanej nazwie już istnieje."
        printf "$DEFAULT_COLOR"
        echo ""
        return 0
    fi
    
    vi "$DB/Documents/$USERNAME/$filename.txt"

    ui_header "$servDoc_title" "DODAJ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0
}


__servDoc_delete() {
    ui_header "$servDoc_title" "USUŃ"

    # if ! -d usersDir; report & exit
    if [ ! -d "$DB/Documents/$USERNAME" ] ; then
        echo "Brak dokumentów."
        echo ""
        return 0
    fi

    # get files
    local _docs=$(db_getFiles "Documents/$USERNAME")

    # if no files
    if [ "${_docs[@]}" == "" ] ; then
        echo "Brak dokumentów."
        echo ""
        return 0
    fi

    # print files' names and store in numeric array
    local docs=()
    local docsIndex=1
    for i in ${_docs[@]}; do
        echo "$docsIndex - $i"
        docs+=("$i")
        ((docsIndex++))
    done
    echo "0 - Powrót"
    echo ""
    ui_line

    # handle input
    read -p "Wybierz plik do usunięcia: " docsIndex
    
    if [ "$docsIndex" == "0" ]; then
        home_skipPause=true
        return 1
    fi
    ((docsIndex--))

    # remove in vi
    rm "$DB/Documents/$USERNAME/${docs[$docsIndex]}"

    # feedback
    ui_header "$servDoc_title" "USUŃ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0

    return 0
}