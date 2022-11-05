#!/opt/ruby/bin/ruby -Ku
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

=end
#==========================================================================
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str_concat_array_of_strings.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_msgc.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_str_concat_array_of_strings.rb"
   require  "kibuvits_io.rb"
end # if
#==========================================================================

class Kibuvits_str_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   public

   def Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings_plain

      ar_x=Array.new  # Tests for an empty array.
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 1 s_x==\""+s_x.to_s+"\"" if s_x!=""
      ar_x=[""] # Tests for an array with one "extreme" element.
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 2 s_x==\""+s_x.to_s+"\"" if s_x!=""
      ar_x=["XXX"] # Tests for an array with one "common" element.
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 3 s_x==\""+s_x.to_s+"\"" if s_x!="XXX"
      ar_x=["Hi ","there!"]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 4 s_x==\""+s_x.to_s+"\"" if s_x!="Hi there!"
      ar_x=["",""]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 5 s_x==\""+s_x.to_s+"\"" if s_x!=""

      # Test for 3 elems and that no spaces are placed between elements.
      ar_x=["3","4","555"]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 6 s_x==\""+s_x.to_s+"\"" if s_x!="34555"

      ar_x=["3","4","5556",""]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 7 s_x==\""+s_x.to_s+"\"" if s_x!="345556"
      ar_x=["3","","888",""]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 8 s_x==\""+s_x.to_s+"\"" if s_x!="3888"

      ar_x=["","3","","9",""]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 9 s_x==\""+s_x.to_s+"\"" if s_x!="39"
      i=ar_x.size
      kibuvits_throw "test 9.1 i=="+i.to_s if i!=5
      s_x=ar_x[0]
      kibuvits_throw "test 9.2 s_x==\""+s_x.to_s+"\"" if s_x!=""
      s_x=ar_x[1]
      kibuvits_throw "test 9.3 s_x==\""+s_x.to_s+"\"" if s_x!="3"
      s_x=ar_x[2]
      kibuvits_throw "test 9.4 s_x==\""+s_x.to_s+"\"" if s_x!=""
      s_x=ar_x[3]
      kibuvits_throw "test 9.5 s_x==\""+s_x.to_s+"\"" if s_x!="9"
      s_x=ar_x[4]
      kibuvits_throw "test 9.6 s_x==\""+s_x.to_s+"\"" if s_x!=""

      ar_x=["","42"]
      s_x=kibuvits_s_concat_array_of_strings_plain(ar_x)
      kibuvits_throw "test 10 s_x==\""+s_x.to_s+"\"" if s_x!="42"

   end # Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings_plain

   def Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings_watershed

      ar_x=Array.new  # Tests for an empty array.
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 1 s_x==\""+s_x.to_s+"\"" if s_x!=""
      ar_x=[""] # Tests for an array with one "extreme" element.
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 2 s_x==\""+s_x.to_s+"\"" if s_x!=""
      ar_x=["XXX"] # Tests for an array with one "common" element.
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 3 s_x==\""+s_x.to_s+"\"" if s_x!="XXX"
      ar_x=["Hi ","there!"]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 4 s_x==\""+s_x.to_s+"\"" if s_x!="Hi there!"
      ar_x=["",""]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 5 s_x==\""+s_x.to_s+"\"" if s_x!=""

      # Test for 3 elems and that no spaces are placed between elements.
      ar_x=["3","4","555"]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 6 s_x==\""+s_x.to_s+"\"" if s_x!="34555"

      ar_x=["3","4","5556",""]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 7 s_x==\""+s_x.to_s+"\"" if s_x!="345556"
      ar_x=["3","","888",""]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 8 s_x==\""+s_x.to_s+"\"" if s_x!="3888"

      ar_x=["","3","","9",""]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 9 s_x==\""+s_x.to_s+"\"" if s_x!="39"
      i=ar_x.size
      kibuvits_throw "test 9.1 i=="+i.to_s if i!=5
      s_x=ar_x[0]
      kibuvits_throw "test 9.2 s_x==\""+s_x.to_s+"\"" if s_x!=""
      s_x=ar_x[1]
      kibuvits_throw "test 9.3 s_x==\""+s_x.to_s+"\"" if s_x!="3"
      s_x=ar_x[2]
      kibuvits_throw "test 9.4 s_x==\""+s_x.to_s+"\"" if s_x!=""
      s_x=ar_x[3]
      kibuvits_throw "test 9.5 s_x==\""+s_x.to_s+"\"" if s_x!="9"
      s_x=ar_x[4]
      kibuvits_throw "test 9.6 s_x==\""+s_x.to_s+"\"" if s_x!=""

      ar_x=["","42"]
      s_x=kibuvits_s_concat_array_of_strings_watershed(ar_x)
      kibuvits_throw "test 10 s_x==\""+s_x.to_s+"\"" if s_x!="42"

   end # Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings_watershed


   def Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings

      ar_x=Array.new  # Tests for an empty array.
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 1 s_x==\""+s_x.to_s+"\"" if s_x!=""
      ar_x=[""] # Tests for an array with one "extreme" element.
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 2 s_x==\""+s_x.to_s+"\"" if s_x!=""
      ar_x=["XXX"] # Tests for an array with one "common" element.
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 3 s_x==\""+s_x.to_s+"\"" if s_x!="XXX"
      ar_x=["Hi ","there!"]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 4 s_x==\""+s_x.to_s+"\"" if s_x!="Hi there!"
      ar_x=["",""]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 5 s_x==\""+s_x.to_s+"\"" if s_x!=""

      # Test for 3 elems and that no spaces are placed between elements.
      ar_x=["3","4","555"]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 6 s_x==\""+s_x.to_s+"\"" if s_x!="34555"

      ar_x=["3","4","5556",""]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 7 s_x==\""+s_x.to_s+"\"" if s_x!="345556"
      ar_x=["3","","888",""]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 8 s_x==\""+s_x.to_s+"\"" if s_x!="3888"

      ar_x=["","3","","9",""]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 9 s_x==\""+s_x.to_s+"\"" if s_x!="39"
      i=ar_x.size
      kibuvits_throw "test 9.1 i=="+i.to_s if i!=5
      s_x=ar_x[0]
      kibuvits_throw "test 9.2 s_x==\""+s_x.to_s+"\"" if s_x!=""
      s_x=ar_x[1]
      kibuvits_throw "test 9.3 s_x==\""+s_x.to_s+"\"" if s_x!="3"
      s_x=ar_x[2]
      kibuvits_throw "test 9.4 s_x==\""+s_x.to_s+"\"" if s_x!=""
      s_x=ar_x[3]
      kibuvits_throw "test 9.5 s_x==\""+s_x.to_s+"\"" if s_x!="9"
      s_x=ar_x[4]
      kibuvits_throw "test 9.6 s_x==\""+s_x.to_s+"\"" if s_x!=""

      ar_x=["","42"]
      s_x=kibuvits_s_concat_array_of_strings(ar_x)
      kibuvits_throw "test 10 s_x==\""+s_x.to_s+"\"" if s_x!="42"

   end # Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_wholenumber_ASCII_2_whonenumber_Unicode
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      -1)
      kibuvits_throw "test 1 msg=="+msg if !b_failure
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      -300)
      kibuvits_throw "test 2 msg=="+msg if !b_failure
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      0x21)
      if (i_uc!=0x21)||b_failure
         kibuvits_throw "test 3 msg=="+msg+" i_uc=="+i_uc.to_s(16)
      end # if
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      0xA0)
      if (i_uc!=0xA0)||b_failure
         kibuvits_throw "test 4 msg=="+msg+" i_uc=="+i_uc.to_s(16)
      end # if
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      0x93)
      if (i_uc!=0x201C)||b_failure
         kibuvits_throw "test 5 msg=="+msg+" i_uc=="+i_uc.to_s(16)
      end # if
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      0xA)
      if (i_uc!=0xA)||b_failure
         kibuvits_throw "test 6 msg=="+msg+" i_uc=="+i_uc.to_s(16)
      end # if
      b_failure,i_uc,msg=Kibuvits_str.wholenumber_ASCII_2_whonenumber_Unicode(
      0xD)
      if (i_uc!=0xD)||b_failure
         kibuvits_throw "test 3 msg=="+msg+" i_uc=="+i_uc.to_s(16)
      end # if
   end # Kibuvits_str_selftests.test_wholenumber_ASCII_2_whonenumber_Unicode

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_verify_noninclusion
      ar=["hei","hoi"]
      b_inclusion_present,msg=Kibuvits_str.verify_noninclusion ar
      kibuvits_throw "vrfy 1 msg=="+msg if b_inclusion_present
      ar=["hei","ei", "yei"]
      b_inclusion_present,msg=Kibuvits_str.verify_noninclusion ar
      kibuvits_throw "vrfy 2 msg=="+msg if !b_inclusion_present
      ar=["he","ei", "ir"]
      b_inclusion_present,msg=Kibuvits_str.verify_noninclusion ar
      kibuvits_throw "vrfy 3 msg=="+msg if !b_inclusion_present
      ar=[]
      b_inclusion_present,msg=Kibuvits_str.verify_noninclusion ar
      kibuvits_throw "vrfy 4 msg=="+msg if b_inclusion_present
      ar=["e","i", "r"]
      b_inclusion_present,msg=Kibuvits_str.verify_noninclusion ar
      kibuvits_throw "vrfy 5 msg=="+msg if b_inclusion_present
      ar=["","i", "r"]
      b_inclusion_present,msg=Kibuvits_str.verify_noninclusion ar
      kibuvits_throw "vrfy 6 msg=="+msg if !b_inclusion_present
   end # Kibuvits_str_selftests.test_verify_noninclusion

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_pick_by_instance
      msgcs=Kibuvits_msgc_stack.new
      ar=Array.new
      ar<<"  startWoWend startHiend "
      ar<<"startWoWend startHiend"
      ar.each do |s_hay|
         msgcs.clear
         s_hay,ht=Kibuvits_str.pick_by_instance("start",
         "end",s_hay,msgcs)
         i1=ht.keys.length
         kibuvits_throw "1 i1=="+i1.to_s if i1<2
         b_WoW_found=false;
         b_Hi_found=false;
         ht.each_pair do |key,value|
            b_WoW_found=true if value=="WoW"
            b_Hi_found=true if value=="Hi"
         end # loop
         kibuvits_throw "2" if !(b_WoW_found&&b_Hi_found)
         kibuvits_throw "3" if msgcs.b_failure
      end # loop
      msgcs.clear
      s_hay,ht=Kibuvits_str.pick_by_instance("start",
      "end",'start start end',msgcs)
      kibuvits_throw "4 msg=="+msgcs.to_s if !msgcs.b_failure
      kibuvits_throw "5 msg=="+msgcs[0].to_s if msgcs[0].to_s!="err_multiple_start"
      msgcs.clear
      s_hay,ht=Kibuvits_str.pick_by_instance("start",
      "end",'start ',msgcs)
      kibuvits_throw "6 msg=="+msgcs.to_s if !msgcs.b_failure
      kibuvits_throw "7 msg=="+msgcs[0].to_s if msgcs[0].to_s!="err_missing_end"
      msgcs.clear
      s_hay,ht=Kibuvits_str.pick_by_instance("start",
      "end",'end ',msgcs)
      kibuvits_throw "8 msg=="+msgcs.to_s if !msgcs.b_failure
      kibuvits_throw "9 msg=="+msgcs[0].to_s if msgcs[0].to_s!="err_missing_start_or_multiple_end"
      msgcs.clear
      s_hay,ht=Kibuvits_str.pick_by_instance("start",
      "end",'',msgcs)
      kibuvits_throw "10 msg=="+msgcs.to_s if msgcs.b_failure
      msgcs.clear
      s_hay,ht=Kibuvits_str.pick_by_instance("start",
      "end",'startend',msgcs)
      s=ht[ht.keys[0]].to_s
      kibuvits_throw "11 msg=="+msgcs.to_s+" s=="+s if s!=""
      i=ht.keys.length
      kibuvits_throw "12 msg=="+msgcs.to_s+" s=="+s+" i=="+i.to_s if i!=1
   end # Kibuvits_str_selftests.test_pick_by_instance

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_sort_by_length
      ar=["xx","xxx","x"]
      Kibuvits_str.sort_by_length ar
      kibuvits_throw "test 1 " if ar.length!=3
      kibuvits_throw "test 2 " if ar[0].length!=3
      kibuvits_throw "test 3 " if ar[1].length!=2
      kibuvits_throw "test 4 " if ar[2].length!=1
      Kibuvits_str.sort_by_length ar, false
      kibuvits_throw "test 5 " if ar.length!=3
      kibuvits_throw "test 6 " if ar[2].length!=3
      kibuvits_throw "test 7 " if ar[1].length!=2
      kibuvits_throw "test 8 " if ar[0].length!=1
      ar=["xx","xxx","x",""]
      Kibuvits_str.sort_by_length ar
      kibuvits_throw "test 9 " if ar.length!=4
      kibuvits_throw "test 10 " if ar[3].length!=0
   end #Kibuvits_str_selftests.test_sort_by_length

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_ribboncut
      ar=Kibuvits_str.ribboncut("YY","xxYYmmmmYY")
      kibuvits_throw "test 1" if ar.length!=3
      kibuvits_throw "test 2 ar=="+ar.to_s if (ar[0]!="xx")||(ar[1]!="mmmm")||(ar[2]!="")
      ar=Kibuvits_str.ribboncut("YY","YYxxYYmmmm")
      kibuvits_throw "test 3" if ar.length!=3
      kibuvits_throw "test 4 ar=="+ar.to_s if (ar[0]!="")||(ar[1]!="xx")||(ar[2]!="mmmm")
      ar=Kibuvits_str.ribboncut("YY","YY")
      kibuvits_throw "test 5" if ar.length!=2
      kibuvits_throw "test 6 ar=="+ar.to_s if (ar[0]!="")||(ar[1]!="")
      ar=Kibuvits_str.ribboncut("YY","xxx")
      kibuvits_throw "test 7" if ar.length!=1
      kibuvits_throw "test 8 ar=="+ar.to_s if (ar[0]!="xxx")
      ar=Kibuvits_str.ribboncut("YY","x") # s_hay.length<s_needle.length
      kibuvits_throw "test 9" if ar.length!=1
      kibuvits_throw "test 10 ar=="+ar.to_s if (ar[0]!="x")
      ar=Kibuvits_str.ribboncut("YY","xx") # s_hay.length==s_needle.length
      kibuvits_throw "test 11" if ar.length!=1
      kibuvits_throw "test 12 ar=="+ar.to_s if (ar[0]!="xx")
      ar=Kibuvits_str.ribboncut("YY","")
      kibuvits_throw "test 13" if ar.length!=1
      kibuvits_throw "test 14 ar=="+ar.to_s if (ar[0]!="")
      ar=Kibuvits_str.ribboncut("YY","xxYYYYmmmm")
      kibuvits_throw "test 15" if ar.length!=3
      kibuvits_throw "test 16 ar=="+ar.to_s if (ar[0]!="xx")||(ar[1]!="")||(ar[2]!="mmmm")
      ar=Kibuvits_str.ribboncut("YY","YYYYYY")
      kibuvits_throw "test 17" if ar.length!=4
      kibuvits_throw "test 18 ar=="+ar.to_s if (ar[0]!="")||(ar[1]!="")||(ar[2]!="")||(ar[3]!="")
      ar=Kibuvits_str.ribboncut("YY","YYYY")
      kibuvits_throw "test 19" if ar.length!=3
      kibuvits_throw "test 20 ar=="+ar.to_s if (ar[0]!="")||(ar[1]!="")||(ar[2]!="")
      ar=Kibuvits_str.ribboncut("YY","YYmmmmYY")
      kibuvits_throw "test 21" if ar.length!=3
      kibuvits_throw "test 22 ar=="+ar.to_s if (ar[0]!="")||(ar[1]!="mmmm")||(ar[2]!="")
      ar=Kibuvits_str.ribboncut("YY","YYxxYYYY")
      kibuvits_throw "test 23" if ar.length!=4
      kibuvits_throw "test 24 ar=="+ar.to_s if (ar[0]!="")||(ar[1]!="xx")||(ar[2]!="")||(ar[3]!="")
   end # Kibuvits_str_selftests.test_ribboncut

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_batchreplace
      ht_needles=Hash.new
      ht_needles["Casanova"]=["cat"]
      ht_needles["catastrophe"]=["nova"]
      s_hay="A cat saw a nova."
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay, false
      kibuvits_throw "test 1" if s!="A Casanova saw a catastrophe."
      ht_needles=Hash.new
      ht_needles["cat"]="Casanova"
      ht_needles["nova"]="catastrophe"
      s_hay="A cat saw a nova."
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay, true
      kibuvits_throw "test 2" if s!="A Casanova saw a catastrophe."
      ht_needles=Hash.new
      ht_needles["x"]="m"
      ht_needles["y"]="m"
      s_hay="xHyHyym"
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay
      kibuvits_throw "test 3" if s!="mHmHmmm"
      ht_needles=Hash.new
      ht_needles["x"]="y"
      ht_needles["y"]="x"
      s_hay="xxyx"
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay
      kibuvits_throw "test 4 s=="+s if s!="yyxy"
      ht_needles=Hash.new
      ht_needles["x"]="f"
      ht_needles["y"]="f"
      s_hay="xxyGx"
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay
      kibuvits_throw "test 5 s=="+s if s!="fffGf"
      ht_needles=Hash.new
      ht_needles["x"]="f"
      ht_needles["y"]="f"
      s_hay=""
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay
      kibuvits_throw "test 6 s=="+s if s!=""
      ht_needles=Hash.new
      ht_needles["x"]="xxx"
      ht_needles["y"]="f"
      s_hay="xyx"
      s=Kibuvits_str.s_batchreplace ht_needles, s_hay
      kibuvits_throw "test 7 s=="+s if s!="xxxfxxx"
   end # Kibuvits_str_selftests.test_batchreplace

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_bisect
      ar=Kibuvits_str.bisect("AhXXhoo",'XX');
      kibuvits_throw "test 0" if ar.length!=2
      kibuvits_throw "test 1" if ar[0]!="Ah"
      kibuvits_throw "test 2" if ar[1]!="hoo"
      s="AhXXhoo"
      ar=Kibuvits_str.bisect(s,'XXX');
      kibuvits_throw "test 3" if ar[0]!=s
      kibuvits_throw "test 4" if ar[1]!=""
      ar=Kibuvits_str.bisect("AhXXhooXX",'XX');
      kibuvits_throw "test 5" if ar[0]!="Ah"
      kibuvits_throw "test 6" if ar[1]!="hooXX"
      ar=Kibuvits_str.bisect("XXhooXX",'XX');
      kibuvits_throw "test 7" if ar[0]!=""
      kibuvits_throw "test 8" if ar[1]!="hooXX"
      ar=Kibuvits_str.bisect("hooXX",'XX');
      kibuvits_throw "test 9" if ar[0]!="hoo"
      kibuvits_throw "test 10" if ar[1]!=""
      ar=Kibuvits_str.bisect("XX",'XX');
      kibuvits_throw "test 11" if ar[0]!=""
      kibuvits_throw "test 12" if ar[1]!=""
      ar=Kibuvits_str.bisect("XXXX",'XX');
      kibuvits_throw "test 13" if ar[0]!=""
      kibuvits_throw "test 14" if ar[1]!="XX"
   end # Kibuvits_str_selftests.test_bisect

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_snatch_n_times
      ar=Kibuvits_str.snatch_n_times("AhXXhooXXBooXXCooXXDoo",'XX',4);
      kibuvits_throw "test 0" if ar.length!=4
      kibuvits_throw "test 1" if ar[0]!="Ah"
      kibuvits_throw "test 2" if ar[1]!="hoo"
      kibuvits_throw "test 3" if ar[2]!="Boo"
      kibuvits_throw "test 4" if ar[3]!="Coo"
      s="AzXXiooXX"
      ar=Kibuvits_str.snatch_n_times(s,'XX',2);
      kibuvits_throw "test 5" if ar.length!=2
      kibuvits_throw "test 6" if ar[0]!="Az"
      kibuvits_throw "test 7" if ar[1]!="ioo"
      if !kibuvits_block_throws{ Kibuvits_str.snatch_n_times(s,'XX',3)}
         kibuvits_throw "test 8"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.snatch_n_times(11,11,1)}
         kibuvits_throw "test 9"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.snatch_n_times(s,11,1)}
         kibuvits_throw "test 10"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.snatch_n_times(44,"XX",1)}
         kibuvits_throw "test 11"
      end # if
      s="XXAzXXiooXX"
      ar=Kibuvits_str.snatch_n_times(s,'XX',2);
      kibuvits_throw "test 12" if ar.length!=2
      kibuvits_throw "test 13" if ar[0]!=""
      kibuvits_throw "test 14" if ar[1]!="Az"
      ar=Kibuvits_str.snatch_n_times("XX",'XX',1);
      kibuvits_throw "test 15" if ar.length!=1
      kibuvits_throw "test 16" if ar[0]!=""
      ar=Kibuvits_str.snatch_n_times("abcXX",'XX',1);
      kibuvits_throw "test 17" if ar.length!=1
      kibuvits_throw "test 18" if ar[0]!="abc"
   end # Kibuvits_str_selftests.test_snatch_n_times

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_count_substrings
      if !kibuvits_block_throws{ Kibuvits_str.count_substrings("xx",3)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.count_substrings(4,"xx")}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.count_substrings("xx","")}
         kibuvits_throw "test 3"
      end # if
      kibuvits_throw "test 4" if Kibuvits_str.count_substrings("aaa","b")!=0
      kibuvits_throw "test 5" if Kibuvits_str.count_substrings("","b")!=0
      kibuvits_throw "test 6" if Kibuvits_str.count_substrings("aabbab","b")!=3
      kibuvits_throw "test 7" if Kibuvits_str.count_substrings("aabbab","bb")!=1
      kibuvits_throw "test 8" if Kibuvits_str.count_substrings("baabba","bb")!=1
      kibuvits_throw "test 9" if Kibuvits_str.count_substrings("aa","aaa")!=0
   end # Kibuvits_str_selftests.test_count_substrings

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_explode
      if !kibuvits_block_throws{ Kibuvits_str.explode("xx",3)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.explode(4,"xx")}
         kibuvits_throw "test 2"
      end # if
      ar=Kibuvits_str.explode("abc","")
      kibuvits_throw "test 3" if ar.length!=3
      kibuvits_throw "test 4" if ar[0]!="a"
      kibuvits_throw "test 5" if ar[1]!="b"
      kibuvits_throw "test 6" if ar[2]!="c"
      ar=Kibuvits_str.explode("abc","b")
      kibuvits_throw "test 7" if ar.length!=2
      kibuvits_throw "test 8" if ar[0]!="a"
      kibuvits_throw "test 9" if ar[1]!="c"
      ar=Kibuvits_str.explode("abc","bb")
      kibuvits_throw "test 10" if ar.length!=1
      kibuvits_throw "test 11" if ar[0]!="abc"
      ar=Kibuvits_str.explode("abc","bbbb")
      kibuvits_throw "test 12" if ar.length!=1
      kibuvits_throw "test 13" if ar[0]!="abc"
      ar=Kibuvits_str.explode("","")
      kibuvits_throw "test 14" if ar.length!=1
      kibuvits_throw "test 15" if ar[0]!=""
      ar=Kibuvits_str.explode("","bb")
      kibuvits_throw "test 16" if ar.length!=1
      kibuvits_throw "test 17" if ar[0]!=""
      ar=Kibuvits_str.explode("bbabbc","bb")
      kibuvits_throw "test 18" if ar.length!=3
      kibuvits_throw "test 19" if ar[0]!=""
      kibuvits_throw "test 20" if ar[1]!="a"
      kibuvits_throw "test 21" if ar[2]!="c"
      ar=Kibuvits_str.explode("axx","xx")
      kibuvits_throw "test 22" if ar.length!=2
      kibuvits_throw "test 23" if ar[0]!="a"
      kibuvits_throw "test 24" if ar[1]!=""
   end # Kibuvits_str_selftests.test_explode

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_trim
      if !kibuvits_block_throws{ Kibuvits_str.trim(42)}
         kibuvits_throw "test 1"
      end # if
      kibuvits_throw "test 2" if Kibuvits_str.trim(" 	 x 	")!="x"
      kibuvits_throw "test 3" if Kibuvits_str.trim("\n\r x\n\r\r	 ")!="x"
      kibuvits_throw "test 4" if Kibuvits_str.trim("  ")!=""
      kibuvits_throw "test 5" if Kibuvits_str.trim("")!=""

      s=Kibuvits_str.trim("  Hi  there!   ")
      kibuvits_throw "test 6" if s!="Hi  there!"
      s=Kibuvits_str.trim(" Space at the left")
      kibuvits_throw "test 7" if s!="Space at the left"
      s=Kibuvits_str.trim("Space at the right ")
      kibuvits_throw "test 8" if s!="Space at the right"

      s=Kibuvits_str.trim("1984")
      kibuvits_throw "test 9" if s!="1984"
      s=Kibuvits_str.trim("24 7")
      kibuvits_throw "test 10" if s!="24 7"
   end # Kibuvits_str_selftests.test_trim

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_get_array_of_linebreaks
      ar=Kibuvits_str.get_array_of_linebreaks
      kibuvits_throw "test 1" if ar.length!=3
      if kibuvits_block_throws{ar<<"fun factor"}
         kibuvits_throw "test 2"
      end # if
      ar=Kibuvits_str.get_array_of_linebreaks true
      if !kibuvits_block_throws{ar<<"fun factor"}
         kibuvits_throw "test 3"
      end # if
   end # Kibuvits_str_selftests.test_get_array_of_linebreaks

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_character_is_escapable
      if !kibuvits_block_throws{ Kibuvits_str.character_is_escapable(42)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{ Kibuvits_str.character_is_escapable("XX")}
         kibuvits_throw "test 2"
      end # if
      kibuvits_throw "test 3" if !Kibuvits_str.character_is_escapable "\""
      kibuvits_throw "test 4" if !Kibuvits_str.character_is_escapable "'"
      kibuvits_throw "test 5" if !Kibuvits_str.character_is_escapable "\n"
      kibuvits_throw "test 6" if !Kibuvits_str.character_is_escapable "\r"
      kibuvits_throw "test 7" if !Kibuvits_str.character_is_escapable "\t"
      kibuvits_throw "test 8" if Kibuvits_str.character_is_escapable "t"
      if !kibuvits_block_throws{ Kibuvits_str.character_is_escapable("")}
         kibuvits_throw "test 9"
      end # if
      kibuvits_throw "test 10" if Kibuvits_str.character_is_escapable "4"
      if !kibuvits_block_throws{ Kibuvits_str.character_is_escapable("x",4)}
         kibuvits_throw "test 11"
      end # if
      kibuvits_throw "test 12" if !Kibuvits_str.character_is_escapable "'","\"\n"
      kibuvits_throw "test 13" if Kibuvits_str.character_is_escapable "'","'"
      kibuvits_throw "test 14" if !Kibuvits_str.character_is_escapable "\\"
   end # Kibuvits_str_selftests.test_character_is_escapable

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_index_is_outside_of_the_string
      kibuvits_throw "test 1" if !Kibuvits_str.index_is_outside_of_the_string "",0
      kibuvits_throw "test 2" if !Kibuvits_str.index_is_outside_of_the_string "",1
      kibuvits_throw "test 3" if !Kibuvits_str.index_is_outside_of_the_string "",(-1)
      s="xxx"
      kibuvits_throw "test 4" if Kibuvits_str.index_is_outside_of_the_string s,0
      kibuvits_throw "test 5" if Kibuvits_str.index_is_outside_of_the_string s,1
      kibuvits_throw "test 6" if Kibuvits_str.index_is_outside_of_the_string s,2
      kibuvits_throw "test 7" if !Kibuvits_str.index_is_outside_of_the_string s,(-1)
      kibuvits_throw "test 8" if !Kibuvits_str.index_is_outside_of_the_string s,3
      kibuvits_throw "test 9" if !Kibuvits_str.index_is_outside_of_the_string s,99
      kibuvits_throw "test 10" if !Kibuvits_str.index_is_outside_of_the_string s,(-10)
   end # Kibuvits_str_selftests.test_index_is_outside_of_the_string

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_count_character_repetition
      s="aXXaXXX"
      #  0123456
      kibuvits_throw "test 1 " if Kibuvits_str.count_character_repetition(s,0)!=1
      kibuvits_throw "test 2 " if Kibuvits_str.count_character_repetition(s,1)!=2
      kibuvits_throw "test 3 " if Kibuvits_str.count_character_repetition(s,2)!=1
      kibuvits_throw "test 4 " if Kibuvits_str.count_character_repetition(s,3)!=1
      kibuvits_throw "test 5 " if Kibuvits_str.count_character_repetition(s,4)!=3
      kibuvits_throw "test 6 " if Kibuvits_str.count_character_repetition(s,5)!=2
      kibuvits_throw "test 7 " if Kibuvits_str.count_character_repetition(s,6)!=1
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition(s,7)}
         kibuvits_throw "test 8"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition(s,(-1))}
         kibuvits_throw "test 9"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition("",0)}
         kibuvits_throw "test 10"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition("",(-1))}
         kibuvits_throw "test 11"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition("",(-9))}
         kibuvits_throw "test 12"
      end # if
      s="I\n\nI\n\rI\r\rIII\r\nI\n"
      #  0_1_23_4_56_7_8901_2_34_5
      kibuvits_throw "test 13 " if Kibuvits_str.count_character_repetition(s,0)!=1
      kibuvits_throw "test 14 " if Kibuvits_str.count_character_repetition(s,1)!=2
      kibuvits_throw "test 15 " if Kibuvits_str.count_character_repetition(s,2)!=1
      kibuvits_throw "test 16 " if Kibuvits_str.count_character_repetition(s,3)!=1
      kibuvits_throw "test 17 " if Kibuvits_str.count_character_repetition(s,4)!=1
      kibuvits_throw "test 18 " if Kibuvits_str.count_character_repetition(s,5)!=1
      kibuvits_throw "test 19 " if Kibuvits_str.count_character_repetition(s,6)!=1
      kibuvits_throw "test 20 " if Kibuvits_str.count_character_repetition(s,7)!=2
      kibuvits_throw "test 21 " if Kibuvits_str.count_character_repetition(s,8)!=1
      kibuvits_throw "test 22 " if Kibuvits_str.count_character_repetition(s,9)!=3
      kibuvits_throw "test 23 " if Kibuvits_str.count_character_repetition(s,10)!=2
      kibuvits_throw "test 24 " if Kibuvits_str.count_character_repetition(s,11)!=1
      kibuvits_throw "test 25 " if Kibuvits_str.count_character_repetition(s,12)!=1
      kibuvits_throw "test 26 " if Kibuvits_str.count_character_repetition(s,13)!=1
      kibuvits_throw "test 27 " if Kibuvits_str.count_character_repetition(s,14)!=1
      kibuvits_throw "test 28 " if Kibuvits_str.count_character_repetition(s,15)!=1
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition(42,0)}
         kibuvits_throw "test 29"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition(s,"")}
         kibuvits_throw "test 30"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition(s,(-1))}
         kibuvits_throw "test 31"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.count_character_repetition(s,16)}
         kibuvits_throw "test 31"
      end # if
   end # Kibuvits_str_selftests.test_count_character_repetition

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_character_is_escaped
      kibuvits_throw "test 1 " if Kibuvits_str.character_is_escaped("n\\f",0)
      kibuvits_throw "test 2 " if Kibuvits_str.character_is_escaped("n\\f",1)
      kibuvits_throw "test 3 " if !Kibuvits_str.character_is_escaped("n\\f",2)
      kibuvits_throw "test 4 " if !Kibuvits_str.character_is_escaped("n\\\\f",2)
      kibuvits_throw "test 5 " if Kibuvits_str.character_is_escaped("n\\\\f",3)
      kibuvits_throw "test 6 " if !Kibuvits_str.character_is_escaped("n\\\\\\f",4)
      #                                                      0_1_2_34
      if !kibuvits_block_throws{Kibuvits_str.character_is_escaped(4,42)}
         kibuvits_throw "test 7"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.character_is_escaped("x","xx")}
         kibuvits_throw "test 8"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.character_is_escaped("x",1)}
         kibuvits_throw "test 9"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.character_is_escaped("x",(-1))}
         kibuvits_throw "test 10"
      end # if
      kibuvits_throw "test 11 " if Kibuvits_str.character_is_escaped("\\",0)
   end # Kibuvits_str_selftests.test_character_is_escaped

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_clip_tail_by_str
      if !kibuvits_block_throws{Kibuvits_str.clip_tail_by_str("x",42)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.clip_tail_by_str(42,"x")}
         kibuvits_throw "test 2"
      end # if
      s_hay="lizard tail"
      s_needle="tail"
      s_cl="lizard "
      kibuvits_throw "test 3" if s_cl!=Kibuvits_str.clip_tail_by_str(s_hay,s_needle)
      kibuvits_throw "test 4" if ""!=Kibuvits_str.clip_tail_by_str("",s_needle)
      kibuvits_throw "test 5" if s_hay!=Kibuvits_str.clip_tail_by_str(s_hay,"")
      kibuvits_throw "test 6" if s_hay!=Kibuvits_str.clip_tail_by_str(s_hay,"L")
      kibuvits_throw "test 7" if s_hay!=Kibuvits_str.clip_tail_by_str(s_hay,"\n")
      kibuvits_throw "test 8" if s_hay!=Kibuvits_str.clip_tail_by_str(s_hay,s_hay+"X")
      s_hay="a\nb\nc\n"
      s_cl="a\nb\nc"
      kibuvits_throw "test 9" if s_cl!=Kibuvits_str.clip_tail_by_str(s_hay,"\n")
      kibuvits_throw "test 10" if s_hay!=Kibuvits_str.clip_tail_by_str(s_hay,"\n\n")
      kibuvits_throw "test 11" if ""!=Kibuvits_str.clip_tail_by_str("","")
      kibuvits_throw "test 12" if ""!=Kibuvits_str.clip_tail_by_str(s_hay,s_hay)
      kibuvits_throw "test 13" if ""!=Kibuvits_str.clip_tail_by_str(s_needle,s_needle)
   end # Kibuvits_str_selftests.test_clip_tail_by_str

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_array2xseparated_list
      if !kibuvits_block_throws{Kibuvits_str.array2xseparated_list(42)}
         kibuvits_throw "test 1"
      end # if
      if kibuvits_block_throws{Kibuvits_str.array2xseparated_list(["x"])}
         kibuvits_throw "test 2"
      end # if
      kibuvits_throw "test 3" if Kibuvits_str.array2xseparated_list([1,2,3])!="1, 2, 3"
      kibuvits_throw "test 4" if Kibuvits_str.array2xseparated_list([])!=""
      kibuvits_throw "test 5" if Kibuvits_str.array2xseparated_list(["xxx"])!="xxx"
   end # Kibuvits_str_selftests.test_array2xseparated_list

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_ht2str
      if !kibuvits_block_throws{Kibuvits_str.ht2str(42)}
         kibuvits_throw "test 1"
      end # if
      ht=Hash.new
      ht['a']=["a1","a2"]
      s_expected="a=[a1, a2]"
      s=Kibuvits_str.ht2str(ht)
      kibuvits_throw "test 2" if s_expected!=s
      ht['b']=["b1","b2"]
      s_expected=s_expected+"\nb=[b1, b2]"
      s=Kibuvits_str.ht2str(ht)
      kibuvits_throw "test 3" if s_expected!=s
      ht['c']=[]
      s_expected=s_expected+"\nc=[]"
      s=Kibuvits_str.ht2str(ht)
      kibuvits_throw "test 4" if s_expected!=s
      ht['d']=nil
      s_expected=s_expected+"\nd=nil"
      s=Kibuvits_str.ht2str(ht)
      kibuvits_throw "test 5" if s_expected!=s

      ht=Hash.new
      ht['a']=["a1","a2"]
      ht2=Hash.new
      ht2['ht2A']=4
      ht2['ht2B']=["ht2B1","ht2B2"]
      ht2['aa']=42
      ht['ht2']=ht2
      ht['b']=3.4
      # The hashtable actually doesn't guarantee any order, so
      # the s_expected has been assembled a bit dirtily.
      # The alternative would be to start sorting the keys,
      # but that might get really complicated, if the keys are of
      # different type.
      s_expected=""+
      "  a=[a1, a2]\n"+
      "  b=3.4\n"+
      "ht2=Hash\n"+
      "        aa=42\n"+
      "      ht2A=4\n"+
      "      ht2B=[ht2B1, ht2B2]"
      s=Kibuvits_str.ht2str(ht)
      # TODO: figure something out about this test
      #kibuvits_throw "test 6" if s_expected!=s
   end # Kibuvits_str_selftests.test_ht2str

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_surround_lines
      if !kibuvits_block_throws{Kibuvits_str.surround_lines(42,"m","r",true)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.surround_lines("l",42,"r",true)}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.surround_lines("l","m",42,true)}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.surround_lines("l","m","r",42)}
         kibuvits_throw "test 4"
      end # if
      s=Kibuvits_str.surround_lines("(","xx\nyy\nzz\n\nff",")",false)
      kibuvits_throw "test 5" if s!="(xx)\n(yy)\n(zz)\n()\n(ff)"

   end #Kibuvits_str_selftests.test_surround_lines

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_filter_array
      ar_in=["xx1","xx2","yy1","yy2",333,334]
      if kibuvits_block_throws{Kibuvits_str.filter_array("2",ar_in,true)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.filter_array(42,ar_in,true)}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.filter_array("2",42,true)}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.filter_array("2",ar_in,42)}
         kibuvits_throw "test 4"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.filter_array("2",ar_in,true,42)}
         kibuvits_throw "test 5"
      end # if
      ar=Kibuvits_str.filter_array("[2]",ar_in,true)
      kibuvits_throw "test 6.0 " if ar.length!=2
      s=ar[0].to_s+ar[1].to_s
      kibuvits_throw "test 6 " if s!="xx2yy2"
      ar=Kibuvits_str.filter_array("[2]",ar_in,false)
      kibuvits_throw "test 7.0 " if ar.length!=4
      s=""; ar.length.times{|i| s=s+ar[i].to_s}
      kibuvits_throw "test 7 " if s!="xx1yy1333334"
      ht=Kibuvits_str.filter_array("[2]",ar_in,true,true)
      kibuvits_throw "test 8 " if (!ht.has_key?("xx2"))||(!ht.has_key?("yy2"))
      kibuvits_throw "test 9 " if (ht.has_key?("xx1"))||(ht.has_key?("yy1"))
      kibuvits_throw "test 10 " if (ht.has_key?(333))||(ht.has_key?(334))
   end # Kibuvits_str_selftests.test_filter_array

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_verify_s_is_within_domain
      msgcs=Kibuvits_msgc_stack.new
      s_test="aa"
      ar_domain=["aa","bb"]
      s_action="note_in_msgcs"
      s_lang="English"
      if kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,s_action,s_lang)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(42,ar_domain,msgcs,s_action,s_lang)}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,42,msgcs,s_action,s_lang)}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,42,s_action,s_lang)}
         kibuvits_throw "test 4"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,42,s_lang)}
         kibuvits_throw "test 5"
      end # if
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,s_action,42)}
         kibuvits_throw "test 6"
      end # if
      msgcs.clear
      s_action="This action does not exist"
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,s_action,s_lang)}
         kibuvits_throw "test 7"
      end # if
      msgcs.clear
      s_test="aa"
      ar_domain=["aa","bb"]
      s_action="note_in_msgcs"
      Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,s_action,s_lang)
      kibuvits_throw "test 8 " if msgcs.length!=0

      msgcs.clear
      s_test="aa"
      ar_domain=["bb"]
      s_action="note_in_msgcs"
      Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,s_action,s_lang)
      kibuvits_throw "test 9 " if msgcs.length!=1

      msgcs.clear
      s_test="aa"
      ar_domain=["bb"]
      s_action="throw"
      if !kibuvits_block_throws{Kibuvits_str.verify_s_is_within_domain(s_test,ar_domain,msgcs,s_action,s_lang)}
         kibuvits_throw "test 10"
      end # if
   end # Kibuvits_str_selftests.test_verify_s_is_within_domain

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_str2strliteral
      s=Kibuvits_str.str2strliteral("hi\\there")
      kibuvits_throw "test 1" if s!="\"hi\\\\there\""
      s=Kibuvits_str.str2strliteral("hi\nthere")
      kibuvits_throw "test 2" if s!="\"hi\"+\n\"there\""
   end # Kibuvits_str_selftests.test_str2strliteral

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_str_contains_spacestabslinebreaks
      if !kibuvits_block_throws{Kibuvits_str.str_contains_spacestabslinebreaks(42)}
         kibuvits_throw "test 1"
      end # if
      b=Kibuvits_str.str_contains_spacestabslinebreaks(" some spaces ")
      kibuvits_throw "test 2" if !b
      b=Kibuvits_str.str_contains_spacestabslinebreaks("NoSpacesTabsLinebreaks")
      kibuvits_throw "test 3" if b
      b=Kibuvits_str.str_contains_spacestabslinebreaks("A	Tab")
      kibuvits_throw "test 4" if !b
      b=Kibuvits_str.str_contains_spacestabslinebreaks("A\nlinebreak")
      kibuvits_throw "test 5" if !b
   end # Kibuvits_str_selftests.test_str_contains_spacestabslinebreaks

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_datestring_for_fs_prefix
      if !kibuvits_block_throws{Kibuvits_str.datestring_for_fs_prefix(42)}
         kibuvits_throw "test 1"
      end # if
      dt=Time.mktime(2000,1,21)
      s=Kibuvits_str.datestring_for_fs_prefix(dt)
      kibuvits_throw "test 2 "+s if s!="2000_01_21"
   end # Kibuvits_str_selftests.test_datestring_for_fs_prefix

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_commaseparated_list_2_ht
      s='aa,bb, cc'
      ht=Kibuvits_str.commaseparated_list_2_ht(s)
      kibuvits_throw "test 1" if !ht.has_key? "aa"
      kibuvits_throw "test 2" if !ht.has_key? "bb"
      kibuvits_throw "test 3" if !ht.has_key? "cc"
      kibuvits_throw "test 4" if ht.keys.size!=3

      s=' '
      ht=Kibuvits_str.commaseparated_list_2_ht(s)
      kibuvits_throw "test 5" if ht.keys.size!=0

      s='aa  bb'
      ht=Kibuvits_str.commaseparated_list_2_ht(s)
      kibuvits_throw "test 6" if ht.keys.size!=1
      kibuvits_throw "test 7" if ht.keys[0]!="aa  bb"
   end # Kibuvits_str_selftests.test_commaseparated_list_2_ht

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_s_i2unicode
      if !kibuvits_block_throws{Kibuvits_str.s_i2unicode("42")}
         kibuvits_throw "test 1"
      end # if
      s=Kibuvits_str.s_i2unicode(98)
      kibuvits_throw "test 2 "+s if s!="b"
      s=Kibuvits_str.s_i2unicode(8364)
      kibuvits_throw "test 3 "+s if s!="€"
   end # Kibuvits_str_selftests.test_s_i2unicode

   #-----------------------------------------------------------------------

   def Kibuvits_str_selftests.test_s_get_substring_by_bounds
      msgcs=Kibuvits_msgc_stack.new
      s_start="START"
      s_end="END"

      s_in="Welcome toSTART hellEND"
      s_expected=" hell"
      s_x=Kibuvits_str.s_get_substring_by_bounds(s_in,s_start,s_end,msgcs)
      kibuvits_throw "test 1 " if msgcs.b_failure
      kibuvits_throw "test 2 s_x=="+s_x.to_s if s_x!=s_expected

      s_in="Welcome \ntoSTART hell\n and END heaven,\n as we see it."
      s_expected=" hell\n and "
      s_x=Kibuvits_str.s_get_substring_by_bounds(s_in,s_start,s_end,msgcs)
      kibuvits_throw "test 2 " if msgcs.b_failure
      kibuvits_throw "test 3 s_x=="+s_x.to_s if s_x!=s_expected

   end # Kibuvits_str_selftests.test_s_get_substring_by_bounds

   #-----------------------------------------------------------------------

   public
   include Singleton
   def Kibuvits_str_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      # POOLELI: uus msgc formaat pole k8ikjal veel yle v8etud
      #          K8ik siin v2lja kommenteeritud testid viitavad poolikutele kohtadele.
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings_plain"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings_watershed"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_kibuvits_s_concat_array_of_strings"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_wholenumber_ASCII_2_whonenumber_Unicode"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_verify_noninclusion"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_pick_by_instance"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_sort_by_length"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_ribboncut"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_batchreplace"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_bisect"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_snatch_n_times"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_count_substrings"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_explode"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_trim"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_get_array_of_linebreaks"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_character_is_escapable"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_index_is_outside_of_the_string"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_count_character_repetition"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_character_is_escaped"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_clip_tail_by_str"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_array2xseparated_list"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_ht2str"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_surround_lines"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_filter_array"
      #kibuvits_testeval bn, "Kibuvits_str_selftests.test_verify_s_is_within_domain"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_str2strliteral"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_str_contains_spacestabslinebreaks"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_datestring_for_fs_prefix"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_commaseparated_list_2_ht"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_s_i2unicode"
      kibuvits_testeval bn, "Kibuvits_str_selftests.test_s_get_substring_by_bounds"
      return ar_msgs
   end # Kibuvits_str_selftests.selftest

end # class Kibuvits_str_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_str_selftests.selftest.to_s

