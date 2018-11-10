#!/bin/bash
mainDir="${BASH_SOURCE%/*}"
if [[ ! -d "$mainDir" ]]; then mainDir="$PWD"; fi

. $mainDir/globals.sh



check() {
    local testName=$1 && shift
    local expectedResult=$1 && shift

    if ($@); then
        local result=true
    else
        local result=false
    fi

    if [ $result == $expectedResult ]; then
        echo -e "       $green[PASS]$defaultColor $testName: $expectedResult"
        ((nPassed++))
    else
        echo -e "       $red[FAIL]$defaultColor $testName: $expectedResult" && shift
        echo    "           arg: $@"
        ((nFailed++))
    fi
}


printCategory() {
    echo -e "\n$1" | awk '{print toupper($1)}'
}


printSubcategory() {
    echo -e "\n    $1"
}