#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
func_init_data(){
    AR_DEBUG_TEST_STRINGS=(\
        "StarTrek" \
        "Space Force" \
        " " \
        "  " \
        )
} # func_init_data
#--------------------------------------------------------------------------
func_demo(){
    func_init_data
    #----------------------------------------
    local S_TMP_0=""
    echo ""
    S_TMP_0=${AR_DEBUG_TEST_STRINGS[0]}
    echo "The first element of the AR_DEBUG_TEST_STRINGS is: $S_TMP_0"
    S_TMP_0=${#AR_DEBUG_TEST_STRINGS[@]}
    echo -e "AR_DEBUG_TEST_STRINGS length:\e[36m $S_TMP_0 \e[39m"
    echo "The AR_DEBUG_TEST_STRINGS elements:"
    #--------
    for S_ITER in ${AR_DEBUG_TEST_STRINGS[@]}; do
         #--------
         echo -e "Value from the flawed loop: S_ITER==\"\e[36m$S_ITER\e[39m\""
         #--------
         #printf "%q" "$S_ITER" | xargs \
         #ruby -e 's_0=ARGV[0].to_s; puts("{\e[36m"+s_0+"\e[39m}");' 
         #--------
    done
    #----------------------------------------
    # The solution originates from:
    #     https://stackoverflow.com/questions/9084257/bash-array-with-spaces-in-elements
    S_TMP_0=""
    for ((i = 0; i < ${#AR_DEBUG_TEST_STRINGS[@]}; i++)) do
        S_TMP_0="${AR_DEBUG_TEST_STRINGS[$i]}"
        echo -e "Value from the array element index incrementing loop: S_ITER==\"\e[36m$S_TMP_0\e[39m\""
    done
    #----------------------------------------
} # func_demo
func_demo
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="d55cf948-e517-4da3-83e1-0020801117e7"
#==========================================================================
