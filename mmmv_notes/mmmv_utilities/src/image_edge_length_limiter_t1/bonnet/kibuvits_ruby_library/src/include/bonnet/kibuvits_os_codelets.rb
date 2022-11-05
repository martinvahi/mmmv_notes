#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2010, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 Redistribution and use in source and binary forms, with or
 without modification, are permitted provided that the following
 conditions are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer
   in the documentation and/or other materials provided with the
   distribution.
 * Neither the name of the Martin Vahi nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end
#==========================================================================
if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"

#==========================================================================

# It's just a namespace for various operating system specific,
# relatively small, subroutines.
class Kibuvits_os_codelets
   @@cache=Hash.new
   attr_accessor :s_xx

   def initialize
      #@mx=Mutex.new
   end # initialize

   #-----------------------------------------------------------------------
   def get_os_type
      s_key='os_type'
      if @@cache.has_key? s_key
         s_out=""+@@cache[s_key]
         return s_out
      end # if
      s=RUBY_PLATFORM
      s_out='not_determined'
      if 	s.include? 'linux'
         s_out=$kibuvits_lc_kibuvits_ostype_unixlike
      elsif 	s.include? 'bsd' # on DesktopBSD it's "i386-freebsd7"
         s_out=$kibuvits_lc_kibuvits_ostype_unixlike
      elsif (s.include? 'win')||(s.include? 'mingw')
         s_out=$kibuvits_lc_kibuvits_ostype_windows
      elsif 	s.include? 'java' # JRuby
         s_out=$kibuvits_lc_kibuvits_ostype_java
         if system("ver")
            s_out=$kibuvits_lc_kibuvits_ostype_windows
         else
            s_fp="/tmp/"+generate_tmp_file_name()
            if system("uname")
               if system("uname > s_fp")
                  if File.exists? s_fp
                     s=file2str(s_fp)
                     File.delete s_fp
                     if s.include? "CYGWIN"
                        s_out=$kibuvits_lc_kibuvits_ostype_windows
                     end # if
                  end # if
               end # if
               File.delete s_fp if File.exists? s_fp
            end # if
         end # if
      else
         kibuvits_throw 'RUBY_PLATFORM=='+RUBY_PLATFORM+
         ' is not supported by this library.'
      end # elsif
      # There's no point of synchronizing it, because all
      # threads will insert a same result.

      @@cache[s_key]=$kibuvits_lc_emptystring+s_out
      return s_out
   end # get_os_type

   def Kibuvits_os_codelets.get_os_type
      s_out=Kibuvits_os_codelets.instance.get_os_type
      return s_out
   end # Kibuvits_os_codelets.get_os_type

   def Kibuvits_os_codelets.test_get_os_type
      Kibuvits_os_codelets.get_os_type
   end # Kibuvits_os_codelets.test_get_os_type

   #-----------------------------------------------------------------------
   def ht_path_2_os_type_check_for_Windows_compatibility(ht_out,s_in,
      rgx_common1,msgcs)
      if /[\/]/.match(s_in,0)!=nil
         # some invalid paths:
         # "abcd/hi.exe" a Linux path style
         return
      end # if
      s_lc_ostype="kibuvits_ostype_windows"
      if /^[\w][\w\d_]*:/.match(s_in)!=nil
         # "X:"
         # "C:\\xx\\yy"
         # "ScoobyDoo:\\xx\\yy"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if /[\\]/.match(s_in)!=nil
         # ".\\"
         # ".\\xx\\yy"
         # ".\\..\\"
         # ".\\..\\zz\\gg.txt"
         # ".\\..\\zz\\..\\ff\\ll.txt"
         # "..\\..\\"
         # "..\\..\\zz"
         # "xx\\"
         # "xx\\yy"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if /^[%][\w][\w\d_]*[%]/.match(s_in)!=nil
         # "%windir%\\yy"
         # "%windir%\\..\\"
         # "%windir%"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if rgx_common1.match(s_in)!=nil  # rgx_common1==/^[\w][\w\d _.]*$/
         # "hallo"
         # "hallo.txt"
         # "awesome.tar.gz"
         # "awesome......."
         # "awesome... .. .."
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
   end #  ht_path_2_os_type_check_for_Windows_compatibility

   def ht_path_2_os_type_check_for_Linux_compatibility(ht_out,s_in,
      rgx_common1,msgcs)

      if /[\\]/.match(s_in,0)!=nil
         # some invalid paths:
         # "abcd\\hi.exe" a Windows path style
         return
      end # if
      s_lc_ostype="kibuvits_ostype_unixlike"
      if /[\/]/.match(s_in,0)!=nil
         # "/"
         # "/hi.txt"
         # "/abcd"
         # "/abcd/"
         # "/abcd/hi.exe"
         # "/abcd/../hi.exe"
         # "/abcd/../tmp/"
         # "/abcd/../tmp/hi.exe"

         # "./xxx"
         # "./gg.txt"
         # "./x/"
         # "./../../../nice.txt"
         # "./../abc/../nice.txt"

         # "../"
         # "../../../"
         # "../x/"

         # "abcd/hi.exe"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if rgx_common1.match(s_in,0)!=nil  # rgx_common1==/^[\w][\w\d _.]*$/
         # "hallo"
         # "hallo.txt"
         # "awesome.tar.gz"
         # "awesome......."
         # "awesome... .. .."
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if

   end #  ht_path_2_os_type_check_for_Linux_compatibility

   def s_normalize_Linux_path(s_path_in,msgcs)
      #msgcs=Kibuvits_msgc_stack.new)
      s_out=s_path_in
   end # s_normalize_Linux_path

   public
   # Returns a hashtable, where the keys match
   # with their corresponding values and the keys are the operating
   # system types that use the format of the s_file_path_subject_to_analyze
   #
   # Example of a file path that is accepted by unix-like
   # operating systems and the windows:
   # ----verbatim--start----
   #    nice_filename.txt
   # ----verbatim--end------
   # It does not throw on the s_file_path_subject_to_analyze verification
   # failures.
   def ht_path_2_os_type(s_file_path_subject_to_analyze, msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path_subject_to_analyze
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      s_in=s_file_path_subject_to_analyze
      if s_in.length==0
         s_default_msg="s_file_path_subject_to_analyze.length==0"
         i_message_code=1
         b_failure=true
         s_default_language="English"
         msgc=Kibuvits_msgc.new(s_default_msg,i_message_code,b_failure,s_default_language)
         msgcs << msgc
         return
      end # if
      if (s_in.include? "/")&&(s_in.include? "\\")
         s_default_msg="The file/folder path contains both, "+
         "Windows and Unix path characters, i.e. "+
         "slashes and backslashes. s_file_path_subject_to_analyze=="+
         s_file_path_subject_to_analyze
         i_message_code=2
         b_failure=true
         s_default_language="English"
         msgc=Kibuvits_msgc.new(s_default_msg,i_message_code,b_failure,s_default_language)
         msgc["Estonian"]="Faili või kataloogi rada sisaldab nii Unix'i kui "+
         "Windowsi raja spetsiifilisi eraldusmärke."
         msgcs << msgc
         return
      end # if
      if /([.]{3})|([?])/.match(s_in,0)!=nil
         # some invalid paths:
         # "abcd/.../hi.exe"
         # "abcd/hi?.exe"
         s_default_msg="The file/folder path contained either 3 dots "+
         "or a question mark. The current specification of "+
         "this method considers that sort of paths to be invalid."
         s_file_path_subject_to_analyze
         i_message_code=3
         b_failure=true
         s_default_language="English"
         msgc=Kibuvits_msgc.new(s_default_msg,i_message_code,b_failure,s_default_language)
         msgc["Estonian"]="Faili või kataloogi rada sisaldab kas "+
         "kolme järjestikust punkti või küsimärki. Selle meetodi praeguse "+
         "spetsifikatsiooni järgi loetakse seda sorti faili/kataloogi rajad vigaseks."
         msgcs << msgc
         return
      end # if
      ht_out=Hash.new
      rgx_common1=/^[\w][\w\d _.]*$/
      ht_path_2_os_type_check_for_Windows_compatibility(ht_out,s_in,
      rgx_common1,msgcs)
      return if msgcs.b_failure
      ht_path_2_os_type_check_for_Linux_compatibility(ht_out,s_in,
      rgx_common1,msgcs)
      return ht_out
   end # ht_path_2_os_type

   def Kibuvits_os_codelets.ht_path_2_os_type(s_file_path_subject_to_analyze,msgcs)
      ht_out=Kibuvits_os_codelets.instance.ht_path_2_os_type(s_file_path_subject_to_analyze,msgcs)
      return ht_out
   end # Kibuvits_os_codelets.ht_path_2_os_type

   #-----------------------------------------------------------------------
   def get_tmp_folder_path
      s_system_name=self.get_os_type()
      s_out=''
      if defined? KIBUVITS_TMP_FOLDER_PATH
         s_out=KIBUVITS_TMP_FOLDER_PATH
      elsif s_system_name=='kibuvits_ostype_unixlike'
         s_out='/tmp'
      elsif s_system_name=='kibuvits_ostype_windows'
         #s_out=ENV['TEMP']
         #kibuvits_throw "ENV['TEMP']==nil" if s_out==nil
         # If cygwin or something alike is used, then the
         # cygwin uses the Linux file paths, i.e. /c/blabla, but
         # the ENV['TEMP'] gives c:/blablabla  and that breaks things.
         # the solution:
         s_out=KIBUVITS_HOME+"/src/bonnet/tmp"
         # There's nothing lost with that, because KRL relies on
         # unix tools anyway, which means that on Windows the KRL runs
         # on cygwin or something like that.
      elsif s_system_name=="kibuvits_ostype_java"
         s_out=KIBUVITS_HOME+"/src/bonnet/tmp"
      else
         kibuvits_throw 'System "'+s_system_name+'" is not supported.'
      end # elsif
      return s_out
   end # get_tmp_folder_path

   def Kibuvits_os_codelets.get_tmp_folder_path
      s_out=Kibuvits_os_codelets.instance.get_tmp_folder_path
      return s_out
   end # Kibuvits_os_codelets.get_tmp_folder_path

   #-----------------------------------------------------------------------
   def convert_file_path_2_unix_format(s_file_path, msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ht_ostypes=self.ht_path_2_os_type(s_file_path,msgcs)
      return "" if msgcs.b_failure
      return ""+s_file_path if ht_ostypes.has_key? "kibuvits_ostype_unixlike"
      # TODO: add various tests that analyze the path,i.e.
      # forbidden characters, whether the path goes higher than
      # the root, etc.
      s_pt=s_file_path.sub(":\\","/")
      i_len_diff=(s_file_path.length-s_pt.length)
      if 1<i_len_diff
         # There can be at most one ":\" in the path, like
         # C:\plapla
         kibuvits_throw "\""+s_file_path+"\" is not a file path."
         # TODO: add checks
      end # if
      s_pt=s_pt.gsub("\\","/")
      s_pt="/"+s_pt if i_len_diff==1
      s_pt=s_pt.gsub(/[\/]+/,"/")
      return s_pt
   end #convert_file_path_2_unix_format

   def Kibuvits_os_codelets.convert_file_path_2_unix_format(s_file_path,msgcs)
      s_p=Kibuvits_os_codelets.instance.convert_file_path_2_unix_format(
      s_file_path,msgcs)
      return s_p
   end # Kibuvits_os_codelets.convert_file_path_2_unix_format

   #-----------------------------------------------------------------------
   public

   # "/C/Program\ Files" -> "C:\\Program\ Files"
   def convert_file_path_2_windows_format(s_file_path,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ht_ostypes=self.ht_path_2_os_type(s_file_path,msgcs)
      return "" if msgcs.b_failure
      return ""+s_file_path if ht_ostypes.has_key? "kibuvits_ostype_windows"
      # TODO: add various tests that analyze the path,i.e.
      # forbidden characters, whether the path goes higher than
      # the root, etc.
      return s_file_path if s_file_path.length==0
      s_backslash="\\"
      s_p=s_file_path.gsub("/",s_backslash)
      s_p=s_p.gsub(/[\\]+/,s_backslash)
      s_char0=s_p[0..0]
      if (s_char0!=s_backslash)&&(s_char0!=".")
         s_p=s_backslash+s_p
      end # if
      return "" if s_p.length==1
      return s_p if s_p[0..0]=="."
      s_p=s_p[1..(-1)]
      s_clbsl=":\\"
      return s_p if s_p.include? s_clbsl
      ar=Kibuvits_str.bisect(s_p, s_backslash)
      s_p=ar[0]+s_clbsl+ar[1]
      return s_p
   end #convert_file_path_2_windows_format

   def Kibuvits_os_codelets.convert_file_path_2_windows_format(s_file_path,msgcs)
      s_p=Kibuvits_os_codelets.instance.convert_file_path_2_windows_format(
      s_file_path,msgcs)
      return s_p
   end # Kibuvits_os_codelets.convert_file_path_2_windows_format

   #-----------------------------------------------------------------------
   public

   # This method is DEPRECATED. One should always use UNIX paths.
   # It will be deleted after it has been refactored out from
   # the rest of the library.
   def convert_file_path_2_os_specific_format(s_file_path,msgcs)
      # TODO: throw it out after the resto of the library has been refactored.
      s_out=""+s_file_path
      return s_out
   end # convert_file_path_2_os_specific_format

   # This method is DEPRECATED. One should always use UNIX paths.
   # It will be deleted after it has been refactored out from
   # the rest of the library.
   def Kibuvits_os_codelets.convert_file_path_2_os_specific_format(s_file_path,msgcs)
      s_out=Kibuvits_os_codelets.instance.convert_file_path_2_os_specific_format(
      s_file_path,msgcs)
      return s_out
   end # Kibuvits_os_codelets.convert_file_path_2_os_specific_format

   #-----------------------------------------------------------------------
   public

   def generate_tmp_file_name s_file_name_prefix="tmp_file_"
      s=s_file_name_prefix+(Time.new.to_s).gsub!(/[\s;.\\\/:+]/,"_")
      # 2147483647==2^(32-1)-1, i.e. 0 included
      s=s+'r'+Kernel.rand(2147483647).to_s
      s=s+'r'+Kernel.rand(2147483647).to_s
      s=s+'r'+Kernel.rand(2147483647).to_s+'e.txt' # 'e' is a [^\d]
      return s
   end # generate_tmp_file_name

   def Kibuvits_os_codelets.generate_tmp_file_name(
      s_file_name_prefix="tmp_file_")
      s_out=Kibuvits_os_codelets.instance.generate_tmp_file_name(
      s_file_name_prefix)
      return s_out
   end # Kibuvits_os_codelets.generate_tmp_file_name

   #-----------------------------------------------------------------------
   def generate_tmp_file_absolute_path(s_file_name_prefix="tmp_file_",
      msgcs=nil)
      # TODO: refactor the msgcs part here
      #interpret_msgcs_var(msgcs,b_msgcs_received)
      s_fp0=get_tmp_folder_path+"/"+generate_tmp_file_name(s_file_name_prefix)
      #interpret_msgcs_var(msgcs,b_msgcs_received)
      return s_fp0
   end # generate_tmp_file_absolute_path

   def Kibuvits_os_codelets.generate_tmp_file_absolute_path(
      s_file_name_prefix="tmp_file_")
      s_out=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path(
      s_file_name_prefix)
      return s_out
   end # Kibuvits_os_codelets.generate_tmp_file_absolute_path

   #-----------------------------------------------------------------------
   # Returns the absolute path in an OS-specific format.
   def append2application_starterrubyfile_pwd(
      s_absolute_path_suffix_in_unix_format,msgcs=nil)
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), String, s_absolute_path_suffix_in_unix_format
      end # if
      # POOLELI. Tegelikult peaks siin kohe return-k2sk rakenduma, kui msgcs tuleb
      # kyll sisse, aga msgcs.b_failure==true M8tiskleda selle mehhanismi yle.
      # msgcs,b_msgcs_received=normalize_msgcs_var(msgcs)
      s=APPLICATION_STARTERRUBYFILE_PWD
      s_tail=s_absolute_path_suffix_in_unix_format.sub(/^[.][\/]/,"")
      s=(s+"/"+s_tail).gsub(/[\/]+/,"/")
      return s
   end # append2application_starterrubyfile_pwd

   def Kibuvits_os_codelets.append2application_starterrubyfile_pwd(
      s_absolute_path_suffix_in_unix_format,msgcs=nil)
      s_out=Kibuvits_os_codelets.instance.append2application_starterrubyfile_pwd(
      s_absolute_path_suffix_in_unix_format,msgcs)
      return s_out
   end # Kibuvits_os_codelets.append2application_starterrubyfile_pwd

   #-----------------------------------------------------------------------
   include Singleton
   def Kibuvits_os_codelets.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_os_codelets.test_get_os_type"
      return ar_msgs
   end # Kibuvits_os_codelets.selftest

end # class Kibuvits_os_codelets
#==========================================================================
# Sample code:
#puts Kibuvits_os_codelets.instance.generate_tmp_file_name()
#puts Kibuvits_os_codelets.instance.get_os_type
#puts Kibuvits_os_codelets.instance.get_tmp_folder_path
