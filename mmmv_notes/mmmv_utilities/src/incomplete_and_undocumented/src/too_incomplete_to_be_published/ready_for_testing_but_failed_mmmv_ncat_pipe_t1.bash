#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#--------------------------------------------------------------------------
# Configuration:

echo "This script is ready for testing, but "
echo "for some quirky reason it failed the tests."
echo "To be studied later."

exit 1

S_TUNNEL_ENTRY_FOR_QUERIES_IP_ADDRESS="95.153.20.212"
#S_TUNNEL_ENTRY_FOR_QUERIES_IP_ADDRESS="localhost"
S_TUNNEL_ENTRY_FOR_QUERIES_PORT="4011"

S_TUNNEL_EXIT_FOR_QUERIES_IP_ADDRESS="localhost"
#S_TUNNEL_EXIT_FOR_QUERIES_IP_ADDRESS="95.153.20.212"
S_TUNNEL_EXIT_FOR_QUERIES_PORT="4000"

#--------------------------------------------------------------------------
# Implementation:

S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FN_FIFO_SUFFIX="`whoami`_$S_TUNNEL_EXIT_FOR_QUERIES_PORT$S_TIMESTAMP$S_TUNNEL_ENTRY_FOR_QUERIES_PORT"
S_FN_FIFO_SERVER2CLIENT="server_2_client_$S_FN_FIFO_SUFFIX"
S_FN_FIFO_CLIENT2SERVER="client_2_server_$S_FN_FIFO_SUFFIX"

S_FP_FIFO_SERVER2CLIENT="/tmp/pipes/$S_FN_FIFO_SERVER2CLIENT"
S_FP_FIFO_CLIENT2SERVER="/tmp/pipes/$S_FN_FIFO_CLIENT2SERVER"
S_TMP_0="$S_FP_FIFO_SERVER2CLIENT"

#----------------------------------
# The hope is that ~/tmp_ has greater 
# file system access restrictions than the /tmp .

if [ -e "$HOME/tmp_" ]; then
    mkdir -p $HOME/tmp_/pipes
    S_FP_FIFO_SERVER2CLIENT="$HOME/tmp_/pipes/$S_FN_FIFO_SERVER2CLIENT"
    S_FP_FIFO_CLIENT2SERVER="$HOME/tmp_/pipes/$S_FN_FIFO_CLIENT2SERVER"
else 
    if [ -e "$HOME/tmp" ]; then
        mkdir -p $HOME/tmp/pipes
        S_FP_FIFO_SERVER2CLIENT="$HOME/tmp/pipes/$S_FN_FIFO_SERVER2CLIENT"
        S_FP_FIFO_CLIENT2SERVER="$HOME/tmp/pipes/$S_FN_FIFO_CLIENT2SERVER"
    fi
fi

if [ "$S_TMP_0" == "$S_FP_FIFO_SERVER2CLIENT" ]; then
    mkdir -p /tmp/pipes
fi

if [ ! -e "$S_FP_FIFO_SERVER2CLIENT" ]; then
    mkfifo $S_FP_FIFO_SERVER2CLIENT 
fi
if [ ! -e "$S_FP_FIFO_CLIENT2SERVER" ]; then
    mkfifo $S_FP_FIFO_CLIENT2SERVER 
fi

sync
sleep 1 # for the fifos to be created
#----------------------------------

ncat -lk $S_TUNNEL_ENTRY_FOR_QUERIES_IP_ADDRESS $S_TUNNEL_ENTRY_FOR_QUERIES_PORT  < $S_FP_FIFO_SERVER2CLIENT > $S_FP_FIFO_CLIENT2SERVER &

ncat -lk $S_TUNNEL_EXIT_FOR_QUERIES_IP_ADDRESS $S_TUNNEL_EXIT_FOR_QUERIES_PORT < $S_FP_FIFO_CLIENT2SERVER > $S_FP_FIFO_SERVER2CLIENT &
 

#==========================================================================
