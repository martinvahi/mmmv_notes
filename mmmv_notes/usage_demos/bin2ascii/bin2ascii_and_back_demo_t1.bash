#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# 
# Tested on ("uname -a")
# Linux linux-f26r 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux
# 
# Script version: "a10f9fd6-329e-4399-b0b9-c272203024e7"
#--------------------------------------------------------------------------

# Boilerplate.
func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of this Bash script is aborted."
        echo "GUID=='1f2d6553-4756-43aa-a139-c272203024e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2
func_mmmv_exit_if_not_on_path_t2 "uuencode" # boilerplate
func_mmmv_exit_if_not_on_path_t2 "uudecode" # boilerplate

#---------------the--real--demo--starts--here------------------------------

S_FP_TXT_0="`pwd`/subject_to_enoding.txt"
S_FP_ASCII="`pwd`/encoded_2_ascii.txt"
S_FP_TXT_1="`pwd`/decoded_from_ascii.txt"
S_FP_TMP="`pwd`/temporary.x"

echo "Tere päev! Demoteksti rida 1" >  "$S_FP_TXT_0"
echo "Demoteksti rida 2"            >> "$S_FP_TXT_0"
echo "Demoteksti rida 3"            >> "$S_FP_TXT_0"

    echo ""
    echo -e "\e[34m==============================================="
    echo -e "\e[39m----subject--to--encoding--citation--start---"
    cat "$S_FP_TXT_0"
    echo "----subject--to--encoding--citation--end-----"

# https://en.wikipedia.org/wiki/Base64
# https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/Base64_encoding_and_decoding
uuencode -m "$S_FP_TMP" < "$S_FP_TXT_0" > "$S_FP_ASCII"
    echo ""
    echo -e "\e[32m---------ASCII--citation--start--------------"
    cat "$S_FP_ASCII"
    echo "---------ASCII--citation--end----------------"

    if [ -e "$S_FP_TMP" ]; then
        echo -e "\e[39m" # resets colors and adds a newline
        echo "----temporary--file--citation--start---------"
        cat "$S_FP_TMP"
        echo "----temporary--file--citation--end-----------"
    fi

uudecode -o "$S_FP_TXT_1"  "$S_FP_ASCII"
    echo -e "\e[39m" # resets colors and adds a newline
    echo "----decoded----file--citation--start---------"
    cat "$S_FP_TXT_1"
    echo "----decoded----file--citation--end-----------"
    echo -e "\e[34m==============================================="
    echo -e "\e[39m" # resets colors and adds a newline

rm -f "$S_FP_TXT_0"
rm -f "$S_FP_ASCII"
rm -f "$S_FP_TXT_1"
rm -f "$S_FP_TMP"
exit 0 # dirty, but proper code would clutter this script even more
#==========================================================================

