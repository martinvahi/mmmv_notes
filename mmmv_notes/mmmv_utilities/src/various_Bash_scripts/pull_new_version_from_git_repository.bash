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
S_VERSION_OF_THIS_SCRIPT="5ed477b2-19f6-4549-92cc-b3c1215125e7" # a GUID
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
        echo "GUID=='3a5ff344-c9cb-4e1a-accc-b3c1215125e7'"
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
        echo "GUID=='61e1472d-1ddc-469e-b5cc-b3c1215125e7'"
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
        echo "GUID=='db0e632d-8eb8-4beb-85cc-b3c1215125e7'"
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
        echo "GUID=='36f90cb4-b0f0-42e4-9ccc-b3c1215125e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='63f5b6ec-4062-4113-81bc-b3c1215125e7'"
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
                echo "GUID=='e036e230-9cdc-41ce-83bc-b3c1215125e7'"
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
            echo "GUID=='2d9b3af2-9afc-42df-a1bc-b3c1215125e7'"
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
            echo "GUID=='e1ff9536-2642-4041-a5bc-b3c1215125e7'"
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
            echo "GUID=='5ee2ce25-ee71-45b2-94bc-b3c1215125e7'"
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
                    echo "GUID=='53bdd738-b8ce-4e9a-83bc-b3c1215125e7'"
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
        echo "GUID=='4363f43a-9bed-4db9-b4bc-b3c1215125e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='f8db5014-1737-4c51-81ac-b3c1215125e7'"
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
                echo "GUID=='ad7c8c56-abd8-4510-92ac-b3c1215125e7'"
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
            echo "GUID=='215f9633-ced1-4297-94ac-b3c1215125e7'"
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
            echo "GUID=='3df3b749-6fe4-4346-83ac-b3c1215125e7'"
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
            echo "GUID=='953a6b3c-21ee-4e05-84ac-b3c1215125e7'"
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
                    echo "GUID=='b1a59802-e4e1-4243-aeac-b3c1215125e7'"
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
        echo "  GUID=='20239a85-d956-44ce-bbac-b3c1215125e7'"
        echo ""
        echo "  Aborting script without doing anything."
        echo ""
        echo "GUID=='3a97aa38-3255-4b55-b29c-b3c1215125e7'"
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
            fun_exc_exit_with_an_error_t1 "f93c8a4c-5454-47ac-95cc-b3c1215125e7"
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
            fun_exc_exit_with_an_error_t1 "c8ee133b-d8ca-4779-a1cc-b3c1215125e7"
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
        "e347b156-53be-4f79-b5bc-b3c1215125e7" "t"
    if [ ! -e "$S_FP_THE_REPOSITORY_CLONES" ]; then
        printf "Starting to unpack the $S_FN_THE_REPOSITORY_CLONES_TAR .."
        nice -n 10 tar -xf "$S_FP_THE_REPOSITORY_CLONES_TAR" 
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "359557b7-786b-4019-92bc-b3c1215125e7"
        echo " unpacking complete."
        func_wait_and_sync
        func_mmmv_assert_folder_exists_t1 "$S_FP_THE_REPOSITORY_CLONES" \
            "61d3ed7f-6af8-4679-87bc-b3c1215125e7" "t"
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
            "30a8c883-ca05-4dae-a1bc-b3c1215125e7" "t"
        #--------
        local S_TMP_0=".renamed_at_$S_TIMESTAMP"
        local S_FP_TAR_OLD="$S_FP_THE_REPOSITORY_CLONES_TAR$S_TMP_0"
        local SB_RENAMING_REQUIRED="f"
        if [ -e "$S_FP_THE_REPOSITORY_CLONES_TAR" ]; then 
            SB_RENAMING_REQUIRED="t"
            mv "$S_FP_THE_REPOSITORY_CLONES_TAR" "$S_FP_TAR_OLD"
            func_mmmv_assert_error_code_zero_t1 "$?" \
                "0e14bad5-33f6-4227-94bc-b3c1215125e7"
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
            echo "GUID=='93317111-bb5f-4953-a19c-b3c1215125e7'"
            echo ""
            cd "$S_FP_ORIG"
            exit 1 # exit with an error
        fi
        #--------
        cd "$S_FP_DIR"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "8b006458-bec5-4607-95bc-b3c1215125e7"
        if [ "$SB_RENAMING_REQUIRED" == "t" ]; then
            printf "Starting to recreate the $S_FN_THE_REPOSITORY_CLONES_TAR .."
        else
            if [ "$SB_RENAMING_REQUIRED" == "f" ]; then
                printf "Starting to create the $S_FN_THE_REPOSITORY_CLONES_TAR .."
            else
                fun_exc_exit_with_an_error_t1 "a2acbd5e-4b54-47e5-84bc-b3c1215125e7"
            fi
        fi
        nice -n 10 tar -cf "./$S_FN_THE_REPOSITORY_CLONES_TAR" "./$S_FN_THE_REPOSITORY_CLONES" 2> /dev/null
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "d0f1664a-89c3-4926-b2ac-b3c1215125e7"
        func_wait_and_sync
        echo " tar-file creation complete."
        #--------
    else
        if [ "$SB_CREATE_TAR" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "66ab831d-4197-4b44-b4ac-b3c1215125e7"
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
                fun_exc_exit_with_an_error_t1 "7b30a850-51ba-4a0b-a1ac-b3c1215125e7"
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
                echo "GUID=='4b864e2e-72f1-4c79-959c-b3c1215125e7'"
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
                    "39197e55-e41a-4fa6-b3ac-b3c1215125e7" "t"
            fi
        else
            # The 
            func_mmmv_assert_folder_exists_t1 \
                "$S_FP_THE_REPOSITORY_CLONES" \
                "ed234d2a-4dc4-4f2a-a4ac-b3c1215125e7" "t"
            # is for testing that it is not a symlink and not a file.
            if [ "$SB_OK_TO_EXIT_WITH_ERR_CODE_0" == "t" ]; then 
                echo ""
                echo "The folder "
                echo ""
                echo "    $S_FP_THE_REPOSITORY_CLONES"
                echo ""
                echo "already exists. Nothing to initialize."
                echo "GUID=='2270c11c-5660-460e-849c-b3c1215125e7'"
                echo ""
                cd "$S_FP_ORIG"
                exit 0 # exit without any errors
            fi
        fi
    else
        if [ "$SB_RUN_INIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "165b9247-707b-4e9c-b1ac-b3c1215125e7"
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
        "0145b4c1-f97d-4fdf-93ac-b3c1215125e7" "t"
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
            fun_exc_exit_with_an_error_t1 "037eb752-c00b-4eb5-839c-b3c1215125e7"
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
            fun_exc_exit_with_an_error_t1 "c66ea73d-c02e-4755-a49c-b3c1215125e7"
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
             echo "GUID=='457c49fd-a0b1-4194-b49c-b3c1215125e7'"
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
            fun_exc_exit_with_an_error_t1 "9871a751-d7f2-4bf6-ad9c-b3c1215125e7"
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
        echo "GUID=='5db5ef01-be3f-4970-829c-b3c1215125e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1 # exit with an error
    fi
    if [ "$S_FP_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID=='50558861-72ea-4e08-a68c-b3c1215125e7'"
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
        echo "GUID=='b35cd9f1-dd42-46e9-828c-b3c1215125e7'"
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
            echo "GUID=='4f97a628-9802-4619-858c-b3c1215125e7'"
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
                        echo "GUID=='45e240d5-34b7-4403-b38c-b3c1215125e7'"
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
        "cbebb11a-b1c4-4cff-a49c-b3c1215125e7"
    mkdir -p "$S_FP_CANDIDATE"
    func_wait_and_sync
    func_mmmv_assert_folder_exists_t1 \
        "$S_FP_CANDIDATE" \
        "79bb7034-7ec3-486c-b49c-b3c1215125e7" "t"
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
        "cf80485a-2471-4422-859c-b3c1215125e7"
    printf "%b" "" > $S_FP_CANDIDATE # the echo "" would add a linebreak
    wait
    func_wait_and_sync
    func_mmmv_assert_file_exists_t1 \
        "$S_FP_CANDIDATE" \
        "fcfe7f17-29f6-42ff-849c-b3c1215125e7" "t"
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
        echo "GUID=='bba19752-5f92-4e82-ba8c-b3c1215125e7'"
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
            fun_exc_exit_with_an_error_t1 "f2c8e23d-92e2-4aa6-8f8c-b3c1215125e7"
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
    echo "GUID=='c687b11e-8f1d-42a5-948c-b3c1215125e7'"
    echo ""
    cd "$S_FP_ORIG"
    exit 1 # exit with an error
else
    if [ "$SB_INVALID_COMMAND_LINE_ARGUMENTS" != "f" ]; then 
        fun_exc_exit_with_an_error_t1 "897a2015-edaa-43ad-a48c-b3c1215125e7"
    fi
fi

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0 # exit without any errors
#==========================================================================

