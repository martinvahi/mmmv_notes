#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"

#==========================================================================

# The "cg" in the name of the class Kibuvits_cg_php_t1
# stands for "code generation".
class Kibuvits_cg_php_t1

   def initialize
      @s_lc_escapedsinglequote="\\'".freeze
   end #initialize

   #-----------------------------------------------------------------------

   private

   def s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_elem,rgx_0)
      if x_elem.class==String
         s_elem=($kibuvits_lc_singlequote+
         x_elem.gsub(rgx_0,@s_lc_escapedsinglequote)+$kibuvits_lc_singlequote)
         ar_s<<s_elem
      else # Fixnum or Float
         ar_s<<x_elem.to_s
      end # if
   end # s_ar_or_ht_2php_t1_x_elem_2_ar_s


   def s_ar_or_ht_2php_t1_array(s_corrected_php_array_variable_name,
      ar_of_numbers_or_strings,i_row_length)
      #----------
      i_len=ar_of_numbers_or_strings.size
      b_nonfirst=false
      ar_s=Array.new
      ar_s<<s_corrected_php_array_variable_name
      ar_s<<"=array("
      #----------
      x_elem=nil
      rgx_0=/[']/
      i_len.times do |ix|
         if b_nonfirst
            ar_s<<$kibuvits_lc_comma
         else
            b_nonfirst=true
         end # if
         ar_s<<($kibuvits_lc_linebreak+"   ") if ((ix%i_row_length)==0) && (0<ix)
         x_elem=ar_of_numbers_or_strings[ix]
         s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_elem,rgx_0)
      end # loop
      #----------
      ar_s<<");"
      ar_s<<$kibuvits_lc_linebreak
      s_out=kibuvits_s_concat_array_of_strings(ar_s)
      return s_out
   end # s_ar_or_ht_2php_t1_array


   public

   # The elements/keys/values of the ar_or_ht_of_numbers_or_strings can
   # are allowd to be a mixture of types String, Fixnum, Float.
   def s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_of_numbers_or_strings,i_row_length=7)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_php_array_variable_name
         kibuvits_typecheck bn, [Array,Hash], ar_or_ht_of_numbers_or_strings
         kibuvits_typecheck bn, Fixnum, i_row_length
         #----
         s_varname=s_php_array_variable_name.sub(/^[$]/,$kibuvits_lc_emptystring)
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_varname,
         "GUID='28143223-4fc8-445d-acf4-03c1e0306ed7'\n")
         #----
         kibuvits_assert_is_smaller_than_or_equal_to(bn, 1, i_row_length,
         "GUID='13c8a065-0285-458d-bbf4-03c1e0306ed7'\n")
         ar_cl=[Fixnum,Float,String]
         if ar_or_ht_of_numbers_or_strings.class==Array
            kibuvits_assert_ar_elements_typecheck_if_is_array(bn,
            ar_cl,ar_or_ht_of_numbers_or_strings,
            "GUID='427bd573-f22a-439e-a5e4-03c1e0306ed7'\n")
         else # ar_or_ht_of_numbers_or_strings.class==Hash
            ar_keys=ar_or_ht_of_numbers_or_strings.keys
            ar_values=ar_or_ht_of_numbers_or_strings.values
            kibuvits_assert_ar_elements_typecheck_if_is_array(bn,
            ar_cl,ar_keys, "GUID='2aa21281-933f-4abc-b7e4-03c1e0306ed7'\n")
            kibuvits_assert_ar_elements_typecheck_if_is_array(bn,
            ar_cl,ar_values, "GUID='468f8931-cbe9-4e96-99e4-03c1e0306ed7'\n")
         end # if
      end # if
      #----------
      s_corrected_php_array_variable_name=$kibuvits_lc_dollarsign+
      s_php_array_variable_name.sub(/^[$]/,$kibuvits_lc_emptystring)
      s_out=nil
      if ar_or_ht_of_numbers_or_strings.class==Array
         ar_in=ar_or_ht_of_numbers_or_strings
         s_out=s_ar_or_ht_2php_t1_array(s_corrected_php_array_variable_name,
         ar_in,i_row_length)
      else # ar_or_ht_of_numbers_or_strings.class==Hash
         ar_s=Array.new
         ar_s<<s_corrected_php_array_variable_name
         ar_s<<"=array();\n"
         ht_in=ar_or_ht_of_numbers_or_strings
         rgx_0=/[']/
         s_elem=nil
         lc_s_0=(s_corrected_php_array_variable_name+"[").freeze
         lc_s_1="]=".freeze
         lc_s_2=($kibuvits_lc_semicolon+" ").freeze
         ix=0
         ht_in.each_pair do |x_key,x_value|
            ar_s<<$kibuvits_lc_linebreak+"   " if ((ix%i_row_length)==0) && (0<ix)
            ar_s<<lc_s_0
            s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_key,rgx_0)
            ar_s<<lc_s_1
            s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_value,rgx_0)
            ar_s<<lc_s_2
            ix=ix+1
         end # loop
         ar_s<<$kibuvits_lc_linebreak
         s_out=kibuvits_s_concat_array_of_strings(ar_s)
      end # if
      return s_out
   end # s_ar_or_ht_2php_t1


   def Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_of_numbers_or_strings,i_row_length=7)
      s_out=Kibuvits_cg_php_t1.instance.s_ar_or_ht_2php_t1(
      s_php_array_variable_name,ar_or_ht_of_numbers_or_strings,i_row_length)
      return s_out
   end # Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1

   #-----------------------------------------------------------------------

   def s_var(a_binding,x_ruby_variable,i_row_length=7)
      if KIBUVITS_b_DEBUG
         bn=binding()
         ar_types=[Fixnum,Float,String,TrueClass,FalseClass,Hash,Array]
         kibuvits_typecheck bn, Binding, a_binding
         kibuvits_typecheck bn, ar_types, x_ruby_variable
         kibuvits_typecheck bn, Fixnum, i_row_length
         kibuvits_assert_is_smaller_than_or_equal_to(bn, 1, i_row_length,
         "GUID='63c9714d-78f4-423e-a1e4-03c1e0306ed7'\n")
      end # if
      s_variable_name=kibuvits_s_varvalue2varname(a_binding,x_ruby_variable)
      s_out=nil
      s_cl=x_ruby_variable.class.to_s
      case s_cl
      when "Fixnum"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s+";\n"
      when "Float"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s+";\n"
      when "String"
         s_out="$"+s_variable_name+"='"+x_ruby_variable+"';\n"
      when "Hash"
         s_out=s_ar_or_ht_2php_t1(s_variable_name,x_ruby_variable,i_row_length)
      when "Array"
         s_out=s_ar_or_ht_2php_t1(s_variable_name,x_ruby_variable,i_row_length)
      when "TrueClass"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s.upcase+";\n"
      when "FalseClass"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s.upcase+";\n"
      when "NilClass" # a bit risky?
         # Not reached due to entry tests, but here in a role of a comment.
         s_out="$"+s_variable_name+"=NULL;\n"
      else
         kibuvits_throw("s_cl == "+s_cl+
         ", which is not yet supported by this method."+
         "\n GUID='5b9ea653-c981-4908-85e4-03c1e0306ed7'\n\n")
      end # case s_cl
      return s_out
   end # s_var(a_binding,x_ruby_variable)

   def Kibuvits_cg_php_t1.s_var(a_binding,x_ruby_variable,i_row_length=7)
      s_out=Kibuvits_cg_php_t1.instance.s_var(
      a_binding,x_ruby_variable,i_row_length)
      return s_out
   end # Kibuvits_cg_php_t1.s_var(a_binding,x_ruby_variable)

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_cg_php_t1

#=========================================================================

# s_php_array_variable_name="arht_uuu"
# ar_or_ht_x=Hash.new
# ar_or_ht_x["ee"]=44
# ar_or_ht_x[55]="ihii"
# ar_or_ht_x[57]=4.5
# s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
# ar_or_ht_x)
