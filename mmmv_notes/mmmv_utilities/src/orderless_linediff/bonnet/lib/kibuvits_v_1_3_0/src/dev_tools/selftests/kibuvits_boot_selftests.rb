#!/opt/ruby/bin/ruby -Ku
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
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
else
   require  "kibuvits_boot.rb"
end # if
#==========================================================================

class Kibuvits_boot_selftests_testclass_1
   def initialize
   end # initialize

   def func_with_4_args_and_without_a_block(a,b,c,d)
      x_out=a+b+c+d
      return x_out
   end # func_with_4_args_and_without_a_block

   def func_with_4_args_and_with_a_block(a,b,c,d,&block)
      x_sum=a+b+c+d
      x_out=yield(x_sum)
      return x_out
   end # func_with_4_args_and_with_a_block

   def func_with_10_args_and_without_a_block(x1,x2,x3,x4,x5,
      x6,x7,x8,x9,x10)
      x_out=x1+x2+x3+x4+x5+x6+x7+x8+x9+x10
      return x_out
   end # func_with_10_args_and_without_a_block

   def func_with_10_args_and_with_a_block(x1,x2,x3,x4,x5,
      x6,x7,x8,x9,x10,&block)
      x_sum=x1+x2+x3+x4+x5+x6+x7+x8+x9+x10
      x_out=yield(x_sum)
      return x_out
   end # func_with_10_args_and_with_a_block

end # class Kibuvits_boot_selftests_testclass_1


# It tests functions that reside within the kibuvits_boot.rb .
class Kibuvits_boot_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_ht_has_keyvaluepairs_s

      ht_test=Hash.new
      ht_test["hi"]="there"
      ht_test["welcome"]="to heaven"
      ht_test["nice"]="day"
      ht_test["whatever"]="ohter string value"

      a_binding=binding()

      # A single compulsory key-value pair:
      kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,["hi","there"])

      # Multiple compulsory key-value pairs:
      kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
      [["hi","there"],["nice","day"]])

      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
         [["nice","day"],["key_does_not_exist","there"]])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
         [["key_does_not_exist","there"],["nice","day"]])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2.a" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
         ["key_does_not_exist","there"])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2.b" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
         [["nice","day"],["hi","value_does_not_exist"]])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
         [["hi","value_does_not_exist"],["nice","day"]])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3.a" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,
         ["hi","value_does_not_exist"])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3.b" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,[])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,[4,"ehee"])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht_test,["hi",42])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5a" if !b_thrown

      #kibuvits_throw "test 4" if ar[2]!="CC"
   end # Kibuvits_boot_selftests.test_kibuvits_assert_ht_has_keyvaluepairs_s

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_arrayix
      ar=["aa",42,"cc"]
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,0)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,1)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,2)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[0,1,2])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[2])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if b_thrown

      #-------start-of-tests-where-throwing-isneeded-for-passing---
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,3)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[3])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 7" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,(-1))
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 8" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[-1])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 9" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 10" if !b_thrown
      #------------
      ar=Array.new
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,0)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 11" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,(-1))
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 12" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 13" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[(-1),0])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 14" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_arrayix(a_binding,ar,[(-1)])
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 15" if !b_thrown
   end # Kibuvits_boot_selftests.test_kibuvits_assert_arrayix

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_ht_container_version
      ht_xx=Hash.new
      ht_xx[$kibuvits_lc_s_version]="vvvX"
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         {$kibuvits_lc_s_version=>"vvvX"},"vvvX")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         ht_xx,"vvvX")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         ht_xx,"vvvX","Some sort of a error message suffix")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2.a" if b_thrown
      #-------start-of-tests-where-throwing-isneeded-for-passing---
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         {"something_else"=>"vvvX"},"vvvX") # missing key
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         Hash.new,"vvvX") # missing key
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         {$kibuvits_lc_s_version=>"vZvX"},"vvvX") # wrong value
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if !b_thrown
      #------------
      b_thrown=false
      ht_xx[$kibuvits_lc_s_version]="vZvX"
      begin
         a_binding=binding()
         kibuvits_assert_ht_container_version(a_binding,
         ht_xx,"vvvX") # wrong value
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
   end # Kibuvits_boot_selftests.test_kibuvits_assert_ht_container_version

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_eval_t1
      #------------
      s_script="ar_out<<42"
      ar_x=kibuvits_eval_t1(s_script)
      raise "test 1" if ar_x.length!=1
      raise "test 2" if ar_x[0]!=42
      #------------
      b_thrown=false
      begin
         s_script="ar_out=Array.new"
         ar_x=kibuvits_eval_t1(s_script)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if !b_thrown
      #------------
      b_thrown=false
      begin
         s_script="ar_out=[]"
         ar_x=kibuvits_eval_t1(s_script)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if !b_thrown
      #------------
      b_thrown=false
      begin
         s_script="ar_in=[]"
         ar_x=kibuvits_eval_t1(s_script)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if !b_thrown
      #------------
      b_thrown=false
      begin
         s_script="ar_in = Array.new"
         ar_x=kibuvits_eval_t1(s_script)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
      #------------
      ar_in=[77,23]
      s_script="ar_out<<(ar_in[0]+ar_in[1])"
      ar_x=kibuvits_eval_t1(s_script,ar_in)
      raise "test 7.a" if ar_x.length!=1
      raise "test 7.b" if ar_x[0]!=100
   end # Kibuvits_boot_selftests.test_kibuvits_eval_t1

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_class_name_prefix
      #------------
      b_thrown=false
      begin
         bn=binding()
         s_or_cl_prefix="Str"
         ob="Hallo"
         kibuvits_assert_class_name_prefix(bn,ob,s_or_cl_prefix)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         s_or_cl_prefix="H"
         ob="Hallo"
         kibuvits_assert_class_name_prefix(bn,ob,s_or_cl_prefix)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if !b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         s_or_cl_prefix=42.class
         ob="Hallo"
         kibuvits_assert_class_name_prefix(bn,ob,s_or_cl_prefix)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if !b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         s_or_cl_prefix=42.class
         ob=44
         kibuvits_assert_class_name_prefix(bn,ob,s_or_cl_prefix)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if b_thrown
      #------------
   end # Kibuvits_boot_selftests.test_kibuvits_assert_class_name_prefix

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_responds_2_method
      #------------
      b_thrown=false
      begin
         bn=binding()
         x_method_name_or_method_or_symbol="to_s"
         ob="Hallo"
         kibuvits_assert_responds_2_method(bn,ob,
         x_method_name_or_method_or_symbol)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         x_method_name_or_method_or_symbol=:to_s
         ob="Hallo"
         kibuvits_assert_responds_2_method(bn,ob,
         x_method_name_or_method_or_symbol)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         x_method_name_or_method_or_symbol="hi".method(:to_s)
         ob="Hallo"
         kibuvits_assert_responds_2_method(bn,ob,
         x_method_name_or_method_or_symbol)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if b_thrown
      #------------
      # The start of throwing test cases.
      #------------
      b_thrown=false
      begin
         bn=binding()
         x_method_name_or_method_or_symbol="thisMethodCouldPossiblyNot_exist_we_are_trolling_around"
         ob="Hallo"
         kibuvits_assert_responds_2_method(bn,ob,
         x_method_name_or_method_or_symbol)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if !b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         x_method_name_or_method_or_symbol=:thisMethodCouldPossiblyNot_exist_we_are_trolling_around
         ob="Hallo"
         kibuvits_assert_responds_2_method(bn,ob,
         x_method_name_or_method_or_symbol)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if !b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         x_method_name_or_method_or_symbol=Kernel.method(:eval)
         ob="Hallo"
         kibuvits_assert_responds_2_method(bn,ob,
         x_method_name_or_method_or_symbol)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
      #------------
   end # Kibuvits_boot_selftests.test_kibuvits_assert_responds_2_method

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_string_min_length
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=0
         s_in=""
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=0
         s_in="Something"
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=1
         s_in="X"
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=1
         s_in="xx"
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=1
         s_in="xxxxx"
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if b_thrown
      #------------
      # The start of the throwing test cases.
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=99
         s_in="xxxxx"
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=1
         s_in=""
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 7" if !b_thrown
      #------------
      b_thrown=false
      begin
         bn=binding()
         i_min_length=2
         s_in="x"
         kibuvits_assert_string_min_length(bn,s_in,i_min_length)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 8" if !b_thrown
      #------------
   end # Kibuvits_boot_selftests.test_kibuvits_assert_string_min_length

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_call_by_ar_of_args
      #------------
      b_thrown=false
      begin
         ob="Hello"
         x_method_name_or_symbol="to_s".to_sym
         ar_method_arguments=[]
         kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         ob=42
         x_method_name_or_symbol=:times
         ar_method_arguments=[]
         # A version with a block
         kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments){}
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if b_thrown
      #------------
      b_thrown=false
      begin
         ob=Kibuvits_boot_selftests_testclass_1.new
         x_method_name_or_symbol="func_with_4_args_and_without_a_block"
         ar_method_arguments=[3,7,11,13]
         x=kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments)
         raise "x=="+x.to_s if x!=34
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if b_thrown
      #------------
      b_thrown=false
      begin
         ob=Kibuvits_boot_selftests_testclass_1.new
         x_method_name_or_symbol="func_with_4_args_and_with_a_block"
         ar_method_arguments=[3,7,11,15]
         x=kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments) do |x_sum|
            next(x_sum+3)
         end # block
         raise "x=="+x.to_s if x!=(36+3)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if b_thrown
      #------------
      b_thrown=false
      begin
         ob=Kibuvits_boot_selftests_testclass_1.new

         # The classics:
         # 1 2 3 4
         # 4 3 2 1
         # sum=n*(n+1)/2

         x_method_name_or_symbol="func_with_10_args_and_without_a_block"
         ar_method_arguments=[1,2,3,4,5,6,7,8,9,10] # sum==10*(1+10)/2=(10+100)/2=55
         x=kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments)
         raise "x=="+x.to_s if x!=55
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 41" if b_thrown
      #------------
      b_thrown=false
      begin
         ob=Kibuvits_boot_selftests_testclass_1.new
         x_method_name_or_symbol="func_with_10_args_and_with_a_block"
         ar_method_arguments=[1,2,3,4,5,6,7,8,9,10]
         x=kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments) do |x_sum|
            next(x_sum+3)
         end # block
         raise "x=="+x.to_s if x!=(55+3)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 44" if b_thrown
      #------------
      # The start of the throwing test cases.
      #------------
      #------------
      b_thrown=false
      begin
         ob="Hello"
         x_method_name_or_symbol=42
         ar_method_arguments=[]
         kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
      #------------
      b_thrown=false
      begin
         ob="Hello"
         x_method_name_or_symbol=:to_s
         ar_method_arguments=nil
         kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 7" if !b_thrown
      #------------
   end # Kibuvits_boot_selftests.test_kibuvits_call_by_ar_of_args

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_class_inheritance_related_assertions_t1
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         ob="xx"
         kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,
         ob,String)
         kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,
         ob,Object)
         kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,
         ob,"String")
         kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,
         ob,"Object")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         ob="xx"
         kibuvits_assert_is_inherited_from_and_does_not_equal_with_class(a_binding,
         ob,Object)
         kibuvits_assert_is_inherited_from_and_does_not_equal_with_class(a_binding,
         ob,"Object")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if b_thrown
      #------------
      # The start of the throwing test cases.
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         ob="xx"
         kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,
         ob,Hash)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 3" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         ob="xx"
         kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,
         ob,"Hash")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 4" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         ob="xx"
         kibuvits_assert_is_inherited_from_and_does_not_equal_with_class(a_binding,
         ob,String)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 5" if !b_thrown
      #------------
      b_thrown=false
      begin
         a_binding=binding()
         ob="xx"
         kibuvits_assert_is_inherited_from_and_does_not_equal_with_class(a_binding,
         ob,"String")
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 6" if !b_thrown
   end # Kibuvits_boot_selftests.test_class_inheritance_related_assertions_t1

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_b_not_suitable_for_a_varname_t1
      ar_1=["_","wow","x","xx","_xx_","KIBUVITS_SELFTESTS_TESTENV_1"]
      ar_1.each do |s_x|
         b_x=kibuvits_b_not_suitable_for_a_varname_t1(s_x)
         raise("test 1 s_x=="+s_x.to_s)if b_x
      end # loop

      ar_1=[""," ","a b","_ a","\n","\t","\r","(","(uhuu)","(x","x)",")"]
      ar_1.concat(["[w","x]","[","]","[fff]","[\nfff","fff\n]"])
      ar_1.concat(["(w","x)","(",")","(fff)","(\nfff","fff\n)"])
      ar_1.concat(["{w","x}","{","}","{fff}","{\nfff","fff\n}"])
      ar_1.concat([",x",":x","x;","$ff","$"])
      ar_1.each do |s_x|
         b_x=kibuvits_b_not_suitable_for_a_varname_t1(s_x)
         raise("test 2 s_x=="+s_x.to_s) if !b_x
      end # loop
   end # Kibuvits_boot_selftests.test_kibuvits_b_not_suitable_for_a_varname_t1

   def Kibuvits_boot_selftests.test_kibuvits_assert_ok_to_be_a_varname_t1
      b_thrown=false
      begin
         a_binding=binding()
         s_x="this_is_a_valid_variable_name"
         kibuvits_assert_ok_to_be_a_varname_t1(a_binding,s_x)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1" if b_thrown
      b_thrown=false
      begin
         a_binding=binding()
         s_x="This is not a valid variable name, because it contains spaces and a point."
         kibuvits_assert_ok_to_be_a_varname_t1(a_binding,s_x)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2" if !b_thrown
   end # Kibuvits_boot_selftests.test_kibuvits_assert_ok_to_be_a_varname_t1

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_assert_is_among_values
      ar=["aaa","bbb","ccc"]
      ht=Hash.new
      ht["key_aaa"]="aaa"
      ht["key_bbb"]="bbb"
      ht["key_ccc"]="ccc"
      #-------------------------------------------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         s_x="aaa"
         kibuvits_assert_is_among_values(a_binding,ar,s_x)
         kibuvits_assert_is_among_values(a_binding,ht,s_x)
         kibuvits_assert_is_among_values(a_binding,s_x,s_x)
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 1a e.to_s=="+s_0 if b_thrown
      #--------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         s_x="bbb"
         kibuvits_assert_is_among_values(a_binding,ar,s_x)
         kibuvits_assert_is_among_values(a_binding,ht,s_x)
         kibuvits_assert_is_among_values(a_binding,s_x,s_x)
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 1b e.to_s=="+s_0 if b_thrown
      #--------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         s_x="ccc"
         kibuvits_assert_is_among_values(a_binding,ar,s_x)
         kibuvits_assert_is_among_values(a_binding,ht,s_x)
         kibuvits_assert_is_among_values(a_binding,s_x,s_x)
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 1c e.to_s=="+s_0 if b_thrown
      #-------------------------------------------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         s_x="Xaaa"
         kibuvits_assert_is_among_values(a_binding,ar,s_x)
         kibuvits_assert_is_among_values(a_binding,ht,s_x)
         kibuvits_assert_is_among_values(a_binding,"XXXX",s_x)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2a " if !b_thrown
      #--------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         s_x="Xbbb"
         kibuvits_assert_is_among_values(a_binding,ar,s_x)
         kibuvits_assert_is_among_values(a_binding,ht,s_x)
         kibuvits_assert_is_among_values(a_binding,"XXXX",s_x)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2b " if !b_thrown
      #--------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         s_x="Xccc"
         kibuvits_assert_is_among_values(a_binding,ar,s_x)
         kibuvits_assert_is_among_values(a_binding,ht,s_x)
         kibuvits_assert_is_among_values(a_binding,"XXXX",s_x)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2c " if !b_thrown
      #-------------------------------------------------------
      ar=[17,42,69]
      ht=Hash.new
      ht["key_17"]=17
      ht["key_42"]=42
      ht["key_69"]=69
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         i_x=69
         kibuvits_assert_is_among_values(a_binding,ar,i_x)
         kibuvits_assert_is_among_values(a_binding,ht,i_x)
         kibuvits_assert_is_among_values(a_binding,i_x,i_x)
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 3a e.to_s=="+s_0 if b_thrown
      #--------------------
      s_0=""
      b_thrown=false
      begin
         a_binding=binding()
         i_x=99
         kibuvits_assert_is_among_values(a_binding,ar,i_x)
         kibuvits_assert_is_among_values(a_binding,ht,i_x)
         kibuvits_assert_is_among_values(a_binding,i_x,i_x)
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 3b e.to_s=="+s_0 if !b_thrown
      #-------------------------------------------------------
   end # Kibuvits_boot_selftests.test_kibuvits_assert_is_among_values

   #-----------------------------------------------------------------------

   def Kibuvits_boot_selftests.test_kibuvits_typecheck_ar_content
      s_0=nil
      #-------------------------------------------------------
      b_thrown=false
      begin
         bn=binding()
         kibuvits_typecheck_ar_content(bn,[String,Integer],["test",42])
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 1a e.to_s=="+s_0 if b_thrown
      #--------------------
      b_thrown=false
      begin
         bn=binding()
         kibuvits_typecheck_ar_content(bn,[String,Integer],["test",33.9])
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 1b " if !b_thrown
      #--------------------
      b_thrown=false
      begin
         bn=binding()
         kibuvits_typecheck_ar_content(bn,String,["test",33.9],"testmsg")
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 2a " if !b_thrown
      #--------------------
      b_thrown=false
      begin
         bn=binding()
         kibuvits_typecheck_ar_content(bn,String,["test","xxxx"],"testmsg")
      rescue Exception => e
         b_thrown=true
         s_0=e.to_s
      end # rescue
      raise "test 2b s_0=="+s_0 if b_thrown
   end # test_kibuvits_typecheck_ar_content

   #-----------------------------------------------------------------------


   def Kibuvits_boot_selftests.test_kibuvits_s_hash
      s_in="xxxx"
      s_x=nil
      #--------------------
      b_thrown=false
      i_bitlen=256
      begin
         s_x=kibuvits_s_hash(s_in,i_bitlen)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1."+i_bitlen.to_s if b_thrown
      #--------------------
      b_thrown=false
      i_bitlen=384
      begin
         s_x=kibuvits_s_hash(s_in,i_bitlen)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1."+i_bitlen.to_s if b_thrown
      #--------------------
      b_thrown=false
      i_bitlen=512
      begin
         s_x=kibuvits_s_hash(s_in,i_bitlen)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 1."+i_bitlen.to_s if b_thrown
      #--------------------
      b_thrown=false
      i_bitlen=42
      begin
         s_x=kibuvits_s_hash(s_in)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2.a" if b_thrown
      #--------------------
      b_thrown=false
      i_bitlen=42
      begin
         s_x=kibuvits_s_hash(s_in,i_bitlen)
      rescue Exception => e
         b_thrown=true
      end # rescue
      raise "test 2."+i_bitlen.to_s if !b_thrown
   end # Kibuvits_boot_selftests.test_kibuvits_s_hash

   #-----------------------------------------------------------------------
   public
   def Kibuvits_boot_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_ht_has_keyvaluepairs_s"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_arrayix"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_ht_container_version"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_eval_t1"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_class_name_prefix"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_responds_2_method"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_string_min_length"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_call_by_ar_of_args"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_class_inheritance_related_assertions_t1"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_b_not_suitable_for_a_varname_t1"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_ok_to_be_a_varname_t1"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_assert_is_among_values"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_typecheck_ar_content"
      kibuvits_testeval bn, "Kibuvits_boot_selftests.test_kibuvits_s_hash"
      return ar_msgs
   end # Kibuvits_boot_selftests.selftest

end # class Kibuvits_boot_selftests

#--------------------------------------------------------------------------

#==========================================================================
#puts Kibuvits_boot_selftests.selftest.to_s

