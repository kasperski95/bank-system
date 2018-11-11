#!/bin/bash
auth_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$auth_dir" ]]; then auth_dir="$PWD"; fi

. $auth_dir/../Database/users.sh



# handle user communication
auth_authenticate() {
    local login password
    while [ "$USERS_FILE" == "" ]; do
        ui_printHeader "LOGOWANIE"

        # login
        read -p "Podaj login: " login
        while (! __verifyLogin $login); do
            ui_printHeader "LOGOWANIE"
            echo "Login może się składać tylko z liter."
            echo ""
            read -p "Podaj login: " login
        done

        # password
        read -p "Podaj hasło: " password
        while (! __verifyPassword $password); do
            echo "Hasło może się składać tylko z cyfr."
            echo ""
            read -p "Podaj hasło: " password
        done

        # verify
        if db_getUser $login $password; then
            USERS_FILE="$DB/Users/$login.$DB_EXT"
            ui_printHeader "LOGOWANIE"
            echo "Trwa przekierowywanie..."  && sleep 1s
            clear
            return 0
        else
            clear
            echo "Niepoprawny login lub hasło."
            echo ""
        fi
    done
    return 1
}



# only letters
__verifyLogin() {
    if [[ $1 =~ ^[a-zA-Z]+$ ]]; then
        return 0
    fi
    return 1
} 

# only integers
__verifyPassword() {
    # \d sucks
    if [[ $1 =~ ^[0-9]+$ ]]; then 
        return 0
    fi
    return 1
}