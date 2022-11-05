#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/BSD-3-Clause
=end
#==========================================================================

class Kibuvits_rubylangtest_string_creation_versus_classvar
   def initialize
      @lc_a_string="a_string"
   end # initialize

   private
   def add_up1 a, ht
      sum=ht["a_string"]+a
      ht["a_string"]=sum
   end # add_up1

   def add_up2 a, ht
      sum=ht[@lc_a_string]+a
      ht[@lc_a_string]=sum
   end # add_up2

   public

   def calcsum n, a, create_string
      ht=Hash.new
      sum=0
      if create_string
         ht["a_string"]=0
         n.times do |i|
            add_up1 a, ht
         end # loop
         sum=ht["a_string"]
      else
         ht[@lc_a_string]=0
         n.times do |i|
            add_up2 a, ht
         end # loop
         sum=ht[@lc_a_string]
      end # if
      return sum
   end # calcsum

end # class Kibuvits_rubylangtest_string_creation_versus_classvar

smr=Kibuvits_rubylangtest_string_creation_versus_classvar.new
a=171
raise Exception.new("\n\nConsole arguments: n, [whatever] \n\n") if ARGV.length==0
n=ARGV[0].to_i
create_string=false
create_string=true if 1<ARGV.length
puts "\n\ncreate_string=="+create_string.to_s+"\n\n"
sum=smr.calcsum n,a,create_string
puts "sum=="+sum.to_s+"\n\n"

# Conclusion is that the one without string creation is 
# about 90% of the one with the string creation. :-)

