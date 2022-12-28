#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
#
# The core idea at this file is based on a Bash line by
# Raivo Laanemets (infdot.com, "inf" like "infinity"):
#     curl "https://koodivaramu.eesti.ee/api/v4/projects?per_page=100" | jq '.[].ssh_url_to_repo'
#        
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
# Tested on ("uname -a")
# Linux hoidla01 4.19.0-22-amd64 #1 SMP Debian 4.19.260-1 (2022-09-29) x86_64 GNU/Linux
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_FP_CLONESCRIPT="$S_FP_DIR/clonescript_of_koodivaramu_eesti_ee.bash"
#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
    wait # for sync
} # func_mmmv_wait_and_sync_t1
#--------------------------------------------------------------------------
func_mmmv_exit_if_not_on_path_t2b() { # S_COMMAND_NAME
    local S_COMMAND_NAME="$1"
    #----------------------------------------------------------------------
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME 2>/dev/null`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo -e "\e[31mCommand \"$S_COMMAND_NAME\" could not be found from the PATH. \e[39m"
        echo "The execution of this Bash script is aborted."
        echo "GUID=='48705142-f224-47a4-b367-c21131c1c6e7'"
        echo ""
        cd "$S_FP_ORIG"
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2b

func_mmmv_exit_if_not_on_path_t2b "curl"
func_mmmv_exit_if_not_on_path_t2b "jq"
func_mmmv_exit_if_not_on_path_t2b "sed"
func_mmmv_exit_if_not_on_path_t2b "which" # it might be missing at Android userspace 
                                          # Linux distros like the Termux.
#--------------------------------------------------------------------------
func_insert_line_t1(){
    #--------------------
    printf "%s" "#-------------------" >> $S_FP_CLONESCRIPT # 19 times "-"
    func_mmmv_wait_and_sync_t1
    for I in {1..11}; do 
        printf "%s" "-----" >> $S_FP_CLONESCRIPT # 5 times "-"
    done # loop
    func_mmmv_wait_and_sync_t1
    echo "" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    #--------------------
} # func_insert_line_t1
#--------------------------------------------------------------------------
func_insert_line_t2(){
    #--------------------
    printf "%s" "#===================" >> $S_FP_CLONESCRIPT # 19 times "="
    func_mmmv_wait_and_sync_t1
    for I in {1..11}; do 
        printf "%s" "=====" >> $S_FP_CLONESCRIPT # 5 times "="
    done # loop
    func_mmmv_wait_and_sync_t1
    echo "" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    #--------------------
} # func_insert_line_t2
#--------------------------------------------------------------------------
func_generate_koodivaramu_eesti_ee_clonescript_boilerplate(){
    #--------------------
    echo "#!/usr/bin/env bash"   >  $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t2
    #--------------------
    echo "# This file is in public domain." >> $S_FP_CLONESCRIPT
    echo "# The following line is a spdx.org license label line:" >> $S_FP_CLONESCRIPT
    echo "# SPDX-License-Identifier: 0BSD" >> $S_FP_CLONESCRIPT
    func_insert_line_t1
    #--------------------
    echo "# Clonescript generation start-time:" >> $S_FP_CLONESCRIPT
    echo "# `date`" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t1
    #--------------------
    echo "S_FP_DIR=\"\$( cd \"\$( dirname \"\${BASH_SOURCE[0]}\" )\" && pwd )\"" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    #--------------------
    echo "S_FP_ORIG=\"\`pwd\`\"" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    #--------------------
    echo "S_FP_CLONES=\"\$S_FP_DIR/the_repository_clones\"" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t1
    #--------------------
    echo "func_mmmv_wait_and_sync_t1(){" >> $S_FP_CLONESCRIPT
    echo "    wait # for background processes started by this Bash script to exit/finish" >> $S_FP_CLONESCRIPT
    echo "    sync # network drives, USB-sticks, etc." >> $S_FP_CLONESCRIPT
    echo "    wait # for sync" >> $S_FP_CLONESCRIPT
    echo "} # func_mmmv_wait_and_sync_t1" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t1
    #--------------------
    echo "func_mmmv_assert_error_code_zero_t1(){" >> $S_FP_CLONESCRIPT
    echo "    local S_ERR_CODE=\"\$1\" # the \"\$?\"" >> $S_FP_CLONESCRIPT
    echo "    local S_GUID_CANDIDATE=\"\$2\"" >> $S_FP_CLONESCRIPT
    echo "    #----------------------------------------------------------------------" >> $S_FP_CLONESCRIPT
    echo "    if [ \"\$S_GUID_CANDIDATE\" == \"\" ]; then" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        echo -e \"\\e[31mThe Bash code that calls this function is flawed. \\e[39m\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"    S_GUID_CANDIDATE==\\\"\\\"\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"but it is expected to be a GUID.\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"Aborting script.\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"GUID=='46ec325f-0c81-4f02-8167-c21131c1c6e7'\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"S_GUID_CANDIDATE=='\$S_GUID_CANDIDATE'\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        #--------" >> $S_FP_CLONESCRIPT
    echo "        cd \"\$S_FP_ORIG\"" >> $S_FP_CLONESCRIPT
    echo "        exit 1" >> $S_FP_CLONESCRIPT
    echo "    fi" >> $S_FP_CLONESCRIPT
    echo "    #------------------------------" >> $S_FP_CLONESCRIPT
    echo "    # If the \"\$?\" were evaluated in this function, " >> $S_FP_CLONESCRIPT
    echo "    # then it would be \"0\" even, if it is" >> $S_FP_CLONESCRIPT
    echo "    # something else at the calling code." >> $S_FP_CLONESCRIPT
    echo "    if [ \"\$S_ERR_CODE\" != \"0\" ];then" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"Something went wrong. Error code: \$S_ERR_CODE\"" >> $S_FP_CLONESCRIPT
    echo "        echo -e \"\\e[31mAborting script. \\e[39m\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"GUID=='a854811e-d953-4a3b-9567-c21131c1c6e7'\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"S_GUID_CANDIDATE=='\$S_GUID_CANDIDATE'\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        #--------" >> $S_FP_CLONESCRIPT
    echo "        cd \"\$S_FP_ORIG\"" >> $S_FP_CLONESCRIPT
    echo "        exit 1" >> $S_FP_CLONESCRIPT
    echo "    fi" >> $S_FP_CLONESCRIPT
    echo "    #------------------------------" >> $S_FP_CLONESCRIPT
    echo "} # func_mmmv_assert_error_code_zero_t1" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t1
    #--------------------
    echo "func_mmmv_exit_if_not_on_path_t2b() { # S_COMMAND_NAME" >> $S_FP_CLONESCRIPT
    echo "    local S_COMMAND_NAME=\"\$1\"" >> $S_FP_CLONESCRIPT
    echo "    #----------------------------------------------------------------------" >> $S_FP_CLONESCRIPT
    echo "    local S_LOCAL_VARIABLE=\"\`which \$S_COMMAND_NAME 2>/dev/null\`\"" >> $S_FP_CLONESCRIPT
    echo "    if [ \"\$S_LOCAL_VARIABLE\" == \"\" ]; then" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        echo -e \"\\e[31mCommand \\\"\$S_COMMAND_NAME\\\" could not be found from the PATH. \\e[39m\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"The execution of this Bash script is aborted.\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"GUID=='48a76001-57df-4c4d-a367-c21131c1c6e7'\"" >> $S_FP_CLONESCRIPT
    echo "        echo \"\"" >> $S_FP_CLONESCRIPT
    echo "        cd \"\$S_FP_ORIG\"" >> $S_FP_CLONESCRIPT
    echo "        exit 1;" >> $S_FP_CLONESCRIPT
    echo "    fi" >> $S_FP_CLONESCRIPT
    echo "} # func_mmmv_exit_if_not_on_path_t2b" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    echo "" >> $S_FP_CLONESCRIPT
    echo "func_mmmv_exit_if_not_on_path_t2b \"git\"" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t1
    #--------------------
    echo "mkdir -p \$S_FP_CLONES" >> $S_FP_CLONESCRIPT
    echo "func_mmmv_assert_error_code_zero_t1 \"\$?\" \\" >> $S_FP_CLONESCRIPT
    echo '    "f8fa793e-d284-4411-9367-c21131c1c6e7"' >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    #--------------------
    echo "cd \$S_FP_CLONES" >> $S_FP_CLONESCRIPT
    echo "func_mmmv_assert_error_code_zero_t1 \"\$?\" \\" >> $S_FP_CLONESCRIPT
    echo '    "b2692714-b1c7-4e47-b367-c21131c1c6e7"' >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    func_insert_line_t1
    #--------------------
    echo "" >> $S_FP_CLONESCRIPT
    func_mmmv_wait_and_sync_t1
    #--------------------
} # func_generate_koodivaramu_eesti_ee_clonescript_boilerplate
#--------------------------------------------------------------------------
func_generate_koodivaramu_eesti_ee_clonescript_suffix(){
    #--------------------
    func_insert_line_t2
    #--------------------
} # func_generate_koodivaramu_eesti_ee_clonescript_suffix
#--------------------------------------------------------------------------
func_generate_koodivaramu_eesti_ee_clonescript_optionally_update_GUIDs(){
    #--------------------
    if [ "`which ruby 2> /dev/null`" != "" ]; then
        # UpGUID is implemented in Ruby.
        # https://github.com/martinvahi/mmmv_devel_tools/tree/master/src/mmmv_devel_tools/GUID_trace/src/UpGUID
        if [ "`which upguid 2> /dev/null`" != "" ]; then
            func_mmmv_wait_and_sync_t1
            upguid -f $S_FP_CLONESCRIPT 
            func_mmmv_wait_and_sync_t1
            chmod -f -R 0700 $S_FP_CLONESCRIPT
            func_mmmv_wait_and_sync_t1
        fi
    fi
    #--------------------
} # func_generate_koodivaramu_eesti_ee_clonescript_optionally_update_GUIDs
#--------------------------------------------------------------------------
# The original Bash line by 
# Raivo Laanemets (infdot.com, "inf" like "infinity"):
#     curl "https://koodivaramu.eesti.ee/api/v4/projects?per_page=100" | jq '.[].ssh_url_to_repo'
func_generate_koodivaramu_eesti_ee_clonescript(){
    #--------------------
    func_generate_koodivaramu_eesti_ee_clonescript_boilerplate
    #--------------------
    # TODO: get rid of the future bug that will occur, when
    #       the number of "pages" exceeds 60. The bugfix might
    #       ruin the simplicity of this code, 
    #       but it is a matter of choice. As of 2022_12_21
    #       the number of 100-repository pages at the koodivaramu.eesti.ee
    #       GitLab collection of repositories is 2 ("two"), id est
    #       the whole collection consists of less than 200 repositories.
    #
    # The API gives something like 
    #
    #     "git@koodivaramu.eesti.ee:xtss/xtss-rights.git"
    #
    # but the actual cloning address that MIGHT work is like 
    #
    #     "https://koodivaramu.eesti.ee/xtss/xtss-rights.git"
    #
    for I in {1..60}; do 
        curl "https://koodivaramu.eesti.ee/api/v4/projects?per_page=100&page=$I" | \
            jq '.[].ssh_url_to_repo' | \
            sed -e 's/^["]git[@]koodivaramu[.]eesti[.]ee[:]/"https:\/\/koodivaramu.eesti.ee\//' | \
            sed -e 's/^["]/nice -n 15 git clone --recursive \\\n    "/' | \
            sed -e 's/["]$/"\nfunc_mmmv_assert_error_code_zero_t1 "$?" \\\n    "f56d2efd-8b48-4ff1-8267-c21131c1c6e7"\nfunc_mmmv_wait_and_sync_t1\n/' \
            >> $S_FP_CLONESCRIPT
        func_mmmv_wait_and_sync_t1
    done # loop
    #--------------------
    func_generate_koodivaramu_eesti_ee_clonescript_suffix
    func_generate_koodivaramu_eesti_ee_clonescript_optionally_update_GUIDs
    #--------------------
} # func_generate_koodivaramu_eesti_ee_clonescript
#--------------------------------------------------------------------------
func_generate_koodivaramu_eesti_ee_clonescript
exit 0
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="2a6d4a55-9486-4466-a367-c21131c1c6e7"
#==========================================================================
