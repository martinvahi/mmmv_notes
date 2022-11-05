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

require  KIBUVITS_HOME+"/src/include/kibuvits_gstatement.rb"

#==========================================================================

class Kibuvits_gstatement_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_gstatement_selftests.test_1
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A"
      if kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 1"
      end # if
      if KIBUVITS_b_DEBUG
         msgcs.clear
         if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(42,msgcs)}
            kibuvits_throw "test 2"
         end # if
         msgcs.clear
         if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,42)}
            kibuvits_throw "test 3"
         end # if
      end # if
      msgcs.clear
      s_spec="UUU:==A*|B"  # OK, subject to bracket autocompletion.
      if kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 4"
      end # if
      msgcs.clear
      s_spec="UUU:==(A*|B) | C" # | outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 5"
      end # if
      msgcs.clear
      s_spec="UUU:==((A*|B) C)" # the nesting of braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 6"
      end # if
      msgcs.clear
      s_spec="UUU:==(A)? " # ? outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 7"
      end # if
      msgcs.clear
      s_spec="UUU:==(A)* " # * outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 8"
      end # if
      msgcs.clear
      s_spec="UUU:==(A)+ " # + outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 9"
      end # if
   end # Kibuvits_gstatement_selftests.test_1

   #-----------------------------------------------------------------------

   def Kibuvits_gstatement_selftests.test_get_array_of_level1_components
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A"
      gst=Kibuvits_gstatement.new(s_spec,msgcs)
      s_right="A (B+ |C)E F(G)"
      ar=gst.send(:get_array_of_level1_components,s_right)
      kibuvits_throw "test 1" if ar.length!=5
      kibuvits_throw "test 2" if ar[0]!="A"
      kibuvits_throw "test 3" if ar[1]!="B+|C"
      kibuvits_throw "test 4" if ar[2]!="E"
      kibuvits_throw "test 5" if ar[3]!="F"
      kibuvits_throw "test 6" if ar[4]!="G"
   end # Kibuvits_gstatement_selftests.test_get_array_of_level1_components

   #-----------------------------------------------------------------------

   def Kibuvits_gstatement_selftests.test_complete_and_insertable
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A:==BB CC?"
      gst=Kibuvits_gstatement.new(s_spec,msgcs)
      kibuvits_throw "test 1" if gst.complete?
      gst_bb=Kibuvits_gstatement.new("BB",msgcs)
      gst_cc=Kibuvits_gstatement.new("CC",msgcs)
      gst_dd=Kibuvits_gstatement.new("DD",msgcs)
      kibuvits_throw "test 2" if !gst.insertable? gst_bb
      kibuvits_throw "test 3" if !gst.insertable? gst_cc
      kibuvits_throw "test 4" if gst.insertable? gst_dd
      gst.insert gst_bb
      kibuvits_throw "test 5" if gst.insertable? gst_bb
      kibuvits_throw "test 6" if !gst.insertable? gst_cc
      kibuvits_throw "test 7" if !gst.complete?
      gst.insert gst_cc
      kibuvits_throw "test 8" if gst.insertable? gst_cc
      kibuvits_throw "test 9" if !gst.complete?
   end # Kibuvits_gstatement_selftests.test_complete_and_insertable

   #-----------------------------------------------------------------------

   def Kibuvits_gstatement_selftests.test_to_s
      # TODO: There's some sort of a bug at the spec part, where
      # the "A:==(BB? CC DD)" gets translated to "(BB?CC)(DD)"
      # So level2 spec's are already faulty at initialization.
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A:==(BB)(CC?)(DD)"
      gst_a=Kibuvits_gstatement.new(s_spec,msgcs)

      gst_bb=Kibuvits_gstatement.new("BB",msgcs)
      gst_bb.s_suffix="(BB_suffix)"
      gst_cc=Kibuvits_gstatement.new("CC",msgcs)
      gst_cc.s_prefix="(CC_prefix)"
      gst_dd=Kibuvits_gstatement.new("DD",msgcs)
      gst_dd.s_prefix="(DD_prefix)"
      s_spec="EE:==A BB"
      gst_ee=Kibuvits_gstatement.new(s_spec,msgcs)

      gst_a.insert(gst_bb)
      gst_a.insert(gst_dd)
      gst_a.insert(gst_cc)
      s_expected="(BB_suffix)(CC_prefix)(DD_prefix)"
      s=gst_a.to_s
      kibuvits_throw "test 1" if s!=s_expected
   end # Kibuvits_gstatement_selftests.test_to_s

   #-----------------------------------------------------------------------

   public
   def Kibuvits_gstatement_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_gstatement_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_gstatement_selftests.test_get_array_of_level1_components"
      kibuvits_testeval bn, "Kibuvits_gstatement_selftests.test_complete_and_insertable"
      kibuvits_testeval bn, "Kibuvits_gstatement_selftests.test_to_s"
      return ar_msgs
   end # Kibuvits_gstatement_selftests.selftest

end # class Kibuvits_gstatement_selftests

#==========================================================================

