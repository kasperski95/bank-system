#!/bin/bash

# DevConfig
PRODUCTION_MODE=true
DB_EXT="json"

# Config
DB="$(pwd)/Database"
WIDTH=48
if $PRODUCTION_MODE; then
    USERS_FILE="$DB/Users/mock.$DB_EXT"
else
    USERS_FILE=""
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
SILVER='\033[0;37m' 
DEFAULT_COLOR=$SILVER