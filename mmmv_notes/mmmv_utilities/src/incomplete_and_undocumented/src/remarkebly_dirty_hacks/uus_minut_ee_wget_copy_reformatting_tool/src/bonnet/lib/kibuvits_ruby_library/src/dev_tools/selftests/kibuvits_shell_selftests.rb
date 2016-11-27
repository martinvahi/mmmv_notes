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
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"

#==========================================================================


class Kibuvits_shell_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_shell_selftests.test_b_available_on_path
      #------------
      b_thrown=false
      b_x=nil
      begin
         b_x=Kibuvits_shell.b_available_on_path(42)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1 b_x=="+b_x.to_s if !b_thrown
      #------------
      s_x="ls"
      b_x=Kibuvits_shell.b_available_on_path(s_x)
      raise "test 2 b_x=="+b_x.to_s+" s_x==\""+s_x+"\"" if b_x!=true
      #------------
      s_x="thaT_cOullD_possibl413454lY_not_ExIsTt"
      b_x=Kibuvits_shell.b_available_on_path(s_x)
      raise "test 3 b_x=="+b_x.to_s+" s_x==\""+s_x+"\"" if b_x!=false
   end # Kibuvits_shell_selftests.test_b_available_on_path

   #-----------------------------------------------------------------------

   def Kibuvits_shell_selftests.test_s_exc_system_specific_path_by_caching_t1
      b_throw_if_not_found=true
      s_program_name="ls"
      s_x=nil
      #------------
      b_thr=kibuvits_block_throws do
         s_x=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
         s_program_name,b_throw_if_not_found)
      end # block
      raise "test 1a " if b_thr
      b_throw_if_not_found=false
      b_thr=kibuvits_block_throws do
         s_x=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
         s_program_name,b_throw_if_not_found)
      end # block
      raise "test 1b " if b_thr
      s_x=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
      s_program_name,b_throw_if_not_found)
      s_0=s_x
      raise "test 1c s_x=="+s_x.to_s if s_x.length==0
      b_throw_if_not_found=true
      s_x=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
      s_program_name,b_throw_if_not_found)
      s_1=s_x
      raise "test 1d s_x=="+s_x.to_s if s_x.length==0
      raise "test 1e s_0=="+s_0+"  s_1=="+s_1 if s_0!=s_1
      #------------
      b_throw_if_not_found=true
      s_program_name="thIs_can_noT_PPpPPPPppppoOsSibly_exIsT_42343kJdfs0234jdddfsss11"
      b_thr=kibuvits_block_throws do
         s_x=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
         s_program_name,b_throw_if_not_found)
      end # block
      raise "test 2a " if !b_thr
      b_throw_if_not_found=false
      b_thr=kibuvits_block_throws do
         s_x=Kibuvits_shell.s_exc_system_specific_path_by_caching_t1(
         s_program_name,b_throw_if_not_found)
      end # block
      raise "test 2b " if b_thr
      raise "test 2c s_x=="+s_x.to_s if s_x!=$kibuvits_lc_emptystring
   end # Kibuvits_shell_selftests.test_s_exc_system_specific_path_by_caching_t1

   #-----------------------------------------------------------------------

   def Kibuvits_shell_selftests.test_throw_if_stderr_has_content_t1
      s_x=nil
      b_thrown=false
      s_cmd="W_this_command_CaNnnnoTpossssiBlyExisT_ljdljfF2"
      while Kibuvits_shell.b_available_on_path(s_cmd)
         s_cmd<<"X"
      end # loop
      #------------
      b_thrown=false
      ht_stdstreams=kibuvits_sh("ls")
      begin
         Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams)
      rescue Exception => e
         b_thrown=true
         s_x=e.to_s
      end # rescue
      raise "test 1 s_x=="+s_x if b_thrown
      #------------
      b_thrown=false
      ht_stdstreams=kibuvits_sh(s_cmd)
      begin
         Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams)
      rescue Exception => e
         b_thrown=true
         s_x=e.to_s
      end # rescue
      raise "test 2 s_cmd=="+s_cmd if !b_thrown
      #------------
   end # Kibuvits_shell_selftests.test_throw_if_stderr_has_content_t1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_shell_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_shell_selftests.test_b_available_on_path"
      kibuvits_testeval bn, "Kibuvits_shell_selftests.test_s_exc_system_specific_path_by_caching_t1"
      kibuvits_testeval bn, "Kibuvits_shell_selftests.test_throw_if_stderr_has_content_t1"
      return ar_msgs
   end # Kibuvits_shell_selftests.selftest

end # class Kibuvits_shell_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_shell_selftests.selftest.to_s

