#!/opt/ruby/bin/ruby -Ku
=begin
 Copyright 2010, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/bsd-license.php
=end
#==========================================================================
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   if x==nil or x==""
      puts "\nEnvironment variable named KIBUVITS_HOME is \n"+
      "either unset or not defined.\n"
      exit
   end # if
   KIBUVITS_HOME=x # The x is due to IDE code browser
end # if
#==========================================================================

require  KIBUVITS_HOME+'/include/kibuvits_comments_detector.rb'


s_language="c++"
s_script=" "+
  "s=\"A C++ string with a stringmark.\\\" //doesn't confuse\"; // oneliner1\n"+
  "  // Oneliner comment number 2 \n"+
  "  /* multiline comments  \n"+
  " are also supported */ i++; // Oneliner #3 \n"+
  " /* multiliner2 */ o++; s=\"/* a fake comment start\" /*multiliner3*/ \n"+
  " s=\"Quotation mark not escaped in cpp string \\\\\" //\" Oneliner #4 "


msgcs=Kibuvits_msgc_stack.new
ar_comments=Kibuvits_comments_detector.run(s_language,s_script,msgcs)
ar_commentstrings=Kibuvits_comments_detector.extract_commentstrings(
	ar_comments,false)

s=""
ar_commentstrings.each{|s_comment| s=s+"{"+s_comment+"}\n"}
puts s

=begin
 Expected console output:

{ oneliner1}
{ Oneliner comment number 2 }
{ multiline comments
 are also supported }
{ Oneliner #3 }
{ multiliner2 }
{multiliner3}
{" Oneliner #4 }

=end

