#!/bin/bash

# DevConfig
PRODUCTION_MODE=true
DB_EXT="json"

utl_getDate() {
    date '+%Y-%m-%d'
}
utl_getTime() {
    date '+%H:%M:%S'
}
utl_getDateAndTime() {
    date '+%Y-%m-%d_%H:%M:%S'
}

# Config
DB="$(pwd)/Database"
WIDTH=48

# Crucial
if $PRODUCTION_MODE; then
    USERS_FILE="$DB/Users/foo.$DB_EXT"
else
    USERS_FILE=""
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
SILVER='\033[0;37m' 
DEFAULT_COLOR=$SILVER

