#!/bin/bash

. ./Main/globals.sh
. ./Main/Utils/index.sh
. ./Main/Auth/view.sh
. ./Main/Home/view.sh


while true; do
    auth_authenticate
    home_show
done


exit 0