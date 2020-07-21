#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This Bash script is in public domain. 
#--------------------------------------------------------------------------
# Configuration:

# The original web page:
#     http://www.cs.uoregon.edu/research/summerschool/summer12/curriculum.html

S_FP_WEBM_DIR="/tmp/foo_692faX32_1196_4e5c_94be_721bd57ddc1c_bar"

# The string "The_files_to_be_downloaded_and_converted" is a
# navigation point for the start of the list of videofile URLs. 

#--------------------------------------------------------------------------
S_FP_ORIG="`pwd`"
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
# S_FN_SCRIPTFILE="`basename ${BASH_SOURCE[0]}`"
# S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"

if [ ! -e "$S_FP_WEBM_DIR" ]; then
    echo ""
    echo "The folder "
    echo "    $S_FP_WEBM_DIR "
    echo "does not exist."
    echo "The file path is value of a configuration parameter, S_FP_WEBM_DIR, "
    echo "at the start of this Bash script. Please either "
    echo "create the folder or update the folder path at this Bash script."
    echo "Exiting the Bash script without doing anything. "
    echo "GUID=='88264a24-ea63-4c47-b615-51b0405174e7'"
    echo ""
    #--------
    cd "$S_FP_ORIG"
    exit 1
fi 

if [ ! -d "$S_FP_WEBM_DIR" ]; then
    echo ""
    echo "The "
    echo "    $S_FP_WEBM_DIR "
    echo "is a file, but it is expected to be a folder or "
    echo "a symbolic link to a folder."
    echo "Exiting the Bash script without doing anything. "
    echo "GUID=='f396b058-2a52-47b5-ae45-51b0405174e7'"
    echo ""
    #--------
    cd "$S_FP_ORIG"
    exit 1
fi 

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of the Bash script is aborted."
        echo "GUID=='748d2b7d-2be8-43f8-8915-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "wget"
func_mmmv_exit_if_not_on_path_t2 "ruby"
func_mmmv_exit_if_not_on_path_t2 "ffmpeg"

func_1(){ 
    local S_URL="$1"
    #--------
    local S_FN_MP4="`basename $S_URL`"
    # ruby -e "print('foo.mp4'[0..(-4)]+'webm')"
        #ruby -e \"print('$S_FN_MP4'[0..(-4)]+'webm') \"  \
    local S_FN_WEBM="`ruby -e \" \
        s_0='$S_FN_MP4'; \
        s_1=s_0.reverse; \
        i_0=s_1.index('.'); \
        s_2=s_1[(i_0)..(-1)].reverse+'webm' ;\
        print(s_2); \
        \"`"
    echo ""
    echo ""
    echo "Downloading "
    echo "    $S_URL"
    echo "    to  $S_FP_ORIG"
    nice -n6 wget $S_URL 
    #----------------
    if [ "$?" != "0" ]; then
        echo ""
        echo "The download failed with an error code $?"
        echo "Exiting the Bash script with an error. "
        echo "GUID=='49597201-353c-45c0-8745-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    if [ ! -e "$S_FP_ORIG/$S_FN_MP4" ]; then
        echo ""
        echo "The download failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='72676269-8b87-43d3-9d45-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    #----------------
    echo ""
    echo "Converting "
    echo "    $S_FN_MP4    to "
    echo "    $S_FN_WEBM "
    time nice -n20 ffmpeg -i "$S_FP_ORIG/$S_FN_MP4" "$S_FP_ORIG/$S_FN_WEBM" 
    if [ "$?" != "0" ]; then
        echo ""
        echo "The conversion failed with an error code $?"
        echo "Exiting the Bash script with an error. "
        echo "GUID=='959f519d-0b74-42ac-8f95-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    if [ ! -e "$S_FP_ORIG/$S_FN_WEBM" ]; then
        echo ""
        echo "The conversion failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='3df12402-da73-4a69-8e35-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    #----------------
    echo ""
    echo "Moving "
    echo "    $S_FN_WEBM   to "
    echo "    $S_FP_WEBM_DIR"
    nice -n2 mv "$S_FP_ORIG/$S_FN_WEBM" "$S_FP_WEBM_DIR/"
    if [ "$?" != "0" ]; then
        echo ""
        echo "The mv command exited with an error code $?"
        echo "Exiting the Bash script with an error. "
        echo "GUID=='54906554-c842-4ca3-ba55-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    sync
    sleep 1  # A dirty hack, but 
             # needed for the file system info to become available,
             # specially, when the destination folder resides 
             # at some storage device other than the origin device.
    if [ ! -e "$S_FP_WEBM_DIR/$S_FN_WEBM" ]; then
        echo ""
        echo "The mv command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='d2c1e2dd-a2a3-4202-ac45-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    if [ -e "$S_FP_ORIG/$S_FN_WEBM" ]; then
        echo ""
        echo "The mv command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='55c09642-100c-4fd3-ab55-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    #----------------
    echo ""
    echo "Deleting the "
    echo "    $S_FN_MP4 "
    rm -f $S_FP_ORIG/$S_FN_MP4
    if [ "$?" != "0" ]; then
        echo ""
        echo "The rm command exited with an error code $?"
        echo "Exiting the Bash script with an error. "
        echo "GUID=='a4d3e23b-cd76-42c9-8085-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
    sync
    sleep 1 
    if [ -e "$S_FP_ORIG/$S_FN_MP4" ]; then
        echo ""
        echo "The rm command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='13b0bb63-67d5-4632-8a35-51b0405174e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1
    fi 
} # func_1


# A test case:
# func_1 "http://archive.softf1.com/2015/2015_05_12_eesti_televisioon_terevisioon_Juku_nimelisest_arvutist.webm"
# exit 1

#--------------------------------------------------------------------------
# The_files_to_be_downloaded_and_converted:
# An example:
func_1 "https://longterm.softf1.com/2020/blog_resources/2020_05_06_Martin_Vahi_ekraanivideokommentaar_eestis_arendatavatest_programmeerimiskeeltest_t1.webm"

