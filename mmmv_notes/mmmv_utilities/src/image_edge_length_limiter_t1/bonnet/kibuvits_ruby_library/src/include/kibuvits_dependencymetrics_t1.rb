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

if !defined? KIBUVITS_DEPENDENCYMETRICS_T1_RB_INCLUDED
   KIBUVITS_DEPENDENCYMETRICS_T1_RB_INCLUDED=true

   if !defined? KIBUVITS_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
      require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
   end # if

   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
end # if

#==========================================================================

# The class Kibuvits_dependencymetrics_t1 is a namespace for methods
# that provide answers about a instances that have their
# dependency graph described and acessible according to
# the specification that the Kibuvits_dependencymetrics_t1
# is designed to use. The specification is described by the
# following example:
#
# The dependencies graph is described in the format of a hashtable:
#
# ht_dependency_relations=Hash.new
# ht_dependency_relations["Micky"]=["Donald","Pluto"]
# ht_dependency_relations["Swan"]=[]
# ht_dependency_relations["Horse"]=["Mule"]
# ht_dependency_relations["Frog"]=nil
# ht_dependency_relations["Butterfly"]="Beetle"
#
# Part of the semantics of the ht_dependency_relations content is that
# the dependencies are considered to be met, if the
# following boolean expression has the value of true:
#
#                       ( <Micky> OR <Donald> OR <Pluto> ) AND
#                   AND   <Swan> AND
#                   AND ( <Horse> OR <Mule> ) AND
#                   AND   <Frog> AND
#                   AND ( <Butterfly> OR <Beetle> )
#
# The chevrons denote a function that
# returns a boolean value.
#
# The other part of the semantics of the ht_dependency_relations
# is that the order of the names in the arrays is
# important, because the replacement dependencies
# are searched by starting from the smallest
# index. For example, in the case of the illustration,
# if the Pluto is available and the Donald
# is available, but the Micky is not available, then
# the Donald is used, because its index in the
# array is smaller than that of the Pluto.
#
# The previous, boolean, example was equivalent to a situation,
# where the dependency fulfillment has only 2 values,
#       "met"  ,  "unmet",
# i.e.  "yes"  ,   "no",
# i.e.    1   and   0,
# i.e. "true"  ,  "false
# and the fulfillment threshold equals one.
#
# A generalized version of that is that there is a range of
# floating point numbers, [0,n], where 1<=n, and the question, whether
# all dependencies have been met, is equivalent to a question:
# do all of the dependencies have their availability value
# equal to or greater than the threshold?
#
# For example, in the case of the classical, boolean,
# version, the n==1, i.e. the range of floating point numbers
# is [0,1], and all dependencies are considered to be met, if
# all of the dependencies have their availability value
# "greater than" or "equal to" one. That is to say, in the
# case of the boolean version the threshold equals 1 .
#
class Kibuvits_dependencymetrics_t1
   def initialize
   end # initialize

   private
   def verify_ht_dependency_relations_format(s_dependent_object_name,
      ht_dependency_relations)
      bn=binding()
      kibuvits_assert_string_min_length(bn,s_dependent_object_name,1)
      kibuvits_typecheck bn, Hash, ht_dependency_relations
      bn=nil
      s_clname=nil
      ht_dependency_relations.each_pair do |s_key,x_value|
         bn=binding()
         kibuvits_typecheck bn, String, s_key
         kibuvits_assert_string_min_length(bn,s_key,1)
         s_clname=x_value.class.to_s
         case s_clname
         when "String"
            # Any string is OK. An empty string
            # indicates that the dependency s_key
            # does not have any substitutes.
         when "Array"
            # An empty array indicates that the dependency s_key
            # does not have any substitutes.
            x_value.each do |s_key_substitute_name|
               bn_1=binding()
               kibuvits_typecheck bn_1, String, s_key_substitute_name
               kibuvits_assert_string_min_length(bn_1,
               s_key_substitute_name,1)
            end # loop
         when "NilClass"
            # x_value==nil indicates that the dependency s_key
            # does not have any substitutes.
         else
            kibuvits_throw("ht_dependency_relations[\""+s_key+"\"].class=="+
            s_clname+", which is not supported in this role.")
         end # case x_value.class
      end # loop
      if ht_dependency_relations.has_key? s_dependent_object_name
         kibuvits_throw("ht_dependency_relations.has_key?("+
         "s_dependent_object_name)==true, "+
         "s_dependent_object_name=="+s_dependent_object_name)
      end # if
   end # verify_ht_dependency_relations_format


   private

   def fd_get_availability(ht_objects,s_ob_name,sym_avail,
      ht_cycle_detection_opmem,fd_threshold)
      ob=ht_objects[s_ob_name]
      if ob==nil
         fd_out=0.to_r
         return fd_out;
      end # if
      if !ob.respond_to? sym_avail
         kibuvits_throw("Object with the name "+s_ob_name+
         " exist, but it does not have a public method called "+sym_avail.to_s+
         "\nGUID='4fdd4d45-2ec2-4214-8355-322160818cd7'.")
      end # if
      if ht_cycle_detection_opmem.has_key? s_ob_name
         # This if-clause here has to be before the
         # ob.method(sym_avail).call(ht_cycle_detection_opmem)
         # because then it stops the infinite loop that ocurrs, when
         # A depends on B depends on C depends on A.
         fd_out=0.to_r
         return fd_out;
      end # if
      x=ob.method(sym_avail).call(ht_cycle_detection_opmem,fd_threshold)
      bn=binding()
      kibuvits_typecheck bn, [TrueClass,FalseClass,Float,Fixnum,Bignum,Rational], x
      fd_out=x
      if x.class==TrueClass
         fd_out=1
      else
         fd_out=0 if x.class==FalseClass
      end # if
      fd_out=fd_out.to_r
      return fd_out;
   end # fd_get_availability

   def ht_calculate_row(s_dependent_object_name,ht_row,
      ht_objects,sym_avail,ht_cycle_detection_opmem,fd_threshold)
      ar_ht_row_keys=ht_row.keys
      if KIBUVITS_b_DEBUG
         i_n_of_keys=ar_ht_row_keys.length
         if i_n_of_keys!=1
            kibuvits_throw("i_n_of_keys=="+i_n_of_keys.to_s+
            "\nGUID='1028827a-30b8-4e08-a765-322160818cd7'.")
         end # if
      end # if
      s_ix0_ob_name=ar_ht_row_keys[0]
      ht_out=Hash[s_ix0_ob_name,s_ix0_ob_name]
      fd_out=fd_get_availability(ht_objects,s_ix0_ob_name,sym_avail,
      ht_cycle_detection_opmem,fd_threshold)
      return ht_out if fd_threshold<=fd_out
      x_substs=ht_row[s_ix0_ob_name]
      return ht_out if x_substs==nil
      return ht_out if x_substs==""
      cl_x_substs=x_substs.class
      if cl_x_substs==String
         x_substs=[x_substs]
      else
         if cl_x_substs!=Array
            kibuvits_throw("cl_x_substs=="+cl_x_substs.to_s+
            "\nGUID='62c211f2-d329-4285-a275-322160818cd7'.")
         end # if
      end # if
      ar_subst=x_substs
      return ht_out if ar_subst.length==0
      # If none of the objects reach the threshold,
      # the ix_fd_out equals with the index of the object
      # that has the maximum threshold within this row.
      ix_fd_out=(-1) # === s_ix0_ob_name
      fd_ob_availability=nil
      s_ob_name=nil
      i_ar_subst_len=ar_subst.length
      i_ar_subst_len.times do |ix|
         s_ob_name=ar_subst[ix]
         fd_ob_availability=fd_get_availability(ht_objects,s_ob_name,sym_avail,
         ht_cycle_detection_opmem,fd_threshold)
         if fd_threshold<=fd_ob_availability
            ix_fd_out=ix
            break;
         end # if
         if fd_out<fd_ob_availability
            fd_out=fd_ob_availability
            ix_fd_out=ix
         end # if
      end # loop
      return ht_out if ix_fd_out==(-1)
      ht_out[s_ix0_ob_name]=ar_subst[ix_fd_out]
      return ht_out
   end # ht_calculate_row

   public

   #
   # Returns 2 parameters:
   #
   # ht_dependencies --- The keys match with the keys of the
   #                     ht_dependency_relations, except when the
   #                     ht_dependency_relations has at least one key and the
   #                     ht_cycle_detection_opmem contains the s_dependent_object_name
   #                     as one of its keys. The values are the names of the
   #                     dependencies that got selected.
   #
   #            fd_x --- Availability, which is of a floating point number type.
   #                     fd_x equals with the maximum threshold that
   #                     the availability of all of the selected objects
   #                     is equal to or greater, regardless of wether
   #                     fd_x is greater than or equal to the fd_threshold.
   #
   #  If the ht_cycle_detection_opmem does contain the s_dependent_object_name
   #  as one of its keys, then the ht_dependencies will be an empty hashtable.
   #
   # The fd_threshold must be greater than or equal to 0.
   #
   # The ht_objects has object names as keys and the objects as values.
   # The objects in the ht_objects must have a
   # method that corresponds to the s_or_sym_method.
   #
   # If the s_or_sym_method returns boolean values, then the
   # boolean values are interpreted so that the boolean true equals
   # 1 and the boolean false equals 0. The method that is
   # denoted by the s_or_sym_method must accept exactly two
   # parameters, which must be optional. First of the parameters is
   # of type Hash and optionally has a name of ht_cycle_detection_opmem.
   # The second of the parameters is the fd_threshold. The keys
   # of the ht_cycle_detection_opmem are object names and the
   # values of the ht_cycle_detection_opmem  are the objects.
   #
   # Cyclic dependencies ARE allowed, but if the availability
   # of the ht_objects[s_dependent_object_name] is determined
   # by its own availability, then the fd_x==0.
   # Due to the substitutions within the ht_dependency_relations
   # the existance of cyclic dependencies is dynamic, determined
   # at runtime. The cyclic paths that consist of more than
   # 2 nodes are detected by using the ht_cycle_detection_opmem.
   #
   # If the ht_objects[s_dependent_object_name] does not
   # depend on any of the other instances that are listed
   # in the ht_objects, i.e. if the
   # ht_dependency_relations.keys.size==0, then the
   # ar_get_availability_value(...) returns
   # ht_objects[s_dependent_object_name].method(s_or_sym_method).call
   #
   # The fd_threshold is related to substitutions.
   # For example, if
   #
   #     ht_dependency_relations=Hash["ob_2", ["ob_3","ob_4"] ]
   #
   # and
   #
   #     fd_threshold==60
   #
   # and
   #
   #     ht_objects["ob_2"].method(s_or_sym_method).call == 42
   #     ht_objects["ob_3"].method(s_or_sym_method).call == 73
   #     ht_objects["ob_4"].method(s_or_sym_method).call == 99
   #
   # i.e.
   #     "ob_2" => ["ob_3","ob_4"]
   #       42         73     99
   #
   # then the fd_x==73 , because 42 is smaller than the fd_threshold,
   # but the first substitution, the ht_objects["ob_2"], has an availability
   # value of 73 and 60<=73 . The reason, why the availability value of the
   # ht_objects["ob_3"] is used in stead of the availability value of the
   # ht_objects["ob_4"], is that the substitution order is determined by the
   # array indices, not availability values.
   #
   # Some code examples, illustrations, reside
   # within the Kibuvits_dependencymetrics_t1 selftests.
   #
   # It's OK for the ht_objects to miss some of the keys that
   # are represented within the ht_dependency_relations either as keys or
   # parts of the ht_dependency_relations values. The availability of instances
   # that are not represented within the ht_objects, is considered 0 (zero).
   #
   def fd_ht_get_availability(s_dependent_object_name,
      ht_dependency_relations,ht_objects,s_or_sym_method,
      ht_cycle_detection_opmem=Hash.new,fd_threshold=1)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_dependent_object_name
         kibuvits_typecheck bn, Hash, ht_dependency_relations
         verify_ht_dependency_relations_format(s_dependent_object_name,
         ht_dependency_relations)
         kibuvits_typecheck bn, Hash, ht_objects
         kibuvits_typecheck bn, [Symbol,String], s_or_sym_method
         if s_or_sym_method.class==String
            kibuvits_assert_string_min_length(bn,s_or_sym_method,1)
         end # if
         sym_avail=s_or_sym_method
         sym_avail=s_or_sym_method.to_sym if s_or_sym_method.class==String
         i_par_len=nil
         ht_objects.each_pair do |s_ob_name,ob|
            if !ob.respond_to? sym_avail
               kibuvits_throw("Object with the name "+s_ob_name+
               "  does not have a public method called "+sym_avail.to_s+
               "\nGUID='292a9e75-44fb-484d-8525-322160818cd7'.")
            else
               i_par_len=ob.method(sym_avail).parameters.length
               if i_par_len!=2
                  kibuvits_throw("Object with the name "+s_ob_name+
                  "  does have a public method called "+sym_avail.to_s+
                  ",\nbut the number of parameters of that method equals "+i_par_len.to_s+
                  ".\nGUID='4f675f93-9d7a-4727-9415-322160818cd7'.")
               end # if
            end # if
         end # loop
         kibuvits_typecheck bn, Hash, ht_cycle_detection_opmem
         kibuvits_typecheck bn, [Float,Fixnum,Bignum,Rational], fd_threshold
         i_1=ht_dependency_relations.object_id
         i_2=ht_objects.object_id
         i_3=ht_cycle_detection_opmem.object_id
         if i_par_len!=2
            kibuvits_throw("Object with the name "+s_ob_name+
            "  does have a public method called "+sym_avail.to_s+
            ",\nbut the number of parameters of that method equals "+i_par_len.to_s+
            ".\nGUID='2ad397f1-44e0-4d69-8a35-322160818cd7'.")
         end # if
      end # if KIBUVITS_b_DEBUG
      if fd_threshold<0
         kibuvits_throw("fd_threshold=="+fd_threshold.to_s+" < 0"+
         "\nGUID='15c950e1-4197-43bf-b615-322160818cd7'.")
      end # if
      ht_out=Hash.new
      fd_out=0.to_r
      if ht_cycle_detection_opmem.has_key? s_dependent_object_name
         return fd_out, ht_out
      end # if
      if !ht_objects.has_key? s_dependent_object_name
         # There's no cycle, but according to the spec of this method
         # objects that are missing from the ht_objects are
         # considered to be un-available.
         return fd_out, ht_out
      end # if
      ht_cycle_detection_opmem[s_dependent_object_name]=ht_objects[s_dependent_object_name]
      fd_threshold=fd_threshold.to_r
      sym_avail=s_or_sym_method
      sym_avail=s_or_sym_method.to_sym if s_or_sym_method.class==String
      fd_out=(-1)
      ar_ht_dependency_relations_keys=ht_dependency_relations.keys
      if ar_ht_dependency_relations_keys.length==0
         fd_out=fd_get_availability(ht_objects,s_dependent_object_name,
         sym_avail,ht_cycle_detection_opmem,fd_threshold)
         ht_cycle_detection_opmem.delete(s_dependent_object_name)
         return fd_out, ht_out
      else
         ht_row=Hash.new
         ht_out_row=nil
         s_1=nil
         ht_dependency_relations.each_pair do |s_key,x_substs|
            ht_row[s_key]=x_substs
            ht_out_row=ht_calculate_row(s_dependent_object_name,ht_row,
            ht_objects,sym_avail,ht_cycle_detection_opmem,fd_threshold)
            s_1=ht_out_row.keys[0]
            if KIBUVITS_b_DEBUG
               if s_1!=s_key
                  kibuvits_throw("s_1=="+s_1.to_s+",  s_key=="+s_key.to_s+
                  "\nGUID='1abf2b64-c31b-4e47-8545-322160818cd7'.")
               end # if
            end # if
            ht_out[s_1]=ht_out_row[s_1]
            ht_row.clear
         end # loop
      end # if
      ar_subst_names=ht_out.values
      s_1=ar_subst_names[0] # guaranteed to have at least one element here
      fd_out=fd_get_availability(ht_objects,s_1,sym_avail,
      ht_cycle_detection_opmem,fd_threshold)
      fd_ob_availability=nil
      ar_subst_names.each do |s_ob_name|
         if s_ob_name==s_dependent_object_name
            fd_out=0
            break
         end # if
         fd_ob_availability=fd_get_availability(ht_objects,s_ob_name,sym_avail,
         ht_cycle_detection_opmem,fd_threshold)
         fd_out=fd_ob_availability if fd_ob_availability<fd_out
      end # loop
      if fd_out<0
         kibuvits_throw("fd_out=="+fd_out.to_s+" < 0 "+
         "\nGUID='160e2391-4a0d-4c5e-9a55-322160818cd7'.")
      end # if
      ht_cycle_detection_opmem.delete(s_dependent_object_name)
      return fd_out, ht_out
   end # fd_ht_get_availability

   def Kibuvits_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method, ht_cycle_detection_opmem=Hash.new, fd_threshold=1.0)

      fd_x,ht_dependencies=Kibuvits_dependencymetrics_t1.instance.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method, ht_cycle_detection_opmem, fd_threshold)

      return fd_x,ht_dependencies
   end # Kibuvits_dependencymetrics_t1.fd_ht_get_availability

   public
   include Singleton
   # The Kibuvits_dependencymetrics_t1.selftest analogue is
   # in a separate selftest file.

end # class Kibuvits_dependencymetrics_t1

#==========================================================================
