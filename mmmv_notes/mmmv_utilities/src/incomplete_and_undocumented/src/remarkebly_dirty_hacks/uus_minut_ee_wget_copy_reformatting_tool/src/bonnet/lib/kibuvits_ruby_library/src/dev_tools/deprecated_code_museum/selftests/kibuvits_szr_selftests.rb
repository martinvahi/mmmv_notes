#!/usr/bin/env ruby
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
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
require  KIBUVITS_HOME+"/src/include/incomplete/kibuvits_szr.rb"

#==========================================================================


class Kibuvits_szr_selftests_testclass_1
   attr_reader :i_x

   def initialize i_x
      bn=binding()
      kibuvits_typecheck bn, Integer ,i_x
      @i_x=i_x
   end # initialize

   def s_serialize
      s_out=i_x.to_s
      return s_out
   end # s_serialize

   def ob_deserialize s_serialized
      ob=Kibuvits_szr_selftests_testclass_1.new(s_serialized.to_i)
      return ob
   end # ob_deserialize

end # Kibuvits_szr_selftests_testclass_1

#--------------------------------------------------------------------------

# It tests functions that reside within the kibuvits_szr.rb .
class Kibuvits_szr_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_szr_selftests.test_serialize_by_ht_szr_explicit
      #------------
      ob_1=Kibuvits_szr_selftests_testclass_1.new(924)
      ht_szr_explicit=Hash.new
      #------------
      b_thrown=false
      s_x=nil
      begin
         bn=binding()
         s_x=Kibuvits_szr.serialize(bn,ob_1,nil,ht_szr_explicit)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1 s_x="+s_x if !b_thrown
      #------------
      ht_szr_explicit[$kibuvits_lc_Ruby_serialize_+ob_1.class.to_s]=$kibuvits_lc_emptystring+
      "ar_out<<ar_in[0].s_serialize"
      s_x=Kibuvits_szr.serialize(bn,ob_1,nil,ht_szr_explicit)
      raise "test 2 s_x="+s_x if s_x!=ob_1.i_x.to_s
      #------------
      ht_szr_explicit=Hash.new
      ht_szr_explicit[$kibuvits_lc_Ruby_serialize_szrtype_instance]=$kibuvits_lc_emptystring+
      "ar_out<<ar_in[0].s_serialize"
      s_x=Kibuvits_szr.serialize(bn,ob_1,nil,ht_szr_explicit)
      raise "test 3 s_x="+s_x if s_x!=ob_1.i_x.to_s
      #------------
      ht_szr_explicit[$kibuvits_lc_Ruby_serialize_+ob_1.class.to_s]=$kibuvits_lc_emptystring+
      "raise \"This script should not be called, because there's another script available. \""
      s_x=Kibuvits_szr.serialize(bn,ob_1,nil,ht_szr_explicit)
      raise "test 4 s_x="+s_x if s_x!=ob_1.i_x.to_s
   end # Kibuvits_szr_selftests.test_serialize_by_ht_szr_explicit

   #-----------------------------------------------------------------------


   #-----------------------------------------------------------------------
   public
   def Kibuvits_szr_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_szr_selftests.test_serialize_by_ht_szr_explicit"
      return ar_msgs
   end # Kibuvits_szr_selftests.selftest

end # class Kibuvits_szr_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_szr_selftests.selftest.to_s

