#!/usr/bin/env ruby 
#==========================================================================
=begin

 Copyright 2012, martin.vahi@softf1.com that has an
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

---------------------------------------------------------------------------

To facilitate the exporting of the string concatenation code 
from the Kibuvits Ruby Library (KRL) to other projects,
this file is totally selfcontained.

Its selftests reside within the KRL.

=end
#==========================================================================

def kibuvits_s_concat_array_of_strings_plain(ar_in)
   n=ar_in.size
   if defined? KIBUVITS_b_DEBUG
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array, ar_in
         s=nil
         n.times do |i|
            bn=binding()
            s=ar_in[i]
            kibuvits_typecheck bn, String, s
         end # loop
      end # if
   end # if
   s_out="";
   n.times{|i| s_out<<ar_in[i]}
   return s_out;
end # kibuvits_s_concat_array_of_strings_plain

#--------------------------------------------------------------------------

def kibuvits_s_concat_array_of_strings_watershed(ar_in)
   s_lc_emptystring=""
   if defined? KIBUVITS_b_DEBUG
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array, ar_in
      end # if
   end # if
   i_n=ar_in.size
   if i_n<3
      if i_n==2
         s_out=ar_in[0]+ar_in[1]
         return s_out
      else
         if i_n==1
            # For the sake of consistency one
            # wants to make sure that the returned
            # string instance always differs from those
            # that are within the ar_in.
            s_out=s_lc_emptystring+ar_in[0]
            return s_out
         else # i_n==0
            s_out=s_lc_emptystring
            return s_out
         end # if
      end # if
   end # if
   s_out=s_lc_emptystring # needs to be inited to the ""

   # The classic part for testing and playing.
   # ar_in.size.times{|i| s_out=s_out+ar_in[i]}
   # return s_out

   # In its essence the rest of the code here implements
   # a tail-recursive version of this function. The idea is that
   #
   # s_out='something_very_long'.'short_string_1'.short_string_2'
   # uses a temporary string of length
   # 'something_very_long'.'short_string_1'
   # but
   # s_out='something_very_long'.('short_string_1'.short_string_2')
   # uses a much more CPU-cache friendly temporary string of length
   # 'short_string_1'.short_string_2'
   #
   # Believe it or not, but as of January 2012 the speed difference
   # in PHP can be at least about 20% and in Ruby about 50%.
   # Please do not take my word on it. Try it out yourself by
   # modifying this function and assembling strings of length
   # 10000 from single characters.
   #
   # This here is probably not the most optimal solution, because
   # within the more optimal solution the the order of
   # "concatenation glue placements" depends on the lengths
   # of the tokens/strings, but as the analysis and "gluing queue"
   # assembly also has a computational cost, the version
   # here is almost always more optimal than the totally
   # naive version.
   ar_1=ar_in
   b_ar_1_equals_ar_in=true # to avoid modifying the received Array
   ar_2=Array.new
   b_take_from_ar_1=true
   b_not_ready=true
   i_reminder=nil
   i_loop=nil
   i_ar_in_len=nil
   i_ar_out_len=0 # code after the while loop needs a number
   s_1=nil
   s_2=nil
   s_3=nil
   i_2=nil
   while b_not_ready
      # The next if-statement is to avoid copying temporary
      # strings between the ar_1 and the ar_2.
      if b_take_from_ar_1
         i_ar_in_len=ar_1.size
         i_reminder=i_ar_in_len%2
         i_loop=(i_ar_in_len-i_reminder)/2
         i_loop.times do |i|
            i_2=i*2
            s_1=ar_1[i_2]
            s_2=ar_1[i_2+1]
            s_3=s_1+s_2
            ar_2<<s_3
         end # loop
         if i_reminder==1
            s_3=ar_1[i_ar_in_len-1]
            ar_2<<s_3
         end # if
         i_ar_out_len=ar_2.size
         if 1<i_ar_out_len
            if b_ar_1_equals_ar_in
               ar_1=Array.new
               b_ar_1_equals_ar_in=false
            else
               ar_1.clear
            end # if
         else
            b_not_ready=false
         end # if
      else # b_take_from_ar_1==false
         i_ar_in_len=ar_2.size
         i_reminder=i_ar_in_len%2
         i_loop=(i_ar_in_len-i_reminder)/2
         i_loop.times do |i|
            i_2=i*2
            s_1=ar_2[i_2]
            s_2=ar_2[i_2+1]
            s_3=s_1+s_2
            ar_1<<s_3
         end # loop
         if i_reminder==1
            s_3=ar_2[i_ar_in_len-1]
            ar_1<<s_3
         end # if
         i_ar_out_len=ar_1.size
         if 1<i_ar_out_len
            ar_2.clear
         else
            b_not_ready=false
         end # if
      end # if
      b_take_from_ar_1=!b_take_from_ar_1
   end # loop
   if i_ar_out_len==1
      if b_take_from_ar_1
         s_out=ar_1[0]
      else
         s_out=ar_2[0]
      end # if
   else
      # The s_out has been inited to "".
      if 0<i_ar_out_len
         raise Exception.new("This function is flawed.")
      end # if
   end # if
   return s_out
end # kibuvits_s_concat_array_of_strings_watershed

#--------------------------------------------------------------------------

# Reference to the version of string
# concatenation function that is "usually" the fastest.
def kibuvits_s_concat_array_of_strings(ar_in)
   # In the most frequent cases the time taken by the
   # kibuvits_s_concat_array_of_strings_plain is  about 75% of the
   # time taken by the kibuvits_s_concat_array_of_strings_watershed.
   # In its core mutable strings are "immutable", because they
   # have to be stretched, reallocated, from time to time like variable
   # length arrays/vectors. If the ar_in contains "huge enough" strings, then
   # it might happen that with the "huge enough" strings the
   # kibuvits_s_concat_array_of_strings_watershed
   # takes less time than the plain version. As both of the functions
   # are pretty fast in terms of the absolute amount of time,
   # the watershed version is a more reliable choise.
   #
   s_out=kibuvits_s_concat_array_of_strings_watershed(ar_in)
   #s_out=kibuvits_s_concat_array_of_strings_plain(ar_in)
   return s_out;
end # kibuvits_s_concat_array_of_strings

#=========================================================================

