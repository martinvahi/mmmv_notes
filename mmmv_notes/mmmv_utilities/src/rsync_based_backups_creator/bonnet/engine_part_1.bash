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

===========================================================================

 Working directory verifications are not necessary here, because
 if the ../bonnet did not exist, the ../create_backup.bash would
 throw an exception, etc. 

 The I_NUMBER_OF_BACKUP_VERSIONS is 
 initiated within the ./../creat_backup.bash 

txt1
)#-------------------------------------------------------------------------

fun_assert_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE=$1 # first function argument
    local S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE\" "
        echo "to be on the PATH, but it is missing from the PATH."
        echo "GUID=='336fe3e1-0454-4a53-9251-d1e0809152e7'"
        echo ""
        exit 1 # exit with error
    fi
} # fun_assert_exists_on_path_t1

fun_assert_exists_on_path_t1 "ruby"
#fun_assert_exists_on_path_t1 "grep"
fun_assert_exists_on_path_t1 "rsync"
fun_assert_exists_on_path_t1 "nice"

#-------------------------------------------------------------------------
PERIOD_MINUS_ONE=$((I_NUMBER_OF_BACKUP_VERSIONS-1))

S_BACKUP_FOLDER_NAME_PREFIX="backup_v_"
S_BACKUP_FOLDER_FULL_PATH_PREFIX="`pwd`/backups/$S_BACKUP_FOLDER_NAME_PREFIX"

for i in `seq 0 $PERIOD_MINUS_ONE`; do 
    mkdir -p $S_BACKUP_FOLDER_FULL_PATH_PREFIX$i
done

BACKUP_COPY_NUMBER=`ruby ./bonnet/folder_selector.rb $PERIOD_MINUS_ONE`
S_FULL_PATH_TO_THE_BACKUP_FOLDER="$S_BACKUP_FOLDER_FULL_PATH_PREFIX$BACKUP_COPY_NUMBER"

echo ""
echo ""
echo "The backup copy will be placed to folder: $S_BACKUP_FOLDER_NAME_PREFIX$BACKUP_COPY_NUMBER"
echo ""
echo ""
sync # For network drives and USB drives.
# sleep 5s

#--------------------------------------------------------------------------
S_RSYNC_SKIP_COMPRESS_ARG=" --skip-compress=jpg/jpeg/jp2/j2k/jpf/jpx/jpm/mj2/mp[34]/m4p/m4v/mpg/mpeg/m2v/svi/3gp/3g2/amv/7z/s7z/z/rar/rk/bz2/mar/zz/xz/lz/lzma/lha/lzh/lzx/tar/gz/tgz/tbz2/tlz/txz/taz/tz/tzma/lzo/rz/rzip/lrzip/sfark/sz/alz/apk/arc/b1/b6z/paq6/paq7/pit/shk/sit/sitx/sqx/zoo/zpaq/xar/kgb/jar/zip/zipx/arj/stblob/webm/ogg/ogv/spx/mov/qt/avi/mts/m2ts/wmv/rm/rmvb/flv/f4v/f4p/f4a/f4b/swf/mkv/vob/mng/msi/pkg/iso/img/deb/rpm/dvd/dmg/ova/vdi/vmdk/vhd "
# The S_RSYNC_SKIP_COMPRESS_ARG makes more sense,
# when the rsync logs in to some remote computer, which it
# does not do at this script, but this script here 
# is a nice place for storing the list of 
# file extensions of files that probably can not be compressed
# "that much" and this file also serves as a test case 
# for the syntax of the list of file extensions.
S_RSYNC_COMMAND_PREFIX="nice -n15 rsync -avz $S_RSYNC_SKIP_COMPRESS_ARG --delete "

$S_RSYNC_COMMAND_PREFIX \
    $S_FP_FULL_PATH_2_A_FOLDER_OR_A_FILE_THAT_WILL_BE_BACKED_UP \
    $S_FULL_PATH_TO_THE_BACKUP_FOLDER
S_TMP_0="$?"
if [ "$S_TMP_0" != "0" ]; then
    echo ""
    echo "The program rsync exited with an error code of $S_TMP_0."
    echo "GUID='e6639832-c84b-45df-b931-d1e0809152e7'"
    echo ""
    exit $S_TMP_0
fi
sync # Motivated by the use of external USB drives/sticks.
exit 0
#==========================================================================

