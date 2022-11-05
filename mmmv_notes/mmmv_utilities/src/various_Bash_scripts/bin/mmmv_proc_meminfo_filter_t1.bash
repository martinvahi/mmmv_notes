#!/usr/bin/env bash
# Initial author: Martin.Vahi@softf1.com
# This file is in the public domain.
#==========================================================================
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_ORIG="`pwd`"
#S_TIMESTAMP="`date +%Y`_`date +%m`_`date +%d`_T_`date +%H`h_`date +%M`min_`date +%S`s"

func_assert_exists_on_path_t1 () {
    local S_NAME_OF_THE_EXECUTABLE=$1 # first function argument
    local S_TMP_0="\`which $S_NAME_OF_THE_EXECUTABLE 2>/dev/null\`"
    local S_TMP_1=""
    local S_TMP_2="S_TMP_1=$S_TMP_0"
    eval ${S_TMP_2}
    if [ "$S_TMP_1" == "" ] ; then
        echo ""
        echo "This bash script requires the \"$S_NAME_OF_THE_EXECUTABLE\" to be on the PATH."
        echo "GUID=='7856d22d-bbcc-4235-a22b-13b0405174e7'"
        echo ""
        #----
        cd "$S_FP_ORIG"
        exit 1 # exit with error
    fi
} # func_assert_exists_on_path_t1

func_assert_exists_on_path_t1 "bash"   # this is a bash script, but it does not hurt
func_assert_exists_on_path_t1 "gawk"
func_assert_exists_on_path_t1 "grep"
func_assert_exists_on_path_t1 "cat"
func_assert_exists_on_path_t1 "ruby"   # anything over/equal v.2.1 will probably do
func_assert_exists_on_path_t1 "uname"  # to check the OS type
func_assert_exists_on_path_t1 "uuidgen"
func_assert_exists_on_path_t1 "basename"
func_assert_exists_on_path_t1 "test"
func_assert_exists_on_path_t1 "readlink"
#func_assert_exists_on_path_t1 "xargs"   
#func_assert_exists_on_path_t1 "file"    # for checking MIME types

#--------------------------------------------------------------------------
S_TMP_0="`uname -a | grep -E [Ll]inux`"
if [ "$S_TMP_0" == "" ]; then
    echo ""
    echo "  The classical command line utilities at "
    echo "  different operating systems, for example, Linux and BSD,"
    echo "  differ. This script is designed to run only on Linux."
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
    echo "  GUID=='6f107d59-8f5b-40bf-a32b-13b0405174e7'"
    echo ""
    echo "  Aborting script without doing anything."
    echo ""
    echo "GUID=='a19fdfc4-eefe-4f02-812b-13b0405174e7'"
    echo ""
    exit 1 # exit with error
fi

#--------------------------------------------------------------------------
export S_LC_SMALLER_THAN_MEMINFO="smaller_than_the_meminfo_field"
export S_LC_GREATER_THAN_MEMINFO="greater_than_the_meminfo_field"
export S_LC_EQUALS_MEMINFO="equals_with_the_meminfo_field"

func_print_help_msg_t1() {
    # http://stackoverflow.com/questions/192319/how-do-i-know-the-script-file-name-in-a-bash-script
    S_SCRIPT_NAME="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
    echo ""
    echo "Console arguments of this script:"
    echo ""
    echo "    </proc/meminfo field name without the colon>"
    echo "    (<positive whole number><a space or a tab>?B?)?"
    echo ""
    echo "The optional parameter is for comparison. "
    echo "If the optional parameter is missing, then this script"
    echo "prints to the console the /proc/meminfo field in bytes."
    echo "If the optional parameter is present, then this script"
    echo "prints to the console a string, which is one of the "
    echo "following strings:"
    echo ""
    echo "    $S_LC_SMALLER_THAN_MEMINFO"
    echo "    $S_LC_GREATER_THAN_MEMINFO"
    echo "    $S_LC_EQUALS_MEMINFO"
    echo ""
    echo "If the \$1 of this script is not a /proc/meminfo field, then "
    echo "this script will exit with an error code of 1. Sample commands:"
    echo ""
    echo "    ./$S_SCRIPT_NAME Inactive"
    echo "    ./$S_SCRIPT_NAME MemTotal"
    echo "    ./$S_SCRIPT_NAME MemTotal  42"
    echo "    ./$S_SCRIPT_NAME MemTotal  42B"
    echo "    ./$S_SCRIPT_NAME MemTotal  42B"
    echo ""
    echo ""
    echo ""
} # func_print_help_msg_t1


export S_MEMINFO_FIELD="$1";  #Examples: MemTotal, Inactive

#--------
if [ "$S_MEMINFO_FIELD" == "" ] ; then
    S_MEMINFO_FIELD="help"
fi
if [ "$S_MEMINFO_FIELD" == "?" ]; then
    S_MEMINFO_FIELD="help"
fi
if [ "$S_MEMINFO_FIELD" == "-?" ]; then
    S_MEMINFO_FIELD="help"
fi
if [ "$S_MEMINFO_FIELD" == "--help" ]; then
    S_MEMINFO_FIELD="help"
fi
if [ "$S_MEMINFO_FIELD" == "-help" ]; then
    S_MEMINFO_FIELD="help"
fi
#--------

if [ "$S_MEMINFO_FIELD" == "help" ] ; then
    func_print_help_msg_t1
    #----
    cd "$S_FP_ORIG"
    exit 1
fi
#--------------------------------------------------------------------------
export S_TMP_0="$1"
S_TMP_1="` \
ruby -e \"print(ENV['S_TMP_0'].to_s.gsub(/[\\s\\t\\n\\r]/,''));\"  \
`"

if [ "$S_TMP_0" != "$S_TMP_1" ] ; then
    echo ""
    echo "  This script does not support "
    echo "  /proc/meminfo fields that contain spaces, tabs or line breaks."
    echo "  GUID=='5a1c9051-6393-42a4-852b-13b0405174e7'"
    echo ""
    #----
    cd "$S_FP_ORIG"
    exit 1
fi
#----

#--------
SB_PERFORM_COMPARISON="f"
SI_COMPARABLE="not initialized"
if [ "$2" != "" ] ; then
    #--------
    # According to the specification of this script the 
    # $2 can be like "4B" or "4 B" or just "4".
    export S_TMP_00="$2"
    S_TMP_01="` \
    ruby -e \"print(ENV['S_TMP_00'].to_s.gsub(/[\\s\\t]*B\$/,''));\"  \
    `"
    #--------
    # The $S_TMP_01 is the $2 without the optional "B" and 
    # the spaces that precede the "B".
    export S_TMP_0="$S_TMP_01" 
    S_TMP_1="` \
    ruby -e \"print(ENV['S_TMP_0'].to_s.gsub(/[^\\d]/,''));\"  \
    `"
    #----
    if [ "$S_TMP_0" != "$S_TMP_1" ] ; then
        echo ""
        echo "  The 2. argument of this script must be a positive whole number,"
        echo "  but it currently contained a space or a tab or a line break."
        echo "  or some other non-digit character. Citation:($2)"
        echo "  GUID=='13a5da0b-9bea-4707-a12b-13b0405174e7'"
        echo ""
        #----
        cd "$S_FP_ORIG"
        exit 1
    fi
    export SI_COMPARABLE="$S_TMP_0"
    SB_PERFORM_COMPARISON="t"
    #--------
    if [ "$3" != "" ] ; then
        # It might be that in stead of 
        #
        #     <the file name of this script> MemTotal 444\ B
        #
        # the end user enters
        #     <the file name of this script> MemTotal 444  B
        # or
        #     <the file name of this script> MemTotal 444  \ B
        # or
        #     <the file name of this script> MemTotal 444  B\ # id est "B "
        #
        # That entry is not necessarily wrong, but if the entry is 
        #
        #     <the file name of this script> MemTotal 444 kB
        #
        # then an exception should be thrown, because the unit "kB" 
        # is not supported by this script. 
        #
        S_TMP_0="` echo "$3" | gawk '{ gsub(/ |\t/, ""); print }'`"
        #echo "($S_TMP_0)"
        if [ "$3" != "B" ] ; then
            echo ""
            echo "  The only unit that this script supports is B (single bytes)."
            echo "  The current unit candidate seems to be: ($3)"
            echo "  GUID=='67071456-a20a-4196-912b-13b0405174e7'"
            echo ""
            #----
            cd "$S_FP_ORIG"
            exit 1
        fi
    fi
    if [ "$4" != "" ] ; then
        echo ""
        echo "  This script supports at most 3 command line arguments."
        echo "  The visible/documented maximum number of "
        echo "  command line arguments is 2, but the current "
        echo "  call to this script received 4 command line arguments." 
        echo "  There is probably a flaw at the code that calls this script."
        echo "  The value of the 4. command line argument:($4)"
        echo "  GUID=='7bffc2a2-9d95-449a-b21b-13b0405174e7'"
        echo ""
        #----
        cd "$S_FP_ORIG"
        exit 1
    fi
    #--------
    # An exception should also be thrown on the double-unit cases:
    #
    #     <the file name of this script> MemTotal 444B  B 
    #     <the file name of this script> MemTotal 444BB B 
    #     <the file name of this script> MemTotal 444   BBBB 
    S_TMP_0="` echo "$2$3" | gawk '{ gsub(/[^B]/, ""); print }' | gawk '{ sub(/B/, ""); print }'`"
    if [ "$S_TMP_0" != "" ] ; then
        echo ""
        echo "  There's a flaw at the code that "
        echo "  calls this script, because the unit \"B\" is"
        echo "  used more than once at the single call to this script. "
        echo "  The value of the 2. command line argument:($2)"
        if [ "$3" != "" ] ; then
            echo "  The value of the 3. command line argument:($3)"
        fi
        echo "  GUID=='8ca49433-5d5e-467a-951b-13b0405174e7'"
        echo ""
        #----
        cd "$S_FP_ORIG"
        exit 1
    fi
fi

#--------------------------------------------------------------------------

# According to the 
#
#    http://unix.stackexchange.com/questions/263881/convert-meminfo-kb-to-bytes
#
# the /proc/meminfo designates 1024B with the small "kB",
# not the traditional "KB" or the "KiB".
# What regards to the MiB part then as of 2016_03 I, martin.vahi@softf1.com,
# do not know anything about it. I just assumed that may be
# it will then be the same kind of a mess and just used the
# classical 1KB==1024B, 1MB=1024KB, 1GB=1024MB style of calcucation.
#
# Please note that the 
#
#     gawk '{gsub(/B/,\"*1\");print}' | \
#
# needs to be the very last of the gawk-calls, because otherwise the 
#
#     "kB" -> "k" 
#
# and there is no regex that replaces the "k" with anything useful.
# The series of gawk-calls is such a hack to make it
# easy to copy-paste the single-liner to some other 
# programming language shell execution call. 
#
# The colon (":") at the grep-clause is mandatory, because otherwise 
# the grep can return more than one line, like it sometimes does for 
#
#     export S_MEMINFO_FIELD="Inactive";
#
export S_CAT_AND_GREP="`cat /proc/meminfo | grep $S_MEMINFO_FIELD: `"
if [ "$S_CAT_AND_GREP" == "" ] ; then
    echo ""
    echo "  The /proc/meminfo does not contain a field named \"$S_MEMINFO_FIELD\"."
    echo "  GUID=='44b26557-3742-48ca-a21b-13b0405174e7'"
    echo ""
    #----
    cd "$S_FP_ORIG"
    exit 1
fi

S_TMP_FILE_0="/tmp/tmp_mmmv_`uuidgen`.txt"

#export S_MEMINFO_FIELD="Inactive"; \
#export S_MEMINFO_FIELD="MemTotal";\#comentless version part of the single-liner
#ruby -e "s=%x(cat /proc/meminfo | grep $S_MEMINFO_FIELD: | \
ruby -e "s=%x(printf \"$S_CAT_AND_GREP\" | \
gawk '{gsub(/MemTotal:/,\"\");print}' | \
gawk '{gsub(/kB/,\"*1024\");print}' | \
gawk '{gsub(/KB/,\"*1024\");print}' | \
gawk '{gsub(/KiB/,\"*1024\");print}' | \
gawk '{gsub(/MB/,\"*1048576\");print}' | \
gawk '{gsub(/MiB/,\"*1048576\");print}' | \
gawk '{gsub(/GB/,\"*1073741824\");print}' | \
gawk '{gsub(/GiB/,\"*1073741824\");print}' | \
gawk '{gsub(/TB/,\"*1099511627776\");print}' | \
gawk '{gsub(/TiB/,\"*1099511627776\");print}' | \
gawk '{gsub(/B/,\"*1\");print}' | \
gawk '{gsub(/[^1234567890*]/,\"\");print}' \
); \
s_prod=s.gsub(/[\\s\\n\\r]/,\"\")+\"*1\";\
ar=s_prod.scan(/[\\d]+/);\
i_prod=1;\
ar.each{|s_x| i_prod=i_prod*s_x.to_i};\
print(i_prod.to_s);" > $S_TMP_FILE_0
#print(i_prod.to_s+\" B\");"

export S_TMP_0="`cat $S_TMP_FILE_0`"
rm -f $S_TMP_FILE_0

if [ "$SB_PERFORM_COMPARISON" == "t" ] ; then
    # Addresses within 8GiB of RAM can be 
    # greater than the 4B can handle, which explains
    # the need for the 64bit CPU architectures. 
    # Ruby is used for avoiding the Bash built-in 4B integers. 
    # Ruby uses absolute precision integers by default. The 
    #
    #     "$SI_COMPARABLE".to_i 
    #
    # is to handle "00099".to_i==99
    #
    if [ "`ruby -e \"print((\\\"$SI_COMPARABLE\\\".to_i==$S_TMP_0).to_s)\" `" == "true" ] ; then
        printf "$S_LC_EQUALS_MEMINFO"
    else
        if [ "`ruby -e \"print(($S_TMP_0<\\\"$SI_COMPARABLE\\\".to_i).to_s)\" `" == "true" ] ; then
            printf "$S_LC_GREATER_THAN_MEMINFO"
        else
            if [ "`ruby -e \"print((\\\"$SI_COMPARABLE\\\".to_i<$S_TMP_0).to_s)\" `" == "true" ] ; then
                printf "$S_LC_SMALLER_THAN_MEMINFO"
            else
                echo ""
                echo "  This Bash script is flawed. "
                echo "  SI_COMPARABLE==$SI_COMPARABLE"
                echo "  S_TMP_0==$S_TMP_0"
                echo "  GUID=='f38e3962-3396-4fd6-a61b-13b0405174e7'"
                echo ""
                #----
                cd "$S_FP_ORIG"
                exit 1
            fi
        fi
    fi
else
    if [ "$SB_PERFORM_COMPARISON" == "f" ] ; then
        printf "$S_TMP_0 B"
    else
        echo ""
        echo "  This Bash script is flawed. "
        echo "  SB_PERFORM_COMPARISON==$SB_PERFORM_COMPARISON"
        echo "  GUID=='20aae051-654f-4b48-b41b-13b0405174e7'"
        echo ""
        #----
        cd "$S_FP_ORIG"
        exit 1
    fi
fi


#--------------------------------------------------------------------------
cd "$S_FP_ORIG"
exit 0 # 

#==========================================================================

