#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2015, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/wrappers/kibuvits_REDUCE.rb"
#==========================================================================


class Kibuvits_wrappers_REDUCE_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_wrappers_REDUCE_selftests.test_1
      msgcs=Kibuvits_msgc_stack.new
      s_reduce_source="solve({x2+x1^4+1=44,x1+7=924},{x1,x2});"
      s_x_reduce_output=Kibuvits_REDUCE.s_run_by_source(s_reduce_source,msgcs)
      if  msgcs.b_failure
         s_0=$kibuvits_lc_emptystring
         msgc=msgcs.last
         if msgc.x_data.class==Hash
            ht=msgc.x_data
            # The to_s at s_0 assignment is due to the
            # fact that missing hashtable keys give "nil" for values.
            s_0=ht[$kibuvits_lc_s_stderr].to_s+$kibuvits_lc_doublelinebreak+
            ht[$kibuvits_lc_s_stdout].to_s
         end # if
         s_1=msgcs.to_s+s_0
         kibuvits_throw("test 1, msgcs.to_s=="+s_1+
         "\nGUID='ce576f4c-4e16-4538-9352-c06151311fd7'")
      end # if
      kibuvits_throw "test 2" if s_x_reduce_output.length==0
   end # Kibuvits_wrappers_REDUCE_selftests.test_1

   #-----------------------------------------------------------------------

   def Kibuvits_wrappers_REDUCE_selftests.test_ht_solve_system_of_equations_t1
      msgcs=Kibuvits_msgc_stack.new
      #------------
      #     solve({x2+x1^4+1=44,x1+7=924},{x1,x2});
      s_or_ar_eq="x2+x1^4+1=44,x1+7*x2^2=924"
      s_or_ar_var="x1,x2,,,"
      ht_x=Kibuvits_REDUCE.ht_solve_system_of_equations_t1(
      s_or_ar_eq,s_or_ar_var,msgcs)
      kibuvits_throw "test 1 msgcs.to_s=="+msgcs.to_s if msgcs.b_failure
      #------------
      s_or_ar_eq="x2+x1^4+1=44,x1+7*x2^2=924"
      s_or_ar_var="x1"
      ht_x=Kibuvits_REDUCE.ht_solve_system_of_equations_t1(
      s_or_ar_eq,s_or_ar_var,msgcs)
      kibuvits_throw "test 2 msgcs.to_s=="+msgcs.to_s if msgcs.b_failure
      i_keys_len=ht_x.keys.size
      kibuvits_throw "test 3 i_keys_len=="+i_keys_len.to_s if i_keys_len!=0
      #------------
      # Triggers the presence of "arbcomplex" and "arbint".
      s_or_ar_eq="x2+x1^4+1=44,x1+7*x2^(x3)=924"
      s_or_ar_var="x1,x2,x3"
      ht_x=Kibuvits_REDUCE.ht_solve_system_of_equations_t1(
      s_or_ar_eq,s_or_ar_var,msgcs)
      i_keys_len=ht_x.keys.size
      kibuvits_throw "test 4 i_keys_len=="+i_keys_len.to_s if i_keys_len!=3
   end # Kibuvits_wrappers_REDUCE_selftests.test_ht_solve_system_of_equations_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_wrappers_REDUCE_selftests.selftest
      ar_msgs=Array.new
      #--------
      if !KIBUVITS_b_DEBUG
         b_available_on_path=Kibuvits_shell.b_available_on_path("reduce")
         return ar_msgs if !b_available_on_path
      end # if
      #--------
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_wrappers_REDUCE_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_wrappers_REDUCE_selftests.test_ht_solve_system_of_equations_t1"
      return ar_msgs
   end # Kibuvits_wrappers_REDUCE_selftests.selftest

end # class Kibuvits_wrappers_REDUCE_selftests

#==========================================================================

#Kibuvits_wrappers_REDUCE_selftests.test_1
