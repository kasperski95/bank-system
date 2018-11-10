#!/bin/bash

. ./Main/globals.sh
. ./Main/Utils/index.sh
. ./Main/Auth/index.sh
. ./Main/Home/index.sh


while true; do
    auth_authenticate
    home_show
done


exit 0