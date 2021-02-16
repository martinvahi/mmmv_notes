#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FP_TESTDIR="$S_FP_DIR/Bash_lang_test_t1_$S_TIMESTAMP"
#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of this Bash script is aborted."
        echo "GUID=='68b5a32e-9216-497e-91c0-416180e163e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "ruby"

#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_mmmv_wait_and_sync_t1

#--------------------------------------------------------------------------

func_run_test(){
    local S_FP_IN="$1"
    #---------------------------------------
    local S_FN_0="`ruby -e \"\
        s=ARGV[0]; \
        s_1=(((s.reverse)[0..(s.reverse.index('/')-1)]).reverse); \
        print(s_1)\
        \" \"$S_FP_IN\"`"
    echo "$S_FN_0"
    #---------------------------------------
    if [ -e "$S_FP_IN" ]; then
        echo "     -e  : true "
    else
        echo "     -e  : false "
    fi
    #---------------
    if [ -h "$S_FP_IN" ]; then
        echo "     -h  : true "
    else
        echo "     -h  : false "
    fi
    #---------------
    if [ -d "$S_FP_IN" ]; then
        echo "     -d  : true "
    else
        echo "     -d  : false "
    fi
    #---------------------------------------
    echo ""
} # func_run_test

#--------------------------------------------------------------------------
func_try_2_create_hardlink(){
    local S_FP_ORIGIN="$1"
    local S_FP_LINK="$2"
    #---------------------------------------
    if [ "$S_FP_ORIGIN" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "GUID=='14d9cd3c-40e4-46d0-a4c0-416180e163e7'"
        echo ""
        exit 1
    fi
    if [ "$S_FP_LINK" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "GUID=='7f8fe8e1-0623-4eb0-bfc0-416180e163e7'"
        echo ""
        exit 1
    fi
    if [ "$S_FP_ORIGIN" == "$S_FP_LINK" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "GUID=='548ad211-1960-47d5-bfc0-416180e163e7'"
        echo ""
        exit 1
    fi
    #---------------------------------------
    ln "$S_FP_ORIGIN" "$S_FP_LINK"
    local S_TMP_0="$?"
    if [ "$S_TMP_0" != "0" ]; then
        echo ""
        echo "The creation of a hardlink failed. S_TMP_0==$S_TMP_0"
        echo "Aborting script."
        echo "GUID=='ec778218-2fc9-48f4-94c0-416180e163e7'"
        echo ""
        exit 1
    fi
    #---------------------------------------
} # func_try_2_create_hardlink

#--------------------------------------------------------------------------
cd "$S_FP_DIR"
    mkdir "$S_FP_TESTDIR"
    func_mmmv_wait_and_sync_t1
    if [ ! -e "$S_FP_TESTDIR" ]; then
        echo ""
        echo " Failed to create a folder with the path of "
        echo ""
        echo "    $S_FP_TESTDIR"
        echo ""
        echo "Aborting script."
        echo "GUID=='09e5f247-0e7a-43de-a1c0-416180e163e7'"
        echo ""
        exit 1
    fi
    cd "$S_FP_TESTDIR"
        #------------------------------------------------------------------
        echo ""
        func_run_test "$S_FP_TESTDIR" # test for a folder
        #------------------------------------------------------------------
        S_FP="$S_FP_TESTDIR/x_symlink_2_folder"
        ln -s "$S_FP_TESTDIR" "$S_FP"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP"
        S_FP_1="$S_FP_TESTDIR/x_symlink_2_symlink_2_folder"
        ln -s "$S_FP" "$S_FP_1"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP_1"
        func_try_2_create_hardlink "$S_FP" "$S_FP"'_hardlink'
        func_try_2_create_hardlink "$S_FP_1" "$S_FP_1"'_hardlink'
        #------------------------------------------------------------------
        S_FP="$S_FP_TESTDIR/x_broken_symlink"
        S_FP_1="$S_FP_TESTDIR/this_does_not_exist"
        ln -s "$S_FP_1" "$S_FP"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP"
        func_run_test "$S_FP_1"
        func_try_2_create_hardlink "$S_FP" "$S_FP"'_hardlink'
        # func_try_2_create_hardlink "$S_FP_1" "$S_FP_1"'_hardlink' # can't be made
        #------------------------------------------------------------------
        S_FP="$S_FP" # just to assure that it has not been forgotten
        S_FP_1="$S_FP_TESTDIR/x_symlink_2_broken_symlink"
        ln -s "$S_FP" "$S_FP_1"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP_1"
        # func_try_2_create_hardlink "$S_FP" "$S_FP"'_hardlink' # would duplicate
        func_try_2_create_hardlink "$S_FP_1" "$S_FP_1"'_hardlink'
        #------------------------------------------------------------------
        S_FP="$S_FP_TESTDIR/x_existing_plain_file.txt"
        echo "Hello World!" > "$S_FP"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP"
        S_FP_1="$S_FP_TESTDIR/x_symlink_2_file"
        ln -s "$S_FP" "$S_FP_1"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP_1"
        func_try_2_create_hardlink "$S_FP" "$S_FP"'_hardlink'
        func_try_2_create_hardlink "$S_FP_1" "$S_FP_1"'_hardlink'
        #------------------------------------------------------------------
        S_FP="$S_FP_TESTDIR/x_symlink_2_symlink_2_file"
        S_FP_1="$S_FP_1" # just to assure that it has not been forgotten
        ln -s "$S_FP_1" "$S_FP"
        func_mmmv_wait_and_sync_t1
        func_run_test "$S_FP"
        func_try_2_create_hardlink "$S_FP" "$S_FP"'_hardlink'
        #------------------------------------------------------------------
        ls -l --inode  # shows inode numbers and inode reference counts
        echo ""
        #------------------------------------------------------------------
cd "$S_FP_ORIG"
#--------------------------------------------------------------------------
# Console output example:
#
# Bash_lang_test_t1_2019_06_30_T_08h_02min_27s
#      -e  : true 
#      -h  : false 
#      -d  : true 
# 
# x_symlink_2_folder
#      -e  : true 
#      -h  : true 
#      -d  : true 
# 
# x_symlink_2_symlink_2_folder
#      -e  : true 
#      -h  : true 
#      -d  : true 
# 
# x_broken_symlink
#      -e  : false 
#      -h  : true 
#      -d  : false 
# 
# this_does_not_exist
#      -e  : false 
#      -h  : false 
#      -d  : false 
# 
# x_symlink_2_broken_symlink
#      -e  : false 
#      -h  : true 
#      -d  : false 
# 
# x_existing_plain_file.txt
#      -e  : true 
#      -h  : false 
#      -d  : false 
# 
# x_symlink_2_file
#      -e  : true 
#      -h  : true 
#      -d  : false 
# 
# x_symlink_2_symlink_2_file
#      -e  : true 
#      -h  : true 
#      -d  : false 
# 
# total 48
# 3410193 lrwxrwxrwx 2 ts2 users 79 Jun 30 08:02 x_broken_symlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/this_does_not_exist
# 3410193 lrwxrwxrwx 2 ts2 users 79 Jun 30 08:02 x_broken_symlink_hardlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/this_does_not_exist
# 3410201 -rw-r--r-- 2 ts2 users 13 Jun 30 08:02 x_existing_plain_file.txt
# 3410201 -rw-r--r-- 2 ts2 users 13 Jun 30 08:02 x_existing_plain_file.txt_hardlink
# 3410194 lrwxrwxrwx 2 ts2 users 76 Jun 30 08:02 x_symlink_2_broken_symlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_broken_symlink
# 3410194 lrwxrwxrwx 2 ts2 users 76 Jun 30 08:02 x_symlink_2_broken_symlink_hardlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_broken_symlink
# 3410202 lrwxrwxrwx 2 ts2 users 85 Jun 30 08:02 x_symlink_2_file -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_existing_plain_file.txt
# 3410202 lrwxrwxrwx 2 ts2 users 85 Jun 30 08:02 x_symlink_2_file_hardlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_existing_plain_file.txt
# 3407951 lrwxrwxrwx 2 ts2 users 59 Jun 30 08:02 x_symlink_2_folder -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s
# 3407951 lrwxrwxrwx 2 ts2 users 59 Jun 30 08:02 x_symlink_2_folder_hardlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s
# 3410203 lrwxrwxrwx 2 ts2 users 76 Jun 30 08:02 x_symlink_2_symlink_2_file -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_symlink_2_file
# 3410203 lrwxrwxrwx 2 ts2 users 76 Jun 30 08:02 x_symlink_2_symlink_2_file_hardlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_symlink_2_file
# 3410029 lrwxrwxrwx 2 ts2 users 78 Jun 30 08:02 x_symlink_2_symlink_2_folder -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_symlink_2_folder
# 3410029 lrwxrwxrwx 2 ts2 users 78 Jun 30 08:02 x_symlink_2_symlink_2_folder_hardlink -> /home/ts2/demo/Bash_lang_test_t1_2019_06_30_T_08h_02min_27s/x_symlink_2_folder
#
#==========================================================================
