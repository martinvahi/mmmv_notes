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

require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"

#==========================================================================

class Kibuvits_fs_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_verify_access
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(42,"exists")}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("","exists")}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(["x",""],"exists")}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(["x","s"],42)}
         kibuvits_throw "test 4"
      end # if
      #----------------
      begin
         Kibuvits_fs.verify_access(["x","s"],"is_file")
      rescue Exception => e
         kibuvits_throw "test 5 e.to_s"==e.to_s
      end # rescue
      #----------------
      if kibuvits_block_throws{Kibuvits_fs.verify_access("x","is_file")}
         #Because the rest of the "kibuvits_throw up tests" assume that "x" is OK.
         kibuvits_throw "test 6"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","is_file,does_not_exist")}
         kibuvits_throw "test 7"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","is_directory,does_not_exist")}
         kibuvits_throw "test 8"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","this_command_does_not_exist")}
         kibuvits_throw "test 9"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","readable,does_not_exist")}
         kibuvits_throw "test 10"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","writable,does_not_exist")}
         kibuvits_throw "test 11"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","executable,does_not_exist")}
         kibuvits_throw "test 12"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","readable,not_readable")}
         kibuvits_throw "test 13"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","writable,not_writable")}
         kibuvits_throw "test 14"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","executable,not_executable")}
         kibuvits_throw "test 15"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access("x","exists,does_not_exist")}
         kibuvits_throw "test 16"
      end # if
      s_tmp_folder_path=Kibuvits_os_codelets.instance.get_tmp_folder_path
      ht_failures=Kibuvits_fs.verify_access([s_tmp_folder_path],"exists")
      kibuvits_throw "test 17" if ht_failures.length!=0
      s=s_tmp_folder_path+"_nonsense_that42_CaNnotProbablyExist4"
      ht_failures=Kibuvits_fs.verify_access(s,"exists")
      kibuvits_throw "test 18" if ht_failures.length!=1
      ht_failures=Kibuvits_fs.verify_access(s,"exists")
      kibuvits_throw "test 18" if ht_failures.length!=1
      ht_failures=Kibuvits_fs.verify_access(s_tmp_folder_path,"is_directory")
      kibuvits_throw "test 19" if ht_failures.length!=0
      #-------------------
      msgcs=Kibuvits_msgc_stack.new
      kibuvits_throw "test 20a" if msgcs.b_failure
      ht_failures=Kibuvits_fs.verify_access(s_tmp_folder_path,"is_file",msgcs)
      kibuvits_throw "test 20b" if ht_failures.length!=1
      kibuvits_throw "test 20c" if !msgcs.b_failure
      ar_failures=ht_failures[s_tmp_folder_path]
      ht_failure=ar_failures[0]
      kibuvits_throw "test 21d" if ht_failure['command']!="is_file"
      kibuvits_throw "test 22e" if !ht_failure['msgc'].b_failure
      msgcs.clear
      #-------------------
=begin
		s_fp=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
		str2file("A temporary file created by the "+
			  "Kibuvits_fs.test_verify_access. ",s_fp)
		ht_failures=Kibuvits_fs.verify_access(s_fp,"is_file")
		File.delete(s_fp) # Cleans up before throwing.
		kibuvits_throw "test 23" if ht_failures.length!=0
		ht_failures=Kibuvits_fs.verify_access(s_fp,"does_not_exist")
		kibuvits_throw "test 24" if ht_failures.length!=0
=end
   end # Kibuvits_fs_selftests.test_verify_access


   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_verify_access_v2
      s_fp=KIBUVITS_HOME+"/src/dev_tools/selftests/kibuvits_fs_selftests.rb"
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(s_fp,",,,,,")}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(s_fp,",")}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(s_fp,"")}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(s_fp,"deletable, not_deletable")}
         kibuvits_throw "test 4"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(s_fp,"deletable, not_writable")}
         kibuvits_throw "test 5"
      end # if
      if !kibuvits_block_throws{Kibuvits_fs.verify_access(s_fp,"deletable, does_not_exist")}
         kibuvits_throw "test 6"
      end # if
      s_tmp_folder_path=Kibuvits_os_codelets.get_tmp_folder_path
      ht_x=Kibuvits_fs.verify_access(s_tmp_folder_path,"is_directory, writable")
      kibuvits_throw "test 7 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0

      s_genfolder_path=Kibuvits_os_codelets.generate_tmp_file_absolute_path()
      s_tmp_file_path=s_genfolder_path+"/f1.txt"
      begin
         Dir.mkdir(s_genfolder_path,0700)
         str2file("TestString",s_tmp_file_path)
      rescue Exception => e
         kibuvits_throw "test 8 e.to_s=="+e.to_s
      end # rescue
      begin
         File.chmod(0777,s_tmp_file_path)
         File.chmod(0500,s_genfolder_path)
      rescue Exception => e
         kibuvits_throw "test 9 e.to_s=="+e.to_s
      end # rescue
      ht_x=Kibuvits_fs.verify_access(s_tmp_file_path,"is_file, writable")
      kibuvits_throw "test 10 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0
      ht_x=Kibuvits_fs.verify_access(s_genfolder_path,"is_directory, not_writable")
      kibuvits_throw "test 11 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0
      ht_x=Kibuvits_fs.verify_access(s_tmp_file_path,"not_deletable")
      kibuvits_throw "test 12 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0
      ht_x=Kibuvits_fs.verify_access(s_genfolder_path,"not_deletable")
      kibuvits_throw "test 13 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0
      File.chmod(0700,s_genfolder_path)
      ht_x=Kibuvits_fs.verify_access(s_genfolder_path,"deletable")
      kibuvits_throw "test 14 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0
      ht_x=Kibuvits_fs.verify_access(s_tmp_file_path,"deletable")
      kibuvits_throw "test 15 ht_x.to_s=="+ht_x.to_s if ht_x.size!=0
      File.delete s_tmp_file_path if File.exists? s_tmp_file_path
      Dir.rmdir s_genfolder_path if File.exists? s_genfolder_path
   end # Kibuvits_fs_selftests.test_verify_access_v2

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_path2array
      if !kibuvits_block_throws{ Kibuvits_fs.path2array(42)}
         kibuvits_throw "test 1"
      end # if
      ar=Kibuvits_fs.path2array('/a/b')
      kibuvits_throw "test 2" if ar.length!=2
      kibuvits_throw "test 3" if ar[0]!="a"
      kibuvits_throw "test 4" if ar[1]!="b"
      ar=Kibuvits_fs.path2array('/')
      kibuvits_throw "test 5" if ar.length!=0
      ar=Kibuvits_fs.path2array('/a/')
      kibuvits_throw "test 6" if ar.length!=1
      kibuvits_throw "test 7" if ar[0]!="a"
      ar=Kibuvits_fs.path2array("C:\\a\\b",$kibuvits_lc_kibuvits_ostype_windows)
      kibuvits_throw "test 8" if ar.length!=3
      kibuvits_throw "test 9" if ar[0]!="C:"
      kibuvits_throw "test 10" if ar[1]!="a"
      kibuvits_throw "test 11" if ar[2]!="b"
      ar=Kibuvits_fs.path2array("C:\\",$kibuvits_lc_kibuvits_ostype_windows)
      kibuvits_throw "test 13" if ar[0]!="C:"
   end # Kibuvits_fs_selftests.test_path2array

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_array2path
      if !kibuvits_block_throws{ Kibuvits_fs.array2path(42)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{ Kibuvits_fs.array2path(['xx',''])}
         kibuvits_throw "test 2"
      end # if
      ar_results=Array.new
      ar_results<<Kibuvits_fs.array2path(['aa','bb'])
      ar_results<<Kibuvits_fs.array2path([])
      ar_results<<Kibuvits_fs.array2path(['ff'])
      ar_results<<Kibuvits_fs.array2path(['.','gg'])
      ar_results<<Kibuvits_fs.array2path(['..','gg','..'])
      kibuvits_throw "test 3" if ar_results[0]!="/aa/bb"
      kibuvits_throw "test 4" if ar_results[1]!="/"
      kibuvits_throw "test 5" if ar_results[2]!="/ff"
      kibuvits_throw "test 6" if ar_results[3]!="./gg"
      kibuvits_throw "test 7" if ar_results[4]!="../gg/.."
   end # Kibuvits_fs_selftests.test_array2path

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_rm_fr
      s_sys_tmp_folder=Kibuvits_os_codelets.get_tmp_folder_path
      s_main_folder=s_sys_tmp_folder+"/"+Kibuvits_GUID_generator.generate_GUID
      kibuvits_throw "test 0" if File.exists? s_main_folder
      Dir.mkdir(s_main_folder)
      kibuvits_throw "test 1" if !File.exists? s_main_folder
      Kibuvits_fs.chmod_recursive_secure_7(s_main_folder)
      Dir.mkdir(s_main_folder+"/xx7")
      Dir.mkdir(s_main_folder+"/xx8")

      s_fp_1=s_main_folder+"/xx7/x1.txt"
      str2file("Hi\nthere",s_fp_1)
      str2file("Hi\nthere X",s_main_folder+"/x2.txt")
      kibuvits_throw "test 2" if !File.exists? s_fp_1
      Kibuvits_fs.chmod_recursive_secure_7(s_main_folder)
      Kibuvits_fs.rm_fr(s_main_folder)
      kibuvits_throw "test 3" if File.exists? s_main_folder
   end # Kibuvits_fs_selftests.test_rm_fr

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_array2folders_sequential
      if !kibuvits_block_throws{Kibuvits_fs.array2folders_sequential(42,["aa"])}
         kibuvits_throw "test 1"
      end # if

      s_tmp_fldr=Kibuvits_os_codelets.get_tmp_folder_path
      s_tmp_fldr_unix=s_tmp_fldr

      # One is not able to do the tests, if the system's temporary
      # folder either does not exist or is not writable.
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(
      s_tmp_fldr,"is_directory,writable")
      if ht_filesystemtest_failures.length!=0
         s_msg=Kibuvits_fs.access_verification_results_to_string(
         ht_filesystemtest_failures)
         kibuvits_throw "test 2, "+s_msg+"\n"
      end # if

      if !kibuvits_block_throws{ Kibuvits_fs.array2folders_sequential(s_tmp_fldr,42)}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{ Kibuvits_fs.array2folders_sequential(s_tmp_fldr,["ff/g"])}
         kibuvits_throw "test 4"
      end # if

      s_tmp_aa=s_tmp_fldr_unix+"/aa"
      if !kibuvits_block_throws{ Kibuvits_fs.array2folders_sequential(s_tmp_fldr,["aa",""])}
         Kibuvits_fs.rm_fr(s_tmp_aa)
         kibuvits_throw "test 5"
      end # if
      Kibuvits_fs.rm_fr(s_tmp_aa)

      Kibuvits_fs.array2folders_sequential(s_tmp_fldr,["bb","cc"])

      s_pth0=s_tmp_fldr_unix+"/bb"
      s_testcreated_folder_path=s_pth0
      if !File.exists? s_pth0
         kibuvits_throw "test 6"
      end # if
      if !File.directory? s_pth0
         kibuvits_throw "test 7"
      end # if

      s_pth0=s_pth0+"/cc"
      if !File.exists? s_pth0
         Kibuvits_fs.rm_fr(s_testcreated_folder_path)
         kibuvits_throw "test 8"
      end # if
      if !File.directory? s_pth0
         Kibuvits_fs.rm_fr(s_testcreated_folder_path)
         kibuvits_throw "test 9"
      end # if
      #Dir.rmdir(s_testcreated_folder_path)
      Kibuvits_fs.rm_fr(s_testcreated_folder_path)
   end # Kibuvits_fs_selftests.test_array2folders_sequential

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_s_concat_files
      s_fp=KIBUVITS_HOME+"/src/dev_tools/selftests/data_for_selftests/kitty_1.txt"
      s_file_content=file2str(s_fp)
      ar=[s_fp,s_fp+$kibuvits_lc_emptystring,s_fp]
      s_x=Kibuvits_fs.s_concat_files(ar)
      s_2x=s_file_content+s_file_content+s_file_content
      kibuvits_throw "test 1" if s_2x!=s_x
   end # Kibuvits_fs_selftests.test_s_concat_files

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_b_not_suitable_to_be_a_file_path_t1
      msgcs=Kibuvits_msgc_stack.new

      msgcs.clear
      s_x="/x\n/f"
      b_x=Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1(s_x,msgcs)
      msgc=msgcs.last
      kibuvits_throw "test 1 msgcs.last=="+msgc.to_s if !b_x
      s_message_id=msgc.s_message_id
      kibuvits_throw "test 1a msgcs.last.s_message_id=="+s_message_id if s_message_id!="1"

      msgcs.clear
      s_x="   x"
      b_x=Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1(s_x,msgcs)
      msgc=msgcs.last
      kibuvits_throw "test 2 msgcs.last=="+msgc.to_s if !b_x
      s_message_id=msgc.s_message_id
      kibuvits_throw "test 2a msgcs.last.s_message_id=="+s_message_id if s_message_id!="2"

      msgcs.clear
      s_x="x  "
      b_x=Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1(s_x,msgcs)
      msgc=msgcs.last
      kibuvits_throw "test 3 msgcs.last=="+msgc.to_s if !b_x
      s_message_id=msgc.s_message_id
      kibuvits_throw "test 3a msgcs.last.s_message_id=="+s_message_id if s_message_id!="3"

      msgcs.clear
      s_x=".../x"
      b_x=Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1(s_x,msgcs)
      msgc=msgcs.last
      kibuvits_throw "test 4 msgcs.last=="+msgc.to_s if !b_x
      s_message_id=msgc.s_message_id
      kibuvits_throw "test 4a msgcs.last.s_message_id=="+s_message_id if s_message_id!="4"

      msgcs.clear
      s_x="x/.../"
      b_x=Kibuvits_fs.b_not_suitable_to_be_a_file_path_t1(s_x,msgcs)
      msgc=msgcs.last
      kibuvits_throw "test 5 msgcs.last=="+msgc.to_s if !b_x
      s_message_id=msgc.s_message_id
      kibuvits_throw "test 5a msgcs.last.s_message_id=="+s_message_id if s_message_id!="4"

   end # Kibuvits_fs_selftests.test_b_not_suitable_to_be_a_file_path_t1
   #-----------------------------------------------------------------------
   public
   def Kibuvits_fs_selftests.test_b_env_not_set_or_has_improper_path_t1
      s_environment_variable_name="KIBUVITS_SELFTESTS_TESTENV_1"
      s_or_ar_file_names=$kibuvits_lc_emptyarray
      s_or_ar_folder_names=$kibuvits_lc_emptyarray
      msgcs=Kibuvits_msgc_stack.new
      #----------------------------------------------
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name+" contains at least one space",msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 1 msgcs.to_s=="+msgcs.to_s if !b_throws
      msgcs.clear
      #----------------------------------------------
      s_environment_variable_name=s_environment_variable_name+"_that_does_not_exist"
      b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,
      s_or_ar_file_names,s_or_ar_folder_names)
      kibuvits_throw "test 2 msgcs.to_s=="+msgcs.to_s if !b_x
      kibuvits_throw "test 2a msgcs.length==0" if msgcs.length==0
      s_0=msgcs.last.s_message_id.to_s
      kibuvits_throw "test 2b msgcs.last.s_message_id.to_s=="+s_0 if s_0!="1"
      msgcs.clear
      #----------------------------------------------
      s_environment_variable_name="KIBUVITS_HOME"
      b_erase_krl_env=false
      if ENV["KIBUVITS_HOME"].to_s.length<2
         ENV["KIBUVITS_HOME"]=KIBUVITS_HOME
         b_erase_krl_env=true
      end # if
      b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,
      s_or_ar_file_names,s_or_ar_folder_names)
      kibuvits_throw "test 3 msgcs.to_s=="+msgcs.to_s if b_x
      kibuvits_throw "test 3a msgcs.length!=0 msgcs.to_s=="+msgcs.to_s if msgcs.length!=0
      msgcs.clear
      #----------------------------------------------
      s_fp_0=KIBUVITS_HOME+"/src/dev_tools/selftests"
      s_fp_1=KIBUVITS_HOME+"/src/dev_tools/selftests/data_for_selftests"
      s_fp_2=KIBUVITS_HOME+"/src/dev_tools/selftests/data_for_selftests/kitty_1.txt"
      #----------------------------------------------
      s_or_ar_file_names=[]
      s_or_ar_folder_names="src"
      b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,
      s_or_ar_file_names,s_or_ar_folder_names)
      kibuvits_throw "test 4 msgcs.to_s=="+msgcs.to_s if b_x
      kibuvits_throw "test 4a msgcs.length!=0 msgcs.to_s=="+msgcs.to_s if msgcs.length!=0
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names="src"
      s_or_ar_folder_names=[]
      b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,
      s_or_ar_file_names,s_or_ar_folder_names)
      kibuvits_throw "test 5 msgcs.to_s=="+msgcs.to_s if !b_x
      kibuvits_throw "test 5a msgcs.length==0" if msgcs.length==0
      s_0=msgcs.last.s_message_id.to_s
      kibuvits_throw "test 5b msgcs.last.s_message_id.to_s=="+s_0 if s_0!="5"
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names=["this_file_does_not_exist.txt"]
      s_or_ar_folder_names=[]
      b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,
      s_or_ar_file_names,s_or_ar_folder_names)
      kibuvits_throw "test 6 msgcs.to_s=="+msgcs.to_s if !b_x
      kibuvits_throw "test 6a msgcs.length==0" if msgcs.length==0
      s_0=msgcs.last.s_message_id.to_s
      kibuvits_throw "test 6b msgcs.last.s_message_id.to_s=="+s_0 if s_0!="4"
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names=[]
      s_or_ar_folder_names=["src","doc"]
      b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,
      s_or_ar_file_names,s_or_ar_folder_names)
      kibuvits_throw "test 7 msgcs.to_s=="+msgcs.to_s if b_x
      kibuvits_throw "test 7a msgcs.length==0" if msgcs.length!=0
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names="src/include/kibuvits_boot.rb"
      s_or_ar_folder_names="include"
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name,msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 8 " if b_throws
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names=[]
      s_or_ar_folder_names=["src/dev_tools/selftests"]
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name,msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 9 " if b_throws
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names="src/include/\nkibuvits_boot.rb"
      s_or_ar_folder_names=[]
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name,msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 10 " if !b_throws
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names=[]
      s_or_ar_folder_names=["src/dev_tools/self\ntests"]
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name,msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 11 " if !b_throws
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names=["src/include/kibuvits_boot.rb","////src//include//kibuvits_fs.rb"]
      s_or_ar_folder_names="src/dev_tools/selftests"
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name,msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 12a " if b_throws
      kibuvits_throw "test 12b msgcs.to_s=="+msgcs.to_s if b_x
      kibuvits_throw "test 12c msgcs.length==0" if msgcs.length!=0
      msgcs.clear
      #----------------------------------------------
      s_or_ar_file_names=["src/include/kibuvits_boot.rb","src/include/kibuvits_nonexistent.rb"]
      s_or_ar_folder_names="src/dev_tools/selftests"
      b_throws=false
      begin
         b_x=Kibuvits_fs.b_env_not_set_or_has_improper_path_t1(
         s_environment_variable_name,msgcs,
         s_or_ar_file_names,s_or_ar_folder_names)
      rescue Exception => e
         b_throws=true
      end # rescue
      kibuvits_throw "test 13a " if b_throws
      kibuvits_throw "test 13b msgcs.to_s=="+msgcs.to_s if !b_x
      kibuvits_throw "test 13c msgcs.length==0" if msgcs.length==0
      s_0=msgcs.last.s_message_id.to_s
      kibuvits_throw "test 13d msgcs.last.s_message_id.to_s=="+s_0 if s_0!="4"
      msgcs.clear
      #----------------------------------------------
      ENV["KIBUVITS_HOME"]=nil if b_erase_krl_env
      #----------------------------------------------
   end # Kibuvits_fs_selftests.test_b_env_not_set_or_has_improper_path_t1

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_ar_glob_locally_t1
      s_fp=KIBUVITS_HOME+"/src/include"
      s_fp_wd_1=Dir.getwd
      ar_x1=Dir.glob("*")
      ar_x3=Kibuvits_fs.ar_glob_locally_t1(s_fp,"*.rb")
      ar_x2=Dir.glob("*")
      s_fp_wd_2=Dir.getwd
      kibuvits_throw "test 1a" if ar_x1.size!=ar_x2.size
      kibuvits_throw "test 1b s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2 # to check that it has returned
      i_1=ar_x3.size
      kibuvits_throw "test 1c ar_x3.size=="+i_1.to_s if i_1==0
      ar_x1.clear; ar_x2.clear

      s_wd_bonnet=KIBUVITS_HOME+"/src/include/bonnet"

      ar_x4=[]+ar_x3
      ar_x3.clear
      ar_x3=Kibuvits_fs.ar_glob_locally_t1([s_fp,s_wd_bonnet],"*.rb")
      s_fp_wd_2=Dir.getwd
      i_1=ar_x3.size
      kibuvits_throw "test 2a ar_x3.size=="+i_1.to_s if ar_x3.size<=ar_x4.size
      kibuvits_throw "test 2b s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2

      ar_x4=[]+ar_x3
      ar_x3.clear
      ar_x3=Kibuvits_fs.ar_glob_locally_t1([s_fp,s_wd_bonnet],["*.rb","*.doc"])
      s_fp_wd_2=Dir.getwd
      i_1=ar_x3.size
      kibuvits_throw "test 3a ar_x3.size=="+i_1.to_s if ar_x3.size!=ar_x4.size
      kibuvits_throw "test 3b s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2

      ar_x3=Kibuvits_fs.ar_glob_locally_t1([s_fp,s_wd_bonnet],["*.rb","tm*"]) # tm* === "tmp"
      s_fp_wd_2=Dir.getwd
      kibuvits_throw "test 4a" if ar_x3.size<=ar_x4.size
      kibuvits_throw "test 4b s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2
      #--------------------
      s_fp=KIBUVITS_HOME+"/src/include"
      ar_or_s_glob_string="*"
      b_return_long_paths=true
      ar_exclude_dirs=[]

      ar_x_1=Kibuvits_fs.ar_glob_locally_t1(s_fp,ar_or_s_glob_string,
      b_return_long_paths,ar_exclude_dirs)
      ar_exclude_dirs<<(s_fp+"/bonnet")
      ar_exclude_dirs<<(s_fp+"/uhuu")
      ar_x_2=Kibuvits_fs.ar_glob_locally_t1(s_fp,ar_or_s_glob_string,
      b_return_long_paths,ar_exclude_dirs)
      i_len_1=ar_x_1.size
      i_len_2=ar_x_2.size
      msg="i_len_1=="+i_len_1.to_s+"  i_len_2=="+i_len_2.to_s
      kibuvits_throw "test 5a "+msg if (i_len_1-i_len_2)!=1
      #--------------------
      # The version, where the ar_exclude_dirs is
      # replaced by a function, is tested as
      # part of the ar_glob_recursively_t1(...)
      #--------------------
      ar_or_s_glob_string="*.rb"
      b_return_long_paths=true
      ar_x_1=Kibuvits_fs.ar_glob_locally_t1(s_fp,ar_or_s_glob_string,
      b_return_long_paths,ar_exclude_dirs)
      i_size_1=ar_x_1.size
      kibuvits_throw "test 6a i_size_1=="+i_size_1.to_s if i_size_1==0
      b_return_globbing_results=false
      ar_x_2=Kibuvits_fs.ar_glob_locally_t1(s_fp,ar_or_s_glob_string,
      b_return_long_paths,ar_exclude_dirs,b_return_globbing_results)
      i_size_2=ar_x_2.size
      kibuvits_throw "test 6b i_size_2=="+i_size_2.to_s if i_size_2!=0
   end # Kibuvits_fs_selftests.test_ar_glob_locally_t1

   #-----------------------------------------------------------------------
   public

   def Kibuvits_fs_selftests.test_ar_glob_recursively_t1
      # The s_fp_surfingfolder might be in
      # KIBUVITS_HOME+"/src/include/bonnet/tmp
      ar_fp_folders=Array.new
      s_fp_surfingfolder=Kibuvits_os_codelets.generate_tmp_file_absolute_path(
      "surfingfolder_","_tmp")
      s_fp_folder_1=s_fp_surfingfolder+"/ff1"
      ar_fp_folders<<s_fp_folder_1
      s_fp_folder_2=s_fp_surfingfolder+"/ff2"
      ar_fp_folders<<s_fp_folder_2
      s_fp_folder_2_1=s_fp_surfingfolder+"/ff2/ff1"
      ar_fp_folders<<s_fp_folder_2_1
      s_fp_folder_2_2=s_fp_surfingfolder+"/ff2/ff2"
      ar_fp_folders<<s_fp_folder_2_2
      cmd=""
      ar_fp_folders.each{|s_fp| cmd<<("mkdir -p "+s_fp+" ;")}
      func_rm_surfingfolder=lambda do
         if File.exist? s_fp_surfingfolder
            if s_fp_surfingfolder.match(/^[\/]tmp[\/]/)==nil
               kibuvits_throw("test 0a s_fp_surfingfolder=="+s_fp_surfingfolder+
               "\n GUID='ed880931-11fb-4849-b4c8-53437110ced7'\n\n")
            else
               cmd="rm -f -R "+s_fp_surfingfolder
               ht_stdstreams=kibuvits_sh(cmd)
               Kibuvits_shell.throw_if_stderr_has_content_t1(
               ht_stdstreams,"test 0b\n\n")
            end # if
         end # if
      end # func_rm_surfingfolder
      s_fp_orig=Dir.getwd
      rgx_filter_0=/.+/
      begin
         #---------------
         # The creation of temporary files and folders.
         ht_stdstreams=kibuvits_sh(cmd)
         Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,"test 0c")
         #----
         ar_fp_files=Array.new
         s_fp_file_2_1_f1=s_fp_folder_2_1+"/file1.txt"
         ar_fp_files<<s_fp_file_2_1_f1
         s_fp_file_1_f1=s_fp_folder_1+"/file1.txt"
         ar_fp_files<<s_fp_file_1_f1
         s_fp_file_1_f2=s_fp_folder_1+"/file2.txt"
         ar_fp_files<<s_fp_file_1_f2
         ar_fp_files.each{|s_fp| str2file("Test file.\nx="+rand(400).to_s,s_fp)}
         #-----------------------------
         s_fp_wd_1=Dir.getwd
         b_return_long_paths=true
         ar_x_all=Kibuvits_fs.ar_glob_recursively_t1(s_fp_surfingfolder,"*",
         rgx_filter_0,b_return_long_paths)
         i_ar_x_all_len=ar_x_all.size
         kibuvits_throw "test 1a ar_x_all.size == "+i_ar_x_all_len if i_ar_x_all_len!=7
         rgx_txt=/.+txt$/
         func_b_include=lambda do |x_key,x_value|
            b_out=false
            b_out=true if x_value.match(rgx_txt)!=nil
            return b_out
         end # func_b_include
         ar_x_txt=Kibuvits_ix.x_filter_t1(ar_x_all,func_b_include)
         i_ar_x_txt_len=ar_x_txt.size
         kibuvits_throw "test 1b ar_x_txt.size == "+i_ar_x_txt_len if i_ar_x_txt_len!=3
         #---------------
         s_fp_wd_1=Dir.getwd
         b_return_long_paths=true
         ar_x1=Kibuvits_fs.ar_glob_recursively_t1(s_fp_surfingfolder,"ff*",
         rgx_filter_0,b_return_long_paths)
         s_fp_wd_2=Dir.getwd
         kibuvits_throw "test 2a" if ar_x1.size!=ar_fp_folders.size
         kibuvits_throw "test 2b s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2 # to check that it has returned
         ar_x1.clear;
         b_return_long_paths=false
         ar_x1=Kibuvits_fs.ar_glob_recursively_t1(s_fp_surfingfolder,"ff*",
         rgx_filter_0,b_return_long_paths)
         s_fp_wd_2=Dir.getwd
         kibuvits_throw "test 2c" if ar_x1.size!=ar_fp_folders.size
         kibuvits_throw "test 2d s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2 # to check that it has returned
         ar_x1.clear;
         #---------------
      rescue Exception => e
         Dir.chdir(s_fp_orig)
         func_rm_surfingfolder.call
         raise e
      end # rescue
      Dir.chdir(s_fp_orig)
      func_rm_surfingfolder.call
   end # Kibuvits_fs_selftests.test_ar_glob_recursively_t1


   def Kibuvits_fs_selftests.test_ht_find_nonbroken_symlinks_recursively_t1
      s_fp_surfingfolder=Kibuvits_os_codelets.generate_tmp_file_absolute_path(
      "surfingfolder_","_tmp")
      cmd="mkdir "+s_fp_surfingfolder+
      " ; cp -f -R "+KIBUVITS_HOME+"/src/include/* "+s_fp_surfingfolder+"/ ;"
      s_fp_wd_orig=Dir.getwd
      func_rm_surfingfolder=lambda do
         Dir.chdir(s_fp_wd_orig)
         if File.exist? s_fp_surfingfolder
            if s_fp_surfingfolder.match(/^[\/]tmp[\/]/)==nil
               kibuvits_throw "test 0b s_fp_surfingfolder=="+s_fp_surfingfolder
            else
               cmd="rm -f -R "+s_fp_surfingfolder
               ht_stdstreams=kibuvits_sh(cmd)
               Kibuvits_shell.throw_if_stderr_has_content_t1(
               ht_stdstreams,"test 0b\n\n")
            end # if
         end # if
      end # func_rm_surfingfolder
      begin
         ht_stdstreams=kibuvits_sh(cmd)
         Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,"test 0a")
         #---------------
         Dir.chdir(s_fp_surfingfolder)
         s_fp_0=s_fp_surfingfolder+"/orig.txt"
         s_0="Welcome!\nOrigin GUID='01432827-6cd6-4321-b4c8-53437110ced7'"
         str2file(s_0,s_fp_0)
         cmd="ln -s ./orig.txt ./lllinK_1.txt ;"+
         "ln -s ./orig.txt ./lllinK_2.txt ;"+
         "cd ./bonnet; "+
         "ln -s ./../orig.txt ./lllinK_3.txt ; cd ./..;"+
         "ln -s ./this_file_does_not_exist.txt ./a_BroKen_linkK444444.txt ;"
         ht_stdstreams=kibuvits_sh(cmd)
         Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,"test 1a")
         #---------------
         ht_symlinks=Kibuvits_fs.ht_find_nonbroken_symlinks_recursively_t1(s_fp_surfingfolder)
         i_len=ht_symlinks.keys.size
         kibuvits_throw "test 1b i_len=="+i_len.to_s if i_len!=3
         #----
         s_fp_expected=s_fp_surfingfolder+"/lllinK_1.txt"
         if !ht_symlinks.has_key? s_fp_expected
            kibuvits_throw "test 1c ht_symlinks=="+ht_symlinks.to_s
         end # if
         s_fp_expected=s_fp_surfingfolder+"/lllinK_2.txt"
         if !ht_symlinks.has_key? s_fp_expected
            kibuvits_throw "test 1d ht_symlinks=="+ht_symlinks.to_s
         end # if
         s_fp_expected=s_fp_surfingfolder+"/bonnet/lllinK_3.txt"
         if !ht_symlinks.has_key? s_fp_expected
            kibuvits_throw "test 1e ht_symlinks=="+ht_symlinks.to_s
         end # if
      rescue Exception => e
         func_rm_surfingfolder.call
         raise e
      end # rescue
      func_rm_surfingfolder.call
   end # Kibuvits_fs_selftests.test_ht_find_nonbroken_symlinks_recursively_t1

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_b_files_that_exist_changed_after_last_check_t1
      s_fp_tmp=KIBUVITS_HOME+"/src/include/bonnet/tmp"
      s_fp_f1=s_fp_tmp+"/testfolder_1"
      s_fp_f1_1=s_fp_f1+"/testfolder_1_1"
      s_fp_file_1=s_fp_f1_1+"/testfile_1.txt"
      kibuvits_sh("mkdir -p "+s_fp_f1_1)
      s_file_content="demo"
      str2file(s_file_content,s_fp_file_1)
      i_cache_max_size=30*(10**6) # Roughly 10^6 1K-sized files per 1GiB
      if !File.exists? s_fp_file_1
         kibuvits_throw("test 1a, s_fp_file_1=="+s_fp_file_1.to_s+
         "\ne=="+e.to_s+
         "\nGUID='c136f539-4538-4d96-a5c8-53437110ced7'")
      end # if
      #-----------------------------
      begin
         # To generate the cache file path field in the Kibuvits_fs singleton.
         Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1,
         i_cache_max_size)
      rescue Exception => e
         kibuvits_throw("test 1b, e=="+e.to_s+
         "\nGUID='02e96014-70b6-4867-94c8-53437110ced7'")
      end # rescue
      #-----------------------------
      # There's some bug in Ruby API-s, why it is not possible to use a solution like
      # s_fp_cache=Kibuvits_fs.instance.instance_variable_get(
      # :s_b_files_that_exist_changed_after_last_check_t1_cache_fp)
      # The following line is manually copy-pasted.
      s_fp_cache=KIBUVITS_HOME+"/src/include/bonnet/tmp"+
      "/KRL_sys_Kibuvits_fs_b_files_that_exist_changed_after_last_check_t1_cache.txt"
      #-----------------------------
      if !File.exists? s_fp_cache
         kibuvits_throw("test 1c, s_fp_cache=="+s_fp_cache.to_s+
         "\ne=="+e.to_s+
         "\nGUID='6a886027-a988-44bd-a1c8-53437110ced7'")
      end # if
      File.delete(s_fp_cache)
      #-----------------------------
      if !Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1,i_cache_max_size)
         # Check 1 that creates the cache file
         kibuvits_throw("test 2a "+
         "\nGUID='c1feb017-5520-4bea-b3c8-53437110ced7'")
      end # if
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1,i_cache_max_size)
         # Check 2 that reads the cache file
         kibuvits_throw("test 2b "+
         "\nGUID='219f7e94-eb03-4095-b5c8-53437110ced7'")
      end # if
      sleep(2) # Seconds. File timestamps have 1s resolution.
      str2file(s_file_content,s_fp_file_1)
      if !Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1,i_cache_max_size)
         kibuvits_throw("test 2c "+
         "\nGUID='1b0d1413-a144-4b24-a2b8-53437110ced7'")
      end # if
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1,i_cache_max_size)
         kibuvits_throw("test 2d "+
         "\nGUID='232a8136-bc58-4192-82b8-53437110ced7'")
      end # if
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1,i_cache_max_size)
         kibuvits_throw("test 2e "+
         "\nGUID='45cd3fbc-585d-434c-85b8-53437110ced7'")
      end # if
      #------------
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_f1_1,i_cache_max_size)
         kibuvits_throw("test 3a "+
         "\ns_fp_file_1="+s_fp_f1_1+
         "\nGUID='446fe3b1-0c65-416d-81b8-53437110ced7'")
      end # if
      # argument change from folder 2 file, from s_fp_f1_1 to s_fp_file_1
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_file_1,i_cache_max_size)
         kibuvits_throw("test 3b "+
         "\ns_fp_file_1="+s_fp_file_1+
         "\nGUID='956075f1-ba07-4b03-a5b8-53437110ced7'")
      end # if
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_file_1,i_cache_max_size)
         kibuvits_throw("test 3c "+
         "\ns_fp_file_1="+s_fp_file_1+
         "\nGUID='22b3e124-27b2-4d2d-92b8-53437110ced7'")
      end # if
      if Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(s_fp_file_1,i_cache_max_size)
         kibuvits_throw("test 3d "+
         "\ns_fp_file_1="+s_fp_file_1+
         "\nGUID='7f95072b-9398-48cf-91b8-53437110ced7'")
      end # if
      #---------cleanup---start---------
      if File.exists? s_fp_f1
         if  s_fp_f1.reverse[0..11]=="1_redloftset"
            kibuvits_sh("rm -fr "+s_fp_f1)
         else
            kibuvits_throw("test cleanup_1a \n s_fp_f1 =="+s_fp_f1.to_s+
            "\nGUID='e0dffe5c-53cd-4663-b3b8-53437110ced7'")
         end # if
      else
         kibuvits_throw("test cleanup_1b \n s_fp_f1 =="+s_fp_f1.to_s+
         "\nGUID='a724c021-d686-4902-b4a8-53437110ced7'")
      end # if
      #--------
      if File.exists? s_fp_cache
         File.delete(s_fp_cache)
         if File.exists? s_fp_cache
            kibuvits_throw("test cleanup_1b \n s_fp_cache =="+s_fp_cache.to_s+
            "\nGUID='ee620f13-d094-4fc6-81a8-53437110ced7'")
         end # if
      else
         kibuvits_throw("test cleanup_1b \n s_fp_cache =="+s_fp_cache.to_s+
         "\nGUID='7ee9f336-52a6-417a-afa8-53437110ced7'")
      end # if
   end # Kibuvits_fs_selftests.test_b_files_that_exist_changed_after_last_check_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_fs_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_verify_access"
      kibuvits_testeval bn, "test_verify_access_v2"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_path2array"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_array2path"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_rm_fr"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_array2folders_sequential"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_s_concat_files"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_b_not_suitable_to_be_a_file_path_t1"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_b_env_not_set_or_has_improper_path_t1"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_ar_glob_locally_t1"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_ar_glob_recursively_t1"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_ht_find_nonbroken_symlinks_recursively_t1"
      kibuvits_testeval bn, "Kibuvits_fs_selftests.test_b_files_that_exist_changed_after_last_check_t1"
      return ar_msgs
   end # Kibuvits_fs_selftests.selftest

end # class Kibuvits_fs_selftests


#--------------------------------------------------------------------------

#==========================================================================
# puts Kibuvits_fs_selftests.selftest.to_s
# Kibuvits_fs_selftests.test_ar_glob_recursively_t1
# puts Kibuvits_fs_selftests.test_ar_glob_locally_t1.to_s
