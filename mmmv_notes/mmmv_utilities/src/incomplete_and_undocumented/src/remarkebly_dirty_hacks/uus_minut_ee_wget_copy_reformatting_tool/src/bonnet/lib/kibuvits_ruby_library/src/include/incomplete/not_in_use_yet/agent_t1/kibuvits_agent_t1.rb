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
   require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ix.rb"
   require  "kibuvits_ProgFTE.rb"
end # if
#==========================================================================

# Each skill instance can be inserted to at most one agent
# at a time.
class Kibuvits_agent_t1_skill
   @@lc_s_agent_interface_version="v_1"
   @@lc_emptystring=""

   attr_reader  :s_agent_interface_version, :s_skill_name

   def initialize s_skill_name, msgcs
      bn=binding()
      kibuvits_typecheck bn, String, s_skill_name
      kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs

      s=s_skill_name.gsub(/\s\r\n\t/,@@lc_emptystring)
      if s.length==0
         kibuvits_throw "Skill instance names are not allowed to be empty strings, nor"+
         "are they allowed to contain spaces-tabs-linebrakes. s_skill_name==\""+
         s_skill_name+"\"."
      end # if
      @s_skill_name=s

      @s_agent_interface_version=@@lc_s_agent_interface_version
      @ob_agent=nil
      @b_agent_registered=false

      @ht_agent_messageboard_for_skills=nil
      @msgcs=msgcs
   end #initialize

   def run_skill
      kibuvits_throw "This method is expected to be overriden."
   end # run_skill

   private
   def register_agent ob_agent
      bn=binding()
      kibuvits_typecheck bn, Kibuvits_agent_t1, ob_agent
      if @b_agent_registered==true
         kibuvits_throw "An instance of a skill named \""+@s_skill_name+
         "\" is registered to an instance of an agent named \""+@ob_agent.s_name+
         "\", but someone tries to re-register it to an instance of an agent named \""+
         ob_agent.s_name+".\n"
      end # if
      @b_agent_registered=true
      @ob_agent=ob_agent
      @msgcs=@ob_agent.instance_variable_get(:@msgcs)
      @ht_agent_messageboard_for_skills=@ob_agent.instance_variable_get(:@ht_agent_messageboard_for_skills)
      @ht_skills=@ob_agent.instance_variable_get(:@ht_skills)
   end # register_agent

end # class Kibuvits_agent_t1_skill

#--------------------------------------------------------------------------

# An agent is like some "move character" or "actor" or "robot" that loads
# its skills and waits for commands.
#
# The skills can be loaded either at initialization or by using
# method called load_skill. By default all agent instances have
# a skill called "load_skill". Skills can be overridden.
#
# Skill instances can communicate with eachother by using
# 2 hashtable instances that are private fields of the agent that
# contains the skill instances. When a skill instance and an
# agent instance is paired, the hashtable instances are made available
# to skill code by a skill's instance private fields named
# @ht_skills and @ht_agent_messageboard_for_skills. The keys of the 
# @ht_skills are the skill instance names. 
#
# A command consist of a skill name and skill usage single-use parameters.
# The commands can be fed either to a method called run_skill or, optionally,
# the agent can be ordered to open a port and accept the commands from there.
#
# All agents run in individual threads and there's a method called
# Kibuvits_agent_t1.kill_all for exiting all of them.
#
class Kibuvits_agent_t1
   @@lc_s_agent_interface_version="v_1"
   @@ht_agents=Hash.new

   # A skill is an instance that wraps a procedure, but
   # it also contains some public readonly fields like
   # s_agent_interface_version, skill_name.
   def initialize s_name, ar_or_ob_skills, msgcs
      bn=binding()
      kibuvits_typecheck bn, String, s_name
      kibuvits_typecheck bn, [Object,Array], ar_or_ob_skills
      kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      @ht_agent_messageboard_for_skills=Hash.new
      @ht_skills=Hash.new
      @msgcs=msgcs
   end #initialize

   def load_skill ob_skill
      bn=binding()
      kibuvits_typecheck bn, Kibuvits_agent_t1_skill, ob_skill
      ob_skill.send(:register_agent,self)
   end # load_skill


   private
   def Kibuvits_agent_t1.test_t1
      if !kibuvits_block_throws{Kibuvits_agent_t1.sar("x"," ",1)}
         #kibuvits_throw "test 1"
      end # if
   end # Kibuvits_agent_t1.test_t1

   public
   def Kibuvits_agent_t1.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_agent_t1.test_t1"
      return ar_msgs
   end # Kibuvits_agent_t1.selftest
end # class Kibuvits_agent_t1
#=========================================================================
