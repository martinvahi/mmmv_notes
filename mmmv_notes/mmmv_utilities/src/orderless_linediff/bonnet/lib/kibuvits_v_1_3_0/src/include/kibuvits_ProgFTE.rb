#!/usr/bin/env ruby 
#==========================================================================
=begin

 Copyright 2009, martin.vahi@softf1.com that has an
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

------------------------------------------------------------------------
This file adds ProgFTE support to Ruby. It is selfcontained. 

The class ProgFTE_v0 is is too verbose, bloated and kind
of a mess, but the mess there is self-contained, the ProgFTE_v0 
exists for backwards compatibility only and,
one doesn't want to fix, what's isn't broken. :-> 

The public API here is as simple as it can get and resides at
class Kibuvits_ProFTE. Some common code for other ProgFTE 
implementations resides in the class Kibuvits_ProgFTE_v1.

=end
#==========================================================================
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

if defined? KIBUVITS_HOME
   # As the Kibuvits_ProgFTE is used for serialization, the
   # Kibuvits_ProgFTE  may not depend on anything else than
   # the booting code.
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
else
   # To allow the Kibuvits Ruby Library (KRL) ProgFTE implantation
   # to be used without using any part of the rest of the KRL,
   # this file should not include any of the KRL files, if it is
   # used outside of the KRL.
   require("kibuvits_boot.rb") if false
end # if
KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE=false if !defined? KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
require "singleton"
#==========================================================================

# Implements the very first and fundamentally flawed ProgFTE specification,
# the ProgFTE_v0
class Kibuvits_ProgFTE_v0

   def initialize
      @b_kibuvits_bootfile_run=KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
   end #initialize


   def Kibuvits_ProgFTE_v0.selftest_failure(a,b)
      exc=Exception.new(a.to_s+b.to_s)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_throw(exc)
      else raise(exc)
      end # if
   end # Kibuvits_ProgFTE_v0.selftest_failure

   private

   # It's copy-pasted from the Kibuvits_str. The testing
   # code of it resides also there. The
   # dumb duplication is to eliminate the dependency.
   #
   # It returns an array of 2 elements. If the separator is not
   # found, the array[0]==input_string and array[1]=="".
   #
   # The ar_output is for array instance reuse and is expected
   # to increase speed a tiny bit at "snatching".
   def bisect(input_string, separator_string,ar_output=Array.new(2,""))
      i_separator_stringlen=separator_string.length
      if i_separator_stringlen==0
         exc=Exception.new("separator_string==\"\"")
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      ar=ar_output
      i=input_string.index(separator_string)
      if(i==nil)
         ar[0]=input_string
         ar[1]=""
         return ar;
      end # if
      if i==0
         ar[0]=""
      else
         ar[0]=input_string[0..(i-1)]
      end # if
      i_input_stringlen=input_string.length
      if (i+i_separator_stringlen)==i_input_stringlen
         ar[1]=""
      else
         ar[1]=input_string[(i+i_separator_stringlen)..(-1)]
      end # if
      return ar
   end # bisect

   # Returns an array of strings that contains only the snatched string pieces.
   def snatch_n_times(haystack_string, separator_string,n)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_typecheck bn, String, haystack_string
         kibuvits_typecheck bn, String, separator_string
         kibuvits_typecheck bn, Fixnum, n
      end # if
      if(separator_string=="")
         exc=Exception.new("\nThe separator string had a "+
         "value of \"\", but empty strings are not "+
         "allowed to be used as separator strings.");
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      s_hay=haystack_string
      if s_hay.length==0
         exc=Exception.new("haystack_string.length==0")
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      # It's a bit vague, whether '' is also present at the
      # very end and very start of the string or only between
      # characters. That's why there's a limitation, that the
      # separator_string may not equal with the ''.
      if separator_string.length==0
         exc=Exception.new("separator_string.length==0")
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      s_hay=""+haystack_string
      ar=Array.new
      ar1=Array.new(2,"")
      n.times do |i|
         ar1=bisect(s_hay,separator_string,ar1)
         ar<<ar1[0]
         s_hay=ar1[1]
         if (s_hay=='') and ((i+1)<n)
            exc=Exception.new("Expected number of separators is "+n.to_s+
            ", but the haystack_string contained only "+(i+1).to_s+
            "separator strings.")
            if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
               kibuvits_throw(exc)
            else
               raise(exc)
            end # if
         end # if
      end # loop
      return ar;
   end # snatch_n_times

   public
   def ht_to_s(a_hashtable)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_typecheck binding(), Hash, a_hashtable
      end # if
      s=""
      a_hashtable.keys.each do |a_key|
         s=s+a_key.to_s
         s=s+(a_hashtable[a_key].to_s) # Ruby 1.9. bug workaround
      end # loop
      return s;
   end # ht_to_s

   def Kibuvits_ProgFTE_v0.ht_to_s(a_hashtable)
      s=Kibuvits_ProgFTE_v0.instance.ht_to_s(a_hashtable)
      return s;
   end # Kibuvits_ProgFTE_v0.ht_to_s

   def create_nonexisting_needle(haystack_string)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_typecheck binding(), String, haystack_string
      end # if
      n=0
      s_needle='^0'
      while haystack_string.include? s_needle do
         n=n+1;
         s_needle='^'+n.to_s
      end # loop
      return s_needle
   end # create_nonexisting_needle

   def Kibuvits_ProgFTE_v0.create_nonexisting_needle(haystack_string)
      s_needle=Kibuvits_ProgFTE_v0.instance.create_nonexisting_needle(
      haystack_string)
      return s_needle
   end # Kibuvits_ProgFTE_v0.create_nonexisting_needle

   public
   def from_ht(a_hashtable)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_typecheck binding(), Hash, a_hashtable
      end # if
      ht=a_hashtable
      s_subst=create_nonexisting_needle(self.ht_to_s(ht))
      s_progfte=''+ht.size.to_s+'|||'+s_subst+'|||'
      s_key=''; s_value=''; # for a possible, slight, speed improvement
      ht.keys.each do |key|
         a_key=key.to_s # Ruby 1.9 bug workaround
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_typecheck binding(), String, a_key
         end # if
         s_key=a_key.gsub('|',s_subst)
         s_value=(ht[a_key]).to_s
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_typecheck binding(), String, s_value
         end # if
         s_value=s_value.gsub('|',s_subst)
         s_progfte=s_progfte+s_key+'|||'+s_value+'|||'
      end # loop
      return s_progfte
   end # from_ht

   def Kibuvits_ProgFTE_v0.from_ht(a_hashtable)
      s_progfte=Kibuvits_ProgFTE_v0.instance.from_ht(a_hashtable)
      return s_progfte
   end # Kibuvits_ProgFTE_v0.from_ht

   public
   def to_ht(a_string)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_typecheck binding(), String, a_string
      end # if
      ar=bisect(a_string,'|||')
      tf='Kibuvits_ProgFTE_v0.to_ht'
      Kibuvits_ProgFTE_v0.selftest_failure(tf,1) if ar[1]==""
      n=Integer(ar[0])
      s_subst=''
      err_no=2
      ht=Hash.new
      begin
         ar1=bisect(ar[1],'|||')
         s_subst=ar1[0]
         err_no=3
         Kibuvits_ProgFTE_v0.selftest_failure(tf,err_no) if s_subst==''
         err_no=4
         # ar1[1]=='', if n==0 and it's legal in here
         ar=snatch_n_times(ar1[1],'|||',n*2) if 0<n
         err_no=5
         n.times do |x|
            key=ar[x*2].gsub(s_subst,'|')
            value=(ar[x*2+1]).gsub(s_subst,'|')
            ht[key]=value
         end # loop
      rescue Exception => e
         Kibuvits_ProgFTE_v0.selftest_failure(tf.to_s+e.to_s,err_no)
      end # try-catch
      return ht
   end # to_ht

   def Kibuvits_ProgFTE_v0.to_ht(a_string)
      ht=Kibuvits_ProgFTE_v0.instance.to_ht(a_string)
      return ht
   end # Kibuvits_ProgFTE_v0.to_ht

   public
   include Singleton

end #class Kibuvits_ProgFTE_v0

#--------------------------------------------------------------------------

class Kibuvits_ProgFTE_v1

   def initialize
      @lc_s_pillar="|".freeze
      @lc_s_v1__pillar_format_mode_0_pillar="v1|0|".freeze
      @lc_s_const_1="|0||0||".freeze
      @lc_s_emptystring="".freeze
   end #initialize

   def kibuvits_progfte_throw(msg)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_throw(msg)
      else
         throw(Exception.new(msg))
      end # if
   end # kibuvits_progfte_throw


   def Kibuvits_ProgFTE_v1.kibuvits_progfte_throw(msg)
      Kibuvits_ProgFTE_v1.instance.kibuvits_progfte_throw(msg)
   end # Kibuvits_ProgFTE_v1.selftest_failure

   #--------------------------------------------------------------------------

   private

   def kibuvits_progfte_kibuvits_s_concat_array_of_strings_watershed(ar_in)
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
               s_out=@lc_s_emptystring+ar_in[0]
               return s_out
            else # i_n==0
               s_out=@lc_s_emptystring
               return s_out
            end # if
         end # if
      end # if
      s_out=@lc_s_emptystring # needs to be inited to the ""

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
   end # kibuvits_progfte_kibuvits_s_concat_array_of_strings_watershed

   def kibuvits_progfte_s_concat_array_of_strings(ar_in)
      s_out=kibuvits_progfte_kibuvits_s_concat_array_of_strings_watershed(ar_in)
      return s_out
   end # kibuvits_progfte_s_concat_array_of_strings(ar_in)

   public

   def Kibuvits_ProgFTE_v1.kibuvits_progfte_s_concat_array_of_strings(ar_in)
      s_out=Kibuvits_ProgFTE_v1.instance.kibuvits_progfte_s_concat_array_of_strings(ar_in)
      return s_out
   end # kibuvits_progfte_s_concat_array_of_strings(ar_in)

   private

   # That includes all points, minus signs, etc.
   def i_number_of_characters(x_in)
      i_out=x_in.to_s.length
      return i_out
   end # i_number_of_characters

   # That's the <stringrecord> part in the ProgFTE_v1 spec,
   # http://martin.softf1.com/g/n//a2/doc/progfte/index.html
   def append_stringrecord(ar_s,s_in)
      ar_s<<s_in.length.to_s
      ar_s<<@lc_s_pillar
      ar_s<<s_in
      ar_s<<@lc_s_pillar
   end # append_stringrecord

   def append_header_format_mode_0(ar_s,ht_in)
      # The very first key-value pair always exists and
      # it is reserved for the metadata.
      s_n_of_pairs=(ht_in.size+1).to_s
      #-----------------------------------------
      # v1|0|<number_of_key-value_pairs>|0||0||
      #-----------------------------------------
      ar_s<<@lc_s_v1__pillar_format_mode_0_pillar
      ar_s<<s_n_of_pairs
      ar_s<<@lc_s_const_1
   end # append_header_format_mode_0

   public

   def from_ht(ht_in)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_in
      end # if
      ar_s=Array.new
      append_header_format_mode_0(ar_s,ht_in)
      ht_in.each do |s_key,s_value|
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            if KIBUVITS_b_DEBUG
               bn=binding()
               kibuvits_typecheck bn, String, s_key
               kibuvits_typecheck bn, String, s_value
            end # if
         end # if
         append_stringrecord(ar_s,s_key)
         append_stringrecord(ar_s,s_value)
      end # loop
      s_progfte=kibuvits_progfte_s_concat_array_of_strings(ar_s)
      ar_s.clear # May be it helps the garbage collector a bit.
      return s_progfte
   end # from_ht

   def Kibuvits_ProgFTE_v1.from_ht(a_hashtable)
      s_progfte=Kibuvits_ProgFTE_v1.instance.from_ht(a_hashtable)
      return s_progfte
   end # Kibuvits_ProgFTE_v1.from_ht

   private

   def i_i_read_intpillar(s_in,ixs_low,rgx_int_pillar)
      md=s_in.match(rgx_int_pillar,ixs_low)
      if md==nil
         msg="\nEither The ProgFTE string candidate does not conform to "+
         "the ProgFTE_v1 specification or the code is faulty. \n"+
         "Reading of a token /[\d]+[|]/ failed.\n"+
         "GUID='54a57c48-65f6-43a3-9308-c0d260301dd7'\n"+
         "ixs_low=="+ixs_low.to_s+
         "\ns_in=="+s_in+"\n"
         kibuvits_progfte_throw(msg)
      end # if
      s_int=(md[0])[0..(-2)]
      ixs_low=ixs_low+s_int.length+1 # +1 is due to the [|]
      i_out=s_int.to_i
      return i_out, ixs_low
   end # i_i_read_intpillar

   def i_s_parse_stringrecord(s_progfte,ixs_low,rgx_int_pillar)
      # <stringrecord>  ::=  <si_string_length>[|].*[|]
      i_len, ixs_low=i_i_read_intpillar(s_progfte,ixs_low,rgx_int_pillar)
      s_out=@lc_s_emptystring
      if 0<i_len
         i_highminusone=ixs_low+i_len-1
         s_out=s_progfte[ixs_low..i_highminusone]
      end # if
      ixs_low=ixs_low+i_len+1 # +1 is due to the [|]
      return ixs_low, s_out
   end # i_s_parse_stringrecord

   def i_parse_keyvalue_pair(ht_in,s_progfte,ixs_low,rgx_int_pillar)
      ixs_1=ixs_low
      ixs_1, s_key=i_s_parse_stringrecord(s_progfte,ixs_1,rgx_int_pillar)
      ixs_1, s_value=i_s_parse_stringrecord(s_progfte,ixs_1,rgx_int_pillar)
      ht_in[s_key]=s_value
      return ixs_1
   end # i_parse_keyvalue_pair

   def ht_parse_header(s_progfte_v1_candidate,ht_opmem)
      rgx_int_pillar=ht_opmem["rgx_int_pillar"]
      s_in=s_progfte_v1_candidate
      # http://martin.softf1.com/g/n//a2/doc/progfte/index.html
      # v<ProgFTE_format_version>[|]<ProgFTE_format_mode>[|]<number_of_key-value_pairs>[|](<key-value_pair>)+
      md=s_in.match(/^v[\d]+[|][\d]+[|][\d]+[|]/)
      if md==nil
         msg="\nThe ProgFTE string candidate does not conform to "+
         "the ProgFTE_v1 specification.\n"+
         "GUID='39ad0c33-dadd-4d0b-a308-c0d260301dd7'\n"+
         "s_progfte_v1_candidate=="+s_progfte_v1_candidate+"\n"
         kibuvits_progfte_throw(msg)
      end # if
      ht_header=Hash.new
      s_header=md[0]
      # v1|<ProgFTE_format_mode>|
      # 012
      ixs_low=3
      i_format_mode, ixs_low=i_i_read_intpillar(s_header,ixs_low,rgx_int_pillar)
      ht_header["i_format_mode"]=i_format_mode
      i_n_of_pairs, ixs_low=i_i_read_intpillar(s_header,ixs_low,rgx_int_pillar)
      ht_header["i_n_of_pairs"]=i_n_of_pairs

      ht=Hash.new
      ixs_low=i_parse_keyvalue_pair(ht,s_in,ixs_low,rgx_int_pillar)
      s_metadata=ht[@lc_s_emptystring]
      if s_metadata==nil
         msg="\nThe ProgFTE string candidate does not conform to "+
         "the ProgFTE_v1 specification.\n"+
         "According to the ProgFTE_v1 specification the "+
         "very first key-value pair is reserved for encoding related\n"+
         "metadata and its key must be an empty string, but "+
         "extraction of the metadata from the very first key-value pair failed.\n"+
         "GUID='319ad316-88d6-4041-a108-c0d260301dd7'\n"+
         "ixs_low=="+ixs_low.to_s+
         "\ns_progfte_v1_candidate=="+s_progfte_v1_candidate+"\n"
         kibuvits_progfte_throw(msg)
      end # if
      ht_header["s_metadata"]=s_metadata
      ht_opmem["ixs_low"]=ixs_low
      ht_opmem["ht_header"]=ht_header
      return ht_header
   end # ht_parse_header

   public
   def to_ht(s_progfte)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_typecheck binding(), String, s_progfte
      end # if
      rgx_int_pillar=/[\d]+[|]/ # widely used, but can not be global due to thread safety
      ht_opmem=Hash.new
      ht_opmem["rgx_int_pillar"]=rgx_int_pillar
      ht_header=ht_parse_header(s_progfte,ht_opmem)
      ixs_low=ht_opmem["ixs_low"]
      ht_out=Hash.new
      begin
         i_n_of_pairs=ht_header["i_n_of_pairs"]-1 # -1 is due to the metadata keyvalue pair
         i_n_of_pairs.times do
            ixs_low=i_parse_keyvalue_pair(ht_out,s_progfte,ixs_low,rgx_int_pillar)
         end # loop
      rescue Exception => e
      end # try-catch
      return ht_out
   end # to_ht

   def Kibuvits_ProgFTE_v1.to_ht(s_progfte)
      ht=Kibuvits_ProgFTE_v1.instance.to_ht(s_progfte)
      return ht
   end # Kibuvits_ProgFTE_v1.to_ht

   public
   include Singleton

end #class Kibuvits_ProgFTE_v1


#--------------------------------------------------------------------------
# The ProgFTE is a text format for serializing hashtables that
# contain only strings and use only strings for keys. The
# ProgFTE stands for Programmer Friendly text Exchange.
#
# Specifications reside at:
# http://martin.softf1.com/g/n//a2/doc/progfte/index.html
#
# This implementation has a full support for ProgFTE_v0 and ProgFTE_v1
class Kibuvits_ProgFTE

   def initialize
   end #initialize

   private
   def kibuvits_progfte_throw(msg)
      Kibuvits_ProgFTE_v1.kibuvits_progfte_throw(msg)
   end # kibuvits_progfte_throw

   public
   def from_ht(ht_in, i_specification_version=1)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_in
         kibuvits_typecheck bn, [Fixnum,Bignum], i_specification_version
         kibuvits_assert_is_among_values(bn,[0,1],i_specification_version)
      end # if
      s_progfte=nil
      if(i_specification_version==1)
         s_progfte=Kibuvits_ProgFTE_v1.from_ht(ht_in)
      else
         if(i_specification_version==0)
            s_progfte=Kibuvits_ProgFTE_v0.from_ht(ht_in)
         else
            msg="\nThis implementation does not yet support the ProgFTE_v"+
            i_specification_version.to_s
            "\n GUID='2ad0f515-a086-415c-ac08-c0d260301dd7'\n"
            kibuvits_progfte_throw(msg)
         end # if
      end # if
      return s_progfte;
   end # from_ht

   def Kibuvits_ProgFTE.from_ht(ht_in, i_specification_version=1)
      s_progfte=Kibuvits_ProgFTE.instance.from_ht(ht_in,i_specification_version)
      return s_progfte;
   end # Kibuvits_ProgFTE.from_ht

   public
   def to_ht(s_in)
      if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_typecheck bn, String, s_in
         kibuvits_assert_string_min_length(bn,s_in,3,
         " GUID='7a4a3a5b-4d96-4498-8108-c0d260301dd7'\n")
      end # if
      ht_out=nil
      begin
         md=s_in.match(/^v[\d]+[|]/)
         if md!=nil
            if md[0]=="v1|"
               ht_out=Kibuvits_ProgFTE_v1.to_ht(s_in)
            else
               if md[0]=="v0|"
                  msg="\nStrings that conform to version 0 of the "+
                  "ProgFTE format specification \n"+
                  "start with a digit, not a character.\n"
                  "GUID='7493af13-4e62-4ac7-a208-c0d260301dd7'\n"+
                  "s_in=="+s_in+"\n"
                  kibuvits_progfte_throw(msg)
               else
                  msg="\nThis implementation does not yet "+
                  "support the ProgFTE_v"+md[0][1..-1]+
                  "\n GUID='d42e9ffb-e2f5-4a10-b208-c0d260301dd7'\n"+
                  "s_in=="+s_in+"\n"
                  kibuvits_progfte_throw(msg)
               end # if
            end # if
         else
            md=s_in.match(/^[\d]+[|]/)
            if md==nil
               msg="\nProgFTE string candidate does not conform to any "+
               "ProgFTE specification, where \nthe format version "+
               "is greater than 0, but the ProgFTE string "+
               "candidate does not \nconform to ProgFTE_v0 either.\n "+
               "GUID='45667529-a679-45fa-a408-c0d260301dd7'\n"+
               "s_in=="+s_in+"\n"
               kibuvits_progfte_throw(msg)
            end # if
            ht_out=Kibuvits_ProgFTE_v0.to_ht(s_in)
         end # if
      rescue Exception => e
         msg="\nProgFTE string candidate deserialization failed. \n"+
         "GUID='ea39d549-c221-498b-a108-c0d260301dd7'\n"+e.to_s+"\n"
         kibuvits_progfte_throw(msg)
      end # try-catch
      return ht_out
   end # to_ht

   def Kibuvits_ProgFTE.to_ht(s_in)
      ht_out=Kibuvits_ProgFTE.instance.to_ht(s_in)
      return ht_out
   end # Kibuvits_ProgFTE.to_ht

   public
   include Singleton

end #class Kibuvits_ProgFTE

#==========================================================================
# Sample code:
#    ht=Hash.new
#    ht['Welcome']='to hell'
#    ht['with XML']='we all go'
#    s_progfte=Kibuvits_ProgFTE.from_ht(ht)
#    ht.clear
#    ht2=Kibuvits_ProgFTE.to_ht(s_progfte)
#    puts ht2['Welcome']
#    puts ht2['with XML']

