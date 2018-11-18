#!/bin/bash

utl_printMoney() {
    echo "scale=2;$1/100" | bc | sed "s/^\./0./"
}


# JSON value extractor
utl_getFromJson() {
    local key=$1
    local file=$2
    grep -Po "\"$key\":[ ]*\"\K.+(?=\")" $file
    return $?
}

# Array must be inline because of backtracing limit
utl_getRawArrayFromJson() {
    local key=$1
    local file=$2
    grep -Po "\"$key\": \[\K(.|\s)*(?=])" $file | tr -d ' '
    return $?
} 


utl_sort() {
    echo $@ | tr ' ' '\n' | sort
    return 0
}

utl_sortR() {
    echo $@ | tr ' ' '\n' | sort -r
    return 0
}

utl_removeDoubles() {
    local uniqueArray
    local prev=""
    for i in $@; do
        if [ "$prev" != "$i" ]; then
            uniqueArray+=("$i")
            prev=$i
        fi
    done
    echo ${uniqueArray[@]}
    return 0
}


utl_parseArrayToJson() {
    local result="["
    local i
    local j=1

    for i in $@; do 
        if [ $j -lt $# ]; then
            result="$result\"$i\","
        else
            result="$result\"$i\""
        fi
        ((j++))
    done
    result="$result]"
    
    echo $result
    return 0
}


utl_parseToArray() {
    IFS=','
    for i in $@; do 
        echo $i | sed 's/^.\(.*\).$/\1/'
    done
    IFS=' '
    return 0
}


utl_getNextIndex() {
    local path="$1"
    local length="$2"

    if [ -z "$(ls -A $path)" ]; then
        local newID=-1
    else
        local newID=$(ls $path | tail --lines=1 | grep -Po ".*(?=\.)")
    fi

    # remove 0 from the beginning because of octal bullshit
    newID=$(echo $newID | sed 's/^0*//')

    ((newID++))
    newID=$(printf "%0${length}d\n" $newID)

    echo "$newID"

    return 0
}