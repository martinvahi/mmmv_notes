#!/usr/bin/env ruby
#=========================================================================
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
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_arraycursor_t1.rb"

#==========================================================================


class Kibuvits_arraycursor_t1_selftests

   def initialize
   end #initialize

   #--------------------------------------------------------------------------
   private

   def Kibuvits_arraycursor_t1_selftests.test_1
      ob_cursor=Kibuvits_arraycursor_t1.new
      #-----------
      if !kibuvits_block_throws{ ob_cursor.inc()}
         kibuvits_throw "test 1"
      end # if
      ob_cursor.reset([11,22,33])
      if kibuvits_block_throws{ ob_cursor.inc()}
         kibuvits_throw "test 2"
      end # if
      i_x=ob_cursor.inc()
      kibuvits_throw "test 3 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.inc()
      kibuvits_throw "test 4 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.inc()
      kibuvits_throw "test 5 i_x=="+i_x.to_s if i_x!=11
      # Both, the inc() and dec() return the element under the
      # cursor before moving the cursor.
      i_x=ob_cursor.dec()
      kibuvits_throw "test 6 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.dec()
      kibuvits_throw "test 7 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 8 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.inc()
      kibuvits_throw "test 9 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.inc()
      kibuvits_throw "test 10 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 11 i_x=="+i_x.to_s if i_x!=11
      ob_cursor.clear()
      if !kibuvits_block_throws{ ob_cursor.inc()}
         kibuvits_throw "test 12"
      end # if
      ob_cursor.reset([])
      i_x=ob_cursor.dec()
      kibuvits_throw "test 13 i_x=="+i_x.to_s if i_x!=nil
      i_x=ob_cursor.dec()
      kibuvits_throw "test 14 i_x=="+i_x.to_s if i_x!=nil
      i_x=ob_cursor.inc()
      kibuvits_throw "test 15 i_x=="+i_x.to_s if i_x!=nil
      i_x=ob_cursor.inc()
      kibuvits_throw "test 16 i_x=="+i_x.to_s if i_x!=nil
      ob_cursor.reset([99])
      i_x=ob_cursor.inc()
      kibuvits_throw "test 17 i_x=="+i_x.to_s if i_x!=99
      i_x=ob_cursor.inc()
      kibuvits_throw "test 18 i_x=="+i_x.to_s if i_x!=99
      i_x=ob_cursor.dec()
      kibuvits_throw "test 19 i_x=="+i_x.to_s if i_x!=99
      i_x=ob_cursor.dec()
      kibuvits_throw "test 20 i_x=="+i_x.to_s if i_x!=99
   end # Kibuvits_arraycursor_t1_selftests.test_1

   #--------------------------------------------------------------------------

   def Kibuvits_arraycursor_t1_selftests.test_2
      ob_cursor=Kibuvits_arraycursor_t1.new
      def ob_cursor.b_skip(x_elem)
         b_out=false
         b_out=true if ((x_elem==42)||(x_elem==99))
         return b_out
      end # ob_cursor.b_skip
      #-----------
      # Both, the inc() and dec() return the element under the
      # cursor before moving the cursor.
      #-----------
      ob_cursor.reset([11,22,42,33]) # 42
      i_x=ob_cursor.inc()
      kibuvits_throw "test 1 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.inc()
      kibuvits_throw "test 2 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.inc()
      kibuvits_throw "test 3 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.inc()
      kibuvits_throw "test 4 i_x=="+i_x.to_s if i_x!=11
      #-----------
      ob_cursor.reset([11,22,42,33]) # 42
      i_x=ob_cursor.dec()
      kibuvits_throw "test 5 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 6 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 7 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.dec()
      kibuvits_throw "test 8 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 9 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 100 i_x=="+i_x.to_s if i_x!=22
      #-----------
      ob_cursor.reset([11,99,22,42,33]) # 99, 42
      i_x=ob_cursor.dec()
      kibuvits_throw "test 11 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 12 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 13 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.dec()
      kibuvits_throw "test 14 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 15 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 160 i_x=="+i_x.to_s if i_x!=22
      #-----------
      ob_cursor.reset([11,99,22,42,99,33]) # 99, 42,99
      i_x=ob_cursor.dec()
      kibuvits_throw "test 17 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 18 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 19 i_x=="+i_x.to_s if i_x!=22
      i_x=ob_cursor.dec()
      kibuvits_throw "test 20 i_x=="+i_x.to_s if i_x!=11
      i_x=ob_cursor.dec()
      kibuvits_throw "test 21 i_x=="+i_x.to_s if i_x!=33
      i_x=ob_cursor.dec()
      kibuvits_throw "test 22 i_x=="+i_x.to_s if i_x!=22
      #-----------
      ob_cursor.reset([99,42,99]) # 99, 42, 99
      i_x=ob_cursor.dec()
      kibuvits_throw "test 23 i_x=="+i_x.to_s if i_x!=nil
      #-----------
      ob_cursor.reset([99]) # 99, 42, 99
      i_x=ob_cursor.dec()
      kibuvits_throw "test 24 i_x=="+i_x.to_s if i_x!=nil
   end # Kibuvits_arraycursor_t1_selftests.test_2

   #--------------------------------------------------------------------------

   public
   include Singleton

   def Kibuvits_arraycursor_t1_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_arraycursor_t1_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_arraycursor_t1_selftests.test_2"
      return ar_msgs
   end # Kibuvits_arraycursor_t1_selftests.selftest

end # class Kibuvits_arraycursor_t1_selftests

#=========================================================================
#Kibuvits_arraycursor_t1_selftests.selftest
#puts Kibuvits_arraycursor_t1_selftests.test_2.to_s

