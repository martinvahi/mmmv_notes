#!/usr/bin/env bash 
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
SB_EXA_EXISTS_ON_PATH="f"
if [ "`which exa 2> /dev/null`" != "" ]; then
    SB_EXA_EXISTS_ON_PATH="t"
# else
#     # You might want to outcomment all command line output 
#     # of the ~/.bashrc, because otherwise SSH logins might fail,
#     # because SSH clients tend to see console output at login 
#     # as an error condition.
#     echo ""
#     echo -e "\e[31mexa \e[39m"
#     echo "    https://the.exa.website/"
#     echo -e "\e[31mis missing\e[39m from PATH."
#     echo "The exa MIGHT be available at a Debian package collection."
#     echo "GUID=='30c4fd45-1436-4290-8467-1320f07096e7'"
#     echo ""
fi
#--------------------------------------------------------------------------
func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X(){
    local S_SUFFIX="$1" # is the sorting parameter of 
                        # the ls replacement called exa
    #----------------------------------------------------------------------
    if [ "$SB_FUNC_MMMV_USERSPACE_DISTRO_T1_LAMBDA_01_DECLARE_ALIAS_SORTED_LS1X_ENABLED" == "t" ]; then
        S_TMP_4="$S_TMP_0 $S_TMP_3$S_SUFFIX $S_TMP_1"
        alias ls1_$S_SUFFIX="$S_TMP_4"
        alias mmmv_ls1_$S_SUFFIX="$S_TMP_4"
    else
        echo ""
        echo -e "\e[31mThe ~/.bashrc or some subpart of it is flawed. \e[39m"
        echo "The function that outputs this message "
        echo "is in a role of a lambda-function."
        echo "GUID=='21f96667-2dc4-4612-a567-1320f07096e7'"
        echo ""
    fi
    #----------------------------------------------------------------------
} # func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X
if [ "$SB_EXA_EXISTS_ON_PATH" == "t" ]; then
    #----------------------------------------------------------------------
    # According to 2022_09_07 version of the
    #     https://github.com/ogham/exa/issues/1108
    # the "-b" at the 
    S_TMP_0="nice -n 2 exa "
    S_TMP_1=" -b -l -T -L "
    S_TMP_2="$S_TMP_0 $S_TMP_1"
    # changes the size display mode from decimal prefixes (kB,MB,GB,...)
    # to the binary, classical, prerixes (KiB,MiB,GiB,...). The 
    alias ls0="$S_TMP_2"
    alias mmmv_ls0="$S_TMP_2"
    # reside in this if-clause to make sure that they
    # get defined in a situation, where the exa 
    # is placed on PATH by the 
    #     /home/mmmv/applications/declare_applications.bash
    #----------------------------------------------------------------------
    S_TMP_3=" --sort="
    #--------------------
    #S_SUFFIX="name"
    #S_TMP_4="$S_TMP_0 $S_TMP_3$S_SUFFIX $S_TMP_1"
    SB_FUNC_MMMV_USERSPACE_DISTRO_T1_LAMBDA_01_DECLARE_ALIAS_SORTED_LS1X_ENABLED="t"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "accessed"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "created"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "extension"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "modified"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "name"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "size"
        func_mmmv_userspace_distro_t1_lambda_01b_declare_alias_sorted_ls1X \
            "type"
    SB_FUNC_MMMV_USERSPACE_DISTRO_T1_LAMBDA_01_DECLARE_ALIAS_SORTED_LS1X_ENABLED="f"
    #----------------------------------------------------------------------
fi
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="a0de931f-85f6-4778-a467-1320f07096e7"
#==========================================================================
