#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2009, martin.vahi@softf1.com that has an
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
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
   require  KIBUVITS_HOME+"/src/include/kibuvits_str_concat_array_of_strings.rb"
end # if

#==========================================================================

# For string output, the kibuvits_writeln and kibuvits_write
# are defined in the kibuvits_boot.rb
# WARNING: it's not that well tested.
def kibuvits_write_to_stdout data
   $kibuvits_lc_mx_streamaccess.synchronize do
      # It's like the kibuvits_writeln, but without the
      an_io=STDOUT.reopen($stdout)
      an_io.write data
      an_io.flush
      an_io.close
   end # synchronize
end # kibuvits_write_to_stdout

#--------------------------------------------------------------------------
def str2file(s_a_string, s_fp)
   if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_a_string
         kibuvits_typecheck bn, String, s_fp
      end # if
   end # if
   $kibuvits_lc_mx_streamaccess.synchronize do
      begin
         file=File.open(s_fp, "w")
         file.write(s_a_string)
         file.close
      rescue Exception =>err
         raise "No comments. GUID='4d4b83d3-356b-49ca-a128-40f130713ed7' \n"+
         "s_a_string=="+s_a_string+"\n"+err.to_s+"\n\n"
      end #
   end # synchronize
end # str2file

#--------------------------------------------------------------------------

# It's actually a copy of a TESTED version of
# kibuvits_s_concat_array_of_strings
# and this copy here is made to avoid making the
# kibuvits_io.rb to depend on the kibuvits_str.rb
def kibuvits_hack_to_break_circular_dependency_between_io_and_str_kibuvits_s_concat_array_of_strings(ar_in)
   n=ar_in.size
   if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array, ar_in
         s=nil
         n.times do |i|
            bn=binding()
            s=ar_in[i]
            kibuvits_typecheck bn, String, s
         end # loop
      end # if
   end # if
   s_out="";
   n.times{|i| s_out<<ar_in[i]}
   return s_out;
end # kibuvits_hack_to_break_circular_dependency_between_io_and_str_kibuvits_s_concat_array_of_strings


def file2str(s_file_path)
   s_out=$kibuvits_lc_emptystring
   if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path
      end # if
   end # if
   $kibuvits_lc_mx_streamaccess.synchronize do
      # The idea here is to make the file2str easily copy-pastable to projects that
      # do not use the Kibuvits Ruby Library.
      s_fp=s_file_path
      ar_lines=Array.new
      begin
         File.open(s_fp) do |file|
            while line = file.gets
               ar_lines<<$kibuvits_lc_emptystring+line
            end # while
         end # Open-file region.
         if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
            s_out=kibuvits_s_concat_array_of_strings(ar_lines)
         else
            s_out=kibuvits_hack_to_break_circular_dependency_between_io_and_str_kibuvits_s_concat_array_of_strings(ar_lines)
         end # if
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='63afbc52-9fe7-43b5-b528-40f130713ed7'\n\n"))
      end #
   end # synchronize
   return s_out
end # file2str

#--------------------------------------------------------------------------

def kibuvits_ar_i_2_file_t1(ar_i,s_file_path)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Array, ar_i
      kibuvits_typecheck bn, String, s_file_path
   end # if
   # Credits for the Array.pack solution go to:
   # http://stackoverflow.com/questions/941856/write-binary-file-in-ruby
   x_binary_string=ar_i.pack("C*") # 8 bit unsigned integer
   $kibuvits_lc_mx_streamaccess.synchronize do
      begin
         File.open(s_file_path,"wb") do |file|
            file.write(x_binary_string)
         end # Open-file region.
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='b5987046-2b40-4a15-8328-40f130713ed7'\n\n"))
      end #
   end # synchronize
end # kibuvits_ar_i_2_file_t1

def kibuvits_file_2_ar_i_t1(s_file_path)
   ar_out=Array.new
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String, s_file_path
   end # if
   s_fp=s_file_path
   $kibuvits_lc_mx_streamaccess.synchronize do
      begin
         File.open(s_fp) do |file|
            file.each_byte do |i_byte|
               ar_out<<i_byte
            end # loop
         end # Open-file region.
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='436c2d68-2509-4390-9228-40f130713ed7'\n\n"))
      end #
   end # synchronize
   return ar_out
end # kibuvits_file_2_ar_i_t1

#--------------------------------------------------------------------------

# All of the numbers in the ar_i must be in range [0,255]
def kibuvits_s_armour_t1(ar_i)
   i_len_ar_i=ar_i.size
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Array, ar_i
      x_i=nil
      i_len_ar_i.times do |i|
         bn1=binding()
         x_i=ar_i[i]
         kibuvits_typecheck bn1, Fixnum, x_i
         if x_i<0
            kibuvits_throw("x_i == "+x_i.to_s+" < 0 "+
            "\n GUID='3b4c61dc-a421-477d-a428-40f130713ed7'\n\n")
         end # if
         if 255<x_i
            kibuvits_throw(" 255 < x_i == "+x_i.to_s+
            "\n GUID='7277113b-7eed-4bb7-9218-40f130713ed7'\n\n")
         end # if
      end # loop
   end # if
   s_out=$kibuvits_lc_emptystring
   # The range [A000,A48C]_hex has been chosen simply
   # because it covers a whole byte, [0,FF]_hex
   # and has an interesting language name, Yi,
   #
   # http://en.wikipedia.org/wiki/Yi_people
   # http://www.unicode.org/charts/PDF/UA000.pdf
   #
   # This way every byte can be represented by
   # a single existing Unicode character without
   # any branching, jumping, over/around Unicode "holes",
   # unassigned Unicode code points.
   #
   # A single byte is armoured as 2 byte Unicode
   # character, but this approach saves data
   # volume at later steps.
   #
   # For example, 255_base_10 is armoured to
   # 2 characters in hex, the FF_base_16, but
   # it is a single character, if armoured to Yi.
   # If the Yi characters are encrypted,
   # character-by-charcter and the number of
   # characters that the encryption function
   # returns is at least double the input data volume of the
   # encryption function, then minimizing
   # the amount of characters at armouring
   # step yields a considerable winning.
   ar_s=Array.new
   s_0=nil
   x_i=nil
   i_zero="A000".to_i(16)
   i_len_ar_i.times do |i|
      x_i=i_zero+ar_i[i]
      s_0="".concat(x_i)
      ar_s<<s_0
   end # loop
   s_out=kibuvits_s_concat_array_of_strings(ar_s)
   return s_out
end #  kibuvits_s_armour_t1

def kibuvits_ar_i_dearmour_t1(s_armoured)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String, s_armoured
   end # if
   ar_out=Array.new
   ar_unicode=s_armoured.codepoints
   i_len=ar_unicode.size
   return ar_out if i_len==0
   i_zero="A000".to_i(16)
   i_x=nil
   if KIBUVITS_b_DEBUG
      i_len.times do |ix|
         i_x=ar_unicode[ix]-i_zero
         if i_x<0
            kibuvits_throw("i_x == "+i_x.to_s+" < 0 "+
            "\n GUID='c167073b-45cf-43d6-9218-40f130713ed7'\n\n")
         end # if
         if 255<i_x
            kibuvits_throw(" 255 < i_x == "+i_x.to_s+
            "\n GUID='850f3e21-baca-404f-9518-40f130713ed7'\n\n")
         end # if
         ar_out<<i_x
      end # loop
   else
      i_len.times do |ix|
         i_x=ar_unicode[ix]-i_zero
         ar_out<<i_x
      end # loop
   end # if
   return ar_out
end # kibuvits_ar_i_dearmour_t1

#--------------------------------------------------------------------------

# Reads in any file, byte-by-byte, converts
# the bytes to Unicode characters and returns the
# series of characters as a single string.
def kibuvits_file2str_by_armour_t1(s_file_path)
   s_out=$kibuvits_lc_emptystring
   if KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path
      end # if
   end # if
   ar_i=kibuvits_file_2_ar_i_t1(s_file_path)
   s_out=kibuvits_s_armour_t1(ar_i)
   return s_out
end # kibuvits_file2str_by_armour_t1

# The string must conform to the format
# of the kibuvits_s_armour_t1(...)
def kibuvits_str2file_by_dearmour_t1(s_armoured,s_file_path)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String, s_armoured
      kibuvits_typecheck bn, String, s_file_path
   end # if
   ar_i=kibuvits_ar_i_dearmour_t1(s_armoured)
   kibuvits_ar_i_2_file_t1(ar_i,s_file_path)
end # kibuvits_str2file_by_dearmour_t1

#--------------------------------------------------------------------------

# The main purpose of this method is to encapsulate the console
# reading code, because there's just too many unanswered questions about
# the console reading.
def read_a_line_from_console
   s_out=nil
   $kibuvits_lc_mx_streamaccess.synchronize do
      # The IO.gets() treats console arguments as if they would have
      # been  as user input for a query. For some weird reason,
      # the current solution works.
      s_out=""+$stdin.gets
   end # synchronize
   return s_out
end # read_a_line_from_console

def write_2_console a_string
   $kibuvits_lc_mx_streamaccess.synchronize do
      # The "" is just for reducing the probability of
      # mysterious memory sharing related quirk-effects.
      $stdout.write ""+a_string.to_s
   end # synchronize
end # write_2_console

def writeln_2_console a_string,
   i_number_of_prefixing_linebreaks=0,
   i_number_of_suffixing_linebreaks=1
   s=("\n"*i_number_of_prefixing_linebreaks)+a_string.to_s+
   ("\n"*i_number_of_suffixing_linebreaks)
   write_2_console s
end # write_2_console

class Kibuvits_io
   @@cache=Hash.new
   def initialize
   end #initialize

   #-----------------------------------------------------------------------

   def create_empty_ht_stdstreams
      ht_stdstreams=Hash.new
      ht_stdstreams[$kibuvits_lc_s_stdout]=$kibuvits_lc_emptystring
      ht_stdstreams[$kibuvits_lc_s_stderr]=$kibuvits_lc_emptystring
      return ht_stdstreams
   end # create_empty_ht_stdstreams

   def Kibuvits_io.create_empty_ht_stdstreams
      ht_stdstreams=Kibuvits_io.instance.create_empty_ht_stdstreams
      return ht_stdstreams
   end # Kibuvits_io.create_empty_ht_stdstreams

   #-----------------------------------------------------------------------

   # A computer might have multiple network
   # cards, like WiFi card, mobile internet USB-stick, etc.
   #
   # If only loop-back interfaces are found, a random
   # "localhost" loop-back IP-addrss is returned.
   #
   # Action priorities:
   #
   #     highest_priority) Return a non-loop-back IPv4 address
   #       lower_priority) Return a non-loop-back IPv6 address
   #       lower_priority) Return a loop-back IPv4 address
   #       lower_priority) Return a loop-back IPv6 address
   #      lowest_priority) Throw an exception
   #
   # The reason, why IPv4 is preferred to IPv6 is
   # that IPv6 addresses are assigned to interfaces
   # on LAN even, when the actual internet connection
   # is available only through an IPv4 address.
   #
   # On the other hand, just like NAT almost solved the
   # IPv4 address space problem by mapping
   # LANipAddress:whateverport1_to_WANipAddress:someport2
   # it is possible to increase the number of end-point
   # addresses even further by adding a software layer, like
   # ApplicationName_LANipAddress:whateverport1, where the
   # ApplicationName might depict a multiplexer/demultiplexer.
   # That is to say, the IPv4 addresses are likely
   # to go a pretty long way.
   def s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      if !defined? $kibuvits_inclusionconstannt_kibuvits_io_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
         # The interpreter is sometimes picky, if real
         # Ruby constants are  in a function.
         require "socket"
         $kibuvits_inclusionconstannt_kibuvits_io_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected=true
      end # if
      ar_doable=Array.new(5,false) # actions by priority
      #ar_doable[4]=true # throw, if all else fails, outcommented due to a hack
      ar_data=Array.new(5,nil)
      # Credits go to to:
      # http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix
      ar_addrinfo=Socket.ip_address_list
      ar_addrinfo.each do |ob_addrinfo|
         if ob_addrinfo.ipv6?
            next if ob_addrinfo.ipv6_multicast?
            if ob_addrinfo.ipv6_loopback?
               ar_doable[3]=true
               ar_data[3]=ob_addrinfo.ip_address
               next
            end # if
            next if ar_doable[1]
            ar_doable[1]=true
            ar_data[1]=ob_addrinfo.ip_address
         else
            if ob_addrinfo.ipv4?
               next if ob_addrinfo.ipv4_multicast?
               if ob_addrinfo.ipv4_loopback?
                  ar_doable[2]=true
                  ar_data[2]=ob_addrinfo.ip_address
                  next
               end # if
               next if ar_doable[0]
               ar_doable[0]=true
               ar_data[0]=ob_addrinfo.ip_address
            else
               kibuvits_throw("ob_addrinfo.to_s=="+ob_addrinfo.to_s+
               "\n GUID='b851144d-9e65-4a36-b318-40f130713ed7'\n\n")
            end # if
         end # if
      end # loop
      i_n=ar_doable.size-1 # The last option is throwing.
      i_n.times do |i_ix|
         if ar_doable[i_ix]
            s_out=ar_data[i_ix]
            return s_out
         end # if
      end # loop
      kibuvits_throw("ar_addrinfo.to_s=="+ar_addrinfo.to_s+
      "\n GUID='de50b235-2572-4148-9118-40f130713ed7'\n\n")
   end # s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected

   def Kibuvits_io.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      s_out=Kibuvits_io.instance.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      return s_out
   end # Kibuvits_io.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected


   # Returns "127.0.0.1" or "::1", depending on the
   # value of the s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected()
   def s_localhost_IP_address
      if !defined? @s_localhost_IP_address_cache
         s_ip_address=s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
         s_0=nil
         if (s_ip_address.gsub(/[\d]/,$kibuvits_lc_emptystring)).length==3
            s_0="127.0.0.1"
         else
            if s_ip_address==$kibuvits_lc_s_localhost
               kibuvits_throw("s_ip_addresss == \"localhost\", \n"+
               "but it should be an IP-address.\n"+
               "GUID='359bdf2e-0425-49a5-a118-40f130713ed7'\n\n")
            end # if
            s_0="::1" # IPv6 version of the loop-back interface
         end # if
         @s_localhost_IP_address_cache=s_0.freeze
      end # if
      s_out=@s_localhost_IP_address_cache
      return s_out
   end # s_localhost_IP_address

   def Kibuvits_io.s_localhost_IP_address
      s_out=Kibuvits_io.instance.s_localhost_IP_address
      return s_out
   end # Kibuvits_io.s_localhost_IP_address

   #-----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_io

#==========================================================================
