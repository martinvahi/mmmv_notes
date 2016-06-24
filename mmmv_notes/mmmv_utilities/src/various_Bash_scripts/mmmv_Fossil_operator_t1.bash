#!/usr/bin/env bash
# Initial author: Martin.Vahi@softf1.com
# This file is in the public domain.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"

fun_assert_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE=$1 # first function argument
    local S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE\" to be on the PATH."
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
} # fun_assert_exists_on_path_t1

fun_assert_exists_on_path_t1 "file"    # for checking MIME types
fun_assert_exists_on_path_t1 "find"    # for recursing
fun_assert_exists_on_path_t1 "fossil"  # tested with v1.34
fun_assert_exists_on_path_t1 "gawk"
fun_assert_exists_on_path_t1 "grep"
fun_assert_exists_on_path_t1 "cat"
fun_assert_exists_on_path_t1 "ruby"    # anything over/equal v.2.1 will probably do
fun_assert_exists_on_path_t1 "shred"   # for secure delete
fun_assert_exists_on_path_t1 "uname"   # to check the OS type
fun_assert_exists_on_path_t1 "uuidgen" # needed for generating tmp file names
fun_assert_exists_on_path_t1 "xargs"   # find . -name '*' | xargs blabla

#--------------------------------------------------------------------------
S_TMP_0="`uname -a | grep -E [Ll]inux`"
if [ "$S_TMP_0" == "" ]; then
    echo ""
    echo "  The classical command line utilities at "
    echo "  different operating systems, for example, Linux and BSD,"
    echo "  differ. This script is designed to run only on Linux."
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
    echo "  GUID=='10b1e716-b716-4be1-950e-60c2018160e7'"
    echo ""
    echo "  Aborting script without doing anything."
    echo ""
    exit 1 # exit with error
fi


#--------------------------------------------------------------------------
S_TMP_0=""
S_ACTIVITY_OF_THIS_SCRIPT=$1
S_URL_REMOTE_REPOSITORY=""
SB_EXIT_WITH_ERROR="f"

# needed for scriptability
S_ARGNAME_ACTIVITY_SHRED_ARG_2="do_not_prompt_for_confirmation" 

fun_print_msg_t1() {
    echo ""
    echo "The second console argument "
    echo "is expected to be the URL of the remote repository."
} # fun_print_msg_t1


fun_exit_without_any_errors_t1() {
    local X_SKIP_MESSAGE="$1"
    if [ "$X_SKIP_MESSAGE" == "" ]; then
        echo ""
        echo "Aborting script without doing anything."
        echo ""
    fi 
    #----
    cd $S_FP_ORIG
    exit 0
} # fun_exit_without_any_errors_t1


#--------------------------------------------------------------------------
# Activity aliases for comfort.

if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "up" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_remote_with_local"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "upload" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_remote_with_local"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "ci" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_remote_with_local"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "down" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_local_with_remote"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "download" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_local_with_remote"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "co" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="clone_all"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "?" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-?" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "--help" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-help" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "rm" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="shred_local_copy"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "del" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="shred_local_copy"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "delete" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="shred_local_copy"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "info" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "--info" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-info" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "--about" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-about" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
#--------
#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "about" ]; then
    echo ""
    echo "    The initial version of this script has been written by "
    echo "    Martin.Vahi@softf1.com         "
    echo "    in 2016_02. The initial version is in public domain."
    echo "    The command \"help\" offers more information. "
    echo ""
    echo "    Thank You for using this script :-)"
    echo ""
    echo ""
    fun_exit_without_any_errors_t1 "t"
fi 
#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "exit" ]; then
    fun_exit_without_any_errors_t1
else
    if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_all" ]; then
        if [ "$2" == "" ]; then
            fun_print_msg_t1
            S_ACTIVITY_OF_THIS_SCRIPT="help"
            SB_EXIT_WITH_ERROR="t"
        else
            S_URL_REMOTE_REPOSITORY="$2"
        fi
    else
        if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_public" ]; then
            if [ "$2" == "" ]; then
                fun_print_msg_t1
                S_ACTIVITY_OF_THIS_SCRIPT="help"
                SB_EXIT_WITH_ERROR="t"
            else
                S_URL_REMOTE_REPOSITORY="$2"
            fi
        else
            if [ "$S_ACTIVITY_OF_THIS_SCRIPT" != "overwrite_local_with_remote" ]; then
                if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "overwrite_remote_with_local" ]; then
                    if [ "$2" != "" ]; then
                        if [ "$2" == "use_autogenerated_commit_message" ]; then
                            if [ "$3" != "" ]; then
                                echo ""
                                echo "If the first console argument is \"overwrite_local_with_remote\" and"
                                echo "the second console argument is \"use_autogenerated_commit_message\", "
                                echo "then there should not be a 3. console argument."
                                echo "GUID=='94e31fd3-85c9-4dfb-a2fd-60c2018160e7'"
                                S_ACTIVITY_OF_THIS_SCRIPT="help"
                                SB_EXIT_WITH_ERROR="t"
                            fi
                        else
                            if [ "$2" == "read_commit_message_from_file" ]; then
                                S_FP_MESSAGE_FILE_CANDIDATE="$3" # file path candidate
                                if [ "$S_FP_MESSAGE_FILE_CANDIDATE" == "" ]; then
                                    echo ""
                                    echo "If the first console argument is "
                                    echo "\"overwrite_local_with_remote\" and"
                                    echo "the second console argument is "
                                    echo "\"read_commit_message_from_file\", "
                                    echo "then there should be also a 3. console argument "
                                    echo "that is expected to be a file path to a text file."
                                    echo "GUID=='adfce255-e3fe-40ae-84fd-60c2018160e7'"
                                    S_ACTIVITY_OF_THIS_SCRIPT="help"
                                    SB_EXIT_WITH_ERROR="t"
                                fi
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    if [ "$4" != "" ]; then
                                        echo ""
                                        echo "If the first console argument is "
                                        echo "\"overwrite_local_with_remote\" and"
                                        echo "the second console argument is "
                                        echo "\"read_commit_message_from_file\", "
                                        echo "then there should be exactly 3. console arguments, "
                                        echo "not 4 or more. Unfortunately the 4. argument is currently "
                                        echo "---citation--start---"
                                        echo "$4"
                                        echo "---citation--end-----"
                                        echo "GUID=='0b03ec37-da96-456e-b3fd-60c2018160e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    if [ ! -e "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                                        echo ""
                                        echo "The commit message file path candidate "
                                        echo "references either a missing file or "
                                        echo "a broken symlink."
                                        echo "GUID=='4c29c433-48e4-4ced-a4fd-60c2018160e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi 
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    if [ -d "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                                        echo ""
                                        echo "The commit message file path candidate "
                                        echo "references a folder, but it should "
                                        echo "reference a text file."
                                        echo "GUID=='fee26538-6bfb-4adb-b4fd-60c2018160e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    S_TMP_0="`filesize $S_FP_MESSAGE_FILE_CANDIDATE`"
                                    S_TMP_1="`ruby -e \"s_out='OK'; if (2000<$S_TMP_0) then s_out='too_big' end; print(s_out);\"`"
                                    if [ "$S_TMP_1" == "too_big" ]; then
                                        echo ""
                                        echo "The commit message file path "
                                        echo "references a file that has a size of $S_TMP_0 bytes."
                                        echo "The suspicion is that it is a wrong file. "
                                        echo "because a commit message is usually not that lengthy."
                                        echo "GUID=='b95f593c-5140-4506-84ed-60c2018160e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    else
                                        if [ "$S_TMP_0" == "0" ]; then
                                            echo ""
                                            echo "The commit message file path "
                                            echo "references a file that has a size of 0 (zero) bytes."
                                            echo ""
                                            echo "The generation of commit message files "
                                            echo "can be avoided by using the option "
                                            echo ""
                                            echo "    \"use_autogenerated_commit_message\""
                                            echo ""
                                            echo "in stead of the option "
                                            echo ""
                                            echo "    \"read_commit_message_from_file\" ."
                                            echo ""
                                            echo "GUID=='31b2b6aa-10c1-4349-93ed-60c2018160e7'"
                                            S_ACTIVITY_OF_THIS_SCRIPT="help"
                                            SB_EXIT_WITH_ERROR="t"
                                        fi
                                    fi
                                fi 
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    S_TMP_0="`file --mime-type $S_FP_MESSAGE_FILE_CANDIDATE | grep text `"
                                    if [ "$S_TMP_0" == "" ]; then
                                        echo ""
                                        echo "The commit message file path "
                                        echo "references a file that has a  MIME type of "
                                        echo ""
                                        echo "`file --mime-type $S_FP_MESSAGE_FILE_CANDIDATE`"
                                        echo ""
                                        echo "The commit message file must be a text file and "
                                        echo "text files have the string \"text\" in their MIME type name."
                                        echo "GUID=='fc0cb22c-578d-47a2-92ed-60c2018160e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi 
                            fi # read_commit_message_from_file
                        fi
                    fi
                else
                    if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "shred_local_copy" ]; then
                        if [ "$2" != "" ]; then # the 2. arg is optional here
                            if [ "$2" != "$S_ARGNAME_ACTIVITY_SHRED_ARG_2" ]; then 
                                echo ""
                                echo "If the first console argument is \"shred_local_copy\", then"
                                echo "the second console argument is allowed to be only "
                                echo ""
                                echo "    \"$S_ARGNAME_ACTIVITY_SHRED_ARG_2\", without quotation marks."
                                echo "GUID=='1a618c55-ef9a-4a2f-aeed-60c2018160e7'"
                                S_ACTIVITY_OF_THIS_SCRIPT="help"
                                SB_EXIT_WITH_ERROR="t"
                            fi
                        fi
                    else
                        if [ "$S_ACTIVITY_OF_THIS_SCRIPT" != "print_script_version" ]; then
                            if [ "$S_ACTIVITY_OF_THIS_SCRIPT" != "help" ]; then
                                echo ""
                                echo "The very first console argument "
                                echo "of this script is expected to be "
                                echo "a command that is specific to this script."
                                echo "GUID=='a6728226-e43f-4baa-93ed-60c2018160e7'"
                                S_ACTIVITY_OF_THIS_SCRIPT="help"
                                SB_EXIT_WITH_ERROR="t"
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
fi 

#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "help" ]; then
    echo ""
    echo "Possible console argument sets are:"
    echo ""
    echo "    clone_all    <remote repository url>"
    echo "    clone_public <remote repository url>"
    echo "    overwrite_local_with_remote"
    echo ""
    echo "    overwrite_remote_with_local (use_autogenerated_commit_message)?"
    echo "    overwrite_remote_with_local read_commit_message_from_file <path to a text file>"
    echo ""
    echo "    shred_local_copy ($S_ARGNAME_ACTIVITY_SHRED_ARG_2)?"
    echo "    help"
    echo "    print_script_version"
    echo "    exit # just for testing"
    echo ""
    #----
    cd $S_FP_ORIG
    if [ "$SB_EXIT_WITH_ERROR" == "t" ]; then
        exit 1 # To let the parent script know that 
               # the parent script calls this script with 
               # flawed console argument values.    
    else
        exit 0
    fi
fi 

#--------------------------------------------------------------------------
# The script version is needed by other scripts that depend on this script.
# The script version GUID must not be surrounded by 
# any quote signs (',"), because otherwise the 
# version GUID will be overwritten by the UpGUID tool,
# but unlike error message GUID-s this GUID must stay constant. 
# To allow the version to be used as sub-part of file names and 
# folder names, the version must not contain any spaces, line breaks
# and other characters that have a special meaning in Bash.
#
# If the version ID did not match the GUID regex, then I would have to 
# write a long comment about it not being allowed to match the 
# GUID regex. :-D 
S_VERSION_OF_THIS_SCRIPT="c52b5919-3ea2-4ebd-94fd-60c2018160e7"
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "print_script_version" ]; then
    echo "The version of this script is: $S_VERSION_OF_THIS_SCRIPT"
    #----
    cd $S_FP_ORIG
    exit 0
fi 


#--------------------------------------------------------------------------
S_FP_SANDBOX_DIRECTORY_NAME="sandbox_of_the_Fossil_repository"
S_FP_SANDBOX="$S_FP_DIR/$S_FP_SANDBOX_DIRECTORY_NAME"
#----
S_FP_ARCHIVES_DIRECTORY_NAME="archival_copies_of_the_Fossil_repository_sandbox"
S_FP_ARCHIVES="$S_FP_DIR/$S_FP_ARCHIVES_DIRECTORY_NAME"
S_FP_ARCHIVES_TS="$S_FP_ARCHIVES/v$S_TIMESTAMP"
#----
S_FP_FOSSILFILE_NAME="repository_storage.fossil"
S_FP_FOSSILFILE="$S_FP_DIR/$S_FP_FOSSILFILE_NAME"

#--------
S_LC_NOT_DETERMINED="not determined"
SB_SANDBOX_DIR_EXISTS="$S_LC_NOT_DETERMINED"
fun_sandbox_folder_or_symlink_exists() {
    SB_SANDBOX_DIR_EXISTS="f"
    if [ ! -e $S_FP_SANDBOX ]; then
        # Does not exist or it is a broken symbolic link.
        SB_SANDBOX_DIR_EXISTS="f"
    else
        if [ -d $S_FP_SANDBOX ]; then
            SB_SANDBOX_DIR_EXISTS="t"
        fi
    fi
} # fun_sandbox_folder_or_symlink_exists

SB_FOSSILFILE_EXISTS="$S_LC_NOT_DETERMINED"
fun_fossil_repository_file_or_symlink_exists() {
    SB_FOSSILFILE_EXISTS="t"
    if [ ! -e $S_FP_FOSSILFILE ]; then
        # Does not exist or it is a broken symbolic link.
        SB_FOSSILFILE_EXISTS="f"
    else
        if [ -d $S_FP_FOSSILFILE ]; then
            SB_FOSSILFILE_EXISTS="f"
        fi
    fi
} # fun_fossil_repository_file_or_symlink_exists

S_LC_NOT_DETERMINED="not determined"
SB_ARCHIVE_DIR_EXISTS="$S_LC_NOT_DETERMINED"
fun_archives_folder_or_symlink_exists() {
    SB_ARCHIVE_DIR_EXISTS="f"
    if [ ! -e $S_FP_ARCHIVES ]; then
        # Does not exist or it is a broken symbolic link.
        SB_ARCHIVE_DIR_EXISTS="f"
    else
        if [ -d $S_FP_ARCHIVES ]; then
            SB_ARCHIVE_DIR_EXISTS="t"
        fi
    fi
} # fun_archives_folder_or_symlink_exists

#--------
fun_fossil_repository_file_or_symlink_exists
fun_sandbox_folder_or_symlink_exists
fun_archives_folder_or_symlink_exists

fun_assertion_t1() {
    local SB_CANDIDATE=$1
    local SB_THROW="t"
    #----
    if [ "$SB_CANDIDATE" == "t" ]; then
        SB_THROW="f"
    else
        if [ "$SB_CANDIDATE" == "f" ]; then
            SB_THROW="f"
        fi
    fi
    #----
    if [ "$SB_THROW" == "t" ]; then
        echo ""
        echo "This Bash script is flawed. "
        echo "fun_assertion_t1() assertion failed."
        echo "GUID=='0e253639-885d-49b9-a4ed-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_assertion_t1

fun_assertion_t1 "$SB_FOSSILFILE_EXISTS"
fun_assertion_t1 "$SB_SANDBOX_DIR_EXISTS"
fun_assertion_t1 "$SB_ARCHIVE_DIR_EXISTS"

#--------------------------------------------------------------------------

fun_assert_repository_local_copy_existence() {
    fun_fossil_repository_file_or_symlink_exists
    if [ "$SB_FOSSILFILE_EXISTS" == "f" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "does not contain a Fossil repository file named "
        echo ""
        echo "    $S_FP_FOSSILFILE_NAME"
        echo ""
        echo "Aborting script."
        echo "GUID=='9e259331-2604-424b-b2dd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    fun_sandbox_folder_or_symlink_exists
    if [ "$SB_SANDBOX_DIR_EXISTS" == "f" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "does not contain a directory named "
        echo ""
        echo "    $S_FP_SANDBOX_DIRECTORY_NAME"
        echo ""
        echo "Aborting script."
        echo "GUID=='bd274616-5c19-4da2-b3dd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_assert_repository_local_copy_existence


fun_assert_the_lack_of_repository_local_copy_t1() {
    if [ "$SB_FOSSILFILE_EXISTS" == "t" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "already contain a file named "
        echo ""
        echo "    $S_FP_FOSSILFILE_NAME"
        echo ""
        echo "To avoid overwriting an existing local copy, this script is aborted"
        echo "and nothing is downloaded/uploaded by this script."
        echo "GUID=='e82ebd3b-eeec-4eaa-b5dd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$SB_SANDBOX_DIR_EXISTS" == "t" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "already contains a directory named "
        echo ""
        echo "    $S_FP_SANDBOX_DIRECTORY_NAME"
        echo ""
        echo "To avoid overwriting an existing local copy, this script is aborted"
        echo "and nothing is downloaded/uploaded by this script."
        echo "GUID=='12ece555-f0b7-4b68-91dd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_assert_the_lack_of_repository_local_copy_t1



fun_initialize_sandbox_t1() {
    mkdir -p $S_FP_SANDBOX
    sync;
    cd $S_FP_SANDBOX
    fossil open $S_FP_DIR/$S_FP_FOSSILFILE_NAME # full path for reliability 
    fossil settings autosync off ;
    fossil settings case-sensitive TRUE ;
    fossil checkout --force --latest
    fossil pull 
    fossil close
    sync;
} # fun_initialize_sandbox_t1


#--------------------------------------------------------------------------
fun_last_minute_checks_t1() {
    # Last minute checks, just to be sure.
    local S_FP_FORBIDDEN_VALUE=$1
    if [ "$S_FP_FORBIDDEN_VALUE" == "/" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='731d2a24-b82e-4703-b4dd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "$HOME" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='31c15b4f-e658-41c0-92dd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/home" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='b9f58420-e95a-488e-84cd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/root" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='40236327-50d4-45aa-83cd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/etc" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='d26ba631-c952-4f73-b4cd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/usr" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='398688e1-00d4-47b1-98cd-60c2018160e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_last_minute_checks_t1


#--------------------------------------------------------------------------
SB_FOLDER_IS_EMPTY="$S_LC_NOT_DETERMINED"
fun_folder_is_empty_t1() {
    local S_FP_FOLDER_TO_STUDY=$1
    local S_FP_ORIG_LOCAL="`pwd`"
    #--------
    SB_FOLDER_IS_EMPTY="t"
    local S_TMP_0="`cd $S_FP_FOLDER_TO_STUDY; ls -l | grep \"total 0\"`"
    if [ "$S_TMP_0" == "" ]; then
        SB_FOLDER_IS_EMPTY="f"
    fi
    #--------
    cd $S_FP_ORIG_LOCAL # just in case
} # fun_folder_is_empty_t1

fun_folder_is_empty_t1 "$S_FP_DIR"
fun_assertion_t1 "$SB_FOLDER_IS_EMPTY"
if [ "$SB_FOLDER_IS_EMPTY" == "t" ]; then
    echo ""
    echo "This Bash script is flawed. The "
    echo "$S_FP_DIR" 
    echo "can not possibly be empty, because it contains "
    echo "at least one file, whcih is "
    echo "this very same Bash script that outputs the current error message."
    echo "GUID=='ca6dfb51-7279-415f-a1bd-60c2018160e7'"
    echo ""
    #----
    cd $S_FP_ORIG
    exit 1
fi

#--------------------------------------------------------------------------

fun_activity_core_overwrite_local_with_remote() {
    fun_assert_repository_local_copy_existence
    #--------
    # The checks are party to cope with the `whoami`=="root" case.
    fun_last_minute_checks_t1 "$S_FP_SANDBOX"
    fun_last_minute_checks_t1 "$S_FP_ARCHIVES"
    fun_last_minute_checks_t1 "$S_FP_ARCHIVES_TS"
    #--------
    chmod -f -R u+rx $S_FP_SANDBOX
    fun_folder_is_empty_t1 "$S_FP_SANDBOX"
    if [ "$SB_FOLDER_IS_EMPTY" == "f" ]; then
        # This if-statement is needed because the 
        #      cp -f -R AnEmptyDirectory/* ToSomewhere/
        # gives an error.
        #----
        mkdir -p $S_FP_ARCHIVES_TS
        #----
        # The "chmod -f -R " is not used because it would
        # waste time on folders that are named by 
        # the older $S_FP_ARCHIVES_TS values.
        chmod -f 0700 $S_FP_ARCHIVES
        chmod -f 0700 $S_FP_ARCHIVES_TS 
        #----
        # The separate cp and rm of the sandbox
        # contents is to somewhat retain the original
        # file premissions of the sandbox contents.
        cp -f -R $S_FP_SANDBOX/* $S_FP_ARCHIVES_TS/
        fun_last_minute_checks_t1 "$S_FP_SANDBOX"
        chmod -f -R u+rwx $S_FP_SANDBOX
        rm -fr $S_FP_SANDBOX/*
    fi
    #--------
    cd $S_FP_SANDBOX
    fossil open $S_FP_DIR/$S_FP_FOSSILFILE_NAME # full path for reliability 
    fossil settings autosync off ;
    fossil checkout --force --latest
    fossil pull 
    fossil close
} # fun_activity_core_overwrite_local_with_remote



if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "overwrite_local_with_remote" ]; then
    fun_activity_core_overwrite_local_with_remote
    #----
    cd $S_FP_ORIG
    exit 0
fi # overwrite_local_with_remote



#--------------------------------------------------------------------------
fossil close 2>/dev/null

if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_public" ]; then
    fun_assert_the_lack_of_repository_local_copy_t1
    cd $S_FP_DIR 
    fossil clone $S_URL_REMOTE_REPOSITORY ./$S_FP_FOSSILFILE_NAME
    fun_initialize_sandbox_t1
    cd $S_FP_ORIG
    #----
    sync
    fun_activity_core_overwrite_local_with_remote
    cd $S_FP_ORIG
    sync
    #----
    exit 0
fi # clone_public


#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_all" ]; then
    fun_assert_the_lack_of_repository_local_copy_t1
    cd $S_FP_DIR 
    #--------
    S_USERNAME=""
    while [ "$S_USERNAME" == "" ]
    do
        echo ""
        echo "Please enter a username: "
        S_USERNAME="`ruby -e \"s=gets.gsub(/[\n\r\s]/,'');print(s)\"`" 
        S_URL="`export S_USERNAME=\"$S_USERNAME\"; S_URL=\"$S_URL_REMOTE_REPOSITORY\" ruby -e 's_0=ENV[\"S_URL\"].sub(\"http://\",\"http:/\").sub(\"http:/\",\"http://\"+ENV[\"S_USERNAME\"].to_s+\":nonsensepassword@\");print(s_0)'`"
    done
    #--------
    fossil clone --private $S_URL ./$S_FP_FOSSILFILE_NAME
    fun_initialize_sandbox_t1
    cd $S_FP_ORIG
    #----
    sync
    fun_activity_core_overwrite_local_with_remote
    cd $S_FP_ORIG
    sync
    #----
    exit 0
fi # clone_all


#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "overwrite_remote_with_local" ]; then
    fun_assert_repository_local_copy_existence
    #--------
    # It's important that this script will not try 
    # to recursively copy/move the content of the "/" to 
    # a subfolder of the "/", the "/tmp". 
    # The other folders that are covered by the
    # test are a bit of an overkill here, may be even an
    # annoying and unjustified restrictions, but 
    # in most cases those restrictions do not hurt either.
    fun_last_minute_checks_t1 "$S_FP_SANDBOX"
    #----
    S_TMP_0="/tmp/tmp_mmmv_$S_VERSION_OF_THIS_SCRIPT"
    S_TMP_1="__"
    S_TMP_FOR_LOCAL="$S_TMP_0$S_TMP_1`uuidgen`"
    S_TMP_FOR_COMMIT_MESSAGE="$S_TMP_0$S_TMP_1`uuidgen`"
    mkdir -p $S_TMP_FOR_LOCAL
    chmod -f -R u+rwx $S_FP_SANDBOX
    mv -f $S_FP_SANDBOX/* $S_TMP_FOR_LOCAL/ # the -f is for empty sandbox
    #--------
    fun_activity_core_overwrite_local_with_remote 
    fun_last_minute_checks_t1 "$S_FP_SANDBOX" # should there be flaws elsewhere
    chmod -f -R u+rwx $S_FP_SANDBOX # to be able to delete the old content
    #--------
    cd $S_FP_SANDBOX
        fossil open $S_FP_DIR/$S_FP_FOSSILFILE_NAME # full path for reliability 
        fossil settings autosync off ;
        fun_folder_is_empty_t1 "$S_FP_SANDBOX"
        SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED="f"
        if [ "$SB_FOLDER_IS_EMPTY" == "f" ]; then
            fossil rm --hard --case-sensitive TRUE ./* 
            SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED="t"
            fun_last_minute_checks_t1 "`pwd`"
            if [ "$S_FP_SANDBOX" == "`pwd`" ]; then
                rm -fr ./*
            else
                echo ""
                echo "This Bash script is flawed."
                echo "GUID=='39b31171-e088-4d93-94bd-60c2018160e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1
            fi
        fi
        mv -f $S_TMP_FOR_LOCAL/* $S_FP_SANDBOX/ # the -f is for empty source
        #----
        fun_last_minute_checks_t1 "$S_TMP_FOR_LOCAL"
        rm -fr $S_TMP_FOR_LOCAL
        #----
        fun_folder_is_empty_t1 "$S_FP_SANDBOX"
        if [ "$SB_FOLDER_IS_EMPTY" == "f" ]; then
            if [ "$S_FP_SANDBOX" != "`pwd`" ]; then
                echo ""
                echo "This Bash script is flawed."
                echo "GUID=='7e89c51b-f97c-43d2-a5bd-60c2018160e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1
            fi
            find . -name '*' | xargs fossil add --force --dotfiles --case-sensitive TRUE  
            SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED="t"
        fi
        if [ "$SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED" == "t" ]; then
            if [ "$2" == "" ]; then
                echo ""
                #echo "Please enter a one-liner commit message: "
                #S_TMP_0="`ruby -e \"s=gets.gsub(/[\n\r\s]/,'');print(s)\"`" 
                # TODO: improve this script so that it would not ask 
                # for a commit message, when nothing changed. It requires
                # some recursive analysis of files, which might be slow.
                # This script is not optimal for speed even now and that would
                # make it even slower. On the other hand, usually when 
                # the upload operation is initiated, there are some changes,
                # which means that the slow analysis would be useless in 
                # most frequent cases. So this thing needs to be figured out 
                # at some later time, when there is more experience with the
                # use of this script.
                read -p "Please enter a one-liner commit message: " S_TMP_0
                echo $S_TMP_0 > $S_TMP_FOR_COMMIT_MESSAGE
            else
                if [ "$2" == "use_autogenerated_commit_message" ]; then
                    echo "Autogenerated commit message timestamp: $S_TIMESTAMP" > $S_TMP_FOR_COMMIT_MESSAGE
                else
                    if [ "$2" == "read_commit_message_from_file" ]; then
                        S_FP_MESSAGE_FILE_CANDIDATE="$3" # file path candidate
                        # Initial file existence and type checks for the 
                        # $S_FP_MESSAGE_FILE_CANDIDATE 
                        # were conducted at the start of the script.
                        # but the $S_FP_MESSAGE_FILE_CANDIDATE  might have
                        # referenced a file in the sandbox and 
                        # that file might have been just removed/deleted.
                        #
                        # There is no threat that the file got changed to a folder
                        # or a symlink switched from a file to a folder,
                        # at least that's the case for the single threaded model.
                        if [ ! -e "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                            # missing or a broken symlink
                            echo ""
                            echo "The commit message file is missing or "
                            echo "references a broken symlink."
                            echo "The file or symlink to it was fine at "
                            echo "the start of this script, it passed the various tests, "
                            echo "but for some reason it got deleted or its target . "
                            echo "got deleted. If the commit message file or"
                            echo "the symlink target resided within the sandbox, then "
                            echo "a recommendation is to use a file that resides "
                            echo "outside of the sandbox."
                            echo "GUID=='9c0865d1-1134-4203-92bd-60c2018160e7'"
                            echo ""
                            #----
                            cd $S_FP_ORIG
                            exit 1
                        fi
                        if [ -d "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                            # folder or a symlink to a folder
                            echo ""
                            echo "The commit message file path does not reference "
                            echo "a file. It references a folder or a symlink to a folder."
                            echo "The file or symlink to it was fine at "
                            echo "the start of this script, it passed the various tests, "
                            echo "but for some reason there were changes. "
                            echo "GUID=='4a707715-ffe8-47ca-b4bd-60c2018160e7'"
                            echo ""
                            #----
                            cd $S_FP_ORIG
                            exit 1
                        fi
                        cat $S_FP_MESSAGE_FILE_CANDIDATE > $S_TMP_FOR_COMMIT_MESSAGE
                    # else
                    #     Due to the checks at the start of the script 
                    #     this else branch is useless.
                    fi
                fi
            fi
            #--------
            fossil commit --message-file $S_TMP_FOR_COMMIT_MESSAGE
            #----
            fun_last_minute_checks_t1 "$S_TMP_FOR_COMMIT_MESSAGE"
            rm -f $S_TMP_FOR_COMMIT_MESSAGE
            #----
        fi
    #--------
    fossil push --private
    fossil push 
    fossil pull --private
    fossil close
    #----
    cd $S_FP_ORIG
    exit 0
fi # overwrite_remote_with_local


#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "shred_local_copy" ]; then
    #--------
    SB_THERE_IS_SOMETHING_TO_DELETE="f"
    if [ "$SB_FOSSILFILE_EXISTS" == "t" ]; then
        SB_THERE_IS_SOMETHING_TO_DELETE="t"
    fi
    if [ "$SB_SANDBOX_DIR_EXISTS" == "t" ]; then
        SB_THERE_IS_SOMETHING_TO_DELETE="t"
    fi
    if [ "$SB_ARCHIVE_DIR_EXISTS" == "t" ]; then
        SB_THERE_IS_SOMETHING_TO_DELETE="t"
    fi
    #--------
    if [ "$SB_THERE_IS_SOMETHING_TO_DELETE" == "t" ]; then 
        if [ "$2" != "$S_ARGNAME_ACTIVITY_SHRED_ARG_2" ]; then 
            # Includes the $2=="" case
            # id est if the control flow is in here, then there 
            # is a need to prompt for confirmation.
            # The skipping of the prompt is necessary for
            # software that use this script as its sub-component.
            #--------
            echo ""
            echo "The command \"shred_local_copy\" deletes "
            echo "the repository file, the sandbox and "
            echo "the associated automatically created archives."
            echo ""
            read -p "Proceed with deletion?  (Yes/whatever_else)  " S_TMP_0
            S_TMP_1="`echo $S_TMP_0 | gawk '{print tolower($1)}'`"
            if [ "$S_TMP_1" == "yes" ]; then
                echo ""
                printf "Deleting ... "
            else
                fun_exit_without_any_errors_t1
            fi
       fi
    fi
    #--------
    if [ "$SB_FOSSILFILE_EXISTS" == "t" ]; then
        cd $S_FP_DIR  # just in case
        # The     shred "-f" option re-sets file access permissions as needed.
        nice -n10 shred  -f --remove $S_FP_FOSSILFILE  
    fi
    #--------
    if [ "$SB_SANDBOX_DIR_EXISTS" == "t" ]; then
        cd $S_FP_SANDBOX
        fun_last_minute_checks_t1 "`pwd`"
        #--------
        # The S_TMP_0 is to suppress shred output.
        S_TMP_0="`find . -name '*' | xargs shred -f --remove 2>/dev/null`"
        #----
        cd $S_FP_DIR  # step out of the sandbox directory
        fun_last_minute_checks_t1 "$S_FP_SANDBOX"
        chmod -f -R 0700 $S_FP_SANDBOX 
        rm -fr $S_FP_SANDBOX 
    fi
    #--------
    if [ "$SB_ARCHIVE_DIR_EXISTS" == "t" ]; then
        cd $S_FP_ARCHIVES 
        fun_last_minute_checks_t1 "`pwd`"
        #--------
        # The S_TMP_0 is to suppress shred output.
        S_TMP_0="`find . -name '*' | xargs shred -f --remove 2>/dev/null`" 
        #----
        cd $S_FP_DIR  # step out of the archive directory
        fun_last_minute_checks_t1 "$S_FP_ARCHIVES"
        chmod -f -R 0700 $S_FP_ARCHIVES
        rm -fr $S_FP_ARCHIVES 
    fi
    #--------
    if [ "$SB_THERE_IS_SOMETHING_TO_DELETE" == "t" ]; then 
        if [ "$2" != "$S_ARGNAME_ACTIVITY_SHRED_ARG_2" ]; then 
            echo "✓"
            echo ""
        fi
    fi
    #--------
    cd $S_FP_ORIG
    exit 0
fi # shred_local_copy


#--------------------------------------------------------------------------
# All possible actions must have been described
# above this code block.
echo ""
echo "This Bash script is flawed."
echo "GUID=='4332a245-ca3c-45d0-8bad-60c2018160e7'"
echo ""
#----
cd $S_FP_ORIG
exit 1

#==========================================================================

