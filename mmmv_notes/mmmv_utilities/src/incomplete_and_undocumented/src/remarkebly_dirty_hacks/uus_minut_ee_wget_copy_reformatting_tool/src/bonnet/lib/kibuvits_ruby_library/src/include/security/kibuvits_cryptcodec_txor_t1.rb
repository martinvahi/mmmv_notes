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

require  KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
require  KIBUVITS_HOME+"/src/include/security/kibuvits_cleartext_length_normalization.rb"

#==========================================================================

class Kibuvits_cryptcodec_txor_t1
   @@i_n_of_datasalt_digits=7
   @@i_key_param_max_number_of_bytes_per_character=7

   def initialize
      @s_key_type_t1="kibuvits_series_of_whole_numbers_t2"
      @s_lc_s_key_type="s_key_type"
      @s_lc_i_n_of_datasalt_digits="i_n_of_datasalt_digits".freeze
      @s_lc_i_saltfree_data_max="i_saltfree_data_max".freeze
      @s_cryptocodec_type_t1="kibuvits_wearlevelling_t1d"
      @s_lc_s_key_id="s_key_id"
   end # initialize

   private

   # http://longterm.softf1.com/specifications/txor/
   def txor(aa,bb,m)
      i_out=((bb-aa+m)%m)
      return i_out
   end # txor(aa,bb,m)

   def txor_encrypt(i_cleartext,i_key,i_m)
      i_out=txor(i_cleartext,i_key,i_m)
      return i_out
   end # txor_encrypt

   def txor_decrypt(i_ciphertext,i_key,i_m)
      i_out=txor(i_ciphertext,i_key,i_m)
      return i_out
   end # txor_decrypt

   public

   def ht_generate_key_t1(i_key_length,
      i_max_number_of_bytes_per_character=@@i_key_param_max_number_of_bytes_per_character)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Integer, i_key_length
         kibuvits_typecheck bn, Integer, i_max_number_of_bytes_per_character
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         1, [i_key_length,i_max_number_of_bytes_per_character],
         "\n GUID='3ca43724-a7b2-4925-85d8-507100601fd7'")
      end # if
      ht_key=Hash.new
      ht_key[@s_lc_i_n_of_datasalt_digits]=@@i_n_of_datasalt_digits
      ht_key[@s_lc_s_key_id]=Kibuvits_GUID_generator.generate_GUID
      i_number_of_saltfree_values_max=2**(8*i_max_number_of_bytes_per_character)
      i_saltfree_data_max=i_number_of_saltfree_values_max-1
      ht_key[@s_lc_i_saltfree_data_max]=i_saltfree_data_max

      # The m is a term from the TXOR specification.
      # http://longterm.softf1.com/specifications/txor/
      i_m=i_number_of_saltfree_values_max*(10**@@i_n_of_datasalt_digits)+
      Kibuvits_rng.i_random_t1(10**4) # + random to counter rainbow table style attacks

      ht_key[$kibuvits_lc_i_m]=i_m
      ar=Array.new
      i_key_length.times{ar<<Kibuvits_rng.i_random_t1(i_m)}
      ht_key[$kibuvits_lc_ar]=ar
      ht_key[@s_lc_s_key_type]=@s_key_type_t1
      #----------
      # "mode_1" might be a mode, where the key
      # is being used as the traditional one-time pad,
      # where key characters are used up sequentially.
      #
      # "mode_2" is a one-time pad,
      # where key characters are chosen the way they are
      # chosen in mode_0.
      #
      # There might be other modes, that shift the
      # random selection target window among the array of
      # key characters.
      #
      # The thing to note is that decryption algorithm
      # does not depend on the key wearlevelling mode.
      ht_key["s_wearlevelling_mode"]="mode_0"
      #----------
      return ht_key
   end # ht_generate_key_t1

   def Kibuvits_cryptcodec_txor_t1.ht_generate_key_t1(i_key_length,
      i_max_number_of_bytes_per_character=@@i_key_param_max_number_of_bytes_per_character)
      ht_key=Kibuvits_cryptcodec_txor_t1.instance.ht_generate_key_t1(
      i_key_length,i_max_number_of_bytes_per_character)
      return ht_key
   end # Kibuvits_cryptcodec_txor_t1.ht_generate_key_t1

   #-----------------------------------------------------------------------

   private

   def exc_verify_t1(bn,ht_key)
      kibuvits_typecheck bn, Hash, ht_key
      kibuvits_assert_ht_has_keys(bn,ht_key, [@s_lc_s_key_id,$kibuvits_lc_ar,$kibuvits_lc_i_m],
      "\n GUID='0acd8545-c58f-4cf2-b2c8-507100601fd7'")
      ar=ht_key[$kibuvits_lc_ar]
      kibuvits_assert_ar_elements_typecheck_if_is_array(bn,Integer, ar,
      "\n GUID='2cfd35a4-0506-46c9-a4c8-507100601fd7'")
      s_key_type=ht_key[@s_lc_s_key_type]
      if s_key_type!=@s_key_type_t1
         kibuvits_throw("s_key_type == "+s_key_type+" != "+@s_key_type_t1+
         "\n GUID='1b3d5c81-029b-4447-b5c8-507100601fd7'")
      end # if
   end # exc_verify_t1


   #-----------------------------------------------------------------------

   public

   # http://longterm.softf1.com/specifications/progfte/
   def s_serialize_key(ht_key)
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_verify_t1(bn,ht_key)
      end # if
      ht=Hash.new
      ht_key.each_pair do |s_key,x_value|
         if s_key==$kibuvits_lc_ar
            ar_s=Array.new
            i_len=x_value.size
            b_not_first=false
            i_len.times do |ii|
               if b_not_first
                  ar_s<<$kibuvits_lc_pillar
               else
                  b_not_first=true
               end # if
               ar_s<<x_value[ii].to_s(16) # primitive data compression
            end # loop
            ht[$kibuvits_lc_ar]=kibuvits_s_concat_array_of_strings(ar_s)
         else
            ht[s_key]=x_value.to_s
         end # if
      end # loop
      ht[@s_lc_i_n_of_datasalt_digits]=ht_key[@s_lc_i_n_of_datasalt_digits].to_s
      ht[@s_lc_i_saltfree_data_max]=ht_key[@s_lc_i_saltfree_data_max].to_s
      s_out=Kibuvits_ProgFTE.from_ht(ht)
      return s_out
   end # s_serialize_key

   def Kibuvits_cryptcodec_txor_t1.s_serialize_key(ht_key)
      s_out=Kibuvits_cryptcodec_txor_t1.instance.s_serialize_key(ht_key)
      return s_out
   end # Kibuvits_cryptcodec_txor_t1.s_serialize_key

   #-----------------------------------------------------------------------

   def ht_deserialize_key(s_progfte)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_progfte
      end # if
      ht_out=Kibuvits_ProgFTE.to_ht(s_progfte)
      s_ar=ht_out[$kibuvits_lc_ar]
      ar_of_s=s_ar.split($kibuvits_lc_pillar)
      i_len=ar_of_s.size
      ar=Array.new
      i_len.times{|i| ar<<ar_of_s[i].to_i(16)}
      ht_out[$kibuvits_lc_ar]=ar
      ht_out[$kibuvits_lc_i_m]=ht_out[$kibuvits_lc_i_m].to_i
      ht_out[@s_lc_i_n_of_datasalt_digits]=ht_out[@s_lc_i_n_of_datasalt_digits].to_i
      ht_out[@s_lc_i_saltfree_data_max]=ht_out[@s_lc_i_saltfree_data_max].to_i
      return ht_out
   end # ht_deserialize_key

   def Kibuvits_cryptcodec_txor_t1.ht_deserialize_key(s_progfte)
      ht_out=Kibuvits_cryptcodec_txor_t1.instance.ht_deserialize_key(s_progfte)
      return ht_out
   end # Kibuvits_cryptcodec_txor_t1.ht_deserialize_key

   #-----------------------------------------------------------------------

   private

   def s_datasalt_t1(i_n_of_datasalt_digits,i_cleartext)
      s_out=""
      if i_cleartext!=0
         i_n_of_datasalt_digits.times{s_out<<Kibuvits_rng.i_random_fast_t1(9).to_s}
         return s_out
      end # if
      # <data><datasalt>
      # if data=="0" then the most significant digit of the
      # datasalt must not be 0, because otherwise
      #
      #     (00<the_rest_of_the_datasalt>).to_i
      #
      # will not have the specified amount of datasalt digits.
      #
      # Example of the failure:
      #
      #     data="0"   i_n_of_datasalt_digits=3 s_datasalt="042"
      #
      #     ("0"+"042").to_i="0042".to_i=42
      #
      i_n=i_n_of_datasalt_digits-1
      s_out<<(Kibuvits_rng.i_random_fast_t1(8)+1).to_s
      i_n.times{s_out<<Kibuvits_rng.i_random_fast_t1(9).to_s}
      return s_out
   end # s_datasalt_t1


   # The
   # ar_concat_all_strings_in_here_to_get_headerless_ciphertext is a speedhack.
   # If it weren't for the speedhack, the concatenation
   # of the elements of the
   # ar_concat_all_strings_in_here_to_get_headerless_ciphertext
   # would reside at the end of this function and the return
   # value would equal with the headerless ciphertext of the s_cleartext.
   # The end of this function shows an outcommented demo and
   # explains the return value.
   def ar_encrypt_wearlevelling_t1_core(s_cleartext,ht_key,
      ar_concat_all_strings_in_here_to_get_headerless_ciphertext=Array.new)
      ar_s=ar_concat_all_strings_in_here_to_get_headerless_ciphertext
      ar_unicode=s_cleartext.codepoints
      i_ar_unicode_len=ar_unicode.size
      i_m=ht_key[$kibuvits_lc_i_m]
      i_n_of_datasalt_digits=ht_key[@s_lc_i_n_of_datasalt_digits]
      i_saltfree_data_max=ht_key[@s_lc_i_saltfree_data_max]
      if i_saltfree_data_max<100
         # Encoding depends the availability of at least 1 digit
         # that can have any value between 0 and 9. The 100 is
         # taken with a small surplus, but the i_m is
         # determined in the key generation function, where
         # 1B i.e. 8b is minimum amount of data bits.
         # The 2 digits are related to the encoding of
         # the 1 packet in the quartet.
         kibuvits_throw("i_saltfree_data_max == "+i_saltfree_data_max.to_s+" < 100 "+
         "\n GUID='092a1e4f-0f4d-48b1-92c8-507100601fd7'")
      end # if
      ar_key=ht_key[$kibuvits_lc_ar]
      i_ar_key_len=ar_key.size
      if i_ar_key_len==0
         kibuvits_throw("GUID='a4a04fd2-ca13-49f2-92c8-507100601fd7'")
      end # if
      i_ar_key_ix_max=i_ar_key_len-1
      func_encrypt_0=lambda do |i_cleartext|
         # Cycling the key by incrementing the index
         # can lead to a situation, where the same
         # region of the key (same indexes of ar_key)
         # will encrypt some standard, publicly known,
         # header of the cleartext. To avoid revealing
         # the key by "painting/revealing parts of it" with a
         # standard header, the loop that calls this
         # lambda func_encrypt_0tion uses the classical trick, where
         # a candy/coin is placed under one of three upside-down
         # cups, except that instead of shuffling the cups,
         # http://www.youtube.com/watch?v=AZZi1SA90Io
         # the location of the candy/coin is written
         # under a 4. cup that has a known index within the quartet.
         # The other 2 cups will "hide" noise, randomly
         # generated data.
         # The hopping in memory does ignore
         # the locality based speed-optimization method,
         # but the excuse here is security and with flash
         # memories only the CPU cache is lost.
         #
         # The 3 cup solution also helps to secure the
         # secret a bit, when all of the cleartext characters
         # are the same.
         ix=Kibuvits_rng.i_random_fast_t1(i_ar_key_ix_max) # TODO: implement wearlevelling modes
         i_key=ar_key[ix]
         s_lambda_0=(i_cleartext.to_s<<s_datasalt_t1(i_n_of_datasalt_digits,i_cleartext))
         i_ciphertext=txor_encrypt(s_lambda_0.to_i,i_key,i_m)
         s_lambda_0=i_ciphertext.to_s(16) # primitive data compression
         s_ciphertext=ix.to_s+$kibuvits_lc_colon+s_lambda_0
         return s_ciphertext
      end # func_encrypt_0
      i_unicode=nil
      s_packet_real=nil
      s_packet_location=nil
      s_packet_hoax=nil
      i_location=nil
      i_location_masked=nil
      b_not_first=false
      ar_quartet=Array.new(4)
      s_0=nil
      i_ar_unicode_len.times do |i|
         if b_not_first
            # The meaning of the pillar here is that
            # it is a separator between packets,
            # not a bound of the packet at the tail or head of a packet.
            ar_s<<$kibuvits_lc_pillar
         else
            ar_s<<$kibuvits_lc_linebreak
            b_not_first=true
         end # if
         #-------
         # Introduction to the trickery here resides at
         # a comment of the lambda func_encrypt_0tion that is designated
         # by the variable func_encrypt_0 .
         i_location=Kibuvits_rng.i_random_fast_t1(2)+1
         # Index 0 of the ar_quartet is for storing the i_location,
         # which is converted to i_location_masked, which
         # has its least significant digit encoded like that
         #
         #           1== 0,1,2,3
         #           2== 4,5,6
         #           3== 7,8,9
         #
         s_0=Kibuvits_rng.i_random_fast_t1(i_saltfree_data_max).to_s
         s_0=s_0[0..(-2)]
         # s_0 can be "", because "7"[0..(-2)]==""
         case i_location
         when 1
            i_location_masked=(s_0+Kibuvits_rng.i_random_fast_t1(3).to_s).to_i
         when 2
            i_location_masked=(s_0+(Kibuvits_rng.i_random_fast_t1(2)+4).to_s).to_i
         when 3
            i_location_masked=(s_0+(Kibuvits_rng.i_random_fast_t1(2)+7).to_s).to_i
         else
            kibuvits_throw("GUID='5ccf534f-ba57-413b-82c8-507100601fd7'")
         end # case i_location
         #-------
         s_packet_location=((i*4).to_s+$kibuvits_lc_equalssign)
         ar_s<<(s_packet_location+func_encrypt_0.call(i_location_masked))
         #-------
         ar_s<<$kibuvits_lc_pillar
         i_unicode=ar_unicode[i]
         if i_location==1
            s_packet_real=((i*4+1).to_s+$kibuvits_lc_equalssign)
            ar_s<<(s_packet_real+func_encrypt_0.call(i_unicode))
         else
            s_packet_hoax=((i*4+1).to_s+$kibuvits_lc_equalssign)
            ar_s<<(s_packet_hoax+func_encrypt_0.call(Kibuvits_rng.i_random_fast_t1(i_saltfree_data_max)))
         end # if
         ar_s<<$kibuvits_lc_pillar
         if i_location==2
            s_packet_real=((i*4+2).to_s+$kibuvits_lc_equalssign)
            ar_s<<(s_packet_real+func_encrypt_0.call(i_unicode))
         else
            s_packet_hoax=((i*4+2).to_s+$kibuvits_lc_equalssign)
            ar_s<<(s_packet_hoax+func_encrypt_0.call(Kibuvits_rng.i_random_fast_t1(i_saltfree_data_max)))
         end # if
         ar_s<<$kibuvits_lc_pillar
         if i_location==3
            s_packet_real=((i*4+3).to_s+$kibuvits_lc_equalssign)
            ar_s<<(s_packet_real+func_encrypt_0.call(i_unicode))
         else
            s_packet_hoax=((i*4+3).to_s+$kibuvits_lc_equalssign)
            ar_s<<(s_packet_hoax+func_encrypt_0.call(Kibuvits_rng.i_random_fast_t1(i_saltfree_data_max)))
         end # if
         #-------------
         # Some text editors and e-mail clients are flawed,
         # their developers have been sloppy, in a way that they
         # the text editors and e-mail clients can not handle a
         # 1MiB text file that consists of a single line.
         # Hence the line-breaks here.
         ar_s<<$kibuvits_lc_linebreak
         # There's also an extra line-break at the very start
         # of the ar_s.
         #-------------
      end # loop

      # s_headerless_ciphertext=kibuvits_s_concat_array_of_strings(
      #     ar_concat_all_strings_in_here_to_get_headerless_ciphertext)
      #
      # return s_headerless_ciphertext # the general idea
      #
      return ar_concat_all_strings_in_here_to_get_headerless_ciphertext # speedhack
   end # ar_encrypt_wearlevelling_t1_core

   #-----------------------------------------------------------------------

   def s_decrypt_wearlevelling_t1_core(s_ciphertext,ht_key,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_ciphertext
         exc_verify_t1(bn,ht_key)
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='230ebaa5-94af-43b9-a1c8-507100601fd7'")
      end # if
      #--------------
      s_cleartext=$kibuvits_lc_equalssign
      s_ciphertext.gsub!($kibuvits_lc_linebreak,$kibuvits_lc_emptystring)
      ar_s_packets=s_ciphertext.split($kibuvits_lc_pillar)
      i_ar_s_packets_len=ar_s_packets.size
      if i_ar_s_packets_len%4!=0
         kibuvits_throw("Packets are required to form quartets."+
         "\n GUID='60f44627-e88b-4ccc-95c8-507100601fd7'")
      end # if
      s_packet=nil
      s_packet_0=nil
      i_m=ht_key[$kibuvits_lc_i_m]
      ar_key=ht_key[$kibuvits_lc_ar]
      i_n_of_datasalt_digits=ht_key[@s_lc_i_n_of_datasalt_digits]
      ar_0=nil
      func_decrypt_0=lambda do |s_packet| #s_packet=="<ar_key[ix]>:<ciphertext>"
         ar_0=s_packet.split($kibuvits_lc_colon)
         ix=ar_0[0].to_i
         i_ciphertext=ar_0[1].to_i(16) # string form is encoded in hex
         i_key=ar_key[ix]
         i_cleartext_1=txor_decrypt(i_ciphertext,i_key,i_m)
         s_lambda_0=i_cleartext_1.to_s
         s_lambda_0=s_lambda_0[0..(-1-i_n_of_datasalt_digits)]
         i_cleartext=s_lambda_0.to_i  # "".to_i==0
         return i_cleartext
      end # func_decrypt_0
      i_qt_ix=0 #quartet index
      i_data_ix=0
      i_0=nil
      i_lsd=nil # lsd === "least significant digit"
      s_char=nil
      ar_s=Array.new
      func_decrypt_1=lambda do |ii|
         s_packet_0=ar_s_packets[ii]
         ar_0=s_packet_0.split($kibuvits_lc_equalssign)
         if ar_0.size!=2
            kibuvits_throw("ar_0.size=="+ar_0.size.to_s+
            "\n GUID='4404f781-c807-4edf-83c8-507100601fd7'")
         end # if
         s_packet=ar_0[1]
         i_00=func_decrypt_0.call(s_packet)
         return i_00
      end # lambda
      i_ar_s_packets_len.times do |i|
         if i_qt_ix==0
            i_0=func_decrypt_1.call(i)
            s_i_lsd=i_0.to_s
            i_lsd=s_i_lsd[(-1)..(-1)].to_i
            # The least significant digit (i_lsd) can only
            # be between 0 and 9, which is one out of 10 values.
            # The 10 values are almost equally divided to
            # 3 regions. A region determines the cup, under which
            # the actual data resides.
            if i_lsd<4
               i_data_ix=1
            else
               if i_lsd<7
                  i_data_ix=2
               else
                  i_data_ix=3
               end # if
            end # if
         end # if
         if i_qt_ix==1
            if i_data_ix==1
               i_unicode=func_decrypt_1.call(i)
               s_char="".concat(i_unicode) # necessary, can't use a constant
               ar_s<<s_char
            end # if
         end # if
         if i_qt_ix==2
            if i_data_ix==2
               i_unicode=func_decrypt_1.call(i)
               s_char="".concat(i_unicode) # necessary, can't use a constant
               ar_s<<s_char
            end # if
         end # if
         if i_qt_ix==3
            if i_data_ix==3
               i_unicode=func_decrypt_1.call(i)
               s_char="".concat(i_unicode) # necessary, can't use a constant
               ar_s<<s_char
            end # if
         end # if
         i_qt_ix=i_qt_ix+1
         i_qt_ix=0 if 3<i_qt_ix
      end # loop
      s_cleartext=kibuvits_s_concat_array_of_strings(ar_s)
      return s_cleartext
   end # s_decrypt_wearlevelling_t1_core

   #-----------------------------------------------------------------------

   public

   # The client code must verify, that the
   # ht_key["s_key_type"]=="kibuvits_series_of_whole_numbers_t1"
   # Otherwise this method throws an exception.
   #
   # The s_prefix_of_the_output_string is a considerable
   # speed-hack that is based on the following scheme:
   #
   #     s_armouring_header=s_prefix_of_the_output_string
   #     s_output=s_armouring_header+s_ciphertext_with_its_own_header
   #
   # The speed increase comes from avoiding
   #
   #     s_output=s_something_quite_short+s_something_very_long
   #
   # by using the kibuvits_s_concat_array_of_strings(...)
   # and this is not a joke, because the "s_something_very_long"
   # contains the whole encrypted message and really can be
   # a considerably long temporary string, taking up
   # tens of megabytes of memory.
   #
   # This crypto-algorithm is probably not affected
   # by quantum computer based attacks, because
   # it does not rely on any kind of factorization,
   # nor does it explicitly rely on the lack of knowledge about
   # some function.
   #
   def s_encrypt_wearlevelling_t1(s_cleartext,ht_key,
      s_prefix_of_the_output_string=$kibuvits_lc_emptystring,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=Kibuvits_cleartext_length_normalization.i_const_t1,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=(
      (i_estimated_median_of_lengths_of_nonnormalized_cleartexts.to_r/3).floor*2))
      if KIBUVITS_b_DEBUG
         bn=binding()
         exc_verify_t1(bn,ht_key)
         kibuvits_typecheck bn, String, s_cleartext
         kibuvits_typecheck bn, Hash, ht_key
         kibuvits_typecheck bn, String, s_prefix_of_the_output_string
         kibuvits_typecheck bn, Integer, i_estimated_median_of_lengths_of_nonnormalized_cleartexts
         kibuvits_typecheck bn, Integer, i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='3ac19d81-0e67-418c-94c8-507100601fd7'\n\n")
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='c6d7fe1b-bcf9-4981-a1c8-507100601fd7'\n\n")
      end # if
      #-----
      s_key_type=ht_key[@s_lc_s_key_type]
      if s_key_type!=@s_key_type_t1
         # The throw is used here because this
         # condition indicates that the code that
         # calls this decryption function is flawed,
         # is missing a proper key type verification.
         kibuvits_throw("ht_key[\"s_key_type\"] == "+s_key_type+
         " != "+@s_key_type_t1+
         "\n GUID='52fd5e53-18d3-45b9-b5c8-507100601fd7'")
      end # if
      #-----
      ar_s=[s_prefix_of_the_output_string]
      ht_header=Hash.new
      ht_header["s_cryptocodec_type"]=@s_cryptocodec_type_t1
      ht_header[@s_lc_s_key_id]=ht_key[@s_lc_s_key_id]
      s_header=Kibuvits_ProgFTE.from_ht(ht_header)
      ar_s<<(s_header.length.to_s+$kibuvits_lc_pillar)
      ar_s<<(s_header+$kibuvits_lc_pillar)
      #-----------------
      b_use_fast_random=false
      s_cleartext_normalized=Kibuvits_cleartext_length_normalization.s_normalize_t1(
      s_cleartext,i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
      b_use_fast_random,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts)
      #-----------------
      ar_encrypt_wearlevelling_t1_core(s_cleartext_normalized,ht_key,ar_s)
      s_ciphertext_with_header=kibuvits_s_concat_array_of_strings(ar_s)
      return s_ciphertext_with_header
   end # s_encrypt_wearlevelling_t1


   def Kibuvits_cryptcodec_txor_t1.s_encrypt_wearlevelling_t1(s_cleartext,ht_key,
      s_prefix_of_the_output_string=$kibuvits_lc_emptystring,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=Kibuvits_cleartext_length_normalization.i_const_t1,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=(
      (i_estimated_median_of_lengths_of_nonnormalized_cleartexts.to_r/3).floor*2))
      s_out=Kibuvits_cryptcodec_txor_t1.instance.s_encrypt_wearlevelling_t1(
      s_cleartext,ht_key,s_prefix_of_the_output_string,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts)
      return s_out
   end # Kibuvits_cryptcodec_txor_t1.s_encrypt_wearlevelling_t1

   #-----------------------------------------------------------------------

   def s_decrypt_wearlevelling_t1(s_ciphertext_with_header,ht_key,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_ciphertext_with_header
         exc_verify_t1(bn,ht_key)
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='99580710-2b80-404d-92b8-507100601fd7'")
      end # if
      #--------------
      s_out=$kibuvits_lc_emptystring
      s_header_progfte,s_ciphertext=Kibuvits_str.s_s_bisect_by_header_t1(
      s_ciphertext_with_header,msgcs)
      return s_out if msgcs.b_failure
      #--------------
      ht=Kibuvits_ProgFTE.to_ht(s_header_progfte)
      s_cryptocodec_type=ht["s_cryptocodec_type"]
      if s_cryptocodec_type!=@s_cryptocodec_type_t1
         s_default_msg="s_cryptocodec_type == "+s_cryptocodec_type+
         " != "+@s_cryptocodec_type_t1
         s_message_id="cryptocodec_mismatch_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "49b66b1a-870c-4cc3-82d8-507100601fd7")
         return s_out
      end # if
      #-----
      s_key_type=ht_key[@s_lc_s_key_type]
      if s_key_type!=@s_key_type_t1
         # The throw is used here because this
         # condition indicates that the code that
         # calls this decryption function is probably,
         # but not necessarily, flawed. The existence of the
         # flaw is somewhat questionable, because
         # if only one type of cryptcodec is used, then
         # there's no point of verifying the key type.
         kibuvits_throw("ht_key[\"s_key_type\"] == "+s_key_type+
         " != "+@s_key_type_t1+
         "\n GUID='5ab9d22e-f2ed-4a1d-81b8-507100601fd7'")
      end # if
      #-----
      # The key ID verification has to be _after_ the
      # key type verification, because a key of wrong type
      # probably fails ID verification and if the ID verification
      # is before key type verification, the flaw that
      # causes the key type mismatch is not hinted.
      s_key_id_0=ht_key[@s_lc_s_key_id]
      s_key_id_1=ht[@s_lc_s_key_id]
      if s_key_id_0!=s_key_id_1
         s_default_msg="The ID of the key is == "+s_key_id_0+
         "\n, but the ciphertext has been encrypted with a "+
         "key that has an ID of \n"+s_key_id_1+
         $kibuvits_lc_doublelinebreak
         s_message_id="decrytion_key_mismatch_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "b9fcb753-84dc-4542-84c8-507100601fd7")
         return s_out
      end # if
      ht.clear
      #--------------
      s_cleartext_normalized=s_decrypt_wearlevelling_t1_core(s_ciphertext,ht_key,msgcs)
      s_cleartext=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_cleartext_normalized,msgcs)
      s_out=s_cleartext
      return s_out
   end # s_decrypt_wearlevelling_t1

   def Kibuvits_cryptcodec_txor_t1.s_decrypt_wearlevelling_t1(s_ciphertext_with_header,ht_key,msgcs)
      s_out=Kibuvits_cryptcodec_txor_t1.instance.s_decrypt_wearlevelling_t1(
      s_ciphertext_with_header,ht_key,msgcs)
      return s_out
   end # Kibuvits_cryptcodec_txor_t1.s_decrypt_wearlevelling_t1

   #-----------------------------------------------------------------------
   include Singleton

end # class Kibuvits_cryptcodec_txor_t1

#=========================================================================
