#!/usr/bin/env bash
#==========================================================================
# Initial author of this script: Martin.Vahi@softf1.com
# This file is in public domain
#
# A citation of user "alfredozn" from
#     https://superuser.com/questions/153371/what-does-export-do-in-bash
#     (archival copy: https://archive.is/fQ5Mf )
#     -----tsitation---start-----------------------------------------------
#     When you use export, you are adding the variable 
#     to the environment variables list of the shell in which 
#     the export command was called and all the environment variables 
#     of a shell are passed to the child processes, thats why you can use it.
# 
#     When you finish the shell its environment is destroyed, 
#     thats why the environment variables are declared and exported 
#     at login, in the .bashrc file for example
#     -----tsitation---end-------------------------------------------------
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------

echo ""
export -p | grep S_DEMO_TMP_42 # displays a line from the list of vars,
                               # if the list has that kind of a line.
echo ""
if [ "$1" == "e" ]; then
    echo "With export."
    echo ""
    export S_DEMO_TMP_42="AHa" # with export
    export -p | grep S_DEMO_TMP_42 # displays a line from the list of vars
                                   # if the list has that kind of a line.
    ruby -e " \
        puts('Buoy_1: S_DEMO_TMP_42=='+ENV['S_DEMO_TMP_42'].to_s); \
        sleep(1.1); \
        puts('Buoy_2: S_DEMO_TMP_42=='+ENV['S_DEMO_TMP_42'].to_s); \
        " 
    export S_DEMO_TMP_42="EHe" 
    echo "Buoy_3"
else
    echo "Without export."
    echo ""
    S_DEMO_TMP_42="AHa" # without export
    export -p | grep S_DEMO_TMP_42 # displays a line from the list of vars
                                   # if the list has that kind of a line.
    ruby -e " \
        puts('Buoy_1: S_DEMO_TMP_42=='+ENV['S_DEMO_TMP_42'].to_s); \
        sleep(1.1); \
        puts('Buoy_2: S_DEMO_TMP_42=='+ENV['S_DEMO_TMP_42'].to_s); \
        " 
    S_DEMO_TMP_42="EHe" 
    echo "Buoy_3"
fi
export -p | grep S_DEMO_TMP_42 # displays a line from the list of vars,
                               # if the list has that kind of a line.
echo ""

#==========================================================================
