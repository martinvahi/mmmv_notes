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

---------------------------------------------------------------------------
 This file is a script that runs all of the available selftests of the
 Kibuvits Ruby Library. The test results are presented on the console.

 There's no need to update this file duering the Kibuvits Ruby Library
 development, because it analyses the Ruby files, searches for
 class declarations within the files and searches for a static methods
 named selftest(). If it finds one, it'll execute it.

=end
#==========================================================================
require "pathname"
# The APPLICATION_STARTERRUBYFILE_PWD is not the
# same as the Dir.pwd. It's expaned in kibuvits_io.rb.
if !defined? APPLICATION_STARTERRUBYFILE_PWD
   APPLICATION_STARTERRUBYFILE_PWD=Pathname.new(__FILE__).realpath.parent.to_s
end # if

if !defined? KIBUVITS_HOME
   KIBUVITS_HOME=Pathname.new(__FILE__).realpath.parent.parent.parent.to_s
end # if

require 'monitor'
#require 'kibuvits_all.rb' # for testing the gem
require  KIBUVITS_HOME+'/src/include/kibuvits_all.rb' # for gem-free testing
require 'find'
#==========================================================================

class Kibuvits_selftests_executer
   # As I couldn't figure out, how to get variable values
   # from one binding to another, the current solution does
   # not encapsulate the testable Kibuvits Ruby Library files
   # into a separate binding. If any of the library files
   # should declare a class named Kibuvits_selftests_executer,
   # then this script will probably not work.

   def initialize
   end # initialize
   #private

   private
   def get_file_paths folder_path, s_regex, look_for="files"
      fl_p=folder_path
      kibuvits_typecheck binding(), String, folder_path
      kibuvits_typecheck binding(), String, s_regex
      kibuvits_throw "4be74a6c-2d15-4b9c-a022-2f1123b5e7e1" if !File.directory?(fl_p)
      pfn=Pathname.new(fl_p)
      fl_p=pfn.absolute_path if !pfn.absolute?
      ar_file_or_folder_paths=Array.new
      rgx=Regexp.new(s_regex)
      match_data=nil
      case look_for
      when "files"
         Find.find(fl_p) do |s_entry|
            if !File.directory?(s_entry)
               match_data=rgx.match(s_entry)
               if match_data!=nil
                  ar_file_or_folder_paths<<s_entry
               end # if
            end # if
         end # loop
      when "folders"
         Find.find(fl_p) do |s_entry|
            if File.directory?(s_entry)
               match_data=rgx.match(s_entry)
               if match_data!=nil
                  ar_file_or_folder_paths<<s_entry
               end # if
            end # if
         end # loop
      when "files_and_folders"
         Find.find(fl_p) do |s_entry|
            match_data=rgx.match(s_entry)
            if match_data!=nil
               ar_file_or_folder_paths<<s_entry
            end # if
         end # loop
      else
         kibuvits_throw "4be74a6c-1197-414a-b8d1-f013530abe24"
      end # case
      return ar_file_or_folder_paths
   end # get_file_paths

   def get_list_of_analyzable_rubyfiles
      #pthn=Pathname.new(__FILE__).realpath.parent.to_s
      pthn=Pathname.new(KIBUVITS_HOME).realpath
      #s_mypath=pthn.realpath.to_s
      ar_all_rubyfiles=get_file_paths(pthn.to_s,"[.]rb$")
      ar_all_analyzable_files=Array.new
      # The /examples/ is excluded mainly because the
      #example Ruby-scripts put stuff to console.
      a_regex1=Regexp.new(/[\/\\]examples[\/\\]/) # The \\ is for Windows
      a_regex2=Regexp.new(/[\/\\]dev_tools[\/\\](([^s].*)|(s[^e].*)|(se[^l].*)|(sel[^f].*)|(self[^t].*)|(selft[^e].*)|(selfte[^s].*)|(selftes[^t].*)|(selftest[^s].*)|(selftests[^\/\\].*))/)
      a_regex3=Regexp.new(/[\/\\]not_in_use_yet[\/\\]/)
      ar_all_rubyfiles.each do |a_rubyfile_path|
         next if a_regex1.match(a_rubyfile_path)!=nil
         next if a_regex2.match(a_rubyfile_path)!=nil
         next if a_regex3.match(a_rubyfile_path)!=nil
         ar_all_analyzable_files<<a_rubyfile_path
      end # loop
      return ar_all_analyzable_files
   end # get_list_of_analyzable_rubyfiles

   public
   def get_selftestequipped_classes
      ar_class_declaration_file_paths=get_list_of_analyzable_rubyfiles
      pfn=nil
      ar_classes=Array.new
      ar_class_declaration_file_paths.each do |file_path|
         kibuvits_typecheck binding(), String, file_path
         pfn=Pathname.new(file_path)
         kibuvits_throw "4be74a6c-901f-4acd-f284-fb658468de10" if !pfn.absolute?
         require file_path
      end # loop
      s_class_name=""
      a_regex=Regexp.new("^Kibuvits_.+")
      ObjectSpace.each_object do |an_object|
         next if an_object.class!=Class
         s_class_name=an_object.name
         next if a_regex.match(s_class_name)==nil
         ar_classes<<an_object if an_object.respond_to? :selftest
      end # loop
      return ar_classes
   end # get_selftestequipped_classes


   def execute_all_Kibuvits_selftests
      ar_classes=self.get_selftestequipped_classes
      cmd=""
      ar_msgs_all=Array.new
      ar_msgs=Array.new
      ar_classes.each do |a_class_instance|
         cmd="ar_msgs="+a_class_instance.name.to_s+".selftest"
         eval(cmd,binding())
         ar_msgs_all=ar_msgs_all+ar_msgs if  0<ar_msgs.length
      end # loop
      return ar_msgs_all
   end # execute_all_Kibuvits_selftests

end # class Kibuvits_selftests_executer

#==========================================================================
selftester=Kibuvits_selftests_executer.new

def kibuvits_selftestrunnerscript_display_selftests_failure_messages(
   ar_msgs, s_class_name=nil)
   if ar_msgs.length==0
      if s_class_name==nil
         puts "\nAll selftests passed.\n\n"
      else
         puts "\nClass "+s_class_name+" selftests passed.\n\n"
      end # if
   else
      puts "\nSelftest failure messages:\n\n"
      ar_msgs.each {|msg| puts msg.to_s}
      puts "\n"
   end # if
end # kibuvits_selftestrunnerscript_display_selftests_failure_messages

def kibuvits_selftestrunnerscript_run_class_selftest(s_class_name,selftester)
   kibuvits_typecheck binding(), String, s_class_name
   ar=selftester.get_selftestequipped_classes
   b_exec=false
   ar.each do |a_class|
      if a_class.to_s==s_class_name
         ar_msgs=a_class.selftest
         kibuvits_selftestrunnerscript_display_selftests_failure_messages(
         ar_msgs,s_class_name)
         b_exec=true
         break
      end # if
   end # loop
   return b_exec
end # kibuvits_selftestrunnerscript_run_class_selftest

def kibuvits_selftestrunnerscript_display_console_args
   puts "\nArgs: [-l|<class name>]\n\n"
end # kibuvits_selftestrunnerscript_display_console_args

def kibuvits_selftestrunnerscript_list_all_selftestable_classes selftester
   puts "\nKibuvits Ruby Library classes that are equipped with selftests:\n"
   ar=selftester.get_selftestequipped_classes
   ar.sort! { |a, b| a.name<=>b.name }
   ar.each {|x| puts '        '+x.name.to_s}
   puts "\n"
end # kibuvits_selftestrunnerscript_list_all_selftestable_classes

#--------------------------------------------------------------------------
if ARGV.length==0
   Dir.chdir(APPLICATION_STARTERRUBYFILE_PWD)
   ar_msgs=selftester.execute_all_Kibuvits_selftests
   kibuvits_selftestrunnerscript_display_selftests_failure_messages ar_msgs
else
   argv0=ARGV[0]
   case argv0
   when "-l"
      kibuvits_selftestrunnerscript_list_all_selftestable_classes selftester
   when "--list"
      kibuvits_selftestrunnerscript_list_all_selftestable_classes selftester
   when "--help"
      kibuvits_selftestrunnerscript_display_console_args
   when "-h"
      kibuvits_selftestrunnerscript_display_console_args
   else
      if !kibuvits_selftestrunnerscript_run_class_selftest argv0,selftester
         puts"\nClass "+argv0+" is either not found or it does "+
         "not have \na static method named selftest.\n"
         kibuvits_selftestrunnerscript_display_console_args
      end # if
   end # case
end # else

#==========================================================================
