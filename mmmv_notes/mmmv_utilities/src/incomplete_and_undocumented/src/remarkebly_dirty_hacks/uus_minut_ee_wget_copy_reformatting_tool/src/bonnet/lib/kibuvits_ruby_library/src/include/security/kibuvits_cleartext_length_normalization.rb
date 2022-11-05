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

require  KIBUVITS_HOME+"/src/include/security/kibuvits_hash_plaice_t1.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"

#==========================================================================


# The idea is that cryptotext length should not
# reveal cleartext length.
#
# http://longterm.softf1.com/2014/codedoc/cleartext_length_t1/
#

class Kibuvits_cleartext_length_normalization
   @@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1=10000
   @@s_format_version_t1="Kibuvits_cleartext_length_normalization.s_normalize_t1.v2".freeze
   @@s_failure_id_checksum_failure_t1="text_length_denormalization_checksum_failure_t1".freeze

   def initialize
      @s_lc_s_charstream_1="s_charstream_1".freeze
      @s_lc_s_charstream_2="s_charstream_2".freeze
      @s_lc_s_charstream_3="s_charstream_3".freeze
      #------
      @ar_of_key_candidates=Array.new
      @ar_of_key_candidates<<$kibuvits_lc_s_format_version
      @ar_of_key_candidates<<@s_lc_s_charstream_1
      @ar_of_key_candidates<<@s_lc_s_charstream_2
      @ar_of_key_candidates<<@s_lc_s_charstream_3
      @ar_of_key_candidates<<$kibuvits_lc_s_checksum_hash
      @ar_of_key_candidates.freeze
   end # initialize

   #-----------------------------------------------------------------------

   def i_val_t2(i_in)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Integer, i_in
      end # if
      i_out=(i_in.to_r/3).floor*2
      return i_out
   end # i_val_t2

   def Kibuvits_cleartext_length_normalization.i_val_t2(i_in)
      i_out=Kibuvits_cleartext_length_normalization.instance.i_val_t2(i_in)
      return i_out
   end # Kibuvits_cleartext_length_normalization.i_val_t2

   #-----------------------------------------------------------------------

   private

   def s_gen_charstream(i_charstream_len,b_use_fast_random)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Integer, i_charstream_len
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_use_fast_random
      end # if
      ar_charstream=Kibuvits_security_core.ar_random_charstream_t1(
      i_charstream_len,b_use_fast_random)
      s_charstream=kibuvits_s_concat_array_of_strings(ar_charstream)
      ar_charstream.clear # may be it helps a little
      return s_charstream
   end # s_gen_charstream

   #-----------------------------------------------------------------------

   public

   # This function mainly exists to wrap the
   # hash calculation parameters.
   # Normalization and de-normalization must
   # both use the same hashing algorithm with
   # the same parameters.
   #
   # It's public to facilitate testing.
   def s_calc_checksum_hash_t1(s_in)
      i_headerless_hash_length=8
      # The hash implementation will probably
      # increase the number of rounds anyways.
      i_minimum_n_of_rounds=1
      s_out=kibuvits_hash_plaice_t1(s_in,
      i_headerless_hash_length,i_minimum_n_of_rounds)
      return s_out
   end # s_calc_checksum_hash_t1

   def Kibuvits_cleartext_length_normalization.s_calc_checksum_hash_t1(s_in)
      s_out=Kibuvits_cleartext_length_normalization.instance.s_calc_checksum_hash_t1(s_in)
      return s_out
   end # Kibuvits_cleartext_length_normalization.s_calc_checksum_hash_t1

   #-----------------------------------------------------------------------

   # Returns a ProgFTE_v1 string. The s_in
   # should be extracted from the ProgFTE by using
   # s_normalize_t1_extract_cleartext(s_normalized_text)
   #
   def s_normalize_t1(s_in,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=@@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1,
      b_use_fast_random=false,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=i_val_t2(
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts))
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_in
         kibuvits_typecheck bn, Integer, i_estimated_median_of_lengths_of_nonnormalized_cleartexts
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_use_fast_random
         kibuvits_typecheck bn, Integer, i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='ab6ee9d2-6fb4-4026-a149-60c100d1ced7'\n\n")
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='16a3c914-878d-432b-8449-60c100d1ced7'\n\n")
      end # if
      #---------
      i_normalized_cleartext_len_min=i_estimated_median_of_lengths_of_nonnormalized_cleartexts+
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
      i_charstream_len_sum=i_normalized_cleartext_len_min
      i_len_s_in=s_in.length
      if i_len_s_in<i_normalized_cleartext_len_min
         i_charstream_len_sum=i_normalized_cleartext_len_min-i_len_s_in
      end # if
      i_randdelta_max=2*i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
      if 0<i_randdelta_max # It's OK for the standard deviation to be 0. Series of constants are like that.
         if b_use_fast_random
            i_charstream_len_sum=i_charstream_len_sum+Kibuvits_rng.i_random_fast_t1(i_randdelta_max)
         else
            i_charstream_len_sum=i_charstream_len_sum+Kibuvits_rng.i_random_t1(i_randdelta_max)
         end # if
      end # if
      #---------
      i_charstream_len_1=0
      i_charstream_len_3=0
      if 0<i_charstream_len_sum
         i_max=i_charstream_len_sum-1
         if b_use_fast_random
            i_charstream_len_1=Kibuvits_rng.i_random_fast_t1(i_max)
         else
            i_charstream_len_1=Kibuvits_rng.i_random_t1(i_max)
         end # if
      end # if
      i_charstream_len_3=i_charstream_len_sum-i_charstream_len_1
      #------------------------------
      # The idea is that the s_in should be "anywhere"
      # within the normalized string. The solution:
      # <randomcharstream_with_random_length><s_in><randomcharstream_with_random_length>
      ht=Hash.new
      ht[$kibuvits_lc_s_format_version]=@@s_format_version_t1
      ht[@s_lc_s_charstream_1]=s_gen_charstream(i_charstream_len_1,b_use_fast_random)
      ht[$kibuvits_lc_s_checksum_hash]=s_calc_checksum_hash_t1(s_in)
      ht[@s_lc_s_charstream_2]=s_in
      ht[@s_lc_s_charstream_3]=s_gen_charstream(
      i_charstream_len_3,b_use_fast_random)
      #---------
      s_progfte=Kibuvits_ProgFTE.from_ht(ht)
      #---------
      # To mitigate the situation, where ProgFTE
      # header characters and the very last "|"
      # reveal information about the key that encrypts them,
      # a random length random charstream prefix and suffix are used.
      i_max=400+(0.01*i_estimated_median_of_lengths_of_nonnormalized_cleartexts.to_f).round
      i_charstream_prefix_len=0
      rgx_for_func=/[v\d|\n\r\s]/
      func_gen_prefix_or_suffix_charstream=lambda do
         if b_use_fast_random
            i_charstream_prefix_len=Kibuvits_rng.i_random_fast_t1(i_max)
         else
            i_charstream_prefix_len=Kibuvits_rng.i_random_t1(i_max)
         end # if
         #---------
         # The "v" and digits are removed from the prefix to allow
         # ProgFTE format version detection to detect that the
         # s_normalized is not in ProgFTE_v0 nor in ProgFTE_v1
         # The pillar is removed from the charstreams to allow the
         # charstreams to be stripped from the prefix and suffix of
         # ProgFTE string.
         #
         # What regards to the efficiency of this solution,
         # then that depends on, how string reversal has been
         # implemented in ruby. As of 2014_12 on a 3GHz machine
         # a 10 million character string is reversed in
         # a fraction of a second.
         #
         s_charstream=s_gen_charstream(i_charstream_prefix_len,
         b_use_fast_random).gsub(rgx_for_func,$kibuvits_lc_emptystring)
         return s_charstream
      end # func_gen_prefix_or_suffix_charstream
      #---------
      s_prefix=func_gen_prefix_or_suffix_charstream.call()
      s_prefix<<$kibuvits_lc_pillar
      s_suffix=func_gen_prefix_or_suffix_charstream.call()
      s_normalized=s_prefix+s_progfte
      s_normalized<<s_suffix # faster than "+", if the Ruby.String preallocation covers s_suffix.length
      return s_normalized
   end # s_normalize_t1

   def Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=@@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1,
      b_use_fast_random=false,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=Kibuvits_cleartext_length_normalization.i_val_t2(
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts))

      s_out=Kibuvits_cleartext_length_normalization.instance.s_normalize_t1(s_in,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts,b_use_fast_random,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts)
      return s_out
   end # Kibuvits_cleartext_length_normalization.s_normalize_t1

   #-----------------------------------------------------------------------

   private

   # A bit short for a separate method, but keeps code organized.
   def s_normalize_t1_extract_cleartext_add_x_data_2_msgc(ht,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         #msgcs.assert_lack_of_failures("GUID='375dda3f-3d25-45a6-a439-60c100d1ced7'")
      end # if
      msgc=msgcs.last
      msgc.x_data=ht
   end # s_normalize_t1_extract_cleartext_add_x_data_2_msgc

   def s_verify_cleartext_integrity(ht,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         msgcs.assert_lack_of_failures("GUID='1f5705e2-b090-4b86-8639-60c100d1ced7'")
      end # if
      s_cleartext=ht[@s_lc_s_charstream_2]
      s_hash_orig=ht[$kibuvits_lc_s_checksum_hash]
      s_hash_calc=s_calc_checksum_hash_t1(s_cleartext)
      if s_hash_orig!=s_hash_calc
         s_default_msg="The hash of the cleartext within the "+
         "normalized text (==\n"+s_hash_orig+"\n) "+
         "differs from the hash that is calculated from the de-normalized text(==\n"+
         s_hash_calc+"\n).\n"
         s_message_id=@@s_failure_id_checksum_failure_t1
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "3cb11cf5-f8ff-4327-8349-60c100d1ced7")
         s_normalize_t1_extract_cleartext_add_x_data_2_msgc(ht,msgcs)
      end # if
      return s_cleartext
   end # s_verify_cleartext_integrity


   public

   # The s_in is expected to be the output of the s_normalize_t1(...)
   def s_normalize_t1_extract_cleartext(s_in,msgcs)
      bn=binding()
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck bn, String, s_in
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='5ce63d3e-e371-40d5-8239-60c100d1ced7'")
      end # if
      #-------
      ix_0=s_in.index($kibuvits_lc_pillar)        # "xx|abc|yyy".index("|") == 2
      s_progfte_plus_suffix=s_in[(ix_0+1)..(-1)]  #    "abc|yyy"
      s_0=s_progfte_plus_suffix.reverse           #    "yyy|cba"
      ix_0=s_0.index($kibuvits_lc_pillar)         #    "yyy|cba".index("|") == 3
      s_progfte=s_0[(ix_0)..(-1)].reverse         #    "abc|"
      #-------
      ht=Kibuvits_ProgFTE.to_ht(s_progfte)
      kibuvits_assert_ht_has_keys(bn,ht,@ar_of_key_candidates,
      "GUID='3a013069-464b-4ac3-8339-60c100d1ced7'")
      s_format_version=ht[$kibuvits_lc_s_format_version]
      if s_format_version!=@@s_format_version_t1
         s_default_msg="The s_format_version == "+s_format_version+
         "\nbut "+@@s_format_version_t1+" is expected.\n"
         s_message_id="text_length_denormalization_failure_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "72a3e759-1a16-45a0-a449-60c100d1ced7")
         s_normalize_t1_extract_cleartext_add_x_data_2_msgc(ht,msgcs)
      end # if
      s_out=s_verify_cleartext_integrity(ht,msgcs)
      return s_out
   end # s_normalize_t1_extract_cleartext


   def Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_in,msgcs)
      s_out=Kibuvits_cleartext_length_normalization.instance.s_normalize_t1_extract_cleartext(
      s_in,msgcs)
      return s_out
   end # Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext

   #-----------------------------------------------------------------------

   def Kibuvits_cleartext_length_normalization.i_const_t1
      i_out=@@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1
      return i_out
   end # Kibuvits_cleartext_length_normalization.i_const_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_cleartext_length_normalization

#=========================================================================

# s_cleartext="aa"
# s_normalized=Kibuvits_cleartext_length_normalization.s_normalize_t1(
# s_cleartext,42) # 42 is too short for real data
# puts "\nNormalized text:\n"+s_normalized+"\n\n"
# s_denormalized=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
# s_normalized,$kibuvits_msgc_stack)
# puts "denormalized text:\n"+s_denormalized+"\n\n"
