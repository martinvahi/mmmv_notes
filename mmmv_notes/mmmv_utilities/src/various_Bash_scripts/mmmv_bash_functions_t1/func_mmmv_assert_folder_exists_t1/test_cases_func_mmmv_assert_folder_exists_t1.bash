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

func_mmmv_assert_folder_exists_t1() {
    local S_FP="$1"
    local S_GUID_CANDIDATE="$2"
    local SB_OPTIONAL_BAN_SYMLINKS="$3" # domain: {"t", "f", ""} default: "f"
                                        # is the last formal parameter 
                                        # in stead of the S_GUID_CANDIDATE, 
                                        # because that way this function is 
                                        # backwards compatibile with 
                                        # an earlier version of this 
                                        # funciton.
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
        echo "This function requires 2 parameters, whcih are "
        echo "S_FP, S_GUID_CANDIDATE, and it has an optional 3. parameter, "
        echo "which is SB_OPTIONAL_BAN_SYMLINKS."
        if [ "$S_GUID_CANDIDATE" != "" ]; then
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        fi
        echo "GUID=='a215ba3f-7ef2-4021-9203-2173005125e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='27aa2586-b440-49bb-b3f2-2173005125e7'"
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
                echo "GUID=='2654bc94-c664-42ee-93f2-2173005125e7'"
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
            echo "GUID=='2796c502-789b-40bb-a5f2-2173005125e7'"
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
            echo "GUID=='d3605429-6ad7-4884-83f2-2173005125e7'"
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
            echo "GUID=='fbbd0915-a40a-463f-adf2-2173005125e7'"
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
                    echo "GUID=='63c845c2-8b76-40ce-89f2-2173005125e7'"
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
S_FP="/tmp/tmp_test_func_mmmv_assert_folder_exists_t1/$S_TIMESTAMP"
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
# func_mmmv_assert_folder_exists_t1 S_FP S_GUID_CANDIDATE SB_OPTIONAL_BAN_SYMLINKS

func_calls_that_should_all_pass(){
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "41d54864-7c78-4a37-b403-2173005125e7"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "1ee4e2f3-096f-473e-b2f2-2173005125e7" \
       "f"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "6cfa064e-fa8b-4ae2-a4f2-2173005125e7" \
       "t"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "ee760b18-2b8b-4bd7-81f2-2173005125e7" \
       ""
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./symlink_2_existing_folder" \
       "1aff8195-8dc6-4b37-b3f2-2173005125e7"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./symlink_2_existing_folder" \
       "ced3a63a-cfa1-4303-83f2-2173005125e7" \
       "f"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./symlink_2_existing_folder" \
       "d565f968-1b04-4605-89f2-2173005125e7" \
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
# func_mmmv_assert_folder_exists_t1 S_FP S_GUID_CANDIDATE SB_OPTIONAL_BAN_SYMLINKS

func_calls_that_should_fail_when_symlinks_are_allowed(){
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_0" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./existing_file" \
           "c09f333a-01a8-4ccf-95f2-2173005125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_1" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./existing_file" \
           "e1ec50dc-7936-412a-b1f2-2173005125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_2" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./existing_file" \
           "a9212f3e-0057-4335-b1f2-2173005125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_3" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "a357c432-6639-4a65-b1f2-2173005125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_4" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "4faf4c91-ea25-4146-b3f2-2173005125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_5" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "865b2641-b678-4221-bcf2-2173005125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_6" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "15327215-c4be-48ff-a5f2-2173005125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_7" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "d3ed4d84-060d-413a-98e2-2173005125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_8" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "45692b38-104e-4c9d-91e2-2173005125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_9" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "19583d33-a349-46f6-82e2-2173005125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_10" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "ca27bc32-f124-4c69-92e2-2173005125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_11" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "3db7d941-4bc6-45fb-b4e2-2173005125e7" \
           ""
    fi
    #--------------------------------------------
} # func_calls_that_should_fail_when_symlinks_are_allowed
func_calls_that_should_fail_when_symlinks_are_allowed

#--------------------------------------------------------------------------
# Signature:
# func_mmmv_assert_folder_exists_t1 S_FP S_GUID_CANDIDATE SB_OPTIONAL_BAN_SYMLINKS

func_calls_that_should_fail_when_symlinks_are_banned(){
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_12" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./existing_file" \
           "2b47c02d-43fa-449b-91e2-2173005125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_13" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "59377913-5feb-4f2e-95e2-2173005125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_14" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "75e6dbfc-4b5b-4b2e-b1e2-2173005125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_15" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "88f40e5d-0d3e-4910-b3e2-2173005125e7" \
           "t"
    fi
    #--------------------------------------------
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_16" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_folder" \
           "8e103a12-c6bf-4390-a1e2-2173005125e7" \
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
    echo "GUID=='f535bd1b-ee8e-4283-b4f2-2173005125e7'"
    echo ""
    exit 172 # no other exit clause in this file uses that error code
fi

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0 # All assertions passed and no other errors were detected.
#==========================================================================
