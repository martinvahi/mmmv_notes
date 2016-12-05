#!/usr/bin/env bash
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
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
        echo "GUID=='cfd63737-f45c-4cd3-a3b3-c0b1e050c0e7'"
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
    echo "GUID=='5be21265-1c08-4efb-92b3-c0b1e050c0e7'"
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
        echo "GUID=='1b805943-e13e-48fe-b2b3-c0b1e050c0e7'"
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
        echo "GUID=='be29944d-2a67-4bb0-82a3-c0b1e050c0e7'"
        echo ""
        #--------
        cd $S_FP_ORIG
        exit 1 # exiting with an error
    fi
    #------------------------------
    if [ ! -e $S_FP ]; then
        if [ -h $S_FP ]; then
            echo ""
            echo "The path "
            echo ""
            echo "    $S_FP "
            echo ""
            echo "points to a broken symbolic link."
            echo "GUID==\"$S_GUID\""
            echo "GUID=='067b4f34-d28d-4702-81a3-c0b1e050c0e7'"
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
            echo "GUID=='dc32f724-a283-4f91-93a3-c0b1e050c0e7'"
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
    func_assert_last_cmd_exited_without_errors_t1 "2a49d4f3-9251-4ba4-9cb3-c0b1e050c0e7"
    sleep 1
    func_assert_folder_exists_t1 "$S_TMP_0_SRC" \
        "92df7b25-8dea-47eb-b2b3-c0b1e050c0e7"
    #----
    mkdir -p $S_TMP_0_INSTALLED
    func_assert_last_cmd_exited_without_errors_t1 "5593fb51-550a-4c3e-b1b3-c0b1e050c0e7"
    sleep 1
    func_assert_folder_exists_t1 "$S_TMP_0_INSTALLED" \
        "f16f351c-58f3-45a4-b3a3-c0b1e050c0e7"
    #----
    cp $S_FP_BASHSCRIPT_THAT_DOWNLOADS  $S_TMP_0/$S_FN_BASHSCRIPT_THAT_COMPILES
    func_assert_last_cmd_exited_without_errors_t1 "96299c5e-96aa-4b3e-81a3-c0b1e050c0e7"
    #--------------------------------------------
    cd $S_TMP_0_SRC
        svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
        func_assert_last_cmd_exited_without_errors_t1 "d201323c-2f41-4664-82a3-c0b1e050c0e7"
        sleep 1
        func_assert_folder_exists_t1 "$S_FP_LLVM" "2cdce243-5284-4e36-a3a3-c0b1e050c0e7"
        cd $S_FP_LLVM
            #--------------------------------------------
            mkdir -p ./tools
            func_assert_last_cmd_exited_without_errors_t1 "573abae4-b14a-4551-b4a3-c0b1e050c0e7"
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/tools" \
                "25dc9639-d8d0-4c92-b3a3-c0b1e050c0e7"
            cd ./tools
                svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
                func_assert_last_cmd_exited_without_errors_t1 "24d2b97e-c2f4-4d22-9aa3-c0b1e050c0e7"
            cd ..
            #--------
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/tools/clang/tools" \
                "e2e1273b-f333-4b0b-a1a3-c0b1e050c0e7"
            cd ./tools/clang/tools
                svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
                func_assert_last_cmd_exited_without_errors_t1 "1a64dec7-047c-4a91-85a3-c0b1e050c0e7"
            cd ../../..
            #--------
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/projects" \
                "43e2893f-a0e8-4a3e-a1a3-c0b1e050c0e7"
            cd ./projects
                svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
                func_assert_last_cmd_exited_without_errors_t1 "2b30d893-db4f-4ece-b2a3-c0b1e050c0e7"
            cd ..
            #--------
            sleep 1
            func_assert_folder_exists_t1 "$S_FP_LLVM/projects" \
                "8419e76e-4a16-491f-81a3-c0b1e050c0e7"
            cd ./projects
                svn co http://llvm.org/svn/llvm-project/test-suite/trunk test-suite
                func_assert_last_cmd_exited_without_errors_t1 "ef7b9e55-a905-498a-a193-c0b1e050c0e7"
            cd ..
            #--------
            make update
            func_assert_last_cmd_exited_without_errors_t1 "b1282758-be0f-4b30-a293-c0b1e050c0e7"
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
        "1502c845-5886-4bb7-b193-c0b1e050c0e7"
    func_assert_folder_exists_t1 "$S_TMP_0_INSTALLED" \
        "341542f1-23cc-4f05-b493-c0b1e050c0e7"
    func_assert_folder_exists_t1 "$S_FP_LLVM" \
        "95cd3142-c39a-42f6-a293-c0b1e050c0e7"
    #--------------------------------------------
    mkdir -p $S_TMP_0_BUILD
    func_assert_last_cmd_exited_without_errors_t1 "16e171c2-fa4b-48a1-b593-c0b1e050c0e7"
    sleep 1
    func_assert_folder_exists_t1 "$S_TMP_0_BUILD" \
        "32b887d6-2507-44ee-b593-c0b1e050c0e7"
    #--------------------------------------------
    cd $S_TMP_0_BUILD
        # http://llvm.org/docs/CMake.html
        #--------
        nice -n19 cmake $S_FP_LLVM  # the configure step
        func_assert_last_cmd_exited_without_errors_t1 "2101f631-7200-495a-b193-c0b1e050c0e7"
        nice -n19 cmake --build . --target install
        func_assert_last_cmd_exited_without_errors_t1 "9a33ed5e-8c93-4e34-8493-c0b1e050c0e7"
        nice -n19 cmake -DCMAKE_INSTALL_PREFIX=$S_TMP_0_INSTALLED -P cmake_install.cmake
        func_assert_last_cmd_exited_without_errors_t1 "dc6d6c34-5660-49b0-b193-c0b1e050c0e7"
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
        echo "GUID=='8a6c824c-899e-4b19-81a3-c0b1e050c0e7'"
        echo ""
        #--------
        cd $S_FP_ORIG
        exit 1 # exiting with an error
    fi
fi

#--------------------------------------------------------------------------
 
 

