#!/bin/bash

. ./Main/globals.sh
. ./Main/Utils/json.sh
. ./Main/Utils/ui.sh
. ./Main/Utils/user.sh
. ./Main/Auth/index.sh
. ./Main/Core/Homepage/index.sh


while true; do
    auth_authenticate
    home_show
done


exit 0