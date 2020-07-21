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
#
# The customizable part of this script starts at a line that 
# contains the word "INSTANCE". Prefix acronyms and their meanings: 
#
#     S_<the rest of the name>     --- variable that holds a string
#     S_FN_<the rest of the name>  --- variable that holds a string
#                                      that is a File Name (FN)
#
#     S_FP_<the rest of the name>  --- variable that holds a string
#                                      that is a full File Path (FP) 
#
#     SB_<the rest of the name>    --- variable that holds 
#                                      a string representation of 
#                                      a boolean value: "t" for ture and
#                                      "f" for false. Case sensitive.
#
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
#S_FP_ORIG="`pwd`"
S_VERSION_OF_THIS_SCRIPT="45316418-b2e4-4fd4-811e-0390405174e7" # a GUID

#--------------------------------------------------------------------------
func_mmmv_wait_and_sync_t1(){
    wait # for background processes started by this Bash script to exit/finish
    sync # network drives, USB-sticks, etc.
} # func_mmmv_wait_and_sync_t1


func_mmmv_ln_create_hardlink_t1() { # S_FP_TARGET  S_FP_LINK
    local S_FP_TARGET="$1" # is allowed to be a broken symlink, but 
                           # must NOT be a folder and must be 
                           # on the same filesystem volume with the S_FP_LINK .

    local S_FP_LINK="$2"   # must not exist during the call of this function .

    local SB_THROW_ON_INVALID_DATA="$3" # Optional.
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
                echo "GUID=='1afe1a67-9b9a-4400-a31e-0390405174e7'"
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
                echo "GUID=='c159e824-dab9-4a2e-b11e-0390405174e7'"
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
            echo "GUID=='f200952f-2d7f-4cb5-a51e-0390405174e7'"
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
                echo "GUID=='0719ac14-ce26-48f7-840e-0390405174e7'"
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
                    echo "GUID=='86d3be40-c530-4fb2-930e-0390405174e7'"
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
                echo "GUID=='5983b791-5f5c-4b89-a10e-0390405174e7'"
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
    local S_TMP_0="not_set_yet GUID=='27fd5723-5a86-4c7f-b20e-0390405174e7'"
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
            echo "GUID=='0c996112-a47e-4d84-b30e-0390405174e7'"
            echo ""
            if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                exit 1
            fi
            SB_DO_NOT_CREATE_THE_HARDLINK="t" # here to skip some tests later
        fi
        func_mmmv_wait_and_sync_t1
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
                    echo "GUID=='da647220-67c5-465c-850e-0390405174e7'"
                    echo ""
                    S_TMP_0="t"
                else
                    if [ -e "$S_FP_TARGET" ]; then # symlink to a folder or a file
                        if [ ! -e "$S_FP_LINK" ]; then
                            echo ""
                            echo "Problem detection branch marker "
                            echo "GUID=='6a272f23-f8bd-4b60-a10e-0390405174e7'"
                            echo ""
                            S_TMP_0="t"
                        else
                            if [ -d "$S_FP_TARGET" ]; then
                                if [ ! -d "$S_FP_LINK" ]; then
                                    echo ""
                                    echo "Problem detection branch marker "
                                    echo "GUID=='3ddaef4a-f543-47e1-940e-0390405174e7'"
                                    echo ""
                                    S_TMP_0="t"
                                fi
                            else
                                if [ -d "$S_FP_LINK" ]; then
                                    echo ""
                                    echo "Problem detection branch marker "
                                    echo "GUID=='2f26f625-d7e0-407e-a50e-0390405174e7'"
                                    echo ""
                                    S_TMP_0="t"
                                fi
                            fi
                        fi
                    else # broken symlink
                        if [ -e "$S_FP_LINK" ]; then
                            echo ""
                            echo "Problem detection branch marker "
                            echo "GUID=='924ea93e-885a-45b2-940e-0390405174e7'"
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
                    echo "GUID=='1357ea35-ecc1-47c3-a10e-0390405174e7'"
                    echo ""
                    S_TMP_0="t"
                else
                    if [ -d "$S_FP_TARGET" ]; then # just an extra test
                        echo ""
                        echo "Problem detection branch marker "
                        echo "GUID=='eaf75e3b-9ba4-4d2a-810e-0390405174e7'"
                        echo ""
                        S_TMP_0="t"
                    else
                        if [ -h "$S_FP_LINK" ]; then
                            echo ""
                            echo "Problem detection branch marker "
                            echo "GUID=='4f69f045-3cfa-4314-930e-0390405174e7'"
                            echo ""
                            S_TMP_0="t"
                        else
                            if [ ! -e "$S_FP_LINK" ]; then
                                echo ""
                                echo "Problem detection branch marker "
                                echo "GUID=='3a8edc38-6e71-4d97-820e-0390405174e7'"
                                echo ""
                                S_TMP_0="t"
                            else
                                if [ -d "$S_FP_LINK" ]; then
                                    echo ""
                                    echo "Problem detection branch marker "
                                    echo "GUID=='de36c212-b831-4a5b-ba0e-0390405174e7'"
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
                echo "GUID=='35001d01-fab6-4acd-820e-0390405174e7'"
                echo ""
                if [ "$SB_THROW_ON_INVALID_DATA" == "t" ]; then
                    exit 1
                fi
            else
                if [ "$S_TMP_0" != "f" ]; then
                    echo ""
                    echo "The implementation of this function is flawed."
                    echo "Aborting script."
                    echo "GUID=='b989474f-be1c-4af4-b30e-0390405174e7'"
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
            echo "GUID=='cb497439-cf0a-42fb-b2fd-0390405174e7'"
            echo ""
            exit 1
        fi
    fi
} # func_mmmv_ln_create_hardlink_t1


func_mmmv_ln_create_hardlink_t2() { # S_FP_TARGET  S_FP_LINK
    local S_FP_TARGET="$1" # is allowed to be a broken symlink, but 
                           # must NOT be a folder and must be 
                           # on the same filesystem volume with the S_FP_LINK .

    local S_FP_LINK="$2"   # must not exist during the call of this function .

    local SB_THROW_ON_INVALID_DATA="$3" # Optional.
                                        # Domain: {"t","f","",<unassigned>}.
                                        # default=="t"
    #----------------------------------------------------------------------
    local S_TMP_0=""
    if [ -e "$S_FP_LINK" ]; then
        rm -f $S_FP_LINK
        S_TMP_0="$?"
        if [ "$S_TMP_0" != "0" ]; then 
            echo ""
            echo "Failed to delete "
            echo ""
            echo "    $S_FP_LINK"
            echo ""
            echo "Error code $S_TMP_0."
            echo "Aborting script."
            echo "GUID=='2473f614-f2fa-4c47-84fd-0390405174e7'"
            echo ""
            exit 1
        fi
        func_mmmv_wait_and_sync_t1
    fi
    #----------------
    local SB_0="t"
    if [ "$SB_THROW_ON_INVALID_DATA" != "" ]; then
        SB_0="$SB_THROW_ON_INVALID_DATA"
    fi
    #----------------
    func_mmmv_ln_create_hardlink_t1 \
        "$S_FP_TARGET"  "$S_FP_LINK" "$SB_0"
} # func_mmmv_ln_create_hardlink_t2


#-------------SCRIPT--INSTANCE--SPECIFIC--CUSTOMIZATION--START-------------
if [ "$MMMV_BASHRC_LC_DEVELOPMENT_MACHINE_PSEUDONAME" != "mmmv_dev_machine_0001" ]; then
    echo ""
    echo "Please customize this script to Your environment."
    echo "Aborting script without doing anything."
    echo "GUID=='1b608ac1-66a0-4922-a3fd-0390405174e7'"
    echo ""
    exit 1 
fi

S_FP_EXPECTED_PATH_OF_THE_PARENT_FOLDER_OF_THIS_SCRIPT="$HOME/m_local/kodu_punkt/liivakastid/vimrc_ja_bashrc_ja_muu_rc"
if [ "$S_FP_DIR" != "$S_FP_EXPECTED_PATH_OF_THE_PARENT_FOLDER_OF_THIS_SCRIPT" ]; then
    echo ""
    echo "Please customize this script to Your environment."
    echo "Aborting script without doing anything."
    echo "GUID=='e57c9937-40bd-49c9-b3fd-0390405174e7'"
    echo ""
    exit 1 
fi

#--------------------------------------------------------------------------
S_FP_ORIGIN_PARENT_FOLDER="$HOME/Projektid/dokumentatsioon/mmmv_notes/juur_liivakast/mmmv_notes/mmmv_utilities/src/various_Bash_scripts/_bashrc_subparts/website_copy_creation"
S_FP_LINK_PARENT_FOLDER="$HOME/m_local/kodu_punkt/liivakastid/vimrc_ja_bashrc_ja_muu_rc"
#--------------------------------------------------------------------------
S_FN="_bashrc_subpart_create_redirection_HTML"
S_FP_ORIGIN="$S_FP_ORIGIN_PARENT_FOLDER/$S_FN"
S_FP_LINK="$S_FP_LINK_PARENT_FOLDER/$S_FN"
func_mmmv_ln_create_hardlink_t2 "$S_FP_ORIGIN" "$S_FP_LINK"
#-----------------------------
S_FN="_bashrc_subpart_wget"
S_FP_ORIGIN="$S_FP_ORIGIN_PARENT_FOLDER/$S_FN"
S_FP_LINK="$S_FP_LINK_PARENT_FOLDER/$S_FN"
func_mmmv_ln_create_hardlink_t2 "$S_FP_ORIGIN" "$S_FP_LINK"
#-----------------------------

#==========================================================================
