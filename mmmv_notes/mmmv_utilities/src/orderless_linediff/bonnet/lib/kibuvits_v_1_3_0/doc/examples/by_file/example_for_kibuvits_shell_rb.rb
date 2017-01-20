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

require  KIBUVITS_HOME+'/include/kibuvits_shell.rb'

a_shell_script="dir"
ht_stdstreams=sh(a_shell_script)
s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
puts s_stdout

