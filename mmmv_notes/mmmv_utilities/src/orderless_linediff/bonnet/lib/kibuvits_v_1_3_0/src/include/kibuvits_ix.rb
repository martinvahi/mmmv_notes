#!/usr/bin/env ruby 
#==========================================================================
=begin

 Copyright 2010, martin.vahi@softf1.com that has an
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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
else
   require  "kibuvits_msgc.rb"
end # if
require "singleton"
#==========================================================================

# The class Kibuvits_ix is a namespace for functions that
# are meant for facilitating the use of indexes. In the
# context of the Kibuvits_ix an index is an Array index,
# hash-table key, etc.
class Kibuvits_ix
   def initialize
   end #initialize

   #-----------------------------------------------------------------------
   private

   # "sar" stands for sub-array. The i_low and i_high
   # are separator-indices.
   def sar_for_strings(s_hay, i_low, i_high)
      # Verification and tests are assumed to be done earlier.
      x_out=""
      i_x_outlen=i_high-i_low
      return x_out if i_x_outlen==0
      x_out=s_hay[i_low..(i_high-1)]
      return x_out
   end # sar_for_strings

   # "sar" stands for sub-array. The i_low and i_high
   # are separator-indices.
   def sar_for_arrays(ar_hay, i_low, i_high)
      # Verification and tests are assumed to be done earlier.
      i_x_outlen=i_high-i_low
      x_out=ar_hay.slice(i_low,i_x_outlen)
      return x_out
   end # sar_for_arrays

   public

   # An explanation by an example:
   #
   #  Array indices:       0   1   2   3   4
   #               array=["H","e","l","l","o"]
   #  Separator indices: 0   1   2   3   4   5
   #
   #
   #                  0   1   2
   # Kibuvits_ix.sar(["H","e"],0,0)==[]         # 0-0=0
   # Kibuvits_ix.sar(["H","e"],0,1)==["H"]      # 1-0=1
   # Kibuvits_ix.sar(["H","e"],1,1)==[]         # 1-1=0
   # Kibuvits_ix.sar(["H","e"],1,2)==["e"]      # 2-1=1
   # Kibuvits_ix.sar(["H","e"],2,2)==[]         # 2-2=0
   # Kibuvits_ix.sar(["H","e"],0,2)==["H","e"]  # 2-0=2
   # Kibuvits_ix.sar(["H","e"],2,2)==[]         # 2-2=0
   #
   # Kibuvits_ix([],0,0)==[]          # 0-0=0
   #
   # "sar" stands for sub-array.
   def sar(haystack,i_lower_separator_index, i_higher_separator_index)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Fixnum, i_lower_separator_index
         kibuvits_typecheck bn, Fixnum, i_higher_separator_index
      end # if
      i_low=i_lower_separator_index
      i_high=i_higher_separator_index
      if i_high<i_low
         kibuvits_throw "i_higher_separator_index=="+i_high.to_s+
         " < i_lower_separator_index=="+i_low.to_s
      end # if
      kibuvits_throw "i_lower_separator_index=="+i_low.to_s+" < 0" if i_low<0
      if haystack.length<i_high
         kibuvits_throw "haystack.length=="+haystack.length.to_s+
         " < i_higher_separator_index=="+i_high.to_s
      end # if
      cl_name=haystack.class.to_s
      case cl_name
      when 'String'
         x_out=sar_for_strings(haystack, i_low, i_high)
         return x_out
      when 'Array'
         x_out=sar_for_arrays(haystack, i_low, i_high)
         return x_out
      else
      end # case
      x_out=haystack.class.new
      i=i_low
      while i<i_high  do
         x_out<<haystack[i].clone
         i=i+1
      end
      return x_out
   end # sar

   # "sar" stands for sub-array.
   def Kibuvits_ix.sar(haystack, i_lower_separator_index,
      i_higher_separator_index)
      x_out=Kibuvits_ix.instance.sar(haystack,i_lower_separator_index,
      i_higher_separator_index)
      return x_out
   end # Kibuvits_ix.sar

   #-----------------------------------------------------------------------
   private

   def bisect_at_sindex_for_strings s_string, i_sindex
      i_slen=s_string.length
      s_left=""
      s_right=""
      return s_left,s_right if i_slen==0
      s_left=s_string[0..(i_sindex-1)] if 0<i_sindex
      s_right=s_string[i_sindex..(-1)] if i_sindex<i_slen # if is for speed
      return s_left,s_right
   end # bisect_at_sindex_for_strings

   def bisect_at_sindex_for_ar ar_hay, i_sindex
      i_arlen=ar_hay.length
      return [],[] if i_arlen==0
      ar_left=ar_hay.slice(0,i_sindex)
      ar_right=ar_hay.slice(i_sindex,(i_arlen-i_sindex))
      return ar_left, ar_right
   end # bisect_at_sindex_for_ar

   public

   #  Array indices:       0   1   2   3   4
   #               array=["H","e","l","l","o"]
   #  Separator indices: 0   1   2   3   4   5
   #
   def bisect_at_sindex(haystack,i_sindex, b_force_element_cloning=false)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Fixnum, i_sindex
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_force_element_cloning
      end # if
      kibuvits_throw "i_sindex=="+i_sindex.to_s+" < 0" if i_sindex<0
      i_hlen=haystack.length
      if i_hlen<i_sindex
         kibuvits_throw "haystack.length=="+i_hlen.to_s+" < i_sindex=="+i_sindex.to_s
      end # if
      cl_name=haystack.class.to_s
      case cl_name
      when 'String'
         x_left,x_right=bisect_at_sindex_for_strings(haystack,
         i_sindex)
         return x_left,x_right
      when 'Array'
         if !b_force_element_cloning
            x_left,x_right=bisect_at_sindex_for_ar(haystack,i_sindex)
            return x_left,x_right
         end # if
      else
      end # case
      x_left=haystack.class.new
      x_right=haystack.class.new
      i_hlen=haystack.length
      i=0
      if b_force_element_cloning
         while i<i_sindex do
            x_left<<haystack[i].clone
            i=i+1
         end # loop
         while i<i_hlen do
            x_right<<haystack[i].clone
            i=i+1
         end # loop
      else
         while i<i_sindex do
            x_left<<haystack[i]
            i=i+1
         end # loop
         while i<i_hlen do
            x_right<<haystack[i]
            i=i+1
         end # loop
      end # if
      return x_left,x_right
   end # bisect_at_sindex

   def Kibuvits_ix.bisect_at_sindex(haystack,i_sindex,
      b_force_element_cloning=false)
      x_left,x_right=Kibuvits_ix.instance.bisect_at_sindex(haystack,i_sindex,
      b_force_element_cloning)
      return x_left,x_right
   end # Kibuvits_ix.bisect_at_sindex

   #-----------------------------------------------------------------------
   private

   def normalize2array_searchstring(x_that_is_not_an_array)
      cl=x_that_is_not_an_array.class
      s_out=(cl.to_s+$kibuvits_lc_underscore)+x_that_is_not_an_array.to_s
      return s_out
   end # normalize2array_searchstring

   public

   def normalize2array_insert_2_ht(ht_values_that_result_an_empty_array,
      x_that_is_not_an_array)
      s_key=normalize2array_searchstring(x_that_is_not_an_array)
      ht_values_that_result_an_empty_array[s_key]=42
   end # normalize2array_insert_2_ht

   def Kibuvits_ix.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,x_that_is_not_an_array)
      Kibuvits_ix.instance.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,x_that_is_not_an_array)
   end # Kibuvits_ix.normalize2array_insert_2_ht

   # If the ht_values_that_result_an_empty_array!=nil,
   # then the entries to it must be inserted by using
   #
   # normalize2array_insert_2_ht(
   #         ht_values_that_result_an_empty_array,<the value>)
   #
   def normalize2array(x_array_or_something_else,
      ht_values_that_result_an_empty_array=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [NilClass,Hash], ht_values_that_result_an_empty_array
      end # if
      cl=x_array_or_something_else.class
      return x_array_or_something_else if cl==Array
      ht_vls_for_empty=ht_values_that_result_an_empty_array
      ar_out=nil
      if ht_vls_for_empty==nil
         ar_out=[x_array_or_something_else]
      else
         s=normalize2array_searchstring(x_array_or_something_else)
         if ht_vls_for_empty.has_key? s
            ar_out=Array.new
         else
            ar_out=[x_array_or_something_else]
         end # if
      end # if
      return ar_out
   end # normalize2array

   def Kibuvits_ix.normalize2array(x_array_or_something_else,
      ht_values_that_result_an_empty_array=nil)
      ar_out=Kibuvits_ix.instance.normalize2array(
      x_array_or_something_else,
      ht_values_that_result_an_empty_array)
      return ar_out
   end # Kibuvits_ix.normalize2array

   #-----------------------------------------------------------------------
   # Explanation by example:
   # ht_1=Hash.new
   # ht_2=Hash.new
   #
   # ht_1["a"]="aaa1"
   # ht_1["c"]="ccc1"
   #
   # ht_2["a"]="aaa2"
   # ht_2["b"]="bbb2"
   #
   # ar_1_2=[ht_1,ht_2]
   # ar_2_1=[ht_2,ht_1]
   #
   # ht_merged_1_2=ht_merge_by_overriding_t1(ar_1_2)
   # ht_merged_2_1=ht_merge_by_overriding_t1(ar_2_1)
   #
   # #---------------|-------------
   # # ht_merged_1_2 | ht_merged_2_1
   # #---------------|-------------
   # #  a=="aaa2"    | a=="aaa1"
   # #  b=="bbb2"    | b=="bbb2"
   # #  c=="ccc1"    | c=="ccc1"
   # #---------------|-------------
   def ht_merge_by_overriding_t1(ar_hashtables)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array,ar_hashtables
         ar_hashtables.each do |ht_candidate|
            bn=binding()
            kibuvits_typecheck bn, Hash, ht_candidate
         end # loop
      end # if
      ht_out=Hash.new
      ar_hashtables.each do |ht|
         ht.each_key do |key|
            ht_out[key]=ht[key]
         end # loop
      end # loop
      return ht_out
   end # ht_merge_by_overriding_t1

   def Kibuvits_ix.ht_merge_by_overriding_t1(ar_hashtables)
      ar_out=Kibuvits_ix.instance.ht_merge_by_overriding_t1(
      ar_hashtables)
      return ar_out
   end # Kibuvits_ix.ht_merge_by_overriding_t1

   #-----------------------------------------------------------------------

   public
   include Singleton
   # The Kibuvits_dependencymetrics_t1.selftest analogue is
   # in a separate selftest file.

end # class Kibuvits_ix
#==========================================================================

