#!/bin/bash



# JSON value extractor
utl_getFromJson() {
    local key=$1
    local file=$2
    grep -Po "\"$key\":[ ]*\"\K.+(?=\")" $file
    return $?
}