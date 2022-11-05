#!/usr/bin/env ruby
#==========================================================================

if !defined? MMMV_DEVEL_TOOLS_HOME
   raise(Exception.new("The Ruby constant, MMMV_DEVEL_TOOLS_HOME, "+
   "should have been defined before the control flow reaches the "+
   "file, from where this exception is thrown."+
   "\nGUID=='6a238e15-dfa8-4ac5-b1b0-7002d0b16ed7'"))
   exit
end # if

require MMMV_DEVEL_TOOLS_HOME+"/src/bonnet/mmmv_devel_tools_initialization_t1.rb"
require MMMV_DEVEL_TOOLS_HOME+"/src/mmmv_devel_tools"+
"/breakdancemake/src/bonnet/breakdancemake_cl.rb"

#--------------------------------------------------------------------------

class C_mmmv_devel_tools_public_api_core

   def initialize
      @msgcs_=C_mmmv_devel_tools_global_singleton.msgcs()
   end # initialize

   #-----------------------------------------------------------------------
   private
   def run_renessaator_t1_b_run_on_unmodified_files(
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
      b_run_on_unmodified_files=true
      b_run_on_unmodified_files=Kibuvits_fs.b_files_that_exist_changed_after_last_check_t1(
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
      return b_run_on_unmodified_files
   end # run_renessaator_t1_b_run_on_unmodified_files

   public
   # Renessaator code generation blocks may include, depend, on
   # files that are not listed in the ar_or_s_file_paths.
   # Those files should be listed in the
   # ar_or_s_fp_additional_folders_and_files_to_watch_for_changes
   def run_renessaator_t1(ar_or_s_file_paths,
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], ar_or_s_file_paths
         kibuvits_typecheck bn, [Array,String], ar_or_s_fp_additional_folders_and_files_to_watch_for_changes
         kibuvits_typecheck bn, [Fixnum], i_observable_files_cache_max_size
         if ar_or_s_file_paths.class==String
            kibuvits_assert_string_min_length(bn,ar_or_s_file_paths,1)
         else  # ar_or_s_file_paths.class==Array
            kibuvits_typecheck_ar_content(bn,String,ar_or_s_file_paths)
            # Lazy-hack: one just hopes that
            # the string lengths in the ar_or_s_file_paths are OK.
         end # if
         ar_short=ar_or_s_fp_additional_folders_and_files_to_watch_for_changes
         if ar_short.class==String
            kibuvits_assert_string_min_length(bn,ar_short,1)
         else  # ar_short.class==Array
            kibuvits_typecheck_ar_content(bn,String,ar_short)
         end # if
      end # if
      b_run_on_unmodified_files=run_renessaator_t1_b_run_on_unmodified_files(
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
      if !defined? @s_run_renessaator_t1_cache_fp
         @s_run_renessaator_t1_cache_fp=MMMV_DEVEL_TOOLS_HOME+
         "/src/bonnet/tmp/mmmv_devel_tools_sys_run_renessaator_t1_cache.txt"
      end # if
      ht_cache=nil
      ar_fp_2_renessaator=nil
      ar_fp=Kibuvits_ix.normalize2array(ar_or_s_file_paths)
      if b_run_on_unmodified_files
         ar_fp_2_renessaator=ar_fp
      else
         if File.exists? @s_run_renessaator_t1_cache_fp
            s_progfte=file2str(@s_run_renessaator_t1_cache_fp)
            ht_cache=Kibuvits_ProgFTE.to_ht(s_progfte)
         else
            ht_cache=Hash.new
         end # if
         ar_fp_2_renessaator=Array.new
         ht_failures=Kibuvits_fs.verify_access(ar_fp,"readable,is_file")
         s_output_message_language="English"
         b_throw=false
         Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures,
         s_output_message_language, b_throw)
         s_mtime=nil
         ar_fp.each do |s_fp|
            s_mtime=File.mtime(s_fp).to_s
            if ht_cache.has_key? s_fp
               if s_mtime!=ht_cache[s_fp]
                  ar_fp_2_renessaator<<s_fp
               end # if
            else
               ar_fp_2_renessaator<<s_fp
            end # if
         end # loop
      end # if

      if ar_fp_2_renessaator.size==0
         # There's no point for letting the renessaator throw here.
         return
      end # if
      if !defined? @ob_renessaator_ui
         # One of the benefits for creating an instance of the Renessaator
         # over here in stead calling it from console is that this
         # way the startup of a new instance of ruby interpreter
         # is avoided and reparsing of a huge portion of the
         # Kibuvits Ruby Library is avoided.
         require(MMMV_DEVEL_TOOLS_HOME+
         "/src/mmmv_devel_tools/renessaator/src/bonnet/renessaator.rb")
         @ob_renessaator_ui=Renessaator_console_UI.new
      end # if
      #----------------------------------
      # "+" is used in stead of the "concat(...)" due to a Ruby memory corruption flaw
      ar_argv=["--files"]+ar_fp_2_renessaator
      #----------------------------------
      @ob_renessaator_ui.run_by_ar_argv(ar_argv,@msgcs_)
      #------------------------------------------------------
      if ht_cache==nil
         if File.exists? @s_run_renessaator_t1_cache_fp
            s_progfte=file2str(@s_run_renessaator_t1_cache_fp)
            ht_cache=Kibuvits_ProgFTE.to_ht(s_progfte)
         else
            ht_cache=Hash.new
         end # if
      end # if
      # The next line allows more than i_observable_files_cache_max_size files to be cached.
      ht_cache=Hash.new if i_observable_files_cache_max_size<ht_cache.keys.size
      s_mtime=nil
      ar_fp_2_renessaator.each do |s_fp|
         s_mtime=File.mtime(s_fp).to_s
         ht_cache[s_fp]=s_mtime
      end # loop
      s_progfte=Kibuvits_ProgFTE.from_ht(ht_cache)
      str2file(s_progfte,@s_run_renessaator_t1_cache_fp)
   end # run_renessaator_t1

   def C_mmmv_devel_tools_public_api_core.run_renessaator_t1(
      ar_or_s_file_paths,
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
      C_mmmv_devel_tools_public_api_core.instance.run_renessaator_t1(
      ar_or_s_file_paths,
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
   end # C_mmmv_devel_tools_public_api_core.run_renessaator_t1

   #-----------------------------------------------------------------------

   public

   def load_breakdancemake_if_not_already_loaded
      return if defined? @b_breakdancemake_loaded
      require(MMMV_DEVEL_TOOLS_HOME+
      "/src/mmmv_devel_tools/breakdancemake/src/bonnet/breakdancemake_cl.rb")
      @b_breakdancemake_loaded=true
   end # load_breakdancemake_if_not_already_loaded

   def C_mmmv_devel_tools_public_api_core.load_breakdancemake_if_not_already_loaded
      C_mmmv_devel_tools_public_api_core.instance.load_breakdancemake_if_not_already_loaded()
   end # C_mmmv_devel_tools_public_api_core.load_breakdancemake_if_not_already_loaded

   #-----------------------------------------------------------------------

   def run_breakdancemake_concat_t1(
      s_output_file_path,ar_or_s_input_file_paths,s_compress_mode)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_output_file_path
         kibuvits_typecheck bn, [Array,String], ar_or_s_input_file_paths
         kibuvits_typecheck bn, String, s_compress_mode
         kibuvits_assert_string_min_length(bn,s_output_file_path,1)
         if ar_or_s_input_file_paths.class==String
            kibuvits_assert_string_min_length(bn,ar_or_s_input_file_paths,1)
         else  # ar_or_s_input_file_paths.class==Array
            kibuvits_typecheck_ar_content(bn,String,ar_or_s_input_file_paths)
         end # if
      end # if
      load_breakdancemake_if_not_already_loaded()
      if !defined? @ob_breakdancemake_wrapperhack
         s_bdmcomponent_name="breakdancemake_bdmprojectdescriptor_"+
         "wrapping_hack_for_the_mmmv_devel_tools_singleton_1"
         @ob_breakdancemake_wrapperhack=Breakdancemake_bdmprojectdescriptor_base.new(s_bdmcomponent_name)
      end # if
      ar_fp=Kibuvits_ix.normalize2array(ar_or_s_input_file_paths)
      Breakdancemake.undeclare_all_bdmprojectdescriptors
      ht_config=Hash.new
      ht_config["ar_paths_of_concatenable_files"]=ar_fp
      ht_config["s_concatenation_output_file_path"]=s_output_file_path
      ht_concat_t1=@ob_breakdancemake_wrapperhack.ht_configurations
      ht_concat_t1.clear # should I forget to do it outside of this func
      s_cl_concat_t1="concat_t1"
      ht_concat_t1[s_cl_concat_t1]=ht_config
      ar_argv=[s_cl_concat_t1]
      ar_argv<<($kibuvits_lc_minusminus+s_compress_mode)
      Breakdancemake.declare_bdmcomponent(@ob_breakdancemake_wrapperhack)
      Breakdancemake.run(ar_argv)
      Breakdancemake.undeclare_all_bdmprojectdescriptors
      ht_concat_t1.clear
   end # run_breakdancemake_concat_t1

   def C_mmmv_devel_tools_public_api_core.run_breakdancemake_concat_t1(
      s_output_file_path,ar_or_s_input_file_paths,s_compress_mode)
      C_mmmv_devel_tools_public_api_core.instance.run_breakdancemake_concat_t1(
      s_output_file_path,ar_or_s_input_file_paths,s_compress_mode)
   end # C_mmmv_devel_tools_public_api_core.run_breakdancemake_concat_t1

   #-----------------------------------------------------------------------

   def get_config(s_config_ht_key)
      #--------
      bn=binding()
      kibuvits_typecheck bn, String, s_config_ht_key
      #--------
      ht_config=C_mmmv_devel_tools_global_singleton.ht_global_configuration
      s_out=ht_config[s_config_ht_key]
      if s_out==nil
         kibuvits_throw("\nGUID=='1b936255-accf-48a9-b8a0-7002d0b16ed7'\n\n")
      end # if
      return s_out
   end # get_config

   def C_mmmv_devel_tools_public_api_core.get_config(s_config_ht_key)
      s_out=C_mmmv_devel_tools_public_api_core.instance.get_config(s_config_ht_key)
      return s_out
   end # C_mmmv_devel_tools_public_api_core.get_config

   include Singleton
end # class C_mmmv_devel_tools_public_api_core


#==========================================================================

