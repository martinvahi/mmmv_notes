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

require  KIBUVITS_HOME+"/src/include/kibuvits_coords.rb"
#==========================================================================


class Kibuvits_coords_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_coords_selftests.test_1
      i_initial_width=6
      i_initial_height=6
      i_new_edge_length=3
      b_scale_by_width=true
      i_w_x,i_h_x=Kibuvits_coords.i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      if  (i_w_x!=3)||(i_h_x!=3)
         kibuvits_throw "test 1, i_w_x=="+i_w_x.to_s+"  i_h_x=="+i_h_x.to_s+
         "\nGUID='62afdc44-01e5-4681-9255-b3a241014dd7'"
      end # if
      #---------------
      i_initial_width=6000
      i_initial_height=4000
      i_new_edge_length=6000
      b_scale_by_width=true
      i_w_x,i_h_x=Kibuvits_coords.i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      if  (i_w_x!=6000)||(i_h_x!=4000)
         kibuvits_throw "test 2, i_w_x=="+i_w_x.to_s+"  i_h_x=="+i_h_x.to_s+
         "\nGUID='ffa61c57-997b-47d6-b455-b3a241014dd7'"
      end # if
      #---------------
      i_initial_width=6000
      i_initial_height=4000
      i_new_edge_length=30
      b_scale_by_width=true
      i_w_x,i_h_x=Kibuvits_coords.i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      if  (i_w_x!=30)||(i_h_x!=20)
         kibuvits_throw "test 2, i_w_x=="+i_w_x.to_s+"  i_h_x=="+i_h_x.to_s+
         "\nGUID='614cf726-9e4d-45fc-a555-b3a241014dd7'"
      end # if
      #---------------
      i_initial_width=6000
      i_initial_height=4000
      i_new_edge_length=10000 # 2.5
      b_scale_by_width=false
      i_w_x,i_h_x=Kibuvits_coords.i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      if  (i_w_x!=15000)||(i_h_x!=10000)
         kibuvits_throw "test 3, i_w_x=="+i_w_x.to_s+"  i_h_x=="+i_h_x.to_s+
         "\nGUID='302cbdd3-67ff-43d5-b155-b3a241014dd7'"
      end # if
   end # Kibuvits_coords_selftests.test_1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_coords_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_coords_selftests.test_1"
      return ar_msgs
   end # Kibuvits_coords_selftests.selftest

end # class Kibuvits_coords_selftests

#==========================================================================

