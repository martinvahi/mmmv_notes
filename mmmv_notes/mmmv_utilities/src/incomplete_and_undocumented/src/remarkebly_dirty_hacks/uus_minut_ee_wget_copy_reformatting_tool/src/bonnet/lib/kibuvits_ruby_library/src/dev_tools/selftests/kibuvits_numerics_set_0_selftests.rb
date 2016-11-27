#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2014, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/numerics/kibuvits_numerics_set_0.rb"

#==========================================================================

class Kibuvits_numerics_set_0_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_numerics_set_0_selftests.test_i_product_of_primes_t1
      ar_ref_primes=Prime.take(100) # [2,3,5,7,11,13,...]
      #                               0 1 2 3 4  5  6
      #---------
      ixs_low=0
      ixs_high=1
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_expected=2
      kibuvits_throw "test 1 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
      ixs_low=0
      ixs_high=0
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_expected=1
      kibuvits_throw "test 2 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
      ixs_low=4
      ixs_high=4
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_expected=1
      kibuvits_throw "test 3 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
      ixs_low=1
      ixs_high=3
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_expected=3*5
      kibuvits_throw "test 4 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
      ixs_low=0
      ixs_high=5
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_expected=2*3*5*7*11
      kibuvits_throw "test 5 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
      ixs_low=5
      ixs_high=6
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_expected=13
      kibuvits_throw "test 6 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
      ixs_low=0
      ixs_high=500
      i_x=Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_prod=1
      Prime.take(ixs_high).each{|i_prime| i_prod=i_prod*i_prime}
      i_expected=i_prod
      kibuvits_throw "test 7 i_x=="+i_x.to_s if i_x!=i_expected
      #---------
   end # Kibuvits_numerics_set_0_selftests.test_i_product_of_primes_t1

   #-----------------------------------------------------------------------

   def Kibuvits_numerics_set_0_selftests.test_i_factorial_t1
      #---------
      i_x=Kibuvits_numerics_set_0.i_factorial_t1(0)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 0 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_x=Kibuvits_numerics_set_0.i_factorial_t1(1)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_x=Kibuvits_numerics_set_0.i_factorial_t1(2)
      i_expected=1*2
      if i_x!=i_expected
         kibuvits_throw "test 2 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_x=Kibuvits_numerics_set_0.i_factorial_t1(3)
      i_expected=1*2*3
      if i_x!=i_expected
         kibuvits_throw "test 3a i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_x=Kibuvits_numerics_set_0.i_factorial_t1(10)
      i_expected=1*2*3*4*5*6*7*8*9*10
      if i_x!=i_expected
         kibuvits_throw "test 3b i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      #---------
      i_x=kibuvits_factorial(10)
      i_expected=Kibuvits_numerics_set_0.i_factorial_t1(10)
      if i_x!=i_expected
         kibuvits_throw "test 4 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
   end # Kibuvits_numerics_set_0_selftests.test_i_factorial_t1

   #-----------------------------------------------------------------------

   def Kibuvits_numerics_set_0_selftests.test_kibuvits_combination
      #---------
      i_in_super=0
      i_in_sub=0
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1a i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=1
      i_in_sub=0
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1b i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=1
      i_in_sub=1
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1c i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=2
      i_in_sub=2
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1d i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=3
      i_in_sub=3
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1e i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=25
      i_in_sub=25
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=1
      if i_x!=i_expected
         kibuvits_throw "test 1f i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=2
      i_in_sub=1
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=2
      if i_x!=i_expected
         kibuvits_throw "test 2 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=4
      i_in_sub=2
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=6
      if i_x!=i_expected
         kibuvits_throw "test 3 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
      #---------
      i_in_super=4
      i_in_sub=3
      i_x=kibuvits_combination(i_in_super,i_in_sub)
      i_expected=4
      if i_x!=i_expected
         kibuvits_throw "test 4 i_x=="+i_x.to_s+" i_expected=="+i_expected.to_s
      end # if
   end # Kibuvits_numerics_set_0_selftests.test_kibuvits_combination

   #-----------------------------------------------------------------------

   public

   def Kibuvits_numerics_set_0_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_numerics_set_0_selftests.test_i_product_of_primes_t1"
      kibuvits_testeval bn, "Kibuvits_numerics_set_0_selftests.test_i_factorial_t1"
      kibuvits_testeval bn, "Kibuvits_numerics_set_0_selftests.test_kibuvits_combination"
      return ar_msgs
   end # Kibuvits_numerics_set_0_selftests.selftest

end # class Kibuvits_numerics_set_0_selftests

#==========================================================================

# Kibuvits_numerics_set_0_selftests.test_i_product_of_primes_t1

