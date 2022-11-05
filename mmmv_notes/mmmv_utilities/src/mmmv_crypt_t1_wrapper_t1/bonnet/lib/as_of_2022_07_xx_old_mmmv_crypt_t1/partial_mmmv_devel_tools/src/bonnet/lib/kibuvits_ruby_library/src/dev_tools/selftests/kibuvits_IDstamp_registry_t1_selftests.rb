#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2011, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/kibuvits_graph.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_IDstamp_registry_t1.rb"

#==========================================================================


class Kibuvits_IDstamp_registry_t1_selftests

   def initialize
   end #initialize

   #--------------------------------------------------------------------------
   private

   def Kibuvits_IDstamp_registry_t1_selftests.test_1
      ob_x=Kibuvits_IDstamp_registry_t1.new
      ht_wild=Hash.new
      s_id_name="id_1"
      b_x=ob_x.b_xor_registry2wild(ht_wild,s_id_name)
      kibuvits_throw "test 1 " if !b_x
      b_x=ob_x.b_xor_registry2wild(ht_wild,s_id_name)
      kibuvits_throw "test 2 " if b_x
      ob_x.reset(s_id_name)
      b_x=ob_x.b_xor_registry2wild(ht_wild,s_id_name)
      kibuvits_throw "test 3 " if !b_x
      b_x=ob_x.b_xor_registry2wild(ht_wild,s_id_name)
      kibuvits_throw "test 4 " if b_x

      s_x=ob_x.s_get_ID_prefix(s_id_name)
      s_0=ob_x.s_default_ID_prefix
      kibuvits_throw "test 5 " if s_x!=s_0
      s_id_prefix="this_is_a_WildandCusom_prefix_"
      ob_x.set_ID_prefix(s_id_name,s_id_prefix)
      s_x=ob_x.s_get_ID_prefix(s_id_name)
      kibuvits_throw "test 6 " if s_x!=s_id_prefix
      ob_x.reset(s_id_name)
      s_x=ob_x.s_get(s_id_name)
      md=s_x.match(/^this_is_a_WildandCusom_prefix_/)
      kibuvits_throw "test 7 " if md.size!=1
   end # Kibuvits_IDstamp_registry_t1_selftests.test_1

   def Kibuvits_IDstamp_registry_t1_selftests.test_wild2registry
      ob_x=Kibuvits_IDstamp_registry_t1.new
      ht_wild=Hash.new
      s_id_name="id_1"
      if !kibuvits_block_throws{b_x=ob_x.b_xor_wild2registry(ht_wild,s_id_name)}
         kibuvits_throw "test 1"
      end # if
      ht_wild[s_id_name]=nil
      if !kibuvits_block_throws{b_x=ob_x.b_xor_wild2registry(ht_wild,s_id_name)}
         kibuvits_throw "test 2"
      end # if
      s_0="aaa_bbb"
      ht_wild[s_id_name]=s_0
      if kibuvits_block_throws{b_x=ob_x.b_xor_wild2registry(ht_wild,s_id_name)}
         kibuvits_throw "test 3"
      end # if
      s_1=ob_x.s_get(s_id_name)
      b_x=ob_x.b_xor_wild2registry(ht_wild,s_id_name)
      kibuvits_throw "test 4 " if s_0!=s_1
      # Repetition to cover the "first entry" related critical point.
      b_x=ob_x.b_xor_wild2registry(ht_wild,s_id_name)
      kibuvits_throw "test 5 " if s_0!=s_1
   end # Kibuvits_IDstamp_registry_t1_selftests.test_wild2registry

   #--------------------------------------------------------------------------
   public
   include Singleton

   def Kibuvits_IDstamp_registry_t1_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_IDstamp_registry_t1_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_IDstamp_registry_t1_selftests.test_wild2registry"
      return ar_msgs
   end # Kibuvits_IDstamp_registry_t1_selftests.selftest

end # class Kibuvits_IDstamp_registry_t1_selftests

#=========================================================================
#Kibuvits_IDstamp_registry_t1_selftests.selftest
#puts Kibuvits_IDstamp_registry_t1_selftests.test_1.to_s
#puts Kibuvits_IDstamp_registry_t1_selftests.test_wild2registry.to_s

