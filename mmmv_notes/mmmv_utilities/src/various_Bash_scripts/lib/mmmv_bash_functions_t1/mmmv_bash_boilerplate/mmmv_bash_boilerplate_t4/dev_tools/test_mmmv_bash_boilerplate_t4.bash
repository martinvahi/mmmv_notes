#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
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
            echo "GUID=='471ddc51-1758-4530-857e-e2a270a067e7'"
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            #--------
            exit 1
        fi
    fi
    #------------------------------
} # func_assert_error_code_zero

#--------------------------------------------------------------------------
S_FP_MMMV_BASH_BOILERPLATE_TX_BASH="`cd $S_FP_DIR/../ ; pwd`/mmmv_bash_boilerplate_t4.bash"
#--------------------------------------------------------------------------
if [ ! -e "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '5289f7b5-cde4-4889-847e-e2a270a067e7'
fi
if [ -d "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '1bce413c-b3ed-4758-b47e-e2a270a067e7'
fi
if [ -h "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '9fcfa638-1370-4e8d-927e-e2a270a067e7'
fi
source "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH"
func_assert_error_code_zero "$?" '5b9b6c73-f67c-4edb-b57e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_add_bin_2_Z_PATH_and_optionally_share_man_2_MANPATH_t1 "/usr" \
    '29cc3a1d-c2db-431e-a57e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_assert_Linux_or_BSD_t1 \
    '7cea5053-272d-4db6-a17e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1 "0" \
    '48d3e844-676a-4e67-947e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2 "0" \
    '77e50626-d4ab-4a04-817e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3 "0" \
    '329af21d-af8d-45f1-837e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t4 "0" \
    '21a3d1a2-ffbc-44d0-aa7e-e2a270a067e7'
#--------------------------------------------------------------------------
S_TMP_000="Foo"
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '54bbe324-b854-446a-b56e-e2a270a067e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'c24d8551-f4ab-4876-a46e-e2a270a067e7'
SB_NO_ERRORS_YET="t"
S_TMP_000=" "
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'd41ba1de-730c-458e-816e-e2a270a067e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '4e95d31c-8cb4-4237-b16e-e2a270a067e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="Bar"
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'c279b127-a305-489d-946e-e2a270a067e7'
# S_TMP_000=""
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '96454b10-24c2-4eda-846e-e2a270a067e7'
#--------------------------------------------------------------------------
SB_NO_ERRORS_YET="t"
S_TMP_000="t"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '54eb0a36-414a-43ce-846e-e2a270a067e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '6194852e-b0ba-4e81-836e-e2a270a067e7'
S_TMP_000="f"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '3bd15a95-b0ba-42bb-986e-e2a270a067e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'b9300d4e-cb60-4779-846e-e2a270a067e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="t"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'a60d3a4e-6302-4889-b56e-e2a270a067e7'
# SB_NO_ERRORS_YET="f"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '735ea503-b4df-4263-b16e-e2a270a067e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'd5821e1b-e3b8-456a-b36e-e2a270a067e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=""
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '4ba4aa56-17a2-483b-926e-e2a270a067e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=" "
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'ac407b5b-c7c5-4672-956e-e2a270a067e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="X"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '45950811-e47a-4b52-9c6e-e2a270a067e7'
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
    "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" \
    '5ce2b748-ba20-4d50-936e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t2 \
    "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" \
    '2dd3e134-fd56-4e8b-916e-e2a270a067e7'
#--------------------------------------------------------------------------
func_mmmv_init_s_timestamp_if_not_inited_t1
#--------------------------------------------------------------------------
# func_mmmv_report_an_error_but_do_not_exit_t1
#--------------------------------------------------------------------------
func_mmmv_verify_S_FP_ORIG_but_do_not_exit_t1
func_mmmv_exc_verify_S_FP_ORIG_t1
func_mmmv_exc_verify_S_FP_ORIG_t2
#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1
echo ""
echo -e "\e[32mSuperficial tests passed without detecting any errors. \e[39m"
echo ""
exit 0 # no errors detected
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="50e300b1-c3c4-49f3-937e-e2a270a067e7"
#==========================================================================
