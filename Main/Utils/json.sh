#!/bin/bash



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