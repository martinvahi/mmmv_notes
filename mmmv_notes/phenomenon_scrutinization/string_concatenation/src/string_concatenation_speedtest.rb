#!/opt/ruby/bin/ruby -Ku
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/BSD-3-Clause
=end
#==========================================================================
require "./watershed_concatenation_implementations/kibuvits_str_concat_array_of_strings.rb"

STRING_CONSTANT_xV="xV".freeze # for avoiding string instantiation

def concact_by_plain_loop n
   s_out=""
   n.times{s_out=s_out+(STRING_CONSTANT_xV+rand(9).to_s)}
   return s_out
end # concact_by_plain_loop

# It's here to allow You to experiment with
# something more primitive to see the
# concatenation order related speed effects.
def concat_by_pseudowatershed n
   i_reminder=n%2
   i_loop=n.div(2)
   s_1=""
   i_loop.times{s_1=s_1+(STRING_CONSTANT_xV+rand(9).to_s)}
   s_2=""
   i_loop.times{s_2=s_2+(STRING_CONSTANT_xV+rand(9).to_s)}
   s_2=s_2+(STRING_CONSTANT_xV+rand(9).to_s) if i_reminder==1
   s_out=s_1+s_2
   return s_out
end # concat_by_pseudowatershed

def concact_by_watershed n
   s_out=nil
   ar=Array.new
   n.times{ar<<(STRING_CONSTANT_xV+rand(9).to_s)}
   s_out=kibuvits_s_concat_array_of_strings(ar)
   return s_out
end # concact_by_watershed

n=ARGV[0].to_i
puts "\n"
case ARGV.length
when 2
   puts "Ruby test with the plain loop concatenation."
   s=concact_by_plain_loop(n)
   puts "s.length=="+s.length.to_s
when 3
   puts "Ruby test with the pseudo-watershed concatenation."
   s=concat_by_pseudowatershed(n)
   puts "s.length=="+s.length.to_s
when 4
   puts "Ruby test with the watershed concatenation."
   s=concact_by_watershed(n)
   puts "s.length=="+s.length.to_s
else
   puts "\nConsole arguments: n, [whatever] \n\n"
end # case ARGV.length


