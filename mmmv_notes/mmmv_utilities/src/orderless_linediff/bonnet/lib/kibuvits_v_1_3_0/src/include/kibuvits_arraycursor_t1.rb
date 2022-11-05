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

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
else
   require  "kibuvits_boot.rb"
end # if

#==========================================================================

# The Array.new.each {|array_element| do_something(array_element)} iterates
# over all elements of the array, but instances of this class allow
# to pause the iteration cycle and implement the "overflow" mechanism.
# For example, if ar[ar.size] is reached, it returns ar[0].
#
# It allows to iterate to both directions, like {0,1,2,3} and {3,2,1,0}.
class Kibuvits_arraycursor_t1

   attr_reader :ar_core

   #-----------------------------------------------------------------------

   def reset(ar_core)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array,ar_core
      end # if KIBUVITS_b_DEBUG
      # As the @ar_core is a reference, code outside might call
      # Array.clear(). and that might cause the cursor position
      # to become obsolete.
      if @b_threadsafe
         @mx.synchronize do
            @ar_core=ar_core
            @i_ar_core_expected_lenght=@ar_core.size
            # The indexing scheme: http://urls.softf1.com/a1/krl/frag4_array_indexing_by_separators/
            @ixs_low=0
            @ixs_high=0
            @ixs_high=1 if 0<@i_ar_core_expected_lenght
            @b_inited=true
         end # block
      else
         @ar_core=ar_core
         @i_ar_core_expected_lenght=@ar_core.size
         # The indexing scheme: http://urls.softf1.com/a1/krl/frag4_array_indexing_by_separators/
         @ixs_low=0
         @ixs_high=0
         @ixs_high=1 if 0<@i_ar_core_expected_lenght
         @b_inited=true
      end # if
   end # reset

   # Description resides next to the method inc().
   def clear
      if @b_threadsafe
         @mx.synchronize do
            @b_inited=false
            @ar_core=$kibuvits_lc_emptyarray
         end # block
      else
         @b_inited=false
         @ar_core=$kibuvits_lc_emptyarray
      end # if
   end # clear

   def initialize(b_threadsafe=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [TrueClass,FalseClass],b_threadsafe
      end # if KIBUVITS_b_DEBUG
      @b_threadsafe=b_threadsafe
      @mx=nil
      @mx=Monitor.new if @b_threadsafe
      clear()
   end # initialize

   #-----------------------------------------------------------------------

   # This method is meant to be overridden. Methods inc() and dec()
   # will skip all elements in the array, where this method returns true;
   #
   # If all elements in the array are skipped, then the cursor
   # position will not be changed and inc() and dec() will return nil.
   # The dec() and inc() will avoid infinite loops by keeping track of
   # the index accountancy. Code example:
   #
   # ob_cursor=Kibuvits_arraycursor_t1.new
   # def ob_cursor.b_skip(x_array_element)
   #     b_out=do_some_analysis(x_array_element)
   #     return b_out
   # end # ob_cursor.b_skip
   #
   def b_skip(x_array_element)
      return false
   end # b_skip

   #-----------------------------------------------------------------------
   private

   def b_conditions_met_for_returning_nil_for_both_inc_and_dec(i_ar_len)
      if !@b_inited
         s_0=self.class.to_s
         kibuvits_throw("\n\nThe "+s_0+" instance has not been associated with "+
         "an array.\n"+s_0+" instances can be "+
         "associeated with an array by using metod reset(ar)."+
         "\nGUID='c925f42e-6007-4854-a3a8-b2a06041bcd7'\n\n")
      end # if
      if @i_ar_core_expected_lenght!=i_ar_len
         @b_inited=false # Should the exception be caught by some sloppy developer.
         kibuvits_throw("\n\nThe length of the array instance that "+
         "has been declared by using the method reset(ar)\n"+
         "has been changed from "+@i_ar_core_expected_lenght.to_s+
         " to "+i_ar_len.to_s+".\n"+
         "\nGUID='c925f42e-6007-4854-a3a8-b2a06041bcd7'\n\n")
      end # if
      if KIBUVITS_b_DEBUG
         if 0<i_ar_len
            if @ixs_low==@ixs_high
               kibuvits_throw("\n\n@ixs_low == "+@ixs_low.to_s+
               " == @ixs_high == "+@ixs_high.to_s+
               "\nGUID='c925f42e-6007-4854-a3a8-b2a06041bcd7'\n\n")
            end # if
         end # if
      end # if KIBUVITS_b_DEBUG
      return true if i_ar_len==0
      return false
   end # b_conditions_met_for_returning_nil_for_both_inc_and_dec

   def inc_sindices(i_ar_len)
      if KIBUVITS_b_DEBUG
         if i_ar_len==0
            kibuvits_throw("\n\ni_ar_len == 0, which is contradictory here.\n"+
            "\nGUID='c925f42e-6007-4854-a3a8-b2a06041bcd7'\n\n")
         end # if
      end # if KIBUVITS_b_DEBUG
      return if i_ar_len==1
      if @ixs_high==i_ar_len
         @ixs_low=0
         @ixs_high=1
      else
         @ixs_low=@ixs_low+1
         @ixs_high=@ixs_high+1
      end # if
   end # inc_sindices

   def dec_sindices(i_ar_len)
      if KIBUVITS_b_DEBUG
         if i_ar_len==0
            kibuvits_throw("\n\ni_ar_len == 0, which is contradictory here.\n"+
            "\nGUID='c925f42e-6007-4854-a3a8-b2a06041bcd7'\n\n")
         end # if
      end # if KIBUVITS_b_DEBUG
      return if i_ar_len==1
      if @ixs_low==0
         @ixs_high=i_ar_len
         @ixs_low=i_ar_len-1
      else
         @ixs_low=@ixs_low-1
         @ixs_high=@ixs_high-1
      end # if
   end # dec_sindices

   def inc_and_dec_impl(b_increment)
      # The b_skip() might be defined more than once during
      # instance lifetime, which means that unless one wants
      # to start keeping track of the redefining part and to
      # apply heavy reflection routines, an observation that
      # all elements in the array are skipped, can not be cached.
      i_ar_len=@ar_core.size
      if b_conditions_met_for_returning_nil_for_both_inc_and_dec(i_ar_len)
         return nil
      end # if
      # Here the @ar_core has at least one element and the @b_inited==true
      x_elem_out=nil
      ixs_low_0=@ixs_low
      b_go_on=true
      while b_go_on
         x_elem_out=@ar_core[@ixs_low]
         if b_increment
            inc_sindices(i_ar_len)
         else
            dec_sindices(i_ar_len)
         end # if
         if b_skip(x_elem_out)
            if i_ar_len==1
               x_elem_out=nil
               b_go_on=false
            else
               if ixs_low_0==@ixs_low
                  # All elements skipped
                  x_elem_out=nil
                  b_go_on=false
               end # if
            end # if
         else
            b_go_on=false
         end # if
      end # loop
      return x_elem_out
   end # inc_and_dec_impl

   public
   # Throws or returns nil or an array element that the cursor points to.
   #
   # The inc() and dec() return the element under the
   # cursor and then move the cursor. Explanation by example:
   #
   #     reset(["aa","bb","cc");
   #     inc()=="aa"; inc()=="bb"; inc()=="cc"; inc()=="aa"; dec()=="bb"; dec()==aa;
   #     clear()
   #     inc() and dec() will throw and exception.
   #
   #     reset(["aa","bb","cc");
   #     inc()=="aa"; inc()=="bb";
   #     reset([]);
   #     inc()==nil; inc()==nil; dec()==nil
   #
   def inc()
      if @b_threadsafe
         @mx.synchronize do
            inc_and_dec_impl(true)
         end # block
      else
         inc_and_dec_impl(true)
      end # if
   end # inc

   # Description resides next to the method inc().
   def dec()
      if @b_threadsafe
         @mx.synchronize do
            inc_and_dec_impl(false)
         end # block
      else
         inc_and_dec_impl(false)
      end # if
   end # dec

   # Explanation by example:
   #
   # reset(["aa","bb","cc");
   # b_inited==true
   # clear()
   # b_inited==false
   #
   def b_inited
      return @b_inited
   end # b_inited

   # A single array element is selected by using
   # 2 sindices: low and high. http://urls.softf1.com/a1/krl/frag4_array_indexing_by_separators/
   #
   # This method returns the lower bound that corresponds
   # to the classical array index.
   def ixs_low
      return @ixs_low
   end # ixs_low

   #-----------------------------------------------------------------------

end # class Kibuvits_arraycursor_t1

#==========================================================================
