#!/usr/bin/env ruby 
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_I18N_MSGS_T1_RB_INCLUDED
   KIBUVITS_I18N_MSGS_T1_RB_INCLUDED=true

   if !defined? KIBUVITS_HOME
      x=ENV['KIBUVITS_HOME']
      KIBUVITS_HOME=x if (x!=nil and x!="")
   end # if

   require "singleton"
   if defined? KIBUVITS_HOME
      require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   else
      require  "kibuvits_msgc.rb"
   end # if
end # if

#==========================================================================

# The class Kibuvits_i18n_msgs_t1 is a namespace for
# functions that are assemble human language specific strings.
# In the old fachioned terms: this file here is a language file.
class Kibuvits_i18n_msgs_t1
   def initialize
   end # initialize
   #-----------------------------------------------------------------------

   # The s_file_candidate_type is expected to hold
   # the File.ftype(...) output.
   #
   # It returns a human language analogue to the official,
   # english, eversion.
   def s_filetype_to_humanlanguage_t1(s_language,
      s_path_to_the_file_candidate,s_file_candidate_type)
      s_out=nil
      case s_language
      when $kibuvits_lc_et
         case s_file_candidate_type
         when "directory"
            s_out="kataloog"
         when "fifo"
            s_out="järjekord (fifo)"
         when "link"
            s_out="link"
         when "characterSpecial"
            s_out="jada-seadme-fail"
         when "blockSpecial"
            s_out="blokk-seadme-fail"
         when "unknown"
            s_out="klassifitseerumatu"
         else
            kibuvits_throw("s_file_candidate_type.to_s==\""+
            s_file_candidate_type.to_s+"\", but that value is "+
            "not supported by this method.")
         end # case s_file_candidate_type
      else # probably s_language=="uk"
         s_out=$kibuvits_lc_emptystring+s_file_candidate_type
      end # case s_language
      return s_out
   end # s_filetype_to_humanlanguage_t1

   def Kibuvits_i18n_msgs_t1.s_filetype_to_humanlanguage_t1(s_language,
      s_path_to_the_file_candidate,s_file_candidate_type)
      s_out=Kibuvits_i18n_msgs_t1.instance.s_filetype_to_humanlanguage_t1(
      s_language,s_path_to_the_file_candidate,s_file_candidate_type)
      return s_out
   end # Kibuvits_i18n_msgs_t1.s_filetype_to_humanlanguage_t1

   #-----------------------------------------------------------------------

   def s_msg_regular_file_exists_but_it_is_not_readable_t1(s_language,s_file_path)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_language
         kibuvits_typecheck bn, String, s_file_path
      end # if
      s_out=nil
      case s_language
      when $kibuvits_lc_et
         s_out="\nOperatsioonisüsteemi kontekstis tavapärane fail, \""+
         s_file_path+"\",\nleidub, kuid ta ei ole failisüsteemi juurdepääsuõiguste järgi loetav.\n\n"
      else # probably s_language=="uk"
         s_out="\nIn the contenxt of an operating system the regular file, \""+
         s_file_path+"\",\nexists, but it is not readable by the file system access rights.\n\n"
      end # case s_language
      return s_out
   end # s_msg_regular_file_exists_but_it_is_not_readable_t1

   def Kibuvits_i18n_msgs_t1.s_msg_regular_file_exists_but_it_is_not_readable_t1(
      s_language,s_file_path)
      s_out=Kibuvits_i18n_msgs_t1.instance.s_msg_regular_file_exists_but_it_is_not_readable_t1(
      s_language,s_file_path)
      return s_out
   end # Kibuvits_i18n_msgs_t1.s_msg_regular_file_exists_but_it_is_not_readable_t1

   #-----------------------------------------------------------------------

   def s_msg_method_is_missing_t1(s_language,ob,s_method_name,a_binding=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_language
         kibuvits_typecheck bn, String, s_method_name
         kibuvits_typecheck bn, [NilClass,Binding], a_binding
         bn_1=bn
         bn_1=a_binding if a_binding!=nil
         kibuvits_assert_string_min_length(bn_1,s_language,1)
         kibuvits_assert_string_min_length(bn_1,s_method_name,1)
      end # if
      s_ob_varname=$kibuvits_lc_emptystring
      if a_binding!=nil
         s_ob_varname=kibuvits_s_varvalue2varname(a_binding, ob)
      end # if
      s_out=nil
      case s_language
      when $kibuvits_lc_et
         if s_ob_varname.length==0
            s_out="\nIsendil puudus meetod nimega \""+
            s_method_name+"\".\n\n"
         else
            s_out="\nIsendil, millele viitab muutuja nimega \""+
            s_ob_varname+"\" puudus meetod nimega \""+
            s_method_name+"\".\n\n"
         end # if
      else # probably s_language=="uk"
         if s_ob_varname.length==0
            s_out="\nThe instance is missing a method named \""+
            s_method_name+"\".\n\n"
         else
            s_out="\nThe instance that is held by a variable named \""+
            s_ob_varname+"\" is missing a method named \""+
            s_method_name+"\".\n\n"
         end # if
      end # case s_language
      return s_out
   end # s_msg_method_is_missing_t1

   def Kibuvits_i18n_msgs_t1.s_msg_method_is_missing_t1(s_language,ob,
      s_method_name,a_binding=nil)
      s_out=Kibuvits_i18n_msgs_t1.instance.s_msg_method_is_missing_t1(
      s_language,ob,s_method_name,a_binding)
      return s_out
   end # Kibuvits_i18n_msgs_t1.s_msg_regular_file_exists_but_it_is_not_readable_t1

   #-----------------------------------------------------------------------
   include Singleton
end # class Kibuvits_i18n_msgs_t1

#==========================================================================
