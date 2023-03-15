#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
# S_VERSION_OF_THIS_FILE="1405173c-b983-4e0b-8579-73c041f1c5e7"
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`" # required by some tests
#S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#--------------------------------------------------------------------------
func_assert_error_code_zero(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #------------------------------
    if [ "$S_ERR_CODE" != "" ]; then
        # If the "$?" were evaluated in this function, 
        # then it would be "0" even, if it is
        # something else at the calling code.
        if [ "$S_ERR_CODE" != "0" ]; then
            echo ""
            echo -e "\e[31mTest failed. \e[39m"
            echo "    S_ERR_CODE==\"$S_ERR_CODE\""
            echo "GUID=='cf662633-6729-4d40-9479-73c041f1c5e7'"
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            #--------
            exit 1
        fi
    fi
    #------------------------------
} # func_assert_error_code_zero

#--------------------------------------------------------------------------
S_FP_MMMV_BASH_BOILERPLATE_T1_BASH="`cd $S_FP_DIR/../ ; pwd`/mmmv_bash_boilerplate_t1.bash"
#--------------------------------------------------------------------------
if [ ! -e "$S_FP_MMMV_BASH_BOILERPLATE_T1_BASH" ]; then
    func_assert_error_code_zero "42" '3a96ded4-cc95-4b3c-8679-73c041f1c5e7'
fi
if [ -d "$S_FP_MMMV_BASH_BOILERPLATE_T1_BASH" ]; then
    func_assert_error_code_zero "42" '85c0c738-84f5-4320-a579-73c041f1c5e7'
fi
if [ -h "$S_FP_MMMV_BASH_BOILERPLATE_T1_BASH" ]; then
    func_assert_error_code_zero "42" '255b3e71-d4c7-4a70-8e79-73c041f1c5e7'
fi
source "$S_FP_MMMV_BASH_BOILERPLATE_T1_BASH"
func_assert_error_code_zero "$?" 'e353c17e-b002-4c65-8a79-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_add_bin_2_Z_PATH_and_optionally_share_man_2_MANPATH_t1 "/usr" \
    '35799975-5e5a-4d2e-b179-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_assert_Linux_or_BSD_t1 \
    '32593843-0e99-411e-a179-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1 "0" \
    'fc2bfb21-5564-4683-8379-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2 "0" \
    'ff629834-1498-4a62-b279-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3 "0" \
    '8d64ef1f-e1ab-4949-b279-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t4 "0" \
    '2d81fc28-cbc1-4a89-8379-73c041f1c5e7'
#--------------------------------------------------------------------------
S_TMP_000=""
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 "Foo" "S_TMP_000" \
    '30f26f19-edd4-4556-8379-73c041f1c5e7'
#--------------------------------------------------------------------------
# func_mmmv_cd_S_FP_ORIG_and_exit_t1
#--------------------------------------------------------------------------
# func_mmmv_create_folder_t1
#--------------------------------------------------------------------------
# func_mmmv_exc_exit_with_an_error_t1
#--------------------------------------------------------------------------
# func_mmmv_exc_exit_with_an_error_t2
#--------------------------------------------------------------------------
# func_mmmv_exit_t1
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t1 \
    "$S_FP_MMMV_BASH_BOILERPLATE_T1_BASH" \
    '25b76991-60f1-437b-8179-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t2 \
    "$S_FP_MMMV_BASH_BOILERPLATE_T1_BASH" \
    'c94f674d-d5b9-456d-a369-73c041f1c5e7'
#--------------------------------------------------------------------------
func_mmmv_init_s_timestamp_if_not_inited_t1
#--------------------------------------------------------------------------
# func_mmmv_report_an_error_but_do_not_exit_t1
#--------------------------------------------------------------------------
func_mmmv_verify_S_FP_ORIG_but_do_not_exit_t1
#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
echo ""
echo -e "\e[32mSuperficial tests passed without detecting any errors. \e[39m"
echo ""
exit 0 # no errors detected
#==========================================================================
