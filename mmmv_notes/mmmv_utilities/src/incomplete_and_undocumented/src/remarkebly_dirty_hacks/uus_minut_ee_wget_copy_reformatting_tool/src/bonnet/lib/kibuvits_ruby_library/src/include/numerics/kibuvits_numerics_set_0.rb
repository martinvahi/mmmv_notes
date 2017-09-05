#!/usr/bin/env ruby
#=========================================================================
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
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
require "prime"

#==========================================================================


class Kibuvits_numerics_set_0

   def initialize
   end # initialize

   #-----------------------------------------------------------------------

   # ixs_low and ixs_high are sindexes
   # http://longterm.softf1.com/specifications/array_indexing_by_separators/
   # of an array that is created by Prime.take(i_number_of_primes)
   #
   # This function here is pretty expensive.
   def i_product_of_primes_t1(ixs_low,ixs_high)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, ixs_low,"\n GUID='20f49a85-e150-4521-9e21-439250f01fd7'\n\n")
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         ixs_low, ixs_high,"\n GUID='4b9bb5e4-5ab5-4dcf-ad41-439250f01fd7'\n\n")
         kibuvits_typecheck bn, Integer, ixs_low
         kibuvits_typecheck bn, Integer, ixs_high
      end # if
      x_identity_element=1
      x_identity_element if ixs_low==ixs_high
      ar_primes=Prime.take(ixs_high)
      ar_factors=Kibuvits_ix.sar(ar_primes,ixs_low,ixs_high)
      func_star=lambda do |x_a,x_b|
         x_out=x_a*x_b
         return x_out
      end # func_star
      i_out=Kibuvits_ix.x_apply_binary_operator_t1(
      x_identity_element,ar_factors,func_star)
      return i_out
   end # i_product_of_primes_t1

   def Kibuvits_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_out=Kibuvits_numerics_set_0.instance.i_product_of_primes_t1(ixs_low,ixs_high)
      return i_out
   end # Kibuvits_numerics_set_0.i_product_of_primes_t1

   #-----------------------------------------------------------------------

   # Calculates the factorial of i_n .
   #
   # For shorter code it is recommended to use
   # the kibuvits_factorial(...) in stead of calling i
   # this function directly.
   #
   def i_factorial_t1(i_n)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Integer, i_n
         kibuvits_assert_is_smaller_than_or_equal_to(bn,0,i_n,
         "\n GUID='0224dc60-7b29-4ab8-9150-439250f01fd7'\n\n")
      end # if
      i_out=1 # factorial(0)==1
      return i_out if i_n==0
      func_star=lambda do |x_a,x_b|
         x_out=x_a*x_b
         return x_out
      end # func_star
      ar_n=Array.new
      # For i_n==2, the ar_n==[0,1,2], ar_n.size==3 .
      # To avoid multiplication with 0, ar_n[0]==1 .
      # Therefore, for i_n==2, ar_n==[1,2] .
      i_n.times{|i| ar_n<<(i+1)} # i starts from 0
      x_identity_element=1
      i_out=Kibuvits_ix.x_apply_binary_operator_t1(
      x_identity_element,ar_n,func_star)
      return i_out
   end # i_factorial_t1

   def Kibuvits_numerics_set_0.i_factorial_t1(i_n)
      i_out=Kibuvits_numerics_set_0.instance.i_factorial_t1(i_n)
      return i_out
   end # Kibuvits_numerics_set_0.i_factorial_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_numerics_set_0

def kibuvits_factorial(i_n)
   i_out=Kibuvits_numerics_set_0.i_factorial_t1(i_n)
   return i_out
end # kibuvits_factorial

def kibuvits_combinatorical_variation(i_superset_size,i_subset_size)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Integer, i_superset_size
      kibuvits_typecheck bn, Integer, i_subset_size
      kibuvits_assert_is_smaller_than_or_equal_to(bn,0,i_subset_size,
      "\n GUID='143c7005-88e5-4bfb-a510-439250f01fd7'\n\n")
      kibuvits_assert_is_smaller_than_or_equal_to(bn,i_subset_size,i_superset_size,
      "\n GUID='1e8ee883-ed31-42a5-9650-439250f01fd7'\n\n")
   end # if
   i_0=kibuvits_factorial(i_superset_size)
   i_1=kibuvits_factorial(i_superset_size-i_subset_size)
   i_var=i_0/i_1
   return i_var
end # kibuvits_combinatorical_variation

def kibuvits_combination(i_superset_size,i_subset_size)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Integer, i_superset_size
      kibuvits_typecheck bn, Integer, i_subset_size
      kibuvits_assert_is_smaller_than_or_equal_to(bn,0,i_subset_size,
      "\n GUID='4a6f6135-3222-4fa4-8850-439250f01fd7'\n\n")
      kibuvits_assert_is_smaller_than_or_equal_to(bn,i_subset_size,i_superset_size,
      "\n GUID='173a0932-9e08-4f91-8340-439250f01fd7'\n\n")
   end # if
   i_var=kibuvits_combinatorical_variation(
   i_superset_size,i_subset_size)
   i_c=i_var/kibuvits_factorial(i_subset_size)
   return i_c
end # kibuvits_combination


#=========================================================================

