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
        echo "GUID=='25781a23-21e9-4426-8410-2160905125e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='494693b1-fa1c-498d-bf10-2160905125e7'"
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
                echo "GUID=='1fe4abb3-2407-417f-831f-2160905125e7'"
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
            echo "GUID=='52a14f21-91c2-447b-a05f-2160905125e7'"
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
            echo "GUID=='498514c5-9bb5-43c4-b42f-2160905125e7'"
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
            echo "GUID=='5e13da65-5265-40bf-b92f-2160905125e7'"
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
                    echo "GUID=='a1b1dc11-e88d-44c8-b8cf-2160905125e7'"
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
S_FP="/tmp/tmp_test_mmmv_bash_functions_t1/test_func_mmmv_assert_file_exists_t1/$S_TIMESTAMP"
mkdir -p "$S_FP"
sync; wait
cd "$S_FP" # Needed by the tests and the following function.

func_prepare_test(){
    mkdir -p ./existing_folder
    rm -f ./symlink_2_existing_folder
    ln -s ./existing_folder ./symlink_2_existing_folder
    #--------------------
    rm -f ./existing_file
    rm -f ./symlink_2_existing_file
    echo "Testing-testing" > ./existing_file
    ln -s ./existing_file ./symlink_2_existing_file
    #--------------------
    rm -f ./broken_symlink
    ln -s ./this/does/not/exist ./broken_symlink
    sync; wait
} # func_prepare_test

func_prepare_test

#--------------------------------------------------------------------------
# Signature:
# func_mmmv_assert_file_exists_t1 S_FP S_GUID_CANDIDATE SB_OPTIONAL_BAN_SYMLINKS

func_calls_that_should_all_pass(){
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./existing_file" \
       "5d086d87-d9c7-4940-b420-2160905125e7"
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./existing_file" \
       "f4b205e1-480c-4bf1-9a40-2160905125e7" \
       "f"
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./existing_file" \
       "f5543eb8-8ccd-4878-bc3f-2160905125e7" \
       "t"
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./existing_file" \
       "f381b786-4858-44b2-bd4f-2160905125e7" \
       ""
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./symlink_2_existing_file" \
       "913b4366-3df3-4e35-ab5f-2160905125e7"
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./symlink_2_existing_file" \
       "57e28d55-93fd-46ae-8c4f-2160905125e7" \
       "f"
    #--------------------------------------------
    func_mmmv_assert_file_exists_t1 \
       "./symlink_2_existing_file" \
       "5fd45873-03e5-416a-9d4f-2160905125e7" \
       ""
    #--------------------------------------------
} # func_calls_that_should_all_pass

#--------------------------------------------------------------------------
S_TEST_ID="$1"
if [ "$S_TEST_ID" == "" ]; then
    echo ""
    echo "Executing only tests, where the assertion has to pass."
    echo ""
    func_calls_that_should_all_pass
fi

#--------------------------------------------------------------------------
# Signature:
# func_mmmv_assert_file_exists_t1 S_FP S_GUID_CANDIDATE SB_OPTIONAL_BAN_SYMLINKS

func_calls_that_should_fail_when_symlinks_are_allowed(){
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_0" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./existing_folder" \
           "a57a544e-63bd-449e-9bbf-2160905125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_1" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./existing_folder" \
           "27facd34-b5da-4591-bb2f-2160905125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_2" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./existing_folder" \
           "2def7dc4-b368-41dc-8f4f-2160905125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_3" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./symlink_2_existing_folder" \
           "950ec82a-5c00-4ed5-965f-2160905125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_4" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./symlink_2_existing_folder" \
           "602d79f7-0dbf-47e8-b45f-2160905125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_5" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./symlink_2_existing_folder" \
           "36347473-64e5-4b3f-aa5f-2160905125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_6" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./broken_symlink" \
           "5e6f1a85-6ff9-4334-9a3f-2160905125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_7" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./broken_symlink" \
           "2167f1b2-d237-419f-a62f-2160905125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_8" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./broken_symlink" \
           "23f3ac53-1860-4db5-8a5f-2160905125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_9" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./this/does/not/exist" \
           "3a75d7c5-3b09-47b3-8f4e-2160905125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_10" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./this/does/not/exist" \
           "f14fdf7d-cee5-428c-bc4e-2160905125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_11" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./this/does/not/exist" \
           "54816e22-827a-4235-a13e-2160905125e7" \
           ""
    fi
    #--------------------------------------------
} # func_calls_that_should_fail_when_symlinks_are_allowed
func_calls_that_should_fail_when_symlinks_are_allowed

#--------------------------------------------------------------------------
# Signature:
# func_mmmv_assert_file_exists_t1 S_FP S_GUID_CANDIDATE SB_OPTIONAL_BAN_SYMLINKS

func_calls_that_should_fail_when_symlinks_are_banned(){
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_12" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./existing_folder" \
           "81e496a3-3ae7-4b49-8f4e-2160905125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_13" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./symlink_2_existing_folder" \
           "5a6c6635-b645-4d7b-8e4e-2160905125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_14" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./broken_symlink" \
           "519d7204-0387-4432-9f3e-2160905125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_15" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./this/does/not/exist" \
           "13d21272-d111-4b37-8d3e-2160905125e7" \
           "t"
    fi
    #--------------------------------------------
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_16" ]; then
        func_mmmv_assert_file_exists_t1 \
           "./symlink_2_existing_file" \
           "16988cc5-2a62-474a-935e-2160905125e7" \
           "t"
    fi
    #--------------------------------------------
} # func_calls_that_should_fail_when_symlinks_are_banned

func_calls_that_should_fail_when_symlinks_are_banned

#--------------------------------------------------------------------------
if [ "$S_TEST_ID" != "" ]; then
    echo ""
    echo "Either a test, where the assertion was expected to fail "
    echo "did not pass or there was no test with a test ID of \"$S_TEST_ID\"."
    echo "GUID=='47f5f432-0425-4964-af5f-2160905125e7'"
    echo ""
    exit 172 # no other exit clause in this file uses that error code
fi

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0 # All assertions passed and no other errors were detected.
#==========================================================================
