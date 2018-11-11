#!/bin/bash



utl_test() {
    local testName=$1 && shift
    local expectedResult=$1 && shift

    if ($@); then
        local result=true
    else
        local result=false
    fi

    if [ $result == $expectedResult ]; then
        echo -e "       $GREEN[PASS]$DEFAULT_COLOR $testName: $expectedResult"
        ((nPassed++))
    else
        echo -e "       $RED[FAIL]$DEFAULT_COLOR $testName: $expectedResult" && shift
        echo    "           arg: $@"
        ((nFailed++))
    fi
}


utl_printCategory() {
    echo -e "\n$1" | awk '{print toupper($1)}'
}


utl_printSubcategory() {
    echo -e "\n    $1"
}