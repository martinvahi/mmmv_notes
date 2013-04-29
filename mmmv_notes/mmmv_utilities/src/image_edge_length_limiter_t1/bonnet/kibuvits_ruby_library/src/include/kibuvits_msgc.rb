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

# The "included" const. has to be befor the "require" clauses
# to be available, when the code within the require clauses probes for it.
KIBUVITS_MSGC_INCLUDED=true if !defined? KIBUVITS_MSGC_INCLUDED

require  KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
if !(defined? KIBUVITS_SZR_INCLUDED)
   require KIBUVITS_HOME+"/src/include/incomplete/kibuvits_szr.rb"
end # if

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
   @@s_version="1:ProgFTE".freeze

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
      end # if
      @s_instance_id="msgc_"+Kibuvits_wholenumberID_generator.generate.to_s+"_"+
      Kibuvits_GUID_generator.generate_GUID
      @s_default_language=$kibuvits_lc_emptystring+s_default_language
      @ht_msgs=Hash.new
      @ht_msgs[@s_default_language]=($kibuvits_lc_emptystring+
      s_default_msg).freeze
      @s_message_id=s_message_id.freeze
      @b_failure=b_failure
      @s_data=$kibuvits_lc_emptystring
      @mx=Mutex.new
      @ob_instantiation_time=Time.now
      @ob_data=nil

      @s_location_marker_GUID=s_location_marker_GUID.freeze
      if @s_location_marker_GUID!=$kibuvits_lc_emptystring
         rgx=Regexp.new($kibuvits_lc_GUID_regex_core_t1)
         md_candidate=$s_location_marker_GUID.match(rgx)
         if md_candidate==nil
            kibuvits_throw("\nThe s_location_marker_GUID(=="+
            s_location_marker_GUID+")\nis not a GUID."+
            "\nCurrent exception location GUID=='e163bb41-a3b1-420d-a5d7-e25240014dd7'\n\n");
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
      x_out.instance_variable_set(:@s_data,@s_data)
      x_out.instance_variable_set(:@ob_data,@ob_data)
      return x_out
   end # clone

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

   def s_data
      s_out=$kibuvits_lc_emptystring+@s_data
      return s_out
   end # s_data

   def s_data= s_whatever_string
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_whatever_string
      end # if
      @s_data=$kibuvits_lc_emptystring+s_whatever_string
      return nil
   end # s_data

   def ob_data
      return @ob_data
   end # ob_data

   def ob_data= ob_data
      @ob_data=ob_data
   end # ob_data=

   protected

   # Retunrs a string.
   # Application level code should use Kibuvits_szr.serialize(...) in stead
   # of using this method directly.
   #
   # TODO: update the ob_data serialization/deserialization part in here
   # and in the Kibuvits_szr.serialize.
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
         ht["s_data"]=@s_data
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
      msgc=Kibuvits_msgc.new
      msgc.instance_variable_set(:@s_message_id,ht["s_message_id"])
      b_failure=false
      b_failure=true if ht["sb_failure"]=="t"
      msgc.instance_variable_set(:@b_failure,b_failure)
      msgc.instance_variable_set(:@s_instance_id,ht["s_instance_id"])
      msgc.instance_variable_set(:@s_data,ht["s_data"])
      msgc.instance_variable_set(:@s_default_language,ht["s_default_language"])
      ht_msgs=Kibuvits_ProgFTE.to_ht(ht["s_ht_msgs_progfte"])
      msgc.instance_variable_set(:@ht_msgs,ht_msgs)
      return msgc
   end # ob_deserialize

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


   def Kibuvits_msgc.test_clone
      msgc=Kibuvits_msgc.new "Hi","UFO_42"
      msgc[$kibuvits_lc_Estonian]="Tere"
      msgc_clone=msgc.clone
      kibuvits_throw "test 3" if msgc_clone.to_s!="Hi"
      kibuvits_throw "test 4" if msgc_clone[$kibuvits_lc_Estonian]!="Tere"
   end # Kibuvits_msgc.test_clone

   def Kibuvits_msgc.test_1
      msgc=Kibuvits_msgc.new "Hi","4"
      kibuvits_throw "test 1" if msgc.to_s!="Hi"
      kibuvits_throw "test 2" if msgc.to_s("UFO")!="Hi"
      msgc1=Kibuvits_msgc.new "Blurrrp","7",false,"Alien"
      kibuvits_throw "test 4" if msgc.s_message_id!="4"
      kibuvits_throw "test 5" if msgc1.to_s!="Blurrrp"
      kibuvits_throw "test 6" if msgc1.to_s("Alien")!="Blurrrp"
      kibuvits_throw "test 7" if msgc1["Alien"]!="Blurrrp"
      kibuvits_throw "test 8" if msgc1["MissingLang"]!="Blurrrp"
      kibuvits_throw "test 9" if msgc1.s_message_id!="7"
      if kibuvits_block_throws{ msgc1['Alien']="New msg"}
         kibuvits_throw "test 10"
      end # if
      if kibuvits_block_throws{ msgc1['Marsian']="QuirrQuirr"}
         kibuvits_throw "test 11"
      end # if
      kibuvits_throw "test 12" if msgc1["Marsian"]!="QuirrQuirr"
      msgc=Kibuvits_msgc.new
      kibuvits_throw "test 13" if msgc.to_s!=""
      kibuvits_throw "test 14" if msgc.s_message_id!="message code not set"
      kibuvits_throw "test 14.1" if msgc.b_failure!=true
      if kibuvits_block_throws{ msgc.s_message_id="9977"}
         kibuvits_throw "test 15"
      end # if
      kibuvits_throw "test 16" if msgc.s_message_id!="9977"

      msgc=Kibuvits_msgc.new "Hi","44",false,"MoonLang"
      kibuvits_throw "test 17" if msgc.b_failure
      if kibuvits_block_throws{ msgc["MoonLang"]="Welcome to the moon!"}
         kibuvits_throw "test 18"
      end # if
      kibuvits_throw "test 19" if msgc["MoonLang"]!="Welcome to the moon!"
      msgc[$kibuvits_lc_English]="Good morning!"
      kibuvits_throw "test 20" if msgc.to_s!="Welcome to the moon!"
   end # Kibuvits_msgc.test_1

   public
   def Kibuvits_msgc.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(), "Kibuvits_msgc.test_1"
      return ar_msgs
   end # Kibuvits_msgc.selftest

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
   @@s_version="1:ProgFTE".freeze

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
            s_instance_id+" more than onece. ")
         end # if
         @ht_element_ids[s_instance_id]=s_instance_id
         # The ht_instance_ids_in=msgc_or_msgcs.send(:get_ht_instance_ids)
         # is used in stead of the
         # msgc_or_msgcs.get_ht_instance_ids() due to the fact that the
         # get_ht_instance_ids is an implementationspecific method,
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
   def << msgc_or_msgcs
      bn=binding()
      kibuvits_typecheck bn, [Kibuvits_msgc,Kibuvits_msgc_stack], msgc_or_msgcs
      insert_originedited_msgc_or_msgcs(msgc_or_msgcs)
   end # <<


   # Adds a Kibuvits_msgc instance to the stack. Arguments match with
   # the Kibuvits_msgc constructor arguments.
   def cre(s_default_msg=$kibuvits_lc_emptystring,
      s_message_id="message code not set",
      b_failure=true,s_default_language="English",
      s_location_marker_GUID=$kibuvits_lc_emptystring)
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

   protected

   # Retunrs a string.
   #
   # Application level code should use Kibuvits_szr.serialize(...) in stead
   # of using this method directly.
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
            ht_elem_container[$kibuvits_lc_s_serialized]=msgc_or_msgcs.send(:s_serialize)
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

   # Returns a Kibuvits_msgc instance
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
      msgc_tmp=Kibuvits_msgc.new
      msgcs_tmp=Kibuvits_msgc_stack.new
      i_number_of_elements.times do |i|
         ht_elem_container=Kibuvits_ProgFTE.to_ht(ht_elems[i.to_s])
         s_type=ht_elem_container[$kibuvits_lc_s_type]
         s_serialized=ht_elem_container[$kibuvits_lc_s_serialized]
         if s_type==lc_s_Kibuvits_msgc
            msgc_or_msgcs=msgc_tmp.send(:ob_deserialize,s_serialized)
         else
            if s_type==lc_s_Kibuvits_msgc_stack
               msgc_or_msgcs=msgcs_tmp.send(:ob_deserialize,s_serialized)
            else
               kibuvits_throw("s_type=="+s_type.to_s+", but "+
               "the only valid values are \"Kibuvits_msgc\" "+
               "and \"Kibuvits_msgc_stack\".")
            end # if
         end # if
         ar_elements<<msgc_or_msgcs
      end # loop
      msgcs=Kibuvits_msgc_stack.new
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

   def to_s s_language=nil
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
      # "".each_line{|x| puts("["+x.sub(/[\n\r]$/,"")+"]")} outputs only "", not "[]"
      # "hi\nthere".each_line{|x| puts("["+x.sub(/[\n\r]$/,"")+"]")} outputs "[hi]\n[there]\n"
      s_1=$kibuvits_lc_emptystring
      s_lc_spaces=$kibuvits_lc_space*2
      rgx_2=/([\s]|[\n\r])+$/
      s_0.each_line do |s_line|
         if 0<((s_line.sub(rgx_2,$kibuvits_lc_emptystring)).length)
            # The idea is that the very last line contains
            # just a linebreak, which means that without this
            # if-clause the "\n" is replaced with the s_1+(s_lc_spaces+"\n")
            s_1=s_1+(s_lc_spaces+s_line)
         end # if
      end # loop
      if @ob_data!=nil
         # TODO: implement a serializationmodem mecanism for
         # the @ob_data so that it also has a to_s method.
         s_1=s_1+"\n\n"+@ob_data.to_s
      end # if
      return s_1
   end # to_s

   def [] i_index
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Fixnum, i_index
         kibuvits_assert_arrayix(bn,@ar_elements,i_index)
      end # if
      msgc_or_msgcs=@ar_elements[i_index]
      return msgc_or_msgcs
   end # []

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

   private

   def Kibuvits_msgc_stack.test_eachfunc
      msgcs=Kibuvits_msgc_stack.new
      msgcs.cre "AA"
      msgcs.cre "BB"
      msgcs.cre "CC"
      ar=Array.new
      msgcs.each do |msgc|
         ar<<msgc.to_s
      end # loop
      kibuvits_throw "test 1" if ar.length!=3
      # The "each" is not meant to guarantee specific order,
      # but while it does, one can get away with the following 3 lines.
      kibuvits_throw "test 2" if ar[0]!="AA"
      kibuvits_throw "test 3" if ar[1]!="BB"
      kibuvits_throw "test 4" if ar[2]!="CC"
   end # Kibuvits_msgc_stack.test_eachfunc

   def Kibuvits_msgc_stack.test_1
      msgc=Kibuvits_msgc.new "Hi","code4",false
      msgcs=Kibuvits_msgc_stack.new
      kibuvits_throw "test 1" if msgcs.length!=0
      kibuvits_throw "test 2" if msgcs.b_failure!=false
      if !kibuvits_block_throws{ msgcs<<42}
         kibuvits_throw "test 3"
      end # if
      msgcs<< msgc
      kibuvits_throw "test 4" if msgcs.length!=1
      kibuvits_throw "test 5" if msgcs.b_failure!=false
      msgc.b_failure=true
      msgc2=Kibuvits_msgc.new "Bo","code42",false
      msgcs<< msgc2
      kibuvits_throw "test 6" if msgcs.length!=2
      kibuvits_throw "test 7" if msgcs.b_failure!=true
      msgc.b_failure=false
      kibuvits_throw "test 8" if msgcs.b_failure!=false
      msgc2.b_failure=true
      kibuvits_throw "test 9" if msgcs.b_failure!=true
      if !kibuvits_block_throws{ msgcs<<msgc2} # tests for multiple insertion
         kibuvits_throw "test 10"
      end # if
      msgcs.clear
      kibuvits_throw "test 11" if msgcs.b_failure!=false
      kibuvits_throw "test 12" if msgcs.length!=0
      msgc2.b_failure=false
      if kibuvits_block_throws{ msgcs<<msgc2} # re-insertion after cleanup
         kibuvits_throw "test 13"
      end # if
      x=msgcs[0]
      kibuvits_throw "test 14" if msgcs.b_failure!=false
      x.b_failure=true
      kibuvits_throw "test 15" if msgcs.b_failure!=true
      x.b_failure=false
      kibuvits_throw "test 16" if msgcs.b_failure!=false
      msgcs2=Kibuvits_msgc_stack.new
      msgcs=Kibuvits_msgc_stack.new
      msgcs.cre "Greeting", "code42",false
      kibuvits_throw "test 18" if msgcs.b_failure!=false
      kibuvits_throw "test 19" if msgcs.length!=1
      kibuvits_throw "test 20" if msgcs[0].s_instance_id!=msgcs.last.s_instance_id
      msgcs.cre "Greeting2", "code43"
      kibuvits_throw "test 21" if msgcs.b_failure!=true
   end # Kibuvits_msgc_stack.test_1


   def Kibuvits_msgc_stack.test_stack_within_stack
      msgcs_1=Kibuvits_msgc_stack.new
      msgcs_1.cre "AA_1"
      msgcs_1.cre "BB_1"
      msgcs_1.cre "CC_1"
      msgcs_2=Kibuvits_msgc_stack.new
      msgcs_2.cre "DD_2"
      msgcs_2.cre "EE_2"
      msgcs_2.cre "FF_2"
      msgcs_1<<msgcs_2
      msgcs_1.cre "GG_1"
   end # Kibuvits_msgc_stack.test_stack_within_stack

   def Kibuvits_msgc_stack.test_serialization_and_to_s
      msgcs_1=Kibuvits_msgc_stack.new
      msgcs_1.cre "AA_1"
      msgcs_1.cre "BB_1"
      msgcs_1.cre "CC_1"
      msgcs_2=Kibuvits_msgc_stack.new
      msgcs_2.cre "DD_2"
      msgcs_2.cre "EE_2"
      msgcs_2.cre "FF_2"
      msgcs_3=Kibuvits_msgc_stack.new
      msgcs_3.cre "GG_3"
      msgcs_2<<msgcs_3
      msgcs_1<<msgcs_2
      msgcs_1.cre "HH_1"

      bn=binding()
      s_1=msgcs_1.to_s
      s_2=Kibuvits_szr.serialize(bn,msgcs_1)
      msgcs_x=Kibuvits_szr.deserialize(bn,s_2)
      #puts "--------------------------\n"
      s_3=msgcs_x.to_s
      # The test method might be called more than one,
      # which explains the multiple printouts for
      #puts s_3
      #puts "AAA--------------------------\n"
      kibuvits_throw "test 1" if s_1!=s_3
   end # Kibuvits_msgc_stack.test_serialization_and_to_s

   public
   def Kibuvits_msgc_stack.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_msgc.test_clone"
      kibuvits_testeval bn, "Kibuvits_msgc_stack.test_1"
      kibuvits_testeval bn, "Kibuvits_msgc_stack.test_eachfunc"
      kibuvits_testeval bn, "Kibuvits_msgc_stack.test_stack_within_stack"
      kibuvits_testeval bn, "Kibuvits_msgc_stack.test_serialization_and_to_s"
      return ar_msgs
   end # Kibuvits_msgc_stack.selftest

end # class Kibuvits_msgc_stack

#--------------------------------------------------------------------------

#==========================================================================
#Kibuvits_msgc.selftest
#puts Kibuvits_msgc_stack.selftest.to_s

