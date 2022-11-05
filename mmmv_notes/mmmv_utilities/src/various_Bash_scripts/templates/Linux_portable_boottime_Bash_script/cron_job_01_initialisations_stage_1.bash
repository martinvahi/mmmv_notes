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
# Bash lines that might come handy:
# 
#     mount -t tmpfs -o size=1m RAM_1MiB_01 /opt/andmekettad/RAM_1MiB_01
#     sync; wait ; 
#     chmod -f -R 1777 /opt/andmekettad/RAM_1MiB_01
# 
# A line for /etc/fstab
# 
#     tmpfs   /opt/andmekettad/RAM_1MiB_01  tmpfs   nodev,size=1M 0 0 
# 
# The command for adding a new cron job for user root: 
# 
#     crontab -e -u root 
# 
# The line at cron jobs file: 
# 
#     * * * * * /bin/bash  /root/m_local/etc/cron_job_01_initialisations_stage_1.bash
# 
#--------------------------------------------------------------------------
S_TMP_0="/opt/andmekettad/RAM_1MiB_01/initialization_jobs_are_in_progress_or_done.txt"
if [ ! -e "$S_TMP_0" ]; then
    echo "42" > $S_TMP_0
    sync ; wait; sync
    S_TMP_1="/root/m_local/etc/cron_job_01_initialisations_stage_2.bash"
    if [ -e "$S_TMP_1" ]; then
        source "$S_TMP_1"
        sync ; wait; sync
    fi
fi

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="56888654-b0c0-4fa4-a61d-2361d01166e7"
#==========================================================================
