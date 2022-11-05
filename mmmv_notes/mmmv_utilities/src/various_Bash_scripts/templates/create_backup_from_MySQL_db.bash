#!/usr/bin/env bash 
XXX=$(cat<< 'txt1' #=======================================================

 The MIT license from the 
 http://www.opensource.org/licenses/mit-license.php

 Copyright (c) 2013, martin.vahi@softf1.com that has an
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

txt1
)#=========================================================================
# Engine start:

S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_STORAGE_FOLDER="$S_FP_DIR/`date +%Y`_`date +%m`_`date +%d`"

S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_`date +%H`:`date +%M`:`date +%S`"
S_FP_prefix="`echo $S_TIMESTAMP`_"

func_dump_MySQL() {
    mkdir -p "$S_FP_STORAGE_FOLDER"
    S_FP_DUMP_IMAGE="$S_FP_STORAGE_FOLDER/`echo $S_FP_prefix`MySQL_dump_`echo $S_DATABASENAME`.sql"
    nice -n5 mysqldump -u $S_USERNAME -p$S_PASSWORD $S_DATABASENAME > $S_FP_DUMP_IMAGE 
} # fun_tere

#-------------------------- Engine end ------------------------------------

S_DATABASENAME="tiger_database"
S_USERNAME="purr"
S_PASSWORD="a_nice_password"
func_dump_MySQL;

S_DATABASENAME="whale_database"
S_USERNAME="iiiiiiirssss"
S_PASSWORD="another_password"
func_dump_MySQL;

# etc.

