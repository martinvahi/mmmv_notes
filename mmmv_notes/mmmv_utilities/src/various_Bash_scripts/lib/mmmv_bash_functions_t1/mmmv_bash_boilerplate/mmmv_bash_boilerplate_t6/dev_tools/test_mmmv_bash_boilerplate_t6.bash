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
            echo "GUID=='95945745-2d14-446c-a467-31a270d078e7'"
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            #--------
            exit 1
        fi
    fi
    #------------------------------
} # func_assert_error_code_zero

#--------------------------------------------------------------------------
S_FP_MMMV_BASH_BOILERPLATE_TX_BASH="`cd $S_FP_DIR/../ ; pwd`/mmmv_bash_boilerplate_t6.bash"
#--------------------------------------------------------------------------
if [ ! -e "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" 'a27ad35e-1989-4569-b267-31a270d078e7'
fi
if [ -d "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '546324e6-226e-4533-9567-31a270d078e7'
fi
if [ -h "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '1bf60d32-1eed-4bd8-af67-31a270d078e7'
fi
source "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH"
func_assert_error_code_zero "$?" '00d9f74b-4e49-4e0e-a567-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_exc_determine_Awk_command_t1     # "" -> "t"
func_mmmv_exc_determine_Awk_command_t1 "t" # branch, because value not set
func_mmmv_exc_determine_Awk_command_t1 "f" # branch, because value set but forced to recalc
func_mmmv_exc_determine_Awk_command_t1 "t" # branch, because value set and reuse requested
#--------
func_mmmv_exc_determine_sed_command_t1     # "" -> "t"
func_mmmv_exc_determine_sed_command_t1 "t" # branch, because value not set
func_mmmv_exc_determine_sed_command_t1 "f" # branch, because value set but forced to recalc
func_mmmv_exc_determine_sed_command_t1 "t" # branch, because value set and reuse requested
#--------------------------------------------------------------------------
if [ -e "/usr" ]; then # exists, because the 
    # Android specific Linux distrubution named Termux 
    # is an application at Android userspace and 
    # at least at some Android versions the "/usr" 
    # is not always even readable from the Android userspace.
    if [ -d "/usr" ]; then
        func_mmmv_add_bin_2_Z_PATH_and_optionally_share_man_2_MANPATH_t1 \
            "/usr" \
            '8b432213-e657-41af-9367-31a270d078e7'
    else
        echo ""
        echo -e "The \"\e[31m/usr\e[39m\" exists, but it is not a folder. "
        echo "GUID=='2398ad1c-7e69-4d31-9367-31a270d078e7'"
        echo ""
    fi
fi
#--------------------------------------------------------------------------
func_mmmv_assert_Linux_or_BSD_t1 \
    '4c06dc18-9a90-413d-a467-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1 "0" \
    '44cc634c-a0e4-433a-a567-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2 "0" \
    '82f35d51-f289-4ac2-8167-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3 "0" \
    '2a1e15f0-9da1-48d6-8467-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t4 "0" \
    '1bf3d883-7a74-46bf-b667-31a270d078e7'
#--------------------------------------------------------------------------
S_TMP_000="Foo"
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '25eea895-c2f5-48bd-9167-31a270d078e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '30864c72-0736-446d-b267-31a270d078e7'
SB_NO_ERRORS_YET="t"
S_TMP_000=" "
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '11f01a7a-7f8c-4b9e-9267-31a270d078e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '7af20a18-db71-4f22-8567-31a270d078e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="Bar"
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '1f84b1b1-0436-45d8-8e67-31a270d078e7'
# S_TMP_000=""
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '8a5eb61d-6b1e-47af-a467-31a270d078e7'
#--------------------------------------------------------------------------
SB_NO_ERRORS_YET="t"
S_TMP_000="t"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '46486033-efb3-4978-b557-31a270d078e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '768c9230-6a45-4b89-9157-31a270d078e7'
S_TMP_000="f"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '33d62782-0f82-4162-b257-31a270d078e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '3eba7b54-826a-432e-9157-31a270d078e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="t"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '290b605e-bf15-4b69-9257-31a270d078e7'
# SB_NO_ERRORS_YET="f"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '3beb9e25-021e-45f6-8457-31a270d078e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '2c15a575-93ee-4ed1-9157-31a270d078e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=""
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '3d2fd931-add8-47a3-b157-31a270d078e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=" "
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '4614bcbb-e6fc-4c4e-a157-31a270d078e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="X"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '47277142-e6a0-4e8e-8357-31a270d078e7'
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
    'ec9e7fa3-b993-4a75-9557-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t2 \
    "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" \
    'cf463056-daa8-454c-8157-31a270d078e7'
#--------------------------------------------------------------------------
func_mmmv_init_s_timestamp_if_not_inited_t1
#--------------------------------------------------------------------------
# func_mmmv_report_an_error_but_do_not_exit_t1
#--------------------------------------------------------------------------
func_mmmv_verify_S_FP_ORIG_but_do_not_exit_t1
func_mmmv_exc_verify_S_FP_ORIG_t1
func_mmmv_exc_verify_S_FP_ORIG_t2
#--------------------------------------------------------------------------
func_mmmv_operatingsystem_is_Linux "SB_TMP_0"
func_mmmv_operatingsystem_is_BSD "SB_TMP_0"
func_mmmv_operatingsystem_is_macOS "SB_TMP_0"
if [ "`uname -a 2> /dev/null | grep -E '(Linux|BSD)' `" != "" ]; then
    func_mmmv_assert_Linux_or_BSD_t1 'c4231330-8a2c-478e-8257-31a270d078e7'
    #----------------------------------------
    S_FP_0="/dev/sda1" # probably always present
    # blkid | grep '/dev/sda1' | sed -e 's/^[^U]\+UUID[=]["]//g' | sed -e 's/["].\+$//g'
    S_UUID="`blkid | grep '/dev/sda1' | sed -e 's/^[^U]\\+UUID[=][\"]//g' | sed -e 's/[\"].\\+\$//g'`"
    #-------
    S_BLOCK_DEVICE_ID_SUBPART_CANDIDATE="$S_UUID"
    func_mmmv_exc_block_device_ID_to_device_file_name_t1 \
        "$S_BLOCK_DEVICE_ID_SUBPART_CANDIDATE" \
        "401875b4-913c-4088-9367-31a270d078e7"
    if [ "$S_FP_DEVICE_FILE" != "$S_FP_0" ]; then
        func_mmmv_exc_exit_with_an_error_t2 \
            "3677e68a-d125-4a4e-8367-31a270d078e7"
    fi
    #----------------------------------------
fi
#--------------------------------------------------------------------------
S_MMMV_OPERATING_SYSTEM="FooBar_operating_system"
func_mmmv_determine_operatingsystem_t1     # "" -> "t"
func_mmmv_determine_operatingsystem_t1 "t" # branch, because value not set
func_mmmv_determine_operatingsystem_t1 "f" # branch, because value set but forced to recalc
func_mmmv_determine_operatingsystem_t1 "t" # branch, because value set and reuse requested
#echo "Operating system name is: $S_MMMV_OPERATING_SYSTEM"
#--------------------------------------------------------------------------
SB_RESULT="to_be_set"
func_mmmv_sb_s_on_PATH_t1 "this_does_not_possibly_exist_4440o0" \
    "55f8a65e-3750-404b-9367-31a270d078e7"
if [ "$SB_RESULT" != "f" ]; then
    func_mmmv_exc_exit_with_an_error_t2 \
        "73f9852c-e21b-4262-8167-31a270d078e7"
fi
func_mmmv_sb_s_on_PATH_t1 "ls" \
    "71e58c29-3210-43d5-b367-31a270d078e7"
if [ "$SB_RESULT" != "t" ]; then
    func_mmmv_exc_exit_with_an_error_t2 \
        "6ec35f13-f0a2-491a-b167-31a270d078e7"
fi
#--------------------------------------------------------------------------
S_EXPECTED_SUBSTRING="`hostname`"
func_mmmv_assert_uname_hyphen_a_output_includes_t1 "$S_EXPECTED_SUBSTRING" \
    "2186c714-3649-4252-8367-31a270d078e7"
#--------------------------------------------------------------------------
S_EXPECTED_USER_NAME="`whoami`"
func_mmmv_assert_current_user_t1 "$S_EXPECTED_USER_NAME" \
    "ad69921b-88f5-41ff-9267-31a270d078e7"
#--------------------------------------------------------------------------
S_GENERATED_GUID=""  # "011fa44c-8b56-4353-a567-31a270d078e7"
func_mmmv_s_generate_GUID_t1 
if [ "$S_GENERATED_GUID" == "" ]; then
    func_mmmv_exc_exit_with_an_error_t2 \
        "14bdec19-c3a6-4dd2-8367-31a270d078e7"
fi
#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1
echo ""
echo -e "\e[32mSuperficial tests passed without detecting any errors. \e[39m"
echo ""
exit 0 # no errors detected
#==========================================================================
# S_VERSION_OF_THIS_FILE="72280dde-10ec-4410-a867-31a270d078e7"
#==========================================================================
