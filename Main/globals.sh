#!/bin/bash

# DevConfig
PRODUCTION_MODE=true
DB_EXT="json"

# Config
DB="$(pwd)/Database"
WIDTH=48
if $PRODUCTION_MODE; then
    USERS_FILE="$DB/Users/user.$DB_EXT"
else
    USERS_FILE=""
fi

# Colors
red='\033[0;31m'
green='\033[0;32m'
lightGreen='\033[1;32m'
lightGray='\033[0;37m' 
white='\033[1;37m'
defaultColor=$lightGray