#!/bin/bash

# DevConfig
PRODUCTION_MODE=false
DB_EXT="json"

LC_NUMERIC=C # use '.' instead of ',' for floating point numbers         

# Config
DB="$(pwd)/Database"
WIDTH=48

# Crucial
if $PRODUCTION_MODE; then
    USERNAME="foo"
    USERS_FILE="$DB/Users/$USERNAME.$DB_EXT"
else
    USERNAME=""
    USERS_FILE=""
fi

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
SILVER='\033[0;37m' 
BLUE='\033[0;36m' 
DEFAULT_COLOR=$SILVER

