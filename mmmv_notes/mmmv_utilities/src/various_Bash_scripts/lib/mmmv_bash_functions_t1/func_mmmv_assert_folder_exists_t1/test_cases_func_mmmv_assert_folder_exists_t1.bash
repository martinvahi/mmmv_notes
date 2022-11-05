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
        echo "GUID=='531be055-c30d-4a3c-a837-a101105125e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo "This code is flawed."
            echo "GUID=='d5cd95d2-83fe-4ca8-b817-a101105125e7'"
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
                echo "GUID=='9e35cbe8-475f-4cee-a247-a101105125e7'"
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
            echo "GUID=='93d8cde7-9401-40bd-a137-a101105125e7'"
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
            echo "GUID=='74de5f7b-c071-435b-8e67-a101105125e7'"
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
            echo "GUID=='3eb02501-fc0a-4e8f-bb56-a101105125e7'"
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
                    echo "GUID=='a249e8f3-2c4d-440e-bfd6-a101105125e7'"
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
S_FP="/tmp/tmp_test_mmmv_bash_functions_t1/test_func_mmmv_assert_folder_exists_t1/$S_TIMESTAMP"
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
       "3a6f2862-2db0-4614-a237-a101105125e7"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "25fceea3-53aa-42dc-a837-a101105125e7" \
       "f"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "75b28169-9e61-49e4-8c47-a101105125e7" \
       "t"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./existing_folder" \
       "5ddc10db-1022-4524-9937-a101105125e7" \
       ""
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./symlink_2_existing_folder" \
       "338c7f83-081d-445e-9a47-a101105125e7"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./symlink_2_existing_folder" \
       "2f020925-5c7f-49a0-a146-a101105125e7" \
       "f"
    #--------------------------------------------
    func_mmmv_assert_folder_exists_t1 \
       "./symlink_2_existing_folder" \
       "9a545e46-3b73-4dc4-9856-a101105125e7" \
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
           "126a45e3-64fd-4339-bd56-a101105125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_1" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./existing_file" \
           "b3a21ebf-f74d-4fa8-a216-a101105125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_2" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./existing_file" \
           "ba7a4325-b724-4b81-8626-a101105125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_3" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "4f3d6bb2-0107-449f-bc36-a101105125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_4" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "5f7f1574-1216-47ce-b436-a101105125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_5" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "31ef0810-5fda-47aa-9d46-a101105125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_6" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "24d11e92-9a4c-4c2c-9b26-a101105125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_7" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "268cfb42-4dc6-4c5d-8346-a101105125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_8" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "61c87074-21b5-47fc-8d56-a101105125e7" \
           ""
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_9" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "2f544d02-573d-46b8-9f46-a101105125e7"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_10" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "2f2a543f-807c-415d-9076-a101105125e7" \
           "f"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_11" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "d36ada8c-6e0b-43ee-b046-a101105125e7" \
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
           "445a5a62-806c-4a43-9125-a101105125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_13" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_file" \
           "63362ea1-4ac6-4386-a045-a101105125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_14" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./broken_symlink" \
           "33ec9803-009e-4c0a-ae25-a101105125e7" \
           "t"
    fi
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_15" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./this/does/not/exist" \
           "556e36e3-f77c-4618-8b15-a101105125e7" \
           "t"
    fi
    #--------------------------------------------
    #--------------------------------------------
    if [ "$S_TEST_ID" == "assertion_expected_to_fail_16" ]; then
        func_mmmv_assert_folder_exists_t1 \
           "./symlink_2_existing_folder" \
           "12857d30-db82-4553-a735-a101105125e7" \
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
    echo "GUID=='4f560e42-f34e-43a3-9156-a101105125e7'"
    echo ""
    exit 172 # no other exit clause in this file uses that error code
fi

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0 # All assertions passed and no other errors were detected.
#==========================================================================
