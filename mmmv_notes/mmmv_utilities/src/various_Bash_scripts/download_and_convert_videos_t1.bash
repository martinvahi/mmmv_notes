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

if [ ! -e $S_FP_WEBM_DIR ]; then
    echo ""
    echo "The folder "
    echo "    $S_FP_WEBM_DIR "
    echo "does not exist."
    echo "The file path is value of a configuration parameter, S_FP_WEBM_DIR, "
    echo "at the start of this Bash script. Please either "
    echo "create the folder or update the folder path at this Bash script."
    echo "Exiting the Bash script without doing anything. "
    echo "GUID=='442d3943-280c-4c7d-841d-404140b1b0e7'"
    echo ""
    #--------
    exit 1
fi 

if [ ! -d $S_FP_WEBM_DIR ]; then
    echo ""
    echo "The "
    echo "    $S_FP_WEBM_DIR "
    echo "is a file, but it is expected to be a folder or "
    echo "a symbolic link to a folder."
    echo "Exiting the Bash script without doing anything. "
    echo "GUID=='189b9123-a81c-4e7d-a41d-404140b1b0e7'"
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
        echo "GUID=='1e49693f-f739-45a4-a41d-404140b1b0e7'"
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
        echo "GUID=='aa5a7830-215f-474e-951d-404140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    if [ ! -e $S_FP_ORIG/$S_FN_MP4 ]; then
        echo ""
        echo "The download failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='b5309326-ac85-4f0b-931d-404140b1b0e7'"
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
        echo "GUID=='774f454f-8484-433f-931d-404140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    if [ ! -e $S_FP_ORIG/$S_FN_WEBM ]; then
        echo ""
        echo "The conversion failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='34656d21-1ca7-4a74-9d1d-404140b1b0e7'"
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
        echo "GUID=='83228b30-3d4e-4b98-a41d-404140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    sync
    sleep 1  # A dirty hack, but 
             # needed for the file system info to become available,
             # specially, when the destination folder resides 
             # at some storage device other than the origin device.
    if [ ! -e $S_FP_WEBM_DIR/$S_FN_WEBM ]; then
        echo ""
        echo "The mv command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='1529e704-4796-46e4-a11d-404140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    if [ -e $S_FP_ORIG/$S_FN_WEBM ]; then
        echo ""
        echo "The mv command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='473df63e-318d-4814-911d-404140b1b0e7'"
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
        echo "GUID=='91cfc32b-9895-402b-851d-404140b1b0e7'"
        echo ""
        #--------
        exit 1
    fi 
    sync
    sleep 1 
    if [ -e $S_FP_ORIG/$S_FN_MP4 ]; then
        echo ""
        echo "The rm command failed."
        echo "Exiting the Bash script with an error. "
        echo "GUID=='b868c943-8799-49b6-b10d-404140b1b0e7'"
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


