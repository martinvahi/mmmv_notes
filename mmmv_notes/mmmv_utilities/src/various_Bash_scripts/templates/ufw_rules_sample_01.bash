#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
# The ufw is a wrapper to the iptables. The changes that the ufw does
# can be viewed by executing 
#
#    iptables --list
#
#--------------------------------------------------------------------------

# The main entry to the code is the func_main().

func_warning(){
    #------------------------------
    echo ""    
    echo -e "\e[31mPlease outcomment the call to the function that\e[39m"
    echo -e "\e[31moutputs this message.\e[39m Thank You."    
    echo "GUID=='26919d66-4e4f-4a0c-8913-33d0715086e7'"
    echo ""    
    #--------
    exit 1;
    #------------------------------
} # func_warning

func_settings(){
    #------------------------------
    func_warning
    #------------------------------
    # The 
    S_IPv4_ADDRESS_THAT_IS_ALLOWED_TO_CONNECT_TO_ALL_PORTS="192.168.55.42"
    # is usually a machine on LAN.
    #------------------------------
} # func_settings

#--------------------------------------------------------------------------
#::::::::Everything::below::this::line::is:::implementation::::::::::::::::
#--------------------------------------------------------------------------
func_mmmv_exit_if_not_on_path_t2b() { # S_COMMAND_NAME
    local S_COMMAND_NAME="$1"
    #----------------------------------------------------------------------
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo -e "\e[31mCommand \"$S_COMMAND_NAME\" could not be found from the PATH. \e[39m"
        echo "The execution of this Bash script is aborted."
        echo "GUID=='14497fd5-1ab6-4c0f-a343-33d0715086e7'"
        echo ""
        #--------
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2b

func_mmmv_exit_if_not_on_path_t2b "grep"
func_mmmv_exit_if_not_on_path_t2b "iptables"
func_mmmv_exit_if_not_on_path_t2b "ufw"

#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t2(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #----------------------------------------------------------------------
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        echo ""
        echo -e "\e[31mThe Bash code that calls this function is flawed. \e[39m"
        echo ""
        echo "    S_GUID_CANDIDATE==\"\""
        echo ""
        echo "but it is expected to be a GUID."
        echo "Aborting script."
        echo "GUID=='68bae2e6-551f-4fe2-b673-33d0715086e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        #--------
        exit 1
    fi
    #------------------------------
    # If the "$?" were evaluated in this function, 
    # then it would be "0" even, if it is
    # something else at the calling code.
    if [ "$S_ERR_CODE" != "0" ];then
        echo ""
        echo "Something went wrong. Error code: $S_ERR_CODE"
        echo -e "\e[31mAborting script. \e[39m"
        echo "GUID=='1c09a6e5-f5a7-47c2-8a33-33d0715086e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        #--------
        exit 1
    fi
    #------------------------------
} # func_mmmv_assert_error_code_zero_t2

#--------------------------------------------------------------------------
func_main(){
    #------------------------------
    func_settings
    #------------------------------
    ufw reset 
    func_mmmv_assert_error_code_zero_t2 "$?" \
        "36d84862-f4b0-4e13-b133-33d0715086e7"
    #------------------------------
    ufw default deny incoming
    func_mmmv_assert_error_code_zero_t2 "$?" \
        "48d37802-f7f0-44d3-9123-33d0715086e7"
    #------------------------------
    ufw default allow outgoing
    func_mmmv_assert_error_code_zero_t2 "$?" \
        "051a7aa5-3416-4d60-b133-33d0715086e7"
    #------------------------------
    ufw allow from $S_IPv4_ADDRESS_THAT_IS_ALLOWED_TO_CONNECT_TO_ALL_PORTS
    func_mmmv_assert_error_code_zero_t2 "$?" \
        "17476af3-d4bb-4b19-bd43-33d0715086e7"
    #------------------------------
    # ufw deny  in 22
    # func_mmmv_assert_error_code_zero_t2 "$?" \
    #     "84afb00c-ac52-4304-9923-33d0715086e7"
    #------------------------------
    # ufw allow in 22
    # func_mmmv_assert_error_code_zero_t2 "$?" \
    #     "45867381-bbcd-4a94-b913-33d0715086e7"
    #------------------------------
    #------------------------------
} # func_main

func_main

#--------------------------------------------------------------------------
exit 0
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="14061152-cd1f-41f3-b443-33d0715086e7"
#==========================================================================
