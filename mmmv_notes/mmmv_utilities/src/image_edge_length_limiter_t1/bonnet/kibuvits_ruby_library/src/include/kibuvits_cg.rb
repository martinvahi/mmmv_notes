#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2010, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"

#==========================================================================

# The "cg" in the name of the class Kibuvits_cg
# stands for "code generation".
class Kibuvits_cg
   private
   @@lc_blstp="[CODEGENERATION_BLANK_"# blstp==="blank search string prefix"
   @@lc_blstp_guid="[CODEGENERATION_BLANK_GUID_"
   @@lc_rsqbrace="]"
   @@lc_emptystring=""
   @@lc_space=" "
   @@lc_8_spaces="        "
   @@lc_linebreak="\n"
   @@lc_doublequote="\""

   # The @@lc_ar_blsts exists only for speed. Its initialization relies
   # on this class being a singleton.
   @@lc_ar_blsts=[]

   public
   def initialize
      @@lc_ar_blsts<<@@lc_blstp+"0]"
      @@lc_ar_blsts<<@@lc_blstp+"1]"
      @@lc_ar_blsts<<@@lc_blstp+"2]"
      @@lc_ar_blsts<<@@lc_blstp+"3]"
   end #initialize

   private

   # It practically counts the number of differnet
   # guid needles from the s_form.
   def fill_form_guids_get_ht_needles(s_form, s_prefix)
      ht_needles=Hash.new
      s_needle=nil
      i=0
      while true
         s_needle=s_prefix+i.to_s+@@lc_rsqbrace
         break if !s_form.include? s_needle
         ht_needles[s_needle]=Kibuvits_GUID_generator.generate_GUID
         i=i+1
      end # loop
      return ht_needles
   end # fill_form_guids_get_ht_needles


   def fill_form_guids s_form, s_guid_searchstring_prefix
      s_prefix=@@lc_blstp_guid
      if s_guid_searchstring_prefix!=nil
         s_prefix=s_guid_searchstring_prefix
      end # if
      ht_needles=fill_form_guids_get_ht_needles(s_form, s_prefix)
      s_out=Kibuvits_str.s_batchreplace(ht_needles,s_form)
      return s_out
   end # fill_form_guids

   public
   def fill_form(ar_or_s_blank_value,s_form,
      s_searchstring_prefix=nil,
      s_guid_searchstring_prefix=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Array,String], ar_or_s_blank_value
         kibuvits_typecheck bn, String, s_form
         kibuvits_typecheck bn, [NilClass,String], s_searchstring_prefix
         kibuvits_typecheck bn, [NilClass,String], s_guid_searchstring_prefix
      end # if
      s_out=@@lc_emptystring+s_form
      return s_out if s_out.length==0
      s_out=fill_form_guids(s_out,s_guid_searchstring_prefix)
      ar_blank_values=Kibuvits_ix.normalize2array(ar_or_s_blank_value)
      # The order of the blank values in the ar_blank_values is important.
      i_len=ar_blank_values.length
      return s_out if i_len==0
      return s_out if (i_len==1)&&(ar_blank_values[0].length==0)
      s_blst=nil
      b=(s_searchstring_prefix==nil)&&(i_len<=@@lc_ar_blsts.length)
      ht_needles=Hash.new
      s_blank_value=nil
      if b
         i_len.times do |i|
            s_blst=@@lc_ar_blsts[i]
            s_blank_value=ar_blank_values[i]
            # The next line is a quick hack for Kibuvits_str.s_batchreplace bug workaround.
            s_blank_value=@@lc_space if s_blank_value==@@lc_emptystring
            ht_needles[s_blst]=s_blank_value
         end # loop
      else
         s_prefix=@@lc_blstp
         s_prefix=s_searchstring_prefix if s_searchstring_prefix!=nil
         i_len.times do |i|
            s_blst=s_prefix+i.to_s+@@lc_rsqbrace
            ht_needles[s_blst]=ar_blank_values[i]
         end # loop
      end #
      s_out=Kibuvits_str.s_batchreplace(ht_needles,s_out)
      return s_out
   end # fill_form

   def Kibuvits_cg.fill_form(ar_or_s_blank_value,s_form,
      s_searchstring_prefix=nil,
      s_guid_searchstring_prefix=nil)
      s_out=Kibuvits_cg.instance.fill_form(ar_or_s_blank_value,s_form,
      s_searchstring_prefix, s_guid_searchstring_prefix)
      return s_out
   end # Kibuvits_cg.fill_form

   private

   def Kibuvits_cg.test_fill_form
      if kibuvits_block_throws{Kibuvits_cg.fill_form([],"")}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_cg.fill_form(42,"")}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_cg.fill_form([],42)}
         kibuvits_throw "test 3"
      end # if
      s_form="A[CODEGENERATION_BLANK_0]BB\n"+
      "CC[CODEGENERATION_BLANK_1]DD"
      s_expected="AxxBB\nCCyyDD"
      s=Kibuvits_cg.fill_form(["xx","yy"],s_form)
      kibuvits_throw "test 4" if s!=s_expected

      # The next test has more blank needle-strings than
      # in the global cache, so that a needle-string generation
      # branch is entered.
      s_form="A[CODEGENERATION_BLANK_0]BB\n"+
      "CC[CODEGENERATION_BLANK_1]DD\n"+
      "CC[CODEGENERATION_BLANK_2]DD\n"+
      "CC[CODEGENERATION_BLANK_3]DD\n"+
      "CC[CODEGENERATION_BLANK_4]DD\n"
      s_expected="Ax0BB\nCCx1DD\nCCx2DD\nCCx3DD\nCCx4DD\n"
      s=Kibuvits_cg.fill_form(["x0","x1","x2","x3","x4"],s_form)
      kibuvits_throw "test 5" if s!=s_expected

      s_form="A[CODEGENERATION_BLANK_GUID_0]BB\n"+
      "CC[CODEGENERATION_BLANK_GUID_1]DD\n"+
      "CC[CODEGENERATION_BLANK_GUID_1]DD"
      s=Kibuvits_cg.fill_form("",s_form) # To see, that it doesn't throw.
      #puts "\n\n{"+s+"}\n\n"
   end # Kibuvits_cg.test_fill_form

   public

   @s_form_func_tables_exist_entry=""+
   "			$b=$b&&($this->db_->table_exists([CODEGENERATION_BLANK_0]));\n"



   # The idea is that a list like:
   #
   #  List_header
   #     elem1
   #     elem2
   #     ...
   #  List_footer
   #
   # can be seen as:
   #
   #  List_header
   #     [CODEGENERATION_BLANK_0]
   #  List_footer
   #
   # where each of the elements is given by a form that also has
   # a blank naemed  [CODEGENERATION_BLANK_0].
   def assemble_list_by_forms(s_list_form,s_list_element_form,
      s_or_ar_of_element_form_blank_values)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_list_form
         kibuvits_typecheck bn, String, s_list_element_form
         kibuvits_typecheck bn, [Array,String], s_or_ar_of_element_form_blank_values
      end # if
      ar=Kibuvits_ix.normalize2array(s_or_ar_of_element_form_blank_values)
      s_list=""
      s=nil
      s_element_form_blank=nil
      i_arlen=ar.length
      i_arlen.times do |i|
         s_element_form_blank=ar[i]
         s=Kibuvits_cg.fill_form(s_element_form_blank,s_list_element_form)
         s_list=s_list+s
      end # loop
      s_out=Kibuvits_cg.fill_form(s_list,s_list_form)
      return s_out
   end # assemble_list_by_forms

   def Kibuvits_cg.assemble_list_by_forms(s_list_form,s_list_element_form,
      s_or_ar_of_element_form_blank_values)
      s_out=Kibuvits_cg.instance.assemble_list_by_forms(
      s_list_form,s_list_element_form,s_or_ar_of_element_form_blank_values)
      return s_out
   end # Kibuvits_cg.assemble_list_by_forms

   private
   def Kibuvits_cg.test_assemble_list_by_forms
      s_list_form="A<[CODEGENERATION_BLANK_0]>B"
      s_elem_form="([CODEGENERATION_BLANK_0])"
      s_expected="A<(a)(c)(d)>B"
      s=Kibuvits_cg.assemble_list_by_forms(s_list_form,s_elem_form,
      ["a","c","d"])
      kibuvits_throw "test 1" if s!=s_expected
   end # Kibuvits_cg.test_assemble_list_by_forms

   public
   def get_standard_warning_msg(s_singleliner_comment_start,
      s_code_generation_region_name="")
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_singleliner_comment_start
         kibuvits_typecheck bn, String, s_code_generation_region_name
      end # if
      s_out=@@lc_8_spaces+s_singleliner_comment_start+
      " WARNING: This function resides in an autogeneration region.\n"
      if s_code_generation_region_name!=""
         s_out=s_out+@@lc_8_spaces+s_singleliner_comment_start+
         " This code has been autogenerated by: "+
         s_code_generation_region_name+" \n"
      end # if
      return s_out
   end # get_standard_warning_msg

   def Kibuvits_cg.get_standard_warning_msg(s_singleliner_comment_start,
      s_code_generation_region_name="")
      s_out=Kibuvits_cg.instance.get_standard_warning_msg(
      s_singleliner_comment_start, s_code_generation_region_name)
      return s_out
   end # Kibuvits_cg.get_standard_warning_msg

   public
   include Singleton
   def Kibuvits_cg.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_cg.test_fill_form"
      kibuvits_testeval bn, "Kibuvits_cg.test_assemble_list_by_forms"
      return ar_msgs
   end # Kibuvits_cg.selftest
end # class Kibuvits_cg

#=========================================================================

#s=Kibuvits_cg.fill_form([],"")
#Kibuvits_cg.test_fill_form
