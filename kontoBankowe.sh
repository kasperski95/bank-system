#!/bin/bash

. ./Main/globals.sh
. ./Main/Utils/index.sh
. ./Main/Auth/view.sh
. ./Main/Home/view.sh


while true; do
    if [ ! -z "$(ls -A $DB/Users)" ]; then
        auth_authenticate
        home_show
    else
        echo "Inicjalizuje bazę danych..."
        . ./fillDatabase.sh
        sleep 1s
    fi
done


exit 0