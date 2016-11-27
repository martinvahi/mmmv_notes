#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2009, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_SHELL_RB_INCLUDED
   KIBUVITS_SHELL_RB_INCLUDED=true

   if !defined? KIBUVITS_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
      require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
   end # if

   require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
   require  KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
end # if

#==========================================================================

# It's a sub-function of the function sh
def kibuvits_sh_unix(s_shell_script)
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck binding(), String, s_shell_script
   end # if
   s_fp_script_0=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stdout=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stderr=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   #------------
   b_throw_if_not_found=true
   s_fp_bash=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
   "bash", b_throw_if_not_found)
   #------------
   str2file(s_shell_script,s_fp_script_0)
   str2file($kibuvits_lc_emptystring,s_fp_stdout)
   str2file($kibuvits_lc_emptystring,s_fp_stderr)
   cmd=s_fp_bash+$kibuvits_lc_space+s_fp_script_0+" 1>"+s_fp_stdout+" 2>"+s_fp_stderr+" ;"
   ht_stdstreams=Kibuvits_io.create_empty_ht_stdstreams
   begin
      # Kernel.system return values:
      #     true  on success, e.g. program returns 0 as execution status
      #     false on successfully started program that
      #              returns nonzero execution status
      #     nil   on command that could not be executed
      x_success=system(cmd)

      # An alternative version that needs improvement:
      #
      #     x_success=nil
      #     IO.popen(cmd) {x_success=true }
      #
   rescue Exception=>e
      File.delete(s_fp_script_0)
      File.delete(s_fp_stdout)
      File.delete(s_fp_stderr)
      kibuvits_throw e.message.to_s
   end # try-catch
   s_stdout=Kibuvits_str.normalise_linebreaks(
   file2str(s_fp_stdout),$kibuvits_lc_linebreak)
   s_stderr=Kibuvits_str.normalise_linebreaks(
   file2str(s_fp_stderr),$kibuvits_lc_linebreak)
   File.delete(s_fp_script_0) if File.exists? s_fp_script_0
   File.delete(s_fp_stdout) if File.exists? s_fp_stdout
   File.delete(s_fp_stderr) if File.exists? s_fp_stderr
   ht_stdstreams[$kibuvits_lc_s_stdout]=s_stdout
   ht_stdstreams[$kibuvits_lc_s_stderr]=s_stderr
   return ht_stdstreams
end # kibuvits_sh_unix


$kibuvits_lc_mx_sh=Mutex.new


# Writes a script to a file and executes it in Bash. Returns a hashtable with
# keys "s_stdout" and "s_stderr". The values that are pointed by the keys
# are always strings.
#
# The line breaks within the s_stdout, s_stderr have been normalized
# to the "\n". In case of Windows the 2 header lines and the footer line
# have been removed from the s_stdout.
def kibuvits_sh(s_shell_script)
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck binding(), String, s_shell_script
   end # if
   s_ostype=Kibuvits_os_codelets.instance.get_os_type
   ht_stdstreams=nil
   $kibuvits_lc_mx_sh.synchronize do
      case s_ostype
      when "kibuvits_ostype_unixlike"
         ht_stdstreams=kibuvits_sh_unix(s_shell_script)
      else
         # Some of the cases, where it happens:
         # "kibuvits_ostype_java", "kibuvits_ostype_windows"
         kibuvits_throw("Operating system with the "+
         "Kibuvits Ruby Library operating system type \""+
         s_ostype+"\" is not supported by this function.")
      end # case
   end # synchronize
   return ht_stdstreams
end # kibuvits_sh

#--------------------------------------------------------------------------

# The same as the kibuvits_sh(...), except that it
# prints the output streams, if there's any output.
def kibuvits_sh_writeln2console_t1(s_shell_script)
   ht_stdstreams=sh(s_shell_script)
   s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
   s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
   kibuvits_writeln s_stdout if 0<s_stdout.length
   if 0<s_stderr.length
      kibuvits_writeln $kibuvits_lc_linebreak+s_stderr+$kibuvits_lc_linebreak
   end # if
   return ht_stdstreams
end # kibuvits_sh_writeln2console_t1

#--------------------------------------------------------------------------

class Kibuvits_shell

   def initialize
      @s_lc_which="which ".freeze
      @s_lc_1="[/]".freeze
   end # initialize

   #-----------------------------------------------------------------------

   private

   # Returns an empty string, if not found.
   # It's also used in
   #
   #     b_available_on_path(...)
   #
   def s_exc_system_specific_path_by_caching_t1_look_from_system(s_program_name)
      s_fp="/usr/bin/env"
      if !File.exist? s_fp
         kibuvits_throw("The file "+ s_fp+" does not exist."+
         "\nGUID='a05d2a54-1515-4cfb-951e-40d150011fd7'")
      end # if
      s_fp_stdout=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
      s_fp_stderr=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
      cmd="which "+s_program_name+" 1>"+s_fp_stdout+" 2>"+s_fp_stderr+" ;"
      x_success=nil
      begin
         # Kernel.system(...) return values:
         #     true  on success, e.g. program returns 0 as execution status
         #     false on successfully started program that
         #              returns nonzero execution status
         #     nil   on command that could not be executed
         x_success=system(cmd)
      rescue Exception=>e
         File.delete(s_fp_stdout)
         File.delete(s_fp_stderr)
         kibuvits_throw e.message.to_s
      end # try-catch
      s_stdout=$kibuvits_lc_emptystring
      if x_success==true
         s_stdout=file2str(s_fp_stdout).gsub(/[\n\r]/,$kibuvits_lc_emptystring)
      end # if
      File.delete(s_fp_stdout) if File.exist? s_fp_stdout
      File.delete(s_fp_stderr) if File.exist? s_fp_stderr
      return s_stdout
   end # s_exc_system_specific_path_by_caching_t1_look_from_system

   public

   # A pooling wrapper to the /usr/bin/env
   #
   # If the s_program_name is found on PATH,
   # returns the full path of the s_program_name
   #
   # If the s_program_name is NOT found on PATH,
   # returns an empty string or throws an exception.
   def s_exc_system_specific_path_by_caching_t1(s_program_name,b_throw_if_not_found=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         i_min_length=2 # May be it should be 1?
         # The i_min_length can be changed to 1, after problems emerge.
         kibuvits_assert_string_min_length(bn,s_program_name,i_min_length,
         "GUID='b3cf4512-5d46-4c10-821e-40d150011fd7'")
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_throw_if_not_found
      end # if
      if !defined? @ht_s_exc_system_specific_path_by_caching_t1_cache
         @ht_s_exc_system_specific_path_by_caching_t1_cache=Hash.new
      end # if
      #---------------
      # s_fp is a string in stead of nil to match the
      # s_exc_system_specific_path_by_caching_t1_look_from_system output format.
      s_fp=$kibuvits_lc_emptystring
      if @ht_s_exc_system_specific_path_by_caching_t1_cache.has_key? s_program_name
         s_fp=@ht_s_exc_system_specific_path_by_caching_t1_cache[s_program_name]
      else
         s_fp=s_exc_system_specific_path_by_caching_t1_look_from_system(s_program_name)
         if 0<s_fp.length
            @ht_s_exc_system_specific_path_by_caching_t1_cache[s_program_name]=s_fp.freeze
         end # if
      end # if
      #---------------
      if s_fp.length==0
         if b_throw_if_not_found
            kibuvits_throw("Program \""+ s_program_name+
            "\" could not be found on the PATH."+
            "\nGUID='308c735b-e911-4ad9-a31e-40d150011fd7'")
         end # if
      end # if
      return s_fp
   end # s_exc_system_specific_path_by_caching_t1


   def Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
      s_program_name,b_throw_if_not_found=true)
      s_out=Kibuvits_shell.instance.s_exc_system_specific_path_by_caching_t1(
      s_program_name,b_throw_if_not_found)
      return s_out
   end # Kibuvits_shell.s_exc_system_specific_path_by_caching_t1

   #-----------------------------------------------------------------------

   # Returns boolean true, if the script or binary named
   # valueof(s_executable_name) is available on the path.
   #
   # The semantics of it is that it always studies
   # the PATH and does not cache the results.
   def b_available_on_path(s_program_name) # like "which", "grep", "vim", etc.
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_program_name
      end # if
      b_out=false
      s_fp=s_exc_system_specific_path_by_caching_t1_look_from_system(s_program_name)
      b_out=true if 0<s_fp.length
      return b_out
   end # b_available_on_path

   def Kibuvits_shell.b_available_on_path(s_program_name)
      b_out=Kibuvits_shell.instance.b_available_on_path(s_program_name)
      return b_out
   end # Kibuvits_shell.b_available_on_path

   #-----------------------------------------------------------------------

   def b_stderr_has_content_t1(ht_stdstreams)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_stdstreams
         kibuvits_assert_ht_has_keys(bn,ht_stdstreams,
         [$kibuvits_lc_s_stderr,$kibuvits_lc_s_stdout],
         "\nGUID='53e69253-3fee-49cc-841e-40d150011fd7'")
      end # if
      s_err=ht_stdstreams[$kibuvits_lc_s_stderr]
      if s_err.class!=String
         # s_err==nil, if the key is missing from the hashtable and
         # there is a flaw somewhere, if s_err is a number or
         # some custom instance, etc.
         kibuvits_throw("The ht_stdstreams does not seem to have the "+
         "right content. \nGUID='85c18e71-5b30-4af8-b11e-40d150011fd7'")
      end # if
      return false if s_err.length==0
      return true
   end # b_stderr_has_content_t1

   def Kibuvits_shell.b_stderr_has_content_t1(ht_stdstreams)
      b_out=Kibuvits_shell.instance.b_stderr_has_content_t1(ht_stdstreams)
      return b_out
   end # Kibuvits_shell.b_stderr_has_content_t1


   def throw_if_stderr_has_content_t1(ht_stdstreams,
      s_optional_error_message_suffix=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_stdstreams
         kibuvits_typecheck bn, [NilClass,String], s_optional_error_message_suffix
         kibuvits_assert_ht_has_keys(bn,ht_stdstreams,
         [$kibuvits_lc_s_stderr,$kibuvits_lc_s_stdout],
         "\nGUID='e6f03232-974e-4864-841e-40d150011fd7'")
      end # if
      return if !b_stderr_has_content_t1(ht_stdstreams)
      s_msg=ht_stdstreams[$kibuvits_lc_s_stderr]+$kibuvits_lc_linebreak
      if s_optional_error_message_suffix!=nil
         s_msg=s_msg+s_optional_error_message_suffix+$kibuvits_lc_linebreak
      end # if
      kibuvits_throw(s_msg)
   end # throw_if_stderr_has_content_t1

   def Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
      s_optional_error_message_suffix=nil)
      Kibuvits_shell.instance.throw_if_stderr_has_content_t1(
      ht_stdstreams,s_optional_error_message_suffix)
   end # Kibuvits_shell.throw_if_stderr_has_content_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_shell

#==========================================================================
# puts kibuvits_sh("whoami")["s_stdout"]
