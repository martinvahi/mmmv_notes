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
        echo "GUID=='40690b12-206a-44a2-af05-4070305137e7'"
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
    echo "GUID=='8dc7583d-00ab-4430-9305-4070305137e7'"
    echo ""
fi
#--------------------------------------------------------------------------

func_main(){
    #----------------------------------------------------------------------
    local SB_DISPLAY_NONERROR_FEEDBACK="t" # domain: {"t","f",""}; default: "" -> "f"
    local SB_OK_TO_CACHE="t" # domain: {"t","f",""}; default: "" -> "f"
    #----------------------------------------
    local S_FP_BORLAND_V_5_5_INSTALLER_HOME="$S_FP_PROJECT_HOME/bonnet/Borland_v_5_5_installer"
    local S_FP_INSTALLER="$S_FP_BORLAND_V_5_5_INSTALLER_HOME/freecommandLinetools.exe"
    # Proper Borland version 5.5 compiler usage instructions reside
    # at a Windows Help file, which MIGHT be displayed on Linux by executing the 
    local S_FP_DISPLAY_BORLAND_V_5_5_HELP_BASH="$S_FP_PROJECT_HOME/bin/display_Borland_v_5_5_help_by_using_Wine_and_winhlp32_exe.bash"
    #----------------------------------------
    local S_FP_C="$HOME/.wine/drive_c"
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    #----------------------------------------
    # 'C:\Borland\BCC55\Help\bcb5tool.hlp'
    local S_FP_BORLAND_V_5_5="$S_FP_C/Borland/BCC55"
    local S_FP_BORLAND_V_5_5_WINDOWS_HELP="$S_FP_BORLAND_V_5_5/Help"
    local S_FP_BORLAND_V_5_5_WINDOWS_HELP_FILE="$S_FP_BORLAND_V_5_5_WINDOWS_HELP/bcb5tool.hlp"
    local S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_ORIGIN="$S_FP_BORLAND_V_5_5_INSTALLER_HOME/Using_the_Borland_5.pdf"
    local S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION="$S_FP_BORLAND_V_5_5_WINDOWS_HELP/Using_the_Borland_5.pdf"
    #----------------------------------------------------------------------
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
        echo "Wine dialogs use GUI."
    fi
    func_mmmv_assert_GUI_applications_can_be_launched_t1 \
        "4f466201-c31c-4d1c-9505-4070305137e7" \
        "$SB_OK_TO_CACHE" "$SB_DISPLAY_NONERROR_FEEDBACK"
    #----------------------------------------
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
        echo "Sometimes Wine downloads some Mono version."
    fi
    func_mmmv_assert_internet_connection_exists_t1 \
        "3fc53ec1-6770-4b79-94f4-4070305137e7" \
        "$SB_OK_TO_CACHE" "$SB_DISPLAY_NONERROR_FEEDBACK"
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
    fi
    #----------------------------------------
    func_mmmv_exc_initialize_wine_C_drive_if_needed_t1 \
        "$SB_DISPLAY_NONERROR_FEEDBACK"
    func_mmmv_assert_folder_exists_t1 "$S_FP_C" \
        "3b7e8d52-a6e0-4227-8df4-4070305137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    #----------------------------------------------------------------------
    SB_OPTIONAL_BAN_SYMLINKS="t"
    if [ ! -e "$S_FP_BORLAND_V_5_5_WINDOWS_HELP_FILE" ]; then
        #------------------------------------------------------------------
        if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
            echo ""
            echo "Attempting to launch the Borland version 5.5 installer, "
            echo -e "    \e[33m$S_FP_INSTALLER\e[39m"
            echo "with Wine. It might take multiple minutes till the "
            echo "dialog of the installer appears..."
        fi
        nice -n 3 wine "$S_FP_INSTALLER"
        func_mmmv_assert_error_code_zero_t1 "$?" \
            "e5f73720-ae1a-492d-a3f4-4070305137e7"
        func_mmmv_wait_and_sync_t1
        #------------------------------------------------------------------
        #func_mmmv_assert_folder_exists_t1 "$S_FP_BORLAND_V_5_5_WINDOWS_HELP" \
        #    "c5d56a4f-1181-427e-a1f4-4070305137e7" \
        #    "$SB_OPTIONAL_BAN_SYMLINKS"
        func_mmmv_assert_file_exists_t1 "$S_FP_BORLAND_V_5_5_WINDOWS_HELP_FILE" \
            "0c4b7a7b-4b6c-4620-81f4-4070305137e7" \
            "$SB_OPTIONAL_BAN_SYMLINKS"
        func_mmmv_assert_file_exists_t1 "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_ORIGIN" \
            "8564d027-cfbd-423f-91f4-4070305137e7" \
            "$SB_OPTIONAL_BAN_SYMLINKS"
        if [ ! -e "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION" ]; then
            nice -n 3 cp -f "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_ORIGIN" "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION"
            func_mmmv_assert_error_code_zero_t1 "$?" \
                "1628e438-8e74-46ed-a5f4-4070305137e7"
            func_mmmv_wait_and_sync_t1
            func_mmmv_assert_file_exists_t1 "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION" \
                "677ca830-8c18-432f-92f4-4070305137e7" \
                "$SB_OPTIONAL_BAN_SYMLINKS"
        fi
        #------------------------------------------------------------------
        if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
            echo ""
            echo -e "Borland version 5.5\e[32m installation succeeded\e[39m."
        fi
        #------------------------------------------------------------------
    else
        #------------------------------------------------------------------
        if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
            echo ""
            echo -e "It seems that the Borland version 5.5 has been\e[32m installed already\e[39m. "
            echo "Skipping the execution of the installer."
            echo "GUID=='58acbc05-9b5b-4c31-9ef4-4070305137e7'"
        fi
        #------------------------------------------------------------------
    fi
    #----------------------------------------------------------------------
    #func_mmmv_assert_folder_exists_t1 "$S_FP_BORLAND_V_5_5_WINDOWS_HELP" \
    #    "55e59354-77b9-4c37-83f4-4070305137e7" \
    #    "$SB_OPTIONAL_BAN_SYMLINKS"
    func_mmmv_assert_file_exists_t1 "$S_FP_BORLAND_V_5_5_WINDOWS_HELP_FILE" \
        "0fba1b4d-b7aa-4c48-a4f4-4070305137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    #----------------------------------------------------------------------
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
        echo "You may want to use the "
        echo -e "\e[33m    $S_FP_DISPLAY_BORLAND_V_5_5_HELP_BASH \e[39m"
        echo "for displaying the Borland version 5.5 Windows help file."
        echo ""
        echo "Thank You for tring out this installer."
        echo ""
    fi
    #----------------------------------------------------------------------
} # func_main
func_main
exit 0
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="5daa5713-b35c-46fc-83f4-4070305137e7"
#==========================================================================
