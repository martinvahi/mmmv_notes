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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "rubygems"
require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_argv_parser.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_finite_sets.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ix.rb"
   require  "kibuvits_io.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_argv_parser.rb"
   require  "kibuvits_finite_sets.rb"
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
      s_f1,s_f2=parse_console()
      s_1=file2str(s_f1)
      s_2=file2str(s_f2)
      ht_1=string_lines_2_ht_keys(s_1)
      ht_2=string_lines_2_ht_keys(s_2)

      puts "\nLines that are in \""+s_f1+"\", but that are missing from the \""+s_f2+"\":"
      ht_diff=Kibuvits_finite_sets.difference(ht_1,ht_2)
      puts ht_of_lines_2_str(ht_diff)

      puts "\nLines that are in \""+s_f2+"\", but that are missing from the \""+s_f1+"\":"
      ht_diff=Kibuvits_finite_sets.difference(ht_2,ht_1)
      puts ht_of_lines_2_str(ht_diff)
      puts "\n\n"
   end # run

   private
   def parse_console
      msgcs=Kibuvits_msgc_stack.new
      ht_grammar=Hash.new
      ht_grammar["-f"]=2
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ARGV,msgcs)
      throw msgcs.to_s if msgcs.b_failure
      ar=ht_args["-f"]
      s_f1=ar[0]
      s_f2=ar[1]
      return s_f1,s_f2
   end # parse_console

   def ht_of_lines_2_str ht_of_lines
      s_out=""
      ht_of_lines.each_key{|s_line| s_out=s_out+"\n"+s_line}
      return s_out
   end # print_2_console

   def string_lines_2_ht_keys s_in
      ht=Hash.new
      s=nil
      s_in.each_line do |s_line|
         s=Kibuvits_str.trim(s_line.gsub(/[\n\r]/,@@lc_s_emptystring))
         ht[s]=s
      end # loop
      return ht
   end #  string_lines_2_ht_keys

end # class Orderless_linediff
#--------------------------------------------------------------------------
Orderless_linediff.new.run

