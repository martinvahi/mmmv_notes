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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "pathname"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_os_codelets.rb"
   require  "kibuvits_io.rb"
end # if

# The "fileutils" gem/library MUST NOT BE USED, because
# it does not come precompiled with the Ruby distribution
# and its installation requires operating system specific
# compilation, which  prevents parts of the the KRL from running
# on Windows and JRuby. JRuby is necessary for using KRL
# form Java. The JRuby is used for running IDE addons/plugins
# and for using the KRL text processing routines for custom
# Java applications.

require "singleton"
#==========================================================================

# The class Kibuvits_fs is a namespace for functions that
# deal with filesystem related activities, EXCEPT the IO, which
# is considered to be more general and depends on the filesystem.
class Kibuvits_fs
   @@lc_s_emptystring=""
   @@lc_s_slash="/"
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
         "recieve a valid checks specification. s_checks_specification=="+
         s_checks_specification+" \n"
      end # if

      ar=Kibuvits_str.explode s_1, $kibuvits_lc_comma
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
                           msgc['English']=s_en+"with the path of\n\""+
                           s_file_path_candidate+"\"\nis deletable,"
                           msgc['Estonian']=s_ee+" rajaga \n\""+
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
            msgc['English']=s_en+"with a path of\n\""+s_file_path_candidate+
            "\"\nis required to be missing, but it exists."
            s_ee="Fail "
            s_ee="Kataloog " if b_is_directory
            msgc['Estonian']=s_ee+" rajaga \""+s_file_path_candidate+
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
            msgc['English']="File or folder with a path of\n\""+
            s_file_path_candidate+"\"\ndoes not exist."
            msgc['Estonian']="Faili ega kataloogi rajaga \""+
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
                     msgc['English']="\""+s_file_path_candidate+
                     "\" is a file, but a foder is required."
                     msgc['Estonian']=s_ee+" rajaga \""+s_file_path_candidate+
                     "\" on fail, kuid nõutud on kataloog."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "is_file"
                  if b_is_directory
                     msgc=Kibuvits_msgc.new
                     msgc['English']="\""+s_file_path_candidate+
                     "\" is a folder, but a file is required."
                     msgc['Estonian']=s_ee+" rajaga \""+s_file_path_candidate+
                     "\" on kataloog, kuid nõutud on fail."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "readable"
                  if !File.readable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis not readable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
                     s_file_path_candidate+"\"\nei ole loetav."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "not_readable"
                  if File.readable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis readable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
                     s_file_path_candidate+"\"\non loetav."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "writable"
                  if !File.writable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis not writable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
                     s_file_path_candidate+"\"\nei ole kirjutatav."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "not_writable"
                  if File.writable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis writable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
                     s_file_path_candidate+"\"\non kirjutatav."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "deletable"
                  # It's possible to delete only files that exist.
                  if !File.writable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis not deletable, because it is not writable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
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
                        msgc['English']=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not deletable, because its parent folder is not writable."
                        msgc['Estonian']=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole kustutatav, sest seda sisaldav kataloog ei ole kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  end # if
               when "executable"
                  if !File.executable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis not executable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
                     s_file_path_candidate+"\"\nei ole jookstav."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               when "not_executable"
                  if File.executable?(s_file_path_candidate)
                     msgc=Kibuvits_msgc.new
                     msgc['English']=s_en+"with the path of\n\""+
                     s_file_path_candidate+"\"\nis executable."
                     msgc['Estonian']=s_ee+" rajaga \n\""+
                     s_file_path_candidate+"\"\non jookstav."
                     verify_access_register_failure(
                     ht_out, s_file_path_candidate, s_cmd, msgc)
                  end # if
               else
               end # case
            end # if b_value
         end # loop
      end # if File.exists?(s_file_path_candidate)
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
   # The Kibuvits_fs.verify_access returns a hashtable.
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
      s_checks_specification)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], arry_of_file_paths_or_a_file_path_string
         kibuvits_typecheck bn, String, s_checks_specification
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
      ht_cmds=verify_access_spec2ht s_checks_specification
      ht_filesystemtest_failures=Hash.new
      ar_path_candidates.each do |s_file_path_candidate|
         verify_access_verification_step(s_file_path_candidate,
         ht_cmds, ht_filesystemtest_failures)
      end # loop
      return ht_filesystemtest_failures
   end # verify_access

   def Kibuvits_fs.verify_access(arry_of_file_paths_or_a_file_path_string,
      s_checks_specification)
      ht_filesystemtest_failures=Kibuvits_fs.instance.verify_access(
      arry_of_file_paths_or_a_file_path_string,s_checks_specification)
      return ht_filesystemtest_failures
   end # Kibuvits_fs.verify_access

   #-----------------------------------------------------------------------

   # The format of the ht_failures matches with the output of the
   # Kibuvits_fs.test_verify_access.
   def access_verification_results_to_string(ht_failures,
      s_language="English")
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_failures
         kibuvits_typecheck bn, String, s_language
      end # if
      s_out=""
      if ht_failures.length==0
         case s_language
         when "Estonian"
            s_out="\nFailisüsteemiga seonduvad testid läbiti edukalt.\n"
         else
            s_out="\nFilesystem related verifications passed.\n"
         end # case
         return s_out
      end # if
      case s_language
      when "Estonian"
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
      s_language="English")
      s_out=Kibuvits_fs.instance.access_verification_results_to_string(
      ht_failures, s_language)
      return s_out
   end # Kibuvits_fs.access_verification_results_to_string

   #-----------------------------------------------------------------------

   def exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language="English",b_throw=false)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_filesystemtest_failures
         kibuvits_typecheck bn, String, s_output_message_language
      end # if
      return if ht_filesystemtest_failures.length==0
      s_msg=Kibuvits_fs.access_verification_results_to_string(
      ht_filesystemtest_failures, s_output_message_language)
      if b_throw
         kibuvits_throw(s_msg+$kibuvits_lc_linebreak)
      else
         puts s_msg+$kibuvits_lc_linebreak
         exit
      end # if
   end # exit_if_any_of_the_filesystem_tests_failed

   def Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures,s_output_message_language="English",
      b_throw=false)
      Kibuvits_fs.instance.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures, s_output_message_language,b_throw)
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
      s_out="undetermined"
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
         ar=Kibuvits_str.explode(s_path,$kibuvits_lc_slash)
      when $kibuvits_lc_kibuvits_ostype_windows
         ar=Kibuvits_str.explode(s_path,$kibuvits_lc_backslash)
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
      s_folder_name1=s_folder_name0.gsub(rgx_slash,@@lc_s_emptystring)
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
      s_left=s_base_unix.reverse.gsub(/^[\/]/,@@lc_s_emptystring).reverse
      rgx_slash=/\//
      i_len.times do |i|
         s_folder_name0=ar_folder_names[i]
         array2folders_verify_folder_name_candidate_t1 s_folder_name0, rgx_slash
         s_left=s_left+@@lc_s_slash+s_folder_name0
         s_folder_name1=s_left
         Dir.mkdir(s_folder_name1) if !File.exists? s_folder_name1
         ht_filesystemtest_failures=Kibuvits_fs.verify_access(
         s_folder_name1,"is_directory,writable")
         exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures)
      end # loop
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
            s_output_message_language="English",b_throw=false)
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
   # has been made acessible to everyone, then there's no
   # point of denying access to it.
   #
   def chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], ar_or_s_file_or_folder_path
      end # if
      ar_fp=Kibuvits_ix.normalize2array(ar_or_s_file_or_folder_path)
      ar_fp.each do |s_fp|
         if !File.exists? s_fp
            kibuvits_throw("The file or folder \n"+s_fp+
            "\ndoes not exist. GUID='502524a2-7dbe-471a-aa3a-516260e0acd7'\n")
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
         File.chmod(0777,s_fp) # access descrition must contain 4 digits, or a flaw is introduced
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
         "the owner of the current process. GUID='d1fc312f-b40e-4c4e-a33a-516260e0acd7'")
      end # loop
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
            "GUID='b2c8bb54-f014-44ac-b13a-516260e0acd7'\n")
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
   # does not exist, regardless of wether the parent
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
      ar_paths_in.each do |s_file_or_folder_path|
         next if !File.exists? s_file_or_folder_path
         ob_pth=Pathname.new(s_file_or_folder_path)
         s_parent_path=ob_pth.dirname.to_s
         # Here the (File.exists? s_parent_path)==true
         # because every existing file or folder that
         # is not the "/" defenately has an existing parent
         # and the Pathname.new("/").to_s=="/"
         if !File.writable? s_parent_path
            kibuvits_throw("Folder \n"+s_parent_path+
            "\nis not writable. GUID='453f40f6-50d2-48c1-a93a-516260e0acd7'\n")
         end # if
         s_fp=s_file_or_folder_path
         chmod_recursive_secure_7(s_fp) # throws, if the chmod-ding fails
         impl_rm_fr_part_1(s_file_or_folder_path)
      end # loop
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
         msgcs.last["Estonian"]=s_default_msg
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
         msgcs.last["Estonian"]=s_default_msg
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
         msgcs.last["Estonian"]=s_default_msg
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
         msgcs.last["Estonian"]=s_default_msg
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
            "GUID='3f556f84-40c2-42fb-b33a-516260e0acd7'\n\n"
            #s_message_id="throw_1"
            #b_failure=false
            #msgcs.cre(s_default_msg,s_message_id,b_failure)
            #msgcs.last["Estonian"]="\n"+x_candidate.to_s+
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
         #    "GUID='663c5651-e080-45d8-b32a-516260e0acd7'\n\n"
         #s_message_id="throw_1"
         #b_failure=false
         #msgcs.cre(s_default_msg,s_message_id,b_failure)
         #msgcs.last["Estonian"]="\n"+x_candidate.to_s+
         #", omab väärtust, mis ei sobi faili nimeks.\n"
         #    kibuvits_throw(s_default_msg)
         #    end # if
      end # loop
   end # b_env_not_set_or_has_improper_path_t1_exc_verif1

   def b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
      s_environment_variable_name,s_env_value,s_path,msgcs)
      b_missing=false
      if !File.exists? s_path
         s_default_msg="\nThe environment variable, "+
         s_environment_variable_name+"==\""+s_env_value+
         "\",\n has a wrong value, because a file or a folder "+
         "with the path of \n"+s_path+"\n does not esist.\n"
         s_message_id="4"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         msgcs.last["Estonian"]="\nKeskkonnamuutuja, "+
         s_environment_variable_name+"==\""+s_env_value+
         "\"\n, omab vale väärtust, sest faili ega kataloogi rajaga\n"+
         s_path+"\n ei eksisteeri.\n"
         b_missing=true
      end # if
      return b_missing
   end # b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist


   public

   # The evironment variable that is referenced by the
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
         msgcs.last["Estonian"]="\nKeskkonnamuutuja, "+s_environment_variable_name+
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
         msgcs.last["Estonian"]="\nKeskkonnamuutuja, "+s_environment_variable_name+
         ", omab väärtust, mis ei sobi faili rajaks.\n"
         return true
      end # if
      b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_file_names,msgcs)
      b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_folder_names,msgcs)
      s_env_value=x_env_value
      if !File.exists? s_env_value
         s_default_msg="\nThe file or folder that the environment variable, "+
         s_environment_variable_name+", references does not exist.\n"
         s_message_id="3"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         msgcs.last["Estonian"]="\nKeskkonnamuutuja, "+s_environment_variable_name+
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
            msgcs.last["Estonian"]="\nKeskkonnamuutuja, "+
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
            msgcs.last["Estonian"]="\nKeskkonnamuutuja, "+
            s_environment_variable_name+"==\""+s_env_value+
            "\"\n, korral kahtlustatakse vale väärtust, sest kataloogi rajaga\n"+
            s_path+"\n ei eksisteeri, kuid sama rajaga fail eksisteerib.\n"
            return true
         end # if
      end # loop
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
      ar_or_s_fp_directory,ar_or_s_glob_string,b_return_long_paths)
      kibuvits_typecheck bn, [String,Array], ar_or_s_fp_directory
      kibuvits_typecheck bn, [String,Array], ar_or_s_glob_string
      kibuvits_typecheck bn, [TrueClass,FalseClass], b_return_long_paths

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
   end # exc_ar_glob_x_verifications_t1

   public

   # Folder paths have to be full paths.
   # Throws, if the folder does not exist or could not be found.
   #
   # It temporarily changes the working directory to the s_fp_directory.
   def ar_glob_locally_t1(ar_or_s_fp_directory,ar_or_s_glob_string,
      b_return_long_paths=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_ar_glob_x_verifications_t1(bn,ar_or_s_fp_directory,
         ar_or_s_glob_string,b_return_long_paths)
      end # if
      ar_fp_folder=Kibuvits_ix.normalize2array(ar_or_s_fp_directory)
      ar_globstrings=Kibuvits_ix.normalize2array(ar_or_s_glob_string)

      ht_test_failures=verify_access(ar_fp_folder,"readable,is_directory")
      s_output_message_language="English"
      b_throw=true
      exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw)

      ar_out=Array.new
      s_fp_wd_orig=Dir.getwd
      begin
         ar_1=nil
         ar_2=nil
         ar_2=Array.new if b_return_long_paths
         s_0=nil
         s_1=nil
         rgx_1=/[\/]+/ # can't cache due to threading
         ar_fp_folder.each do |s_fp_folder|
            s_0=s_fp_folder+$kibuvits_lc_slash if b_return_long_paths
            Dir.chdir(s_fp_folder)
            ar_globstrings.each do |s_globstring|
               ar_1=Dir.glob(s_globstring)
               if b_return_long_paths
                  ar_1.each do |s_fname|
                     s_1=(s_0+s_fname).gsub(rgx_1,$kibuvits_lc_slash)
                     ar_2<<s_1
                  end # loop
               else
                  ar_2=ar_1
               end # if
               ar_out.concat(ar_2)
               ar_2.clear
            end # loop
            Dir.chdir(s_fp_wd_orig)
         end # loop
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
      ar_or_s_glob_string, b_return_long_paths=true)
      ar_out=Kibuvits_fs.instance.ar_glob_locally_t1(
      ar_or_s_fp_directory,ar_or_s_glob_string,b_return_long_paths)
      return ar_out
   end # Kibuvits_fs.ar_glob_locally_t1

   #----------------------------------------------------------------------
   # Folder paths have to be full paths.
   # Throws, if the folder does not exist or could not be found.
   #
   # It temporarily changes the working directory to the s_fp_directory.
   def ar_glob_recursively_t1(ar_or_s_fp_directory,ar_or_s_glob_string,
      b_return_long_paths=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_ar_glob_x_verifications_t1(bn,ar_or_s_fp_directory,
         ar_or_s_glob_string,b_return_long_paths)
      end # if
      ar_fp_folder=Kibuvits_ix.normalize2array(ar_or_s_fp_directory)
      ar_globstrings=Kibuvits_ix.normalize2array(ar_or_s_glob_string)

      ar_out=Array.new
      ar_1=nil
      ar_2=nil
      ar_3=nil
      ar_fp_folder.each do |s_fp_folder|
         ar_1=ar_glob_locally_t1(s_fp_folder,ar_globstrings,
         b_return_long_paths)
         ar_out.concat(ar_1)
         ar_2=Dir.glob(s_fp_folder+"/*")
         ar_2.each do |s_fp|
            if File.directory? s_fp
               ar_3=ar_glob_recursively_t1(s_fp,
               ar_globstrings,b_return_long_paths)
               ar_out.concat(ar_3)
            end # if
         end # loop
      end # loop
      return ar_out
   end # ar_glob_recursively_t1

   def Kibuvits_fs.ar_glob_recursively_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string, b_return_long_paths=true)
      ar_out=Kibuvits_fs.instance.ar_glob_recursively_t1(
      ar_or_s_fp_directory,ar_or_s_glob_string,b_return_long_paths)
      return ar_out
   end # Kibuvits_fs.ar_glob_recursively_t1

   #----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_fs

#==========================================================================
