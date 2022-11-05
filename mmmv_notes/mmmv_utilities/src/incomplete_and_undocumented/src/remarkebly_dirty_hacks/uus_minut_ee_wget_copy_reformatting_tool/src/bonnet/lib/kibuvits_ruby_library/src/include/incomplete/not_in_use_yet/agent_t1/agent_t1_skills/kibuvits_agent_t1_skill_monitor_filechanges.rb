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

# Executes a block, if a file last modification state has changed.
# It's turned off by default. It 
class Kibuvits_agent_t1_skill_monitor_filechanges_t1< Kibuvits_agent_t1_skill
   @@lc_emptystring=""

   def initialize s_skill_name, msgcs
      super(s_skill_name,msgcs)
@b_is_turned_on=false
@ob_message_filter=nil
   end #initialize

   def register_file s_full_file_path
      # On m2hiseks https://github.com/ttilley/fssm
      # teegile, mis ei ole Ruby standardteegi osa, kuid on
      # opsysteemist s8ltumatu.
   end # register_file

   # s_mode:=="execute_block"|"relay"|"execute_block_and_relay"
   def start s_mode="execute_block", s_destination_ip_address="localhost", i_destination_port=2222
   end # start

   def stop
   end # stop

   def run_skill
      kibuvits_throw "This method is expected to be overriden."
   end # run_skill

private


   private
   def Kibuvits_agent_t1_skill_monitor_filechanges_t1.test_t1
      if !kibuvits_block_throws{Kibuvits_agent_t1_skill_monitor_filechanges_t1.sar("x"," ",1)}
         #kibuvits_throw "test 1"
      end # if
   end # Kibuvits_agent_t1_skill_monitor_filechanges_t1.test_t1

   public
   def Kibuvits_agent_t1_skill_monitor_filechanges_t1.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_agent_t1_skill_monitor_filechanges_t1.test_t1"
      return ar_msgs
   end # Kibuvits_agent_t1_skill_monitor_filechanges_t1.selftest
end # class Kibuvits_agent_t1_skill_monitor_filechanges_t1

#=========================================================================
