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
            echo "GUID=='508069a4-f0ce-42bb-92d2-b3932010a6e7'"
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            #--------
            exit 1
        fi
    fi
    #------------------------------
} # func_assert_error_code_zero

#--------------------------------------------------------------------------
S_FP_MMMV_BASH_BOILERPLATE_T2_BASH="`cd $S_FP_DIR/../ ; pwd`/mmmv_bash_boilerplate_t2_locally_modified_version_t1.bash"
#--------------------------------------------------------------------------
if [ ! -e "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" ]; then
    func_assert_error_code_zero "42" '14945752-d89f-45f9-b2c2-b3932010a6e7'
fi
if [ -d "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" ]; then
    func_assert_error_code_zero "42" 'f44c5f5b-077a-478b-95c2-b3932010a6e7'
fi
if [ -h "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" ]; then
    func_assert_error_code_zero "42" '55c85e48-ea00-4e94-b2c2-b3932010a6e7'
fi
source "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH"
func_assert_error_code_zero "$?" '256bbf61-cace-47a3-b5c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_add_bin_2_Z_PATH_and_optionally_share_man_2_MANPATH_t1 "/usr" \
    '23320714-e731-40c0-81c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_assert_Linux_or_BSD_t1 \
    'c3a40727-535e-4b19-a4c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1 "0" \
    '51995e25-b1fa-4596-94c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2 "0" \
    '5709ebf2-0bad-4837-b5c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3 "0" \
    '31d1d624-3e5d-4170-85c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t4 "0" \
    '79dcb12f-e86a-41bf-a1c2-b3932010a6e7'
#--------------------------------------------------------------------------
S_TMP_000="Foo"
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'd77931dc-277e-46b5-b1c2-b3932010a6e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '421deb04-f22d-4fd5-abc2-b3932010a6e7'
SB_NO_ERRORS_YET="t"
S_TMP_000=" "
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'e7b70834-82ff-45e9-b2c2-b3932010a6e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '56fd58b1-d388-49b8-b1c2-b3932010a6e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="Bar"
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '0203bb1a-31b9-4053-82c2-b3932010a6e7'
# S_TMP_000=""
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '2df75931-8a01-45d6-81c2-b3932010a6e7'
#--------------------------------------------------------------------------
SB_NO_ERRORS_YET="t"
S_TMP_000="t"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '292b6d02-cf1c-48d1-94c2-b3932010a6e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '68bed645-d24e-4ac8-81c2-b3932010a6e7'
S_TMP_000="f"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '3b5c7830-0bff-4784-a2c2-b3932010a6e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '4921e4cd-89f1-47b8-92c2-b3932010a6e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="t"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'a58aa019-bb63-404b-a5c2-b3932010a6e7'
# SB_NO_ERRORS_YET="f"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '83ba3f1b-d2d4-42cd-92c2-b3932010a6e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '305a7f69-c39c-44d5-a5c2-b3932010a6e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=""
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '828f3259-0f38-4e2f-b5c2-b3932010a6e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=" "
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '618c6850-5d80-446c-a1c2-b3932010a6e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="X"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '78c6f64d-f3a0-49ea-a3c2-b3932010a6e7'
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
    '2bc8df16-2b87-414a-83c2-b3932010a6e7'
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t2 \
    "$S_FP_MMMV_BASH_BOILERPLATE_T2_BASH" \
    '94313c2b-466f-4f64-b1c2-b3932010a6e7'
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
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="74f9ff17-8915-45f7-a3d2-b3932010a6e7"
#==========================================================================
