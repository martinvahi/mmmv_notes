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
    echo "GUID=='423a4c3a-bf7b-4d88-9320-6303706176e7'"
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
    "304d1522-b6cd-4ad7-a120-6303706176e7"
#--------------------
S_FP_MMMV_CRYPT_T1_BIN="$S_FP_PROJECT_HOME/bonnet/lib/as_of_2022_07_xx_old_mmmv_crypt_t1/partial_mmmv_devel_tools/src/mmmv_devel_tools/mmmv_crypt_t1/src"
func_mmmv_assert_folder_exists_t1 "$S_FP_MMMV_CRYPT_T1_BIN" \
    "04cc0649-fd2d-4ac0-b320-6303706176e7"
#--------------------
SB_OPTIONAL_BAN_SYMLINKS="t"
S_FP_MMMV_DECRYPT_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_decrypt_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_DECRYPT_t1" \
    "2787e3b1-b086-4a86-8c20-6303706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
S_FP_MMMV_ENCRYPT_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_encrypt_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_ENCRYPT_t1" \
    "f5af5b85-dff5-495b-a620-6303706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
S_FP_MMMV_GENKEY_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_genkey_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_GENKEY_t1" \
    "523c2b76-8b02-41f2-9a20-6303706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"

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
        "f0e3824a-b74e-4c9e-a120-6303706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    S_FP_KEYFILE_PATH_CANDITATE="$S_FP_C"
    #--------------------
} # func_generate_keyfile_path

#--------------------------------------------------------------------------
# mmmv_decrypt_t1 command line arguments:
#
#   first argument: path to key file 
#  second argument: path to ciphertext file 
#   third argument: path to cleartext  file 
#--------------------------------------------------------------------------
func_decrypt(){
    #--------------------
    if [ -e "$S_FP_CLEARTEXT" ]; then
        echo ""
        echo -e "\e[31mCleartext file already exists.\e[39m"
        echo "Not overwriting the"
        echo ""
        echo "    $S_FP_CLEARTEXT"
        echo ""
        echo "GUID=='41c76e01-f1fc-416e-a220-6303706176e7'"
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ -h "$S_FP_CLEARTEXT" ]; then
        echo ""
            echo -e "\e[31mCleartext file already exists\e[39m" 
            echo "in the form of a broken symlink "
            echo ""
            echo "    $S_FP_CLEARTEXT"
            echo ""
            echo "GUID=='513e2b9f-78cd-4248-a420-6303706176e7'"
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi 
    fi
    #--------------------
    func_generate_keyfile_path # assignes value to the S_FP_KEYFILE_PATH_CANDITATE
    echo ""
    echo "Trying to decrypt..."
    $S_FP_MMMV_DECRYPT_t1 "$S_FP_KEYFILE_PATH_CANDITATE" \
        "$S_FP_CIPHERTEXT" "$S_FP_CLEARTEXT" 
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "0a555823-6b87-4c57-a220-6303706176e7"
    func_mmmv_wait_and_sync_t1 # to cope with USB-sticks and network drives
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    func_mmmv_assert_file_exists_t1 "$S_FP_CLEARTEXT" \
        "8444bc93-448e-4c4a-8e20-6303706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    echo "Created file "
    echo "    $S_FP_CLEARTEXT"
    echo ""
    #--------------------
} # func_decrypt

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
    echo "which is a full path to the ciphertext file. There is "
    echo "an attempt to place the cleartext file to the same folder,"
    echo "where the ciphertext file resides. If that attempt fails, "
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
        "978c3e2c-f5dc-4347-a320-6303706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    S_FP_CIPHERTEXT="$S_ARGV_0"
    S_FN_CIPHERTEXT="`basename $S_FP_CIPHERTEXT`"
    #--------------------
    S_TMP_0=".cleartext"
    S_FN_CLEARTEXT="$S_FN_CIPHERTEXT$S_TMP_0"
    S_FP_CLEARTEXT="`dirname $S_FP_CIPHERTEXT`/$S_FN_CLEARTEXT"
    #--------------------
    func_decrypt
    #--------------------
    cd "$S_FP_ORIG"
    exit 0 # no errors detected
    #--------------------
} # func_main

func_main

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="62cd5b41-dfb2-4bb1-9320-6303706176e7"
#==========================================================================
