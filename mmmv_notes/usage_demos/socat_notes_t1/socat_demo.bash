#!/usr/bin/env bash 
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
# S_VERSION_OF_THIS_FILE="5f94b025-413d-411e-84fc-0342706195e7"
#
# socat home page:
#     http://www.dest-unreach.org/socat/download/
# socat tutorial:
#     https://www.cyberciti.biz/faq/linux-unix-tcp-port-forwarding/
#     archival copy: https://archive.vn/71LZc
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
#--------------------------------------------------------------------------

#--------------------------------------------------------------------------
#:::::::::::::::::::start::of:::boilerplate::::::::::::::::::::::::::::::::
#--------------------------------------------------------------------------

func_mmmv_select_text_processing_mode_t1(){
    if [ "$S_MMMV_TEXT_PROCESSING_MODE" == "" ]; then
    #------------------------------
        # The BSD sed differs from the GNU sed.
        # As of 2021 the GNU sed is the default sed on Linux.
        # If the GNU sed is not available, then in the context
        # of this Bash function the fallback option is ruby 
        # which is portable, but slow due to the slow startup 
        # of the Ruby interpreter. As of 2021 the Ruby
        # interpreter takes about 40MiB of RAM and allocating
        # 40MiB in C/C++ is a slow operation even without
        # any other initializations.
        #------------------------------
        # Initialization of the global variables:
        S_MMMV_TEXT_PROCESSING_MODE="text_processing_mode_ruby" # default fallback for BSD
        S_MMMV_SED_CMD="echo \"GUID=='b0a5f85a-ce36-45a5-82fc-0342706195e7'\"; exit 1 ; "
        #------------------------------
        if [ "`which sed 2> /dev/null`" != "" ]; then
            S_MMMV_SED_CMD="sed"  # it might be the BSD sed or the GNU sed
        fi
        if [ "`which GNU_sed 2> /dev/null`" != "" ]; then
            S_MMMV_SED_CMD="GNU_sed" # should be the GNU sed, but in some 
                                     # flawed case it might be something else.
        fi
        if [ "`$S_MMMV_SED_CMD --help 2> /dev/null | grep -i gnu`" == "" ]; then # line tested on Linux and FreeBSD
            # This if-clause covers also the case, where 
            # the GNU_sed on the PATH is actually not the GNU sed.
            if [ "$S_MMMV_SED_CMD" == "GNU_sed" ]; then
                echo ""
                echo -e "\e[31mThe PATH content is flawed.\e[39m"
                echo -e "\e[31mThe \"GNU_sed\" is not a GNU sed binary.\e[39m"
                echo "Aborting script."
                echo "GUID=='5101ba16-33b0-4097-85fc-0342706195e7'"
                echo ""
                #--------
                cd "$S_FP_ORIG"
                exit 1 # exiting with an error
            # else
            #     # The sed is some non-GNU-sed, probably 
            #     # the BSD sed, which is a valid case, not an error case.
            fi
        else
            S_MMMV_TEXT_PROCESSING_MODE="text_processing_mode_GNU_sed"
            # independent of whether the S_MMMV_SED_CMD is "sed" or "GNU_sed".
        fi
    #------------------------------
    fi
} # func_mmmv_select_text_processing_mode_t1

#--------------------------------------------------------------------------

func_mmmv_IPv4_domain_2_IPv4_address_t1(){
    local S_DOMAIN_CANDIDATE="$1"
    local S_GUID_CANDIDATE="$2"
    #------------------------------
    # Dependencies: resolveip, grep, (ruby|GNU sed)
    # Assigns to a global variable: S_MMMV_IPv4
    #------------------------------
    local SB_LACK_OF_PARAMETERS="f"
    if [ "$S_DOMAIN_CANDIDATE" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        SB_LACK_OF_PARAMETERS="t"
    fi
    if [ "$SB_LACK_OF_PARAMETERS" == "t" ]; then
        echo ""
        echo -e "\e[31mThe code that calls this function is flawed.\e[39m"
        echo "This function requires 2 parameters, which are "
        echo "S_DOMAIN_CANDIDATE, S_GUID_CANDIDATE ."
        if [ "$S_GUID_CANDIDATE" != "" ]; then
            echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        fi
        echo "GUID=='b0bd1955-3679-4e87-a4fc-0342706195e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    else
        if [ "$SB_LACK_OF_PARAMETERS" != "f" ]; then
            echo -e "\e[31mThis code is flawed.\e[39m"
            echo "GUID=='11551e24-cad1-4711-81fc-0342706195e7'"
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
    #------------------------------
    local S_RESOLVEIP_OUTPUT_WITH_IPv4="`resolveip $S_DOMAIN_CANDIDATE | grep -E '([0123456789]+[.]){3}[0123456789]+'`"
    if [ "$S_RESOLVEIP_OUTPUT_WITH_IPv4" == "" ]; then
            echo ""
            echo -e "\e[31mThe code that calls this function is probably flawed.\e[39m"
            echo ""
            echo "    S_DOMAIN_CANDIDATE==\"$S_DOMAIN_CANDIDATE\""
            echo ""
            echo "GUID=='341e0211-3457-42ad-b2fc-0342706195e7'"
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
    fi
    #------------------------------
    func_mmmv_select_text_processing_mode_t1
    S_MMMV_IPv4="subject_to_initialization:'50092e49-7b57-403f-b2fc-0342706195e7'"
    if [ "$S_MMMV_TEXT_PROCESSING_MODE" == "text_processing_mode_GNU_sed" ]; then
        # Test line:
        # time echo "IP address of archive.org is 207.241.224.2 7 " | grep -E '([0123456789]+[.]){3}[0123456789]+' | sed -e 's/[[:space:]][[:digit:]][[:space:]]//g' | sed -e 's/[[:alpha:]]//g' | sed -e 's/\([[:blank:]]\.\)\|\(\.[[:blank:]]\)//g' | sed -e 's/[[:blank:]]\+//g'
        S_MMMV_IPv4="`echo \"$S_RESOLVEIP_OUTPUT_WITH_IPv4\" | $S_MMMV_SED_CMD -e 's/[[:space:]][[:digit:]][[:space:]]//g' | $S_MMMV_SED_CMD -e 's/[[:alpha:]]//g' | $S_MMMV_SED_CMD -e 's/\\([[:blank:]]\\.\\)\\|\\(\\.[[:blank:]]\\)//g' | $S_MMMV_SED_CMD -e 's/[[:blank:]]\\+//g'`"
    else # the default, which is ruby based 
        # The test line:
        # time echo "IP address of archive.org is 207.241.224.2 7 " | grep -E '([0123456789]+[.]){3}[0123456789]+' | ruby -e 's_in=gets; md=s_in.match(/([\d]+[.]){3}[\d]+/  ); s_0=md[0]; printf(s_0)'
        S_MMMV_IPv4="`echo \"$S_RESOLVEIP_OUTPUT_WITH_IPv4\" | ruby -e 's_in=gets; md=s_in.match(/([\d]+[.]){3}[\d]+/); s_0=md[0]; printf(s_0)'`"

    fi
    #------------------------------
} # func_mmmv_IPv4_domain_2_IPv4_address_t1

#--------------------------------------------------------------------------
#:::::::::::::::::::::end::of:::boilerplate::::::::::::::::::::::::::::::::
#--------------------------------------------------------------------------


#func_mmmv_IPv4_domain_2_IPv4_address_t1 "homebrewcpu.com" \
func_mmmv_IPv4_domain_2_IPv4_address_t1 "dunkels.com" \
    "a23b8c3c-38b0-4d94-91fc-0342706195e7"
S_WEB_SERVER_IP="$S_MMMV_IPv4"
S_WEB_SERVER_PORT="80"

#S_WEB_SERVER_IP="192.168.30.41"
#S_WEB_SERVER_PORT="20070"

S_QUERY_INPUT_IP="127.0.0.1"
S_QUERY_INPUT_PORT="9180"

func_socat_demo_1(){
    # Binds to the public IP address of the local machine:
    nice -n 5 socat TCP-LISTEN:$S_QUERY_INPUT_PORT,fork TCP:$S_WEB_SERVER_IP:$S_WEB_SERVER_PORT
} # func_socat_demo_1

func_socat_demo_2(){
    # Origin of the idea:
    #     https://stackoverflow.com/questions/57299019/make-socat-open-port-only-on-localhost-interface
    #     archival copy: https://archive.vn/lv86j
    nice -n 5 socat -v TCP-LISTEN:$S_QUERY_INPUT_PORT,fork,bind=$S_QUERY_INPUT_IP TCP:$S_WEB_SERVER_IP:$S_WEB_SERVER_PORT
} # func_socat_demo_2

#func_socat_demo_1

ps -A | grep socat
func_socat_demo_2 # At tests done with this script the 
                  # error condition with the text,
                  # " E bind(5, {AF=2 127.0.0.1:9180}, 16): Address already in use",
                  # disappeared automatically in about 15s
                  # after all socat processes were killed.

#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0
#==========================================================================

