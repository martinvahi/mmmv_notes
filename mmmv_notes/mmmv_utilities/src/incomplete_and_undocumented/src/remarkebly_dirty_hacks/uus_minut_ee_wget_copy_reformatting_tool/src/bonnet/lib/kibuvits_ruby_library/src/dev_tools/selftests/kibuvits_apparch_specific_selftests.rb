#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/kibuvits_apparch_specific.rb"

#==========================================================================

class Kibuvits_apparch_specific_selftests

   def initialize
   end #initialize
   private
   #-----------------------------------------------------------------------

   def Kibuvits_apparch_specific_selftests.test_xof_run_bloc_on_a_copy_of_a_template
      s_tmp_folder_path=Kibuvits_os_codelets.get_tmp_folder_path
      s_fp=Kibuvits_os_codelets.generate_tmp_file_absolute_path
      s_demo="Test text"+Kibuvits_GUID_generator.generate_GUID
      str2file(s_demo,s_fp)
      if KIBUVITS_b_DEBUG
         if !kibuvits_block_throws{Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(s_fp,s_tmp_folder_path,nil){}}
            File.delete(s_fp) if File.exists? s_fp
            kibuvits_throw "test 1"
         end # if
      end # if
      if !kibuvits_block_throws{Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(42,s_tmp_folder_path,true){}}
         File.delete(s_fp) if File.exists? s_fp
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(s_fp,42,true){}}
         File.delete(s_fp) if File.exists? s_fp
         kibuvits_throw "test 3"
      end # if
      if kibuvits_block_throws{Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(s_fp,s_tmp_folder_path,true){}}
         File.delete(s_fp) if File.exists? s_fp
         kibuvits_throw "test 4"
      end # if
      str2file(s_demo,s_fp)
      if kibuvits_block_throws{Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(s_fp,s_tmp_folder_path){}}
         File.delete(s_fp) if File.exists? s_fp
         kibuvits_throw "test 5"
      end # if
      str2file(s_demo,s_fp)
      ht=Hash.new
      ht_1=nil
      s_x=nil
      Kibuvits_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(
      s_fp,s_tmp_folder_path,true) do |s_tmp_file_path|
         s_x=file2str(s_tmp_file_path)
      end # block
      kibuvits_throw "test 6 s_x=="+s_x.to_s if s_x!=s_demo
      File.delete(s_fp) if File.exists? s_fp
   end # Kibuvits_apparch_specific_selftests.test_xof_run_bloc_on_a_copy_of_a_template

   #-----------------------------------------------------------------------

   def Kibuvits_apparch_specific_selftests.test_x_file_path_2_version_t1
      if !kibuvits_block_throws{Kibuvits_apparch_specific.x_file_path_2_version_t1(42)}
         kibuvits_throw "test 1"
      end # if
      x=Kibuvits_apparch_specific.x_file_path_2_version_t1("aa_v33.nonsense")
      kibuvits_throw "test 2 x=="+x.to_s if x!=33
      x=Kibuvits_apparch_specific.x_file_path_2_version_t1("aa_v.nonsense")
      kibuvits_throw "test 3 x=="+x.to_s if x!=nil
      x=Kibuvits_apparch_specific.x_file_path_2_version_t1("aa_v3a.nonsense")
      kibuvits_throw "test 4 x=="+x.to_s if x!=nil
      x=Kibuvits_apparch_specific.x_file_path_2_version_t1("aa_vZZZ.nonsense")
      kibuvits_throw "test 5 x=="+x.to_s if x!=nil
      x=Kibuvits_apparch_specific.x_file_path_2_version_t1("aa_v0.nonsense")
      kibuvits_throw "test 6 x=="+x.to_s if x!=0
      x=Kibuvits_apparch_specific.x_file_path_2_version_t1("aa_v-3.nonsense")
      kibuvits_throw "test 7 x=="+x.to_s if x!=nil
   end # Kibuvits_apparch_specific_selftests.test_x_file_path_2_version_t1

   #-----------------------------------------------------------------------
   public
   def Kibuvits_apparch_specific_selftests.test_update_file_version_t1
      msgcs=Kibuvits_msgc_stack.new
      s_folder_path=Kibuvits_os_codelets.generate_tmp_file_absolute_path
      Dir.mkdir(s_folder_path)
      s_fn1="file_for_testing_v1.txt"
      s_fn2="file_for_testing_v79.txt"
      s_fp_1=s_folder_path+"/"+s_fn1
      s_fp_expected=s_folder_path+"/file_for_testing_v79.txt"
      s_fp_42=s_folder_path+"/file_for_testing_42.txt"
      str2file(s_fn1,s_fp_1)
      str2file(s_fn1,s_fp_42)
      Kibuvits_apparch_specific.update_file_version_t1(
      s_fp_1,s_fp_42,79,msgcs)
      s_x=file2str(s_fp_42)
      b_test_1_failure=false
      b_test_1_failure=true if s_x!=s_fn2
      b_test_2_failure=false
      b_test_2_failure=true if !File.exists? s_fp_expected
      b_test_3_failure=false
      b_test_3_failure=true if File.exists? s_fp_1

      File.delete(s_fp_1) if File.exists? s_fp_1
      File.delete(s_fp_expected) if File.exists? s_fp_expected
      File.delete(s_fp_42) if File.exists? s_fp_42
      Dir.rmdir(s_folder_path) if File.exists? s_folder_path
      kibuvits_throw "test 0" if msgcs.b_failure
      kibuvits_throw "test 1" if b_test_1_failure
      kibuvits_throw "test 2" if b_test_2_failure
      kibuvits_throw "test 3" if b_test_3_failure
   end # Kibuvits_apparch_specific_selftests.test_update_file_version_t1

   #-----------------------------------------------------------------------

   def Kibuvits_apparch_specific_selftests.test_b_softf1_com_envs_NOT_OK
      # The strategy here is just to execute as many branches as possible.
      msgcs=Kibuvits_msgc_stack.new
      #---------
      s_env_name="KIBUVITS_HOME"
      x=ENV[s_env_name]
      b_erase=false
      if x.class!=String
         ENV[s_env_name]=KIBUVITS_HOME
         b_erase=true
      end # if
      msgcs.clear
      ar_envnames=[s_env_name]
      b_x=Kibuvits_apparch_specific.b_softf1_com_envs_NOT_OK(ar_envnames,msgcs)
      kibuvits_throw "test 0 s_env_name=="+s_env_name if b_x
      ENV[s_env_name]=nil if b_erase
      #---------
      s_env_name="SIREL_HOME"
      x=ENV[s_env_name]
      if x.class==String
         msgcs.clear
         ar_envnames=[s_env_name]
         b_x=Kibuvits_apparch_specific.b_softf1_com_envs_NOT_OK(ar_envnames,msgcs)
         kibuvits_throw "test 1 s_env_name=="+s_env_name if b_x
      end # if
      #---------
      s_env_name="RAUDROHI_HOME"
      x=ENV[s_env_name]
      if x.class==String
         msgcs.clear
         ar_envnames=[s_env_name]
         b_x=Kibuvits_apparch_specific.b_softf1_com_envs_NOT_OK(ar_envnames,msgcs)
         kibuvits_throw "test 2 s_env_name=="+s_env_name if b_x
      end # if
      #---------
      s_env_name="MMMV_DEVEL_TOOLS_HOME"
      x=ENV[s_env_name]
      if x.class==String
         msgcs.clear
         ar_envnames=[s_env_name]
         b_x=Kibuvits_apparch_specific.b_softf1_com_envs_NOT_OK(ar_envnames,msgcs)
         kibuvits_throw "test 3 s_env_name=="+s_env_name if b_x
      end # if
      #---------
   end # Kibuvits_apparch_specific_selftests.test_b_softf1_com_envs_NOT_OK

   #-----------------------------------------------------------------------
   public

   def Kibuvits_apparch_specific_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_apparch_specific_selftests.test_xof_run_bloc_on_a_copy_of_a_template"
      kibuvits_testeval bn, "Kibuvits_apparch_specific_selftests.test_x_file_path_2_version_t1"
      kibuvits_testeval bn, "Kibuvits_apparch_specific_selftests.test_update_file_version_t1"
      kibuvits_testeval bn, "Kibuvits_apparch_specific_selftests.test_b_softf1_com_envs_NOT_OK"
      return ar_msgs
   end # Kibuvits_apparch_specific_selftests.selftest

end # class Kibuvits_apparch_specific_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_apparch_specific_selftests.selftest.to_s

