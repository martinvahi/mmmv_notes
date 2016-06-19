#!/usr/bin/env ruby 
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 This file is licensed under the MIT license:
 http://www.opensource.org/licenses/mit-license.php

=end
#==========================================================================
require "./watershed_concatenation_implementations/kibuvits_str_concat_array_of_strings.rb"
require "./watershed_concatenation_implementations/kibuvits_str_concat_array_of_strings_v2.rb"

STRING_CONSTANT_xV="xV".freeze # for avoiding string instantiation

def concact_by_plain_loop n, i_version
   s_out="" # must not be nil due to the + operator in the loop
   case i_version
   when 1
      n.times{s_out=s_out+(rand(9).to_s+STRING_CONSTANT_xV)}
   when 2
      n.times{s_out=(s_out<<(rand(9).to_s<<STRING_CONSTANT_xV))}
   else
      raise Exception.new("i_version=="+i_version.to_s)
   end # case i_version
   return s_out
end # concact_by_plain_loop

# It's here to allow You to experiment with
# something more primitive to see the
# concatenation order related speed effects.
def concat_by_pseudowatershed n
   i_reminder=n%2
   i_loop=n.div(2)
   s_1=""
   i_loop.times{s_1=s_1+(rand(9).to_s+STRING_CONSTANT_xV)}
   s_2=""
   i_loop.times{s_2=s_2+(rand(9).to_s+STRING_CONSTANT_xV)}
   s_2=s_2+(rand(9).to_s+STRING_CONSTANT_xV) if i_reminder==1
   s_out=s_1+s_2
   return s_out
end # concat_by_pseudowatershed

def concact_by_watershed n, i_version
   s_out=nil
   ar=Array.new
   n.times{ar<<(rand(9).to_s+STRING_CONSTANT_xV)}
   case i_version
   when 1
      s_out=kibuvits_s_concat_array_of_strings(ar)
   when 2
      s_out=kibuvits_s_concat_array_of_strings_v2(ar)
   else
      raise Exception.new("i_version=="+i_version.to_s)
   end # case i_version
   return s_out
end # concact_by_watershed

n=ARGV[0].to_i
puts "\n"
case ARGV.length
when 2
   puts "Ruby test with the plain loop concatenation, version 1."
   s=concact_by_plain_loop(n,i_version=1)
   puts "s.length=="+s.length.to_s
when 3
   puts "Ruby test with the pseudo-watershed concatenation."
   s=concat_by_pseudowatershed(n)
   puts "s.length=="+s.length.to_s
when 4
   puts "Ruby test with the watershed concatenation, version 1"
   s=concact_by_watershed(n,i_version=1)
   puts "s.length=="+s.length.to_s
when 5
   puts "Ruby test with the watershed concatenation,  version 2 (improved according to the comments of Benoit Daloze)."
   s=concact_by_watershed(n,i_version=2)
   puts "s.length=="+s.length.to_s
when 6
   puts "Ruby test with the plain loop concatenation, version 2 (improved according to the comments of Benoit Daloze)."
   s=concact_by_plain_loop(n,i_version=2)
   puts "s.length=="+s.length.to_s
else
   puts "\nConsole arguments: n, [whatever] \n\n"
end # case ARGV.length


