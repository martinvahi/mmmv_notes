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

def test_functionality_demo
   i_x=0
   case i_x
   when 0
      puts "i_x=="+i_x.to_s
      i_x=i_x+1
   when 1
      puts "i_x=="+i_x.to_s
      i_x=i_x+1
   when 2
      puts "i_x=="+i_x.to_s
      i_x=i_x+1
   when 3
      puts "i_x=="+i_x.to_s
      i_x=i_x+1
   when 4
      puts "i_x=="+i_x.to_s
      i_x=i_x+1
   when 5
      puts "i_x=="+i_x.to_s
      i_x=i_x+1
   else
      puts "The else block."
   end # case xx
end # test_functionality_demo

def test_for_speed_ifelse(n)
   i_sum=0
   n.times do
      6.times do |i_x|
         if i_x==0
            i_sum=i_sum+i_x
         else
            if i_x==1
               i_sum=i_sum+i_x
            else
               if i_x==2
                  i_sum=i_sum+i_x
               else
                  if i_x==3
                     i_sum=i_sum+i_x
                  else
                     if i_x==4
                        i_sum=i_sum+i_x
                     else
                        if i_x==5
                           i_sum=i_sum+i_x
                        else
                           raise(Exception.new(
                           "Exception in the test_for_speed_ifelse(...)."))
                        end # if
                     end # if
                  end # if
               end # if
            end # if
         end # if
      end # loop 6.times
   end # loop n.times
   return i_sum
end # test_for_speed_ifelse

def test_for_speed_switch(n)
   i_sum=0
   n.times do
      6.times do |i_x|
         case i_x
         when 0
            i_sum=i_sum+i_x
         when 1
            i_sum=i_sum+i_x
         when 2
            i_sum=i_sum+i_x
         when 3
            i_sum=i_sum+i_x
         when 4
            i_sum=i_sum+i_x
         when 5
            i_sum=i_sum+i_x
         else
            raise(Exception.new(
            "Exception in the test_for_speed_switch(...)."))
         end # case xx
      end # loop 6.times
   end # loop n.times
   return i_sum
end # test_for_speed_switch

puts ""
if ARGV.size==0
   puts "Functionality demo:"
   test_functionality_demo()
else
   if ARGV.size==1
      n=ARGV[0].to_i
      puts "test_for_speed_ifelse("+n.to_s+")"
      puts "i_sum=="+test_for_speed_ifelse(n).to_s
   else
      if ARGV.size==2
         n=ARGV[0].to_i
         puts "test_for_speed_switch("+n.to_s+")"
         puts "i_sum=="+test_for_speed_switch(n).to_s
      else
      end # if
   end # if
end # if
puts ""

# For n==3'000'000 the arithmetic mean of time measurements of 3 runs were:
# switch version: 16,5s
# ifelse version: 21,7s
#
# That is to say that the switch version takes about 76% of
# the time taken by the ifelse version.
#
# The test is conducted in April 2012 with
# ruby 1.9.2p180 (2011-02-18 revision 30909) [i686-linux]
# on a max. 1.6GHz AMD Sempron laptop that has
# the following /proc/cpuinfo excerpt:
# ---/proc/cpuinfo--excerpt--start---
#  Mobile AMD Sempron(tm) Processor 2600+
#  cache size	: 128 KB
#  processor	: 0
#  vendor_id	: AuthenticAMD
#  cpu family	: 15
#  model		: 28
#  model name	: Mobile AMD Sempron(tm) Processor 2600+
#  cache size	: 128 KB
#  flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt 3dnowext 3dnow up lahf_lm
#  bogomips	: 1605.81
#  clflush size	: 64
# ---/proc/cpuinfo--excerpt--start---


