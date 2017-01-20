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
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

# The "included" const. has to be befor the "require" clauses
# to be available, when the code within the require clauses probes for it.
if !defined? KIBUVITS_SZR_INCLUDED
   KIBUVITS_SZR_INCLUDED=true
end # if

require "monitor"
if defined? KIBUVITS_HOME
   if !(defined? KIBUVITS_MSGC_INCLUDED)
      require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   end # if
   require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
else
   require  "kibuvits_boot.rb"
   if !(defined? KIBUVITS_MSGC_INCLUDED)
      require  "kibuvits_msgc.rb"
   end # if
   require  "kibuvits_ProgFTE.rb"
   require  "kibuvits_str.rb"
end # if

require "singleton"
#==========================================================================

# The class Kibuvits_szr implements a serialization framework.
class Kibuvits_szr
   @@s_version="ProgFTE:ht_p:1" # a free-style string without any structure

   def initialize
   end #initialize

   def ht_create_ht_p
      ht_p=Hash.new
      msgcs=Kibuvits_msgc_stack.new
      ht_p[$kibuvits_lc_msgcs]=msgcs
      ht_szr=Hash.new
      ht_p[$kibuvits_lc_ht_szr]=ht_szr
      # The keys of the ht_szr are expected to
      # be of form <programming language name>_<action>_<type name>.
      #
      # Examples: Ruby_serialize_AwesomeClass
      #           Ruby_deserialize_AwesomeClass
      #
      # The values of the ht_szr are expected to
      # be source code fragments that describe
      # a single function named func_x
      #
      # If the ht_szr is part of the ht_p, then it
      # must not contain keys of form
      # <programming language name>_serialize_szrtype_instance and
      # <programming language name>_deserialize_szrtype_instance,
      # because the ht_p is meant to be passed on during
      # method/function invocations, implying that it is also
      # passed on from instance to instance and different instances
      # probably have different scripts for serialization/deserialization.
      return ht_p
   end # ht_create_ht_p

   def Kibuvits_szr.ht_create_ht_p
      ht_out=Kibuvits_szr.instance.ht_create_ht_p
      return ht_out
   end # Kibuvits_szr.ht_create_ht_p

   private

   #-----------------------------------------------------------------------

   def serialize_by_class_ht(a_binding,ob,ht_p,ht_szr_explicit)
      ht_in=ob
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash,ht_in
      end # if
      ht_container=Hash.new
      ht_container[$kibuvits_lc_s_version]=@@s_version
      ht_container[$kibuvits_lc_s_type]=ob.class.to_s
      ht=Hash.new
      s_key=nil
      s_value=nil
      ht_in.each_pair do |key,value|
         s_key=serialize(a_binding,key,ht_p,ht_szr_explicit)
         s_value=serialize(a_binding,value,ht_p,ht_szr_explicit)
         ht[s_key]=s_value
      end # loop
      s_serialized=Kibuvits_ProgFTE.from_ht(ht)
      ht_container[$kibuvits_lc_s_serialized]=s_serialized
      s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      return s_out
   end # serialize_by_class_ht

   #-----------------------------------------------------------------------

   def serialize_by_class_ar(a_binding,ob,ht_p,ht_szr_explicit)
      ar_in=ob
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn,Array,ar_in
      end # if
      ht_container=Hash.new
      ht_container[$kibuvits_lc_s_version]=@@s_version
      ht_container[$kibuvits_lc_s_type]=ob.class.to_s
      s_serialized=nil
      ht=Hash.new
      i_len=ar_in.size.to_s
      ht[$kibuvits_lc_si_number_of_elements]=i_len.to_s
      ht=Hash.new
      s_key=nil
      s_value=nil
      x=nil
      i_len.times do |i|
         s_key=i.to_s
         x=ar_in[i]
         s_value=serialize(a_binding,x,ht_p,ht_szr_explicit)
         ht[s_key]=s_value
      end # loop
      s_serialized=Kibuvits_ProgFTE.from_ht(ht)
      ht_container[$kibuvits_lc_s_serialized]=s_serialized
      s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      return s_out
   end # serialize_by_class_ar

   #-----------------------------------------------------------------------

   # The ht_p,ht_srz_explicit are here only due to the
   # recursive nature of this function. The idea is that
   # one uses recursion for container types and the container
   # types, like Hash and Array, may contain instances of
   # custom type, which can be serialized only by using the
   # serialization instructions.
   def serialize_by_class(a_binding,ob,ht_p,ht_szr_explicit)
      cl=ob.class
      s_out=nil
      # The overhead is due to the fact that the
      # serialization output has to contain info about
      # the serialized instance type and that the type info
      # has to be extractable from the serialization output
      # by using a method that does not depend on the
      # serialized instance type.
      if cl==String
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=cl.to_s
         ht_container[$kibuvits_lc_s_serialized]=ob
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif ((cl==Fixnum)||(cl==Rational)||(cl==Float))
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=cl.to_s
         ht_container[$kibuvits_lc_s_serialized]=ob.to_s
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif cl==NilClass
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=cl.to_s
         ht_container[$kibuvits_lc_s_serialized]=$kibuvits_lc_emptystring
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif (cl==TrueClass)
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=$kibuvits_lc_boolean
         ht_container[$kibuvits_lc_s_serialized]=$kibuvits_lc_sb_true
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif (cl==FalseClass)
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=$kibuvits_lc_boolean
         ht_container[$kibuvits_lc_s_serialized]=$kibuvits_lc_sb_false
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif cl==Hash
         s_out=serialize_by_class_ht(a_binding,ob,ht_p,ht_szr_explicit)
      elsif cl==Array
         s_out=serialize_by_class_ar(a_binding,ob,ht_p,ht_szr_explicit)
      elsif (cl==Time)
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=cl.to_s
         ht=Hash.new
         ht[$kibuvits_lc_year]=ob.year.to_s
         ht[$kibuvits_lc_month]=ob.month.to_s
         ht[$kibuvits_lc_day]=ob.day.to_s
         ht[$kibuvits_lc_hour]=ob.hour.to_s
         ht[$kibuvits_lc_minute]=ob.min.to_s
         ht[$kibuvits_lc_second]=ob.sec.to_s
         # A nanosecond is a period of 1GHz, but not all
         # CPU-s or hardware clocks operate at such a high frequency.
         x=ob.nsec
         x=0 if x.class!=Fixnum
         ht[$kibuvits_lc_nanosecond]=x.to_s
         s_serialized=Kibuvits_ProgFTE.from_ht(ht)
         ht_container[$kibuvits_lc_s_serialized]=s_serialized
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif (cl==Kibuvits_msgc)
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=cl.to_s
         s_serialized=ob.send(:s_serialize)
         ht_container[$kibuvits_lc_s_serialized]=s_serialized
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      elsif (cl==Kibuvits_msgc_stack)
         ht_container=Hash.new
         ht_container[$kibuvits_lc_s_version]=@@s_version
         ht_container[$kibuvits_lc_s_type]=cl.to_s
         s_serialized=ob.send(:s_serialize)
         ht_container[$kibuvits_lc_s_serialized]=s_serialized
         s_out=Kibuvits_ProgFTE.from_ht(ht_container)
      else
         kibuvits_throw("The "+self.class.to_s+
         " does not yet support the serialization of class "+
         cl.to_s+".",a_binding)
         # It's not possible to call ob.class.s_serialize
         # or/and ob.class.ob_deserialize by using reflection,
         # because the serialization format of classes
         # that have been developed without adhering to the Kibuvits_szr
         # specification will introduce a flaw, if
         # their serialized version is fed directly to the
         # Kibuvits_szr.deserialize(...)
      end # if
      return s_out
   end # serialize_by_class


   #-----------------------------------------------------------------------

   def serialize_assert_ht_p_if_not_nil bn,ht_p
      if ht_p!=nil
         kibuvits_assert_ht_has_keys(bn,ht_p,
         [$kibuvits_lc_msgcs, $kibuvits_lc_ht_szr])
         msgcs=ht_p[$kibuvits_lc_msgcs]
         kibuvits_typecheck bn, [Kibuvits_msgc_stack], msgcs
         ht_szr=ht_p[$kibuvits_lc_ht_szr]
         kibuvits_typecheck bn, [Hash], ht_szr
      end # if
   end # serialize_assert_ht_p_if_not_nil

   #-----------------------------------------------------------------------

   def serialize_by_ht_szr_explicit(a_binding,ob,ht_p,ht_szr_explicit)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Binding, a_binding
         kibuvits_typecheck bn, [Hash,NilClass], ht_p
         kibuvits_typecheck bn, [Hash], ht_szr_explicit
         serialize_assert_ht_p_if_not_nil(bn,ht_p)
      end # if
      s_out=nil
      if ht_szr_explicit.has_key? $kibuvits_lc_Ruby_serialize_szrtype_instance
         s_script=ht_szr_explicit[$kibuvits_lc_Ruby_serialize_szrtype_instance]
         ar_in=[ob]
         ar=kibuvits_eval_t1(s_script,ar_in)
         s_out=ar[0]
         return s_out
      end # if
      s_key_name=$kibuvits_lc_Ruby_serialize_+ob.class.to_s
      if ht_szr_explicit.has_key? s_key_name
         s_script=ht_szr_explicit[s_key_name]
         ar_in=[ob]
         ar=kibuvits_eval_t1(s_script,ar_in)
         s_out=ar[0]
         return s_out
      end # if
      kibuvits_throw("Serialization by using the ht_szr_explicit "+
      "got called with ob.class=="+ob.class.to_s+
      ", but the the ht_szr_explicit neither contained the key \""+
      $kibuvits_lc_Ruby_serialize_szrtype_instance+"\", nor did it contain "+
      "the key \""+s_key_name+"\".")
   end # serialize_by_ht_szr_explicit

   #-----------------------------------------------------------------------

   def serialize_by_ht_p(a_binding,ob,ht_p,ht_szr_explicit)
      ht_szr=nil
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Binding, a_binding
         kibuvits_typecheck bn, [Hash], ht_p
         kibuvits_typecheck bn, [NilClass], ht_szr_explicit
         serialize_assert_ht_p_if_not_nil(bn,ht_p)
      else
         ht_szr=ht_p[$kibuvits_typecheck]
      end # if

      s_out=nil
      if ht_szr_explicit.has_key? $kibuvits_lc_Ruby_serialize_szrtype_instance
         s_script=ht_szr_explicit[$kibuvits_lc_Ruby_serialize_szrtype_instance]
         ar_in=[ob]
         ar=kibuvits_eval_t1(s_script,ar_in)
         s_out=ar[0]
         return s_out
      end # if
      s_key_name=$kibuvits_lc_Ruby_serialize_+ob.class.to_s
      if ht_szr_explicit.has_key? s_key_name
         s_script=ht_szr_explicit[s_key_name]
         ar_in=[ob]
         ar=kibuvits_eval_t1(s_script,ar_in)
         s_out=ar[0]
         return s_out
      end # if

      s_out=serialize_by_class(a_binding,ob,ht_p,ht_szr_explicit)

      kibuvits_throw("Serialization by using the ht_szr_explicit "+
      "got called with ob.class=="+ob.class.to_s+
      ", but the the ht_szr_explicit neither contained the key \""+
      $kibuvits_lc_Ruby_serialize_szrtype_instance+"\", nor did it contain "+
      "the key \""+s_key_name+"\".")
   end # serialize_by_ht_p


   #-----------------------------------------------------------------------

   public

   # Returns a string.
   #
   # Inputs:
   #       a_binding --- binding() of the routine from
   #                     where the Kibuvits_szr.serialize
   #                     is called.
   #              ob --- An instance subject to serialization.
   #            ht_p --- The format matches that of the
   #                     Kibuvits_szr.ht_create_ht_p() output.
   # ht_szr_explicit --- It has the same format as the
   #                     ht_p["ht_szr"] has, but if the
   #                     ht_szr_explicit is present, then
   #                     it is used in stead of the ht_p["ht_szr"].
   #                     The format of the ht_szr is explained
   #                     next to the Kibuvits_szr.ht_create_ht_p().
   #
   # If the ht_szr_explicit!=nil, then the ht_p is allowed to
   # be nil.
   #
   # The maximum number of key-value pairs in the
   # ht_szr_explicit and the ht_p["ht_szr"]
   # is not limited by this specification.
   #
   # The ht_szr_explicit may, but is not required to, contain
   # reserved keys of form :
   # <currently running programming language name>_serialize_szrtype_instance and
   # <currently running programming language name>_deserialize_szrtype_instance
   # If those keys are present, namely, if
   # Ruby_serialize_szrtype_instance and Ruby_deserialize_szrtype_instance
   # are present, the corresponding scripts,
   # stored as values, are used for the serialization/deserialization.
   # If those keys are missing, keys
   # Ruby_serialize_<ob.class.to_s> and Ruby_deserialize_<ob.class.to_s>
   # are searched for keys. If those keys are also missing, an
   # exception is thrown, because the purpose of providing the
   # ht_szr_explicit is to explicitly specify the
   # serialization/deserialization scripts.
   #
   # If the ht_szr_explicit==nil, then the ht_p["ht_szr"] is
   # searched for the keys
   # Ruby_serialize_<ob.class.to_s> and Ruby_deserialize_<ob.class.to_s>
   # If the ht_p["ht_szr"] is missing the keys
   # Ruby_serialize_<ob.class.to_s> and Ruby_deserialize_<ob.class.to_s>,
   # the default, ob.class based, conversion is attempted.
   #
   # The reason, why the ht_p["ht_szr"] must not contain the keys
   # <languagename>_<serialize|deserialize>_szrtype_instance ,
   # is that the ht_p is fed from one instance to another and the
   # fields would get out of sync or would have to be updated
   # at every function call that accepts the ht_p, which would be
   # considerably costly.
   #
   #------------------------------------------------
   # Precedence:
   #                   high
   #
   #                   ht_szr_explicit
   #                      |
   #                      +--<programming language name>_serialize_szrtype_instance
   #                      +--(<programming language name>_deserialize_szrtype_instance)
   #                      |
   #                      +--<programming language name>_serialize_<ob.class.to_s>
   #                      +--(<programming language name>_deserialize_<ob.class.to_s>)
   #
   #                   ht_p["ht_szr"]
   #                      +--<programming language name>_serialize_<ob.class.to_s>
   #                      +--(<programming language name>_deserialize_<ob.class.to_s>)
   #
   #                   <Default serialization (deserialization) routine that
   #                    corresponds to ob.class>
   #
   #                   low
   #------------------------------------------------
   #
   # The reason, why this specification contains the keys,
   # <currently running programming language name>_serialize_szrtype_instance and
   # <currently running programming language name>_deserialize_szrtype_instance
   # is that those keys allow prototype oriented programming,
   # where the instances are assembled dynamically and the
   # ob.class does not always determine the proper seraialization/deserialization
   # routine.
   #
   # ht_szr_explicit["Ruby_serialize_szrtype_instance"]==s_script
   # The s_script should read the ob instance from ar_in[0] and
   # return the answer as ar_out[0].
   # s_script example:
   # ---verbatim--start---
   #    ob=ar_in[0]
   #    s_out=ob.s_serialize
   #    ar_out<<s_out
   # ---verbatim--out-----
   #
   def serialize(a_binding,ob,ht_p=nil,ht_szr_explicit=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Binding, a_binding
         kibuvits_typecheck bn, [NilClass,Hash], ht_p
         kibuvits_typecheck bn, [NilClass,Hash], ht_szr_explicit
         serialize_assert_ht_p_if_not_nil(bn,ht_p)
      end # if
      if ht_szr_explicit!=nil
         s_out=serialize_by_ht_szr_explicit(a_binding,ob,ht_p,ht_szr_explicit)
         return s_out
      end # if
      if ht_p!=nil
         s_out=serialize_by_ht_p(a_binding,ob,ht_p,ht_szr_explicit)
         return s_out
      end # if
      s_out=serialize_by_class(a_binding,ob,ht_p,ht_szr_explicit)
      return s_out
   end # serialize

   def Kibuvits_szr.serialize(a_binding,ob,ht_p=nil,ht_szr_explicit=nil)
      s_out=Kibuvits_szr.instance.serialize(a_binding,ob,ht_p,ht_szr_explicit)
      return s_out
   end # Kibuvits_szr.serialize

   #-----------------------------------------------------------------------

   def verify_ht_container_at_deserialization(a_binding,ht_container,s_in_original)
      if !(ht_container.has_key? $kibuvits_lc_s_version)
         s_varname=kibuvits_s_varvalue2varname(a_binding, s_in_original)
         msg=nil
         if 0<s_varname.length
            msg="The hashtable that is created from the string, "+s_varname+
            ", and that is expected to contain the serialized version of "+
            "the instance subject to deserialization "+
            "is missing the key \""+$kibuvits_lc_s_version+"\"."
         else
            msg="The hashtable that is created from the input string "+
            "and that is expected to contain the serialized version of "+
            "the instance subject to deserialization "+
            "is missing the key \""+$kibuvits_lc_s_version+"\"."
         end # if
         kibuvits_throw(msg,a_binding)
      end # if
      s_version=ht_container[$kibuvits_lc_s_version]
      if s_version!=@@s_version
         s_varname=kibuvits_s_varvalue2varname(a_binding, s_in_original)
         msg=nil
         if 0<s_varname.length
            msg="The serialization format version within the string, "+
            s_varname+", is \""+s_version+
            "\", but the acceptable value is \""+@@s_version+"\"."
         else
            msg="The received serialization format version is \""+s_version+
            "\", but the acceptable value is \""+@@s_version+"\"."
         end # if
         kibuvits_throw(msg,a_binding)
      end # if
   end # verify_ht_container_at_deserialization

   #-----------------------------------------------------------------------

   # The s_in_original is the "whole thing", whilst the s_in
   # may equal with the s_in_original or just be some string
   # that resides in any debth of a container that is derived
   # from the s_in_original.
   #
   # The s_in is the one that gets deserialized in this
   # function. The s_in_original is used only as an error message
   # complement.
   #
   # The a_binding is expected to reference the scope that
   # contains the call to teh Kibuvits_szr.deserialize(...)
   def deserialize_class(a_binding,s_in,s_in_original)
      ht_container=Kibuvits_ProgFTE.to_ht(s_in)
      verify_ht_container_at_deserialization(a_binding,
      ht_container,s_in_original)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ht_has_keys(bn,ht_container,
         [$kibuvits_lc_s_type,$kibuvits_lc_s_serialized])
      end # if
      # POOLELI.
      s_type=ht_container[$kibuvits_lc_s_type]
      s_serialized=ht_container[$kibuvits_lc_s_serialized]
      ob=nil
      if s_type=="String"
         ob=s_serialized
      elsif (s_type=="Fixnum")
         ob=s_serialized.to_i
      elsif (s_type=="Rational")
         ob=s_serialized.to_r
      elsif (s_type=="Float")
         ob=s_serialized.to_f
      elsif (s_type==$kibuvits_lc_boolean)
         if s_serialized==$kibuvits_lc_sb_true
            ob=true
         elsif s_serialized==$kibuvits_lc_sb_false
            ob=false
         else
            kibuvits_throw("s_serialized==\""+s_serialized+
            "\", but only \"t\" and \"f\" are supported "+
            "for string-based boolean values.")
         end # if
      elsif (s_type=="Time")
         ht=Kibuvits_ProgFTE.to_ht(s_serialized)
         ob=Time.mktime(
         ht[$kibuvits_lc_year].to_i,
         ht[$kibuvits_lc_month].to_i,
         ht[$kibuvits_lc_day].to_i,
         ht[$kibuvits_lc_hour].to_i,
         ht[$kibuvits_lc_minute].to_i,
         ht[$kibuvits_lc_second].to_i,
         ht[$kibuvits_lc_nanosecond].to_i)
      elsif (s_type=="Kibuvits_msgc")
         msgc_tmp=Kibuvits_msgc.new
         ob=msgc_tmp.send(:ob_deserialize,s_serialized)
      elsif (s_type=="Kibuvits_msgc_stack")
         msgcs_tmp=Kibuvits_msgc_stack.new
         ob=msgcs_tmp.send(:ob_deserialize,s_serialized)
      elsif s_type=="NilClass"
         # do nothing, ob==nil by initialization
      else
         kibuvits_throw("Class "+cl.to_s+" is not yet supported.")
      end # if
      return ob
   end # deserialize_class

   #-----------------------------------------------------------------------

   public

   # The source of this func says it all.
   def deserialize(a_binding,x_in,ht_p=nil,s_type=nil,ht_szr=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Binding, a_binding
         # In the future the x_in could be something binary.
         kibuvits_typecheck bn, String, x_in
         kibuvits_typecheck bn, [Hash,NilClass], ht_p
         kibuvits_typecheck bn, [NilClass,String], s_type
         kibuvits_typecheck bn, [NilClass,Hash], ht_szr
      end # if
      # POOLELI.
      ht_container=Kibuvits_ProgFTE.to_ht(x_in)
      verify_ht_container_at_deserialization(a_binding,
      ht_container,x_in)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ht_has_keys(bn,ht_container,
         [$kibuvits_lc_s_type,$kibuvits_lc_s_serialized])
      end # if
      x_out=nil
      if ht_p==nil
         x_out=deserialize_class(a_binding,x_in,x_in)
         return x_out
      end # if
      return x_out
   end # deserialize

   def Kibuvits_szr.deserialize(a_binding,ob,ht_p=nil,s_type=nil,ht_szr=nil)
      x_out=Kibuvits_szr.instance.deserialize(a_binding,ob,ht_p,s_type,ht_szr)
      return x_out
   end # Kibuvits_szr.deserialize

   public
   include Singleton
   # The Kibuvits_szr.selftest analogue is
   # in a separate selftest file.

end # class Kibuvits_szr

#==========================================================================
#puts Kibuvits_szr.selftest.to_s

