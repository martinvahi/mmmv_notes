#!/usr/bin/env bash
#==========================================================================
# Initial author of this script: Martin.Vahi@softf1.com
# This script is in public domain.
#--------------------------------------------------------------------------
# The ssh-tunnel parameters:

SSH_SERVER_IP_ADDRESS_FROM_SSH_CLIENT_PERSPECTIVE="96.163.22.231"
SSH_SERVER_PORT_FROM_SSH_CLIENT_PERSPECTIVE="22"
USERNAME_FOR_LOGGING_INTO_THE_SSH_SERVER="pi"


# The model is that each tunnel has only 2 ends and
# queries/"questions" enter the tunnel from one of the ends and
# query results, "answers", exit from the same end of the tunnel,
# where the queries entered the tunnel.
SB_QUERIES_ENTER_THE_TUNNEL_FROM_SSH_CLIENT_SIDE="t" # {t,f}, "t" for "true"


TUNNEL_IP_ADDRESS_FROM_SSH_SERVER_PERSPECTIVE="localhost"
TUNNEL_PORT_FROM_SSH_SERVER_PERSPECTIVE="30120"
 
TUNNEL_IP_ADDRESS_FROM_SSH_CLIENT_PERSPECTIVE="localhost"
TUNNEL_PORT_FROM_SSH_CLIENT_PERSPECTIVE="4146"



#-------------------------------------------------------------------------- 
# SSH Server Configuration Quirks
#-------------------------------------------------------------------------- 
#
# By default the ssh-server only binds the ssh-tunnels to the "localhost", 
# even, when a server side public network interface/IP-address is
# assigned to this script's variable 
#
#     TUNNEL_IP_ADDRESS_FROM_SSH_SERVER_PERSPECTIVE
#
# To overcome that issue, the ssh-server side 
# 
#     /etc/ssh/sshd_config
#
# has to be updated by adding/uncommenting the line
#
#     GatewayPorts yes
#
# and the ssh-server has to be restarted by 
#
#      cd /etc/init.d
#      ./ssh restart
#
#
#-------------------------------------------------------------------------- 
# Everything below this line consists of only the implementation.
#-------------------------------------------------------------------------- 


if [ "$SB_QUERIES_ENTER_THE_TUNNEL_FROM_SSH_CLIENT_SIDE" == "t" ];then
    S_QUIRK_1="-L" # queries/questions enter the tunnel at ssh client side
else
    if [ "$SB_QUERIES_ENTER_THE_TUNNEL_FROM_SSH_CLIENT_SIDE" == "f" ];then
        S_QUIRK_1="-R" # queries/questions enter the tunnel at ssh server side
    else
        echo ""
        echo "The configuration is flawed. The "
        echo ""
        echo "    SB_QUERIES_ENTER_THE_TUNNEL_FROM_SSH_CLIENT_SIDE==$SB_QUERIES_ENTER_THE_TUNNEL_FROM_SSH_CLIENT_SIDE"
        echo ""
        echo "Supported values: {t,f}."
        echo "The model is that each tunnel has only 2 ends and "
        echo "queries enter the tunnel from one of the ends and "
        echo "query results exit from the same end of the tunnel,"
        echo "where the queries entered the tunnel."
        echo ""
        echo "GUID='adb80c84-f7a7-4f4f-af20-92a0405174e7'"
        echo ""
        #--------
        exit 1
    fi
fi
 
 
 
if [ "$S_QUIRK_1" == "-L" ];then
ssh -p $SSH_SERVER_PORT_FROM_SSH_CLIENT_PERSPECTIVE  $S_QUIRK_1 \
$TUNNEL_IP_ADDRESS_FROM_SSH_CLIENT_PERSPECTIVE:$TUNNEL_PORT_FROM_SSH_CLIENT_PERSPECTIVE:\
$TUNNEL_IP_ADDRESS_FROM_SSH_SERVER_PERSPECTIVE:$TUNNEL_PORT_FROM_SSH_SERVER_PERSPECTIVE \
$USERNAME_FOR_LOGGING_INTO_THE_SSH_SERVER@$SSH_SERVER_IP_ADDRESS_FROM_SSH_CLIENT_PERSPECTIVE
else
    if [ "$S_QUIRK_1" == "-R" ];then
ssh -p $SSH_SERVER_PORT_FROM_SSH_CLIENT_PERSPECTIVE  $S_QUIRK_1 \
$TUNNEL_IP_ADDRESS_FROM_SSH_SERVER_PERSPECTIVE:$TUNNEL_PORT_FROM_SSH_SERVER_PERSPECTIVE:\
$TUNNEL_IP_ADDRESS_FROM_SSH_CLIENT_PERSPECTIVE:$TUNNEL_PORT_FROM_SSH_CLIENT_PERSPECTIVE \
$USERNAME_FOR_LOGGING_INTO_THE_SSH_SERVER@$SSH_SERVER_IP_ADDRESS_FROM_SSH_CLIENT_PERSPECTIVE
    else
        echo ""
        echo "This script is flawed."
        echo "    S_QUIRK_1==$S_QUIRK_1"
        echo "GUID='c416fe9b-d7b3-44af-a2d0-92a0405174e7'"
        echo ""
        #--------
        exit 1
    fi
fi


#==========================================================================
