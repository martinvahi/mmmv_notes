#!/usr/bin/env ruby
#==========================================================================
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
#==========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/security/kibuvits_security_core.rb"

#==========================================================================

class Kibuvits_security_core_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_security_core_selftests.test_1
      #msgcs=Kibuvits_msgc_stack.new
      i_m=256**4
      #---------
      s_0="abc"
      i_number_of_columns=3
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected="97_98_99"
      kibuvits_throw "test 1 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
      s_0=""
      i_number_of_columns=3
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected=""
      kibuvits_throw "test 2 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
      s_0="abc"
      i_number_of_columns=1
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected=(97+98+99).to_s
      kibuvits_throw "test 3 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
      s_0=""
      i_number_of_columns=1
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected=""
      kibuvits_throw "test 4 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
      s_0="a"
      i_number_of_columns=1
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected="97"
      kibuvits_throw "test 5 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
      s_0="ab"
      i_number_of_columns=5
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected="97_98_97_98_97"
      kibuvits_throw "test 6 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
      i_0=472
      s_0="ab"*i_0
      i_number_of_columns=2
      s_x=Kibuvits_security_core.s_mmmv_checksum_t1(s_0,i_number_of_columns,i_m)
      s_expected=(97*i_0).to_s+"_"+(98*i_0).to_s
      kibuvits_throw "test 7 s_x==\""+s_x.to_s+"\"" if s_x!=s_expected
      #---------
   end # Kibuvits_security_core_selftests.test_1

   #-----------------------------------------------------------------------

   def Kibuvits_security_core_selftests.test_ht_gen_substitution_box_t1
      func_gen=lambda do |ix|
         ar_out=Array.new
         if (ix%4)==0           # 0,4,8,12,16
            ar_out<<[ix,(ix+1)] # 1,5,9,13,17
         end # if
         if (ix%4)==1           # 1,5,9,13,17
            ar_out<<[ix,(ix-1)] # 0,4,8,12,16
         end # if
         return ar_out
      end # func
      i_alphabet_length=20
      i_n_of_passes=2
      ht_x=Kibuvits_security_core.ht_gen_substitution_box_t1(
      func_gen,i_alphabet_length)

      ar_keys_x=ht_x.keys
      i_ar_keys_x_len=ar_keys_x.size
      if i_ar_keys_x_len!=10
         kibuvits_throw "test 1a i_ar_keys_x_len=="+i_ar_keys_x_len.to_s
      end # if
      ar_keys_expected=[0,1,4,5,8,9,12,13,16,17]
      ar_values_expected=[1,0,5,4,9,8,13,12,17,16]
      i_key=nil
      x_value=nil
      i_key_expected=nil
      i_value_expected=nil
      ar_keys_expected.size.times do |ix|
         i_key_expected=ar_keys_expected[ix]
         i_value_expected=ar_values_expected[ix]
         x_value=ht_x[i_key_expected]
         if x_value!=i_value_expected
            x_value="nil" if x_value==nil
            kibuvits_throw("test 1b ht_x["+i_key_expected.to_s+"] == "+
            x_value.to_s+" != "+i_value_expected.to_s)
         end # if
      end # loop
      # The initial ht_x is frozen. The clone is not.
      #ht_x=Kibuvits_htoper_t1.ht_clone_with_shared_references(ht_x)
      #ht_x.delete(1) # for testing the tests
      ar_keys_expected.each do |i_key_expected|
         if !ht_x.has_key? i_key_expected
            kibuvits_throw("test 1c The key "+i_key_expected.to_s+
            " is missing from the substitution box hashtable.")
         end # if
      end # loop
   end # Kibuvits_security_core_selftests.test_ht_gen_substitution_box_t1

   #-----------------------------------------------------------------------

   def Kibuvits_security_core_selftests.test_i_nsa_cpu_cycles_per_second_t1
      bn=binding()
      i_x=Kibuvits_security_core.i_nsa_cpu_cycles_per_second_t1()
      kibuvits_typecheck bn, Integer, i_x
   end # Kibuvits_security_core_selftests.test_i_nsa_cpu_cycles_per_second_t1

   #-----------------------------------------------------------------------

   def Kibuvits_security_core_selftests.test_txor
      m=50
      i_cleartext=42
      i_key=28
      i_chiphertext=Kibuvits_security_core.txor(i_cleartext,i_key,m)
      i_x=Kibuvits_security_core.txor(i_chiphertext,i_key,m)
      kibuvits_throw "test 1a i_x=="+i_x.to_s if i_cleartext!=i_x
      kibuvits_throw "test 1b i_x=="+i_x.to_s if i_cleartext==i_chiphertext
      #---------
   end # Kibuvits_security_core_selftests.test_txor

   #-----------------------------------------------------------------------

   def Kibuvits_security_core_selftests.test_kibuvits_hash_plaice_t1
      i_headerless_hash_length=8
      s_data="TEre!ff"
      s_x1=kibuvits_hash_plaice_t1(s_data,i_headerless_hash_length)
      s_x2=kibuvits_hash_plaice_t1(s_data,i_headerless_hash_length)
      kibuvits_throw "test 1 s_x1=="+s_x1.to_s if s_x1!=s_x2
      #---------
      i_minimum_n_of_rounds=2 # for speed only, smaller than the default
      begin
         # strings with linebreak
         s_in="ab\ncd"
         s_x1=kibuvits_hash_plaice_t1(s_in,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 2a e.to_s=="+e.to_s
      end # rescue
      s_x2=kibuvits_hash_plaice_t1("abcd", # lacks the linebreak
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x2 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 2b s_x1=="+s_x1.to_s
      end # if
      #---------
      begin
         # frozen strings
         s_in="ab\ncd".freeze
         s_x1=kibuvits_hash_plaice_t1(s_in,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 3 e.to_s=="+e.to_s
      end # rescue
      #---------
      begin
         s_in="a"
         s_x1=kibuvits_hash_plaice_t1(s_in,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 4a e.to_s=="+e.to_s
      end # rescue
      s_x2=kibuvits_hash_plaice_t1("b",
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x2 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4b s_x1=="+s_x1.to_s
      end # if
      s_x3=kibuvits_hash_plaice_t1("A", # upper case versus lower case
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x3 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4c s_x1=="+s_x1.to_s
      end # if
      #---------
      begin
         s_in="".freeze
         s_x1=kibuvits_hash_plaice_t1(s_in,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 5a e.to_s=="+e.to_s
      end # rescue
      begin
         s_in=""
         s_x1=kibuvits_hash_plaice_t1(s_in,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 5b e.to_s=="+e.to_s
      end # rescue
      #---------
      begin
         s_in="\n"
         s_x1=kibuvits_hash_plaice_t1(s_in,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 6a e.to_s=="+e.to_s
      end # rescue
      s_x2=kibuvits_hash_plaice_t1("\r", # different linebreaks
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x2 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 6b s_x1=="+s_x1.to_s
      end # if
      s_x3=kibuvits_hash_plaice_t1("\n\r",
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x3 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4c s_x1=="+s_x1.to_s
      end # if
      if s_x2==s_x3 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4d s_x1=="+s_x1.to_s
      end # if
      s_x3=kibuvits_hash_plaice_t1("\r\n", # order of \n and \r swiched
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x3 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4e s_x1=="+s_x1.to_s
      end # if
      if s_x2==s_x3 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4f s_x1=="+s_x1.to_s
      end # if
      s_x3=kibuvits_hash_plaice_t1("",
      i_headerless_hash_length,i_minimum_n_of_rounds)
      if s_x1==s_x3 # probabilistic, not necessarily a flaw
         kibuvits_throw "test 4g s_x1=="+s_x1.to_s
      end # if
      #---------
      i_headerless_hash_length=1
      s_x1=kibuvits_hash_plaice_t1(s_data,i_headerless_hash_length)
      s_x1=kibuvits_hash_plaice_t1("",i_headerless_hash_length)
      #---------
      i_headerless_hash_length=5
      i_minimum_n_of_rounds=4 # small to speed up the test
      s_data="longer than the 4 rounds times i_headerless_hash_length"*40
      begin
         s_x1=kibuvits_hash_plaice_t1(s_data,
         i_headerless_hash_length,i_minimum_n_of_rounds)
      rescue Exception => e
         kibuvits_throw "test 5"
      end # rescue
      #---------
   end # Kibuvits_security_core_selftests.test_kibuvits_hash_plaice_t1

   #-----------------------------------------------------------------------

   def Kibuvits_security_core_selftests.test_ar_random_charstream_t1
      ar_x=Kibuvits_security_core.ar_random_charstream_t1()
      kibuvits_throw "test 1a" if ar_x.size!=1
      kibuvits_throw "test 1b" if ar_x[0].class!=String
      kibuvits_throw "test 1c" if ar_x[0].length!=1
      #---------
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(1)
      kibuvits_throw "test 2a" if ar_x.size!=1
      kibuvits_throw "test 2b" if ar_x[0].class!=String
      kibuvits_throw "test 2c" if ar_x[0].length!=1
      #---------
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(2)
      kibuvits_throw "test 3a" if ar_x.size!=2
      kibuvits_throw "test 3b" if ar_x[0].class!=String
      kibuvits_throw "test 3c" if ar_x[1].class!=String
      kibuvits_throw "test 3d" if ar_x[0].length!=1
      kibuvits_throw "test 3e" if ar_x[1].length!=1
      #---------
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(42,false)
      kibuvits_throw "test 4a" if ar_x.size!=42
      kibuvits_throw "test 4b" if ar_x.first.class!=String
      kibuvits_throw "test 4c" if ar_x.first.length!=1
      kibuvits_throw "test 4d" if ar_x[10].class!=String
      kibuvits_throw "test 4e" if ar_x[10].length!=1
      kibuvits_throw "test 4f" if ar_x.last.class!=String
      kibuvits_throw "test 4g" if ar_x.last.length!=1
      #---------
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(42,true)
      kibuvits_throw "test 5a" if ar_x.size!=42
      kibuvits_throw "test 5b" if ar_x.first.class!=String
      kibuvits_throw "test 5c" if ar_x.first.length!=1
      kibuvits_throw "test 5d" if ar_x[10].class!=String
      kibuvits_throw "test 5e" if ar_x[10].length!=1
      kibuvits_throw "test 5f" if ar_x.last.class!=String
      kibuvits_throw "test 5g" if ar_x.last.length!=1
      #---------
      ar_ref=ar_x[0..14] # 15 elements
      i_len_0=ar_x.size
      ar_x2=Kibuvits_security_core.ar_random_charstream_t1(ar_x) # length by array
      i_len_1=ar_x2.size
      if i_len_0!=i_len_1
         kibuvits_throw("test 6a i_len_0=="+i_len_0.to_s+
         "  i_len_1=="+i_len_1.to_s)
      end # if
      i_len_1.times do |ix|
         kibuvits_throw "test 6b " if ar_x[ix]!=ar_x2[ix]
         kibuvits_throw "test 6c " if ar_x[ix].class!=String
         kibuvits_throw "test 6d " if ar_x[ix].length!=1
      end # loop
      #---------
      i_score=0
      ar_ref.size.times do |ix|
         i_score=i_score+1 if ar_ref[ix]!=ar_x2[ix]
      end # loop
      # The 3 at the test 7a is taken semi-arbitrarily.
      # The alphabet consists of thausands of charcters,
      # which means that the cance of
      #
      #   ( (ar_ref[0]==ar_x2[0]) &&(ar_ref[1]==ar_x2[1]) )==true
      #
      # is less than one in 1000*1000 = "a million".
      # The ar_ref contains more than 2 characters.
      kibuvits_throw "test 7a i_score=="+i_score.to_s if i_score<3
      #---------
      ar_len=[42,"uuu",3.33]
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(ar_len) # length by array
      kibuvits_throw "test 8a" if ar_x.size!=3
      kibuvits_throw "test 8b" if ar_x[0].class!=String
      kibuvits_throw "test 8c" if ar_x[1].class!=String
      kibuvits_throw "test 8d" if ar_x[2].class!=String
      #---------
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(ar_len,true) # length by array
      kibuvits_throw "test 9a" if ar_x.size!=3
      kibuvits_throw "test 9b" if ar_x[0].class!=String
      kibuvits_throw "test 9c" if ar_x[1].class!=String
      kibuvits_throw "test 9d" if ar_x[2].class!=String
      #---------
      ar_x_in=[]
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(ar_x_in) # an empty array
      kibuvits_throw "test 10a" if ar_x.class!=Array
      kibuvits_throw "test 10b" if ar_x.object_id!=ar_x_in.object_id
      kibuvits_throw "test 10c" if ar_x.size!=0
      ar_x=Kibuvits_security_core.ar_random_charstream_t1(0)
      kibuvits_throw "test 10d" if ar_x.size!=0
      kibuvits_throw "test 10e" if ar_x.object_id==ar_x_in.object_id
   end # Kibuvits_security_core_selftests.test_ar_random_charstream_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_security_core_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_security_core_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_security_core_selftests.test_ht_gen_substitution_box_t1"
      kibuvits_testeval bn, "Kibuvits_security_core_selftests.test_i_nsa_cpu_cycles_per_second_t1"
      kibuvits_testeval bn, "Kibuvits_security_core_selftests.test_txor"
      kibuvits_testeval bn, "Kibuvits_security_core_selftests.test_kibuvits_hash_plaice_t1"
      kibuvits_testeval bn, "Kibuvits_security_core_selftests.test_ar_random_charstream_t1"
      return ar_msgs
   end # Kibuvits_security_core_selftests.selftest

end # class Kibuvits_security_core_selftests

#==========================================================================
# Kibuvits_security_core_selftests.test_ar_random_charstream_t1
