#!/bin/bash


dbReceivers_get() {
    local key=$1
    local receiverID=$2

    if [ -f $USERS_FILE ]; then
        utl_getFromJson $key "$(dbReceivers_getPath)/$receiverID"
        return 0
    fi
    return 1
}


dbReceivers_set() {
    #FIXME: last property
    #FIXME: " and arrays
    local key=$1
    local val=$2
    local receiverID=$3

    if [ -f $USERS_FILE ]; then
        sed -i "s/\($key\":\).*$/\1 $val,/" "$(dbReceivers_getPath)/$receiverID"
        return $?
    fi
    return 1
}


dbReceivers_getPath() {
    echo "$DB/Receivers/$USERNAME"
}

db_getReceivers() {
    ls "$(dbReceivers_getPath)"
    return 0
}


db_createReceiver() {
    local file="$(dbReceivers_getPath)/$(utl_getNextIndex "$(dbReceivers_getPath)" "3").$DB_EXT"
    touch $file
    echo -e "{" > $file
    echo -e "\t\"name\": \"$1\"," >> $file
    echo -e "\t\"address\": \"$2\"," >> $file
    echo -e "\t\"accountID\": \"$3\"," >> $file
    echo -e "\t\"hidden\": \"$4\"" >> $file
    echo -e "}" >> $file

    return 0
}


db_removeReceiver() {
    rm "$(dbReceivers_getPath)/$1.DB_EXT"
}

db_receiversExists() {
    if [ "$(ls -A "$(dbReceivers_getPath)")" ]; then
        return 0
    else
        return 1
    fi
}

db_getReceiversNames() {
    if (db_receiversExists); then
        for i in "$(dbReceivers_getPath)/*.$DB_EXT"; do
            echo $(utl_getFromJson "name" "$i")
        done
    fi

    return 0
}