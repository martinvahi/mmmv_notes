#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_VERSION_OF_THIS_SCRIPT="2b0cf793-9113-46d3-b164-63f23161c2e7" # a GUID
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
    local S_GUID_CANDIDATE=$1 # first function argument
    if [ "$S_GUID_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID=='169cd1a5-28df-47ac-9564-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    else
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
} # fun_exc_exit_with_an_error_t1 

fun_assert_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE=$1 # first function argument
    local S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE\" to be on the PATH."
        echo "GUID=='b0fce14d-946d-4b35-9464-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
} # fun_assert_exists_on_path_t1

fun_assert_exists_on_path_t1 "ruby"
fun_assert_exists_on_path_t1 "printf"
fun_assert_exists_on_path_t1 "grep"
fun_assert_exists_on_path_t1 "date"
fun_assert_exists_on_path_t1 "git"


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
        echo "  GUID=='aa324f26-9306-41f2-8164-63f23161c2e7'"
        echo ""
        echo "  Aborting script without doing anything."
        echo ""
        echo "GUID=='77271e13-35d6-4197-8454-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
fi


#--------------------------------------------------------------------------

S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FP_ARCHIVE="$S_FP_DIR/archives/$S_TIMESTAMP"
S_FP_THE_REPOSITORY_CLONES="$S_FP_DIR/the_repository_clones"

#--------------------------------------------------------------------------
S_ARGV_0="$1"
SB_SKIP_ARCHIVING="f"
SB_RUN_GIT_GARBAGE_COLLECTOR_ON_LOCAL_GIT_REPOSITORY="f"
SB_RUN_UPDATE="f"
SB_INVALID_COMMAND_LINE_ARGUMENTS="t"

fun_display_help_without_exiting(){
    echo ""
    echo "COMMAND_LINE_ARGUMENTS :== ( SKIP_ARCHIVING | SKIP_ARCHIVING_GC | "
    echo "                           | GC | PRP | HELP | VERSION | INIT)?"
    echo ""
    echo "     SKIP_ARCHIVING    :== 'skip_archiving'       | 'ska' "
    echo "     SKIP_ARCHIVING_GC :== 'skip_archiving_gc'    | 'ska_gc' | 'skagc'"
    echo "                    GC :== 'run_garbage_collector'| 'run_gc' |    'gc'"
    echo "                   PRP :== 'print_upstream_repository_path' | 'prp' "
    echo "                  HELP :== 'help'    | '-help'    | '-h' | '-?' "
    echo "               VERSION :== 'version' | '-version' | '-v' "
    echo "                  INIT :== 'init' "
    echo ""
} # fun_display_help_without_exiting


fun_if_needed_display_help_and_exit_with_error_code_0(){
    local S_ERROR_CODE_IF
    #--------
    local SB_DISPLAY_HELP_AND_EXIT="f" # "f" for "false", "t" for "true"
    local AR_0=("help" "-help" "\"help\"" "\"-help\"" "'help'" "'-help'" \
                "\"-h\"" "\"h\"" "'-h'" "'h'" \
                "\"-?\"" "\"?\"" "'-?'" "'?'" \
                "-?" "?" "-h" "h" "abi" "-abi" "apua" "-apua")
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_DISPLAY_HELP_AND_EXIT="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------
    if [ "$SB_DISPLAY_HELP_AND_EXIT" == "t" ]; then 
        fun_display_help_without_exiting
        cd $S_FP_ORIG
        exit 0 # exit without any errors
    else
        if [ "$SB_DISPLAY_HELP_AND_EXIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "6df1ba30-d151-463f-9564-63f23161c2e7"
        fi
    fi
} # fun_if_needed_display_help_and_exit_with_error_code_0
fun_if_needed_display_help_and_exit_with_error_code_0


#-------------------------------------------------------------------------
fun_if_needed_display_version_and_exit_with_an_error_code_0(){
    #--------
    local SB_DISPLAY_VERSION_AND_EXIT="f" # "f" for "false", "t" for "true"
    local AR_0=("versioon" "-versioon" "-v" "v" "version" "-version" "versio" "-versio")
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
        cd $S_FP_ORIG
        exit 0 # exit without any errors
    else
        if [ "$SB_DISPLAY_VERSION_AND_EXIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "ea540e41-caa0-456c-a364-63f23161c2e7"
        fi
    fi
} # fun_if_needed_display_version_and_exit_with_an_error_code_0
fun_if_needed_display_version_and_exit_with_an_error_code_0

#-------------------------------------------------------------------------
fun_exc_assert_repositories_clones_folder_is_missing_or_is_not_a_symlink_and_not_a_file(){
    local S_GUID_CANDIDATE=$1 # first function argument
    if [ "$S_GUID_CANDIDATE" == "" ]; then 
        fun_exc_exit_with_an_error_t1 "316a661e-bf3c-4e4f-b254-63f23161c2e7"
    fi
    #--------
    if [ -h "$S_FP_THE_REPOSITORY_CLONES" ]; then 
        echo ""
        echo "The "
        echo ""
        echo "    $S_FP_THE_REPOSITORY_CLONES"
        echo ""
        echo "is a symlink, but it is expected to be "
        echo "either missing or a folder."
        echo "Aborting script."
        echo "GUID=='ff8c8759-813a-4c55-a454-63f23161c2e7'"
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
    if [ -f "$S_FP_THE_REPOSITORY_CLONES" ]; then 
        echo ""
        echo "The "
        echo ""
        echo "    $S_FP_THE_REPOSITORY_CLONES"
        echo ""
        echo "is a file, but it is expected to be "
        echo "either missing or a folder."
        echo "Aborting script."
        echo "GUID=='e8b7ff48-ca68-41d3-8154-63f23161c2e7'"
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
} # fun_exc_assert_repositories_clones_folder_is_missing_or_is_not_a_symlink_and_not_a_file

#-------------------------------------------------------------------------
fun_if_needed_create_the_folder_4_downloading_repositories_and_exit_with_an_error_code_0(){
    #--------
    local SB_INIT_FS_AND_EXIT="f" # "f" for "false", "t" for "true"
    local AR_0=("init" "-init" "-i" "i" "initialize" "-initialize")
    for S_ITER in ${AR_0[@]}; do
        if [ "$S_ARGV_0" == "$S_ITER" ]; then 
            SB_INIT_FS_AND_EXIT="t"
            SB_INVALID_COMMAND_LINE_ARGUMENTS="f"
        fi
    done
    #--------
    if [ "$SB_INIT_FS_AND_EXIT" == "t" ]; then 
        fun_exc_assert_repositories_clones_folder_is_missing_or_is_not_a_symlink_and_not_a_file \
            "84aa2674-35ff-4c88-9554-63f23161c2e7"
        if [ ! -e "$S_FP_THE_REPOSITORY_CLONES" ]; then 
            mkdir $S_FP_THE_REPOSITORY_CLONES
            func_wait_and_sync
            if [ ! -e "$S_FP_THE_REPOSITORY_CLONES" ]; then 
                echo ""
                echo "The creation of the folder "
                echo ""
                echo "    $S_FP_THE_REPOSITORY_CLONES "
                echo ""
                echo "failed. Aborting script."
                echo "GUID=='4a14bcd5-ac76-48c4-9354-63f23161c2e7'"
                echo ""
                cd $S_FP_ORIG
                exit 1 # exit with an error
            fi
        fi
    else
        if [ "$SB_INIT_FS_AND_EXIT" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "4b3ac762-ff1d-49e2-8454-63f23161c2e7"
        fi
    fi
} # fun_if_needed_create_the_folder_4_downloading_repositories_and_exit_with_an_error_code_0
fun_if_needed_create_the_folder_4_downloading_repositories_and_exit_with_an_error_code_0

#-------------------------------------------------------------------------
AR_REPO_FOLDER_NAMES=()

fun_assemble_array_of_repository_clone_folder_names () {
    fun_exc_assert_repositories_clones_folder_is_missing_or_is_not_a_symlink_and_not_a_file \
        "cce5ee13-a7b2-478f-8154-63f23161c2e7"
    #--------------------
    if [ ! -e "$S_FP_THE_REPOSITORY_CLONES" ]; then 
        echo ""
        echo "The folder "
        echo ""
        echo "    $S_FP_THE_REPOSITORY_CLONES"
        echo ""
        echo "does not exist. Aborting script."
        echo "GUID=='6e9a9d3f-845a-42ed-a554-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
    #--------------------
    cd $S_FP_THE_REPOSITORY_CLONES
    local S_TMP_0="`ruby -e \"ar=Array.new; Dir.glob('*').each{|x| if File.directory? x then ar<<x end}; puts(ar.to_s.gsub('[','(').gsub(']',')').gsub(',',' '))\"`"
    cd $S_FP_DIR
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
        mkdir -p $S_FP_ARCHIVE
    else
        if [ "$SB_SKIP_ARCHIVING" != "t" ]; then 
            fun_exc_exit_with_an_error_t1 "36034fef-7686-4681-a454-63f23161c2e7"
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
         cd $S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY
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
         cd $S_FP_DIR
    done
    cd $S_FP_PWD_AT_FUNC_START
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
        cd $S_FP_ORIG
        exit 0 # exit without any errors
    else
        if [ "$SB_RUN_UPDATE" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "9d57ba21-5e49-4d37-9254-63f23161c2e7"
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
         cd $S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY
         echo "Running the garbage collector on $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         nice -n15 git gc --aggressive --prune=all 
         S_TMP_0="$?" 
         if [ "$S_TMP_0" != "0" ]; then 
             echo ""
             echo "Git exited with the error code of $S_TMP_0."
             echo "Aborting script."
             echo "GUID=='5b907448-41df-4734-8254-63f23161c2e7'"
             echo ""
             sync & # in the background, because 
                    # it might have been that the
                    # error is due to a lack of 
                    # access to a mounted drive
             cd $S_FP_ORIG
             exit $S_TMP_0 # exit with an error
         fi
         #----
         echo ""
         func_wait_and_sync
         cd $S_FP_DIR
    done
    #--------
    cd $S_FP_PWD_AT_FUNC_START
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
        cd $S_FP_ORIG
        exit 0 # exit without any errors
    else
        if [ "$SB_RUN_GARBAGE_COLLECTOR" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "6859691a-32d6-4e83-b354-63f23161c2e7"
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
        echo "GUID=='71dfd396-0f04-4b79-b554-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
    if [ "$S_FP_CANDIDATE" == "" ]; then 
        echo ""
        echo "The code of this script is flawed."
        echo "Aborting script."
        echo "GUID=='0f677352-780d-490d-9254-63f23161c2e7'"
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd $S_FP_ORIG
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
        echo "GUID=='8313df13-3595-46e4-9344-63f23161c2e7'"
        echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd $S_FP_ORIG
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
            echo "GUID=='44cf7576-f64e-458f-8144-63f23161c2e7'"
            echo "GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
            echo ""
            cd $S_FP_ORIG
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
                        echo "GUID=='eca9f02e-8ae7-4c21-a344-63f23161c2e7'"
                        echo ""
                        cd $S_FP_ORIG
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
        "4b547446-54e6-48fe-9144-63f23161c2e7"
    mkdir -p $S_FP_CANDIDATE
    func_wait_and_sync
    if [ ! -e "$S_FP_CANDIDATE" ]; then 
        echo ""
        echo "The creation of the folder "
        echo ""
        echo "    $S_FP_CANDIDATE"
        echo ""
        echo "failed. Aborting script."
        echo "GUID=='dbc55032-2423-451d-b444-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    else 
        if [ ! -d "$S_FP_CANDIDATE" ]; then 
            echo ""
            echo "The "
            echo ""
            echo "    $S_FP_CANDIDATE"
            echo ""
            echo "should be a folder, but it is not a folder."
            echo "Aborting script."
            echo "GUID=='db9fd55c-5e14-4ed9-9544-63f23161c2e7'"
            echo ""
            cd $S_FP_ORIG
            exit 1 # exit with an error
        fi
        if [ -h "$S_FP_CANDIDATE" ]; then 
            echo ""
            echo "The "
            echo ""
            echo "    $S_FP_CANDIDATE"
            echo ""
            echo "is a symlink to a folder, but it should be a folder."
            echo "Aborting script."
            echo "GUID=='47290353-86bf-4cde-9144-63f23161c2e7'"
            echo ""
            cd $S_FP_ORIG
            exit 1 # exit with an error
        fi
    fi
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
        "0447a158-d98b-4c1b-b244-63f23161c2e7"
    printf "%b" "" > $S_FP_CANDIDATE # the echo "" would add a linebreak
    wait
    func_wait_and_sync
    if [ ! -e "$S_FP_CANDIDATE" ]; then 
        echo ""
        echo "The creation of the file "
        echo ""
        echo "    $S_FP_CANDIDATE"
        echo ""
        echo "failed. Aborting script."
        echo "GUID=='70195cbb-2ce8-4694-9f44-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    else 
        if [ -d "$S_FP_CANDIDATE" ]; then 
            echo ""
            echo "The "
            echo ""
            echo "    $S_FP_CANDIDATE"
            echo ""
            echo "should be a file, but it is a folder or "
            echo "a symlink to a folder."
            echo "Aborting script."
            echo "GUID=='276a24c4-37ec-4805-8944-63f23161c2e7'"
            echo ""
            cd $S_FP_ORIG
            exit 1 # exit with an error
        fi
        if [ -h "$S_FP_CANDIDATE" ]; then 
            echo ""
            echo "The "
            echo ""
            echo "    $S_FP_CANDIDATE"
            echo ""
            echo "is a symlink to a file, but it should be a file."
            echo "Aborting script."
            echo "GUID=='17850c47-178c-4050-a144-63f23161c2e7'"
            echo ""
            cd $S_FP_ORIG
            exit 1 # exit with an error
        fi
    fi
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
        cd $S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY
        nice -n2 git config remote.origin.url >> $S_FP_TMP_ALL_REPO_PATHS
                          # Prints the repository path to console. 
                          # As a single local repository can have multiple 
                          # push targets, the number of printed lines
                          # per local repository can be more than one.
        cd $S_FP_DIR
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
        echo "GUID=='ce7f271e-775c-46c4-b344-63f23161c2e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
    #---------------------------------
    cd $S_FP_PWD_AT_FUNC_START
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
        cd $S_FP_ORIG
        exit 0 # exit without any errors
    else
        if [ "$SB_PRINT_UPSTREAM_REPOSITORY_PATH" != "f" ]; then 
            fun_exc_exit_with_an_error_t1 "c535a33d-c0c8-4979-8444-63f23161c2e7"
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
    echo "GUID=='3ec33872-c5fc-40d8-b334-63f23161c2e7'"
    echo ""
    cd $S_FP_ORIG
    exit 1 # exit with an error
else
    if [ "$SB_INVALID_COMMAND_LINE_ARGUMENTS" != "f" ]; then 
        fun_exc_exit_with_an_error_t1 "828e051c-b406-446c-8244-63f23161c2e7"
    fi
fi

#--------------------------------------------------------------------------
cd $S_FP_ORIG
exit 0 # exit without any errors
#==========================================================================

