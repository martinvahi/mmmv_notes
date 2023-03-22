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
S_FP_PROJECT_HOME="`cd $S_FP_DIR/../; pwd`"
S_FP_COMMON_BASH="$S_FP_PROJECT_HOME/bonnet/application_specific_code/common.bash"
if [ -e "$S_FP_COMMON_BASH" ]; then
    if [ -d "$S_FP_COMMON_BASH" ]; then
        echo ""
        echo "A folder with the path of "
        echo ""
        echo "    S_FP_COMMON_BASH==$S_FP_COMMON_BASH"
        echo ""
        echo "exists, but a file is expected."
        echo "GUID=='c40cbd14-3c26-4a27-9214-7191316137e7'"
        echo ""
    else
        source "$S_FP_COMMON_BASH"
    fi
else
    echo ""
    echo "A file with the path of "
    echo ""
    echo "    S_FP_COMMON_BASH==$S_FP_COMMON_BASH"
    echo ""
    echo "could not be found."
    echo "GUID=='b218352b-fd30-41fe-9414-7191316137e7'"
    echo ""
fi
#--------------------------------------------------------------------------

func_display_the_hlp_file(){
    #----------------------------------------
    local S_FP_C="$HOME/.wine/drive_c"
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    func_mmmv_assert_folder_exists_t1 "$S_FP_C" \
        "399754a8-b7ae-479c-9514-7191316137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    local S_FP_BORLAND_CPP_V_5_5="$S_FP_C/Borland/BCC55"
    func_mmmv_assert_folder_exists_t1 "$S_FP_BORLAND_CPP_V_5_5" \
        "472c425f-e724-41be-b114-7191316137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    local S_FP_HLP="$S_FP_BORLAND_CPP_V_5_5/Help/bcb5tool.hlp"
    func_mmmv_assert_file_exists_t1 "$S_FP_HLP" \
        "520e1575-b083-4192-b514-7191316137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    #----------------------------------------
    echo "Attempting to launch winhlp32.exe with Wine. "
    echo -e "Sometimes\e[33m it might take ~3 minutes \e[39m"
    echo "to launch the winhlp32.exe with Wine..."
    nice -n 2 wine 'winhlp32.exe' 'C:\Borland\BCC55\Help\bcb5tool.hlp'
    func_mmmv_assert_error_code_zero_t1 "$?" \
        "3c834043-ed56-4034-b114-7191316137e7"
    #----------------------------------------
} # func_display_the_hlp_file

#--------------------------------------------------------------------------

func_main(){
    #----------------------------------------------------------------------
    local SB_DISPLAY_NONERROR_FEEDBACK="t"
    local SB_OK_TO_CACHE="t" # domain: {"t","f",""}; default: "" -> "f"
    func_mmmv_assert_GUI_applications_can_be_launched_t1 \
        "d323b422-0c23-48bf-8314-7191316137e7" \
        "$SB_OK_TO_CACHE" "$SB_DISPLAY_NONERROR_FEEDBACK"
    #----------------------------------------------------------------------
    func_display_the_hlp_file
    #----------------------------------------------------------------------
} # func_main
func_main
exit 0
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="06dd3942-d611-44fe-a514-7191316137e7"
#==========================================================================
