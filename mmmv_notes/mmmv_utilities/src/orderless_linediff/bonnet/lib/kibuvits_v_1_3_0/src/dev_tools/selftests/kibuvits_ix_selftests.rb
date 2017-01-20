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
   require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ix.rb"
end # if
#==========================================================================

class Kibuvits_ix_selftests
   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_ix_selftests.test_sar
      if !kibuvits_block_throws{Kibuvits_ix.sar("x"," ",1)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.sar("x",0," ")}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.sar("x",1,0)}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.sar("x",(-1),0)}
         kibuvits_throw "test 4"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.sar("x",0,2)}
         kibuvits_throw "test 5"
      end # if
      x_out=Kibuvits_ix.sar("",0,0)
      kibuvits_throw "test 6" if x_out!=""
      s="abcd"
      x_out=Kibuvits_ix.sar(s,0,0)
      kibuvits_throw "test 7" if x_out!=""
      x_out=Kibuvits_ix.sar(s,4,4)
      kibuvits_throw "test 8" if x_out!=""
      x_out=Kibuvits_ix.sar(s,2,2)
      kibuvits_throw "test 9" if x_out!=""
      x_out=Kibuvits_ix.sar(s,2,2)
      kibuvits_throw "test 10" if x_out!=""
      x_out=Kibuvits_ix.sar(s,2,4)
      kibuvits_throw "test 11" if x_out!="cd"
      if !kibuvits_block_throws{Kibuvits_ix.sar("",0,1)}
         kibuvits_throw "test 12"
      end # if
      ar=["H","e"]
      x_out=Kibuvits_ix.sar(ar,0,0)
      kibuvits_throw "test 13" if x_out.length!=0
      x_out=Kibuvits_ix.sar(ar,0,1)
      kibuvits_throw "test 14" if x_out.length!=1
      kibuvits_throw "test 15" if x_out[0]!="H"
      x_out=Kibuvits_ix.sar(ar,0,2)
      kibuvits_throw "test 16" if x_out.length!=2
      kibuvits_throw "test 17" if x_out[0]!="H"
      kibuvits_throw "test 18" if x_out[1]!="e"
      x_out=Kibuvits_ix.sar(ar,1,1)
      kibuvits_throw "test 19" if x_out.length!=0
      x_out=Kibuvits_ix.sar(ar,1,2)
      kibuvits_throw "test 20" if x_out.length!=1
      kibuvits_throw "test 21" if x_out[0]!="e"
      x_out=Kibuvits_ix.sar(ar,2,2)
      kibuvits_throw "test 22" if x_out.length!=0
      msgcs=Kibuvits_msgc_stack.new
      msgcs.cre "First"
      msgcs.cre "Second"
      msgcs.cre "Third"
      x_out=Kibuvits_ix.sar(msgcs,0,0)
      kibuvits_throw "test 23" if x_out.length!=0
      x_out=Kibuvits_ix.sar(msgcs,0,1)
      kibuvits_throw "test 24" if x_out.length!=1
      kibuvits_throw "test 25" if x_out[0].to_s!="First"
      x_out=Kibuvits_ix.sar(msgcs,1,2)
      kibuvits_throw "test 26" if x_out.length!=1
      kibuvits_throw "test 27" if x_out[0].to_s!="Second"
      x_out=Kibuvits_ix.sar(msgcs,1,3)
      kibuvits_throw "test 28" if x_out.length!=2
      kibuvits_throw "test 29" if x_out[0].to_s!="Second"
      kibuvits_throw "test 30" if x_out[1].to_s!="Third"
      x_out=Kibuvits_ix.sar(msgcs,3,3)
      kibuvits_throw "test 31" if x_out.length!=0
   end # Kibuvits_ix_selftests.test_sar

   #-----------------------------------------------------------------------

   def Kibuvits_ix_selftests.test_bisect_at_sindex_strings
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("x","x")}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("x",(-1))}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("",(-1))}
         kibuvits_throw "test 3"
      end # if
      if kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("",0)}
         kibuvits_throw "test 4"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("",1)}
         kibuvits_throw "test 5"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("x",2)}
         kibuvits_throw "test 6"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("x",-2)}
         kibuvits_throw "test 7"
      end # if
      if kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("x",1)}
         kibuvits_throw "test 8"
      end # if
      s_left,s_right=Kibuvits_ix.bisect_at_sindex("",0)
      kibuvits_throw "test 9" if (s_left!="")||(s_right!="")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex("x",0)
      kibuvits_throw "test 10" if (s_left!="")||(s_right!="x")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex("x",1)
      kibuvits_throw "test 11" if (s_left!="x")||(s_right!="")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex("ab",2)
      kibuvits_throw "test 12" if (s_left!="ab")||(s_right!="")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex("ab",0)
      kibuvits_throw "test 13" if (s_left!="")||(s_right!="ab")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex("ab",1)
      kibuvits_throw "test 14" if (s_left!="a")||(s_right!="b")
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("ab",3)}
         kibuvits_throw "test 15"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex("ab",(-1))}
         kibuvits_throw "test 16"
      end # if
   end # Kibuvits_ix_selftests.test_bisect_at_sindex_strings

   #-----------------------------------------------------------------------

   def Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_impl b_force_element_cloning
      b=b_force_element_cloning
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["x"],"x",b)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["x"],(-1),b)}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex([],(-1),b)}
         kibuvits_throw "test 3"
      end # if
      if kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex([],0,b)}
         kibuvits_throw "test 4"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex([],1,b)}
         kibuvits_throw "test 5"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["x"],2,b)}
         kibuvits_throw "test 6"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["x"],-2,b)}
         kibuvits_throw "test 7"
      end # if
      if kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["x"],1,b)}
         kibuvits_throw "test 8"
      end # if
      s_left,s_right=Kibuvits_ix.bisect_at_sindex([],0,b)
      kibuvits_throw "test 9" if (s_left!=[])||(s_right!=[])
      s_left,s_right=Kibuvits_ix.bisect_at_sindex(["x"],0,b)
      kibuvits_throw "test 10" if (s_left!=[])||(s_right!=["x"])
      s_left,s_right=Kibuvits_ix.bisect_at_sindex(["x"],1,b)
      kibuvits_throw "test 11" if (s_left!=["x"])||(s_right!=[])
      s_left,s_right=Kibuvits_ix.bisect_at_sindex(["a","b"],2,b)
      kibuvits_throw "test 12a" if (s_left.length!=2)||(s_right.length!=0)
      kibuvits_throw "test 12b" if (s_left[0]!="a")
      kibuvits_throw "test 12c" if (s_left[1]!="b")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex(["a","b"],0,b)
      kibuvits_throw "test 13a" if (s_left.length!=0)||(s_right.length!=2)
      kibuvits_throw "test 13b" if (s_right[0]!="a")
      kibuvits_throw "test 13c" if (s_right[1]!="b")
      s_left,s_right=Kibuvits_ix.bisect_at_sindex(["a","b"],1,b)
      kibuvits_throw "test 14a" if (s_left.length!=1)||(s_right.length!=1)
      kibuvits_throw "test 14b" if (s_left[0]!="a")
      kibuvits_throw "test 14c" if (s_right[0]!="b")
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["a","b"],3,b)}
         kibuvits_throw "test 15"
      end # if
      if !kibuvits_block_throws{Kibuvits_ix.bisect_at_sindex(["a","b"],(-1),b)}
         kibuvits_throw "test 16"
      end # if
   end # Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_impl

   def Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_clonefree
      Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_impl b_force_element_cloning=false
   end # Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_clonefree

   def Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_clone
      Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_impl b_force_element_cloning=true
   end # Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_clone

   #-----------------------------------------------------------------------

   def Kibuvits_ix_selftests.test_normalize2array
      x=Kibuvits_ix.normalize2array("hi")
      kibuvits_throw "test 1" if x.length!=1
      x=Kibuvits_ix.normalize2array(nil)
      kibuvits_throw "test 2" if x.length!=1
   end # Kibuvits_ix_selftests.test_normalize2array

   def Kibuvits_ix_selftests.test_normalize2array_tests_2
      ht_values_that_result_an_empty_array=Hash.new
      s_1="ttt"
      ar_x=Kibuvits_ix.normalize2array(s_1,
      ht_values_that_result_an_empty_array)
      i_len=ar_x.length
      kibuvits_throw "test 1 ar_x.length=="+i_len.to_s if i_len!=1

      Kibuvits_ix.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,s_1)
      ar_x=Kibuvits_ix.normalize2array(s_1,
      ht_values_that_result_an_empty_array)
      i_len=ar_x.length
      kibuvits_throw "test 2 ar_x.length=="+i_len.to_s if i_len!=0

      Kibuvits_ix.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,s_1)
      ar_x=Kibuvits_ix.normalize2array([s_1],
      ht_values_that_result_an_empty_array)
      i_len=ar_x.length
      kibuvits_throw "test 3 ar_x.length=="+i_len.to_s if i_len!=1

      Kibuvits_ix.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,s_1)
      ar_x=Kibuvits_ix.normalize2array([],
      ht_values_that_result_an_empty_array)
      i_len=ar_x.length
      kibuvits_throw "test 4 ar_x.length=="+i_len.to_s if i_len!=0
   end # Kibuvits_ix_selftests.test_normalize2array_tests_2

   #-----------------------------------------------------------------------

   def Kibuvits_ix_selftests.test_ht_merge_by_overriding_t1
      ht_1=Hash.new # a
      ht_2=Hash.new # b
      ht_3=Hash.new # c
      #          1 2: d
      #          1 3: e
      #          2 3: f
      #        1 2 3: g

      ht_1["a"]="aaa1"
      #ht_1["b"]="bbb1"
      #ht_1["c"]="ccc1"
      ht_1["d"]="ddd1"
      ht_1["e"]="eee1"
      #ht_1["f"]="fff1"
      ht_1["g"]="ggg1"

      #ht_2["a"]="aaa2"
      ht_2["b"]="bbb2"
      #ht_2["c"]="ccc2"
      ht_2["d"]="ddd2"
      #ht_2["e"]="eee2"
      ht_2["f"]="fff2"
      ht_2["g"]="ggg2"

      #ht_3["a"]="aaa3"
      #ht_3["b"]="bbb3"
      ht_3["c"]="ccc3"
      #ht_3["d"]="ddd3"
      ht_3["e"]="eee3"
      ht_3["f"]="fff3"
      ht_3["g"]="ggg3"

      ar=[ht_1,ht_2,ht_3]
      ht_x=Kibuvits_ix.ht_merge_by_overriding_t1(ar)

      i=ht_x.keys.size
      kibuvits_throw "test 1 ht_x.keys.size=="+i.to_s if i!=7

      s=ht_x["a"].to_s
      kibuvits_throw "test 1 ht_x[\"a\"]=="+s if s!="aaa1"
      s=ht_x["b"].to_s
      kibuvits_throw "test 2 ht_x[\"b\"]=="+s if s!="bbb2"
      s=ht_x["c"].to_s
      kibuvits_throw "test 3 ht_x[\"c\"]=="+s if s!="ccc3"
      s=ht_x["d"].to_s
      kibuvits_throw "test 4 ht_x[\"d\"]=="+s if s!="ddd2"
      s=ht_x["e"].to_s
      kibuvits_throw "test 5 ht_x[\"e\"]=="+s if s!="eee3"
      s=ht_x["f"].to_s
      kibuvits_throw "test 6 ht_x[\"f\"]=="+s if s!="fff3"
      s=ht_x["g"].to_s
      kibuvits_throw "test 7 ht_x[\"g\"]=="+s if s!="ggg3"

   end # Kibuvits_ix_selftests.test_ht_merge_by_overriding_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_ix_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_sar"
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_bisect_at_sindex_strings"
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_clonefree"
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_bisect_at_sindex_arrays_clone"
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_normalize2array"
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_normalize2array_tests_2"
      kibuvits_testeval bn, "Kibuvits_ix_selftests.test_ht_merge_by_overriding_t1"
      return ar_msgs
   end # Kibuvits_ix_selftests.selftest

end # class Kibuvits_ix_selftests

#==========================================================================
#puts Kibuvits_ix_selftests.selftest.to_s

