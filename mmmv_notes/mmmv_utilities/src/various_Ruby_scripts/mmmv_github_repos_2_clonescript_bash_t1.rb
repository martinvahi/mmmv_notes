#!/usr/bin/env ruby
#==========================================================================
# This file is in the public domain.
# Initial author: Martin.Vahi@softf1.com
# Tested with Ruby version 2.5.1p57 on Linux.
#--------------------------------------------------------------------------
$s_doc_github_repos_2_clonescript_bash_t1_s=<<DESCRIPTION
#
# A video introduction to this script MIGHT be available from
#
#     https://longterm.softf1.com/documentation_fragments/2018/2018_12_18_GitHub_Clonescript_Generator_demo_01.webm
#
# It is an extra simplistic script that reads in
# the file named "repos" from the working directory and
# creates a file "clonescript.bash" to the working directory.
# The file "repos" is expected to contain lines like
#
#     "git_url": "git://github.com/martinvahi/mmmv_devel_tools.git",
#
# and it is expected to be created by using the wget at
# the GitHub API like
#
#     wget https://api.github.com/users/martinvahi/repos
#
# but this Ruby script can do the wget part automatically, 
# if given the GitHub user account URL 
# as the 1. console argument. An example:
#
#     <file path to this script> https://github.com/martinvahi
#
# Optionally the espeak speech synthesis program is used 
# for some messages, provided that it is available on the PATH.
# The use of the speech synthesis can be turned off by setting the
#
#      @b_config_use_speech_synthesis=false
#
# at the constructor of the only class that has been 
# declared at this Ruby script.
#
#
# COMMAND_LINE_ARGS :== <GitHub user account URL> | HELP | T0 | CLEAR_CMDS 
#              HELP :== "help" | "-?" | "-h"
#                T0 :== "test_0" | t0
#        CLEAR_CMDS :== CLEAR | DELETE_CLONINGSCRIPT | DELETE_REPOS
#             CLEAR :== "clear" | "cl"  # deletes files 
#                                       # "repos" and "cloningscript.bash"
#  DELETE_CLONINGSCRIPT :== "delete_cloningscript" | "clc"
#          DELETE_REPOS :== "delete_repos" | "clr"
#
#
DESCRIPTION
$s_doc_github_repos_2_clonescript_bash_t1_s.gsub!(/^[#]/," ") # because src formatter can't handle heredoc properly
#--------------------------------------------------------------------------

require "thread"

class GitHub_repos_2_clonescript_bash_t1

   # According to tests with Ruby version 2.5.1p57
   # a Mutex-protected region can NOT be re-entered by the same thread and
   # a Monitor-protected region CAN be re-entered by the same thread.
   @@mx_speech_synthesis=Mutex.new  # static variable
   @@mx_repos_file_write=Mutex.new  # static variable


   def initialize
      # A nice thing about the constructor is that
      # it is guaranteed to have only a single thread
      # per instance entering it. This code depends on that assumption.
      @s_lc_2devnull=" 2> /dev/null ".freeze
      #------------------------------------------------------
      @b_use_speechless_throw_mode=true # a quirk to reduce code
      # If the previous line ==false,
      # then the next line may enter infinite recursion.
      @b_espeak_available=(!b_is_missing_from_the_path_01("espeak"))
      @b_use_speechless_throw_mode=false#regardless of the previous line outcome
      #-----------------
      @ar_argv=Array.new # allows override and autoassignment at test modes
      i_len=ARGV.size
      i_len.times{|i| @ar_argv<<ARGV[i]}
      #-----------------
      @ht_argv_help_options=Hash.new
      @ht_argv_help_options["-?"]=42
      @ht_argv_help_options["-h"]=42
      @ht_argv_help_options["h"]=42
      @ht_argv_help_options["--help"]=42
      @ht_argv_help_options["-help"]=42
      @ht_argv_help_options["help"]=42
      @ht_argv_help_options["--abi"]=42
      @ht_argv_help_options["-abi"]=42
      @ht_argv_help_options["abi"]=42
      @ht_argv_help_options["--apua"]=42
      @ht_argv_help_options["-apua"]=42
      @ht_argv_help_options["apua"]=42
      #----config---start------------------------------------
      @b_config_use_speech_synthesis=true
   end # initialize

   private

   def speak_if_possible(s_text,s_suffix_2_print_without_pronounciation="")
      cl_0=s_text.class
      if cl_0!=String
         @b_use_speechless_throw_mode=true # to break infinite recursion
         angervaks_throw("s_text.class=="+cl_0.to_s+"\n"+
         "GUID=='b2960a20-7e4b-47a7-9151-02726021c2e7'")
      end # if
      #--------
      cl_1=s_suffix_2_print_without_pronounciation.class
      if cl_1!=String
         @b_use_speechless_throw_mode=true # to break infinite recursion
         angervaks_throw("s_suffix_2_print_without_pronounciation.class=="+
         cl_1.to_s+"\n"+
         "GUID=='3ff251ce-b0ae-4e44-8151-02726021c2e7'")
      end # if
      #--------
      @@mx_speech_synthesis.synchronize{
         #--------
         puts(s_text+s_suffix_2_print_without_pronounciation+"\n")
         #----
         if @b_config_use_speech_synthesis
            if @b_espeak_available
               b_0=@b_use_speechless_throw_mode
               @b_use_speechless_throw_mode=true
               exc_angervaks_sh("nice -n2 espeak \""+
               s_text.gsub(/([\$^\/\\"';^%()\[\]\{\}|-]|[+]|[*])+/," ")+
               "\""+@s_lc_2devnull)
               @b_use_speechless_throw_mode=b_0
            end # if
         end # if
      } # synchronize
   end # speak_if_possible

   def angervaks_throw(s_in,s_optional_guid_candidate=nil)
      if !@b_use_speechless_throw_mode
         puts "\n"
         speak_if_possible("Failure. Script aborted.")
         puts "\n"
      end # if
      #----------------------------
      s_err="\n\n"+s_in+"\n"
      if s_optional_guid_candidate.class==String # !=NilClass
         s_err<<("GUID=='"+s_optional_guid_candidate+"'\n")
      end # if
      s_err<<"GUID=='0e5d314d-d330-408f-8551-02726021c2e7'\n\n"
      raise(Exception.new(s_err))
   end # angervaks_throw


   def exc_angervaks_sh(s_cmd)
      begin
         # Kernel.system(...) return values:
         #     true  on success, e.g. program returns 0 as execution status
         #     false on successfully started program that
         #              returns nonzero execution status
         #     nil   on command that could not be executed
         x_success=system(s_cmd)
         if x_success!=true
            angervaks_throw("Shell execution failed. \n"+
            "The command line was:\n"+s_cmd,
            "dca0b816-2785-40db-b351-02726021c2e7")
         end # if
      rescue Exception=>e
         angervaks_throw("Shell execution failed.\n"+
         "The command line was:\n"+s_cmd+"\n"+"e.to_s=="+e.to_s,
         "75b67903-e14a-414e-9151-02726021c2e7")
      end # try-catch
   end # exc_angervaks_sh


   # The general idea:
   #
   #     bash -c "which <s_console_application_name>"
   #
   def b_is_missing_from_the_path_01(s_console_application_name)
      #------------------------
      s_0=s_console_application_name.gsub(/[\s\n\r\t]+/,"")
      if s_0.size!=s_console_application_name.size
         angervaks_throw("This function implementation does not allow \n"+
         "spaces or tabs at the console application name.\n"+
         "GUID=='9806f112-94a5-409d-8151-02726021c2e7'")
      end # if
      #------------------------
      b_missing_from_path=false
      begin
         exc_angervaks_sh("which "+s_console_application_name+
         " > /dev/null "+@s_lc_2devnull)
      rescue Exception=>e
         b_missing_from_path=true
      end # try-catch
      return b_missing_from_path
   end # b_is_missing_from_the_path_01


   def exc_wget_repos_if_needed(ht_opmem)
      s_fp_repos=ht_opmem["s_fp_repos"]
      if File.exists? s_fp_repos
         if File.directory? s_fp_repos
            angervaks_throw("The \n\n"+s_fp_repos+"\n\n"+
            "exists, but it is a folder. \n"+
            "It is expected to be a file.\n"+
            "GUID=='5ed206d2-c78f-4357-9351-02726021c2e7'")
         end # if
         return
      end # if
      if @ar_argv.size==0
         angervaks_throw("The file \n\n"+s_fp_repos+"\n\n"+
         "is missing. It MIGHT be auto-created by \n"+
         "giving the GitHub user account URL as \n"+
         "the first console argument of this Ruby script.\n"+
         "An example of a valid URL:\n"+
         "\n"+
         "    https://github.com/martinvahi \n"+
         "\n"+
         "GUID=='59e69323-e303-43d0-b351-02726021c2e7'")
      end  # if
      #----------------------------------------------------------
      #     https://github.com/martinvahi
      #     -->
      #     wget https://api.github.com/users/martinvahi/repos
      s_account_url_candidate=@ar_argv[0].to_s
      rgx_0=/^http[s]?:[\/][\/]?github[.]com[\/]+[^\s\/]+[\/]*$/
      md=s_account_url_candidate.match(rgx_0)
      if md==nil
         angervaks_throw("The optional 1. console argument \n"+
         "is expected to be either missing or \n"+
         "a GitHub user account, but it was \n"+
         s_account_url_candidate+"\n"+
         "GUID=='f1cd96e9-a53e-4335-a351-02726021c2e7'")
      end # if
      s_account_url=s_account_url_candidate.sub(/[\/]+$/,"")
      s_0=s_account_url.reverse
      s_1=s_0[0..(s_0.index("/")-1)]
      s_username=s_1.reverse
      #--------
      s_api_url="https://api.github.com/users/"+s_username+"/repos"
      s_download_cmd="nice -n5 wget "+s_api_url+@s_lc_2devnull
      #----------------------------------------------------------
      if b_is_missing_from_the_path_01("wget")
         if b_is_missing_from_the_path_01("curl")
            angervaks_throw("It seems that both of the programs, \n"+
            "the wget and the curl, are missing from the PATH.\n"+
            "Failed to auto-create the \n\n"+s_fp_repos+"\n\n"+
            "GUID=='e6d66555-ae3f-4817-a351-02726021c2e7'")
         else
            s_download_cmd="nice -n5 curl "+s_api_url+
            " > "+s_fp_repos+@s_lc_2devnull
         end # if
      end # if
      @@mx_repos_file_write.synchronize{
         ob_thread_0=Thread.new{
            # This thread is just to save some time.
            # The idea is that while the text is being
            # spoken, the wget can work in the background,
            # saving about one second of wall time.
            speak_if_possible("Downloading info about repositories",
            ": "+s_account_url)
         }
         exc_angervaks_sh(s_download_cmd)
         i_max_n_of_seconds_to_wait_4_the_thread=30
         ob_thread_0.join(i_max_n_of_seconds_to_wait_4_the_thread)
      } # synchronize
   end # exc_wget_repos_if_needed


   def exc_verify_file_existence_01(ht_opmem)
      s_fp_repos=ht_opmem["s_fp_repos"]
      s_fp_clonescript=ht_opmem["s_fp_clonescript"]
      #--------
      exc_wget_repos_if_needed(ht_opmem)
      if !File.exists? s_fp_repos
         angervaks_throw("The file \n\n"+s_fp_repos+"\n\n"+
         "is missing.\n"+
         "GUID=='4807922d-c10a-462b-a251-02726021c2e7'")
      end # if
      if File.exists? s_fp_clonescript
         angervaks_throw("The file \n"+s_fp_clonescript+
         "\n already exists.\n"+
         "GUID=='f490fb51-b9ef-4605-9241-02726021c2e7'")
      end # if
   end # exc_verify_file_existence_01


   def run_exc_parse_s_repos_01(ht_opmem)
      s_repos=ht_opmem["s_repos"]
      s_fp_repos=ht_opmem["s_fp_repos"]
      #--------------------------------------
      # "git_url": "git://github.com/martinvahi/mmmv_devel_tools.git",
      rgx_0=/^[\s]+["]git_url["][:].+$/
      rgx_1=/^[\s]+["]git_url["][:] "/
      rgx_2=/["][,][\s]*$/
      ar_matches=s_repos.scan(rgx_0)
      ar_s_giturl=Array.new
      s_0=nil
      s_1=nil
      s_lc_0=""
      ar_matches.each do |s_match|
         s_0=s_match.sub(rgx_1,s_lc_0)
         if s_0==s_match
            angervaks_throw("repos file format mismatch.\n"+
            "File path:\n\n"+s_fp_repos+"\n\n"+
            "s_0=="+s_0+"\n"+
            "GUID=='9d465c1d-8ecc-46e4-9341-02726021c2e7'")
         end # if
         #--------
         s_1=s_0.sub(rgx_2,s_lc_0)
         if s_1==s_0
            angervaks_throw("repos file format mismatch.\n"+
            "File path:\n\n"+s_fp_repos+"\n\n"+
            "s_1=="+s_1+"\n"+
            "GUID=='ad3e843f-8137-43f0-9241-02726021c2e7'")
         end # if
         ar_s_giturl<<s_1
      end # loop
      #--------
      ht_opmem["ar_s_giturl"]=ar_s_giturl
   end # run_exc_parse_s_repos_01

   def run_s_generate_clonescript(ht_opmem)
      ar_s_giturl=ht_opmem["ar_s_giturl"]
      s_0="#/usr/bin/env bash \n#"
      s_0<<("="*74+"\n")
      #--------
      func_s_precede_with_0_if_needed=lambda do |i|
         if i.class!=Integer
            angervaks_throw("GUID=='b6e43a3f-ff99-4d1b-9341-02726021c2e7'")
         end # if
         if i<0
            angervaks_throw("GUID=='78093f2b-b4b1-4a3a-a241-02726021c2e7'")
         end # if
         s_out=i.to_s
         s_out=("0"+i.to_s) if i<10
         return s_out
      end # func_s_precede_with_0_if_needed
      func_s_format_t1=lambda do |i|
         s_out=func_s_precede_with_0_if_needed.call(i)+"_"
         return s_out
      end # func_s_format_t1
      #----
      ob_time=Time.now
      s_0<<"#Script generation timestamp: "
      s_0<<(ob_time.year.to_s+"_")
      s_0<<func_s_format_t1.call(ob_time.month)
      s_0<<func_s_format_t1.call(ob_time.day)
      s_0<<func_s_format_t1.call(ob_time.hour)
      s_0<<func_s_format_t1.call(ob_time.min)
      s_0<<func_s_format_t1.call(ob_time.sec)
      s_0<<(ob_time.nsec.to_s+"\n#")
      s_0<<("-"*74+"\n\n")
      #--------
      s_lc_0="\n"
      s_prefix="nice -n15 git clone --recursive "
      ar_s_giturl.each do |s_giturl|
         s_0<<(s_prefix+s_giturl+s_lc_0)
      end # loop
      s_0<<"\n"
      #--------
      s_clonescript=s_0
      ht_opmem["s_clonescript"]=s_clonescript
   end # run_s_generate_clonescript


   def ht_run_init_opmem
      ht=Hash.new
      s_fp_wd=Dir.getwd
      ht["s_fp_wd"]=s_fp_wd
      ht["s_fp_repos"]=s_fp_wd+"/repos"
      ht["s_fp_clonescript"]=s_fp_wd+"/clonescript.bash"
      return ht
   end # ht_run_init_opmem


   def run_handle_some_of_the_command_line_args_and_exit_if_needed(ht_opmem)
      i_n_of_console_arguments=@ar_argv.size
      return if i_n_of_console_arguments==0
      if i_n_of_console_arguments!=1
         angervaks_throw("At most 1 command line argument is accepted.\n"+
         "The optional 1. command line argument \n"+
         "should be either a GitHub user account URL or \n"+
         "\"help\" without the quotation marks.\n"+
         "GUID=='b72a9017-4cc4-4e26-b141-02726021c2e7'")
      end # if
      s_argv_0=@ar_argv[0].to_s
      if @ht_argv_help_options.has_key? s_argv_0
         puts $s_doc_github_repos_2_clonescript_bash_t1_s
         exit(0)
      end # if
      #-----------------------------------------
      s_fp_repos=ht_opmem["s_fp_repos"]
      s_fp_clonescript=ht_opmem["s_fp_clonescript"]
      #--------
      func_del_file_if_exists=lambda do |s_fp|
         if File.exists? s_fp
            if File.directory? s_fp
               angervaks_throw("Directory found, but a file expected.\n"+
               "s_fp==\n"+
               s_fp+"\n"+
               "GUID=='a79b954d-d93c-4efd-9341-02726021c2e7'")
            end # if
            File.delete s_fp
            if File.exists? s_fp
               angervaks_throw("File deletion failed.\n"+
               "s_fp==\n"+
               s_fp+"\n"+
               "GUID=='637aaa3f-7684-4aea-b441-02726021c2e7'")
            end # if
         end # if
      end # func_del_file_if_exists
      func_del_clonescript_if_exists=lambda do
         func_del_file_if_exists.call(s_fp_clonescript)
      end # func_del_clonescript_if_exists
      func_del_repos_if_exists=lambda do
         func_del_file_if_exists.call(s_fp_repos)
      end # func_del_repos_if_exists
      #-----------------------------------------
      if (s_argv_0=="t0") || (s_argv_0=="test_0")
         @ar_argv[0]="https://github.com/martinvahi"
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
      end # if
      if (s_argv_0=="clear") || (s_argv_0=="c")
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
         exit(0)
      end # if
      if (s_argv_0=="delete_cloningscript") || (s_argv_0=="clc")
         func_del_clonescript_if_exists.call
         exit(0)
      end # if
      if (s_argv_0=="delete_repos") || (s_argv_0=="clr")
         func_del_repos_if_exists.call
         exit(0)
      end # if
   end # run_handle_some_of_the_command_line_args_and_exit_if_needed

   public

   def run
      ht_opmem=ht_run_init_opmem
      run_handle_some_of_the_command_line_args_and_exit_if_needed(ht_opmem)
      puts "\n"
      #------------------------------------
      exc_verify_file_existence_01(ht_opmem)
      s_fp_repos=ht_opmem["s_fp_repos"]
      s_repos=IO.read(s_fp_repos)
      ht_opmem["s_repos"]=s_repos
      run_exc_parse_s_repos_01(ht_opmem)
      run_s_generate_clonescript(ht_opmem)
      #--------
      s_fp_clonescript=ht_opmem["s_fp_clonescript"]
      s_clonescript=ht_opmem["s_clonescript"]
      #puts s_clonescript
      IO.write(s_fp_clonescript,s_clonescript)
      if !File.exists? s_fp_clonescript
         angervaks_throw("The file \n"+s_fp_clonescript+
         "\n does not exists.\n"+
         "GUID=='7d63d94e-0666-44f4-b141-02726021c2e7'")
      end # if
      File.chmod(0700,s_fp_clonescript)
      File.chmod(0600,s_fp_repos)
      if !File.exists? s_fp_clonescript
         angervaks_throw("The file \n"+s_fp_clonescript+
         "\n does not exists.\n"+
         "GUID=='1f4a5d81-75e8-482b-a241-02726021c2e7'")
      end # if
      speak_if_possible("Cloning script generated.")
      #------------------------------------
      puts "\n"
   end # run

end # class GitHub_repos_2_clonescript_bash_t1

GitHub_repos_2_clonescript_bash_t1.new.run

#==========================================================================

