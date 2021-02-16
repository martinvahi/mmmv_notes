#!/usr/bin/env bash
#==========================================================================
# Initial author(2021_02_16): Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
if [ "$1" == "" ]; then 
    S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
else
    S_TIMESTAMP="$1" # from the main.bash
fi

# The syntax of the console output of this script
# is intentionally such that it is easy to create a 
# primitive parser for it.
#--------------------------------------------------------------------------

func_assert_program_is_available_on_PATH_t1(){
    local S_PROGRAM_NAME="$1"
    #--------------------
    local S_TMP_0="`which $S_PROGRAM_NAME 2> /dev/null`"
    if [ "$S_TMP_0" == "" ]; then
        echo "testresult [MISSING_FROM_PATH]: $S_PROGRAM_NAME"
    else
        echo "testresult [          on_PATH]: $S_PROGRAM_NAME"
    fi
} # func_assert_program_is_available_on_PATH_t1

t(){
    local S_PROGRAM_NAME="$1"
    func_assert_program_is_available_on_PATH_t1 "$S_PROGRAM_NAME"
} # t
#--------------------------------------------------------------------------
echo "comment [test_start_timestamp:$S_TIMESTAMP]"
#--------------------------------------------------------------------------

#---start-of-an-example--
# t "llvm"
# t "mvn"
# t "java"
# t "python"
# t "svn"
# t "cvs"
# t "erlang"
# t "psl"
# t "vim"
#---end-of-an-example----



