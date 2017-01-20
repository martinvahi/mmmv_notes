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

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"

#--------------------------------------------------------------------------
# Test settings:
b_test_for_array=false
i_n_of_cycles=10**6

#----handwritten-results---start---
#        i_n_of_cycles=10**6
#
#        b_test_for_array=true   ~2.4s
#        b_test_for_array=false  ~2.8s   
#
# The Array version is about 87% of the Hash version, i.e. 
# the Array version is about 13% faster than the Hash version.
#----handwritten-results---end-----

#--------------------------------------------------------------------------
# The reason for all of the trickery here with the
# string constants and later on with the elseif-s
# in the loop is to avoid string instantiation
# related overhead and a will to keep the cost of both
# of the test-branches as blanced as one can think of
# in terms of test supporting code. For example,
# if one wants to measure the densities of 2 liquids, then
# it makes sense to try to make it so that the vessels that
# hold the liquids, are, in relevant terms, as equal as possible.

ar=[44,55,234,342,23442]

ht=Hash.new
s_lc_0="0"
s_lc_1="1"
s_lc_2="2"
s_lc_3="3"
s_lc_4="4"

ht[s_lc_0]=44
ht[s_lc_1]=55
ht[s_lc_2]=234
ht[s_lc_3]=342
ht[s_lc_4]=23442

x=0
x1=nil
if b_test_for_array
   i_n_of_cycles.times do |i|
      ii=rand 4
      if ii==0
         x1=ar[0]
      elsif ii==1
         x1=ar[1]
      elsif ii==2
         x1=ar[2]
      elsif ii==3
         x1=ar[3]
      elsif ii==4
         x1=ar[4]
      else
         raise "We should not be here"
      end
      x=x+x1
   end # loop
else # test for hashtable
   i_n_of_cycles.times do |i|
      ii=rand 4
      if ii==0
         x1=ht[s_lc_0]
      elsif ii==1
         x1=ht[s_lc_1]
      elsif ii==2
         x1=ht[s_lc_2]
      elsif ii==3
         x1=ht[s_lc_3]
      elsif ii==4
         x1=ht[s_lc_4]
      else
         raise "We should not be here"
      end
      x=x+x1
   end # loop
end # if

if b_test_for_array
    puts "\nArray test complete. x=="+x.to_s
else
    puts "\nHashtable test complete. x=="+x.to_s
end 


