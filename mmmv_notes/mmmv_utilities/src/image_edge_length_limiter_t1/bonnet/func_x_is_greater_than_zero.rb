#!/usr/bin/env ruby
#==========================================================================
require 'pathname'
ob_pth_0=Pathname.new(__FILE__).realpath.parent
KIBUVITS_HOME=ob_pth_0.to_s+"/kibuvits_ruby_library"
require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"

#--------------------------------------------------------------------------

def s_func_x_is_greater_than_zero(s_in)
   s_out="f"
   return s_out if kibuvits_b_not_a_whole_number_t1(s_in)
   i_0=s_in.to_i
   s_out="t" if 0<i_0
   return s_out
end # s_func_x_is_greater_than_zero

i_len=ARGV.size
kibuvits_throw("ARGV.size==0") if i_len==0
if 1<i_len # like "4 44.7" becomes 2 commandline arguments
   print("f")
   exit
end # if
s_in=ARGV[0]
s_out=s_func_x_is_greater_than_zero(s_in)
print(s_out)

#==========================================================================
