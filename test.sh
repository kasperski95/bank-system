#!/bin/bash

nPassed=0
nFailed=0

clear
. ./Main/Auth/test.sh

echo ""
echo "========================================"
echo "Passed: $nPassed"
echo "Failed: $nFailed"
echo ""

exit 0