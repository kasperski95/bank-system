#!/bin/bash


# check if DB is set and exists
if [ -z ${DB+x} ] || [ ! -d $DB ]; then
    echo -e "$red"
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