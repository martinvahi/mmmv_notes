#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================

# The keyfiles reside at ./bonnet/keys_for_use_with_mmmv_crypt_t1
# The 
S_SETTINGS_KEYFILE_NAME="2022_05_11_T_10h_11min_22s_generated_symmetric_key_2dac9a9f.txt" # please update that
# is expected to reference only the name of the file, NOT the full path.

SI_SETTINGS_ESTIMATED_MEDIAN_OF_CLEARTEXT_LENGTHS="7000"
SI_SETTINGS_ESTIMATED_STANDARD_DEVIATION_OF_CLEARTEXT_LENGTHS="5000"

SB_CLEARTEXT_IS_A_BINARY_BLOB="t"  # domain=={"t","f"} 
# Text files are also binary blobs, but characters can be
# seen as whole numbers that have Unicode codepoints.
# That view can be used for some extra efficiency.

#--------------------------------------------------------------------------
# Everything below this line is implementation.
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#--------------------------------------------------------------------------
S_FP_PROJECT_HOME="`cd $S_FP_DIR/../; pwd`"
S_FP_BASH_LIB="$S_FP_PROJECT_HOME/bonnet/lib/2022_02_09_mmmv_bash_boilerplate_t2/mmmv_bash_boilerplate_t2.bash"
if [ ! -e "$S_FP_BASH_LIB" ]; then
    echo ""
    echo -e "\e[31mThis code is flawed.\e[39m The file "
    echo ""
    echo "    $S_FP_BASH_LIB"
    echo ""
    echo "could not be found."
    echo "GUID=='227dd459-554f-4748-b5cd-7113706176e7'"
    echo ""
    #--------
    cd "$S_FP_ORIG"
    exit 1
fi
source "$S_FP_BASH_LIB" # not all in here is needed in the current 
                        # script, but it's easier this way.
func_mmmv_exit_if_not_on_path_t2 "ruby"
func_mmmv_exit_if_not_on_path_t2 "grep"
func_mmmv_exit_if_not_on_path_t2 "uuid"
func_mmmv_exit_if_not_on_path_t2 "sed"
#func_mmmv_exit_if_not_on_path_t2 "dirname"
func_mmmv_exit_if_not_on_path_t2 "basename"
#func_mmmv_exit_if_not_on_path_t2 "date"
#--------------------
S_FP_KEYS="$S_FP_PROJECT_HOME/bonnet/keys_for_use_with_mmmv_crypt_t1"
func_mmmv_assert_folder_exists_t1 "$S_FP_KEYS" \
    "11dcc9d9-8c01-4040-b2cd-7113706176e7"
#--------------------
S_FP_MMMV_CRYPT_T1_BIN="$S_FP_PROJECT_HOME/bonnet/lib/as_of_2022_07_xx_old_mmmv_crypt_t1/partial_mmmv_devel_tools/src/mmmv_devel_tools/mmmv_crypt_t1/src"
func_mmmv_assert_folder_exists_t1 "$S_FP_MMMV_CRYPT_T1_BIN" \
    "95444a96-8f38-42ab-8dcd-7113706176e7"
#--------------------
SB_OPTIONAL_BAN_SYMLINKS="t"
S_FP_MMMV_DECRYPT_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_decrypt_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_DECRYPT_t1" \
    "292d1374-def5-4f61-bccd-7113706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
S_FP_MMMV_ENCRYPT_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_encrypt_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_ENCRYPT_t1" \
    "cdc6f03e-c7d6-4681-b1cd-7113706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
S_FP_MMMV_GENKEY_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_genkey_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_GENKEY_t1" \
    "9286c722-ff90-46d0-92cd-7113706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
#--------------------------------------------------------------------------
func_assert_domain_t_f_t1(){
    local SB_VARIABLE_VALUE="$1"
    local S_VARIABLE_NAME_IN_CALLING_CODE="$2"
    #--------------------
    if [ "$SB_VARIABLE_VALUE" == "" ]; then
        echo -e "\e[31mThe code that calls this function is flawed. \e[39m"
        echo "GUID=='34e5cb56-54fe-40fc-84cd-7113706176e7'"
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
    if [ "$S_VARIABLE_NAME_IN_CALLING_CODE" == "" ]; then
        echo -e "\e[31mThe code that calls this function is flawed. \e[39m"
        echo "GUID=='7b9d1a42-5c07-45a7-83cd-7113706176e7'"
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
    if [ "$SB_VARIABLE_VALUE" != "t" ]; then 
        if [ "$SB_VARIABLE_VALUE" != "f" ]; then 
            echo ""
            echo -e "\e[31mThere is a flaw somewhere in the code\e[39m that"
            echo "uses a variable named \"$S_VARIABLE_NAME_IN_CALLING_CODE\". The " 
            echo ""
            echo "    $S_VARIABLE_NAME_IN_CALLING_CODE==\"$SB_VARIABLE_VALUE\""
            echo ""
            echo "but it is expected to be either \"t\" or \"f\"."
            echo "GUID=='da79ad58-dc2b-4536-b2cd-7113706176e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
    #--------------------
} # func_assert_domain_t_f_t1

#--------------------------------------------------------------------------
func_assert_domain_si_t1(){
    local SI_VARIABLE_VALUE="$1"
    local S_VARIABLE_NAME_IN_CALLING_CODE="$2"
    #--------------------
    if [ "$S_VARIABLE_NAME_IN_CALLING_CODE" == "" ]; then
        echo -e "\e[31mThe code that calls this function is flawed. \e[39m"
        echo "GUID=='a577b95f-5043-4304-93cd-7113706176e7'"
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
    if [ "$SI_VARIABLE_VALUE" == "" ]; then 
        echo ""
        echo -e "\e[31mThere is a flaw somewhere in the code\e[39m that"
        echo "uses a variable named \"$S_VARIABLE_NAME_IN_CALLING_CODE\". The " 
        echo ""
        echo "    $S_VARIABLE_NAME_IN_CALLING_CODE==\"$SI_VARIABLE_VALUE\""
        echo ""
        echo "but it is expected to be a string form of a positive whole number."
        echo "GUID=='8d24f636-dd27-4356-a2cd-7113706176e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
    # The testline:
    # echo "9*9 2-3+4aa" | sed -e 's/[[:alpha:]]//g' | sed -e 's/[[:space:]]//g' | sed -e 's/-\|+\|*//g'
    #--------------------
    local S_TMP_0="`echo \"$SI_VARIABLE_VALUE\" | sed -e 's/[[:alpha:]]//g' | sed -e 's/[[:space:]]//g' | sed -e 's/-\|+\|*//g'`"
    if [ "$S_TMP_0" != "$SI_VARIABLE_VALUE" ]; then 
        echo ""
        echo -e "\e[31mThere is a flaw somewhere in the code\e[39m that"
        echo "uses a variable named \"$S_VARIABLE_NAME_IN_CALLING_CODE\". The " 
        echo ""
        echo "    $S_VARIABLE_NAME_IN_CALLING_CODE==\"$SI_VARIABLE_VALUE\""
        echo ""
        echo "but it is expected to be a string form of a positive whole number."
        echo "GUID=='8955313f-014e-4158-b4cd-7113706176e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
} # func_assert_domain_si_t1

#--------------------------------------------------------------------------
S_FN_CLEARTEXT="to_be_set" # FN like file name
S_FP_CLEARTEXT="to_be_set" # FP like file path
S_FN_CIPHERTEXT="to_be_set" # FN like file name
S_FP_CIPHERTEXT="to_be_set" # FP like file path
#--------------------------------------------------------------------------
S_FP_KEYFILE_PATH_CANDITATE="to_be_set"
func_generate_keyfile_path(){
    #--------------------
    S_FP_KEYFILE_PATH_CANDITATE="to_be_set"
    local S_FP_C="$S_FP_KEYFILE_PATH_CANDITATE"
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    #--------------------
    S_FP_C="$S_FP_KEYS/$S_SETTINGS_KEYFILE_NAME"
    func_mmmv_assert_file_exists_t1 "$S_FP_C" \
        "c032441a-e5bb-4cb1-92cd-7113706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    S_FP_KEYFILE_PATH_CANDITATE="$S_FP_C"
    #--------------------
} # func_generate_keyfile_path

#--------------------------------------------------------------------------
# mmmv_encrypt_t1 command line arguments:
#
#   first argument: path to key file 
#  second argument: path to cleartext  file 
#   third argument: path to ciphertext file 
#
#Optional:
#
#  fourth argument: estimated median of cleartext lengths 
#                          default:      10000
#
#   fifth argument: estimated standard deviation of cleartext lengths 
#                          default: calculated from the fifth argument 
#                                   func(10000) == 6666
#
#   sixth argument: armouring type {"text_armour_t1",
#                                   "bytestream_armour_t1"},
#                          default: "bytestream_armour_t1".
#--------------------------------------------------------------------------
func_encrypt(){
    #--------------------
    func_assert_domain_t_f_t1 \
        "$SB_CLEARTEXT_IS_A_BINARY_BLOB" "SB_CLEARTEXT_IS_A_BINARY_BLOB"
    local S_ARMOURING_TYPE="bytestream_armour_t1"
    if [ "$SB_CLEARTEXT_IS_A_BINARY_BLOB" == "f" ]; then
        S_ARMOURING_TYPE="text_armour_t1"
    fi
    #--------------------
    func_assert_domain_si_t1 \
        "$SI_SETTINGS_ESTIMATED_MEDIAN_OF_CLEARTEXT_LENGTHS" \
        "SI_SETTINGS_ESTIMATED_MEDIAN_OF_CLEARTEXT_LENGTHS"
    func_assert_domain_si_t1 \
        "$SI_SETTINGS_ESTIMATED_STANDARD_DEVIATION_OF_CLEARTEXT_LENGTHS" \
        "SI_SETTINGS_ESTIMATED_STANDARD_DEVIATION_OF_CLEARTEXT_LENGTHS"
    #--------------------
    if [ -e "$S_FP_CIPHERTEXT" ]; then
        echo ""
        echo -e "\e[31mCiphertext file already exists.\e[39m"
        echo "Not overwriting the"
        echo ""
        echo "    $S_FP_CIPHERTEXT"
        echo ""
        echo "GUID=='33e1c75a-86de-4f19-a5cd-7113706176e7'"
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ -h "$S_FP_CIPHERTEXT" ]; then
        echo ""
            echo -e "\e[31mCiphertext file already exists\e[39m" 
            echo "in the form of a broken symlink "
            echo ""
            echo "    $S_FP_CIPHERTEXT"
            echo ""
            echo "GUID=='5bae7f47-ef10-47b4-92cd-7113706176e7'"
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi 
    fi
    #--------------------
    func_generate_keyfile_path # assignes value to the S_FP_KEYFILE_PATH_CANDITATE
    echo ""
    echo "Trying to encrypt..."
    $S_FP_MMMV_ENCRYPT_t1 "$S_FP_KEYFILE_PATH_CANDITATE" \
        "$S_FP_CLEARTEXT" "$S_FP_CIPHERTEXT" \
        "$SI_SETTINGS_ESTIMATED_MEDIAN_OF_CLEARTEXT_LENGTHS" \
        "$SI_SETTINGS_ESTIMATED_STANDARD_DEVIATION_OF_CLEARTEXT_LENGTHS" \
        "$S_ARMOURING_TYPE"
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "c30d11bf-59c8-44dd-91cd-7113706176e7"
    func_mmmv_wait_and_sync_t1 # to cope with USB-sticks and network drives
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    func_mmmv_assert_file_exists_t1 "$S_FP_CIPHERTEXT" \
        "87533329-b64f-44f8-a3cd-7113706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    echo "Created file "
    echo "    $S_FP_CIPHERTEXT"
    echo ""
    #--------------------
} # func_encrypt

#--------------------------------------------------------------------------
func_display_help(){
    echo ""
    echo "This script is meant to be edited and it is "
    echo "a convenience wrapper to the mmmv_crypt_t1."
    echo "The idea is that some of the encryption settings, "
    echo "for example, encryption key path and salting related"
    echo "parameters, are part of this script. "
    echo ""
    echo "This script takes only one command line argument,"
    echo "which is a full path to the cleartext file. There is "
    echo "an attempt to place the ciphertext file to the same folder,"
    echo "where the cleartext file resides. If that attempt fails, "
    echo "then this script will _probably_ exit with an error."
    echo ""
    echo "Thank You for using this script :-)"
    echo ""
} # func_display_help

#--------------------------------------------------------------------------
S_ARGV_0="$1"
func_display_help_and_exit_if_help_requested(){
    #--------------------
    local S_HELP_REQUESTED="f"
    #--------------------
    if [ "$S_ARGV_0" == "h" ]; then
        S_HELP_REQUESTED="t"
    fi
    #--------------------
    if [ "$S_ARGV_0" == "-h" ]; then
        S_HELP_REQUESTED="t"
    fi
    #--------------------
    if [ "$S_ARGV_0" == "-?" ]; then
        S_HELP_REQUESTED="t"
    fi
    #--------------------
    if [ "$S_ARGV_0" == "--help" ]; then
        S_HELP_REQUESTED="t"
    fi
    #--------------------
    if [ "$S_HELP_REQUESTED" == "t" ]; then
        func_display_help
        #--------
        cd "$S_FP_ORIG"
        exit 0 # no errors detected
    fi
    #--------------------
} # func_display_help_and_exit_if_help_requested

#--------------------------------------------------------------------------
func_main(){
    #--------------------
    func_display_help_and_exit_if_help_requested
    if [ "$S_ARGV_0" == "" ]; then
        func_display_help
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exits with an error 
    fi
    #--------------------
    local S_TMP_0=""
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    func_mmmv_assert_file_exists_t1 "$S_ARGV_0" \
        "5ec62e2c-af4a-48b7-91cd-7113706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    S_FP_CLEARTEXT="$S_ARGV_0"
    S_FN_CLEARTEXT="`basename $S_FP_CLEARTEXT`"
    #--------------------
    S_TMP_0=".ciphertext"
    S_FN_CIPHERTEXT="$S_FN_CLEARTEXT$S_TMP_0"
    S_FP_CIPHERTEXT="`dirname $S_FP_CLEARTEXT`/$S_FN_CIPHERTEXT"
    #--------------------
    func_encrypt
    #--------------------
    cd "$S_FP_ORIG"
    exit 0 # no errors detected
    #--------------------
} # func_main

func_main

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="08486e18-5c6c-4d16-92cd-7113706176e7"
#==========================================================================
