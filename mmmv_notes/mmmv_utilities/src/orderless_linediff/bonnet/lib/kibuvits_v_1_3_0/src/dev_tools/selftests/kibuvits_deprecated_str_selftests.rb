#!/opt/ruby/bin/ruby -Ku
#==========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str_concat_array_of_strings.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_io.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_msgc.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_str_concat_array_of_strings.rb"
   require  "kibuvits_io.rb"
end # if
#==========================================================================

class Kibuvits_deprecated_str_selftests

   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_deprecated_str_selftests.test_configstylestr_2_ht
      if !kibuvits_block_throws{ Kibuvits_deprecated_str.configstylestr_2_ht(42)}
         kibuvits_throw "test 1"
      end # if
      msgcs=Kibuvits_msgc_stack.new

      msgcs.clear
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht("a b=44",msgcs)
      kibuvits_throw "test 2" if !msgcs.b_failure
      kibuvits_throw "test 2.1" if msgcs.last.s_message_id!=4.to_s

      msgcs.clear
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht("=44",msgcs)
      kibuvits_throw "test 3" if !msgcs.b_failure
      kibuvits_throw "test 3.1" if msgcs.last.s_message_id!=3.to_s

      msgcs.clear
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(" =44",msgcs)
      kibuvits_throw "test 4" if !msgcs.b_failure
      kibuvits_throw "test 4.1" if msgcs.last.s_message_id!=3.to_s

      msgcs.clear
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(" = 44 ",msgcs)
      kibuvits_throw "test 5" if !msgcs.b_failure
      kibuvits_throw "test 5.1" if msgcs.last.s_message_id!=3.to_s

      msgcs.clear
      s_heredoc=" a value"
      s="x=HEREDOC\n"+
      s_heredoc+"\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 6" if msgcs.b_failure
      kibuvits_throw "test 6.2" if ht_vars['x']!=s_heredoc

      msgcs.clear
      s="x=HEREDOC 4 4\n"+
      "a value\n"+
      "4 4"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 7" if !msgcs.b_failure
      kibuvits_throw "test 7.1" if msgcs.last.s_message_id!=8.to_s

      msgcs.clear
      s="x=HEREDOC42\n"+
      "a value\n"+
      "42"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 8" if msgcs.b_failure
      kibuvits_throw "test 8.1" if ht_vars["x"]!="HEREDOC42"

      msgcs.clear
      s="x=HEREDOC 42\n"+
      "a value\n"+
      "42"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 9" if msgcs.b_failure
      kibuvits_throw "test 9.2" if ht_vars['x']!="a value"

      s="xii = v 1 "
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 10" if msgcs.b_failure
      kibuvits_throw "test 11" if ht_vars['xii']!="v 1"

      msgcs.clear
      s_heredoc="  line1\nline2"
      s="x=HEREDOC\n"+
      s_heredoc+"\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 12" if msgcs.b_failure
      kibuvits_throw "test 13" if ht_vars['x']!=s_heredoc

      msgcs.clear
      s_heredoc="  \\=xx"
      s="x=HEREDOC\n"+
      s_heredoc+"\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 14" if msgcs.b_failure
      kibuvits_throw "test 15" if ht_vars['x']!=s_heredoc

      msgcs.clear
      s_heredoc="  \\=xx"
      s=" This line is a comment\n"+
      "x=HEREDOC\n"+
      s_heredoc+"\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 16 " if msgcs.b_failure
      kibuvits_throw "test 17" if ht_vars['x']!=s_heredoc

      msgcs.clear
      s_heredoc="  \\=xx"
      s="The equals signs (\\=) have to be escaped\n"+
      "at comment lines. \n"+
      "x=HEREDOC\n"+
      s_heredoc+"\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 18" if msgcs.b_failure
      kibuvits_throw "test 19" if ht_vars['x']!=s_heredoc

      msgcs.clear
      s="The equals signs following line must not give a failure:\n"+
      "x= \\= something"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 20" if msgcs.b_failure

      msgcs.clear
      s="The equals signs following line must give a failure:\n"+
      " \\= x= something"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 21" if !msgcs.b_failure
      kibuvits_throw "test 21.1" if msgcs.last.s_message_id!=10.to_s

      msgcs.clear
      s="The equals signs following line must not give a failure:\n"+
      "x=(y=z)"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 22" if msgcs.b_failure
      kibuvits_throw "test 22.1" if ht_vars["x"]!="(y=z)"

      msgcs.clear
      s_heredoc="x=(y=z)"
      s="x=HEREDOC\n"+
      s_heredoc+"\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 23" if msgcs.b_failure
      kibuvits_throw "test 24" if ht_vars['x']!=s_heredoc

      msgcs.clear
      s="\n\n\n\n"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 25" if msgcs.b_failure
      kibuvits_throw "test 25.2" if ht_vars.length!=0

      msgcs.clear
      s=""
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 26" if msgcs.b_failure

      msgcs.clear
      s="HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 27" if msgcs.b_failure

      msgcs.clear
      s_heredoc=" An end is missing."
      s="x=HEREDOC\n"+
      s_heredoc
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 28" if !msgcs.b_failure
      kibuvits_throw "test 28.1" if msgcs.last.s_message_id!=9.to_s

      msgcs.clear
      s=""
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 29" if msgcs.b_failure

      msgcs.clear
      s="x=4\n"+
      "x=42"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 30" if !msgcs.b_failure
      kibuvits_throw "test 30.1" if msgcs.last.s_message_id!=5.to_s

      msgcs.clear
      s="x= "
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 31" if !msgcs.b_failure
      kibuvits_throw "test 31.1" if msgcs.last.s_message_id!=6.to_s

      msgcs.clear
      s="x=   HEREDOC  Ehee \n"+
      "WoWx\n"+
      "Ehee"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 32" if msgcs.b_failure
      kibuvits_throw "test 32.1" if ht_vars["x"]!="WoWx"

      msgcs.clear
      s="x=   HEREDOC \n"+
      "x2=45\n"+
      "HEREDOC_END"
      ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s,msgcs)
      kibuvits_throw "test 33" if msgcs.b_failure
      kibuvits_throw "test 33.1" if !ht_vars.has_key? "x"
      s_1=ht_vars["x"].to_s
      kibuvits_throw "test 33.2 ht_vars[\"x\"]=="+s_1 if s_1!="x2=45"
      kibuvits_throw "test 33.3" if ht_vars.has_key? "x2"
   end # Kibuvits_deprecated_str_selftests.test_configstylestr_2_ht

   #-----------------------------------------------------------------------

   def Kibuvits_deprecated_str_selftests.test_configstylestr_2_ht_docverif
      msgcs=Kibuvits_msgc_stack.new
      s_haystack=file2str(__FILE__)
      s_start="-the-start-of-the-configstylestr_2_ht-usage-example-DO-NOT-CHANGE-THIS-LINE"
      s_demovar_0="A value"
      s_end="-the-end---of-the-configstylestr_2_ht-usage-example-DO-NOT-CHANGE-THIS-LINE"
      s_hay,ht_out=Kibuvits_str.pick_by_instance(s_start,s_end,s_haystack,msgcs)
      kibuvits_throw "test 1, msgcs.last.to_s=="+msgcs.last.to_s if msgcs.b_failure
      ar_keys=ht_out.keys
      i=ar_keys.size
      kibuvits_throw "test 2, ar_keys.size=="+i.to_s if i!=1 # 1 === one block of text
      s_extracted=ht_out[ar_keys[0]]
      ht_vars=nil
      begin
         ht_vars=Kibuvits_deprecated_str.configstylestr_2_ht(s_extracted,msgcs)
      rescue Exception => e
         kibuvits_throw "test 3, e.to_s=="+e.to_s
      end # rescue
      i=ht_vars.keys.size
      kibuvits_throw "test 3a, ht_vars.keys.size=="+i.to_s if i!=2 # 2 === 2 variables
      kibuvits_throw "test 4, msgcs.last.to_s=="+msgcs.last.to_s if msgcs.b_failure

      s_varname="s_end"
      kibuvits_throw "test 5" if !ht_vars.has_key? s_varname
      s_varvalue=ht_vars[s_varname]
      if s_varvalue!="\""
         kibuvits_throw "test 5.1 s_varvalue=="+s_varvalue
      end # if

      s_varname="s_demovar_0"
      kibuvits_throw "test 6" if !ht_vars.has_key? s_varname
      s_varvalue=ht_vars[s_varname]
      if s_varvalue!=($kibuvits_lc_doublequote+s_demovar_0+$kibuvits_lc_doublequote)
         kibuvits_throw "test 6.1 s_varvalue=="+s_varvalue
      end # if
   end # Kibuvits_deprecated_str_selftests.test_configstylestr_2_ht_docverif

   #-----------------------------------------------------------------------

   public
   include Singleton
   def Kibuvits_deprecated_str_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_deprecated_str_selftests.test_configstylestr_2_ht"
      kibuvits_testeval bn, "Kibuvits_deprecated_str_selftests.test_configstylestr_2_ht_docverif"
      return ar_msgs
   end # Kibuvits_deprecated_str_selftests.selftest

end # class Kibuvits_deprecated_str_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_deprecated_str_selftests.selftest.to_s

