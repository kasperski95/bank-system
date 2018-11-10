#!/bin/bash
mainAuthDir="${BASH_SOURCE%/*}"
if [[ ! -d "$mainAuthDir" ]]; then mainAuthDir="$PWD"; fi

. $mainAuthDir/../utils.sh
. $mainAuthDir/index.sh



printCategory "AUTH"


printSubcategory "verifyLogin"
check "letters" true __verifyLogin "login"
check "empty" false __verifyLogin ""
check "digits" false __verifyLogin "123"
check "letters and digits" false __verifyLogin "login123"
check "special characters" false __verifyLogin "!@#$%^&*"

printSubcategory "verifyPassword"
check "digits" true __verifyPassword "123"
check "empty" false __verifyPassword ""
check "letters" false __verifyPassword "foobar"
check "letters and digits" false __verifyPassword "foobar123"
check "special characters" false __verifyPassword "!@#$%^&*"