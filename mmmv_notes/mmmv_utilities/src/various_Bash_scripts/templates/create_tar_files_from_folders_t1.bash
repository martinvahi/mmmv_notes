#!/usr/bin/env bash 
#==========================================================================
# Initial author of this script: Martin.Vahi@softf1.com
# This file is in public domain.
# 
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------

func_this_script_is_meant_to_be_customized_by_customizing_this_function(){

    # Folders that will be copied to backup tar-files will be read from the 
    S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP="$HOME/htdocs/vx"
    # The 
    S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS="files_that_have_been_uploaded_to_the_MediaWiki"
    # will be created to the same folder, where this script resides. It is OK to
    # redefine both of those environment variables even after calling

    func_create_tarfile "MediaWiki_instance_01"
    func_create_tarfile "MediaWiki_instance_03"
    func_create_tarfile "MediaWiki_instance_04"

    # like 
    S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP="$HOME/htdocs/someplace_else"
    S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS="some_other_set_of_backups"

    func_create_tarfile "Foo"
    func_create_tarfile "Bar"

    #The 
    SB_COMPRESS_TARFILES="t"
    # is an optional parameter that can be skipped in this function, but
    # if it is used, then it should be set before calling the func_create_tarfile(..)

    func_create_tarfile "Atlantis"

} # func_this_script_is_meant_to_be_customized_by_customizing_this_function

#------------------------start_of_implementation---------------------------
# There is no point of reading anything below this line.
S_FP_ORIG="`pwd`"
#-----------------------start_of_boilerplate-------------------------------

func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_mmmv_wait_and_sync_t1

#--------------------------------------------------------------------------

func_mmmv_assert_error_code_zero_t1(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #--------
    # If the "$?" were evaluated in this function, 
    # then it would be "0" even, if it is
    # something else at the calling code.
    if [ "$S_ERR_CODE" != "0" ];then
        echo ""
        echo "Something went wrong. Error code: $S_ERR_CODE"
        echo "Aborting script."
        echo "GUID=='eb0d9d5c-84a0-4e78-85a0-319321e0c4e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1
    fi
} # func_mmmv_assert_error_code_zero_t1

#--------------------------------------------------------------------------

func_mmmv_assert_file_exists_t1() {  # S_FP, S_GUID
    local S_FP="$1"
    local S_GUID="$2"
    #------------------------------
    if [ "$S_GUID" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters: S_FP, S_GUID"
        echo "GUID=='5f1c9387-f026-42fe-82a0-319321e0c4e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #------------------------------
    if [ ! -e "$S_FP" ]; then
        if [ -h "$S_FP" ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symlink, but a file or "
            echo "a symlinkt to a file is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='25eca575-d188-4eb8-a8a0-319321e0c4e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            echo "The file "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='3c34c051-3f6a-4790-b2a0-319321e0c4e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    else
        if [ -d "$S_FP" ]; then
            echo ""
            if [ -h "$S_FP" ]; then
                echo "The symlink to the folder "
            else
                echo "The folder "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "exists, but a file or a symlink to a file is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='803b7018-c5c6-40ef-9190-319321e0c4e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
} # func_mmmv_assert_file_exists_t1

#--------------------------------------------------------------------------

func_mmmv_assert_folder_exists_t1() {  # S_FP, S_GUID
    local S_FP="$1"
    local S_GUID="$2"
    #------------------------------
    if [ "$S_GUID" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters: S_FP, S_GUID"
        echo "GUID=='7d34e946-80c2-44f4-9290-319321e0c4e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #------------------------------
    if [ ! -e "$S_FP" ]; then
        if [ -h "$S_FP" ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symlink, but a folder "
            echo "or a symlink to a folder is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='d3452d43-c756-4b63-b290-319321e0c4e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            echo "The folder "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='11499394-6489-4dc5-9590-319321e0c4e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    else
        if [ ! -d "$S_FP" ]; then
            echo ""
            if [ -h "$S_FP" ]; then
                echo "The symlink to an existing file "
            else
                echo "The file "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "exists, but a folder is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='7066e857-48c8-4612-9290-319321e0c4e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
} # func_mmmv_assert_folder_exists_t1

#--------------------------------------------------------------------------

func_mmmv_exc_verify_S_FP_ORIG_t1() {
    if [ "$S_FP_ORIG" == "" ]; then
        echo ""
        echo "The code of this script is flawed."
        echo "The environment variable S_FP_ORIG is expected "
        echo "to be initialized at the start of the script by "
        echo ""
        echo "    S_FP_ORIG=\"\`pwd\`\""
        echo ""
        echo "Aborting script."
        echo "GUID=='a18a9725-2b6a-4ae6-9490-319321e0c4e7'"
        echo ""
        exit 1 # exit with an error
    fi
    #------------------------
    local SB_IS_SYMLINK="f"      # possible values: "t", "f"
    if [ -h "$S_FP_ORIG" ]; then # Returns "false" for paths that 
                                 # do not refer to anything.
        SB_IS_SYMLINK="t"
    fi
    #--------
    if [ ! -e "$S_FP_ORIG" ]; then
        if [ "$SB_IS_SYMLINK" == "t" ]; then
            echo "The "
        else
            echo "The file or folder "
        fi
        echo ""
        echo "    S_FP_ORIG==$S_FP_ORIG "
        echo ""
        if [ "$SB_IS_SYMLINK" == "t" ]; then
            echo "is a broken symlink. It is expected to be a folder that "
        else
            echo "does not exist. It is expected to be a folder that "
        fi
        echo "contains the script that prints this error message."
        echo "Aborting script."
        echo "GUID=='d7454873-6a4a-4344-9b90-319321e0c4e7'"
        echo ""
        exit 1 # exit with an error
    fi
    #------------------------
    if [ ! -d "$S_FP_ORIG" ]; then
        echo "The "
        echo ""
        echo "    S_FP_ORIG==$S_FP_ORIG "
        echo ""
        echo "is not a folder. It is expected to be a folder that "
        echo "contains the script that prints this error message."
        echo "Aborting script."
        echo "GUID=='109f6cab-63cd-46c5-a290-319321e0c4e7'"
        echo ""
        exit 1 # exit with an error
    fi
} # func_mmmv_exc_verify_S_FP_ORIG_t1

#--------------------------------------------------------------------------

func_mmmv_exc_exit_with_an_error_t2(){
    local S_GUID_CANDIDATE="$1"   # first function argument
    local S_OPTIONAL_ERR_MSG="$2" # second function argument
    func_mmmv_exc_verify_S_FP_ORIG_t1
    #--------
    if [ "$S_GUID_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed. "
        if [ "$S_OPTIONAL_ERR_MSG" != "" ]; then 
            echo "$S_OPTIONAL_ERR_MSG"
        fi
        echo "Aborting script."
        echo "GUID=='1909dd42-48a2-4e60-9680-319321e0c4e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    else
        echo ""
        echo "Something went wrong."
        if [ "$S_OPTIONAL_ERR_MSG" != "" ]; then 
            echo "$S_OPTIONAL_ERR_MSG"
        fi
        echo "Aborting script."
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo "GUID=='e0a9ad33-411f-4164-8380-319321e0c4e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
} # func_mmmv_exc_exit_with_an_error_t2

#--------------------------------------------------------------------------

func_mmmv_create_folder_t1(){
    local S_FP_FOLDER="$1" # first function argument
    #--------
    # The reason, why this function is used instead of the 
    #     mkdir -p $S_FP_FOLDER
    # is that there is no guarantee that the 
    #     mkdir -p $S_FP_FOLDER
    # succeeds and it would be a waste of
    # development time to write the file system related
    # tests from scatch every time a folder 
    # needs to be created.
    #--------
    func_mmmv_exc_verify_S_FP_ORIG_t1
    if [ "$S_FP_FOLDER" == "" ]; then
        echo ""
        echo "The function formal parameter S_FP_FOLDER "
        echo "is expected to be a full path to a folder that "
        echo "either already exists or that has to be created."
        echo "Aborting script."
        echo "GUID=='a57c0916-86fb-4707-a280-319321e0c4e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
    #--------
    if [ -e "$S_FP_FOLDER" ]; then 
        if [ ! -d "$S_FP_FOLDER" ]; then 
            echo ""
            echo "The "
            echo ""
            echo "    $S_FP_FOLDER"
            echo ""
            echo "is a file or a symlink to a file, but it "
            echo "is expected to be a full path to a folder, "
            echo "a symlink to a folder or it should not "
            echo "reference anything that already exists."
            echo "Aborting script."
            echo "GUID=='280e334c-a06d-40a8-b480-319321e0c4e7'"
            echo ""
            cd "$S_FP_ORIG"
            exit 1 # exit with an error
        fi
    else
        mkdir -p $S_FP_FOLDER
        local S_TMP_0="$?"
        wait # just in case
        sync # for network drives and USB-sticks
        wait # just in case
        if [ "$S_TMP_0" != "0" ]; then 
            func_mmmv_exc_exit_with_an_error_t2 "2b9ad111-3867-4866-b5a0-319321e0c4e7" \
                "S_FP_FOLDER==$S_FP_FOLDER"
        fi
        if [ ! -e "$S_FP_FOLDER" ]; then 
            func_mmmv_exc_exit_with_an_error_t2 "96ec2e4a-2b4a-4267-a1a0-319321e0c4e7" \
                "Folder creation failed. S_FP_FOLDER==$S_FP_FOLDER"
        fi
    fi
    #--------
} # func_mmmv_create_folder_t1

#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME="$1"
    #--------
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of this Bash script is aborted."
        echo "GUID=='6086341a-51e6-48a8-a380-319321e0c4e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "tar"
func_mmmv_exit_if_not_on_path_t2 "xz"
func_mmmv_exit_if_not_on_path_t2 "nice" # should be provided by the 
                                        # operating system developers, but 
                                        # this script does assume its availability.

#-------------------------end_of_boilerplate-------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_`date +%H`_`date +%M`_`date +%S`"
S_TMP_0="_"
S_TIMESTAMP_AS_NAME_PREFIX="$S_TIMESTAMP$S_TMP_0"

S_FP_BACKUP_FOLDER_UNINITED_VALUE="/tmp/this_value_still_needs_to_be_initialized_77"
S_FP_BACKUP_FOLDER="$S_FP_BACKUP_FOLDER_UNINITED_VALUE"

#--------------------------------------------------------------------------
# Settings variables and their default values:
S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP_UNINITED_VALUE="/tmp/this_value_still_needs_to_be_initialized_4c3dcacd23db511ebAH0aF1c6f6552Wf9e6"
S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS_UNINITED_VALUE="this_value_still_needs_to_be_initialized_bb79ff6R3dbH11eQM8dd1cZ6f6552f9e6"

S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP="$S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP_UNINITED_VALUE"
S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS="$S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS_UNINITED_VALUE"

#--------------------------------------------------------------------------
func_angervaks_verify_settings_t1(){
    #--------------------
    if [ "$S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP" == "$S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP_UNINITED_VALUE" ]; then
        S_TMP_0="The S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP "
        S_TMP_1="needs to be initialized at the function named "
        S_TMP_2="func_this_script_is_meant_to_be_customized_by_customizing_this_function() "
        S_TMP_3="before the very first call to the function func_create_tarfile(..)."
        func_mmmv_exc_exit_with_an_error_t2 \
            "756db91b-6c8a-4203-b5a0-319321e0c4e7" \
            "$S_TMP_0$S_TMP_1$S_TMP_2$S_TMP_3"
    fi
    #--------------------
    func_mmmv_assert_folder_exists_t1 \
        "$S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP" \
        "150db3d2-b8ea-4e7c-8390-319321e0c4e7"
    #--------------------
    if [ "$S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS" == "$S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS_UNINITED_VALUE" ]; then
        S_TMP_0="The S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS "
        S_TMP_1="needs to be initialized at the function named "
        S_TMP_2="func_this_script_is_meant_to_be_customized_by_customizing_this_function() "
        S_TMP_3="before the very first call to the function func_create_tarfile(..)."
        func_mmmv_exc_exit_with_an_error_t2 \
            "26409ea1-2f24-4086-b490-319321e0c4e7" \
            "$S_TMP_0$S_TMP_1$S_TMP_2$S_TMP_3"
    fi
    #--------------------
    if [ "$SB_COMPRESS_TARFILES" != "t" ]; then
        if [ "$SB_COMPRESS_TARFILES" != "f" ]; then
            S_TMP_0="The SB_COMPRESS_TARFILES=\"$SB_COMPRESS_TARFILES\", but "
            S_TMP_1="the only valid values for the SB_COMPRESS_TARFILES "
            S_TMP_2="are \"t\" and \"f\"."
            func_mmmv_exc_exit_with_an_error_t2 \
                "9d28ba2f-3836-422b-9190-319321e0c4e7" \
                "$S_TMP_0$S_TMP_1$S_TMP_2"
        fi
    fi
    #--------------------
} # func_angervaks_verify_settings_t1

#--------------------------------------------------------------------------

# The 
func_angervaks_create_folder_for_tar_files_if_it_does_not_exist(){
    # must be called only after the func_angervaks_verify_settings_t1 
    # has been already called.
    #--------------------
    if [ "$S_FP_BACKUP_FOLDER" == "" ]; then
        func_mmmv_exc_exit_with_an_error_t2 \
            "36822053-cd16-4ee4-b390-319321e0c4e7" "This script is flawed."
    fi
    #--------------------
    S_TMP_0="copy_of_$S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS"
    S_FP_BACKUP_FOLDER="$S_FP_DIR/$S_PATHLESS_NAME_OF_THE_FOLDER_OF_BACKUP_FOLDERS/$S_TIMESTAMP_AS_NAME_PREFIX$S_TMP_0"
    #--------------------
    if [ -e "$S_FP_BACKUP_FOLDER" ]; then
        # To output an error message, if it is a file or a symlink to a file.
        func_mmmv_assert_folder_exists_t1 "$S_FP_BACKUP_FOLDER" \
            "c8cf4ea1-e166-4051-8290-319321e0c4e7"
    else
        if [ -h "$S_FP_BACKUP_FOLDER" ]; then
            func_mmmv_exc_exit_with_an_error_t2 \
                "5623037f-561c-41aa-8490-319321e0c4e7" \
                "The S_FP_BACKUP_FOLDER=\"$S_FP_BACKUP_FOLDER\" is a broken symlink."
        else
            func_mmmv_create_folder_t1 "$S_FP_BACKUP_FOLDER"
        fi
    fi
} # func_angervaks_create_folder_for_tar_files_if_it_does_not_exist

#--------------------------------------------------------------------------
SB_COMPRESS_TARFILES="f"

func_angervaks_compress_tarfile_with_xz_if_requested(){
    local S_FP_TARFILE="$1"
    if [ "$SB_COMPRESS_TARFILES" == "t" ]; then
        #--------------------
        func_mmmv_assert_file_exists_t1 "$S_FP_TARFILE" \
            "4624ea1c-33b2-4dbb-b390-319321e0c4e7"
        #--------------------
        printf "Using xz to compress the file $S_FP_TARFILE .. "
        nice -n 19 xz -1 "$S_FP_TARFILE"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "c637b35d-02d9-4c3b-b590-319321e0c4e7"
        func_mmmv_wait_and_sync_t1
        S_TMP_0=".xz"
        func_mmmv_assert_file_exists_t1 "$S_FP_TARFILE$S_TMP_0" \
            "c570845c-dbed-440f-b180-319321e0c4e7"
        echo "compression complete."
    else
        if [ "$SB_COMPRESS_TARFILES" != "f" ]; then
            S_TMP_0="This script is flawed. SB_COMPRESS_TARFILES==\"$SB_COMPRESS_TARFILES\", but "
            S_TMP_1="that flaw should have been caught at the function named " 
            S_TMP_2="func_angervaks_verify_settings_t1(), because "
            S_TMP_3="that way the execution of this script is stopped "
            S_TMP_4="before the creaton of some files and folders."
            func_mmmv_exc_exit_with_an_error_t2 \
                "8fa0bc04-7963-45cc-9180-319321e0c4e7" \
                "$S_TMP_0$S_TMP_1$S_TMP_2$S_TMP_3$S_TMP_4"
        fi
    fi
} # func_angervaks_compress_tarfile_with_xz_if_requested

#--------------------------------------------------------------------------

func_create_tarfile(){
    local S_FN="$1"
    #--------------------
    func_angervaks_verify_settings_t1
    local S_FP_SOURCE_FOLDER="$S_FULL_PATH_OF_THE_FOLDER_THAT_CONTAINS_FOLDERS_SUBJECT_TO_BACKUP/$S_FN"
    func_mmmv_assert_folder_exists_t1 "$S_FP_SOURCE_FOLDER" \
        "2154c073-d3d2-4976-8580-319321e0c4e7"
    #--------
    func_angervaks_create_folder_for_tar_files_if_it_does_not_exist
    if [ "$S_FP_BACKUP_FOLDER" == "" ]; then
        func_mmmv_exc_exit_with_an_error_t2 \
            "2070d623-7206-4313-a180-319321e0c4e7" "This script is flawed."
    fi
    if [ "$S_FP_BACKUP_FOLDER" == "$S_FP_BACKUP_FOLDER_UNINITED_VALUE" ]; then
        func_mmmv_exc_exit_with_an_error_t2 \
            "742d2f64-4e71-4717-bb80-319321e0c4e7" "This script is flawed."
    fi
    #--------
    local S_TMP_0=".tar"
    local S_FP_TARFILE="$S_FP_BACKUP_FOLDER/$S_TIMESTAMP_AS_NAME_PREFIX$S_FN$S_TMP_0"
    if [ -e "$S_FP_TARFILE" ]; then
        func_mmmv_exc_exit_with_an_error_t2 \
            "3b5d133f-1797-41a7-9380-319321e0c4e7" \
            "S_FP_TARFILE=\"$S_FP_TARFILE\" already exists."
    else
        if [ -h "$S_FP_TARFILE" ]; then
            func_mmmv_exc_exit_with_an_error_t2 \
                "49d12f21-520e-4bc3-8f80-319321e0c4e7" \
                "The S_FP_TARFILE=\"$S_FP_TARFILE\" already exists as a broken symlink."
        fi
    fi
    #--------
    nice -n 18 tar -cf  "$S_FP_TARFILE" "$S_FP_SOURCE_FOLDER"
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "32803c4a-9480-48a3-8180-319321e0c4e7"
    func_mmmv_wait_and_sync_t1
    func_mmmv_assert_file_exists_t1 "$S_FP_TARFILE" \
        "2d34a45f-2441-4e38-8580-319321e0c4e7"
    #--------
    func_angervaks_compress_tarfile_with_xz_if_requested "$S_FP_TARFILE"
} # func_create_tarfile

echo ""
func_this_script_is_meant_to_be_customized_by_customizing_this_function
echo ""

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0
#==========================================================================
