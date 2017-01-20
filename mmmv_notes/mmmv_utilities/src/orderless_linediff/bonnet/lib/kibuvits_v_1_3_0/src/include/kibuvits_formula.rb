#!/usr/bin/env ruby 
#=========================================================================
=begin

 Copyright 2011, martin.vahi@softf1.com that has an
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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_GUID_generator.rb"
   require  "kibuvits_ix.rb"
end # if
require "bigdecimal"
#==========================================================================

# The class Kibuvits_formula exists mainly for duck typing.
#
# Everything is stored to the public field, which is a
# hash table, and the main idea is that a formula consists of
# components that are described by 2 variables in the hashtable:
#
# x) An array of other formulaes, integers or symbols, like the Pi.
#
# x) A string that is a name of the function that ties the
#    array elements together. For example, it might be multiplication,
#    werhe the order of elements in the array is relevant in cases
#    of matrixes, or the function might be summation, where usually
#    the order of arguments, in thins case, the array elements,
#    is not relevant.
#
# One calls the formula component that are described by the array and
# the string a formulicle. (It's a bit like the word: particle. The
# word "funclet" seems to be already used by other people for other
# denotates.)
#
# The format of the hashtable is simplistic enough to be read
# form the source of the Kibuvits_formula.create_formulicle
class Kibuvits_formula
   @@lc_s_formulicle_name='s_formulicle_name_'
   @@lc_ar_formulicle_elements='ar_formulicle_elements_'
   @@lc_s_numerator='numerator'
   @@lc_s_denominator='denominator'
   @@lc_s_fraction='fraction'

   attr_reader :ht #The content of the @ht is editable despite the attr_reader.
   attr_reader :s_id #==GUID

   # The s_formulicles_set_name is useful for determining, how to
   # interpret the set of formulicles.
   attr_accessor :s_formulicles_set_name

   def initialize
      @ht=Hash.new
      @s_id=Kibuvits_GUID_generator.generate_GUID();
      @s_formulicles_set_name=nil
   end #initialize

   private

   public

   # There are no type restrictions set to the elements of the ar.
   # For example, the elements might be matrices, Kibuvits_formula
   # instances, etc., but a recommendation is to use BigDecimal
   # instances in stead of Float and Fixnum instances, because
   # that avoids Fixnum related truncation and Float related
   # rounding errors.
   def create_formulicle(s_name, ar)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_name
         kibuvits_typecheck bn, Array, ar
      end # if
      kibuvits_throw 's_name.length==0' if s_name.length==0
      @ht[@@lc_s_formulicle_name+s_name]=s_name
      @ht[@@lc_ar_formulicle_elements+s_name]=ar
   end # create_formulicle

   def delete_formulicle(s_name)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_name
      end # if
      Hash.new.delete(@@lc_s_formulicle_name+s_name)
      Hash.new.delete(@@lc_ar_formulicle_elements+s_name)
   end # delete_formulicle

   # Deletes all formulicles.
   #
   # This function exists just in case one changes the
   # specification of the Kibuvits_formula later.
   def clear
      @ht.clear
   end # clear

   #----------start-of-convenience-methods----------------------------

   def create_fraction(ar_or_x_numerator, ar_or_x_denominator)
      # If the single element at the numerator array is itself an
      # array, then one has to wrapt it to the fraction array outside
      # of this function, because the following 2 lines are not capable
      # of distinquishing the 2 cases.
      ar_numerator=Kibuvits_ix.normalize2array(ar_or_x_numerator)
      ar_denominator=Kibuvits_ix.normalize2array(ar_or_x_denominator)
      kibuvits_throw "ar_numerator.size==0" if ar_numerator.size==0
      kibuvits_throw "ar_denominator.size==0" if ar_denominator.size==0

      create_formulicle(@@lc_s_numerator,ar_numerator)
      create_formulicle(@@lc_s_denominator,ar_denominator)
      @s_formulicles_set_name=@@lc_s_fraction
   end # create_fraction

   def create_Riemann_integral(forumla_for_the_function,formula_for_the_dx_part,
      upper_limit=nil,lower_limit=nil)
      # TODO: complete it
   end # create_Riemann_integral

   #----------end-of-convenience-methods------------------------------

   private
   def Kibuvits_formula.test_1
      ob_formula_1=Kibuvits_formula.new
      ob_formula_1.create_fraction(BigDecimal(4.to_s),BigDecimal(5.to_s))
      ob_formula_1.delete_formulicle(@@lc_s_denominator)
   end # Kibuvits_formula.test_1

   public
   def Kibuvits_formula.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_formula.test_1"
      return ar_msgs
   end # Kibuvits_formula.selftest

end # class Kibuvits_formula

#=========================================================================
