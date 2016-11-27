#!/usr/bin/env ruby
#==========================================================================

if !defined?(KIBUVITS_HOME)
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
else
   require "kibuvits_msgc.rb"
end # if
require "singleton"
#==========================================================================

# The idea is that a lock has infinite number of bits, one
# bit for each of the processes, and the lock is considered
# to be "unlocked", if all of the bits are 0. Processes
# detect collisions like that:
#
# 1) process X1 sets up its own bit;
# 2) process X1 checks, whether its bit is the only one set;
# 3a) if process X1 bit is the only one set, process X1 continues;
# 3b) if process X1 bit is not the only one set,
#     process X1 clears its bit and aborts;
#
# It is possible that 2 processes collide and both abort:
#
# 1) process X1 sets up its own bit;
# 2) process X2 sets up its own bit;
# 3) process X1 checks, whether its bit is the only one set;
# 4) process X2 checks, whether its bit is the only one set;
# 5) both, the process X1 and the process X2, unset their
#    bits and abort;
#
# In the case of the Kibuvits_fsmutex, a bit is considered set,
# if a file exists in a mutex folder. File name collision is 
# avoided by using file names that contain 
# Globally Unique Identifiers (GUIDs).
class Kibuvits_fsmutex
   def initialize
   end # initialize

   public
   include Singleton

   def Kibuvits_fsmutex.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_comments_detector.test_singleline"
      return ar_msgs
   end # Kibuvits_fsmutex.selftest
end # class Kibuvits_fsmutex

#==========================================================================
