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
    grep -Po "\"$key\": \[\K(.|\s)*(?=])" $file | tr -d '\n' | tr -d ' ' | tr -d '\t' | tr -d '\0'
    return $?
} 

utl_parseToArray() {
    IFS=','
    for i in $1; do 
        echo $i | sed 's/^.\(.*\).$/\1/'
    done
}