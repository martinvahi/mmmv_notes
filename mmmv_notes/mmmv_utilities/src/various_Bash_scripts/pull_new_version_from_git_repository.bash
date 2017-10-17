#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#--------------------------------------------------------------------------
# For copy-pasting to the ~/.bashrc
#
#     alias mmmv_cre_git_clone="cp $PATH_TO_THE<$S_FP_DIR>/pull_new_version_from_git_repository ./; mkdir -p ./the_repository_clones;"
#
#--------------------------------------------------------------------------


fun_assert_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE=$1 # first function argument
    local S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE\" to be on the PATH."
        echo "GUID=='5b33d722-4ad8-491b-a330-43136020a1e7'"
        echo ""
        exit 1 # exit with error
    fi
} # fun_assert_exists_on_path_t1

fun_assert_exists_on_path_t1 "ruby"
fun_assert_exists_on_path_t1 "grep"
fun_assert_exists_on_path_t1 "date"
fun_assert_exists_on_path_t1 "git"


#--------------------------------------------------------------------------
S_TMP_0="`uname -a | grep -E [Ll]inux`"
if [ "$S_TMP_0" == "" ]; then
    S_TMP_0="`uname -a | grep -E [Bb][Ss][Dd]`"
    if [ "$S_TMP_0" == "" ]; then
        echo ""
        echo "  The classical command line utilities at "
        echo "  different operating systems, for example, Linux and BSD,"
        echo "  differ. This script is designed to run only on Linux and BSD."
        echo "  If You are willing to risk that some of Your data "
        echo "  is deleted and/or Your operating system instance"
        echo "  becomes permanently flawed, to the point that "
        echo "  it will not even boot, then You may edit the Bash script that "
        echo "  displays this error message by modifying the test that "
        echo "  checks for the operating system type."
        echo ""
        echo "  If You do decide to edit this Bash script, then "
        echo "  a recommendation is to test Your modifications "
        echo "  within a virtual machine or, if virtual machines are not"
        echo "  an option, as some new operating system user that does not have "
        echo "  any access to the vital data/files."
        echo "  GUID=='1ee02b82-4b99-47f3-8430-43136020a1e7'"
        echo ""
        echo "  Aborting script without doing anything."
        echo ""
        echo "GUID=='7f1be944-f283-4c07-b530-43136020a1e7'"
        echo ""
        exit 1 # exit with error
    fi
fi


#--------------------------------------------------------------------------

S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"
S_FP_ARCHIVE="$S_FP_DIR/archives/$S_TIMESTAMP"
S_FP_THE_REPOSITORY_CLONES="$S_FP_DIR/the_repository_clones"
mkdir -p $S_FP_THE_REPOSITORY_CLONES

#--------------------------------------------------------------------------
S_ARGV_0="$1"
SB_SKIP_ARCHIVING="f"

fun_init_sb_archive_and_archives_folder(){
    #--------
    if [ "$S_ARGV_0" == "skip_archiving" ]; then 
        SB_SKIP_ARCHIVING="t"
    fi
    if [ "$S_ARGV_0" == "ska" ]; then # abbreviation of "skip archiving"
        SB_SKIP_ARCHIVING="t"
    fi
    #--------
    if [ "$SB_SKIP_ARCHIVING" != "t" ]; then 
        mkdir -p $S_FP_ARCHIVE
    fi
    #--------
} # fun_init_sb_archive_and_archives_folder

fun_init_sb_archive_and_archives_folder

#--------------------------------------------------------------------------

AR_REPO_FOLDER_NAMES=()

fun_assemble_array_of_repository_clone_folder_names () {
    cd $S_FP_THE_REPOSITORY_CLONES
    local S_TMP_0="`ruby -e \"ar=Array.new; Dir.glob('*').each{|x| if File.directory? x then ar<<x end}; puts(ar.to_s.gsub('[','(').gsub(']',')').gsub(',',' '))\"`"
    cd $S_FP_DIR
    local S_TMP_1="AR_REPO_FOLDER_NAMES=$S_TMP_0"
    eval ${S_TMP_1}
} # fun_assemble_array_of_repository_clone_folder_names 

fun_assemble_array_of_repository_clone_folder_names 


fun_update () {
    #--------
    local S_FP_FUNC_UPDATE_ORIG="`pwd`"
    #--------
    for s_iter in ${AR_REPO_FOLDER_NAMES[@]}; do
         S_FOLDER_NAME_OF_THE_LOCAL_COPY="$s_iter"
         echo ""
         #----
         if [ "$SB_SKIP_ARCHIVING" != "t" ]; then 
             echo "            Archiving a copy of $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
             cp -f -R $S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY $S_FP_ARCHIVE/
         else
             echo "            Skipping the archiving a copy of $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         fi
         #----
         cd $S_FP_THE_REPOSITORY_CLONES/$S_FOLDER_NAME_OF_THE_LOCAL_COPY
         echo "Checking out a newer version of $S_FOLDER_NAME_OF_THE_LOCAL_COPY"
         #--------
         # Downloads the newest version of the software to that folder.
         git checkout --force # overwrites local changes, like the "svn co"
         git pull --all --recurse-submodules --force # gets the submodules
         #----
         # http://stackoverflow.com/questions/1030169/easy-way-pull-latest-of-all-submodules
         git submodule update --init --recursive --force
         #--------
         cd $S_FP_DIR
    done
    cd $S_FP_FUNC_UPDATE_ORIG
} # fun_update 

fun_update # is a call to the function
echo ""

#==========================================================================

