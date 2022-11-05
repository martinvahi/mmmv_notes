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
require  KIBUVITS_HOME+"/src/include/kibuvits_argv_parser.rb"

#==========================================================================

class Kibuvits_argv_parser_selftests

   def initialize
   end #initialize

   #private

   #-----------------------------------------------------------------------

   def Kibuvits_argv_parser_selftests.test_normalize_parsing_result
      ht_spec=Hash.new
      ht_spec['-f']=["--file"]
      ht_args=Hash.new
      ht_args['-f']=["f1","f2"]
      ht_args['--file']=["ff1","ff2"]
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(42,ht_args)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,42)}
         kibuvits_throw "test 2"
      end # if
      ht_args=Hash.new
      ht_args['-f']=["f1","f2"]
      ht_args['--file']=["ff1","ff2"]
      if kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 3"
      end # if
      ar_synonyms=ht_args['-f']
      ar_synonyms.sort! { |a, b| a<=>b }
      s=Kibuvits_str.array2xseparated_list(ar_synonyms,",")
      kibuvits_throw "test 4" if s!="f1,f2,ff1,ff2"
      ht_spec['-f']=["--nonexisting"]
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 5"
      end # if
      ht_spec[42]=["--file"]
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 6"
      end # if
      ht_args=Hash.new
      ht_spec['-f']=nil
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 7"
      end # if

      ht_spec=Hash.new
      ht_spec['-f']=["--file"]
      ht_args=Hash.new
      ht_args['-f']=["f1","f2","-f"]
      ht_args['--file']=["ff1","ff2"]
      if kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 8"
      end # if

      ht_spec=Hash.new
      ht_spec['-f']=["--file",42] # nonstring element
      ht_args=Hash.new
      ht_args['-f']=["f1","f2"]
      ht_args['--file']=["ff1","ff2"]
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 9"
      end # if

      ht_spec=Hash.new
      ht_spec['-f']=["--file"]
      ht_args=Hash.new
      ht_args['-f']=["f1","f2"]
      ht_args['--file']=["ff1","ff2",42] # nonstring element
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 10"
      end # if

      ht_spec=Hash.new
      ht_spec['-f']=["--file"]
      ht_args=Hash.new
      ht_args['-f']=["f1","f2"]
      ht_args['--file']=["ff1","ff2","ff1"] # duplicate ff1
      msgcs=Kibuvits_msgc_stack.new
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args,msgcs)}
         kibuvits_throw "test 11"
      end # if

      ht_spec=Hash.new
      ht_spec['-f']=["--file"]
      ht_args=Hash.new
      ht_args['-f']=["f1","f2","f2"] # duplicate f2
      ht_args['--file']=["ff1","ff2"]
      if !kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 12"
      end # if

      ht_spec=Hash.new
      ht_spec['-f']=["--file"]
      ht_args=Hash.new
      ht_args['-f']=["f1","f2","ff1"] # ff1 in 2 arrays
      ht_args['--file']=["ff1","ff2"]
      if kibuvits_block_throws {Kibuvits_argv_parser.normalize_parsing_result(ht_spec,ht_args)}
         kibuvits_throw "test 13"
      end # if
   end # Kibuvits_argv_parser_selftests.test_normalize_parsing_result


   #-----------------------------------------------------------------------

   def Kibuvits_argv_parser_selftests.test_preparations
      if defined? KIBUVITS_HOME
         require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
      else
         require  "kibuvits_shell.rb"
      end # if
   end # Kibuvits_argv_parser_selftests.test_preparations

   def Kibuvits_argv_parser_selftests.test_ar
      msgcs=Kibuvits_msgc_stack.new
      ar=["-a", "b","ccc"]
      ht_grammar=Hash.new
      ht_grammar["-a"]=2
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 1" if msgcs.b_failure
      ar=["-a", "b","ccc","extra"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 2" if !msgcs.b_failure
      kibuvits_throw "test 3" if msgcs[0].s_message_id!=3.to_s
      ar=["b","-ccc","extra"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 4" if !msgcs.b_failure
      kibuvits_throw "test 5" if msgcs[0].s_message_id!=2.to_s
      ar=["-a=a1","ccc","-b","b1"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 6" if !msgcs.b_failure
      kibuvits_throw "test 7" if msgcs[0].s_message_id!=1.to_s
      ht_grammar["-b"]=1
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 8" if msgcs.b_failure
      # a small gap: test 9
      ar=["-a=a1","\\-ax","-b=44"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 10" if msgcs.b_failure
      # a small gap: test 11
      kibuvits_throw "test 12" if (ht_args['-a'])[1]!="-ax"
      ar=["-a=a1","-b=44"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 13" if !msgcs.b_failure
      kibuvits_throw "test 14" if msgcs[0].s_message_id!=4.to_s
      ht_grammar["-c"]=0
      ar=["-a=a1","a2","-b=b1","-c"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 15" if msgcs.b_failure
      ar=["-a=a1","a2","-b=b1","-c=c1"]
      ht_grammar["-c"]=(-1)
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 16" if msgcs.b_failure
      ar=["-a=a1","a2","-c","-b=b1"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 17" if msgcs.b_failure
      ar=["-a=a1","a2","-c=c1","c2","c3","-b=b1"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 18" if msgcs.b_failure
      s=""
      ht_args['-c'].each{|x| s=s+x}
      kibuvits_throw "test 19" if s!="c1c2c3"
      ar=["-a=a1","a2","-c","-b=b1","-c"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 20" if !msgcs.b_failure
      kibuvits_throw "test 21" if msgcs[0].s_message_id!=5.to_s
      ht_grammar=Hash.new
      ht_grammar["-a"]=1
      ar=["-a"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 22" if !msgcs.b_failure
      kibuvits_throw "test 23" if msgcs[0].s_message_id!=4.to_s
      ar=["-a=a1"]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 24" if msgcs.b_failure
      # a small gap: test 25
      kibuvits_throw "test 26" if (ht_args["-a"]).class!=Array
      kibuvits_throw "test 27" if (ht_args["-a"])[0]!="a1"
      ht_grammar["-b"]=0
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 28" if msgcs.b_failure
      # a small gap: test 29
      kibuvits_throw "test 30" if (ht_args["-b"]).class!=NilClass
      ar=Array.new
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 31" if msgcs.b_failure
      # a small gap: test 32
      ar<<""
      if !kibuvits_block_throws {ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)}
         kibuvits_throw "test 33"
      end # if
      ar=[4]
      msgcs.clear
      ht_args=Kibuvits_argv_parser.run(ht_grammar,ar,msgcs)
      kibuvits_throw "test 34" if !msgcs.b_failure
      kibuvits_throw "test 35" if msgcs[0].s_message_id!=6.to_s
   end # Kibuvits_argv_parser_selftests.test_ar

   #-----------------------------------------------------------------------

   def Kibuvits_argv_parser_selftests.test_console
      s_script=""+
      'if !defined? KIBUVITS_HOME'+"\n"+
      '    KIBUVITS_HOME="'+KIBUVITS_HOME+'"'+"\n"+
      'end # if'+"\n"+
      'require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"'+"\n"+
      'require  KIBUVITS_HOME+"/src/include/kibuvits_argv_parser.rb"'+"\n"+
      "\n"+
      'msgcs=Kibuvits_msgc_stack.new'+"\n"+
      'ht_grammar=Hash.new'+"\n"+
      'ht_grammar["-a"]=(-1)'+"\n"+
      'ht_grammar["-b"]=1'+"\n"+
      'ht_grammar["-c"]=0'+"\n"+
      'ht_args=Kibuvits_argv_parser.run(ht_grammar,ARGV,msgcs)'+"\n"+
      'kibuvits_throw msgc.to_s if msgcs.b_failure'+"\n"+
      's=""'+"\n"+
      'ht_args["-a"].each{|x|s=s+x}'+"\n"+
      'ht_args["-b"].each{|x|s=s+x}'+"\n"+
      'puts s'+"\n"

      s_fp_script=Kibuvits_os_codelets.instance.generate_tmp_file_absolute_path
      str2file(s_script,s_fp_script)
      if !File.exist? s_fp_script # OK to throw before file deletion
         kibuvits_throw "console test 1"
      end # if
      cmd="KIBUVITS_HOME="+KIBUVITS_HOME+"   "+
      KIBUVITS_s_CMD_RUBY+" "+s_fp_script+" -a a1 a2\\ a3 -b b1  -c "
      ht=nil
      begin
         ht=kibuvits_sh(cmd)
      rescue Exception => e
      end # rescue
      File.delete s_fp_script # before throwing anything
      s=ht[$kibuvits_lc_s_stderr]
      kibuvits_throw "console test 3 s=="+s.to_s if 2<s.gsub(/[\n]/,"").length
      s=ht[$kibuvits_lc_s_stdout]
      kibuvits_throw "console test 4 s=="+s.to_s if s.gsub(/[\n]/,"")!="a1a2 a3b1"
   end # Kibuvits_argv_parser_selftests.test_console

   #-----------------------------------------------------------------------

   def  Kibuvits_argv_parser_selftests.test_verify_parsed_input
      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x"]
      ht_args['-g']=[]
      ht_args['-s']=["aa","bb"]
      msgcs=Kibuvits_msgc_stack.new

      msgcs.clear
      if kibuvits_block_throws {Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)}
         kibuvits_throw "test 1"
      end # if
      kibuvits_throw "test 1.1" if msgcs.b_failure

      msgcs.clear
      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_parsed_input(42,ht_args,msgcs)}
         kibuvits_throw "test 2"
      end # if

      msgcs.clear
      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_parsed_input(ht_grammar,42,msgcs)}
         kibuvits_throw "test 3"
      end # if

      msgcs.clear
      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,42)}
         kibuvits_throw "test 4"
      end # if

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x","xx","xxx"]
      ht_args['-g']=[]
      ht_args['-s']=["aa","bb"]
      msgcs.clear
      Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 5" if msgcs.b_failure

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x","xx","xxx"]
      ht_args['-g']=nil # args are optional
      ht_args['-s']=["aa","bb"]
      msgcs.clear
      Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 6" if msgcs.b_failure

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x","xx","xxx"]
      ht_args['-g']=['xx'] # expected to be nil or []
      ht_args['-s']=["aa","bb"]
      msgcs.clear
      Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 8" if !msgcs.b_failure
      kibuvits_throw "test 9" if msgcs.last.s_message_id!=1.to_s

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=[] # test-region
      ht_args['-g']=[]
      ht_args['-s']=["aa","bb"]
      msgcs.clear
      Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 10" if !msgcs.b_failure
      kibuvits_throw "test 11" if msgcs.last.s_message_id!=2.to_s

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x","xx","xxx"]
      ht_args['-g']=[]
      ht_args['-s']=["aa","bb","ccEXTRA"] # test-region
      msgcs.clear
      Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 12" if !msgcs.b_failure
      kibuvits_throw "test 13" if msgcs.last.s_message_id!=3.to_s

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x","xx","xxx"]
      ht_args['-g']=[]
      ht_args['-s']=["aa"] # test-region
      msgcs.clear
      Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 14" if !msgcs.b_failure
      kibuvits_throw "test 15" if msgcs.last.s_message_id!=3.to_s

      ht_grammar=Hash.new
      ht_grammar['-f']=(-1)
      ht_grammar['-g']=0
      ht_grammar['-s']=2
      ht_args=Hash.new
      ht_args['-f']=["x","xx","xxx"]
      #ht_args['-g']=[]# test-region: '-g' is missing from ht_arg keys.
      ht_args['-s']=["aa","ff"]
      msgcs.clear
      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_parsed_input(ht_grammar,ht_args,msgcs)}
         kibuvits_throw "test 16"
      end # if
   end # Kibuvits_argv_parser_selftests.test_verify_parsed_input

   #-----------------------------------------------------------------------

   def Kibuvits_argv_parser_selftests.test_verify_compulsory_input
      msgcs=Kibuvits_msgc_stack.new
      ht_grammar=Hash.new
      s_key='-f'
      ht_grammar[s_key]=(-1)
      ht_args=Hash.new
      ht_args[s_key]=["aa"]

      msgcs.clear
      if kibuvits_block_throws {Kibuvits_argv_parser.verify_compulsory_input(s_key,ht_grammar,ht_args,msgcs)}
         kibuvits_throw "test 1"
      end # if
      kibuvits_throw "test 1.1" if msgcs.b_failure

      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_compulsory_input(42,ht_grammar,ht_args,msgcs)}
         kibuvits_throw "test 2"
      end # if
      kibuvits_throw "test 2.2" if msgcs.b_failure

      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_compulsory_input(s_key,42,ht_args,msgcs)}
         kibuvits_throw "test 3"
      end # if
      kibuvits_throw "test 3.3" if msgcs.b_failure

      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_compulsory_input(s_key,ht_grammar,42,msgcs)}
         kibuvits_throw "test 4"
      end # if
      kibuvits_throw "test 4.4" if msgcs.b_failure

      if !kibuvits_block_throws {Kibuvits_argv_parser.verify_compulsory_input(s_key,ht_grammar,ht_args,42)}
         kibuvits_throw "test 5"
      end # if
      kibuvits_throw "test 5.5" if msgcs.b_failure

      msgcs.clear
      ht_grammar=Hash.new
      s_key='-f'
      ht_grammar[s_key]=0
      ht_args=Hash.new
      ht_args[s_key]=["aa"]
      Kibuvits_argv_parser.verify_compulsory_input(
      s_key,ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 6" if !msgcs.b_failure

      msgcs.clear
      ht_grammar=Hash.new
      s_key='-f'
      ht_grammar[s_key]=0
      ht_args=Hash.new
      ht_args[s_key]=nil
      Kibuvits_argv_parser.verify_compulsory_input(
      s_key,ht_grammar,ht_args,msgcs)
      kibuvits_throw "test 7" if !msgcs.b_failure
      kibuvits_throw "test 8" if msgcs.last.s_message_id!=4.to_s

   end # Kibuvits_argv_parser_selftests.test_verify_compulsory_input

   #-----------------------------------------------------------------------

   public
   include Singleton
   def Kibuvits_argv_parser_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_argv_parser_selftests.test_preparations"
      kibuvits_testeval bn, "Kibuvits_argv_parser_selftests.test_ar"
      kibuvits_testeval bn, "Kibuvits_argv_parser_selftests.test_console"
      kibuvits_testeval bn, "Kibuvits_argv_parser_selftests.test_normalize_parsing_result"
      kibuvits_testeval bn, "Kibuvits_argv_parser_selftests.test_verify_parsed_input"
      kibuvits_testeval bn, "Kibuvits_argv_parser_selftests.test_verify_compulsory_input"
      return ar_msgs
   end # Kibuvits_argv_parser_selftests.selftest

end # class Kibuvits_argv_parser_selftests

#--------------------------------------------------------------------------

#==========================================================================

#Kibuvits_argv_parser_selftests.test_preparations
#Kibuvits_argv_parser_selftests.test_ar
#Kibuvits_argv_parser_selftests.test_console

