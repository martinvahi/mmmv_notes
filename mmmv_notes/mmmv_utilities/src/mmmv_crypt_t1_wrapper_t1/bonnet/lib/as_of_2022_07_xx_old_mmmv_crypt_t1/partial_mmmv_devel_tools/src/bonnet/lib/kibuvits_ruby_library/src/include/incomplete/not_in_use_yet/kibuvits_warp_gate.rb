#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ProgFTE.rb"
end # if
#==========================================================================


# The purpose and usage of this class is explaned at the
# comments of the class Kibuvits_warp_gate.
class Kibuvits_warp_gate_connection
   attr_reader :s_name
   def initialize s_name
      bn=binding()
      kibuvits_typecheck bn, String, ob_connection
      kibuvits_throw "s_name.length==0" if s_name.length==0
      @s_name=s_name
      @ob_warp_gate=nil
   end #initialize

   protected

   def open
      kibuvits_throw "This method is subject to overriding."
   end # open

   def close
      kibuvits_throw "This method is subject to overriding."
   end # close

   def send_string s_data
      kibuvits_throw "This method is subject to overriding."
   end # send_string

   private
   def send ht_warp_gate_vehicle
      s_progfte=Kibuvits_ProgFTE.from_ht(ht_warp_gate_vehicle)
      send_string s_progfte
   end # send

   def register_warp_gate ob_warp_gate
   end # register_warp_gate

end # class Kibuvits_warp_gate_connection

#---------------------------------------------------------------------------

# The Kibuvits_warp_gate implements an asyncronous
# tow-way communication port, where data packets have
# a parameter called preferred_maximum_departure_delay_category.
# The category determins a "standard" amount of milliseconds.
#
# This allows multiple data packets to be gahtered,
# packed, to a single "warp gate vehicle" and sent through
# the warp gate all at once. This minimizes the
# number of handshaking procedures that are
# related to a single dispatch and hopefully gives
# application speedup and copes better with communication lines
# that have a considerable latency.
#
# A classical example is a http request to a PHP application,
# where for every request the PHP side does considerable
# instantiation and creates a new database connection.
#
# The different connection types, like TCP, http, SSH, etc.
# are implemented as Kibuvits_warp_gate_connection instances,
# which must be loaded to the warp gate at its initialization.
#
class Kibuvits_warp_gate

   def initialize ob_connection
      bn=binding()
      kibuvits_typecheck bn, Kibuvits_warp_gate_connection, ob_connection
   end #initialize

   def open_connection
   end # open_connection

   def close_connection
   end # close_connection

   public
   def Kibuvits_warp_gate.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_warp_gate.test_sar"
      return ar_msgs
   end # Kibuvits_warp_gate.selftest
end # class Kibuvits_warp_gate


#=========================================================================
