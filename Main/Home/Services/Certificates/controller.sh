#!/bin/bash


__servCer_showList() {
    ui_header "$servCer_title" "EDYCJA"

    # if ! -d usersDir; report & exit
    if [ ! -d "$DB/Certificates/$USERNAME" ] ; then
        echo "Brak zaświadczeń."
        echo ""
        return 0
    fi

    # get files
    local _certs=$(db_getFiles "Certificates/$USERNAME")

    # if no files
    if [ "${_certs[@]}" == "" ] ; then
        echo "Brak zaświadczeń."
        echo ""
        return 0
    fi

    # print files' names and store in numeric array
    local certs=()
    local certsIndex=1
    for i in ${_certs[@]}; do
        echo "$certsIndex - $i"
        certs+=("$i")
        ((certsIndex++))
    done
    echo "0 - Powrót"
    echo ""
    ui_line

    # handle input
    read -p "Wybierz plik do edycji: " certsIndex
    
    if [ "$certsIndex" == "0" ]; then
        home_skipPause=true
        return 1
    fi
    ((certsIndex--))

    # open in vi
    vi "$DB/Certificates/$USERNAME/${certs[$certsIndex]}"

    # feedback
    ui_header "$servCer_title" "EDYCJA"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0
}


__servCer_add() {
    ui_header "$servCer_title" "DODAJ"

    # extract data from user: filename
    local filename
    read -p "Nazwa nowego pliku: " filename

    # if ! -d usersDir; create
    if [ ! -d "$DB/Certificates/$USERNAME" ]; then
        mkdir "$DB/Certificates/$USERNAME"
    fi

    # if file exists; error
    if [ -f "$DB/Certificates/$USERNAME/$filename.txt" ]; then
        ui_header "$servCer_title" "DODAJ"
        printf "$RED"
        echo "Dokument o podanej nazwie już istnieje."
        printf "$DEFAULT_COLOR"
        echo ""
        return 0
    fi
    
    vi "$DB/Certificates/$USERNAME/$filename.txt"

    ui_header "$servCer_title" "DODAJ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0
}


__servCer_delete() {
    ui_header "$servCer_title" "USUŃ"

    # if ! -d usersDir; report & exit
    if [ ! -d "$DB/Certificates/$USERNAME" ] ; then
        echo "Brak zaświadczeń."
        echo ""
        return 0
    fi

    # get files
    local _certs=$(db_getFiles "Certificates/$USERNAME")

    # if no files
    if [ "${_certs[@]}" == "" ] ; then
        echo "Brak zaświadczeń."
        echo ""
        return 0
    fi

    # print files' names and store in numeric array
    local certs=()
    local certsIndex=1
    for i in ${_certs[@]}; do
        echo "$certsIndex - $i"
        certs+=("$i")
        ((certsIndex++))
    done
    echo "0 - Powrót"
    echo ""
    ui_line

    # handle input
    read -p "Wybierz plik do usunięcia: " certsIndex
    
    if [ "$certsIndex" == "0" ]; then
        home_skipPause=true
        return 1
    fi
    ((certsIndex--))

    # remove in vi
    rm "$DB/Certificates/$USERNAME/${certs[$certsIndex]}"

    # feedback
    ui_header "$servCer_title" "USUŃ"
    echo "Operacja zakończyła się powodzeniem."
    echo ""
    return 0

    return 0
}