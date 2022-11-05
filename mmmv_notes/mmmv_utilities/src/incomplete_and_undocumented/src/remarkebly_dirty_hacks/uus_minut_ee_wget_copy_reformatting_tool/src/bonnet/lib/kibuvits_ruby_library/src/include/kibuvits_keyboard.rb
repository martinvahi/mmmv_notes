#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2013, martin.vahi@softf1.com that has an
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
#==========================================================================

if !defined? KIBUVITS_HTOPER_RB_INCLUDED
   KIBUVITS_HTOPER_RB_INCLUDED=true

   if !defined? KIBUVITS_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
      require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
   end # if

   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
end # if

#--------------------------------------------------------------------------

# The Curses stdlib will mess things up to the point that
# You will curse in Your thoughts. That's why the
# require "courses" # must not be uncommented.
# For those, who still have a great temptation to use the
# Curses library, the following link migth be appealing:
# http://stackoverflow.com/questions/7297753/how-to-capture-a-key-press-in-ruby

#==========================================================================

class Kibuvits_keyboard

   def initialize
=begin
      raise(new.Exception("This class is totally flawed, becuase the "+
      "gets uses stdin, which is tied to the main thread and "+
      "as long as there's no way to get clean keyboard presses "+
      "without the whole stdin stuff (the stdin is global by nature, "+
      "with all the classicla glory of globals) then threads can not "+
      "capture keyboard events independent of eachother."+
      "\nGUID=='e6c15732-8beb-44a7-9c45-f2a011715dd7')\n\n"))
=end
   end # initialize

   #--------------------------------------------------------------------------

   # ht_str2func keys are strings and values are Ruby lambda functions.
   #
   # Whenever a string that is a key of the ht_str2func is
   # entered during the running of the thread, the function that
   # is associated with the key, is run.
   #
   # Returns a dormant thred that can be started by using Thread.run
   #
   # WARNING: the current version blocks all file access and console feedback
   def ob_thread_gets_t1(ht_str2func)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_str2func
         ht_str2func.each_pair do |x_key,x_value|
            bn_1=binding()
            kibuvits_typecheck bn_1, String, x_key
            kibuvits_typecheck bn_1, Proc, x_value
         end # loop
      end # if
      ob_thread=Thread.new do
         s_cmd=nil
         ob_func=nil
         rgx_1=/[\n]/
         loop do
            $kibuvits_lc_mx_streamaccess.synchronize do
               s_cmd=STDIN.gets
            end # synchronize
            s_cmd.gsub!(rgx_1,$kibuvits_lc_emptystring)
            if ht_str2func.has_key? s_cmd
               ob_func=ht_str2func[s_cmd]
               ob_func.call
            end # if
         end # loop
      end # thread
      return ob_thread
   end # ob_thread_gets_t1

   def Kibuvits_keyboard.ob_thread_gets_t1(ht_str2func)
      ob_thread=Kibuvits_keyboard.instance.ob_thread_gets_t1(ht_str2func)
      return ob_thread
   end # Kibuvits_keyboard.ob_thread_gets_t1

   #--------------------------------------------------------------------------
   public
   include Singleton
end # class Kibuvits_keyboard

#==========================================================================
