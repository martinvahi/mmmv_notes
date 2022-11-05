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
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"

#==========================================================================

# http://longterm.softf1.com/specifications/txor/index.html
# http://martin.softf1.com/g/yellow_soap_opera_blog/uniformly-distributed-random-numbers-and-random-bitstreams
class Kibuvits_security_txor_codec_t1

   def initialize
      @ob_rand=Random.new
   end #initialize

   private

   def verify_txor_arguments_t1(aa,bb,m)
      bn=binding()
      kibuvits_typecheck bn, Integer, aa
      kibuvits_typecheck bn, Integer, bb
      kibuvits_typecheck bn, Integer, m
      # 2≤m
      # 0≤aa<m
      # 0≤bb<m
      kibuvits_assert_is_smaller_than_or_equal_to(bn, [2,(aa+1),(bb+1)], @m)
      kibuvits_assert_is_smaller_than_or_equal_to(bn,0,[aa,bb])
   end # verify_txor_arguments_t1


   # TXOR(aa,bb,m)=((bb-aa+m) mod m)
   #
   # The bb must always be in the role of a key and
   # the aa must always be either
   # in the role of a clear-text or
   # in the role of a cipher-text.
   def txor_impl_1(aa,bb,m)
      if KIBUVITS_b_DEBUG
         verify_txor_arguments_t1(aa,bb,m)
      end # if
      i_out=(bb-aa+m)%m
      return i_out
   end # txor_impl_1

   def ar_txor_impl_2(ar_or_i_aa,ar_or_i_bb,m)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,Integer], ar_or_i_aa
         kibuvits_typecheck bn, [Array,Integer], ar_or_i_bb
         kibuvits_typecheck bn, Integer, m
         b_ar=false
         if ar_or_i_aa.class==Array
            kibuvits_typecheck bn, Array, ar_or_i_bb
            b_ar=true
         end # if
         if ar_or_i_bb.class==Array
            kibuvits_typecheck bn, Array, ar_or_i_aa
            b_ar=true
         else
            if b_ar
               kibuvits_throw("GUID='7a448822-8680-4e9e-92be-3240a010add7'\n\n")
            end # if
         end # if
         if b_ar
            i_aa_len=ar_or_i_aa.size
            i_bb_len=ar_or_i_bb.size
            if i_aa_len!=i_bb_len
               kibuvits_throw("i_aa_len=="+i_aa_len.to_s+
               " != i_bb_len=="+i_bb_len.to_s+
               "\nGUID='c3566123-901e-414c-a3ae-3240a010add7'\n\n")
            end # if
            kibuvits_typecheck_ar_content(bn,Integer,ar_or_i_aa,
            "GUID='271a5dd1-1170-49a6-9cae-3240a010add7'")
            kibuvits_typecheck_ar_content(bn,Integer,ar_or_i_bb,
            "GUID='49e0e5b3-f711-4d64-aaae-3240a010add7'")
         end # if
         verify_txor_arguments_t1(0,0,m) # a hack to verify m
      end # if
      ar_aa=Kibuvits_ix.normalize2array(ar_or_i_aa)
      ar_bb=Kibuvits_ix.normalize2array(ar_or_i_bb)
      i_len=ar_aa.size
      ar_out=Array.new(i_len)
      aa=nil
      bb=nil
      i_0=nil
      ar_aa.i_len.times do |i|
         aa=ar_aa[i]
         bb=ar_bb[i]
         i_0=txor_impl_1(aa,bb,m)
         ar_out[i]=i_0
      end # loop
      return ar_out
   end # ar_txor_impl_2

   # The primer guarantees that the
   # key sequence of "0"*40 will not
   # reveal the cleartext to pattern
   # recognition software that does not
   # remove the primer prior to detection.
   #
   # The primer will be encrypted
   # the classical, TXOR, way.
   #
   # The pattern recognition software
   # might look for standard text
   # fragments like <doctype> <html>, etc.
   def ar_gen_primer(i_primer_len,m)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Integer, i_primer_len
         kibuvits_assert_is_smaller_than_or_equal_to(bn, 2, i_primer_len)
         verify_txor_arguments_t1(0,0,m) # a hack to verify m
      end # if
      ht=Hash.new
      b_go_on=true
      i_ix=0
      i_mminus1=m-1 # 2≤m
      i_0=nil
      s_0=nil
      ar_out=Array.new(i_primer_len)
      while b_go_on do
         i_0=@ob_rand.rand(i_mminus1)
         s_0=i_0.to_s
         if !ht.has_key? s_0
            ht[s_0]=42
            ar_out[i_ix]=i_0
            i_ix=i_ix+1
            b_go_on=false if i_primer_len==i_ix
            if KIBUVITS_b_DEBUG
               if i_primer_len<i_ix
                  kibuvits_throw("GUID='1e4eaa20-f26b-46ea-85ae-3240a010add7'\n\n")
               end # if
            end # if
         end # if
      end # loop
      return ar_out
   end # ar_gen_primer

   public

   def encrypt
      # POOLELI
      # ar_gen_primer ja ar_txor_impl_2 on
      # testimisvalmis.
   end # encrypt

   #-----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_security_txor_codec_t1

#==========================================================================

