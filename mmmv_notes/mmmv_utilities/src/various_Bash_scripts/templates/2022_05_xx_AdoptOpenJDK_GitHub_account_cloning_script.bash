#/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
#S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
    wait # for sync
} # func_mmmv_wait_and_sync_t1

#--------------------------------------------------------------------------
func_mmmv_assert_error_code_zero_t1x1(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    local S_COMMENT="$3"
    #----------------------------------------------------------------------
    if [ "$S_GUID_CANDIDATE" == "" ]; then
        echo ""
        echo -e "\e[31mThe Bash code that calls this function is flawed. \e[39m"
        echo ""
        echo "    S_GUID_CANDIDATE==\"\""
        echo ""
        echo "but it is expected to be a GUID."
        echo "Aborting script."
        echo "GUID=='95e142e4-cc82-42e1-9e15-e140311156e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #------------------------------
    # If the "$?" were evaluated in this function, 
    # then it would be "0" even, if it is
    # something else at the calling code.
    if [ "$S_ERR_CODE" != "0" ];then
        echo ""
        echo "Something went wrong. Error code: $S_ERR_CODE"
        echo -e "\e[31mAborting script. \e[39m"
        echo "GUID=='47757940-5533-4143-9415-e140311156e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        if [ "$S_COMMENT" != "" ]; then
            echo ""
            echo "$S_COMMENT"
        fi
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #------------------------------
} # func_mmmv_assert_error_code_zero_t1x1

#--------------------------------------------------------------------------
func_ask_for_confirmation(){
    #------------------------------
    echo ""
    echo -e "\e[33mWARNING:\e[39m The repositories that You are "
    echo "about to clone are relatively huge. If You are "
    echo "sure that You still want to clone them, then"
    echo "please type \"clone\", without the quotatin marks and"
    echo -e "\e[33min lowercase\e[39m, to verify Your wish. "
    echo "Thank You for trying out this script."
    echo "GUID=='6c51ba34-a69a-4c41-9205-e140311156e7'"
    echo ""
    #------------------------------
    local S_ANSWER="not_set"
    read -p "Your confirmation please: " S_ANSWER
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "3a1ae0d0-58d2-4982-b315-e140311156e7" ""
    #------------------------------
    if [ "$S_ANSWER" == "clone" ]; then
        echo ""
        echo -e "\e[33mAttempting to clone.\e[39m"
        local S_CLONING_START_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
        echo -e "Cloning start timestamp: \e[33m$S_CLONING_START_TIMESTAMP\e[39m"
        echo ""
    else
        echo ""
        echo -e "Confirmation \e[33mNOT received\e[39m."
        echo "Exiting as requested."
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 0 # no errors
    fi
    #------------------------------
} # func_ask_for_confirmation
func_ask_for_confirmation

#--------------------------------------------------------------------------
func_create_script_for_updating_clones_folder_t1(){
    # usually named pull_new_version_from_git_repository.bash
    # Exits with error, if uudecode is missing from PATH.
    #----------------------------------------------------------------------
    local S_FP_BASH_FILE_TO_BE_CREATED="$1"
    #----------------------------------------------------------------------
    if [ "$S_FP_BASH_FILE_TO_BE_CREATED" == "" ]; then
        echo "Value for the formal parameter S_FP_BASH_FILE_TO_BE_CREATED is missing."
        echo -e "\e[31mAborting script.\e[39m"
        echo "GUID=='2db8f397-095c-44a8-8205-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #----------------------------------------------------------------------
    if [ -h "$S_FP_BASH_FILE_TO_BE_CREATED" ]; then
        echo ""
        echo "A symlink with the path of "
        echo ""
        echo "    $S_FP_BASH_FILE_TO_BE_CREATED"
        echo ""
        echo -e "exists. \e[31mAborting script.\e[39m"
        echo "GUID=='b3d4e753-0340-4bcc-a105-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    if [ -e "$S_FP_BASH_FILE_TO_BE_CREATED" ]; then
        # The control flow won't get in here with 
        # existing broken symlinks.
        echo ""
        if [ -d "$S_FP_BASH_FILE_TO_BE_CREATED" ]; then
            echo "A folder with the path of "
        else
            echo "A file with the path of "
        fi
        echo ""
        echo "    $S_FP_BASH_FILE_TO_BE_CREATED"
        echo ""
        echo -e "exists. \e[31mAborting script.\e[39m"
        echo "GUID=='32401715-d04c-460d-bf05-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #----------------------------------------------------------------------
    if [ "`which uudecode 2> /dev/null`" == "" ]; then
        echo ""
        echo -e "\e[31muudecode is missing\e[39m from PATH."
        echo -e "\e[31mAborting script.\e[39m"
        echo "GUID=='99c96910-67ae-4e6a-8205-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #----------------------------------------------------------------------
    local S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
    local S_TMP_0="_$S_TIMESTAMP"
    local S_TMP_1="_tmp.txt"
    local S_FP_ASCII="$S_FP_BASH_FILE_TO_BE_CREATED$S_TMP_0$S_TMP_1"
    if [ -e "$S_FP_ASCII" ]; then
        echo ""
        echo -e "\e[31mThe code of this Bash function is flawed.\e[39m"
        echo "GUID=='2801b73c-3945-49b0-b3f4-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #----------------------------------------------------------------------
    echo "begin-base64 644 ./ajut" > $S_FP_ASCII
    func_mmmv_wait_and_sync_t1
    if [ ! -e "$S_FP_ASCII" ]; then
        echo ""
        echo -e "\e[31mThe code of this Bash function is flawed.\e[39m"
        echo "GUID=='3eb7d31d-04ed-45eb-94f4-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    echo "IyEvdXNyL2Jpbi9lbnYgYmFzaAojPT09PT09PT09PT09PT09PT09PT09PT09" >> $S_FP_ASCII
    echo "PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09" >> $S_FP_ASCII
    echo "PT09PT0KIyBJbml0aWFsIGF1dGhvcjogTWFydGluLlZhaGlAc29mdGYxLmNv" >> $S_FP_ASCII
    echo "bQojIFRoaXMgZmlsZSBpcyBpbiBwdWJsaWMgZG9tYWluLgojCiMgVGhlIGZv" >> $S_FP_ASCII
    echo "bGxvd2luZyBsaW5lIGlzIGEgc3BkeC5vcmcgbGljZW5zZSBsYWJlbCBsaW5l" >> $S_FP_ASCII
    echo "OgojIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiAwQlNECiM9PT09PT09PT09" >> $S_FP_ASCII
    echo "PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09" >> $S_FP_ASCII
    echo "PT09PT09PT09PT09PT09PT09PQpTX0ZQX0RJUj0iJCggY2QgIiQoIGRpcm5h" >> $S_FP_ASCII
    echo "bWUgIiR7QkFTSF9TT1VSQ0VbMF19IiApIiAmJiBwd2QgKSIKU19GUF9PUklH" >> $S_FP_ASCII
    echo "PSJgcHdkYCIKU19WRVJTSU9OX09GX1RISVNfU0NSSVBUPSI0ZjNmNDQ2NC1i" >> $S_FP_ASCII
    echo "MGJlLTRhMTUtYTk1Ny03MTkxMTExMTU2ZTciICMgYSBHVUlECiMtLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLQojIEZvciBjb3B5LXBhc3RpbmcgdG8g" >> $S_FP_ASCII
    echo "dGhlIH4vLmJhc2hyYwojCiMgICAgIGFsaWFzIG1tbXZfY3JlX2dpdF9jbG9u" >> $S_FP_ASCII
    echo "ZT0iY3AgJFBBVEhfVE9fVEhFPCRTX0ZQX0RJUj4vcHVsbF9uZXdfdmVyc2lv" >> $S_FP_ASCII
    echo "bl9mcm9tX2dpdF9yZXBvc2l0b3J5LmJhc2ggLi8gOyBta2RpciAtcCAuL3Ro" >> $S_FP_ASCII
    echo "ZV9yZXBvc2l0b3J5X2Nsb25lcyA7IgojCiMtLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLQpmdW5jX3dhaXRfYW5kX3N5bmMoKXsKICAgIHdhaXQgIyBm" >> $S_FP_ASCII
    echo "b3IgYmFja2dyb3VuZCBwcm9jZXNzZXMgc3RhcnRlZCBieSB0aGlzIEJhc2gg" >> $S_FP_ASCII
    echo "c2NyaXB0IHRvIGV4aXQvZmluaXNoCiAgICBzeW5jICMgbmV0d29yayBkcml2" >> $S_FP_ASCII
    echo "ZXMsIFVTQi1zdGlja3MsIGV0Yy4KfSAjIGZ1bmNfd2FpdF9hbmRfc3luYwoK" >> $S_FP_ASCII
    echo "ZnVuX2V4Y19leGl0X3dpdGhfYW5fZXJyb3JfdDEoKXsKICAgIGxvY2FsIFNf" >> $S_FP_ASCII
    echo "R1VJRF9DQU5ESURBVEU9IiQxIiAjIGZpcnN0IGZ1bmN0aW9uIGFyZ3VtZW50" >> $S_FP_ASCII
    echo "CiAgICBpZiBbICIkU19HVUlEX0NBTkRJREFURSIgPT0gIiIgXTsgdGhlbiAK" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICIiCiAgICAgICAgZWNobyAiVGhlIGNvZGUgb2YgdGhp" >> $S_FP_ASCII
    echo "cyBzY3JpcHQgaXMgZmxhd2VkLiIKICAgICAgICBlY2hvICJBYm9ydGluZyBz" >> $S_FP_ASCII
    echo "Y3JpcHQuIgogICAgICAgIGVjaG8gIkdVSUQ9PScyNWMxMzY0OS1jZjNkLTQ1" >> $S_FP_ASCII
    echo "ZWMtODRiOC03MTkxMTExMTU2ZTcnIgogICAgICAgIGVjaG8gIiIKICAgICAg" >> $S_FP_ASCII
    echo "ICBjZCAiJFNfRlBfT1JJRyIKICAgICAgICBleGl0IDEgIyBleGl0IHdpdGgg" >> $S_FP_ASCII
    echo "YW4gZXJyb3IKICAgIGVsc2UKICAgICAgICBlY2hvICIiCiAgICAgICAgZWNo" >> $S_FP_ASCII
    echo "byAiVGhlIGNvZGUgb2YgdGhpcyBzY3JpcHQgaXMgZmxhd2VkLiIKICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICJBYm9ydGluZyBzY3JpcHQuIgogICAgICAgIGVjaG8gIkdVSURf" >> $S_FP_ASCII
    echo "Q0FORElEQVRFPT0nJFNfR1VJRF9DQU5ESURBVEUnIgogICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiIKICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAgICAgICBleGl0IDEgIyBl" >> $S_FP_ASCII
    echo "eGl0IHdpdGggYW4gZXJyb3IKICAgIGZpCn0gIyBmdW5fZXhjX2V4aXRfd2l0" >> $S_FP_ASCII
    echo "aF9hbl9lcnJvcl90MSAKCmZ1bl9hc3NlcnRfZXhpc3RzX29uX3BhdGhfdDEg" >> $S_FP_ASCII
    echo "KCkgewogICAgbG9jYWwgU19OQU1FX09GX1RIRV9FWEVDVVRBQkxFPSIkMSIg" >> $S_FP_ASCII
    echo "IyBmaXJzdCBmdW5jdGlvbiBhcmd1bWVudAogICAgbG9jYWwgU19UTVBfMD0i" >> $S_FP_ASCII
    echo "XGB3aGljaCAkU19OQU1FX09GX1RIRV9FWEVDVVRBQkxFIDI+L2Rldi9udWxs" >> $S_FP_ASCII
    echo "XGAiCiAgICBsb2NhbCBTX1RNUF8xPSIiCiAgICBsb2NhbCBTX1RNUF8yPSJT" >> $S_FP_ASCII
    echo "X1RNUF8xPSRTX1RNUF8wIgogICAgZXZhbCAke1NfVE1QXzJ9CiAgICBpZiBb" >> $S_FP_ASCII
    echo "ICIkU19UTVBfMSIgPT0gIiIgXSA7IHRoZW4KICAgICAgICBlY2hvICIiCiAg" >> $S_FP_ASCII
    echo "ICAgICAgZWNobyAiVGhpcyBiYXNoIHNjcmlwdCByZXF1aXJlcyB0aGUgXCIk" >> $S_FP_ASCII
    echo "U19OQU1FX09GX1RIRV9FWEVDVVRBQkxFXCIgdG8gYmUgb24gdGhlIFBBVEgu" >> $S_FP_ASCII
    echo "IgogICAgICAgIGVjaG8gIkdVSUQ9PScxZDZkMGEwMi1iZjE2LTQ5OGEtYmI1" >> $S_FP_ASCII
    echo "Ny03MTkxMTExMTU2ZTcnIgogICAgICAgIGVjaG8gIiIKICAgICAgICBjZCAi" >> $S_FP_ASCII
    echo "JFNfRlBfT1JJRyIKICAgICAgICBleGl0IDEgIyBleGl0IHdpdGggYW4gZXJy" >> $S_FP_ASCII
    echo "b3IKICAgIGZpCn0gIyBmdW5fYXNzZXJ0X2V4aXN0c19vbl9wYXRoX3QxCgpm" >> $S_FP_ASCII
    echo "dW5fYXNzZXJ0X2V4aXN0c19vbl9wYXRoX3QxICJydWJ5IgpmdW5fYXNzZXJ0" >> $S_FP_ASCII
    echo "X2V4aXN0c19vbl9wYXRoX3QxICJwcmludGYiCmZ1bl9hc3NlcnRfZXhpc3Rz" >> $S_FP_ASCII
    echo "X29uX3BhdGhfdDEgImdyZXAiCmZ1bl9hc3NlcnRfZXhpc3RzX29uX3BhdGhf" >> $S_FP_ASCII
    echo "dDEgImRhdGUiCmZ1bl9hc3NlcnRfZXhpc3RzX29uX3BhdGhfdDEgImdpdCIK" >> $S_FP_ASCII
    echo "ZnVuX2Fzc2VydF9leGlzdHNfb25fcGF0aF90MSAidGFyIgpmdW5fYXNzZXJ0" >> $S_FP_ASCII
    echo "X2V4aXN0c19vbl9wYXRoX3QxICJiYXNlbmFtZSIKCiMtLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLQoKZnVuY19tbW12X2Fzc2VydF9lcnJvcl9jb2Rl" >> $S_FP_ASCII
    echo "X3plcm9fdDEoKXsKICAgIGxvY2FsIFNfRVJSX0NPREU9IiQxIiAjIHRoZSAi" >> $S_FP_ASCII
    echo "JD8iCiAgICBsb2NhbCBTX0dVSURfQ0FORElEQVRFPSIkMiIKICAgICMtLS0t" >> $S_FP_ASCII
    echo "LS0tLQogICAgIyBJZiB0aGUgIiQ/IiB3ZXJlIGV2YWx1YXRlZCBpbiB0aGlz" >> $S_FP_ASCII
    echo "IGZ1bmN0aW9uLCAKICAgICMgdGhlbiBpdCB3b3VsZCBiZSAiMCIgZXZlbiwg" >> $S_FP_ASCII
    echo "aWYgaXQgaXMKICAgICMgc29tZXRoaW5nIGVsc2UgYXQgdGhlIGNhbGxpbmcg" >> $S_FP_ASCII
    echo "Y29kZS4KICAgIGlmIFsgIiRTX0VSUl9DT0RFIiAhPSAiMCIgXTt0aGVuCiAg" >> $S_FP_ASCII
    echo "ICAgICAgZWNobyAiIgogICAgICAgIGVjaG8gIlNvbWV0aGluZyB3ZW50IHdy" >> $S_FP_ASCII
    echo "b25nLiBFcnJvciBjb2RlOiAkU19FUlJfQ09ERSIKICAgICAgICBlY2hvICJB" >> $S_FP_ASCII
    echo "Ym9ydGluZyBzY3JpcHQuIgogICAgICAgIGVjaG8gIkdVSUQ9PSdjMWM1MDhm" >> $S_FP_ASCII
    echo "Ni1jMmJjLTQyNzItOWFhNy03MTkxMTExMTU2ZTcnIgogICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IlNfR1VJRF9DQU5ESURBVEU9PSckU19HVUlEX0NBTkRJREFURSciCiAgICAg" >> $S_FP_ASCII
    echo "ICAgZWNobyAiIgogICAgICAgIGNkICIkU19GUF9PUklHIgogICAgICAgIGV4" >> $S_FP_ASCII
    echo "aXQgMQogICAgZmkKfSAjIGZ1bmNfbW1tdl9hc3NlcnRfZXJyb3JfY29kZV96" >> $S_FP_ASCII
    echo "ZXJvX3QxCgojLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCmZ1bmNf" >> $S_FP_ASCII
    echo "bW1tdl9hc3NlcnRfZmlsZV9leGlzdHNfdDEoKSB7CiAgICBsb2NhbCBTX0ZQ" >> $S_FP_ASCII
    echo "PSIkMSIKICAgIGxvY2FsIFNfR1VJRF9DQU5ESURBVEU9IiQyIgogICAgbG9j" >> $S_FP_ASCII
    echo "YWwgU0JfT1BUSU9OQUxfQkFOX1NZTUxJTktTPSIkMyIgIyBkb21haW46IHsi" >> $S_FP_ASCII
    echo "dCIsICJmIiwgIiJ9IGRlZmF1bHQ6ICJmIgogICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgIyBpcyB0aGUgbGFzdCBmb3JtYWwgcGFy" >> $S_FP_ASCII
    echo "YW1ldGVyIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIyBpbiBzdGVhZCBvZiB0aGUgU19HVUlEX0NBTkRJREFURSwgCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAjIGJlY2F1c2Ug" >> $S_FP_ASCII
    echo "dGhhdCB3YXkgdGhpcyBmdW5jdGlvbiBpcyAKICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICMgYmFja3dhcmRzIGNvbXBhdGlibGUg" >> $S_FP_ASCII
    echo "d2l0aCAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICMgYW4gZWFybGllciB2ZXJzaW9uIG9mIHRoaXMgCiAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAjIGZ1bmN0aW9uLgogICAgIy0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgbG9jYWwgU0JfTEFD" >> $S_FP_ASCII
    echo "S19PRl9QQVJBTUVURVJTPSJmIgogICAgaWYgWyAiJFNfRlAiID09ICIiIF07" >> $S_FP_ASCII
    echo "IHRoZW4KICAgICAgICBTQl9MQUNLX09GX1BBUkFNRVRFUlM9InQiCiAgICBm" >> $S_FP_ASCII
    echo "aQogICAgaWYgWyAiJFNfR1VJRF9DQU5ESURBVEUiID09ICIiIF07IHRoZW4K" >> $S_FP_ASCII
    echo "ICAgICAgICBTQl9MQUNLX09GX1BBUkFNRVRFUlM9InQiCiAgICBmaQogICAg" >> $S_FP_ASCII
    echo "aWYgWyAiJFNCX0xBQ0tfT0ZfUEFSQU1FVEVSUyIgPT0gInQiIF07IHRoZW4K" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICIiCiAgICAgICAgZWNobyAiVGhlIGNvZGUgdGhhdCBj" >> $S_FP_ASCII
    echo "YWxscyB0aGlzIGZ1bmN0aW9uIGlzIGZsYXdlZC4iCiAgICAgICAgZWNobyAi" >> $S_FP_ASCII
    echo "VGhpcyBmdW5jdGlvbiByZXF1aXJlcyAyIHBhcmFtZXRlcnMsIHdoaWNoIGFy" >> $S_FP_ASCII
    echo "ZSAiCiAgICAgICAgZWNobyAiU19GUCwgU19HVUlEX0NBTkRJREFURSwgYW5k" >> $S_FP_ASCII
    echo "IGl0IGhhcyBhbiBvcHRpb25hbCAzLiBwYXJhbWV0ZXIsICIKICAgICAgICBl" >> $S_FP_ASCII
    echo "Y2hvICJ3aGljaCBpcyBTQl9PUFRJT05BTF9CQU5fU1lNTElOS1MuIgogICAg" >> $S_FP_ASCII
    echo "ICAgIGlmIFsgIiRTX0dVSURfQ0FORElEQVRFIiAhPSAiIiBdOyB0aGVuCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgIGVjaG8gIlNfR1VJRF9DQU5ESURBVEU9PSckU19HVUlEX0NB" >> $S_FP_ASCII
    echo "TkRJREFURSciCiAgICAgICAgZmkKICAgICAgICBlY2hvICJHVUlEPT0nNTQ4" >> $S_FP_ASCII
    echo "OWRiOTYtNmE2Mi00MzI4LWJiNTctNzE5MTExMTE1NmU3JyIKICAgICAgICBl" >> $S_FP_ASCII
    echo "Y2hvICIiCiAgICAgICAgIy0tLS0tLS0tCiAgICAgICAgY2QgIiRTX0ZQX09S" >> $S_FP_ASCII
    echo "SUciCiAgICAgICAgZXhpdCAxICMgZXhpdGluZyB3aXRoIGFuIGVycm9yCiAg" >> $S_FP_ASCII
    echo "ICBlbHNlCiAgICAgICAgaWYgWyAiJFNCX0xBQ0tfT0ZfUEFSQU1FVEVSUyIg" >> $S_FP_ASCII
    echo "IT0gImYiIF07IHRoZW4KICAgICAgICAgICAgZWNobyAiVGhpcyBjb2RlIGlz" >> $S_FP_ASCII
    echo "IGZsYXdlZC4iCiAgICAgICAgICAgIGVjaG8gIkdVSUQ9PSczYzI2NGMxMy02" >> $S_FP_ASCII
    echo "YTAzLTQ2OTktYmQyNy03MTkxMTExMTU2ZTcnIgogICAgICAgICAgICAjLS0t" >> $S_FP_ASCII
    echo "LS0tLS0KICAgICAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGV4aXQgMSAjIGV4aXRpbmcgd2l0aCBhbiBlcnJvcgogICAgICAgIGZpCiAg" >> $S_FP_ASCII
    echo "ICBmaQogICAgIy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogICAg" >> $S_FP_ASCII
    echo "aWYgWyAiJFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUyIgPT0gIiIgXTsgdGhl" >> $S_FP_ASCII
    echo "bgogICAgICAgICMgVGhlIGRlZmF1bHQgdmFsdWUgb2YgdGhlIAogICAgICAg" >> $S_FP_ASCII
    echo "IFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUz0iZiIKICAgICAgICAjIG11c3Qg" >> $S_FP_ASCII
    echo "YmUgYmFja3dhcmRzIGNvbXBhdGlibGUgd2l0aCB0aGUKICAgICAgICAjIHZl" >> $S_FP_ASCII
    echo "cnNpb24gb2YgdGhpcyBmdW5jdGlvbiwgd2hlcmUgCiAgICAgICAgIyBzeW1s" >> $S_FP_ASCII
    echo "aW5rcyB0byBmaWxlcyB3ZXJlIHRyZWF0ZWQgYXMgYWN0dWFsIGZpbGVzLgog" >> $S_FP_ASCII
    echo "ICAgZWxzZQogICAgICAgIGlmIFsgIiRTQl9PUFRJT05BTF9CQU5fU1lNTElO" >> $S_FP_ASCII
    echo "S1MiICE9ICJ0IiBdOyB0aGVuCiAgICAgICAgICAgIGlmIFsgIiRTQl9PUFRJ" >> $S_FP_ASCII
    echo "T05BTF9CQU5fU1lNTElOS1MiICE9ICJmIiBdOyB0aGVuCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICBlY2hvICIiCiAgICAgICAgICAgICAgICBlY2hvICJUaGUgIgogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAgICAgICAgZWNobyAiICAg" >> $S_FP_ASCII
    echo "IFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUz09XCIkU0JfT1BUSU9OQUxfQkFO" >> $S_FP_ASCII
    echo "X1NZTUxJTktTXCIiCiAgICAgICAgICAgICAgICBlY2hvICIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICJidXQgdGhlIHZhbGlkIHZhbHVlcyBmb3IgdGhlIFNC" >> $S_FP_ASCII
    echo "X09QVElPTkFMX0JBTl9TWU1MSU5LUyIKICAgICAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "ImFyZTogXCJ0XCIsIFwiZlwiLCBcIlwiLiIKICAgICAgICAgICAgICAgIGVj" >> $S_FP_ASCII
    echo "aG8gIlNfR1VJRF9DQU5ESURBVEU9PSckU19HVUlEX0NBTkRJREFURSciCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICBlY2hvICJHVUlEPT0nOTE3ZjEzNmUtYTBhZC00Njkz" >> $S_FP_ASCII
    echo "LWJiMzctNzE5MTExMTE1NmU3JyIKICAgICAgICAgICAgICAgIGVjaG8gIiIK" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICMtLS0tLS0tLQogICAgICAgICAgICAgICAgY2Qg" >> $S_FP_ASCII
    echo "IiRTX0ZQX09SSUciCiAgICAgICAgICAgICAgICBleGl0IDEgIyBleGl0aW5n" >> $S_FP_ASCII
    echo "IHdpdGggYW4gZXJyb3IKICAgICAgICAgICAgZmkKICAgICAgICBmaQogICAg" >> $S_FP_ASCII
    echo "ZmkKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICAgIGlm" >> $S_FP_ASCII
    echo "IFsgISAtZSAiJFNfRlAiIF07IHRoZW4KICAgICAgICBpZiBbIC1oICIkU19G" >> $S_FP_ASCII
    echo "UCIgXTsgdGhlbgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgIGVj" >> $S_FP_ASCII
    echo "aG8gIlRoZSBwYXRoICIKICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIgICAgJFNfRlAgIgogICAgICAgICAgICBlY2hvICIiCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gInBvaW50cyB0byBhIGJyb2tlbiBzeW1saW5rLCBidXQg" >> $S_FP_ASCII
    echo "IgogICAgICAgICAgICBpZiBbICIkU0JfT1BUSU9OQUxfQkFOX1NZTUxJTktT" >> $S_FP_ASCII
    echo "IiA9PSAidCIgXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAiYSBmaWxl" >> $S_FP_ASCII
    echo "IGlzIGV4cGVjdGVkLiIKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgZWNobyAiYSBmaWxlIG9yIGEgc3ltbGluayB0byBhIGZpbGUgaXMgZXhw" >> $S_FP_ASCII
    echo "ZWN0ZWQuIgogICAgICAgICAgICBmaQogICAgICAgICAgICBlY2hvICJTX0dV" >> $S_FP_ASCII
    echo "SURfQ0FORElEQVRFPT1cIiRTX0dVSURfQ0FORElEQVRFXCIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gIkdVSUQ9PScyMDNlMDYzNC0wYjBlLTRiZmMtODY1Ny03MTkx" >> $S_FP_ASCII
    echo "MTExMTU2ZTcnIgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgICMt" >> $S_FP_ASCII
    echo "LS0tLS0tLQogICAgICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgZXhpdCAxICMgZXhpdGluZyB3aXRoIGFuIGVycm9yCiAgICAgICAgZWxz" >> $S_FP_ASCII
    echo "ZQogICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgIGlmIFsgIiRTQl9P" >> $S_FP_ASCII
    echo "UFRJT05BTF9CQU5fU1lNTElOS1MiID09ICJ0IiBdOyB0aGVuCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICJUaGUgZmlsZSAiCiAgICAgICAgICAgIGVsc2UKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgIGVjaG8gIlRoZSBmaWxlIG9yIGEgc3ltbGluayB0byBh" >> $S_FP_ASCII
    echo "IGZpbGUgIgogICAgICAgICAgICBmaQogICAgICAgICAgICBlY2hvICIiCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgIGVjaG8gIiAgICAkU19GUCAiCiAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiIKICAgICAgICAgICAgZWNobyAiZG9lcyBub3QgZXhpc3QuIgogICAgICAg" >> $S_FP_ASCII
    echo "ICAgICBlY2hvICJTX0dVSURfQ0FORElEQVRFPT1cIiRTX0dVSURfQ0FORElE" >> $S_FP_ASCII
    echo "QVRFXCIiCiAgICAgICAgICAgIGVjaG8gIkdVSUQ9PScyMGE3ZWY5NS1iNTll" >> $S_FP_ASCII
    echo "LTQ3NDYtOTcyNy03MTkxMTExMTU2ZTcnIgogICAgICAgICAgICBlY2hvICIi" >> $S_FP_ASCII
    echo "CiAgICAgICAgICAgICMtLS0tLS0tLQogICAgICAgICAgICBjZCAiJFNfRlBf" >> $S_FP_ASCII
    echo "T1JJRyIKICAgICAgICAgICAgZXhpdCAxICMgZXhpdGluZyB3aXRoIGFuIGVy" >> $S_FP_ASCII
    echo "cm9yCiAgICAgICAgZmkKICAgIGVsc2UKICAgICAgICBpZiBbIC1kICIkU19G" >> $S_FP_ASCII
    echo "UCIgXTsgdGhlbgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgIGlm" >> $S_FP_ASCII
    echo "IFsgLWggIiRTX0ZQIiBdOyB0aGVuCiAgICAgICAgICAgICAgICBlY2hvICJU" >> $S_FP_ASCII
    echo "aGUgc3ltbGluayB0byBhbiBleGlzdGluZyBmb2xkZXIgIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlbHNlCiAgICAgICAgICAgICAgICBlY2hvICJUaGUgZm9sZGVyICIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgZmkKICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAgICBl" >> $S_FP_ASCII
    echo "Y2hvICIgICAgJFNfRlAgIgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIHByaW50ZiAiZXhpc3RzLCBidXQgIgogICAgICAgICAgICBpZiBbICIk" >> $S_FP_ASCII
    echo "U0JfT1BUSU9OQUxfQkFOX1NZTUxJTktTIiA9PSAidCIgXTsgdGhlbgogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgZWNobyAiYSBmaWxlIGlzIGV4cGVjdGVkLiIKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgZWxzZQogICAgICAgICAgICAgICAgZWNobyAiYSBmaWxlIG9yIGEg" >> $S_FP_ASCII
    echo "c3ltbGluayB0byBhIGZpbGUgaXMgZXhwZWN0ZWQuIgogICAgICAgICAgICBm" >> $S_FP_ASCII
    echo "aQogICAgICAgICAgICBlY2hvICJTX0dVSURfQ0FORElEQVRFPT1cIiRTX0dV" >> $S_FP_ASCII
    echo "SURfQ0FORElEQVRFXCIiCiAgICAgICAgICAgIGVjaG8gIkdVSUQ9PSc0YzY1" >> $S_FP_ASCII
    echo "MWEyMS1kNGMyLTQ3NzItYTYxNy03MTkxMTExMTU2ZTcnIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIiCiAgICAgICAgICAgICMtLS0tLS0tLQogICAgICAgICAgICBj" >> $S_FP_ASCII
    echo "ZCAiJFNfRlBfT1JJRyIKICAgICAgICAgICAgZXhpdCAxICMgZXhpdGluZyB3" >> $S_FP_ASCII
    echo "aXRoIGFuIGVycm9yCiAgICAgICAgZWxzZQogICAgICAgICAgICBpZiBbICIk" >> $S_FP_ASCII
    echo "U0JfT1BUSU9OQUxfQkFOX1NZTUxJTktTIiA9PSAidCIgXTsgdGhlbgogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgaWYgWyAtaCAiJFNfRlAiIF07IHRoZW4gCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IlRoZSAiCiAgICAgICAgICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgIGVjaG8gIiAgICAkU19GUCIKICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIiCiAgICAgICAgICAgICAgICAgICAgZWNobyAiaXMgYSBzeW1s" >> $S_FP_ASCII
    echo "aW5rIHRvIGEgZmlsZSwgYnV0IGEgZmlsZSBpcyBleHBlY3RlZC4iCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgZWNobyAiU19HVUlEX0NBTkRJREFURT09XCIkU19H" >> $S_FP_ASCII
    echo "VUlEX0NBTkRJREFURVwiIgogICAgICAgICAgICAgICAgICAgIGVjaG8gIkdV" >> $S_FP_ASCII
    echo "SUQ9PSdlNTk2OGQyZC0zMjRlLTRmMzctYTg1Ny03MTkxMTExMTU2ZTcnIgog" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgIGVjaG8gIiIKICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAjLS0tLS0tLS0KICAgICAgICAgICAgICAgICAgICBjZCAiJFNfRlBfT1JJ" >> $S_FP_ASCII
    echo "RyIKICAgICAgICAgICAgICAgICAgICBleGl0IDEgIyBleGl0aW5nIHdpdGgg" >> $S_FP_ASCII
    echo "YW4gZXJyb3IKICAgICAgICAgICAgICAgIGZpCiAgICAgICAgICAgIGZpCiAg" >> $S_FP_ASCII
    echo "ICAgICAgZmkKICAgIGZpCn0gIyBmdW5jX21tbXZfYXNzZXJ0X2ZpbGVfZXhp" >> $S_FP_ASCII
    echo "c3RzX3QxCgojLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCmZ1bmNf" >> $S_FP_ASCII
    echo "bW1tdl9hc3NlcnRfZm9sZGVyX2V4aXN0c190MSgpIHsKICAgIGxvY2FsIFNf" >> $S_FP_ASCII
    echo "RlA9IiQxIgogICAgbG9jYWwgU19HVUlEX0NBTkRJREFURT0iJDIiCiAgICBs" >> $S_FP_ASCII
    echo "b2NhbCBTQl9PUFRJT05BTF9CQU5fU1lNTElOS1M9IiQzIiAjIGRvbWFpbjog" >> $S_FP_ASCII
    echo "eyJ0IiwgImYiLCAiIn0gZGVmYXVsdDogImYiCiAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAjIGlzIHRoZSBsYXN0IGZvcm1hbCBw" >> $S_FP_ASCII
    echo "YXJhbWV0ZXIgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAjIGluIHN0ZWFkIG9mIHRoZSBTX0dVSURfQ0FORElEQVRFLCAKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICMgYmVjYXVz" >> $S_FP_ASCII
    echo "ZSB0aGF0IHdheSB0aGlzIGZ1bmN0aW9uIGlzIAogICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgIyBiYWNrd2FyZHMgY29tcGF0aWJs" >> $S_FP_ASCII
    echo "ZSB3aXRoIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIyBhbiBlYXJsaWVyIHZlcnNpb24gb2YgdGhpcyAKICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICMgZnVuY3Rpb24uCiAgICAj" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAgICBsb2NhbCBTQl9M" >> $S_FP_ASCII
    echo "QUNLX09GX1BBUkFNRVRFUlM9ImYiCiAgICBpZiBbICIkU19GUCIgPT0gIiIg" >> $S_FP_ASCII
    echo "XTsgdGhlbgogICAgICAgIFNCX0xBQ0tfT0ZfUEFSQU1FVEVSUz0idCIKICAg" >> $S_FP_ASCII
    echo "IGZpCiAgICBpZiBbICIkU19HVUlEX0NBTkRJREFURSIgPT0gIiIgXTsgdGhl" >> $S_FP_ASCII
    echo "bgogICAgICAgIFNCX0xBQ0tfT0ZfUEFSQU1FVEVSUz0idCIKICAgIGZpCiAg" >> $S_FP_ASCII
    echo "ICBpZiBbICIkU0JfTEFDS19PRl9QQVJBTUVURVJTIiA9PSAidCIgXTsgdGhl" >> $S_FP_ASCII
    echo "bgogICAgICAgIGVjaG8gIiIKICAgICAgICBlY2hvICJUaGUgY29kZSB0aGF0" >> $S_FP_ASCII
    echo "IGNhbGxzIHRoaXMgZnVuY3Rpb24gaXMgZmxhd2VkLiIKICAgICAgICBlY2hv" >> $S_FP_ASCII
    echo "ICJUaGlzIGZ1bmN0aW9uIHJlcXVpcmVzIDIgcGFyYW1ldGVycywgd2hpY2gg" >> $S_FP_ASCII
    echo "YXJlICIKICAgICAgICBlY2hvICJTX0ZQLCBTX0dVSURfQ0FORElEQVRFLCBh" >> $S_FP_ASCII
    echo "bmQgaXQgaGFzIGFuIG9wdGlvbmFsIDMuIHBhcmFtZXRlciwgIgogICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIndoaWNoIGlzIFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUy4iCiAg" >> $S_FP_ASCII
    echo "ICAgICAgaWYgWyAiJFNfR1VJRF9DQU5ESURBVEUiICE9ICIiIF07IHRoZW4K" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgZWNobyAiU19HVUlEX0NBTkRJREFURT09JyRTX0dVSURf" >> $S_FP_ASCII
    echo "Q0FORElEQVRFJyIKICAgICAgICBmaQogICAgICAgIGVjaG8gIkdVSUQ9PSc1" >> $S_FP_ASCII
    echo "MzdlMzdjNS1iMWY5LTQ3NzYtOGM1Ni03MTkxMTExMTU2ZTcnIgogICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiIKICAgICAgICAjLS0tLS0tLS0KICAgICAgICBjZCAiJFNfRlBf" >> $S_FP_ASCII
    echo "T1JJRyIKICAgICAgICBleGl0IDEgIyBleGl0aW5nIHdpdGggYW4gZXJyb3IK" >> $S_FP_ASCII
    echo "ICAgIGVsc2UKICAgICAgICBpZiBbICIkU0JfTEFDS19PRl9QQVJBTUVURVJT" >> $S_FP_ASCII
    echo "IiAhPSAiZiIgXTsgdGhlbgogICAgICAgICAgICBlY2hvICJUaGlzIGNvZGUg" >> $S_FP_ASCII
    echo "aXMgZmxhd2VkLiIKICAgICAgICAgICAgZWNobyAiR1VJRD09JzNiM2YwNmQ0" >> $S_FP_ASCII
    echo "LTYyYjQtNDQ2Yy04ZDI2LTcxOTExMTExNTZlNyciCiAgICAgICAgICAgICMt" >> $S_FP_ASCII
    echo "LS0tLS0tLQogICAgICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgZXhpdCAxICMgZXhpdGluZyB3aXRoIGFuIGVycm9yCiAgICAgICAgZmkK" >> $S_FP_ASCII
    echo "ICAgIGZpCiAgICAjLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tCiAg" >> $S_FP_ASCII
    echo "ICBpZiBbICIkU0JfT1BUSU9OQUxfQkFOX1NZTUxJTktTIiA9PSAiIiBdOyB0" >> $S_FP_ASCII
    echo "aGVuCiAgICAgICAgIyBUaGUgZGVmYXVsdCB2YWx1ZSBvZiB0aGUgCiAgICAg" >> $S_FP_ASCII
    echo "ICAgU0JfT1BUSU9OQUxfQkFOX1NZTUxJTktTPSJmIgogICAgICAgICMgbXVz" >> $S_FP_ASCII
    echo "dCBiZSBiYWNrd2FyZHMgY29tcGF0aWJsZSB3aXRoIHRoZQogICAgICAgICMg" >> $S_FP_ASCII
    echo "dmVyc2lvbiBvZiB0aGlzIGZ1bmN0aW9uLCB3aGVyZSAKICAgICAgICAjIHN5" >> $S_FP_ASCII
    echo "bWxpbmtzIHRvIGZvbGRlcnMgd2VyZSB0cmVhdGVkIGFzIGFjdHVhbCBmb2xk" >> $S_FP_ASCII
    echo "ZXJzLgogICAgZWxzZQogICAgICAgIGlmIFsgIiRTQl9PUFRJT05BTF9CQU5f" >> $S_FP_ASCII
    echo "U1lNTElOS1MiICE9ICJ0IiBdOyB0aGVuCiAgICAgICAgICAgIGlmIFsgIiRT" >> $S_FP_ASCII
    echo "Ql9PUFRJT05BTF9CQU5fU1lNTElOS1MiICE9ICJmIiBdOyB0aGVuCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgICAgICBlY2hvICJUaGUg" >> $S_FP_ASCII
    echo "IgogICAgICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAgICAgICAgZWNo" >> $S_FP_ASCII
    echo "byAiICAgIFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUz09XCIkU0JfT1BUSU9O" >> $S_FP_ASCII
    echo "QUxfQkFOX1NZTUxJTktTXCIiCiAgICAgICAgICAgICAgICBlY2hvICIiCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICBlY2hvICJidXQgdGhlIHZhbGlkIHZhbHVlcyBmb3Ig" >> $S_FP_ASCII
    echo "dGhlIFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUyIKICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gImFyZTogXCJ0XCIsIFwiZlwiLCBcIlwiLiIKICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gIlNfR1VJRF9DQU5ESURBVEU9PSckU19HVUlEX0NBTkRJREFU" >> $S_FP_ASCII
    echo "RSciCiAgICAgICAgICAgICAgICBlY2hvICJHVUlEPT0nMzkyNTI4MTYtYTZh" >> $S_FP_ASCII
    echo "MS00NmE3LTg3NDYtNzE5MTExMTE1NmU3JyIKICAgICAgICAgICAgICAgIGVj" >> $S_FP_ASCII
    echo "aG8gIiIKICAgICAgICAgICAgICAgICMtLS0tLS0tLQogICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgICAgICAgICBleGl0IDEgIyBl" >> $S_FP_ASCII
    echo "eGl0aW5nIHdpdGggYW4gZXJyb3IKICAgICAgICAgICAgZmkKICAgICAgICBm" >> $S_FP_ASCII
    echo "aQogICAgZmkKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0K" >> $S_FP_ASCII
    echo "ICAgIGlmIFsgISAtZSAiJFNfRlAiIF07IHRoZW4KICAgICAgICBpZiBbIC1o" >> $S_FP_ASCII
    echo "ICIkU19GUCIgXTsgdGhlbgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gIlRoZSBwYXRoICIKICAgICAgICAgICAgZWNobyAiIgogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICIgICAgJFNfRlAgIgogICAgICAgICAgICBlY2hvICIi" >> $S_FP_ASCII
    echo "CiAgICAgICAgICAgIGVjaG8gInBvaW50cyB0byBhIGJyb2tlbiBzeW1saW5r" >> $S_FP_ASCII
    echo "LCBidXQgIgogICAgICAgICAgICBpZiBbICIkU0JfT1BUSU9OQUxfQkFOX1NZ" >> $S_FP_ASCII
    echo "TUxJTktTIiA9PSAidCIgXTsgdGhlbgogICAgICAgICAgICAgICAgZWNobyAi" >> $S_FP_ASCII
    echo "YSBmb2xkZXIgaXMgZXhwZWN0ZWQuIgogICAgICAgICAgICBlbHNlCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBlY2hvICJhIGZvbGRlciBvciBhIHN5bWxpbmsgdG8gYSBm" >> $S_FP_ASCII
    echo "b2xkZXIgaXMgZXhwZWN0ZWQuIgogICAgICAgICAgICBmaQogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICJTX0dVSURfQ0FORElEQVRFPT1cIiRTX0dVSURfQ0FORElEQVRF" >> $S_FP_ASCII
    echo "XCIiCiAgICAgICAgICAgIGVjaG8gIkdVSUQ9PSczOTRkMGRlOS00NTRmLTQ0" >> $S_FP_ASCII
    echo "YmUtYmQxNi03MTkxMTExMTU2ZTcnIgogICAgICAgICAgICBlY2hvICIiCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICMtLS0tLS0tLQogICAgICAgICAgICBjZCAiJFNfRlBfT1JJ" >> $S_FP_ASCII
    echo "RyIKICAgICAgICAgICAgZXhpdCAxICMgZXhpdGluZyB3aXRoIGFuIGVycm9y" >> $S_FP_ASCII
    echo "CiAgICAgICAgZWxzZQogICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGlmIFsgIiRTQl9PUFRJT05BTF9CQU5fU1lNTElOS1MiID09ICJ0IiBdOyB0" >> $S_FP_ASCII
    echo "aGVuCiAgICAgICAgICAgICAgICBlY2hvICJUaGUgZm9sZGVyICIKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgZWxzZQogICAgICAgICAgICAgICAgZWNobyAiVGhlIGZvbGRlciBv" >> $S_FP_ASCII
    echo "ciBhIHN5bWxpbmsgdG8gYSBmb2xkZXIgIgogICAgICAgICAgICBmaQogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICIiCiAgICAgICAgICAgIGVjaG8gIiAgICAkU19GUCAi" >> $S_FP_ASCII
    echo "CiAgICAgICAgICAgIGVjaG8gIiIKICAgICAgICAgICAgZWNobyAiZG9lcyBu" >> $S_FP_ASCII
    echo "b3QgZXhpc3QuIgogICAgICAgICAgICBlY2hvICJTX0dVSURfQ0FORElEQVRF" >> $S_FP_ASCII
    echo "PT1cIiRTX0dVSURfQ0FORElEQVRFXCIiCiAgICAgICAgICAgIGVjaG8gIkdV" >> $S_FP_ASCII
    echo "SUQ9PScxNmMxZTIzNC00N2FkLTRlYTItOWYzNi03MTkxMTExMTU2ZTcnIgog" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgICMtLS0tLS0tLQogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAgICAgICAgICAgZXhpdCAxICMg" >> $S_FP_ASCII
    echo "ZXhpdGluZyB3aXRoIGFuIGVycm9yCiAgICAgICAgZmkKICAgIGVsc2UKICAg" >> $S_FP_ASCII
    echo "ICAgICBpZiBbICEgLWQgIiRTX0ZQIiBdOyB0aGVuCiAgICAgICAgICAgIGVj" >> $S_FP_ASCII
    echo "aG8gIiIKICAgICAgICAgICAgaWYgWyAtaCAiJFNfRlAiIF07IHRoZW4KICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgIGVjaG8gIlRoZSBzeW1saW5rIHRvIGFuIGV4aXN0aW5n" >> $S_FP_ASCII
    echo "IGZpbGUgIgogICAgICAgICAgICBlbHNlCiAgICAgICAgICAgICAgICBlY2hv" >> $S_FP_ASCII
    echo "ICJUaGUgZmlsZSAiCiAgICAgICAgICAgIGZpCiAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiIKICAgICAgICAgICAgZWNobyAiICAgICRTX0ZQICIKICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ZWNobyAiIgogICAgICAgICAgICBwcmludGYgImV4aXN0cywgYnV0ICIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgaWYgWyAiJFNCX09QVElPTkFMX0JBTl9TWU1MSU5LUyIgPT0g" >> $S_FP_ASCII
    echo "InQiIF07IHRoZW4KICAgICAgICAgICAgICAgIGVjaG8gImEgZm9sZGVyIGlz" >> $S_FP_ASCII
    echo "IGV4cGVjdGVkLiIKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ZWNobyAiYSBmb2xkZXIgb3IgYSBzeW1saW5rIHRvIGEgZm9sZGVyIGlzIGV4" >> $S_FP_ASCII
    echo "cGVjdGVkLiIKICAgICAgICAgICAgZmkKICAgICAgICAgICAgZWNobyAiU19H" >> $S_FP_ASCII
    echo "VUlEX0NBTkRJREFURT09XCIkU19HVUlEX0NBTkRJREFURVwiIgogICAgICAg" >> $S_FP_ASCII
    echo "ICAgICBlY2hvICJHVUlEPT0nM2Y0Mjg3ZTItNDgzYi00Mjg1LWJmNDYtNzE5" >> $S_FP_ASCII
    echo "MTExMTE1NmU3JyIKICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAgICAj" >> $S_FP_ASCII
    echo "LS0tLS0tLS0KICAgICAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGV4aXQgMSAjIGV4aXRpbmcgd2l0aCBhbiBlcnJvcgogICAgICAgIGVs" >> $S_FP_ASCII
    echo "c2UKICAgICAgICAgICAgaWYgWyAiJFNCX09QVElPTkFMX0JBTl9TWU1MSU5L" >> $S_FP_ASCII
    echo "UyIgPT0gInQiIF07IHRoZW4KICAgICAgICAgICAgICAgIGlmIFsgLWggIiRT" >> $S_FP_ASCII
    echo "X0ZQIiBdOyB0aGVuIAogICAgICAgICAgICAgICAgICAgIGVjaG8gIiIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICBlY2hvICJUaGUgIgogICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gIiIKICAgICAgICAgICAgICAgICAgICBlY2hvICIgICAgJFNf" >> $S_FP_ASCII
    echo "RlAiCiAgICAgICAgICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gImlzIGEgc3ltbGluayB0byBhIGZvbGRlciwgYnV0IGEg" >> $S_FP_ASCII
    echo "Zm9sZGVyIGlzIGV4cGVjdGVkLiIKICAgICAgICAgICAgICAgICAgICBlY2hv" >> $S_FP_ASCII
    echo "ICJTX0dVSURfQ0FORElEQVRFPT1cIiRTX0dVSURfQ0FORElEQVRFXCIiCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgZWNobyAiR1VJRD09JzJjZmY0Y2Q1LWVhMmUt" >> $S_FP_ASCII
    echo "NDU1YS04NTI2LTcxOTExMTExNTZlNyciCiAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ZWNobyAiIgogICAgICAgICAgICAgICAgICAgICMtLS0tLS0tLQogICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgIGNkICIkU19GUF9PUklHIgogICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGV4aXQgMSAjIGV4aXRpbmcgd2l0aCBhbiBlcnJvcgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgZmkKICAgICAgICAgICAgZmkKICAgICAgICBmaQogICAgZmkKfSAj" >> $S_FP_ASCII
    echo "IGZ1bmNfbW1tdl9hc3NlcnRfZm9sZGVyX2V4aXN0c190MQoKIy0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tClNfVE1QXzA9ImB1bmFtZSAtYSB8IGdy" >> $S_FP_ASCII
    echo "ZXAgLUUgW0xsXWludXhgIgppZiBbICIkU19UTVBfMCIgPT0gIiIgXTsgdGhl" >> $S_FP_ASCII
    echo "bgogICAgU19UTVBfMD0iYHVuYW1lIC1hIHwgZ3JlcCAtRSBbQmJdW1NzXVtE" >> $S_FP_ASCII
    echo "ZF1gIgogICAgaWYgWyAiJFNfVE1QXzAiID09ICIiIF07IHRoZW4KICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIiCiAgICAgICAgZWNobyAiICBUaGUgY2xhc3NpY2FsIGNvbW1h" >> $S_FP_ASCII
    echo "bmQgbGluZSB1dGlsaXRpZXMgYXQgIgogICAgICAgIGVjaG8gIiAgZGlmZmVy" >> $S_FP_ASCII
    echo "ZW50IG9wZXJhdGluZyBzeXN0ZW1zLCBmb3IgZXhhbXBsZSwgTGludXggYW5k" >> $S_FP_ASCII
    echo "IEJTRCwiCiAgICAgICAgZWNobyAiICBkaWZmZXIuIFRoaXMgc2NyaXB0IGlz" >> $S_FP_ASCII
    echo "IGRlc2lnbmVkIHRvIHJ1biBvbmx5IG9uIExpbnV4IGFuZCBCU0QuIgogICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gIiAgSWYgWW91IGFyZSB3aWxsaW5nIHRvIHJpc2sgdGhhdCBz" >> $S_FP_ASCII
    echo "b21lIG9mIFlvdXIgZGF0YSAiCiAgICAgICAgZWNobyAiICBpcyBkZWxldGVk" >> $S_FP_ASCII
    echo "IGFuZC9vciBZb3VyIG9wZXJhdGluZyBzeXN0ZW0gaW5zdGFuY2UiCiAgICAg" >> $S_FP_ASCII
    echo "ICAgZWNobyAiICBiZWNvbWVzIHBlcm1hbmVudGx5IGZsYXdlZCwgdG8gdGhl" >> $S_FP_ASCII
    echo "IHBvaW50IHRoYXQgIgogICAgICAgIGVjaG8gIiAgaXQgd2lsbCBub3QgZXZl" >> $S_FP_ASCII
    echo "biBib290LCB0aGVuIFlvdSBtYXkgZWRpdCB0aGUgQmFzaCBzY3JpcHQgdGhh" >> $S_FP_ASCII
    echo "dCAiCiAgICAgICAgZWNobyAiICBkaXNwbGF5cyB0aGlzIGVycm9yIG1lc3Nh" >> $S_FP_ASCII
    echo "Z2UgYnkgbW9kaWZ5aW5nIHRoZSB0ZXN0IHRoYXQgIgogICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiAgY2hlY2tzIGZvciB0aGUgb3BlcmF0aW5nIHN5c3RlbSB0eXBlLiIKICAg" >> $S_FP_ASCII
    echo "ICAgICBlY2hvICIiCiAgICAgICAgZWNobyAiICBJZiBZb3UgZG8gZGVjaWRl" >> $S_FP_ASCII
    echo "IHRvIGVkaXQgdGhpcyBCYXNoIHNjcmlwdCwgdGhlbiAiCiAgICAgICAgZWNo" >> $S_FP_ASCII
    echo "byAiICBhIHJlY29tbWVuZGF0aW9uIGlzIHRvIHRlc3QgWW91ciBtb2RpZmlj" >> $S_FP_ASCII
    echo "YXRpb25zICIKICAgICAgICBlY2hvICIgIHdpdGhpbiBhIHZpcnR1YWwgbWFj" >> $S_FP_ASCII
    echo "aGluZSBvciwgaWYgdmlydHVhbCBtYWNoaW5lcyBhcmUgbm90IgogICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiAgYW4gb3B0aW9uLCBhcyBzb21lIG5ldyBvcGVyYXRpbmcgc3lz" >> $S_FP_ASCII
    echo "dGVtIHVzZXIgdGhhdCBkb2VzIG5vdCBoYXZlICIKICAgICAgICBlY2hvICIg" >> $S_FP_ASCII
    echo "IGFueSBhY2Nlc3MgdG8gdGhlIHZpdGFsIGRhdGEvZmlsZXMuIgogICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiAgR1VJRD09JzI2ODE5MzMyLTBkYzMtNGM4Yi1hOTU2LTcxOTEx" >> $S_FP_ASCII
    echo "MTExNTZlNyciCiAgICAgICAgZWNobyAiIgogICAgICAgIGVjaG8gIiAgQWJv" >> $S_FP_ASCII
    echo "cnRpbmcgc2NyaXB0IHdpdGhvdXQgZG9pbmcgYW55dGhpbmcuIgogICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiIKICAgICAgICBlY2hvICJHVUlEPT0nNDdjN2ZjMzUtYzIyMS00" >> $S_FP_ASCII
    echo "MmYzLThkNTYtNzE5MTExMTE1NmU3JyIKICAgICAgICBlY2hvICIiCiAgICAg" >> $S_FP_ASCII
    echo "ICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgZXhpdCAxICMgZXhpdCB3aXRo" >> $S_FP_ASCII
    echo "IGFuIGVycm9yCiAgICBmaQpmaQoKIy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tClNfVElNRVNUQU1QPSJgZGF0ZSArJVlgX2BkYXRlICslbWBfYGRh" >> $S_FP_ASCII
    echo "dGUgKyVkYF9UX2BkYXRlICslSGBoX2BkYXRlICslTWBtaW5fYGRhdGUgKyVT" >> $S_FP_ASCII
    echo "YHMiClNfRlBfQVJDSElWRT0iJFNfRlBfRElSL2FyY2hpdmVzLyRTX1RJTUVT" >> $S_FP_ASCII
    echo "VEFNUCIKU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVM9IiRTX0ZQX0RJUi90" >> $S_FP_ASCII
    echo "aGVfcmVwb3NpdG9yeV9jbG9uZXMiClNfRk5fVEhFX1JFUE9TSVRPUllfQ0xP" >> $S_FP_ASCII
    echo "TkVTPSJgYmFzZW5hbWUgXCIkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVNc" >> $S_FP_ASCII
    echo "ImAiClNfVE1QXzA9Ii50YXIiClNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVT" >> $S_FP_ASCII
    echo "X1RBUj0iJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTJFNfVE1QXzAiClNf" >> $S_FP_ASCII
    echo "Rk5fVEhFX1JFUE9TSVRPUllfQ0xPTkVTX1RBUj0iYGJhc2VuYW1lIFwiJFNf" >> $S_FP_ASCII
    echo "RlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTX1RBUlwiYCIKCiMtLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLQpTX0FSR1ZfMD0iJDEiClNCX1NLSVBfQVJD" >> $S_FP_ASCII
    echo "SElWSU5HPSJmIgpTQl9SVU5fR0lUX0dBUkJBR0VfQ09MTEVDVE9SX09OX0xP" >> $S_FP_ASCII
    echo "Q0FMX0dJVF9SRVBPU0lUT1JZPSJmIgpTQl9SVU5fVVBEQVRFPSJmIgpTQl9J" >> $S_FP_ASCII
    echo "TlZBTElEX0NPTU1BTkRfTElORV9BUkdVTUVOVFM9InQiCgpmdW5fZGlzcGxh" >> $S_FP_ASCII
    echo "eV9oZWxwX3dpdGhvdXRfZXhpdGluZygpewogICAgZWNobyAiIgogICAgZWNo" >> $S_FP_ASCII
    echo "byAiQ09NTUFORF9MSU5FX0FSR1VNRU5UUyA6PT0gKCBTS0lQX0FSQ0hJVklO" >> $S_FP_ASCII
    echo "RyB8IFNLSVBfQVJDSElWSU5HX0dDIHwgIgogICAgZWNobyAiICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgfCBHQyB8IFBSUCB8IEhFTFAgfCBWRVJTSU9O" >> $S_FP_ASCII
    echo "IHwgSU5JVCB8ICIKICAgIGVjaG8gIiAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIHwgQ1JFQVRFX1RBUiApPyIKICAgIGVjaG8gIiIKICAgIGVjaG8gIiAg" >> $S_FP_ASCII
    echo "ICAgU0tJUF9BUkNISVZJTkcgICAgOj09ICdza2lwX2FyY2hpdmluZycgICAg" >> $S_FP_ASCII
    echo "ICAgfCAnc2thJyAiCiAgICBlY2hvICIgICAgIFNLSVBfQVJDSElWSU5HX0dD" >> $S_FP_ASCII
    echo "IDo9PSAnc2tpcF9hcmNoaXZpbmdfZ2MnICAgIHwgJ3NrYV9nYycgfCAnc2th" >> $S_FP_ASCII
    echo "Z2MnIgogICAgZWNobyAiICAgICAgICAgICAgICAgICAgICBHQyA6PT0gJ3J1" >> $S_FP_ASCII
    echo "bl9nYXJiYWdlX2NvbGxlY3Rvcid8ICdydW5fZ2MnIHwgICAgJ2djJyIKICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiAgICAgICAgICAgICAgICAgICBQUlAgOj09ICdwcmludF91cHN0" >> $S_FP_ASCII
    echo "cmVhbV9yZXBvc2l0b3J5X3BhdGgnIHwgJ3BycCcgIgogICAgZWNobyAiICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgSEVMUCA6PT0gJ2hlbHAnICAgIHwgJy1oZWxwJyAg" >> $S_FP_ASCII
    echo "ICB8ICctaCcgfCAnLT8nICIKICAgIGVjaG8gIiAgICAgICAgICAgICAgIFZF" >> $S_FP_ASCII
    echo "UlNJT04gOj09ICd2ZXJzaW9uJyB8ICctdmVyc2lvbicgfCAnLXYnICIKICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiAgICAgICAgICAgICAgICAgIElOSVQgOj09ICdpbml0JyAiCiAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIgICAgICAgICAgICBDUkVBVEVfVEFSIDo9PSAnY3JlYXRlX3Rh" >> $S_FP_ASCII
    echo "cicgfCAndGFyJyAgIgogICAgZWNobyAiIgp9ICMgZnVuX2Rpc3BsYXlfaGVs" >> $S_FP_ASCII
    echo "cF93aXRob3V0X2V4aXRpbmcKCgpmdW5faWZfbmVlZGVkX2Rpc3BsYXlfaGVs" >> $S_FP_ASCII
    echo "cF9hbmRfZXhpdF93aXRoX2Vycm9yX2NvZGVfMCgpewogICAgbG9jYWwgU19F" >> $S_FP_ASCII
    echo "UlJPUl9DT0RFX0lGCiAgICAjLS0tLS0tLS0KICAgIGxvY2FsIFNCX0RJU1BM" >> $S_FP_ASCII
    echo "QVlfSEVMUF9BTkRfRVhJVD0iZiIgIyAiZiIgZm9yICJmYWxzZSIsICJ0IiBm" >> $S_FP_ASCII
    echo "b3IgInRydWUiCiAgICBsb2NhbCBBUl8wPSgiaGVscCIgIi1oZWxwIiAiLS1o" >> $S_FP_ASCII
    echo "ZWxwIiBcCiAgICAgICAgICAgICAgICAiXCJoZWxwXCIiICInaGVscCciIFwK" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICJcIi1oZWxwXCIiICInLWhlbHAnIiBcCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAiXCItLWhlbHBcIiIgIictLWhlbHAnIiBcCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAiaCIgIlwiaFwiIiAiJ2gnIiBcCiAgICAgICAgICAgICAgICAi" >> $S_FP_ASCII
    echo "LWgiICJcIi1oXCIiICInLWgnIiBcCiAgICAgICAgICAgICAgICAiPyIgIlwi" >> $S_FP_ASCII
    echo "P1wiIiAiJz8nIiBcCiAgICAgICAgICAgICAgICAiLT8iICJcIi0/XCIiICIn" >> $S_FP_ASCII
    echo "LT8nIiBcCiAgICAgICAgICAgICAgICAiYWJpIiAiXCJhYmlcIiIgIidhYmkn" >> $S_FP_ASCII
    echo "IiBcCiAgICAgICAgICAgICAgICAiLWFiaSIgIlwiLWFiaVwiIiAiJy1hYmkn" >> $S_FP_ASCII
    echo "IiBcCiAgICAgICAgICAgICAgICAiLS1hYmkiICJcIi0tYWJpXCIiICInLS1h" >> $S_FP_ASCII
    echo "YmknIiBcCiAgICAgICAgICAgICAgICAiYXB1YSIgIlwiYXB1YVwiIiAiJ2Fw" >> $S_FP_ASCII
    echo "dWEnIiBcCiAgICAgICAgICAgICAgICAiLWFwdWEiICJcIi1hcHVhXCIiICIn" >> $S_FP_ASCII
    echo "LWFwdWEnIiBcCiAgICAgICAgICAgICAgICAiLS1hcHVhIiAiXCItLWFwdWFc" >> $S_FP_ASCII
    echo "IiIgIictLWFwdWEnIiBcCiAgICAgICAgICAgICAgICApCiAgICBmb3IgU19J" >> $S_FP_ASCII
    echo "VEVSIGluICR7QVJfMFtAXX07IGRvCiAgICAgICAgaWYgWyAiJFNfQVJHVl8w" >> $S_FP_ASCII
    echo "IiA9PSAiJFNfSVRFUiIgXTsgdGhlbiAKICAgICAgICAgICAgU0JfRElTUExB" >> $S_FP_ASCII
    echo "WV9IRUxQX0FORF9FWElUPSJ0IgogICAgICAgICAgICBTQl9JTlZBTElEX0NP" >> $S_FP_ASCII
    echo "TU1BTkRfTElORV9BUkdVTUVOVFM9ImYiCiAgICAgICAgZmkKICAgIGRvbmUK" >> $S_FP_ASCII
    echo "ICAgICMtLS0tLS0tLQogICAgaWYgWyAiJFNCX0RJU1BMQVlfSEVMUF9BTkRf" >> $S_FP_ASCII
    echo "RVhJVCIgPT0gInQiIF07IHRoZW4gCiAgICAgICAgZnVuX2Rpc3BsYXlfaGVs" >> $S_FP_ASCII
    echo "cF93aXRob3V0X2V4aXRpbmcKICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAg" >> $S_FP_ASCII
    echo "ICAgICBleGl0IDAgIyBleGl0IHdpdGhvdXQgYW55IGVycm9ycwogICAgZWxz" >> $S_FP_ASCII
    echo "ZQogICAgICAgIGlmIFsgIiRTQl9ESVNQTEFZX0hFTFBfQU5EX0VYSVQiICE9" >> $S_FP_ASCII
    echo "ICJmIiBdOyB0aGVuIAogICAgICAgICAgICBmdW5fZXhjX2V4aXRfd2l0aF9h" >> $S_FP_ASCII
    echo "bl9lcnJvcl90MSAiNTg2NmNmNTMtMDQ2OC00MmUzLWFkNTctNzE5MTExMTE1" >> $S_FP_ASCII
    echo "NmU3IgogICAgICAgIGZpCiAgICBmaQp9ICMgZnVuX2lmX25lZWRlZF9kaXNw" >> $S_FP_ASCII
    echo "bGF5X2hlbHBfYW5kX2V4aXRfd2l0aF9lcnJvcl9jb2RlXzAKZnVuX2lmX25l" >> $S_FP_ASCII
    echo "ZWRlZF9kaXNwbGF5X2hlbHBfYW5kX2V4aXRfd2l0aF9lcnJvcl9jb2RlXzAK" >> $S_FP_ASCII
    echo "CgojLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpmdW5faWZfbmVlZGVk" >> $S_FP_ASCII
    echo "X2Rpc3BsYXlfdmVyc2lvbl9hbmRfZXhpdF93aXRoX2FuX2Vycm9yX2NvZGVf" >> $S_FP_ASCII
    echo "MCgpewogICAgIy0tLS0tLS0tCiAgICBsb2NhbCBTQl9ESVNQTEFZX1ZFUlNJ" >> $S_FP_ASCII
    echo "T05fQU5EX0VYSVQ9ImYiICMgImYiIGZvciAiZmFsc2UiLCAidCIgZm9yICJ0" >> $S_FP_ASCII
    echo "cnVlIgogICAgbG9jYWwgQVJfMD0oInZlcnNpb29uIiAiLXZlcnNpb29uIiAi" >> $S_FP_ASCII
    echo "LS12ZXJzaW9vbiIgXAogICAgICAgICAgICAgICAgIi12IiAidiIgXAogICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgInZlcnNpb24iICItdmVyc2lvbiIgICItLXZlcnNpb24i" >> $S_FP_ASCII
    echo "IFwKICAgICAgICAgICAgICAgICJ2ZXJzaW8iICItdmVyc2lvIiAiLS12ZXJz" >> $S_FP_ASCII
    echo "aW8iKQogICAgZm9yIFNfSVRFUiBpbiAke0FSXzBbQF19OyBkbwogICAgICAg" >> $S_FP_ASCII
    echo "IGlmIFsgIiRTX0FSR1ZfMCIgPT0gIiRTX0lURVIiIF07IHRoZW4gCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIFNCX0RJU1BMQVlfVkVSU0lPTl9BTkRfRVhJVD0idCIKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgU0JfSU5WQUxJRF9DT01NQU5EX0xJTkVfQVJHVU1FTlRTPSJmIgog" >> $S_FP_ASCII
    echo "ICAgICAgIGZpCiAgICBkb25lCiAgICAjLS0tLS0tLS0KICAgIGlmIFsgIiRT" >> $S_FP_ASCII
    echo "Ql9ESVNQTEFZX1ZFUlNJT05fQU5EX0VYSVQiID09ICJ0IiBdOyB0aGVuIAog" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gIiIKICAgICAgICBlY2hvICIgICAgU19WRVJTSU9OX09G" >> $S_FP_ASCII
    echo "X1RISVNfU0NSSVBUID09IFwiJFNfVkVSU0lPTl9PRl9USElTX1NDUklQVFwi" >> $S_FP_ASCII
    echo "IgogICAgICAgIGVjaG8gIiIKICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAg" >> $S_FP_ASCII
    echo "ICAgICBleGl0IDAgIyBleGl0IHdpdGhvdXQgYW55IGVycm9ycwogICAgZWxz" >> $S_FP_ASCII
    echo "ZQogICAgICAgIGlmIFsgIiRTQl9ESVNQTEFZX1ZFUlNJT05fQU5EX0VYSVQi" >> $S_FP_ASCII
    echo "ICE9ICJmIiBdOyB0aGVuIAogICAgICAgICAgICBmdW5fZXhjX2V4aXRfd2l0" >> $S_FP_ASCII
    echo "aF9hbl9lcnJvcl90MSAiNWFlZjI4NDMtZDI0ZC00NTI1LTk2MTctNzE5MTEx" >> $S_FP_ASCII
    echo "MTE1NmU3IgogICAgICAgIGZpCiAgICBmaQp9ICMgZnVuX2lmX25lZWRlZF9k" >> $S_FP_ASCII
    echo "aXNwbGF5X3ZlcnNpb25fYW5kX2V4aXRfd2l0aF9hbl9lcnJvcl9jb2RlXzAK" >> $S_FP_ASCII
    echo "ZnVuX2lmX25lZWRlZF9kaXNwbGF5X3ZlcnNpb25fYW5kX2V4aXRfd2l0aF9h" >> $S_FP_ASCII
    echo "bl9lcnJvcl9jb2RlXzAKCiMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "CiMgVGhpcyBpcyBvbmUgd2F5LCBob3cgdG8gc2ltcGxpZnkgdGhlIHN0b3Jp" >> $S_FP_ASCII
    echo "bmcgb2YgdGhlIAojIAojICAgICAuL3RoZV9yZXBvc2l0b3J5X2Nsb25lcwoj" >> $S_FP_ASCII
    echo "IAojIHRvIGEgZ2l0IHJlcG9zaXRvcnkgdGhhdCBjb250YWlucyB0aGUgcGFy" >> $S_FP_ASCII
    echo "ZW50IGZvbGRlciBvZiB0aGlzIHNjcmlwdC4KIyBUaGlzIHBhcnRpYWxseSBh" >> $S_FP_ASCII
    echo "dm9pZHMgdGhlIG5lY2Vzc2l0eSB0byBkZWNsYXJlIEdpdCByZXBvc2l0b3J5" >> $S_FP_ASCII
    echo "IHN1Ym1vZHVsZXMuCmZ1bl9jb25kaXRpb25hbGx5X3VucGFja190aGVfcmVw" >> $S_FP_ASCII
    echo "b3NpdG9yeV9jbG9uZXNfdGFyKCl7CiAgICAjLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0KICAgIGZ1bmNfbW1tdl9hc3NlcnRfZmlsZV9leGlzdHNfdDEgIiRTX0ZQ" >> $S_FP_ASCII
    echo "X1RIRV9SRVBPU0lUT1JZX0NMT05FU19UQVIiIFwKICAgICAgICAiYTNhMzQw" >> $S_FP_ASCII
    echo "NGEtNTU5Yy00ZDliLWI0MjctNzE5MTExMTE1NmU3IiAidCIKICAgIGlmIFsg" >> $S_FP_ASCII
    echo "ISAtZSAiJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTIiBdOyB0aGVuCiAg" >> $S_FP_ASCII
    echo "ICAgICAgcHJpbnRmICJTdGFydGluZyB0byB1bnBhY2sgdGhlICRTX0ZOX1RI" >> $S_FP_ASCII
    echo "RV9SRVBPU0lUT1JZX0NMT05FU19UQVIgLi4iCiAgICAgICAgbmljZSAtbiAx" >> $S_FP_ASCII
    echo "MCB0YXIgLXhmICIkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVNfVEFSIiAK" >> $S_FP_ASCII
    echo "ICAgICAgICBmdW5jX21tbXZfYXNzZXJ0X2Vycm9yX2NvZGVfemVyb190MSAi" >> $S_FP_ASCII
    echo "JD8iIFwKICAgICAgICAgICAgIjE2M2I2ODAxLTdkOWItNGZhMS1hZjI3LTcx" >> $S_FP_ASCII
    echo "OTExMTExNTZlNyIKICAgICAgICBlY2hvICIgdW5wYWNraW5nIGNvbXBsZXRl" >> $S_FP_ASCII
    echo "LiIKICAgICAgICBmdW5jX3dhaXRfYW5kX3N5bmMKICAgICAgICBmdW5jX21t" >> $S_FP_ASCII
    echo "bXZfYXNzZXJ0X2ZvbGRlcl9leGlzdHNfdDEgIiRTX0ZQX1RIRV9SRVBPU0lU" >> $S_FP_ASCII
    echo "T1JZX0NMT05FUyIgXAogICAgICAgICAgICAiMWQyMGFjYjEtMzMwNi00YmRl" >> $S_FP_ASCII
    echo "LWJjNDctNzE5MTExMTE1NmU3IiAidCIKICAgIGZpCiAgICAjLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0KfSAjIGZ1bl9jb25kaXRpb25hbGx5X3VucGFja190aGVf" >> $S_FP_ASCII
    echo "cmVwb3NpdG9yeV9jbG9uZXNfdGFyCgojLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLQoKZnVuX2NyZWF0ZV9hX3Rhcl9maWxlX2lmX3JlcXVlc3RlZCgp" >> $S_FP_ASCII
    echo "ewogICAgIy0tLS0tLS0tLS0tLS0tLS0tLS0tCiAgICBsb2NhbCBTQl9DUkVB" >> $S_FP_ASCII
    echo "VEVfVEFSPSJmIgogICAgbG9jYWwgQVJfMD0oIi10YXIiICJ0YXIiICJjcmVh" >> $S_FP_ASCII
    echo "dGVfdGFyIikKICAgIGZvciBTX0lURVIgaW4gJHtBUl8wW0BdfTsgZG8KICAg" >> $S_FP_ASCII
    echo "ICAgICBpZiBbICIkU19BUkdWXzAiID09ICIkU19JVEVSIiBdOyB0aGVuIAog" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBTQl9DUkVBVEVfVEFSPSJ0IgogICAgICAgICAgICBTQl9J" >> $S_FP_ASCII
    echo "TlZBTElEX0NPTU1BTkRfTElORV9BUkdVTUVOVFM9ImYiCiAgICAgICAgZmkK" >> $S_FP_ASCII
    echo "ICAgIGRvbmUKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgaWYgWyAi" >> $S_FP_ASCII
    echo "JFNCX0NSRUFURV9UQVIiID09ICJ0IiBdOyB0aGVuIAogICAgICAgICMtLS0t" >> $S_FP_ASCII
    echo "LS0tLQogICAgICAgIGZ1bmNfbW1tdl9hc3NlcnRfZm9sZGVyX2V4aXN0c190" >> $S_FP_ASCII
    echo "MSBcCiAgICAgICAgICAgICIkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVMi" >> $S_FP_ASCII
    echo "IFwKICAgICAgICAgICAgIjI5NDBhMWMxLTk5MGEtNGU0NS04ZDI3LTcxOTEx" >> $S_FP_ASCII
    echo "MTExNTZlNyIgInQiCiAgICAgICAgIy0tLS0tLS0tCiAgICAgICAgbG9jYWwg" >> $S_FP_ASCII
    echo "U19UTVBfMD0iLnJlbmFtZWRfYXRfJFNfVElNRVNUQU1QIgogICAgICAgIGxv" >> $S_FP_ASCII
    echo "Y2FsIFNfRlBfVEFSX09MRD0iJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVT" >> $S_FP_ASCII
    echo "X1RBUiRTX1RNUF8wIgogICAgICAgIGxvY2FsIFNCX1JFTkFNSU5HX1JFUVVJ" >> $S_FP_ASCII
    echo "UkVEPSJmIgogICAgICAgIGlmIFsgLWUgIiRTX0ZQX1RIRV9SRVBPU0lUT1JZ" >> $S_FP_ASCII
    echo "X0NMT05FU19UQVIiIF07IHRoZW4gCiAgICAgICAgICAgIFNCX1JFTkFNSU5H" >> $S_FP_ASCII
    echo "X1JFUVVJUkVEPSJ0IgogICAgICAgICAgICBtdiAiJFNfRlBfVEhFX1JFUE9T" >> $S_FP_ASCII
    echo "SVRPUllfQ0xPTkVTX1RBUiIgIiRTX0ZQX1RBUl9PTEQiCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGZ1bmNfbW1tdl9hc3NlcnRfZXJyb3JfY29kZV96ZXJvX3QxICIkPyIgXAog" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgIjdlZjQ2Yjk0LTRjNDUtNDU0OS1iZTQ3LTcxOTEx" >> $S_FP_ASCII
    echo "MTExNTZlNyIKICAgICAgICAgICAgZnVuY193YWl0X2FuZF9zeW5jCiAgICAg" >> $S_FP_ASCII
    echo "ICAgZmkKICAgICAgICBpZiBbIC1lICIkU19GUF9USEVfUkVQT1NJVE9SWV9D" >> $S_FP_ASCII
    echo "TE9ORVNfVEFSIiBdOyB0aGVuIAogICAgICAgICAgICBlY2hvICIiCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gIlJlbmFtZWluZyBvZiB0aGUgIgogICAgICAgICAgICBl" >> $S_FP_ASCII
    echo "Y2hvICIiCiAgICAgICAgICAgIGVjaG8gIiAgICAkU19GUF9USEVfUkVQT1NJ" >> $S_FP_ASCII
    echo "VE9SWV9DTE9ORVNfVEFSIgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gInRvICIKICAgICAgICAgICAgZWNobyAiIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIgICAgJFNfRlBfVEFSX09MRCIKICAgICAgICAgICAgZWNobyAi" >> $S_FP_ASCII
    echo "IgogICAgICAgICAgICBlY2hvICJmYWlsZWQuIE5vIG5ldyB0YXIgZmlsZSBj" >> $S_FP_ASCII
    echo "cmVhdGVkLiIKICAgICAgICAgICAgZWNobyAiR1VJRD09JzdkMzQ3MjQxLTUy" >> $S_FP_ASCII
    echo "ZGEtNDQ1YS05ZTU2LTcxOTExMTExNTZlNyciCiAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiIKICAgICAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgICAgIGV4" >> $S_FP_ASCII
    echo "aXQgMSAjIGV4aXQgd2l0aCBhbiBlcnJvcgogICAgICAgIGZpCiAgICAgICAg" >> $S_FP_ASCII
    echo "Iy0tLS0tLS0tCiAgICAgICAgY2QgIiRTX0ZQX0RJUiIKICAgICAgICBmdW5j" >> $S_FP_ASCII
    echo "X21tbXZfYXNzZXJ0X2Vycm9yX2NvZGVfemVyb190MSAiJD8iIFwKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIjJjMmJiNDk2LWU5YmQtNGQxMi04NTU3LTcxOTExMTExNTZlNyIK" >> $S_FP_ASCII
    echo "ICAgICAgICBpZiBbICIkU0JfUkVOQU1JTkdfUkVRVUlSRUQiID09ICJ0IiBd" >> $S_FP_ASCII
    echo "OyB0aGVuCiAgICAgICAgICAgIHByaW50ZiAiU3RhcnRpbmcgdG8gcmVjcmVh" >> $S_FP_ASCII
    echo "dGUgdGhlICRTX0ZOX1RIRV9SRVBPU0lUT1JZX0NMT05FU19UQVIgLi4iCiAg" >> $S_FP_ASCII
    echo "ICAgICAgZWxzZQogICAgICAgICAgICBpZiBbICIkU0JfUkVOQU1JTkdfUkVR" >> $S_FP_ASCII
    echo "VUlSRUQiID09ICJmIiBdOyB0aGVuCiAgICAgICAgICAgICAgICBwcmludGYg" >> $S_FP_ASCII
    echo "IlN0YXJ0aW5nIHRvIGNyZWF0ZSB0aGUgJFNfRk5fVEhFX1JFUE9TSVRPUllf" >> $S_FP_ASCII
    echo "Q0xPTkVTX1RBUiAuLiIKICAgICAgICAgICAgZWxzZQogICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgZnVuX2V4Y19leGl0X3dpdGhfYW5fZXJyb3JfdDEgIjdkOTcxZDhiLTQ5" >> $S_FP_ASCII
    echo "NmMtNDIxNy1iNTU3LTcxOTExMTExNTZlNyIKICAgICAgICAgICAgZmkKICAg" >> $S_FP_ASCII
    echo "ICAgICBmaQogICAgICAgIG5pY2UgLW4gMTAgdGFyIC1jZiAiLi8kU19GTl9U" >> $S_FP_ASCII
    echo "SEVfUkVQT1NJVE9SWV9DTE9ORVNfVEFSIiAiLi8kU19GTl9USEVfUkVQT1NJ" >> $S_FP_ASCII
    echo "VE9SWV9DTE9ORVMiIDI+IC9kZXYvbnVsbAogICAgICAgIGZ1bmNfbW1tdl9h" >> $S_FP_ASCII
    echo "c3NlcnRfZXJyb3JfY29kZV96ZXJvX3QxICIkPyIgXAogICAgICAgICAgICAi" >> $S_FP_ASCII
    echo "NDA4N2IzYzUtMjk3ZS00YzAwLThkMjYtNzE5MTExMTE1NmU3IgogICAgICAg" >> $S_FP_ASCII
    echo "IGZ1bmNfd2FpdF9hbmRfc3luYwogICAgICAgIGVjaG8gIiB0YXItZmlsZSBj" >> $S_FP_ASCII
    echo "cmVhdGlvbiBjb21wbGV0ZS4iCiAgICAgICAgIy0tLS0tLS0tCiAgICBlbHNl" >> $S_FP_ASCII
    echo "CiAgICAgICAgaWYgWyAiJFNCX0NSRUFURV9UQVIiICE9ICJmIiBdOyB0aGVu" >> $S_FP_ASCII
    echo "IAogICAgICAgICAgICBmdW5fZXhjX2V4aXRfd2l0aF9hbl9lcnJvcl90MSAi" >> $S_FP_ASCII
    echo "MDY0OWJmNGUtNDY4MC00YjY5LTg3MjYtNzE5MTExMTE1NmU3IgogICAgICAg" >> $S_FP_ASCII
    echo "IGZpCiAgICBmaQp9ICMgZnVuX2NyZWF0ZV9hX3Rhcl9maWxlX2lmX3JlcXVl" >> $S_FP_ASCII
    echo "c3RlZApmdW5fY3JlYXRlX2FfdGFyX2ZpbGVfaWZfcmVxdWVzdGVkCgojLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpmdW5faWZfbmVlZGVkX2NyZWF0" >> $S_FP_ASCII
    echo "ZV90aGVfZm9sZGVyXzRfZG93bmxvYWRpbmdfcmVwb3NpdG9yaWVzX2FuZF9v" >> $S_FP_ASCII
    echo "cHRpb25hbGx5X2V4aXRfd2l0aF9hbl9lcnJvcl9jb2RlXzAoKXsKICAgIGxv" >> $S_FP_ASCII
    echo "Y2FsIFNCX09QVElPTkFMX1JVTl9JTklUX1JFR0FSRExFU1NfT0ZfU19BUkdW" >> $S_FP_ASCII
    echo "X1ZBTFVFX0FORF9ET19OT1RfRVhJVD0iJDEiICMgZG9tYWluIHsidCIsICJm" >> $S_FP_ASCII
    echo "IiwgIiJ9IAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIyBk" >> $S_FP_ASCII
    echo "ZWZhdWx0OiAiZiIKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgbG9j" >> $S_FP_ASCII
    echo "YWwgU0JfUlVOX0lOSVQ9ImYiCiAgICBsb2NhbCBTQl9PS19UT19FWElUX1dJ" >> $S_FP_ASCII
    echo "VEhfRVJSX0NPREVfMD0idCIgIyBkb21haW4geyJ0IiwgImYifQogICAgbG9j" >> $S_FP_ASCII
    echo "YWwgQVJfMD0oImluaXQiICItaW5pdCIgIi1pIiAiaSIgImluaXRpYWxpemUi" >> $S_FP_ASCII
    echo "ICItaW5pdGlhbGl6ZSIgIi0tdW50YXIiICItdW50YXIiICJ1bnRhciIgIi11" >> $S_FP_ASCII
    echo "dCIgInV0IikKICAgIGZvciBTX0lURVIgaW4gJHtBUl8wW0BdfTsgZG8KICAg" >> $S_FP_ASCII
    echo "ICAgICBpZiBbICIkU19BUkdWXzAiID09ICIkU19JVEVSIiBdOyB0aGVuIAog" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBTQl9SVU5fSU5JVD0idCIKICAgICAgICAgICAgU0JfSU5W" >> $S_FP_ASCII
    echo "QUxJRF9DT01NQU5EX0xJTkVfQVJHVU1FTlRTPSJmIgogICAgICAgIGZpCiAg" >> $S_FP_ASCII
    echo "ICBkb25lCiAgICAjLS0tLS0tLS0tLS0tLS0tLS0tLS0KICAgIGlmIFsgIiRT" >> $S_FP_ASCII
    echo "Ql9PUFRJT05BTF9SVU5fSU5JVF9SRUdBUkRMRVNTX09GX1NfQVJHVl9WQUxV" >> $S_FP_ASCII
    echo "RV9BTkRfRE9fTk9UX0VYSVQiID09ICIiIF07IHRoZW4gCiAgICAgICAgU0Jf" >> $S_FP_ASCII
    echo "T1BUSU9OQUxfUlVOX0lOSVRfUkVHQVJETEVTU19PRl9TX0FSR1ZfVkFMVUVf" >> $S_FP_ASCII
    echo "QU5EX0RPX05PVF9FWElUPSJmIiAjIHRoZSBkZWZhdWx0IHZhbHVlCiAgICBl" >> $S_FP_ASCII
    echo "bHNlCiAgICAgICAgaWYgWyAiJFNCX09QVElPTkFMX1JVTl9JTklUX1JFR0FS" >> $S_FP_ASCII
    echo "RExFU1NfT0ZfU19BUkdWX1ZBTFVFX0FORF9ET19OT1RfRVhJVCIgIT0gInQi" >> $S_FP_ASCII
    echo "IF07IHRoZW4gCiAgICAgICAgICAgIGlmIFsgIiRTQl9PUFRJT05BTF9SVU5f" >> $S_FP_ASCII
    echo "SU5JVF9SRUdBUkRMRVNTX09GX1NfQVJHVl9WQUxVRV9BTkRfRE9fTk9UX0VY" >> $S_FP_ASCII
    echo "SVQiICE9ICJmIiBdOyB0aGVuIAogICAgICAgICAgICAgICAgZnVuX2V4Y19l" >> $S_FP_ASCII
    echo "eGl0X3dpdGhfYW5fZXJyb3JfdDEgIjI0ZjMyODBmLWY3ZTItNGU3OC04ZjQ2" >> $S_FP_ASCII
    echo "LTcxOTExMTExNTZlNyIKICAgICAgICAgICAgZmkKICAgICAgICBmaQogICAg" >> $S_FP_ASCII
    echo "ZmkKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgaWYgWyAiJFNCX09Q" >> $S_FP_ASCII
    echo "VElPTkFMX1JVTl9JTklUX1JFR0FSRExFU1NfT0ZfU19BUkdWX1ZBTFVFX0FO" >> $S_FP_ASCII
    echo "RF9ET19OT1RfRVhJVCIgPT0gInQiIF07IHRoZW4gCiAgICAgICAgU0JfUlVO" >> $S_FP_ASCII
    echo "X0lOSVQ9InQiCiAgICAgICAgU0JfT0tfVE9fRVhJVF9XSVRIX0VSUl9DT0RF" >> $S_FP_ASCII
    echo "XzA9ImYiCiAgICBmaQogICAgIy0tLS0tLS0tLS0tLS0tLS0tLS0tCiAgICBp" >> $S_FP_ASCII
    echo "ZiBbICIkU0JfUlVOX0lOSVQiID09ICJ0IiBdOyB0aGVuIAogICAgICAgIGlm" >> $S_FP_ASCII
    echo "IFsgISAtZSAiJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTIiBdOyB0aGVu" >> $S_FP_ASCII
    echo "IAogICAgICAgICAgICBpZiBbIC1oICIkU19GUF9USEVfUkVQT1NJVE9SWV9D" >> $S_FP_ASCII
    echo "TE9ORVMiIF07IHRoZW4gICMgYSBicm9rZW4gc3ltbGluawogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgZWNobyAiIgogICAgICAgICAgICAgICAgZWNobyAiVGhlICIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgIGVjaG8gIiIKICAgICAgICAgICAgICAgIGVjaG8gIiAg" >> $S_FP_ASCII
    echo "ICAkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVMiCiAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIiCiAgICAgICAgICAgICAgICBlY2hvICJpcyBhIGJyb2tlbiBz" >> $S_FP_ASCII
    echo "eW1saW5rLiBJdCBpcyBleHBlY3RlZCB0byBiZSIKICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gImVpdGhlciBtaXNzaW5nIG9yIGEgZm9sZGVyLiIKICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gIkdVSUQ9PSc0OTQwZDFjMS1jN2ZlLTRlOGUtYTMzNS03" >> $S_FP_ASCII
    echo "MTkxMTExMTU2ZTcnIgogICAgICAgICAgICAgICAgZWNobyAiIgogICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgICAgICAgICBleGl0" >> $S_FP_ASCII
    echo "IDEgIyBleGl0IHdpdGggYW4gZXJyb3IKICAgICAgICAgICAgZmkKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgaWYgWyAtZSAiJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTX1RB" >> $S_FP_ASCII
    echo "UiIgXTsgdGhlbiAKICAgICAgICAgICAgICAgIGZ1bl9jb25kaXRpb25hbGx5" >> $S_FP_ASCII
    echo "X3VucGFja190aGVfcmVwb3NpdG9yeV9jbG9uZXNfdGFyCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGVsc2UKICAgICAgICAgICAgICAgIG1rZGlyICIkU19GUF9USEVfUkVQT1NJ" >> $S_FP_ASCII
    echo "VE9SWV9DTE9ORVMiCiAgICAgICAgICAgICAgICBmdW5jX3dhaXRfYW5kX3N5" >> $S_FP_ASCII
    echo "bmMKICAgICAgICAgICAgICAgIGZ1bmNfbW1tdl9hc3NlcnRfZm9sZGVyX2V4" >> $S_FP_ASCII
    echo "aXN0c190MSBcCiAgICAgICAgICAgICAgICAgICAgIiRTX0ZQX1RIRV9SRVBP" >> $S_FP_ASCII
    echo "U0lUT1JZX0NMT05FUyIgXAogICAgICAgICAgICAgICAgICAgICIxMDI0ZjU0" >> $S_FP_ASCII
    echo "NS1lNzViLTQzNTUtOGM1Ni03MTkxMTExMTU2ZTciICJ0IgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBmaQogICAgICAgIGVsc2UKICAgICAgICAgICAgIyBUaGUgCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGZ1bmNfbW1tdl9hc3NlcnRfZm9sZGVyX2V4aXN0c190MSBcCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAiJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTIiBcCiAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAiNTZhOWY2MTMtOTJkNS00ZTk4LWJlNDYtNzE5MTEx" >> $S_FP_ASCII
    echo "MTE1NmU3IiAidCIKICAgICAgICAgICAgIyBpcyBmb3IgdGVzdGluZyB0aGF0" >> $S_FP_ASCII
    echo "IGl0IGlzIG5vdCBhIHN5bWxpbmsgYW5kIG5vdCBhIGZpbGUuCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGlmIFsgIiRTQl9PS19UT19FWElUX1dJVEhfRVJSX0NPREVfMCIgPT0g" >> $S_FP_ASCII
    echo "InQiIF07IHRoZW4gCiAgICAgICAgICAgICAgICBlY2hvICIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICJUaGUgZm9sZGVyICIKICAgICAgICAgICAgICAgIGVj" >> $S_FP_ASCII
    echo "aG8gIiIKICAgICAgICAgICAgICAgIGVjaG8gIiAgICAkU19GUF9USEVfUkVQ" >> $S_FP_ASCII
    echo "T1NJVE9SWV9DTE9ORVMiCiAgICAgICAgICAgICAgICBlY2hvICIiCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBlY2hvICJhbHJlYWR5IGV4aXN0cy4gTm90aGluZyB0byBp" >> $S_FP_ASCII
    echo "bml0aWFsaXplLiIKICAgICAgICAgICAgICAgIGVjaG8gIkdVSUQ9PSc4ZjBi" >> $S_FP_ASCII
    echo "OGQxMy1hNjUyLTRlMDAtOTYxNS03MTkxMTExMTU2ZTcnIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgZWNobyAiIgogICAgICAgICAgICAgICAgY2QgIiRTX0ZQX09SSUci" >> $S_FP_ASCII
    echo "CiAgICAgICAgICAgICAgICBleGl0IDAgIyBleGl0IHdpdGhvdXQgYW55IGVy" >> $S_FP_ASCII
    echo "cm9ycwogICAgICAgICAgICBmaQogICAgICAgIGZpCiAgICBlbHNlCiAgICAg" >> $S_FP_ASCII
    echo "ICAgaWYgWyAiJFNCX1JVTl9JTklUIiAhPSAiZiIgXTsgdGhlbiAKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgZnVuX2V4Y19leGl0X3dpdGhfYW5fZXJyb3JfdDEgImIxMTRlYjdl" >> $S_FP_ASCII
    echo "LWRiNjEtNDBjYi04ZTI2LTcxOTExMTExNTZlNyIKICAgICAgICBmaQogICAg" >> $S_FP_ASCII
    echo "ZmkKfSAjIGZ1bl9pZl9uZWVkZWRfY3JlYXRlX3RoZV9mb2xkZXJfNF9kb3du" >> $S_FP_ASCII
    echo "bG9hZGluZ19yZXBvc2l0b3JpZXNfYW5kX29wdGlvbmFsbHlfZXhpdF93aXRo" >> $S_FP_ASCII
    echo "X2FuX2Vycm9yX2NvZGVfMApmdW5faWZfbmVlZGVkX2NyZWF0ZV90aGVfZm9s" >> $S_FP_ASCII
    echo "ZGVyXzRfZG93bmxvYWRpbmdfcmVwb3NpdG9yaWVzX2FuZF9vcHRpb25hbGx5" >> $S_FP_ASCII
    echo "X2V4aXRfd2l0aF9hbl9lcnJvcl9jb2RlXzAKCiMtLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tCkFSX1JFUE9fRk9MREVSX05BTUVTPSgpCgpmdW5fYXNz" >> $S_FP_ASCII
    echo "ZW1ibGVfYXJyYXlfb2ZfcmVwb3NpdG9yeV9jbG9uZV9mb2xkZXJfbmFtZXMg" >> $S_FP_ASCII
    echo "KCkgewogICAgaWYgWyAtZSAiJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVT" >> $S_FP_ASCII
    echo "X1RBUiIgXTsgdGhlbgogICAgICAgIGZ1bl9jb25kaXRpb25hbGx5X3VucGFj" >> $S_FP_ASCII
    echo "a190aGVfcmVwb3NpdG9yeV9jbG9uZXNfdGFyCiAgICBmaQogICAgIy0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tCiAgICBmdW5jX21tbXZfYXNzZXJ0X2ZvbGRlcl9l" >> $S_FP_ASCII
    echo "eGlzdHNfdDEgXAogICAgICAgICIkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9O" >> $S_FP_ASCII
    echo "RVMiIFwKICAgICAgICAiNGZhZWU0MTUtNjdkNi00MTg5LTgzNDYtNzE5MTEx" >> $S_FP_ASCII
    echo "MTE1NmU3IiAidCIKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgY2Qg" >> $S_FP_ASCII
    echo "IiRTX0ZQX1RIRV9SRVBPU0lUT1JZX0NMT05FUyIKICAgIGxvY2FsIFNfVE1Q" >> $S_FP_ASCII
    echo "XzA9ImBydWJ5IC1lIFwiYXI9QXJyYXkubmV3OyBEaXIuZ2xvYignKicpLmVh" >> $S_FP_ASCII
    echo "Y2h7fHh8IGlmIEZpbGUuZGlyZWN0b3J5PyB4IHRoZW4gYXI8PHggZW5kfTsg" >> $S_FP_ASCII
    echo "cHV0cyhhci50b19zLmdzdWIoJ1snLCcoJykuZ3N1YignXScsJyknKS5nc3Vi" >> $S_FP_ASCII
    echo "KCcsJywnICcpKVwiYCIKICAgIGNkICIkU19GUF9ESVIiCiAgICBsb2NhbCBT" >> $S_FP_ASCII
    echo "X1RNUF8xPSJBUl9SRVBPX0ZPTERFUl9OQU1FUz0kU19UTVBfMCIKICAgIGV2" >> $S_FP_ASCII
    echo "YWwgJHtTX1RNUF8xfQp9ICMgZnVuX2Fzc2VtYmxlX2FycmF5X29mX3JlcG9z" >> $S_FP_ASCII
    echo "aXRvcnlfY2xvbmVfZm9sZGVyX25hbWVzIAoKCiMgVGhlIGdvYWwgaGVyZSBp" >> $S_FP_ASCII
    echo "cyB0byBiZSBhcyBncmVlZHkgYXQgZG93bmxvYWRpbmcgdGhlIGRpZmZlcmVu" >> $S_FP_ASCII
    echo "dAojIHZlcnRpY2VzIG9mIHRoZSByZXBvc2l0b3J5IHZlcnNpb24gdHJlZSBh" >> $S_FP_ASCII
    echo "cyBwb3NzaWJsZS4KIyBUaGUgaW5zdGFuY2VzIG9mIHRoZSBjbG9uZXMgdGhh" >> $S_FP_ASCII
    echo "dCBhcmUgYmVpbmcgbWFpbnRhaW5lZAojIHdpdGggdGhpcyBzY3JpcHQgYXJl" >> $S_FP_ASCII
    echo "IG5vdCBtZWFudCB0byBiZSB1c2VkIGRpcmVjdGx5IGZvciAKIyBkZXZlbG9w" >> $S_FP_ASCII
    echo "bWVudC4gRGV2ZWxvcG1lbnQgZGVsaXZlcmFibGVzIGFyZSBleHBlY3RlZCB0" >> $S_FP_ASCII
    echo "byAKIyBjb250YWluIG1hbnVhbGx5IGNyZWF0ZWQgY29waWVzIG9mIHRoZSBj" >> $S_FP_ASCII
    echo "bG9uZXMgCiMgdGhhdCB0aGlzIHNjcmlwdCBpcyB1c2VkIGZvciBtYWludGFp" >> $S_FP_ASCII
    echo "bmluZy4KZnVuX3VwZGF0ZSAoKSB7CiAgICAjLS0tLS0tLS0KICAgIGxvY2Fs" >> $S_FP_ASCII
    echo "IFNfRlBfUFdEX0FUX0ZVTkNfU1RBUlQ9ImBwd2RgIgogICAgZnVuX2Fzc2Vt" >> $S_FP_ASCII
    echo "YmxlX2FycmF5X29mX3JlcG9zaXRvcnlfY2xvbmVfZm9sZGVyX25hbWVzIAog" >> $S_FP_ASCII
    echo "ICAgIy0tLS0tLS0tCiAgICBpZiBbICIkU0JfU0tJUF9BUkNISVZJTkciID09" >> $S_FP_ASCII
    echo "ICJmIiBdOyB0aGVuIAogICAgICAgIG1rZGlyIC1wICIkU19GUF9BUkNISVZF" >> $S_FP_ASCII
    echo "IgogICAgZWxzZQogICAgICAgIGlmIFsgIiRTQl9TS0lQX0FSQ0hJVklORyIg" >> $S_FP_ASCII
    echo "IT0gInQiIF07IHRoZW4gCiAgICAgICAgICAgIGZ1bl9leGNfZXhpdF93aXRo" >> $S_FP_ASCII
    echo "X2FuX2Vycm9yX3QxICI3NWI3ODM4ZC1iOWU3LTQ1ODItYTRjNi03MTkxMTEx" >> $S_FP_ASCII
    echo "MTU2ZTciCiAgICAgICAgZmkKICAgIGZpCiAgICAjLS0tLS0tLS0KICAgIGZv" >> $S_FP_ASCII
    echo "ciBzX2l0ZXIgaW4gJHtBUl9SRVBPX0ZPTERFUl9OQU1FU1tAXX07IGRvCiAg" >> $S_FP_ASCII
    echo "ICAgICAgIFNfRk9MREVSX05BTUVfT0ZfVEhFX0xPQ0FMX0NPUFk9IiRzX2l0" >> $S_FP_ASCII
    echo "ZXIiCiAgICAgICAgIGVjaG8gIiIKICAgICAgICAgIy0tLS0KICAgICAgICAg" >> $S_FP_ASCII
    echo "aWYgWyAiJFNCX1NLSVBfQVJDSElWSU5HIiAhPSAidCIgXTsgdGhlbiAKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgIGVjaG8gIiAgICAgICAgICAgIEFyY2hpdmluZyBhIGNvcHkg" >> $S_FP_ASCII
    echo "b2YgJFNfRk9MREVSX05BTUVfT0ZfVEhFX0xPQ0FMX0NPUFkiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICBjcCAtZiAtUiAkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVMvJFNf" >> $S_FP_ASCII
    echo "Rk9MREVSX05BTUVfT0ZfVEhFX0xPQ0FMX0NPUFkgJFNfRlBfQVJDSElWRS8K" >> $S_FP_ASCII
    echo "ICAgICAgICAgZWxzZQogICAgICAgICAgICAgZWNobyAiICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "U2tpcHBpbmcgdGhlIGFyY2hpdmluZyBhIGNvcHkgb2YgJFNfRk9MREVSX05B" >> $S_FP_ASCII
    echo "TUVfT0ZfVEhFX0xPQ0FMX0NPUFkiCiAgICAgICAgIGZpCiAgICAgICAgICMt" >> $S_FP_ASCII
    echo "LS0tCiAgICAgICAgIGNkICIkU19GUF9USEVfUkVQT1NJVE9SWV9DTE9ORVMv" >> $S_FP_ASCII
    echo "JFNfRk9MREVSX05BTUVfT0ZfVEhFX0xPQ0FMX0NPUFkiCiAgICAgICAgIGVj" >> $S_FP_ASCII
    echo "aG8gIkNoZWNraW5nIG91dCBhIG5ld2VyIHZlcnNpb24gb2YgJFNfRk9MREVS" >> $S_FP_ASCII
    echo "X05BTUVfT0ZfVEhFX0xPQ0FMX0NPUFkiCiAgICAgICAgICMtLS0tLS0tLQog" >> $S_FP_ASCII
    echo "ICAgICAgICAjIERvd25sb2FkcyB0aGUgbmV3ZXN0IHZlcnNpb24gb2YgdGhl" >> $S_FP_ASCII
    echo "IHNvZnR3YXJlIHRvIHRoYXQgZm9sZGVyLgogICAgICAgICBuaWNlIC1uIDEw" >> $S_FP_ASCII
    echo "IGdpdCBjaGVja291dCAtLWZvcmNlICMgb3ZlcndyaXRlcyBsb2NhbCBjaGFu" >> $S_FP_ASCII
    echo "Z2VzLCBsaWtlIHRoZSAic3ZuIGNvIgogICAgICAgICBuaWNlIC1uIDEwIGdp" >> $S_FP_ASCII
    echo "dCBwdWxsIC0tYWxsIC0tcmVjdXJzZS1zdWJtb2R1bGVzIC0tZm9yY2UgIyBn" >> $S_FP_ASCII
    echo "ZXRzIHRoZSBzdWJtb2R1bGVzCiAgICAgICAgICMtLS0tCiAgICAgICAgICMg" >> $S_FP_ASCII
    echo "aHR0cDovL3N0YWNrb3ZlcmZsb3cuY29tL3F1ZXN0aW9ucy8xMDMwMTY5L2Vh" >> $S_FP_ASCII
    echo "c3ktd2F5LXB1bGwtbGF0ZXN0LW9mLWFsbC1zdWJtb2R1bGVzCiAgICAgICAg" >> $S_FP_ASCII
    echo "IG5pY2UgLW4gMTAgZ2l0IHN1Ym1vZHVsZSB1cGRhdGUgLS1pbml0IC0tcmVj" >> $S_FP_ASCII
    echo "dXJzaXZlIC0tZm9yY2UgCiAgICAgICAgIG5pY2UgLW4gMTAgZ2l0IHN1Ym1v" >> $S_FP_ASCII
    echo "ZHVsZSB1cGRhdGUgLS1pbml0IC0tcmVjdXJzaXZlIC0tZm9yY2UgLS1yZW1v" >> $S_FP_ASCII
    echo "dGUKICAgICAgICAgbmljZSAtbiAxMCBnaXQgcHVsbCAtLWFsbCAtLXJlY3Vy" >> $S_FP_ASCII
    echo "c2Utc3VibW9kdWxlcyAtLWZvcmNlICMganVzdCBpbiBjYXNlCiAgICAgICAg" >> $S_FP_ASCII
    echo "IGlmIFsgIiRTQl9SVU5fR0lUX0dBUkJBR0VfQ09MTEVDVE9SX09OX0xPQ0FM" >> $S_FP_ASCII
    echo "X0dJVF9SRVBPU0lUT1JZIiA9PSAidCIgXTsgdGhlbiAKICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiIKICAgICAgICAgICAgIGVjaG8gIlJ1bm5pbmcgdGhlIGdpdCBn" >> $S_FP_ASCII
    echo "YXJiYWdlIGNvbGxlY3RvciBvbiB0aGUgbG9jYWwgcmVwb3NpdG9yeS4uLiIK" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICMgQSBjaXRhdGlvbiBmcm9tIAogICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IwogICAgICAgICAgICAgIyAgICAgaHR0cHM6Ly9naXQtc2NtLmNvbS9kb2Nz" >> $S_FP_ASCII
    echo "L2dpdC1nYwogICAgICAgICAgICAgIwogICAgICAgICAgICAgIyAgICAgLS1w" >> $S_FP_ASCII
    echo "cnVuZT08ZGF0ZT4gIFBydW5lIGxvb3NlIG9iamVjdHMgb2xkZXIgCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAjICAgICAgICAgICAgICAgICAgICAgdGhhbiBkYXRlIChkZWZh" >> $S_FP_ASCII
    echo "dWx0IGlzIDIgd2Vla3MgYWdvLCAKICAgICAgICAgICAgICMgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBvdmVycmlkYWJsZSBieSB0aGUgY29uZmlnIHZhcmlhYmxl" >> $S_FP_ASCII
    echo "IAogICAgICAgICAgICAgIyAgICAgICAgICAgICAgICAgICAgIGdjLnBydW5l" >> $S_FP_ASCII
    echo "RXhwaXJlKS4gLS1wcnVuZT1hbGwgcHJ1bmVzIAogICAgICAgICAgICAgIyAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgIGxvb3NlIG9iamVjdHMgcmVnYXJkbGVzcyBv" >> $S_FP_ASCII
    echo "ZiB0aGVpciBhZ2UKICAgICAgICAgICAgICMgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBhbmQgaW5jcmVhc2VzIHRoZSByaXNrIG9mIGNvcnJ1cHRpb24gCiAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAjICAgICAgICAgICAgICAgICAgICAgaWYgYW5vdGhlciBwcm9j" >> $S_FP_ASCII
    echo "ZXNzIGlzIHdyaXRpbmcgdG8gCiAgICAgICAgICAgICAjICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgdGhlIHJlcG9zaXRvcnkgY29uY3VycmVudGx5OyAKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIG5pY2UgLW4gMTUgZ2l0IGdjIC0tYWdncmVzc2l2ZSAtLXBydW5l" >> $S_FP_ASCII
    echo "PWFsbCAKICAgICAgICAgICAgIG5pY2UgLW4gMTAgZ2l0IHB1bGwgLS1hbGwg" >> $S_FP_ASCII
    echo "LS1yZWN1cnNlLXN1Ym1vZHVsZXMgLS1mb3JjZSAjIHRvIGJlIHN1cmUKICAg" >> $S_FP_ASCII
    echo "ICAgICAgZmkKICAgICAgICAgZnVuY193YWl0X2FuZF9zeW5jCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICMtLS0tLS0tLQogICAgICAgICBjZCAiJFNfRlBfRElSIgogICAgZG9uZQog" >> $S_FP_ASCII
    echo "ICAgY2QgIiRTX0ZQX1BXRF9BVF9GVU5DX1NUQVJUIgogICAgZWNobyAiIgp9" >> $S_FP_ASCII
    echo "ICMgZnVuX3VwZGF0ZSAKCgpmdW5fcnVuX3VwZGF0ZV9pZl9uZWVkZWQoKXsK" >> $S_FP_ASCII
    echo "ICAgICMtLS0tLS0tLQogICAgaWYgWyAiJFNfQVJHVl8wIiA9PSAiIiBdOyB0" >> $S_FP_ASCII
    echo "aGVuICAjIHRoZSBkZWZhdWx0IGFjdGlvbgogICAgICAgIFNCX1JVTl9VUERB" >> $S_FP_ASCII
    echo "VEU9InQiCiAgICBmaQogICAgaWYgWyAiJFNfQVJHVl8wIiA9PSAic2tpcF9h" >> $S_FP_ASCII
    echo "cmNoaXZpbmciIF07IHRoZW4gCiAgICAgICAgU0JfU0tJUF9BUkNISVZJTkc9" >> $S_FP_ASCII
    echo "InQiCiAgICAgICAgU0JfUlVOX1VQREFURT0idCIKICAgIGZpCiAgICBpZiBb" >> $S_FP_ASCII
    echo "ICIkU19BUkdWXzAiID09ICJza2EiIF07IHRoZW4gIyBhYmJyZXZpYXRpb24g" >> $S_FP_ASCII
    echo "b2YgInNraXBfYXJjaGl2aW5nIgogICAgICAgIFNCX1NLSVBfQVJDSElWSU5H" >> $S_FP_ASCII
    echo "PSJ0IgogICAgICAgIFNCX1JVTl9VUERBVEU9InQiCiAgICBmaQogICAgIy0t" >> $S_FP_ASCII
    echo "LS0tLS0tCiAgICBpZiBbICIkU19BUkdWXzAiID09ICJza2lwX2FyY2hpdmlu" >> $S_FP_ASCII
    echo "Z19nYyIgXTsgdGhlbiAKICAgICAgICBTQl9TS0lQX0FSQ0hJVklORz0idCIK" >> $S_FP_ASCII
    echo "ICAgICAgICBTQl9SVU5fR0lUX0dBUkJBR0VfQ09MTEVDVE9SX09OX0xPQ0FM" >> $S_FP_ASCII
    echo "X0dJVF9SRVBPU0lUT1JZPSJ0IgogICAgICAgIFNCX1JVTl9VUERBVEU9InQi" >> $S_FP_ASCII
    echo "CiAgICBmaQogICAgaWYgWyAiJFNfQVJHVl8wIiA9PSAic2thX2djIiBdOyB0" >> $S_FP_ASCII
    echo "aGVuICMgYWJicmV2aWF0aW9uIG9mICJza2lwX2FyY2hpdmluZ19nYyIKICAg" >> $S_FP_ASCII
    echo "ICAgICBTQl9TS0lQX0FSQ0hJVklORz0idCIKICAgICAgICBTQl9SVU5fR0lU" >> $S_FP_ASCII
    echo "X0dBUkJBR0VfQ09MTEVDVE9SX09OX0xPQ0FMX0dJVF9SRVBPU0lUT1JZPSJ0" >> $S_FP_ASCII
    echo "IgogICAgICAgIFNCX1JVTl9VUERBVEU9InQiCiAgICBmaQogICAgaWYgWyAi" >> $S_FP_ASCII
    echo "JFNfQVJHVl8wIiA9PSAic2thZ2MiIF07IHRoZW4gICMgYWJicmV2aWF0aW9u" >> $S_FP_ASCII
    echo "IG9mICJza2lwX2FyY2hpdmluZ19nYyIKICAgICAgICBTQl9TS0lQX0FSQ0hJ" >> $S_FP_ASCII
    echo "VklORz0idCIKICAgICAgICBTQl9SVU5fR0lUX0dBUkJBR0VfQ09MTEVDVE9S" >> $S_FP_ASCII
    echo "X09OX0xPQ0FMX0dJVF9SRVBPU0lUT1JZPSJ0IgogICAgICAgIFNCX1JVTl9V" >> $S_FP_ASCII
    echo "UERBVEU9InQiCiAgICBmaQogICAgIy0tLS0tLS0tCiAgICBpZiBbICIkU0Jf" >> $S_FP_ASCII
    echo "UlVOX1VQREFURSIgPT0gInQiIF07IHRoZW4gCiAgICAgICAgU0JfSU5WQUxJ" >> $S_FP_ASCII
    echo "RF9DT01NQU5EX0xJTkVfQVJHVU1FTlRTPSJmIgogICAgICAgIGZ1bl91cGRh" >> $S_FP_ASCII
    echo "dGUgCiAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgZXhpdCAwICMg" >> $S_FP_ASCII
    echo "ZXhpdCB3aXRob3V0IGFueSBlcnJvcnMKICAgIGVsc2UKICAgICAgICBpZiBb" >> $S_FP_ASCII
    echo "ICIkU0JfUlVOX1VQREFURSIgIT0gImYiIF07IHRoZW4gCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "IGZ1bl9leGNfZXhpdF93aXRoX2FuX2Vycm9yX3QxICI1NTQ5MDIzMS1jM2Mw" >> $S_FP_ASCII
    echo "LTQyMzUtOTQyNi03MTkxMTExMTU2ZTciCiAgICAgICAgZmkKICAgIGZpCn0g" >> $S_FP_ASCII
    echo "IyBmdW5fcnVuX3VwZGF0ZV9pZl9uZWVkZWQKZnVuX3J1bl91cGRhdGVfaWZf" >> $S_FP_ASCII
    echo "bmVlZGVkCgojLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KZnVuX3J1" >> $S_FP_ASCII
    echo "bl9nYXJiYWdlX2NvbGxlY3RvcigpIHsKICAgICMtLS0tLS0tLQogICAgbG9j" >> $S_FP_ASCII
    echo "YWwgU19GUF9QV0RfQVRfRlVOQ19TVEFSVD0iYHB3ZGAiCiAgICBsb2NhbCBT" >> $S_FP_ASCII
    echo "X1RNUF8wPSJub3Rfc2V0IgogICAgZnVuX2Fzc2VtYmxlX2FycmF5X29mX3Jl" >> $S_FP_ASCII
    echo "cG9zaXRvcnlfY2xvbmVfZm9sZGVyX25hbWVzIAogICAgIy0tLS0tLS0tCiAg" >> $S_FP_ASCII
    echo "ICBlY2hvICIiCiAgICBmb3Igc19pdGVyIGluICR7QVJfUkVQT19GT0xERVJf" >> $S_FP_ASCII
    echo "TkFNRVNbQF19OyBkbwogICAgICAgICBTX0ZPTERFUl9OQU1FX09GX1RIRV9M" >> $S_FP_ASCII
    echo "T0NBTF9DT1BZPSIkc19pdGVyIgogICAgICAgICAjLS0tLQogICAgICAgICBj" >> $S_FP_ASCII
    echo "ZCAiJFNfRlBfVEhFX1JFUE9TSVRPUllfQ0xPTkVTLyRTX0ZPTERFUl9OQU1F" >> $S_FP_ASCII
    echo "X09GX1RIRV9MT0NBTF9DT1BZIgogICAgICAgICBlY2hvICJSdW5uaW5nIHRo" >> $S_FP_ASCII
    echo "ZSBnYXJiYWdlIGNvbGxlY3RvciBvbiAkU19GT0xERVJfTkFNRV9PRl9USEVf" >> $S_FP_ASCII
    echo "TE9DQUxfQ09QWSIKICAgICAgICAgbmljZSAtbiAxNSBnaXQgZ2MgLS1hZ2dy" >> $S_FP_ASCII
    echo "ZXNzaXZlIC0tcHJ1bmU9YWxsIAogICAgICAgICBTX1RNUF8wPSIkPyIgCiAg" >> $S_FP_ASCII
    echo "ICAgICAgIGlmIFsgIiRTX1RNUF8wIiAhPSAiMCIgXTsgdGhlbiAKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gIiIKICAgICAgICAgICAgIGVjaG8gIkdpdCBleGl0ZWQg" >> $S_FP_ASCII
    echo "d2l0aCB0aGUgZXJyb3IgY29kZSBvZiAkU19UTVBfMC4iCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICJBYm9ydGluZyBzY3JpcHQuIgogICAgICAgICAgICAgZWNobyAi" >> $S_FP_ASCII
    echo "R1VJRD09JzNkNzcyNWI0LWZkOTctNGFhMy05NjE1LTcxOTExMTExNTZlNyci" >> $S_FP_ASCII
    echo "CiAgICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAgICBzeW5jICYgIyBp" >> $S_FP_ASCII
    echo "biB0aGUgYmFja2dyb3VuZCwgYmVjYXVzZSAKICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAjIGl0IG1pZ2h0IGhhdmUgYmVlbiB0aGF0IHRoZQogICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICMgZXJyb3IgaXMgZHVlIHRvIGEgbGFjayBvZiAKICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAjIGFjY2VzcyB0byBhIG1vdW50ZWQgZHJpdmUKICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgIGNkICIkU19GUF9PUklHIgogICAgICAgICAgICAgZXhpdCAkU19U" >> $S_FP_ASCII
    echo "TVBfMCAjIGV4aXQgd2l0aCBhbiBlcnJvcgogICAgICAgICBmaQogICAgICAg" >> $S_FP_ASCII
    echo "ICAjLS0tLQogICAgICAgICBlY2hvICIiCiAgICAgICAgIGZ1bmNfd2FpdF9h" >> $S_FP_ASCII
    echo "bmRfc3luYwogICAgICAgICBjZCAiJFNfRlBfRElSIgogICAgZG9uZQogICAg" >> $S_FP_ASCII
    echo "Iy0tLS0tLS0tCiAgICBjZCAiJFNfRlBfUFdEX0FUX0ZVTkNfU1RBUlQiCn0g" >> $S_FP_ASCII
    echo "IyBmdW5fcnVuX2dhcmJhZ2VfY29sbGVjdG9yCgpmdW5fcnVuX2dhcmJhZ2Vf" >> $S_FP_ASCII
    echo "Y29sbGVjdG9yX2lmX25lZWRlZCgpewogICAgIy0tLS0tLS0tCiAgICBsb2Nh" >> $S_FP_ASCII
    echo "bCBTQl9SVU5fR0FSQkFHRV9DT0xMRUNUT1I9ImYiICMgImYiIGZvciAiZmFs" >> $S_FP_ASCII
    echo "c2UiLCAidCIgZm9yICJ0cnVlIgogICAgbG9jYWwgQVJfMD0oInJ1bl9nYXJi" >> $S_FP_ASCII
    echo "YWdlX2NvbGxlY3RvciIgInJ1bl9nYyIgImdjIikKICAgIGZvciBTX0lURVIg" >> $S_FP_ASCII
    echo "aW4gJHtBUl8wW0BdfTsgZG8KICAgICAgICBpZiBbICIkU19BUkdWXzAiID09" >> $S_FP_ASCII
    echo "ICIkU19JVEVSIiBdOyB0aGVuIAogICAgICAgICAgICBTQl9SVU5fR0FSQkFH" >> $S_FP_ASCII
    echo "RV9DT0xMRUNUT1I9InQiCiAgICAgICAgICAgIFNCX0lOVkFMSURfQ09NTUFO" >> $S_FP_ASCII
    echo "RF9MSU5FX0FSR1VNRU5UUz0iZiIKICAgICAgICBmaQogICAgZG9uZQogICAg" >> $S_FP_ASCII
    echo "Iy0tLS0tLS0tCiAgICBpZiBbICIkU0JfUlVOX0dBUkJBR0VfQ09MTEVDVE9S" >> $S_FP_ASCII
    echo "IiA9PSAidCIgXTsgdGhlbiAKICAgICAgICBmdW5fcnVuX2dhcmJhZ2VfY29s" >> $S_FP_ASCII
    echo "bGVjdG9yCiAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAgICAgZXhpdCAw" >> $S_FP_ASCII
    echo "ICMgZXhpdCB3aXRob3V0IGFueSBlcnJvcnMKICAgIGVsc2UKICAgICAgICBp" >> $S_FP_ASCII
    echo "ZiBbICIkU0JfUlVOX0dBUkJBR0VfQ09MTEVDVE9SIiAhPSAiZiIgXTsgdGhl" >> $S_FP_ASCII
    echo "biAKICAgICAgICAgICAgZnVuX2V4Y19leGl0X3dpdGhfYW5fZXJyb3JfdDEg" >> $S_FP_ASCII
    echo "ImY0YjA2N2ViLWY5YmItNDRkMC05MDY1LTcxOTExMTExNTZlNyIKICAgICAg" >> $S_FP_ASCII
    echo "ICBmaQogICAgZmkKfSAjIGZ1bl9ydW5fZ2FyYmFnZV9jb2xsZWN0b3JfaWZf" >> $S_FP_ASCII
    echo "bmVlZGVkCmZ1bl9ydW5fZ2FyYmFnZV9jb2xsZWN0b3JfaWZfbmVlZGVkCgoj" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KZnVuY19tbW12X2Fzc2Vy" >> $S_FP_ASCII
    echo "dF9maWxlX3BhdGhfaXNfbm90X2luX3VzZV90MSgpeyAKICAgIGxvY2FsIFNf" >> $S_FP_ASCII
    echo "RlBfQ0FORElEQVRFPSQxICAgIyBmaXJzdCBmdW5jdGlvbiBhcmd1bWVudAog" >> $S_FP_ASCII
    echo "ICAgbG9jYWwgU19HVUlEX0NBTkRJREFURT0kMiAjIHNlY29uZCBmdW5jdGlv" >> $S_FP_ASCII
    echo "biBhcmd1bWVudAogICAgIy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICAg" >> $S_FP_ASCII
    echo "IGlmIFsgIiRTX0dVSURfQ0FORElEQVRFIiA9PSAiIiBdOyB0aGVuIAogICAg" >> $S_FP_ASCII
    echo "ICAgIGVjaG8gIiIKICAgICAgICBlY2hvICJUaGUgY29kZSBvZiB0aGlzIHNj" >> $S_FP_ASCII
    echo "cmlwdCBpcyBmbGF3ZWQuIgogICAgICAgIGVjaG8gIkFib3J0aW5nIHNjcmlw" >> $S_FP_ASCII
    echo "dC4iCiAgICAgICAgZWNobyAiR1VJRD09J2FjM2I0ZDdhLTNiODUtNDc3Yi05" >> $S_FP_ASCII
    echo "NDE1LTcxOTExMTExNTZlNyciCiAgICAgICAgZWNobyAiIgogICAgICAgIGNk" >> $S_FP_ASCII
    echo "ICIkU19GUF9PUklHIgogICAgICAgIGV4aXQgMSAjIGV4aXQgd2l0aCBhbiBl" >> $S_FP_ASCII
    echo "cnJvcgogICAgZmkKICAgIGlmIFsgIiRTX0ZQX0NBTkRJREFURSIgPT0gIiIg" >> $S_FP_ASCII
    echo "XTsgdGhlbiAKICAgICAgICBlY2hvICIiCiAgICAgICAgZWNobyAiVGhlIGNv" >> $S_FP_ASCII
    echo "ZGUgb2YgdGhpcyBzY3JpcHQgaXMgZmxhd2VkLiIKICAgICAgICBlY2hvICJB" >> $S_FP_ASCII
    echo "Ym9ydGluZyBzY3JpcHQuIgogICAgICAgIGVjaG8gIkdVSUQ9PSdmZTFjNTYw" >> $S_FP_ASCII
    echo "Mi0xODg5LTQ0Y2YtOWQ0NS03MTkxMTExMTU2ZTcnIgogICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IkdVSURfQ0FORElEQVRFPT0nJFNfR1VJRF9DQU5ESURBVEUnIgogICAgICAg" >> $S_FP_ASCII
    echo "IGVjaG8gIiIKICAgICAgICBjZCAiJFNfRlBfT1JJRyIKICAgICAgICBleGl0" >> $S_FP_ASCII
    echo "IDEgIyBleGl0IHdpdGggYW4gZXJyb3IKICAgIGZpCiAgICAjLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICAgIGlmIFsg" >> $S_FP_ASCII
    echo "LWUgIiRTX0ZQX0NBTkRJREFURSIgXTsgdGhlbiAKICAgICAgICBlY2hvICIi" >> $S_FP_ASCII
    echo "CiAgICAgICAgZWNobyAiVGhlIHBhdGggIgogICAgICAgIGVjaG8gIiIKICAg" >> $S_FP_ASCII
    echo "ICAgICBlY2hvICIgICAgJFNfRlBfQ0FORElEQVRFIgogICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiIKICAgICAgICBlY2hvICJpcyBhbHJlYWR5IGluIHVzZS4iCiAgICAgICAg" >> $S_FP_ASCII
    echo "ZWNobyAiQWJvcnRpbmcgc2NyaXB0LiIKICAgICAgICBlY2hvICJHVUlEPT0n" >> $S_FP_ASCII
    echo "ODgxMmNkMzAtNjZlOC00YzI0LWE4MTUtNzE5MTExMTE1NmU3JyIKICAgICAg" >> $S_FP_ASCII
    echo "ICBlY2hvICJHVUlEX0NBTkRJREFURT09JyRTX0dVSURfQ0FORElEQVRFJyIK" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICIiCiAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAgICAg" >> $S_FP_ASCII
    echo "ICAgZXhpdCAxICMgZXhpdCB3aXRoIGFuIGVycm9yCiAgICBlbHNlIAogICAg" >> $S_FP_ASCII
    echo "ICAgIGlmIFsgLWggIiRTX0ZQX0NBTkRJREFURSIgXTsgdGhlbiAgIyByZWZl" >> $S_FP_ASCII
    echo "cmVuY2VzIGEgYnJva2VuIHN5bWxpbmsKICAgICAgICAgICAgZWNobyAiIgog" >> $S_FP_ASCII
    echo "ICAgICAgICAgICBlY2hvICJUaGUgcGF0aCAiCiAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "IiIKICAgICAgICAgICAgZWNobyAiICAgICRTX0ZQX0NBTkRJREFURSIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgZWNobyAiIgogICAgICAgICAgICBlY2hvICJpcyBhbHJlYWR5" >> $S_FP_ASCII
    echo "IGluIHVzZS4gSXQgcmVmZXJlbmNlcyBhIGJyb2tlbiBzeW1saW5rLiIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgZWNobyAiQWJvcnRpbmcgc2NyaXB0LiIKICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ZWNobyAiR1VJRD09JzUyYWJkMjc0LWY5OTAtNDBhZi1iYjM1LTcxOTExMTEx" >> $S_FP_ASCII
    echo "NTZlNyciCiAgICAgICAgICAgIGVjaG8gIkdVSURfQ0FORElEQVRFPT0nJFNf" >> $S_FP_ASCII
    echo "R1VJRF9DQU5ESURBVEUnIgogICAgICAgICAgICBlY2hvICIiCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGNkICIkU19GUF9PUklHIgogICAgICAgICAgICBleGl0IDEgIyBleGl0" >> $S_FP_ASCII
    echo "IHdpdGggYW4gZXJyb3IKICAgICAgICBmaQogICAgZmkKfSAjIGZ1bmNfbW1t" >> $S_FP_ASCII
    echo "dl9hc3NlcnRfZmlsZV9wYXRoX2lzX25vdF9pbl91c2VfdDEKCkZVTkNfTU1N" >> $S_FP_ASCII
    echo "Vl9HRU5FUkFURV9URU1QT1JBUllfRklMRV9PUl9GT0xERVJfUEFUSF9UMV9P" >> $S_FP_ASCII
    echo "VVRQVVQ9IiIKIyBJdCBkb2VzIG5vdCBjcmVhdGUgdGhlIGZpbGUgb3IgZm9s" >> $S_FP_ASCII
    echo "ZGVyLCBpdCBqdXN0CiMgZ2VuZXJhdGVzIGEgZnVsbCBmaWxlIHBhdGguIEl0" >> $S_FP_ASCII
    echo "IGRvZXMgbm90IGNoZWNrLCB3aGV0aGVyCiMgdGhlIHBhcmVudCBmb2xkZXIg" >> $S_FP_ASCII
    echo "b2YgdGhlIG5ldyBmaWxlIG9yIGZvbGRlciBpcyAKIyB3cml0YWJsZS4gCmZ1" >> $S_FP_ASCII
    echo "bmNfbW1tdl9nZW5lcmF0ZV90ZW1wb3JhcnlfZmlsZV9vcl9mb2xkZXJfcGF0" >> $S_FP_ASCII
    echo "aF90MSgpIHsKICAgIGxvY2FsIFNfRlBfVE1QX0ZPTERFUl9DQU5ESURBVEU9" >> $S_FP_ASCII
    echo "IiRQV0QvX3RtcCIKICAgIGlmIFsgISAtZSAiJFNfRlBfVE1QX0ZPTERFUl9D" >> $S_FP_ASCII
    echo "QU5ESURBVEUiIF07IHRoZW4gCiAgICAgICAgU19GUF9UTVBfRk9MREVSX0NB" >> $S_FP_ASCII
    echo "TkRJREFURT0iJFBXRC90bXAiCiAgICAgICAgaWYgWyAhIC1lICIkU19GUF9U" >> $S_FP_ASCII
    echo "TVBfRk9MREVSX0NBTkRJREFURSIgXTsgdGhlbiAKICAgICAgICAgICAgU19G" >> $S_FP_ASCII
    echo "UF9UTVBfRk9MREVSX0NBTkRJREFURT0iJEhPTUUvX3RtcCIKICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgaWYgWyAhIC1lICIkU19GUF9UTVBfRk9MREVSX0NBTkRJREFURSIgXTsg" >> $S_FP_ASCII
    echo "dGhlbiAKICAgICAgICAgICAgICAgIFNfRlBfVE1QX0ZPTERFUl9DQU5ESURB" >> $S_FP_ASCII
    echo "VEU9IiRIT01FL3RtcCIKICAgICAgICAgICAgICAgIGlmIFsgISAtZSAiJFNf" >> $S_FP_ASCII
    echo "RlBfVE1QX0ZPTERFUl9DQU5ESURBVEUiIF07IHRoZW4gCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgU19GUF9UTVBfRk9MREVSX0NBTkRJREFURT0iL3RtcCIKICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICBpZiBbICEgLWUgIiRTX0ZQX1RNUF9GT0xERVJf" >> $S_FP_ASCII
    echo "Q0FORElEQVRFIiBdOyB0aGVuIAogICAgICAgICAgICAgICAgICAgICAgICBl" >> $S_FP_ASCII
    echo "Y2hvICIiCiAgICAgICAgICAgICAgICAgICAgICAgIGVjaG8gIlRoZSBwYXRo" >> $S_FP_ASCII
    echo "IG9mIHRoZSB0ZW1wb3JhcnkgZm9sZGVyIgogICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICBlY2hvICJjb3VsZCBub3QgYmUgZGV0ZXJtaW5lZC4gRXZlbiB0aGUg" >> $S_FP_ASCII
    echo "IgogICAgICAgICAgICAgICAgICAgICAgICBlY2hvICIiCiAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgIGVjaG8gIiAgICAvdG1wIgogICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICBlY2hvICIiCiAgICAgICAgICAgICAgICAgICAgICAgIGVjaG8g" >> $S_FP_ASCII
    echo "ImRvZXMgbm90IGV4aXN0LiBBYm9ydGluZyBzY3JpcHQuIgogICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICBlY2hvICJHVUlEPT0nYzQ2ZjNjZDAtZDdhOC00NjQy" >> $S_FP_ASCII
    echo "LWI5MTUtNzE5MTExMTE1NmU3JyIKICAgICAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ZWNobyAiIgogICAgICAgICAgICAgICAgICAgICAgICBjZCAiJFNfRlBfT1JJ" >> $S_FP_ASCII
    echo "RyIKICAgICAgICAgICAgICAgICAgICAgICAgZXhpdCAxICMgZXhpdCB3aXRo" >> $S_FP_ASCII
    echo "IGFuIGVycm9yCiAgICAgICAgICAgICAgICAgICAgZmkKICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgIGZpCiAgICAgICAgICAgIGZpCiAgICAgICAgZmkKICAgIGZpCiAgICAj" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KICAgIGxvY2FsIFNf" >> $S_FP_ASCII
    echo "Rk49IiRTX1RJTUVTVEFNUCIKICAgIFNfRk4rPSJfIgogICAgU19GTis9IiRS" >> $S_FP_ASCII
    echo "QU5ET00iCiAgICBTX0ZOKz0iXyIKICAgIFNfRk4rPSIkUkFORE9NIgogICAg" >> $S_FP_ASCII
    echo "U19GTis9Il8iCiAgICBTX0ZOKz0iJFJBTkRPTSIKICAgIFNfRk4rPSJfIgog" >> $S_FP_ASCII
    echo "ICAgU19GTis9IiRSQU5ET00iCiAgICBTX0ZOKz0iXyIKICAgIFNfRk4rPSIk" >> $S_FP_ASCII
    echo "UkFORE9NIgogICAgU19GTis9Il8iCiAgICBTX0ZOKz0iJFJBTkRPTSIKICAg" >> $S_FP_ASCII
    echo "IFNfRk4rPSJfIgogICAgU19GTis9IiRSQU5ET00iCiAgICBTX0ZOKz0iXyIK" >> $S_FP_ASCII
    echo "ICAgIFNfRk4rPSIkUkFORE9NIgogICAgU19GTis9Il8iCiAgICBTX0ZOKz0i" >> $S_FP_ASCII
    echo "JFJBTkRPTSIKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LQogICAgbG9jYWwgU19GUF9PVVQ9IiRTX0ZQX1RNUF9GT0xERVJfQ0FORElE" >> $S_FP_ASCII
    echo "QVRFLyRTX0ZOIgogICAgRlVOQ19NTU1WX0dFTkVSQVRFX1RFTVBPUkFSWV9G" >> $S_FP_ASCII
    echo "SUxFX09SX0ZPTERFUl9QQVRIX1QxX09VVFBVVD0iJFNfRlBfT1VUIgp9ICMg" >> $S_FP_ASCII
    echo "ZnVuY19tbW12X2dlbmVyYXRlX3RlbXBvcmFyeV9maWxlX29yX2ZvbGRlcl9w" >> $S_FP_ASCII
    echo "YXRoX3QxCgpGVU5DX01NTVZfQ1JFQVRFX0VNUFRZX1RFTVBPUkFSWV9GT0xE" >> $S_FP_ASCII
    echo "RVJfVDFfQU5TV0VSPSIiCiMgUmV0dXJucyB0aGUgZnVsbCBwYXRoIG9mIHRo" >> $S_FP_ASCII
    echo "ZSBmb2xkZXIuIApmdW5jX21tbXZfY3JlYXRlX2VtcHR5X3RlbXBvcmFyeV9m" >> $S_FP_ASCII
    echo "b2xkZXJfdDEoKSB7CiAgICBmdW5jX21tbXZfZ2VuZXJhdGVfdGVtcG9yYXJ5" >> $S_FP_ASCII
    echo "X2ZpbGVfb3JfZm9sZGVyX3BhdGhfdDEKICAgIGxvY2FsIFNfRlBfQ0FORElE" >> $S_FP_ASCII
    echo "QVRFPSIkRlVOQ19NTU1WX0dFTkVSQVRFX1RFTVBPUkFSWV9GSUxFX09SX0ZP" >> $S_FP_ASCII
    echo "TERFUl9QQVRIX1QxX09VVFBVVCIKICAgIGZ1bmNfbW1tdl9hc3NlcnRfZmls" >> $S_FP_ASCII
    echo "ZV9wYXRoX2lzX25vdF9pbl91c2VfdDEgIiRTX0ZQX0NBTkRJREFURSIgXAog" >> $S_FP_ASCII
    echo "ICAgICAgICI4MjkyODI0MS00MDBjLTRhOGItODkzNS03MTkxMTExMTU2ZTci" >> $S_FP_ASCII
    echo "CiAgICBta2RpciAtcCAiJFNfRlBfQ0FORElEQVRFIgogICAgZnVuY193YWl0" >> $S_FP_ASCII
    echo "X2FuZF9zeW5jCiAgICBmdW5jX21tbXZfYXNzZXJ0X2ZvbGRlcl9leGlzdHNf" >> $S_FP_ASCII
    echo "dDEgXAogICAgICAgICIkU19GUF9DQU5ESURBVEUiIFwKICAgICAgICAiM2I3" >> $S_FP_ASCII
    echo "ZWZhYjItMjUxZC00ZGM1LThkMzUtNzE5MTExMTE1NmU3IiAidCIKICAgIEZV" >> $S_FP_ASCII
    echo "TkNfTU1NVl9DUkVBVEVfRU1QVFlfVEVNUE9SQVJZX0ZPTERFUl9UMV9BTlNX" >> $S_FP_ASCII
    echo "RVI9IiRTX0ZQX0NBTkRJREFURSIKfSAjIGZ1bmNfbW1tdl9jcmVhdGVfZW1w" >> $S_FP_ASCII
    echo "dHlfdGVtcG9yYXJ5X2ZvbGRlcl90MQoKRlVOQ19NTU1WX0NSRUFURV9FTVBU" >> $S_FP_ASCII
    echo "WV9URU1QT1JBUllfRklMRV9UMV9BTlNXRVI9IiIKIyBSZXR1cm5zIHRoZSBm" >> $S_FP_ASCII
    echo "dWxsIHBhdGggb2YgdGhlIGZpbGUuCmZ1bmNfbW1tdl9jcmVhdGVfZW1wdHlf" >> $S_FP_ASCII
    echo "dGVtcG9yYXJ5X2ZpbGVfdDEoKSB7CiAgICAjLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "IAogICAgbG9jYWwgU19PUFRJT05BTF9TVUZGSVhfT0ZfVEhFX0ZJTEVfTkFN" >> $S_FP_ASCII
    echo "RT0iJDEiICMgZmlsZSBleHRlbnNpb24sIGxpa2UgIi50eHQiCiAgICAjLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tIAogICAgZnVuY19tbW12X2dlbmVyYXRlX3RlbXBv" >> $S_FP_ASCII
    echo "cmFyeV9maWxlX29yX2ZvbGRlcl9wYXRoX3QxCiAgICBsb2NhbCBTX0ZQX0NB" >> $S_FP_ASCII
    echo "TkRJREFURT0iJEZVTkNfTU1NVl9HRU5FUkFURV9URU1QT1JBUllfRklMRV9P" >> $S_FP_ASCII
    echo "Ul9GT0xERVJfUEFUSF9UMV9PVVRQVVQiCiAgICBpZiBbICIkU19PUFRJT05B" >> $S_FP_ASCII
    echo "TF9TVUZGSVhfT0ZfVEhFX0ZJTEVfTkFNRSIgIT0gIiIgXTsgdGhlbiAKICAg" >> $S_FP_ASCII
    echo "ICAgICBTX0ZQX0NBTkRJREFURSs9IiRTX09QVElPTkFMX1NVRkZJWF9PRl9U" >> $S_FP_ASCII
    echo "SEVfRklMRV9OQU1FIgogICAgZmkKICAgIGZ1bmNfbW1tdl9hc3NlcnRfZmls" >> $S_FP_ASCII
    echo "ZV9wYXRoX2lzX25vdF9pbl91c2VfdDEgIiRTX0ZQX0NBTkRJREFURSIgXAog" >> $S_FP_ASCII
    echo "ICAgICAgICI2NWI2ZmRjNy1iM2U0LTQ3ZDgtOTM1NS03MTkxMTExMTU2ZTci" >> $S_FP_ASCII
    echo "CiAgICBwcmludGYgIiViIiAiIiA+ICRTX0ZQX0NBTkRJREFURSAjIHRoZSBl" >> $S_FP_ASCII
    echo "Y2hvICIiIHdvdWxkIGFkZCBhIGxpbmVicmVhawogICAgd2FpdAogICAgZnVu" >> $S_FP_ASCII
    echo "Y193YWl0X2FuZF9zeW5jCiAgICBmdW5jX21tbXZfYXNzZXJ0X2ZpbGVfZXhp" >> $S_FP_ASCII
    echo "c3RzX3QxIFwKICAgICAgICAiJFNfRlBfQ0FORElEQVRFIiBcCiAgICAgICAg" >> $S_FP_ASCII
    echo "IjFiNWQ3ZWIyLTc3YmQtNGJkZC1iNjM1LTcxOTExMTExNTZlNyIgInQiCiAg" >> $S_FP_ASCII
    echo "ICBGVU5DX01NTVZfQ1JFQVRFX0VNUFRZX1RFTVBPUkFSWV9GSUxFX1QxX0FO" >> $S_FP_ASCII
    echo "U1dFUj0iJFNfRlBfQ0FORElEQVRFIgp9ICMgZnVuY19tbW12X2NyZWF0ZV9l" >> $S_FP_ASCII
    echo "bXB0eV90ZW1wb3JhcnlfZmlsZV90MQoKIy0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tCmZ1bl9wcmludF91cHN0cmVhbV9yZXBvc2l0b3J5X3BhdGgo" >> $S_FP_ASCII
    echo "KSB7CiAgICAjLS0tLS0tLS0KICAgIGxvY2FsIFNfRlBfUFdEX0FUX0ZVTkNf" >> $S_FP_ASCII
    echo "U1RBUlQ9ImBwd2RgIgogICAgZnVuX2Fzc2VtYmxlX2FycmF5X29mX3JlcG9z" >> $S_FP_ASCII
    echo "aXRvcnlfY2xvbmVfZm9sZGVyX25hbWVzIAogICAgIy0tLS0tLS0tCiAgICBm" >> $S_FP_ASCII
    echo "dW5jX21tbXZfY3JlYXRlX2VtcHR5X3RlbXBvcmFyeV9maWxlX3QxICIudHh0" >> $S_FP_ASCII
    echo "IgogICAgbG9jYWwgU19GUF9UTVBfQUxMX1JFUE9fUEFUSFM9IiRGVU5DX01N" >> $S_FP_ASCII
    echo "TVZfQ1JFQVRFX0VNUFRZX1RFTVBPUkFSWV9GSUxFX1QxX0FOU1dFUiIKICAg" >> $S_FP_ASCII
    echo "ICMtLS0tLS0tLQogICAgZm9yIHNfaXRlciBpbiAke0FSX1JFUE9fRk9MREVS" >> $S_FP_ASCII
    echo "X05BTUVTW0BdfTsgZG8KICAgICAgICBTX0ZPTERFUl9OQU1FX09GX1RIRV9M" >> $S_FP_ASCII
    echo "T0NBTF9DT1BZPSIkc19pdGVyIgogICAgICAgICMtLS0tCiAgICAgICAgY2Qg" >> $S_FP_ASCII
    echo "IiRTX0ZQX1RIRV9SRVBPU0lUT1JZX0NMT05FUy8kU19GT0xERVJfTkFNRV9P" >> $S_FP_ASCII
    echo "Rl9USEVfTE9DQUxfQ09QWSIKICAgICAgICBuaWNlIC1uIDIgZ2l0IGNvbmZp" >> $S_FP_ASCII
    echo "ZyByZW1vdGUub3JpZ2luLnVybCA+PiAkU19GUF9UTVBfQUxMX1JFUE9fUEFU" >> $S_FP_ASCII
    echo "SFMKICAgICAgICAgICAgICAgICAgICAgICAgICAjIFByaW50cyB0aGUgcmVw" >> $S_FP_ASCII
    echo "b3NpdG9yeSBwYXRoIHRvIGNvbnNvbGUuIAogICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICMgQXMgYSBzaW5nbGUgbG9jYWwgcmVwb3NpdG9yeSBjYW4gaGF2" >> $S_FP_ASCII
    echo "ZSBtdWx0aXBsZSAKICAgICAgICAgICAgICAgICAgICAgICAgICAjIHB1c2gg" >> $S_FP_ASCII
    echo "dGFyZ2V0cywgdGhlIG51bWJlciBvZiBwcmludGVkIGxpbmVzCiAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgIyBwZXIgbG9jYWwgcmVwb3NpdG9yeSBjYW4g" >> $S_FP_ASCII
    echo "YmUgbW9yZSB0aGFuIG9uZS4KICAgICAgICBjZCAiJFNfRlBfRElSIgogICAg" >> $S_FP_ASCII
    echo "ICAgICMtLS0tCiAgICBkb25lCiAgICAjLS0tLS0tLS0KICAgICMgU29ydCB0" >> $S_FP_ASCII
    echo "aGUgbGlzdCB3aXRoIFJ1YnkuCiAgICAjIFRlc3RlZCB3aXRoIFJ1YnkgdmVy" >> $S_FP_ASCII
    echo "c2lvbiAyLjUuMXA1NwogICAgbmljZSAtbiA1IHJ1YnkgLWUgInM9SU8ucmVh" >> $S_FP_ASCII
    echo "ZCgnJFNfRlBfVE1QX0FMTF9SRVBPX1BBVEhTJyk7IFwKICAgICAgICBhcj1B" >> $S_FP_ASCII
    echo "cnJheS5uZXc7XAogICAgICAgIHMuZWFjaF9saW5le3xzX2xpbmV8IGFyPDxz" >> $S_FP_ASCII
    echo "X2xpbmV9O1wKICAgICAgICBhcjA9YXIuc29ydDtcCiAgICAgICAgaV9sZW49" >> $S_FP_ASCII
    echo "YXIwLnNpemU7XAogICAgICAgIHNfMD1cIlwiO1wKICAgICAgICBpX2xlbi50" >> $S_FP_ASCII
    echo "aW1lc3t8aXh8IHNfMDw8YXIwW2l4XX07XAogICAgICAgIHB1dHMgc18wIgog" >> $S_FP_ASCII
    echo "ICAgIy0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQogICAgcm0g" >> $S_FP_ASCII
    echo "LWYgJFNfRlBfVE1QX0FMTF9SRVBPX1BBVEhTCiAgICBmdW5jX3dhaXRfYW5k" >> $S_FP_ASCII
    echo "X3N5bmMKICAgIGlmIFsgLWUgIiRTX0ZQX1RNUF9BTExfUkVQT19QQVRIUyIg" >> $S_FP_ASCII
    echo "XTsgdGhlbiAKICAgICAgICBlY2hvICIiCiAgICAgICAgZWNobyAiRmlsZSBk" >> $S_FP_ASCII
    echo "ZWxldGlvbiBmYWlsZWQuIEZpbGUgcGF0aDoiCiAgICAgICAgZWNobyAiIgog" >> $S_FP_ASCII
    echo "ICAgICAgIGVjaG8gIiAgICAkU19GUF9UTVBfQUxMX1JFUE9fUEFUSFMiCiAg" >> $S_FP_ASCII
    echo "ICAgICAgZWNobyAiIgogICAgICAgIGVjaG8gIkFib3J0aW5nIHNjcmlwdC4i" >> $S_FP_ASCII
    echo "CiAgICAgICAgZWNobyAiR1VJRD09JzY4ZTZlYzVlLTc1MTEtNDIxMi1hYTQ0" >> $S_FP_ASCII
    echo "LTcxOTExMTExNTZlNyciCiAgICAgICAgZWNobyAiIgogICAgICAgIGNkICIk" >> $S_FP_ASCII
    echo "U19GUF9PUklHIgogICAgICAgIGV4aXQgMSAjIGV4aXQgd2l0aCBhbiBlcnJv" >> $S_FP_ASCII
    echo "cgogICAgZmkKICAgICMtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0KICAgIGNkICIkU19GUF9QV0RfQVRfRlVOQ19TVEFSVCIKfSAjIGZ1bl9w" >> $S_FP_ASCII
    echo "cmludF91cHN0cmVhbV9yZXBvc2l0b3J5X3BhdGgKCmZ1bl9wcmludF91cHN0" >> $S_FP_ASCII
    echo "cmVhbV9yZXBvc2l0b3J5X3BhdGhfaWZfbmVlZGVkKCl7CiAgICAjLS0tLS0t" >> $S_FP_ASCII
    echo "LS0KICAgIGxvY2FsIFNCX1BSSU5UX1VQU1RSRUFNX1JFUE9TSVRPUllfUEFU" >> $S_FP_ASCII
    echo "SD0iZiIgIyAiZiIgZm9yICJmYWxzZSIsICJ0IiBmb3IgInRydWUiCiAgICBs" >> $S_FP_ASCII
    echo "b2NhbCBBUl8wPSgicHJpbnRfdXBzdHJlYW1fcmVwb3NpdG9yeV9wYXRoIiAi" >> $S_FP_ASCII
    echo "cHJwIikgIyAicnAiIHNraXBwZWQgZHVlIHRvIAogICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICMgY2xv" >> $S_FP_ASCII
    echo "c2Ugc2ltaWxhcml0eSB0byB0aGUgInJtIiwKICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAjIHdoaWNo" >> $S_FP_ASCII
    echo "IG1pZ2h0IGdldCBhY2NpZGVudGFsbHkgCiAgICAgICAgICAgICAgICAgICAg" >> $S_FP_ASCII
    echo "ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIyBlbnRlcmVk" >> $S_FP_ASCII
    echo "IGR1ZSB0byBhIHR5cG8KICAgIGZvciBTX0lURVIgaW4gJHtBUl8wW0BdfTsg" >> $S_FP_ASCII
    echo "ZG8KICAgICAgICBpZiBbICIkU19BUkdWXzAiID09ICIkU19JVEVSIiBdOyB0" >> $S_FP_ASCII
    echo "aGVuIAogICAgICAgICAgICBTQl9QUklOVF9VUFNUUkVBTV9SRVBPU0lUT1JZ" >> $S_FP_ASCII
    echo "X1BBVEg9InQiCiAgICAgICAgICAgIFNCX0lOVkFMSURfQ09NTUFORF9MSU5F" >> $S_FP_ASCII
    echo "X0FSR1VNRU5UUz0iZiIKICAgICAgICBmaQogICAgZG9uZQogICAgIy0tLS0t" >> $S_FP_ASCII
    echo "LS0tCiAgICBpZiBbICIkU0JfUFJJTlRfVVBTVFJFQU1fUkVQT1NJVE9SWV9Q" >> $S_FP_ASCII
    echo "QVRIIiA9PSAidCIgXTsgdGhlbiAKICAgICAgICBmdW5fcHJpbnRfdXBzdHJl" >> $S_FP_ASCII
    echo "YW1fcmVwb3NpdG9yeV9wYXRoCiAgICAgICAgY2QgIiRTX0ZQX09SSUciCiAg" >> $S_FP_ASCII
    echo "ICAgICAgZXhpdCAwICMgZXhpdCB3aXRob3V0IGFueSBlcnJvcnMKICAgIGVs" >> $S_FP_ASCII
    echo "c2UKICAgICAgICBpZiBbICIkU0JfUFJJTlRfVVBTVFJFQU1fUkVQT1NJVE9S" >> $S_FP_ASCII
    echo "WV9QQVRIIiAhPSAiZiIgXTsgdGhlbiAKICAgICAgICAgICAgZnVuX2V4Y19l" >> $S_FP_ASCII
    echo "eGl0X3dpdGhfYW5fZXJyb3JfdDEgImI0YWEzZTEyLWMyM2ItNDA0My05NzU1" >> $S_FP_ASCII
    echo "LTcxOTExMTExNTZlNyIKICAgICAgICBmaQogICAgZmkKfSAjIGZ1bl9wcmlu" >> $S_FP_ASCII
    echo "dF91cHN0cmVhbV9yZXBvc2l0b3J5X3BhdGhfaWZfbmVlZGVkCmZ1bl9wcmlu" >> $S_FP_ASCII
    echo "dF91cHN0cmVhbV9yZXBvc2l0b3J5X3BhdGhfaWZfbmVlZGVkCgojLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0KCmlmIFsgIiRTQl9JTlZBTElEX0NP" >> $S_FP_ASCII
    echo "TU1BTkRfTElORV9BUkdVTUVOVFMiID09ICJ0IiBdOyB0aGVuIAogICAgZWNo" >> $S_FP_ASCII
    echo "byAiIgogICAgZWNobyAiV3JvbmcgY29tbWFuZCBsaW5lIGFyZ3VtZW50KHMp" >> $S_FP_ASCII
    echo "LiIKICAgIGVjaG8gIlN1cHBvcnRlZCBjb21tYW5kIGxpbmUgYXJndW1lbnRz" >> $S_FP_ASCII
    echo "ICIKICAgIGVjaG8gImNhbiBiZSBkaXNwbGF5ZWQgYnkgdXNpbmcgXCJoZWxw" >> $S_FP_ASCII
    echo "XCIgYXMgIgogICAgZWNobyAidGhlIHNpbmdsZSBjb21tYW5kbGluZSBhcmd1" >> $S_FP_ASCII
    echo "bWVudC4iCiAgICBlY2hvICJBYm9ydGluZyBzY3JpcHQuIgogICAgZWNobyAi" >> $S_FP_ASCII
    echo "R1VJRD09JzRjNjI0MmI0LWE4NjktNDIxMi1iNzQ0LTcxOTExMTExNTZlNyci" >> $S_FP_ASCII
    echo "CiAgICBlY2hvICIiCiAgICBjZCAiJFNfRlBfT1JJRyIKICAgIGV4aXQgMSAj" >> $S_FP_ASCII
    echo "IGV4aXQgd2l0aCBhbiBlcnJvcgplbHNlCiAgICBpZiBbICIkU0JfSU5WQUxJ" >> $S_FP_ASCII
    echo "RF9DT01NQU5EX0xJTkVfQVJHVU1FTlRTIiAhPSAiZiIgXTsgdGhlbiAKICAg" >> $S_FP_ASCII
    echo "ICAgICBmdW5fZXhjX2V4aXRfd2l0aF9hbl9lcnJvcl90MSAiZTQ2N2Q2ZjYt" >> $S_FP_ASCII
    echo "MDJiNC00MmVlLTk5MjUtNzE5MTExMTE1NmU3IgogICAgZmkKZmkKCiMtLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQpjZCAiJFNfRlBfT1JJRyIKZXhp" >> $S_FP_ASCII
    echo "dCAwICMgZXhpdCB3aXRob3V0IGFueSBlcnJvcnMKIy0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t" >> $S_FP_ASCII
    echo "LS0tLS0tLS0tLS0tLS0tCiMgU19WRVJTSU9OX09GX1RISVNfRklMRT0iZDQ0" >> $S_FP_ASCII
    echo "YjJiMTYtNGUyOS00YmVmLThlMjUtNzE5MTExMTE1NmU3IgojPT09PT09PT09" >> $S_FP_ASCII
    echo "PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09" >> $S_FP_ASCII
    echo "PT09PT09PT09PT09PT09PT09PT0K" >> $S_FP_ASCII
    echo "====" >> $S_FP_ASCII
    func_mmmv_wait_and_sync_t1
    #----------------------------------------------------------------------
    # https://en.wikipedia.org/wiki/Base64
    # https://developer.mozilla.org/en-US/docs/Web/API/WindowBase64/Base64_encoding_and_decoding
    #     uuencode -m "$S_FP_TMP" < "$S_FP_BINARY_TO_BE_CONVERTED_2_ASCII" > "$S_FP_ASCII"
    #     uudecode -o "$S_FP_DECODED_FROM_ASCII"  "$S_FP_ASCII"
    #----------------------------------------------------------------------
    nice -n 10 uudecode -o "$S_FP_BASH_FILE_TO_BE_CREATED"  "$S_FP_ASCII"
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "4963bc38-d272-4f9c-b115-e140311156e7" ""
    func_mmmv_wait_and_sync_t1
    chmod 0700 "$S_FP_BASH_FILE_TO_BE_CREATED"
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "590b2b29-4f45-432b-b205-e140311156e7" ""
    func_mmmv_wait_and_sync_t1
    #----------------------------------------------------------------------
    rm -f "$S_FP_ASCII"
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "cda8b722-54ab-4b65-8105-e140311156e7" ""
    func_mmmv_wait_and_sync_t1
    if [ -e "$S_FP_ASCII" ]; then
        echo ""
        echo -e "\e[31mThe code of this Bash function is flawed.\e[39m"
        echo "GUID=='1e3e6955-0f57-4723-89f4-e140311156e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi
    #----------------------------------------------------------------------
} # func_create_script_for_updating_clones_folder_t1

#--------------------------------------------------------------------------
S_FP_CLONE_HOME="$S_FP_DIR/AdoptOpenJDK_GitHub_account_clone"
S_FP_CLONE_UPDATE_SCRIPT="$S_FP_CLONE_HOME/pull_new_version_from_git_repository.bash"
S_FP_THE_REPOSITORY_CLONES="$S_FP_CLONE_HOME/the_repository_clones"
S_URL_PREFIX="https://github.com/AdoptOpenJDK/"

func_clone(){
    local S_REPOSITORY_NAME="$1"
    #------------------------------
    local S_TMP_0=".git"
    local S_CLONING_URL="$S_URL_PREFIX$S_REPOSITORY_NAME$S_TMP_0"
    #echo ""
    #echo "Attempting to clone "
    #echo "    $S_CLONING_URL"
    #echo ""
    nice -n 16 git clone --recursive "$S_CLONING_URL"
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "5ee8b14d-744b-4107-b305-e140311156e7" \
        "URL: $S_CLONING_URL"
    #------------------------------
    func_mmmv_wait_and_sync_t1
    #------------------------------
} # func_clone

#--------------------------------------------------------------------------
mkdir -p "$S_FP_THE_REPOSITORY_CLONES"
func_mmmv_assert_error_code_zero_t1x1 "$?" \
    "1149e7e5-b531-4a7d-9205-e140311156e7" ""
#------------------------------
func_create_script_for_updating_clones_folder_t1 "$S_FP_CLONE_UPDATE_SCRIPT"
#------------------------------
cd "$S_FP_THE_REPOSITORY_CLONES"
func_mmmv_assert_error_code_zero_t1x1 "$?" \
    "31e55d83-4e02-454c-ac05-e140311156e7" ""

#--------------------------------------------------------------------------
func_clone "BuildHelpers"
func_clone "ForkJoinPoolMonitor"
func_clone "IcedTea-Web"
func_clone "JavadocUpdaterTool"
func_clone "Lambdas"
func_clone "NashornHackDay"
func_clone "PatchReview"
func_clone "TDA"
func_clone "TSC"
func_clone "addressbook"
func_clone "adopt-openjdk-kiss-vagrant"
func_clone "adoptopenjdk-getting-started-kit"
func_clone "blog"
func_clone "buzz"
func_clone "gamified-java9-hackathon"
func_clone "homebrew-openjdk"
func_clone "install-jdk"
func_clone "jacoco-report-generator"
func_clone "javaday2016challenge-jshell"
func_clone "jcpelections2014brochure"
func_clone "jdk-api-diff"
func_clone "jdk9-jigsaw"
func_clone "jheappo"
func_clone "jitwatch"
func_clone "jlink.online"
func_clone "jsplitpkgscan-maven-plugin"
func_clone "jsplitpkgscan"
func_clone "lambda-tutorial"
func_clone "mjprof"
func_clone "obuildfactory"
func_clone "openjdk-aarch32-jdk8u-old"
func_clone "openjdk-aarch32-jdk8u"
func_clone "openjdk-aarch64-jdk8u-backup-06-Nov-2018"
func_clone "openjdk-aarch64-jdk8u-old"
func_clone "openjdk-aarch64-jdk8u"
func_clone "openjdk-amber-nightly"
func_clone "openjdk-amber"
func_clone "openjdk-api-graphql"
func_clone "openjdk-api-java-client"
func_clone "openjdk-api-v3"
func_clone "openjdk-api"
func_clone "openjdk-binaries"
func_clone "openjdk-dashboard-v2"
func_clone "openjdk-dashboard"
func_clone "openjdk-docker-build-tools"
func_clone "openjdk-docker"
func_clone "openjdk-jdk-archived"
func_clone "openjdk-jdk-legacy-hg-clone"
func_clone "openjdk-jdk-old"
func_clone "openjdk-jdk"
func_clone "openjdk-jdk10u"
func_clone "openjdk-jdk11"
func_clone "openjdk-jdk11u"
func_clone "openjdk-jdk12u"
func_clone "openjdk-jdk13u"
func_clone "openjdk-jdk14"
func_clone "openjdk-jdk14u"
func_clone "openjdk-jdk15"
func_clone "openjdk-jdk15u"
func_clone "openjdk-jdk16"
func_clone "openjdk-jdk16u"
func_clone "openjdk-jdk8u-backup-06-sep-2018"
func_clone "openjdk-jdk8u-backup-31-oct-2018"
func_clone "openjdk-jdk8u-backup"
func_clone "openjdk-jdk8u-jfr-incubator"
func_clone "openjdk-jdk8u"
func_clone "openjdk-jdk9"
func_clone "openjdk-jdk9u-backup-03-sep-2018"
func_clone "openjdk-jdk9u"
func_clone "openjdk-jfx"
func_clone "openjdk-portola"
func_clone "openjdk-virtual-images"
func_clone "openjdk-website-next"
func_clone "openjdk-website"
func_clone "openjdk10-binaries"
func_clone "openjdk10-nightly"
func_clone "openjdk10-openj9-nightly"
func_clone "openjdk10-openj9-releases"
func_clone "openjdk10-releases"
func_clone "openjdk11-binaries"
func_clone "openjdk11-dragonwell-binaries"
func_clone "openjdk11-upstream-binaries"
func_clone "openjdk12-binaries"
func_clone "openjdk13-binaries"
func_clone "openjdk14-binaries"
func_clone "openjdk15-binaries"
func_clone "openjdk16-binaries"
func_clone "openjdk17-binaries"
func_clone "openjdk8-binaries"
func_clone "openjdk8-dragonwell-binaries"
func_clone "openjdk8-nightly"
func_clone "openjdk8-openj9-nightly"
func_clone "openjdk8-openj9-releases"
func_clone "openjdk8-releases"
func_clone "openjdk8-upstream-binaries"
func_clone "openjdk9-binaries"
func_clone "openjdk9-nightly"
func_clone "openjdk9-openj9-nightly"
func_clone "openjdk9-openj9-releases"
func_clone "openjdk9-releases"
func_clone "semeru11-binaries"
func_clone "semeru16-binaries"
func_clone "semeru17-binaries"
func_clone "semeru18-binaries"
func_clone "semeru8-binaries"
func_clone "slackarchive"
func_clone "vmbenchmarks"
func_clone "website-adoptium"

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="1267f710-5d07-4aa4-82f4-e140311156e7"
#==========================================================================
