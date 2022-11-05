#!/usr/bin/env bash 
XXX=$(cat<< 'txt1' #=======================================================
 
 The MIT license from the 
 http://www.opensource.org/licenses/mit-license.php

 Copyright (c) 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 Permission is hereby granted, free of charge, to 
 any person obtaining a copy of this software and 
 associated documentation files (the "Software"), 
 to deal in the Software without restriction, including 
 without limitation the rights to use, copy, modify, merge, publish, 
 distribute, sublicense, and/or sell copies of the Software, and 
 to permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included 
 in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 The following line is a spdx.org license label line:
 SPDX-License-Identifier: MIT

txt1
)#=========================================================================

COMMAND=$1
GREPARGS=$2

S_RUBYSCRIPT_1="s1=\"$0\";s2=s1.reverse.sub(/[\\/].*/,\"\").reverse"
S_SCRIPTFILE_NAME="`ruby -Ku -e \"$S_RUBYSCRIPT_1;print(s2)\"`"

S_COMMAND_FORMAT_INTRO="

Command semi-examples:
        $S_SCRIPTFILE_NAME kill  <grepargs_as_a_single_string>
        $S_SCRIPTFILE_NAME ls   [<grepargs_as_a_single_string>]

" # end of S_COMMAND_FORMAT_INTRO value

#The next 2 lines are a reminder of a common, line-breaks related, pitfall.
# echo  $S_COMMAND_FORMAT_INTRO   # doublequotes missing
# echo "$S_COMMAND_FORMAT_INTRO"  # doublequotes present

S_RUBYSCRIPT_2="$S_RUBYSCRIPT_1;print(s1[0..(-1-s2.length)])"
S_SCRIPTFILE_PARENT_PATH="`ruby -Ku -e \"$S_RUBYSCRIPT_2\"`"

#--------------------------------------------------------------------------
# command ls

if [ "$COMMAND" == "ls" ]; then
if [ "$GREPARGS" == "" ]; then
        ps -A 
else
        ps -A | grep $GREPARGS
fi
        exit;
fi

#--------------------------------------------------------------------------
# command kill

if [ "$COMMAND" == "kill" ]; then
if [ "$GREPARGS" == "" ]; then
        S_CMD_EXAMPLE="

        Command example:
                $S_SCRIPTFILE_NAME kill <grepargs_as_a_single_string>

        " # end of S_CMD_EXAMPLE

        echo "$S_CMD_EXAMPLE"
        exit;
else
        ps -A | grep $GREPARGS | ruby -Ku $S_SCRIPTFILE_PARENT_PATH/bonnet/mmmv_process_editor_process_killer.rb
        exit;
fi
fi

#--------------------------------------------------------------------------
# If we're here, then none of the command branches caught the control flow.

echo "$S_COMMAND_FORMAT_INTRO"
#--------------------------------------------------------------------------

