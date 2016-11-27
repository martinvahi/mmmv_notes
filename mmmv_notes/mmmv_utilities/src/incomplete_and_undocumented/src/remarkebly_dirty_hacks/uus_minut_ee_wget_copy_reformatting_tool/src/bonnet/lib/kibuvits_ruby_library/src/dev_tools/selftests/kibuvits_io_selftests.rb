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
require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"

#==========================================================================

class Kibuvits_io_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_io_selftests.test_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      #-----------------------------
      s_x=nil
      begin
         s_x=Kibuvits_io.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      rescue Exception => e
         kibuvits_throw("test 1a, e=="+e.to_s+
         "\nGUID='650c2173-8a03-4272-b733-b08130713ed7'")
      end # rescue
      s_0=s_x.gsub(/[\d]/,$kibuvits_lc_emptystring)
      if s_0.length==3
         kibuvits_throw("test 2a, s_0=="+s_0) if s_0!="..." # 198.4.69.42
         # According to the definition of the KRL API,
         # the local loop-back that is returned by the
         #
         #     Kibuvits_io.s_localhost_IP_address
         #
         # must be of the same type (IPv4,IPv6) as
         # the IP-address that is returned by the
         #
         #     Kibuvits_io.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
         #
         s_1=Kibuvits_io.s_localhost_IP_address
         kibuvits_throw("test 2b, s_1=="+s_1) if s_1!="127.0.0.1"
         md=s_x.match(/([\d]?){3}[.]([\d]?){3}[.]([\d]?){3}[.]([\d]?){3}/)
         kibuvits_throw("test 2c, s_x=="+s_x) if md==nil
         kibuvits_throw("test 2d, md[0]=="+md[0]) if md[0]!=s_x
      else
         if s_x==$kibuvits_lc_s_localhost
            kibuvits_throw("test 3a, s_x == \"localhost\", \n"+
            "but it must be an IP-address.\n"+
            "GUID='a470ace4-9dff-436e-aa33-b08130713ed7'\n\n")
         end # if
         s_1=Kibuvits_io.s_localhost_IP_address
         kibuvits_throw("test 3b, s_1=="+s_1) if s_1!="::1"
      end # if
      #-----------------------------
   end # Kibuvits_io_selftests.test_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected

   #-----------------------------------------------------------------------

   def Kibuvits_io_selftests.test_armour_dearmour_1
      s_fp_0=KIBUVITS_HOME+"/src/dev_tools/selftests/COMMENTS.txt"
      #---------
      ar_i_0=kibuvits_file_2_ar_i_t1(s_fp_0)
      s_armoured_0=kibuvits_s_armour_t1(ar_i_0)
      ar_i_1=kibuvits_ar_i_dearmour_t1(s_armoured_0)
      kibuvits_throw "test 1a " if ar_i_0.size!=ar_i_1.size
      i_len=ar_i_0.size
      i_0=nil
      i_1=nil
      i_len.times do |ix|
         i_0=ar_i_0[ix]
         i_1=ar_i_1[ix]
         if i_0!=i_1
            kibuvits_throw("test 1b  ix=="+ix.to_s+
            "  i_0=="+i_0.to_s+"  i_1=="+i_1.to_s)
         end # if
      end # loop
      s_armoured_1=kibuvits_s_armour_t1(ar_i_1)
      kibuvits_throw "test 1c " if s_armoured_0!=s_armoured_1
   end # Kibuvits_io_selftests.test_armour_dearmour_1

   #-----------------------------------------------------------------------

   def Kibuvits_io_selftests.test_armour_dearmour_2
      s_fp_0=KIBUVITS_HOME+"/src/dev_tools/selftests/COMMENTS.txt"
      #---------
      s_fp_tmp_1=Kibuvits_os_codelets.generate_tmp_file_absolute_path
      File.delete(s_fp_tmp_1) if File.exists? s_fp_tmp_1
      s_x_0=kibuvits_file2str_by_armour_t1(s_fp_0)
      kibuvits_str2file_by_dearmour_t1(s_x_0,s_fp_tmp_1)
      s_0=file2str(s_fp_0)
      s_1=file2str(s_fp_tmp_1)
      File.delete(s_fp_tmp_1) if File.exists? s_fp_tmp_1
      if s_0!=s_1
         kibuvits_throw("s_0==\n"+s_0+"\n\ns_1==\n"+s_1+"\n\n test 1 ")
      end # if
      #---------
      kibuvits_ar_i_2_file_t1([],s_fp_tmp_1)
      ar_i_1=kibuvits_file_2_ar_i_t1(s_fp_tmp_1)
      File.delete(s_fp_tmp_1) if File.exists? s_fp_tmp_1
      i_len_x=ar_i_1.size
      kibuvits_throw "test 2  ar_i_1.size=="+i_len_x.to_s if i_len_x!=0
      #---------
      kibuvits_ar_i_2_file_t1([49],s_fp_tmp_1)
      ar_i_1=kibuvits_file_2_ar_i_t1(s_fp_tmp_1)
      File.delete(s_fp_tmp_1) if File.exists? s_fp_tmp_1
      i_len_x=ar_i_1.size
      kibuvits_throw "test 3a  ar_i_1.size=="+i_len_x.to_s if i_len_x!=1
      kibuvits_throw "test 3b  ar_i_1[0]=="+ar_i_1[0].to_s if ar_i_1[0]!=49
      #---------
      kibuvits_ar_i_2_file_t1([49,77],s_fp_tmp_1) # to test the order
      ar_i_1=kibuvits_file_2_ar_i_t1(s_fp_tmp_1)
      File.delete(s_fp_tmp_1) if File.exists? s_fp_tmp_1
      i_len_x=ar_i_1.size
      kibuvits_throw "test 4a  ar_i_1.size=="+i_len_x.to_s if i_len_x!=2
      kibuvits_throw "test 4b  ar_i_1[0]=="+ar_i_1[0].to_s if ar_i_1[0]!=49
      kibuvits_throw "test 4c  ar_i_1[1]=="+ar_i_1[1].to_s if ar_i_1[1]!=77
   end # Kibuvits_io_selftests.test_armour_dearmour_2

   #-----------------------------------------------------------------------

   public
   def Kibuvits_io_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_io_selftests.test_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected"
      kibuvits_testeval bn, "Kibuvits_io_selftests.test_armour_dearmour_1"
      kibuvits_testeval bn, "Kibuvits_io_selftests.test_armour_dearmour_2"
      return ar_msgs
   end # Kibuvits_io_selftests.selftest

end # class Kibuvits_io_selftests

#==========================================================================
# Kibuvits_io_selftests.test_file2str_by_armour_t1
