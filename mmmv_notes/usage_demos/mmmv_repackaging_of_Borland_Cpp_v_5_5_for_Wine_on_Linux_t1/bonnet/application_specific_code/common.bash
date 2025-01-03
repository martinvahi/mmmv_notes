#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#--------------------------------------------------------------------------
S_FP_PROJECT_HOME="`cd $S_FP_DIR/../../; pwd`"
S_FP_MMMV_BASH_BOILERPLATE="$S_FP_PROJECT_HOME/bonnet/lib/2023_03_20_mmmv_bash_boilerplate_t3/mmmv_bash_boilerplate_t3.bash"
if [ -e "$S_FP_MMMV_BASH_BOILERPLATE" ]; then
    if [ -d "$S_FP_MMMV_BASH_BOILERPLATE" ]; then
        echo ""
        echo "A folder with the path of "
        echo ""
        echo "    S_FP_MMMV_BASH_BOILERPLATE==$S_FP_MMMV_BASH_BOILERPLATE"
        echo ""
        echo "exists, but a file is expected."
        echo "GUID=='23c95344-207a-48ee-91ca-53a1316137e7'"
        echo ""
    else
        source "$S_FP_MMMV_BASH_BOILERPLATE"
    fi
else
    echo ""
    echo "A file with the path of "
    echo ""
    echo "    S_FP_MMMV_BASH_BOILERPLATE==$S_FP_MMMV_BASH_BOILERPLATE"
    echo ""
    echo "could not be found."
    echo "GUID=='fe195c5d-7e24-4a03-a1ca-53a1316137e7'"
    echo ""
fi
#--------------------------------------------------------------------------
func_mmmv_assert_exists_on_path_t1 "nice"
func_mmmv_assert_exists_on_path_t1 "bash"
func_mmmv_assert_exists_on_path_t1 "timeout"
func_mmmv_assert_exists_on_path_t1 "wine"
func_mmmv_assert_exists_on_path_t1 "xeyes" # needed for fast testing
func_mmmv_assert_exists_on_path_t1 "ping"
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="42ef1757-9d35-40b7-a5ca-53a1316137e7"
#==========================================================================
