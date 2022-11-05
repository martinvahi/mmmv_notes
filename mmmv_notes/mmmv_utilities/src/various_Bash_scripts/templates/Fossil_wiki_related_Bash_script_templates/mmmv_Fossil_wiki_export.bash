#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
S_FP_FOSSILREPOSITORY="/a/path/to/the/relevant.fossilrepository"
S_OPTIONAL_STARTLINE_LABEL="Some name to avoid accidental confusion "

func_ask_this_script_to_be_updated(){
    echo ""
    echo -e "\e[31mPlease customise this script\e[39m"
    echo "    ${BASH_SOURCE[0]}"
    echo -e "\e[31mbefore its first use.\e[39m The global variable that "
    echo "needs a custom value is S_FP_FOSSILREPOSITORY "
    echo "GUID=='75061637-a54b-49d2-8464-a1e0e01166e7'"
    echo ""
    #--------
    exit 1;
} # func_ask_this_script_to_be_updated
#func_ask_this_script_to_be_updated

# Everything below this line is implementation and it has the structure of:
# 
#     <boilerplate mostly in the form of function declarations>
#     <string "end_of_boilerplate", without the quotationmarks>
#     <application specific global variables and function declarations>
#     func_main # is the main code entry point
#
# There are some global variables.
#--------------------------------------------------------------------------
S_FP_ORIG="`pwd`"

#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
    wait # for sync
} # func_mmmv_wait_and_sync_t1

#--------------------------------------------------------------------------
func_mmmv_exc_verify_S_FP_ORIG_t1() {
    if [ "$S_FP_ORIG" == "" ]; then
        echo ""
        echo -e "\e[31mThe code of this script is flawed. \e[39m"
        echo "The environment variable S_FP_ORIG is expected "
        echo "to be initialized at the start of the script by "
        echo ""
        echo "    S_FP_ORIG=\"\`pwd\`\""
        echo ""
        echo "Aborting script."
        echo "GUID=='74ce6747-6e43-4245-a264-a1e0e01166e7'"
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
        echo -e "\e[31mAborting script. \e[39m"
        echo "GUID=='ad439218-2669-44fc-b264-a1e0e01166e7'"
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
        echo -e "\e[31mAborting script. \e[39m"
        echo "GUID=='db06d03b-6cd6-4b25-b164-a1e0e01166e7'"
        echo ""
        exit 1 # exit with an error
    fi
} # func_mmmv_exc_verify_S_FP_ORIG_t1

#--------------------------------------------------------------------------
FUNC_MMMV_EXC_VERIFY_S_FP_ORIG_T2_S_FB_ORIG_ALREADY_VERIFIED="f"
func_mmmv_exc_verify_S_FP_ORIG_t2(){
    if [ "$FUNC_MMMV_EXC_VERIFY_S_FP_ORIG_T2_S_FB_ORIG_ALREADY_VERIFIED" != "t" ]; then
        if [ "$FUNC_MMMV_EXC_VERIFY_S_FP_ORIG_T2_S_FB_ORIG_ALREADY_VERIFIED" != "f" ]; then
            echo ""
            echo -e "\e[31mThe code that calls this function is flawed. \e[39m"
            echo "The global variable "
            echo ""
            echo "    FUNC_MMMV_EXC_VERIFY_S_FP_ORIG_T2_S_FB_ORIG_ALREADY_VERIFIED==\"$FUNC_MMMV_EXC_VERIFY_S_FP_ORIG_T2_S_FB_ORIG_ALREADY_VERIFIED\""
            echo ""
            echo "has a domain of {\"f\", \"t\"}."
            echo "GUID=='3e1f1a2f-f824-450e-9564-a1e0e01166e7'"
            echo ""
        else
            func_mmmv_exc_verify_S_FP_ORIG_t1
            FUNC_MMMV_EXC_VERIFY_S_FP_ORIG_T2_S_FB_ORIG_ALREADY_VERIFIED="t"
        fi
    fi
} # func_mmmv_exc_verify_S_FP_ORIG_t2

#--------------------------------------------------------------------------
func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME="$1"
    #----------------------------------------------------------------------
    func_mmmv_exc_verify_S_FP_ORIG_t2
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo -e "\e[31mCommand \"$S_COMMAND_NAME\" could not be found from the PATH. \e[39m"
        echo "The execution of this Bash script is aborted."
        echo "GUID=='0ada055e-eb09-4abc-b454-a1e0e01166e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

#--------------------------------------------------------------------------
func_mmmv_assert_file_exists_t1() {
    local S_FP="$1"
    local S_GUID_CANDIDATE="$2"
    local SB_OPTIONAL_BAN_SYMLINKS="$3" # domain: {"t", "f", ""} default: "f"
                                        # is the last formal parameter 
                                        # in stead of the S_GUID_CANDIDATE, 
                                        # because that way this function is 
                                        # backwards compatible with 
                                        # an earlier version of this 
                                        # function.
    #----------------------------------------------------------------------
    func_mmmv_exc_verify_S_FP_ORIG_t2
    local SB_LACK_OF_PARAMETERS="f"
    if [ "$S_FP" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$SB_LACK_OF_PARAMETERS" == "t" ]; then
        echo ""
        echo -e "\e[31mThe code that calls this function is flawed. \e[39m"
        echo "This function requires 2 parameters, which are "
        echo "S_FP, S_GUID_CANDIDATE, and it has an optional 3. parameter, "
        echo "which is SB_OPTIONAL_BAN_SYMLINKS."
        if [ "$S_GUID_CANDIDATE" != "" ]; then
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        fi
        echo "GUID=='4d4fab5d-b703-4edf-8354-a1e0e01166e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo -e "\e[31mThis code is flawed. \e[39m"
            echo "GUID=='d7e3f01f-dd29-4deb-8354-a1e0e01166e7'"
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
    #------------------------------
    if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "" ]; then
        # The default value of the 
        SB_OPTIONAL_BAN_SYMLINKS="f"
        # must be backwards compatible with the
        # version of this function, where 
        # symlinks to files were treated as actual files.
    else
        if [ "$SB_OPTIONAL_BAN_SYMLINKS" != "t" ]; then
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" != "f" ]; then
                echo ""
                echo "The "
                echo ""
                echo "    SB_OPTIONAL_BAN_SYMLINKS==\"$SB_OPTIONAL_BAN_SYMLINKS\""
                echo ""
                echo "but the valid values for the SB_OPTIONAL_BAN_SYMLINKS"
                echo "are: \"t\", \"f\", \"\"."
                echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
                echo "GUID=='34ac9960-ee6c-4f8c-a354-a1e0e01166e7'"
                echo ""
                #--------
                cd "$S_FP_ORIG"
                exit 1 # exiting with an error
            fi
        fi
    fi
    #------------------------------
    if [ ! -e "$S_FP" ]; then
        if [ -h "$S_FP" ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symlink, but "
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "t" ]; then
                echo "a file is expected."
            else
                echo "a file or a symlink to a file is expected."
            fi
            echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
            echo "GUID=='31f02174-c07c-4558-b154-a1e0e01166e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "t" ]; then
                echo "The file "
            else
                echo "The file or a symlink to a file "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
            echo "GUID=='475ae619-0b36-4990-9354-a1e0e01166e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    else
        if [ -d "$S_FP" ]; then
            echo ""
            if [ -h "$S_FP" ]; then
                echo "The symlink to an existing folder "
            else
                echo "The folder "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            printf "exists, but "
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "t" ]; then
                echo "a file is expected."
            else
                echo "a file or a symlink to a file is expected."
            fi
            echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
            echo "GUID=='645fb435-4f4f-450e-9154-a1e0e01166e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "t" ]; then
                if [ -h "$S_FP" ]; then 
                    echo ""
                    echo "The "
                    echo ""
                    echo "    $S_FP"
                    echo ""
                    echo "is a symlink to a file, but a file is expected."
                    echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
                    echo "GUID=='334e7152-a707-4c93-af54-a1e0e01166e7'"
                    echo ""
                    #--------
                    cd "$S_FP_ORIG"
                    exit 1 # exiting with an error
                fi
            fi
        fi
    fi
} # func_mmmv_assert_file_exists_t1

#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #----------------------------------------------------------------------
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        echo ""
        echo -e "\e[31mThe Bash code that calls this function is flawed. \e[39m"
        echo ""
        echo "    S_GUID_CANDIDATE==\"\""
        echo ""
        echo "but it is expected to be a GUID."
        echo "Aborting script."
        echo "GUID=='35c48295-7933-4b7e-a254-a1e0e01166e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #------------------------------
    # If the "$?" were evaluated in this function, 
    # then it would be "0" even, if it is
    # something else at the calling code.
    if [ "$S_ERR_CODE" != "0" ];then
        echo ""
        echo "Something went wrong. Error code: $S_ERR_CODE"
        echo -e "\e[31mAborting script. \e[39m"
        echo "GUID=='86fad343-3f80-46fd-9154-a1e0e01166e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #------------------------------
} # func_mmmv_assert_error_code_zero_t1

#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t3(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #----------------------------------------------------------------------
    func_mmmv_assert_error_code_zero_t1 "$S_ERR_CODE" "$S_GUID_CANDIDATE"
    func_mmmv_wait_and_sync_t1
    #------------------------------
} # func_mmmv_assert_error_code_zero_t3

#--------------------------------------------------------------------------
# For example grep returns error code 1, if no match is found.
func_mmmv_assert_error_code_zero_t3b_ignores_err_code_1(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #----------------------------------------------------------------------
    if [ "$S_ERR_CODE" != "0" ]; then
        if [ "$S_ERR_CODE" != "1" ]; then
            func_mmmv_assert_error_code_zero_t3 \
                "$S_ERR_CODE" "$S_GUID_CANDIDATE"
        fi
    fi
    #------------------------------
} # func_mmmv_assert_error_code_zero_t3b_ignores_err_code_1

#--------------------------------------------------------------------------
#::::::::::::::::::::::: end_of_boilerplate :::::::::::::::::::::::::::::::
#--------------------------------------------------------------------------
# The name of this scriptfile is assigned automatically to the $0 .
S_ARGV_0="$1"
S_ARGV_1="$2"
S_ARGV_2="$3"

S_FOSSIL_CMD_PREFIX="nice -n 6 fossil wiki "
S_FP_HTML="$S_FP_ORIG/wiki.html"
S_FOSSIL_WIKI_PAGE_NAME="should_be_S_ARGV_0_but_not_set_yet"
#--------------------------------------------------------------------------
func_display_help_message(){
    echo ""
    echo "The purpose of this Bash script is to simplify the calling of the "
    echo ""
    echo -e "    $S_FOSSIL_CMD_PREFIX --repository=\"\e[34m$S_FP_FOSSILREPOSITORY\e[39m\" export <name of the wiki page> > $S_FP_HTML "
    echo ""
    echo "where the fossilrepository file path "
    echo -e "is set at the start of this Bash script. \e[33m"
    echo ""
    echo "COMMAND_LINE_ARGUMENTS :== WIKI_PAGE_NAME EXPORT_FILE_PATH?"
    echo -e "\e[39m"
    echo "Thank You for studying this script :-)"
    echo "GUID=='c3f73e58-b833-41a1-8154-a1e0e01166e7'"
    echo ""
} # func_display_help_message

#--------------------------------------------------------------------------
func_if_needed_display_help_and_exit(){
    #----------------------------------------------------------------------
    local SB_DISPLAY_HELP_AND_EXIT="f" # domain: {"f","t"}
    #----------------------------------------------------------------------
    if [ "$S_ARGV_0" == "h" ]; then 
        SB_DISPLAY_HELP_AND_EXIT="t"
    fi
    if [ "$S_ARGV_0" == "-h" ]; then 
        SB_DISPLAY_HELP_AND_EXIT="t"
    fi
    if [ "$S_ARGV_0" == "-?" ]; then 
        SB_DISPLAY_HELP_AND_EXIT="t"
    fi
    if [ "$S_ARGV_0" == "help" ]; then 
        SB_DISPLAY_HELP_AND_EXIT="t"
    fi
    if [ "$S_ARGV_0" == "--help" ]; then 
        SB_DISPLAY_HELP_AND_EXIT="t"
    fi
    #----------------------------------------------------------------------
    if [ "$SB_DISPLAY_HELP_AND_EXIT" == "t" ]; then 
        func_display_help_message
        #--------
        cd "$S_FP_ORIG"
        exit 0 # no errors
    else
        if [ "$SB_DISPLAY_HELP_AND_EXIT" != "f" ]; then 
            echo -e "\e[31mThe code of thisfunction is flawed. \e[39m"
            echo "GUID=='657e52bf-2bed-4866-a754-a1e0e01166e7'"
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
    #----------------------------------------------------------------------
} # func_if_needed_display_help_and_exit

#--------------------------------------------------------------------------
func_export_wiki_page(){
    #----------------------------------------------------------------------
    rm -f "$S_FP_HTML"
    func_mmmv_assert_error_code_zero_t3 "$?" \
        "80d0bb2a-8969-4981-8464-a1e0e01166e7"
    $S_FOSSIL_CMD_PREFIX --repository="$S_FP_FOSSILREPOSITORY" export "$S_FOSSIL_WIKI_PAGE_NAME" > $S_FP_HTML
    func_mmmv_wait_and_sync_t1
    func_mmmv_assert_file_exists_t1 "$S_FP_HTML" \
        "004ff846-4f15-4175-9564-a1e0e01166e7"
    #----------------------------------------------------------------------
} # func_export_wiki_page

#--------------------------------------------------------------------------
# The following table has been assembled from the data that originates from 
#
#     https://misc.flogisoft.com/bash/tip_colors_and_formatting
#     https://web.archive.org/web/20220220202853/https://misc.flogisoft.com/bash/tip_colors_and_formatting
#
# Text foreground color codes:         |  Text background color codes:
#     39 --- Default foreground color  |      49  --- Default background color
#     30 --- Black                     |      40  --- Black
#     31 --- Red                       |      41  --- Red
#     32 --- Green                     |      42  --- Green
#     33 --- Yellow                    |      43  --- Yellow
#     34 --- Blue                      |      44  --- Blue
#     35 --- Magenta                   |      45  --- Magenta
#     36 --- Cyan                      |      46  --- Cyan
#     37 --- Light gray                |      47  --- Light gray
#     90 --- Dark gray                 |      100 --- Dark gray
#     91 --- Light red                 |      101 --- Light red
#     92 --- Light green               |      102 --- Light green
#     93 --- Light yellow              |      103 --- Light yellow
#     94 --- Light blue                |      104 --- Light blue
#     95 --- Light magenta             |      105 --- Light magenta
#     96 --- Light cyan                |      106 --- Light cyan
#     97 --- White                     |      107 --- White
#
# echo -e "Example \e[34mblue text\e[39m and text with the default text color."
#--------------------------------------------------------------------------
func_optionally_display_spacerline_01(){
    #echo ""
    if [ "$S_OPTIONAL_STARTLINE_LABEL" != "" ]; then
        echo -e "\e[36m:::::::::: $S_OPTIONAL_STARTLINE_LABEL \e[39m"
    else
        echo -e "\e[36m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\e[39m"
    fi
} # func_optionally_display_spacerline_01

func_optionally_display_spacerline_02(){
    #echo ""
    echo -e "\e[34m::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::\e[39m"
} # func_optionally_display_spacerline_02

#--------------------------------------------------------------------------
func_main(){
    #----------------------------------------------------------------------
    func_mmmv_exit_if_not_on_path_t2 "fossil"
    func_mmmv_assert_file_exists_t1 "$S_FP_FOSSILREPOSITORY" \
        "385f253f-b164-46cc-b164-a1e0e01166e7"
    #----------------------------------------------------------------------
    if [ "$S_ARGV_0" == "" ]; then 
        echo ""
        echo -e "\e[31mWiki page name is missing.\e[39m"
        echo "The 1. command line argument of this Bash script "
        echo "is expected to be the name of the wiki page "
        echo "that is supposed to be exported."
        echo -e "\e[31mAborting script. \e[39m"
        echo "GUID=='b209fe4c-1827-41a3-b154-a1e0e01166e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        S_FOSSIL_WIKI_PAGE_NAME="$S_ARGV_0"
        if [ "$S_ARGV_2" != "" ]; then 
            echo ""
            echo -e "\e[31mToo many command line arguments.\e[39m"
            func_display_help_message
            echo -e "\e[31mAborting script. \e[39m"
            echo "GUID=='b13a9245-9c4d-467b-a454-a1e0e01166e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            func_if_needed_display_help_and_exit 
            # Due to the previousline the next line might not be reached.
            func_optionally_display_spacerline_01
            if [ "$S_ARGV_1" != "" ]; then 
                S_FP_HTML="$S_ARGV_1"
                func_export_wiki_page
            fi
            func_export_wiki_page
            func_optionally_display_spacerline_02
        fi
    fi
    #----------------------------------------------------------------------
    func_mmmv_wait_and_sync_t1 # for extra reliability.
    # The ext4 file system can get corrupted and at next boot
    #     ("fsck can Delete the Newest Version of a Fossil Repository File")
    #     https://fossil-scm.org/forum/forumpost/4a7ab4e586ea87850860b4955877ffc33c57790b766c838da08d63a4d2dc6deb
    #     archival copy: https://archive.ph/D53Iy
    #
    # There is no such problem with NilFS/NilFS2, so 
    # Fossil repository files should always be held 
    # on NilFS/NilFS2 partitions. A reminder: NilFS/NilFS2 requires 
    # a daemon to release the disk space after the deletion of files,
    # because deletion in NilFS/NilFS2 is equivalent to 
    # adding a note to the log that the files are deleted.
    #----------------------------------------------------------------------
} # func_main

func_main
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="55814331-42c8-47a1-8164-a1e0e01166e7"
#==========================================================================
