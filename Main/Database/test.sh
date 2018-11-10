#!/bin/bash
dbDir="${BASH_SOURCE%/*}"
if [[ ! -d "$dbDir" ]]; then dbDir="$PWD"; fi

. $dbDir/index.sh



utl_printCategory "DATABASE"


utl_printSubcategory "getUser"
utl_test "correct credentials" true db_getUser "user" "1234"
utl_test "empty password" false db_getUser "user" ""
utl_test "empty login" false db_getUser "" "1234"
utl_test "password not set" false db_getUser "user"
utl_test "login not set" false db_getUser "1234"
utl_test "login and password not set" false db_getUser
