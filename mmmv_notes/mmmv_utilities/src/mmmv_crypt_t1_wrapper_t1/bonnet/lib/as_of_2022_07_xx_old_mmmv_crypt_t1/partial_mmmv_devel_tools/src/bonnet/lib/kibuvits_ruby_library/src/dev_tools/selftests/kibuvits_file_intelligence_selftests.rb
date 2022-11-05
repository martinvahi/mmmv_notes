#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2013, martin.vahi@softf1.com that has an
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

require "fileutils"
require  KIBUVITS_HOME+"/src/include/kibuvits_file_intelligence.rb"

#==========================================================================

class Kibuvits_file_intelligence_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_file_intelligence_selftests.test_file_language_by_file_extension
      msgcs=Kibuvits_msgc_stack.new
      if kibuvits_block_throws{Kibuvits_file_intelligence.file_language_by_file_extension("./x.rb",msgcs)}
         kibuvits_throw "test 1"
      end # if
      if KIBUVITS_b_DEBUG
         if !kibuvits_block_throws{Kibuvits_file_intelligence.file_language_by_file_extension(42,msgcs)}
            kibuvits_throw "test 2"
         end # if
         if !kibuvits_block_throws{Kibuvits_file_intelligence.file_language_by_file_extension("./x.rb",42)}
            kibuvits_throw "test 3"
         end # if
      end # if
      msgcs.clear
      s=Kibuvits_file_intelligence.file_language_by_file_extension(
      "./x.rb",msgcs)
      kibuvits_throw "test 4" if msgcs.b_failure
      kibuvits_throw "test 5" if s.downcase!="ruby".downcase
   end # Kibuvits_file_intelligence_selftests.test_file_language_by_file_extension

   #-----------------------------------------------------------------------

   def Kibuvits_file_intelligence_selftests.test_exm_s_create_backup_copy_t1
      msgcs=Kibuvits_msgc_stack.new
      s_name_prefix="tmp_folder_for_KRL_selftests_"
      s_fp_tests_folder=Kibuvits_os_codelets.get_tmp_folder_path+$kibuvits_lc_slash+
      Kibuvits_os_codelets.generate_tmp_file_name(s_name_prefix)
      #---------------------
      func_erase_tmp_dir=lambda do |s_guid|
         # A bit of safety. An antimeasure to "./././././" and "./../../"
         s_fp=s_fp_tests_folder.gsub(/[.]+/,".").gsub(/([.][\/])+/,"./")
         if 20<s_fp.length
            ht_stdstreams=kibuvits_sh("rm -fr "+s_fp)
            Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
            "GUID='1251f456-9ff8-44f3-b2e2-13b370e1ced7'\n")
         else
            raise Exception.new("Selftests are flawed.\n"+"GUID=="+s_guid)
         end # if
      end # func_erase_tmp_dir
      #---------------------
      s_working_directory_orig=FileUtils.getwd.to_s
      FileUtils.chdir("/tmp")
      begin
         Dir.mkdir(s_fp_tests_folder)
         s_fp_orig_file=s_fp_tests_folder+"/file_1.txt"
         s_txt_0="Hi\nthere!"
         str2file(s_txt_0,s_fp_orig_file)
         s_fp_dest_folder=s_fp_tests_folder+"/destination_for_backups"
         Dir.mkdir(s_fp_dest_folder)
         s_fp_x=nil
         begin
            s_fp_x=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_orig_file,s_fp_dest_folder)
            s_fp_x_whatever=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_orig_file,s_fp_dest_folder)
            s_fp_x_whatever=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_orig_file)
         rescue Exception => e
            kibuvits_throw "test 1a e.to_s=="+e.to_s
         end # rescue
         s_fp_expected=s_fp_dest_folder+"/file_1_old_v0.txt"
         kibuvits_throw "test 1b s_fp_x=="+s_fp_x if s_fp_x!=s_fp_expected
         s_txt_x=file2str(s_fp_x)
         kibuvits_throw "test 1c s_txt_x=="+s_txt_x if s_txt_x!=s_txt_0
         #--------------
         # Trickery to back up recursively the s_fp_dest_folder
         s_fp_trickery_orig=s_fp_dest_folder
         s_fp_x_0=nil
         begin
            s_fp_x=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_trickery_orig,".")
            s_fp_x_0=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_trickery_orig,".")
         rescue Exception => e
            kibuvits_throw "test 2a e.to_s=="+e.to_s
         end # rescue
         if s_fp_x_0==s_fp_x # current version must re-copy folders
            kibuvits_throw("test 2b \n"+
            "GUID='3377a55f-a5a7-4692-b5d2-13b370e1ced7'\n"+
            "  s_fp_x == "+s_fp_x+
            "\ns_fp_x_0 == "+s_fp_x_0)
         end # if
         #--------------
         s_fp_x_0=nil
         begin
            s_fp_x=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_orig_file,".")
            s_fp_x_0=Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
            s_fp_orig_file,".")
         rescue Exception => e
            kibuvits_throw "test 3a e.to_s=="+e.to_s
         end # rescue
         if s_fp_x_0!=s_fp_x # Back-up files must not duplicate themselves.
            kibuvits_throw("test 3b \n"+
            "GUID='49484d5a-7ecf-41b9-a8d2-13b370e1ced7'\n"+
            "  s_fp_x == "+s_fp_x+
            "\ns_fp_x_0 == "+s_fp_x_0)
         end # if
      rescue Exception => e
         func_erase_tmp_dir.call("41f75f35-32f3-45b2-84d2-13b370e1ced7")
         kibuvits_throw e.to_s
      end # rescue
      func_erase_tmp_dir.call("1784715f-9784-4c81-a3d2-13b370e1ced7")
      FileUtils.chdir(s_working_directory_orig)
   end # Kibuvits_file_intelligence_selftests.test_exm_s_create_backup_copy_t1

   #-----------------------------------------------------------------------

   def Kibuvits_file_intelligence_selftests.test_s_get_MIME_type
      s_x=Kibuvits_file_intelligence.s_get_MIME_type(__FILE__)
      kibuvits_throw "test 1a s_x=="+s_x if s_x!="text/x-ruby"
      b_x=Kibuvits_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1(s_x)
      kibuvits_throw "test 1b s_x=="+s_x if b_x
      #------
      s_fp=KIBUVITS_HOME+"/src/dev_tools/selftests"+
      "/data_for_selftests/kibuvits_ImageMagick_selftests/uhuu.bmp"
      s_x=Kibuvits_file_intelligence.s_get_MIME_type(s_fp)
      if (s_x!="application/octet-stream") && (s_x!="image/x-ms-bmp")
         kibuvits_throw "test 2a s_x=="+s_x
      end
      b_x=Kibuvits_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1(s_x)
      kibuvits_throw "test 2b s_x=="+s_x if !b_x
   end # Kibuvits_file_intelligence_selftests.test_s_get_MIME_type

   #-----------------------------------------------------------------------

   public
   def Kibuvits_file_intelligence_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_file_intelligence_selftests.test_file_language_by_file_extension"
      kibuvits_testeval bn, "Kibuvits_file_intelligence_selftests.test_exm_s_create_backup_copy_t1"
      kibuvits_testeval bn, "Kibuvits_file_intelligence_selftests.test_s_get_MIME_type"
      return ar_msgs
   end # Kibuvits_file_intelligence_selftests.selftest

end # class Kibuvits_file_intelligence_selftests

#==========================================================================

