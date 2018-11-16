#!/bin/bash


db_getFiles() {
    if [ "$(ls -A "$DB/$1")" ]; then
        ls "$DB/$1"
        return 0
    else
        return 1
    fi
}

db_getExchangeRate() {
    if [ -f $USERS_FILE ]; then
        utl_getFromJson "$1" "$DB/Misc/exchangeRates.$DB_EXT"
        return 0
    fi
    return 1
}

db_get() {
    local key=$1
    local file=$2
    local folder=$3

    if [ -z ${4+x} ]; then
        utl_getFromJson "$key" "$DB/$folder/$file"
    else
        # array
        utl_getRawArrayFromJson "$key" "$DB/$folder/$file"
    fi
    return 0
}


db_set() {
    #FIXME: last property
    local key=$1
    local val=$2
    local file=$3
    local folder=$4

    firstValueCharacter="$(echo $val | head -c 1)"

    if [ "$firstValueCharacter" == "[" ]; then
        sed -i "s/\($key\":\).*$/\1 $val,/" "$DB/$folder/$file"
    else
        sed -i "s/\($key\":\).*$/\1 \"$val\",/" "$DB/$folder/$file"
    fi

    return $?
}


db_add() {
    local key="$1"
    local value="$2"
    local file="$3"
    local dir="$4"

    # echo "key: $key"
    # echo "value: $value"
    # echo "file: $file"
    # echo "dir: $dir"
    # read x

    local array=$(utl_parseToArray $(utl_getRawArrayFromJson "$key" "$DB/$dir/$file"))
    
    array+=("$value")
    local arrayJson=$(utl_parseArrayToJson ${array[@]})
    db_set "$key" "$arrayJson" "$file" "$dir"

    return 0
}