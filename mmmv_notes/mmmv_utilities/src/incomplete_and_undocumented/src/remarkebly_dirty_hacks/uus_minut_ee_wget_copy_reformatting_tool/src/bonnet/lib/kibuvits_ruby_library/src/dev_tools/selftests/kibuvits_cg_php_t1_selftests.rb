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

require  KIBUVITS_HOME+"/src/include/code_generation/kibuvits_cg_php_t1.rb"

#==========================================================================

class Kibuvits_cg_php_t1_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_cg_php_t1_selftests.test_s_ar_or_ht_2php
      #kibuvits_throw "test 1 s_x=="+s_x if s_x!=s_expected
      s_php_array_variable_name="arht_uuu"
      rgx_0=/[\s\n]/
      #-----
      ar_or_ht_x=[4.5,"ff",55]
      s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_x)
      #-----
      ar_or_ht_x=Array.new
      s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_x)
      s_xx=s_x.gsub(rgx_0,$kibuvits_lc_emptystring)
      s_expected=$kibuvits_lc_dollarsign+s_php_array_variable_name+"=array();"
      kibuvits_throw "test 1 s_xx=="+s_xx.to_s if s_xx!=s_expected
      #-----
      ar_or_ht_x=Hash.new
      ar_or_ht_x["ee"]=44
      ar_or_ht_x[55]="ihii"
      ar_or_ht_x[57]=4.5
      s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_x)
      #-----
      ar_or_ht_x=Hash.new
      s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_x)
      s_xx=s_x.gsub(rgx_0,$kibuvits_lc_emptystring)
      s_expected=$kibuvits_lc_dollarsign+s_php_array_variable_name+"=array();"
      kibuvits_throw "test 2 s_xx=="+s_xx.to_s if s_xx!=s_expected
      #-----
      i_row_length=2
      ar_or_ht_x=[4.5,"ff",55]+[9.5,"fff",55]
      s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_x,i_row_length)
      #-----
   end # Kibuvits_cg_php_t1_selftests.test_s_ar_or_ht_2php

   #-----------------------------------------------------------------------

   def Kibuvits_cg_php_t1_selftests.test_s_var
      #kibuvits_throw "test 1 s_x=="+s_x if s_x!=s_expected
      #-----
      bn=binding();
      ar_or_ht_x=[4.5,"ff",55]
      s_x=Kibuvits_cg_php_t1.s_var(bn,ar_or_ht_x)
      s_x=Kibuvits_cg_php_t1.s_var(bn,ar_or_ht_x,2)
      #-----
      x_0=4
      s_x=Kibuvits_cg_php_t1.s_var(bn,x_0)
      s_expected="$x_0=4;\n"
      kibuvits_throw "test 1 s_x=="+s_x.to_s if s_x!=s_expected
      #-----
      x_0023=5.42
      s_x=Kibuvits_cg_php_t1.s_var(bn,x_0023)
      s_expected="$x_0023=5.42;\n"
      kibuvits_throw "test 2 s_x=="+s_x.to_s if s_x!=s_expected
      #-----
   end # Kibuvits_cg_php_t1_selftests.test_s_var

   #-----------------------------------------------------------------------

   public
   def Kibuvits_cg_php_t1_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_cg_php_t1_selftests.test_s_ar_or_ht_2php"
      kibuvits_testeval bn, "Kibuvits_cg_php_t1_selftests.test_s_var"
      return ar_msgs
   end # Kibuvits_cg_php_t1_selftests.selftest

end # class Kibuvits_cg_php_t1_selftests

#==========================================================================

