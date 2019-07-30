#!/usr/bin/env bash
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The main use case of this Bash script (template) is the restoration 
# of hardlinks that reside in multiple repositories at once. 
# For example, as of 2019_07 the Git commit operation tends to change 
# a hardlink to an individual file. The storing of a hardlink to 
# the repository in stead of storing a symlink to the repository increases
# the probability that all of the project sub-components are available.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#S_FP_ORIG="`pwd`"
S_VERSION_OF_THIS_SCRIPT="274106b4-4613-4200-a8ed-510320e173e7" # a GUID

#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_mmmv_wait_and_sync_t1


func_mmmv_ln_create_hardlink_t1() { # S_FP_TARGET  S_FP_LINK
    local S_FP_TARGET=$1 # is allowed to be a broken symlink, but 
                         # must NOT be a folder and must be 
                         # on the same filesystem volume with the S_FP_LINK .

    local S_FP_LINK=$2   # must not exist during the call of this function .

    local SB_THROW_ON_INVALID_DATA=$3 # Optional.
                                      # Domain: {"t","f","",<unassigned>}.
                                      # default=="t"
    #----------------------------------------------------------------------
    if [ "$SB_THROW_ON_INVALID_DATA" == "" ]; then
        SB_THROW_ON_INVALID_DATA="t"
    else
        if [ "$SB_THROW_ON_INVALID_DATA" != "t" ]; then
            if [ "$SB_THROW_ON_INVALID_DATA" != "f" ]; then
                echo ""
                echo "The code that calls this function is flawed."
                echo "Domain(SB_THROW_ON_INVALID_DATA) == "
                echo "    {\"t\",\"f\",\"\",<unassigned>}"
                echo ""
                echo "    SB_THROW_ON_INVALID_DATA==\"$SB_THROW_ON_INVALID_DATA\""
                echo ""
                echo "Aborting script."
                echo "GUID=='eb398cf1-7bd1-435d-87fe-510320e173e7'"
                echo ""
                exit 1 # because of a code defect, not just invalid data.
            fi
        fi
    fi
    local SB_DO_NOT_CREATE_THE_HARDLINK="f" #a fallback for not throwing/exiting
    #----------------------------------------------------------------------
    # The original file and the hardlink share the same inode 
    # and therefore the original file and the hardlink are
    # distinguishable from each other only by their paths. Hardlinks
    # to folders do not exist, can not be made, because that would
    # change a file system tree into a graph that has true loops,
    # not just symlink based loops. Hardlinks form a relation
    # between a file path and an inode of a file. Hardlinks to 
    # symlinks are possible, because symlinks are special purpose files
    # regardless of whether the symlinks reference a folder or a file or another symlink.
    # Revision control systems (Git, Subversion, etc.)
    # can/at_least_sometimes_do break hardlinks by making physical
    # copies of the files that are referenced by hardlinks.
    #
    #     https://superuser.com/questions/12972/how-can-you-see-the-actual-hard-link-by-ls
    #     (archival copy: https://archive.is/8feTw )
    #
    #     http://www.linfo.org/hard_link.html
    #     (archival copy: https://archive.is/HXFYC )
    #
    # Inode numbers can be displayed by executing
    #
    #     ls -l --inode   # short version is: "ls -li "
    # 
    # A 2019_06_30 citation of user "ninjalj" 2017_05_02 comment from  
    # 
    #     https://stackoverflow.com/questions/43733893/when-rm-a-file-but-hard-link-still-there-the-inode-will-be-marked-unused
    #     (archival copy: https://archive.is/5j0cv )
    #     ----citation--start----
    #     i-nodes contain a link count (visible in ls -l output). 
    #     Each hard link increments that count. Unlinking 
    #     (removing a link, be it the original filename->inode 
    #     link, or some hard link added later, which is the only thing 
    #     users can request) decrements the count.  
    #     ----citation--end------
    #
    #----------------------------------------------------------------------
    if [ -e "$S_FP_LINK" ]; then 
        if [ -d "$S_FP_LINK" ]; then # folder or a symlink to a folder
            if [ ! -h "$S_FP_LINK" ]; then # not a symlink, therefore a folder
                echo ""
                echo "The hardlink candidate, the "
                echo ""
                echo "    $S_FP_LINK"
                echo ""
                echo "already exists and it is a folder, not a symlink."
                echo "According to the implementation of this function "
                echo "this is a situation, where there is probably something wrong,"
                echo "because hardlinks can be made only to files and symlinks, "
                echo "regardless of whether the symlinks are broken or not."
                echo "Skipping the creation of the hardlink with the target path of "
                echo ""
                echo "    $S_FP_TARGET"
                echo ""
                echo "GUID=='f1436a06-1220-48d8-bb3d-510320e173e7'"
                echo ""
                if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                    exit 1
                fi
                SB_DO_NOT_CREATE_THE_HARDLINK="t"
            # else # symlink to a folder
            fi
        # else # file or a symlink to a file
        fi
        if [ "$SB_DO_NOT_CREATE_THE_HARDLINK" == "f" ]; then
            echo ""
            echo "According to the specification of this function "
            echo "the hardlink, which in the case of this function call "
            echo "has the path of "
            echo ""
            echo "    $S_FP_LINK"
            echo ""
            echo "must not exist before the call to this function."
            echo "GUID=='20ff4d15-64ba-431d-a54d-510320e173e7'"
            echo ""
            if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                exit 1
            fi
            SB_DO_NOT_CREATE_THE_HARDLINK="t"
        fi
    else # missing or a broken symlink
        if [ "$SB_DO_NOT_CREATE_THE_HARDLINK" == "f" ]; then
            if [ -h "$S_FP_LINK" ]; then # a broken symlink, therefore NOT missing
                echo ""
                echo "The hardlink candidate, the "
                echo ""
                echo "    $S_FP_LINK"
                echo ""
                echo "already exists and it is a broken symlink. According to "
                echo "the specification of this function the hardlink "
                echo "must not exist before the call to this function."
                echo "GUID=='15d5a185-a1d2-4e1b-b04d-510320e173e7'"
                echo ""
                if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                    exit 1
                fi
                SB_DO_NOT_CREATE_THE_HARDLINK="t"
            fi
        fi
    fi
    #----------------------------------------------------------------------
    if [ "$SB_DO_NOT_CREATE_THE_HARDLINK" == "f" ]; then
        if [ -e "$S_FP_TARGET" ]; then
            if [ -d "$S_FP_TARGET" ]; then # a folder or a symlink to a folder
                if [ ! -h "$S_FP_TARGET" ]; then # not a symlink, therefore a folder
                    echo ""
                    echo "The hardlink target candidate, the "
                    echo ""
                    echo "    $S_FP_TARGET"
                    echo ""
                    echo "is a folder, not a symlink to a folder. "
                    echo "Hardlinks can be made only to files and symlinks, "
                    echo "regardless of whether the symlinks are broken or not."
                    echo "Skipping the creation of the hardlink with the path of "
                    echo ""
                    echo "    $S_FP_LINK"
                    echo ""
                    echo "GUID=='85f1ff9a-1e10-4e89-8b3d-510320e173e7'"
                    echo ""
                    if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                        exit 1
                    fi
                    SB_DO_NOT_CREATE_THE_HARDLINK="t"
                # else # symlink to a folder
                fi
            # else # file or a symlink to a file
            fi
        else # missing or a broken symlink
            if [ ! -h "$S_FP_TARGET" ]; then # not a symlink, therefore missing
                echo ""
                echo "The hardlink target candidate with the path of  "
                echo ""
                echo "    $S_FP_TARGET"
                echo ""
                echo "does not exist. Skipping the creation of a hardlink"
                echo "with the path of "
                echo ""
                echo "    $S_FP_LINK"
                echo ""
                echo "GUID=='91c61bfb-bb48-4b0e-811d-510320e173e7'"
                echo ""
                if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                    exit 1
                fi
                SB_DO_NOT_CREATE_THE_HARDLINK="t"
            # else # broken symlink
                   # It is possible to create hardlinks to broken symlinks.
            fi
        fi
    fi
    #----------------------------------------------------------------------
    local S_TMP_0="not_set_yet GUID=='700a3b72-afd6-4d48-b25d-510320e173e7'"
    if [ "$SB_DO_NOT_CREATE_THE_HARDLINK" == "f" ]; then
        ln  "$S_FP_TARGET" "$S_FP_LINK" 
        S_TMP_0="$?"
        if [ "$S_TMP_0" != "0" ]; then
            echo ""
            echo "The creation of a hardlink with the path of "
            echo ""
            echo "    $S_FP_LINK"
            echo ""
            echo "and the target path of "
            echo ""
            echo "    $S_FP_TARGET"
            echo ""
            echo "failed. The ln exited with the error code of $S_TMP_0 ."
            echo "GUID=='441584e2-292e-474b-849d-510320e173e7'"
            echo ""
            if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                exit 1
            fi
            SB_DO_NOT_CREATE_THE_HARDLINK="t" # here to skip some tests later
        fi
        #------------------------------------------------------------------
        #func_mmmv_wait_and_sync_t1 # inlined at the next 2 lines
        wait # for background processes started by this Bash script to exit/finish
        sync # USB-sticks, etc.
        #------------------------------------------------------------------
        if [ "$SB_DO_NOT_CREATE_THE_HARDLINK" == "f" ]; then
            #--------------------------------------------------------------
            S_TMP_0="f" # "t" --- potential error condition detected
                        # "f" --- no error detected
            #--------------------------------------------------------------
            if [ -h "$S_FP_TARGET" ]; then
                # A broken symlink, including a hardlink to a broken symlink
                # gives "false" with the Bash "-e".
                if [ ! -h "$S_FP_LINK" ]; then
                    echo ""
                    echo "Problem detection branch marker "
                    echo "GUID=='242013ff-3f46-413d-833d-510320e173e7'"
                    echo ""
                    S_TMP_0="t"
                else
                    if [ -e "$S_FP_TARGET" ]; then # symlink to a folder or a file
                        if [ ! -e "$S_FP_LINK" ]; then
                            echo ""
                            echo "Problem detection branch marker "
                            echo "GUID=='34dcf6b5-f501-412b-bf1d-510320e173e7'"
                            echo ""
                            S_TMP_0="t"
                        else
                            if [ -d "$S_FP_TARGET" ]; then
                                if [ ! -d "$S_FP_LINK" ]; then
                                    echo ""
                                    echo "Problem detection branch marker "
                                    echo "GUID=='5c26cf85-0bf7-4d1d-864d-510320e173e7'"
                                    echo ""
                                    S_TMP_0="t"
                                fi
                            else
                                if [ -d "$S_FP_LINK" ]; then
                                    echo ""
                                    echo "Problem detection branch marker "
                                    echo "GUID=='69571325-d3fe-4480-8e4d-510320e173e7'"
                                    echo ""
                                    S_TMP_0="t"
                                fi
                            fi
                        fi
                    else # broken symlink
                        if [ -e "$S_FP_LINK" ]; then
                            echo ""
                            echo "Problem detection branch marker "
                            echo "GUID=='2497666f-5276-4c99-b82d-510320e173e7'"
                            echo ""
                            S_TMP_0="t"
                        fi
                    fi
                fi
            else # As the S_FP_LINK can never be a hardlink to a folder and
                 # the S_FP_TARGET is not a symlink at this branch, the 
                 # S_FP_TARGET is a file. Therefore at this branch 
                 # the S_FP_LINK is also a file.
                if [ ! -e "$S_FP_TARGET" ]; then # just an extra test
                    echo ""
                    echo "Problem detection branch marker "
                    echo "GUID=='2c007e53-45fa-464b-833d-510320e173e7'"
                    echo ""
                    S_TMP_0="t"
                else
                    if [ -d "$S_FP_TARGET" ]; then # just an extra test
                        echo ""
                        echo "Problem detection branch marker "
                        echo "GUID=='28261012-e66b-4884-b03d-510320e173e7'"
                        echo ""
                        S_TMP_0="t"
                    else
                        if [ -h "$S_FP_LINK" ]; then
                            echo ""
                            echo "Problem detection branch marker "
                            echo "GUID=='4d3d9425-0bfc-471b-8e4d-510320e173e7'"
                            echo ""
                            S_TMP_0="t"
                        else
                            if [ ! -e "$S_FP_LINK" ]; then
                                echo ""
                                echo "Problem detection branch marker "
                                echo "GUID=='48d84695-f8a5-4d2f-974d-510320e173e7'"
                                echo ""
                                S_TMP_0="t"
                            else
                                if [ -d "$S_FP_LINK" ]; then
                                    echo ""
                                    echo "Problem detection branch marker "
                                    echo "GUID=='5f0dc545-a148-426d-aa2c-510320e173e7'"
                                    echo ""
                                    S_TMP_0="t"
                                fi
                            fi
                        fi
                    fi
                fi
            fi
            #--------------------------------------------------------------
            if [ "$S_TMP_0" == "t" ]; then
                echo ""
                echo "The creation of a hardlink with the path of "
                echo ""
                echo "    $S_FP_LINK "
                echo ""
                echo "and the target path of "
                echo ""
                echo "    $S_FP_TARGET"
                echo ""
                echo "might have succeeded, but did not go as expected."
                echo "The ln command succeeded, but there might have been "
                echo "some other operating system processes that altered some "
                echo "related files or folders or symlinks on disk before "
                echo "this Bash function could exit. One possible debugging "
                echo "idea is that it is possible to chain symlinks "
                echo "together by making a symlink to symlink that references "
                echo "a symlink that references "
                echo "a symlink that references "
                echo "a symlink that references "
                echo "a symlink that references ..."
                echo "and the operating system processes might have "
                echo "altered any of the symlinks in the chain, including "
                echo "the file or folder at the very end of the symlink chain."
                echo "GUID=='c5db9239-8e70-423d-aa1c-510320e173e7'"
                echo ""
                if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                    exit 1
                fi
            else
                if [ "$S_TMP_0" != "f" ]; then
                    echo ""
                    echo "The implementation of this function is flawed."
                    echo "Aborting script."
                    echo "GUID=='9e1ce421-2d05-455d-8bcc-510320e173e7'"
                    echo ""
                    exit 1
                fi
            fi
            #--------------------------------------------------------------
        fi
        #------------------------------------------------------------------
    else
        if [ "$SB_DO_NOT_CREATE_THE_HARDLINK" != "t" ]; then
            echo ""
            echo "The implementation of this function is flawed."
            echo "Aborting script."
            echo "GUID=='2b4f8005-8521-410a-bb5c-510320e173e7'"
            echo ""
            exit 1
        fi
    fi
} # func_mmmv_ln_create_hardlink_t1


#--------------ENVIRONMENT--SPECIFIC--CUSTOMIZATION--START-----------------
if [ "$MMMV_BASHRC_LC_DEVELOPMENT_MACHINE_PSEUDONAME" != "mmmv_dev_machine_0001" ]; then
    echo ""
    echo "Please customize this script to Your environment."
    echo "Aborting script without doing anything."
    echo "GUID=='8c393e22-30cf-4469-8d5c-510320e173e7'"
    echo ""
    exit 1 
fi

S_FP_EXPECTED_PATH_OF_THE_PARENT_FOLDER_OF_THIS_SCRIPT="$HOME/m_local/kodu_punkt/liivakastid/vimrc_ja_bashrc_ja_muu_rc"
if [ "$S_FP_DIR" != "$S_FP_EXPECTED_PATH_OF_THE_PARENT_FOLDER_OF_THIS_SCRIPT" ]; then
    echo ""
    echo "Please customize this script to Your environment."
    echo "Aborting script without doing anything."
    echo "GUID=='1ef97875-aad9-4e1a-aa4c-510320e173e7'"
    echo ""
    exit 1 
fi

#--------------------------------------------------------------------------
S_FN_BASHRC_SUBPART_CREATE_REDIRECTION_HTML="_bashrc_subpart_create_redirection_HTML"
S_FN_BASHRC_SUBPART_WGET="_bashrc_subpart_wget"
#-----------------------------
S_FP_ORIGIN_PARENT_FOLDER="$HOME/Projektid/dokumentatsioon/mmmv_notes/juur_liivakast/mmmv_notes/mmmv_utilities/src/various_Bash_scripts/_bashrc_subparts/website_copy_creation"
S_FP_LINK_PARENT_FOLDER="$HOME/m_local/kodu_punkt/liivakastid/vimrc_ja_bashrc_ja_muu_rc"
#-----------------------------
S_FP_ORIGIN_BASHRC_SUBPART_CREATE_REDIRECTION_HTML="$S_FP_ORIGIN_PARENT_FOLDER/$S_FN_BASHRC_SUBPART_CREATE_REDIRECTION_HTML"
S_FP_ORIGIN_S_FN_BASHRC_SUBPART_WGET="$S_FP_ORIGIN_PARENT_FOLDER/$S_FN_BASHRC_SUBPART_WGET"
#-----------------------------
S_FP_LINK_BASHRC_SUBPART_CREATE_REDIRECTION_HTML="$S_FP_LINK_PARENT_FOLDER/$S_FN_BASHRC_SUBPART_CREATE_REDIRECTION_HTML"
S_FP_LINK_S_FN_BASHRC_SUBPART_WGET="$S_FP_LINK_PARENT_FOLDER/$S_FN_BASHRC_SUBPART_WGET"
#-----------------------------
rm -f "$S_FP_LINK_BASHRC_SUBPART_CREATE_REDIRECTION_HTML"
rm -f "$S_FP_LINK_S_FN_BASHRC_SUBPART_WGET"
func_mmmv_wait_and_sync_t1

func_mmmv_ln_create_hardlink_t1 \
"$S_FP_ORIGIN_BASHRC_SUBPART_CREATE_REDIRECTION_HTML" "$S_FP_LINK_BASHRC_SUBPART_CREATE_REDIRECTION_HTML"

func_mmmv_ln_create_hardlink_t1 \
"$S_FP_ORIGIN_S_FN_BASHRC_SUBPART_WGET" "$S_FP_LINK_S_FN_BASHRC_SUBPART_WGET"


#==========================================================================
