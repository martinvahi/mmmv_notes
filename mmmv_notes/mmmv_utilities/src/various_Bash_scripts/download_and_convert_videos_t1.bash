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
# S_FP_SCRIPTFILE_NAME="`basename ${BASH_SOURCE[0]}`"
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
    echo "GUID=='49e50562-0e24-44ff-a441-302140b1b0e7'"
    echo ""
    #--------
    exit 1
fi 

if [ ! -d "$S_FP_WEBM_DIR" ]; then
    echo ""
    echo "The "
    echo "    $S_FP_WEBM_DIR "
    echo "is a file, but it is expected to be a folder or "
    echo "a symbolic link to a folder."
    echo "Exiting the Bash script without doing anything. "
    echo "GUID=='42f9c244-42d1-42e1-8141-302140b1b0e7'"
    echo ""
    #--------
    exit 1
fi 

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of the Bash script is aborted."
        echo "GUID=='2c6fb415-b20a-4162-9c41-302140b1b0e7'"
        echo ""
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
        echo "GUID=='cbaa0a31-b4e8-4688-8341-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    if [ ! -e "$S_FP_ORIG/$S_FN_MP4" ]; then
        echo ""
        echo "The download failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='4430082b-35f8-44a9-a141-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    #----------------
    echo ""
    echo "Converting "
    echo "    $S_FN_MP4    to "
    echo "    $S_FN_WEBM "
    time nice -n20 ffmpeg -i $S_FP_ORIG/$S_FN_MP4 $S_FP_ORIG/$S_FN_WEBM 
    if [ "$?" != "0" ]; then
        echo ""
        echo "The conversion failed with an error code $?"
        echo "Exiting the Bash script with an error. "
        echo "GUID=='cdda3c25-1504-42ce-8141-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    if [ ! -e "$S_FP_ORIG/$S_FN_WEBM" ]; then
        echo ""
        echo "The conversion failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='a04a5d3e-6bd4-44c7-8241-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    #----------------
    echo ""
    echo "Moving "
    echo "    $S_FN_WEBM   to "
    echo "    $S_FP_WEBM_DIR"
    nice -n2 mv $S_FP_ORIG/$S_FN_WEBM $S_FP_WEBM_DIR/
    if [ "$?" != "0" ]; then
        echo ""
        echo "The mv command exited with an error code $?"
        echo "Exiting the Bash script with an error. "
        echo "GUID=='f7d20af8-0305-4bf1-8541-302140b1b0e7'"
        echo ""
        #--------
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
        echo "GUID=='24ccfc45-6f09-4bb3-b241-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    if [ -e "$S_FP_ORIG/$S_FN_WEBM" ]; then
        echo ""
        echo "The mv command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='65c99739-80b0-4469-9241-302140b1b0e7'"
        echo ""
        #--------
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
        echo "GUID=='bb5cbf34-5ed3-4f96-9141-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    sync
    sleep 1 
    if [ -e "$S_FP_ORIG/$S_FN_MP4" ]; then
        echo ""
        echo "The rm command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='11c7a046-7897-48ea-b431-302140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
} # func_1


# A test case:
# func_1 "http://archive.softf1.com/2015/2015_05_12_eesti_televisioon_terevisioon_Juku_nimelisest_arvutist.webm"
# exit 1

#--------------------------------------------------------------------------
# The_files_to_be_downloaded_and_converted:
# An example:
func_1 "http://archive.softf1.com/2015/2015_05_12_eesti_televisioon_terevisioon_Juku_nimelisest_arvutist.webm"


