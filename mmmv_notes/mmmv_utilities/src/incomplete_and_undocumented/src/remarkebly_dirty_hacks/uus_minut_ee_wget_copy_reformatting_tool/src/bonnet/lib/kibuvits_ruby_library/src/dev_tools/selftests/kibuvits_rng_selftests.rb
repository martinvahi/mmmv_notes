#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 Redistribution and use in source and binary forms, with or
 without modification, are permitted provided that the following
 conditions are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer
   in the documentation and/or other materials provided with the
   distribution.
 * Neither the name of the Martin Vahi nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end
#==========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/security/kibuvits_rng.rb"

#==========================================================================

class Kibuvits_rng_selftests
   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_rng_selftests.testimpl_t1_tests_1_2_(func_rand)
      i_0=0
      i_1=0
      b_flaw_or_the_unlikely_event_happened=false
      i_power=2
      while ((i_1<1) && (i_power<3))
         i_n=10**i_power
         i_n.times do |i_max|
            i_0=func_rand.call(i_max)
            kibuvits_throw "test 1a" if i_max<i_0
            if 0<i_max
               i_1=i_1+i_0
            else
               i_1=i_1+1
            end # if
         end # loop
         i_0=func_rand.call(0)
         kibuvits_throw "test 1b" if i_0!=0
         i_power=i_power+1
      end # loop
      kibuvits_throw "test 1c" if i_1==0
   end # Kibuvits_rng_selftests.testimpl_t1_tests_1_2_

   #-----------------------------------------------------------------------

   def Kibuvits_rng_selftests.test_1
      func_rand=lambda do |i_max|
         i_out=Kibuvits_rng.i_random_t1(i_max)
         return i_out
      end # func_rand
      Kibuvits_rng_selftests.testimpl_t1_tests_1_2_(func_rand)
      i_x=nil
      100.times do |i|
         i_x=Kibuvits_rng.i_random_t1(0)
         kibuvits_throw "test 2a" if i_x!=0
         i_x=Kibuvits_rng.i_random_fast_t1(0)
         kibuvits_throw "test 2b" if i_x!=0
      end # loop
      #------------------
   end # Kibuvits_rng_selftests.test_1

   #-----------------------------------------------------------------------

   def Kibuvits_rng_selftests.test_i_random_fast_t1
      func_rand=lambda do |i_max|
         i_out=Kibuvits_rng.i_random_fast_t1(i_max)
         return i_out
      end # func_rand
      Kibuvits_rng_selftests.testimpl_t1_tests_1_2_(func_rand)
      #------------------
   end # Kibuvits_rng_selftests.test_i_random_fast_t1


   #-----------------------------------------------------------------------

   public
   def Kibuvits_rng_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_rng_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_rng_selftests.test_i_random_fast_t1"
      return ar_msgs
   end # Kibuvits_rng_selftests.selftest

end # class Kibuvits_rng_selftests

#==========================================================================
#puts Kibuvits_rng_selftests.selftest.to_s

