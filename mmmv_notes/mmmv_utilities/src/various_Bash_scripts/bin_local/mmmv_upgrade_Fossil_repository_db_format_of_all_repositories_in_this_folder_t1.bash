#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
#S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_VERSION="d1482824-0eaa-44f5-93eb-d0c0405174e7"
#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME="$1"
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of the Bash script is aborted."
        echo "GUID=='3f78015a-2aa1-442b-95eb-d0c0405174e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

# As the "Windows Subsystem for Linux" might be 
# yet another Microsoft "quality" crapware, the 
# testing for the program "nice" is not an overkill.
func_mmmv_exit_if_not_on_path_t2 "nice"   

# The "fossil" availability is tested, because custom built programs
# might not be on the path by default, specially if the server
# process is run by some user other than the one, who is 
# the owner of the "right" ~/.bashrc
func_mmmv_exit_if_not_on_path_t2 "fossil"

#--------------------------------------------------------------------------


func_mmmv_ar_ls_fossilrepositories_t1() { # S_ARRAY_VARIABLE_NAME S_FP_LS
    local S_ARRAY_VARIABLE_NAME="$1"
    local S_FP_LS="$2"
    #--------
    # The "ls -m "Works with both, BSD and Linux.
    local S_CMD_PREFIX=" ls -m $S_FP_LS/*fossilrepository "
    # It's an expensive test, but it's done relatively rarely. 
    $S_CMD_PREFIX > /dev/null
    local S_ERROR_CODE="$?"
    if [ "$S_ERROR_CODE" != "0" ]; then
        echo ""
        echo "The command "
        echo ""
        echo "    $S_CMD_PREFIX "
        echo ""
        echo "exited with an error code of $S_ERROR_CODE ."
        echo "Aborting script."
        echo "GUID=='f0941091-4db4-4f00-b4eb-d0c0405174e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi 
    local AR_0=$( ls -m $S_FP_LS/*fossilrepository ) 
    #--------
    local S_SCRIPT_0="$S_ARRAY_VARIABLE_NAME=()"
    eval "$S_SCRIPT_0"
    local s_iter=""
    S_SCRIPT_0="$S_ARRAY_VARIABLE_NAME+=(\$s_iter)"
    local S_TMP_IFS="$IFS"
    # The IFS is an internal Bash variable, "Internal Field Separator".
    IFS="," # That should handle file names that contain spaces.
    for s_iter in ${AR_0[@]}; do
        eval "$S_SCRIPT_0"
    done
    IFS="$S_TMP_IFS"
    if [ -z "$IFS" ]; then
        unset IFS
    fi
} # func_mmmv_ar_ls_fossilrepositories_t1


#--------------------------------------------------------------------------

func_mmmv_exec_with_every_ar_element_t1() { # S_CMD_PART_0  S_ARRAY_VARIABLE_NAME_OF_AR_S_CMD_PART_1 S_CMD_PART_2
    local S_CMD_PART_0="$1"
    local S_ARRAY_VARIABLE_NAME_OF_AR_S_CMD_PART_1="$2"
    local S_CMD_PART_2="$3"
    #----------------
    local S_SCRIPT_0=""
    local S_SCRIPT_1=""
    local S_SCRIPT_2=""
    local S_SCRIPT_x0=""
    local S_SCRIPT_x1=""
    local S_SCRIPT_x2=""
    #----------------
    # # Might be wastefully and intentionally left uncommented 
    # # to detect flaws and to make life more comfortable :-)
    # local S_TMP=""
    # S_SCRIPT_0="S_TMP=\${#"
    # S_SCRIPT_1="$S_ARRAY_VARIABLE_NAME_OF_AR_S_CMD_PART_1"
    # S_SCRIPT_2="[@]}"
    # eval "$S_SCRIPT_0$S_SCRIPT_1$S_SCRIPT_2" 
    # #echo "The length of the $S_ARRAY_VARIABLE_NAME_OF_AR_S_CMD_PART_1 is: $S_TMP"
    #----------------
    # The newline trick 
    local S_NEWLINE=$'\n'
    # originates from the answer of Gordon Davisson:
    # https://stackoverflow.com/questions/17821277/how-to-separate-multiple-commands-passed-to-eval-in-bash
    # archival copy: https://archive.fo/7XI3a 
    #--------
    local S_ITER=""
    S_SCRIPT_0="for S_ITER in \${$S_ARRAY_VARIABLE_NAME_OF_AR_S_CMD_PART_1[@]}; do " 
    S_SCRIPT_x0="echo \"\"; echo \"\$S_ITER\""
    #S_SCRIPT_1="echo \"\$S_ITER\" " 
    S_SCRIPT_1="$S_CMD_PART_0 \$S_ITER  $S_CMD_PART_2 ;" 
    S_SCRIPT_x1="echo \"\""
    S_SCRIPT_2="done"
    S_SCRIPT_x2=""
    #----
    local S_TMP_0="$S_SCRIPT_0$S_NEWLINE$S_SCRIPT_x0$S_NEWLINE"
    local S_TMP_1="$S_SCRIPT_1$S_NEWLINE$S_SCRIPT_x1$S_NEWLINE"
    local S_TMP_2="$S_SCRIPT_2$S_NEWLINE$S_SCRIPT_x2$S_NEWLINE"
    eval "$S_TMP_0$S_TMP_1$S_TMP_2"
} # func_mmmv_exec_with_every_ar_element_t1

#--------------------------------------------------------------------------

AR_REPOFILENAMES=""
func_mmmv_ar_ls_fossilrepositories_t1 "AR_REPOFILENAMES" "$S_FP_DIR/"

S_CMD_PART_0="time nice -n20 fossil rebuild "
S_CMD_PART_1=" --vacuum --compress --cluster "

func_mmmv_exec_with_every_ar_element_t1 "$S_CMD_PART_0" "AR_REPOFILENAMES" "$S_CMD_PART_2"

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"  # to be sure
#=========================================================================

