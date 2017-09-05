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

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_refl.rb"

#==========================================================================

class Kibuvits_refl_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_refl_selftests.test_get_methods_by_name
      rgx=/delet./
      ob="This is a string object"
      s_method_type="public"
      msgcs=Kibuvits_msgc_stack.new
      if kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(rgx,ob,s_method_type,msgcs)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(42,ob,s_method_type,msgcs)}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(rgx,ob,42,msgcs)}
         kibuvits_throw "test 3"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(rgx,ob,s_method_type,42)}
         kibuvits_throw "test 4"
      end # if
      msgcs.clear
      ht=Kibuvits_refl.get_methods_by_name(rgx,ob,s_method_type,msgcs)
      kibuvits_throw "test 5 " if ht.length==0
      kibuvits_throw "test 5.1" if msgcs.b_failure
      if kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(rgx,ob,'private',msgcs)}
         kibuvits_throw "test 6"
      end # if
      if kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(rgx,ob,'protected',msgcs)}
         kibuvits_throw "test 7"
      end # if
      if kibuvits_block_throws{Kibuvits_refl.get_methods_by_name(rgx,ob,'singleton',msgcs)}
         kibuvits_throw "test 8"
      end # if
      def ob.crazy_singleton_method
         kibuvits_writeln "whatever"
      end # crazy_singleton_method
      msgcs.clear
      rgx=/crazy_si.+/
      ht=Kibuvits_refl.get_methods_by_name(rgx,ob,s_method_type,msgcs)
      kibuvits_throw "test 9 " if ht.length!=1
      kibuvits_throw "test 9.1" if msgcs.b_failure
      msgcs.clear
      # The trick at the next line is that the self is the Kibuvits_refl class.
      ht=Kibuvits_refl.get_methods_by_name(/test_get_methods_by_name/,
      self,'any',msgcs)
      i_len=ht.length
      kibuvits_throw "test 10 i_len=="+i_len.to_s if i_len!=1
      kibuvits_throw "test 10.1" if msgcs.b_failure
      msgcs.clear
      ht=Kibuvits_refl.get_methods_by_name(rgx,ob,'this_just_is_NoT_supported',msgcs)
      kibuvits_throw "test 11" if !msgcs.b_failure
   end # Kibuvits_refl_selftests.test_get_methods_by_name

   #-----------------------------------------------------------------------

   def Kibuvits_refl_selftests.test_get_local_variables_from_binding
      Kibuvits_refl.get_local_variables_from_binding(binding())
      if kibuvits_block_throws{Kibuvits_refl.get_local_variables_from_binding(binding())}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.get_local_variables_from_binding(42)}
         kibuvits_throw "test 2"
      end # if
      x=42
      xx=52
      ht=Kibuvits_refl.get_local_variables_from_binding(binding())
      kibuvits_throw "test 3" if ht.length!=4 # ht2 is also counted.
      kibuvits_throw "test 4" if ht["x"]==nil
      kibuvits_throw "test 5" if ht["xx"]==nil
      kibuvits_throw "test 6" if ht["ht"]!=nil
      ht2=Kibuvits_refl.get_local_variables_from_binding(binding(),true)
      kibuvits_throw "test 7" if ht.length!=4
      kibuvits_throw "test 8" if ht2["x"]!=42
      kibuvits_throw "test 9" if ht2["xx"]!=42
      kibuvits_throw "test 10" if ht2["ht"]!=42
      kibuvits_throw "test 11" if ht2["ht2"]!=42
   end # Kibuvits_refl_selftests.test_get_local_variables_from_binding

   #-----------------------------------------------------------------------

   def Kibuvits_refl_selftests.test_get_instances_from_binding_by_class
      bn=binding()
      if kibuvits_block_throws{Kibuvits_refl.get_instances_from_binding_by_class(bn)}
         kibuvits_throw "test 1"
      end # if
      if kibuvits_block_throws{Kibuvits_refl.get_instances_from_binding_by_class(bn,String)}
         kibuvits_throw "test 2"
      end # if
      if KIBUVITS_b_DEBUG
         if !kibuvits_block_throws{Kibuvits_refl.get_instances_from_binding_by_class(42,[])}
            kibuvits_throw "test 3"
         end # if
         if !kibuvits_block_throws{Kibuvits_refl.get_instances_from_binding_by_class(bn,42)}
            kibuvits_throw "test 4"
         end # if
      end # if
      s1="Hi"
      s2="Hi2"
      ht=Kibuvits_refl.get_instances_from_binding_by_class(bn,String)
      kibuvits_throw "test 5" if ht.length!=2
      kibuvits_throw "test 6" if !ht.has_key? "s1"
      kibuvits_throw "test 7" if !ht.has_key? "s2"
      i1=42
      fd1=42.3
      ht=Kibuvits_refl.get_instances_from_binding_by_class(bn,
      [String,Integer])
      kibuvits_throw "test 8" if ht.length!=3
   end # Kibuvits_refl_selftests.test_get_instances_from_binding_by_class

   #-----------------------------------------------------------------------

   def Kibuvits_refl_selftests.test_str2sym
      bn=binding()
      if kibuvits_block_throws{Kibuvits_refl.str2sym("fff")}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.str2sym("contains some spaces")}
         kibuvits_throw "test 2"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.str2sym(42)}
         kibuvits_throw "test 3"
      end # if
      sym=Kibuvits_refl.str2sym("abcd")
      kibuvits_throw "test 4" if sym.class!=Symbol
      kibuvits_throw "test 5" if sym.to_s!="abcd"
   end # Kibuvits_refl_selftests.test_str2sym

   #-----------------------------------------------------------------------

   #   def Kibuvits_refl_selftests.test_get_eigenclass
   #      s1="tere"
   #      s2="tere"
   #      cl_eg_s1=Kibuvits_refl.get_eigenclass(s1)
   #      s="HallooHalloo"
   #      cl_eg_s1.send(:define_singleton_method,:halloo){|| return s}
   #      kibuvits_throw "test 1" if !s1.respond_to? :halloo
   #      if kibuvits_block_throws{s1.halloo}
   #         kibuvits_throw "test 2"
   #      end # if
   #      if !kibuvits_block_throws{s2.halloo}
   #         kibuvits_throw "test 3"
   #      end # if
   #      kibuvits_throw "test 4" if s1.halloo!=s
   #   end # Kibuvits_refl_selftests.test_get_eigenclass

   #-----------------------------------------------------------------------

   def Kibuvits_refl_selftests.test_get_kibuvits_refl_cache_from_class_of
      n=binding()
      msgcs=Kibuvits_msgc_stack.new
      if kibuvits_block_throws{Kibuvits_refl.get_kibuvits_refl_cache_from_class_of(msgcs)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_refl.get_kibuvits_refl_cache_from_class_of(Class)}
         kibuvits_throw "test 2"
      end # if
   end # Kibuvits_refl_selftests.test_get_kibuvits_refl_cache_from_class_of

   #-----------------------------------------------------------------------

   #
   #   def Kibuvits_refl_selftests.test_set_vars_2_binding
   #      bn=binding()
   #      ht_vars=Hash.new
   #      ht_vars['x1']="42"
   #      ht_vars['x2']="52"
   #      if kibuvits_block_throws{Kibuvits_refl.set_vars_2_binding(bn,ht_vars)}
   #         kibuvits_throw "test 1"
   #      end # if
   #      if !kibuvits_block_throws{Kibuvits_refl.set_vars_2_binding(42,ht_vars)}
   #         kibuvits_throw "test 2"
   #      end # if
   #      if !kibuvits_block_throws{Kibuvits_refl.set_vars_2_binding(bn,42)}
   #         kibuvits_throw "test 3"
   #      end # if
   #      Kibuvits_refl.set_vars_2_binding(bn,ht_vars)
   #      s_local_variable="local-variable"
   #      kibuvits_throw "test 4" if defined?(x1)!=s_local_variable
   #      kibuvits_throw "test 5" if defined?(x2)!=s_local_variable
   #      kibuvits_throw "test 6" if x1!=42
   #      kibuvits_throw "test 7" if x2!=52
   #   end # Kibuvits_refl_selftests.test_set_vars_2_binding

   #-----------------------------------------------------------------------

   public
   def Kibuvits_refl_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_refl_selftests.test_get_methods_by_name"
      kibuvits_testeval bn, "Kibuvits_refl_selftests.test_get_local_variables_from_binding"
      kibuvits_testeval bn, "Kibuvits_refl_selftests.test_get_instances_from_binding_by_class"
      kibuvits_testeval bn, "Kibuvits_refl_selftests.test_str2sym"
      #kibuvits_testeval bn, "Kibuvits_refl_selftests.test_get_eigenclass"
      #kibuvits_testeval bn, "Kibuvits_refl_selftests.test_get_kibuvits_refl_cache_from_class_of"
      #kibuvits_testeval bn, "Kibuvits_refl_selftests.test_set_vars_2_binding"
      return ar_msgs
   end # Kibuvits_refl_selftests.selftest

end # class Kibuvits_refl_selftests

#==========================================================================

