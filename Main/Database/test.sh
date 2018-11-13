#!/bin/bash
db_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$db_dir" ]]; then db_dir="$PWD"; fi

. $db_dir/users.sh
. $db_dir/accounts.sh



utl_printCategory "DATABASE"


utl_printSubcategory "getUser"
if [ -f $DB/Users/foo.$DB_EXT ]; then
    utl_test "correct credentials" true db_getUser "foo" "1234"
    utl_test "empty password" false db_getUser "user" ""
    utl_test "empty login" false db_getUser "" "1234"
    utl_test "password not set" false db_getUser "user"
    utl_test "login not set" false db_getUser "1234"
    utl_test "login and password not set" false db_getUser
else
    echo -e "\t\tCouldn't find mock user (foo.$DB_EXT)"
fi
