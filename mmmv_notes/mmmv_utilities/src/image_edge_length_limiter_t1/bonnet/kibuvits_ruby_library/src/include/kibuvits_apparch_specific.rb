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
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"

#==========================================================================

# The class Kibuvits_apparch_specific is a namespace for
# code fragmetns that are somewhat specific to
# an application architecture, but as the architectures are
# shared by more than one application, it saves time by
# writing them only once in stead of rewriting the parts
# in every application.
class Kibuvits_apparch_specific
   def initialize
   end #initialize

   # Makes a copy of a file that is pointed by the
   # s_template_file_path and executes
   # a block that gets 1 block argument: s_tmp_file_path
   def xof_run_bloc_on_a_copy_of_a_template(
      s_template_file_path, s_temporary_folder_path,
      b_delete_temporary_file=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_template_file_path
         kibuvits_typecheck bn, String, s_temporary_folder_path
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_delete_temporary_file
      end # if
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(
      s_template_file_path,'is_file,readable')
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures)

      ht_filesystemtest_failures=Kibuvits_fs.verify_access(
      s_temporary_folder_path,'is_directory,writable')
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures)

      s_tmp_file_path=s_temporary_folder_path+"/subject_to_removal_"+
      Kibuvits_GUID_generator.generate_GUID+".txt"

      # The next line works also on binary files, which is important.
      sh "cp "+s_template_file_path+" "+s_tmp_file_path
      b_exception_in_block=false
      s_xs_msg=""
      begin
         yield(s_tmp_file_path)
      rescue Exception => e
         b_exception_in_block=true
         s_xs_msg=e.message
      end # end
      if b_delete_temporary_file
         File.delete(s_tmp_file_path) if File.exists? s_tmp_file_path
      end # if
      kibuvits_throw s_xs_msg if b_exception_in_block
   end # xof_run_bloc_on_a_copy_of_a_template,

   def Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(
      s_template_file_path, s_temporary_folder_path,
      b_delete_temporary_file=true,&a_block)
      Kibuvits_apparch_specific.instance.xof_run_bloc_on_a_copy_of_a_template(
      s_template_file_path, s_temporary_folder_path,
      b_delete_temporary_file,&a_block)
   end # Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template

   #-----------------------------------------------------------------------

   # Explanation by examples:
   #
   # "nice_v42.css" -> 42
   # "nice_v99.awesomeextension" -> 99
   # "nice_v69.tar.bz_v23.jar" -> 23
   # "nice_v.css" -> nil
   # "nice_47.css" -> nil
   # "nice_v72.contains a space" -> nil
   # "nice_v-72.js" -> nil
   # "nice_vX82.js" -> nil
   #
   # The file does not have to exist.
   # Returns an integer or nil.
   def x_file_path_2_version_t1(s_file_path_or_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path_or_name
      end # if
      rgx_1=/_v[\d]+[.][^.\s]+$/
      md=s_file_path_or_name.match(rgx_1)
      return nil if md==nil
      s_1=md[0]
      i_1=s_1.index($kibuvits_lc_dot)
      # _v427.css
      # 012345
      i_old_version=s_1[2..(i_1-1)].to_i
      return  i_old_version
   end # x_file_path_2_version_t1

   def Kibuvits_apparch_specific.x_file_path_2_version_t1(s_file_path_or_name)
      x=Kibuvits_apparch_specific.instance.x_file_path_2_version_t1(s_file_path_or_name)
      return x
   end # Kibuvits_apparch_specific.x_file_path_2_version_t1

   #-----------------------------------------------------------------------

   private

   # The rgx_1 is meant to be the same as the one uncommented here.
   # Its a param to avoid reinit of the regex.
   def impl_x_old_path_2_new_path_t1(s_old_path,i_new_version,rgx_1)
      #rgx_1=/_v[\d]+[.][^.\s]+$/
      md=s_old_path.match(rgx_1)
      return nil if md==nil
      s_1=md[0]
      i_1=s_1.index($kibuvits_lc_dot)
      # _v427.css
      # 012345
      s_2=s_1[(i_1+1)..(-1)]
      s_1=("_v"+i_new_version.to_s)+($kibuvits_lc_dot+s_2)
      s_new_path=s_old_path.sub(rgx_1,s_1)
      return s_new_path
   end # impl_x_old_path_2_new_path_t1


   public

   # It does not return anything.
   # If modifications to the file names or file content
   # have been applied, then the msgcs.b_failure==false.
   #
   # If the msgcs.b_failure==true, then the
   # msgcs.last has the following values:
   #
   #     if msgcs.last.s_message_id=="Kibuvits_apparch_specific_wrong_filesystem_access_or_wrong_element_type"
   #        msgcs.last.ob_data=<Output of the Kibuvits_fs.verify_access.>
   #     end # if
   #     if msgcs.last.s_message_id=="Kibuvits_apparch_specific_malformed_paths"
   #        msgcs.last.ob_data=<An Array that contains at least one .>
   #     end # if
   #
   # This function is inspired by the fact that CSS and JavaScript
   # files get cached by the browser and to force the
   # browser to download a new version of the CSS and JavaScript
   # files, the file names have to change. One way to
   # implement the chane is to name the files like
   # nicenameprefix_v42.css  and someothernicename_v69.js and then
   # to increment the 42->42, 69->70 .
   #
   def update_file_version_t1(
      ar_or_s_renamable_file_paths,
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files,
      i_new_version,msgcs=Kibuvits_msgc_stack.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], ar_or_s_renamable_file_paths
         kibuvits_typecheck bn, [Array,String], ar_or_s_file_paths_of_files_that_reference_the_renamable_files
         kibuvits_typecheck bn, Fixnum,i_new_version
         kibuvits_typecheck bn, Kibuvits_msgc_stack,msgcs
      end # if
      if i_new_version<0
         kibuvits_throw "i_new_version == "+i_new_version.to_s+" < 0"
      end # if
      kibuvits_throw "msgcs.b_failure==true" if msgcs.b_failure
      ar_renamables=Kibuvits_ix.normalize2array(
      ar_or_s_renamable_file_paths)
      ar_rewritables=Kibuvits_ix.normalize2array(
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files)
      if KIBUVITS_b_DEBUG
         ar_renamables.each do |x|
            bn=binding()
            kibuvits_typecheck bn, String, x
         end # loop
         ar_rewritables.each do |x|
            bn=binding()
            kibuvits_typecheck bn, String, x
         end # loop
      end # if
      ht_fschecks=nil
      ar_renamables.each do |s_fp|
         ht_fschecks=Kibuvits_fs.verify_access(s_fp,"is_file,deletable")
         break if ht_fschecks.size!=0
      end # loop
      if ht_fschecks.size!=0
         msgcs.cre(s_default_msg="At least one of the renamable file candidates "+
         "has wrong filesystem access rigths or is a folder.",
         s_message_id="Kibuvits_apparch_specific_wrong_filesystem_access_or_wrong_element_type",
         b_failure=true)
         msgcs.last.ob_data=ht_fschecks
         return
      end # if
      ar_rewritables.each do |s_fp|
         ht_fschecks=Kibuvits_fs.verify_access(s_fp,"is_file,writable")
         break if ht_fschecks.size!=0
      end # loop
      if ht_fschecks.size!=0
         msgcs.cre(s_default_msg="At least one of the editable file candidates "+
         "has wrong filesystem access rigths or is a folder.",
         s_message_id="Kibuvits_apparch_specific_wrong_filesystem_access_or_wrong_element_type",
         b_failure=true)
         msgcs.last.ob_data=ht_fschecks
         return
      end # if
      ht_old_path_2_new_path=Hash.new
      rgx_1_for_tmp_caching=/_v[\d]+[.][^.\s]+$/
      x_new_path_candidate=nil
      ar_renamables.each do |s_old_path|
         x_new_path_candidate=impl_x_old_path_2_new_path_t1(s_old_path,
         i_new_version,rgx_1_for_tmp_caching)
         if x_new_path_candidate==nil
            msgcs.cre(s_default_msg="At least one of the renamable file candidates "+
            "has a name that does not meet the specification of this function.",
            s_message_id="Kibuvits_apparch_specific_malformed_paths", b_failure=true)
            msgcs.last.ob_data=[s_old_path]
            return
         end # if
         ht_old_path_2_new_path[s_old_path]=x_new_path_candidate
      end # loop
      # Over here, we're clear to go all the way. :-)
      ar_editables=[]+ar_rewritables
      ht_old_fn_2_new_fn=Hash.new
      s_old_file_name=nil
      s_new_file_name=nil
      ht_old_path_2_new_path.each_pair do |s_old_path,s_new_path|
         s_old_file_name=Pathname.new(s_old_path).basename.to_s
         s_new_file_name=Pathname.new(s_new_path).basename.to_s
         ht_old_fn_2_new_fn[s_old_file_name]=s_new_file_name
         File.rename(s_old_path,s_new_path)
         ar_editables<<s_new_path
      end # loop
      s_content=nil
      ar_editables.each do |s_file_path|
         s_content=file2str(s_file_path)
         s_content=Kibuvits_str.s_batchreplace(ht_old_fn_2_new_fn, s_content)
         str2file(s_content,s_file_path)
      end # loop
   end # update_file_version_t1


   def Kibuvits_apparch_specific.update_file_version_t1(
      ar_or_s_renamable_file_paths,
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files,
      i_new_version,msgcs=Kibuvits_msgc_stack.new)
      Kibuvits_apparch_specific.instance.update_file_version_t1(
      ar_or_s_renamable_file_paths,
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files,
      i_new_version,msgcs)
   end # Kibuvits_apparch_specific.update_file_version_t1(

   #-----------------------------------------------------------------------

   # Throws, if the s_or_ar_environment_variable_names depicts
   # an environment variable that has not been added to the
   # tests or the string that is an environment variable name candidate
   # does not qualify to be a variable name.
   def b_softf1_com_envs_NOT_OK(s_or_ar_environment_variable_names,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [String,Array], s_or_ar_environment_variable_names
         kibuvits_typecheck bn, Kibuvits_msgc_stack,msgcs
      end # if
      ar_env_names=Kibuvits_ix.normalize2array(s_or_ar_environment_variable_names)
      bn_1=nil
      ar_file_names=nil
      ar_folder_names=nil
      b_x=nil
      ar_env_names.each do |s_env_name|
         bn_1=binding()
         kibuvits_assert_ok_to_be_a_varname_t1(bn_1,s_env_name)
         case s_env_name
         when "KIBUVITS_HOME"
            ar_file_names=["include/kibuvits_boot.rb","include/kibuvits_all.rb"]
            ar_folder_names=["include","bonnet","dev_tools/selftests"]
            b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         when "SIREL_HOME"
            ar_file_names=["COMMENTS.txt","src/devel/src/sirel_core.php","src/devel/src/sirel.php"]
            ar_folder_names=["src/devel/src/bonnet","src/devel/src/lib/spyc"]
            b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         when "RAUDROHI_HOME"
            s_0="src/release/third_party/gnu_org/freefont/2011/"+
            "with_raudrhoi_specific_modifications/"+
            "raudrohi_thirdpartyspecificversion_1_FreeMono.ttf"
            ar_file_names=["COMMENTS.txt","src/dev_tools/Rakefile","src/devel/raudrohi_base.js","src/devel/raudrohi_core.js",s_0]
            ar_folder_names=["src/dev_tools/javascript_language_tests"]
            b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         when "MMMV_DEVEL_TOOLS_HOME"
            ar_file_names=["COMMENTS.txt","src/etc/mmmv_devel_tools_fallback_configuration.txt"]
            ar_folder_names=["src/mmmv_devel_tools","src/bonnet"]
            b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         else
            msg="\nEnvironment variable named "+s_env_name+
            " is not yet supported by this function.\n"
            kibuvits_throw(msg)
         end # case s_env_name
      end # loop
      return false
   end # b_softf1_com_envs_NOT_OK

   def Kibuvits_apparch_specific.b_softf1_com_envs_NOT_OK(
      s_or_ar_environment_variable_names,msgcs)
      b_out=Kibuvits_apparch_specific.instance.b_softf1_com_envs_NOT_OK(
      s_or_ar_environment_variable_names,msgcs)
      return b_out
   end # Kibuvits_apparch_specific.b_softf1_com_envs_NOT_OK

   #-----------------------------------------------------------------------

   public
   include Singleton
   # The Kibuvits_apparch_specific.selftest analogue is
   # in a separate selftest file.

end # class Kibuvits_apparch_specific
#=========================================================================
