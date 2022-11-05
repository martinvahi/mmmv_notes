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
   require "pathname"
   ob_pth=Pathname.new(__FILE__).realpath.parent.parent
   KIBUVITS_HOME=(ob_pth.to_s+"/bonnet/lib/kibuvits_v_1_3_0").freeze
   ob_pth=nil;
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_argv_parser.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_finite_sets.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str_concat_array_of_strings.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ix.rb"
   require  "kibuvits_io.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_argv_parser.rb"
   require  "kibuvits_finite_sets.rb"
   require  "kibuvits_str_concat_array_of_strings.rb"
end # if

#==========================================================================

class Orderless_linediff
   @@lc_doublequote="\""
   @@lc_linebreak="\n"
   @@lc_s_emptystring=""
   @@lc_s_underscore="_"
   @@lc_s_space=" "

   def initialize
   end # initialize

   def run
      ht_opmem=Hash.new
      s_f1,s_f2=parse_console(ht_opmem)
      s_1=file2str(s_f1)
      s_2=file2str(s_f2)
      ht_1=string_lines_2_ht_keys(s_1)
      ht_2=string_lines_2_ht_keys(s_2)

      puts("\nLines that are in the \n    "+s_f1+
      "\n, but that are missing from the \n    "+s_f2+"\n:")
      ht_diff=Kibuvits_finite_sets.difference(ht_1,ht_2)
      puts ht_of_lines_2_str(ht_opmem,ht_diff)

      puts("\nLines that are in the \n    "+s_f2+
      "\n, but that are missing from the \n    "+s_f1+"\n:")
      ht_diff=Kibuvits_finite_sets.difference(ht_2,ht_1)
      puts ht_of_lines_2_str(ht_opmem,ht_diff)
      puts "\n\n"
   end # run


   private

   def exc_assert_ARGV_legnth(ht_opmem)
      b_throw=false
      if ARGV.size!=3 then
         if ARGV.size!=5 then
            b_throw=true
         end # if
      end # if
      if b_throw
         raise(Exception.new("\n\n"+
         "Wrong number of console arguments. Expected:\n"+
         "\n"+
         "    -f <path to file 1> <path to file 2> (--sb_sort <t/f>)? \n"+
         "\n"+
         "GUID=='23db7095-ffa7-4475-9443-22a1905091e7'\n"))
      end # if
   end # exc_assert_ARGV_legnth


   def parse_console(ht_opmem)
      exc_assert_ARGV_legnth(ht_opmem)
      #----
      msgcs=Kibuvits_msgc_stack.new
      ht_grammar=Hash.new
      ht_grammar["-f"]=2
      ht_grammar["--sb_sort"]=1
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ARGV,msgcs)
      throw Exception.new("\n\n"+msgcs.to_s+"\n\n") if msgcs.b_failure
      #-------------------
      ar=ht_args["--sb_sort"]
      b_sort=true
      if ar!=nil
         if ar.size!=1 then
            raise(Exception.new("\n\n"+
            "The code is flawed. The console arguments parsing code \n"+
            "shold have caught that error.\n"+
            "GUID=='4150f931-1acf-4b98-8523-22a1905091e7'\n"))
         end # if
         s=ar[0].to_s
         if s!="t"
            if s!="f"
               raise(Exception.new("\n\n"+
               "The only valid values for the --sb_sort are: t,f \n"+
               "\n"+
               "Received value: "+s+" \n"+
               "\n"+
               "GUID=='5bbeec22-6b0e-4be4-8513-22a1905091e7'\n"))
            end # if
            b_sort=false
         else
            b_sort=true
         end # if
      end # if
      ht_opmem["b_sort"]=b_sort
      #-------------------
      ar=ht_args["-f"]
      s_f1=ar[0]
      s_f2=ar[1]
      return s_f1,s_f2
   end # parse_console

   def ht_of_lines_2_str(ht_opmem,ht_of_lines)
      b_sort=ht_opmem["b_sort"]
      ar_keys=ht_of_lines.keys
      ar_keys.sort! if b_sort
      #----
      ar_s=Array.new
      ar_keys.each do |s_line|
         ar_s<<("\n"+s_line)
      end # loop
      s_out=kibuvits_s_concat_array_of_strings(ar_s)
      return s_out
   end # print_2_console

   def string_lines_2_ht_keys s_in
      ht=Hash.new
      s=nil
      rgx_0=/[\n\r]/
      s_in.each_line do |s_line|
         s=Kibuvits_str.trim(s_line.gsub(rgx_0,@@lc_s_emptystring))
         ht[s]=s
      end # loop
      return ht
   end #  string_lines_2_ht_keys

end # class Orderless_linediff
#--------------------------------------------------------------------------
Orderless_linediff.new.run


