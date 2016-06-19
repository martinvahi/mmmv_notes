#!/usr/bin/env ruby 
#==========================================================================
=begin

 The MIT license from the 
 http://www.opensource.org/licenses/mit-license.php

 Copyright (c) 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 Permission is hereby granted, free of charge, to 
 any person obtaining a copy of this software and 
 associated documentation files (the "Software"), 
 to deal in the Software without restriction, including 
 without limitation the rights to use, copy, modify, merge, publish, 
 distribute, sublicense, and/or sell copies of the Software, and 
 to permit persons to whom the Software is furnished to do so, 
 subject to the following conditions:

 The above copyright notice and this permission notice shall be included 
 in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
 IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
 CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, 
 TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

---------------------------------------------------------------------------

This file is totally selfcontained and contains only one 
function, the string concatenation function. Its selftests 
reside within the Kibuvits Ruby Library (KRL).

=end
#==========================================================================

def kibuvits_s_concat_array_of_strings(ar_in)
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
end # kibuvits_s_concat_array_of_strings


#=========================================================================

