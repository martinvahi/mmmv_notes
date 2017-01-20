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


if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_dependencymetrics_t1.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_dependencymetrics_t1.rb"
end # if
#==========================================================================

class Kibuvits_dependencymetrics_t1_testclass_1
   def initialize fd_availability
      @fd_availability=fd_availability
   end # initialize

   def x_get_availability(ht_cycle_detection_opmem=Hash.new,fd_threshold=1)
      return @fd_availability
   end # x_get_availability
end # class Kibuvits_dependencymetrics_t1_testclass_1

class Kibuvits_dependencymetrics_t1_testclass_2
   def initialize b_availability
      @b_availability=b_availability
   end # initialize

   def x_get_availability(ht_cycle_detection_opmem=Hash.new,fd_threshold=1)
      return @b_availability
   end # x_get_availability
end # class Kibuvits_dependencymetrics_t1_testclass_2

class Kibuvits_dependencymetrics_t1_testclass_3
   def initialize i_availability, s_name,ht_objects,ht_dependency_relations
      @i_availability=i_availability
      @s_name=s_name
      @ht_dependency_relations=ht_dependency_relations
      @ht_objects=ht_objects
   end # initialize

   def x_get_availability(ht_cycle_detection_opmem=Hash.new,fd_threshold=1)
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      @s_name,@ht_dependency_relations,@ht_objects,
      "x_get_availability",ht_cycle_detection_opmem,fd_threshold)
      return fd_x
   end # x_get_availability
end # class Kibuvits_dependencymetrics_t1_testclass_3

#--------------------------------------------------------------------------

class Kibuvits_dependencymetrics_t1_selftests

   def initialize
   end #initialize

   #private
   #-----------------------------------------------------------------------

   def Kibuvits_dependencymetrics_t1_selftests.test_set_1

      #-----------------------------------------------------
      s_dependent_object_name="ob_1"
      ht_dependency_relations=Hash.new
      ht_objects=Hash.new
      ht_cycle_detection_opmem=Hash.new
      s_or_sym_method=:x_get_availability
      fd_threshold=9
      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:5   |  ob_3:8 ob_4:9
      ht_objects[s_dependent_object_name]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(5)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(8)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_dependency_relations["ob_2"]=["ob_3", "ob_4"]
      fd_threshold=9
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 1 fd_x=="+fd_x.to_s if fd_x!=9
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 2 s_x=="+s_x.to_s if s_x!="ob_4"

      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:1   |  ob_3:0
      # ob_4:0   |  ob_5:1
      # ob_6:0   |  ob_7:8   ob_8:0
      # ob_9:0   |  ob_10:0  ob_11:0  ob_12:1
      # ob_13:4  |  nil
      ht_objects[s_dependent_object_name]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(1)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_5"]=Kibuvits_dependencymetrics_t1_testclass_1.new(1)
      ht_objects["ob_6"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_7"]=Kibuvits_dependencymetrics_t1_testclass_1.new(8)
      ht_objects["ob_8"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_9"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_10"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_11"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0)
      ht_objects["ob_12"]=Kibuvits_dependencymetrics_t1_testclass_1.new(1)
      ht_objects["ob_13"]=Kibuvits_dependencymetrics_t1_testclass_1.new(4)
      ht_dependency_relations["ob_2"]="ob_3"
      ht_dependency_relations["ob_4"]=["ob_5"]
      ht_dependency_relations["ob_6"]=["ob_7","ob_8"]
      ht_dependency_relations["ob_9"]=["ob_10","ob_11","ob_12"]
      ht_dependency_relations["ob_13"]=nil

      fd_threshold=1
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 3 fd_x=="+fd_x.to_s if fd_x!=1
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 4 s_x=="+s_x.to_s if s_x!="ob_2"
      s_x=ht_dependencies["ob_4"]
      kibuvits_throw "test 5 s_x=="+s_x.to_s if s_x!="ob_5"
      s_x=ht_dependencies["ob_6"]
      kibuvits_throw "test 6 s_x=="+s_x.to_s if s_x!="ob_7"
      s_x=ht_dependencies["ob_9"]
      kibuvits_throw "test 7 s_x=="+s_x.to_s if s_x!="ob_12"
      s_x=ht_dependencies["ob_13"]
      kibuvits_throw "test 8 s_x=="+s_x.to_s if s_x!="ob_13"
      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:t   |  ob_3:f
      # ob_4:f   |  ob_5:t
      # ob_6:t   |  ob_7:t   ob_8:t
      # ob_9:f   |  ob_10:f  ob_11:t  ob_12:t
      # ob_13:t  |  nil
      ht_objects[s_dependent_object_name]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_5"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_6"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_7"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_8"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_9"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_10"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_11"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_12"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_13"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_dependency_relations["ob_2"]="ob_3"
      ht_dependency_relations["ob_4"]=["ob_5"]
      ht_dependency_relations["ob_6"]=["ob_7","ob_8"]
      ht_dependency_relations["ob_9"]=["ob_10","ob_11","ob_12"]
      ht_dependency_relations["ob_13"]=nil

      fd_threshold=9999999
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method)

      kibuvits_throw "test 9 fd_x=="+fd_x.to_s if fd_x!=1
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 10 s_x=="+s_x.to_s if s_x!="ob_2"
      s_x=ht_dependencies["ob_4"]
      kibuvits_throw "test 11 s_x=="+s_x.to_s if s_x!="ob_5"
      s_x=ht_dependencies["ob_6"]
      kibuvits_throw "test 12 s_x=="+s_x.to_s if s_x!="ob_6"
      s_x=ht_dependencies["ob_9"]
      kibuvits_throw "test 13 s_x=="+s_x.to_s if s_x!="ob_11"
      s_x=ht_dependencies["ob_13"]
      kibuvits_throw "test 14 s_x=="+s_x.to_s if s_x!="ob_13"

      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:t   |  ob_3:f
      # ob_4:f   |  ob_5:t
      # ob_6:t   |  ob_7:t   ob_8:t
      # ob_9:f   |  ob_10:f  ob_11:t  ob_12:t
      # ob_13:t  |  nil
      ht_objects[s_dependent_object_name]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      #ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      #ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_5"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_6"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_7"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_8"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      #ht_objects["ob_9"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_10"]=Kibuvits_dependencymetrics_t1_testclass_2.new(false)
      ht_objects["ob_11"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_12"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_objects["ob_13"]=Kibuvits_dependencymetrics_t1_testclass_2.new(true)
      ht_dependency_relations["ob_2"]="ob_3"
      ht_dependency_relations["ob_4"]=["ob_5"]
      ht_dependency_relations["ob_6"]=["ob_7","ob_8"]
      ht_dependency_relations["ob_9"]=["ob_10","ob_11","ob_12"]
      ht_dependency_relations["ob_13"]=nil

      fd_threshold=9999999
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem)

      kibuvits_throw "test 9 fd_x=="+fd_x.to_s if fd_x!=1
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 10 s_x=="+s_x.to_s if s_x!="ob_2"
      s_x=ht_dependencies["ob_4"]
      kibuvits_throw "test 11 s_x=="+s_x.to_s if s_x!="ob_5"
      s_x=ht_dependencies["ob_6"]
      kibuvits_throw "test 12 s_x=="+s_x.to_s if s_x!="ob_6"
      s_x=ht_dependencies["ob_9"]
      kibuvits_throw "test 13 s_x=="+s_x.to_s if s_x!="ob_11"
      s_x=ht_dependencies["ob_13"]
      kibuvits_throw "test 14 s_x=="+s_x.to_s if s_x!="ob_13"

      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:5   |  []
      # ob_3:5   |  nil
      # ob_4:5   |  ""
      ht_objects["ob_1"]=Kibuvits_dependencymetrics_t1_testclass_1.new(34)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(8)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(4.5)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_dependency_relations["ob_2"]=[]
      ht_dependency_relations["ob_3"]=nil
      ht_dependency_relations["ob_4"]=""
      fd_threshold=2
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      "ob_1",ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 15 fd_x=="+fd_x.to_s if fd_x!=4.5
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 16 s_x=="+s_x.to_s if s_x!="ob_2"
      s_x=ht_dependencies["ob_3"]
      kibuvits_throw "test 17 s_x=="+s_x.to_s if s_x!="ob_3"
      s_x=ht_dependencies["ob_4"]
      kibuvits_throw "test 18 s_x=="+s_x.to_s if s_x!="ob_4"

      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:5   |  []
      # ob_3:5   |  nil
      # ob_4:5   |  ""
      ht_objects["ob_1"]=Kibuvits_dependencymetrics_t1_testclass_1.new(34)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0.5)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_dependency_relations["ob_2"]=[]
      ht_dependency_relations["ob_3"]=nil
      ht_dependency_relations["ob_4"]=""
      fd_threshold=2
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      "ob_1",ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 19 fd_x=="+fd_x.to_s if fd_x!=0.5
      i_ht_dependencies_keys_len=ht_dependencies.keys.size
      kibuvits_throw "test 19a i_ht_dependencies_keys_len=="+i_ht_dependencies_keys_len.to_s if i_ht_dependencies_keys_len!=3
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 20 s_x=="+s_x.to_s if s_x!="ob_2"
      s_x=ht_dependencies["ob_3"]
      kibuvits_throw "test 21 s_x=="+s_x.to_s if s_x!="ob_3"
      s_x=ht_dependencies["ob_4"]
      kibuvits_throw "test 22 s_x=="+s_x.to_s if s_x!="ob_4"

      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_1:?
      # ob_2:5   |  []
      # ob_3:5   |  nil
      # ob_4:5   |  ""
      ht_objects["ob_1"]=Kibuvits_dependencymetrics_t1_testclass_1.new(34)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(0.5)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_1.new(98)
      ht_dependency_relations["ob_2"]=["ob_3","ob_4"]
      ht_dependency_relations["ob_3"]=nil
      ht_dependency_relations["ob_4"]=""
      fd_threshold=2
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      "ob_1",ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 23 fd_x=="+fd_x.to_s if fd_x!=9
      i_ht_dependencies_keys_len=ht_dependencies.keys.size
      kibuvits_throw "test 23a i_ht_dependencies_keys_len=="+i_ht_dependencies_keys_len.to_s if i_ht_dependencies_keys_len!=3
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 24 s_x=="+s_x.to_s if s_x!="ob_3"
      s_x=ht_dependencies["ob_3"]
      kibuvits_throw "test 25 s_x=="+s_x.to_s if s_x!="ob_3"
      s_x=ht_dependencies["ob_4"]
      kibuvits_throw "test 26 s_x=="+s_x.to_s if s_x!="ob_4"

      #-----------------------------------------------------

   end # Kibuvits_dependencymetrics_t1_selftests.test_set_1


   #-----------------------------------------------------------------------

   def Kibuvits_dependencymetrics_t1_selftests.test_set_2

      #-----------------------------------------------------
      s_dependent_object_name="ob_1"
      ht_dependency_relations=Hash.new
      ht_objects=Hash.new
      ht_cycle_detection_opmem=Hash.new
      s_or_sym_method=:x_get_availability
      fd_threshold=9
      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      # ob_4:?
      # ob_1:5   |  nil
      ht_deprel_2=Hash.new
      ht_deprel_2["ob_2"]=["ob_1"]

      # ob_1:?
      # ob_2:5   |  ob_3:8 ob_4:xx ob_5:9
      ht_objects[s_dependent_object_name]=Kibuvits_dependencymetrics_t1_testclass_1.new(99)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(5)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(8)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_3.new(2, "ob_4",ht_objects,ht_deprel_2)
      ht_objects["ob_5"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_dependency_relations["ob_2"]=["ob_3", "ob_4", "ob_5"]
      fd_threshold=9
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 1 fd_x=="+fd_x.to_s if fd_x!=9
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 2 s_x=="+s_x.to_s if s_x!="ob_5"

      #-----------------------------------------------------
      ht_objects.clear
      ht_dependency_relations.clear
      ht_deprel_2.clear
      # ob_4:?
      # ob_1:5   |  nil
      ht_deprel_2=Hash.new
      ht_deprel_2["ob_2"]=["ob_6"]

      # ob_1:?
      # ob_2:5   |  ob_3:8 ob_4:xx ob_5:9
      ht_objects[s_dependent_object_name]=Kibuvits_dependencymetrics_t1_testclass_1.new(99)
      ht_objects["ob_2"]=Kibuvits_dependencymetrics_t1_testclass_1.new(5)
      ht_objects["ob_3"]=Kibuvits_dependencymetrics_t1_testclass_1.new(8)
      ht_objects["ob_4"]=Kibuvits_dependencymetrics_t1_testclass_3.new(2, "ob_4",ht_objects,ht_deprel_2)
      ht_objects["ob_5"]=Kibuvits_dependencymetrics_t1_testclass_1.new(9)
      ht_objects["ob_6"]=Kibuvits_dependencymetrics_t1_testclass_1.new(13)
      ht_dependency_relations["ob_2"]=["ob_3", "ob_4", "ob_5"]
      fd_threshold=9
      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method,ht_cycle_detection_opmem,fd_threshold)

      kibuvits_throw "test 3 fd_x=="+fd_x.to_s if fd_x!=13
      s_x=ht_dependencies["ob_2"]
      kibuvits_throw "test 4 s_x=="+s_x.to_s if s_x!="ob_4"
      #-----------------------------------------------------

   end # Kibuvits_dependencymetrics_t1_selftests.test_set_2

   #-----------------------------------------------------------------------
   public
   def Kibuvits_dependencymetrics_t1_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_dependencymetrics_t1_selftests.test_set_1"
      kibuvits_testeval bn, "Kibuvits_dependencymetrics_t1_selftests.test_set_2"
      return ar_msgs
   end # Kibuvits_dependencymetrics_t1_selftests.selftest

end # class Kibuvits_dependencymetrics_t1_selftests

#--------------------------------------------------------------------------

#==========================================================================
#Kibuvits_dependencymetrics_t1_selftests.test_set_1
#Kibuvits_dependencymetrics_t1_selftests.test_set_2
#puts Kibuvits_dependencymetrics_t1_selftests.selftest.to_s

