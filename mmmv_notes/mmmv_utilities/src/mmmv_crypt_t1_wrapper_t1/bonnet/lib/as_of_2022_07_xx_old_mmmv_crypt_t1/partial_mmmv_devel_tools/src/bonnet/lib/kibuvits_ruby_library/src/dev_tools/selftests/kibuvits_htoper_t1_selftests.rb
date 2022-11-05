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
require  KIBUVITS_HOME+"/src/include/kibuvits_htoper_t1.rb"

#==========================================================================


class Kibuvits_htoper_t1_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_htoper_t1_selftests.test_run_in_htspace
      #------------
      ht=Hash.new
      ht['aa']=42
      ht['bb']=74
      ht['cc']=2
      ht['ht']=ht
      #------------
      b_thrown=false
      begin
         x=Kibuvits_htoper_t1.run_in_htspace(ht) do |aa,bb|
            next(aa+bb)
         end # block
         raise Exception.new("x=="+x.to_s) if x!=116
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         x=Kibuvits_htoper_t1.run_in_htspace(ht) do |aa,bb,ht|
            ht['cc']=aa+bb
         end # block
         raise Exception.new("x=="+x.to_s) if ht['cc']!=116
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if b_thrown

      #------------
      ht=Hash.new
      ht['aa']=42
      ht['bb']=74
      ht['cc']=2
      #------------
      b_thrown=false
      # A non-throwing version with a binding.
      begin
         bn_x=binding()
         x=Kibuvits_htoper_t1.run_in_htspace(ht,bn_x) do |aa,bb|
            next(aa+bb)
         end # block
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3a " if b_thrown

      #------------
      if KIBUVITS_b_DEBUG
         ht=Hash.new
         ht['aa']=42
         ht['bb']=74
         ht['cc']=2
         x=nil
         b_thrown=false
         # In debug mode it must throw, if it detects a missing key from the ht.
         begin
            x=Kibuvits_htoper_t1.run_in_htspace(ht) do |aa,bb,gg_THIS_IS_MISSING|
               next(aa+bb)
            end # block
         rescue Exception => e
            b_thrown=true
         end # rescue
         raise "test 3b " if !b_thrown
         #------------
         ht_uhuu=Hash.new
         ht_uhuu['aa']=42
         ht_uhuu['bb']=74
         ht_uhuu['cc']=2
         x=nil
         b_thrown=false
         # A throwing version with a binding.
         begin
            bn_x=binding()
            x=Kibuvits_htoper_t1.run_in_htspace(ht_uhuu,bn_x) do |aa,bb,gg|
               next(aa+bb)
            end # block
         rescue Exception => e
            b_thrown=true
         end # rescue
         raise "test 3c " if !b_thrown
      end # if
      #------------
   end # Kibuvits_htoper_t1_selftests.test_run_in_htspace


   # This function is part of the embedded documentation
   # of the Kibuvits_htoper_t1.run_in_htspace(...) and it's duplicated
   # here only to verify that it actually runs as expected.
   def Kibuvits_htoper_t1_selftests.demo_for_storing_values_back_to_the_hashtable
      ht=Hash.new
      ht['aa']=42
      ht['bb']=74
      ht['cc']=2
      ht['ht']=ht
      x=Kibuvits_htoper_t1.run_in_htspace(ht) do |bb,aa,ht|
         ht['cc']=aa+bb
      end # block
      raise Exception.new("x=="+x.to_s) if ht['cc']!=116
   end # Kibuvits_htoper_t1_selftests.demo_for_storing_values_back_to_the_hashtable

   #-----------------------------------------------------------------------

   def Kibuvits_htoper_t1_selftests.test_plus
      #------------
      ht_x=Hash.new
      ht_x['aa']=42
      ht_x['bb']=74
      ht_x['cc']=2
      ht_x['ht_x']=ht_x
      #------------
      x=Kibuvits_htoper_t1.plus(ht_x,'aa',8)
      raise "test 1a" if ht_x['aa']!=50
      raise "test 1b" if x!=50
      ht_x['aa']=42
      #------------
      x=nil
      b_thrown=false
      begin
         bn_x=binding()
         x=Kibuvits_htoper_t1.plus(ht_x,'aa',11,bn_x)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2a" if b_thrown
      raise "test 2b" if ht_x['aa']!=53
      ht_x['aa']=42
      #------------
      if KIBUVITS_b_DEBUG
         b_thrown=false
         begin
            bn_x=binding()
            x=Kibuvits_htoper_t1.plus(ht_x,'aX',70,bn_x)
         rescue Exception => e
            b_thrown=true
         end # rescue
         raise "test 3a " if !b_thrown
      end # if
      #------------
   end # Kibuvits_htoper_t1_selftests.test_plus

   #-----------------------------------------------------------------------

   def Kibuvits_htoper_t1_selftests.test_x_getset_semisparse_var
      ht_x=Hash.new
      #------------
      ht_x['aa']=42
      #------------
      x=Kibuvits_htoper_t1.x_getset_semisparse_var(ht_x,'aa',99)
      raise "test 1 x=="+x.to_s if x!=42
      x=Kibuvits_htoper_t1.x_getset_semisparse_var(ht_x,'bb',99)
      raise "test 2 x=="+x.to_s if x!=99
      #------------
   end # Kibuvits_htoper_t1_selftests.test_x_getset_semisparse_var

   #-----------------------------------------------------------------------

   def Kibuvits_htoper_t1_selftests.test_ht2binding
      bn=binding()
      ht_x=Hash.new
      #------------
      ht_x["aa"]=42
      raise "test 1a " if defined? aa
      Kibuvits_htoper_t1.ht2binding(bn,ht_x)
      raise "test 1b " if !defined? aa
      raise "test 1c aa=="+aa.to_s if aa!=42
      #------------
      ht_x["aa"]=74
      ht_x["bb"]="69x"
      raise "test 2a " if defined? bb
      Kibuvits_htoper_t1.ht2binding(bn,ht_x)
      raise "test 2b " if !defined? bb
      raise "test 2c bb=="+bb.to_s if bb!="69x"
      raise "test 2d aa=="+aa.to_s if aa!=74
   end # Kibuvits_htoper_t1_selftests.test_ht2binding

   #-----------------------------------------------------------------------

   def Kibuvits_htoper_t1_selftests.test_ht_clone_with_shared_references
      ht_orig=Hash.new
      ht_x=Kibuvits_htoper_t1.ht_clone_with_shared_references(ht_orig)
      raise "test 1 " if ht_orig.size!=ht_x.size
      #------------
      ht_orig.clear
      s_key="aa"
      ht_orig[s_key]="AAA"
      ht_x=Kibuvits_htoper_t1.ht_clone_with_shared_references(ht_orig)
      raise "test 2a " if ht_orig.size!=ht_x.size
      x_value=ht_x[s_key]
      x_value<<"X"
      raise "test 2b " if ht_orig[s_key]!=("AAAX")
      ht_x.clear
      raise "test 2c " if ht_orig.size==ht_x.size
   end # Kibuvits_htoper_t1_selftests.test_ht_clone_with_shared_references

   #-----------------------------------------------------------------------

   def Kibuvits_htoper_t1_selftests.test_insert_to_ht_without_overwriting_any_key_t1
      b_all_keys_will_contain_numeration_rpefix=true
      i_minimum_amount_of_digits=3
      s_suffix_of_the_prefix="WWW"
      #------------
      ht_x=Hash.new
      s_key="aa"
      x_value="AAAA"
      Kibuvits_htoper_t1.insert_to_ht_without_overwriting_any_key_t1(
      ht_x,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      s_expected_key="000WWW"+s_key
      raise "test 1a " if !ht_x.has_key? s_expected_key
      s_x=ht_x[s_expected_key]
      raise "test 1b " if s_x!=x_value
      Kibuvits_htoper_t1.insert_to_ht_without_overwriting_any_key_t1(
      ht_x,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      s_expected_key="001WWW"+s_key
      raise "test 1c " if !ht_x.has_key? s_expected_key
      s_x=ht_x[s_expected_key]
      raise "test 1d s_x=="+s_x if s_x!=x_value
      #------------
      b_all_keys_will_contain_numeration_rpefix=false
      s_key="bb"
      x_value="BBBB"
      Kibuvits_htoper_t1.insert_to_ht_without_overwriting_any_key_t1(
      ht_x,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      s_expected_key=s_key
      raise "test 2a " if !ht_x.has_key? s_expected_key
      s_x=ht_x[s_expected_key]
      raise "test 2b s_x=="+s_x if s_x!=x_value
      #------------
   end # Kibuvits_htoper_t1_selftests.test_insert_to_ht_without_overwriting_any_key_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_htoper_t1_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.test_run_in_htspace"
      kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.demo_for_storing_values_back_to_the_hashtable"
      kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.test_plus"
      kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.test_x_getset_semisparse_var"
      kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.test_ht_clone_with_shared_references"
      kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.test_insert_to_ht_without_overwriting_any_key_t1"
      #-----------
      # Needs to be dormant till the ruby-lang.org flaw #8438 gets fixed.
      #kibuvits_testeval bn, "Kibuvits_htoper_t1_selftests.test_ht2binding"
      #-----------
      return ar_msgs
   end # Kibuvits_htoper_t1_selftests.selftest

end # class Kibuvits_htoper_t1_selftests

#==========================================================================

