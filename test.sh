#!/bin/bash

. ./Main/globals.sh
DB=./Main/Database/Mock
. ./Main/Utils/json.sh
. ./Main/Utils/testing.sh

nPassed=0
nFailed=0

clear
. ./Main/Auth/test.sh
. ./Main/Database/test.sh
. ./Main/Utils/test.sh

echo ""
echo "========================================"
echo "Passed: $nPassed"
echo "Failed: $nFailed"
echo ""

exit 0