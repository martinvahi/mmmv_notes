#!/bin/bash 
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

===========================================================================

 Working directory verifications are not necessary here, because
 if the ../bonnet did not exist, the ../create_backup.bash would
 throw an exception, etc. 

 The I_NUMBER_OF_BACKUP_VERSIONS is 
 initiated within the ./../creat_backup.bash 

txt1
)#-------------------------------------------------------------------------


PERIOD_MINUS_ONE=$((I_NUMBER_OF_BACKUP_VERSIONS-1))

S_BACKUP_FOLDER_NAME_PREFIX="backup_v_"
S_BACKUP_FOLDER_FULL_PATH_PREFIX="`pwd`/backups/$S_BACKUP_FOLDER_NAME_PREFIX"

for i in `seq 0 $PERIOD_MINUS_ONE`; do 
    mkdir -p $S_BACKUP_FOLDER_FULL_PATH_PREFIX$i
done

BACKUP_COPY_NUMBER=`ruby -Ku ./bonnet/folder_selector.rb $PERIOD_MINUS_ONE`
S_FULL_PATH_TO_THE_BACKUP_FOLDER="$S_BACKUP_FOLDER_FULL_PATH_PREFIX$BACKUP_COPY_NUMBER"

echo ""
echo ""
echo "The backup copy will be placed to folder: $S_BACKUP_FOLDER_NAME_PREFIX$BACKUP_COPY_NUMBER"
echo ""
echo ""
# sleep 5s

#==========================================================================

