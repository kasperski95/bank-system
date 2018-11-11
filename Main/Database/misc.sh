#!/bin/bash


db_getExchangeRate() {
    if [ -f $USERS_FILE ]; then
        utl_getFromJson "$1" "$DB/Misc/exchangeRates.$DB_EXT"
        return 0
    fi
    return 1
}