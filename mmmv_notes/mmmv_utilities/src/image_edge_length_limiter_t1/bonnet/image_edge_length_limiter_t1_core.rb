#!/usr/bin/env ruby
#==========================================================================
require 'pathname'
ob_pth_0=Pathname.new(__FILE__).realpath.parent
KIBUVITS_HOME=ob_pth_0.to_s+"/kibuvits_ruby_library"
require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"

require  KIBUVITS_HOME+"/src/include/wrappers/kibuvits_ImageMagick.rb"
#--------------------------------------------------------------------------

s_fp_orig=ob_pth_0.parent.to_s+"/originals"
s_fp_dest=ob_pth_0.parent.to_s+"/conversion_result"

#------------------

i_len=ARGV.size
if i_len!=1
   kibuvits_throw("ARGV.size!=1 "+
   "\nGUID='c9d3805a-6d3c-48f4-921d-d1c221d14dd7'")
end # if
s_max_edge_length_candidate=ARGV[0]
if kibuvits_b_not_a_whole_number_t1(s_max_edge_length_candidate)
   kibuvits_throw("\nLength candidate must be "+
   "a string representaton of a postive whole number. "+
   "\ns_max_edge_length_candidate=="+ s_max_edge_length_candidate+
   "\nGUID='7670fa73-6e21-4440-a91d-d1c221d14dd7'")
end # if
i_max_edge_length=s_max_edge_length_candidate.to_i
if (i_max_edge_length<1)
   kibuvits_throw("\nImage side length in number of pixels "+
   "must be greater than 0. "+
   "\ni_max_edge_length=="+ i_max_edge_length.to_s+
   "\nGUID='3e8bbc5e-cab1-4951-a21d-d1c221d14dd7'")
end # if

#------------------

msgcs=Kibuvits_msgc_stack.new
Kibuvits_ImageMagick.apply_width_and_height_limits(
i_max_edge_length,i_max_edge_length,s_fp_dest,s_fp_orig,msgcs)
puts msgcs.to_s if msgcs.b_failure

#==========================================================================
