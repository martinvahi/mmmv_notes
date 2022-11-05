#!/usr/bin/env bash
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#==========================================================================

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of this Bash script is aborted."
        echo "GUID=='c41bb0b8-63f2-41cf-882f-30c0405174e7'"
        echo ""
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

#func_mmmv_exit_if_not_on_path_t2 "grep"
#func_mmmv_exit_if_not_on_path_t2 "wc"
#func_mmmv_exit_if_not_on_path_t2 "uname" 
func_mmmv_exit_if_not_on_path_t2 "date" 
func_mmmv_exit_if_not_on_path_t2 "pwd" 
func_mmmv_exit_if_not_on_path_t2 "basename" 

#-------------------------------------------------------
S_AWK_CMD="exit 1;"
func_mmmv_exc_determine_Awk_command_t1() { 
    S_AWK_CMD="exit 1;" # for reliability
    local SB_THROW="f"
    if [ "`which gawk`" != "" ]; then
        S_AWK_CMD="gawk"
    else
        if [ "`which awk`" != "" ]; then
            S_AWK_CMD="awk"
        else
            SB_THROW="t"
        fi
    fi
    if [ "$SB_THROW" != "f" ]; then
        echo ""
        echo "Neither 'gawk', nor 'awk' was available on PATH."
        echo "The execution of this Bash script is aborted."
        echo "GUID=='5bdce971-b7ed-4aa9-ad4f-30c0405174e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exc_determine_Awk_command_t1

func_mmmv_exc_determine_Awk_command_t1

#-------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#S_FN_SKRIPT="`basename $0`"

#----------End-of-main-Boilerplate-----------------------------------------

echo ""
echo "S_AWK_CMD==$S_AWK_CMD"
echo "GUID=='8e66b713-731d-4a2a-8f2f-30c0405174e7'"
echo ""
#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0
#==========================================================================

