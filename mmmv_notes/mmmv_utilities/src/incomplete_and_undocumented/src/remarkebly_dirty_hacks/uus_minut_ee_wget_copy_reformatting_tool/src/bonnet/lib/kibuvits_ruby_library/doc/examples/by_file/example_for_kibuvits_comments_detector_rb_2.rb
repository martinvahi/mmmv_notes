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

s_language="ruby"
s_script=""+
  " # By changing the boolean parameter of the \n"+
  "    # Kibuvits_comments_detector.extract_commentstrings to true\n"+
  "# the oneliner comments that follow only spaces and tabs, \n"+
  "      # are packed to a single string.\n"+
  "a=1+1 # So, this line will be in a separate string.\n"+
  " # But these 2 lines \n"+
  "  # will be in a single string.\n"+
  "\n"+
  " # And this line will be in its private string again."

msgcs=Kibuvits_msgc_stack.new
ar_comments=Kibuvits_comments_detector.run(s_language,s_script,msgcs)
ar_commentstrings=Kibuvits_comments_detector.extract_commentstrings(
	ar_comments,true)

s=""
ar_commentstrings.each{|s_comment| s=s+"{"+s_comment+"}\n"}
puts s

=begin
 Expected console output:

{ By changing the boolean parameter of the
 Kibuvits_comments_detector.extract_commentstrings to true
 the oneliner comments that follow only spaces and tabs,
 are packed to a single string.}
{ So, this line will be in a separate string.}
{ But these 2 lines
 will be in a single string.}
{ And this line will be in its private string again.}

=end

