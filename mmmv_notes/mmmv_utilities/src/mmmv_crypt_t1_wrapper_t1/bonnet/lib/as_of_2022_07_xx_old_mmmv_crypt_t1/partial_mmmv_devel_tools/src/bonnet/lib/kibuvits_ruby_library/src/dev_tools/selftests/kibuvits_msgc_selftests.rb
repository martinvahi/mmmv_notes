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

require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"

#==========================================================================

class Kibuvits_msgc_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_msgc_selftests.test_msgc_clone
      msgc=Kibuvits_msgc.new "Hi","UFO_42"
      msgc[$kibuvits_lc_Estonian]="Tere"
      msgc_clone=msgc.clone
      kibuvits_throw "test 3" if msgc_clone.to_s!="Hi"
      kibuvits_throw "test 4" if msgc_clone[$kibuvits_lc_Estonian]!="Tere"
   end # Kibuvits_msgc_selftests.test_msgc_clone

   def Kibuvits_msgc_selftests.test_msgc_set_1
      msgc=Kibuvits_msgc.new "Hi","4"
      kibuvits_throw "test 1" if msgc.to_s!="Hi"
      kibuvits_throw "test 2" if msgc.to_s("UFO")!="Hi"
      msgc1=Kibuvits_msgc.new "Blurrrp","7",false,"Alien"
      kibuvits_throw "test 4" if msgc.s_message_id!="4"
      kibuvits_throw "test 5" if msgc1.to_s!="Blurrrp"
      kibuvits_throw "test 6" if msgc1.to_s("Alien")!="Blurrrp"
      kibuvits_throw "test 7" if msgc1["Alien"]!="Blurrrp"
      kibuvits_throw "test 8" if msgc1["MissingLang"]!="Blurrrp"
      kibuvits_throw "test 9" if msgc1.s_message_id!="7"
      if kibuvits_block_throws{ msgc1['Alien']="New msg"}
         kibuvits_throw "test 10"
      end # if
      if kibuvits_block_throws{ msgc1['Marsian']="QuirrQuirr"}
         kibuvits_throw "test 11"
      end # if
      kibuvits_throw "test 12" if msgc1["Marsian"]!="QuirrQuirr"
      msgc=Kibuvits_msgc.new
      kibuvits_throw "test 13" if msgc.to_s!=""
      kibuvits_throw "test 14" if msgc.s_message_id!="message code not set"
      kibuvits_throw "test 14.1" if msgc.b_failure!=true
      if kibuvits_block_throws{ msgc.s_message_id="9977"}
         kibuvits_throw "test 15"
      end # if
      kibuvits_throw "test 16" if msgc.s_message_id!="9977"

      msgc=Kibuvits_msgc.new "Hi","44",false,"MoonLang"
      kibuvits_throw "test 17" if msgc.b_failure
      if kibuvits_block_throws{ msgc["MoonLang"]="Welcome to the moon!"}
         kibuvits_throw "test 18"
      end # if
      kibuvits_throw "test 19" if msgc["MoonLang"]!="Welcome to the moon!"
      msgc[$kibuvits_lc_English]="Good morning!"
      kibuvits_throw "test 20" if msgc.to_s!="Welcome to the moon!"
   end # Kibuvits_msgc_selftests.test_msgc_set_1

   #-----------------------------------------------------------------------

   def Kibuvits_msgc_selftests.test_msgc_assert_lack_of_failures
      s_default_msg="Test 1A"
      s_message_id="Test 1A ID"
      b_failure=false
      msgc_1=Kibuvits_msgc.new(s_default_msg,s_message_id,b_failure)
      kibuvits_throw "test 1a " if msgc_1.b_failure
      begin
         msgc_1.assert_lack_of_failures
      rescue Exception => e
         kibuvits_throw "test 1a e.to_s=="+e.to_s
      end # rescue
      #---------------
      b_failure=true
      msgc_2=Kibuvits_msgc.new(s_default_msg,s_message_id,b_failure)
      # The next test uses msgc_1 in stead of msgc_2 to
      # test for lack of crosstalk.
      kibuvits_throw "test 2a " if msgc_1.b_failure
      kibuvits_throw "test 2b " if !msgc_2.b_failure
      b_thrown=false
      begin
         msgc_2.assert_lack_of_failures
      rescue Exception => e
         b_thrown=true
      end # rescue
      kibuvits_throw "test 2c " if !b_thrown
   end # Kibuvits_msgc_selftests.test_msgc_assert_lack_of_failures

   #-----------------------------------------------------------------------

   def Kibuvits_msgc_selftests.test_eachfunc
      msgcs=Kibuvits_msgc_stack.new
      msgcs.cre "AA"
      msgcs.cre "BB"
      msgcs.cre "CC"
      ar=Array.new
      msgcs.each do |msgc|
         ar<<msgc.to_s
      end # loop
      kibuvits_throw "test 1" if ar.length!=3
      # The "each" is not meant to guarantee specific order,
      # but while it does, one can get away with the following 3 lines.
      kibuvits_throw "test 2" if ar[0]!="AA"
      kibuvits_throw "test 3" if ar[1]!="BB"
      kibuvits_throw "test 4" if ar[2]!="CC"
   end # Kibuvits_msgc_selftests.test_eachfunc

   def Kibuvits_msgc_selftests.test_msgcs_set_1
      msgc=Kibuvits_msgc.new "Hi","code4",false
      msgcs=Kibuvits_msgc_stack.new
      kibuvits_throw "test 1" if msgcs.length!=0
      kibuvits_throw "test 2" if msgcs.b_failure!=false
      if !kibuvits_block_throws{ msgcs<<42}
         kibuvits_throw "test 3"
      end # if
      msgcs<< msgc
      kibuvits_throw "test 4" if msgcs.length!=1
      kibuvits_throw "test 5" if msgcs.b_failure!=false
      msgc.b_failure=true
      msgc2=Kibuvits_msgc.new "Bo","code42",false
      msgcs<< msgc2
      kibuvits_throw "test 6" if msgcs.length!=2
      kibuvits_throw "test 7" if msgcs.b_failure!=true
      msgc.b_failure=false
      kibuvits_throw "test 8" if msgcs.b_failure!=false
      msgc2.b_failure=true
      kibuvits_throw "test 9" if msgcs.b_failure!=true
      if !kibuvits_block_throws{ msgcs<<msgc2} # tests for multiple insertion
         kibuvits_throw "test 10"
      end # if
      msgcs.clear
      kibuvits_throw "test 11" if msgcs.b_failure!=false
      kibuvits_throw "test 12" if msgcs.length!=0
      msgc2.b_failure=false
      if kibuvits_block_throws{ msgcs<<msgc2} # re-insertion after cleanup
         kibuvits_throw "test 13"
      end # if
      x=msgcs[0]
      kibuvits_throw "test 14" if msgcs.b_failure!=false
      x.b_failure=true
      kibuvits_throw "test 15" if msgcs.b_failure!=true
      x.b_failure=false
      kibuvits_throw "test 16" if msgcs.b_failure!=false
      msgcs2=Kibuvits_msgc_stack.new
      msgcs=Kibuvits_msgc_stack.new
      msgcs.cre "Greeting", "code_42",false
      kibuvits_throw "test 18" if msgcs.b_failure!=false
      msgcs.cre "Greetings from Borg!", "code_1984",false
      kibuvits_throw "test 19" if msgcs.length!=2
      kibuvits_throw "test 20" if msgcs[0].s_instance_id!=msgcs.first.s_instance_id
      kibuvits_throw "test 21" if msgcs[1].s_instance_id!=msgcs.last.s_instance_id
      kibuvits_throw "test 22" if msgcs.first.s_instance_id==msgcs.last.s_instance_id
      msgcs.cre "Greeting2", "code43"
      kibuvits_throw "test 23" if msgcs.b_failure!=true
      #-------------
      if kibuvits_block_throws{ msgcs.push(msgcs2)}
         kibuvits_throw "test 22"
      end # if
   end # Kibuvits_msgc_selftests.test_msgcs_set_1


   def Kibuvits_msgc_selftests.test_stack_within_stack
      msgcs_1=Kibuvits_msgc_stack.new
      msgcs_1.cre "AA_1"
      msgcs_1.cre "BB_1"
      msgcs_1.cre "CC_1"
      msgcs_2=Kibuvits_msgc_stack.new
      msgcs_2.cre "DD_2"
      msgcs_2.cre "EE_2"
      msgcs_2.cre "FF_2"
      msgcs_1<<msgcs_2
      msgcs_1.cre "GG_1"
      kibuvits_throw "test 1a" if !msgcs_1.b_failure
      kibuvits_throw "test 1b" if !msgcs_2.b_failure
      #---------------
      msgcs_3=Kibuvits_msgc_stack.new
      kibuvits_throw "test 2a" if msgcs_3.b_failure
      s_default_msg="T3A"
      s_message_id="T3A_ID"
      b_failure=false
      msgcs_3.cre(s_default_msg,s_message_id,b_failure)
      kibuvits_throw "test 2b" if msgcs_3.b_failure
      begin
         msgcs_3.assert_lack_of_failures
      rescue Exception => e
         kibuvits_throw "test 2c e.to_s=="+e.to_s
      end # rescue
      msgcs_3.cre "T3B"
      kibuvits_throw "test 2d" if !msgcs_3.b_failure
      b_thrown=false
      begin
         msgcs_3.assert_lack_of_failures
      rescue Exception => e
         b_thrown=true
      end # rescue
      kibuvits_throw "test 2e " if !b_thrown
      #---------------
   end # Kibuvits_msgc_selftests.test_stack_within_stack

   def Kibuvits_msgc_selftests.test_serialization_and_to_s
      msgcs_1=Kibuvits_msgc_stack.new
      msgcs_1.cre "AA_1"
      msgcs_1.cre "BB_1"
      msgcs_1.cre "CC_1"
      msgcs_2=Kibuvits_msgc_stack.new
      msgcs_2.cre "DD_2"
      msgcs_2.cre "EE_2"
      msgcs_2.cre "FF_2"
      msgcs_3=Kibuvits_msgc_stack.new
      msgcs_3.cre "GG_3"
      msgcs_2<<msgcs_3
      msgcs_1<<msgcs_2
      msgcs_1.cre "HH_1"

      bn=binding()
      s_1=msgcs_1.to_s
      s_2=msgcs_1.s_serialize
      msgcs_x=Kibuvits_msgc_stack.ob_deserialize(s_2)
      #kibuvits_writeln "--------------------------\n"
      s_3=msgcs_x.to_s
      # The test method might be called more than one,
      # which explains the multiple printouts for
      #kibuvits_writeln s_3
      #kibuvits_writeln "AAA--------------------------\n"
      kibuvits_throw "test 1" if s_1!=s_3
   end # Kibuvits_msgc_selftests.test_serialization_and_to_s

   #-----------------------------------------------------------------------

   public
   def Kibuvits_msgc_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_msgc_clone"
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_msgc_set_1"
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_msgc_assert_lack_of_failures"
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_eachfunc"
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_msgcs_set_1"
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_stack_within_stack"
      kibuvits_testeval bn, "Kibuvits_msgc_selftests.test_serialization_and_to_s"
      return ar_msgs
   end # Kibuvits_msgc_selftests.selftest

end # class Kibuvits_msgc_selftests

#==========================================================================
#Kibuvits_msgc_selftests.test_1
