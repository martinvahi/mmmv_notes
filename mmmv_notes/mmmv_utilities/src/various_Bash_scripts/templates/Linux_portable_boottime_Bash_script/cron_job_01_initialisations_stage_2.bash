#!/bin/bash
#==========================================================================
# The "#!/usr/bin/env bash" would also work at the first line, but
# as this script is run by root, then it is probably 
# safer to use a direct path.
#--------------------------------------------------------------------------
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
# Relevant commands: lsblk, blkid

S_TMP_0="/sys/block/sda/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdb/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdc/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdd/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sde/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdf/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdg/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdh/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdi/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

S_TMP_0="/sys/block/sdj/queue/scheduler"
if [ -e "$S_TMP_0" ]; then
    echo "deadline" > $S_TMP_0
fi

sync ; wait; sync
#--------------------------------------------------------------------------
#nice -n 20 /usr/sbin/nilfs-clean /dev/midagi
nice -n 6 /usr/sbin/nilfs-clean /dev/sdc1
nice -n 6 /usr/sbin/nilfs-clean /dev/sdd1
sync ; wait; sync
#--------------------
sleep 10
sync ; wait; sync
#--------------------
S_TMP_0="`/usr/bin/uname -a | /usr/bin/grep -i Linux `"
if [ "$S_TMP_0" != "" ]; then
    /usr/bin/ps -A | /usr/bin/grep nilfs_cleanerd | \
        /usr/bin/gawk '{print $1}' | /usr/bin/xargs /usr/bin/renice -n 19 -p
fi
sync ; wait; sync
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="e990fe31-fa11-492a-923c-e071d01166e7"
#==========================================================================
