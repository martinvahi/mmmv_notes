#!/usr/bin/env ruby
#=========================================================================
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
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_refl.rb"

#==========================================================================

# The Kibuvits_gstatement instances represents an
# EBNF style statement like MY_GSTATEMENT_TYPE:==MOUSE MOUSEJUMP* CAT?
#
# The Kibuvits_gstatement acts as a container for other
# instances of the Kibuvits_gstatement. The overall idea
# behind the Kibuvits_gstatement is that if all of the
# terms and terminals at the right side of the :== are represented
# by elements that reside inside the Kibuvits_gstatement based
# container, then one can generate code by using the
# Decorator design pattern. One just has to call the to_s
# method of the container to get the generated code. :-)
#
# The EBNF spec that is given to the container at initialization
# detetermins the internal structure of the container.
#
# The set of supported operators in the spec is {|,?,+,*},
# but a limitation is that only one level of braces
# is supported, i.e. nesting of braces is not allowd, and
# none of the operators, the {|,?,+,*}, may be used
# outside of braces, except when the right side of the
# EBNF style spec does not contain any braces.
#
# Examples of supported, i.e. valid, specifications:
#         UUU:== A |B |C
#         UUU:==(A |B |C )
#         UUU:== A?|B*|C+
#         UUU:==(A?|B*|C+)
#         UUU:==(A )B  C
#         UUU:==(A |B) C
#         UUU:== A (B|C+) D # gets autocompleted to "(A)(B|C+)(D)"
#
# Examples of UNsupported, i.e. INvalid, specifications:
#         UUU:== A  B |C
#         UUU:==(A  B |C )
#         UUU:== A?|B  C
#         UUU:==(A )B  C+
#         UUU:== A (B|C+) D+
#
# The reason, why the "UUU:== A (B|C+) D+" is not supported
# is that the autocompletion is not advanced enough to handle the
# operator after D.
# The reason, why the " UUU:== A  B |C" is not supported is
# that it actually entails "UUU:==(A B)|C", where the | operator
# is outside of the brackets. If multiple nesting is not
# allowed, one can not autocomple it to "UUU:==((A B)|C)".
#
# There's also a limitation that on the right side of the ":=="
# each term/terminal can be used only once.
#
# NOT supported:
#         UUU:==(A B A+)
#
# The reason for that limitation
# is that later, when one inserts elements that correspond to
# the terms and terminals, one is not able to determine, to
# which of the terminals the insertable element must correspond to.
# For example, in the case of the "UUU:==(A B A+)", it's not
# possible to determine, if it should represent/generate code for
# the first "A" or the second "A".
class Kibuvits_gstatement
   attr_reader :name, :s_spec
   attr_accessor :s_prefix, :s_suffix # for code generation simplification

   private
   @@lc_s_claim_to_be_a_gstatement_42_7="claim_to_be_a_gstatement_42_7"
   @@lc_space=$kibuvits_lc_space
   @@lc_ceqeq=":=="
   @@lc_emptystring=$kibuvits_lc_emptystring
   @@lc_lbrace=$kibuvits_lc_lbrace
   @@lc_rbrace=$kibuvits_lc_rbrace
   @@lc_questionmark=$kibuvits_lc_questionmark
   @@lc_star=$kibuvits_lc_star
   @@lc_plus=$kibuvits_lc_plus
   @@lc_pillar=$kibuvits_lc_pillar
   @@lc_b_complete="b_complete"
   @@lc_ht_level3="ht_level3"
   @@lc_i_level3_min_length="i_level3_min_length"
   @@lc_i_level3_max_length="i_level3_max_length"
   @@lc_ht_level2_index="ht_level2_index"
   @@lc_ar_level3_elements="ar_level3_elements"
   @@lc_name="name"

   # Teststring for testing the @@rgx_for_verification_1
   #
   # (a(bla  (aaa  (ff
   # ((blabla)
   # ( a )b )
   # (bsd))
   # (blabla)? blabla( ff) () ( )
   # a??  b* c** d+ e++ f+* g*?
   # UUU :==C | D* E (F|D)
   # b=  c==g    f=:g
   # GG :==:==ff
   # GG :== :==ff   ll:== ii:==dd
   # (  an uncompleted bracket
   # an unstarted bracket)
   #
   # One has to give credit to the authors of
   # the KomodoIDE regex editor. :-)
   # TODO: The regex doesn't handle the uncompleted brackets.
   @@rgx_for_verification_1=/[*+?]{2}|[(][^)(]*[(]|[)][^)(]*[)]|:==:|[^:=]=|=[^:=]*:/

   # Teststring for testing the @@rgx_for_verification_2
   #  | a
   #  ? a
   #  + a
   #  * a
   #  a |
   @@rgx_for_verification_2=/^[\s]*[|+?*]|[|][\s]*$/

   # Teststring for testing the @@rgx_for_verification_3
   # (a)?
   # (b) *
   # (c d ) +
   # (e f)| (g h)
   # (BB)(CC)(DD+)
   @@rgx_for_verification_3=/[)][^?(*+|]*[?*+|]/

   # Teststring for testing the @@rgx_for_verification_4 and 5
   # A  (B |C)  # the valid case
   # A  B |C    # the invalid case
   # A | B C    # the invalid case
   # (A | B) C  # the valid case
   @@rgx_for_verification_4=/[^\s(]+[\s]+[^|\s(]+[\s]*[|]/
   @@rgx_for_verification_5=/[|][\s]*[^\s)]+[\s]+[^\s]/

   @@rgx_or_at_startofline=/^[|]/
   @@rgx_or_at_endofline=/[|]$/
   @@rgx_two_ors=/[|]{2}/


   # Teststring:
   # UUU :==(A*|B)+ C () (  ) (D ) E? ( F|G )? H ?
   @@rgx_empty_braces=/[(][\s]*[)]/

   # Teststring:"x *  y+  z  ? w + x | zz|ww"
   @@rgx_space_questionmark=/[\s]+[?]/
   @@rgx_space_plus=/[\s]+[+]/
   @@rgx_space_star=/[\s]+[*]/
   @@rgx_space_or=/[\s]+[|]/
   @@rgx_space_rbrace=/[\s]+[)]/
   @@rgx_questionmark_space=/[?][\s]*/
   @@rgx_plus_space=/[+][\s]*/
   @@rgx_star_space=/[*][\s]*/
   @@rgx_or_space=/[|][\s]*/
   @@rgx_lbrace_space=/[(][\s]+/

   @@rgx_lbrace=/[(]/
   @@rgx_rbrace=/[)]/

   @@rgx_at_least_one_space=/[\s]+/

   @@rgx_at_least_one_rbrace=/[)]+/
   @@rgx_at_least_one_lbrace=/[(]+/

   def thrf_do_some_partial_verifications s_spec
      if s_spec.match(@@rgx_for_verification_1)!=nil
         kibuvits_throw "\nFaulty specification. "+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_2)!=nil
         kibuvits_throw "\nEither one of the operators, {?,*,+,|}, is \n"+
         "at the start of the right side of the equation or \n"+
         "the | operator is at the end of the equation.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_3)!=nil
         kibuvits_throw "\nDue to a implementationspecific limitation the \n"+
         "use of any of the operators, {?,*,+,|}, outside of braces\n"+
         "is not allowed.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_4)!=nil
         kibuvits_throw "\nCases like \"Abb Bcc | Cdd\" are not supported.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_5)!=nil
         kibuvits_throw "\nCases like \"Abb | Bcc Cdd\" are not supported.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
   end # thrf_do_some_partial_verifications


   def get_array_of_level1_components s_right
      ar_out=Array.new
      return ar_out if s_right.length==0
      # There are also cases like A(B)C()D (  ) E,
      # where there will be 2 spaces between the D and E after
      # the removal of the (). The C and D have to be
      # kept separate.
      s_right=s_right.gsub(@@rgx_empty_braces,@@lc_space)
      s_right=s_right.gsub(@@rgx_at_least_one_space,@@lc_space)
      return ar_out if s_right==@@lc_space

      # One separates the level1 components from eachother by
      # "(". Due to the artificial limitation the level1
      # components never have any of the operators, the {?,*,+,|},
      # but some of them are still not surrounded with braces.
      #
      # By now the s_right is like "A|B|C*" or like "A (B+|C) E".
      # One need to get them to a form of "(A)(B+|C)(E)" One assumes
      # hat s_right has been trimmed prior to feeding it in this
      # method.

      # "A B?"            ->"A B?"
      # "A (B+ |C)E F(G)" ->"A (B+ |C) E F(G) "
      # ..............................A.......A.
      # "A|B|C*"          ->"A|B|C*"
      s_right=s_right.gsub(@@rgx_rbrace,") ")
      s_right=Kibuvits_str.trim(s_right)

      # "A B?"              -> "A B?"
      # "A (B+ |C) E F(G) " -> "A  (B+ |C) E F (G) "
      # ..........................A...........A......
      # "A|B|C*"            -> "A|B|C*"
      s_right=s_right.gsub(@@rgx_lbrace," (")

      # "A B?"                -> "A B?"
      # "A  (B+ |C) E F (G) " -> "A  (B+ |C) E F (G)"
      # ...................X...........................
      # "A|B|C*"              -> "A|B|C*"
      s_right=Kibuvits_str.trim(s_right)


      # "A B?"               -> "(A B?"
      # "A  (B+ |C) E F (G)" -> "(A  (B+ |C) E F (G)"
      # ..........................A......................
      # "A|B|C*"             -> "(A|B|C*"
      s_right=@@lc_lbrace+s_right if s_right[0..0]!=@@lc_lbrace

      # "(A B?"               -> "(A B?)"
      # ..............................A...................
      # "(A  (B+ |C) E F (G)" -> "(A  (B+ |C) E F (G)"
      # "(A|B|C*"             -> "(A|B|C*)"
      s_right=s_right+@@lc_rbrace if s_right[(-1)..(-1)]!=@@lc_rbrace

      # "(A B?)"              -> "(A B?)"
      # "(A  (B+ |C) E F (G)" -> "(A (B+ |C) E F (G)"
      # ....X............................................
      # "(A|B|C*)"            -> "(A|B|C*)"
      s_right=s_right.gsub(@@rgx_at_least_one_space,@@lc_space)

      # Now this is one of the places, where one depends
      # on the requirement that the operators,
      # {?,*,+,|} are never outside of the baces.
      #
      # "(A B?)"             -> "(A B?)"
      # "(A (B+ |C) E F (G)" -> "(A (B+|C) E F (G)"
      # .......X........................................
      # "(A|B|C*)"           -> "(A|B|C*)"
      s_right=s_right.gsub(@@rgx_space_questionmark,@@lc_questionmark)
      s_right=s_right.gsub(@@rgx_space_plus,@@lc_plus)
      s_right=s_right.gsub(@@rgx_space_star,@@lc_star)
      s_right=s_right.gsub(@@rgx_space_or,@@lc_pillar)
      s_right=s_right.gsub(@@rgx_space_rbrace,@@lc_rbrace)
      s_right=s_right.gsub(@@rgx_questionmark_space,@@lc_questionmark)
      s_right=s_right.gsub(@@rgx_plus_space,@@lc_plus)
      s_right=s_right.gsub(@@rgx_star_space,@@lc_star)
      s_right=s_right.gsub(@@rgx_or_space,@@lc_pillar)
      s_right=s_right.gsub(@@rgx_lbrace_space,@@lc_lbrace)

      # "(A B?)"            -> "(A) B?)"
      # "(A (B+|C) E F (G)" -> "(A) (B+|C)) E) F) (G)"
      # ..........................A.......A..A..A........
      # "(A|B|C*)"          -> "(A|B|C*)"
      s_right=s_right.gsub(@@lc_space,") ")

      # "(A) B?)"               -> "(A) B?)"
      # "(A) (B+|C)) E) F) (G)" -> "(A) (B+|C) E) F) (G)"
      # ...........X.......................................
      # "(A|B|C*)"              -> "(A|B|C*)"
      s_right=s_right.gsub(@@rgx_at_least_one_rbrace,@@lc_rbrace)

      # "(A) B?)"              -> "(A) B?)"
      # "(A) (B+|C) E) F) (G)" -> "(A) (B+|C) (E) (F) (G)"
      # ......................................A...A..........
      # "(A|B|C*)"             -> "(A|B|C*)"
      s_right=s_right.gsub(@@lc_space," (")
      s_right=s_right.gsub(@@rgx_at_least_one_lbrace,@@lc_lbrace)

      # "(A) B?)"                -> "(A) B?)"
      # "(A) (B+|C) (E) (F) (G)" -> "(A)(B+|C)(E)(F)(G)"
      # ....X......X...X...X................................
      # "(A|B|C*)"               -> "(A|B|C*)"
      s_right=s_right.gsub(@@lc_space,@@lc_emptystring)
      ar=Kibuvits_str.explode(s_right,@@lc_lbrace)
      # ar[0]=="", because for sctring like "(blabla)" and
      # a separator like "(" the bisection takes place at the
      # first character. It's just according to the explode spec.

      if ar.length==1 # It's not for debug.
         kibuvits_throw "\nThe code of this class is broken. Sorry. ar.length=="+
         ar.length.to_s+"\n"
      end # if
      s=nil
      (ar.length-1).times do |i|
         s=ar[i+1]
         kibuvits_throw "s=="+s.to_s if s.length<2 # It should at least have the ")".
         kibuvits_throw "s=="+s.to_s if s[(-1)..(-1)]!=@@lc_rbrace
         ar_out<<s[0..(-2)]
      end # loop
      return ar_out;
   end # get_array_of_level1_components

   def level2_spec_partial_verification s_level2_spec
      if s_level2_spec.match(@@rgx_or_at_startofline)!=nil
         kibuvits_throw "\nPlacing the operator | at the start of "+
         "a subexpression does not make sense.\n"+
         "subexpression=="+s_level2_spec+"\n"
      end # if
      if s_level2_spec.match(@@rgx_or_at_endofline)!=nil
         kibuvits_throw "\nPlacing the operator | at the end of "+
         "a subexpression does not make sense.\n"+
         "subexpression=="+s_level2_spec+"\n"
      end # if
      if s_level2_spec.match(@@rgx_two_ors)!=nil
         kibuvits_throw "\nPlacing more than one | operator "+
         "between 2 terminals or terms is not supported.\n"+
         "subexpression=="+s_level2_spec+"\n"
      end # if
      if s_level2_spec.length==0
         kibuvits_throw "\nThe code of this class is broken. "+
         "s_level2_spec.lenght==0\n"
      end # if
   end # level2_spec_partial_verification

   # Level3 specs are like "A?", "Bblaa", "Foo+", "wow+".
   def initialize_single_level3_component(s_level3_spec,ht_level2)
      s_operator_candidate=s_level3_spec[(-1)..(-1)]
      s_name=nil
      i_level3_min_length=1
      i_level3_max_length=1
      case s_operator_candidate
      when @@lc_questionmark
         s_name=s_level3_spec[0..(-2)]
         i_level3_min_length=0
      when @@lc_star
         s_name=s_level3_spec[0..(-2)]
         i_level3_min_length=0
         i_level3_max_length=(-1)
      when @@lc_plus
         s_name=s_level3_spec[0..(-2)]
         i_level3_max_length=(-1)
      else # no operators present
         s_name=s_level3_spec
      end # case

      ht_level3=Hash.new
      ht_level3[@@lc_name]=s_name
      if @ht_gstatement_name_2_ht_level3.has_key? s_name
         kibuvits_throw "\nEach of the terminal/term names can be used \n"+
         "only once at the right side of the \":==\". It's because \n"+
         "if one inserts code generators as elements to this \n"+
         "container, one needs a one to one correspondance between \n"+
         "the code generators and terms/terminals.\n"+
         "Duplicated name:\""+s_name+"\"\n"
      end #
      ht_level2_index=ht_level2[@@lc_ht_level2_index]
      ht_level2_index[s_name]=ht_level3
      @ht_gstatement_name_2_ht_level3[s_name]=ht_level3

      b_complete=false
      b_complete=true if i_level3_min_length==0
      ht_level3[@@lc_b_complete]=b_complete

      ht_level3[@@lc_i_level3_min_length]=i_level3_min_length
      ht_level3[@@lc_i_level3_max_length]=i_level3_max_length

      ht_level3[@@lc_ar_level3_elements]=Array.new
   end # initialize_single_level3_component

   # Memory map:
   #
   # @ar_level1
   #   |
   #   +-ht_level2
   #     |
   #     +-b_complete
   #     |
   #     +-ht_level2_index[level3_name]
   #       |
   #       +-ht_level3
   #         |
   #         +-name
   #         +-b_complete
   #         |
   #         | # ? -> (0,1)               * -> (0,(-1))
   #         | # + -> (1,(-1))      default -> (1,1)
   #         +-i_level3_min_length==={0,1}
   #         +-i_level3_max_length==={(-1),1}
   #         |
   #         +-ar_level3_elements
   #           |
   #           +-gstatements
   #
   def initialize_single_level2_component(s_level2_spec, i_level1_index)
      level2_spec_partial_verification s_level2_spec
      ar=Kibuvits_str.explode(s_level2_spec,@@lc_pillar)

      ht_level2=@ar_level1[i_level1_index]
      ht_level2[@@lc_b_complete]=false
      ht_level2_index=Hash.new
      ht_level2[@@lc_ht_level2_index]=ht_level2_index
      ar.each do |s_level3_spec|
         initialize_single_level3_component(s_level3_spec,ht_level2)
      end # loop
   end # initialize_single_level2_component

   def parse_specification s_spec
      ar=Kibuvits_str.bisect(s_spec,@@lc_ceqeq)
      s_left=Kibuvits_str.trim(ar[0])
      s_right=Kibuvits_str.trim(ar[1])
      @name=s_left
      ar_level2_spec_strings=get_array_of_level1_components(s_right)
      @ar_level1=Array.new
      ar_level2_spec_strings.length.times{@ar_level1<<Hash.new}
      s_level2_spec=nil
      ar_level2_spec_strings.length.times do |i|
         s_level2_spec=ar_level2_spec_strings[i]
         initialize_single_level2_component(s_level2_spec,i)
      end # loop
   end # parse_specification

   def init_some_of_the_mainstructs
      @ht_gstatement_name_2_ht_level3=Hash.new
      @b_complete_cache=true
      @b_complete_cache_out_of_sync=true
      @mx=Mutex.new
      @mx2=Mutex.new
   end # init_some_of_the_mainstructs


   public
   def initialize s_specification_in_EBNF, msgcs
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_specification_in_EBNF
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      s_spec=s_specification_in_EBNF
      thrf_do_some_partial_verifications s_spec
      init_some_of_the_mainstructs
      parse_specification(s_specification_in_EBNF)
      @msgcs=msgcs
      @s_spec=s_specification_in_EBNF
      @s_prefix=@@lc_emptystring
      @s_suffix=@@lc_emptystring
   end #initialize
   private

   protected
   def claim_to_be_a_gstatement_42_7
      return true
   end # claim_to_be_a_gstatement_42_7


   # It's assumed that it's called only from
   # a synchronized code region.
   def update_ht_level3_b_complete ht_level3
      i_level3_min_length=ht_level3[@@lc_i_level3_min_length]
      # The ht_level3[@@lc_b_complete] is set to
      # true at the initialization, if the i_level3_min_length==0
      return if i_level3_min_length==0
      # Over here the i_level3_min_length==1
      ar_level3_elements=ht_level3[@@lc_ar_level3_elements]
      if ar_level3_elements.length==0
         ht_level3[@@lc_b_complete]=false
      else
         ht_level3[@@lc_b_complete]=true
      end # if
   end # update_ht_level3_b_complete ht_level3

   # It's assumed that it's called only from
   # a synchronized code region.
   def update_ht_level2_b_complete ht_level2
      ht_level2_index=ht_level2[@@lc_ht_level2_index]
      b_complete=true
      ht_level2_index.each_value do |ht_level3|
         update_ht_level3_b_complete ht_level3
         b_complete=b_complete&&ht_level3[@@lc_b_complete]
         break if !b_complete
      end # loop
      ht_level2[@@lc_b_complete]=b_complete
   end # update_ht_level2_b_complete

   public
   # Returns true, if the gstatement has enough
   # elements to satisfy the specification that
   # it received at initialization.
   def complete?
      @mx.synchronize do
         return @b_complete_cache if !@b_complete_cache_out_of_sync
         b_out=nil
         b_out=@b_complete_cache
         break if !@b_complete_cache_out_of_sync
         b_out=true
         @ar_level1.each do |ht_level2|
            update_ht_level2_b_complete(ht_level2)
            b_out=b_out&&ht_level2[@@lc_b_complete]
            if !b_out
               @b_complete_cache=false
               @b_complete_cache_out_of_sync=false
               break
            end # if
         end # loop
         @b_complete_cache=b_out
         @b_complete_cache_out_of_sync=false
      end #synchronize
      return @b_complete_cache
   end # complete?

   # Only the gstatements that have a name that
   # matches with the specification of this
   # gstatement, are insertable, provided that
   # the container gstatement is not full.
   #
   # For example, if a specification is:
   # MYTYPE:== a b c
   # then at most one gstatement with name of "a"
   # can be inserted to a gstatement, whiches name is "MYTYPE".
   #
   # This method returns always a boolean value, even, if
   # the tested instance is not a Kibuvits_gstatement istance.
   def insertable? x_gstatement_candidate
      # The synchronization is because API users are
      # expected to check insertability prior to inserting,
      # but that can change after insertion.
      @mx2.synchronize do
         return false if @ar_level1.length==0
         ob=x_gstatement_candidate
         # There's a difference between Ruby 1.8 and 1.9 that
         # in the case of the Ruby 1.8 method names are returned, but
         # in the case of the Ruby 1.9 Symbol instances are returned.
         # It's not Kibuvits specific, but one will not normalize
         # it at the Kibuvits_refl.get_methods_by_name either.
         # One just waits for the Ruby itself to stabilize to something.
         ht_method_names_or_symbols=Kibuvits_refl.get_methods_by_name(
         @@lc_s_claim_to_be_a_gstatement_42_7,ob,"protected",@msgcs)
         kibuvits_throw @msgcs.to_s if @msgcs.b_failure
         ht_method_names=Hash.new
         ht_method_names_or_symbols.each_key do |s_or_sym|
            ht_method_names[s_or_sym.to_s]=@@lc_emptystring
         end # loop
         if !ht_method_names.has_key? @@lc_s_claim_to_be_a_gstatement_42_7
            return false
         end # if
         s_name=ob.name
         return false if !@ht_gstatement_name_2_ht_level3.has_key? s_name
         ht_level3=@ht_gstatement_name_2_ht_level3[s_name]
         i_level3_max_length=ht_level3[@@lc_i_level3_max_length]
         return true if i_level3_max_length==(-1)
         # Here the i_level3_max_length==1
         ar_level3_elements=ht_level3[@@lc_ar_level3_elements]
         i_len=ar_level3_elements.length
         b_out=false
         b_out=true if i_len==0
         return b_out
      end # synchronize
   end # insertale?

   # It throws, if the x_gstatement is not
   # insertable. One should always test for
   # insertability prior to calling this method.
   def insert x_gstatement
      @mx.synchronize do
         @b_complete_cache_out_of_sync=true
         if !insertable? x_gstatement
            kibuvits_throw "x_gstatement, which is of class \""+
            x_gstatement.class.to_s+"\", is not insertable. "
         end # if
         s_name=x_gstatement.name
         ht_level3=@ht_gstatement_name_2_ht_level3[s_name]
         ar_level3_elements=ht_level3[@@lc_ar_level3_elements]
         ar_level3_elements<<x_gstatement
      end # synchronize
   end # insert

   private

   def to_s_ht_level3 ht_level3
      s_out=@@lc_emptystring
      ar_level3_elements=ht_level3[@@lc_ar_level3_elements]
      i_len=ar_level3_elements.length
      gstatement=nil
      i_len.times do |i|
         gstatement=ar_level3_elements[i]
         s_out=s_out+gstatement.to_s
      end # loop
      return s_out
   end # to_s_ht_level3

   def to_s_ht_level2 ht_level2
      s_out=@@lc_emptystring
      ht_level2_index=ht_level2[@@lc_ht_level2_index]
      ht_level2_index.each_value do |ht_level3|
         s_out=s_out+to_s_ht_level3(ht_level3)
      end # loop
      return s_out
   end # to_s_ht_level2

   protected

   # That's for optional overloading.
   def to_s_elemspecific_prefix
      return @@lc_emptystring
   end # to_s_elemspecific_prefix

   # That's for optional overloading.
   def to_s_elemspecific_suffix
      return @@lc_emptystring
   end # to_s_elemspecific_suffix

   public
   def to_s
      i_len=@ar_level1.length
      ht_level2=nil
      s_out=@s_prefix
      s_out=s_out+to_s_elemspecific_prefix
      i_len.times do |i_level1_index|
         ht_level2=@ar_level1[i_level1_index]
         s_out=s_out+to_s_ht_level2(ht_level2)
      end # loop
      s_out=s_out+to_s_elemspecific_suffix
      s_out=s_out+@s_suffix
      return s_out
   end # to_s

   private
   public

   def Kibuvits_gstatement.test_1
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A"
      if kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 1"
      end # if
      msgcs.clear
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(42,msgcs)}
         kibuvits_throw "test 2"
      end # if
      msgcs.clear
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,42)}
         kibuvits_throw "test 3"
      end # if
      msgcs.clear
      s_spec="UUU:==A*|B"  # OK, subject to bracket autocompletion.
      if kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 4"
      end # if
      msgcs.clear
      s_spec="UUU:==(A*|B) | C" # | outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 5"
      end # if
      msgcs.clear
      s_spec="UUU:==((A*|B) C)" # the nesting of braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 6"
      end # if
      msgcs.clear
      s_spec="UUU:==(A)? " # ? outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 7"
      end # if
      msgcs.clear
      s_spec="UUU:==(A)* " # * outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 8"
      end # if
      msgcs.clear
      s_spec="UUU:==(A)+ " # + outside braces
      if !kibuvits_block_throws{gst=Kibuvits_gstatement.new(s_spec,msgcs)}
         kibuvits_throw "test 9"
      end # if
   end # Kibuvits_gstatement.test_1

   def Kibuvits_gstatement.test_get_array_of_level1_components
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A"
      gst=Kibuvits_gstatement.new(s_spec,msgcs)
      s_right="A (B+ |C)E F(G)"
      ar=gst.send(:get_array_of_level1_components,s_right)
      kibuvits_throw "test 1" if ar.length!=5
      kibuvits_throw "test 2" if ar[0]!="A"
      kibuvits_throw "test 3" if ar[1]!="B+|C"
      kibuvits_throw "test 4" if ar[2]!="E"
      kibuvits_throw "test 5" if ar[3]!="F"
      kibuvits_throw "test 6" if ar[4]!="G"
   end # Kibuvits_gstatement.test_get_array_of_level1_components

   def Kibuvits_gstatement.test_complete_and_insertable
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A:==BB CC?"
      gst=Kibuvits_gstatement.new(s_spec,msgcs)
      kibuvits_throw "test 1" if gst.complete?
      gst_bb=Kibuvits_gstatement.new("BB",msgcs)
      gst_cc=Kibuvits_gstatement.new("CC",msgcs)
      gst_dd=Kibuvits_gstatement.new("DD",msgcs)
      kibuvits_throw "test 2" if !gst.insertable? gst_bb
      kibuvits_throw "test 3" if !gst.insertable? gst_cc
      kibuvits_throw "test 4" if gst.insertable? gst_dd
      gst.insert gst_bb
      kibuvits_throw "test 5" if gst.insertable? gst_bb
      kibuvits_throw "test 6" if !gst.insertable? gst_cc
      kibuvits_throw "test 7" if !gst.complete?
      gst.insert gst_cc
      kibuvits_throw "test 8" if gst.insertable? gst_cc
      kibuvits_throw "test 9" if !gst.complete?
   end # Kibuvits_gstatement.test_complete_and_insertable

   def Kibuvits_gstatement.test_to_s
      # TODO: There's some sort of a bug at the spec part, where
      # the "A:==(BB? CC DD)" gets translated to "(BB?CC)(DD)"
      # So level2 spec's are already faulty at initialization.
      msgcs=Kibuvits_msgc_stack.new
      s_spec="A:==(BB)(CC?)(DD)"
      gst_a=Kibuvits_gstatement.new(s_spec,msgcs)

      gst_bb=Kibuvits_gstatement.new("BB",msgcs)
      gst_bb.s_suffix="(BB_suffix)"
      gst_cc=Kibuvits_gstatement.new("CC",msgcs)
      gst_cc.s_prefix="(CC_prefix)"
      gst_dd=Kibuvits_gstatement.new("DD",msgcs)
      gst_dd.s_prefix="(DD_prefix)"
      s_spec="EE:==A BB"
      gst_ee=Kibuvits_gstatement.new(s_spec,msgcs)

      gst_a.insert(gst_bb)
      gst_a.insert(gst_dd)
      gst_a.insert(gst_cc)
      s_expected="(BB_suffix)(CC_prefix)(DD_prefix)"
      s=gst_a.to_s
      kibuvits_throw "test 1" if s!=s_expected
   end # Kibuvits_gstatement.test_to_s

   public
   def Kibuvits_gstatement.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_gstatement.test_1"
      kibuvits_testeval bn, "Kibuvits_gstatement.test_get_array_of_level1_components"
      kibuvits_testeval bn, "Kibuvits_gstatement.test_complete_and_insertable"
      kibuvits_testeval bn, "Kibuvits_gstatement.test_to_s"
      return ar_msgs
   end # Kibuvits_gstatement.selftest
end # class Kibuvits_gstatement
#=========================================================================
#Kibuvits_gstatement.test_1
#msgcs=Kibuvits_msgc_stack.new
#s_spec="UU:==A (B+ |C)E F(G)"
#gst=Kibuvits_gstatement.new(s_spec,msgcs)
