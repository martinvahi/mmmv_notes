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

# The class Kibuvits_refl is a namespace for reflection related functions
class Kibuvits_refl
   @@lc_empty_array=[]
   @@lc_s_public="public"
   @@lc_s_any="any"
   @@lc_rbrace_linebreak=")\n"
   @@lc_rgx_spacetablinebreak=/[\s\t\n\r]/
   @@lc_mx_rgx_spacetablinebreak=Mutex.new
   @@lc_s_kibuvits_refl_cache_of_class="@@kibuvits_refl_cache_of_class"
   @@lc_s_b_public_static_methods_in_instance_metods_namespace="b_public_static_methods_in_instance_metods_namespace"
   @@lc_s_kibuvits_refl_get_eigenclass="kibuvits_refl_get_eigenclass"
   def initialize
      @b_YAML_lib_not_loaded=true
   end #initialize
   private
   def get_methods_by_name_get_ar_method_names ob,s_method_type, msgcs
      ar_method_names=Array.new
      case s_method_type
      when "private"
         ar_method_names=ob.private_methods
      when "singleton"
         ar_method_names=ob.singleton_methods
      when "public"
         ar_method_names=ob.public_methods
      when "protected"
         ar_method_names=ob.protected_methods
      when "any"
         ar_method_names=ar_method_names+ob.private_methods
         ar_method_names=ar_method_names+ob.singleton_methods
         ar_method_names=ar_method_names+ob.public_methods
         ar_method_names=ar_method_names+ob.protected_methods
      else
         ar=["any","private","protected","public","singleton"]
         s_list_of_valid_values=Kibuvits_str.array2xseparated_list(ar)
         msgcs.cre "Method type \""+s_method_type+"\" is not supported. "+
         "Supported values are: "+s_list_of_valid_values+".",1.to_s
         msgcs.last[$kibuvits_lc_Estonian]="Meetodi tüüp \""+s_method_type+
         "\" ei ole toetatud. Toetatud väätused on: "+
         s_list_of_valid_values+"."
      end # case
      return ar_method_names
   end # get_methods_by_name_get_ar_method_names

   public

   # Returns a hash table, where the method names are keys.
   # The values are set to 42.
   # The domain of the s_method_type is:
   # {"any","public","protected","private","singleton"}
   #
   # In order to get class methods, one should just feed the
   # class in as the ob. For example, if one wants to get
   # a list of all static public methods of class String, one should
   # call: get_methods_by_name(/.+/, String, "public", msgcs)
   def get_methods_by_name(rgx_or_s, ob, s_method_type, msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [String,Regexp], rgx_or_s
         kibuvits_typecheck bn, String, s_method_type
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ht_out=Hash.new
      ar_method_names=get_methods_by_name_get_ar_method_names(ob,s_method_type,msgcs)
      return ht_out if msgcs.b_failure
      rgx=rgx_or_s
      rgx=Regexp.compile(rgx_or_s) if rgx_or_s.class==String
      i_42=42
      md=nil
      ar_method_names.each do |s_method_name|
         md=rgx.match(s_method_name)
         ht_out[s_method_name]=i_42 if md!=nil
      end # loop
      return ht_out
   end # Kibuvits_refl.get_methods_by_name

   def Kibuvits_refl.get_methods_by_name(rgx_or_s, ob, s_method_type, msgcs)
      x=Kibuvits_refl.instance.get_methods_by_name(
      rgx_or_s, ob, s_method_type, msgcs)
      return x
   end # Kibuvits_refl.get_methods_by_name


   public

   # The idea is that one does not want to pollute the binding
   # that is being studied. So, in stead of creating a new, temporary,
   # variable, one sends the acquired values away by using a function,
   # which uses a new, temporary, binding, for the temporary stuff.
   def get_local_variables_from_binding_helper_func1(
      ar_variable_names, i_array_instance_object_id)
      ar=ObjectSpace._id2ref(i_array_instance_object_id)
      ar.concat(ar_variable_names)
   end # get_local_variables_from_binding_helper_func1

   def Kibuvits_refl.get_local_variables_from_binding_helper_func1(
      ar_variable_names, i_array_instance_object_id)
      Kibuvits_refl.instance.get_local_variables_from_binding_helper_func1(
      ar_variable_names, i_array_instance_object_id)
   end # Kibuvits_refl.get_local_variables_from_binding_helper_func1

   def get_local_variables_from_binding_helper_func2(
      i_ht_instance_id, i_key_string_instance_id, ob)
      ht=ObjectSpace._id2ref(i_ht_instance_id)
      ht[ObjectSpace._id2ref(i_key_string_instance_id)]=ob
   end # get_local_variables_from_binding_helper_func2

   def Kibuvits_refl.get_local_variables_from_binding_helper_func2(
      i_ht_instance_id, i_key_string_instance_id, ob)
      Kibuvits_refl.instance.get_local_variables_from_binding_helper_func2(
      i_ht_instance_id, i_key_string_instance_id, ob)
   end # Kibuvits_refl.get_local_variables_from_binding_helper_func2

   # Returns a hashtable, where the keys are variable names and values
   # are references to the instances. If b_return_only_variable_names==true,
   # only the hashtable keys will depict the variables and the values of the
   # hashtable are set to some nonsense.
   def get_local_variables_from_binding(bn_in, b_return_only_variable_names=false)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Binding], bn_in
      end # if
      # The mehtod local_variables() returns variable
      # names in the case of the Ruby 1.8 and Symbol
      # instances in the case of the Ruby 1.9
      ar_varnames_or_symbol=Array.new
      s_script="Kibuvits_refl."+
      "get_local_variables_from_binding_helper_func1(local_variables(),"+
      ar_varnames_or_symbol.object_id.to_s+@@lc_rbrace_linebreak
      eval(s_script,bn_in)
      ar_varnames=Array.new
      ar_varnames_or_symbol.each do |s_or_sym|
         ar_varnames<<s_or_sym.to_s
      end # loop
      ht_out=Hash.new
      if b_return_only_variable_names
         i=42
         ar_varnames.each{|s_varname| ht_out[s_varname]=i}
         return ht_out
      end # if
      s_script_prefix="Kibuvits_refl.get_local_variables_from_binding_helper_func2("+
      ht_out.object_id.to_s+$kibuvits_lc_comma
      ar_varnames.each do |s_varname|
         s_script=s_script_prefix+s_varname.object_id.to_s+
         $kibuvits_lc_comma+s_varname+@@lc_rbrace_linebreak
         eval(s_script,bn_in)
      end # loop
      return ht_out
   end # get_local_variables_from_binding

   def Kibuvits_refl.get_local_variables_from_binding(bn_in,
      b_return_only_variable_names=false)
      ht_out=Kibuvits_refl.instance.get_local_variables_from_binding(
      bn_in,b_return_only_variable_names)
      return ht_out
   end # Kibuvits_refl.get_local_variables_from_binding


   # Returns a hashtable. If the ar_classes_or_a_class is an
   # empty array, all of the local variables are collected.
   def get_instances_from_binding_by_class(bn_in,ar_classes_or_a_class=@@lc_empty_array)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Binding, bn_in
         kibuvits_typecheck bn, [Class,Array], ar_classes_or_a_class
      end # if
      ht_alllocal=get_local_variables_from_binding(bn_in)
      ar_classes=Kibuvits_ix.normalize2array(ar_classes_or_a_class)
      ht_classes=Hash.new
      ar_classes.each{|cl| ht_classes[cl.to_s]=cl}
      ht_out=Hash.new
      ht_alllocal.each_pair do |a_key,a_value|
         if ht_classes.has_key? a_value.class.to_s
            ht_out[a_key]=a_value
         end # if
      end # loop
      return ht_out
   end # get_instances_from_binding_by_class

   def Kibuvits_refl.get_instances_from_binding_by_class(bn_in,
      ar_classes_or_a_class=@@lc_empty_array)
      ht_out=Kibuvits_refl.instance.get_instances_from_binding_by_class(
      bn_in,ar_classes_or_a_class)
      return ht_out
   end # Kibuvits_refl.get_instances_from_binding_by_class(


   # Returns a Symbol instance
   def str2sym(s)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [String],s
      end # if
      kibuvits_throw "s.length==0" if s.length==0
      s1=nil
      if @@lc_mx_rgx_spacetablinebreak.locked?
         rgx=/[\s\t\n\r]/
         s1=s.gsub(rgx,$kibuvits_lc_emptystring)
      else
         @@lc_mx_rgx_spacetablinebreak.synchronize{
            s1=s.gsub(@@lc_rgx_spacetablinebreak,$kibuvits_lc_emptystring)
         }
      end # if
      kibuvits_throw "'"+s+"' contains spaces or tabs or linebreaks."  if s.length!=s1.length
      sym_out=nil
      eval("sym_out=:"+s,binding())
      return sym_out
   end # str2sym

   def Kibuvits_refl.str2sym(s)
      sym_out=Kibuvits_refl.instance.str2sym(s)
      return sym_out
   end # Kibuvits_refl.str2sym(s)


   def get_kibuvits_refl_cache_from_class_of(ob)
      cl=ob.class
      kibuvits_throw "ob.class==Class" if cl==Class
      if cl.class_variable_defined? @@lc_s_kibuvits_refl_cache_of_class
         ht_out=cl.send(:class_variable_get,@@lc_s_kibuvits_refl_cache_of_class)
         return ht_out
      end # if
      ht_out=Hash.new
      cl.send(:class_variable_set,@@lc_s_kibuvits_refl_cache_of_class,ht_out)
      return ht_out
   end # get_kibuvits_refl_cache_from_class_of

   def Kibuvits_refl.get_kibuvits_refl_cache_from_class_of(ob)
      Kibuvits_refl.instance.get_kibuvits_refl_cache_from_class_of(ob)
   end # Kibuvits_refl.get_kibuvits_refl_cache_from_class_of(ob)


=begin
   public

   def get_eigenclass(ob)
      kibuvits_throw "This mehtod is untested and incomplete"
      b_getter_present=ob.send(:respond_to?,@@lc_s_kibuvits_refl_get_eigenclass)
      if !b_getter_present
         class << ob
            def kibuvits_refl_get_eigenclass
               return self
            end # kibuvits_refl_get_eigenclass
         end
      end # if
      cl=ob.send(:kibuvits_refl_get_eigenclass)
      return cl
   end # get_eigenclass

   def Kibuvits_refl.get_eigenclass(ob)
      cl=Kibuvits_refl.instance.get_eigenclass(ob)
      return cl
   end # Kibuvits_refl.get_eigenclass

=end
   public

   #
   # For some reason, probably garbage collection, the
   # set_vars_2_binding does not work.
   #
   #   def set_vars_2_binding(bn_in,ht_vars)
   # if KIBUVITS_b_DEBUG
   #      bn=binding()
   #      kibuvits_typecheck bn, Binding, bn_in
   #      kibuvits_typecheck bn, Hash, ht_vars
   # end # if
   #      s_script=""
   #      s_tmp1="=ObjectSpace._id2ref("
   #      ht_vars.each_pair do |s_varname,x_var|
   #         s_script=s_script+s_varname+s_tmp1+
   #         x_var.object_id.to_s+@@lc_rbrace_linebreak
   #      end # loop
   #      eval(s_script,bn_in)
   #   end # set_vars_2_binding
   #
   #   def Kibuvits_refl.set_vars_2_binding(bn_in,ht_vars)
   #      Kibuvits_refl.instance.set_vars_2_binding(bn_in,ht_vars)
   #   end # Kibuvits_refl.set_vars_2_binding
   #

   public

   # The case of the Ruby if there's a class method, then it is
   # not possible to access it through a syntax that looks as if it
   # were an instance method. For example, the following code will NOT
   # work:
   #----verbatim--start--
   #    class X
   #        def initialize
   #        end
   #        def X.hi
   #            kibuvits_writeln "Hi there!"
   #        end
   #    end # class X
   #    X.new.hi
   #----verbatim--end----
   #
   # But the following code does work:
   #
   #----verbatim--start--
   # ob=X.new
   # Kibuvits_refl.cp_all_public_static_methods_2_instance_methods_namespace(ob)
   # ob.hi
   #----verbatim--end----
   #
   # It does not override instance methods.
=begin
   def cp_all_public_static_methods_2_instance_methods_namespace(ob,msgcs)
      kibuvits_throw "This mehtod is untested and incomplete"
      if KIBUVITS_b_DEBUG
       bn=binding()
       kibuvits_typecheck bn, [Kibuvits_msgc_stack], msgcs
      end # if
      cl=ob.class
      kibuvits_throw "ob.class==Class" if cl==Class
      ht_cache_on_class=get_kibuvits_refl_cache_from_class_of(ob)
      b_copy=false
      if ht_cache_on_class.has_key? @@lc_s_b_public_static_methods_in_instance_metods_namespace
         b_copy=!ht_cache_on_class[@@lc_s_b_public_static_methods_in_instance_metods_namespace]
      end # if
      return if !b_copy
      rgx=/.+/
      ar_static_methods=get_methods_by_name(rgx,cl,@@lc_s_public,msgcs)
      ar_instance_methods=get_methods_by_name(rgx,cl,@@lc_s_any,msgcs)
      ht_instance_methods=Hash.new
      ar_instance_methods.each do |s_method_name|
         ht_instance_methods[s_method_name]=$kibuvits_lc_emptystring
      end # loop
      ht_static_metohds_2_copy=Hash.new
      ar_static_methods.each do |s_method_name|
         if !ht_instance_methods.has_key? s_method_name
            ht_static_metohds_2_copy[s_method_name]=$kibuvits_lc_emptystring
         end # if
      end # loop

      ht_static_metohds_2_copy.each_key do |s_method_name|
         sym=str2sym(s_method_name)
         cl.send(:define_method,sym){|ff| kibuvits_writeln ff.to_s}
      end # loop
      ht_cache_on_class[lc_s_b_public_static_methods_in_instance_metods_namespace]=true
   end # cp_all_public_static_methods_2_instance_methods_namespace
=end

   include Singleton

end # class Kibuvits_refl
#=========================================================================

#rgx=/clea./
#ob="This is a string object"
#s_method_type="public"
#msgcs=Kibuvits_msgc_stack.new
#ht=Kibuvits_refl.get_methods_by_name(rgx,ob,s_method_type,msgcs)

