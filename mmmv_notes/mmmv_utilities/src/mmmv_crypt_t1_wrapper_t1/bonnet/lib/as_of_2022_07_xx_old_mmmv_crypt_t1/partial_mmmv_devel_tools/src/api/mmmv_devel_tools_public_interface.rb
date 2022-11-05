#!/usr/bin/env ruby
#==========================================================================
=begin

  This file is meant to be included/required only by projects that 
  depend on mmmv_devel_tools, but that are part of the mmmv_devel_tools
  or are part of a demo code that demonstrates the use of 
  mmmv_devel_tools components.

=end
#==========================================================================
if !defined? MMMV_DEVEL_TOOLS_HOME
   require 'pathname'
   ob_pth0=Pathname.new(__FILE__).realpath.parent
   MMMV_DEVEL_TOOLS_HOME=ob_pth0.parent.parent.to_s.freeze
end # if
require MMMV_DEVEL_TOOLS_HOME+"/src/bonnet/api_core/mmmv_devel_tools_public_api_core.rb"
require MMMV_DEVEL_TOOLS_HOME+"/src/bonnet/api_core/mmmv_devel_tools_info.rb"

#--------------------------------------------------------------------------

# Public Ruby interface to the mmmv_devel_tools.
class C_mmmv_devel_tools
   # The main purpose of this class is to provide
   # a clutter free, or, at least with a reduced amount of clutter,
   # Ruby interface to the mmmv_devel_tools.
   # Otherwise the mmmv_devel_tools_public_api_core could
   # be used directly and client code might directly
   # call the public methods of the C_mmmv_devel_tools_global_singleton.

   def initialize()
   end # initialize

   def C_mmmv_devel_tools.msgcs()
      msgcs=C_mmmv_devel_tools_global_singleton.msgcs()
      return msgcs
   end # C_mmmv_devel_tools.msgcs()

   def C_mmmv_devel_tools.s_configuration_summary()
      s_out=C_mmmv_devel_tools_global_singleton.s_configuration_summary()
      return s_out
   end # C_mmmv_devel_tools.s_configuration_summary

   def C_mmmv_devel_tools.ht_global_configuration
      ht_out=C_mmmv_devel_tools_global_singleton.ht_global_configuration
      return ht_out
   end # C_mmmv_devel_tools.ht_global_configuration

   def C_mmmv_devel_tools.s_config_hash_t1
      s_out=C_mmmv_devel_tools_global_singleton.s_config_hash_t1
      return s_out
   end # C_mmmv_devel_tools.s_config_hash_t1

   def C_mmmv_devel_tools.run_renessaator_t1(
      ar_or_s_file_paths,
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
      C_mmmv_devel_tools_public_api_core.run_renessaator_t1(
      ar_or_s_file_paths,
      ar_or_s_fp_additional_folders_and_files_to_watch_for_changes,
      i_observable_files_cache_max_size)
   end # C_mmmv_devel_tools.run_renessaator_t1

   # s_compress_mode inSet {"yui_compressor_t1","plain"}
   def C_mmmv_devel_tools.run_breakdancemake_concat_t1(
      s_output_file_path,ar_or_s_input_file_paths,s_compress_mode)
      C_mmmv_devel_tools_public_api_core.run_breakdancemake_concat_t1(
      s_output_file_path,ar_or_s_input_file_paths,s_compress_mode)
   end # C_mmmv_devel_tools.run_breakdancemake_concat_t1

   # Sample input:
   # "s_GUID_trace_errorstack_file_path"
   def C_mmmv_devel_tools.get_config(s_config_key)
      if !defined? @@ob_C_mmmv_devel_tools_info
         @@ob_C_mmmv_devel_tools_info=C_mmmv_devel_tools_info.new
      end # if
      s_out=@@ob_C_mmmv_devel_tools_info.get_config(s_config_key)
      return s_out
   end # C_mmmv_devel_tools.get_config


   def C_mmmv_devel_tools.write_exception_text_2_GUIDtrace_errorstack_if_possible_t1(ob_exc)
      begin
         s_fp_errstack=C_mmmv_devel_tools_public_api_core.get_config("s_GUID_trace_errorstack_file_path")
         return if ((s_fp_errstack==nil)||(s_fp_errstack==$kibuvits_lc_emptystring))
         s_msg==ob_exc.to_s
         str2file(s_msg,s_fp_errstack)
      rescue Exception => e
         puts e.to_s
         # This function already processes
         # thrown exceptions. Adding a new one
         # only clutters up exception stack.
      end # rescue
   end # C_mmmv_devel_tools.write_exception_text_2_GUIDtrace_errorstack_if_possible_t1


end # class C_mmmv_devel_tools


#==========================================================================

