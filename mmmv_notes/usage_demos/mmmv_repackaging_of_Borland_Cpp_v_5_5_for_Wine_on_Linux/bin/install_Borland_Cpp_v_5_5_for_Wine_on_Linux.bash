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
        echo "GUID=='53691e48-b87f-49de-a504-0391316137e7'"
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
    echo "GUID=='4969a103-ac89-41b7-8f04-0391316137e7'"
    echo ""
fi
#--------------------------------------------------------------------------

func_main(){
    #----------------------------------------------------------------------
    local SB_DISPLAY_NONERROR_FEEDBACK="t" # domain: {"t","f",""}; default: "" -> "f"
    local SB_OK_TO_CACHE="t" # domain: {"t","f",""}; default: "" -> "f"
    #----------------------------------------
    local S_FP_BORLAND_CPP_V_5_5_INSTALLER_HOME="$S_FP_PROJECT_HOME/bonnet/Borland_v_5_5_installer"
    local S_FP_INSTALLER="$S_FP_BORLAND_CPP_V_5_5_INSTALLER_HOME/freecommandLinetools.exe"
    # Proper Borland version 5.5 compiler usage instructions reside
    # at a Windows Help file, which MIGHT be displayed on Linux by executing the 
    local S_FP_DISPLAY_BORLAND_CPP_V_5_5_HELP_BASH="$S_FP_PROJECT_HOME/bin/display_Borland_Cpp_v_5_5_help_by_using_Wine_and_winhlp32_exe.bash"
    #----------------------------------------
    local S_FP_C="$HOME/.wine/drive_c"
    local SB_OPTIONAL_BAN_SYMLINKS="f"
    #----------------------------------------
    # 'C:\Borland\BCC55\Help\bcb5tool.hlp'
    local S_FP_BORLAND_CPP_V_5_5="$S_FP_C/Borland/BCC55"
    local S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP="$S_FP_BORLAND_CPP_V_5_5/Help"
    local S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP_FILE="$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP/bcb5tool.hlp"
    local S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_ORIGIN="$S_FP_BORLAND_CPP_V_5_5_INSTALLER_HOME/Using_the_Borland_5.pdf"
    local S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION="$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP/Using_the_Borland_5.pdf"
    #----------------------------------------------------------------------
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
        echo "Wine dialogs use GUI."
    fi
    func_mmmv_assert_GUI_applications_can_be_launched_t1 \
        "564f5b14-9dcd-48a6-b104-0391316137e7" \
        "$SB_OK_TO_CACHE" "$SB_DISPLAY_NONERROR_FEEDBACK"
    #----------------------------------------
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
        echo "Sometimes Wine downloads some Mono version."
    fi
    func_mmmv_assert_internet_connection_exists_t1 \
        "44cf722b-a02c-47dd-b304-0391316137e7" \
        "$SB_OK_TO_CACHE" "$SB_DISPLAY_NONERROR_FEEDBACK"
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
    fi
    #----------------------------------------
    func_mmmv_exc_initialize_wine_C_drive_if_needed_t1 \
        "$SB_DISPLAY_NONERROR_FEEDBACK"
    func_mmmv_assert_folder_exists_t1 "$S_FP_C" \
        "20a500b5-af70-48e6-9204-0391316137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    #----------------------------------------------------------------------
    SB_OPTIONAL_BAN_SYMLINKS="t"
    if [ ! -e "$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP_FILE" ]; then
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
            "2acc1b11-fb4a-4553-a504-0391316137e7"
        func_mmmv_wait_and_sync_t1
        #------------------------------------------------------------------
        #func_mmmv_assert_folder_exists_t1 "$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP" \
        #    "517cb045-62d3-421c-8104-0391316137e7" \
        #    "$SB_OPTIONAL_BAN_SYMLINKS"
        func_mmmv_assert_file_exists_t1 "$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP_FILE" \
            "f1410f69-4a16-41ac-9204-0391316137e7" \
            "$SB_OPTIONAL_BAN_SYMLINKS"
        func_mmmv_assert_file_exists_t1 "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_ORIGIN" \
            "f47bf697-7598-4669-a204-0391316137e7" \
            "$SB_OPTIONAL_BAN_SYMLINKS"
        if [ ! -e "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION" ]; then
            nice -n 3 cp -f "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_ORIGIN" "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION"
            func_mmmv_assert_error_code_zero_t1 "$?" \
                "73e69233-971b-4ea7-b204-0391316137e7"
            func_mmmv_wait_and_sync_t1
            func_mmmv_assert_file_exists_t1 "$S_FP_SUPERFICIAL_INSTRUCTIONS_PDF_DESTINATION" \
                "f5b1945f-abcc-44b4-8504-0391316137e7" \
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
            echo "GUID=='95347e82-a95e-44d5-8104-0391316137e7'"
        fi
        #------------------------------------------------------------------
    fi
    #----------------------------------------------------------------------
    #func_mmmv_assert_folder_exists_t1 "$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP" \
    #    "0f43852f-7dc2-4984-b104-0391316137e7" \
    #    "$SB_OPTIONAL_BAN_SYMLINKS"
    func_mmmv_assert_file_exists_t1 "$S_FP_BORLAND_CPP_V_5_5_WINDOWS_HELP_FILE" \
        "94ba8319-ec2a-49c6-8304-0391316137e7" \
        "$SB_OPTIONAL_BAN_SYMLINKS"
    #----------------------------------------------------------------------
    if [ "$SB_DISPLAY_NONERROR_FEEDBACK" == "t" ]; then
        echo ""
        echo "You may want to use the "
        echo -e "\e[33m    $S_FP_DISPLAY_BORLAND_CPP_V_5_5_HELP_BASH \e[39m"
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
# S_VERSION_OF_THIS_FILE="342ec2bd-7785-4787-9404-0391316137e7"
#==========================================================================
