#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2014, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/code_generation/kibuvits_cg_html_t1.rb"

#==========================================================================

class Kibuvits_cg_html_t1_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_cg_html_t1_selftests.test_s_place_2_table_t1
      i_number_of_columns=2
      ar_cell_content_html=["C_1","C_2","C_3"]
      s_table_tag_attributes="XX"
      s_cell_tag_attributes="YY"
      s_x=Kibuvits_cg_html_t1.s_place_2_table_t1(i_number_of_columns,
      ar_cell_content_html,s_table_tag_attributes,s_cell_tag_attributes)
      s_expected="<tableXX><tr>"+
      "<tdYY>C_1</td><tdYY>C_2</td></tr><tr>"+
      "<tdYY>C_3</td><tdYY></td>"+
      "</tr></table>"
      s_x=s_x.gsub(/[\s]/,$kibuvits_lc_emptystring)
      kibuvits_throw "test 1 s_x=="+s_x if s_x!=s_expected
      #------------
      ar_cell_content_html<<"C_4"
      s_table_tag_attributes=""
      s_cell_tag_attributes=""
      s_x=Kibuvits_cg_html_t1.s_place_2_table_t1(i_number_of_columns,
      ar_cell_content_html,s_table_tag_attributes,s_cell_tag_attributes)
      s_expected="<table><tr>"+
      "<td>C_1</td><td>C_2</td></tr><tr>"+
      "<td>C_3</td><td>C_4</td>"+
      "</tr></table>"
      s_x=s_x.gsub(/[\s]/,$kibuvits_lc_emptystring)
      kibuvits_throw "test 2 s_x=="+s_x if s_x!=s_expected
   end # Kibuvits_cg_html_t1_selftests.test_s_place_2_table_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_cg_html_t1_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_cg_html_t1_selftests.test_s_place_2_table_t1"
      return ar_msgs
   end # Kibuvits_cg_html_t1_selftests.selftest

end # class Kibuvits_cg_html_t1_selftests

#==========================================================================

