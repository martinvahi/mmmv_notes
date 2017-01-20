#!/usr/bin/env ruby 
#=========================================================================
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
#=========================================================================
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_fs.rb"
end # if
require "singleton"
#==========================================================================

# The class Kibuvits_file_intelligence is for various
# meta-data like cases, like infering file format by
# its extension, etc.
class Kibuvits_file_intelligence

   def initialize
   end # initialize

   # Returns a string.
   def file_language_by_file_extension s_file_path, msgcs
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ar_tokens=Kibuvits_str.bisect(s_file_path.reverse, '.')
      s_file_extension=ar_tokens[0].reverse.downcase
      s_file_language="undetermined"
      case s_file_extension
      when "js"
         s_file_language="JavaScript"
      when "rb"
         s_file_language="Ruby"
      when "php"
         s_file_language="PHP"
      when "h"
         s_file_language="C"
      when "hpp"
         s_file_language="C++"
      when "c"
         s_file_language="C"
      when "cpp"
         s_file_language="C++"
      when "hs"
         s_file_language="Haskell"
      when "java"
         s_file_language="Java"
      when "scala"
         s_file_language="Scala"
      when "html"
         s_file_language="HTML"
      when "xml"
         s_file_language="XML"
      else
         msgcs.cre "Either the file extension is not supported or "+
         "the file extension extraction failed. File extension "+
         "candidate is:"+s_file_extension, 1.to_s
         msgcs.last["Estonian"]="Faililaiend on kas toetamata või ei õnnestunud "+
         "faililaiendit eraldada. Faililaiendi kandidaat on:"+s_file_extension
      end # case
      return s_file_language
   end # file_language_by_file_extension

   def Kibuvits_file_intelligence.file_language_by_file_extension(
      s_file_path, msgcs)
      s_file_language=Kibuvits_file_intelligence.instance.file_language_by_file_extension(
      s_file_path, msgcs)
      return s_file_language
   end # Kibuvits_file_intelligence.file_language_by_file_extension

   private
   def Kibuvits_file_intelligence.test_file_language_by_file_extension
      msgcs=Kibuvits_msgc_stack.new
      if kibuvits_block_throws{Kibuvits_file_intelligence.file_language_by_file_extension("./x.rb",msgcs)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_file_intelligence.file_language_by_file_extension(42,msgcs)}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_file_intelligence.file_language_by_file_extension("./x.rb",42)}
         kibuvits_throw "test 3"
      end # if
      msgcs.clear
      s=Kibuvits_file_intelligence.file_language_by_file_extension(
      "./x.rb",msgcs)
      kibuvits_throw "test 4" if msgcs.b_failure
      kibuvits_throw "test 5" if s.downcase!="ruby".downcase
   end # Kibuvits_file_intelligence.test_file_language_by_file_extension

   public
   include Singleton
   def Kibuvits_file_intelligence.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_file_intelligence.test_file_language_by_file_extension"
      return ar_msgs
   end # Kibuvits_file_intelligence.selftest

end # class Kibuvits_file_intelligence

#==========================================================================
