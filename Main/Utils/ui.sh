#!/bin/bash

ui_printLine() {
    local i=0
    while [ $i -lt $WIDTH ]; do
        printf "—"
        ((i++))
    done
    echo "" 
}

ui_printHeader() {
    clear
    echo "$1"
    ui_printLine
    echo ""
}