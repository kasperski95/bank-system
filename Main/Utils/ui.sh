#!/bin/bash




ui_line() {
    local i=0
    while [ $i -lt $WIDTH ]; do
        printf "—"
        ((i++))
    done
    echo "" 
    return 0
}

ui_header() {
    clear
    if [ -z ${2+x} ]; then
        printf "%s" "$1"
    elif [ ! -z ${2+x} ] && [ -z ${3+x} ]; then
        local str1="$1"
        local str2="$2" 
        printf "%s -> %s" "$str1" "$str2"
    elif [ ! -z ${2+x} ] && [ ! -z ${3+x} ]; then
        ui_alignRight "$1" "$3" "s" "s"
    fi

    echo ""
    ui_line
    echo ""

    return 0
}


ui_alignRight() {
    if [ -z ${3+x} ]; then
        local str="$1"
        local format="$2"
        local padding=$((WIDTH-1))
        printf "%${padding}${format}" $str
    else
        local str1="$1"
        local str2="$2"
        local format1="$3"
        local format2="$4"
        local offsetLeft="0"
        if [ ! -z ${5+x} ]; then
            local offsetLeft="$5"
        fi
        local padding=$((WIDTH-${#1}-1-offsetLeft))
        printf "%${format1} %${padding}${format2}" "${str1}" "${str2}"
    fi
    return 0
}


ui_form() {
    local title1="$1" && shift 1
    local title2="$1"  && shift 1

    local menuSize="$1" && shift 1
    local menuLabels=( "${@:1:$menuSize}" ); shift $menuSize

    local handlersSize="$1" && shift 1
    local handlers=( ${@:1:$handlersSize} ); shift $handlersSize

    if [ "$handlersSize" == 1 ]; then
        local nArgsHandler="$1" && shift 1
        local argsHandler=( ${@:1:$nArgsHandler} ); shift $nArgsHandler
    fi

    if [ "$#" -gt "0" ]; then
        local toExecute=$1 && shift 1
    
        if [ "$#" -gt "0" ]; then
            local nArgs="$1" && shift 1
            local args=( "${@:1:$nArgs}" ); shift $nArgs
        else
            local args=""
        fi
    fi


    # clear & show header
    ui_header "$title1" "$title2"
    

    # do some stuff before menu appears
    if [ -n ${toExecute+x} ]; then
        $toExecute ${args[@]}
    fi


    # display menu
    local label
    local index=0
    while [ "$index" -lt "$menuSize" ]; do
        ((index++))
        echo "$index - ${menuLabels[$((index-1))]}"
    done
    echo "0 - Powrót"
    echo ""
    ui_line

    # handle input
    read -p "Wybierz akcję: " index
    ((index--))

    if [ "$index" -eq "-1" ]; then
        return 1
    fi

    if [ "$handlersSize" -eq "0" ]; then
        return 0
    elif [ "$handlersSize" -eq "1" ]; then
        ${handlers[0]} $index ${argsHandler[@]}
    else
        ${handlers[$index]}
    fi

    return 0
}