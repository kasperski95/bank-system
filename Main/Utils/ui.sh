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
        local str1=$(echo $1)
        local str2=$(echo $2) 
        echo "$str1 -> $str2"
    elif [ ! -z ${2+x} ] && [ ! -z ${3+x} ]; then
        ui_alignRight $1 $3 "s" "s"
    fi

    echo ""
    ui_line
    echo ""

    return 0
}


ui_alignRight() {
    if [ -z ${3+x} ]; then
        local str=$1
        local format=$2
        local padding=$((WIDTH-1))
        printf "%${padding}${format}" $str
    else
        local str1=$1
        local str2=$2
        local format1=$3
        local format2=$4
        local offsetLeft=0
        if [ ! -z ${5+x} ]; then
            local offsetLeft=$5
        fi
        local padding=$((WIDTH-${#1}-1-offsetLeft))
        printf "%${format1} %${padding}${format2}" $str1 $str2
    fi
    return 0
}