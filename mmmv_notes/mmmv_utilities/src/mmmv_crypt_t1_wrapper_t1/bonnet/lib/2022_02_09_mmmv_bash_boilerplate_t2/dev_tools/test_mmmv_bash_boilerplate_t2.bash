#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
# S_VERSION_OF_THIS_FILE="5c5047d3-50cd-499f-a32a-d201718026e7"
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
            echo "GUID=='c29d6d13-3250-459e-8e2a-d201718026e7'"
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            #--------
            exit 1
        fi
    fi
    #------------------------------
} # func_assert_error_code_zero

#--------------------------------------------------------------------------
S_FP_MMMV_BASH_BOILERPLATE_T2_BASH="`cd $S_FP_DIR/../ ; pwd`/mmmv_bash_boilerplate_t2.bash"
#--------------------------------------------------------------------------
if [ ! -e "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" ]; then
    func_assert_error_code_zero "42" '8969cb3f-4160-477e-b32a-d201718026e7'
fi
if [ -d "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" ]; then
    func_assert_error_code_zero "42" '5f23bdc4-9187-4f7d-a82a-d201718026e7'
fi
if [ -h "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" ]; then
    func_assert_error_code_zero "42" 'b0755c23-5620-4917-b32a-d201718026e7'
fi
source "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH"
func_assert_error_code_zero "$?" '65fc5c1f-e3a1-4b7d-832a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_add_bin_2_Z_PATH_and_optionally_share_man_2_MANPATH_t1 "/usr" \
    '35a124ad-fb51-4bfc-822a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_assert_Linux_or_BSD_t1 \
    'e1df0023-61c8-4484-822a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1 "0" \
    'a39b3834-8fc8-4ea0-b72a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2 "0" \
    '9a9fe54a-d7ba-4d09-b22a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3 "0" \
    'a48f574f-a81d-44ea-9c2a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t4 "0" \
    '125c4a34-3113-4505-b12a-d201718026e7'
#--------------------------------------------------------------------------
S_TMP_000="Foo"
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'cea10a10-1ed2-45da-b12a-d201718026e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '557402f8-2428-4ce2-922a-d201718026e7'
SB_NO_ERRORS_YET="t"
S_TMP_000=" "
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '149d2612-3967-40e5-812a-d201718026e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '2305a159-49f5-4c90-832a-d201718026e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="Bar"
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '19987431-2c51-44e7-a52a-d201718026e7'
# S_TMP_000=""
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '3dc63cdb-0f35-4a66-b42a-d201718026e7'
#--------------------------------------------------------------------------
SB_NO_ERRORS_YET="t"
S_TMP_000="t"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '982c0b1b-4d46-4a56-922a-d201718026e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '7b46e341-ae43-4ff8-b12a-d201718026e7'
S_TMP_000="f"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'dc763837-94e4-4d56-832a-d201718026e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '573bc9d5-eadd-41ce-a52a-d201718026e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="t"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '25620d72-91a3-4af8-842a-d201718026e7'
# SB_NO_ERRORS_YET="f"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '57b338f4-57b1-466b-922a-d201718026e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'bd0ee74c-c7f8-44d9-b22a-d201718026e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=""
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '1ff31a11-1821-4228-942a-d201718026e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=" "
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '2025e852-defd-4d67-a42a-d201718026e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="X"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '418a495f-a55d-41db-a42a-d201718026e7'
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
    "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" \
    '3edc4ca1-094e-42b5-872a-d201718026e7'
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t2 \
    "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" \
    '7c41f691-9834-4e50-bc2a-d201718026e7'
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
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
echo ""
echo -e "\e[32mSuperficial tests passed without detecting any errors. \e[39m"
echo ""
exit 0 # no errors detected
#==========================================================================
