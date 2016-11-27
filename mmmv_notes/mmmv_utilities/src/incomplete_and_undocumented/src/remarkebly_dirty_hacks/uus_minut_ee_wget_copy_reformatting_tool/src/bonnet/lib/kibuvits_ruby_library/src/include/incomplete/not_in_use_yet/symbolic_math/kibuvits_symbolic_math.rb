#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_formula.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_formula.rb"
   require  "kibuvits_str.rb"
   require  "kibuvits_ix.rb"
end # if
#==========================================================================

# The class Kibuvits_symbolic_math is a normalized frontend
# to math applications. The idea is that it's truly laborous to
# re-write the various math routines that took professional mathematicians
# for decades to write. One relies on a mixture of
# math software that others have written.
class Kibuvits_symbolic_math
   attr_reader :s_backend_mode

   def assert_backend_mode s_mode
      s_commaseparated_list_of_supported_modes="REDUCE"
      ht=Kibuvits_str.commaseparated_list_2_ht(
      s_commaseparated_list_of_supported_modes)
      if(!ht.has_key?)
         kibuvits_throw "Backend mode \""+s_mode+"\" is not supported. "+
         "The currently supported modes are: "+
         s_commaseparated_list_of_supported_modes
      end # if
   end # assert_backend_mode

   # Backends are sets of math applications. For example, one might find
   # it easyer or otherwise beneficial to use one math application for one task and
   # an other math application for another task. There might be differences
   # in loading time, etc.
   #
   # Compatibility between different modes is not guaranteed, because
   # math evolves and the math objects can depend on the branch of mathematics.
   # This explanes, why one might beed multiple instances of this class in
   # an application.
   #
   # Supported backend modes: REDUCE
   #
   def initialize s_backend_mode
      bn=binding()
      kibuvits_typecheck bn, String, s_backend_mode
      assert_backend_mode(s_backend_mode)
      @s_backend_mode=s_backend_mode
   end #initialize

   public
   def Kibuvits_symbolic_math.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_symbolic_math.test_sar"
      return ar_msgs
   end # Kibuvits_symbolic_math.selftest

end # class Kibuvits_symbolic_math


#=========================================================================
