#!/usr/bin/env ruby
#==========================================================================
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
#==========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

# The "included" const. has to be before the "require" clauses
# to be available, when the code within the require clauses probes for it.
KIBUVITS_MSGC_INCLUDED=true if !defined? KIBUVITS_MSGC_INCLUDED

require  KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"

#==========================================================================
# msgc stands for "msg container", where "msg" stands for "message".
#
# Messages, including error messages, are often just strings,
# often written only in one language, usually English. The Kibuvits_msgc is
# meant to bundle different language versions of the messages
# together and it also bundles a message code with the strings, thus
# simplifying the implementation of message specific control flow.
#
# If a message in a given language is not available, a default
# version is returned. The Kibuvits_msgc is meant to be used in
# conjunction with the Kibuvits_msgc_stack.
class Kibuvits_msgc
   @@lc_ht_empty_and_frozen=Hash.new.freeze

   # The field s_version is a freeform string that
   # depicts a signature to all of the rest of the fields
   # in the package, recursively. That is to say the
   # s_version has to change whenever the class
   # of the serializable instance changes or the serialization
   # format changes.
   @@s_version="2:ProgFTE".freeze

   attr_reader :s_instance_id
   attr_reader :b_failure
   attr_reader :fdr_instantiation_timestamp
   attr_reader :s_location_marker_GUID


   def initialize(s_default_msg=$kibuvits_lc_emptystring,s_message_id="message code not set",
      b_failure=true,s_default_language=$kibuvits_lc_English,
      s_location_marker_GUID=$kibuvits_lc_emptystring)
      @fdr_instantiation_timestamp=Time.now.to_r
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_default_msg
         kibuvits_typecheck bn, String, s_message_id
         kibuvits_typecheck bn, [TrueClass, FalseClass], b_failure
         kibuvits_typecheck bn, String, s_default_language
         kibuvits_assert_string_min_length(bn,s_default_language,2,
         "\nGUID='1af9a013-15ae-4026-83cb-417370104ed7'")
      end # if
      @s_instance_id="msgc_"+Kibuvits_wholenumberID_generator.generate.to_s+"_"+
      Kibuvits_GUID_generator.generate_GUID
      @s_default_language=$kibuvits_lc_emptystring+s_default_language
      @ht_msgs=Hash.new
      @ht_msgs[@s_default_language]=($kibuvits_lc_emptystring+
      s_default_msg).freeze
      @s_message_id=s_message_id.freeze
      @b_failure=b_failure
      @mx=Mutex.new
      @ob_instantiation_time=Time.now
      @x_data=nil

      @s_location_marker_GUID=s_location_marker_GUID.freeze
      if @s_location_marker_GUID!=$kibuvits_lc_emptystring
         rgx=Regexp.new($kibuvits_lc_GUID_regex_core_t1)
         md_candidate=@s_location_marker_GUID.match(rgx)
         if md_candidate==nil
            kibuvits_throw("\nThe s_location_marker_GUID(=="+
            s_location_marker_GUID+")\nis not a GUID."+
            "\nCurrent exception location GUID=='31e64012-09bd-4d01-94cb-417370104ed7'\n\n");
         end # if
      end # if
   end #initialize

   public

   def b_failure=(b_value)
      bn=binding()
      kibuvits_typecheck bn, [TrueClass, FalseClass], b_value
      @mx.synchronize do
         break if @b_failure==b_value
         @b_failure=b_value
      end # synchronize
   end # b_failure=

   def to_s(s_language=nil)
      # The "s_language=nil" in the input parameters list is due to the
      # Kibuvits_msgc_stack to_s implementation
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), [NilClass,String], s_language
      end # if
      if s_language==nil
         s_language=@s_default_language
      else
         s_language=@s_default_language if !@ht_msgs.has_key? s_language
      end # if
      s=@ht_msgs[s_language]
      if 0<@s_location_marker_GUID.length
         s=s+("\nGUID='"+@s_location_marker_GUID+"'\n")
      end # if
      return $kibuvits_lc_emptystring+s # The "" is to avoid s.downcase!
   end # to_s

   #-----------------------------------------------------------------------

   # Throws, if self.b_failure==true
   def assert_lack_of_failures(s_optional_error_message_suffix=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [NilClass,String], s_optional_error_message_suffix
      end # if
      if b_failure
         s_msg=$kibuvits_lc_linebreak+to_s()+$kibuvits_lc_linebreak
         if s_optional_error_message_suffix.class==String
            s_msg<<(s_optional_error_message_suffix+$kibuvits_lc_linebreak)
         end # if
         kibuvits_throw(s_msg)
      end # if
   end # assert_lack_of_failures

   #-----------------------------------------------------------------------

   def [](s_language)
      s=self.to_s s_language
      return s
   end # []


   def []=(s_language, s_message)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_language
         kibuvits_typecheck bn, String, s_message
      end # if
      @ht_msgs[$kibuvits_lc_emptystring+s_language]=$kibuvits_lc_emptystring+
      s_message # The "" is to avoid s.downcase!
      return nil
   end # []=

   #-----------------------------------------------------------------------

   # Creates a new Kibuvits_msgc instance that has the same message values and
   # s_message_id value, but a different s_instance_id.
   #
   # To clone a Kibuvits_msgc instance so that the s_instance_id of a
   # clone matches that of the original, one should serialize the original
   # and then instantiate the clone by using deserialization.
   def clone
      x_out=Kibuvits_msgc.new(@ht_msgs[@s_default_language],
      @s_message_id, @b_failure, @s_default_language)
      @ht_msgs.each_pair {|s_language,s_msg| x_out[s_language]=s_msg}
      x_out.instance_variable_set(:@x_data,@x_data)
      return x_out
   end # clone

   #-----------------------------------------------------------------------

   def s_message_id
      s_out=$kibuvits_lc_emptystring+@s_message_id
      return s_out
   end # s_message_id

   def s_message_id=(s_whatever_string)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_whatever_string
      end # if
      @s_message_id=$kibuvits_lc_emptystring+s_whatever_string
      return nil
   end # s_message_id

   #-----------------------------------------------------------------------

   def x_data
      x_out=nil
      if @x_data.class==String
         x_out=$kibuvits_lc_emptystring+@x_data
      else
         x_out=@x_data
      end # if
      return x_out
   end # x_data


   def x_data=(x_data)
      @x_data=x_data
   end # x_data=

   #-----------------------------------------------------------------------

   def s_serialize
      ht=Hash.new
      s_ht_msgs_progfte=nil
      @mx.synchronize do
         ht["s_message_id"]=@s_message_id
         if @b_failure
            ht["sb_failure"]="t"
         else
            ht["sb_failure"]="f"
         end # if
         ht["s_instance_id"]=@s_instance_id
         #-------------
         ht["x_data"]=$kibuvits_lc_emptystring
         ht["x_data_class"]=nil.class.to_s
         x_data_class=@x_data.class
         if x_data_class==String
            ht["x_data"]=@x_data
         else
            if @x_data.respond_to? "s_serialize"
               ht["x_data"]=@x_data.s_serialize
            end # if
         end # if
         ht["x_data_class"]=x_data_class.to_s if ht["x_data"]!=nil
         #-------------
         ht["s_default_language"]=@s_default_language
         s_ht_msgs_progfte=Kibuvits_ProgFTE.from_ht(@ht_msgs)
      end # synchronize
      ht["s_ht_msgs_progfte"]=s_ht_msgs_progfte
      s_instance_progfte=Kibuvits_ProgFTE.from_ht(ht)
      ht_container=Hash.new
      ht_container[$kibuvits_lc_s_version]=@@s_version
      ht_container[$kibuvits_lc_s_type]="Kibuvits_msgc"
      ht_container[$kibuvits_lc_s_serialized]=s_instance_progfte
      s_progfte=Kibuvits_ProgFTE.from_ht(ht_container)
      return s_progfte
   end # s_serialize

   #-----------------------------------------------------------------------

   private

   # Returns a Kibuvits_msgc instance
   def ob_deserialize(s_progfte)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String,s_progfte
      end # if
      ht_container=Kibuvits_ProgFTE.to_ht(s_progfte)
      if KIBUVITS_b_DEBUG
         bn=binding()
         $kibuvits_lc_s_serialized=$kibuvits_lc_s_serialized.freeze
         kibuvits_assert_ht_has_keys(bn,ht_container,
         [$kibuvits_lc_s_version,$kibuvits_lc_s_type,$kibuvits_lc_s_serialized])
      end # if
      s_version=ht_container[$kibuvits_lc_s_version]
      if s_version!=@@s_version
         kibuvits_throw("s_version=="+s_version.to_s+
         ", but \""+@@s_version+"\" is expected.")
      end # if
      s_type=ht_container[$kibuvits_lc_s_type]
      if s_type!="Kibuvits_msgc"
         kibuvits_throw("s_type=="+s_type.to_s+", but "+
         "\"Kibuvits_msgc\" is expected.")
      end # if
      s_serialized=ht_container[$kibuvits_lc_s_serialized]
      ht=Kibuvits_ProgFTE.to_ht(s_serialized)
      msgc=self
      msgc.instance_variable_set(:@s_message_id,ht["s_message_id"])
      b_failure=false
      b_failure=true if ht["sb_failure"]=="t"
      msgc.instance_variable_set(:@b_failure,b_failure)
      msgc.instance_variable_set(:@s_instance_id,ht["s_instance_id"])
      #-------------
      x_data=nil
      x_data_class=ht["x_data_class"]
      if x_data_class!=(nil.class.to_s)
         s_x_data_serialized=ht["x_data"]
         if kibuvits_b_class_defined? x_data_class
            if x_data_class=="String"
               x_data=s_x_data_serialized
            else
               cl=kibuvits_exc_class_name_2_cl(x_data_class)
               if cl.respond_to? "ob_deserialize"
                  x_data=cl.ob_deserialize
               else
                  if KIBUVITS_b_DEBUG
                     kibuvits_throw("Deserialization of an "+
                     "instance of the "+self.class.to_s+" failed, because the class "+
                     x_data_class +" is defined, but it does not have a method named "+
                     "ob_deserialize.\n"+
                     "GUID='423cb8b3-5fb1-4003-becb-417370104ed7'\n\n")
                  end # if
               end # if
            end # if
         else
            if KIBUVITS_b_DEBUG
               kibuvits_throw("During the deserialization of an "+
               "instance of the "+self.class.to_s+" the serialized version lists "+
               x_data_class +" as the class of the field \"x_data\", but "+
               "the current application instance does not have a class with that "+
               "name defined.\n"+
               "GUID='81178260-62d0-4b4c-b3bb-417370104ed7'\n\n")
            end # if
         end # if
      end # if
      msgc.instance_variable_set(:@x_data,x_data)
      #-------------
      msgc.instance_variable_set(:@s_default_language,ht["s_default_language"])
      ht_msgs=Kibuvits_ProgFTE.to_ht(ht["s_ht_msgs_progfte"])
      msgc.instance_variable_set(:@ht_msgs,ht_msgs)
      return msgc
   end # ob_deserialize

   public

   def Kibuvits_msgc.ob_deserialize(s_progfte)
      msgc=Kibuvits_msgc.new
      msgc.send(:ob_deserialize,s_progfte)
      return msgc
   end # Kibuvits_msgc.ob_deserialize

   #-----------------------------------------------------------------------

   private

   # Only to be used as a private method and with care
   # taken to make sure that the returned hashtable instance, nor
   # its elements, are modified.
   #
   # The implementation of the
   # Kibuvits_msgc_stack.insert_originedited_msgc_or_msgcs
   # explains the use of this method.
   def get_ht_instance_ids
      ht=@@lc_ht_empty_and_frozen
      return ht # There are no sub-instances within the msgc
   end # get_ht_instance_ids

end # class Kibuvits_msgc

#--------------------------------------------------------------------------
# The Kibuvits_msgc_stack partly mimics an Array that accepts only
# elements that are of type Kibuvits_msgc.
class Kibuvits_msgc_stack

   # The field s_version is a freeform string that
   # depicts a signature to all of the rest of the fields
   # in the package, recursively. That is to say the
   # s_version has to change whenever the class
   # of the serializable instance changes or the serialization
   # format changes.
   @@s_version="2:ProgFTE".freeze

   attr_reader :s_instance_id
   attr_reader :fdr_instantiation_timestamp

   def initialize
      @fdr_instantiation_timestamp=Time.now.to_r
      @ar_elements=Array.new
      @ht_element_ids=Hash.new
      @ht_element_insertion_times=Hash.new
      @s_instance_id="msgcs_"+Kibuvits_wholenumberID_generator.generate.to_s+"_"+
      Kibuvits_GUID_generator.generate_GUID
      @mx=Mutex.new
      @ob_instantiation_time=Time.now
   end #initialize

   # b_failure of the stack is a disjunction of its elements'
   # b_failure fields.
   def b_failure
      # The reason, why it's a recursive method
      # in stead of an instance variable is that the
      # Kibuvits_msgc instances that reside within some
      # Kibuvits_msgc_stack instance that is an element of
      # self have references in other places and the state change
      # of the sub-sub-etc. elements has to be taken to
      # account in the self.b_failure() output, but the
      # update mechanism would probably be
      # computationally relatively expensive and code-verbose.
      # Hence one prefers to pay just the computational expense and
      # save oneself from the code-verbose part.
      b_out=false
      @ar_elements.each do |msgc_or_msgcs|
         if msgc_or_msgcs.b_failure
            b_out=true
            break
         end # if
      end # loop
      return b_out
   end # b_failure


   private

   # Only to be used as a private method and with care
   # taken to make sure that the returned hashtable instance, nor
   # its elements, are modified.
   #
   # The implementation of the
   # Kibuvits_msgc_stack.insert_originedited_msgc_or_msgcs
   # explains the use of this method.
   def get_ht_instance_ids
      return @ht_element_ids
   end # get_ht_instance_ids

   def insert_originedited_msgc_or_msgcs(msgc_or_msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Kibuvits_msgc,Kibuvits_msgc_stack], msgc_or_msgcs
      end # if
      s_instance_id=msgc_or_msgcs.s_instance_id
      @mx.synchronize do
         # Actually the checks here covers all of the cyclic dependencies and subbranches.
         if @ht_element_ids.has_key? s_instance_id
            kibuvits_throw("The Kibuvits_msgc_stack accepts each element only once, but "+
            "there is an attempt to insert an instance with an ID of "+
            s_instance_id+" more than once. ")
         end # if
         @ht_element_ids[s_instance_id]=s_instance_id
         # The ht_instance_ids_in=msgc_or_msgcs.send(:get_ht_instance_ids)
         # is used in stead of the
         # msgc_or_msgcs.get_ht_instance_ids() due to the fact that the
         # get_ht_instance_ids is an implementation specific method,
         # i.e. a private method, and it's also private within
         # the Kibuvits_msgc, which != self.class in this scope.
         ht_instance_ids_in=msgc_or_msgcs.send(:get_ht_instance_ids)
         ht_instance_ids_in.each_value do |s_subinstance_id|
            if @ht_element_ids.has_key? s_subinstance_id
               kibuvits_throw("The Kibuvits_msgc_stack with an instance ID of "+
               @s_instance_id+" accepts each element only once, but "+
               "there is an attempt to insert an instance with an ID of "+
               s_subinstance_id+" more than once. ")
            end # if
            @ht_element_ids[s_subinstance_id]=s_subinstance_id
         end # loop
         @ar_elements<<msgc_or_msgcs
      end # synchronize
   end # insert_originedited_msgc_or_msgcs

   public
   def <<(msgc_or_msgcs)
      bn=binding()
      kibuvits_typecheck bn, [Kibuvits_msgc,Kibuvits_msgc_stack], msgc_or_msgcs
      insert_originedited_msgc_or_msgcs(msgc_or_msgcs)
   end # <<

   def push(msgc_or_msgcs)
      self << msgc_or_msgcs
   end # push(msgc_or_msgcs)


   # Adds a Kibuvits_msgc instance to the stack. Arguments match with
   # the Kibuvits_msgc constructor arguments.
   def cre(s_default_msg=$kibuvits_lc_emptystring,
      s_message_id="message code not set",
      b_failure=true,s_location_marker_GUID=$kibuvits_lc_emptystring,
      s_default_language=$kibuvits_lc_English)
      msgc=Kibuvits_msgc.new(s_default_msg,s_message_id,b_failure,
      s_default_language,s_location_marker_GUID)
      self<<msgc
   end # cre


   def clear
      @mx.synchronize do
         @ar_elements.clear
         @ht_element_ids.clear
      end # synchronize
   end # clear


   def length
      i=@ar_elements.length.to_i
      return i
   end # length


   def s_serialize
      ht_elems=Hash.new
      ht_elem_container=Hash.new
      i_number_of_elements=nil
      @mx.synchronize do
         i_number_of_elements=@ar_elements.size
         s_elem_instance_id=nil
         i_number_of_elements.times do |i|
            msgc_or_msgcs=@ar_elements[i]
            ht_elem_container[$kibuvits_lc_s_type]=msgc_or_msgcs.class.to_s
            ht_elem_container[$kibuvits_lc_s_serialized]=msgc_or_msgcs.s_serialize
            ht_elems[i.to_s]=Kibuvits_ProgFTE.from_ht(ht_elem_container)
            ht_elem_container.clear
         end # loop
      end # synchronize
      ht_elems["si_number_of_elements"]=i_number_of_elements.to_s
      ht_instance=Hash.new
      ht_instance["s_ht_elems_progfte"]=Kibuvits_ProgFTE.from_ht(ht_elems)
      ht_instance["sfdr_instantiation_timestamp"]=@fdr_instantiation_timestamp.to_s
      ht_instance["s_instance_id"]=@s_instance_id
      ht_instance["s_ht_element_ids_progfte"]=Kibuvits_ProgFTE.from_ht(@ht_element_ids)
      ht_container=Hash.new
      ht_container[$kibuvits_lc_s_version]=@@s_version
      ht_container[$kibuvits_lc_s_type]="Kibuvits_msgc_stack"
      ht_container[$kibuvits_lc_s_serialized]=Kibuvits_ProgFTE.from_ht(ht_instance)
      s_progfte=Kibuvits_ProgFTE.from_ht(ht_container)
      return s_progfte
   end # s_serialize

   #-----------------------------------------------------------------------

   private

   # Returns a Kibuvits_msgc_stack instance
   def ob_deserialize(s_progfte)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_progfte
      end # if
      lc_s_Kibuvits_msgc="Kibuvits_msgc".freeze
      lc_s_Kibuvits_msgc_stack="Kibuvits_msgc_stack".freeze
      ht_container=Kibuvits_ProgFTE.to_ht(s_progfte)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ht_has_keys(bn,ht_container,
         [$kibuvits_lc_s_version,$kibuvits_lc_s_type,$kibuvits_lc_s_serialized])
      end # if
      s_version=ht_container[$kibuvits_lc_s_version]
      if s_version!=@@s_version
         kibuvits_throw("s_version=="+s_version.to_s+
         ", but \""+@@s_version+"\" is expected.")
      end # if
      s_type=ht_container[$kibuvits_lc_s_type]
      if s_type!=lc_s_Kibuvits_msgc_stack
         kibuvits_throw("s_type=="+s_type.to_s+", but "+
         "\"Kibuvits_msgc_stack\" is expected.")
      end # if
      s_serialized=ht_container[$kibuvits_lc_s_serialized]
      ht_instance=Kibuvits_ProgFTE.to_ht(s_serialized)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ht_has_keys(bn,ht_instance,
         ["s_ht_elems_progfte","sfdr_instantiation_timestamp","s_instance_id","s_ht_element_ids_progfte"])
      end # if

      ht_elems=Kibuvits_ProgFTE.to_ht(ht_instance["s_ht_elems_progfte"])
      fdr_instantiation_timestamp=ht_instance["sfdr_instantiation_timestamp"].to_r
      s_instance_id=ht_instance["s_instance_id"]
      ht_element_ids=Kibuvits_ProgFTE.to_ht(ht_instance["s_ht_element_ids_progfte"])

      i_number_of_elements=ht_elems["si_number_of_elements"].to_i
      ar_elements=Array.new
      ht_elem_container=nil
      msgc_or_msgcs=nil
      s_type=nil
      s_serialized=nil
      s_elem_instance_id=nil
      i_number_of_elements.times do |i|
         ht_elem_container=Kibuvits_ProgFTE.to_ht(ht_elems[i.to_s])
         s_type=ht_elem_container[$kibuvits_lc_s_type]
         s_serialized=ht_elem_container[$kibuvits_lc_s_serialized]
         if s_type==lc_s_Kibuvits_msgc
            msgc_or_msgcs=Kibuvits_msgc.ob_deserialize(s_serialized)
         else
            if s_type==lc_s_Kibuvits_msgc_stack
               msgc_or_msgcs=Kibuvits_msgc_stack.ob_deserialize(s_serialized)
            else
               kibuvits_throw("s_type=="+s_type.to_s+", but "+
               "the only valid values are \"Kibuvits_msgc\" "+
               "and \"Kibuvits_msgc_stack\".")
            end # if
         end # if
         ar_elements<<msgc_or_msgcs
      end # loop
      msgcs=self
      msgcs.instance_variable_set(:@fdr_instantiation_timestamp,fdr_instantiation_timestamp)
      msgcs.instance_variable_set(:@ar_elements,ar_elements)
      msgcs.instance_variable_set(:@ht_element_ids,ht_element_ids)
      msgcs.instance_variable_set(:@s_instance_id,s_instance_id)
      return msgcs;
      # TODO: One can optimize, refactor, the class Kibuvits_msgc_stack
      #       so that the content of the stack is left to serialized
      #       state until the first occurrence of stack content reading
      #       or writing. This also gives savings at the reserialization
      #       of the deserialized instance. The same thing with the
      #       class Kibuvits_msgc.
   end # ob_deserialize

   public

   def Kibuvits_msgc_stack.ob_deserialize(s_progfte)
      msgcs=Kibuvits_msgc_stack.new
      msgcs.send(:ob_deserialize,s_progfte)
      return msgcs
   end # Kibuvits_msgc_stack.ob_deserialize

   #-----------------------------------------------------------------------

   def to_s(s_language=nil)
      kibuvits_typecheck binding(), [NilClass,String], s_language
      s_0=$kibuvits_lc_emptystring
      s_1=nil
      b_prefix_with_linebreak=false
      rgx_1=/[\n\r]+$/
      @mx.synchronize do
         @ar_elements.each do |msgc_or_msgcs|
            # The braces is to use smaller temporary strings, which
            # are better than longer ones in terms of CPU cache misses.
            if b_prefix_with_linebreak
               s_0=s_0+($kibuvits_lc_linebreak+
               msgc_or_msgcs.to_s(s_language).sub(rgx_1,$kibuvits_lc_emptystring))
            else
               s_0=s_0+(
               msgc_or_msgcs.to_s(s_language).sub(rgx_1,$kibuvits_lc_emptystring))
               b_prefix_with_linebreak=true
            end # if
         end # loop
      end # synchronize
      # "".each_line{|x| kibuvits_writeln("["+x.sub(/[\n\r]$/,"")+"]")} outputs only "", not "[]"
      # "hi\nthere".each_line{|x| kibuvits_writeln("["+x.sub(/[\n\r]$/,"")+"]")} outputs "[hi]\n[there]\n"
      s_1=$kibuvits_lc_emptystring
      s_lc_spaces=$kibuvits_lc_space*2
      rgx_2=/([\s]|[\n\r])+$/
      s_0.each_line do |s_line|
         if 0<((s_line.sub(rgx_2,$kibuvits_lc_emptystring)).length)
            # The idea is that the very last line contains
            # just a line break, which means that without this
            # if-clause the "\n" is replaced with the s_1+(s_lc_spaces+"\n")
            s_1=s_1+(s_lc_spaces+s_line)
         end # if
      end # loop
      if @x_data!=nil
         # TODO: implement a serializationmodem mechanism for
         # the @x_data so that it also has a to_s method.
         s_1=s_1+"\n\n"+@x_data.to_s
      end # if
      s_1<<$kibuvits_lc_doublelinebreak
      return s_1
   end # to_s

   #-----------------------------------------------------------------------

   # Throws, if self.b_failure()==true
   def assert_lack_of_failures(s_optional_error_message_suffix=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [NilClass,String], s_optional_error_message_suffix
      end # if
      if b_failure
         s_msg=$kibuvits_lc_linebreak+to_s()+$kibuvits_lc_linebreak
         if s_optional_error_message_suffix.class==String
            s_msg<<(s_optional_error_message_suffix+$kibuvits_lc_linebreak)
         end # if
         kibuvits_throw(s_msg)
      end # if
   end # assert_lack_of_failures

   #-----------------------------------------------------------------------

   def [](i_index)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Fixnum, i_index
         kibuvits_assert_arrayix(bn,@ar_elements,i_index)
      end # if
      msgc_or_msgcs=@ar_elements[i_index]
      return msgc_or_msgcs
   end # []

   #-----------------------------------------------------------------------

   # Like the Array.first. It returns nil, if the
   # array is empty.
   def first
      msgc_or_msgcs=nil
      @mx.synchronize{msgc_or_msgcs=@ar_elements.first}
      return msgc_or_msgcs
   end # first

   # Like the Array.last. It returns nil, if the
   # array is empty.
   def last
      msgc_or_msgcs=nil
      @mx.synchronize{msgc_or_msgcs=@ar_elements.last}
      return msgc_or_msgcs
   end # last

   def each
      @ar_elements.each do |msgc_or_msgcs|
         yield msgc_or_msgcs
      end # loop
   end # each

end # class Kibuvits_msgc_stack

if !defined? $kibuvits_msgc_stack
   $kibuvits_msgc_stack=Kibuvits_msgc_stack.new
end # if

#==========================================================================
