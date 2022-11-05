#!/usr/bin/env bash
# This script is in public domain.
# Initial author: Martin.Vahi@softf1.com
#
# Tested on openSUSE Linux on 2019_03 with 
# Ruby version 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux]
#============================================================
S_FP_ORIG="`pwd`"
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#------------------------------------------------------------
cd $S_FP_DIR
#------------------------------------------------------------
S_FP_SCRIPT_1="$S_FP_DIR/pull_new_version_from_git_repository.bash"
rm -f $S_FP_SCRIPT_1
wget https://raw.githubusercontent.com/martinvahi/mmmv_notes/master/mmmv_notes/mmmv_utilities/src/various_Bash_scripts/pull_new_version_from_git_repository.bash
chmod 0700 $S_FP_SCRIPT_1
#------------------------------------------------------------
S_FP_SCRIPT_2="$S_FP_DIR/mmmv_github_repos_2_clonescript_bash_t1.rb"
rm -f $S_FP_SCRIPT_2
wget https://raw.githubusercontent.com/martinvahi/mmmv_notes/master/mmmv_notes/mmmv_utilities/src/various_Ruby_scripts/mmmv_github_repos_2_clonescript_bash_t1.rb
chmod 0700 $S_FP_SCRIPT_2
#------------------------------------------------------------
mkdir -p ./the_repository_clones
cd ./the_repository_clones
    $S_FP_SCRIPT_2 test_3 # generates a cloning script 
                          # that may be used for
                          # downloading over 80 repositories.

echo ""
echo "========microhowto==text==start========================"
echo "Both of the scripts, "
echo "the Bash script and the Ruby script, display usage "
echo "instruction if \"help\", without the quotation marks, "
echo "is given as their only command line argument."
echo "The general idea is that the "
echo ""
echo "$S_FP_SCRIPT_1"
echo ""
echo "is used for updating/managing the whole batch of "
echo "repositories at the ./the_repository_clones."
echo ""
echo "========microhowto==text==end=========================="
echo ""
#------------------------------------------------------------
cd $S_FP_ORIG
#============================================================

