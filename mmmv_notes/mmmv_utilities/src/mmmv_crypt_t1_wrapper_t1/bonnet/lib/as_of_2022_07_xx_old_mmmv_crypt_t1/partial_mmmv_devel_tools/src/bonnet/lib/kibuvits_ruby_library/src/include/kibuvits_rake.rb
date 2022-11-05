#!/usr/bin/env ruby
#=========================================================================
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
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

#require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"

#==========================================================================

# It's a namespace for Ruby Rake related code.
class Kibuvits_rake

   def initialize
   end #initialize

   def s_list_tasks(s_language=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [NilClass,String], s_language
      end # if
      ar_task_names=Array.new
      Rake.application.tasks.each {|x_task| ar_task_names<<x_task.to_s}
      ar_task_names.sort!
      s_lang=s_language
      if (s_language==nil)
         s_lang=$kibuvits_lc_English
      end # if
      s_1="xxxxxxxxxxxxxxxx".gsub!("x",$kibuvits_lc_space) # to make spaces visible
      s_out=""
      case s_lang
      when $kibuvits_lc_Estonian
         s_out="\n\nDeklareeritud Rake funktsioonid:\n\n"
      when $kibuvits_lc_English
         # OK, but exec in a separate block
      else
         if KIBUVITS_b_DEBUG
            kibuvits_throw("s_language=="+s_language+
            " not supported by this function."+
            "\nGUID='52b94bc3-9238-412b-923b-33b370116dd7'")
         else
            s_lang=$kibuvits_lc_English
         end # if
      end # case s_language
      if s_lang==$kibuvits_lc_English
         s_out="\n\nDeclared Rake functions:\n\n"
      end # if
      ar_task_names.each do |s_task_name|
         if s_task_name!=$kibuvits_lc_default
            s_out=s_out+s_1+(s_task_name.to_s+$kibuvits_lc_linebreak)
         end # if
      end # loop
      s_out=s_out+$kibuvits_lc_doublelinebreak
      return s_out
   end # s_list_tasks

   def Kibuvits_rake.s_list_tasks(s_language=nil)
      s_out=Kibuvits_rake.instance.s_list_tasks(s_language)
      return s_out
   end # Kibuvits_rake.s_list_tasks

   #-----------------------------------------------------------------------
   include Singleton
end # class Kibuvits_rake

#=========================================================================

