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
        echo "GUID=='1b7b10c5-c436-4dca-8e25-c040311156e7'"
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
        echo "GUID=='50225ab1-14be-4f6d-9c25-c040311156e7'"
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
    echo -e "\e[33mWARNING:\e[39m The files that You are "
    echo "about to download are relatively huge. If You are "
    echo "sure that You still want to download them, then"
    echo "please type \"download\", without the quotatin marks and"
    echo -e "\e[33min lowercase\e[39m, to verify Your wish. "
    echo "Thank You for trying out this script."
    echo "GUID=='fe1ab81b-ddd2-47b0-8225-c040311156e7'"
    echo ""
    #------------------------------
    local S_ANSWER="not_set"
    read -p "Your confirmation please: " S_ANSWER
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "51297f6d-11b4-4b68-9325-c040311156e7" ""
    #------------------------------
    if [ "$S_ANSWER" == "download" ]; then
        echo ""
        echo -e "\e[33mAttempting to download.\e[39m"
        local S_DOWNLOADING_START_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
        echo -e "Downloading start timestamp: \e[33m$S_DOWNLOADING_START_TIMESTAMP\e[39m"
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
S_FP_THE_FILES="$S_FP_DIR/the_files"
S_URL_PREFIX="https://github.com/AdoptOpenJDK/openjdk8-binaries/releases/download/"

func_download(){
    local S_FN="$1"
    #------------------------------
    local S_URL="$S_URL_PREFIX$S_FN"
    echo ""
    echo "Attempting to download"
    echo "    $S_FN"
    echo ""
    nice -n 15 wget "$S_URL"
    func_mmmv_assert_error_code_zero_t1x1 "$?" \
        "8d54c51c-19e1-4769-b225-c040311156e7" \
        "URL: $S_URL"
    #------------------------------
    func_mmmv_wait_and_sync_t1
    #------------------------------
} # func_download

#--------------------------------------------------------------------------
mkdir -p "$S_FP_THE_FILES"
func_mmmv_assert_error_code_zero_t1x1 "$?" \
    "d1c2f614-b0e4-43f7-b525-c040311156e7" ""
cd "$S_FP_THE_FILES"
func_mmmv_assert_error_code_zero_t1x1 "$?" \
    "22abceb1-a3d4-4c8a-a125-c040311156e7" ""

#--------------------------------------------------------------------------
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_mac_openj9_8u292b10_openj9-0.26.0.pkg"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_mac_openj9_8u292b10_openj9-0.26.0.pkg.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_mac_openj9_8u292b10_openj9-0.26.0.pkg.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_windows_openj9_8u292b10_openj9-0.26.0.msi"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_windows_openj9_8u292b10_openj9-0.26.0.msi.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_windows_openj9_8u292b10_openj9-0.26.0.msi.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_windows_openj9_8u292b10_openj9-0.26.0.zip"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_windows_openj9_8u292b10_openj9-0.26.0.zip.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x64_windows_openj9_8u292b10_openj9-0.26.0.zip.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x86-32_windows_openj9_8u292b10_openj9-0.26.0.msi"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x86-32_windows_openj9_8u292b10_openj9-0.26.0.msi.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x86-32_windows_openj9_8u292b10_openj9-0.26.0.msi.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jdk_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_mac_openj9_8u292b10_openj9-0.26.0.pkg"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_mac_openj9_8u292b10_openj9-0.26.0.pkg.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_mac_openj9_8u292b10_openj9-0.26.0.pkg.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_windows_openj9_8u292b10_openj9-0.26.0.msi"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_windows_openj9_8u292b10_openj9-0.26.0.msi.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_windows_openj9_8u292b10_openj9-0.26.0.msi.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_windows_openj9_8u292b10_openj9-0.26.0.zip"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_windows_openj9_8u292b10_openj9-0.26.0.zip.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x64_windows_openj9_8u292b10_openj9-0.26.0.zip.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x86-32_windows_openj9_8u292b10_openj9-0.26.0.msi"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x86-32_windows_openj9_8u292b10_openj9-0.26.0.msi.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x86-32_windows_openj9_8u292b10_openj9-0.26.0.msi.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-jre_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_aarch64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_ppc64le_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_ppc64_aix_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_s390x_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_linux_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_mac_openj9_8u292b10_openj9-0.26.0.tar.gz.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_windows_openj9_8u292b10_openj9-0.26.0.zip"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_windows_openj9_8u292b10_openj9-0.26.0.zip.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x64_windows_openj9_8u292b10_openj9-0.26.0.zip.sha256.txt"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip.json"
func_download \
    "jdk8u292-b10_openj9-0.26.0/OpenJDK8U-testimage_x86-32_windows_openj9_8u292b10_openj9-0.26.0.zip.sha256.txt"

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="46cea65a-6951-4bed-a225-c040311156e7"
#==========================================================================
