#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FP_PROEJCT_HOME="`cd $S_FP_DIR/../../; pwd`"
S_FP_BASH_BOILERPLATE="$S_FP_PROEJCT_HOME/bonnet/lib/2022_02_09_mmmv_bash_boilerplate_t2_locally_modified_version_t1/mmmv_bash_boilerplate_t2_locally_modified_version_t1.bash"
if [ -e "$S_FP_BASH_BOILERPLATE" ]; then
    if [ -d "$S_FP_BASH_BOILERPLATE" ]; then
        echo ""
        echo "A folder with the path of "
        echo ""
        echo "    S_FP_BASH_BOILERPLATE==$S_FP_BASH_BOILERPLATE"
        echo ""
        echo "exists, but a file is expected."
        echo "GUID=='1bd93ba4-5657-4fa1-9306-d1d05010a6e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    else
        source "$S_FP_BASH_BOILERPLATE"
    fi
else
    echo ""
    echo "~/.bashrc sub-part with the path of "
    echo ""
    echo "    S_FP_BASH_BOILERPLATE==$S_FP_BASH_BOILERPLATE"
    echo ""
    echo "could not be found."
    echo "GUID=='6be2163f-d23e-4356-8306-d1d05010a6e7'"
    echo ""
    #--------
    cd "$S_FP_ORIG"
    exit 1
fi

#--------------------------------------------------------------------------
func_mmmv_exit_if_not_on_path_t2 "aria2c"
func_mmmv_exit_if_not_on_path_t2 "grep"
func_mmmv_exit_if_not_on_path_t2 "tr"
#--------------------------------------------------------------------------
func_display_help_t1(){
    echo ""
    echo "COMMAND_LINE_ARGUMENTS :== HELP | CLEAR | DOWNLOAD "
    echo "                  HELP :== '--help'     | 'help'     | '-?' | '-h' | 'h' "
    echo "                 CLEAR :== '--clear'    | 'clear'    | 'c' "
    echo "              DOWNLOAD :== '--download' | 'download' | <empty string> "
    echo ""
} # func_display_help_t1 
#--------------------------------------------------------------------------
SB_MODE="mode_unset"
S_ARGV_0="$1"
if [ "$S_ARGV_0" == "" ]; then
    SB_MODE="mode_download"
else
    #--------------------
    if [ "$S_ARGV_0" == "--help" ]; then
        SB_MODE="mode_help"
    fi
    if [ "$S_ARGV_0" == "help" ]; then
        SB_MODE="mode_help"
    fi
    if [ "$S_ARGV_0" == "-?" ]; then
        SB_MODE="mode_help"
    fi
    if [ "$S_ARGV_0" == "-h" ]; then
        SB_MODE="mode_help"
    fi
    if [ "$S_ARGV_0" == "h" ]; then
        SB_MODE="mode_help"
    fi
    #--------------------
    if [ "$SB_MODE" == "mode_unset" ]; then
        #--------------------
        if [ "$S_ARGV_0" == "--clean" ]; then
            SB_MODE="mode_clear"
        fi
        if [ "$S_ARGV_0" == "clean" ]; then
            SB_MODE="mode_clear"
        fi
        if [ "$S_ARGV_0" == "--clear" ]; then
            SB_MODE="mode_clear"
        fi
        if [ "$S_ARGV_0" == "clear" ]; then
            SB_MODE="mode_clear"
        fi
        if [ "$S_ARGV_0" == "-c" ]; then
            SB_MODE="mode_clear"
        fi
        if [ "$S_ARGV_0" == "c" ]; then
            SB_MODE="mode_clear"
        fi
        #--------------------
    fi
    if [ "$SB_MODE" == "mode_unset" ]; then
        #--------------------
        if [ "$S_ARGV_0" == "--download" ]; then
            SB_MODE="mode_download"
        fi
        if [ "$S_ARGV_0" == "download" ]; then
            SB_MODE="mode_download"
        fi
        # The "d" is intentionally left out, because
        # the "d" might refer to the word "delete" and
        # the command line utility "dd" is also quite dangerous.
        #--------------------
    fi
    #--------------------
    if [ "$SB_MODE" == "mode_unset" ]; then
        echo ""
        S_TMP_0="argument"
        if [ "$2" != "" ]; then
            S_TMP_0="arguments"
        fi
        echo -e "\e[31mWrong command line $S_TMP_0. \e[39m"
        func_display_help_t1 
        echo "GUID=='1e1cf5c9-5caa-41de-9506-d1d05010a6e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #--------------------
fi
#--------------------------------------------------------------------------
SB_OPTIONAL_BAN_SYMLINKS="t"
#--------------------
S_FP_TORRENT_FILES_FOLDER="$S_FP_PROEJCT_HOME/bonnet/data/torrent_files"
func_mmmv_assert_folder_exists_t1 "$S_FP_TORRENT_FILES_FOLDER" \
    "e1915238-c0c5-4b62-a506-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
#--------------------
S_FP_DOWNLOAD_MAIN="$S_FP_PROEJCT_HOME/downloaded_files"
func_mmmv_assert_folder_exists_t1 "$S_FP_DOWNLOAD_MAIN" \
    "e963ec12-964c-4c84-9506-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
#--------------------
S_TMP_0="_download_attempt_incomplete"
S_FP_DOWNLOAD_FOLDER_INCOMPLETE="$S_FP_DOWNLOAD_MAIN/incomplete/$S_TIMESTAMP$S_TMP_0"
S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN="$S_FP_DOWNLOAD_MAIN/complete"
S_TMP_0="_download_attempt_complete"
S_FP_DOWNLOAD_FOLDER_COMPLETE="$S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN/$S_TIMESTAMP$S_TMP_0"
#--------------------------------------------------------------------------
AR_TORRENT_FILE_NAMES="at_some_point_this_variable_might_hold_an_array"
func_attempt_to_download_subpart_loop_01_iteration(){
    local S_ITER="$1" # array element, a torrent file name with a linebreak
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="t"
    local S_FP_TORRENT_CANDIDATE="/tmp/does_not_exist/not/properly/initailized/yet"
    #--------------------
    # The "tr" at the next 2 lines is for removing linereaks.
    local S_TMP_00="`printf \"$S_ITER\" | tr -d \"\\n\" | grep -E '[tT][oO][rR][rR][eE][nN][tT]$' `" 
    local S_TMP_01="`printf \"$S_ITER\" | tr -d \"\\n\" `" 
    #--------------------
    if [ "$S_TMP_00" != "" ]; then 
        #--------------------
        S_FP_TORRENT_CANDIDATE="$S_FP_TORRENT_FILES_FOLDER/$S_TMP_00"
        func_mmmv_assert_file_exists_t1 "$S_FP_TORRENT_CANDIDATE" \
            "e6da4928-5826-47ea-8406-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
        nice -n 4 aria2c "$S_FP_TORRENT_CANDIDATE"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "7eaf3d36-1dea-4ebb-8406-d1d05010a6e7"
        func_mmmv_wait_and_sync_t1
        #--------------------
    else
        #--------------------
        # A file or a folder or a symlink that 
        # does not have a name with the suffix ".torrent"
        if [ "$S_TMP_01" != "" ]; then 
            #--------------------
            echo -e "\e[33m$S_TMP_0\e[39m will not be used as a torrent file."
            #--------------------
        else
            #--------------------
            # Some sort of a flaw, where the array has an element 
            # that is an empty string or may be a strint that
            # consists of only spaces-tabs.
            func_mmmv_exc_exit_with_an_error_t1 \
                "f2383df6-8b5b-4cb7-a206-d1d05010a6e7"
            #--------------------
        fi
        #--------------------
    fi
} # func_attempt_to_download_subpart_loop_01_iteration
#--------------------------------------------------------------------------
func_attempt_to_download(){
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="t"
    #--------------------
    mkdir -p "$S_FP_DOWNLOAD_FOLDER_INCOMPLETE"
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "6f061924-e812-42ff-ad06-d1d05010a6e7"
    func_mmmv_wait_and_sync_t1
    func_mmmv_assert_folder_exists_t1 "$S_FP_DOWNLOAD_FOLDER_INCOMPLETE" \
        "8412a84b-0954-468b-b206-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    #--------------------
    cd "$S_FP_DOWNLOAD_FOLDER_INCOMPLETE"
        #--------
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "24b15233-c309-4f3e-b706-d1d05010a6e7"
        func_mmmv_ar_ls_t1 "AR_TORRENT_FILE_NAMES" "$S_FP_TORRENT_FILES_FOLDER"
        func_mmmv_iterate_over_array_02n_t1 \
            "AR_TORRENT_FILE_NAMES" "" \
            "func_attempt_to_download_subpart_loop_01_iteration"
        #--------
    cd "$S_FP_DOWNLOAD_MAIN" # to get out of a folder that will be renamed
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "2c60b049-9cbc-4fc3-b306-d1d05010a6e7"
        #--------
        mkdir -p "$S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "bc06a05b-abc1-4962-b406-d1d05010a6e7"
        func_mmmv_wait_and_sync_t1
        func_mmmv_assert_folder_exists_t1 "$S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN" \
            "a5992e4d-649c-4de3-8106-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
        #--------
        mv "$S_FP_DOWNLOAD_FOLDER_INCOMPLETE" "$S_FP_DOWNLOAD_FOLDER_COMPLETE"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "1e4bac41-1963-4ee2-a406-d1d05010a6e7"
        func_mmmv_wait_and_sync_t1
        func_mmmv_assert_folder_exists_t1 "$S_FP_DOWNLOAD_FOLDER_COMPLETE" \
            "5d05a233-e1a6-4b69-be06-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    #--------------------
    echo ""
    echo -e "\e[32mDownload complete.\e[39m The dowloaded files reside at "
    echo ""
    echo "    $S_FP_DOWNLOAD_FOLDER_COMPLETE"
    echo ""
    #--------------------
} # func_attempt_to_download
#--------------------------------------------------------------------------
func_attempt_to_clear(){
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="t"
    local S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS="$S_FP_DOWNLOAD_MAIN/incomplete"
    func_mmmv_assert_folder_exists_t1 "$S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS" \
        "540d2cc4-1ee9-4df7-8206-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
    #--------------------
    cd "$S_FP_DOWNLOAD_MAIN" # for extra safety, just in case
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "37778b23-f96f-4256-bd06-d1d05010a6e7"
    echo ""
    echo -e "Starting to \e[31mdelete recursively \e[39m"
    echo ""
    echo -e "\e[33m    $S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS \e[39m"
    echo ""
    local S_WHATEVER_SUFFICIENTLY_SHORT_STRING
    read -p "after the ENTER key has been pushed " S_WHATEVER_SUFFICIENTLY_SHORT_STRING
    echo ""
    echo -e " in\e[33m 10 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  9 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  8 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  7 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  6 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  5 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  4 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  3 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  2 seconds \e[39m"
    sleep 1
    echo -e " in\e[33m  1 second  \e[39m"
    sleep 1
    printf "attempting to delete.."
    nice -n 4 rm -fr "$S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS"
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "a1d3fa4f-001c-489f-8406-d1d05010a6e7"
    func_mmmv_wait_and_sync_t1
    #--------------------
    local SB_OPTIONAL_BAN_SYMLINKS="t"
    if [ -e "$S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS" ]; then
        #--------
        echo ""
        echo -e "\e[31mDeletion failed.\e[39m"
        func_mmmv_assert_folder_exists_t1 "$S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS" \
            "37aa1011-9f2a-42d4-8ef5-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
        echo "GUID=='627d8537-0497-433f-a506-d1d05010a6e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
        #--------
    else
        if [ -h "$S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS" ]; then 
            # A broken symlink.
            func_mmmv_assert_folder_exists_t1 "$S_FP_ALL_INCOMPLETE_DOWNLOAD_ATTEMPTS" \
                "4932dbe9-b10f-4eb3-a2f5-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
        fi
    fi
    #--------------------
    echo ""
    echo "Intended deletion complete."
    if [ -e "$S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN" ]; then
        func_mmmv_assert_folder_exists_t1 "$S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN" \
            "77401f48-781d-4722-a2f5-d1d05010a6e7" "$SB_OPTIONAL_BAN_SYMLINKS"
        echo "The folder "
        echo ""
        echo "    $S_FP_DOWNLOAD_FOLDER_COMPLETE_MAIN"
        echo ""
        echo -e "was intentionally\e[33m left to exist\e[39m."
        echo ""
    fi
    #--------------------
} # func_attempt_to_clear
#--------------------------------------------------------------------------
if [ "$SB_MODE" == "mode_download" ]; then
    func_attempt_to_download
else
    if [ "$SB_MODE" == "mode_clear" ]; then
        func_attempt_to_clear
    else
        if [ "$SB_MODE" == "mode_help" ]; then
            func_display_help_t1
        else
            echo ""
            echo -e "\e[31mThe code of this script is flawed.\e[39m"
            echo "The control-flow should never reach this branch."
            echo "GUID=='7faf6d45-e6b5-4198-b506-d1d05010a6e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1
        fi
    fi
fi
#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="9f98c838-3dd3-4716-95f5-d1d05010a6e7"
#==========================================================================
