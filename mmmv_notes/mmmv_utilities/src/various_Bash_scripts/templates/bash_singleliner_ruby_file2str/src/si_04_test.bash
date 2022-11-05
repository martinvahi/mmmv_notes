#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
S_FP_TMP="$S_FP_DIR/tmp_"
S_FP_FIFO="$S_FP_TMP/ff"
#--------------------------------------------------------------------------
rm -f "$S_FP_FIFO"
mkdir -p "$S_FP_TMP"
mkfifo "$S_FP_FIFO"

if [ -e "$S_FP_FIFO" ]; then 
    # The following Ruby based Bash line 
    # has been tested to work on both, Linux, and BSD.
    #
    # On BSD:
    # FreeBSD capella.elkdata.ee 12.2-RELEASE-p7 FreeBSD 12.2-RELEASE-p7 GENERIC  amd64
    # ruby 2.7.4p191 (2021-07-07 revision a21a3b7d23) [amd64-freebsd12]
    #
    # On Linux:
    # Linux terminal01 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux
    # ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
    printf 'a \nb b\ncc\ndd\td' > $S_FP_FIFO &  ruby -e " def file2str(s_file_path) ; s_out=\"\" ; s_fp=s_file_path ; begin ; File.open(s_fp) do |file| ; while s_line = file.gets; s_out<<s_line ; end ; end ; rescue Exception =>err ; raise(Exception.new(\"\n\"+err.to_s+\"\n\ns_file_path==\"+s_file_path+ \"\n GUID='245832f2-f85b-427a-b635-e201713195e7'\n\n\")) ; end ; return s_out ; end ; s=file2str(\"$S_FP_FIFO\") ; puts(\"----multiline-start---\n\"+s+\"\n----multiline---end---\"); puts(\"----singleline--start----\n\"+s.gsub(/[\n\r]/,'')+\"\n----singleline--end----\"); puts(\"----singleline--with--replacements--start----\n\"+s.gsub(/[\n\r]/,'').gsub(/[\s\t\r]/,'X')+\"\n----singleline--with--replacements--end----\"); "
    # A similar Bash line with GNU sed is:
    printf 'a \nb b\ncc\ndd\td' | sed -e :a  -e 'N;s/\n//;ta' | sed -e 's/[[:blank:]]\|[[:space:]]/X/g'
    # and that does not work with the BSD sed.
    echo ""
else
    echo ""
    echo -e "\e[31mThe creation of the FIFO failed.\e[39m"
    echo ""
    echo "    S_FP_FIFO=$S_FP_FIFO "
    echo ""
    echo "GUID=='3042fb14-5ea6-47d8-b515-e201713195e7'"
    echo ""
fi

rm -f "$S_FP_FIFO"
#==========================================================================
