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
            echo "GUID=='a126c34f-0390-41ad-a1b8-6180a081c7e7'"
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            #--------
            exit 1
        fi
    fi
    #------------------------------
} # func_assert_error_code_zero

#--------------------------------------------------------------------------
S_FP_MMMV_BASH_BOILERPLATE_TX_BASH="`cd $S_FP_DIR/../ ; pwd`/mmmv_bash_boilerplate_t5.bash"
#--------------------------------------------------------------------------
if [ ! -e "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '74e75567-fc0e-415c-8ca8-6180a081c7e7'
fi
if [ -d "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" '1f277402-955b-452b-9c38-6180a081c7e7'
fi
if [ -h "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" ]; then
    func_assert_error_code_zero "42" 'a4e0fced-7b82-452c-9e48-6180a081c7e7'
fi
source "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH"
func_assert_error_code_zero "$?" '4fe99113-2660-4f68-a318-6180a081c7e7'
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
            '4fab9c01-0791-4167-8b18-6180a081c7e7'
    else
        echo ""
        echo -e "The \"\e[31m/usr\e[39m\" exists, but it is not a folder. "
        echo "GUID=='2fe27f44-91e3-48bb-aa18-6180a081c7e7'"
        echo ""
    fi
fi
#--------------------------------------------------------------------------
func_mmmv_assert_Linux_or_BSD_t1 \
    'c3f626a7-3408-41d3-b5f8-6180a081c7e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1 "0" \
    'b4029c9b-d906-4665-b058-6180a081c7e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2 "0" \
    '1dbe8b41-f325-4762-8b48-6180a081c7e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3 "0" \
    '2833f865-ef71-4af1-9058-6180a081c7e7'
#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t4 "0" \
    'b4acb105-19eb-49d7-ab18-6180a081c7e7'
#--------------------------------------------------------------------------
S_TMP_000="Foo"
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '399f7092-5379-4f84-9557-6180a081c7e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'c27e0e4f-3bce-4cf6-bf17-6180a081c7e7'
SB_NO_ERRORS_YET="t"
S_TMP_000=" "
func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '2c3e9e35-e9e3-460f-a147-6180a081c7e7'
func_mmmv_assert_nonempty_string_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '24c77f4b-4cab-4003-ad57-6180a081c7e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="Bar"
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'a1d44b63-e1f0-4a57-95a7-6180a081c7e7'
# S_TMP_000=""
# func_mmmv_assert_nonempty_string_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'b23748ce-ad9a-452c-8f27-6180a081c7e7'
#--------------------------------------------------------------------------
SB_NO_ERRORS_YET="t"
S_TMP_000="t"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'e5d5d1f1-27d6-4043-a027-6180a081c7e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    'b64a65f6-4656-4113-8547-6180a081c7e7'
S_TMP_000="f"
func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '4bee5171-fe0a-4c1b-9927-6180a081c7e7'
func_mmmv_assert_sbvar_domain_t_f_t1 \
    "$S_TMP_000" "S_TMP_000" \
    '3fa7f3f4-ffd9-4c6a-b417-6180a081c7e7'
# #--start-of-tests-that-are-expected-to-fail--
# SB_NO_ERRORS_YET="f"
# S_TMP_000="t"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '4a534fd9-0a31-4d37-9c27-6180a081c7e7'
# SB_NO_ERRORS_YET="f"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '3c8e5373-e7ca-45c1-9d37-6180a081c7e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="f"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     'a1e2e465-eed5-41d9-bff7-6180a081c7e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=""
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '1450254c-d3ae-4151-9527-6180a081c7e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000=" "
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '61b75f17-349f-4455-8277-6180a081c7e7'
# SB_NO_ERRORS_YET="t"
# S_TMP_000="X"
# func_mmmv_assert_sbvar_domain_t_f_but_do_not_exit_t1 \
#     "$S_TMP_000" "S_TMP_000" \
#     '312a7dbf-5088-439c-9c57-6180a081c7e7'
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
    '810dd15c-68bf-44dd-9927-6180a081c7e7'
#--------------------------------------------------------------------------
func_mmmv_include_bashfile_if_possible_t2 \
    "$S_FP_MMMV_BASH_BOILERPLATE_TX_BASH" \
    '4db97bc5-8f66-4dde-b537-6180a081c7e7'
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
    func_mmmv_assert_Linux_or_BSD_t1 'd15059c7-b42e-4181-ae27-6180a081c7e7'
    #----------------------------------------
    S_FP_0="/dev/sda1" # probably always present
    # blkid | grep '/dev/sda1' | sed -e 's/^[^U]\+UUID[=]["]//g' | sed -e 's/["].\+$//g'
    S_UUID="`blkid | grep '/dev/sda1' | sed -e 's/^[^U]\\+UUID[=][\"]//g' | sed -e 's/[\"].\\+\$//g'`"
    #-------
    S_BLOCK_DEVICE_ID_SUBPART_CANDIDATE="$S_UUID"
    func_mmmv_exc_block_device_ID_to_device_file_name_t1 \
        "$S_BLOCK_DEVICE_ID_SUBPART_CANDIDATE" \
        "489eb4e4-dd7b-4b62-b918-6180a081c7e7"
    if [ "$S_FP_DEVICE_FILE" != "$S_FP_0" ]; then
        func_mmmv_exc_exit_with_an_error_t2 \
            "cadadc93-42ea-4ded-ae18-6180a081c7e7"
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
func_mmmv_wait_and_sync_t1
echo ""
echo -e "\e[32mSuperficial tests passed without detecting any errors. \e[39m"
echo ""
exit 0 # no errors detected
#==========================================================================
# S_VERSION_OF_THIS_FILE="d3b24c03-f010-4420-ad38-6180a081c7e7"
#==========================================================================
