#!/usr/bin/env bash
#==========================================================================
# Initial author of this script: Martin.Vahi@softf1.com
# This script has been written in 2020_05 and it is in public domain.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
#--------------------------------------------------------------------------

func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_mmmv_wait_and_sync_t1

func_mmmv_assert_error_code_zero_t1(){
    local S_ERR_CODE="$1" # the "$?"
    local S_GUID_CANDIDATE="$2"
    #--------
    # If the "$?" were evaluated in this function, 
    # then it would be "0" even, if it is
    # something else at the calling code.
    if [ "$S_ERR_CODE" != "0" ];then
        echo ""
        echo "Something went wrong. Error code: $S_ERR_CODE"
        echo "Aborting script."
        echo "GUID=='44a111b1-3c63-411e-a11a-f140c05054e7'"
        echo "S_GUID_CANDIDATE=='$S_GUID_CANDIDATE'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1
    fi
    func_mmmv_wait_and_sync_t1
} # func_mmmv_assert_error_code_zero_t1

#--------------------------------------------------------------------------

func_mmmv_assert_file_exists_t1() {  # S_FP, S_GUID
    local S_FP="$1"
    local S_GUID="$2"
    #------------------------------
    if [ "$S_GUID" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters: S_FP, S_GUID"
        echo "GUID=='54fa0562-fddb-4c82-b83a-f140c05054e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #------------------------------
    if [ ! -e "$S_FP" ]; then
        if [ -h "$S_FP" ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symlink, but a file or "
            echo "a symlinkt to a file is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='cc7a4e8e-d6c7-44f9-968a-f140c05054e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            echo "The file "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='f14f1f40-f4ff-4446-8c4a-f140c05054e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    else
        if [ -d "$S_FP" ]; then
            echo ""
            if [ -h "$S_FP" ]; then
                echo "The symlink to the folder "
            else
                echo "The folder "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "exists, but a file or a symlink to a file is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='556c8d53-e871-4b86-b43a-f140c05054e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
} # func_mmmv_assert_file_exists_t1

#--------------------------------------------------------------------------

func_mmmv_assert_folder_exists_t1() {  # S_FP, S_GUID
    local S_FP="$1"
    local S_GUID="$2"
    #------------------------------
    if [ "$S_GUID" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters: S_FP, S_GUID"
        echo "GUID=='20ad2db1-54da-41fa-ac3a-f140c05054e7'"
        echo ""
        #--------
        cd "$S_FP_ORIG"
        exit 1 # exiting with an error
    fi
    #------------------------------
    if [ ! -e "$S_FP" ]; then
        if [ -h "$S_FP" ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symlink, but a folder "
            echo "or a symlink to a folder is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='e8535b0f-dd21-42dc-aa4a-f140c05054e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        else
            echo ""
            echo "The folder "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='37aea105-edff-45a4-9a4a-f140c05054e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    else
        if [ ! -d "$S_FP" ]; then
            echo ""
            if [ -h "$S_FP" ]; then
                echo "The symlink to an existing file "
            else
                echo "The file "
            fi
            echo ""
            echo "    $S_FP "
            echo ""
            echo "exists, but a folder is expected."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='24d00753-21d6-4f03-ba59-f140c05054e7'"
            echo ""
            #--------
            cd "$S_FP_ORIG"
            exit 1 # exiting with an error
        fi
    fi
} # func_mmmv_assert_folder_exists_t1

#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME="$1"
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of this Bash script is aborted."
        echo "GUID=='d2446ac1-3dce-41d4-8429-f140c05054e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "java"
func_mmmv_exit_if_not_on_path_t2 "javac"
func_mmmv_exit_if_not_on_path_t2 "mvn"
func_mmmv_exit_if_not_on_path_t2 "tar"
func_mmmv_exit_if_not_on_path_t2 "gunzip"
func_mmmv_exit_if_not_on_path_t2 "bash" # a bit absurd here, but just in case

#--------------------------------------------------------------------------
S_FP_THE_BUILD_FOLDER_TMP="$S_FP_DIR/tmp_folder_that_can_be_deleted"
S_FP_THE_BUILD_FOLDER="$S_FP_DIR/cling-2.1.2"
if [ -e "$S_FP_THE_BUILD_FOLDER" ]; then
    # Verifies that it's a folder, not a file.
    func_mmmv_assert_folder_exists_t1 \
        "$S_FP_THE_BUILD_FOLDER"  "40d98441-6490-4773-8e3a-f140c05054e7"
    rm -fr "$S_FP_THE_BUILD_FOLDER"
    func_mmmv_assert_error_code_zero_t1 "$?" "12ac6755-bfda-45a2-b83a-f140c05054e7"
fi
if [ -e "$S_FP_THE_BUILD_FOLDER_TMP" ]; then
    # Verifies that it's a folder, not a file.
    func_mmmv_assert_folder_exists_t1 \
        "$S_FP_THE_BUILD_FOLDER_TMP"  "4e6c1f63-53ce-49f5-be1a-f140c05054e7"
    rm -fr "$S_FP_THE_BUILD_FOLDER_TMP"
    func_mmmv_assert_error_code_zero_t1 "$?" "a43bbc04-0462-416e-bb6a-f140c05054e7"
fi
#---------------------------------------
S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE="$S_FP_DIR/bonnet/upstream_source/cling-2.1.2.tar.gz"
func_mmmv_assert_file_exists_t1 \
    "$S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE"  "b7eed363-d3c3-480c-a02a-f140c05054e7"
S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE_B="$S_FP_DIR/bonnet/cling-2.1.2.tar.gz"
cp "$S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE" "$S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE_B"
func_mmmv_assert_error_code_zero_t1 "$?" "36080a04-9de8-48d9-ab2a-f140c05054e7"
func_mmmv_assert_file_exists_t1 \
    "$S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE_B"  "cc1f7751-386d-4443-b48a-f140c05054e7"
cd "$S_FP_DIR/bonnet"
func_mmmv_assert_error_code_zero_t1 "$?" "e5c1d0c3-b036-46fb-af29-f140c05054e7"
gunzip "$S_FP_TAR_GZ_FILE_WITH_UPSTREAM_SOURCE_B"
func_mmmv_assert_error_code_zero_t1 "$?" "2501eebe-0c86-49c1-9459-f140c05054e7"
#---------------------------------------
S_FP_TARFILE_WITH_UPSTREAM_SOURCE="$S_FP_DIR/bonnet/cling-2.1.2.tar"
func_mmmv_assert_file_exists_t1 \
    "$S_FP_TARFILE_WITH_UPSTREAM_SOURCE"  "4aab9201-b563-430b-b519-f140c05054e7"
cd "$S_FP_DIR"
func_mmmv_assert_error_code_zero_t1 "$?" "c1b1756b-7ac9-4481-88d9-f140c05054e7"
tar -xf "$S_FP_TARFILE_WITH_UPSTREAM_SOURCE"
func_mmmv_assert_error_code_zero_t1 "$?" "b3c429f5-862f-41ae-aa99-f140c05054e7"
func_mmmv_assert_folder_exists_t1 \
    "$S_FP_THE_BUILD_FOLDER"  "846ea31e-cbd3-4cbb-b929-f140c05054e7"
mv "$S_FP_THE_BUILD_FOLDER" "$S_FP_THE_BUILD_FOLDER_TMP"
func_mmmv_assert_error_code_zero_t1 "$?" "4f40a0a1-9236-48af-8a29-f140c05054e7"
func_mmmv_assert_folder_exists_t1 \
    "$S_FP_THE_BUILD_FOLDER_TMP"  "1ae40b23-d2e5-40db-bf19-f140c05054e7"
#---------------------------------------
rm -f "$S_FP_TARFILE_WITH_UPSTREAM_SOURCE"
func_mmmv_assert_error_code_zero_t1 "$?" "27f606a5-abaa-494c-a629-f140c05054e7"
#---------------------------------------
S_FP_MODIFIED_POM_XML_TEMPLATE="$S_FP_DIR/bonnet/modified_cling_v_2_1_2_pom.xml"
func_mmmv_assert_file_exists_t1 \
    "$S_FP_MODIFIED_POM_XML_TEMPLATE"  "3001ec32-e3cd-4a3a-b739-f140c05054e7"
#---------------------------------------
S_FP_POM_XML="$S_FP_THE_BUILD_FOLDER_TMP/pom.xml"
func_mmmv_assert_file_exists_t1 \
    "$S_FP_POM_XML"  "43c333f3-9f4e-4d2b-8d59-f140c05054e7"
cp -f "$S_FP_MODIFIED_POM_XML_TEMPLATE" "$S_FP_POM_XML"
func_mmmv_assert_error_code_zero_t1 "$?" "75aed475-07f8-4401-a0e9-f140c05054e7"
#---------------------------------------
cd "$S_FP_THE_BUILD_FOLDER_TMP"
func_mmmv_assert_error_code_zero_t1 "$?" "79564e30-2260-4aea-a7a9-f140c05054e7"
mvn -Dhttps.protocols=TLSv1.2 clean
func_mmmv_assert_error_code_zero_t1 "$?" "30952a74-9a60-459b-ad19-f140c05054e7"
#--------------------------------------------------------------------------
mvn -Dhttps.protocols=TLSv1.2 install # That is expected to fail.
#func_mmmv_assert_error_code_zero_t1 "$?" "121090b1-feb8-42bb-a049-f140c05054e7"

#==========================================================================
cd $S_FP_ORIG
exit 0
#==========================================================================
