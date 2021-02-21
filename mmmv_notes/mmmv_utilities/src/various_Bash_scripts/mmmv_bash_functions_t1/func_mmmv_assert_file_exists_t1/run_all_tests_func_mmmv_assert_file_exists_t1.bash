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
S_FN_TEST_CASES="test_cases_func_mmmv_assert_file_exists_t1.bash"
S_FP_TEST_CASES="$S_FP_DIR/$S_FN_TEST_CASES"

if [ ! -e "$S_FP_TEST_CASES" ]; then
    echo ""
    echo "The file "
    echo ""
    echo "    $S_FP_TEST_CASES"
    echo ""
    echo "is missing. No tests run."
    echo "GUID=='62346512-e2a0-4854-94d0-4330905125e7'"
    echo ""
    #--------
    cd "$S_FP_ORIG"
    exit 1 # exiting with an error
fi
if [ -d "$S_FP_TEST_CASES" ]; then
    echo ""
    echo "The "
    echo ""
    echo "    $S_FP_TEST_CASES"
    echo ""
    echo "is a folder or a symlink to a folder, but "
    echo "it is expected to be a file. No tests run."
    echo "GUID=='418e1334-326b-48cc-a1d0-4330905125e7'"
    echo ""
    #--------
    cd "$S_FP_ORIG"
    exit 1 # exiting with an error
fi
#--------------------------------------------------------------------------
func_run_single_test_case_that_is_expected_to_throw(){
    local S_TEST_ID="$1"
    #--------------------
    bash "$S_FP_TEST_CASES" "$S_TEST_ID" 1> /dev/null
    local S_ERR_CODE="$?"
    #--------------------
    if [ "$S_ERR_CODE" != "1" ]; then
        echo ""
        echo "Test with a test ID of \"$S_TEST_ID\" failed."
        echo "GUID=='d8a57c36-a288-4768-a3d0-4330905125e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
} # func_run_single_test_case_that_is_expected_to_throw

rt(){
    local S_TEST_ID="$1"
    func_run_single_test_case_that_is_expected_to_throw "$S_TEST_ID"
}
#--------------------------------------------------------------------------

func_run_tests_that_are_not_expected_to_throw(){
    #--------------------
    bash "$S_FP_TEST_CASES"  1> /dev/null
    local S_ERR_CODE="$?"
    #--------------------
    if [ "$S_ERR_CODE" != "0" ]; then
        # The 
        bash "$S_FP_TEST_CASES"
        # tells the GUID of the area, where the failing test resides.
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #--------------------
} # func_run_tests_that_are_not_expected_to_throw
func_run_tests_that_are_not_expected_to_throw

#--------------------------------------------------------------------------

rt "assertion_expected_to_fail_0"
rt "assertion_expected_to_fail_1"
rt "assertion_expected_to_fail_2"
rt "assertion_expected_to_fail_3"
rt "assertion_expected_to_fail_4"
rt "assertion_expected_to_fail_5"
rt "assertion_expected_to_fail_6"
rt "assertion_expected_to_fail_7"
rt "assertion_expected_to_fail_8"
rt "assertion_expected_to_fail_9"
rt "assertion_expected_to_fail_10"
rt "assertion_expected_to_fail_11"
rt "assertion_expected_to_fail_12"
rt "assertion_expected_to_fail_13"
rt "assertion_expected_to_fail_14"
rt "assertion_expected_to_fail_15"
rt "assertion_expected_to_fail_16"

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
echo ""
echo "All tests passed."
echo ""
exit 0 # all tests passed.
#==========================================================================
