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
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
end # if

#==========================================================================

# The class Kibuvits_htoper_t1 is a namespace for general, simplistic,
# functions that read their operands from hashtables or store the
# result to hashtables. The methods of the Kibuvits_htoper_t1 somewhat
# resemble operands that operate on hashtable values. The main idea is
# to abstract away the fetching of values from hashtables and the
# storing of computation results back to the hashtables.
class Kibuvits_htoper_t1
   def initialize
   end # initialize

   #--------------------------------------------------------------------------

   # Returns the value that is returned from the &block
   # by the ruby block analogue of the ruby function return(...),
   # the next(...).
   #
   #        def demo_for_storing_values_back_to_the_hashtable
   #           ht=Hash.new
   #           ht['aa']=42
   #           ht['bb']=74
   #           ht['cc']=2
   #           ht['ht']=ht
   #           x=Kibuvits_htoper_t1.run_in_htspace(ht) do |bb,aa,ht|
   #              ht['cc']=aa+bb
   #           end # block
   #           raise Exception.new("x=="+x.to_s) if ht['cc']!=116
   #        end # demo_for_storing_values_back_to_the_hashtable
   #
   # May be one could figure out, how to improve the
   # implementation of the run_in_htspace(...) so that
   # the block in the demo_for_storing_values_back_to_the_hashtable()
   # would look like:
   #
   #              cc=aa+bb
   #
   # but the solution shown in the current version of the
   # demo_for_storing_values_back_to_the_hashtable(...)
   # seems to be more robust in terms of future changes in the
   # Ruby language implementation.
   #
   def run_in_htspace(ht,a_binding=nil,&block)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash,ht
         kibuvits_typecheck bn, Proc,block
         kibuvits_typecheck bn, [NilClass,Binding],a_binding
      end # if
      ar_of_ar=block.parameters
      s_block_arg_name=nil
      ar_block_arg_names=Array.new
      i_nfr=ar_of_ar.size
      if KIBUVITS_b_DEBUG
         i_nfr.times do |i|
            s_block_arg_name=(ar_of_ar[i])[1].to_s
            if !ht.has_key? s_block_arg_name
               b_ht_varkname_available=false
               s_ht_varname=nil
               if a_binding!=nil
                  s_ht_varname=kibuvits_s_varvalue2varname(a_binding,ht)
                  if s_ht_varname.size!=0
                     b_ht_varkname_available=true
                  end # if
               end # if
               if b_ht_varkname_available
                  kibuvits_throw("The hashtable named \""+s_ht_varname+
                  "\" does not contain a key named \""+s_block_arg_name+"\".")
               else
                  kibuvits_throw("The hashtable "+
                  "does not contain a key named \""+s_block_arg_name+"\".")
               end # if
            end # if
            ar_block_arg_names<<s_block_arg_name
         end # loop
      else
         i_nfr.times do |i|
            s_block_arg_name=(ar_of_ar[i])[1].to_s
            ar_block_arg_names<<s_block_arg_name
         end # loop
      end # if
      ar_method_arguments=Array.new
      i_nfr.times do |i|
         s_block_arg_name=ar_block_arg_names[i]
         ar_method_arguments<<ht[s_block_arg_name]
      end # loop
      x_out=kibuvits_call_by_ar_of_args(block,:call,ar_method_arguments)
      return x_out
   end # run_in_htspace

   def Kibuvits_htoper_t1.run_in_htspace(ht,a_binding=nil,&block)
      x_out=Kibuvits_htoper_t1.instance.run_in_htspace(ht,a_binding,&block)
      return x_out
   end # Kibuvits_htoper_t1.run_in_htspace

   #--------------------------------------------------------------------------

   # ht[s_key]=ht[s_key]+x_value_to_add
   #
   # The ht[s_key] must have the + operator/method defined
   # for the type of the x_value_to_add and the key, s_key,
   # must be present in the hashtable.
   #
   # Returns the version of the instance of ht[s_key] that
   # exists after performing the operation.
   def plus(ht,s_key,x_value_to_add,a_binding=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash,ht
         kibuvits_typecheck bn, String,s_key
         kibuvits_typecheck bn, [NilClass,Binding],a_binding
         if a_binding!=nil
            kibuvits_assert_ht_has_keys(a_binding,ht,s_key)
         else
            kibuvits_assert_ht_has_keys(bn,ht,s_key)
         end # if
      end # if DEBUG
      a=ht[s_key]
      x_sum=a+x_value_to_add
      ht[s_key]=x_sum
      return x_sum
   end # plus

   def Kibuvits_htoper_t1.plus(ht,s_key,x_value_to_add,a_binding=nil)
      x_sum=Kibuvits_htoper_t1.instance.plus(ht,s_key,x_value_to_add,a_binding)
      return x_sum
   end # Kibuvits_htoper_t1.plus

   #--------------------------------------------------------------------------

   # A sparse variables are inspired by sparce matrices.
   # A semi-sparse variable is a variable that is instantiated and
   # inited to the default value at the very first read access.
   def x_getset_semisparse_var(ht,s_varname,x_var_default_value)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash,ht
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_varname)
      end # if DEBUG
      x_out=nil
      if ht.has_key? s_varname
         x_out=ht[s_varname]
      else
         x_out=x_var_default_value
         ht[s_varname]=x_var_default_value
      end # if
      return x_out
   end # x_getset_semisparse_var

   def Kibuvits_htoper_t1.x_getset_semisparse_var(ht,s_varname,x_var_default_value)
      x_out=Kibuvits_htoper_t1.instance.x_getset_semisparse_var(
      ht,s_varname,x_var_default_value)
      return x_out
   end # Kibuvits_htoper_t1.x_getset_semisparse_var

   #--------------------------------------------------------------------------


   # Copies all ht keys to a binding context so that
   # each key-value pair will form a variable-value pair in the binding.
   #
   # All keys of the ht must be strings.
   #
   #  # Needs to be dormant till the ruby-lang.org flaw #8438 gets fixed.
   #
   #def ht2binding(ob_binding,ht)
   #if KIBUVITS_b_DEBUG
   #bn=binding()
   #kibuvits_typecheck bn, Binding, ob_binding
   #kibuvits_typecheck bn, Hash, ht
   #ht.each_key do |x_key|
   #bn_1=binding()
   #kibuvits_assert_ok_to_be_a_varname_t1(bn_1,x_key)
   #end # loop
   #end # if DEBUG
   #ar_for_speed=Array.new
   #ht.each_pair do |s_key,x_value|
   #kibuvits_set_var_in_scope(ob_binding,s_key,x_value,ar_for_speed)
   #end # loop
   #end # ht2binding
   #
   #def Kibuvits_htoper_t1.ht2binding(ob_binding,ht)
   #Kibuvits_htoper_t1.instance.ht2binding(ob_binding,ht)
   #end # Kibuvits_htoper_t1.ht2binding

   #--------------------------------------------------------------------------

   # Creates a new Hash instance that contains the same instances
   # that the ht_orig has.
   def ht_clone_with_shared_references(ht_orig)
      ht_out=Hash.new
      ht_orig.each_pair{|x_key,x_value| ht_out[x_key]=x_value}
      return ht_out
   end # ht_clone_with_shared_references

   def Kibuvits_htoper_t1.ht_clone_with_shared_references(ht_orig)
      ht_out=Kibuvits_htoper_t1.instance.ht_clone_with_shared_references(ht_orig)
      return ht_out
   end # Kibuvits_htoper_t1.ht_clone_with_shared_references

   #--------------------------------------------------------------------------

   # If the ht_in has s_key, then new key candidates are
   # generated by counting from N=1. The key candidate will
   # have a form of
   #
   #     s_numeration="0"*<something>+N.to_s
   #     s_candidate=s_numeration+"_"+s_key
   #
   # where i_minimum_amount_of_digits<=s_numeration.length
   def insert_to_ht_without_overwriting_any_key_t1(
      ht_in,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_in
         kibuvits_typecheck bn, String, s_key
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_all_keys_will_contain_numeration_rpefix
         kibuvits_typecheck bn, Fixnum, i_minimum_amount_of_digits
         kibuvits_typecheck bn, String, s_suffix_of_the_prefix
      end # if
      if !b_all_keys_will_contain_numeration_rpefix
         if !ht_in.has_key? s_key
            ht_in[s_key]=x_value
            return
         end # if
      end # if
      func_s_gen_key_candidate=lambda do |i_in|
         s_enum=Kibuvits_str.s_to_s_with_assured_amount_of_digits_t1(
         i_minimum_amount_of_digits, i_in)
         s_out=s_enum+s_suffix_of_the_prefix+s_key
         return s_out
      end # func_s_gen_key_candidate
      i_enum=0
      s_key_candidate=func_s_gen_key_candidate.call(i_enum)
      while ht_in.has_key? s_key_candidate
         i_enum=i_enum+1
         s_key_candidate=func_s_gen_key_candidate.call(i_enum)
      end # loop
      ht_in[s_key_candidate]=x_value
   end # insert_to_ht_without_overwriting_any_key_t1


   def Kibuvits_htoper_t1.insert_to_ht_without_overwriting_any_key_t1(
      ht_in,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      Kibuvits_htoper_t1.instance.insert_to_ht_without_overwriting_any_key_t1(
      ht_in,s_key,x_value,b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits,s_suffix_of_the_prefix)
   end # Kibuvits_htoper_t1.insert_to_ht_without_overwriting_any_key_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_htoper_t1

#==========================================================================
