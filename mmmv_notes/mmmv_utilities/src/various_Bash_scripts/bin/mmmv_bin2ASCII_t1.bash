#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# Script version: "04d4f213-b897-4735-8935-9180808185e7"
#
# Tested on ("uname -a")
# Linux linux-f26r 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux
#
#--------------------------------------------------------------------------
# The MIT license from the 
# http://www.opensource.org/licenses/mit-license.php
#
# Copyright (c) 2020, martin.vahi@softf1.com that has an
# Estonian personal identification code of 38108050020.
#
# Permission is hereby granted, free of charge, to 
# any person obtaining a copy of this software and 
# associated documentation files (the "Software"), 
# to deal in the Software without restriction, including 
# without limitation the rights to use, copy, modify, merge, publish, 
# distribute, sublicense, and/or sell copies of the Software, and 
# to permit persons to whom the Software is furnished to do so, 
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included 
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
# IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
# CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
# TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
# SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: MIT
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="63289de7-a12c-4115-8145-9180808185e7"
# Please do NOT change the following 3 lines, unless You know the whole script.
    #S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )" 
    S_FP_ORIG="`pwd`" 
    S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"

#-------------the--start--of--settings--block------------------------------
# The 
S_FP_BINARY_TO_BE_CONVERTED_2_ASCII="`pwd`/some_message_in_UTF8.txt" 
# is an input file and its path 
# can be overridden with the 2. command line argument.

# The
S_FP_ASCII="`pwd`/ascii.txt" 
# is one possible output file.

# The
S_FP_DECODED_FROM_ASCII="`pwd`/decoded_from_ascii.txt" 
# is one possible output file.

#-------------the--end----of--settings--block------------------------------
# Everything below this line is just the implementation.

func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_mmmv_wait_and_sync_t1

#--------------------------------------------------------------------------

func_assert_error_code_zero_t1(){
    local S_ERR_CODE=$1 # the "$?"
    local S_GUID_CANDIDATE=$2
    #--------
    # If the "$?" were evaluated in this function, 
    # then it would be "0" even, if it is
    # something else at the calling code.
    if [ "$S_ERR_CODE" != "0" ];then
        echo ""
        echo "Something went wrong. Error code: $S_ERR_CODE"
        echo "Aborting script."
        echo "GUID=='1de9f9a4-1be2-42d5-8c55-9180808185e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1
    fi
} # func_assert_error_code_zero_t1

#--------------------------------------------------------------------------

func_assert_file_exists_t1() {  # S_FP, S_GUID
    local S_FP="$1"
    local S_GUID="$2"
    #------------------------------
    if [ "$S_GUID" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters: S_FP, S_GUID"
        echo "GUID=='41712ad3-e75a-4cc5-9e55-9180808185e7'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #------------------------------
    if [ ! -e "$S_FP" ]; then
        if [ -h "$S_FP" ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symlink, but a file or "
            echo "a symlinkt to a file is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='54e3fe74-91fb-4171-a945-9180808185e7'"
            echo ""
            #----------------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            echo "The file "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='27d602f1-4f47-4578-8055-9180808185e7'"
            echo ""
            #----------------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    else
        if [ -d "$S_FP" ]; then
            echo ""
            if [ -h "$S_FP" ]; then
                echo "The symlink to the folder "
            else
                echo "The folder "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "exists, but a file or a symlink to a file is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='57a42231-0eec-4e4f-ad45-9180808185e7'"
            echo ""
            #----------------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
} # func_assert_file_exists_t1

#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of this Bash script is aborted."
        echo "GUID=='10a8be05-67da-48b7-be35-9180808185e7'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "uuencode" # differs from the next line
func_mmmv_exit_if_not_on_path_t2 "uudecode" 

#--------------------------------------------------------------------------

S_TMP_0="`pwd`/$S_TIMESTAMP"
S_TMP_1="_temporary.x"
S_FP_TMP="$S_TMP_0$S_TMP_1"

SB_CMDLINE_OPTION_INVALID="t" # valid values: "t", "f"

func_rm_all_old_output_files(){
    rm -f $S_FP_ASCII
    rm -f $S_FP_DECODED_FROM_ASCII
    rm -f $S_FP_TMP
} #func_rm_all_old_output_files 

S_ARGV_0="$1"
S_ARGV_1="$2"

#--------------------------------------------------------------------------
SB_CMD_DISPLAY_HELP_AND_EXIT="f" # valid values: "t", "f"
if [ "$S_ARGV_0" == "h" ]; then
    SB_CMD_DISPLAY_HELP_AND_EXIT="t"
fi
if [ "$S_ARGV_0" == "-h" ]; then
    SB_CMD_DISPLAY_HELP_AND_EXIT="t"
fi
if [ "$S_ARGV_0" == "help" ]; then
    SB_CMD_DISPLAY_HELP_AND_EXIT="t"
fi
if [ "$S_ARGV_0" == "--help" ]; then
    SB_CMD_DISPLAY_HELP_AND_EXIT="t"
fi
if [ "$S_ARGV_0" == "?" ]; then
    SB_CMD_DISPLAY_HELP_AND_EXIT="t"
fi
if [ "$S_ARGV_0" == "-?" ]; then
    SB_CMD_DISPLAY_HELP_AND_EXIT="t"
fi
if [ "$SB_CMD_DISPLAY_HELP_AND_EXIT" == "t" ]; then
    #SB_CMDLINE_OPTION_INVALID="f" # dead code here, but it's a comment
    echo ""
    echo "The default input file path that can be changed "
    echo "by modifying the script is: "
    echo ""
    echo -e "    \e[44m$S_FP_BINARY_TO_BE_CONVERTED_2_ASCII\e[49m"
    echo "" 
    echo "The current default values for the output file paths are:" 
    echo "" 
    echo "    $S_FP_ASCII"
    echo "    $S_FP_DECODED_FROM_ASCII"
    echo "" 
    echo "COMMAND_LINE_ARGUMENTS ::= CLEAR | ENCODE | DECODE | help "
    echo "" 
    echo "     CLEAR ::= c | clear                       # deletes output files "
    echo "    ENCODE ::= ENCODECMD (<input file path>)?  # creates the ASCII file "
    echo "    DECODE ::= DECODECMD (<input file path>)?  # decodes the ASCII file "
    echo "" 
    echo " ENCODECMD ::= enc | encode | e | bin2ascii | bin2ASCII "
    echo " DECODECMD ::= dec | decode | ascii2bin | ASCII2bin "
    echo ""
    #----------------
    cd "$S_FP_ORIG"
    exit 0
else
    if [ "$SB_CMD_DISPLAY_HELP_AND_EXIT" != "f" ]; then
        echo ""
        echo "This code is flawed."
        echo "GUID=='85fa6763-5ebe-44c5-a955-9180808185e7'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1
    fi
fi

#--------------------------------------------------------------------------
SB_CMD_CLEAR="f" # valid values: "t", "f"
if [ "$S_ARGV_0" == "c" ]; then
    SB_CMD_CLEAR="t"
fi
if [ "$S_ARGV_0" == "clear" ]; then
    SB_CMD_CLEAR="t"
fi
if [ "$S_ARGV_0" == "cl" ]; then
    SB_CMD_CLEAR="t"
fi
if [ "$SB_CMD_CLEAR" == "t" ]; then
    #SB_CMDLINE_OPTION_INVALID="f" # dead code here, but it's a comment
    func_rm_all_old_output_files
    func_mmmv_wait_and_sync_t1
    #----------------
    cd "$S_FP_ORIG"
    exit 0
else
    if [ "$SB_CMD_CLEAR" != "f" ]; then
        echo ""
        echo "This code is flawed."
        echo "GUID=='c2512929-80ae-4962-9835-9180808185e7'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1
    fi
fi

#--------------------------------------------------------------------------
SB_CMD_ENCODE="f" # valid values: "t", "f"
if [ "$S_ARGV_0" == "enc" ]; then
    SB_CMD_ENCODE="t"
fi
if [ "$S_ARGV_0" == "encode" ]; then
    SB_CMD_ENCODE="t"
fi
if [ "$S_ARGV_0" == "e" ]; then
    SB_CMD_ENCODE="t"
fi
if [ "$S_ARGV_0" == "bin2ascii" ]; then
    SB_CMD_ENCODE="t"
fi
if [ "$S_ARGV_0" == "bin2ASCII" ]; then
    SB_CMD_ENCODE="t"
fi
if [ "$SB_CMD_ENCODE" == "t" ]; then
    SB_CMDLINE_OPTION_INVALID="f"
    func_rm_all_old_output_files
    if [ "$S_ARGV_1" != "" ]; then
        func_assert_file_exists_t1 "$S_ARGV_1" "4c5cca42-02f3-4516-ba35-9180808185e7"
        S_FP_BINARY_TO_BE_CONVERTED_2_ASCII="$S_ARGV_1"
    fi
    #----------------------------------------------------------------------
    # https://en.wikipedia.org/wiki/Base64
    # https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/Base64_encoding_and_decoding
    uuencode -m "$S_FP_TMP" < "$S_FP_BINARY_TO_BE_CONVERTED_2_ASCII" > "$S_FP_ASCII"
    func_assert_error_code_zero_t1 "$?" "154b1db6-b47c-44e3-8035-9180808185e7"
    #----------------------------------------------------------------------
    func_mmmv_wait_and_sync_t1
else
    if [ "$SB_CMD_ENCODE" != "f" ]; then
        echo ""
        echo "This code is flawed."
        echo "GUID=='4d7d9657-c1cb-4078-9545-9180808185e7'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1
    fi
fi
#--------------------------------------------------------------------------
SB_CMD_DECODE="f" # valid values: "t", "f"
if [ "$S_ARGV_0" == "dec" ]; then
    SB_CMD_DECODE="t"
fi
if [ "$S_ARGV_0" == "DEC" ]; then # just for fun,"Digital Equipment Corporation"
    SB_CMD_DECODE="t"
fi
if [ "$S_ARGV_0" == "decode" ]; then
    SB_CMD_DECODE="t"
fi
if [ "$S_ARGV_0" == "ascii2bin" ]; then
    SB_CMD_DECODE="t"
fi
if [ "$S_ARGV_0" == "ASCII2bin" ]; then
    SB_CMD_DECODE="t"
fi
if [ "$S_ARGV_0" == "ASCII2BIN" ]; then
    SB_CMD_DECODE="t"
fi
if [ "$SB_CMD_DECODE" == "t" ]; then
    SB_CMDLINE_OPTION_INVALID="f"
    #----------------------------------
    # func_rm_all_old_output_files  would delete the S_FP_ASCII
    rm -f $S_FP_DECODED_FROM_ASCII
    rm -f $S_FP_TMP
    #----------------------------------
    if [ "$S_ARGV_1" != "" ]; then
        func_assert_file_exists_t1 "$S_ARGV_1" "5ba27f04-4df4-4c85-b215-9180808185e7"
        S_FP_ASCII="$S_ARGV_1"
    fi
    #----------------------------------------------------------------------
    uudecode -o "$S_FP_DECODED_FROM_ASCII"  "$S_FP_ASCII"
    func_assert_error_code_zero_t1 "$?" "fc02bd62-0991-4734-b425-9180808185e7"
    #----------------------------------------------------------------------
    func_mmmv_wait_and_sync_t1
else
    if [ "$SB_CMD_DECODE" != "f" ]; then
        echo ""
        echo "This code is flawed."
        echo "GUID=='4cc55742-a765-40da-8e35-9180808185e7'"
        echo ""
        #----------------
        cd "$S_FP_ORIG"
        exit 1
    fi
fi

if [ "$SB_CMDLINE_OPTION_INVALID" != "f" ]; then
    echo ""
    echo "Wrong command line argument. Valid values are: c, enc, dec, help ."
    echo "GUID=='5d1c38c4-4ebd-4043-a535-9180808185e7'"
    echo ""
    #----------------
    cd "$S_FP_ORIG"
    exit 1
fi 

#--------------------------------------------------------------------------
rm -f $S_FP_TMP
cd "$S_FP_ORIG"
exit 0 
#==========================================================================

