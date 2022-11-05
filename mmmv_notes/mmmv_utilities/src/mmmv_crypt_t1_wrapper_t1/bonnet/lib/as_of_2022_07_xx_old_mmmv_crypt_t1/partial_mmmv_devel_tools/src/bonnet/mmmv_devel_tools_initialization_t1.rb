#!/usr/bin/env ruby
#==========================================================================

# The reason, why the following if-else blocks are not within a function
# is that the Ruby interpreter requires the constant initialization to be
# in the global scope. That does not stop the programmers to try to
# reinitialize the constants, like
#  A_CAT="Miisu"
#  A_CAT="Tom"
# , but, those are the rules.

if !defined? MMMV_DEVEL_TOOLS_HOME
   raise(Exception.new("The Ruby constant, MMMV_DEVEL_TOOLS_HOME, "+
   "should have been defined before the control flow reaches the "+
   "file, from where this exception is thrown."+
   "\nGUID=='fd590255-3685-4153-b375-538231b1aed7'"))
   exit
end # if

if !defined? MMMV_DEVEL_TOOLS_VERSION
   MMMV_DEVEL_TOOLS_VERSION="2.3.0"
end # if

if !defined? KIBUVITS_HOME
   # use the local copy of the KRL
   KIBUVITS_HOME=MMMV_DEVEL_TOOLS_HOME+
   "/src/bonnet/lib/kibuvits_ruby_library"
end # if

# A hazy, very brief, test to see, whether the KIBUVITS_HOME
# might have a wrong value.
if !File.exists? KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
   msg="\nIt seems that the Ruby constant, KIBUVITS_HOME(==\n"+
   KIBUVITS_HOME.to_s+"\n), has a wrong value.\n\n"
   kibuvits_writeln msg
   exit
end # if

s_kibuvits_boot_path=KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
require s_kibuvits_boot_path
require KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"

# Due to a fact that the API of the
# Kibuvits Ruby Library (KRL, http://kibuvits.rubyforge.org/ )
# is allowed to change between different versions,
# applications that use the KRL must be tied to a specific
# version of the KRL.
if !defined? KIBUVITS_s_NUMERICAL_VERSION
   msg="\nThe Ruby constant, KIBUVITS_s_NUMERICAL_VERSION, has not \n"+
   "been defined in the \n"+
   s_kibuvits_boot_path+
   ". That indicates a Kibuvits Ruby Library version mismatch."+
   "\n GUID='ce902441-93d1-4df9-b575-538231b1aed7'\n\n"
   raise Exception.new(msg)
end # if
s_expected_KIBUVITS_s_NUMERICAL_VERSION="1.7.1"
if KIBUVITS_s_NUMERICAL_VERSION!=s_expected_KIBUVITS_s_NUMERICAL_VERSION
   msg="\nThis version of the mmmv_devel_tools expects the Ruby constant, \n"+
   "KIBUVITS_s_NUMERICAL_VERSION, to have the value of \""+s_expected_KIBUVITS_s_NUMERICAL_VERSION+"\", \n"+
   "but the KIBUVITS_s_NUMERICAL_VERSION=="+KIBUVITS_s_NUMERICAL_VERSION.to_s+
   "\n GUID='e096ce3d-c538-41d5-9475-538231b1aed7'\n\n"
   raise Exception.new(msg)
end # if

#--------------------------------------------------------------------------

class C_mmmv_devel_tools_global_singleton

   private

   # The KRL io and str are needed for the config file
   # related things, but one wants to use lazy loading.
   def load_KRL_io_str_ix
      if (defined? @b_KRL_io_str_ix_loaded).class!=NilClass
         return if @b_KRL_io_str_ix_loaded
      end # if
      require KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
      require KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
      require KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
      require KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
      @b_KRL_io_str_ix_loaded=true
   end # load_KRL_io_str_ix

   public

   def initialize
      @msgcs_=$kibuvits_msgc_stack
      @ht_global_configuration_cache=nil
      @fd_config_reading_time=Time.new(1981).to_f
   end # initialize

   #-----------------------------------------------------------------------
   private

   def mmmv_devel_tools_fallback_configuration(ht_config)
      s_fp=MMMV_DEVEL_TOOLS_HOME+"/src/bonnet/tmp/mmmv_devel_tools_GUID_trace_error_stack.txt"
      ht_config["s_GUID_trace_errorstack_file_path"]=s_fp

      # One path per element.
      # The GUIDs that are found from the error stack will be
      # searched from files that reside in those folders.
      ht_config["ar_GUID_trace_project_source_folder_paths"]=$kibuvits_lc_emptyarray

      # One path per element.
      # The GUIDs that are found from the error stack will be
      # searched from files that reside in those folders.
      ht_config["ar_GUID_trace_project_dependencies_source_folder_paths"]=$kibuvits_lc_emptyarray

      ar_fns=["*.js","*.rb","*.php","*.java","*.cpp","*.c","*.h","*.hpp","*.py","*.bash"]
      ht_config["ar_GUID_trace_file_name_glob_patterns_according_to_Ruby_stdlib_class_Dir_method_glob"]=ar_fns
   end # mmmv_devel_tools_fallback_configuration

   private

   def parse_mmmv_devel_tools_default_configuration(ht_config)
      load_KRL_io_str_ix()
      s_fp_config=MMMV_DEVEL_TOOLS_HOME+"/src/etc/mmmv_devel_tools_default_configuration.rb"
      s_ruby_src=file2str(s_fp_config)
      ar_in=[ht_config]
      s_script=s_ruby_src+$kibuvits_lc_linebreak+
      "ht_config=ar_in[0]\n"+
      "mmmv_devel_tools_default_configuration(ht_config)\n"+
      "ar_out<<ht_config\n"
      ar_out=kibuvits_eval_t1(s_script, ar_in)
      # The ht_config is passed to the eval script by reference,
      # which means that there's no need to "obtain" it "back out".
      # That's achieved by the "magic" of Ruby reflection.
   end # parse_mmmv_devel_tools_default_configuration

   #-----------------------------------------------------------------------

   public

   def msgcs()
      x_out=@msgcs_
      return x_out
   end # msgcs

   def C_mmmv_devel_tools_global_singleton.msgcs()
      msgcs=C_mmmv_devel_tools_global_singleton.instance.msgcs()
      return msgcs
   end # C_mmmv_devel_tools_global_singleton.msgcs()

   #-----------------------------------------------------------------------

   # For displaying in error messages.
   def s_configuration_summary
      ht_config=ht_global_configuration()
      s_ar_1=$kibuvits_lc_emptystring
      ht_config["ar_GUID_trace_project_source_folder_paths"].each do |s_fp|
         s_ar_1=s_ar_1+("     "+s_fp+$kibuvits_lc_linebreak)
      end # loop
      s_ar_2=$kibuvits_lc_emptystring
      ht_config["ar_GUID_trace_project_dependencies_source_folder_paths"].each do |s_fp|
         s_ar_2=s_ar_2+("     "+s_fp+$kibuvits_lc_linebreak)
      end # loop
      i=0;
      s_ar_3="     "
      ht_config["ar_GUID_trace_file_name_glob_patterns_according_to_Ruby_stdlib_class_Dir_method_glob"].each do |s_glob|
         s_ar_3=s_ar_3+(s_glob+"  ")
         i=i+1
         if i==5
            s_ar_3=s_ar_3+($kibuvits_lc_linebreak+"     ")
            i=0;
         end # if
      end # loop

      s_out="\ns_GUID_trace_errorstack_file_path==\n     "+
      ht_config["s_GUID_trace_errorstack_file_path"]+
      "\n\nar_GUID_trace_project_source_folder_paths==\n"+s_ar_1+
      "\n\nar_GUID_trace_project_dependencies_source_folder_paths==\n"+s_ar_2+
      "\nar_GUID_trace_file_name_glob_patterns_according_to_Ruby_stdlib_class_Dir_method_glob==\n"+s_ar_3+
      "\n\n";
      return s_out;
   end # s_configuration_summary

   def C_mmmv_devel_tools_global_singleton.s_configuration_summary()
      s_out=C_mmmv_devel_tools_global_singleton.instance.s_configuration_summary()
      return s_out
   end # C_mmmv_devel_tools_global_singleton.s_configuration_summary()

   #-----------------------------------------------------------------------

   def ht_global_configuration
      # The ht_global_configuration is intentionally not totally cached,
      # because in case of tools that are running in some
      # daemon mode one might want to reparse the config more than
      # once during a single run.
      ht_out=nil
      fd_t_now=Time.now.to_f
      b_parse=false
      b_parse=true if 3<(fd_t_now-@fd_config_reading_time)
      if (b_parse==false) && (@ht_global_configuration_cache==nil)
         kibuvits_throw("\n\nThis code has a flaw. \n"+
         "GUID='172cc4b5-be21-4852-b875-538231b1aed7'\n\n")
      end # if
      if b_parse
         ht_out=Hash.new
         mmmv_devel_tools_fallback_configuration(ht_out)
         parse_mmmv_devel_tools_default_configuration(ht_out)
         # Not fully fault tolerant, because client code
         # can still modify the elements of the hashtable,
         # but it's a compromise here.
         ht_cache=Hash.new
         ar=nil
         i_len=nil
         ht_out.each_pair do |x_key,x_value|
            if x_value.class==Array
               ar=Array.new
               i_len=x_value.size
               i_len.times{|i| ar<<x_value[i].freeze }
               ht_cache[x_key]=ar.freeze
            else
               ht_cache[x_key]=x_value
            end # if
         end # loop
         @ht_global_configuration_cache=ht_cache
         @fd_config_reading_time=fd_t_now
      else
         ht_out=@ht_global_configuration_cache.freeze
      end # if
      return ht_out
   end # ht_global_configuration

   def C_mmmv_devel_tools_global_singleton.ht_global_configuration
      ht_out=C_mmmv_devel_tools_global_singleton.instance.ht_global_configuration
      return ht_out
   end # C_mmmv_devel_tools_global_singleton.ht_global_configuration

   def s_config_hash_t1
      ht_config=ht_global_configuration()
      # The ht_config contains arrays, which means
      # that if ProgFTE were used here, the arrays
      # would have to be converted to strings before
      # the Kibuvits_ProgFTE.from_ht(...) could be called.
      s_signature=Marshal.dump(ht_config)
      s_out=kibuvits_s_hash_t1(s_signature)
      return s_out
   end # s_config_hash_t1

   def C_mmmv_devel_tools_global_singleton.s_config_hash_t1
      s_out=C_mmmv_devel_tools_global_singleton.instance.s_config_hash_t1
      return s_out
   end # C_mmmv_devel_tools_global_singleton.s_config_hash_t1

   #-----------------------------------------------------------------------
   include Singleton
end # class C_mmmv_devel_tools_global_singleton

#--------------------------------------------------------------------------

# Writes the s_in to the JumpGUID error message stack, if possible.
def mmmv_devel_tools_writeln_err_doc(s_in)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, [String], s_in
   end # if
   ht_cohfig=C_mmmv_devel_tools_global_singleton.ht_global_configuration
   s_key_errstack="s_GUID_trace_errorstack_file_path"
   if ht_cohfig.has_key? s_key_errstack
      s_fp_errstack=ht_cohfig[s_key_errstack]
      str2file(s_in,s_fp_errstack)
   end # if
   kibuvits_writeln(s_in)
end # mmmv_devel_tools_writeln_err_doc

#==========================================================================

