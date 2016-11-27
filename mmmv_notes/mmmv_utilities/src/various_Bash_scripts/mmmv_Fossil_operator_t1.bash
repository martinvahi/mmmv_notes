#!/usr/bin/env bash
# Initial author: Martin.Vahi@softf1.com
# This file is in the public domain.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"


func_assert_exists_on_path_t2 () {
    local S_NAME_OF_THE_EXECUTABLE_1="$1" # first function argument
    local S_NAME_OF_THE_EXECUTABLE_2="$2" # optional argument
    local S_NAME_OF_THE_EXECUTABLE_3="$3" # optional argument
    local S_NAME_OF_THE_EXECUTABLE_4="$4" # optional argument
    #--------
    # Function calls like
    #
    #     func_assert_exists_on_path_t2  ""    ""  "ls"
    #     func_assert_exists_on_path_t2  "ls"  ""  "ps"
    #
    # are not allowed by the spec of this function, but it's OK to call
    #
    #     func_assert_exists_on_path_t2  "ls" "" 
    #     func_assert_exists_on_path_t2  "ls" "ps" ""
    #     func_assert_exists_on_path_t2  "ls" ""   "" ""
    #
    #
    local SB_THROW="f"
    if [ "$S_NAME_OF_THE_EXECUTABLE_1" == "" ] ; then
        SB_THROW="t"
    else
        if [ "$S_NAME_OF_THE_EXECUTABLE_2" == "" ] ; then
            if [ "$S_NAME_OF_THE_EXECUTABLE_3" != "" ] ; then
                SB_THROW="t"
            fi
            if [ "$S_NAME_OF_THE_EXECUTABLE_4" != "" ] ; then
                SB_THROW="t"
            fi
        else
            if [ "$S_NAME_OF_THE_EXECUTABLE_3" == "" ] ; then
                if [ "$S_NAME_OF_THE_EXECUTABLE_4" != "" ] ; then
                    SB_THROW="t"
                fi
            fi
        fi
    fi
    #----
    if [ "$SB_THROW" == "t" ] ; then
        echo ""
        echo "The Bash function "
        echo ""
        echo "    func_assert_exists_on_path_t2 "
        echo ""
        echo "is not designed to handle series of arguments, where "
        echo "empty strings preced non-empty strings."
        echo "GUID=='0541255e-4633-4cd9-b55c-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    if [ "$5" != "" ] ; then
        echo ""
        echo "This Bash function is designed to work with at most 4 input arguments"
        echo "GUID=='41001a45-42a8-4dd3-824c-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    #--------
    # Function calls like
    #
    #     func_assert_exists_on_path_t2 " "
    #     func_assert_exists_on_path_t2 "ls ps" # contains a space
    #
    # are not allowed.
    SB_THROW="f" 
    local S_TMP_0=""
    local S_TMP_1=""
    local S_TMP_2=""
    #----
    if [ "$SB_THROW" == "f" ] ; then
        S_TMP_0="`printf \"$S_NAME_OF_THE_EXECUTABLE_1\" | gawk '{gsub(/\s/,"");printf "%s", $1 }'`"
        if [ "$S_NAME_OF_THE_EXECUTABLE_1" != "$S_TMP_0" ] ; then
            SB_THROW="t" 
            S_TMP_1="$S_NAME_OF_THE_EXECUTABLE_1"
            S_TMP_2="GUID=='2a1fd3d0-3841-4e87-854c-f1e0305090e7'"
        fi
    fi
    #----
    if [ "$SB_THROW" == "f" ] ; then
        S_TMP_0="`printf \"$S_NAME_OF_THE_EXECUTABLE_2\" | gawk '{gsub(/\s/,"");printf "%s", $1 }'`"
        if [ "$S_NAME_OF_THE_EXECUTABLE_2" != "$S_TMP_0" ] ; then
            SB_THROW="t" 
            S_TMP_1="$S_NAME_OF_THE_EXECUTABLE_2"
            S_TMP_2="GUID=='d23cd2de-f38c-43f2-894c-f1e0305090e7'"
        fi
    fi
    #----
    if [ "$SB_THROW" == "f" ] ; then
        S_TMP_0="`printf \"$S_NAME_OF_THE_EXECUTABLE_3\" | gawk '{gsub(/\s/,"");printf "%s", $1 }'`"
        if [ "$S_NAME_OF_THE_EXECUTABLE_3" != "$S_TMP_0" ] ; then
            SB_THROW="t" 
            S_TMP_1="$S_NAME_OF_THE_EXECUTABLE_3"
            S_TMP_2="GUID=='7bf6f543-26c4-400e-a33c-f1e0305090e7'"
        fi
    fi
    #----
    if [ "$SB_THROW" == "f" ] ; then
        S_TMP_0="`printf \"$S_NAME_OF_THE_EXECUTABLE_4\" | gawk '{gsub(/\s/,"");printf "%s", $1 }'`"
        if [ "$S_NAME_OF_THE_EXECUTABLE_4" != "$S_TMP_0" ] ; then
            SB_THROW="t" 
            S_TMP_1="$S_NAME_OF_THE_EXECUTABLE_4"
            S_TMP_2="GUID=='a8746d54-43bc-4958-923c-f1e0305090e7'"
        fi
    fi
    #--------
    if [ "$SB_THROW" == "t" ] ; then
        echo ""
        echo "The Bash function "
        echo ""
        echo "    func_assert_exists_on_path_t2 "
        echo ""
        echo "is not designed to handle an argument value that contains "
        echo "spaces or tabulation characters."
        echo "The unaccepted value in parenthesis:($S_TMP_1)."
        echo "Branch $S_TMP_2."
        echo "GUID=='c3948131-401e-470a-a53c-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    SB_THROW="f" # Just a reset, should I forget to reset it later.
    #---------------
    S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE_1 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    #----
    if [ "$S_TMP_1" == "" ] ; then
        if [ "$S_NAME_OF_THE_EXECUTABLE_2" == "" ] ; then
        if [ "$S_NAME_OF_THE_EXECUTABLE_3" == "" ] ; then
        if [ "$S_NAME_OF_THE_EXECUTABLE_4" == "" ] ; then
            echo ""
            echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE_1\" to be on the PATH."
            echo "GUID=='f284925c-b40f-4549-b22c-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        fi
        fi
    else
        return # at least one of the programs was available at the PATH
    fi
    #--------
    S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE_2 2>/dev/null\`"
    S_TMP_1=""
    S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    #----
    if [ "$S_TMP_1" == "" ] ; then
        if [ "$S_NAME_OF_THE_EXECUTABLE_3" == "" ] ; then
        if [ "$S_NAME_OF_THE_EXECUTABLE_4" == "" ] ; then
            echo ""
            echo "This bash script requires that either \"$S_NAME_OF_THE_EXECUTABLE_1\" or "
            echo " \"$S_NAME_OF_THE_EXECUTABLE_2\" is available on the PATH."
            echo "GUID=='7f92b447-d805-460e-912c-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        fi
    else
        return # at least one of the programs was available at the PATH
    fi
    #--------
    S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE_3 2>/dev/null\`"
    S_TMP_1=""
    S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    #----
    if [ "$S_TMP_1" == "" ] ; then
        if [ "$S_NAME_OF_THE_EXECUTABLE_4" == "" ] ; then
            echo ""
            echo "This bash script requires that either \"$S_NAME_OF_THE_EXECUTABLE_1\" or "
            echo " \"$S_NAME_OF_THE_EXECUTABLE_2\" or \"$S_NAME_OF_THE_EXECUTABLE_3\" "
            echo "is available on the PATH."
            echo "GUID=='39c63c1f-eec1-450d-b12c-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
    else
        return # at least one of the programs was available at the PATH
    fi
    #--------
    S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE_4 2>/dev/null\`"
    S_TMP_1=""
    S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    #----
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires that either \"$S_NAME_OF_THE_EXECUTABLE_1\" or "
        echo " \"$S_NAME_OF_THE_EXECUTABLE_2\" or \"$S_NAME_OF_THE_EXECUTABLE_3\" or "
        echo " \"$S_NAME_OF_THE_EXECUTABLE_4\" is available on the PATH."
        echo "GUID=='71c5f5de-2801-47fc-841c-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    else
        return # at least one of the programs was available at the PATH
    fi
    #--------
} # func_assert_exists_on_path_t2


func_assert_exists_on_path_t2 "cat"
func_assert_exists_on_path_t2 "file"                 # for checking MIME types
func_assert_exists_on_path_t2 "find"                 # for recursing
func_assert_exists_on_path_t2 "fossil"               # tested with v1.34
func_assert_exists_on_path_t2 "gawk"
func_assert_exists_on_path_t2 "grep"
func_assert_exists_on_path_t2 "nice"
func_assert_exists_on_path_t2 "ruby"                 # anything over/equal v.2.1 will probably do
func_assert_exists_on_path_t2 "shred" "gshred" "rm"  # for shredding, if possible
func_assert_exists_on_path_t2 "uname"                # to check the OS type
func_assert_exists_on_path_t2 "uuidgen" "uuid"       # for generating tmp file names
func_assert_exists_on_path_t2 "xargs"                # find . -name '*' | xargs blabla
func_assert_exists_on_path_t2 "wc"  


#--------------------------------------------------------------------------

S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT=""
func_mmmv_operating_system_type_t1() {
    if [ "$S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT" == "" ]; then
        S_TMP_0="`uname -a | grep -E [Ll]inux`"
        if [ "$S_TMP_0" != "" ]; then
            S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT="Linux"
        else
            S_TMP_0="`uname -a | grep BSD `"
            if [ "$S_TMP_0" != "" ]; then
                S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT="BSD"
            else
                S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT="undetermined"
            fi
        fi
    fi
} # func_mmmv_operating_system_type_t1

func_mmmv_operating_system_type_t1

if [ "$S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT" != "Linux" ]; then
    if [ "$S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT" != "BSD" ]; then
        echo ""
        echo "  The classical command line utilities at "
        echo "  different operating systems, for example, Linux and BSD,"
        echo "  differ. This script is designed to run only on "
        echo "  Linux and some BSD variants."
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
        echo "  GUID=='52460304-7c62-4f4e-b51c-f1e0305090e7'"
        echo ""
        echo "  Aborting script without doing anything."
        echo ""
        exit 1 # exit with error
    fi
fi


#--------------------------------------------------------------------------

SB_EXISTS_ON_PATH_T1_RESULT="f"
func_sb_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE_1="$1" # first function argument
    #--------
    # Function calls like
    #
    #     func_sb_exists_on_path_t1 ""
    #     func_sb_exists_on_path_t1 " "
    #     func_sb_exists_on_path_t1 "ls ps" # contains a space
    #
    # are not allowed.
    if [ "$S_NAME_OF_THE_EXECUTABLE_1" == "" ] ; then
        echo ""
        echo "The Bash function "
        echo ""
        echo "    func_sb_exists_on_path_t1 "
        echo ""
        echo "is not designed to handle an argument that "
        echo "equals with an empty string."
        echo "GUID=='31ed2a21-41ac-4368-831c-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    local S_TMP_0="`printf \"$S_NAME_OF_THE_EXECUTABLE_1\" | gawk '{gsub(/\s/,"");printf "%s", $1 }'`"
    if [ "$S_NAME_OF_THE_EXECUTABLE_1" != "$S_TMP_0" ] ; then
        echo ""
        echo "The Bash function "
        echo ""
        echo "    func_sb_exists_on_path_t1 "
        echo ""
        echo "is not designed to handle an argument value that contains "
        echo "spaces or tabulation characters."
        echo "The received value in parenthesis:($S_NAME_OF_THE_EXECUTABLE_1)."
        echo "GUID=='40cb1b02-90f3-404e-8a0c-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    #--------
    S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE_1 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    #----
    if [ "$S_TMP_1" == "" ] ; then
        SB_EXISTS_ON_PATH_T1_RESULT="f"
    else
        SB_EXISTS_ON_PATH_T1_RESULT="t"
    fi
} # func_sb_exists_on_path_t1 


#--------------------------------------------------------------------------

S_FUNC_MMMV_GUID_T1_RESULT="not_yet_set"
S_FUNC_MMMV_GUID_T1_MODE="" # optim. to skip repeating console tool selection
func_mmmv_GUID_t1() {
    # Does not take any arguments.
    #--------
    #func_mmmv_exc_hash_function_input_verification_t1 "func_mmmv_GUID_t1" "$1"
    #--------------------
    local S_TMP_0="" # declaration
    local S_TMP_1="" # declaration
    # Mode selection:
    if [ "$S_FUNC_MMMV_GUID_T1_MODE" == "" ] ; then
        SB_EXISTS_ON_PATH_T1_RESULT="f"  # if-block init
        #----
        if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "f" ] ; then
            S_TMP_0="uuidgen" # Linux version
            func_sb_exists_on_path_t1 "$S_TMP_0" 
            if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "t" ] ; then
                 S_FUNC_MMMV_GUID_T1_MODE="$S_TMP_0"
            fi
        fi
        #----
        if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "f" ] ; then
            S_TMP_0="uuid"    # BSD version
            func_sb_exists_on_path_t1 "$S_TMP_0" 
            if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "t" ] ; then
                 S_FUNC_MMMV_GUID_T1_MODE="$S_TMP_0"
            fi
        fi
        #--------
        if [ "$S_FUNC_MMMV_GUID_T1_MODE" == "" ] ; then
            echo ""
            echo "All of the GUID generation implementations that this script " 
            echo "is capable of using (uuidgen, uuid) "
            echo "are missing from the PATH."
            echo "GUID=='3094c835-5f40-4884-b40c-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #--------
        if [ "$?" != "0" ]; then
            echo ""
            echo "This script is flawed."
            echo "GUID=='817cc031-3315-4771-a3fb-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #--------
    fi
    #--------------------
    S_FUNC_MMMV_GUID_T1_RESULT=""
    #--------------------
    if [ "$S_FUNC_MMMV_GUID_T1_MODE" == "uuidgen" ]; then
        S_TMP_0="`uuidgen`"
        if [ "$?" != "0" ]; then
            echo ""
            echo "The console application \"uuidgen\" "
            echo "exited with an error."
            echo ""
            echo "----console--output--citation--start-----"
            echo "`uuidgen`" # stdout and stderr
            echo "----console--output--citation--end-------"
            echo ""
            echo "GUID=='46b00d44-8784-489e-a5fb-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #---- 
        S_FUNC_MMMV_GUID_T1_RESULT="$S_TMP_0"
    fi
    #--------------------
    if [ "$S_FUNC_MMMV_GUID_T1_MODE" == "uuid" ]; then
        S_TMP_0="`uuid`"
        if [ "$?" != "0" ]; then
            echo ""
            echo "The console application \"uuid\" "
            echo "exited with an error."
            echo ""
            echo "----console--output--citation--start-----"
            echo "`uuid`" # stdout and stderr
            echo "----console--output--citation--end-------"
            echo ""
            echo "GUID=='c3d42e43-1f05-4355-93fb-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #---- 
        S_FUNC_MMMV_GUID_T1_RESULT="$S_TMP_0"
    fi
    #--------------------
    S_TMP_0="`printf \"$S_FUNC_MMMV_GUID_T1_RESULT\" | wc -m | gawk '{gsub(/\s/,"");printf "%s", $1 }'`"
    S_TMP_1="36"
    if [ "$S_TMP_0" != "$S_TMP_1" ]; then
        echo ""
        echo "According to the GUID specification, IETF RFC 4122,  "
        echo "the lenght of the GUID is "
        echo "$S_TMP_1 characters, but the result of the "
        echo ""
        echo "    func_mmmv_GUID_t1"
        echo ""
        echo "is something else. The flawed GUID candidate in parenthesis:"
        echo "($S_FUNC_MMMV_GUID_T1_RESULT)"
        echo ""
        echo "The lenght candidate of the flawed GUID candidate in parenthesis:"
        echo "($S_TMP_0)."
        echo ""
        echo "GUID=='4bba14f5-f666-40a4-9efb-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    #--------------------
} # func_mmmv_GUID_t1


#--------------------------------------------------------------------------

S_FUNC_MMMV_SHRED_T1_MODE="" # optim. to skip repeating console tool selection
func_mmmv_shred_t1() {
    local S_FP_IN="$1" # path to the file or folder to be shredded
    # The next input parameter is a shoddy compromise,
    # for the case, where shred/gshred is not installed:
    local SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE="$2"  # domain: {"","f","t"}
    #--------------------
    if [ "$SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE" != "" ] ; then
        if [ "$SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE" != "t" ] ; then
            if [ "$SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE" != "f" ] ; then
                echo ""
                echo "The second parameter of this function, the "
                echo ""
                echo "    SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE(==$SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE)"
                echo ""
                echo "is optional, but its range is {\"\",\"f\",\"t\"},"
                echo "without the quotation marks."
                echo "GUID=='502df336-4c86-4286-83fb-f1e0305090e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1 # exit with error
            fi
        fi
    else # $SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE == ""
        SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE="f"
    fi
    #--------------------
    # Declarations:
    local SB_THROW=""
    local SB_USE_RUBY=""
    local S_CMD=""
    local S_GUID=""
    local S_TMP_0=""
    local S_TMP_1=""
    local S_TMP_2=""
    local SI_0="-9999"
    local SI_1="-9999"
    local S_SHREDDER_APPLICATION_NAME=""
    local S_FP_PWD_BEFORE_SHREDDING=""
    #--------------------
    # Mode selection:
    if [ "$S_FUNC_MMMV_SHRED_T1_MODE" == "" ] ; then
        SB_EXISTS_ON_PATH_T1_RESULT="f"  # if-block init
        #----
        if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "f" ] ; then
            S_TMP_0="shred" # Linux version
            func_sb_exists_on_path_t1 "$S_TMP_0" 
            if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "t" ] ; then
                 S_FUNC_MMMV_SHRED_T1_MODE="$S_TMP_0"
            fi
        fi
        #----
        if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "f" ] ; then
            S_TMP_0="gshred" # BSD version
            func_sb_exists_on_path_t1 "$S_TMP_0" 
            if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "t" ] ; then
                 S_FUNC_MMMV_SHRED_T1_MODE="$S_TMP_0"
            fi
        fi
        #----
        if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "f" ] ; then
            if [ "$SB_OK_TO_USE_RM_IF_SHREDDING_APPS_NOT_AVAILABLE" == "t" ] ; then
                S_TMP_0="rm" # a shoddy compromise version for exeptional cases
                func_sb_exists_on_path_t1 "$S_TMP_0" 
                if [ "$SB_EXISTS_ON_PATH_T1_RESULT" == "t" ] ; then
                    func_mmmv_operating_system_type_t1
                    if [ "$S_FUNC_MMMV_OPERATING_SYSTEM_TYPE_T1_RESULT" != "BSD" ]; then
                         S_FUNC_MMMV_SHRED_T1_MODE="rm_BSD"
                    else # Linux and all the rest
                         S_FUNC_MMMV_SHRED_T1_MODE="rm_plain"
                    fi
                else
                    echo ""
                    echo "Something is wrong at the operating system "
                    echo "environment setup. All UNIX-like operating systems "
                    echo "and their emulators "
                    echo "are expected to have the \"rm\" command."
                    echo ""
                    echo "    \$(which rm)==\"`which rm`\""
                    echo ""
                    echo "    PATH=$PATH" # will be a huge string
                    echo ""
                    echo "GUID=='a6e67041-a70f-4e87-92fb-f1e0305090e7'"
                    echo ""
                    #----
                    cd $S_FP_ORIG
                    exit 1 # exit with error
                fi
            fi
        fi
        #--------
        if [ "$S_FUNC_MMMV_SHRED_T1_MODE" == "" ] ; then
            echo ""
            echo "All of the file shredding implementations that this script " 
            echo "is capable of using (shred, gshred) "
            echo "are missing from the PATH."
            echo "GUID=='2db9ac59-a8f0-4852-a1eb-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #--------
        if [ "$?" != "0" ]; then
            echo ""
            echo "This script is flawed."
            echo "GUID=='4a9e0e43-a179-434b-81eb-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #--------
    fi
    #--------------------
    S_TMP_0=$(echo $S_FP_IN | gawk '{gsub(/^[\/]/,""); printf "%s",$1 }')
    if [ "$S_TMP_0" == "$S_FP_IN" ]; then
        echo "" 
        echo "The path is expected to be an absolute path, "
        echo "but currently it is not."
        echo "    S_FP_IN==$S_FP_IN"
        echo "GUID=='b72d3528-b829-43dd-b4eb-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with an error
    fi
    #--------
    if [ -h $S_FP_IN ]; then 
        # The control flow is in here regardless of
        # whether the symbolic link is broken or not.
        # If the path is to a non-existing file/link/folder,
        # then the control flow will not enter this branch.
        echo ""
        echo "The "
        echo "    S_FP_IN=$S_FP_IN"
        echo "is a symbolic link, but it is expected to "
        echo "be a file or a folder."
        echo "GUID=='2ff01c25-3734-48c8-a9eb-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    if [ ! -e $S_FP_IN ]; then
        echo ""
        echo "The "
        echo "    S_FP_IN=$S_FP_IN"
        echo "does not exist."
        echo "GUID=='2b88f713-2945-4752-a4eb-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    #--------
    if [ -d $S_FP_IN ]; then
        #--------start--of--sub-path--check----
        # If the $S_FP_IN is a folder, then the `pwd` 
        # should not be a sub-path or a path of the 
        # folder that is being deleted.
        S_TMP_0="`cd $S_FP_IN;pwd`/"  
        S_TMP_1="`pwd`/"
        #----
        if [ "$S_TMP_0" == "$S_TMP_1" ]; then
            if [ ! -d $S_FP_IN ]; then
                echo ""
                echo "This Bash script is flawed. "
                echo "    S_FP_IN=$S_FP_IN"
                echo "GUID=='5b46db54-09a9-41ab-b5eb-f1e0305090e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1
            fi
            #----
            echo ""
            echo "The working directory, "
            echo ""
            echo "    PWD=$PWD"
            echo ""
            echo "equals with the folder that is being deleted."
            echo ""
            echo "    S_TMP_0=$S_TMP_0"
            echo ""
            echo "    S_FP_IN=$S_FP_IN"
            echo ""
            echo "GUID=='167f9421-0412-433c-91db-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
        #----
        # If the normalized $S_FP_IN is a folder and 
        # the "`pwd`/" is shorter than the normalized $S_FP_IN, then,
        # with the exceptions of some symbolic links, 
        # the "`pwd`/" can not be equal to the normalized $S_FP_IN, 
        # nor can the "`pwd`/" be a folder that is a sub-folder 
        # of the $S_FP_IN.
        # 
        # The paht lenght code is:
        # 
        #     SI_0="` echo \"$S_TMP_0\" | gawk '{i=length;printf "%s", i }' `" # S_FP_IN
        #     SI_1="` echo \"$S_TMP_1\" | gawk '{i=length;printf "%s", i }' `" # pwd
        #     if [ "$SI_0" -lt "$SI_1" ]; then  # $SI_0 < $SI_1
        #        #echo "$SI_0 < $SI_1"
        #        #
        #        # In here the length of the normalized form of the $S_FP_IN
        #        # is shorter than the "`pwd`/" and therefore the working directory
        #        # has a greater probability to be at a sub-path of the $S_FP_IN.
        #        
        #        <
        #         A lot of Ruby code, because 
        #         the gawk code will have trouble with folders that 
        #         contain spaces and other special characters
        #         >
        #    fi
        #
        # but unfortunately the Ruby code that uses 
        # temporary files and the String.index would be 
        # unstable due to the 
        #
        #     https://bugs.ruby-lang.org/issues/12710
        #     https://archive.is/AJpgL
        # 
        # Add to that the fact that this Bash function
        # would be much more appealing, if it did not launch
        # any 40BiB sized interpreters like the Ruby interpreter (in 2016)
        # and the temptation to just skip testing, whether the 
        # working directory (`pwd`) resides at a directory that
        # is a sub-path of the $S_FP_IN, grows even higher.
        # So, for the time being that check is omitted from here. 
        #
        # TODO: If the year is at least 2020, then try to find out, 
        #       whether there's some elegant way to implement that check.
        #
        # A code fragment for later consideration:
        #     S_TMP_2="`echo \"$S_TMP_0\" | gawk '{gsub(/\s/,\"NotASpace\");printf \"%s\", \$1 }' `"
        #     if [ "$S_TMP_2" != "$S_TMP_0" ]; then
        #         # S_TMP_0 contains strings
        #         SB_USE_RUBY="t"
        #     fi
        #--------end--of--sub-path--check----
    fi
    #--------------------
    S_FP_PWD_BEFORE_SHREDDING="`pwd`"
    S_CMD="" # to be sure
    #--------------------
    S_TMP_0="cd $S_FP_IN ; nice -n10 find . -name '*' | nice -n10 xargs "
    # The space after the "cd $S_FP_IN" and before the ";" is compulsory.
    #----
    # The "2>/dev/null" after the shredding/deletion command
    # is to hide the file permissions related error messages.
    # The failure is detected by studying file existence.
    #--------------------
    if [ "$S_FUNC_MMMV_SHRED_T1_MODE" == "shred" ]; then
        S_SHREDDER_APPLICATION_NAME="shred"
        if [ -d $S_FP_IN ]; then
            S_CMD="$S_TMP_0 \
                   $S_SHREDDER_APPLICATION_NAME -f --remove 2>/dev/null "
        else
            S_CMD="nice -n10 $S_SHREDDER_APPLICATION_NAME -f --remove $S_FP_IN 2>/dev/null "
        fi
    fi
    #----
    if [ "$S_FUNC_MMMV_SHRED_T1_MODE" == "gshred" ]; then
        S_SHREDDER_APPLICATION_NAME="gshred"
        if [ -d $S_FP_IN ]; then
            S_CMD="$S_TMP_0 \
                   $S_SHREDDER_APPLICATION_NAME --force --iterations=2 --remove -z 2>/dev/null "
        else
            S_CMD="nice -n10 \
                   $S_SHREDDER_APPLICATION_NAME --force --iterations=2 --remove -z $S_FP_IN 2>/dev/null "
        fi
    fi
    #----
    # The "rm" on Linux and BSD differ, 
    # a bit like the "ps" # on Linux and BSD differ.
    # The "rm -f -P foo" overwrites the file with NON-random 
    # values before deleting.
    # The "rm -f    foo" works, whenever the "rm" is called by the file owner.
    # The "rm -f -P foo" requires write permissions even, 
    # if the "rm" is called by the file owner.
    if [ "$S_FUNC_MMMV_SHRED_T1_MODE" == "rm_BSD" ]; then
        S_SHREDDER_APPLICATION_NAME="rm"
        if [ -d $S_FP_IN ]; then
            S_CMD="$S_TMP_0 \
            $S_SHREDDER_APPLICATION_NAME -f -P $S_FP_IN 2>/dev/null "
        else
            S_CMD="nice -n10 $S_SHREDDER_APPLICATION_NAME -f -P $S_FP_IN 2>/dev/null "
        fi
    fi
    if [ "$S_FUNC_MMMV_SHRED_T1_MODE" == "rm_plain" ]; then
        # The "rm -f    foo" seems to be universally available
        # at all UNIX-like environments.
        S_SHREDDER_APPLICATION_NAME="rm"
        if [ -d $S_FP_IN ]; then
            S_CMD="$S_TMP_0 \
            $S_SHREDDER_APPLICATION_NAME -f $S_FP_IN 2>/dev/null "
        else
            S_CMD="nice -n10 $S_SHREDDER_APPLICATION_NAME -f $S_FP_IN 2>/dev/null "
        fi
    fi
    #--------------------
    eval "$S_CMD" # the "eval" is required due to the command "find"
    cd $S_FP_PWD_BEFORE_SHREDDING # required if the $S_FP_IN  was a folder
    if [ -e $S_FP_IN ]; then 
        # If the control flow is here, then the $S_FP_IN was 
        # a folder or the deletion failed or both.
        chmod -f -R 0700 $S_FP_IN  # chmod 0777 would introduce s security flaw
        eval "$S_CMD" # the "eval" is required due to the command "find"
        cd $S_FP_PWD_BEFORE_SHREDDING
        #----
        SB_THROW="f"
        if [ -d $S_FP_IN ]; then 
            S_TMP_0="`cd $S_FP_IN; pwd`" # "./home///foo" -> "/home/foo"
            # Checks are intentionally missing to 
            # allow this Bash function to be universal, without exceptions.
            #----
            cd $S_TMP_0
            S_TMP_1="`find . -name '*' | \
                      xargs file --mime-type | \
                      grep -v directory | grep -v folder `"
                    # The   file --mime-type foo
                    # works on both, Linux and BSD. 
            cd $S_FP_PWD_BEFORE_SHREDDING
            #----
            if [ "$S_TMP_1" == "" ]; then
                rm -fr $S_TMP_0
            else
                SB_THROW="t"
                S_GUID="'23c2b1e5-3972-4dc6-a2db-f1e0305090e7'"
            fi
        fi
        #----
        if [ "$SB_THROW" == "f" ]; then # to avoid overwriting the S_GUID
            if [ -e $S_FP_IN ]; then
                SB_THROW="t"
                S_GUID="'ca0b9b36-4ea9-4be6-92db-f1e0305090e7'"
            fi 
        fi 
        if [ "$SB_THROW" == "t" ]; then
            echo ""
            echo "The deletion failed even after the "
            echo ""
            echo "    chmod -f -R 0700 $S_FP_IN "
            echo ""
            echo "The "
            echo ""
            echo "    chmod 0777 "
            echo ""
            echo "is not done automatically in this "
            echo "Bash function, because "
            echo "it might introduce a security flaw."
            echo ""
            echo "    S_FUNC_MMMV_SHRED_T1_MODE=$S_FUNC_MMMV_SHRED_T1_MODE"
            echo ""
            echo "    S_CMD=$S_CMD"
            echo ""
            echo "GUID==$S_GUID"
            echo "GUID=='73d84042-9e60-4316-b3db-f1e0305090e7'"
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
    fi
    S_GUID="'693c9923-46d0-4603-92db-f1e0305090e7'" #counters S_GUID related flaws
    #--------------------
    if [ -e $S_FP_IN ]; then
        echo ""
        echo "The deletion of the "
        echo "    S_FP_IN=$S_FP_IN"
        echo "failed or the file or folder was re-created by "
        echo "some other process before this file existance check."
        echo "GUID=='4c690312-7d59-43db-95cb-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1 # exit with error
    fi
    #--------------------
    cd $S_FP_PWD_BEFORE_SHREDDING
} # func_mmmv_shred_t1


#--------------------------------------------------------------------------
S_TMP_0=""
S_ACTIVITY_OF_THIS_SCRIPT=$1
S_URL_REMOTE_REPOSITORY=""
SB_EXIT_WITH_ERROR="f"

# needed for scriptability
S_ARGNAME_ACTIVITY_SHRED_ARG_2="do_not_prompt_for_confirmation" 

fun_print_msg_t1() {
    echo ""
    echo "The second console argument "
    echo "is expected to be the URL of the remote repository."
} # fun_print_msg_t1


fun_exit_without_any_errors_t1() {
    local X_SKIP_MESSAGE="$1"
    if [ "$X_SKIP_MESSAGE" == "" ]; then
        echo ""
        echo "Aborting script without doing anything."
        echo ""
    fi 
    #----
    cd $S_FP_ORIG
    exit 0
} # fun_exit_without_any_errors_t1

#--------------------------------------------------------------------------

SB_FUNC_MMMV_ASSERT_FILE_PATHS_DIFFER_T1_ASSERTION_FAILED="f"
func_mmmv_assert_file_paths_differ_t1(){
    local S_FP_0="$1"
    local S_FP_1="$2"
    local S_GUID="$3"
    local SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE="$4" # domain: {"","f","t"}
    #--------
    if [ "$SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE" != "" ] ; then
        if [ "$SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE" != "t" ] ; then
            if [ "$SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE" != "f" ] ; then
                echo ""
                echo "The fourth parameter of this function, the "
                echo ""
                echo "    SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE(==$SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE)"
                echo ""
                echo "is optional, but its range is {\"\",\"f\",\"t\"},"
                echo "without the quotation marks."
                echo "GUID=='55200d1b-73f9-46a3-82cb-f1e0305090e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1 # exit with error
            fi
        fi
    else # $SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE == ""
        SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE="f"
    fi
    SB_FUNC_MMMV_ASSERT_FILE_PATHS_DIFFER_T1_ASSERTION_FAILED="f" # global
    #--------
    # The block of if-else statements for comparing the 2 paths
    # is so error prone to write that this function is written 
    # according to a schematic that resides at:
    # http://longterm.softf1.com/documentation_fragments/2016_09_03_comparison_of_file_paths_t1/
    # https://archive.is/R4yw9
    #--------
    # Declarations:
    local S_GUID_CRAWL="S_GUID_CRAWL not set" # tree crawling at the schematic
    local S_GUID_CMP="S_GUID_CMP not set"     # comparison at tree leaf
                                              # Some leaves are equivalent.
    local S_COMPARISON_MODE="" 
    local SB_THROW="f" 
    local SB_ASSERTION_FAILED="f" 
    local SB_STR0="f" # whether S_FP_0 is compared purely as a string
    local SB_STR1="f" # whether S_FP_1 is compared purely as a string
    local S_FP_0_STR="$S_FP_0" 
    local S_FP_1_STR="$S_FP_1"
    local S_FP_X="" # a temporary variable for holding path value
    local S_RUBY_SRC_0=""
    #--------
    if [ "$S_FP_0" == "$S_FP_1" ]; then 
        # Covers also the case, where both are existing 
        # folders, but the paths to them contains "../".
        # By making the string comparison to be the first thing tried 
        # a few file system accesses might be saved.
        SB_ASSERTION_FAILED="t"
        S_GUID_CRAWL="644d292d-c01e-47d0-855c-f1e0305090e7"
        S_GUID_CMP="57bc9b05-da56-4eff-954c-f1e0305090e7"
    else # the rest of the 3 comparison modes
        #--------
        if [ -e $S_FP_0 ]; then 
            if [ -d $S_FP_0 ]; then 
                if [ -e $S_FP_1 ]; then 
                    if [ -d $S_FP_1 ]; then 
                        S_COMPARISON_MODE="cmode_cd0_cd1"
                    else 
                        S_COMPARISON_MODE="cmode_cd0_str1"
                        SB_STR1="t"
                    fi 
                else 
                    S_COMPARISON_MODE="cmode_cd0_str1"
                    SB_STR1="t"
                fi
            else 
                if [ -e $S_FP_1 ]; then 
                    if [ -d $S_FP_1 ]; then 
                        S_COMPARISON_MODE="cmode_str0_cd1"
                        SB_STR0="t"
                    else 
                        S_COMPARISON_MODE="cmode_str0_str1"
                        SB_STR0="t"
                        SB_STR1="t"
                    fi 
                else 
                    S_COMPARISON_MODE="cmode_str0_str1"
                    SB_STR0="t"
                    SB_STR1="t"
                fi
            fi
        else # $S_FP_0 is missing or it is a broken symbolic link
            if [ -e $S_FP_1 ]; then 
                if [ -d $S_FP_1 ]; then 
                    S_COMPARISON_MODE="cmode_str0_cd1"
                    SB_STR0="t"
                else 
                    S_COMPARISON_MODE="cmode_str0_str1"
                    SB_STR0="t"
                    SB_STR1="t"
                fi
            else 
                S_COMPARISON_MODE="cmode_str0_str1"
                SB_STR0="t"
                SB_STR1="t"
            fi
        fi
        #----------------        
        # The "cmode_str0_str1" was tried 
        # at the first if-clause of the block, but 
        # that does not catch equivalent cases like 
        #
        #     S_FP_0="`pwd`/././////a_nonexisting_file_or_folder"
        #     S_FP_1="`pwd`/a_nonexisting_file_or_folder"
        #
        #     S_FP_0="./a_nonexisting_file_or_folder"
        #     S_FP_1="././././././a_nonexisting_file_or_folder"
        #
        #     S_FP_0="/a_nonexisting_file_or_folder"
        #     S_FP_1="/////a_nonexisting_file_or_folder"
        #
        #     S_FP_0="/a_nonexisting_file_or_folder"
        #     S_FP_1="/..///../a_nonexisting_file_or_folder"
        #
        # String normalization is required whenever at least
        # one of the paths is used at comparison 
        # purely as a string.
        #
        #----start-of-Ruby-script-header--for-copy/pasting----
        #    #!/usr/bin/env ruby
        #    
        #    s_fp_0="./a_nonexisting_file_or_folder"
        #    s_fp_1="././..//../.././a_nonexisting_file_or_folder"
        #    
        #    # The path "/../foo" is equivalent to "/foo".
        #    s_fp_2="/././..//../.././a_nonexisting_file_or_folder"
        #    
        #    # This script does not cover the case, 
        #    # where "./aa/../bb" is equivalent to "./bb"
        #----end---of-Ruby-script-header-for-copy/pasting----
        S_RUBY_SRC_0="\
            s_0='';\
            s_1=ARGV[0].to_s;\
            rgx_0=/[\\/][.][\\/]/;\
            rgx_1=/^[.][\\/]/;\
            rgx_2=/^[\\/][.][.][\\/]/;\
            i_4safety=0;\
            while s_0!=s_1 do ;\
               s_0=s_1;\
               s_1=s_0.gsub(rgx_0,'/');\
               i_4safety=i_4safety+1;\
               if 10000<i_4safety then ;\
                  raise(Exception.new('boo'));\
               end;\
            end ;\
            s_0=s_1;\
            s_1=s_0.gsub(rgx_1,'');\
            s_0=s_1;\
            s_1=s_0.gsub(/[\\/]+/,'/');\
            ;\
            ;\
            i_4safety=0;\
            while s_0!=s_1 do ;\
               s_0=s_1;\
               s_1=s_0.gsub(rgx_2,'/');\
               i_4safety=i_4safety+1;\
               if 10000<i_4safety then ;\
                  raise(Exception.new('10b7aae4-1940-4361-a4cb-f1e0305090e7'));\
               end;\
            end ;\
            s_0=s_1;\
            s_1=s_0.gsub(rgx_1,'');\
            s_0=s_1;\
            s_1=s_0.gsub(/[\\/]+/,'/');\
            ;\
            print s_1;\
            "
        #----
        if [ "$SB_STR0" == "t" ]; then 
            S_FP_0_STR="`ruby -e \"$S_RUBY_SRC_0\" $S_FP_0`"
        fi
        if [ "$SB_STR1" == "t" ]; then 
            S_FP_1_STR="`ruby -e \"$S_RUBY_SRC_0\" $S_FP_1`"
        fi
        #----------------        
        if [ "$S_COMPARISON_MODE" == "cmode_cd0_str1" ]; then 
            # 2 cases at the schematic
            S_FP_X="`cd $S_FP_0;pwd`"
            if [ "$S_FP_X" == "$S_FP_1_STR" ]; then 
                SB_ASSERTION_FAILED="t"
                S_GUID_CMP="3a6056a5-c267-4111-b24c-f1e0305090e7"
            fi
            if [ "$SB_ASSERTION_FAILED" != "t" ]; then 
                if [ "$S_FP_X" == "$S_FP_1" ]; then # just in case
                    SB_ASSERTION_FAILED="t"
                    S_GUID_CMP="57a656e5-aa92-40a8-a53c-f1e0305090e7"
                fi
            fi
        else
            if [ "$S_COMPARISON_MODE" == "cmode_str0_cd1" ]; then 
                # 2 cases at the schematic
                S_FP_X="`cd $S_FP_1;pwd`"
                if [ "$S_FP_0_STR" == "$S_FP_X" ]; then 
                    SB_ASSERTION_FAILED="t"
                    S_GUID_CMP="2bc33092-26d1-4787-953c-f1e0305090e7"
                fi
                if [ "$SB_ASSERTION_FAILED" != "t" ]; then 
                    if [ "$S_FP_0" == "$S_FP_X" ]; then # just in case
                        SB_ASSERTION_FAILED="t"
                        S_GUID_CMP="05494129-51a8-4d7d-923c-f1e0305090e7"
                    fi
                fi
            else
                if [ "$S_COMPARISON_MODE" == "cmode_cd0_cd1" ]; then 
                    if [ "`cd $S_FP_0;pwd`" == "`cd $S_FP_1;pwd`" ]; then 
                        SB_ASSERTION_FAILED="t"
                        S_GUID_CMP="37d42234-a57e-4d78-b52c-f1e0305090e7"
                    fi
                else 
                    if [ "$S_COMPARISON_MODE" == "cmode_str0_str1" ]; then 
                        if [ "$S_FP_0_STR" == "$S_FP_1_STR" ]; then 
                            SB_ASSERTION_FAILED="t"
                            S_GUID_CMP="b0eb5d1d-9b86-4d66-812c-f1e0305090e7"
                        fi
                        # The if [ "$S_FP_0" == "$S_FP_1" ] ...
                        # has already been tried at the very start 
                        # of the huge if-block.
                    else
                        echo ""
                        echo "This script is flawed."
                        echo ""
                        echo "    S_FP_0=$S_FP_0"
                        echo "    S_FP_1=$S_FP_1"
                        echo "    S_GUID_CRAWL=$S_GUID_CRAWL"
                        echo "    S_GUID_CMP=$S_GUID_CMP"
                        echo "    S_COMPARISON_MODE=$S_COMPARISON_MODE"
                        echo ""
                        echo "GUID=='14286012-4658-42f9-94cb-f1e0305090e7'"
                        echo ""
                        #----
                        cd $S_FP_ORIG
                        exit 1 # exit with error
                    fi
                fi
            fi
        fi
    fi
    #--------
    SB_FUNC_MMMV_ASSERT_FILE_PATHS_DIFFER_T1_ASSERTION_FAILED="$SB_ASSERTION_FAILED" # global
    if [ "$SB_ASSERTION_FAILED" == "t" ]; then 
        if [ "$SB_DO_NOT_TRHOW_ON_ASSERTION_FAILURE" != "t" ]; then
            echo ""
            echo "The file paths "
            echo ""
            echo "    S_FP_0=$S_FP_0"
            echo ""
            echo "    S_FP_1=$S_FP_1"
            echo ""
            echo "are required to differ and "
            echo "they are required to differ also after normalization."
            echo ""
            echo "GUID=='3f8afd21-08d6-487f-b3cb-f1e0305090e7'"
            echo "GUID=='$S_GUID_CMP'"   # comparison
            echo "GUID=='$S_GUID_CRAWL'" # tree crawling at the schematic
            if [ "$S_GUID" != "" ]; then 
                echo "GUID=='$S_GUID'"   # GUID as an input parameter
            fi
            echo ""
            #----
            cd $S_FP_ORIG
            exit 1 # exit with error
        fi
    fi
} # func_mmmv_assert_file_paths_differ_t1


#--------------------------------------------------------------------------
# Activity aliases for comfort.

if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "up" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_remote_with_local"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "upload" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_remote_with_local"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "ci" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_remote_with_local"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "down" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_local_with_remote"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "download" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="overwrite_local_with_remote"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "co" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="clone_all"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "?" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-?" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "--help" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-help" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="help"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "rm" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="delete_local_copy"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "del" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="delete_local_copy"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "delete" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="delete_local_copy"
fi
#--------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "info" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "--info" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-info" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "--about" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "-about" ]; then
    S_ACTIVITY_OF_THIS_SCRIPT="about"
fi
#--------
#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "about" ]; then
    echo ""
    echo "    The initial version of this script has been written by "
    echo "    Martin.Vahi@softf1.com         "
    echo "    in 2016_02. The initial version is in public domain."
    echo "    The command \"help\" offers more information. "
    echo ""
    echo "    Thank You for using this script :-)"
    echo ""
    echo ""
    fun_exit_without_any_errors_t1 "t"
fi 
#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "exit" ]; then
    fun_exit_without_any_errors_t1
else
    if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_all" ]; then
        if [ "$2" == "" ]; then
            fun_print_msg_t1
            S_ACTIVITY_OF_THIS_SCRIPT="help"
            SB_EXIT_WITH_ERROR="t"
        else
            S_URL_REMOTE_REPOSITORY="$2"
        fi
    else
        if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_public" ]; then
            if [ "$2" == "" ]; then
                fun_print_msg_t1
                S_ACTIVITY_OF_THIS_SCRIPT="help"
                SB_EXIT_WITH_ERROR="t"
            else
                S_URL_REMOTE_REPOSITORY="$2"
            fi
        else
            if [ "$S_ACTIVITY_OF_THIS_SCRIPT" != "overwrite_local_with_remote" ]; then
                if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "overwrite_remote_with_local" ]; then
                    if [ "$2" != "" ]; then
                        if [ "$2" == "use_autogenerated_commit_message" ]; then
                            if [ "$3" != "" ]; then
                                echo ""
                                echo "If the first console argument is \"overwrite_local_with_remote\" and"
                                echo "the second console argument is \"use_autogenerated_commit_message\", "
                                echo "then there should not be a 3. console argument."
                                echo "GUID=='468fa904-55da-4388-81cb-f1e0305090e7'"
                                S_ACTIVITY_OF_THIS_SCRIPT="help"
                                SB_EXIT_WITH_ERROR="t"
                            fi
                        else
                            if [ "$2" == "read_commit_message_from_file" ]; then
                                S_FP_MESSAGE_FILE_CANDIDATE="$3" # file path candidate
                                if [ "$S_FP_MESSAGE_FILE_CANDIDATE" == "" ]; then
                                    echo ""
                                    echo "If the first console argument is "
                                    echo "\"overwrite_local_with_remote\" and"
                                    echo "the second console argument is "
                                    echo "\"read_commit_message_from_file\", "
                                    echo "then there should be also a 3. console argument "
                                    echo "that is expected to be a file path to a text file."
                                    echo "GUID=='559c7db3-15af-4a7d-bdbb-f1e0305090e7'"
                                    S_ACTIVITY_OF_THIS_SCRIPT="help"
                                    SB_EXIT_WITH_ERROR="t"
                                fi
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    if [ "$4" != "" ]; then
                                        echo ""
                                        echo "If the first console argument is "
                                        echo "\"overwrite_local_with_remote\" and"
                                        echo "the second console argument is "
                                        echo "\"read_commit_message_from_file\", "
                                        echo "then there should be exactly 3. console arguments, "
                                        echo "not 4 or more. Unfortunately the 4. argument is currently "
                                        echo "---citation--start---"
                                        echo "$4"
                                        echo "---citation--end-----"
                                        echo "GUID=='5e662e45-13a1-499b-9dbb-f1e0305090e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    if [ ! -e "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                                        echo ""
                                        echo "The commit message file path candidate "
                                        echo "references either a missing file or "
                                        echo "a broken symlink."
                                        echo "GUID=='15f6e772-31ba-4f5e-97bb-f1e0305090e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi 
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    if [ -d "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                                        echo ""
                                        echo "The commit message file path candidate "
                                        echo "references a folder, but it should "
                                        echo "reference a text file."
                                        echo "GUID=='3225928c-0920-4018-95bb-f1e0305090e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    S_TMP_0="`filesize $S_FP_MESSAGE_FILE_CANDIDATE`"
                                    S_TMP_1="`ruby -e \"s_out='OK'; if (2000<$S_TMP_0) then s_out='too_big' end; print(s_out);\"`"
                                    if [ "$S_TMP_1" == "too_big" ]; then
                                        echo ""
                                        echo "The commit message file path "
                                        echo "references a file that has a size of $S_TMP_0 bytes."
                                        echo "The suspicion is that it is a wrong file. "
                                        echo "because a commit message is usually not that lengthy."
                                        echo "GUID=='21090045-08fe-4487-81bb-f1e0305090e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    else
                                        if [ "$S_TMP_0" == "0" ]; then
                                            echo ""
                                            echo "The commit message file path "
                                            echo "references a file that has a size of 0 (zero) bytes."
                                            echo ""
                                            echo "The generation of commit message files "
                                            echo "can be avoided by using the option "
                                            echo ""
                                            echo "    \"use_autogenerated_commit_message\""
                                            echo ""
                                            echo "in stead of the option "
                                            echo ""
                                            echo "    \"read_commit_message_from_file\" ."
                                            echo ""
                                            echo "GUID=='a539fb61-243d-4e0c-82bb-f1e0305090e7'"
                                            S_ACTIVITY_OF_THIS_SCRIPT="help"
                                            SB_EXIT_WITH_ERROR="t"
                                        fi
                                    fi
                                fi 
                                if [ "$SB_EXIT_WITH_ERROR" == "f" ]; then
                                    S_TMP_0="`file --mime-type $S_FP_MESSAGE_FILE_CANDIDATE | grep text `"
                                    if [ "$S_TMP_0" == "" ]; then
                                        echo ""
                                        echo "The commit message file path "
                                        echo "references a file that has a  MIME type of "
                                        echo ""
                                        echo "`file --mime-type $S_FP_MESSAGE_FILE_CANDIDATE`"
                                        echo ""
                                        echo "The commit message file must be a text file and "
                                        echo "text files have the string \"text\" in their MIME type name."
                                        echo "GUID=='0e00aa42-a7dd-4e63-b2ab-f1e0305090e7'"
                                        S_ACTIVITY_OF_THIS_SCRIPT="help"
                                        SB_EXIT_WITH_ERROR="t"
                                    fi
                                fi 
                            fi # read_commit_message_from_file
                        fi
                    fi
                else
                    if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "delete_local_copy" ]; then
                        if [ "$2" != "" ]; then # the 2. arg is optional here
                            if [ "$2" != "$S_ARGNAME_ACTIVITY_SHRED_ARG_2" ]; then 
                                echo ""
                                echo "If the first console argument is \"delete_local_copy\", then"
                                echo "the second console argument is allowed to be only "
                                echo ""
                                echo "    \"$S_ARGNAME_ACTIVITY_SHRED_ARG_2\", without quotation marks."
                                echo "GUID=='53d97712-0caf-4847-b5ab-f1e0305090e7'"
                                S_ACTIVITY_OF_THIS_SCRIPT="help"
                                SB_EXIT_WITH_ERROR="t"
                            fi
                        fi
                    else
                        if [ "$S_ACTIVITY_OF_THIS_SCRIPT" != "print_script_version" ]; then
                            if [ "$S_ACTIVITY_OF_THIS_SCRIPT" != "help" ]; then
                                echo ""
                                echo "The very first console argument "
                                echo "of this script is expected to be "
                                echo "a command that is specific to this script."
                                echo "GUID=='5d8d1e92-ac26-408a-81ab-f1e0305090e7'"
                                S_ACTIVITY_OF_THIS_SCRIPT="help"
                                SB_EXIT_WITH_ERROR="t"
                            fi
                        fi
                    fi
                fi
            fi
        fi
    fi
fi 

#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "help" ]; then
    echo ""
    echo "Possible console argument sets are:"
    echo ""
    echo "    clone_all    <remote repository url>"
    echo "    clone_public <remote repository url>"
    echo "    overwrite_local_with_remote"
    echo ""
    echo "    overwrite_remote_with_local (use_autogenerated_commit_message)?"
    echo "    overwrite_remote_with_local read_commit_message_from_file <path to a text file>"
    echo ""
    echo "    delete_local_copy ($S_ARGNAME_ACTIVITY_SHRED_ARG_2)?"
    echo "    help"
    echo "    print_script_version"
    echo "    exit # just for testing"
    echo ""
    #----
    cd $S_FP_ORIG
    if [ "$SB_EXIT_WITH_ERROR" == "t" ]; then
        exit 1 # To let the parent script know that 
               # the parent script calls this script with 
               # flawed console argument values.    
    else
        exit 0
    fi
fi 

#--------------------------------------------------------------------------
# The script version is needed by other scripts that depend on this script.
# The script version GUID must not be surrounded by 
# any quote signs (',"), because otherwise the 
# version GUID will be overwritten by the UpGUID tool,
# but unlike error message GUID-s this GUID must stay constant. 
# To allow the version to be used as sub-part of file names and 
# folder names, the version must not contain any spaces, line breaks
# and other characters that have a special meaning in Bash.
#
# If the version ID did not match the GUID regex, then I would have to 
# write a long comment about it not being allowed to match the 
# GUID regex. :-D 
S_VERSION_OF_THIS_SCRIPT="23dc37cc-4d31-4444-a52c-f1e0305090e7"
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "print_script_version" ]; then
    echo "The version of this script is: $S_VERSION_OF_THIS_SCRIPT"
    #----
    cd $S_FP_ORIG
    exit 0
fi 


#--------------------------------------------------------------------------
S_FP_SANDBOX_DIRECTORY_NAME="sandbox_of_the_Fossil_repository"
S_FP_SANDBOX="$S_FP_DIR/$S_FP_SANDBOX_DIRECTORY_NAME"
#----
S_FP_ARCHIVES_DIRECTORY_NAME="archival_copies_of_the_Fossil_repository_sandbox"
S_FP_ARCHIVES="$S_FP_DIR/$S_FP_ARCHIVES_DIRECTORY_NAME"
S_FP_ARCHIVES_TS="$S_FP_ARCHIVES/v$S_TIMESTAMP"
#----
S_FP_FOSSILFILE_NAME="repository_storage.fossil"
S_FP_FOSSILFILE="$S_FP_DIR/$S_FP_FOSSILFILE_NAME"

#--------
S_LC_NOT_DETERMINED="not determined"
SB_SANDBOX_DIR_EXISTS="$S_LC_NOT_DETERMINED"
fun_sandbox_folder_or_symlink_exists() {
    SB_SANDBOX_DIR_EXISTS="f"
    if [ ! -e $S_FP_SANDBOX ]; then
        # Does not exist or it is a broken symbolic link.
        SB_SANDBOX_DIR_EXISTS="f"
    else
        if [ -d $S_FP_SANDBOX ]; then
            SB_SANDBOX_DIR_EXISTS="t"
        fi
    fi
} # fun_sandbox_folder_or_symlink_exists

SB_FOSSILFILE_EXISTS="$S_LC_NOT_DETERMINED"
fun_fossil_repository_file_or_symlink_exists() {
    SB_FOSSILFILE_EXISTS="t"
    if [ ! -e $S_FP_FOSSILFILE ]; then
        # Does not exist or it is a broken symbolic link.
        SB_FOSSILFILE_EXISTS="f"
    else
        if [ -d $S_FP_FOSSILFILE ]; then
            SB_FOSSILFILE_EXISTS="f"
        fi
    fi
} # fun_fossil_repository_file_or_symlink_exists

S_LC_NOT_DETERMINED="not determined"
SB_ARCHIVE_DIR_EXISTS="$S_LC_NOT_DETERMINED"
fun_archives_folder_or_symlink_exists() {
    SB_ARCHIVE_DIR_EXISTS="f"
    if [ ! -e $S_FP_ARCHIVES ]; then
        # Does not exist or it is a broken symbolic link.
        SB_ARCHIVE_DIR_EXISTS="f"
    else
        if [ -d $S_FP_ARCHIVES ]; then
            SB_ARCHIVE_DIR_EXISTS="t"
        fi
    fi
} # fun_archives_folder_or_symlink_exists

#--------
fun_fossil_repository_file_or_symlink_exists
fun_sandbox_folder_or_symlink_exists
fun_archives_folder_or_symlink_exists

fun_assertion_t1() {
    local SB_CANDIDATE=$1
    local SB_THROW="t"
    #----
    if [ "$SB_CANDIDATE" == "t" ]; then
        SB_THROW="f"
    else
        if [ "$SB_CANDIDATE" == "f" ]; then
            SB_THROW="f"
        fi
    fi
    #----
    if [ "$SB_THROW" == "t" ]; then
        echo ""
        echo "This Bash script is flawed. "
        echo "fun_assertion_t1() assertion failed."
        echo "GUID=='c2afa84b-ad9b-41b4-a4ab-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_assertion_t1

fun_assertion_t1 "$SB_FOSSILFILE_EXISTS"
fun_assertion_t1 "$SB_SANDBOX_DIR_EXISTS"
fun_assertion_t1 "$SB_ARCHIVE_DIR_EXISTS"

#--------------------------------------------------------------------------

fun_assert_repository_local_copy_existence() {
    fun_fossil_repository_file_or_symlink_exists
    if [ "$SB_FOSSILFILE_EXISTS" == "f" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "does not contain a Fossil repository file named "
        echo ""
        echo "    $S_FP_FOSSILFILE_NAME"
        echo ""
        echo "Aborting script."
        echo "GUID=='b6307f42-cfba-4f42-b4ab-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    fun_sandbox_folder_or_symlink_exists
    if [ "$SB_SANDBOX_DIR_EXISTS" == "f" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "does not contain a directory named "
        echo ""
        echo "    $S_FP_SANDBOX_DIRECTORY_NAME"
        echo ""
        echo "Aborting script."
        echo "GUID=='2619a005-53ea-46b9-a79b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_assert_repository_local_copy_existence


fun_assert_the_lack_of_repository_local_copy_t1() {
    if [ "$SB_FOSSILFILE_EXISTS" == "t" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "already contain a file named "
        echo ""
        echo "    $S_FP_FOSSILFILE_NAME"
        echo ""
        echo "To avoid overwriting an existing local copy, this script is aborted"
        echo "and nothing is downloaded/uploaded by this script."
        echo "GUID=='3cdf8c33-e911-4ecf-819b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$SB_SANDBOX_DIR_EXISTS" == "t" ]; then
        echo ""
        echo "The directory "
        echo "`pwd`"
        echo "already contains a directory named "
        echo ""
        echo "    $S_FP_SANDBOX_DIRECTORY_NAME"
        echo ""
        echo "To avoid overwriting an existing local copy, this script is aborted"
        echo "and nothing is downloaded/uploaded by this script."
        echo "GUID=='e054e73b-52b7-4999-929b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_assert_the_lack_of_repository_local_copy_t1



fun_initialize_sandbox_t1() {
    mkdir -p $S_FP_SANDBOX
    sync;
    cd $S_FP_SANDBOX
    fossil open $S_FP_DIR/$S_FP_FOSSILFILE_NAME # full path for reliability 
    fossil settings autosync off ;
    fossil settings case-sensitive TRUE ;
    fossil checkout --force --latest
    fossil pull 
    fossil close
    sync;
} # fun_initialize_sandbox_t1


#--------------------------------------------------------------------------
fun_last_minute_checks_t1() {
    # Last minute checks, just to be sure.
    local S_FP_FORBIDDEN_VALUE=$1
    if [ "$S_FP_FORBIDDEN_VALUE" == "/" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='3c4e5af3-7901-474c-939b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "$HOME" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='c200ef46-b3f7-4204-919b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/home" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='d2a65b5e-0591-4332-948b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/root" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='03b089fe-baa7-4a68-b38b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/etc" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='0062ae2c-e3a2-4764-b28b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
    if [ "$S_FP_FORBIDDEN_VALUE" == "/usr" ]; then
        echo ""
        echo "This Bash script is flawed."
        echo "GUID=='9de55d34-dbca-4803-918b-f1e0305090e7'"
        echo ""
        #----
        cd $S_FP_ORIG
        exit 1
    fi
} # fun_last_minute_checks_t1


#--------------------------------------------------------------------------
SB_FOLDER_IS_EMPTY="$S_LC_NOT_DETERMINED"
fun_folder_is_empty_t1() {
    local S_FP_FOLDER_TO_STUDY=$1
    local S_FP_ORIG_LOCAL="`pwd`"
    #--------
    SB_FOLDER_IS_EMPTY="t"
    local S_TMP_0="`cd $S_FP_FOLDER_TO_STUDY; ls -l | grep \"total 0\"`"
    if [ "$S_TMP_0" == "" ]; then
        SB_FOLDER_IS_EMPTY="f"
    fi
    #--------
    cd $S_FP_ORIG_LOCAL # just in case
} # fun_folder_is_empty_t1

fun_folder_is_empty_t1 "$S_FP_DIR"
fun_assertion_t1 "$SB_FOLDER_IS_EMPTY"
if [ "$SB_FOLDER_IS_EMPTY" == "t" ]; then
    echo ""
    echo "This Bash script is flawed. The "
    echo "$S_FP_DIR" 
    echo "can not possibly be empty, because it contains "
    echo "at least one file, which is "
    echo "this very same Bash script that outputs the current error message."
    echo "GUID=='fb573a47-7195-4c06-b18b-f1e0305090e7'"
    echo ""
    #----
    cd $S_FP_ORIG
    exit 1
fi

#--------------------------------------------------------------------------

fun_activity_core_overwrite_local_with_remote() {
    fun_assert_repository_local_copy_existence
    #--------
    # The checks are party to cope with the `whoami`=="root" case.
    fun_last_minute_checks_t1 "$S_FP_SANDBOX"
    fun_last_minute_checks_t1 "$S_FP_ARCHIVES"
    fun_last_minute_checks_t1 "$S_FP_ARCHIVES_TS"
    #--------
    chmod -f -R u+rx $S_FP_SANDBOX
    fun_folder_is_empty_t1 "$S_FP_SANDBOX"
    if [ "$SB_FOLDER_IS_EMPTY" == "f" ]; then
        # This if-statement is needed because the 
        #      cp -f -R AnEmptyDirectory/* ToSomewhere/
        # gives an error.
        #----
        mkdir -p $S_FP_ARCHIVES_TS
        #----
        # The "chmod -f -R " is not used because it would
        # waste time on folders that are named by 
        # the older $S_FP_ARCHIVES_TS values.
        chmod -f 0700 $S_FP_ARCHIVES
        chmod -f 0700 $S_FP_ARCHIVES_TS 
        #----
        # The separate cp and rm of the sandbox
        # contents is to somewhat retain the original
        # file premissions of the sandbox contents.
        cp -f -R $S_FP_SANDBOX/* $S_FP_ARCHIVES_TS/
        fun_last_minute_checks_t1 "$S_FP_SANDBOX"
        chmod -f -R u+rwx $S_FP_SANDBOX
        rm -fr $S_FP_SANDBOX/*
    fi
    #--------
    cd $S_FP_SANDBOX
    fossil open $S_FP_DIR/$S_FP_FOSSILFILE_NAME # full path for reliability 
    fossil settings autosync off ;
    fossil checkout --force --latest
    fossil pull 
    fossil close
} # fun_activity_core_overwrite_local_with_remote



if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "overwrite_local_with_remote" ]; then
    fun_activity_core_overwrite_local_with_remote
    #----
    cd $S_FP_ORIG
    exit 0
fi # overwrite_local_with_remote



#--------------------------------------------------------------------------
fossil close 2>/dev/null

if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_public" ]; then
    fun_assert_the_lack_of_repository_local_copy_t1
    cd $S_FP_DIR 
    fossil clone $S_URL_REMOTE_REPOSITORY ./$S_FP_FOSSILFILE_NAME
    fun_initialize_sandbox_t1
    cd $S_FP_ORIG
    #----
    sync
    fun_activity_core_overwrite_local_with_remote
    cd $S_FP_ORIG
    sync
    #----
    exit 0
fi # clone_public


#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "clone_all" ]; then
    fun_assert_the_lack_of_repository_local_copy_t1
    cd $S_FP_DIR 
    #--------
    S_USERNAME=""
    while [ "$S_USERNAME" == "" ]
    do
        echo ""
        echo "Please enter a username: "
        S_USERNAME="`ruby -e \"s=gets.gsub(/[\n\r\s]/,'');print(s)\"`" 
        S_URL="`export S_USERNAME=\"$S_USERNAME\"; S_URL=\"$S_URL_REMOTE_REPOSITORY\" ruby -e 's_0=ENV[\"S_URL\"].sub(\"http://\",\"http:/\").sub(\"http:/\",\"http://\"+ENV[\"S_USERNAME\"].to_s+\":nonsensepassword@\");print(s_0)'`"
    done
    #--------
    fossil clone --private $S_URL ./$S_FP_FOSSILFILE_NAME
    fun_initialize_sandbox_t1
    cd $S_FP_ORIG
    #----
    sync
    fun_activity_core_overwrite_local_with_remote
    cd $S_FP_ORIG
    sync
    #----
    exit 0
fi # clone_all


#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "overwrite_remote_with_local" ]; then
    fun_assert_repository_local_copy_existence
    #--------
    # It's important that this script will not try 
    # to recursively copy/move the content of the "/" to 
    # a subfolder of the "/", the "/tmp". 
    # The other folders that are covered by the
    # test are a bit of an overkill here, may be even an
    # annoying and unjustified restrictions, but 
    # in most cases those restrictions do not hurt either.
    fun_last_minute_checks_t1 "$S_FP_SANDBOX"
    #----
    S_TMP_0="/tmp/tmp_mmmv_$S_VERSION_OF_THIS_SCRIPT"
    S_TMP_1="__"
    #--
    func_mmmv_GUID_t1
    S_TMP_FOR_LOCAL="$S_TMP_0$S_TMP_1$S_FUNC_MMMV_GUID_T1_RESULT"
    #--
    func_mmmv_GUID_t1
    S_TMP_FOR_COMMIT_MESSAGE="$S_TMP_0$S_TMP_1$S_FUNC_MMMV_GUID_T1_RESULT"
    mkdir -p $S_TMP_FOR_LOCAL
    chmod -f -R u+rwx $S_FP_SANDBOX
    mv -f $S_FP_SANDBOX/* $S_TMP_FOR_LOCAL/ # the -f is for empty sandbox
    #--------
    fun_activity_core_overwrite_local_with_remote 
    fun_last_minute_checks_t1 "$S_FP_SANDBOX" # should there be flaws elsewhere
    chmod -f -R u+rwx $S_FP_SANDBOX # to be able to delete the old content
    #--------
    cd $S_FP_SANDBOX
        fossil open $S_FP_DIR/$S_FP_FOSSILFILE_NAME # full path for reliability 
        fossil settings autosync off ;
        fun_folder_is_empty_t1 "$S_FP_SANDBOX"
        SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED="f"
        if [ "$SB_FOLDER_IS_EMPTY" == "f" ]; then
            fossil rm --hard --case-sensitive TRUE ./* 
            SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED="t"
            fun_last_minute_checks_t1 "`pwd`"
            if [ "$S_FP_SANDBOX" == "`pwd`" ]; then
                rm -fr ./*
            else
                echo ""
                echo "This Bash script is flawed."
                echo "GUID=='20848e2d-db76-40f0-b18b-f1e0305090e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1
            fi
        fi
        mv -f $S_TMP_FOR_LOCAL/* $S_FP_SANDBOX/ # the -f is for empty source
        #----
        fun_last_minute_checks_t1 "$S_TMP_FOR_LOCAL"
        rm -fr $S_TMP_FOR_LOCAL
        #----
        fun_folder_is_empty_t1 "$S_FP_SANDBOX"
        if [ "$SB_FOLDER_IS_EMPTY" == "f" ]; then
            if [ "$S_FP_SANDBOX" != "`pwd`" ]; then
                echo ""
                echo "This Bash script is flawed."
                echo "GUID=='74c20b5b-81c4-4dea-a17b-f1e0305090e7'"
                echo ""
                #----
                cd $S_FP_ORIG
                exit 1
            fi
            find . -name '*' | xargs fossil add --force --dotfiles --case-sensitive TRUE  
            SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED="t"
        fi
        if [ "$SB_SANDBOX_CONTENT_MIGHT_HAVE_BEEN_CHANGED" == "t" ]; then
            if [ "$2" == "" ]; then
                echo ""
                #echo "Please enter a one-liner commit message: "
                #S_TMP_0="`ruby -e \"s=gets.gsub(/[\n\r\s]/,'');print(s)\"`" 
                # TODO: improve this script so that it would not ask 
                # for a commit message, when nothing changed. It requires
                # some recursive analysis of files, which might be slow.
                # This script is not optimal for speed even now and that would
                # make it even slower. On the other hand, usually when 
                # the upload operation is initiated, there are some changes,
                # which means that the slow analysis would be useless in 
                # most frequent cases. So this thing needs to be figured out 
                # at some later time, when there is more experience with the
                # use of this script.
                read -p "Please enter a one-liner commit message: " S_TMP_0
                echo $S_TMP_0 > $S_TMP_FOR_COMMIT_MESSAGE
            else
                if [ "$2" == "use_autogenerated_commit_message" ]; then
                    echo "Autogenerated commit message timestamp: $S_TIMESTAMP" > $S_TMP_FOR_COMMIT_MESSAGE
                else
                    if [ "$2" == "read_commit_message_from_file" ]; then
                        S_FP_MESSAGE_FILE_CANDIDATE="$3" # file path candidate
                        # Initial file existence and type checks for the 
                        # $S_FP_MESSAGE_FILE_CANDIDATE 
                        # were conducted at the start of the script.
                        # but the $S_FP_MESSAGE_FILE_CANDIDATE  might have
                        # referenced a file in the sandbox and 
                        # that file might have been just removed/deleted.
                        #
                        # There is no threat that the file got changed to a folder
                        # or a symlink switched from a file to a folder,
                        # at least that's the case for the single threaded model.
                        if [ ! -e "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                            # missing or a broken symlink
                            echo ""
                            echo "The commit message file is missing or "
                            echo "references a broken symlink."
                            echo "The file or symlink to it was fine at "
                            echo "the start of this script, it passed the various tests, "
                            echo "but for some reason it got deleted or its target . "
                            echo "got deleted. If the commit message file or"
                            echo "the symlink target resided within the sandbox, then "
                            echo "a recommendation is to use a file that resides "
                            echo "outside of the sandbox."
                            echo "GUID=='489d0043-ac2a-46ae-857b-f1e0305090e7'"
                            echo ""
                            #----
                            cd $S_FP_ORIG
                            exit 1
                        fi
                        if [ -d "$S_FP_MESSAGE_FILE_CANDIDATE" ]; then 
                            # folder or a symlink to a folder
                            echo ""
                            echo "The commit message file path does not reference "
                            echo "a file. It references a folder or a symlink to a folder."
                            echo "The file or symlink to it was fine at "
                            echo "the start of this script, it passed the various tests, "
                            echo "but for some reason there were changes. "
                            echo "GUID=='1c1054d1-d44f-4830-a47b-f1e0305090e7'"
                            echo ""
                            #----
                            cd $S_FP_ORIG
                            exit 1
                        fi
                        cat $S_FP_MESSAGE_FILE_CANDIDATE > $S_TMP_FOR_COMMIT_MESSAGE
                    # else
                    #     Due to the checks at the start of the script 
                    #     this else branch is useless.
                    fi
                fi
            fi
            #--------
            fossil commit --message-file $S_TMP_FOR_COMMIT_MESSAGE
            #----
            fun_last_minute_checks_t1 "$S_TMP_FOR_COMMIT_MESSAGE"
            rm -f $S_TMP_FOR_COMMIT_MESSAGE
            #----
        fi
    #--------
    fossil push --private
    fossil push 
    fossil pull --private
    fossil close
    #----
    cd $S_FP_ORIG
    exit 0
fi # overwrite_remote_with_local


#--------------------------------------------------------------------------
if [ "$S_ACTIVITY_OF_THIS_SCRIPT" == "delete_local_copy" ]; then
    #--------
    SB_THERE_IS_SOMETHING_TO_DELETE="f"
    if [ "$SB_FOSSILFILE_EXISTS" == "t" ]; then
        SB_THERE_IS_SOMETHING_TO_DELETE="t"
    fi
    if [ "$SB_SANDBOX_DIR_EXISTS" == "t" ]; then
        SB_THERE_IS_SOMETHING_TO_DELETE="t"
    fi
    if [ "$SB_ARCHIVE_DIR_EXISTS" == "t" ]; then
        SB_THERE_IS_SOMETHING_TO_DELETE="t"
    fi
    #--------
    if [ "$SB_THERE_IS_SOMETHING_TO_DELETE" == "t" ]; then 
        if [ "$2" != "$S_ARGNAME_ACTIVITY_SHRED_ARG_2" ]; then 
            # Includes the $2=="" case
            # id est if the control flow is in here, then there 
            # is a need to prompt for confirmation.
            # The skipping of the prompt is necessary for
            # software that use this script as its sub-component.
            #--------
            echo ""
            echo "The command \"delete_local_copy\" deletes "
            echo "the repository file, the sandbox and "
            echo "the associated automatically created archives."
            echo ""
            read -p "Proceed with deletion?  (Yes/whatever_else)  " S_TMP_0
            S_TMP_1="`echo $S_TMP_0 | gawk '{print tolower($1)}'`"
            if [ "$S_TMP_1" == "yes" ]; then
                echo ""
                printf "Deleting ... "
            else
                fun_exit_without_any_errors_t1
            fi
       fi
    fi
    #--------
    cd $S_FP_ORIG # to make sure that we're not in the sandbox directory and 
                  # to make sure that we're not in the archive directory
    #----
    # The next 3 checks can bee seen to form a complete graph, 
    # in this case a triangle, with corner points  
    # S_FP_SANDBOX, S_FP_ARCHIVES, S_FP_FOSSILFILE connected
    # with lines of type "!=".
    S_GUID="470c7051-b162-4cba-b51c-f1e0305090e7"
    func_mmmv_assert_file_paths_differ_t1 "$S_FP_FOSSILFILE" "$S_FP_SANDBOX" "$S_GUID"

    S_GUID="45b8df6a-0c67-4d1e-a71c-f1e0305090e7"
    func_mmmv_assert_file_paths_differ_t1 "$S_FP_SANDBOX" "$S_FP_ARCHIVES" "$S_GUID"

    S_GUID="42226761-7b9d-4cfb-bc1c-f1e0305090e7"
    func_mmmv_assert_file_paths_differ_t1 "$S_FP_ARCHIVES" "$S_FP_FOSSILFILE" "$S_GUID"
    #----
    # The next 3 checks turn the triangle to a tetrahedron, where  
    # the S_FP_ORIG is the "top of the pyramid".
    S_GUID="a9379a5b-d3aa-419b-820c-f1e0305090e7"
    func_mmmv_assert_file_paths_differ_t1 "$S_FP_ORIG" "$S_FP_FOSSILFILE" "$S_GUID"
    
    S_GUID="6d2d0251-9d35-4747-940c-f1e0305090e7"
    func_mmmv_assert_file_paths_differ_t1 "$S_FP_ORIG" "$S_FP_ARCHIVES" "$S_GUID"

    S_GUID="3b972413-c33d-4867-910c-f1e0305090e7"
    func_mmmv_assert_file_paths_differ_t1 "$S_FP_ORIG" "$S_FP_SANDBOX" "$S_GUID"
    #--------
    cd $S_FP_ORIG # just in case
    SB_OK_TO_USE_RM_IN_STEAD_OF_SHRED="t" # shred is still used, if available
    if [ "$SB_FOSSILFILE_EXISTS" == "t" ]; then
        fun_last_minute_checks_t1 "`pwd`"
        func_mmmv_shred_t1 "$S_FP_FOSSILFILE" "$SB_OK_TO_USE_RM_IN_STEAD_OF_SHRED"
    fi
    if [ "$SB_SANDBOX_DIR_EXISTS" == "t" ]; then
        fun_last_minute_checks_t1 "`pwd`"
        func_mmmv_shred_t1 "$S_FP_SANDBOX" "$SB_OK_TO_USE_RM_IN_STEAD_OF_SHRED"
    fi
    if [ "$SB_ARCHIVE_DIR_EXISTS" == "t" ]; then
        fun_last_minute_checks_t1 "`pwd`"
        func_mmmv_shred_t1 "$S_FP_ARCHIVES" "$SB_OK_TO_USE_RM_IN_STEAD_OF_SHRED"
    fi
    #--------
    if [ "$SB_THERE_IS_SOMETHING_TO_DELETE" == "t" ]; then 
        if [ "$2" != "$S_ARGNAME_ACTIVITY_SHRED_ARG_2" ]; then 
            echo "✓"
            echo ""
        fi
    fi
    #--------
    cd $S_FP_ORIG
    exit 0
fi # delete_local_copy


#--------------------------------------------------------------------------
# All possible actions must have been described
# above this code block.
echo ""
echo "This Bash script is flawed."
echo "GUID=='1b3f0b52-848d-494a-a47b-f1e0305090e7'"
echo ""
#----
cd $S_FP_ORIG
exit 1

#==========================================================================

