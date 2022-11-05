#!/usr/bin/env ruby
#=========================================================================
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
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
require  KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"

# The "fileutils" gem/library MUST NOT BE USED, because
# it does not come precompiled with the Ruby distribution
# and its installation requires operating system specific
# compilation, which  prevents parts of the the KRL from running
# on Windows and JRuby. JRuby is necessary for using KRL
# form Java. The JRuby is used for running IDE addons/plugins
# and for using the KRL text processing routines for custom
# Java applications.

#==========================================================================

# The class Kibuvits_fs is a namespace for functions that
# deal with filesystem related activities, EXCEPT the IO, which
# is considered to be more general and depends on the filesystem.
class Kibuvits_fs
   @@cache=Hash.new
   def initialize
   end #initialize

   private

   def verify_access_create_flagset
      ht_out=Hash.new
      ht_out['exists']=false
      ht_out['does_not_exist']=false
      ht_out['is_directory']=false
      ht_out['is_file']=false
      ht_out['readable']=false
      ht_out['writable']=false
      ht_out['deletable']=false
      ht_out['executable']=false
      ht_out['not_readable']=false
      ht_out['not_writable']=false
      ht_out['not_deletable']=false
      ht_out['not_executable']=false
      return ht_out
   end # verify_access_create_flagset

   def verify_access_spec2ht s_checks_specification
      # It should not throw with command specifications of
      # ",,,writable", "writable,,readable",
      # "writable,readable,,,,", etc. On the other hand,
      # it must kibuvits_throw with a command specification of ",,,,,".
      s_1=s_checks_specification.gsub(/[\s]+/,$kibuvits_lc_emptystring)
      s_2=s_1.gsub(/[,]+/,$kibuvits_lc_comma).sub(/^[,]/,$kibuvits_lc_emptystring)
      s_1=s_2.sub(/[,]$/,$kibuvits_lc_emptystring)
      if s_1.length==0
         kibuvits_throw "\nThe Kibuvits_fs.verify_access did not "+
         " a valid checks specification. s_checks_specification=="+
         s_checks_specification+" \n"
      end # if

      ar=Kibuvits_str.ar_explode s_1, $kibuvits_lc_comma
      ar_cmds=[]
      ar.each{|s| ar_cmds<<Kibuvits_str.trim(s)}
      ht_out=verify_access_create_flagset
      ar_cmds.each do |s_cmd|
         if ht_out.has_key? s_cmd
            ht_out[s_cmd]=true
         else
            kibuvits_throw "The Kibuvits_fs.verify_access does not "+
            "have a command of \""+s_cmd+"\"."
         end # if
      end # loop
      if ht_out['exists']&&ht_out['does_not_exist']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"exists\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['is_directory']&&ht_out['is_file']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"is_directory\" and \"is_file\" contradict."
      end # if
      if ht_out['readable']&&ht_out['not_readable']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"readable\" and \"not_readable\" contradict."
      end # if
      if ht_out['writable']&&ht_out['not_writable']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"writable\" and \"not_writable\" contradict."
      end # if
      #----------------------------
      if ht_out['deletable']&&ht_out['not_deletable']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"deletable\" and \"not_deletable\" contradict."
      end # if
      if ht_out['deletable']&&ht_out['does_not_exist']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"deletable\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['deletable']&&ht_out['not_writable']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"deletable\" and \"not_writable\" contradict."
      end # if
      #----------------------------
      if ht_out['executable']&&ht_out['not_executable']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"executable\" and \"not_executable\" contradict."
      end # if
      #-----the-start-of-policy-based-conflict-checks--
      if ht_out['readable']&&ht_out['does_not_exist']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"readable\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['writable']&&ht_out['does_not_exist']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"writable\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['executable']&&ht_out['does_not_exist']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"executable\" and \"does_not_exist\" contradict."
      end # if
      #---------change-of-group--
      if ht_out['is_directory']&&ht_out['does_not_exist']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"is_directory\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['does_not_exist']&&ht_out['is_file']
         kibuvits_throw "Kibuvits_fs.verify_access commands "+
         "\"does_not_exist\" and \"is_file\" contradict."
      end # if
      return ht_out
   end # verify_access_spec2ht

   def verify_access_register_failure(ht_out,s_file_path_candidate,
      s_command, msgc)
      ht_desc=Hash.new
      ht_desc['command']=s_command
      ht_desc['msgc']=msgc
      ar_of_ht_descs=nil
      if ht_out.has_key? s_file_path_candidate
         ar_of_ht_descs=ht_out[s_file_path_candidate]
      else
         ar_of_ht_descs=Array.new
         ht_out[s_file_path_candidate]=ar_of_ht_descs
      end # if
      ar_of_ht_descs<<ht_desc
   end # verify_access_register_failure


   # Edits the ht_out.
   def verify_access_verification_step(s_file_path_candidate,
      ht_cmds, ht_out)
      b_is_directory=nil;
      s_en=nil;
      s_ee=nil;
      $kibuvits_lc_mx_streamaccess.synchronize do
         if File.exists?(s_file_path_candidate)
            b_is_directory=File.directory?(s_file_path_candidate)
            s_en="File "
            s_ee="Fail "
            if b_is_directory
               s_en="Folder "
               s_ee="Kataloog "
            end # if
         end # if
         ht_cmds.each_pair do |s_cmd,b_value|
            if b_value
               if s_cmd=="not_deletable"
                  # It's possible to delete only files that exist.
                  # If a file or folder does not exist, then it is
                  # not deletable.
                  if File.exists?(s_file_path_candidate)
                     if File.writable?(s_file_path_candidate)
                        s_parent=Pathname.new(s_file_path_candidate).parent.to_s
                        # The idea is that it is not possible to
                        # to delete the root folder.
                        if (s_parent!=s_file_path_candidate)
                           if File.writable?(s_parent)
                              msgc=Kibuvits_msgc.new
                              msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                              s_file_path_candidate+"\"\nis deletable,"
                              msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                              s_file_path_candidate+"\"\non kustutatav."
                              verify_access_register_failure(
                              ht_out, s_file_path_candidate, s_cmd, msgc)
                              return
                           end # if
                        end # if
                     end # if File.writable?
                  end # if File.exists?
               end # if s_cmd
            end # if b_value
         end # loop

         b_existence_forbidden=ht_cmds['does_not_exist']
         if b_existence_forbidden
            if File.exists?(s_file_path_candidate)
               b_is_directory=File.directory?(s_file_path_candidate)
               msgc=Kibuvits_msgc.new
               s_en="File "
               s_en="Directory " if b_is_directory
               msgc[$kibuvits_lc_English]=s_en+"with a path of\n\""+s_file_path_candidate+
               "\"\nis required to be missing, but it exists."
               s_ee="Fail "
               s_ee="Kataloog " if b_is_directory
               msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \""+s_file_path_candidate+
               "\" eksisteerib, kuid nõutud on tema puudumine."
               verify_access_register_failure(ht_out,
               s_file_path_candidate, 'does_not_exist', msgc)
            end # if
            return
         end # if

         # It's not possible to check for writability
         # of files that do not exist, etc.
         b_existence_required=ht_cmds['exists']
         b_existence_required=b_existence_required||(ht_cmds['is_directory'])
         b_existence_required=b_existence_required||(ht_cmds['is_file'])
         b_existence_required=b_existence_required||(ht_cmds['readable'])
         b_existence_required=b_existence_required||(ht_cmds['writable'])
         b_existence_required=b_existence_required||(ht_cmds['deletable'])
         b_existence_required=b_existence_required||(ht_cmds['executable'])
         if b_existence_required
            if !File.exists?(s_file_path_candidate)
               msgc=Kibuvits_msgc.new
               msgc[$kibuvits_lc_English]="File or folder with a path of\n\""+
               s_file_path_candidate+"\"\ndoes not exist."
               msgc[$kibuvits_lc_Estonian]="Faili ega kataloogi rajaga \""+
               s_file_path_candidate+"\" ei eksisteeri."
               verify_access_register_failure(ht_out,
               s_file_path_candidate, 'exists', msgc)
               return
            end # if
         end # if
         if File.exists?(s_file_path_candidate)
            ht_cmds.each_pair do |s_cmd,b_value|
               if b_value
                  case s_cmd
                  when "is_directory"
                     if !b_is_directory
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]="\""+s_file_path_candidate+
                        "\" is a file, but a folder is required."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \""+s_file_path_candidate+
                        "\" on fail, kuid nõutud on kataloog."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "is_file"
                     if b_is_directory
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]="\""+s_file_path_candidate+
                        "\" is a folder, but a file is required."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \""+s_file_path_candidate+
                        "\" on kataloog, kuid nõutud on fail."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "readable"
                     if !File.readable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not readable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole loetav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "not_readable"
                     if File.readable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis readable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\non loetav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "writable"
                     if !File.writable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not writable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "not_writable"
                     if File.writable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis writable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\non kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "deletable"
                     # It's possible to delete only files that exist.
                     if !File.writable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not deletable, because it is not writable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole kustutatav, sest see ei ole kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                     s_parent=Pathname.new(s_file_path_candidate).parent.to_s
                     if (s_parent!=s_file_path_candidate)
                        # It could be that the s_file_path_candidate equals with "/".
                        # The Pathname.new("/").parent.to_s=="/".
                        # The if-statement, that contains this comment,
                        # exists only to avoid a duplicate error message.
                        if !File.writable?(s_parent)
                           msgc=Kibuvits_msgc.new
                           msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                           s_file_path_candidate+"\"\nis not deletable, because its parent folder is not writable."
                           msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                           s_file_path_candidate+"\"\nei ole kustutatav, sest seda sisaldav kataloog ei ole kirjutatav."
                           verify_access_register_failure(
                           ht_out, s_file_path_candidate, s_cmd, msgc)
                        end # if
                     end # if
                  when "executable"
                     if !File.executable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not executable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole jookstav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "not_executable"
                     if File.executable?(s_file_path_candidate)
                        msgc=Kibuvits_msgc.new
                        msgc[$kibuvits_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis executable."
                        msgc[$kibuvits_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\non jookstav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  else
                  end # case
               end # if b_value
            end # loop
         end # if File.exists?(s_file_path_candidate)
      end # synchronize
   end # verify_access_verification_step


   public
   # The s_checks_specification is a commaseparated list of the following
   # flagstrings, but in a way that no conflicting flagstrings reside in
   # the list:
   #
   # exists, does_not_exist, is_directory, is_file,
   #     readable,     writable, executable,     deletable
   # not_readable, not_writable, not_executable
   #
   # An example of a conflicting set is "does_not_exist,writable", because
   # a non-existing file can not possibly be be writable. However,
   # a commandset of "exists,writable" is considered non-conflicting and
   # equivalent to a commandset of "writable", because a folder or a file
   # must exist to be writable.
   #
   # For the sake of helping the software developer to detect
   # logic mistakes, or just plain coding mistakes, a commandset
   # of "does_not_exist,not_readable" is considered to be conflicting, even
   # though it is not conflicting in the real world sense.
   #
   # The Kibuvits_fs.verify_access returns a hashtable. Schematic explanation
   # of the returnable hashtable:
   #
   # ht_filesystemtest_failures
   #   |
   #   +-1--n--    key: file path candidate
   #             value: ar
   #                    |
   #                    *--ht
   #                        |
   #                        +-key('command')-- <the Kibuvits_fs.verify_access check command>
   #                        +-key('msgc')-- <An instance of the Kibuvits_msgc with b_failure==true>
   #
   #
   # The keys of the hashtable are the file path
   # candidates, in which case at least one of the check commands
   # failed. The values of the hashtable are arrays of hashtables, where
   # ht['command']==<the Kibuvits_fs.verify_access check command>
   # ht['msgc']==<An instance of the Kibuvits_msgc>.
   # The b_failure flag of the msgc is set to true.
   #
   # If all verifications passed, the hashtable length==0.
   def verify_access(arry_of_file_paths_or_a_file_path_string,
      s_checks_specification,msgcs=Kibuvits_msgc_stack.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], arry_of_file_paths_or_a_file_path_string
         kibuvits_typecheck bn, String, s_checks_specification
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ar_path_candidates=arry_of_file_paths_or_a_file_path_string
      if ar_path_candidates.class==String
         x=ar_path_candidates.length
         kibuvits_throw("String paths can not be empty strings.")if x==0
         ar_path_candidates=[ar_path_candidates]
      else
         ar_path_candidates.each do |s_file_path_candidate|
            x=s_file_path_candidate.length
            kibuvits_throw("String paths can not be empty strings.")if x==0
         end # loop
      end # if
      ht_cmds=verify_access_spec2ht(s_checks_specification)
      ht_filesystemtest_failures=Hash.new
      ar_path_candidates.each do |s_file_path_candidate|
         verify_access_verification_step(s_file_path_candidate,
         ht_cmds, ht_filesystemtest_failures)
      end # loop
      #-----------------
      msgc=nil
      ht_filesystemtest_failures.each_pair do |s_fp_candidate, ar_one_ht_per_failed_command|
         ar_one_ht_per_failed_command.each do |ht_failed_command|
            msgc=ht_failed_command["msgc"]
            msgcs << msgc
         end # loop
      end # loop
      return ht_filesystemtest_failures
   end # verify_access

   def Kibuvits_fs.verify_access(arry_of_file_paths_or_a_file_path_string,
      s_checks_specification,msgcs=Kibuvits_msgc_stack.new)
      ht_filesystemtest_failures=Kibuvits_fs.instance.verify_access(
      arry_of_file_paths_or_a_file_path_string,s_checks_specification,msgcs)
      return ht_filesystemtest_failures
   end # Kibuvits_fs.verify_access

   #-----------------------------------------------------------------------

   # The format of the ht_failures matches with the output of the
   # Kibuvits_fs.test_verify_access.
   def access_verification_results_to_string(ht_failures,
      s_language=$kibuvits_lc_English)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_failures
         kibuvits_typecheck bn, String, s_language
      end # if
      s_out=""
      if ht_failures.length==0
         case s_language
         when $kibuvits_lc_Estonian
            s_out="\nFailisüsteemiga seonduvad testid läbiti edukalt.\n"
         else
            s_out="\nFilesystem related verifications passed.\n"
         end # case
         return s_out
      end # if
      case s_language
      when $kibuvits_lc_Estonian
         s_out="\nVähemalt osad failisüsteemiga seonduvatest "+
         "testidest põrusid.\n"
      else
         s_out="\nAt least some of the filesystem related tests failed. \n"
      end # case
      ht_failures.each_value do |ar_failures|
         ar_failures.each do |ht_failure|
            s_out=s_out+"\n"+(ht_failure['msgc'])[s_language]+"\n"
         end #loop
      end #loop
      return s_out
   end # access_verification_results_to_string

   def Kibuvits_fs.access_verification_results_to_string(ht_failures,
      s_language=$kibuvits_lc_English)
      s_out=Kibuvits_fs.instance.access_verification_results_to_string(
      ht_failures, s_language)
      return s_out
   end # Kibuvits_fs.access_verification_results_to_string

   #-----------------------------------------------------------------------

   def exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language=$kibuvits_lc_English,
      b_throw=false,s_optional_error_message_suffix=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_filesystemtest_failures
         kibuvits_typecheck bn, String, s_output_message_language
      end # if
      return if ht_filesystemtest_failures.length==0
      s_msg=Kibuvits_fs.access_verification_results_to_string(
      ht_filesystemtest_failures, s_output_message_language)
      s_msg=s_msg+$kibuvits_lc_linebreak
      if s_optional_error_message_suffix!=nil
         s_msg=s_msg+$kibuvits_lc_linebreak+
         s_optional_error_message_suffix+$kibuvits_lc_linebreak
      end # if
      if b_throw
         kibuvits_throw(s_msg)
      else
         kibuvits_writeln s_msg
         exit
      end # if
   end # exit_if_any_of_the_filesystem_tests_failed

   def Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures,s_output_message_language=$kibuvits_lc_English,
      b_throw=false,s_optional_error_message_suffix=nil)
      Kibuvits_fs.instance.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures, s_output_message_language,b_throw,
      s_optional_error_message_suffix)
   end # Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed

   #-----------------------------------------------------------------------

   # This method will probably go through heavy refactoring.
   # It's probably wise to place it to a separate file, because
   # it's seldom needed and will probably take up relatively huge amount
   # of memory due to all of the information that is added about
   # the different file formats.
   def file_extension_2_file_type s_file_extension
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_extension
      end # if
      s_key='file_extension_2_file_type_ht_of_relations'
      ht_relations=nil
      if @@cache.has_key? s_key
         ht_relations=@@cache[s_key]
      else
         ht_relations=Hash.new
         ht_relations['rb']='Ruby'
         ht_relations['js']='JavaScript'
         ht_relations['exe']='Windows Executable'
         ht_relations['out']='Linux Executable'
         ht_relations['txt']='Text'
         ht_relations['h']='C Header'
         ht_relations['hpp']='C++ Header'
         ht_relations['c']='C Nonheader'
         ht_relations['cpp']='C++ Nonheader'
         ht_relations['dll']='Windows DLL'
         ht_relations['so']='Linux Binary Library'
         ht_relations['conf']='Configuration file'
         ht_relations['am']='GNU Automake Source'
         ht_relations['py']='Python'
         ht_relations['java']='Java'
         ht_relations['class']='Java Virtual Machine'
         ht_relations['scala']='Scala'
         ht_relations['hs']='Haskell'
         ht_relations['htm']='HTML'
         ht_relations['html']='HTML'
         ht_relations['php']='PHP'
         ht_relations['bat']='Windows Batch'
         ht_relations['xml']='XML'
         ht_relations['json']='JSON'
         ht_relations['yaml']='YAML'
         ht_relations['hdf']='Hierarchical data Format'# http://www.hdfgroup.org/
         ht_relations['hdf5']='Hierarchical data Format 5'
         ht_relations['hdf4']='Hierarchical data Format 4'
         ht_relations['script']='Acapella' # From PerkinElmer's Estonian/German department.
         ht_relations['css']='Cascading Style Sheet'
         ht_relations['jpeg']='Joint Photographic Experts Group'
         ht_relations['jpg']='Joint Photographic Experts Group'
         ht_relations['png']='Portable Network Graphics'
         ht_relations['bmp']='Windows Bitmap'
         ht_relations['ico']='Windows Icon'
         ht_relations['svg']='Scalable Vector Graphics'
         ht_relations['xcf']='GIMP Image'
         ht_relations['tar']='Tape Archive'
         ht_relations['gz']='GNU zip'
         ht_relations['tgz']='GNU zip Compressed tape Archive'
         # TODO: continue the list with bzip2, zip, pdf, doc,odf, etc.
         # This whole thing probably has to be refactored for
         # type classification, like document formats, compression
         # formats, image formats, software sources, binaries, etc.
      end # if
      s_out=$kibuvits_lc_undetermined
      if ht_relations.has_key? s_file_extension.downcase
         s_out=ht_relations[s_file_extension]
      end # if
      return s_out
   end # file_extension_2_file_type

   #-----------------------------------------------------------------------

   # An empty array corresponds to a path to the root, i.e. "/".
   #
   # If the s_force_ostype==nil, then the operating system
   # type, i.e. file paths style, is determined by OS detection.
   # Some of the possible s_operating_system_type values are
   # held by the globals $kibuvits_lc_kibuvits_ostype_unixlike and
   # $kibuvits_lc_kibuvits_ostype_windows
   def path2array s_path,s_operating_system_type=nil
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), String, s_path
      end # if
      ar=nil
      s_ostype=s_operating_system_type
      s_ostype=Kibuvits_os_codelets.get_os_type if s_ostype==nil
      case s_ostype
      when $kibuvits_lc_kibuvits_ostype_unixlike
         ar=Kibuvits_str.ar_explode(s_path,$kibuvits_lc_slash)
      when $kibuvits_lc_kibuvits_ostype_windows
         ar=Kibuvits_str.ar_explode(s_path,$kibuvits_lc_backslash)
      else
         kibuvits_throw("Ostype \""+s_ostype+
         "\" is not yet supported by this method.")
      end # case s_ostype

      # The explosion has side effects: "/x/" is converted to
      # ["","x",""]. The loop below is for compensating them.
      ar_out=Array.new
      i_len=ar.length
      i_max=i_len-1
      i_len.times do |i|
         if i==0
            ar_out<<ar[i] if ar[i]!=""
            next
         end # if
         if i==i_max
            ar_out<<ar[i] if ar[i]!=""
            break # might as well be "next"
         end # if
         if ar[i].length==0
            kibuvits_throw "Empty strings can not be file or "+
            "folder names."
         end # if
         ar_out<<ar[i]
      end # loop
      return ar_out
   end # path2array

   def Kibuvits_fs.path2array(s_path,s_operating_system_type=nil)
      ar_out=Kibuvits_fs.instance.path2array(s_path,s_operating_system_type)
      return ar_out
   end # Kibuvits_fs.path2array

   #-----------------------------------------------------------------------

   def array2path ar
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), Array, ar
      end # if
      s_p=Kibuvits_str.array2xseparated_list(ar,$kibuvits_lc_slash)
      # ["xx",""]      --> "xx/"
      # ["xx","","yy"] --> "xx//yy"
      s_tmp=s_p+$kibuvits_lc_slash # creates a double-slash from "/xx/".
      i1=s_tmp.length
      i2=s_tmp.gsub(/[\/]+/,$kibuvits_lc_slash).length
      if i1!=i2
         kibuvits_throw "Array contained an empty string, which violates "+
         "the array-encoded path specification. ar==["+
         $kibuvits_lc_slash+Kibuvits_str.array2xseparated_list(ar,", ")+"]."
      end # if
      # Due to a Ruby quirk the next line works also, if s_p==""
      s_p=$kibuvits_lc_slash+s_p if s_p[0..0]!="."
      return s_p
   end # array2path

   def Kibuvits_fs.array2path ar
      s_p=Kibuvits_fs.instance.array2path(ar)
      return s_p
   end # Kibuvits_fs.array2path

   #-----------------------------------------------------------------------

   private

   # The rgx_slash is fed in for speed, because this func is in a loop.
   def array2folders_verify_folder_name_candidate_t1 s_folder_name0, rgx_slash
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), String, s_folder_name0
      end # if
      if Kibuvits_str.str_contains_spacestabslinebreaks(s_folder_name0)
         kibuvits_throw "Folder name, '"+s_folder_name0+
         "', contained a space or a tab."
      end # if
      s_folder_name1=s_folder_name0.gsub(rgx_slash,$kibuvits_lc_emptystring)
      if s_folder_name0.length!=s_folder_name1.length
         kibuvits_throw "Folder name, '"+s_folder_name0+
         "', contained a slash. For the sake of unambiguity "+
         "the slashes are not allowed."
      end # if
      if s_folder_name1.length==0
         # For some reason the error message is something other than the one here.
         kibuvits_throw "Folder name is not allowed to be an empty string, "+
         " nor is it allowed to consist of only spaces and tabs."
      end # if
   end # array2folders_verify_folder_name_candidate_t1

   public

   # If s_path2folder=='/home/xxx'
   # and ar_folder_names==["aa","bb"]
   # then this method will be equivalent to:
   # "mkdir /home/xxx/aa;"
   # "mkdir /home/xxx/aa/bb;"
   def array2folders_sequential(s_path2folder,ar_folder_names)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [String], s_path2folder
         kibuvits_typecheck bn, [Array], ar_folder_names
      end # if
      s_base_unix=s_path2folder
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(
      s_base_unix,"is_directory,writable")
      exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures)
      i_len=ar_folder_names.length
      s_folder_name0=nil
      s_folder_name1=nil
      s_left=s_base_unix.reverse.gsub(/^[\/]/,$kibuvits_lc_emptystring).reverse
      rgx_slash=/\//
      $kibuvits_lc_mx_streamaccess.synchronize do
         i_len.times do |i|
            s_folder_name0=ar_folder_names[i]
            array2folders_verify_folder_name_candidate_t1 s_folder_name0, rgx_slash
            s_left=s_left+$kibuvits_lc_slash+s_folder_name0
            s_folder_name1=s_left
            Dir.mkdir(s_folder_name1) if !File.exists? s_folder_name1
            ht_filesystemtest_failures=Kibuvits_fs.verify_access(
            s_folder_name1,"is_directory,writable")
            exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures)
         end # loop
      end # synchronize
   end # array2folders_sequential

   def Kibuvits_fs.array2folders_sequential(s_path2folder,ar)
      Kibuvits_fs.instance.array2folders_sequential(s_path2folder,ar)
   end # Kibuvits_fs.array2folders_sequential

   #-----------------------------------------------------------------------

   # Reads in the files as strings and concatenates
   # them in the order as the file paths appear in the
   # ar_file_paths
   def s_concat_files(ar_file_paths)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array], ar_file_paths
         ar_file_paths.each do |s_file_path|
            bn=binding()
            kibuvits_typecheck bn, String, s_file_path
            ht_filesystemtest_failures=Kibuvits_fs.verify_access(
            s_file_path,"is_file,readable")
            exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
            s_output_message_language=$kibuvits_lc_English,b_throw=false)
         end # loop
      end # if
      ar_s=Array.new
      ar_file_paths.each do |s_file_path|
         ar_s<<file2str(s_file_path)
      end # loop
      s_out=kibuvits_s_concat_array_of_strings(ar_s)
      return s_out
   end # s_concat_files

   def Kibuvits_fs.s_concat_files(ar_file_paths)
      s_out=Kibuvits_fs.instance.s_concat_files(ar_file_paths)
      return s_out
   end # Kibuvits_fs.s_concat_files

   #-----------------------------------------------------------------------

   #
   # The idea is that if the process rights owner
   # is the owner of the file, then the result will be
   # 0700, but if the file has been made writable to
   # the group of the file owner and the chmod-er is
   # not the owner but someone from the group of the
   # owner, then the access rights would be 0770 and
   # if everybody has been given the right to write to
   # the file or folder, then the access rights would
   # be 0777.
   #
   # The motive behind such a graceful access rights
   # modification is that, if a folder with a lot of private
   # data were to be deleted, then the delete operation
   # can take considerable amount of time.
   # In that case the temporary chmod(0777) might reveal the
   # private data to users that otherwise would be
   # banned from accessing it.
   #
   # However, if the file or folder has the access rights of 0777 or 0770,
   # and the process access rights are that of the file owner's,
   # then it will not chmod the access rights to the 0700.
   # The rationale is that if a file or folder
   # has been made  to everyone, then there's no
   # point of denying access to it.
   #
   def chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], ar_or_s_file_or_folder_path
      end # if
      ar_fp=Kibuvits_ix.normalize2array(ar_or_s_file_or_folder_path)
      $kibuvits_lc_mx_streamaccess.synchronize do
         ar_fp.each do |s_fp|
            if !File.exists? s_fp
               kibuvits_throw("The file or folder \n"+s_fp+
               "\ndoes not exist. GUID='c25ab87a-2c19-4749-912a-c16050e1ced7'\n")
            end # if
            if (File.writable? s_fp)&&(File.readable? s_fp)&&(File.executable? s_fp)
               if File.directory? s_fp
                  ar=Dir.glob(s_fp+$kibuvits_lc_slashstar)
                  chmod_recursive_secure_7(ar)
               end # if
               return
            end # if
            # If the owner of the current process is not the
            # owner of the file and the file had previously
            # a permission of 0770, then "chmod 0700 filename"
            # would lock the user out.
            File.chmod(0777,s_fp) # access  must contain 4 digits, or a flaw is introduced
            if (File.writable? s_fp)&&(File.readable? s_fp)&&(File.executable? s_fp)
               if File.directory? s_fp
                  ar=Dir.glob(s_fp+$kibuvits_lc_slashstar)
                  chmod_recursive_secure_7(ar)
               end # if
               return
            end # if
            s_1="The file "
            s_1="The folder " if File.directory? s_fp
            kibuvits_throw(s_1+",\n"+s_fp+
            "\nexists, but its access rights could not be changed to 7 for \n"+
            "the owner of the current process. GUID='53012470-9f01-441f-842a-c16050e1ced7'")
         end # loop
      end # synchronize
   end # chmod_recursive_secure_7

   def Kibuvits_fs.chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
      Kibuvits_fs.instance.chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
   end # Kibuvits_fs.chmod_recursive_secure_7

   #-----------------------------------------------------------------------

   private

   def impl_rm_fr_part_1(ar_or_s_file_or_folder_path)
      ar_paths_in=Kibuvits_ix.normalize2array(ar_or_s_file_or_folder_path)
      ar_paths_in.each do |s_fp|
         if File.directory? s_fp
            ar=Dir.glob(s_fp+$kibuvits_lc_slashstar)
            impl_rm_fr_part_1(ar)
            Dir.rmdir(s_fp)
         else
            File.delete(s_fp)
         end # if
         if File.exists? s_fp
            s_1="file\n"
            s_1="folder\n" if File.directory? s_fp
            kibuvits_throw("There exists some sort of a flaw, because the "+s_1+"\n"+s_fp+
            "\ncould not be deleted despite the fact that recursive chmod-ding \n"+
            "takes, or at least should take, place before the recursive deletion.\n"+
            "GUID='a7f0092f-d094-46f6-b42a-c16050e1ced7'\n")
         end # if
      end # loop
   end # impl_rm_fr_part_1

   public
   # The same as the classical
   # rm -fr folder_or_file_path
   #
   # If the root folder or file is not
   # deletable, it throws, but if the folder
   # is deletable, it will override the file
   # access permissions of the folder content.
   #
   # the root folder or file is considered not deletable,
   # if its parent folder is not writable.
   #
   # It does not throw, if the root folder or file
   # does not exist, regardless of  the parent
   # folder of the root folder or file exists or is writable.
   def rm_fr(ar_or_s_file_or_folder_path)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [String,Array], ar_or_s_file_or_folder_path
         if ar_or_s_file_or_folder_path.class==Array
            ar_or_s_file_or_folder_path.each do |x_path_candidate|
               bn=binding()
               kibuvits_typecheck bn, String,x_path_candidate
            end # loop
         end # if
      end # if
      ar_paths_in=Kibuvits_ix.normalize2array(ar_or_s_file_or_folder_path)
      ob_pth=nil
      s_parent_path=nil
      $kibuvits_lc_mx_streamaccess.synchronize do
         ar_paths_in.each do |s_file_or_folder_path|
            next if !File.exists? s_file_or_folder_path
            ob_pth=Pathname.new(s_file_or_folder_path)
            s_parent_path=ob_pth.dirname.to_s
            # Here the (File.exists? s_parent_path)==true
            # because every existing file or folder that
            # is not the "/"  has an existing parent
            # and the Pathname.new("/").to_s=="/"
            if !File.writable? s_parent_path
               kibuvits_throw("Folder \n"+s_parent_path+
               "\nis not writable. GUID='3b5b848f-96bc-46f6-b42a-c16050e1ced7'\n")
            end # if
            s_fp=s_file_or_folder_path
            chmod_recursive_secure_7(s_fp) # throws, if the chmod-ding fails
            impl_rm_fr_part_1(s_file_or_folder_path)
         end # loop
      end # synchronize
   end # rm_fr

   def Kibuvits_fs.rm_fr(ar_or_s_file_or_folder_path)
      Kibuvits_fs.instance.rm_fr(ar_or_s_file_or_folder_path)
   end # Kibuvits_fs.rm_fr

   #----------------------------------------------------------------------
   def b_not_suitable_to_be_a_file_path_t1(s_path_candidate,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String,s_path_candidate
         kibuvits_typecheck bn, Kibuvits_msgc_stack,msgcs
      end # if
      i_0=s_path_candidate.length
      s_1=s_path_candidate.gsub(/[\n\r]/,$kibuvits_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", but file paths are not allowed to contain line breaks.\n"
         s_message_id="1"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei saa sisaldada reavahetusi.\n"
         msgcs.last[$kibuvits_lc_Estonian]=s_default_msg
         return true
      end # if
      s_1=s_path_candidate.gsub(/^[\t\s]/,$kibuvits_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", but file paths are not allowed to start with spaces or tabs.\n"
         s_message_id="2"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei saa alata tühikute ning tabulatsioonimärkidega.\n"
         msgcs.last[$kibuvits_lc_Estonian]=s_default_msg
         return true
      end # if
      s_1=s_path_candidate.gsub(/[\t\s]$/,$kibuvits_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", but file paths are not allowed to end with spaces or tabs.\n"
         s_message_id="3"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei saa lõppeda tühikute ning tabulatsioonimärkidega.\n"
         msgcs.last[$kibuvits_lc_Estonian]=s_default_msg
         return true
      end # if
      # In Linux "//hi////there///" is equivalent to "/hi/there/ and hence legal.
      # The "/////////////////" is equivalent to "/" and hence also legal.
      s_1=s_path_candidate.gsub(/(^[.]{3})|([\/][.]{3})/,$kibuvits_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\",\n but file paths are not allowed to contain three "+
         "sequential dots at the \nstart of the path or right after a slash.\n"
         s_message_id="4"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei või sisaldada kolme järjestikust punkti .\n"+
         "failiraja alguses või vahetult pärast kaldkriipsu.\n"
         msgcs.last[$kibuvits_lc_Estonian]=s_default_msg
         return true
      end # if
      return false
   end # b_not_suitable_to_be_a_file_path_t1

   def Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1(s_path_candidate,msgcs)
      b_out=Kibuvits_fs.instance.b_not_suitable_to_be_a_file_path_t1(
      s_path_candidate,msgcs)
      return b_out
   end # Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1

   #----------------------------------------------------------------------

   # It only works with Linux paths and it does not check for
   # file/folder existence, i.e. its output is derived by
   # performing string operations.
   # def s_normalize_path_t1(s_path_candidate,msgcs)
   # if KIBUVITS_b_DEBUG
   # bn=binding()
   # kibuvits_typecheck bn, String,s_path_candidate
   # kibuvits_typecheck bn, Kibuvits_msgc_stack,msgcs
   # end # if
   # TODO: complete it
   # end # s_normalize_path_t1
   # def Kibuvits_fs.s_normalize_path_t1(s_path_candidate,msgcs)
   # end # Kibuvits_fs.s_normalize_path_t1

   #----------------------------------------------------------------------
   private

   def b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_of_strings,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array,ar_of_strings
         kibuvits_typecheck bn, Kibuvits_msgc_stack,msgcs
      end # if
      ar_of_strings.each do |x_candidate|
         if b_not_suitable_to_be_a_file_path_t1(x_candidate,msgcs)
            s_default_msg="\n\""+x_candidate.to_s+
            "\",\n is not considered to be suitable for a "+
            "file or folder base name. \n"+
            "GUID='10d4fe3f-f776-4a4d-a12a-c16050e1ced7'\n\n"
            #s_message_id="throw_1"
            #b_failure=false
            #msgcs.cre(s_default_msg,s_message_id,b_failure)
            #msgcs.last[$kibuvits_lc_Estonian]="\n"+x_candidate.to_s+
            #", omab väärtust, mis ei sobi faili nimeks.\n"
            kibuvits_throw(s_default_msg)
         end # if
         # Control flow will reach here only, if the
         # x_candidate.length!=0. Points are legal in file names
         # like "awesome.txt"
         #    i_0=x_candidate.length
         #    s_1=x_candidate.gsub(/[\\\/]/,$kibuvits_lc_emptystring)
         #    i_1=s_1.length
         #    if  i_0!=i_1
         #    s_default_msg="\n\""+x_candidate.to_s+
         #    "\",\n is not considered to be suitable for a "+
         #    "file or folder base name. \n"+
         #    "GUID='5dc73a94-a48f-458d-9d1a-c16050e1ced7'\n\n"
         #s_message_id="throw_1"
         #b_failure=false
         #msgcs.cre(s_default_msg,s_message_id,b_failure)
         #msgcs.last[$kibuvits_lc_Estonian]="\n"+x_candidate.to_s+
         #", omab väärtust, mis ei sobi faili nimeks.\n"
         #    kibuvits_throw(s_default_msg)
         #    end # if
      end # loop
   end # b_env_not_set_or_has_improper_path_t1_exc_verif1

   def b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
      s_environment_variable_name,s_env_value,s_path,msgcs)
      b_missing=false
      $kibuvits_lc_mx_streamaccess.synchronize do
         if !File.exists? s_path
            s_default_msg="\nThe environment variable, "+
            s_environment_variable_name+"==\""+s_env_value+
            "\",\n has a wrong value, because a file or a folder "+
            "with the path of \n"+s_path+"\n does not esist.\n"
            s_message_id="4"
            b_failure=false
            msgcs.cre(s_default_msg,s_message_id,b_failure)
            msgcs.last[$kibuvits_lc_Estonian]="\nKeskkonnamuutuja, "+
            s_environment_variable_name+"==\""+s_env_value+
            "\"\n, omab vale väärtust, sest faili ega kataloogi rajaga\n"+
            s_path+"\n ei eksisteeri.\n"
            b_missing=true
         end # if
      end # synchronize
      return b_missing
   end # b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist


   public

   # The  variable that is referenced by the
   # s_environment_variable_name is tested to have a value of a
   # full path to an existing folder or a file.
   #
   # If the environment variable references a file, then
   # the files and folders that are listed in the
   # s_or_ar_file_names  and the s_or_ar_folder_names
   # are searched from the same folder that contains the file.
   #
   # If the environment variable references a folder, then
   # the files and folders that are listed in the
   # s_or_ar_file_names  and the s_or_ar_folder_names
   # are searched from the folder that is referenced by the
   # environment variable.
   #
   # If the s_or_ar_file_names and/or the s_or_ar_folder_names differ
   # from an empty array, then they are expected to depict either basenames or
   # relative paths relative to the folder that is searched.
   #
   # If "true" is returned, then a Kibuvits_msgc instance is added to
   # the msgcs. The Kibuvits_msgc instance has its b_failure value set to "false".
   def b_env_not_set_or_has_improper_path_t1(s_environment_variable_name,
      msgcs=Kibuvits_msgc_stack.new,
      s_or_ar_file_names=$kibuvits_lc_emptyarray,
      s_or_ar_folder_names=$kibuvits_lc_emptyarray)
      bn=binding() # Is in use also outside of the DEBUG block.
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck bn, String,s_environment_variable_name
         kibuvits_typecheck bn, [Array,String],s_or_ar_file_names
         kibuvits_typecheck bn, [Array,String],s_or_ar_folder_names
         kibuvits_typecheck bn, Kibuvits_msgc_stack,msgcs
         if s_or_ar_file_names.class==Array
            ar=s_or_ar_file_names
            ar.each do |x_candidate|
               bn_1=binding()
               kibuvits_typecheck bn_1, String,x_candidate
            end # loop
         end # if
         if s_or_ar_folder_names.class==Array
            ar=s_or_ar_folder_names
            ar.each do |x_candidate|
               bn_1=binding()
               kibuvits_typecheck bn_1, String,x_candidate
            end # loop
         end # if
      end # if KIBUVITS_b_DEBUG
      s_or_ar_file_names=[] if s_or_ar_file_names.class==NilClass
      s_or_ar_folder_names=[] if s_or_ar_file_names.class==NilClass
      ar_file_names=Kibuvits_ix.normalize2array(s_or_ar_file_names)
      ar_folder_names=Kibuvits_ix.normalize2array(s_or_ar_folder_names)

      kibuvits_assert_ok_to_be_a_varname_t1(bn,s_environment_variable_name)
      x_env_value=ENV[s_environment_variable_name]
      if (x_env_value==nil)||(x_env_value==$kibuvits_lc_emptystring)
         s_default_msg="\nThe environment variable, "+s_environment_variable_name+
         ", does not exist or it has an empty string as its value.\n"
         s_message_id="1"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         msgcs.last[$kibuvits_lc_Estonian]="\nKeskkonnamuutuja, "+s_environment_variable_name+
         ", ei eksisteeri või talle on omistatud väärtuseks tühi sõne.\n"
         return true
      end # if
      if b_not_suitable_to_be_a_file_path_t1(x_env_value,msgcs)
         s_default_msg="\nThe environment variable, "+s_environment_variable_name+
         ", does not have a value that \nis considered to be "+
         "suitable to be a file path.\n"
         s_message_id="2"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         msgcs.last[$kibuvits_lc_Estonian]="\nKeskkonnamuutuja, "+s_environment_variable_name+
         ", omab väärtust, mis ei sobi faili rajaks.\n"
         return true
      end # if
      b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_file_names,msgcs)
      b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_folder_names,msgcs)
      s_env_value=x_env_value
      $kibuvits_lc_mx_streamaccess.synchronize do
         if !File.exists? s_env_value
            s_default_msg="\nThe file or folder that the environment variable, "+
            s_environment_variable_name+", references does not exist.\n"
            s_message_id="3"
            b_failure=false
            msgcs.cre(s_default_msg,s_message_id,b_failure)
            msgcs.last[$kibuvits_lc_Estonian]="\nKeskkonnamuutuja, "+s_environment_variable_name+
            ", poolt viidatud fail või kataloog ei eksisteeri.\n"
            return true
         end # if
         rgx_multislash=/[\/]+/
         s_folder_path_1=s_env_value.gsub(rgx_multislash,$kibuvits_lc_slash)
         if s_folder_path_1!=$kibuvits_lc_slash
            if File.file?(s_env_value)
               ob_fp=Pathname.new(s_env_value).realpath.parent
               s_folder_path_1=ob_fp.to_s
            end # if
         end # if
         s_folder_path_1=(s_folder_path_1+"/").gsub(rgx_multislash,$kibuvits_lc_slash)
         s_path=nil
         b_0=nil
         ar_file_names.each do |s_basename|
            # TODO:  filter the s_path through Kibuvits_fs.s_normalize_path_t1
            s_path=s_folder_path_1+s_basename
            b_0=b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
            s_environment_variable_name,s_env_value,s_path,msgcs)
            return true if b_0
            if !File.file? s_path
               s_default_msg="\nThe environment variable, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\",\n is suspected to have a wrong value, because "+
               "a file with the path of \n"+s_path+
               "\n does not esist, but a folder with the same path does exist.\n"
               s_message_id="5"
               b_failure=false
               msgcs.cre(s_default_msg,s_message_id,b_failure)
               msgcs.last[$kibuvits_lc_Estonian]="\nKeskkonnamuutuja, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\"\n, korral kahtlustatakse vale väärtust, sest faili rajaga\n"+
               s_path+"\n ei eksisteeri, kuid sama rajaga kataloog eksisteerib.\n"
               return true
            end # if
         end # loop
         ar_folder_names.each do |s_basename|
            s_path=s_folder_path_1+s_basename
            # TODO:  filter the s_path through Kibuvits_fs.s_normalize_path_t1
            b_0=b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
            s_environment_variable_name,s_env_value,s_path,msgcs)
            return true if b_0
            if File.file? s_path
               s_default_msg="\nThe environment variable, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\",\n is suspected to have a wrong value, because "+
               "a folder with the path of \n"+s_path+
               "\n does not esist, but a file with the same path does exist.\n"
               s_message_id="6"
               b_failure=false
               msgcs.cre(s_default_msg,s_message_id,b_failure)
               msgcs.last[$kibuvits_lc_Estonian]="\nKeskkonnamuutuja, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\"\n, korral kahtlustatakse vale väärtust, sest kataloogi rajaga\n"+
               s_path+"\n ei eksisteeri, kuid sama rajaga fail eksisteerib.\n"
               return true
            end # if
         end # loop
      end # synchronize
      return false
   end # b_env_not_set_or_has_improper_path_t1

   def Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name, msgcs=Kibuvits_msgc_stack.new,
      s_or_ar_file_names=$kibuvits_lc_emptyarray,
      s_or_ar_folder_names=$kibuvits_lc_emptyarray)
      b_out=Kibuvits_fs.instance.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,s_or_ar_file_names,s_or_ar_folder_names )
      return b_out
   end # Kibuvits_fs.b_env_not_set_or_has_improper_path_t1

   #----------------------------------------------------------------------

   private

   def exc_ar_glob_x_verifications_t1(bn,
      ar_or_s_fp_directory,ar_or_s_glob_string,b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      kibuvits_typecheck bn, [String,Array], ar_or_s_fp_directory
      kibuvits_typecheck bn, [String,Array], ar_or_s_glob_string
      kibuvits_typecheck bn, [TrueClass,FalseClass], b_return_long_paths
      kibuvits_typecheck bn, [String,Array,Proc], ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
      kibuvits_typecheck bn, [TrueClass,FalseClass], b_return_globbing_results

      if ar_or_s_fp_directory.class==Array
         ar_or_s_fp_directory.each do |s_fp_folder|
            kibuvits_assert_string_min_length(bn,s_fp_folder,1)
         end # loop
      else
         kibuvits_assert_string_min_length(bn,ar_or_s_fp_directory,1)
      end # if

      if ar_or_s_glob_string.class==Array
         ar_or_s_glob_string.each do |s_globstring|
            kibuvits_assert_string_min_length(bn,s_globstring,1)
         end # loop
      else
         kibuvits_assert_string_min_length(bn,ar_or_s_glob_string,1)
      end # if

      cl_0=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class
      if cl_0==Array
         ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.each do |s_fp_folder|
            kibuvits_assert_string_min_length(bn,s_fp_folder,1)
         end # loop
      else
         if cl_0==String
            kibuvits_assert_string_min_length(bn,
            ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,1)
         else
            if cl_0==Proc
               func_0=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
               ar_params=func_0.parameters
               i_ar_params_len=ar_params.size
               if i_ar_params_len!=1
                  kibuvits_throw("The "+
                  "ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function \n"+
                  "is of class "+cl_0.to_s+
                  "and the number of its parameters == "+i_ar_params_len.to_s+", but \n"+
                  "it is required to have exactly 1 parameter that is "+
                  "of type String and depicts a full path of a file or a folder.\n"+
                  "GUID='31159617-ae50-47ee-821a-c16050e1ced7'\n")
               end # if
               ar_paramdesc=ar_params[0]
               if ar_paramdesc[0]!=:req
                  kibuvits_throw("The first parameter of the function that "+
                  "is referenced by the \n"+
                  "ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function \n"+
                  "is expected to be parameter that does not have a default value.\n"+
                  "GUID='a2b83425-1586-44f3-841a-c16050e1ced7'\n")
               end # if
            else
               kibuvits_throw("The code of this function is faulty. \n"+
               "The previous typechecks "+
               "should have thrown before the control flow reaches this line.\n"+
               "ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class == "+
               cl_0.to_s+$kibuvits_lc_linebreak+
               "GUID='dc220e3c-ebad-4a4c-821a-c16050e1ced7'\n")
            end # if
         end # if
      end # if
   end # exc_ar_glob_x_verifications_t1

   public

   # Folder paths have to be full paths.
   # Throws, if the folder does not exist or is not readable.
   #
   # It temporarily changes the working directory to the s_fp_directory.
   #
   # If the
   #
   #     ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
   #
   # is a function, e.g. of class Proc, then it must accept exactly one
   # parameter that is a full path of a file or a folder.
   # The function must return false, except if the file or folder
   # is expected to be excluded from the output of the
   # ar_glob_locally_t1. In pseudocode:
   #
   #     b_ignore_file_or_folder=func_return_true_if_ignored.call(s_fp)
   #
   # The "b_ignore_file_or_folder" must be either of class TrueType or
   # class FalseType.
   #
   # The path that is fed to the "func_return_true_if_ignored" might
   # point to a nonexistent file or folder. It's up to the
   # implementer of the "func_return_true_if_ignored" to decide,
   # whether it modifies or deletes an existing file or folder
   # or creates a new instance of a nonexistent file or folder.
   # The "func_return_true_if_ignored" might receive the
   # same file or folder path more than once during a
   # single call to the ar_glob_locally_t1.
   #
   # Paths that point to a nonexistent file or folder right
   # after a call to the "func_return_true_if_ignored"
   # are omitted from the output of the ar_glob_locally_t1.
   # Root folders, the the content of the ar_or_s_fp_directory,
   # are not added to the output regardless of the
   # value of the "func_return_true_if_ignored".
   #
   # If the "func_return_true_if_ignored" returns "false" on a folder,
   # then that folder is not descended into. The
   # "func_return_true_if_ignored" might be used for carrying out
   # application specific operations with the paths that the
   # "func_return_true_if_ignored" got called with.
   #
   # The
   #
   #     b_return_globbing_results
   #
   # makes it possible to iterate over the elements that are
   # selected by the ar_or_s_glob_string without allocating
   # memory for returning a list of the file/folder paths.
   def ar_glob_locally_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      #-----------------
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_ar_glob_x_verifications_t1(bn,ar_or_s_fp_directory,
         ar_or_s_glob_string,b_return_long_paths,
         ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
         b_return_globbing_results)
         #--------------------
         ar_globstrings=Kibuvits_ix.normalize2array(ar_or_s_glob_string)
         rgx_0=/^ +/
         rgx_1=/^[\/][*]?/
         rgx_2=/^[\s\t\n\r]+/
         s_0=nil
         s_1=nil
         i_len_0=nil
         i_len_1=nil
         ar_globstrings.each do |s_globstring|
            s_0=s_globstring.gsub(rgx_0,$kibuvits_lc_emptystring)
            i_len_0=s_0.length
            if s_globstring.gsub(rgx_2,$kibuvits_lc_emptystring).length==0
               kibuvits_throw("There's a flaw.\n"+
               "s_globstring consists of only spaces or tabs or line breaks.\n"+
               "GUID='4498bb17-8d19-4793-951a-c16050e1ced7'\n")
            end # if
            s_1=s_0.gsub(rgx_1,$kibuvits_lc_emptystring)
            i_len_1=s_1.length
            if i_len_1!=i_len_0
               kibuvits_throw("There's a flaw.\n"+
               " s_globstring==\""+s_globstring+"\", but if it \n"+
               "is fed to the Dir.glob(...), then it globs the root folder. \n"+
               "GUID='11119157-a4a1-43cd-a20a-c16050e1ced7'\n")
            end # if
         end # loop
      end # if
      #----------------
      ar_fp_folder=Kibuvits_ix.normalize2array(ar_or_s_fp_directory)
      ar_globstrings=Kibuvits_ix.normalize2array(ar_or_s_glob_string)
      #----------------
      func_b_ignore=nil
      ar_fp_ignorables=nil
      b_ignore_by_func=false
      b_ignore_by_func=true if ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class==Proc
      if b_ignore_by_func
         func_b_ignore=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
      else
         ar_fp_ignorables=Kibuvits_ix.normalize2array(
         ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function)
      end # if
      #----------------
      ht_test_failures=verify_access(ar_fp_folder,"readable,is_directory")
      s_output_message_language=$kibuvits_lc_English
      b_throw=true
      exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw)
      #----------------
      ar_out=Array.new
      s_fp_wd_orig=Dir.getwd
      begin
         ar_1=nil
         ar_2=Array.new
         s_fp_0=$kibuvits_lc_emptystring
         s_fp_1=$kibuvits_lc_emptystring
         rgx_slashplus=/[\/]+/ # can't cache due to threading
         b_ignore_file_or_folder=nil
         ar_speedhack_1=[]
         ar_fp_folder.each do |s_fp_folder|
            if b_ignore_by_func
               # This call to the func_b_ignore(...) might delete the
               # s_fp_folder or change its content regardless of
               # whether the s_fp_folder points to a file or a folder.
               b_ignore_file_or_folder=func_b_ignore.call(s_fp_folder)
               next if !File.exist? s_fp_folder
            else
               b_ignore_file_or_folder=Kibuvits_str.b_has_prefix(
               ar_fp_ignorables, s_fp_folder, ar_speedhack_1)
            end # if
            next if b_ignore_file_or_folder
            #-------
            s_fp_0=s_fp_folder+$kibuvits_lc_slash
            Dir.chdir(s_fp_wd_orig) # should there be some mess with relative paths
            Dir.chdir(s_fp_folder)  # at this line
            # A glob string can be "/*", which might
            # be interpreted as the root folder.
            ar_globstrings.each do |s_globstring|
               ar_1=Dir.glob(s_globstring)
               # Separate loops are used to
               # place some if-clauses outside of a loop.
               if b_return_long_paths
                  if b_ignore_by_func
                     ar_1.each do |s_fname|
                        s_fp_1=(s_fp_0+s_fname).gsub(rgx_slashplus,$kibuvits_lc_slash)
                        # This call to the func_b_ignore(...) might delete the
                        # s_fname or change its content regardless of
                        # whether the s_fname points to a file or a folder.
                        b_ignore_file_or_folder=func_b_ignore.call(s_fp_1)
                        next if !File.exist? s_fname
                        next if b_ignore_file_or_folder
                        ar_2<<s_fp_1 if b_return_globbing_results
                     end # loop
                  else # ignore by array
                     ar_1.each do |s_fname|
                        s_fp_1=(s_fp_0+s_fname).gsub(rgx_slashplus,$kibuvits_lc_slash)
                        b_ignore_file_or_folder=Kibuvits_str.b_has_prefix(
                        ar_fp_ignorables, s_fp_1, ar_speedhack_1)
                        next if b_ignore_file_or_folder
                        ar_2<<s_fp_1 if b_return_globbing_results
                     end # loop
                  end # if
               else # relative paths
                  if b_ignore_by_func
                     ar_1.each do |s_fname|
                        s_fp_1=(s_fp_0+s_fname).gsub(rgx_slashplus,$kibuvits_lc_slash)
                        # This call to the func_b_ignore(...) might delete the
                        # s_fname or change its content regardless of
                        # whether the s_fname points to a file or a folder.
                        b_ignore_file_or_folder=func_b_ignore.call(s_fp_1)
                        next if !File.exist? s_fname
                        next if b_ignore_file_or_folder
                        ar_2<<s_fname if b_return_globbing_results
                     end # loop
                  else # ignore by array
                     ar_1.each do |s_fname|
                        b_ignore_file_or_folder=Kibuvits_str.b_has_prefix(
                        ar_fp_ignorables, s_fname, ar_speedhack_1)
                        next if b_ignore_file_or_folder
                        ar_2<<s_fname if b_return_globbing_results
                     end # loop
                  end # if
               end # if
               ar_out.concat(ar_2)
               ar_2.clear
            end # loop
         end # loop
         Dir.chdir(s_fp_wd_orig)
      rescue Exception => e
         # The idea is that may be the
         # client code catches the exception
         # and does something stupid that
         # is harmless only, if the working
         # directory has not been altered.
         Dir.chdir(s_fp_wd_orig)
         kibuvits_throw(e)
      end # rescue
      return ar_out
   end # ar_glob_locally_t1


   def Kibuvits_fs.ar_glob_locally_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      ar_out=Kibuvits_fs.instance.ar_glob_locally_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      return ar_out
   end # Kibuvits_fs.ar_glob_locally_t1

   #----------------------------------------------------------------------

   private

   def exc_ar_glob_recursively_t1_input_verification(bn,
      ar_or_s_fp_directory,ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
      b_return_long_paths, ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      #-------------
      exc_ar_glob_x_verifications_t1(bn,ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      #----
      # The filter-regex is not verified within the
      # exc_ar_glob_x_verifications_t1, because
      # it is specific to the recursive version of
      # the glob function. If the ar_glob_locally_t1(...)
      # receives a single root folder for globbing, it
      # allocates space for everything anyways and the
      # filter parameter is not added to the
      # ar_glob_locally_t1(...) to keep the ar_glob_locally_t1(...)
      # API simpler. It's an intentional tradeoff, where
      # simplicity is preferred to the special-case speed increase.
      kibuvits_typecheck bn, [Regexp,Array,Proc],regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output
      cl=regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output.class
      if cl==Array
         kibuvits_assert_ar_elements_typecheck_if_is_array(bn,Proc,
         regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
         "GUID='4d550af3-1ddb-4f65-850a-c16050e1ced7'")
      else
         if cl==Proc
            x_0=regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output.call(
            $kibuvits_lc_linebreak)
            bn_1=binding()
            kibuvits_typecheck bn_1, [TrueClass,FalseClass],x_0
         end # if
      end # if
      s_output_message_language=$kibuvits_lc_English
      b_throw=true
      s_optional_error_message_suffix="GUID='b2cce144-3f17-49c0-940a-c16050e1ced7'"
      ht_test_failures=verify_access(ar_or_s_fp_directory,"readable,is_directory")
      exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw,s_optional_error_message_suffix)
   end # exc_ar_glob_recursively_t1_input_verification

   def ar_glob_recursively_t1_impl(ar_or_s_fp_directory,
      ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output=/.+/,
      b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      #--------------------
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_ar_glob_recursively_t1_input_verification(bn,
         ar_or_s_fp_directory,ar_or_s_glob_string,
         regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
         b_return_long_paths, ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
         b_return_globbing_results)
      end # if
      #--------------------
      ar_fp_folder=Kibuvits_ix.normalize2array(ar_or_s_fp_directory)
      ar_globstrings=Kibuvits_ix.normalize2array(ar_or_s_glob_string)
      #----
      x_output_filter=regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output
      ar_output_filter_rgxs=nil
      func_output_filter=nil
      cl_x_output_filter=x_output_filter.class
      if cl_x_output_filter==Proc
         func_output_filter=x_output_filter
      else
         ar_output_filter_rgxs=Kibuvits_ix.normalize2array(x_output_filter)
      end # if
      #--------------------
      ar_folders_to_glob=Array.new
      ar_out=Array.new
      ar_fp_1=nil
      ar_fp_2=nil
      ar_fp_3=nil
      #--------------------
      func_b_ignore=nil
      ar_fp_ignorables=nil
      b_ignore_by_func=false
      if ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class==Proc
         b_ignore_by_func=true
         func_b_ignore=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
      else
         ar_fp_ignorables=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
      end # if
      #--------------------
      ar_speedhack_1=[]
      s_lc_globstring_all=$kibuvits_lc_star
      $kibuvits_lc_mx_streamaccess.synchronize do
         b_ignore_file_or_folder=nil
         ar_fp_folder.each do |s_fp_folder|
            if b_ignore_by_func
               # This call to the func_b_ignore(...) might delete the
               # s_fp_folder or change its content regardless of
               # whether the s_fp_folder points to a file or a folder.
               b_ignore_file_or_folder=func_b_ignore.call(s_fp_folder)
               next if !File.exist? s_fp_folder
            else
               b_ignore_file_or_folder=Kibuvits_str.b_has_prefix(
               ar_fp_ignorables, s_fp_folder, ar_speedhack_1)
            end # if
            next if b_ignore_file_or_folder
            #---------------
            ar_fp_1=ar_glob_locally_t1(s_fp_folder,ar_globstrings,b_return_long_paths,
            ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
            b_return_globbing_results)
            ar_out.concat(ar_fp_1) if b_return_globbing_results
            #-----
            b_return_long_paths_for_recursion=true
            ar_fp_recursion=ar_glob_locally_t1(s_fp_folder,ar_globstrings,
            b_return_long_paths_for_recursion,
            ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
            true) # ==true, because the ar_fp_1 is needed later for recursive globbing
            #-----
            md_0=nil
            #-----
            # There does exist the possibility that the ar_globstrings might
            # exclude all folders from the ar_fp_1, but that's OK by the spec.
            ar_fp_recursion.each do |s_fp|
               # POOLELI
               if File.directory? s_fp
                  ar_folders_to_glob, ar_fp_3=ar_glob_recursively_t1_impl(s_fp,
                  ar_globstrings,x_output_filter,b_return_long_paths,
                  ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
                  true) # otherwise the "false" will go down with recursion and break the recursion
                  if b_return_globbing_results
                     if func_output_filter!=nil
                        ar_fp_3.each do |s_fp_1a|
                           ar_out<<s_fp_1a if func_output_filter.call(s_fp_1a)
                        end # loop
                     else
                        ar_output_filter_rgxs.each do |rgx_output_filter|
                           ar_fp_3.each do |s_fp_1a|
                              md_0=s_fp_1a.match(rgx_output_filter)
                              ar_out<<s_fp_1a if md_0!=nil
                           end # loop
                        end # loop
                     end # if
                  end # if
               end # if
            end # loop
         end # loop
      end # synchronize
      return ar_folders_to_glob, ar_out
   end # ar_glob_recursively_t1_impl

   public

   # Folder paths have to be full paths.
   # Throws, if the folder does not exist or could not be found.
   #
   # It temporarily changes the working directory to the s_fp_directory.
   #
   # The use of the
   #
   #     b_return_globbing_results and the
   #     ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
   #
   # are documented next to the
   #
   #     ar_glob_locally_t1(...)
   #
   # Often the output of this function must be passed through a
   # second filter, which might be
   #
   #     Kibuvits_ix.x_filter_t1(ar_or_ht_in,func_returns_true_if_element_is_part_of_output)
   #
   # For example a glob string "*.txt" will not
   # descend to folders that do not have ".txt" as their name suffix.
   # To search for text files recursively, the first operation is to get
   # a recursive list of all files/folders, for example, by using
   # "*" as the globstring, and then the second filter must be
   # applied to the list of paths.
   #
   def ar_glob_recursively_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output=/.+/,
      b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      #--------------------
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_ar_glob_recursively_t1_input_verification(bn,
         ar_or_s_fp_directory,ar_or_s_glob_string,
         regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
         b_return_long_paths, ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
         b_return_globbing_results)
      end # if
      #--------------------
      ar_folders_to_glob, ar_out=ar_glob_recursively_t1_impl(ar_or_s_fp_directory,
      ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
      b_return_long_paths,ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      #--------------------
      return ar_out
   end # ar_glob_recursively_t1

   def Kibuvits_fs.ar_glob_recursively_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output=/.+/,
      b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      ar_out=Kibuvits_fs.instance.ar_glob_recursively_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
      b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      return ar_out
   end # Kibuvits_fs.ar_glob_recursively_t1

   #----------------------------------------------------------------------

   # Searches all folders listed in the ar_or_s_fp_directory.
   # Only the file paths that have a match with at least one of the
   # regexes are included at the output.
   def ar_glob_recursively_t2(ar_or_s_fp_directory,ar_or_rgx_file_path_regexes)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String],ar_or_s_fp_directory
         kibuvits_typecheck bn, [Array,Regexp],ar_or_rgx_file_path_regexes
         kibuvits_assert_ar_elements_typecheck_if_is_array(bn,Regexp,
         ar_or_s_fp_directory,
         "GUID='5c157734-6ba2-49f1-b40a-c16050e1ced7'\n")
         if ar_or_s_fp_directory.class==Array
            ar_fp_root_folder_candidates=ar_or_s_fp_directory
            ht_failures=verify_access(ar_fp_root_folder_candidates,"is_directory,readable")
            #----
            s_output_message_language=$kibuvits_lc_English,
            b_throw=true,
            exit_if_any_of_the_filesystem_tests_failed(
            ht_failures,s_output_message_language,b_throw,
            "GUID='a414de75-92a8-422c-890a-c16050e1ced7'\n")
         end # if
      end # if
      ar_fp_root_folders=Kibuvits_ix.normalize2array(ar_or_s_fp_directory)
      ar_rgx=Kibuvits_ix.normalize2array(ar_or_rgx_file_path_regexes)


      func_keep_in_output=lambda do |x_key,x_value|
      end # func_keep_in_output

      Kibuvits_ix.x_filter_t1(ar_or_ht_in,func_returns_true_if_element_is_part_of_output)
      raise(Exception.new("Pooleli, "+
      "GUID='5ce3af28-b53f-44d6-b1f9-c16050e1ced7'\n"))
   end # ar_glob_recursively_t2

   def Kibuvits_fs.ar_glob_recursively_t2(ar_or_s_fp_directory,ar_or_rgx_file_path_regexes)
      ar_out=Kibuvits_fs.instance.ar_glob_recursively_t2(
      ar_or_s_fp_directory,ar_or_rgx_file_path_regexes)
      return ar_out
   end # Kibuvits_fs.ar_glob_recursively_t2

   #----------------------------------------------------------------------

   # Returns a hashtable, where
   # keys are absolute paths of the symbolic links and
   # values are full paths of files that the symbolic links reference.
   #
   # This method does not introduce any changes to disk,
   # but relative paths of the targets of the symbolic links are
   # stored to the output hashtable as full paths.
   def ht_find_nonbroken_symlinks_recursively_t1(ar_or_s_fp_directory)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String],ar_or_s_fp_directory
      end # if
      ht_test_failures=Kibuvits_fs.verify_access(
      ar_or_s_fp_directory,"readable,is_directory")
      s_output_message_language=$kibuvits_lc_English
      b_throw=true
      exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw)
      #--------------------
      ht_out=Hash.new
      func_exclude=lambda do |s_fp|
         if FileTest.symlink? s_fp
            # Broken symlinks have a nonexistent target.
            if File.exist? s_fp
               ht_out[s_fp]=File.realpath(s_fp)
            end # if
         end # if
         # Folders that are descended into must not
         # be marked as ignorable.
         b_ignore=false
         return b_ignore
      end # func_exclude
      ar_or_s_glob_string=$kibuvits_lc_star
      rgx_filter=/.+/
      b_return_long_paths=true
      ar_fp_symlinks=nil
      b_return_globbing_results=false
      ar_glob_recursively_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,rgx_filter,
      b_return_long_paths,
      func_exclude,b_return_globbing_results)
      return ht_out
   end # ht_find_nonbroken_symlinks_recursively_t1


   def Kibuvits_fs.ht_find_nonbroken_symlinks_recursively_t1(ar_or_s_fp_directory)
      ht_out=Kibuvits_fs.instance.ht_find_nonbroken_symlinks_recursively_t1(
      ar_or_s_fp_directory)
      return ht_out
   end # Kibuvits_fs.ht_find_nonbroken_symlinks_recursively_t1

   #----------------------------------------------------------------------

   public

   # Returns true, if any of the files that do exist have been
   # modified after the last call to this method.
   # In the context of this method file deletion is NOT considered
   # as file modification operation.
   #
   # Returns true, if the cache is omitted.
   # The cache is emptied if the cache max. size is reached.
   def b_files_that_exist_changed_after_last_check_t1(
      ar_or_s_fp_file_or_folder, i_cache_max_size,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files=[])
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String],ar_or_s_fp_file_or_folder
         kibuvits_typecheck bn, Integer, i_cache_max_size
         kibuvits_typecheck bn, [String,Array], ar_or_s_path_prefixes_of_ignorable_folders_and_files
         if ar_or_s_fp_file_or_folder.class==Array
            ar_or_s_fp_file_or_folder.each do |s_fp_candidate|
               bn_1=binding()
               kibuvits_assert_string_min_length(bn_1,s_fp_candidate,2)
            end # loop
         end # if
         if ar_or_s_path_prefixes_of_ignorable_folders_and_files.class==Array
            ar_or_s_path_prefixes_of_ignorable_folders_and_files.each do |s_fp_folder|
               kibuvits_assert_string_min_length(bn,s_fp_folder,1)
            end # loop
         else
            kibuvits_assert_string_min_length(bn,
            ar_or_s_path_prefixes_of_ignorable_folders_and_files,1)
         end # if
      end # if
      ar_fp_ignorables=Kibuvits_ix.normalize2array(
      ar_or_s_path_prefixes_of_ignorable_folders_and_files)
      b_out=false
      $kibuvits_lc_mx_streamaccess.synchronize do
         if !defined? @s_b_files_that_exist_changed_after_last_check_t1_cache_fp
            @s_b_files_that_exist_changed_after_last_check_t1_cache_fp=KIBUVITS_HOME+
            "/src/include/bonnet/tmp"+
            "/KRL_sys_Kibuvits_fs_b_files_that_exist_changed_after_last_check_t1_cache.txt"
         end # if
         ht_cache=nil
         if File.exists? @s_b_files_that_exist_changed_after_last_check_t1_cache_fp
            s_progfte=file2str(@s_b_files_that_exist_changed_after_last_check_t1_cache_fp)
            ht_cache=Kibuvits_ProgFTE.to_ht(s_progfte)
            if i_cache_max_size<ht_cache.keys.size
               ht_cache.clear
               b_out=true
            end # if
         else
            ht_cache=Hash.new
            b_out=true
         end # if
         ar_fp=Kibuvits_ix.normalize2array(ar_or_s_fp_file_or_folder)
         ar_fp_files=Array.new
         ar_fp_files_and_folders=nil
         b_return_long_paths=true
         ar_globstrings=[$kibuvits_lc_star]
         b_ignore_file_or_folder=nil
         ar_speedhack_1=[]
         rgx_filter=/.+/
         ar_fp.each do |s_fp|
            b_ignore_file_or_folder=Kibuvits_str.b_has_prefix(
            ar_fp_ignorables,s_fp,ar_speedhack_1)
            next if b_ignore_file_or_folder
            # Ignorance check has to be before existence check
            # to avoid accessing files and folders on network
            # drives or otherwise slow or costly devices.
            next if !File.exists? s_fp
            if File.directory? s_fp
               ar_fp_files_and_folders=ar_glob_recursively_t1(s_fp,
               ar_globstrings,rgx_filter,b_return_long_paths,ar_fp_ignorables)
               ar_fp_files_and_folders.each do |s_fp_1|
                  if File.file? s_fp_1
                     # The Pathname.new(blabla) is for path normalization.
                     ar_fp_files<<Pathname.new(s_fp_1).realpath.to_s
                  end # if
               end # loop
            else
               # The Pathname.new(blabla) is for path normalization.
               ar_fp_files<<Pathname.new(s_fp).realpath.to_s
            end # if
         end # loop
         ar_fp_files.uniq!
         ar_fp_files.each do |s_fp|
            s_mtime=File.mtime(s_fp).to_f.to_s # to_f for greater precision
            if ht_cache.has_key? s_fp
               b_out=true if ht_cache[s_fp]!=s_mtime
            else
               b_out=true
            end # if
            ht_cache[s_fp]=s_mtime
         end # loop
         s_progfte=Kibuvits_ProgFTE.from_ht(ht_cache)
         str2file(s_progfte,@s_b_files_that_exist_changed_after_last_check_t1_cache_fp)
      end # synchronize
      return b_out
   end # b_files_that_exist_changed_after_last_check_t1

   def Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(
      ar_or_s_fp_file_or_folder, i_cache_max_size,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files=[])
      b_out=Kibuvits_fs.instance.b_files_that_exist_changed_after_last_check_t1(
      ar_or_s_fp_file_or_folder, i_cache_max_size,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files)
      return b_out
   end # Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1

   #----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_fs

#==========================================================================
