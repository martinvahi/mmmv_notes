#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2010, martin.vahi@softf1.com that has an
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
# Example usage:
# ps -A | grep dng | ruby ./the_ruby_file_that_you_are_currently_reading.rb
#--------------------------------------------------------------------------

def ar_extract_process_ids(ar_stdin_lines)
   cl_1=ar_stdin_lines.class
   raise "ar_stdin_lines.class=="+cl_1.to_s if cl_1!=Array
   ar_out=Array.new
   s_lc_emptystring=""
   rgx_1=/^[\s]+/
   rgx_2=/^[\d]+/
   s1=nil
   s2=nil
   md=nil
   # Example of the "ps -A " output format:
   #   28 ?        00:05:20 kondemand/0
   #   29 ?        00:05:23 kondemand/1
   #31184 ?        00:00:00 akonadi_vcard_r
   #32486 pts/4    00:00:00 konsole
   ar_stdin_lines.each do |s_line|
      cl_1=s_line.class
      raise "s_line.class=="+cl_1.to_s if cl_1!=String
      s1=s_line.sub(rgx_1,s_lc_emptystring)
      md=s1.match(rgx_2)
      next if md==nil # the regex did not have any matches
      s2=md[0]
      ar_out<<s2
   end # loop
   return ar_out
end # ar_extract_process_ids

def kill_all_listed_processes(ar_stdin_lines)
   ar_process_ids=ar_extract_process_ids(ar_stdin_lines)
   cmd_prefix="kill -s 9 "
   s_lc_bq="`"
   s_lc_linebreak="\n"
   cmd=nil
   ar_process_ids.each do |s_process_id|
      cmd=s_lc_bq+cmd_prefix+s_process_id+s_lc_bq+s_lc_linebreak
      eval(cmd,binding())
   end # loop
end # kill_all_listed_processes

ar=$stdin.readlines
kill_all_listed_processes(ar)

#==========================================================================

