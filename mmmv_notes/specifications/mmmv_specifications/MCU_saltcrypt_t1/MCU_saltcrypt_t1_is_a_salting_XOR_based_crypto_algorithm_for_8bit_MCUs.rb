#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
# Tested to work on ("uname -a")
# Linux terminal01 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux
# with ("ruby -v")
# ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
#--------------------------------------------------------------------------
# This sample code uses Ruby boolean values for bits.
# For the sake of succinctness,
# correctness related checks/tests are omitted.
# Prefix "ar_" indicates an array and prefix "b_" indicates a boolean value.
class Mmmv_saltcrypt_t1_specification

   def initialize
   end # initialize

   def b_xor(b_first,b_second)
      b_out=true
      b_out=false if b_first==b_second
      return b_out
   end # b_xor

   def b_generate_one_random_bit()
      b_out=true
      b_out=false if rand(2)==0
      return b_out
   end # b_generate_one_random_bit

   # Returns an array of 4 bits.
   # This is the core of the idea, the
   # main reason, why all of the rest of the code
   # in this Ruby file has been written.
   #
   # The idea is that the key can not be derived
   # so easily in cases, where the cleartext is known.
   # The downside is 4 times greater key consumption
   # and the need to generate 3 random bits per
   # 1 cleartext bit.
   def ar_of_4b_encrypt_one_bit(b_cleartext,
      b_key_first, b_key_second, b_key_third, b_key_fourth)
      #----------------------------------------
      ar_b_4_bit=[true,true,true,true]
      # indices:    0 ,  1 ,  2 ,  3
      #----------------------------------------
      b_0_clear=b_generate_one_random_bit()
      b_0_encrypted=b_xor(b_0_clear,b_key_first)
      ar_b_4_bit[0]=b_0_encrypted
      #----------------------------------------
      b_1_clear=b_generate_one_random_bit()
      b_1_encrypted=b_xor(b_1_clear,b_key_second)
      ar_b_4_bit[1]=b_1_encrypted
      #----------------------------------------
      b_2_clear=nil
      b_3_clear=nil
      b_1a=b_xor(b_0_clear,b_1_clear)
      if b_1a
         b_2_clear=b_cleartext
         b_3_clear=b_generate_one_random_bit()
      else
         b_2_clear=b_generate_one_random_bit()
         b_3_clear=b_cleartext
      end # if
      #--------------------
      b_2_encrypted=b_xor(b_2_clear,b_key_third)
      b_3_encrypted=b_xor(b_3_clear,b_key_fourth)
      ar_b_4_bit[2]=b_2_encrypted
      ar_b_4_bit[3]=b_3_encrypted
      #----------------------------------------
      return ar_b_4_bit
      #----------------------------------------
      # An upgrade to this algorithm might be
      # to use 5 cryptokey bits and
      # return 5 bit array in stead of the
      # 4 bit array. The decrypted
      # value of the ar_b_5_bit[4] would be
      # a random bit that determines a swap
      # of cleartext bit pairs, like
      #
      #     b_4_clear=b_generate_one_random_bit()
      #     if b_4_clear
      #        #--------
      #        b_0_clear_after_pairswap=b_2_clear
      #        b_1_clear_after_pairswap=b_3_clear
      #        #--------
      #        b_2_clear_after_pairswap=b_0_clear
      #        b_3_clear_after_pairswap=b_1_clear
      #        #--------
      #     else
      #        #--------
      #        b_0_clear_after_pairswap=b_0_clear
      #        b_1_clear_after_pairswap=b_1_clear
      #        #--------
      #        b_2_clear_after_pairswap=b_2_clear
      #        b_3_clear_after_pairswap=b_3_clear
      #        #--------
      #     end # if
      #     #--------
      #     b_0_encrypted=b_xor(b_0_clear_after_pairswap,b_key_first)
      #     b_1_encrypted=b_xor(b_1_clear_after_pairswap,b_key_second)
      #     b_2_encrypted=b_xor(b_2_clear_after_pairswap,b_key_third)
      #     b_3_encrypted=b_xor(b_3_clear_after_pairswap,b_key_fourth)
      #     b_4_encrypted=b_xor(b_4_clear,b_key_fifth)
      #     #--------
      #     ar_b_5_bit[0]=b_0_encrypted
      #     ar_b_5_bit[1]=b_1_encrypted
      #     ar_b_5_bit[2]=b_2_encrypted
      #     ar_b_5_bit[3]=b_3_encrypted
      #     ar_b_5_bit[4]=b_4_encrypted
      #     #--------
      #
      # A further improvement might be that
      #
      #     b_5_clear=b_generate_one_random_bit()
      #
      # and that might determine, whether key bits
      # for indices 0 and 2 get swaped or not.
      #----------------------------------------
   end # ar_of_4b_encrypt_one_bit


   # A formality here.
   # The main comments are at the encryption function.
   def b_decrypt(ar_b_4_bit,
      b_key_first, b_key_second, b_key_third, b_key_fourth)
      #----------------------------------------
      b_0_encrypted=ar_b_4_bit[0]
      b_1_encrypted=ar_b_4_bit[1]
      b_2_encrypted=ar_b_4_bit[2]
      b_3_encrypted=ar_b_4_bit[3]
      #----------------------------------------
      b_0_clear=b_xor(b_0_encrypted,b_key_first)
      b_1_clear=b_xor(b_1_encrypted,b_key_second)
      b_2_clear=b_xor(b_2_encrypted,b_key_third)
      b_3_clear=b_xor(b_3_encrypted,b_key_fourth)
      #----------------------------------------
      b_cleartext=nil
      b_1a=b_xor(b_0_clear,b_1_clear)
      if b_1a
         b_cleartext=b_2_clear
      else
         b_cleartext=b_3_clear
      end # if
      return b_cleartext
      #----------------------------------------
   end # b_decrypt

end # class Mmmv_saltcrypt_t1_specification

#--------------------------------------------------------------------------

# For the sake of succinctness, there is
# neither any thread safety nor correctness tests.
class Usage_demo

   def initialize
      @ob_encrypter=Mmmv_saltcrypt_t1_specification.new
   end # initialize

   def s_ar_b(s_ar_b_variable_name, ar_b,i_colorcode=33)
      #--------------------
      s_0=""
      b_first=true
      (ar_b.size).times do |ix|
         s_b="0"
         s_b="1" if ar_b[ix]==true
         s_0<<"," if !b_first
         s_0<<s_b
         b_first=false
      end # loop
      s_out=(s_ar_b_variable_name+"==\e["+i_colorcode.to_s+"m["+s_0+"]\e[39m")
      return s_out
      #--------------------
   end # s_ar_b

   private

   def generate_demo_data_and_demo_key(i_number_of_cleartext_bits=10)
      #--------------------
      @ar_b_cleartext=Array.new
      @ar_b_key=Array.new
      i_number_of_cleartext_bits.times do
         @ar_b_cleartext<<@ob_encrypter.b_generate_one_random_bit()
         # It takes 4 key bits to encrypt one cleartext bit.
         @ar_b_key<<@ob_encrypter.b_generate_one_random_bit()
         @ar_b_key<<@ob_encrypter.b_generate_one_random_bit()
         @ar_b_key<<@ob_encrypter.b_generate_one_random_bit()
         @ar_b_key<<@ob_encrypter.b_generate_one_random_bit()
      end # loop
      #--------------------
   end # generate_demo_data_and_demo_key

   def exc_verify_key_length_t1(i_cleartext_lenght,ar_b_key,
      ix_ar_b_key_usage_start_index)
      #--------------------
      i_key_length=ar_b_key.size
      #--------------------
      i_key_max_index=i_key_length-1
      i_consumed_max_key_index=ix_ar_b_key_usage_start_index+
      4*i_cleartext_lenght-1
      if i_key_max_index<i_consumed_max_key_index
         reaise(Exception.new("\nKey is too short.\n"+
         "ix_ar_b_key_usage_start_index=="+ix_ar_b_key_usage_start_index.to_s+"\n"+
         "i_key_length=="+i_key_length.to_s+"\n"+
         "i_cleartext_lenght=="+i_cleartext_lenght.to_s+"\n"+
         "GUID=='918abc73-6113-4312-9725-23c1b051b6e7'\n"))
      end # if
      #--------------------
      i_offset=i_key_length%4
      if i_offset != 0
         reaise(Exception.new("\nKey has wrong size.\n"+
         "i_key_length=="+i_key_length.to_s+"\n"+
         "i_offset=="+i_offset.to_s+"\n"+
         "GUID=='c9f20f32-f365-46ca-8d93-23c1b051b6e7'\n"))
      end # if
      #--------------------
   end # exc_verify_key_length_t1

   def ar_b_encrypt_array_of_bits(ar_b_cleartext,ar_b_key,
      ix_ar_b_key_usage_start_index=0)
      #--------------------
      i_cleartext_lenght=ar_b_cleartext.size
      exc_verify_key_length_t1(i_cleartext_lenght,ar_b_key,
      ix_ar_b_key_usage_start_index)
      #--------------------
      ar_b_cryptotext=Array.new
      #--------------------
      i_cleartext_lenght.times do |ix| # ix starts from 0
         b_cleartext=ar_b_cleartext[ix]
         ix_b_key_first=ix*4+ix_ar_b_key_usage_start_index
         b_key_first=ar_b_key[ix_b_key_first]
         b_key_second=ar_b_key[ix_b_key_first+1]
         b_key_third=ar_b_key[ix_b_key_first+2]
         b_key_fourth=ar_b_key[ix_b_key_first+3]
         ar_b_4_bits=@ob_encrypter.ar_of_4b_encrypt_one_bit(b_cleartext,
         b_key_first,b_key_second,b_key_third,b_key_fourth)
         ar_b_cryptotext.concat(ar_b_4_bits)
      end # loop
      return ar_b_cryptotext
      #--------------------
   end # ar_b_encrypt_array_of_bits

   def b_decrypt_array_of_bits(ar_b_cryptotext,ar_b_key,
      ix_ar_b_key_usage_start_index=0)
      #--------------------
      i_len_ar_b_cryptotext=ar_b_cryptotext.size
      i_n_of_nibbles_in_cryptotext=i_len_ar_b_cryptotext/4
      i_cleartext_lenght=i_n_of_nibbles_in_cryptotext
      #--------------------
      exc_verify_key_length_t1(i_cleartext_lenght,ar_b_key,
      ix_ar_b_key_usage_start_index)
      #--------------------
      ar_b_cleartext=Array.new
      ar_b_4_bit=[true,true,true,true]
      b_cleartext_bit=nil
      i_n_of_nibbles_in_cryptotext.times do |ix_nibble|
         ix_first_bit=ix_nibble*4+ix_ar_b_key_usage_start_index
         ix_second_bit=ix_first_bit+1
         ix_third_bit=ix_first_bit+2
         ix_fourth_bit=ix_first_bit+3
         #--------
         b_key_first=ar_b_key[ix_first_bit]
         b_key_second=ar_b_key[ix_second_bit]
         b_key_third=ar_b_key[ix_third_bit]
         b_key_fourth=ar_b_key[ix_fourth_bit]
         #--------
         ar_b_4_bit[0]=ar_b_cryptotext[ix_first_bit]
         ar_b_4_bit[1]=ar_b_cryptotext[ix_second_bit]
         ar_b_4_bit[2]=ar_b_cryptotext[ix_third_bit]
         ar_b_4_bit[3]=ar_b_cryptotext[ix_fourth_bit]
         #--------
         b_cleartext_bit=@ob_encrypter.b_decrypt(ar_b_4_bit,
         b_key_first,b_key_second,b_key_third,b_key_fourth)
         ar_b_cleartext<<b_cleartext_bit
      end # loop
      #--------------------
      return ar_b_cleartext
      #--------------------
   end # b_decrypt_array_of_bits

   def exc_verify_that_arrays_match_t1(ar_0,ar_1)
      #--------------------
      i_len_0=ar_0.size
      i_len_1=ar_1.size
      if i_len_0!=i_len_1
         raise(Exception.new("Decryption failed\n"+
         "    i_len_0="+i_len_0.to_s+"\n"+
         "    i_len_1="+i_len_1.to_s+"\n"+
         "GUID=='3119397f-c8c0-41a1-b9b5-23c1b051b6e7'\n"))
      end # if
      #--------------------
      b_0=nil
      b_1=nil
      i_len_0.times do |ix|
         b_0=ar_0[ix]
         b_1=ar_1[ix]
         if b_0 != b_1
            raise(Exception.new("Decryption failed\n"+
            "    ix="+ix.to_s+"\n"+
            "    b_0="+b_0.to_s+"\n"+
            "    b_1="+b_1.to_s+"\n"+
            "GUID=='342885c9-0f17-4385-9e85-23c1b051b6e7'\n"))
         end # if
      end #loop
      #--------------------
   end # exc_verify_that_arrays_match_t1

   public

   def run_demo(i_number_of_cleartext_bits=10)
      puts ""
      #--------------------
      generate_demo_data_and_demo_key(3+rand(10))
      puts(s_ar_b("                      @ar_b_key",@ar_b_key))
      #--------------------
      ar_b_cryptotext=ar_b_encrypt_array_of_bits(
      @ar_b_cleartext,@ar_b_key)
      puts(s_ar_b("               @ar_b_cryptotext",ar_b_cryptotext))
      #--------------------
      puts(s_ar_b("                @ar_b_cleartext",@ar_b_cleartext,32))
      #--------------------
      ar_b_cleartext_after_decryption=b_decrypt_array_of_bits(
      ar_b_cryptotext,@ar_b_key, ix_ar_b_key_usage_start_index=0)
      puts(s_ar_b("ar_b_cleartext_after_decryption",ar_b_cleartext_after_decryption,32))
      #--------------------
      exc_verify_that_arrays_match_t1(@ar_b_cleartext,ar_b_cleartext_after_decryption)
      #--------------------
      puts ""
   end # run_demo

end # class Usage_demo

Usage_demo.new.run_demo

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="d3561f70-5323-421a-9d3d-23c1b051b6e7"
#==========================================================================
