#!/usr/bin/env ruby
=begin
 Copyright 2010, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/bsd-license.php
=end
#==========================================================================
#--- start of a distracting hack to keep this example working -------------
if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   require(ob_pth_0.parent.parent.parent.parent.to_s+
   "/src/include/kibuvits_boot.rb")
end # if
require  KIBUVITS_HOME+"/src/include/kibuvits_all.rb"
#----------end of the distracting hack ------------------------------------

require  KIBUVITS_HOME+'/src/include/kibuvits_comments_detector.rb'


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

