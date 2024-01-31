#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
# Tested with ("ruby -v")
#
# ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]
#
#  on ("uname -a")
#
# Linux terminal01 6.1.0-12-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.52-1 (2023-09-07) x86_64 GNU/Linux
#==========================================================================

# As of 2024_01 one way to install the gem at the next line
require          "kibuvits_ruby_library_krl171bt4_"
# is "gem install kibuvits_ruby_library_krl171bt4_" .
# Alternatively there MIGHT be the 
#     ./dependencies/2024_01_26_kibuvits_ruby_library_krl171bt4_.tar.lz

#==========================================================================

class Experiment_main

   def initialize
   end # initialize

   #-----------------------------------------------------------------------
   private

   def i_get_n_of_bits_in_bitstream()
      i_out=1000 # the default
      s_argv=ARGV[0].to_s
      s_0=s_argv.gsub(/[^0123456789]/,$kibuvits_krl171bt4_lc_emptystring)
      if s_0 != $kibuvits_krl171bt4_lc_emptystring
         i_out=s_0.to_i
      end # if
      return i_out
   end # i_get_n_of_bits_in_bitstream

   #-----------------------------------------------------------------------

   # key   --- zerobitchain_length
   # value --- number of zerobitchains with the given length
   def ht_count_zerobitchains_add_to_ht(ht_counts,i_zerobitchain_length)
      if KIBUVITS_krl171bt4_b_DEBUG
         bn=binding()
         kibuvits_krl171bt4_typecheck bn, Hash, ht_counts
         kibuvits_krl171bt4_typecheck bn, [Integer,Fixnum,Bignum], i_zerobitchain_length
         kibuvits_krl171bt4_assert_is_smaller_than_or_equal_to(bn,
         1, i_zerobitchain_length,
         "GUID='3e24d554-03d1-4239-aa22-a39371c118e7'")
      end # if
      if ht_counts.has_key? i_zerobitchain_length
         i_0=ht_counts[i_zerobitchain_length]
         i_0=i_0+1
         ht_counts[i_zerobitchain_length]=i_0
      else
         ht_counts[i_zerobitchain_length]=1
      end # if
   end # ht_count_zerobitchains_add_to_ht

   #-----------------------------------------------------------------------

   # In the context of this method/function a "zerobitchain" is
   # a bitstream that consists of only zeros.
   #
   # key   --- zerobitchain_length
   # value --- number of zerobitchains with the given length
   def ht_count_zerobitchains(i_n_of_bits_in_bitstream,ob_histogram)
      #----------------------------------------
      if KIBUVITS_krl171bt4_b_DEBUG
         bn=binding()
         kibuvits_krl171bt4_typecheck bn, [Integer,Fixnum,Bignum], i_n_of_bits_in_bitstream
         kibuvits_krl171bt4_typecheck bn, Kibuvits_krl171bt4_histogram_t1, ob_histogram
      end # if
      kibuvits_krl171bt4_assert_is_smaller_than_or_equal_to(bn,
      1, i_n_of_bits_in_bitstream,
      "GUID='71b886c1-e0b1-4566-b0d2-a39371c118e7'")
      #----------------------------------------
      ht_counts=Hash.new
      b_counting=false
      i_zerobitchain_length=0
      i_n_of_bits_in_bitstream.times do
         if rand(2) == 1
            if b_counting
               ht_count_zerobitchains_add_to_ht(ht_counts,i_zerobitchain_length)
               ob_histogram.count(i_zerobitchain_length)
               i_zerobitchain_length=0
               b_counting=false
            end # if
         else # == 0
            if b_counting
               i_zerobitchain_length=i_zerobitchain_length+1
            else
               i_zerobitchain_length=1
               b_counting=true
            end # if
         end # if
      end #loop
      if b_counting
         ht_count_zerobitchains_add_to_ht(ht_counts,i_zerobitchain_length)
         ob_histogram.count(i_zerobitchain_length)
      end # if
      #----------------------------------------
      return ht_counts
   end # ht_count_zerobitchains

   #-----------------------------------------------------------------------

   public

   def run_experiment()
      i_n_of_bits_in_random_bitstream=i_get_n_of_bits_in_bitstream()
      i_n_of_columns=20
      ob_histogram=Kibuvits_krl171bt4_histogram_t1.new(0,20,i_n_of_columns)
      ht_counts=ht_count_zerobitchains(i_n_of_bits_in_random_bitstream,ob_histogram)
      s_histogram=ob_histogram.to_s()
      puts("\ni_n_of_bits_in_random_bitstream == "+i_n_of_bits_in_random_bitstream.to_s+"\n")
      puts(s_histogram)
      puts ht_counts.to_s+"\n\n"
   end # run_experiment

end # class Experiment_main

ob=Experiment_main.new
ob.run_experiment()

#==========================================================================
# S_VERSION_OF_THIS_FILE="2ad3d772-7c48-41f8-a132-a39371c118e7"
#==========================================================================
