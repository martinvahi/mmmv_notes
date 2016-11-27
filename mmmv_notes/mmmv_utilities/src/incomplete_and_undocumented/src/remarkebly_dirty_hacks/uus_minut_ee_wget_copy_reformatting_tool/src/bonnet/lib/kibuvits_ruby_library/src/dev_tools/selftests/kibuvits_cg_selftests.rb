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

require  KIBUVITS_HOME+"/src/include/code_generation/kibuvits_cg.rb"

#==========================================================================

class Kibuvits_cg_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_cg_selftests.test_assemble_list_by_forms
      s_list_form="A<[CODEGENERATION_BLANK_0]>B"
      s_elem_form="([CODEGENERATION_BLANK_0])"
      s_expected="A<(a)(c)(d)>B"
      s=Kibuvits_cg.assemble_list_by_forms(s_list_form,s_elem_form,
      ["a","c","d"])
      kibuvits_throw "test 1" if s!=s_expected
   end # Kibuvits_cg_selftests.test_assemble_list_by_forms

   #-----------------------------------------------------------------------

   def Kibuvits_cg_selftests.test_fill_form
      if kibuvits_block_throws{Kibuvits_cg.fill_form([],"")}
         kibuvits_throw "test 1"
      end # if
      if KIBUVITS_b_DEBUG
         if !kibuvits_block_throws{Kibuvits_cg.fill_form(42,"")}
            kibuvits_throw "test 2"
         end # if
         if !kibuvits_block_throws{Kibuvits_cg.fill_form([],42)}
            kibuvits_throw "test 3"
         end # if
      end # if
      s_form="A[CODEGENERATION_BLANK_0]BB\n"+
      "CC[CODEGENERATION_BLANK_1]DD"
      s_expected="AxxBB\nCCyyDD"
      s=Kibuvits_cg.fill_form(["xx","yy"],s_form)
      kibuvits_throw "test 4" if s!=s_expected

      # The next test has more blank needle-strings than
      # in the global cache, so that a needle-string generation
      # branch is entered.
      s_form="A[CODEGENERATION_BLANK_0]BB\n"+
      "CC[CODEGENERATION_BLANK_1]DD\n"+
      "CC[CODEGENERATION_BLANK_2]DD\n"+
      "CC[CODEGENERATION_BLANK_3]DD\n"+
      "CC[CODEGENERATION_BLANK_4]DD\n"
      s_expected="Ax0BB\nCCx1DD\nCCx2DD\nCCx3DD\nCCx4DD\n"
      s=Kibuvits_cg.fill_form(["x0","x1","x2","x3","x4"],s_form)
      kibuvits_throw "test 5" if s!=s_expected

      s_form="A[CODEGENERATION_BLANK_GUID_0]BB\n"+
      "CC[CODEGENERATION_BLANK_GUID_1]DD\n"+
      "CC[CODEGENERATION_BLANK_GUID_1]DD"
      s=Kibuvits_cg.fill_form("",s_form) # To see, that it doesn't throw.
      #kibuvits_writeln "\n\n{"+s+"}\n\n"
   end # Kibuvits_cg_selftests.test_fill_form

   #-----------------------------------------------------------------------

   public
   def Kibuvits_cg_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_cg_selftests.test_assemble_list_by_forms"
      kibuvits_testeval bn, "Kibuvits_cg_selftests.test_fill_form"
      return ar_msgs
   end # Kibuvits_cg_selftests.selftest

end # class Kibuvits_cg_selftests

#==========================================================================

