#!/usr/bin/env bash
#==========================================================================
# Initial author of this file(2021_02_16): Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================

# https://www.quora.com/What-does-%E2%80%9C-%E2%80%9D-mean-in-Bash
# archival copy: https://archive.vn/1hIF4
func_hello(){
    local S_IN="$@"
    echo ""
    echo "The received value is a list of all function arguments."
    echo "like $1 and $2 and $3 and $4 etc." # yes, in this demo the "$4"==""
    echo "$S_IN"
    echo ""
} # func_hello

func_hello "aa" "bb" "cc"

#==========================================================================
