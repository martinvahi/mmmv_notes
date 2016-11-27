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
   require  KIBUVITS_HOME+"/src/include/kibuvits_agent_t1.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_ix.rb"
   require  "kibuvits_ProgFTE.rb"
   require  "kibuvits_agent_t1.rb"
end # if
#==========================================================================

# The migration allows an agent to send a marchalled copy of oneself
# over a network and then selfterminate at the original site.
class Kibuvits_agent_t1_skill_migrate_t1 < Kibuvits_agent_t1_skill
   @@lc_emptystring=""

   def initialize s_skill_name, msgcs
      super(s_skill_name,msgcs)
   end #initialize

   def run_skill
      kibuvits_throw "This method is expected to be overriden."
   end # run_skill


   private
   def Kibuvits_agent_t1_skill_migrate_t1.test_t1
      if !kibuvits_block_throws{Kibuvits_agent_t1_skill_migrate_t1.sar("x"," ",1)}
         #kibuvits_throw "test 1"
      end # if
   end # Kibuvits_agent_t1_skill_migrate_t1.test_t1

   public
   def Kibuvits_agent_t1_skill_migrate_t1.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_agent_t1_skill_migrate_t1_skill_migrate_t1.test_t1"
      return ar_msgs
   end # Kibuvits_agent_t1_skill_migrate_t1.selftest
end # class Kibuvits_agent_t1_skill

#=========================================================================
