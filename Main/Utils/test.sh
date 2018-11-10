#!/bin/bash
utl_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$utl_dir" ]]; then utl_dir="$PWD"; fi

. $utl_dir/json.sh



utl_printCategory "UTILS"


utl_printSubcategory "getFromJson"
utl_test "no space" true utl_getFromJson "0_space" "$utl_dir/Mock/mock.json"
utl_test "wrong key" false utl_getFromJson "0_spaceX" "$utl_dir/Mock/mock.json"