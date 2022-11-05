#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_VERSION_OF_THIS_SCRIPT="f528603d-e752-4172-82ed-d2b3f06176e7" # a GUID
#--------------------------------------------------------------------------
export GIT_SSL_NO_VERIFY=false
#export GIT_SSL_NO_VERIFY=true # to cope with local outdated 
#                              # root certificates. That can be 
#                              # the case with old Linux/BSD distributions.
#--------------------------------------------------------------------------
# For copy-pasting to the ~/.bashrc
#
#     alias mmmv_cre_git_clone="cp $PATH_TO_THE<$S_FP_DIR>/pull_new_version_from_git_repository.bash ./ ; mkdir -p ./the_repository_clones ;"
#
#--------------------------------------------------------------------------
func_wait_and_sync(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_wait_and_sync

fun_exc_exit_with_an_error_t1(){
    local S_GUID_CANDIDATE="$1" # first function argument
    if [ "$S_GUID_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID=='982bf248-5a9e-4897-a3fd-d2b3f06176e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    else
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
} # fun_exc_exit_with_an_error_t1 

fun_assert_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE="$1" # first function argument
    local S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE\" to be on the PATH."
        echo "GUID=='b3a5091d-08ef-4334-b4ed-d2b3f06176e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
} # fun_assert_exists_on_path_t1

fun_assert_exists_on_path_t1 "ruby"
fun_assert_exists_on_path_t1 "printf"
fun_assert_exists_on_path_t1 "grep"
fun_assert_exists_on_path_t1 "date"
fun_assert_exists_on_path_t1 "git"
fun_assert_exists_on_path_t1 "tar"
fun_assert_exists_on_path_t1 "basename"

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
        echo "GUID=='b730e74c-54fe-44a7-92ed-d2b3f06176e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1
    fi
} # func_mmmv_assert_error_code_zero_t1

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
    #------------------------------
    local SB_LACK_OF_PARAMETERS="f"
    if [ "$S_FP" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$SB_LACK_OF_PARAMETERS" == "t" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters, which are "
        echo "S_FP, S_GUID_CANDIDATE, and it has an optional 3. parameter, "
        echo "which is SB_OPTIONAL_BAN_SYMLINKS."
        if [ "$S_GUID_CANDIDATE" != "" ]; then
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        fi
        echo "GUID=='4d78c446-7647-427d-b2ed-d2b3f06176e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='2c69e6d4-4447-420e-a2ed-d2b3f06176e7'"
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
                echo "GUID=='23fac275-2747-4cfb-82ed-d2b3f06176e7'"
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
            echo "GUID=='5fdbb014-49ee-42ee-81ed-d2b3f06176e7'"
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
            echo "GUID=='2e598410-6420-4101-a3ed-d2b3f06176e7'"
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
            echo "GUID=='6902071c-7892-4c46-b3ed-d2b3f06176e7'"
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
                    echo "GUID=='45225f45-d712-47b5-a2ed-d2b3f06176e7'"
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

func_mmmv_assert_folder_exists_t1() {
    local S_FP="$1"
    local S_GUID_CANDIDATE="$2"
    local SB_OPTIONAL_BAN_SYMLINKS="$3" # domain: {"t", "f", ""} default: "f"
                                        # is the last formal parameter 
                                        # in stead of the S_GUID_CANDIDATE, 
                                        # because that way this function is 
                                        # backwards compatible with 
                                        # an earlier version of this 
                                        # function.
    #------------------------------
    local SB_LACK_OF_PARAMETERS="f"
    if [ "$S_FP" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$SB_LACK_OF_PARAMETERS" == "t" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters, which are "
        echo "S_FP, S_GUID_CANDIDATE, and it has an optional 3. parameter, "
        echo "which is SB_OPTIONAL_BAN_SYMLINKS."
        if [ "$S_GUID_CANDIDATE" != "" ]; then
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        fi
        echo "GUID=='3ff69d25-fff1-4e5b-a2dd-d2b3f06176e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='302a3034-f6ca-4f3d-a3dd-d2b3f06176e7'"
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
        # symlinks to folders were treated as actual folders.
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
                echo "GUID=='f23bce32-16db-446c-a4dd-d2b3f06176e7'"
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
                echo "a folder is expected."
            else
                echo "a folder or a symlink to a folder is expected."
            fi
            echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
            echo "GUID=='40f3f541-6c5c-4031-a4dd-d2b3f06176e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "t" ]; then
                echo "The folder "
            else
                echo "The folder or a symlink to a folder "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
            echo "GUID=='85c1443b-1c22-450c-b2dd-d2b3f06176e7'"
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
            printf "exists, but "
            if [ "$SB_OPTIONAL_BAN_SYMLINKS" == "t" ]; then
                echo "a folder is expected."
            else
                echo "a folder or a symlink to a folder is expected."
            fi
            echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
            echo "GUID=='e9cb9329-4aa6-4e61-82dd-d2b3f06176e7'"
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
                    echo "is a symlink to a folder, but a folder is expected."
                    echo "S_GUID_CANDIDATE==\"$S_GUID_CANDIDATE\""
                    echo "GUID=='1f19d259-c20f-49ce-91dd-d2b3f06176e7'"
                    echo ""
                    #--------
                    cd "$S_FP_ORIG"
                    exit 1 # exiting with an error
                fi
            fi
        fi
    fi
} # func_mmmv_assert_folder_exists_t1

#--------------------------------------------------------------------------
S_TMP_0="`uname -a | grep -E [Ll]inux`"
if [ "$S_TMP_0" == "" ]; then
    S_TMP_0="`uname -a | grep -E [Bb][Ss][Dd]`"
    if [ "$S_TMP_0" == "" ]; then
        echo ""
        echo "  The classical command line utilities at "
        echo "  different operating systems, for example, Linux and BSD,"
        echo "  differ. This script is designed to run only on Linux and BSD."
        echo "  If You are willing to risk that some of Your data "
        echo "  is deleted and/or Your operating system instance"
        echo "  becomes permanently flawed, to the point that "
        echo "  it will not even boot, then You may edit the Bash script that "
        echo "  displays this error message by modifying the test that "
        echo "  checks for the operating system type."
        echo ""
        echo "  If You do decide to edit this Bash script, then "
        echo "  a recommendation is to test Your modifications "
        echo "  within a virtual machine or, if virtual machines are not"
        echo "  an option, as some new operating system user that does not have "
        echo "  any access to the vital data/files."
        echo "  GUID=='f4ebeb31-2d73-43cf-a4dd-d2b3f06176e7'"
        echo ""
        echo "  Aborting script without doing anything."
        echo ""
        echo "GUID=='b9640743-bd29-4571-a2dd-d2b3f06176e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
fi

#--------------------------------------------------------------------------
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FP_ARCHIVE="$S_FP_DIR/archives/$S_TIMESTAMP"
S_FP_THE_REPOSITORY_CLONES="$S_FP_DIR/the_repository_clones"
S_FN_THE_REPOSITORY_CLONES="`basename \"$S_FP_THE_REPOSITORY_CLONES\"`"
S_TMP_0=".tar"
S_FP_THE_REPOSITORY_CLONES_TAR="$S_FP_THE_REPOSITORY_CLONES$S_TMP_0"
S_FN_THE_REPOSITORY_CLONES_TAR="`basename \"$S_FP_THE_REPOSITORY_CLONES_TAR\"`"

#--------------------------------------------------------------------------
S_ARGV_0="$1"
SB_SKIP_ARCHIVING="f"
SB_RUN_GIT_GARBAGE_COLLECTOR_ON_LOCAL_GIT_REPOSITORY="f"
SB_RUN_UPDATE="f"
SB_INVALID_COMMAND_LINE_ARGUMENTS="t"

fun_display_help_without_exiting(){
    echo ""
    echo "COMMAND_LINE_ARGUMENTS :== ( SKIP_ARCHIVING | SKIP_ARCHIVING_GC | "
    echo "                           | GC | PRP | HELP | VERSION | INIT | "
    echo "                           | CREATE_TAR )?"
    echo ""
    echo "     SKIP_ARCHIVING    :== 'skip_archiving'       | 'ska' "
    echo "     SKIP_ARCHIVING_GC :== 'skip_archiving_gc'    | 'ska_gc' | 'skagc'"
    echo "                    GC :== 'run_garbage_collector'| 'run_gc' |    'gc'"
    echo "                   PRP :== 'print_upstream_repository_path' | 'prp' "
    echo "                  HELP :== 'help'    | '-help'    | '-h' | '-?' "
    echo "               VERSION :== 'version' | '-version' | '-v' "
    echo "                  INIT :== 'init' "
    echo "            CREATE_TAR :== 'create_tar' | 'tar'  "
    echo ""
} # fun_display_help_without_exiting


fun_if_needed_display_help_and_exit_with_error_code_0(){
    local S_ERROR_CODE_IF
    #--------
    local SB_DISPLAY_HELP_AND_EXIT="f" # "f" for "false", "t" for "true"
    local AR_0=("help" "-help" "--help" \
                "\"help\"" "'help'" \
                "\"-help\"" "'-help'" \
                "\"--help\"" "'--help'" \
                "h" "\"h\"" "'h'" \
                "-h" "\"-h\"" "'-h'" \
                "?" "\"?\"" "'?'" \
                "-?" "\"-?\"" "'-?'" \
                "abi" "\"abi\"" "'abi'" \
                "-abi" "\"-abi\"" "'-abi'" \
                "--abi" "\"--abi\"" "'--abi'" \
                "apua" "\"apua\"" "'apua'" \
                "-apua" "\"-apua\"" "'-apua'" \
                "--apua" "\"--apua\"" "'--apua'" \
                )
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_DISPLAY_HELP_AND_EXIT="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------
    if [ "$SB_DISPLAY_HELP_AND_EXIT" == "t" ]; then 
        fun_display_help_without_exiting
        cd "$S_FP_ORIG"
        exit 0 # exit without any errors
    else
        if [ "$SB_DISPLAY_HELP_AND_EXIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "c267be2e-c26a-4dfa-b4ed-d2b3f06176e7"
        fi
    fi
} # fun_if_needed_display_help_and_exit_with_error_code_0
fun_if_needed_display_help_and_exit_with_error_code_0


#-------------------------------------------------------------------------
fun_if_needed_display_version_and_exit_with_an_error_code_0(){
    #--------
    local SB_DISPLAY_VERSION_AND_EXIT="f" # "f" for "false", "t" for "true"
    local AR_0=("versioon" "-versioon" "--versioon" \
                "-v" "v" \
                "version" "-version"  "--version" \
                "versio" "-versio" "--versio")
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_DISPLAY_VERSION_AND_EXIT="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------
    if [ "$SB_DISPLAY_VERSION_AND_EXIT" == "t" ]; then 
        echo ""
        echo "    S_VERSION_OF_THIS_SCRIPT == \"$S_VERSION_OF_THIS_SCRIPT\""
        echo ""
        cd "$S_FP_ORIG"
        exit 0 # exit without any errors
    else
        if [ "$SB_DISPLAY_VERSION_AND_EXIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "b6f73546-c5e8-4275-b2ed-d2b3f06176e7"
        fi
    fi
} # fun_if_needed_display_version_and_exit_with_an_error_code_0
fun_if_needed_display_version_and_exit_with_an_error_code_0

#-------------------------------------------------------------------------
# This is one way, how to simplify the storing of the 
# 
#     ./the_repository_clones
# 
# to a git repository that contains the parent folder of this script.
# This partially avoids the necessity to declare Git repository submodules.
fun_conditionally_unpack_the_repository_clones_tar(){
    #--------------------
    func_mmmv_assert_file_exists_t1 "$S_FP_THE_REPOSITORY_CLONES_TAR" \
        "2336329a-2428-4713-b2ed-d2b3f06176e7" "t"
    if [ ! -e "$S_FP_THE_REPOSITORY_CLONES" ]; then
        printf "Starting to unpack the $S_FN_THE_REPOSITORY_CLONES_TAR .."
        nice -n 10 tar -xf "$S_FP_THE_REPOSITORY_CLONES_TAR" 
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "f72a6d2e-261c-4244-81ed-d2b3f06176e7"
        echo " unpacking complete."
        func_wait_and_sync
        func_mmmv_assert_folder_exists_t1 "$S_FP_THE_REPOSITORY_CLONES" \
            "e8203be9-5d7c-4ad7-a4ed-d2b3f06176e7" "t"
    fi
    #--------------------
} # fun_conditionally_unpack_the_repository_clones_tar

#-------------------------------------------------------------------------

fun_create_a_tar_file_if_requested(){
    #--------------------
    local SB_CREATE_TAR="f"
    local AR_0=("-tar" "tar" "create_tar")
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_CREATE_TAR="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------------------
    if [ "$SB_CREATE_TAR" == "t" ]; then 
        #--------
        func_mmmv_assert_folder_exists_t1 \
            "$S_FP_THE_REPOSITORY_CLONES" \
            "3c8c4c52-5606-4dc5-91ed-d2b3f06176e7" "t"
        #--------
        local S_TMP_0=".renamed_at_$S_TIMESTAMP"
        local S_FP_TAR_OLD="$S_FP_THE_REPOSITORY_CLONES_TAR$S_TMP_0"
        local SB_RENAMING_REQUIRED="f"
        if [ -e "$S_FP_THE_REPOSITORY_CLONES_TAR" ]; then 
            SB_RENAMING_REQUIRED="t"
            mv "$S_FP_THE_REPOSITORY_CLONES_TAR" "$S_FP_TAR_OLD"
            func_mmmv_assert_error_code_zero_t1 "$?" \
                "65712e4b-222c-4c1d-b1ed-d2b3f06176e7"
            func_wait_and_sync
        fi
        if [ -e "$S_FP_THE_REPOSITORY_CLONES_TAR" ]; then 
            echo ""
            echo "Renameing of the "
            echo ""
            echo "    $S_FP_THE_REPOSITORY_CLONES_TAR"
            echo ""
            echo "to "
            echo ""
            echo "    $S_FP_TAR_OLD"
            echo ""
            echo "failed. No new tar file created."
            echo "GUID=='2cb4a2e3-0a40-436f-a7dd-d2b3f06176e7'"
            echo ""
            cd "$S_FP_ORIG"
            exit 1 # exit with an error
        fi
        #--------
        cd "$S_FP_DIR"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "427d67e4-8683-466d-91ed-d2b3f06176e7"
        if [ "$SB_RENAMING_REQUIRED" == "t" ]; then
            printf "Starting to recreate the $S_FN_THE_REPOSITORY_CLONES_TAR .."
        else
            if [ "$SB_RENAMING_REQUIRED" == "f" ]; then
                printf "Starting to create the $S_FN_THE_REPOSITORY_CLONES_TAR .."
            else
                fun_exc_exit_with_an_error_t1 "b1ebad66-47cd-4358-b3ed-d2b3f06176e7"
            fi
        fi
        nice -n 10 tar -cf "./$S_FN_THE_REPOSITORY_CLONES_TAR" "./$S_FN_THE_REPOSITORY_CLONES" 2> /dev/null
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "afd1852a-c11d-4ec6-b5dd-d2b3f06176e7"
        func_wait_and_sync
        echo " tar-file creation complete."
        #--------
    else
        if [ "$SB_CREATE_TAR" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "2a520f48-f279-4bd7-b2dd-d2b3f06176e7"
        fi
    fi
} # fun_create_a_tar_file_if_requested
fun_create_a_tar_file_if_requested

#-------------------------------------------------------------------------
fun_if_needed_create_the_folder_4_downloading_repositories_and_optionally_exit_with_an_error_code_0(){
    local SB_OPTIONAL_RUN_INIT_REGARDLESS_OF_S_ARGV_VALUE_AND_DO_NOT_EXIT="$1" # domain {"t", "f", ""} 
                                                                               # default: "f"
    #--------------------
    local SB_RUN_INIT="f"
    local SB_OK_TO_EXIT_WITH_ERR_CODE_0="t" # domain {"t", "f"}
    local AR_0=("init" "-init" "-i" "i" "initialize" "-initialize" "--untar" "-untar" "untar" "-ut" "ut")
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_RUN_INIT="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------------------
    if [ "$SB_OPTIONAL_RUN_INIT_REGARDLESS_OF_S_ARGV_VALUE_AND_DO_NOT_EXIT" == "" ]; then 
        SB_OPTIONAL_RUN_INIT_REGARDLESS_OF_S_ARGV_VALUE_AND_DO_NOT_EXIT="f" # the default value
    else
        if [ "$SB_OPTIONAL_RUN_INIT_REGARDLESS_OF_S_ARGV_VALUE_AND_DO_NOT_EXIT" != "t" ]; then 
            if [ "$SB_OPTIONAL_RUN_INIT_REGARDLESS_OF_S_ARGV_VALUE_AND_DO_NOT_EXIT" != "f" ]; then 
                fun_exc_exit_with_an_error_t1 "6bda52e1-7416-43fa-98dd-d2b3f06176e7"
            fi
        fi
    fi
    #--------------------
    if [ "$SB_OPTIONAL_RUN_INIT_REGARDLESS_OF_S_ARGV_VALUE_AND_DO_NOT_EXIT" == "t" ]; then 
        SB_RUN_INIT="t"
        SB_OK_TO_EXIT_WITH_ERR_CODE_0="f"
    fi
    #--------------------
    if [ "$SB_RUN_INIT" == "t" ]; then 
        if [ ! -e "$S_FP_THE_REPOSITORY_CLONES" ]; then 
            if [ -h "$S_FP_THE_REPOSITORY_CLONES" ]; then  # a broken symlink
                echo ""
                echo "The "
                echo ""
                echo "    $S_FP_THE_REPOSITORY_CLONES"
                echo ""
                echo "is a broken symlink. It is expected to be"
                echo "either missing or a folder."
                echo "GUID=='4a915493-5396-4cb8-b6cd-d2b3f06176e7'"
                echo ""
                cd "$S_FP_ORIG"
                exit 1 # exit with an error
            fi
            if [ -e "$S_FP_THE_REPOSITORY_CLONES_TAR" ]; then 
                fun_conditionally_unpack_the_repository_clones_tar
            else
                mkdir "$S_FP_THE_REPOSITORY_CLONES"
                func_wait_and_sync
                func_mmmv_assert_folder_exists_t1 \
                    "$S_FP_THE_REPOSITORY_CLONES" \
                    "cdc57917-a05b-45a8-92dd-d2b3f06176e7" "t"
            fi
        else
            # The 
            func_mmmv_assert_folder_exists_t1 \
                "$S_FP_THE_REPOSITORY_CLONES" \
                "2db9d325-ecd2-4b1b-b2dd-d2b3f06176e7" "t"
            # is for testing that it is not a symlink and not a file.
            if [ "$SB_OK_TO_EXIT_WITH_ERR_CODE_0" == "t" ]; then 
                echo ""
                echo "The folder "
                echo ""
                echo "    $S_FP_THE_REPOSITORY_CLONES"
                echo ""
                echo "already exists. Nothing to initialize."
                echo "GUID=='cb577ad1-9474-4160-a4cd-d2b3f06176e7'"
                echo ""
                cd "$S_FP_ORIG"
                exit 0 # exit without any errors
            fi
        fi
    else
        if [ "$SB_RUN_INIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "05e27e49-04dd-4e1e-81dd-d2b3f06176e7"
        fi
    fi
} # fun_if_needed_create_the_folder_4_downloading_repositories_and_optionally_exit_with_an_error_code_0
fun_if_needed_create_the_folder_4_downloading_repositories_and_optionally_exit_with_an_error_code_0

#-------------------------------------------------------------------------
AR_REPO_FOLDER_NAMES=()

fun_assemble_array_of_repository_clone_folder_names () {
    if [ -e "$S_FP_THE_REPOSITORY_CLONES_TAR" ]; then
        fun_conditionally_unpack_the_repository_clones_tar
    fi
    #--------------------
    func_mmmv_assert_folder_exists_t1 \
        "$S_FP_THE_REPOSITORY_CLONES" \
        "512ea833-18d4-4712-92dd-d2b3f06176e7" "t"
    #--------------------
    cd "$S_FP_THE_REPOSITORY_CLONES"
    local S_TMP_0="`ruby -e \"ar=Array.new; Dir.glob('*').each{|x| if File.directory? x then ar<<x end}; puts(ar.to_s.gsub('[','(').gsub(']',')').gsub(',',' '))\"`"
    cd "$S_FP_DIR"
    local S_TMP_1="AR_REPO_FOLDER_NAMES=$S_TMP_0"
    eval ${S_TMP_1}
} # fun_assemble_array_of_repository_clone_folder_names 


# The goal here is to be as greedy at downloading the different
# vertices of the repository version tree as possible.
# The instances of the clones that are being maintained
# with this script are not meant to be used directly for 
# development. Development deliverables are expected to 
# contain manually created copies of the clones 
# that this script is used for maintaining.
fun_update () {
    #--------
    local S_FP_PWD_AT_FUNC_START="`pwd`"
    fun_assemble_array_of_repository_clone_folder_names 
    #--------
    if [ "$SB_SKIP_ARCHIVING" == "f" ]; then 
        mkdir -p "$S_FP_ARCHIVE"
    else
        if [ "$SB_SKIP_ARCHIVING" != "t" ]; then 
            fun_exc_exit_with_an_error_t1 "dd17152e-7af4-4df3-93dd-d2b3f06176e7"
        fi
    fi
    #--------
    for s_iter in ${AR_REPO_FOLDER_NAMES[@]}; do
         S_FOLDER_NAME_OF_THE_LOCAL_COPY="$s_iter"
         echo ""
         #----
         if [ "$SB_SKIP_ARCHIVING" != "t" ]; then 
             echo "            Archiving a copy of $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
             cp -f -R $S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY $S_FP_ARCHIVE/
         else
             echo "            Skipping the archiving a copy of $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         fi
         #----
         cd "$S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         echo "Checking out a newer version of $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         #--------
         # Downloads the newest version of the software to that folder.
         nice -n10 git checkout --force # overwrites local changes, like the "svn co"
         nice -n10 git pull --all --recurse-submodules --force # gets the submodules
         #----
         # http://stackoverflow.com/questions/1030169/easy-way-pull-latest-of-all-submodules
         nice -n10 git submodule update --init --recursive --force 
         nice -n10 git submodule update --init --recursive --force --remote
         nice -n10 git pull --all --recurse-submodules --force # just in case
         if [ "$SB_RUN_GIT_GARBAGE_COLLECTOR_ON_LOCAL_GIT_REPOSITORY" == "t" ]; then 
             echo ""
             echo "Running the git garbage collector on the local repository..."
             # A citation from 
             #
             #     https://git-scm.com/docs/git-gc
             #
             #     --prune=<date>  Prune loose objects older 
             #                     than date (default is 2 weeks ago, 
             #                     overridable by the config variable 
             #                     gc.pruneExpire). --prune=all prunes 
             #                     loose objects regardless of their age
             #                     and increases the risk of corruption 
             #                     if another process is writing to 
             #                     the repository concurrently; 
             nice -n15 git gc --aggressive --prune=all 
             nice -n10 git pull --all --recurse-submodules --force # to be sure
         fi
         func_wait_and_sync
         #--------
         cd "$S_FP_DIR"
    done
    cd "$S_FP_PWD_AT_FUNC_START"
    echo ""
} # fun_update 


fun_run_update_if_needed(){
    #--------
    if [ "$S_ARGV_0" == "" ]; then  # the default action
        SB_RUN_UPDATE="t"
    fi
    if [ "$S_ARGV_0" == "skip_archiving" ]; then 
        SB_SKIP_ARCHIVING="t"
        SB_RUN_UPDATE="t"
    fi
    if [ "$S_ARGV_0" == "ska" ]; then # abbreviation of "skip_archiving"
        SB_SKIP_ARCHIVING="t"
        SB_RUN_UPDATE="t"
    fi
    #--------
    if [ "$S_ARGV_0" == "skip_archiving_gc" ]; then 
        SB_SKIP_ARCHIVING="t"
        SB_RUN_GIT_GARBAGE_COLLECTOR_ON_LOCAL_GIT_REPOSITORY="t"
        SB_RUN_UPDATE="t"
    fi
    if [ "$S_ARGV_0" == "ska_gc" ]; then # abbreviation of "skip_archiving_gc"
        SB_SKIP_ARCHIVING="t"
        SB_RUN_GIT_GARBAGE_COLLECTOR_ON_LOCAL_GIT_REPOSITORY="t"
        SB_RUN_UPDATE="t"
    fi
    if [ "$S_ARGV_0" == "skagc" ]; then  # abbreviation of "skip_archiving_gc"
        SB_SKIP_ARCHIVING="t"
        SB_RUN_GIT_GARBAGE_COLLECTOR_ON_LOCAL_GIT_REPOSITORY="t"
        SB_RUN_UPDATE="t"
    fi
    #--------
    if [ "$SB_RUN_UPDATE" == "t" ]; then 
        SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fun_update 
        cd "$S_FP_ORIG"
        exit 0 # exit without any errors
    else
        if [ "$SB_RUN_UPDATE" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "5857adb1-d47f-4b74-b5dd-d2b3f06176e7"
        fi
    fi
} # fun_run_update_if_needed
fun_run_update_if_needed

#--------------------------------------------------------------------------
fun_run_garbage_collector() {
    #--------
    local S_FP_PWD_AT_FUNC_START="`pwd`"
    local S_TMP_0="not_set"
    fun_assemble_array_of_repository_clone_folder_names 
    #--------
    echo ""
    for s_iter in ${AR_REPO_FOLDER_NAMES[@]}; do
         S_FOLDER_NAME_OF_THE_LOCAL_COPY="$s_iter"
         #----
         cd "$S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         echo "Running the garbage collector on $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         nice -n15 git gc --aggressive --prune=all 
         S_TMP_0="$?" 
         if [ "$S_TMP_0" != "0" ]; then 
             echo ""
             echo "Git exited with the error code of $S_TMP_0."
             echo "Aborting script."
             echo "GUID=='27689cdf-8cb8-4458-b2cd-d2b3f06176e7'"
             echo ""
             sync & # in the background, because 
                    # it might have been that the
                    # error is due to a lack of 
                    # access to a mounted drive
             cd "$S_FP_ORIG"
             exit $S_TMP_0 # exit with an error
         fi
         #----
         echo ""
         func_wait_and_sync
         cd "$S_FP_DIR"
    done
    #--------
    cd "$S_FP_PWD_AT_FUNC_START"
} # fun_run_garbage_collector

fun_run_garbage_collector_if_needed(){
    #--------
    local SB_RUN_GARBAGE_COLLECTOR="f" # "f" for "false", "t" for "true"
    local AR_0=("run_garbage_collector" "run_gc" "gc")
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_RUN_GARBAGE_COLLECTOR="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------
    if [ "$SB_RUN_GARBAGE_COLLECTOR" == "t" ]; then 
        fun_run_garbage_collector
        cd "$S_FP_ORIG"
        exit 0 # exit without any errors
    else
        if [ "$SB_RUN_GARBAGE_COLLECTOR" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "5d552828-3102-4c23-a1cd-d2b3f06176e7"
        fi
    fi
} # fun_run_garbage_collector_if_needed
fun_run_garbage_collector_if_needed

#--------------------------------------------------------------------------
func_mmmv_assert_file_path_is_not_in_use_t1(){ 
    local S_FP_CANDIDATE=$1   # first function argument
    local S_GUID_CANDIDATE=$2 # second function argument
    #----------------------------------------------------------------------
    if [ "$S_GUID_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID=='c6aacc5c-80e9-4eae-81cd-d2b3f06176e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
    if [ "$S_FP_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID=='d70e0b1c-1040-4bdb-a5cd-d2b3f06176e7'"
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
    #--------------------------------------------
    if [ -e "$S_FP_CANDIDATE" ]; then 
        echo ""
        echo "The path "
        echo ""
        echo "    $S_FP_CANDIDATE"
        echo ""
        echo "is already in use."
        echo "Aborting script."
        echo "GUID=='71757c24-ad52-450a-95cd-d2b3f06176e7'"
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    else 
        if [ -h "$S_FP_CANDIDATE" ]; then  # references a broken symlink
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP_CANDIDATE"
            echo ""
            echo "is already in use. It references a broken symlink."
            echo "Aborting script."
            echo "GUID=='46c43b31-6575-4a85-85cd-d2b3f06176e7'"
            echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            cd "$S_FP_ORIG"
            exit 1 # exit with an error
        fi
    fi
} # func_mmmv_assert_file_path_is_not_in_use_t1

FUNC_MMMV_GENERATE_TEMPORARY_FILE_OR_FOLDER_PATH_T1_OUTPUT=""
# It does not create the file or folder, it just
# generates a full file path. It does not check, whether
# the parent folder of the new file or folder is 
# writable. 
func_mmmv_generate_temporary_file_or_folder_path_t1() {
    local S_FP_TMP_FOLDER_CANDIDATE="$PWD/_tmp"
    if [ ! -e "$S_FP_TMP_FOLDER_CANDIDATE" ]; then 
        S_FP_TMP_FOLDER_CANDIDATE="$PWD/tmp"
        if [ ! -e "$S_FP_TMP_FOLDER_CANDIDATE" ]; then 
            S_FP_TMP_FOLDER_CANDIDATE="$HOME/_tmp"
            if [ ! -e "$S_FP_TMP_FOLDER_CANDIDATE" ]; then 
                S_FP_TMP_FOLDER_CANDIDATE="$HOME/tmp"
                if [ ! -e "$S_FP_TMP_FOLDER_CANDIDATE" ]; then 
                    S_FP_TMP_FOLDER_CANDIDATE="/tmp"
                    if [ ! -e "$S_FP_TMP_FOLDER_CANDIDATE" ]; then 
                        echo ""
                        echo "The path of the temporary folder"
                        echo "could not be determined. Even the "
                        echo ""
                        echo "    /tmp"
                        echo ""
                        echo "does not exist. Aborting script."
                        echo "GUID=='42b532d6-983d-4623-94cd-d2b3f06176e7'"
                        echo ""
                        cd "$S_FP_ORIG"
                        exit 1 # exit with an error
                    fi
                fi
            fi
        fi
    fi
    #--------------------------------
    local S_FN="$S_TIMESTAMP"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    S_FN+="_"
    S_FN+="$RANDOM"
    #--------------------------------
    local S_FP_OUT="$S_FP_TMP_FOLDER_CANDIDATE/$S_FN"
    FUNC_MMMV_GENERATE_TEMPORARY_FILE_OR_FOLDER_PATH_T1_OUTPUT="$S_FP_OUT"
} # func_mmmv_generate_temporary_file_or_folder_path_t1

FUNC_MMMV_CREATE_EMPTY_TEMPORARY_FOLDER_T1_ANSWER=""
# Returns the full path of the folder. 
func_mmmv_create_empty_temporary_folder_t1() {
    func_mmmv_generate_temporary_file_or_folder_path_t1
    local S_FP_CANDIDATE="$FUNC_MMMV_GENERATE_TEMPORARY_FILE_OR_FOLDER_PATH_T1_OUTPUT"
    func_mmmv_assert_file_path_is_not_in_use_t1 "$S_FP_CANDIDATE" \
        "69618812-87c1-4580-95cd-d2b3f06176e7"
    mkdir -p "$S_FP_CANDIDATE"
    func_wait_and_sync
    func_mmmv_assert_folder_exists_t1 \
        "$S_FP_CANDIDATE" \
        "3d39b854-f3e9-4f59-a4cd-d2b3f06176e7" "t"
    FUNC_MMMV_CREATE_EMPTY_TEMPORARY_FOLDER_T1_ANSWER="$S_FP_CANDIDATE"
} # func_mmmv_create_empty_temporary_folder_t1

FUNC_MMMV_CREATE_EMPTY_TEMPORARY_FILE_T1_ANSWER=""
# Returns the full path of the file.
func_mmmv_create_empty_temporary_file_t1() {
    #--------------------------------------------------------------- 
    local S_OPTIONAL_SUFFIX_OF_THE_FILE_NAME="$1" # file extension, like ".txt"
    #--------------------------------------------------------------- 
    func_mmmv_generate_temporary_file_or_folder_path_t1
    local S_FP_CANDIDATE="$FUNC_MMMV_GENERATE_TEMPORARY_FILE_OR_FOLDER_PATH_T1_OUTPUT"
    if [ "$S_OPTIONAL_SUFFIX_OF_THE_FILE_NAME" != "" ]; then 
        S_FP_CANDIDATE+="$S_OPTIONAL_SUFFIX_OF_THE_FILE_NAME"
    fi
    func_mmmv_assert_file_path_is_not_in_use_t1 "$S_FP_CANDIDATE" \
        "6e1989a3-6c4a-4151-a5cd-d2b3f06176e7"
    printf "%b" "" > $S_FP_CANDIDATE # the echo "" would add a linebreak
    wait
    func_wait_and_sync
    func_mmmv_assert_file_exists_t1 \
        "$S_FP_CANDIDATE" \
        "1208b4f2-e9e4-453c-95cd-d2b3f06176e7" "t"
    FUNC_MMMV_CREATE_EMPTY_TEMPORARY_FILE_T1_ANSWER="$S_FP_CANDIDATE"
} # func_mmmv_create_empty_temporary_file_t1

#--------------------------------------------------------------------------
fun_print_upstream_repository_path() {
    #--------
    local S_FP_PWD_AT_FUNC_START="`pwd`"
    fun_assemble_array_of_repository_clone_folder_names 
    #--------
    func_mmmv_create_empty_temporary_file_t1 ".txt"
    local S_FP_TMP_ALL_REPO_PATHS="$FUNC_MMMV_CREATE_EMPTY_TEMPORARY_FILE_T1_ANSWER"
    #--------
    for s_iter in ${AR_REPO_FOLDER_NAMES[@]}; do
        S_FOLDER_NAME_OF_THE_LOCAL_COPY="$s_iter"
        #----
        cd "$S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY"
        nice -n2 git config remote.origin.url >> $S_FP_TMP_ALL_REPO_PATHS
                          # Prints the repository path to console. 
                          # As a single local repository can have multiple 
                          # push targets, the number of printed lines
                          # per local repository can be more than one.
        cd "$S_FP_DIR"
        #----
    done
    #--------
    # Sort the list with Ruby.
    # Tested with Ruby version 2.5.1p57
    nice -n5 ruby -e "s=IO.read('$S_FP_TMP_ALL_REPO_PATHS'); \
        ar=Array.new;\
        s.each_line{|s_line| ar<<s_line};\
        ar0=ar.sort;\
        i_len=ar0.size;\
        s_0=\"\";\
        i_len.times{|ix| s_0<<ar0[ix]};\
        puts s_0"
    #---------------------------------
    rm -f $S_FP_TMP_ALL_REPO_PATHS
    func_wait_and_sync
    if [ -e "$S_FP_TMP_ALL_REPO_PATHS" ]; then 
        echo ""
        echo "File deletion failed. File path:"
        echo ""
        echo "    $S_FP_TMP_ALL_REPO_PATHS"
        echo ""
        echo "Aborting script."
        echo "GUID=='eac7873c-0559-4a9f-a3bd-d2b3f06176e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
    #---------------------------------
    cd "$S_FP_PWD_AT_FUNC_START"
} # fun_print_upstream_repository_path

fun_print_upstream_repository_path_if_needed(){
    #--------
    local SB_PRINT_UPSTREAM_REPOSITORY_PATH="f" # "f" for "false", "t" for "true"
    local AR_0=("print_upstream_repository_path" "prp") # "rp" skipped due to 
                                                        # close similarity to the "rm",
                                                        # which might get accidentally 
                                                        # entered due to a typo
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_PRINT_UPSTREAM_REPOSITORY_PATH="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------
    if [ "$SB_PRINT_UPSTREAM_REPOSITORY_PATH" == "t" ]; then 
        fun_print_upstream_repository_path
        cd "$S_FP_ORIG"
        exit 0 # exit without any errors
    else
        if [ "$SB_PRINT_UPSTREAM_REPOSITORY_PATH" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "ffb0fc39-b473-4f81-b4cd-d2b3f06176e7"
        fi
    fi
} # fun_print_upstream_repository_path_if_needed
fun_print_upstream_repository_path_if_needed

#--------------------------------------------------------------------------

if [ "$SB_INVALID_COMMAND_LINE_ARGUMENTS" == "t" ]; then 
    echo ""
    echo "Wrong command line argument(s)."
    echo "Supported command line arguments "
    echo "can be displayed by using \"help\" as "
    echo "the single commandline argument."
    echo "Aborting script."
    echo "GUID=='34267713-a38c-4b05-97bd-d2b3f06176e7'"
    echo ""
    cd "$S_FP_ORIG"
    exit 1 # exit with an error
else
    if [ "$SB_INVALID_COMMAND_LINE_ARGUMENTS" != "f" ]; then 
        fun_exc_exit_with_an_error_t1 "aa6fa14a-9ddb-4c2b-94cd-d2b3f06176e7"
    fi
fi

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0 # exit without any errors
#==========================================================================

