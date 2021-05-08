#!/usr/bin/env bash
#==========================================================================
# Initial author of this script: Martin.Vahi@softf1.com
# This script is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
#  The_editable_part of this script is marked with the search string
# "The_editable_part".
#
# This script is a dirty, unreliable, hack to cope with 
# a situation, where during the copying of a large amount 
# of small files from one hard disk to another the destination
# hard disk fails to allocate space for the new files
# "fast enough" and gives an IO-error. A cleaner version would be
# to integrate the pausing idea of this script to a recursive
# copying tool. 
#
# There are only 2 types of hard disks: 
# burned through electronic junk and hard disks that are gradually 
# becoming the burned through electronic junk. The ones that
# are on their way for becoming the junk, internally keep track of 
# unusable regions, burned thorough Flash cells, "bad sectors", etc.
# That accountancy takes time and if there are a lot of files to 
# be written at high speed, the hardware buffer at the HDD might
# get full, because the allocation software/firmware at the HDD 
# is not able to complete its job fast enough 
# to allocate space for the new data or because
# the physical writing from the HDD buffer to the magnetic disk 
# takes "too long". Hence the IO-error. If the copying is paused, then the
# allocation software can probabilistically complete its job and 
# the HDD buffer can be probabilistically emptied to a "sufficiently empty"
# level to allow further writing take place without IO-errors.
#
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
#S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FN_SCRIPTFILE="`basename $0`"
S_FP_SCRIPTFILE="$S_FP_DIR/$S_FN_SCRIPTFILE"
#S_SCRIPT_VERSION="497a7a55-bd5e-4065-b372-614371f152e7"

#--------------------------------------------------------------------------
S_FP_SOURCE="/this/path/needs/to/be/updated"

func_mmmv_cp_hack_t1(){
    local S_FN_0="$1"
    if [ "$S_FP_SOURCE" == "/this/path/needs/to/be/updated" ]; then
        echo ""
        echo "The value of the S_FP_SOURCE in the "
        echo ""
        echo "    $S_FP_SCRIPTFILE"
        echo ""
        echo "has not been updated. Aborting script."
        echo "GUID=='cbdfad47-afa7-4713-b572-614371f152e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1
    fi
    #--------
    local S_FP_SRC="$S_FP_SOURCE/$S_FN_0"
    local S_FP_DESTINATION="$S_FP_DIR/$S_FN_0"
    local S_TMP_0=""
    if [ ! -e "$S_FP_SRC" ]; then
        echo ""
        echo "The file or a folder with the path of "
        echo ""
        echo "    $S_FP_SRC"
        echo ""
        echo "does not exist. Aborting script."
        echo "GUID=='2af3b344-6ba5-4325-b272-614371f152e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1
    fi
    if [ -e "$S_FP_DESTINATION" ]; then
        echo ""
        echo "The file or a folder with the path of "
        echo ""
        echo "    $S_FP_DESTINATION"
        echo ""
        echo "already exists. Aborting script."
        echo "GUID=='14035f19-31bd-4bca-9472-614371f152e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1
    fi
    #--------
    if [ -d "$S_FP_DESTINATION" ]; then
        echo "Copying a folder named '$S_FN_0' ..."
    else
        echo "Copying a file named '$S_FN_0' ..."
    fi
    nice -n17 cp -f -R $S_FP_SRC $S_FP_DIR/
    S_TMP_0="$?"
    if [ "$S_TMP_0" != "0" ]; then 
        echo ""
        echo "The cp command exited with an error code $S_TMP_0."
        echo "Aborting script."
        echo "GUID=='b5a54b48-6c3b-4f08-b572-614371f152e7'"
        echo ""
        cd $S_FP_ORIG
        exit $S_TMP_0
    fi
    sleep 5
    sync
    sleep 2
    if [ ! -e "$S_FP_DESTINATION" ]; then
        echo ""
        echo "The creation of a file or a folder with the path of "
        echo ""
        echo "    $S_FP_DESTINATION"
        echo ""
        echo "failed. Aborting script."
        echo "GUID=='4c35b52d-b9da-4d8b-b572-614371f152e7'"
        echo ""
        cd $S_FP_ORIG
        exit 1
    fi
} # func_mmmv_cp_hack_t1 

#--------------------------------------------------------------------------
# The_editable_part:

S_FP_SOURCE="/this/path/needs/to/be/updated"

func_mmmv_cp_hack_t1 "buran_ru"

#--------------------------------------------------------------------------
cd $S_FP_ORIG
exit 0
#==========================================================================
