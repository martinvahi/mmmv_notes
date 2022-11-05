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

require  KIBUVITS_HOME+"/src/include/security//kibuvits_cleartext_length_normalization.rb"

#==========================================================================

class Kibuvits_cleartext_length_normalization_selftests
   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_cleartext_length_normalization_selftests.test_1
      #------------------
      msgcs=Kibuvits_msgc_stack.new
      s_in="abcd".freeze
      i_median=1000
      i_deviation=300
      #------------------
      b_use_fast_random=false
      s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_median, b_use_fast_random,i_deviation)
      kibuvits_throw "test 1a " if s_x_n.length<=i_median
      s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_x_n,msgcs)
      kibuvits_throw "test 1b " if msgcs.b_failure
      kibuvits_throw "test 1c " if s_in.object_id==s_x_n.object_id
      kibuvits_throw "test 1d " if s_in==s_x_n
      kibuvits_throw "test 1e " if s_in!=s_x_dn
      #--
      kibuvits_throw "test 1f " if s_in.object_id==s_x_dn.object_id # stupid, but correct
      kibuvits_throw "test 1g " if s_x_dn!="abcd"
      #------------------
      b_use_fast_random=true
      s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_median, b_use_fast_random,i_deviation)
      kibuvits_throw "test 2a " if s_x_n.length<=i_median
      s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_x_n,msgcs)
      kibuvits_throw "test 2b " if msgcs.b_failure
      kibuvits_throw "test 2c " if s_in.object_id==s_x_n.object_id
      kibuvits_throw "test 2d " if s_in==s_x_n
      kibuvits_throw "test 2e " if s_in!=s_x_dn
      #------------------
      i_median=0
      s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_median, b_use_fast_random,i_deviation)
      kibuvits_throw "test 3a " if s_x_n.length<=i_median
      s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_x_n,msgcs)
      kibuvits_throw "test 3b " if msgcs.b_failure
      kibuvits_throw "test 3c " if s_in.object_id==s_x_n.object_id
      kibuvits_throw "test 3d " if s_in==s_x_n
      kibuvits_throw "test 3e " if s_in!=s_x_dn
      #------------------
      # with default i_deviation
      s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_median, b_use_fast_random)
      kibuvits_throw "test 4a " if s_x_n.length<=i_median
      s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_x_n,msgcs)
      kibuvits_throw "test 4b " if msgcs.b_failure
      kibuvits_throw "test 4c " if s_in.object_id==s_x_n.object_id
      kibuvits_throw "test 4d " if s_in==s_x_n
      kibuvits_throw "test 4e " if s_in!=s_x_dn
      #------------------
      i_median=0
      i_deviation=0
      s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_median, b_use_fast_random,i_deviation)
      kibuvits_throw "test 5a " if s_x_n.length<=i_median
      s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_x_n,msgcs)
      kibuvits_throw "test 5b " if msgcs.b_failure
      kibuvits_throw "test 5c " if s_in.object_id==s_x_n.object_id
      kibuvits_throw "test 5d " if s_in==s_x_n
      kibuvits_throw "test 5e " if s_in!=s_x_dn
      #------------------
      i_median=0
      i_deviation=20000
      s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
      i_median, b_use_fast_random,i_deviation)
      kibuvits_throw "test 6a " if s_x_n.length<=i_median
      s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_x_n,msgcs)
      kibuvits_throw "test 6b " if msgcs.b_failure
      kibuvits_throw "test 6c " if s_in.object_id==s_x_n.object_id
      kibuvits_throw "test 6d " if s_in==s_x_n
      kibuvits_throw "test 6e " if s_in!=s_x_dn
      #------------------
      kibuvits_throw "test 7 " if s_in!="abcd" # just in case
      #------------------
      # Tests linebreaks and frozen input at once.
      s_in_2="aa\nbb".freeze
      begin
         s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in_2)
      rescue Exception => e
         kibuvits_throw "test 8 e.to_s=="+e.to_s
      end # rescue
      #------------------
   end # Kibuvits_cleartext_length_normalization_selftests.test_1

   #-----------------------------------------------------------------------

   def Kibuvits_cleartext_length_normalization_selftests.test_denormalization_hash_check
      # The following is a ProgFTE specific hack that
      # intentionally ruins the cleartext. That way the
      # actual checksum and the checksum in the container
      # should, probabilistically, differ. Due to
      # the random charstreams in the normalized string,
      # there might be more than one place, where
      # a string that corresponds to one of the hashtable keys is written.
      # To avoid re-writing the whole parsing code and
      # duplicating the flaws of the testable code,
      # this test is probabilistic. The loop is to
      # further reduce the otherwise small probability that this
      # test is omitted due to unsuitable random charstreams.
      #-----------
      s_lc_1="s_charstream_2|".freeze
      func_corrupt_container=lambda do |s_container|
         # An excerpt of the ProgFTE_v1 string:
         #     s_charstream_2|<string length in decimal digits>|<the string>|
         #---
         bn=binding()
         ix_s_lc_1_first_char=s_container.index(s_lc_1) # "abcde".index("b")==1
         kibuvits_typecheck(bn, Integer, ix_s_lc_1_first_char,
         "GUID='258bc145-45ca-4875-8207-a3b100d1ced7'")
         ix_first_strlen_digit=ix_s_lc_1_first_char+s_lc_1.length
         ix_first_char_of_the_value=s_container.index(
         $kibuvits_lc_pillar,ix_first_strlen_digit)+1
         kibuvits_typecheck(bn, Integer, ix_first_char_of_the_value,
         "GUID='96135f31-99bb-4ef1-b507-a3b100d1ced7'")
         if s_container[ix_first_char_of_the_value]==$kibuvits_lc_pillar
            kibuvits_throw("This function assumes that the "+
            "cleartext consists of at least one character. "+
            "GUID='804db148-51fe-42a3-8107-a3b100d1ced7'")
         end # if
         s_out=s_container[0..(ix_first_char_of_the_value-1)]+"X"+
         s_container[(ix_first_char_of_the_value+1)..(-1)]
         if s_out==s_container
            s_out=s_container[0..(ix_first_char_of_the_value-1)]+"Z"+
            s_container[(ix_first_char_of_the_value+1)..(-1)]
         end # if
         if s_out.length!=s_container.length
            kibuvits_throw("The test code has a flaw.\n"+
            "GUID='7524ad04-832f-4e7d-8507-a3b100d1ced7'")
         end # if
         return s_out
      end # func_corrupt_container
      #----
      s_x_in=s_lc_1+"1|f|"
      s_x=func_corrupt_container.call(s_x_in)
      if s_x.object_id==s_x_in.object_id
         kibuvits_throw("The test code has a flaw.\n"+
         "GUID='55d3a618-ccd7-4842-8407-a3b100d1ced7'")
      end # if
      if s_x!=(s_lc_1+"1|X|")
         kibuvits_throw("The test code has a flaw.\n"+
         "GUID='5773c129-1792-4e1a-b407-a3b100d1ced7'")
      end # if
      if s_x.length!=s_x_in.length # only partly duplicates the previous test
         kibuvits_throw("The test code has a flaw.\n"+
         "GUID='a901dc3a-7a40-4b4c-b407-a3b100d1ced7'")
      end # if
      #----
      s_x_in=s_lc_1+"1|Xabc|"
      s_x=func_corrupt_container.call(s_x_in)
      if s_x!=(s_lc_1+"1|Zabc|")
         kibuvits_throw("The test code has a flaw.\n"+
         "GUID='31452c71-7677-443a-aa07-a3b100d1ced7'")
      end # if
      #------
      s_in="abcd\nefg".freeze
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=500 # smaller than the default
      b_use_fast_random=true
      20.times do
         s_x_n=Kibuvits_cleartext_length_normalization.s_normalize_t1(s_in,
         i_estimated_median_of_lengths_of_nonnormalized_cleartexts,b_use_fast_random)
         i_strcount=Kibuvits_str.i_count_substrings(s_x_n,s_lc_1)
         if i_strcount<1
            kibuvits_throw("This selftest is flawed. "+
            "GUID='42362f25-a500-4476-9507-a3b100d1ced7'")
         end # if
         next if 1<i_strcount
         msgcs=Kibuvits_msgc_stack.new
         msgcs.assert_lack_of_failures # Should bugs creap into the Kibuvits_msgc_stack.
         s_x_dn=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
         ($kibuvits_lc_emptystring+s_x_n),msgcs)
         if msgcs.b_failure
            kibuvits_throw("test 1 \n"+
            "GUID='a166019b-3074-4bb5-a907-a3b100d1ced7'")
         end # if
         s_x_n_corrupted=func_corrupt_container.call(s_x_n)
         s_x=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
         s_x_n_corrupted,msgcs)
         if !msgcs.b_failure
            kibuvits_throw("test 2 \n"+
            "GUID='5d0eb9ed-efcc-48e0-a2f6-a3b100d1ced7'")
         end # if
         s_hash_container=(msgcs.last.x_data)[$kibuvits_lc_s_checksum_hash]
         s_hash_calc=Kibuvits_cleartext_length_normalization.s_calc_checksum_hash_t1(s_in)
         if s_hash_container!=s_hash_calc
            kibuvits_throw("test 3 \n"+
            "s_hash_container == "+s_hash_container+
            " != s_hash_calc == "+s_hash_calc+
            "\nGUID='0dc9af39-3da0-4576-a3f6-a3b100d1ced7'")
         end # if
         break # The loop was only to cope with the randomness in the random charstreams.
      end # loop
   end # Kibuvits_cleartext_length_normalization_selftests.test_denormalization_hash_check

   #-----------------------------------------------------------------------

   public
   def Kibuvits_cleartext_length_normalization_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_cleartext_length_normalization_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_cleartext_length_normalization_selftests.test_denormalization_hash_check"
      return ar_msgs
   end # Kibuvits_cleartext_length_normalization_selftests.selftest

end # class Kibuvits_cleartext_length_normalization_selftests

#==========================================================================
#puts Kibuvits_cleartext_length_normalization_selftests.selftest.to_s

