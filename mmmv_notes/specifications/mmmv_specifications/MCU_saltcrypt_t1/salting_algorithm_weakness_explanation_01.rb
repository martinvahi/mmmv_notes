#!/usr/bin/env ruby
#==========================================================================
=begin 
 Initial author of this file: Martin.Vahi@softf1.com
 This file is in public domain.
 The following line is a spdx.org license label line:
 SPDX-License-Identifier: 0BSD
---------------------------------------------------------------------------
 Tested with ("ruby -v")

ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]

 on ("uname -a")

Linux terminal01 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux
---------------------------------------------------------------------------
=end
#--------------------------------------------------------------------------

# The 4-bit container can be seen as an array with 4 elements:
#
#     ar_container = [
#                    (b_random_bit_0 or b_cleartext_bit),
#                    (b_random_bit_1 or b_cleartext_bit)
#                    b_random_bit_2,
#                    b_random_bit_3,
#                    ]
#
# This code demonstrates that if the ar_container[0] or ar_container[1],
# where the b_cleartext_bit may reside, is encrypted with the exact
# same b_cryptokey_bit while the b_cleartext_bit is constant, then
# the salting fails to hide the value of the
#
#     b_cryptotext_bit = XOR(b_cryptokey_bit, b_cleartext_bit)
#
# If the b_cleartext_bit depicts some "standard value"
# of some protocol, let's say, a "standard string" like a name of
# a field at some business application or XML/JSON file header, then
#
#     b_cryptokey_bit = XOR(b_cryptotext_bit, b_cleartext_bit)
#
# can allow the attacker to reveal some of the cryptokey.
# The scheme is that 50% of the cryptotext bit samples are
#
#     b_cryptotext_bit = XOR(b_cryptokey_bit,b_random_bit_with_uniform_distribution)
#
# and the rest of the samples, the other 50% of the
# cryptotext bit samples, are constant.
#
#     b_cryptotext_bit = XOR(b_cryptokey_bit, b_cleartext_bit)
#
# That is to say, with enough cryptotext samples,
# the distribution of true/1 and false/0 will be :
# 75% of one of the values(true/1 or false/0) and
# 25%  of the opposite value. The problem would be
# solved, if the distribution is 50% and 50%.
#
# A possible countermeasure MIGHT be to view the cryptokey bitstream
# as a circular register and "shift" the starting point, the "bit at position 0",
# by some random amount and write that random shift distance to the start of the
# cleartext bitstream. Encrypt/decrypt that random number without
# shifting the cryptokey bitstream and encrypt/decrypt the rest
# after shifting the cryptokey bitstream. Part of the idea is that
# this salting weakness is not a problem if cleartext consists of
# one-time-use random bits and that shifting distance is exactly
# that: a one-time-use random set of bits.
#
# This demo depicts only one of the ar_container bits, which is
# either the ar_container[0] or the ar_container[1], the positions,
# where the b_cleartext_bit can reside.
#
# The coding style here is that of an "academic hack", id est
# it lacks the checks that are required at production code.
class Salting_weakness_demo

   def b_generate_random_bit
      b_out=true
      b_out=false if rand(2)==0
      return b_out
   end # b_generate_random_bit

   def initialize
      @b_cryptokey_bit=b_generate_random_bit()
   end # initialize

   private

   def xor(b_0,b_1)
      b_out=false
      b_out=true if b_0!=b_1
      return b_out
   end # xor

   def s_summary(i_n_of_cryptotext_0_bits,i_n_of_cryptotext_1_bits)
      s_out="\n"
      #--------------------
      i_n_of_all_bits=i_n_of_cryptotext_0_bits+i_n_of_cryptotext_1_bits
      fd_n_of_all_bits=i_n_of_all_bits.to_f
      i_round_n_of_digits=7
      fd_percentage_0_bits=((i_n_of_cryptotext_0_bits.to_f)/fd_n_of_all_bits).round(i_round_n_of_digits)
      fd_percentage_1_bits=((i_n_of_cryptotext_1_bits.to_f)/fd_n_of_all_bits).round(i_round_n_of_digits)
      s_0=fd_percentage_0_bits.to_s
      s_1=fd_percentage_1_bits.to_s
      #--------------------
      s_out<<"\n"
      s_out<<("i_n_of_cryptotext_0_bits == "+i_n_of_cryptotext_0_bits.to_s+"  "+s_0+"% \n")
      s_out<<("i_n_of_cryptotext_1_bits == "+i_n_of_cryptotext_1_bits.to_s+"  "+s_1+"% \n")
      s_out<<"\n"
      #--------------------
      return s_out
   end # s_summary

   public

   def run_demo(i_n_of_intercepted_cryptotext_samples_div_2=500)
      # It's a bit dumb to even writhe this code here, because
      # the result can be derived analytically, but here it goes...
      #--------------------
      b_cryptotext_bit=nil
      i_n_of_cryptotext_0_bits=0
      i_n_of_cryptotext_1_bits=0
      func_count_cryptotext_bits=lambda do |b_bit|
         if b_cryptotext_bit
            i_n_of_cryptotext_1_bits=i_n_of_cryptotext_1_bits+1
         else
            i_n_of_cryptotext_0_bits=i_n_of_cryptotext_0_bits+1
         end # if
      end # func_count_cryptotext_bits
      #--------------------
      i_n_of_intercepted_cryptotext_samples_div_2.times do
         b_cryptotext_bit=xor(@b_cryptokey_bit,b_generate_random_bit())
         func_count_cryptotext_bits.call(b_cryptotext_bit)
      end #loop
      b_cleartext_bit=b_generate_random_bit()
      i_n_of_intercepted_cryptotext_samples_div_2.times do
         b_cryptotext_bit=xor(@b_cryptokey_bit,b_cleartext_bit)
         func_count_cryptotext_bits.call(b_cryptotext_bit)
      end #loop
      #--------------------
      puts(s_summary(i_n_of_cryptotext_0_bits,i_n_of_cryptotext_1_bits))
   end # run_demo
end # class Salting_weakness_demo

if ARGV[0]!=nil
   Salting_weakness_demo.new.run_demo(ARGV[0].to_i)
else
   Salting_weakness_demo.new.run_demo
end # if
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="928d7ee3-4c62-45ec-83ac-4172d030c6e7"
#==========================================================================
