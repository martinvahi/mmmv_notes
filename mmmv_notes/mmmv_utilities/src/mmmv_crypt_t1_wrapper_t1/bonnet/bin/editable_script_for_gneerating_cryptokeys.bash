#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
# Editable settings:

SI_SETTINGS_KEY_LENGTH="1048576" # number of whole numbers in the key
#SI_SETTINGS_KEY_LENGTH="2097152" # number of whole numbers in the key
#SI_SETTINGS_KEY_LENGTH="3145728" # number of whole numbers in the key

# The file size of the keyfile tends to be ~50x the length of the key.
SI_SETTINGS_NUMBER_OF_KEYS="5"


#--------------------------------------------------------------------------
# Everything below this line is implementation.
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#--------------------------------------------------------------------------
S_FP_PROJECT_HOME="`cd $S_FP_DIR/../../; pwd`"
S_FP_BASH_LIB="$S_FP_PROJECT_HOME/bonnet/lib/2022_02_09_mmmv_bash_boilerplate_t2/mmmv_bash_boilerplate_t2.bash"
if [ ! -e "$S_FP_BASH_LIB" ]; then
    echo ""
    echo -e "\e[31mThis code is flawed.\e[39m The file "
    echo ""
    echo "    $S_FP_BASH_LIB"
    echo ""
    echo "could not be found."
    echo "GUID=='13f36022-8bda-49e3-811e-7043706176e7'"
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
#--------------------
S_FP_KEYS="$S_FP_PROJECT_HOME/bonnet/keys_for_use_with_mmmv_crypt_t1"
mkdir -p "$S_FP_KEYS"
func_mmmv_assert_error_code_zero_t1 "$?" \
    "cd54494d-2b47-48ac-921e-7043706176e7"
func_mmmv_wait_and_sync_t1
func_mmmv_assert_folder_exists_t1 "$S_FP_KEYS" \
    "2fde8a25-0734-4b2f-a31e-7043706176e7"
#--------------------
S_FP_MMMV_CRYPT_T1_BIN="$S_FP_PROJECT_HOME/bonnet/lib/as_of_2022_07_xx_old_mmmv_crypt_t1/partial_mmmv_devel_tools/src/mmmv_devel_tools/mmmv_crypt_t1/src"
func_mmmv_assert_folder_exists_t1 "$S_FP_MMMV_CRYPT_T1_BIN" \
    "b3efde40-031b-464d-851e-7043706176e7"
#--------------------
SB_OPTIONAL_BAN_SYMLINKS="t"
S_FP_MMMV_DECRYPT_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_decrypt_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_DECRYPT_t1" \
    "b9625825-f955-490f-a31e-7043706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
S_FP_MMMV_ENCRYPT_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_encrypt_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_ENCRYPT_t1" \
    "02a5c32e-b481-4393-911e-7043706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
S_FP_MMMV_GENKEY_t1="$S_FP_MMMV_CRYPT_T1_BIN/mmmv_genkey_t1"
func_mmmv_assert_file_exists_t1 "$S_FP_MMMV_GENKEY_t1" \
    "d7bb7641-aca8-4a5b-b31e-7043706176e7" "$SB_OPTIONAL_BAN_SYMLINKS"
#--------------------------------------------------------------------------

S_KEYFILE_NAME="to_be_set"
func_generate_keyfile_name(){
    local S_RAND="`uuid | sed -e 's/-.\+//g'`"
    local S_TMP_0="_generated_symmetric_key_$S_RAND"
    local S_TMP_1=".txt"
    S_KEYFILE_NAME="$S_TIMESTAMP$S_TMP_0$S_TMP_1"
} #func_generate_keyfile_name 
#--------------------------------------------------------------------------

S_FP_KEYFILE_PATH_CANDITATE="to_be_set"
func_generate_keyfile_path(){
    #--------------------
    local SB_NOT_DONE="t"
    S_FP_KEYFILE_PATH_CANDITATE="to_be_set"
    local S_FP_C="$S_FP_KEYFILE_PATH_CANDITATE"
    local I_0=42
    #--------------------
    for I_0 in {0..20}; do
        if [ "$SB_NOT_DONE" == "t" ]; then
            func_generate_keyfile_name
            S_FP_C="$S_FP_KEYS/$S_KEYFILE_NAME"
            if [ ! -e "$S_FP_C" ]; then
                if [ ! -h "$S_FP_C" ]; then # to cope with broken symlinks
                    SB_NOT_DONE="f"
                fi
            fi
        fi
    done
    #--------------------
    if [ "$SB_NOT_DONE" == "t" ]; then
        echo ""
        echo -e "\e[31mDue to the dirty hack nature of this script, it should be run again.\e[39m "
        echo "The issue was that the random number generator"
        echo "returned too many repeating numbers. It's not necessarily a flaw, but"
        echo "to keep this script as primitive as possible, this situation "
        echo "is not handled in this Bash code."
        echo "GUID=='c813032c-3ed8-40d9-921e-7043706176e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    else
        S_FP_KEYFILE_PATH_CANDITATE="$S_FP_C"
    fi
    #--------------------
} # func_generate_keyfile_path

#--------------------------------------------------------------------------
func_generate_keyfile(){
    func_generate_keyfile_path
    $S_FP_MMMV_GENKEY_t1 $SI_SETTINGS_KEY_LENGTH "$S_FP_KEYFILE_PATH_CANDITATE"
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "d2101acb-3fd1-4b96-911e-7043706176e7"
    func_mmmv_wait_and_sync_t1 # to cope with USB-sticks and network drives
} # func_generate_keyfile

#--------------------------------------------------------------------------
func_main(){
    #--------------------
    echo ""
    local S_CMD="I_0=42; for I_0 in {1..$SI_SETTINGS_NUMBER_OF_KEYS}; do \
        echo \"Generating keyfile #\$I_0 ..\" ; \
        func_generate_keyfile ; done"
        #echo \"Hello testingline \$I_0\"; done"
    eval ${S_CMD}
    echo ""
    echo "Generation complete. The files should reside at "
    echo ""
    echo "    $S_FP_KEYS"
    echo ""
    echo "and the newly generated files MIGHT be "
    echo ""
    ls -l $S_FP_KEYS/ | grep $S_TIMESTAMP
    echo ""
    #--------------------
    cd "$S_FP_ORIG"
    exit 0 # no errors detected
    #--------------------
} # func_main

func_main

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="4118bd18-8224-40ea-930e-7043706176e7"
#==========================================================================
