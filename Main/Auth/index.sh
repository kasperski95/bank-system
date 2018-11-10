#!/bin/bash
authDir="${BASH_SOURCE%/*}"
if [[ ! -d "$authDir" ]]; then authDir="$PWD"; fi

. $authDir/../Database/index.sh



# handle user communication
auth_authenticate() {
    local login password

    while [ -z ${USERS_FILE+x} ]; do
        read -p "Podaj login: " login
        while (! __verifyLogin $login); do
            clear
            echo "Login może się składać tylko z liter."
            echo ""
            read -p "Podaj login: " login
        done

        read -p "Podaj hasło: " password
        while (! __verifyPassword $password); do
            echo "Hasło może się składać tylko z cyfr."
            echo ""
            read -p "Podaj hasło: " password
        done

        if db_getUser $login $password; then
            USERS_FILE="$DB/$login.txt"
        else
            clear
            echo "Niepoprawny login lub hasło."
            echo ""
        fi
    done
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