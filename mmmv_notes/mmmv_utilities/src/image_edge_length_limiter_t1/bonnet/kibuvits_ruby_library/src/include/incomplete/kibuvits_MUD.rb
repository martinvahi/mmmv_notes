#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2011, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 Redistribution and use in source and binary forms, with or
 without modification, are permitted provided that the following
 conditions are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer
   in the documentation and/or other materials provided with the
   distribution.
 * Neither the name of the Martin Vahi nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
#==========================================================================

# Once upon a time there were text based multi-player games called
# Multi-User Dungeon-s, generally called
# as MUD (http://en.wikipedia.org/wiki/MUD ).
#
# The idea was that
# there is a graph (http://mathworld.wolfram.com/Graph.html ), called
# a world, and users and coputer operated agents were moving along that
# graph. User interaction was text based, commands were given from
# console and feedback was also mostly textual.
# Each of the nodes had some set of
# descriptions and "activities" that the user could do there. The users
# had also capabilities that were attached to them, like chatting to
# other users, asking for node descriptions, applying one's skills at
# the objects present at the node, picking the objects up and carrying
# carrying them with oneself, etc.
#
# The motive behind the class Kibuvits_MUD_node is
# to facilitate the creation of small, simple, text-based,
# choice operated, console applications. The idea is that user interaction
# of console applications is practically the same as the one of the
# historic game, MUD. So, there's no point of rewriting the same logic
# from scrap every time one needs to write some console application,
# specially if it's a small utility that is used as an application
# specific tool for developing and maintaining some other, more extensive,
# application. A common usage scenario is that there's a version
# updater that renames files as part of the version update and then
# applies appropriate text replacements within the project specific files.
# Anohter case is the execution of tests.
#
# In addition to the interactive mode, where users navigate within the
# graph and then execute actions at specific nodes, one should be able
# to execute the console applications without user interaction, in a
# scriptable manner. That can be done by letting a robot to navigate
# and interact with the MUD world. This entails that all of the states
# and feedback must be in a computer readable, i.e. "semantically labeled",
# form.
#
class Kibuvits_MUD_node
   def initialize
   end #initialize


   public
   def Kibuvits_MUD_node.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_MUD_node.test_difference"
      return ar_msgs
   end # Kibuvits_MUD_node.selftest
end # class Kibuvits_MUD_node

#=========================================================================
