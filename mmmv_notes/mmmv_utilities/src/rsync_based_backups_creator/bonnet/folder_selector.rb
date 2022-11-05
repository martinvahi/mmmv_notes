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

The following Bash script demonstrates the main functionality 
of this Ruby script:

#----The--Bash--script--start---
#!/bin/bash 
PERIOD_MINUS_ONE="3"

for i in `seq 0 $PERIOD_MINUS_ONE`; do 
    ruby -Ku ./folder_selector.rb $PERIOD_MINUS_ONE
done

for i in `seq 0 $PERIOD_MINUS_ONE`; do 
    echo $i
done

seq 0 $PERIOD_MINUS_ONE

#----The--Bash--script--end-----

=end
#==========================================================================
# Configuration:
I_FOLDER_INDEX_MAX_IF_NOT_GIVEN_AS_ARGV1=1

#--------------------------------------------------------------------------
# Everything below this line is just part of the implementation.
#--------------------------------------------------------------------------

i_argv_size=ARGV.size
if i_argv_size==1
   I_FOLDER_INDEX_MAX=ARGV[0].to_i
else
   if i_argv_size==0
      I_FOLDER_INDEX_MAX=I_FOLDER_INDEX_MAX_IF_NOT_GIVEN_AS_ARGV1
   else
      msg="\n\nARGV.size=="+i_argv_size.to_s+", but the maximum "+
      "accepted number of console parameters is 1\n\n"
      raise Exception.new(msg)
   end # if
end # if

#--------------------------------------------------------------------------

I_FOLDER_INDEX=0

=begin FEEDBACK_BLOCK_START

Last execution timestamp: 2012-06-01T11:09:38+03:00

FEEDBACK_BLOCK_END
=end 

#--------------------------------------------------------------------------

KIBUVITS_b_DEBUG=false
require "date"

# It's actually a copy of a TESTED version of
# Kibuvits_str.s_concat_array_of_strings
# and this copy here is made to avoid making the
# kibuvits_io.rb to depend on the kibuvits_str.rb
def kibuvits_hack_to_break_circular_dependency_between_io_and_str_s_concat_array_of_strings(ar_in)
   s_lc_emptystring=nil
   if defined? $kibuvits_lc_emptystring
      s_lc_emptystring=$kibuvits_lc_emptystring
   else
      s_lc_emptystring=""
   end # if
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Array, ar_in
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
   # Believe it or not, but the speed difference
   # in PHP is at least about 20% and in Ruby about 50%.
   # Please do not take my word on it. Try it out yourself by
   # modifying this function and assembling strings of length
   # 10000 from single characters.
   #
   # This here is probably not the most optimal solution, because
   # within the more optimal solution the the order of
   # "concatenation glue placements" depends on the lengths
   # of the tokens/strings, but analysis and "gluing queue"
   # assembly also has a computational cost, and the version
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
         kibuvits_throw("This function is flawed.")
      end # if
   end # if
   return s_out
end # kibuvits_hack_to_break_circular_dependency_between_io_and_str_s_concat_array_of_strings

def file2str(s_file_path)
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck binding(), String, s_file_path
      if !defined? kibuvits_hack_to_break_circular_dependency_between_io_and_fs_ensure_absolute_path
         s="3ff80352-1591-43af-b61c-5023b0d11cd7" # a var to make the GUID match a regex
         kibuvits_throw("If the control flow is in this area, \""+
         s+"\", it is expected that the file2str is called while it is part of the "+
         "Kibuvits Ruby Library. In here the tested method must exist.")
      end # if
   end # if
   # The idea here is to make the file2str easily copyable to projects that
   # do not use the Kibuvits Ruby Library.
   s_fp=nil
   if defined? kibuvits_hack_to_break_circular_dependency_between_io_and_fs_ensure_absolute_path
      s_fp=kibuvits_hack_to_break_circular_dependency_between_io_and_fs_ensure_absolute_path(
      s_file_path,Dir.pwd)
   else
      s_fp=s_file_path
   end # if
   s_emptystring="" # to avoid repeated instantiation
   s_out=s_emptystring
   ar_lines=Array.new
   begin
      File.open(s_fp) do |file|
         while line = file.gets
            ar_lines<<s_emptystring+line
         end # while
      end # Open-file region.
      s_out=kibuvits_hack_to_break_circular_dependency_between_io_and_str_s_concat_array_of_strings(ar_lines)
   rescue Exception =>err
      raise "\n"+err.to_s+"\n\ns_file_path=="+s_file_path+"\n\n"
   end # rescue
   return s_out
end # file2str

def str2file(s_a_string, s_fp_osspecific)
   begin
      file=File.open(s_fp_osspecific, "w")
      file.write(s_a_string)
      file.close
   rescue Exception =>err
      raise "No comments. s_a_string=="+s_a_string+"\n"+err.to_s+"\n\n"
   end # rescue
end # str2file

#--------------------------------------------------------------------------

def s_feedback_block_content
   s_out="Last execution timestamp: "+DateTime.now.to_s
end # s_feedback_block_content

def s_update_feedback_block_content(s_file)
   b_outside_the_feedback_block=true
   b_block_update_complete=false
   rgx_start=/^=begin[\s]+FEEDBACK_BLOCK_START/
   rgx_end=/^[\s]*FEEDBACK_BLOCK_END/
   md=nil
   ar_lines=Array.new
   s_file.each_line do |s_line|
      if !b_block_update_complete
         if b_outside_the_feedback_block
            md=s_line.match(rgx_start)
            if md!=nil
               b_outside_the_feedback_block=false
            end # if
            ar_lines<<s_line
         else
            md=s_line.match(rgx_end)
            if md!=nil
               ar_lines<<"\n"
               ar_lines<<s_feedback_block_content()
               ar_lines<<"\n\n"
               ar_lines<<s_line
               b_block_update_complete=true
            end # if
         end # if
      else
         ar_lines<<s_line
      end # if
   end # loop
   s_out=kibuvits_hack_to_break_circular_dependency_between_io_and_str_s_concat_array_of_strings(ar_lines)
   return s_out
end # s_update_feedback_block_content

#--------------------------------------------------------------------------

# There can be a situation, where the I_FOLDER_INDEX_MAX==3, the
# I_FOLDER_INDEX is assigned the value of 3, but before the
# next run the user decreases the I_FOLDER_INDEX_MAX
# to the level, where  I_FOLDER_INDEX_MAX<I_FOLDER_INDEX .
# To retain the round-robin style of the output, the
# I_FOLDER_INDEX_MAX<I_FOLDER_INDEX case is handled by
# overflowing to zero, 0.
def i_get_folder_index
   i_folder_index=nil
   if I_FOLDER_INDEX_MAX<I_FOLDER_INDEX
      i_folder_index=0
   else
      i_folder_index=I_FOLDER_INDEX
   end # if
   return i_folder_index
end # i_get_folder_index

def the_implementation
   i_folder_index=i_get_folder_index()
   i_folder_index_new=i_folder_index+1
   i_folder_index_new=0 if I_FOLDER_INDEX_MAX<i_folder_index_new
   s_file=file2str(__FILE__)
   s_file=s_update_feedback_block_content(s_file)

   # The rgx can not be assembled by using the i_folder_index_new,
   # because the I_FOLDER_INDEX=SomeValue may have a
   # condition that the i_folder_index_new!=SomeValue .
   rgx=Regexp.new("I_FOLDER_INDEX[\\s]*=[\\s]*\\d+")

   s_file_new=s_file.sub(rgx,"I_FOLDER_INDEX="+i_folder_index_new.to_s)
   str2file(s_file_new,__FILE__)
   puts i_folder_index.to_s
end # the_implementation

the_implementation()
#==========================================================================

