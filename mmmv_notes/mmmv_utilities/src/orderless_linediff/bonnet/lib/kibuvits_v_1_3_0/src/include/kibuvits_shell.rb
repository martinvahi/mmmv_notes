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
      x=ENV['KIBUVITS_HOME']
      KIBUVITS_HOME=x if (x!=nil and x!="")
   end # if

   require "singleton"
   if defined? KIBUVITS_HOME
      require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
      require  KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"
      require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   else
      require  "kibuvits_io.rb"
      require  "kibuvits_os_codelets.rb"
      require  "kibuvits_str.rb"
   end # if
end # if

#==========================================================================

# It's a sub-function of the function sh
def sh_unix(s_shell_script)
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck binding(), String, s_shell_script
   end # if
   s_fp_script=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stdout=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stderr=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   cmd="bash "+s_fp_script+" 1>"+s_fp_stdout+" 2>"+s_fp_stderr+" ;"
   str2file(s_shell_script,s_fp_script)
   str2file($kibuvits_lc_emptystring,s_fp_stdout)
   str2file($kibuvits_lc_emptystring,s_fp_stderr)
   ht_stdstreams=Kibuvits_io.creat_empty_ht_stdstreams
   begin
      b_success=system(cmd)
   rescue Exception=>e
      File.delete(s_fp_script)
      File.delete(s_fp_stdout)
      File.delete(s_fp_stderr)
      kibuvits_throw e.message.to_s
   end # try-catch
   s_stdout=Kibuvits_str.normalise_linebreaks(
   file2str(s_fp_stdout),$kibuvits_lc_linebreak)
   s_stderr=Kibuvits_str.normalise_linebreaks(
   file2str(s_fp_stderr),$kibuvits_lc_linebreak)
   File.delete(s_fp_script)
   File.delete(s_fp_stdout)
   File.delete(s_fp_stderr)
   ht_stdstreams[$kibuvits_lc_s_stdout]=s_stdout
   ht_stdstreams[$kibuvits_lc_s_stderr]=s_stderr
   return ht_stdstreams
end # sh_unix

# It's a sub-function of the function sh
def sh_windows(s_shell_script)
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck binding(), String, s_shell_script
   end # if
   s_fp_script0=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_script=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stdout=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stderr=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
   cmd="export PATH=\"/bin:/usr/bin:/sbin:/cygdrive/c/Windows:$PATH\"; "+
   "bash "+s_fp_script+" 1>"+s_fp_stdout+" 2>"+s_fp_stderr+" ;"
   str2file(cmd,s_fp_script0)
   str2file(s_shell_script,s_fp_script)
   str2file($kibuvits_lc_emptystring,s_fp_stdout)
   str2file($kibuvits_lc_emptystring,s_fp_stderr)
   ht_stdstreams=Kibuvits_io.creat_empty_ht_stdstreams
   begin
      b_success=system("c:/cygwin/bin/bash "+s_fp_script0)
   rescue Exception=>e
      File.delete(s_fp_script0)
      File.delete(s_fp_script)
      File.delete(s_fp_stdout)
      File.delete(s_fp_stderr)
      kibuvits_throw e.message.to_s
   end # try-catch
   s_stdout=Kibuvits_str.normalise_linebreaks(
   file2str(s_fp_stdout),$kibuvits_lc_linebreak)
   s_stderr=Kibuvits_str.normalise_linebreaks(
   file2str(s_fp_stderr),$kibuvits_lc_linebreak)
   File.delete(s_fp_script0)
   File.delete(s_fp_script)
   File.delete(s_fp_stdout)
   File.delete(s_fp_stderr)
   ht_stdstreams[$kibuvits_lc_s_stdout]=s_stdout
   ht_stdstreams[$kibuvits_lc_s_stderr]=s_stderr
   return ht_stdstreams
end # sh_windows


# Writes a script to a file and executes it in Bash. Returns a hashtable with
# keys "s_stdout" and "s_stderr". The values that are pointed by the keys
# are always strings.
#
# The line breaks within the s_stdout, s_stderr have been normalized
# to the "\n". In case of Windows the 2 header lines and the footer line
# have been removed from the s_stdout.
def sh(s_shell_script)
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck binding(), String, s_shell_script
   end # if
   s_ostype=Kibuvits_os_codelets.instance.get_os_type
   ht_stdstreams=nil
   case s_ostype
   when "kibuvits_ostype_unixlike"
      ht_stdstreams=sh_unix(s_shell_script)
   when "kibuvits_ostype_windows"
      ht_stdstreams=sh_windows(s_shell_script)
   else
      # One case, where it happens: "kibuvits_ostype_java"
      kibuvits_throw("Operating system with the "+
      "Kibuvits Ruby Library operating system type \""+
      s_ostype+"\" is not supported by this function.")
   end # case
   return ht_stdstreams
end # sh

#--------------------------------------------------------------------------

# The same as the sh(...), except that it
# prints the output streams, if there's any output.
def kibuvits_sh_writeln2console_t1(s_shell_script)
   ht_stdstreams=sh(s_shell_script)
   s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
   s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
   puts s_stdout if 0<s_stdout.length
   if 0<s_stderr.length
      puts $kibuvits_lc_linebreak+s_stderr+$kibuvits_lc_linebreak
   end # if
   return ht_stdstreams
end # kibuvits_sh_writeln2console_t1

#--------------------------------------------------------------------------

class Kibuvits_shell
   def initialize
      @s_lc_which="which ".freeze
      @s_lc_1="[/]".freeze
   end # initialize

   # Returns boolean true, if the script or binary named
   # valueof(s_executable_name) is available on the path.
   def b_available_on_path(s_executable_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_executable_name
      end # if
      b_out=false
      ht=sh(@s_lc_which+s_executable_name)
      s_from_console=ht[$kibuvits_lc_s_stdout].to_s
      rgx=Regexp.new(@s_lc_1+s_executable_name+$kibuvits_lc_dollarsign)
      if (rgx.match(s_from_console))!=nil
         b_out=true
      end # if
      return b_out
   end # b_available_on_path

   def Kibuvits_shell.b_available_on_path(s_executable_name)
      b_out=Kibuvits_shell.instance.b_available_on_path(s_executable_name)
      return b_out
   end # Kibuvits_shell.b_available_on_path

   public
   include Singleton
   # The Kibuvits_shell.selftest analogue is
   # in a separate selftest file.

end # class Kibuvits_shell

#==========================================================================
