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

# The class Kibuvits_htoper is a namespace for general, simplistic,
# functions that read their operands from hashtables or store the
# result to hashtables. The methods of the Kibuvits_htoper somewhat
# resemble operands that operate on hashtable values. The main idea is
# to abstract away the fetching of values from hashtables and the
# storing of computation results back to the hashtables.
class Kibuvits_htoper
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
   #           x=Kibuvits_htoper.run_in_htspace(ht) do |bb,aa,ht|
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

   def Kibuvits_htoper.run_in_htspace(ht,a_binding=nil,&block)
      x_out=Kibuvits_htoper.instance.run_in_htspace(ht,a_binding,&block)
      return x_out
   end # Kibuvits_htoper.run_in_htspace

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

   def Kibuvits_htoper.plus(ht,s_key,x_value_to_add,a_binding=nil)
      x_sum=Kibuvits_htoper.instance.plus(ht,s_key,x_value_to_add,a_binding)
      return x_sum
   end # Kibuvits_htoper.plus

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

   def Kibuvits_htoper.x_getset_semisparse_var(ht,s_varname,x_var_default_value)
      x_out=Kibuvits_htoper.instance.x_getset_semisparse_var(
      ht,s_varname,x_var_default_value)
      return x_out
   end # Kibuvits_htoper.x_getset_semisparse_var

   #--------------------------------------------------------------------------

   public
   include Singleton
   # The Kibuvits_htoper.selftest analogue is
   # in a separate selftest file.

end # class Kibuvits_htoper

#==========================================================================
