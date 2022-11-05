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
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"

#==========================================================================

# The idea is that there's a set of ID-name-ID-value pairs , i.e. a
# registry of ID-s, and one writes the ID-values out into the wild.
# The wilderness might be a set of documents, communication packets,
# communication sessions, etc.
#
# The question that the instances of the Kibuvits_IDstamp_registry_t1 help to answer is:
# Has an ID in the registry or in the wild chanted
# after the event, where the ID got copied from the registry to the wild?
#
# ID-s are usually assembled by concating Globally Unique Identifiers with
# some other strings and postprocessing the resultant string.
class Kibuvits_IDstamp_registry_t1

   attr_reader :s_default_ID_prefix

   #-----------------------------------------------------------------------

   def initialize(s_default_ID_prefix=$kibuvits_lc_emptystring,
      b_nil_from_wilderness_differs_from_registry_entries=false)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_default_ID_prefix
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_nil_from_wilderness_differs_from_registry_entries
      end # if
      @s_default_ID_prefix=($kibuvits_lc_emptystring+s_default_ID_prefix).freeze
      @b_nil_from_wilderness_differs_from_registry_entries=b_nil_from_wilderness_differs_from_registry_entries
      @ht_registry=Hash.new
      @ht_prefixes=Hash.new
   end # initialize

   # ID-s can have heir private prefixes that override the default ID prefix.
   # ID-s, including their prefixes, must adhere to the rules of variable names.
   def set_ID_prefix(s_id_name,s_id_prefix)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_prefix)
      end # if
      @ht_prefixes[s_id_name]=($kibuvits_lc_emptystring+s_id_prefix).freeze
   end # set_ID_prefix

   def s_get_ID_prefix(s_id_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      s_out=@s_default_ID_prefix
      s_out=@ht_prefixes[s_id_name] if @ht_prefixes.has_key? s_id_name
      return s_out
   end # s_get_ID_prefix

   #-----------------------------------------------------------------------
   private

   def generate_ID(s_id_name,s_value_that_the_new_id_must_differ_from=$kibuvits_lc_underscore)
      s_out=nil
      s_initial=s_value_that_the_new_id_must_differ_from
      b_go_on=true
      while b_go_on
         s_out=s_get_ID_prefix(s_id_name)+Kibuvits_GUID_generator.generate_GUID()
         s_out.gsub!($kibuvits_lc_minus,$kibuvits_lc_underscore)
         b_go_on=false if s_initial!=s_out
      end # loop
      return s_out
   end # generate_ID

   #-----------------------------------------------------------------------
   public

   # ID-s must adhere to the rules of variable names.
   def set(s_id_name,s_id)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id)
      end # if
      @ht_registry[s_id_name]=($kibuvits_lc_emptystring+s_id).freeze
   end # set

   # Generates a new value for the ID in the registry.
   def reset(s_id_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      s_id_registry=nil
      if @ht_registry.has_key? s_id_name
         s_id_registry=@ht_registry[s_id_name]
      else
         s_id_registry=$kibuvits_lc_underscore
      end # if
      @ht_registry[s_id_name]=(generate_ID(s_id_name,s_id_registry)).freeze
   end # reset

   def s_get(s_id_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      reset(s_id_name) if !@ht_registry.has_key? s_id_name
      s_out=@ht_registry[s_id_name]
      return s_out
   end # s_get

   #-----------------------------------------------------------------------

   # Returns true, if the ht_wild[s_id_name] differs
   # from the ID in the registry. Performs the operation of:
   # ht_wild[s_id_name]=s_get(s_id_name)
   def b_xor_registry2wild(ht_wild,s_id_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_wild
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      b_out=true
      if !@ht_registry.has_key? s_id_name
         # nil from registry and <whatever_value_from_the_wild> always differ.
         s_id_wild=$kibuvits_lc_underscore
         s_id_wild=ht_wild[s_id_name] if ht_wild.has_key? s_id_name
         s_id_registry=generate_ID(s_id_name,s_id_wild)
         set(s_id_name,s_id_registry)
         s_id_registry=s_get(s_id_name) # to be consistent
         ht_wild[s_id_name]=s_id_registry
         return b_out
      end # if
      s_id_registry=s_get(s_id_name)
      if !ht_wild.has_key? s_id_name
         ht_wild[s_id_name]=s_id_registry
         b_out=@b_nil_from_wilderness_differs_from_registry_entries
         return b_out
      end # if
      s_id_wild=ht_wild[s_id_name]
      if s_id_wild==s_id_registry
         b_out=false
      else
         ht_wild[s_id_name]=s_id_registry
      end # if
      return b_out
   end # b_xor_registry2wild

   # Returns true, if the ht_wild[s_id_name] differs
   # from the ID in the registry. Performs the operation of:
   # self.set(s_id_name,ht_wild[s_id_name])
   #
   # Throws, if the ht_wild[s_id_name] is not a string that
   # conforms to variable name requirements.
   def b_xor_wild2registry(ht_wild,s_id_name)
      bn=binding() # Outside of the if due to multiple uses.
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck bn, Hash, ht_wild
         kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      if !ht_wild.has_key? s_id_name
         kibuvits_throw("\n\nht_wild is missing the key \""+s_id_name+
         "\nGUID='3e377304-78c6-484f-b9e7-93906041bcd7'\n\n")
      end # if
      s_id_wild=ht_wild[s_id_name] # Hash[<nonexisting_key>] does not throw, but returns nil
      cl=s_id_wild.class
      if cl!=String # Includes the case, where s_id_wild==nil
         # The reason, why an exception is thrown here
         # in stead of just branching according to the
         # @b_nil_from_wilderness_differs_from_registry_entries
         # is that if the ht_wild has nil paired to the <s_id_name>,
         # then it's likely that the application code that wrote the
         # value to the ht_wild is faulty. A general requirement
         # is that the ht_wild[s_id_name] meets variable name requirements.
         kibuvits_throw("\n\nht_wild does contain the key \""+s_id_name+
         ", but it is not paired with a string.\n"+
         "s_id_wild.class=="+cl.to_s+
         "\ns_id_wild=="+s_id_wild.to_s+
         "\nGUID='62f17425-a5a1-4658-a5e7-93906041bcd7'\n\n")
      end # if
      kibuvits_assert_ok_to_be_a_varname_t1(bn,s_id_wild) if KIBUVITS_b_DEBUG
      reset(s_id_name) if !@ht_registry.has_key? s_id_name
      s_id_registry=@ht_registry[s_id_name]
      b_out=(s_id_wild!=s_id_registry)
      set(s_id_name,s_id_wild)
      return b_out
   end # b_xor_wild2registry

   #-----------------------------------------------------------------------

   def clear
      @ht_registry.clear
      @ht_prefixes.clear
   end # clear

end # class Kibuvits_IDstamp_registry_t1

#==========================================================================
