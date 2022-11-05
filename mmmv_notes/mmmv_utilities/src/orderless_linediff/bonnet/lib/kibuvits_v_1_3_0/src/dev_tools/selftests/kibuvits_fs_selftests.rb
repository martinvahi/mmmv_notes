#!/opt/ruby/bin/ruby -Ku
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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_msgc.rb"
   require  "kibuvits_fs.rb"
end # if
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
      if kibuvits_block_throws{Kibuvits_fs.verify_access(["x","s"],"is_file")}
         kibuvits_throw "test 5"
      end # if
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

      ht_failures=Kibuvits_fs.verify_access(s_tmp_folder_path,"is_file")
      kibuvits_throw "test 20" if ht_failures.length!=1
      ar_failures=ht_failures[s_tmp_folder_path]
      ht_failure=ar_failures[0]
      kibuvits_throw "test 21" if ht_failure['command']!="is_file"
      kibuvits_throw "test 22" if !ht_failure['msgc'].b_failure


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
   end # Kibuvits_fs_selftests.test_ar_glob_locally_t1

   #-----------------------------------------------------------------------

   def Kibuvits_fs_selftests.test_ar_glob_recursively_t1
      s_fp=KIBUVITS_HOME+"/src/dev_tools/tests_of_rubylang"
      s_fp_wd_1=Dir.getwd
      s_globstring_0="*.rb"
      Dir.chdir(s_fp)
      ar_x1=Dir.glob(s_globstring_0)
      Dir.chdir(s_fp_wd_1)
      b_return_long_paths=false
      ar_x2=Kibuvits_fs.ar_glob_recursively_t1(s_fp,"*.rb",b_return_long_paths)
      s_fp_wd_2=Dir.getwd
      kibuvits_throw "test 1a" if ar_x1.size!=ar_x2.size
      kibuvits_throw "test 1b" if ar_x1.size==0
      ht_x=Hash.new
      ar_x2.each {|x| ht_x[x]=x; }
      kibuvits_throw "test 1c ar_x1[0]=="+ar_x1[0] if !ht_x.has_key?ar_x1[0]
      kibuvits_throw "test 1d s_fp_wd_2=="+s_fp_wd_2.to_s if s_fp_wd_1!=s_fp_wd_2 # to check that it has returned
      ar_x1.clear; ar_x2.clear; ht_x.clear

      s_fp=KIBUVITS_HOME+"/src/include"
      s_globstring="*.rb"
      ar_x1=Dir.glob(s_fp+"/"+s_globstring)
      ar_x2=Kibuvits_fs.ar_glob_recursively_t1(s_fp,s_globstring,b_return_long_paths)
      kibuvits_throw "test 2a" if ar_x2.size<=ar_x1.size

      #puts Kibuvits_fs.ar_glob_recursively_t1("/home/ts2/tmp","*.txt").to_s
   end # Kibuvits_fs_selftests.test_ar_glob_recursively_t1

   #-----------------------------------------------------------------------
   public
   def Kibuvits_fs_selftests.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_verify_access"
      kibuvits_testeval binding(), "test_verify_access_v2"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_path2array"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_array2path"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_rm_fr"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_array2folders_sequential"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_s_concat_files"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_b_not_suitable_to_be_a_file_path_t1"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_b_env_not_set_or_has_improper_path_t1"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_ar_glob_locally_t1"
      kibuvits_testeval binding(), "Kibuvits_fs_selftests.test_ar_glob_recursively_t1"
      return ar_msgs
   end # Kibuvits_fs_selftests.selftest

end # class Kibuvits_fs_selftests


#--------------------------------------------------------------------------

#==========================================================================
#ar=Kibuvits_fs_selftests.selftest
# Kibuvits_fs_selftests.test_rm_fr
#ar.each{|s| puts s}
