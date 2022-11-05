#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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


#==========================================================================

# "rng" stands for "random number generator".
#
# There is a rumor that sometimes the standard random generators
# are so bad that their output ends up being on some "high dimensional"
# (how high is high?) hyperplane.
#
#     http://youtu.be/FoKxzorQIhU?t=30m54s
#
# TODO: Think of some recursive and iteration based
#       functions that generate nice pseudorandom
#       sequences. Their values should be bounded
#       like it is the case with the sin(x).
#       Study, how the currently available versions have been
#       implemented.
#
class Kibuvits_rng

   private

   def ob_gen_instance_of_class_random_t1
      ob_t=Time.now
      i_usec=ob_t.usec
      i_0=(ob_t.to_i.to_s<<i_usec.to_s).to_i
      i_00=(Random.new_seed.to_s<<i_0.to_s).to_i
      if (i_usec%3)==0
         i_00=i_00+i_usec
      else
         i_00=i_00+(i_usec/2+1) if (i_usec%2)==0
      end # if
      i_rand_ps=(`ps -A`).length
      @i_rand_whoami=(`whoami`).length if !defined? @i_rand_whoami
      i_rand_whoami_ps=@i_rand_whoami+i_rand_ps
      ob_random=Random.new(i_00+i_rand_whoami_ps)
      #-----------
      i_0=0
      3.times do
         # TODO replace this sloop with something smarter.
         i_0=i_0+ob_random.rand(900)
         i_0=i_0*(1+ob_random.rand(900))
      end # loop
      i_n_of_loops=(i_0+i_00+i_rand_whoami_ps)%200
      i_0=42
      i_n_of_loops.times do # scrolls the sequence to a semi-random position
         i_0=i_0+ob_random.rand(200)
      end # loop
      @ob_gen_instance_of_class_random_t1_optimization_blocker_1=i_0
      #-----------
      return ob_random
   end # ob_gen_instance_of_class_random_t1

   public

   def initialize
      @i_rand_whoami=(`whoami`).length
      @i_rand_impl_1_ob_random=ob_gen_instance_of_class_random_t1()
      #---------
      @i_rand_impl_1_i_rand_ps=(`ps -A`).length
      @i_rand_impl_1_callcount_ob_random=0
      @i_rand_impl_1_callcount_i_rand_ps=0
      @ob_gen_instance_of_class_random_t1_optimization_blocker_1=42
      #--------------
      @i_random_fast_t1_ob_random=ob_gen_instance_of_class_random_t1()
   end # initialize

   private


   # Output will be in the range of [0,i_max]
   # min(i_max)== 0
   def i_rand_impl_1(i_max,i_n_of_calls_between_the_renewal_of_ob_random,
      i_n_of_calls_between_the_renewal_of_i_rand_ps)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Fixnum,Bignum], i_max
         kibuvits_typecheck bn, [Fixnum], i_n_of_calls_between_the_renewal_of_ob_random
         kibuvits_typecheck bn, [Fixnum,Bignum], i_n_of_calls_between_the_renewal_of_i_rand_ps
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_max,"\n GUID='98e8f72a-6bb4-41a8-94a2-e1b071c1bed7'\n\n")
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_n_of_calls_between_the_renewal_of_ob_random,
         "\n GUID='a5135e2c-f5a9-44de-84a2-e1b071c1bed7'\n\n")
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_n_of_calls_between_the_renewal_of_i_rand_ps,
         "\n GUID='40c99344-16f3-4bc9-a2a2-e1b071c1bed7'\n\n")
      end # if
      #----------------------
      if i_n_of_calls_between_the_renewal_of_ob_random<=@i_rand_impl_1_callcount_ob_random
         @i_rand_impl_1_callcount_ob_random=0
         @i_rand_impl_1_ob_random=ob_gen_instance_of_class_random_t1()
      else
         @i_rand_impl_1_callcount_ob_random=@i_rand_impl_1_callcount_ob_random+1
      end # if
      ob_random=@i_rand_impl_1_ob_random
      #----------------------
      if 0<i_n_of_calls_between_the_renewal_of_i_rand_ps
         if i_n_of_calls_between_the_renewal_of_i_rand_ps<=@i_rand_impl_1_callcount_i_rand_ps
            @i_rand_impl_1_callcount_i_rand_ps=0
            @i_rand_impl_1_i_rand_ps=(`ps -A`).length
         else
            @i_rand_impl_1_callcount_i_rand_ps=@i_rand_impl_1_callcount_i_rand_ps+1
         end # if
      end # if
      i_rand_ps=@i_rand_impl_1_i_rand_ps
      i_rand_whoami_ps=@i_rand_whoami+i_rand_ps
      #----------------------
      i_max_plus_one=i_max+1 # because ( max(Random.rand(n)) == (n-1) )
      i_0=0
      3.times {i_0=i_0+ob_random.rand(i_max_plus_one)}
      ob_t=Time.now
      i_usec=ob_t.usec
      i_0=i_0+(i_usec+i_rand_whoami_ps)
      i_out=i_0%i_max_plus_one
      return i_out
   end # i_rand_impl_1


   public

   # Returns a whole number in range [0,i_max]
   # min(i_max)== 0
   def i_random_t1(i_max)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Fixnum,Bignum], i_max
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_max,"\n GUID='6d76d710-d3db-4e08-b1a2-e1b071c1bed7'\n\n")
      end # if
      ob_random=@i_rand_impl_1_ob_random
      i_0=ob_random.rand(100)
      i_1=ob_random.rand(300)
      i_out=i_rand_impl_1(i_max,(300+i_0),(3013+i_1))
      return i_out
   end # i_random_t1

   def Kibuvits_rng.i_random_t1(i_max)
      i_out=Kibuvits_rng.instance.i_random_t1(i_max)
      return i_out
   end # Kibuvits_rng.i_random_t1

   #-----------------------------------------------------------------------

   # Returns a whole number in range [0,i_max]
   # min(i_max)== 1
   def i_random_fast_t1(i_max)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Fixnum,Bignum], i_max
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_max,"\n GUID='8aaa3036-b136-48c7-a5a2-e1b071c1bed7'\n\n")
      end # if
      i_out=@i_random_fast_t1_ob_random.rand(i_max+1)
      return i_out
   end # i_random_fast_t1

   def Kibuvits_rng.i_random_fast_t1(i_max)
      i_out=Kibuvits_rng.instance.i_random_fast_t1(i_max)
      return i_out
   end # Kibuvits_rng.i_random_fast_t1

   #-----------------------------------------------------------------------
   include Singleton

end # class Kibuvits_rng

#=========================================================================
#puts "A random number: "+Kibuvits_rng.i_random_t1(10).to_s

