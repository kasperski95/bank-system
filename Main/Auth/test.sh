#!/bin/bash
mainAuthDir="${BASH_SOURCE%/*}"
if [[ ! -d "$mainAuthDir" ]]; then mainAuthDir="$PWD"; fi

. $mainAuthDir/index.sh



utl_printCategory "AUTH"


utl_printSubcategory "verifyLogin"
utl_test "letters" true __verifyLogin "login"
utl_test "empty" false __verifyLogin ""
utl_test "digits" false __verifyLogin "123"
utl_test "letters and digits" false __verifyLogin "login123"
utl_test "special characters" false __verifyLogin "!@#$%^&*"

utl_printSubcategory "verifyPassword"
utl_test "digits" true __verifyPassword "123"
utl_test "empty" false __verifyPassword ""
utl_test "letters" false __verifyPassword "foobar"
utl_test "letters and digits" false __verifyPassword "foobar123"
utl_test "special characters" false __verifyPassword "!@#$%^&*"