#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#S_VERSION="ac4be64b-96e0-4b41-9572-f2b36091a1e7"

S_FP_ORIGIN_FOLDER="$S_FP_DIR/orig"
S_FP_DESTINATION_FOLDER="$S_FP_DIR/dest"

if [ "$1" == "reset" ]; then
    rm -fr $S_FP_ORIGIN_FOLDER
    rm -fr $S_FP_DESTINATION_FOLDER
    sync
    ls
    exit 0
fi

if [ ! -e $S_FP_ORIGIN_FOLDER ]; then
    mkdir -p $S_FP_ORIGIN_FOLDER
    mkdir -p $S_FP_DESTINATION_FOLDER
    sync # to dump it to disk
    echo "Content of the test file." > $S_FP_ORIGIN_FOLDER/x1.txt
    sync
fi

echo "---------------------------------------------------------------------"

if [ "`ls $S_FP_ORIGIN_FOLDER/`" != "" ]; then # works on both, BSD and Linux
    echo "files present"
    # The "mv -f <path to an empty folder>/* foo/" gives an error. 
    # Only non-empty folder content can be moved with the "mv" command.
    mv $S_FP_ORIGIN_FOLDER/* $S_FP_DESTINATION_FOLDER/
    sync
else
    echo "the empty void"
fi

echo "---------------------------------------------------------------------"
echo "demo script folder:"
ls
echo "---------------------------------------------------------------------"
echo "$S_FP_ORIGIN_FOLDER:"
ls $S_FP_ORIGIN_FOLDER
echo "---------------------------------------------------------------------"
echo "$S_FP_DESTINATION_FOLDER:"
ls $S_FP_DESTINATION_FOLDER
echo "---------------------------------------------------------------------"
exit 0

