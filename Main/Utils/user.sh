#!/bin/bash


isLogIn() {
    if [ ! -z ${USERS_FILE+x} ] && [ "$USERS_FILE" != "" ] && [ -f $USERS_FILE ]; then
        return 0;
    fi
    return 1;
}

logOut() {
    USERS_FILE=""
    clear
    ui_header "LOGOWANIE"
    echo "Trwa wylogowywanie..." && sleep 1s
    return 0;
}