#!/bin/bash
utl_dir="${BASH_SOURCE%/*}"
if [[ ! -d "$utl_dir" ]]; then utl_dir="$PWD"; fi

. $utl_dir/data.sh
. $utl_dir/ui.sh
. $utl_dir/user.sh
. $utl_dir/time.sh