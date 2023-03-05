#!/usr/bin/env bash 
#==========================================================================
# This file is in public domain.
#
# TODO: Rewrite this historic, proof of concept MESS 
#       so that Ruby wraps Bash, not the way this mess here
#       has been written. 
#
#       On the other hand, the mess here does seem to work, so
#       may be there is no need to "fix that isn't broken".
#       The idea that seedfiles reside at a single folder
#       and are refernced by symbolic links seems to work.
# 
#==========================================================================
S_FP_DIR_ORIG_GENERATE_BITTORRENT_FILES_SC1="$S_FP_DIR"
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_TIMESTAMP_PREFIX="`date +%Y`_`date +%m`_`date +%d`_`date +%H`:`date +%M`:`date +%S`_"
#==========================================================================

func_mmmv_exit_if_not_on_path_t2() { # S_COMMAND_NAME
    local S_COMMAND_NAME=$1
    local S_LOCAL_VARIABLE="`which $S_COMMAND_NAME`"
    if [ "$S_LOCAL_VARIABLE" == "" ]; then
        echo ""
        echo "Command \"$S_COMMAND_NAME\" could not be found from the PATH. "
        echo "The execution of the Bash script is aborted."
        echo "GUID='3a59c120-1248-4fd0-85e2-c271004040e7'"
        echo ""
        exit 1;
    fi
} # func_mmmv_exit_if_not_on_path_t2

func_mmmv_exit_if_not_on_path_t2  "gawk"
func_mmmv_exit_if_not_on_path_t2  "ln"
func_mmmv_exit_if_not_on_path_t2  "ls"
func_mmmv_exit_if_not_on_path_t2  "mktorrent"
func_mmmv_exit_if_not_on_path_t2  "nice"
func_mmmv_exit_if_not_on_path_t2  "pwd"
func_mmmv_exit_if_not_on_path_t2  "ruby"

#--------------------------------------------------------------------------

func_mmmv_exit_if_environment_variable_not_set_t1() { # S_ENVIRONMENT_VARIABLE_NAME
    local S_ENVIRONMENT_VARIABLE_NAME="$1"
    local S_ENVIRONMENT_VARIABLE_DOCSTRING="$2" # will be appended to failure-message
    #---------------
    local S_ENVIR_VALUE=""
    local S_SCRIPT_0="S_ENVIR_VALUE=\"\`echo \$$S_ENVIRONMENT_VARIABLE_NAME\`\""
    eval "$S_SCRIPT_0"
    if [ "$S_ENVIR_VALUE" == "" ]; then
        echo ""
        echo "The environment variable $S_ENVIRONMENT_VARIABLE_NAME is not set, but "
        echo "it must be set or this script will not run (properly)."
        echo "GUID='eed7601b-b272-4275-81d2-c271004040e7'"
        if [ "$S_ENVIRONMENT_VARIABLE_DOCSTRING" != "" ]; then
            echo ""
            echo "$S_ENVIRONMENT_VARIABLE_DOCSTRING"
        fi
        echo ""
        exit 1;
    #else 
         # echo "S_ENVIR_VALUE==\"$S_ENVIR_VALUE\""
    fi
} # func_mmmv_exit_if_environment_variable_not_set_t1

# func_mmmv_exit_if_environment_variable_not_set_t1 "CFLAGS"

#--------------------------------------------------------------------------

func_mmmv_angervaks_generate_single_torrent_file() { # S_FP_SEED S_SEED_MACHINE_URL
    local S_FP_SEED="$1"
    local S_SEED_MACHINE_URL="$2"
    #---------------
    local S_TMP_0="`echo \"$S_SEED_MACHINE_URL\" | gawk '{ gsub(/\s/, \"\"); print }'`"
    if [ "$S_TMP_0" != "$S_SEED_MACHINE_URL" ]; then
        echo ""
        echo "The S_SEED_MACHINE_URL(==$S_SEED_MACHINE_URL) ."
        echo "must not contain spaces or tabulation characters."
        echo "GUID='72868d19-9e5c-43d5-82d2-c271004040e7'"
        echo ""
        exit 1;
    fi
    if [ "$S_SEED_MACHINE_URL" == "" ]; then
        echo ""
        echo "The S_SEED_MACHINE_URL is either absent from the "
        echo "list of function arguments of the "
        echo ""
        echo "    func_mmmv_angervaks_generate_single_torrent_file(...)"
        echo ""
        echo "or it equals with an empty string."
        echo "GUID='59470925-2dcb-4eff-81d2-c271004040e7'"
        echo ""
        exit 1;
    fi
    #---------------
    if [ -h "$S_FP_SEED" ]; then
        #echo "symbolic link, regardless of whether it is broken or not"
        if [ ! -e "$S_FP_SEED" ]; then
            echo ""
            echo "The symbolic link "
            echo "$S_FP_SEED"
            echo "is broken"
            echo "GUID='88803be7-6c4b-4009-b3d2-c271004040e7'"
            echo ""
            exit 1
        else
            if [ -d "$S_FP_SEED" ]; then
                echo ""
                echo "The symbolic link "
                echo "$S_FP_SEED"
                echo "points to a folder, but it is expected to point to a file."
                echo "GUID='561cbf53-361d-49bf-91d2-c271004040e7'"
                echo ""
                exit 1
            fi
        fi
    else # not a symbolic link
        if [ ! -e "$S_FP_SEED" ]; then
            echo ""
            echo "The "
            echo "$S_FP_SEED"
            echo "is missing."
            echo "GUID='6e75f34e-6c50-49a1-94d2-c271004040e7'"
            echo ""
            exit 1
        fi
        if [ -d "$S_FP_SEED" ]; then
            echo ""
            echo "The "
            echo "$S_FP_SEED"
            echo "is a folder, but it is expected to be a file."
            echo "GUID='29a14f63-f15c-4bf4-89d2-c271004040e7'"
            echo ""
            exit 1
        fi
    fi # else
    #---------------
    local S_FP_TORRENTFILE="$S_FP_SEED.torrent"
    if [ -h "$S_FP_TORRENTFILE" ]; then
                echo ""
                echo "The "
                echo "$S_FP_TORRENTFILE"
                echo "is a symbolic link, but it should be "
                echo "either missing or be a file. "
                echo "Something is wrong. Aborting script."
                echo "GUID='942bc0d7-f923-4732-a4d2-c271004040e7'"
                exit 1
    else # not a symbolic link
        if [ -e "$S_FP_TORRENTFILE" ]; then
            if [ -d "$S_FP_TORRENTFILE" ]; then
                echo ""
                echo "The "
                echo "$S_FP_TORRENTFILE"
                echo "is a folder, but it is expected to be either missing or to be a file."
                echo "Something is wrong. Aborting script."
                echo "GUID='cdb8e827-cd70-43c3-93d2-c271004040e7'"
                echo ""
                exit 1
            fi
        fi
    fi # else
    #--------------------
    local SB_GENERATE_TORRENTFILE="t"
    if [ "$SB_DO_NOT_REGENERATE_ALL_BITTORRENT_FILES" == "t" ]; then
        if [ -e "$S_FP_TORRENTFILE" ]; then
            SB_GENERATE_TORRENTFILE="v"
        fi 
    fi
    #--------------------
    if [ "$SB_GENERATE_TORRENTFILE" == "t" ]; then
        rm -f $S_FP_TORRENTFILE
        #---------------
        export func_mmmv_angervaks_generate_single_torrent_file_S_FP_SEED="$S_FP_SEED"
        local S_FP_FILENAME=`ruby -e "s=ENV[\"func_mmmv_angervaks_generate_single_torrent_file_S_FP_SEED\"];print (s.reverse)[0..(s.reverse.index(\"/\")-1)].reverse"`
        #---------------
        local S_CMD_MKTORRENT_PART_1="nice -n5 mktorrent -a udp://tracker.publicbt.com:80/announce,udp://tracker.openbittorrent.com:80/announce,http://explodie.org:6969/announce,udp://11.rarbg.com/announce,udp://tracker.ccc.de:80,http://announce.torrentsmd.com:6969/announce -w "
        local S_SCRIPT_0="$S_CMD_MKTORRENT_PART_1 $S_SEED_MACHINE_URL/bittorrent_seeds/$S_FP_FILENAME $S_FP_SEED"
        #--------------------
        local S_FP_PWD_ORIG="`pwd`"
        local S_FP_DIR_FUNCCUSTOM="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
        #--------------------
        cd $S_FP_DIR_FUNCCUSTOM
        $S_SCRIPT_0
        cd $S_FP_PWD_ORIG
    fi # SB_GENERATE_TORRENTFILE
    #--------------------
} # func_mmmv_angervaks_generate_single_torrent_file

#--------------------------------------------------------------------------


func_mmmv_ar_ls_by_extension_t1_create_ruby_file() { # S_FP_RUBYFILE
    local S_FP_RUBYFILE=$1
    #--------------------
    rm -f $S_FP_RUBYFILE
    echo "#!/usr/bin/env ruby" >> $S_FP_RUBYFILE
    echo "#=========================================" >> $S_FP_RUBYFILE
    echo "# This ruby-file is in public domain." >> $S_FP_RUBYFILE
    echo "#=========================================" >> $S_FP_RUBYFILE
    echo "# Returns a string in the format of" >> $S_FP_RUBYFILE
    #--------
    #  The "ls -m " works with both, Linux and BSD.
    echo "# ls -m `pwd`/blaa.ext" >> $S_FP_RUBYFILE
    #--------
    echo "def s_ls_t1" >> $S_FP_RUBYFILE
    echo "   s_envname_list_of_extensions='S_FUNC_MMMV_AR_LS_BY_EXTENSION_T1_CREATE_RUBY_FILE_LIST_OF_EXTENSIONS'" >> $S_FP_RUBYFILE
    echo "   s_envname_s_fp_seedfiles_folder='S_FP_FUNC_MMMV_AR_LS_BY_EXTENSION_T1_CREATE_RUBY_FILE_SEEDFILES'" >> $S_FP_RUBYFILE
    echo "   #------------" >> $S_FP_RUBYFILE
    echo "   b_debug_mode=false" >> $S_FP_RUBYFILE
    echo "   if b_debug_mode" >> $S_FP_RUBYFILE
    echo "      s_envname_list_of_extensions='S_BLAA_1'" >> $S_FP_RUBYFILE
    echo "      s_envname_s_fp_seedfiles_folder='S_FP_SEEDFILES_FOLDER'" >> $S_FP_RUBYFILE
    echo "      ENV[s_envname_list_of_extensions]='txt|rb|'" >> $S_FP_RUBYFILE
    echo "      require 'pathname'" >> $S_FP_RUBYFILE
    echo "      ob_pth_0=Pathname.new(__FILE__).realpath" >> $S_FP_RUBYFILE
    echo "      s_fp_folder=ob_pth_0.parent.to_s" >> $S_FP_RUBYFILE
    echo "      ENV[s_envname_s_fp_seedfiles_folder]=s_fp_folder" >> $S_FP_RUBYFILE
    echo "   end # if" >> $S_FP_RUBYFILE
    echo "   #-----------" >> $S_FP_RUBYFILE
    echo "   s_list_of_extensions=''+ENV[s_envname_list_of_extensions].to_s" >> $S_FP_RUBYFILE
    echo "   s_fp_folder=''+ENV[s_envname_s_fp_seedfiles_folder]" >> $S_FP_RUBYFILE
    echo "   s_0=s_list_of_extensions.sub(/[|]$/,'').sub(/^[|]/,'').gsub(/[\s\t\r]+/,'')" >> $S_FP_RUBYFILE
    echo "   ar_ext=s_0.scan(/[^|]+/)" >> $S_FP_RUBYFILE
    echo "   ar_list=Array.new" >> $S_FP_RUBYFILE
    echo "   ar_0=nil" >> $S_FP_RUBYFILE
    echo "   s_0=s_fp_folder+'/*.'" >> $S_FP_RUBYFILE
    echo "   s_1=nil" >> $S_FP_RUBYFILE
    echo "   ar_ext.each do |s_file_extension|" >> $S_FP_RUBYFILE
    echo "      s_1=s_0+s_file_extension" >> $S_FP_RUBYFILE
    echo "      ar_0=Dir.glob(s_1)" >> $S_FP_RUBYFILE
    echo "      ar_list=ar_list+ar_0" >> $S_FP_RUBYFILE
    echo "   end # loop" >> $S_FP_RUBYFILE
    echo "   #----------" >> $S_FP_RUBYFILE
    echo "   s_separator=', '" >> $S_FP_RUBYFILE
    echo "   b_first=true" >> $S_FP_RUBYFILE
    echo "   s_out=''" >> $S_FP_RUBYFILE
    echo "   ar_list.each do |s_fp|" >> $S_FP_RUBYFILE
    echo "      if b_first" >> $S_FP_RUBYFILE
    echo "         b_first=false" >> $S_FP_RUBYFILE
    echo "      else" >> $S_FP_RUBYFILE
    echo "         s_out<<s_separator" >> $S_FP_RUBYFILE
    echo "      end # if" >> $S_FP_RUBYFILE
    echo "      s_out<<s_fp" >> $S_FP_RUBYFILE
    echo "   end # loop" >> $S_FP_RUBYFILE
    echo "   print s_out" >> $S_FP_RUBYFILE
    echo "end # s_ls_t1" >> $S_FP_RUBYFILE
    echo "" >> $S_FP_RUBYFILE
    echo "s_ls_t1()" >> $S_FP_RUBYFILE
    echo "" >> $S_FP_RUBYFILE
} # func_mmmv_ar_ls_by_extension_t1_create_ruby_file


# Samples of the S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS values:
# 
#     bzip2|tar|gz
#          
#     xz
#
#     arj|jar|txt|
#
func_mmmv_ar_ls_by_extension_t1() { # S_ARRAY_VARIABLE_NAME S_FP_LS S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS
    local S_ARRAY_VARIABLE_NAME=$1
    local S_FP_LS=$2
    local S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS=$3
    #--------------------
    local S_SCRIPT_0="local S_LEN=\${#$S_ARRAY_VARIABLE_NAME[@]}"
    eval ${S_SCRIPT_0}
    if [ "$S_LEN" == "0" ]; then # if the array is empty or does not exist
        S_SCRIPT_0="$S_ARRAY_VARIABLE_NAME=()" # init array
        eval "$S_SCRIPT_0" 
    fi
    #--------------------
    local S_FP_RUBYFILE="/tmp/tmp_rubyfile_for_regenerate_bittorrent_files_to_update_their_seed_URL_$S_TIMESTAMP_PREFIX.rb"
    func_mmmv_ar_ls_by_extension_t1_create_ruby_file "$S_FP_RUBYFILE"
    local S_FP_DIR_FUNCCUSTOM="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    #--------------------
    local S_FP_ORIG="`pwd`"
    cd $S_FP_LS
    export S_FUNC_MMMV_AR_LS_BY_EXTENSION_T1_CREATE_RUBY_FILE_LIST_OF_EXTENSIONS="$S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS"
    export S_FP_FUNC_MMMV_AR_LS_BY_EXTENSION_T1_CREATE_RUBY_FILE_SEEDFILES="$S_FP_DIR_FUNCCUSTOM"
    #--------
    #         The "ls -m " works with both, Linux and BSD.
    #local AR_0=$( ls -m $S_FP_DIR_FUNCCUSTOM/*.$S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS  )
    #--------
    local AR_0="`ruby $S_FP_RUBYFILE`"
    cd $S_FP_ORIG
    rm -f $S_FP_RUBYFILE
    #--------------------
    local s_iter=""
    local S_TMP_IFS="$IFS"
    # The IFS is an internal Bash variable, "Internal Field Separator".
    IFS="," # That should handle file names that contain spaces.
    S_SCRIPT_0="$S_ARRAY_VARIABLE_NAME+=(\$s_iter)"
    for s_iter in ${AR_0[@]}; do
        eval "$S_SCRIPT_0"
    done
    IFS="$S_TMP_IFS"
    if [ -z "$IFS" ]; then
        unset IFS
    fi
} # func_mmmv_ar_ls_by_extension_t1


# Depends on the value {"t","v",""} of 
#
#      SB_DO_NOT_REGENERATE_ALL_BITTORRENT_FILES
#
func_mmmv_angervaks_generate_torrent_files() { 
    #--------------------
    local S_FP_DIR_FUNCCUSTOM="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    local S_FP_PWD_ORIG="`pwd`"
    cd $S_FP_DIR_FUNCCUSTOM
    #--------------------
    local AR_SEED_FILE_EXTENSIONS=()
    #------- 
    AR_SEED_FILE_EXTENSIONS+=("bz2")
    AR_SEED_FILE_EXTENSIONS+=("tbz2")
    AR_SEED_FILE_EXTENSIONS+=("tlz")
    AR_SEED_FILE_EXTENSIONS+=("zip")
    AR_SEED_FILE_EXTENSIONS+=("zipx")
    AR_SEED_FILE_EXTENSIONS+=("gz")
    AR_SEED_FILE_EXTENSIONS+=("zz")
    AR_SEED_FILE_EXTENSIONS+=("zpaq")
    AR_SEED_FILE_EXTENSIONS+=("xz")
    AR_SEED_FILE_EXTENSIONS+=("7z")
    AR_SEED_FILE_EXTENSIONS+=("tgz")
    AR_SEED_FILE_EXTENSIONS+=("ar")
    AR_SEED_FILE_EXTENSIONS+=("iso")
    AR_SEED_FILE_EXTENSIONS+=("img")
    AR_SEED_FILE_EXTENSIONS+=("cpio")
    AR_SEED_FILE_EXTENSIONS+=("tar")
    AR_SEED_FILE_EXTENSIONS+=("lz")
    AR_SEED_FILE_EXTENSIONS+=("lzma")
    AR_SEED_FILE_EXTENSIONS+=("lzo")
    AR_SEED_FILE_EXTENSIONS+=("rz")
    AR_SEED_FILE_EXTENSIONS+=("sfark")
    AR_SEED_FILE_EXTENSIONS+=("xz")
    AR_SEED_FILE_EXTENSIONS+=("z")
    AR_SEED_FILE_EXTENSIONS+=("Z")
    AR_SEED_FILE_EXTENSIONS+=("alz")
    AR_SEED_FILE_EXTENSIONS+=("apk")
    AR_SEED_FILE_EXTENSIONS+=("arc")
    AR_SEED_FILE_EXTENSIONS+=("arj")
    AR_SEED_FILE_EXTENSIONS+=("b1")
    AR_SEED_FILE_EXTENSIONS+=("ba")
    AR_SEED_FILE_EXTENSIONS+=("bh")
    AR_SEED_FILE_EXTENSIONS+=("cab")
    AR_SEED_FILE_EXTENSIONS+=("cfs")
    AR_SEED_FILE_EXTENSIONS+=("cpt")
    AR_SEED_FILE_EXTENSIONS+=("dar")
    AR_SEED_FILE_EXTENSIONS+=("ear")
    AR_SEED_FILE_EXTENSIONS+=("lzh")
    AR_SEED_FILE_EXTENSIONS+=("lha")
    AR_SEED_FILE_EXTENSIONS+=("partimg")
    AR_SEED_FILE_EXTENSIONS+=("pea")
    AR_SEED_FILE_EXTENSIONS+=("rar")
    AR_SEED_FILE_EXTENSIONS+=("rk")
    AR_SEED_FILE_EXTENSIONS+=("war")
    AR_SEED_FILE_EXTENSIONS+=("jar")
    AR_SEED_FILE_EXTENSIONS+=("xar")

    # Slow as hell and contains a dumb constant, 
    # but it's a hacky script that is run about 
    # 10 times annually.
    AR_SEED_FILE_EXTENSIONS+=("part_0000")
    AR_SEED_FILE_EXTENSIONS+=("part_0001")
    AR_SEED_FILE_EXTENSIONS+=("part_0002")
    AR_SEED_FILE_EXTENSIONS+=("part_0003")
    AR_SEED_FILE_EXTENSIONS+=("part_0004")
    AR_SEED_FILE_EXTENSIONS+=("part_0005")
    AR_SEED_FILE_EXTENSIONS+=("part_0006")
    AR_SEED_FILE_EXTENSIONS+=("part_0007")
    AR_SEED_FILE_EXTENSIONS+=("part_0008")
    AR_SEED_FILE_EXTENSIONS+=("part_0009")
    AR_SEED_FILE_EXTENSIONS+=("part_0010")
    AR_SEED_FILE_EXTENSIONS+=("part_0011")
    AR_SEED_FILE_EXTENSIONS+=("part_0012")
    AR_SEED_FILE_EXTENSIONS+=("part_0013")
    AR_SEED_FILE_EXTENSIONS+=("part_0014")
    AR_SEED_FILE_EXTENSIONS+=("part_0015")
    AR_SEED_FILE_EXTENSIONS+=("part_0016")
    AR_SEED_FILE_EXTENSIONS+=("part_0017")
    AR_SEED_FILE_EXTENSIONS+=("part_0018")
    AR_SEED_FILE_EXTENSIONS+=("part_0019")
    AR_SEED_FILE_EXTENSIONS+=("part_0020")
    AR_SEED_FILE_EXTENSIONS+=("part_0021")
    AR_SEED_FILE_EXTENSIONS+=("part_0022")
    AR_SEED_FILE_EXTENSIONS+=("part_0023")
    AR_SEED_FILE_EXTENSIONS+=("part_0024")
    AR_SEED_FILE_EXTENSIONS+=("part_0025")
    AR_SEED_FILE_EXTENSIONS+=("part_0026")
    AR_SEED_FILE_EXTENSIONS+=("part_0027")
    AR_SEED_FILE_EXTENSIONS+=("part_0028")
    AR_SEED_FILE_EXTENSIONS+=("part_0029")
    AR_SEED_FILE_EXTENSIONS+=("part_0030")
    AR_SEED_FILE_EXTENSIONS+=("part_0031")
    AR_SEED_FILE_EXTENSIONS+=("part_0032")
    AR_SEED_FILE_EXTENSIONS+=("part_0033")
    AR_SEED_FILE_EXTENSIONS+=("part_0034")
    AR_SEED_FILE_EXTENSIONS+=("part_0035")
    AR_SEED_FILE_EXTENSIONS+=("part_0036")
    AR_SEED_FILE_EXTENSIONS+=("part_0037")
    AR_SEED_FILE_EXTENSIONS+=("part_0038")
    AR_SEED_FILE_EXTENSIONS+=("part_0039")
    AR_SEED_FILE_EXTENSIONS+=("part_0040")

    echo ""
    echo "Assembling list of seedfiles..."
    local S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS=""
    for s_iter in ${AR_SEED_FILE_EXTENSIONS[@]}; do
        S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS="$S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS|$s_iter"
    done
    func_mmmv_ar_ls_by_extension_t1 "AR_FP_SEEDS" "$S_FP_DIR_FUNCCUSTOM" "$S_PILLARSEPARATED_LIST_OF_FILE_EXTENSIONS"
    #echo "$AR_FP_SEEDS"
    #--------------------
    if [ "$SB_DO_NOT_REGENERATE_ALL_BITTORRENT_FILES" != "t" ]; then
        rm -f $S_FP_DIR_FUNCCUSTOM/*.torrent
    fi
    echo "Iterating over seedfiles and creating torrents, if required..."
    for s_iter in ${AR_FP_SEEDS[@]}; do
         # echo "AR_FP_SEEDS element:[$s_iter]" 
         func_mmmv_angervaks_generate_single_torrent_file "$s_iter" "$S_SEED_MACHINE_URL"
    done
    echo "Torrent generation complete."
    echo ""
    #------------
    cd $S_FP_PWD_ORIG
} # func_mmmv_angervaks_generate_torrent_files


func_mmmv_create_link_to_torrentfile_t1() { 
    local S_FP_LINK="$1"                 # "FP" stands for "file path"
    local SB_COPY_IN_STEAD_OF_SYMLINK=$2 # "t" for copying. Some web servers do not follow symlinks.
    local SB_REGENERATE_TORRENTFILE="$3" # "t" for "true", "f" for "false"
    #---------------
    if [ -e "$S_FP_LINK" ]; then
        if [ -d "$S_FP_LINK" ]; then
            echo ""
            echo "The "
            echo "$S_FP_LINK"
            echo "is a folder, but it is expected to be a symlink or a file."
            echo "Aborting script."
            echo "GUID='dab5a61d-1dd0-4525-a3d2-c271004040e7'"
            echo ""
            exit 1
        fi
      # If the $S_FP_LINK is a symlink, then it 
      # might point to some other file than the
      # file that the symlink that is created by this function
      # points to.
      rm -f $S_FP_LINK 
    fi
    #--------------------
    local S_FP_DIR_FUNCCUSTOM="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    #--------------------
    export func_mmmv_create_link_to_torrentfile_t1_TMP_0="$S_FP_LINK"
    local S_TORRENTFILE_NAME=`ruby -e "s=ENV[\"func_mmmv_create_link_to_torrentfile_t1_TMP_0\"];print (s.reverse)[0..(s.reverse.index(\"/\")-1)].reverse"`
    local S_FP_TORRENTFILE="$S_FP_DIR_FUNCCUSTOM/$S_TORRENTFILE_NAME"
    # BitTorrent files end with an extension .torrent
    local S_SEED_NAME=`ruby -e "s=ENV[\"func_mmmv_create_link_to_torrentfile_t1_TMP_0\"];print ((s.reverse)[0..(s.reverse.index(\"/\")-1)].reverse)[0..(-9)]"`
    local S_FP_SEED="$S_FP_DIR_FUNCCUSTOM/$S_SEED_NAME"
    #--------------------
    if [ -e "$S_FP_TORRENTFILE" ]; then
        if [ -d "$S_FP_TORRENTFILE" ]; then
            echo ""
            echo "The "
            echo "$S_FP_TORRENTFILE"
            echo "is a folder, but it is expected to be a symlink or a file."
            echo "Aborting script."
            echo "GUID='e992923b-e775-441b-83d2-c271004040e7'"
            echo ""
            exit 1
        fi
        if [ "$SB_REGENERATE_TORRENTFILE" == "t" ]; then
            # If the $S_FP_TORRENTFILE exists, then it might 
            # contain a wrong seed URL. 
            rm -f $S_FP_TORRENTFILE 
            func_mmmv_angervaks_generate_single_torrent_file "$S_FP_SEED" "$S_SEED_MACHINE_URL"
        fi
    else 
        rm -f $S_FP_TORRENTFILE  # to delete dead symlink
        func_mmmv_angervaks_generate_single_torrent_file "$S_FP_SEED" "$S_SEED_MACHINE_URL"
    fi
    #--------------------
    if [ -e "$S_FP_TORRENTFILE" ]; then
        rm -f $S_FP_LINK
        if [ "$SB_COPY_IN_STEAD_OF_SYMLINK" == "t" ]; then
            cp -f $S_FP_TORRENTFILE $S_FP_LINK
        else
            ln -s $S_FP_TORRENTFILE $S_FP_LINK
        fi
    else
        echo ""
        echo "Something went wrong. The torrent file should have been "
        echo "created, but it is missing. S_FP_LINK=="
        echo "$S_FP_LINK"
        echo "Aborting script."
        echo "GUID='55f48d52-e3b2-4ded-bcd2-c271004040e7'"
        echo ""
        exit 1
    fi
} # func_mmmv_create_link_to_torrentfile_t1

#--------------------------------------------------------------------------

#S_SEED_MACHINE_URL="http://archivestoragenode1.softf1.com:1984/"
if [ "$S_SEED_MACHINE_URL" == "" ]; then
    read -p "Please enter seed server URL: " S_SEED_MACHINE_URL
fi


#SB_COPY_IN_STEAD_OF_SYMLINK="t" # Hiawatha web server does not follow symlinks
#SB_REGENERATE_TORRENTFILE="v"
#S_FP_LINK="$S_FP_DIR/demo_1.txt.bz2.torrent" 
#func_mmmv_create_link_to_torrentfile_t1 $S_FP_LINK "$SB_REGENERATE_TORRENTFILE" "$SB_REGENERATE_TORRENTFILE"

#--------------------------------------------------------------------------

func_mmmv_angervaks_generate_torrent_files

#==========================================================================
S_FP_DIR="$S_FP_DIR_ORIG_GENERATE_BITTORRENT_FILES_SC1"

