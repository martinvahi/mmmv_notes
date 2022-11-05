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

---------------------------------------------------------------------------
It is possible to load the subroutines of this file to other 
Bash scripts by adding the following 2 lines to the Bash scripts:

source <absolute path to this file>

txt1
)#=========================================================================

X1=""

#--------------------------------------------------------------------------

function mmmv_utilities_s_timestamp_t1 {
    S_TIMESTAMP_T1_YEAR="`date +%Y`"
    S_TIMESTAMP_T1_MONTH="`date +%m`"
    S_TIMESTAMP_T1_DAY="`date +%d`"
    S_TIMESTAMP_T1_HOUR="`date +%H`"
    S_TIMESTAMP_T1_MINUTE="`date +%M`"
    S_TIMESTAMP_T1_SECOND="`date +%S`"
    S_TIMESTAMP_T1_NANOSECOND="`date +%N`"

    S_TIMESTAMP_T1_X1="$S_TIMESTAMP_T1_YEAR"
    S_TIMESTAMP_T1_X2="_$S_TIMESTAMP_T1_MONTH"
    S_TIMESTAMP_T1_X3="_$S_TIMESTAMP_T1_DAY"
    S_TIMESTAMP_T1_X4="$S_TIMESTAMP_T1_X1$S_TIMESTAMP_T1_X2$S_TIMESTAMP_T1_X3"

    S_TIMESTAMP_T1_X5="_$S_TIMESTAMP_T1_HOUR"
    S_TIMESTAMP_T1_X6="_$S_TIMESTAMP_T1_MINUTE"
    S_TIMESTAMP_T1_X7="_$S_TIMESTAMP_T1_SECOND"
    S_TIMESTAMP_T1_X8="_$S_TIMESTAMP_T1_NANOSECOND"
    S_TIMESTAMP_T1_X9="$S_TIMESTAMP_T1_X5$S_TIMESTAMP_T1_X6$S_TIMESTAMP_T1_X7$S_TIMESTAMP_T1_X8"

    S_TIMESTAMP_T1_X10="_"

    X1="$S_TIMESTAMP_T1_X4$S_TIMESTAMP_T1_X9$S_TIMESTAMP_T1_X10"
} # mmmv_utilities_s_timestamp_t1 


#--------------------------------------------------------------------------

function mmmv_utilities_id_generation_demo {
    mmmv_utilities_s_timestamp_t1
    echo "$X1"
} # mmmv_utilities_id_generation_demo 

# mmmv_utilities_id_generation_demo 


#==========================================================================


