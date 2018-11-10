#!/bin/bash


db_getFromAccount() {
    if [ -f $USERS_FILE ]; then
        utl_getFromJson "$1" "$DB/Accounts/$2.$DB_EXT"
        return 0
    fi
    return 1
}