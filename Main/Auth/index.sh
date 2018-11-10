#!/bin/bash


# handle user authentication
authenticate() {
    read -p "Podaj login: " login
    while (! __verifyLogin $login); do
        echo "Login może się składać tylko z liter."
        read -p "Podaj login: " login
    done;

    read -p "Podaj hasło: " password
    while (! __verifyPassword $password); do
        echo "Hasło może się składać tylko z cyfr."
        read -p "Podaj hasło: " password
    done;
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
    if [[ $1 =~ ^[0-9]+$ ]]; then
        return 0
    fi
    return 1
}