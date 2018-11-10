#!/bin/bash

. ./Main/globals.sh
. ./Main/Utils/json.sh
. ./Main/Utils/ui.sh
. ./Main/Utils/testing.sh


nPassed=0
nFailed=0

clear

# run all tests
for i in $(find Main -name "test.sh"); do
    . $i
done

echo ""
echo "========================================"
echo "Passed: $nPassed"
echo "Failed: $nFailed"
echo ""


exit 0