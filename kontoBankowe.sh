#!/bin/bash

. ./Main/globals.sh
. ./Main/Utils/index.sh
. ./Main/Auth/view.sh
. ./Main/Home/view.sh


while true; do
    if [ -d "$DB/Users" ]; then
        auth_authenticate
        home_show
    else
        echo "Inicjalizuje bazę danych..."
        . ./createDatabase.sh
        sleep 1s
    fi
done


exit 0