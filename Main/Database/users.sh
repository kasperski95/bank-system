#!/bin/bash


# check if DB is set and exists
if [ -z ${DB+x} ] || [ ! -d $DB ]; then
    echo -e "$RED"
    echo "FATAL ERROR: Cannot find databse"
    echo ""
    exit 1
fi


db_getUser() {
    local login=$1
    local password=$2

    if [ -f "$DB/Users/$login.$DB_EXT" ]; then
        local db_password=$(utl_getFromJson "password" "$DB/Users/$login.$DB_EXT")

        if [ "$password" == "$db_password" ]; then
            return 0
        fi
    fi
    
    return 1
}


db_getUserAccounts() {
    local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
    echo $accounts
    return 0
}

db_isUsersAccount() {
    local accountID=$1
    local accounts=$(db_getUserAccounts)

    for i in ${accounts[@]}; do
        if [ "$accountID" == "$i" ]; then
            echo "true"
            return 0
        fi
    done;

    echo "false"
    return 1
}

db_addAccount() {
    local accountID=$1
    local accounts=$(utl_parseToArray $(utl_getRawArrayFromJson "accountsID" $USERS_FILE))
    
    accounts+=($accountID)
    local accountsJson=$(utl_parseArrayToJson ${accounts[@]})
    dbUsers_set "accountsID" $accountsJson

    return 0
}


dbUsers_get() {
    local key=$1
    if [ -f $USERS_FILE ]; then
        utl_getFromJson $key $USERS_FILE
        return 0
    fi
    return 1
}


dbUsers_set() {
    #FIXME: last property
    #FIXME: " and arrays
    local key=$1
    local val=$2

    if [ -f $USERS_FILE ]; then
        sed -i "s/\($key\":\).*$/\1 $val,/" $USERS_FILE
        return $?
    fi
    return 1
}


