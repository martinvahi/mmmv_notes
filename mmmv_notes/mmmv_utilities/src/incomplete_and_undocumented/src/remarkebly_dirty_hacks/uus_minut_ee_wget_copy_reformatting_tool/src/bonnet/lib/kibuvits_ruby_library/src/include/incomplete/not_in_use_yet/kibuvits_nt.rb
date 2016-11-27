#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ix.rb"
end # if
require "singleton"
require "bigdecimal"
#==========================================================================

# The class Kibuvits_nt is a namespace for functions that
# perform numeric type conversions and some basic math operations.
class Kibuvits_nt
   def initialize
   end #initialize

# Converts the value to BigDecimal
def to_bigfd s_or_i_or_fd_or_BigDecimal
      bn=binding()
      kibuvits_typecheck bn, [Float,Fixnum,String,BigDecimal], s_or_i_or_fd_or_BigDecimal
end # to_bigfd  


   public
   include Singleton
   def Kibuvits_nt.selftest
	  ar_msgs=Array.new
	  bn=binding()
	  #kibuvits_testeval bn, "Kibuvits_nt.test_sar"
	  return ar_msgs
   end # Kibuvits_nt.selftest
end # class Kibuvits_nt
#=========================================================================
