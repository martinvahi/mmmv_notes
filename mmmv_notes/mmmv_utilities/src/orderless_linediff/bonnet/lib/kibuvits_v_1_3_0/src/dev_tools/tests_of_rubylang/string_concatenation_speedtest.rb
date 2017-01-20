#!/opt/ruby/bin/ruby -Ku
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/BSD-3-Clause
=end
#==========================================================================

class Kibuvits_rubylangtest_string_concatenation_speedtest
   def initialize
      @s_lc_token="_a_token_"
   end # initialize

   def concact_by_plain_loop n
      s_out=""
      n.times{s_out=s_out+@s_lc_token}
      return s_out
   end # concact_by_plain_loop

   def concact_by_watershed n
      i_reminder=n%2
      i_loop=n.div(2)
      s_1=""
      i_loop.times{s_1=s_1+@s_lc_token}
      s_2=""
      i_loop.times{s_2=s_2+@s_lc_token}
      s_2=s_2+@s_lc_token if i_reminder==1
      s_out=s_1+s_2
      return s_out
   end # concact_by_watershed

end # class Kibuvits_rubylangtest_string_concatenation_speedtest

ob_speedtest=Kibuvits_rubylangtest_string_concatenation_speedtest.new
kibuvits_throw "\n\nConsole arguments: n, [whatever] \n\n" if ARGV.length==0
n=ARGV[0].to_i
b_watershed=false
b_watershed=true if 1<ARGV.length
if b_watershed
   puts "Using the watershed concatenation."
   s=ob_speedtest.concact_by_watershed(n)
   puts s[0..0]+s.length.to_s
else
   puts "Using the plain loop concatenation."
   s=ob_speedtest.concact_by_plain_loop(n)
   puts s[0..0]+s.length.to_s
end # if

# Conclusion is that the time spent by the watershed
# version is about 50% of the time spent by the plain version.

