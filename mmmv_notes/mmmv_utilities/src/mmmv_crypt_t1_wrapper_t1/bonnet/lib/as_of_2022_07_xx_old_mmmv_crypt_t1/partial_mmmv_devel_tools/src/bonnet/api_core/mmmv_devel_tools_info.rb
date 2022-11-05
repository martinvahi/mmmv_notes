#!/usr/bin/env ruby
#==========================================================================

#require "singleton"
require "pathname"

if !defined? MMMV_DEVEL_TOOLS_HOME
   ob_pth=Pathname.new(__FILE__).realpath.parent
   MMMV_DEVEL_TOOLS_HOME=ob_pth.parent.parent.parent.to_s
end # if
require MMMV_DEVEL_TOOLS_HOME+"/src/bonnet/api_core/mmmv_devel_tools_public_api_core.rb"

class C_mmmv_devel_tools_info
   def initialize
   end # initialize


   def get_config(s_config_ht_key)
      s_out=C_mmmv_devel_tools_public_api_core.get_config(s_config_ht_key)
      return s_out
   end # get_config

   def s_doc(s_optional_GUID="")
      s_out="\n\nCommand line arguments: "+
      "\n"+
      "\n        (get_config <ht_config key>)\n"+
      "\n"+
      "For example:\n"+
      "\n"+
      "        get_config s_GUID_trace_errorstack_file_path\n"+
      "\n\n"
      if 0<s_optional_GUID.length
         s_out=s_out+
         "Current message branch GUID=="+s_optional_GUID+"\n\n"
      end #
      return s_out
   end # s_doc

end # class C_mmmv_devel_tools_info

ob_info=C_mmmv_devel_tools_info.new

# The following if-clause causes problems in this
# old version/branch of the mmmv_devel_tools. 
# The newer, currently probably yet unpublished, branch 
# has this nonsense all refactored out. It's a very dirty, temporary "fix".
#if ARGV.size==0
#   kibuvits_writeln(ob_info.s_doc("'0728c25b-76a2-49f0-93a5-409170b16ed7'"))
#   exit
#end # if

if ARGV.size!=0  # part of the dirty "fix"
   s_cmd=ARGV[0].to_s


   case s_cmd
   when "get_config"
      if ARGV.size!=2
         kibuvits_writeln(ob_info.s_doc("'375c45d1-763b-4dc9-97a5-409170b16ed7'"))
         exit
      end # if
      s_config_key=ARGV[1]
      s_out=ob_info.get_config(s_config_key)
      kibuvits_write s_out
   else
      kibuvits_writeln(ob_info.s_doc("'5295c1a4-7c85-44da-85a5-409170b16ed7'"))
      exit
   end # case s_cmd
end # if # part of the dirty "fix"

#==========================================================================

