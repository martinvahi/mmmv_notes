#!/usr/bin/env ruby
#==========================================================================
# Initial author: martin.vahi@softf1.com
# This file is in public domain.
# 
# This script has been tested only on Linux.
# 
#--------------------------------------------------------------------------


def sleep_a_while(i_process_id,
   i_sleeping_time_in_seconds,
   i_working_time_in_seconds,
   n, b_run_sleep_run)
   ar=[n,i_process_id,i_sleeping_time_in_seconds,i_working_time_in_seconds]
   ar.size.times do |ix|
      x=ar[ix]
      if x.class != Integer
         raise (Exception.new("ix=="+ix.to_s+
         "GUID='4a845132-6bf8-44cf-95e0-a2913050a0e7'"))
      end # if
      if x<1 # may be it should be 0, but 1 seems safer, not just for n
         raise (Exception.new("ix=="+ix.to_s+
         "GUID='9970ed59-5493-45c9-b1e0-a2913050a0e7'"))
      end # if
   end # loop
   cl=b_run_sleep_run.class
   if cl!= TrueClass
      if cl!= FalseClass
         raise (Exception.new("ix=="+ix.to_s+
         "GUID='689e9958-d05c-437f-92e0-a2913050a0e7'"))
      end # if
   end # if
   #----
   s_go_to_sleep="kill -s 19 S_PROCESS_ID ; " # pauses, Ctrl-Z
   s_wake_up="kill -s 18 S_PROCESS_ID ; " # "continue", wakes the process up again
   s_bash="bash -c \""
   if b_run_sleep_run
      s_bash<<s_go_to_sleep
      s_bash<<"sleep "+i_sleeping_time_in_seconds.to_s+" ; "
      s_bash<<s_wake_up
   else
      s_bash<<s_wake_up
      s_bash<<"sleep "+i_working_time_in_seconds.to_s+" ; "
      s_bash<<s_go_to_sleep
   end # if
   s_bash<<"\" "
   s_bash.gsub!("S_PROCESS_ID",i_process_id.to_s)
   s_bash.freeze
   #----
   puts "\n"
   puts "i_process_id="+i_process_id.to_s
   puts "i_sleeping_time_in_seconds="+i_sleeping_time_in_seconds.to_s
   puts "i_working_time_in_seconds="+i_working_time_in_seconds.to_s
   puts "n="+n.to_s
   puts "s_bash="+s_bash.to_s
   puts "\n"
   #----
   i_0=0
   s_lc_down="V".freeze
   s_lc_up="A".freeze
   s_ruby="\`"+s_bash+"\`"
   s_ruby.freeze
   i_row_length=30
   if b_run_sleep_run
      n.times do |i|
         i_0=i_0+1
         if i_row_length<=i_0
            i_0=0
            puts("\n"+i.to_s)
         end # if
         printf(s_lc_down)
         #----
         x=eval(s_ruby)
         #puts x.to_s
         printf(s_lc_up)
         sleep(i_working_time_in_seconds)
      end # loop
   else # sleep_run_sleep
      n.times do |i|
         i_0=i_0+1
         if i_row_length<=i_0
            i_0=0
            puts("\n"+i.to_s)
         end # if
         printf(s_lc_up)
         #----
         x=eval(s_ruby)
         #puts x.to_s
         printf(s_lc_down)
         sleep(i_sleeping_time_in_seconds)
      end # loop
   end # if
   puts ""
end # sleep_a_while

#--------------------------------------------------------------------------

#i_process_id=14201
i_sleeping_time_in_seconds=1
i_working_time_in_seconds=1
n=2
b_run_sleep_run=true

sleep_a_while(i_process_id,
i_sleeping_time_in_seconds, i_working_time_in_seconds,n,b_run_sleep_run)

#==========================================================================
