#!/usr/bin/env bash
#==========================================================================
# Initial author of this script: Martin.Vahi@softf1.com
# This script is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
S_FP_ORIG="`pwd`"
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`"
S_FN_SCRIPTFILE_NAME="`basename ${BASH_SOURCE[0]}`"
S_FP_SCRIPTFILE_NAME="$S_FP_DIR/$S_FN_SCRIPTFILE_NAME"

#--------------------------------------------------------------------------

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of the Bash script is aborted."
        echo "GUID=='36f7634a-44fa-476e-83b0-2310009055e7'"
        echo ""
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2 "git"
func_mmmv_exit_if_not_on_path_t2 "gcc"
func_mmmv_exit_if_not_on_path_t2 "g++"
func_mmmv_exit_if_not_on_path_t2 "cmake"
func_mmmv_exit_if_not_on_path_t2 "make"
func_mmmv_exit_if_not_on_path_t2 "svn"
func_mmmv_exit_if_not_on_path_t2 "ruby"

# To avoid verifying some of the environment variable values:
    func_mmmv_exit_if_not_on_path_t2 "basename" 
    func_mmmv_exit_if_not_on_path_t2 "dirname"
    func_mmmv_exit_if_not_on_path_t2 "date"


#--------------------------------------------------------------------------
if [ "$CC" == "" ]; then
    export CC="gcc"
fi
if [ "$CXX" == "" ]; then
    export CXX="g++"
fi

ANGERVAKS_CFLAGS=" -mtune=native -ftree-vectorize "
if [ "$CFLAGS" == "" ]; then
    export CFLAGS="$ANGERVAKS_CFLAGS"
fi
if [ "$CXXFLAGS" == "" ]; then
    export CXXFLAGS="$ANGERVAKS_CFLAGS"
fi

#--------------------------------------------------------------------------
S_FN_BASHSCRIPT_THAT_DOWNLOADS="download_the_LLVM_t1.bash"
S_FP_BASHSCRIPT_THAT_DOWNLOADS="$S_FP_DIR/$S_FN_BASHSCRIPT_THAT_DOWNLOADS"
S_FN_BASHSCRIPT_THAT_COMPILES="compile_the_downloaded_LLVM_t1.bash"
S_FP_BASHSCRIPT_THAT_COMPILES="$S_FP_DIR/$S_FN_BASHSCRIPT_THAT_COMPILES"

# The only purpose of the S_MODE based mechanism is 
# to avoid writing and maintaining the user input verificaton 
# and documentation related code. The user input decrease 
# related comfort is a bonus.
S_LC_MODE_NOT_SET="mode_not_set"
S_MODE="$S_LC_MODE_NOT_SET" # {"$S_LC_MODE_NOT_SET", "mode_download", "mode_compile"} 

if [ "$S_FP_SCRIPTFILE_NAME" == "$S_FP_BASHSCRIPT_THAT_DOWNLOADS" ]; then
    S_MODE="mode_download"
fi
if [ "$S_FP_SCRIPTFILE_NAME" == "$S_FP_BASHSCRIPT_THAT_COMPILES" ]; then
    S_MODE="mode_compile"
fi

if [ "$S_MODE" == "$S_LC_MODE_NOT_SET" ]; then
    echo ""
    echo "Either this script is flawed or "
    echo "it has a wrong file name."
    echo "This script depends on its own full path. "
    echo ""
    echo "    S_FP_SCRIPTFILE_NAME:"
    echo "    $S_FP_SCRIPTFILE_NAME"
    echo ""
    echo "The supported values are:"
    echo ""
    echo "    $S_FP_BASHSCRIPT_THAT_DOWNLOADS"
    echo "    $S_FP_BASHSCRIPT_THAT_COMPILES"
    echo ""
    echo "GUID=='421292e1-ad76-4e1e-b7b0-2310009055e7'"
    echo ""
    #--------
    cd $S_FP_ORIG
    exit 1 # exiting with an error
fi


#--------------------------------------------------------------------------

func_assert_last_cmd_exited_without_errors_t1() {  # S_GUID
    local S_GUID="$1"
    if [ "$?" != "0" ]; then
        echo ""
        echo "Something went wrong. The error code is: $?"
        echo "GUID==\"$S_GUID\""
        echo "GUID=='3d100bb5-206f-4fd0-a9b0-2310009055e7'"
        echo ""
        #--------
        cd $S_FP_ORIG
        exit 1 # exiting with an error
    fi
} # func_assert_last_cmd_exited_without_errors_t1


func_assert_folder_exists_t1() {  # S_FP, S_GUID
    local S_FP="$1"
    local S_GUID="$2"
    #------------------------------
    if [ "$S_GUID" == "" ]; then
        echo ""
        echo "The code that calls this function is flawed."
        echo "This function requires 2 parameters: S_FP, S_GUID"
        echo "GUID=='73344d6b-4bba-426b-92b0-2310009055e7'"
        echo ""
        #--------
        cd $S_FP_ORIG
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
            echo "points to a broken symbolic link."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='f53d1b37-1fea-4a67-84a0-2310009055e7'"
            echo ""
            #--------
            cd $S_FP_ORIG
            exit 1 # exiting with an error
        else
            echo ""
            echo "The folder "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "does not exist."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='652f9cb1-5e41-4155-9da0-2310009055e7'"
            echo ""
            #--------
            cd $S_FP_ORIG
            exit 1 # exiting with an error
        fi
    fi
} # func_assert_folder_exists_t1


#--------------------------------------------------------------------------

func_download(){
    #--------------------------------------------
    local S_TMP_0="$S_FP_DIR/vd_$S_TIMESTAMP"
    local S_TMP_0_SRC="$S_TMP_0/src"
    local S_TMP_0_INSTALLED="$S_TMP_0/installed"
    local S_FP_LLVM="$S_TMP_0_SRC/llvm"
    #----
    mkdir -p $S_TMP_0_SRC
    func_assert_last_cmd_exited_without_errors_t1 "6ec7144a-ceee-4cb0-a3b0-2310009055e7"
    sleep 1
    func_assert_folder_exists_t1 "$S_TMP_0_SRC" \
        "edaf0525-49c5-4515-b5b0-2310009055e7"
    #----
    mkdir -p $S_TMP_0_INSTALLED
    func_assert_last_cmd_exited_without_errors_t1 "81fc1832-44a3-43b0-bdb0-2310009055e7"
    sleep 1
    func_assert_folder_exists_t1 "$S_TMP_0_INSTALLED" \
        "5bbbd258-57b5-4f15-a1a0-2310009055e7"
    #----
    cp $S_FP_BASHSCRIPT_THAT_DOWNLOADS  $S_TMP_0/$S_FN_BASHSCRIPT_THAT_COMPILES
    func_assert_last_cmd_exited_without_errors_t1 "5fb69f03-da4a-4457-a3a0-2310009055e7"
    #--------------------------------------------
    cd $S_TMP_0_SRC
        svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
        func_assert_last_cmd_exited_without_errors_t1 "2b4e4852-cbf7-499d-a2a0-2310009055e7"
        sleep 1
        func_assert_folder_exists_t1 "$S_FP_LLVM" "ffc69925-18cc-46a2-83a0-2310009055e7"
        cd $S_FP_LLVM
            #--------------------------------------------
            mkdir -p ./tools
            func_assert_last_cmd_exited_without_errors_t1 "26cd7b01-f3bf-4e07-a8a0-2310009055e7"
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/tools" \
                "4de3c304-a5f9-458d-b3a0-2310009055e7"
            cd ./tools
                svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
                func_assert_last_cmd_exited_without_errors_t1 "6c782351-1d6a-4dfc-a5a0-2310009055e7"
            cd ..
            #--------
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/tools/clang/tools" \
                "2d2bce44-5a38-4905-82a0-2310009055e7"
            cd ./tools/clang/tools
                svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
                func_assert_last_cmd_exited_without_errors_t1 "485daa15-fc26-4d8a-a9a0-2310009055e7"
            cd ../../..
            #--------
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/projects" \
                "2eaa4d33-bffd-43b2-94a0-2310009055e7"
            cd ./projects
                svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
                func_assert_last_cmd_exited_without_errors_t1 "343ff434-d248-446b-b2a0-2310009055e7"
            cd ..
            #--------
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/projects" \
                "d4752340-e575-416d-a2a0-2310009055e7"
            cd ./projects
                svn co http://llvm.org/svn/llvm-project/test-suite/trunk test-suite
                func_assert_last_cmd_exited_without_errors_t1 "3218f2a1-8c80-4036-b1a0-2310009055e7"
            cd ..
            #--------
            make update
            func_assert_last_cmd_exited_without_errors_t1 "c6480d22-47a1-433f-a4a0-2310009055e7"
        #--------------------------------------------
        cd .. # $S_FP_LLVM
    cd .. # $S_TMP_0_SRC
} # func_download

#--------------------------------------------------------------------------

func_compile(){
    #--------------------------------------------
    local S_TMP_0="$S_FP_DIR"
    local S_TMP_0_SRC="$S_TMP_0/src"
    local S_TMP_0_INSTALLED="$S_TMP_0/installed"
    local S_TMP_0_BUILD="$S_TMP_0/build_directory"
    local S_FP_LLVM="$S_TMP_0_SRC/llvm"
    #--------------------------------------------
    func_assert_folder_exists_t1 "$S_TMP_0_SRC" \
        "9859f83a-8cd2-438a-a290-2310009055e7"
    func_assert_folder_exists_t1 "$S_TMP_0_INSTALLED" \
        "371d5771-dbb3-45ef-b890-2310009055e7"
    func_assert_folder_exists_t1 "$S_FP_LLVM" \
        "cdf98239-d332-4242-8590-2310009055e7"
    #--------------------------------------------
    mkdir -p $S_TMP_0_BUILD
    func_assert_last_cmd_exited_without_errors_t1 "1042102e-eb6f-43d6-8290-2310009055e7"
    sleep 1
    func_assert_folder_exists_t1 "$S_TMP_0_BUILD" \
        "0b046527-0ee1-4cd4-9390-2310009055e7"
    #--------------------------------------------
    cd $S_TMP_0_BUILD
        # http://llvm.org/docs/CMake.html
        #--------
        nice -n19 cmake $S_FP_LLVM  # the configure step
        func_assert_last_cmd_exited_without_errors_t1 "3b3c9945-5d76-4058-a490-2310009055e7"
        nice -n19 cmake --build . --target install
        func_assert_last_cmd_exited_without_errors_t1 "e5dc2f3f-8218-4751-8390-2310009055e7"
        nice -n19 cmake -DCMAKE_INSTALL_PREFIX=$S_TMP_0_INSTALLED -P cmake_install.cmake
        func_assert_last_cmd_exited_without_errors_t1 "e2a28f3a-f7d6-49de-b390-2310009055e7"
        #--------------------------------------------
    cd .. # $S_TMP_0_BUILD
} # func_compile



#--------------------------------------------------------------------------

if [ "$S_MODE" == "mode_download" ]; then
    func_download
else
    if [ "$S_MODE" == "mode_compile" ]; then
        func_compile
    else
        echo ""
        echo "This script is flawed."
        echo "GUID=='128daad8-9ac2-4f31-a1a0-2310009055e7'"
        echo ""
        #--------
        cd $S_FP_ORIG
        exit 1 # exiting with an error
    fi
fi

#--------------------------------------------------------------------------
 
 

