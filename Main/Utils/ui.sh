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
        printf "%s" $1
    elif [ ! -z ${2+x} ] && [ -z ${3+x} ]; then
        printf "%s -> %s" $1 $2 
    elif [ ! -z ${2+x} ] && [ ! -z ${3+x} ]; then
        printf "%s \t %s" $1 $3 
    fi

    echo ""
    ui_line
    echo ""

    return 0
}