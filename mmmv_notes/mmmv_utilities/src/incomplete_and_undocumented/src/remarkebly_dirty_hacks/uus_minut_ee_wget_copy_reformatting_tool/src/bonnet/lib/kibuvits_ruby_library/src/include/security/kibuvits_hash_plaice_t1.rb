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

require  KIBUVITS_HOME+"/src/include/security/kibuvits_security_core.rb"

#==========================================================================

#
# http://longterm.softf1.com/specifications/hash_functions/plaice_hash_function/
#
# It's selftests are part of the Kibuvits_security_core selftests.
#
class Kibuvits_hash_plaice_t1

   def initialize
      @mx_ar_of_ht_substitution_boxes_t1_datainit=Mutex.new
      #---------
      # Actual alphabets are all at least as long as the
      # Kibuvits_security_core.ar_s_set_of_alphabets_t1()
      @ar_s_set_of_alphabets_t1=Kibuvits_security_core.ar_s_set_of_alphabets_t1()
      @i_ar_s_set_of_alphabets_t1_len=@ar_s_set_of_alphabets_t1.size
      #---------------
      # The variables that contain string "_algorithm_constant_"
      # in their names, must be transferred to the PHP and JavaScript sources.
      s="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @s_algorithm_constant_arabic_digits_and_english_alphabet=("0123456789"+s+
      s.downcase).freeze
      @i_algorithm_constant_prime_t1=397
      @s_algorithm_constant_version="v_plaice_t1_e".freeze
      #---------
      @lc_s_ar_i_s_in="ar_i_s_in".freeze
      @lc_s_i_len_alphabet="i_len_alphabet".freeze
      @lc_s_blockoper_scatter_t1_ar_index_templates="blockoper_scatter_t1_ar_index_templates".freeze
   end # initialize

   #-----------------------------------------------------------------------

   private

   def ht_substitution_box_t1
      func_substbox=lambda do |ix|
         # The i_interval has to be small enough to fit
         # more than once into the 26 character Latin alphabet.
         # Otherwise many of the real-life texts might
         # not get shuffled "enough".
         i_interval=5
         i_mod_0=ix%i_interval
         return nil if i_mod_0!=0
         i_mod_1=ix%(5*i_interval)
         return nil if (i_mod_1==0) # to break the regularity a bit
         ar_keyvaluepairs=Array.new
         ix_1=ix+3
         ar_keyvaluepairs<<[ix,ix_1]
         ar_keyvaluepairs<<[ix_1,ix]
         return ar_keyvaluepairs
      end # func_substbox
      ht_out=Kibuvits_security_core.ht_gen_substitution_box_t1(
      func_substbox,@i_ar_s_set_of_alphabets_t1_len)
      return ht_out
   end #  ht_substitution_box_t1

   # The Kibuvits_security_core_doc.new.doc_study_n_of_necessary_collisions_t1()
   #
   # explains this substitution box.
   # For short: 32 rounds and a batch of 8
   def ht_substitution_box_t2
      func_substbox=lambda do |ix|
         i_delta_1=4 # XcccXccc ... {X,3c}
         i_delta_2=8*i_delta_1+5
         i_mod_d2=ix%i_delta_2
         return nil if i_mod_d2!=0
         #-----------
         i_delta_3=i_delta_2*5
         i_mod_d3=ix%i_delta_3
         return nil if (i_mod_d3==0) # to break the regularity a bit
         #-----------
         ar_keyvaluepairs=Array.new
         8.times do |ii|
            ar_keyvaluepairs<<[(ix+ii*i_delta_1),ix]
         end # loop
         #-----------
         return ar_keyvaluepairs
      end # func_substbox
      ht_out=Kibuvits_security_core.ht_gen_substitution_box_t1(
      func_substbox,@i_ar_s_set_of_alphabets_t1_len)
      return ht_out
   end #  ht_substitution_box_t2

   def ht_substitution_box_t3
      func_substbox=lambda do |ix|
         i_interval=37
         i_mod_0=ix%i_interval
         return nil if i_mod_0!=0
         i_mod_1=ix%(11*i_interval)
         return nil if (i_mod_1==0) # to break the regularity a bit
         ar_keyvaluepairs=Array.new
         ix_0=ix-1  # even
         ix_1=ix+29 # odd
         ar_keyvaluepairs<<[ix_0,ix_1]
         ar_keyvaluepairs<<[ix_1,ix_0]
         return ar_keyvaluepairs
      end # func_substbox
      ht_out=Kibuvits_security_core.ht_gen_substitution_box_t1(
      func_substbox,@i_ar_s_set_of_alphabets_t1_len)
      return ht_out
   end #  ht_substitution_box_t3


   public

   # The substitution boxes are stored to an
   # array, because this way code generation
   # scripts that transfer the substitution
   # boxes to other languages, for example, PHP and JavaScript,
   # do not need to be edited, when the number
   # of substitution boxes changes.
   def ar_of_ht_substitution_boxes_t1
      if defined? @ar_of_ht_substitution_boxes_t1_cache
         ar_out=@ar_of_ht_substitution_boxes_t1_cache
         return ar_out
      end # if
      @mx_ar_of_ht_substitution_boxes_t1_datainit.synchronize do
         if defined? @ar_of_ht_substitution_boxes_t1_cache
            ar_out=@ar_of_ht_substitution_boxes_t1_cache
            return ar_out
         end # if
         ar_substboxes=Array.new
         ar_substboxes<<ht_substitution_box_t1()
         ar_substboxes<<ht_substitution_box_t2()
         ar_substboxes<<ht_substitution_box_t3()
         @ar_of_ht_substitution_boxes_t1_cache=ar_substboxes.freeze
      end # synchronize
      ar_out=@ar_of_ht_substitution_boxes_t1_cache
      return ar_out
   end # ar_of_ht_substitution_boxes_t1

   def Kibuvits_hash_plaice_t1.ar_of_ht_substitution_boxes_t1
      ar_out=Kibuvits_hash_plaice_t1.instance.ar_of_ht_substitution_boxes_t1
      return ar_out
   end # Kibuvits_hash_plaice_t1.ar_of_ht_substitution_boxes_t1

   #-----------------------------------------------------------------------

   private

   # The returned array might be longer than the i_headerless_hash_length.
   def ar_gen_ar_opmem(ht_opmem)
      ar_s_in=ht_opmem["ar_s_in"]
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      ht_alphabet_char2ix=ht_opmem["ht_alphabet_char2ix"]
      i_headerless_hash_length=ht_opmem["i_headerless_hash_length"]
      #---------------------
      # In an effort to make the hash algorithm
      # more sensitive to its input, the blocks are
      # extracted from the input character stream by
      # introducing a shift. An example:
      #
      #     s_in == "abcdefgh"
      #
      #     opmem data blocks:
      #         "abc"
      #         "def"
      #         "ghA".downcase  # end of s_in, shift introduced
      #         "bcd"           # shifted
      #         "efg"           # shifted
      #         "hAb".downcase  # end of s_in, another shift introduced
      #
      i_s_in_len=ar_s_in.size
      i_opmem_length=i_headerless_hash_length
      i_mod_s_in=i_s_in_len%2
      i_mod_opmem=i_opmem_length%2
      i_opmem_length=i_opmem_length+1 if i_mod_s_in==i_mod_opmem
      #------------
      ar_opmem=Array.new(i_opmem_length,42)
      ix_ar_opmem=0
      s_char=nil
      i_char=nil
      while (ix_ar_opmem<i_opmem_length) && (ix_ar_opmem<i_s_in_len)
         s_char=ar_s_in[ix_ar_opmem]
         i_char=ht_alphabet_char2ix[s_char]
         ar_opmem[ix_ar_opmem]=i_char
         ix_ar_opmem=ix_ar_opmem+1
      end # while
      # The code would be correct even, if the
      # content of the next if-clause were not
      # wrapped by the if-clause, but it saves
      # some CPU-cycles.
      if ix_ar_opmem<i_opmem_length
         #-------------
         # To increase the probability that the
         #
         #     (i_len_alphabet mod i_delta)!=0
         #
         # the i_delta should be some "big" prime number.
         # If the
         #
         #     (i_len_alphabet mod i_delta)!=0
         #
         # then there will likely be a similar shifting
         # phenomena that the i_opmem_length was tuned to achieve.
         # On the other hand, the i_delta should not be
         # "too big", because the alphabet might contain
         # only a few thousand characters.
         #
         # If the
         #
         #     (i_len_alphabet mod i_delta)==0
         #
         # then the only
         #
         #     i_len_alphabet div i_delta
         #
         # characters are are available for padding
         # the ar_opmem.
         #
         i_delta=@i_algorithm_constant_prime_t1 # a "big", but "not too big", prime number
         i_char=(i_char+i_delta)%i_len_alphabet
         if KIBUVITS_b_DEBUG
            bn=binding()
            kibuvits_assert_is_smaller_than_or_equal_to(bn,
            (i_delta+1),i_len_alphabet, "There's a flaw in the code.\n"+
            "GUID='52412b11-3327-4d34-b796-d1526021ced7'\n\n")
         end # if
         while ix_ar_opmem<i_opmem_length
            i_char=(i_char+i_delta)%i_len_alphabet
            ar_opmem[ix_ar_opmem]=i_char
            ix_ar_opmem=ix_ar_opmem+1
         end # while
      end # if
      return ar_opmem
   end # ar_gen_ar_opmem(i_hash_length)

   #-----------------------------------------------------------------------

   def read_2_ar_opmem_raw(ht_opmem)
      ar_opmem_raw=ht_opmem[$kibuvits_lc_ar_opmem_raw]
      ar_i_s_in=ht_opmem[@lc_s_ar_i_s_in]
      #---------------------
      # The ix_ar_x_in_cursor points to the first character
      # of the next iteration. The general idea is that
      # the s_in might be shorter than the ar_opmem or, generally,
      #
      #     (s_in.lenght mod ar_opmem.size) != 0
      #
      # and the s_in is cycled through, character by character.
      #
      ix_ar_x_in_cursor=0
      if ht_opmem.has_key? $kibuvits_lc_ix_ar_x_in_cursor
         ix_ar_x_in_cursor=ht_opmem[$kibuvits_lc_ix_ar_x_in_cursor]
      end # if
      #---------------------
      i_opmem_length=ar_opmem_raw.size
      i_s_in_len=ar_i_s_in.size
      #---------------------
      #    ABCDE
      #       A
      #    01234
      #---------------------
      ix=0
      i_char=nil
      if KIBUVITS_b_DEBUG
         i_char=nil
         bn=binding()
         while ix<i_opmem_length
            i_char=ar_i_s_in[ix_ar_x_in_cursor]
            #---------
            if i_char.class!=Fixnum
               # The if-clause wrapping current comment
               # is code bloat, but it's for speed, because
               # otherwise the error message string should
               # be assembled at every call to the typecheck.
               kibuvits_typecheck(bn, Fixnum, i_char,
               "\n ix_ar_x_in_cursor=="+ix_ar_x_in_cursor.to_s+
               "\nGUID='422c5582-57bb-4477-bcc4-d1526021ced7'")
            end # if
            #---------
            ar_opmem_raw[ix]=i_char
            ix_ar_x_in_cursor=ix_ar_x_in_cursor+1
            ix_ar_x_in_cursor=0 if ix_ar_x_in_cursor==i_s_in_len
            ix=ix+1
         end # while
      else
         while ix<i_opmem_length
            i_char=ar_i_s_in[ix_ar_x_in_cursor]
            ar_opmem_raw[ix]=i_char
            ix_ar_x_in_cursor=ix_ar_x_in_cursor+1
            ix_ar_x_in_cursor=0 if ix_ar_x_in_cursor==i_s_in_len
            ix=ix+1
         end # while
      end # if
      #---------------------
      ht_opmem[$kibuvits_lc_ix_ar_x_in_cursor]=ix_ar_x_in_cursor
   end # read_2_ar_opmem_raw

   #-----------------------------------------------------------------------

   def blockoper_apply_substitution_box(ht_opmem,i_substitution_box_index)
      ar_substboxes=ar_of_ht_substitution_boxes_t1()
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_arrayix(bn,ar_substboxes,i_substitution_box_index,
         "GUID='fa2319c7-9034-4534-bc91-d1526021ced7'\n")
      end # if
      ht_substbox=ar_substboxes[i_substitution_box_index]
      #-----------
      ar_opmem_0=ht_opmem[$kibuvits_lc_ar_opmem_0]
      ar_opmem_1=ht_opmem[$kibuvits_lc_ar_opmem_1]
      ar_orig=nil
      ar_dest=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ar_opmem_0
         ar_dest=ar_opmem_1
      else
         ar_orig=ar_opmem_1
         ar_dest=ar_opmem_0
      end # if
      i_opmem_length=ar_opmem_0.size
      #-----------
      i_char_old=nil
      i_char_new=nil
      ix=0
      while ix<i_opmem_length
         i_char_old=ar_orig[ix]
         if ht_substbox.has_key? i_char_old
            i_char_new=ht_substbox[i_char_old]
         else
            i_char_new=i_char_old
         end # if
         ar_dest[ix]=i_char_new
         ix=ix+1
      end # loop
      #-----------
      b_data_in_ar_opmem_0=(!b_data_in_ar_opmem_0)
      ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]=b_data_in_ar_opmem_0
   end # blockoper_apply_substitution_box


   def blockoper_txor_raw_and_opmem(ht_opmem)
      ar_opmem_0=ht_opmem[$kibuvits_lc_ar_opmem_0]
      ar_opmem_1=ht_opmem[$kibuvits_lc_ar_opmem_1]
      ar_opmem_raw=ht_opmem[$kibuvits_lc_ar_opmem_raw]
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      ar_orig=nil
      ar_dest=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ar_opmem_0
         ar_dest=ar_opmem_1
      else
         ar_orig=ar_opmem_1
         ar_dest=ar_opmem_0
      end # if
      i_opmem_length=ar_opmem_0.size
      #-----------
      i_char_old=nil
      i_char_new=nil
      i_char_raw=nil
      ix=0
      while ix<i_opmem_length
         i_char_old=ar_orig[ix]
         # The ar_opmem_raw has the same length as
         # the ar_opmem_0 and ar_opmem_1.
         i_char_raw=ar_opmem_raw[ix]
         i_char_new=Kibuvits_security_core.txor(
         i_char_old,i_char_raw,i_len_alphabet)
         ar_dest[ix]=i_char_new
         ix=ix+1
      end # loop
      #-----------
      b_data_in_ar_opmem_0=(!b_data_in_ar_opmem_0)
      ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]=b_data_in_ar_opmem_0
   end # blockoper_txor_raw_and_opmem


   # Its purpose is to make sure that every character
   # in the opmem block influences all the rest of the
   # characters in the opmem block.
   def blockoper_txor_opmemwize_t1(ht_opmem)
      ar_orig=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ht_opmem[$kibuvits_lc_ar_opmem_0]
      else
         ar_orig=ht_opmem[$kibuvits_lc_ar_opmem_1]
      end # if
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      i_opmem_length=ar_orig.size
      #-----------
      i_char_old=nil
      i_char_new=nil
      i_char_leftside=nil
      ix=1 # array indices start from 0
      while ix<i_opmem_length
         i_char_leftside=ar_orig[ix-1]
         i_char_old=ar_orig[ix]
         i_char_new=Kibuvits_security_core.txor(
         i_char_leftside,i_char_old,i_len_alphabet)
         ar_orig[ix]=i_char_new
         ix=ix+1
      end # loop
      # The next if-clause rotates over the top,
      # back to the beginning, i.e. from the
      # greatest index to the smallest index, the index 0.
      if 1<i_opmem_length
         ix_last=i_opmem_length-1
         i_char_leftside=ar_orig[ix_last] # actually the rightmost
         i_char_old=ar_orig[0]            # this time the leftmost
         i_char_new=Kibuvits_security_core.txor(
         i_char_leftside,i_char_old,i_len_alphabet)
         ar_orig[0]=i_char_new
      end # if
   end # blockoper_txor_opmemwize_t1


   def blockoper_swap_t1(ht_opmem)
      ar_orig=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ht_opmem[$kibuvits_lc_ar_opmem_0]
      else
         ar_orig=ht_opmem[$kibuvits_lc_ar_opmem_1]
      end # if
      i_opmem_length=ar_orig.size
      #-----------
      i_char_leftside=nil
      i_char_rightside=nil
      ix_rightside=nil
      ix=5 # array indices start from 0
      while ix<i_opmem_length
         i_char_leftside=ar_orig[ix]
         ix_rightside=(ix+3)%i_opmem_length
         i_char_rightside=ar_orig[ix_rightside]
         ar_orig[ix_rightside]=i_char_leftside
         ar_orig[ix]=i_char_rightside
         ix=ix+5
      end # loop
   end #  blockoper_swap_t1(ht_opmem)

   # The purpose of this operation is to distribute
   # opmem characters to the whole alphabet, even, if
   # all of the opmem characters are equal. It's harder
   # to conduct cryptanalysis, if the distribution of
   # the output hash characters is uniform regardless of
   # the distribution of the input characters.
   #
   # It also lessens the likelihood that collision based substitution
   # boxes converge the process to a "local minimum" like state.
   def blockoper_scatter_t1(ht_opmem)
      ar_opmem_0=ht_opmem[$kibuvits_lc_ar_opmem_0]
      ar_opmem_1=ht_opmem[$kibuvits_lc_ar_opmem_1]
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      ar_orig=nil
      ar_dest=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ar_opmem_0
         ar_dest=ar_opmem_1
      else
         ar_orig=ar_opmem_1
         ar_dest=ar_opmem_0
      end # if
      i_opmem_length=ar_opmem_0.size
      #-----------
      i_template=nil
      ar_index_templates=nil
      if !ht_opmem.has_key? @lc_s_blockoper_scatter_t1_ar_index_templates
         ar_index_templates=Array.new(i_opmem_length,42)
         i_delta=i_len_alphabet.div(i_opmem_length)+1
         ix=0
         i_template=0
         while ix<i_opmem_length
            ar_index_templates[ix]=i_template
            i_template=(i_template+i_delta)%i_len_alphabet
            ix=ix+1
         end # loop
         ht_opmem[@lc_s_blockoper_scatter_t1_ar_index_templates]=ar_index_templates
      else
         ar_index_templates=ht_opmem[@lc_s_blockoper_scatter_t1_ar_index_templates]
      end # if
      #-----------
      i_char_old=nil
      i_char_new=nil
      ix=0
      while ix<i_opmem_length
         i_char_old=ar_orig[ix]
         i_template=ar_index_templates[ix]
         i_char_new=(i_char_old+i_template)%i_len_alphabet
         ar_dest[ix]=i_char_new
         ix=ix+1
      end # loop
      #-----------
      b_data_in_ar_opmem_0=(!b_data_in_ar_opmem_0)
      ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]=b_data_in_ar_opmem_0
   end # blockoper_scatter_t1

   #-----------------------------------------------------------------------

   def gather_the_hash_string_from_data_structures(ht_opmem)
      i_minimum_n_of_rounds=ht_opmem["i_minimum_n_of_rounds"]
      i_headerless_hash_length=ht_opmem["i_headerless_hash_length"]
      ht_alphabet_ix2char=ht_opmem["ht_alphabet_ix2char"]
      #--------------
      ar_s=[@s_algorithm_constant_version+$kibuvits_lc_colon]
      ar_s<<(i_minimum_n_of_rounds.to_s+$kibuvits_lc_pillar)
      ar_ix_hash=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_ix_hash=ht_opmem[$kibuvits_lc_ar_opmem_0]
      else
         ar_ix_hash=ht_opmem[$kibuvits_lc_ar_opmem_1]
      end # if
      ix=0
      i_char=nil
      while ix<i_headerless_hash_length
         i_char=ar_ix_hash[ix]
         s_char=ht_alphabet_ix2char[i_char]
         ar_s<<s_char
         ix=ix+1
      end # loop
      s_out=kibuvits_s_concat_array_of_strings(ar_s)
      return s_out
   end # gather_the_hash_string_from_data_structures

   #-----------------------------------------------------------------------

   public

   # General explanation resides at
   #
   # http://longterm.softf1.com/specifications/hash_functions/plaice_hash_function/
   #
   # A few references to inspirations:
   # http://www.cs.technion.ac.il/~biham/Reports/Tiger/
   # http://www.cs.technion.ac.il/~orrd/SHAvite-3/
   #
   #
   # A few ideas, how to increase the computational expense of
   # deriving the input string from the hash function output:
   #
   # idea_1) Mimic classical, cryptographically strong,
   #         hash functions that use XOR, except that
   #         in stead of using the bitwise XOR, TXOR is used.
   #         http://longterm.softf1.com/specifications/txor/
   #
   # idea_2) Substitution boxes that collide some of the
   #         elements in their domain.
   #         (offers more "originals" for the hash function
   #          output, therefore increases the likelihood of
   #          collisions, but makes it harder to derive exact
   #          input from the output);
   #
   # idea_3) A whole, cyclic, maze of data flows that
   #         have been constructed from idea_1 and idea_2.
   #         The maze might have the shape of a square that
   #         has been recursively divided to smaller squares by
   #         horizontal and vertical bisections. Cross-sections
   #         of lines form graph nodes.
   #
   # idea_5) Colliding probability of
   #         broken_hash_algorithm_1 and
   #         broken_hash_algorithm_2 can be decreased
   #         by conjunction:
   #
   #         far_more_secure_hash_function(s_data) =
   #             = broken_hash_algorithm_1(s_data).concat(
   #               broken_hash_algorithm_2(s_data))
   #
   # idea_6) To make sure that input strings
   #         "cal", "call" and  "wall"
   #         produce different hashes, the hash
   #         has to contain the whole alphabet
   #         and something has to be done with
   #         character counts. To hide the original
   #         message, the original message has to be
   #         extended with characters that are not
   #         in the original message. To hide
   #         Names and number of sentences in the
   #         original message, all characters should
   #         be downcased. On the other hand,
   #         "Wall" and "wall" should produce
   #         different hash values.
   #
   #
   # The unit of the i_headerless_hash_length is "number of characters"
   # and it must be at least 1. Hash format:
   #
   #     <header>|<headerless hash of length i_headerless_hash_length>
   #
   # The <header> does not contain the character "|".
   # Header format: <protocol name and version>:<i_minimum_n_of_rounds>
   #
   # The 300 characters per headerless hash is roughly 300*14b~4200b
   # The 30  characters per headerless hash is roughly  30*14b~ 420b
   # Approximately 7 (seven) characters should be enough to
   # hide the s_in from the NSA for 20 years, prior to the year 2150.
   # For security reasons the minimum value for the i_minimum_n_of_rounds
   # should be 40, but for file checksums it can be 1.
   # The i_minimum_n_of_rounds is part of the parameters only
   # to make it possible to increase the strength of the
   # hash, should the extra number of rounds be enough to
   # compensate design vulnerabilities.
   #
   # In addition to byte endianness CPU-s vary in
   # bit endianness (order of bits in a byte).
   #
   #     http://en.wikipedia.org/wiki/Bit_numbering
   #
   # The conversion of bitstream to text is a complex
   # problem and this hash function has been designed to AVIOID
   # solving that problem in cases, where the conversion
   # has been already performed by programming language stdlib.
   # It is discouraged to use this function for calculating
   # file checksums, because other, bitstream oriented,
   # hash function implementations are a lot faster than
   # the implementation of this hash function.
   def generate(s_in,i_headerless_hash_length=30,
      i_minimum_n_of_rounds=40)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_in
         kibuvits_typecheck bn, Fixnum, i_headerless_hash_length
         kibuvits_typecheck bn, Fixnum, i_minimum_n_of_rounds
         kibuvits_assert_is_smaller_than_or_equal_to(bn,1,
         i_headerless_hash_length,
         "GUID='833cacf3-4eec-4376-bb41-d1526021ced7'\n")
         kibuvits_assert_is_smaller_than_or_equal_to(bn,1,
         i_minimum_n_of_rounds,
         "GUID='6a18c818-65fd-42b6-a854-d1526021ced7'\n")
      end # if
      #---------------
      # The next step is essential for making sure
      # that strings that have different lengths, but
      # consist all of same characters, have different hashes.
      # Without it the strings "ttt" and "tttttt" will
      # have the same hash, provided that the
      # i_headerless_hash_length has a value greater than
      # both of the strings. The @s_algorithm_constant_arabic_digits_and_english_alphabet
      # is just an extra measure.
      s_in=(@s_algorithm_constant_arabic_digits_and_english_alphabet+s_in.length.to_s)+s_in
      # A simplistic countermeasure to the "length extension attack" resides
      # near the "rounds" loop.
      #---------------
      ht_opmem=Hash.new
      ht_opmem["i_headerless_hash_length"]=i_headerless_hash_length
      ht_opmem["i_minimum_n_of_rounds"]=i_minimum_n_of_rounds
      #-------------------------------
      # The
      #     "ab\nc".scan(/./)
      # gives
      #     ["a","b","c"]
      # but the
      #     "ab\nc".scan(/.|[\n\r\s\t]/)
      # gives
      #     ["a","b","\n","c"]
      #
      ar_s_in=s_in.scan(/.|[\n\r\s\t]/).freeze
      #---------------
      ht_opmem["ar_s_in"]=ar_s_in
      ar_0=ar_s_in.uniq
      ar_s_alphabet=(ar_0+@ar_s_set_of_alphabets_t1).uniq.freeze
      i_len_alphabet=ar_s_alphabet.size
      ht_alphabet_char2ix=Hash.new # starts from 0
      ht_alphabet_ix2char=Hash.new
      s_char=nil
      # Worst case scenario is that every character
      # of the s_in is a separate character.
      # 1 giga-character, where in average 1 character
      # is approximately 2B, has a size of 2GB. 2G fits
      # perfectly in the range of the 4B int. This means that
      # due to practical speed considerations the ix
      # will never exit the 4B int range.
      i_len_alphabet.times do |ix|
         s_char=ar_s_alphabet[ix]
         ht_alphabet_char2ix[s_char]=ix
         ht_alphabet_ix2char[ix]=s_char
      end # loop
      ht_opmem["ht_alphabet_char2ix"]=ht_alphabet_char2ix
      ht_opmem["ht_alphabet_ix2char"]=ht_alphabet_ix2char
      #---------------
      ht_opmem[@lc_s_i_len_alphabet]=i_len_alphabet
      ar_opmem_0=ar_gen_ar_opmem(ht_opmem)
      i_opmem_length=ar_opmem_0.size
      ht_opmem[$kibuvits_lc_ar_opmem_0]=ar_opmem_0
      ht_opmem[$kibuvits_lc_b_data_in_ar_opmem_0]=true
      ar_opmem_1=Array.new(i_opmem_length,42) # speed hack
      ht_opmem[$kibuvits_lc_ar_opmem_1]=ar_opmem_1
      ar_opmem_raw=Array.new(i_opmem_length,42)
      ht_opmem[$kibuvits_lc_ar_opmem_raw]=ar_opmem_raw
      #---------------
      i_s_in_len=s_in.length
      ar_i_s_in=Array.new(i_s_in_len,42)
      s_in_char=nil
      i_s_in_char=nil
      i_s_in_len.times do |ix|
         s_in_char=ar_s_in[ix]
         i_s_in_char=ht_alphabet_char2ix[s_in_char]
         if i_s_in_char==nil
            kibuvits_throw("\nCharacter \""+s_in_char+
            "\" is missing from the \n"+
            "alphabet that this hash function uses.\n"+
            "The character is missing ONLY because the \n"+
            "hash algorithm implementation is flawed.\n"+
            "GUID='b4a25dd0-1522-4e41-b73f-d1526021ced7'\n\n")
            # That situation can actually happen in real life.
            # Hopefully the exception text allows somewhat
            # gradual degradation by trying to give the end
            # users a temporary semi-workaround in the form
            # of a chance to avoid the character in the input text.
         end # if
         ar_i_s_in[ix]=i_s_in_char
      end # loop
      ar_i_s_in=ar_i_s_in.freeze
      ht_opmem[@lc_s_ar_i_s_in]=ar_i_s_in
      #---------------
      # Characters are read from the s_in and inserted to the
      # hashing operation by a call to a pair of functions:
      #
      #  read_2_ar_opmem_raw(ht_opmem)
      #  blockoper_txor_raw_and_opmem(ht_opmem)
      #
      # To make sure that all characters of the
      # s_in are inserted to the hashing operation,
      # the number of rounds might have to be increased.
      #
      i_n_blocks_per_round=5 # read manually from the rounds loop
      i_n_chars_per_round=i_n_blocks_per_round*i_opmem_length  # i_opmem_length==<block size>
      i_n_chars_taken_to_account=i_minimum_n_of_rounds*i_n_chars_per_round
      i_n_rounds_adjusted=nil
      if i_n_chars_taken_to_account<i_s_in_len
         i_chars_omitted=i_s_in_len-i_n_chars_taken_to_account
         i_rounds_to_add=i_chars_omitted.div(i_n_chars_per_round)+1
         # The "+1" was to compensate a situation, where
         #
         # i_chars_omitted.div(i_n_chars_per_round)*i_n_chars_per_round < i_chars_omitted
         #
         i_n_rounds_adjusted=i_minimum_n_of_rounds+i_rounds_to_add
      else
         i_n_rounds_adjusted=i_minimum_n_of_rounds
      end # if
      #---------------
      # If I (martin.vahi@softf1.com) understand the
      # idea behind a "length extension attack" correctly, (a BIG IF), then
      # the idea behind the "length extension attack" is that the
      # tail part of the s_hashable_string=secret+publicly_known_message
      # is changed by unrolling the hash function from the
      # input datastream tail to somewhere in the middle, replacing the
      # tail and then rolling the hash function back on the tail, the new tail,
      # again.
      # https://en.wikipedia.org/wiki/Length_extension_attack
      # https://github.com/bwall/HashPump
      # https://github.com/iagox86/hash_extender
      #
      # The scheme of the simplistic countermeasure here
      # is that in stead of calculating
      #
      #     s_in=s_secret+s_publicly_known_text
      #     or
      #     s_in=s_publicly_known_text+s_secret
      #     hash(s_in)
      #
      # the countermeasure tries to make sure that
      # "roughly" the following is calculated:
      #
      #     hash(s_secret+s_publicly_known_text+s_secret)
      #
      # A way to do that, approximately, "roughly", is to
      # re-read the start of the
      #
      #     s_in=s_secret+s_publicly_known_text
      #
      # The case, where the "s_secret" is part of the tail, i.e.
      #
      #     s_in=s_publicly_known_text+s_secret
      #
      # is covered by the fact that the tail part, the s_secret part,
      # is fed to the hash algorithm at the very end.
      # So, here it goes, with a semirandom constant of 10% equiv 0.1:
      i_antimeasure_rounds=(i_s_in_len.to_f*0.1/i_n_chars_per_round).round
      i_antimeasure_rounds=i_antimeasure_rounds+1 # also covers the i_antimeasure_rounds==0
      i_n_rounds_adjusted=i_n_rounds_adjusted+i_antimeasure_rounds
      # POOLELI uuendada PHP koodi
      #---------------
      # There is no need to call the
      #
      # blockoper_txor_raw_and_opmem(...)
      #
      # prior to this loop, because the first
      # reading of raw data has been performed
      # within ar_gen_ar_opmem(...)
      i_n_rounds_adjusted.times do |i_round|
         blockoper_scatter_t1(ht_opmem)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_apply_substitution_box(ht_opmem,0)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_apply_substitution_box(ht_opmem,1) # "8-collider"
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_txor_opmemwize_t1(ht_opmem)
         blockoper_swap_t1(ht_opmem)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_apply_substitution_box(ht_opmem,2)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
      end # loop
      #---------------
      # Improve the hash algorithm by adding a loop here,
      # where the Prüfer Code is generated from part
      # of the output of the previous loop, may be the
      # very first character code. The tree as a graph
      # is "sorted" and the nodes of the tree are
      # the substitution boxes and other operations
      # that modify the ht_opmem content.
      #---------------
      s_out=gather_the_hash_string_from_data_structures(ht_opmem)
      return s_out
   end # generate

   # This method has a wrapper: kibuvits_hash_plaice_t1(...)
   def Kibuvits_hash_plaice_t1.generate(s_in,
      i_headerless_hash_length=30,i_minimum_n_of_rounds=40)
      s_out=Kibuvits_hash_plaice_t1.instance.generate(
      s_in,i_headerless_hash_length,i_minimum_n_of_rounds)
      return s_out
   end # Kibuvits_hash_plaice_t1.generate

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_hash_plaice_t1

def kibuvits_hash_plaice_t1(s_in,
   i_headerless_hash_length=30,i_minimum_n_of_rounds=40)
   s_out=Kibuvits_hash_plaice_t1.generate(
   s_in,i_headerless_hash_length,i_minimum_n_of_rounds)
   return s_out
end # kibuvits_hash_plaice_t1


#=========================================================================
# puts kibuvits_hash_plaice_t1("abcc")
