#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The original CruiseControl build instructions reside at:
# http://cruisecontrol.sourceforge.net/gettingstartedsourcedist.html#Install_CruiseControl
#
# CruiseControl home: 
#     http://cruisecontrol.sourceforge.net/
#     (archival copy: https://archive.is/NNS0i )               
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
S_FP_ORIG="`pwd`"
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_`date +%H`_`date +%M`_`date +%S`"
#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of the Bash script is aborted."
        echo "GUID=='5ed67825-86e5-4215-903d-73f21101c0e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "ant"
func_mmmv_exit_if_not_on_path_t2 "java"
func_mmmv_exit_if_not_on_path_t2 "javac"
func_mmmv_exit_if_not_on_path_t2 "tee"
func_mmmv_exit_if_not_on_path_t2 "svn"
# func_mmmv_exit_if_not_on_path_t2 "dirname" # used before this call
# func_mmmv_exit_if_not_on_path_t2 "date"    # used before this call
func_mmmv_exit_if_not_on_path_t2 "bash" # to be sure that it is on the PATH


#--------------------------------------------------------------------------

func_mmmv_echo_t1() {  # <text>, <optional log file path, has side effects>
    local S_FUNC_MMMV_ECHO_T1_MSG="$1" # the text
    local S_FUNC_MMMV_ECHO_T1_FP_LOGFILE="$2" # optional log file path
    #--------
    # The long weird names are a probabilistic workaround to 
    # an easily created flaw/bug, where somewhere outside of this Bash script, 
    # the short names like "S_TMP", "S_0", are used without the "local" keyword.
    local S_FUNC_MMMV_ECHO_T1_TMP_0=""     # declaration
    local S_FUNC_MMMV_ECHO_T1_TMP_1=""     # declaration
    local S_FUNC_MMMV_ECHO_T1_FP_LOG=""    # declaration
    local SB_FUNC_MMMV_ECHO_T1_FIRST_CALL="f" # {t,f}
    #----
    if [ "$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE" != "" ]; then  # first call to this function
        SB_FUNC_MMMV_ECHO_T1_FIRST_CALL="t" # {t,f}
        if    [ "$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE_CURRENT" != "" ]; then 
            # The S_FUNC_MMMV_ECHO_T1_FP_LOGFILE_CURRENT is a global variable.
            echo ""
            echo "Wrong use of the function func_mmmv_echo_t1(...). "
            echo "This function has an intentional side effect that it accepts "
            echo "the logfile path parameter only once per Bash proccess."
            echo ""
            echo "    S_FUNC_MMMV_ECHO_T1_FP_LOGFILE=$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE"
            echo ""
            echo "GUID=='64cfa6b2-9d7a-47c3-bb2d-73f21101c0e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi
        S_FUNC_MMMV_ECHO_T1_TMP_0="`dirname $S_FUNC_MMMV_ECHO_T1_FP_LOGFILE`"
        mkdir -p $S_FUNC_MMMV_ECHO_T1_TMP_0 # might create a mess with relative path
        if [ "$?" != "0" ]; then 
            echo ""
            echo "The mkdir exited with error code: $? "
            echo ""
            echo "    S_FUNC_MMMV_ECHO_T1_TMP_0==$S_FUNC_MMMV_ECHO_T1_TMP_0"
            echo "    S_FUNC_MMMV_ECHO_T1_FP_LOGFILE=$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE"
            echo ""
            echo "GUID=='cd3f52a4-2f49-4371-8b5c-73f21101c0e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        if [ ! -e "$S_FUNC_MMMV_ECHO_T1_TMP_0" ]; then 
            echo ""
            echo "The mkdir exited with error code $? , but the folder "
            echo ""
            echo "    $S_FUNC_MMMV_ECHO_T1_TMP_0"
            echo ""
            echo "is still missing."
            echo "GUID=='52aa56e4-ff1c-4579-a13c-73f21101c0e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        #--------
        S_FUNC_MMMV_ECHO_T1_TMP_1="`cd $S_FUNC_MMMV_ECHO_T1_TMP_0 ; pwd`"
        S_FUNC_MMMV_ECHO_T1_TMP_0="`basename $S_FUNC_MMMV_ECHO_T1_FP_LOGFILE`"
        if [ "$S_FUNC_MMMV_ECHO_T1_TMP_0" == "" ]; then 
            echo ""
            echo "The basename of the logfile path must not be an empty string."
            echo ""
            echo "    S_FUNC_MMMV_ECHO_T1_FP_LOGFILE=$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE"
            echo "    S_FUNC_MMMV_ECHO_T1_TMP_1==$S_FUNC_MMMV_ECHO_T1_TMP_1"
            echo ""
            echo "GUID=='95b37772-6281-4b16-bb5c-73f21101c0e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi
        S_FUNC_MMMV_ECHO_T1_FP_LOG="$S_FUNC_MMMV_ECHO_T1_TMP_1/$S_FUNC_MMMV_ECHO_T1_TMP_0"
        S_FUNC_MMMV_ECHO_T1_FP_LOGFILE_CURRENT="$S_FUNC_MMMV_ECHO_T1_FP_LOG"
    else # non-first call to this function
        if    [ "$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE_CURRENT" == "" ]; then 
            # The S_FUNC_MMMV_ECHO_T1_FP_LOGFILE_CURRENT is a global variable.
            echo ""
            echo "Wrong use of the function func_mmmv_echo_t1(...). "
            echo "This function has an intentional side effect that its "
            echo "first call during a Bash process is required to include "
            echo "a full path to a logfile."
            echo ""
            echo "GUID=='f4e5eb73-7748-4493-8f3c-73f21101c0e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi
        S_FUNC_MMMV_ECHO_T1_FP_LOG="$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE_CURRENT"
    fi
    #--------
    S_FUNC_MMMV_ECHO_T1_TMP_0="`dirname $S_FUNC_MMMV_ECHO_T1_FP_LOG`"
    # The file system accesses of the following few if-clauses 
    # are not as bad as they might look at first glance, because this function 
    # needs to access the file system anyway to write to the log file.
    if [ ! -e "$S_FUNC_MMMV_ECHO_T1_TMP_0" ]; then 
        echo ""
        echo "The folder, where the logfile is expected to be created, the "
        echo ""
        echo "    $S_FUNC_MMMV_ECHO_T1_TMP_0"
        echo ""
        echo "does not exist. "
        echo "If the code in this function, the func_mmmv_echo_t1(...), "
        echo "works as expected, then that folder did exist at some point "
        echo "before the control flow reached this error message."
        echo "GUID=='4c1ac273-c14e-4357-ba4c-73f21101c0e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi 
    if [ -d "$S_FUNC_MMMV_ECHO_T1_FP_LOG" ]; then 
        echo ""
        echo "Something is wrong."
        echo "The path that is expected to reference a log file, "
        echo ""
        echo "    $S_FUNC_MMMV_ECHO_T1_FP_LOG"
        echo ""
        echo "references "
        if [ -h "$S_FUNC_MMMV_ECHO_T1_FP_LOG" ]; then 
            echo "a link to a folder. "
        else
            echo "a folder."
        fi
        if [ "$SB_FUNC_MMMV_ECHO_T1_FIRST_CALL" == "t" ]; then 
            echo ""
            echo "    S_FUNC_MMMV_ECHO_T1_FP_LOGFILE=$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE"
            echo ""
        else
            if [ "$S_FUNC_MMMV_ECHO_T1_FP_LOGFILE" != "" ]; then 
                echo ""
                echo "The implementation of the function "
                echo "func_mmmv_echo_t1(...) is flawed."
                echo "GUID=='31e2b654-ffdb-44aa-a76c-73f21101c0e7'"
                echo ""
            fi
        fi
        echo "GUID=='16214e82-8096-40e4-b41c-73f21101c0e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi 
    #--------
    echo "$S_FUNC_MMMV_ECHO_T1_MSG" | tee -a $S_FUNC_MMMV_ECHO_T1_FP_LOG
} # func_mmmv_echo_t1


#--------------------------------------------------------------------------

S_FP_SANDBOX="$S_FP_DIR/sandbox"
S_FP_CLEAN_SRC="$S_FP_SANDBOX/clean_copy_of_cruisecontrol_source"
S_FP_SRC="$S_FP_SANDBOX/cruisecontrol"
S_FP_LOGS="$S_FP_SANDBOX/cruisecontrol_build_logs"
S_0=".txt"
S_FP_STDOUT="$S_FP_LOGS/cruisecontrol_buildlog_stdout_$S_TIMESTAMP$S_0"
S_FP_STDERR="$S_FP_LOGS/cruisecontrol_buildlog_stderr_$S_TIMESTAMP$S_0"

func_mmmv_echo_t1 "" "$S_FP_STDOUT" # init logfile

func_create_clean_build_folder() {
    mkdir -p $S_FP_LOGS # creates also the $S_FP_SANDBOX
    if [ "$?" != "0" ]; then 
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "The mkdir exited with error code: $? "
        func_mmmv_echo_t1 "GUID=='204db421-5ffc-4ce7-904c-73f21101c0e7'"
        func_mmmv_echo_t1 ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi 
    if [ ! -e "$S_FP_SANDBOX" ]; then 
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "The folder "
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "    $S_FP_SANDBOX"
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "does not exist."
        func_mmmv_echo_t1 "GUID=='48066774-f9f1-4a27-855c-73f21101c0e7'"
        func_mmmv_echo_t1 ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi 
    #--------
    if [ ! -e "$S_FP_CLEAN_SRC" ]; then 
        cd $S_FP_SANDBOX
        svn checkout https://cruisecontrol.svn.sourceforge.net/svnroot/cruisecontrol/trunk/cruisecontrol
        if [ "$?" != "0" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "The svn exited with error code: $? "
            func_mmmv_echo_t1 "GUID=='14da36c7-d696-407d-af3c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        if [ ! -e "$S_FP_SRC" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "The svn checked out something, but the folder structure "
            func_mmmv_echo_t1 "is not what this script expects it to be."
            func_mmmv_echo_t1 "GUID=='1c277f83-f858-4cd5-bf2c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        cp -f -R $S_FP_SRC $S_FP_CLEAN_SRC
        if [ "$?" != "0" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "The cp exited with error code: $? "
            func_mmmv_echo_t1 "GUID=='44cf5472-2e35-4b3b-b72c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
    else # copy the previously downloaded src
        rm -f -R $S_FP_SRC
        if [ "$?" != "0" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "The rm exited with error code: $? "
            func_mmmv_echo_t1 "GUID=='46a9a7b4-0972-46cd-845c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        if [ -e "$S_FP_SRC" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "Deletion of the old copy of the "
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "    $S_FP_SRC"
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "failed."
            func_mmmv_echo_t1 "GUID=='512e8e81-d0a8-4c93-bc4c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        #--------
        cp -f -R $S_FP_CLEAN_SRC $S_FP_SRC
        if [ "$?" != "0" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "The cp exited with error code: $? "
            func_mmmv_echo_t1 "GUID=='b3f57195-3670-49d6-8f4c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
        if [ ! -e "$S_FP_SRC" ]; then 
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "Cration of the copy of the "
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "    $S_FP_SRC"
            func_mmmv_echo_t1 ""
            func_mmmv_echo_t1 "failed."
            func_mmmv_echo_t1 "GUID=='31841885-6e44-4739-ab5c-73f21101c0e7'"
            func_mmmv_echo_t1 ""
            #----
            cd $S_FP_ORIG
            exit 1;
        fi 
    fi 
} # func_create_clean_build_folder


#--------------------------------------------------------------------------

exc_assert_no_err_t1(){ # S_EXIT_CODE, S_GUID_1
    local S_EXIT_CODE="$1"
    local S_GUID_1="$2"
    local S_GUID_2="$3" # optional
    #----
    if [ "$S_GUID_1" == "" ]; then 
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "This script is flawed. "
        func_mmmv_echo_t1 "Some parameters are missing from "
        func_mmmv_echo_t1 "a call to the exc_assert_no_err_t1 "
        func_mmmv_echo_t1 "GUID=='c11f9a0d-43d5-4b3e-9d2c-73f21101c0e7'"
        func_mmmv_echo_t1 ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi
    #----
    if [ "$S_EXIT_CODE" != "0" ]; then 
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "Some command exited with an error code $S_EXIT_CODE"
        func_mmmv_echo_t1 "Log file paths:"
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "    stdout: "
        func_mmmv_echo_t1 "        $S_FP_STDOUT "
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "    stderr: "
        func_mmmv_echo_t1 "        $S_FP_STDERR "
        func_mmmv_echo_t1 ""
        func_mmmv_echo_t1 "GUID=='41b63d51-97d3-4f96-802c-73f21101c0e7'"
        func_mmmv_echo_t1 "GUID==\"$S_GUID_1\""
        if [ "$S_GUID_2" != "" ]; then 
            func_mmmv_echo_t1 "GUID==\"$S_GUID_2\""
        fi
        func_mmmv_echo_t1 ""
        #----
        cd $S_FP_ORIG
        exit 1;
    fi 
} # exc_assert_no_err_t1 

#--------------------------------------------------------------------------

func_attempt_to_build_it_helper_01(){
    local S_FP="$1"
    local S_GUID_2="$2"
    #--------
    local S_LINE_40="----------------------------------------"
    #--------
    func_mmmv_echo_t1 ""
    func_mmmv_echo_t1 "$S_LINE_40$S_LINE_40"
    func_mmmv_echo_t1 "    START  of  $S_GUID_2"
    func_mmmv_echo_t1 "    $S_FP"
    func_mmmv_echo_t1 "$S_LINE_40$S_LINE_40"
    func_mmmv_echo_t1 ""
    #--------
    cd $S_FP
    exc_assert_no_err_t1 "$?" "a80cc4c2-bd9f-4ade-8c1d-73f21101c0e7" "$S_GUID_2"
    ant -logfile $S_FP_STDOUT 2>> $S_FP_STDERR 
    # The ant blabla | tee blabla 
    # can not be used, because otherwise the exc_assert_no_err_t1(...) 
    # catches the exit code of "tee", not "ant".
    exc_assert_no_err_t1 "$?" "55013c85-bd6b-4d16-932d-73f21101c0e7" "$S_GUID_2"
    #--------
    func_mmmv_echo_t1 ""
    func_mmmv_echo_t1 "$S_LINE_40$S_LINE_40"
    func_mmmv_echo_t1 "    THE END  of  $S_GUID_2"
    func_mmmv_echo_t1 "    $S_FP"
    func_mmmv_echo_t1 "$S_LINE_40$S_LINE_40"
    func_mmmv_echo_t1 ""
    #--------
} # func_attempt_to_build_it_helper_01


func_attempt_to_build_it(){
    func_attempt_to_build_it_helper_01 \
        "$S_FP_SRC/reporting/dashboard" \
        "a2ad35cb-867f-406f-8a5c-73f21101c0e7"
    func_attempt_to_build_it_helper_01 \
        "$S_FP_SRC/main" \
        "d2ff345e-0259-42d5-9e4c-73f21101c0e7"
    func_attempt_to_build_it_helper_01 \
        "$S_FP_SRC/reporting/jsp" \
        "270cbb1e-a0b2-4813-894c-73f21101c0e7"
} # func_attempt_to_build_it


#--------------------------------------------------------------------------

func_create_clean_build_folder
func_attempt_to_build_it

#--------------------------------------------------------------------------
cd $S_FP_ORIG
#==========================================================================

