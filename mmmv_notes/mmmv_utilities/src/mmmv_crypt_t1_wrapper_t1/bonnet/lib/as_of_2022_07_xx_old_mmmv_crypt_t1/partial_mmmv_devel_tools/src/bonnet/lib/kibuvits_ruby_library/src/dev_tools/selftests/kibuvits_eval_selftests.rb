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

require  KIBUVITS_HOME+"/src/include/kibuvits_i18n_msgs_t1.rb"

#==========================================================================


class Kibuvits_eval_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_eval_selftests.test_interpreter_ruby
      msgcs=Kibuvits_msgc_stack.new
      bridge=Kibuvits_eval_bridge_Ruby.new
      kibuvits_throw "test 1" if !bridge.installed
      s_script='puts "hi".reverse'
      ht_stdstreams=Kibuvits_eval.run(s_script,"Ruby",msgcs)
      kibuvits_throw "test 2" if msgcs.b_failure
      s_stdout=ht_stdstreams['s_stdout']
      kibuvits_throw "test 3 s_stdout=="+s_stdout if !s_stdout.include? "ih"
   end # Kibuvits_eval_selftests.test_interpreter_ruby

   def Kibuvits_eval_selftests.test_interpreter_php5
      msgcs=Kibuvits_msgc_stack.new
      bridge=Kibuvits_eval_bridge_PHP5.new
      return if !bridge.installed
      s_script="$xx='Hi'.'There'; echo $xx;"
      ht_stdstreams=Kibuvits_eval.run(s_script,"php5",msgcs)
      kibuvits_throw "test 1" if msgcs.b_failure
      s_stdout=ht_stdstreams['s_stdout']
      kibuvits_throw "test 2 s_stdout=="+s_stdout  if !s_stdout.include? "HiThere"
   end # Kibuvits_eval_selftests.test_interpreter_php5

   def Kibuvits_eval_selftests.test_language_independent
      msgcs=Kibuvits_msgc_stack.new
      s_script="whatever"
      ht_stdstreams=Kibuvits_eval.run(s_script,
      "lang_that_doesn't_exist",msgcs)
      kibuvits_throw "test 1,  msgcs.to_s=="+msgcs.to_s if !msgcs.b_failure
      kibuvits_throw "test 2" if msgcs.last.s_message_id!="1"
   end # Kibuvits_eval_selftests.test_language_independent

   #-----------------------------------------------------------------------

   public
   def Kibuvits_eval_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_eval_selftests.test_interpreter_ruby"
      kibuvits_testeval bn, "Kibuvits_eval_selftests.test_interpreter_php5"
      kibuvits_testeval bn, "Kibuvits_eval_selftests.test_language_independent"
      return ar_msgs
   end # Kibuvits_eval_selftests.selftest

end # class Kibuvits_eval_selftests

#==========================================================================

