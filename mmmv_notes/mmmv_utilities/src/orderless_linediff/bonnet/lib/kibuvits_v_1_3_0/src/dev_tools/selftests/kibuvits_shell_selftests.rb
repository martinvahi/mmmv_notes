#!/opt/ruby/bin/ruby -Ku
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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_msgc.rb"
   require  "kibuvits_shell.rb"
end # if
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
   public
   def Kibuvits_shell_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_shell_selftests.test_b_available_on_path"
      return ar_msgs
   end # Kibuvits_shell_selftests.selftest

end # class Kibuvits_shell_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_shell_selftests.selftest.to_s

