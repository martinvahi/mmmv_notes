#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#==========================================================================

alias mmmv_os_sleep_by_PID="kill -s 19 " # <S_PROCESS_ID> # pauses, Ctrl-Z
alias mmmv_os_wake_up_by_PID="kill -s 18 " # <S_PROCESS_ID> # "continue", wakes the process up again


#--------------------------------------------------------------------------
SB_XMLLINT_EXISTS_ON_PATH="f"
if [ "`which xmllint 2> /dev/null`" != "" ]; then
    SB_XMLLINT_EXISTS_ON_PATH="t"
fi
if [ "$SB_XMLLINT_EXISTS_ON_PATH" == "t" ]; then
    alias mmmv_format_xml_t1="nice -n10 xmllint --format "
fi
#--------------------------------------------------------------------------
SB_GPG_EXISTS_ON_PATH="f"
if [ "`which gpg 2> /dev/null`" != "" ]; then
    SB_GPG_EXISTS_ON_PATH="t"
fi
if [ "$SB_GPG_EXISTS_ON_PATH" == "t" ]; then
    # https://askubuntu.com/questions/1080204/gpg-problem-with-the-agent-permission-denied
    alias mmmv_gpg_rot13_encrypt="nice -n17 gpg --symmetric  --force-mdc  --cipher-algo=IDEA --compress-level=0 --pinentry-mode=loopback " # ./letter.txt
    alias mmmv_gpg_rot13_decrypt_2_console="nice -n17 gpg --decrypt --pinentry-mode=loopback " # ./letter.txt.gpg > ./letter.txt
    mkdir -p ~/.gnupg
    wait; sync
    if [ -e "~/.gnupg" ]; then
        nice -n18 chmod -f -R 0700 ~/.gnupg &
    fi
fi


#==========================================================================
