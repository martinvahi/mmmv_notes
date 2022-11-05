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

class Kibuvits_rubylangtest_global_classvar_versus_nongloba_classvar
   @@lc_s_a="a_string"
   def initialize
      @lc_s_b="a_string"
   end # initialize

   private

   def add_up_a i, ht
      sum=ht[@@lc_s_a]+i
      ht[@@lc_s_a]=sum
   end # add_up_a

   def add_up_b i, ht
      sum=ht[@lc_s_b]+i
      ht[@lc_s_b]=sum
   end # add_up_b

   public

   def calcsum n, i, use_global_classvar
      ht=Hash.new
      sum=0
      if use_global_classvar
         ht[@@lc_s_a]=0
         n.times do |ii|
            add_up_a i, ht
         end # loop
         sum=ht[@@lc_s_a]
      else
         ht[@lc_s_b]=0
         n.times do |ii|
            add_up_b i, ht
         end # loop
         sum=ht[@lc_s_b]
      end # if
      return sum
   end # calcsum

end # class Kibuvits_rubylangtest_global_classvar_versus_nongloba_classvar

smr=Kibuvits_rubylangtest_global_classvar_versus_nongloba_classvar.new
i=171
if ARGV.length==0
   kibuvits_throw "\n\nConsole arguments: n, "+
   "[whatever_for_static_classvar_usage] \n\n"
end # if
n=ARGV[0].to_i
use_global_classvar=false
use_global_classvar=true if 1<ARGV.length
puts "\n\nuse_global_classvar=="+use_global_classvar.to_s+"\n\n"
sum=smr.calcsum n,i,use_global_classvar
puts "sum=="+sum.to_s+"\n\n"

# Conclusion is that the use of global classvars is 
# about 1% slower than the use of instance classvars.
# 
# The tests were done by running a command like:
# nice -n -5 time ./global_class_variable_versus_nonglobal_class_variable.rb 10000000 
# 
# If the result of this test is compared with the one of
# string_creation_versus_class_variable.rb, then in case
# of string constants there should be about 9% speed gain
# if the string constants are stored to global variables
# in stead of local class variables. The idea is that
# an instantiation constitutes string object creation.
#
# As the time won that way it's really small in absolute terms, 
# it makes sense to use this tecnique only for classes 
# that have potentially "a lot of" instances.
#
