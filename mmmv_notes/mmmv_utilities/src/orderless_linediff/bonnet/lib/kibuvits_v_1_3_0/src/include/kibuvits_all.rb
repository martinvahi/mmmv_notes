#!/usr/bin/env ruby 
#==========================================================================
=begin

The reason, why the name of this file is kibuvits_all.rb in stead of
just kibuvits.rb, is that there was some sort of trouble loading the
kibuvits.rb from a gem.

The ultimate reason, why it's such a self-writing quirk, is that
one could not figure out, how to elegantly use absolute file
paths within a gem. So relative paths have to be used, but if
one does not use absolute paths, the Dir.glob(stuff) is a bit
difficult to use, which leads to a pre-written list of
require statements, and usefulness of the the swlf-writing quirk,
which frees one from the manual list-assembling.

=end
#==========================================================================

require 'pathname'

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   if (x!=nil and x!="")
      KIBUVITS_HOME=x.to_s.freeze
   else
      KIBUVITS_HOME=Pathname.new(__FILE__).realpath.parent.parent.parent.to_s
   end # if
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"

def apply_to_genlist(s_mypath, a_file_path,s_list_for_gem)
   s1=a_file_path[(s_mypath.length-15)..-1]
   if a_file_path!=s_mypath
      s_list_for_gem=s_list_for_gem+"    require KIBUVITS_HOME+\"/src/include/"+s1+"\"\n"
      require a_file_path
   end # if
   return s_list_for_gem
end #apply_to_genlist

b_selfwriting=false
if defined? KIBUVITS_b_DEBUG
   # The TrueClass is used in stead of the boolean "true" to keep
   # this code working even, if some non-boolean value is
   # accidentally assigned to the KIBUVITS_b_DEBUG in the kibuvits_boot.rb.
   # In a way it hides a potentsial flaw, but the flaw/bug will probably
   # become visible at some other location and the solution here
   # just increase the probability that the system
   # is testable during debugging.
   b_selfwriting=KIBUVITS_b_DEBUG if KIBUVITS_b_DEBUG.class==TrueClass
end # if
if b_selfwriting
   kibuvits_home=KIBUVITS_HOME
   require kibuvits_home+"/src/include/kibuvits_msgc.rb"
   msgcs=Kibuvits_msgc_stack.new
   begin
      require  kibuvits_home+"/src/include/kibuvits_io.rb"
      s_mypath=Pathname.new(kibuvits_home+"/src/include/kibuvits_all.rb").realpath.to_s
      s_list_for_gem=""
      s0=""
      s1=""
      pthn=nil
      s_prefix=kibuvits_home+"/src/include/"
      Dir.glob(s_prefix+"*.rb").each do |a_file_path|
         s_list_for_gem=apply_to_genlist(s_mypath, a_file_path,s_list_for_gem)
      end # loop
      Dir.glob(kibuvits_home+"/src/include/incomplete/*.rb").each do |a_file_path|
         s_list_for_gem=apply_to_genlist(s_mypath, a_file_path,s_list_for_gem)
      end # loop
      Dir.glob(kibuvits_home+"/src/include/deprecated/*.rb").each do |a_file_path|
         s_list_for_gem=apply_to_genlist(s_mypath, a_file_path,s_list_for_gem)
      end # loop
      Dir.glob(kibuvits_home+"/src/include/bonnet/*.rb").each do |a_file_path|
         s_list_for_gem=apply_to_genlist(s_mypath, a_file_path,s_list_for_gem)
      end # loop
      s_start="SELFWRIGING_REGION_STAR"+"T"
      s_end="SELFWRIGING_REGION_EN"+"D"
      s_hay=file2str(s_mypath)
      s_hay,ht_picks=Kibuvits_str.pick_by_instance(s_start,s_end,
      s_hay,msgcs)
      if msgcs.b_failure
         raise Exception.new("Selfwriting in kibuvits_all.rb failed. t1 msg=="+msgcs.to_s)
      end # if
      if 1!=ht_picks.keys.length
         raise Exception.new("Selfwriting in kibuvits_all.rb failed. t2")
      end # if
      s_key=ht_picks.keys[0]
      s_block=s_start+"\n"+s_list_for_gem+"\n # "+s_end
      s_hay.sub!(s_key,s_block)
      str2file(s_hay,s_mypath)
   rescue Exception => e
      # The kibuvits_throw should not be used here, because
      # it resides in the kibuvits_boot.rb, which is not loaded,
      # if any of the kibuvits_io.rb or alike has not been loaded
      # sucessfully for rewriting this file here.
      raise Exception.new("\n\nkibuvits_all.rb selfwriting failed.\n"+
      "It might be that the API of some function that the selfwriting \n"+
      "depends on, changed. msgcs.to_s==\n"+msgcs.to_s+
      "\n\nThe system exception message is:\n\n"+
      e.to_s) #+
   end # rescue
else
   # SELFWRIGING_REGION_START
    require KIBUVITS_HOME+"/src/include/kibuvits_arraycursor_t1.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_graph.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_htoper.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_coords.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_i18n_msgs_t1.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_argv_parser.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_apparch_specific.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_refl.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_formula.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_file_intelligence.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_str_concat_array_of_strings.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_gstatement.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_IDstamp_registry_t1.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_comments_detector.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_dependencymetrics_t1.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_graph_oper_t1.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_cg.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_finite_sets.rb"
    require KIBUVITS_HOME+"/src/include/kibuvits_eval.rb"
    require KIBUVITS_HOME+"/src/include/incomplete/kibuvits_whiteboard.rb"
    require KIBUVITS_HOME+"/src/include/incomplete/kibuvits_MUD.rb"
    require KIBUVITS_HOME+"/src/include/incomplete/kibuvits_szr.rb"
    require KIBUVITS_HOME+"/src/include/deprecated/kibuvits_iteratable_tree_t1.rb"
    require KIBUVITS_HOME+"/src/include/deprecated/kibuvits_deprecated_str.rb"
    require KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"

 # SELFWRIGING_REGION_END
end # if
#==========================================================================
