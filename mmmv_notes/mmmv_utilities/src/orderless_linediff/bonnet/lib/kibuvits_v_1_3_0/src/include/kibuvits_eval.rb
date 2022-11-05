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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
else
   require  "kibuvits_os_codelets.rb"
   require  "kibuvits_shell.rb"
end # if
require "singleton"
#==========================================================================
# It's meant to be only a base class for bridges.
# No instances of it should ever be created.
class Kibuvits_eval_bridge
   def initialize
      @s_scriptfile_extension="_is_meant_to_be_set_in_sibling_classes"
      @s_bridge_name="<bridge name not set. GUID=="+
      "'7daa0c03-2b2a-425b-d4e6-a5cea2a29e0f'>"
   end #initialize

   # It's a hook for modifying the s_script prior to writing
   # it to the script file. For example, one can add
   # language specific start and end tags with it. It's meant
   # to be overridden, but its not compulsory to override it.
   def create_scriptfile_string s_script
      return s_script
   end # create_scriptfile_string

   def create_scriptfile s_script
      s_sc=create_scriptfile_string s_script
      s_fp=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path()
      s_fp=s_fp.gsub(".txt","_")+"."+@s_scriptfile_extension
      str2file(s_sc,s_fp)
      return s_fp
   end # create_scriptfile

   # It is expected to return a string.
   def create_console_command s_script_file_path
      kibuvits_throw "This method is meant to be overridden."
   end # create_console_command

   def installed
      kibuvits_throw "This method is meant to be overridden."
   end # installed

   def run s_script, msgcs
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_script
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ht_stdstreams=nil
      s_fp=""
      begin
         s_fp=create_scriptfile s_script
         cmd=create_console_command s_fp
         ht_stdstreams=sh cmd
      rescue Exception => e
         msgcs.cre "Something went wrong within the "+
         "Kibuvits to "+@s_bridge_name+" bridge. The error message: "+
         e.message.to_s,3.to_s
         msgcs.last['Estonian']="Midagi läks Kibuvits teegi "+
         @s_bridge_name+" sillal valesti. Veateade: "+e.message.to_s
         ht_stdstreams=Kibuvits_io.creat_empty_ht_stdstreams
      end # try-catch
      File.delete(s_fp) if File.exists? s_fp
      return ht_stdstreams
   end # run
end # class Kibuvits_eval_bridge
#==========================================================================
class Kibuvits_eval_bridge_PHP5 < Kibuvits_eval_bridge
   def initialize
      @s_scriptfile_extension="php"
      @s_bridge_name="PHP5"
      # TODO: port this class to Windows.
      if Kibuvits_os_codelets.instance.get_os_type!="kibuvits_ostype_unixlike"
         kibuvits_throw "Only unixlike operatingsystems supported."
      end # if
   end #initialize

   private
   def fix_start_end_tags s_script
      s_out=s_script
      regex=/[\s]*<[?][\s]*php[\s]/
      match_data=regex.match(s_script)
      if match_data==nil
         s_out="<?php \n"+s_script+" \n?>\n"
      end # if
      return s_out
   end # fix_start_end_tags

   public

   def create_scriptfile_string s_script
      s_out=fix_start_end_tags s_script
      return s_out
   end # create_scriptfile_string

   def create_console_command s_script_file_path
      #No ";" for corss-OS compatibility.
      cmd="php5 --file "+s_script_file_path+" "
      return cmd
   end # create_console_command

   def installed
      cmd="php5 -version "
      ht_stdstreams=sh cmd
      s_stdout=ht_stdstreams['s_stdout']
      b_installed=false
      b_installed=true if s_stdout.include? "Zend"
      return b_installed
   end # installed

end # class Kibuvits_eval_bridge_PHP5
#==========================================================================
# The ruby eval has been wrapped to this class for
# API unification purposes and it also serves the purpose
# of being an interpreter class source example.
class Kibuvits_eval_bridge_Ruby < Kibuvits_eval_bridge
   def initialize
      @s_scriptfile_extension="rb"
      @s_bridge_name="Ruby"
   end #initialize

   def create_console_command s_script_file_path
      #No ";" for corss-OS compatibility.
      cmd="ruby -Ku "+s_script_file_path+" "
      return cmd
   end # create_console_command

   def installed
      return true
   end #installed

end # class Kibuvits_eval_bridge_Ruby
#==========================================================================
class Kibuvits_eval
   def initialize
      @ht_bridges=Hash.new
      @ht_installed=Hash.new
   end #initialize

   # Returns a boolean value.
   def language_is_supported s_language
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), String, s_language
      end # if
      s_lang=s_language.downcase
      b_is_supported=true
      case s_lang
      when "php5"
         if !@ht_bridges.has_key?("php5")
            @ht_bridges["php5"]=Kibuvits_eval_bridge_PHP5.new
            @ht_installed[s_lang]=@ht_bridges[s_lang].installed
         end # if
      when "ruby"
         if !@ht_bridges.has_key?("ruby")
            @ht_bridges["ruby"]=Kibuvits_eval_bridge_Ruby.new
            @ht_installed[s_lang]=@ht_bridges[s_lang].installed
         end # if
      else
         b_is_supported=false
      end
      return b_is_supported
   end # language_is_supported


   def run s_script,s_language,msgcs
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_script
         kibuvits_typecheck bn, String, s_language
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      s_lang=s_language.downcase
      if !language_is_supported s_lang
         s_ostype=Kibuvits_os_codelets.instance.get_os_type
         msgcs.cre "The library does not yet support language \""+
         s_language+"\" on operationg system \""+s_ostype+"\".",1.to_s
         msgcs.last['Estonian']="Keel \""+s_language+"\" ei ole "+
         "veel teegi poolt operatsioonisüsteemil "+
         "nimega \""+s_ostype+"\" toetatud."
         ht_stdstreams=Kibuvits_io.creat_empty_ht_stdstreams
         return ht_stdstreams
      end # if
      return ht_stdstreams if msgcs.b_failure
      if !@ht_installed[s_lang]
         msgcs.cre "Language \""+s_language+"\" is supported by "+
         "the library, but it is not yet installed.",2.to_s
         msgcs.last['Estonian']="Keel \""+s_language+"\" on "+
         "küll teegi poolt toetatud, kuid seda ei ole veel "+
         "installeeritud."
         ht_stdstreams=Kibuvits_io.creat_empty_ht_stdstreams
         return ht_stdstreams
      end # if
      ht_stdstreams=@ht_bridges[s_lang].run s_script,msgcs
      return ht_stdstreams
   end # run

   def Kibuvits_eval.run s_script,s_language,msgcs
      ht_stdstreams=Kibuvits_eval.instance.run s_script,s_language,msgcs
      return ht_stdstreams
   end # Kibuvits_eval.run
   private

   def Kibuvits_eval.test_interpreter_ruby
      msgcs=Kibuvits_msgc_stack.new
      bridge=Kibuvits_eval_bridge_Ruby.new
      kibuvits_throw "test 1" if !bridge.installed
      s_script='puts "hi".reverse'
      ht_stdstreams=Kibuvits_eval.run(s_script,"Ruby",msgcs)
      kibuvits_throw "test 2" if msgcs.b_failure
      s_stdout=ht_stdstreams['s_stdout']
      kibuvits_throw "test 3 s_stdout=="+s_stdout if !s_stdout.include? "ih"
   end # Kibuvits_eval.test_interpreter_ruby

   def Kibuvits_eval.test_interpreter_php5
      msgcs=Kibuvits_msgc_stack.new
      bridge=Kibuvits_eval_bridge_PHP5.new
      return if !bridge.installed
      s_script="$xx='Hi'.'There'; echo $xx;"
      ht_stdstreams=Kibuvits_eval.run(s_script,"php5",msgcs)
      kibuvits_throw "test 1" if msgcs.b_failure
      s_stdout=ht_stdstreams['s_stdout']
      kibuvits_throw "test 2 s_stdout=="+s_stdout  if !s_stdout.include? "HiThere"
   end # Kibuvits_eval.test_interpreter_php5

   def Kibuvits_eval.test_language_independent
      msgcs=Kibuvits_msgc_stack.new
      s_script="whatever"
      ht_stdstreams=Kibuvits_eval.run(s_script,
      "lang_that_doesn't_exist",msgcs)
      kibuvits_throw "test 1,  msgcs.to_s=="+msgcs.to_s if !msgcs.b_failure
      kibuvits_throw "test 2" if msgcs.last.s_message_id!="1"
   end # Kibuvits_eval.test_language_independent

   public
   include Singleton
   def Kibuvits_eval.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(), "Kibuvits_eval.test_language_independent"
      kibuvits_testeval binding(), "Kibuvits_eval.test_interpreter_php5"
      kibuvits_testeval binding(), "Kibuvits_eval.test_interpreter_ruby"
      return ar_msgs
   end # Kibuvits_eval.selftest
end # class Kibuvits_eval

#==========================================================================


