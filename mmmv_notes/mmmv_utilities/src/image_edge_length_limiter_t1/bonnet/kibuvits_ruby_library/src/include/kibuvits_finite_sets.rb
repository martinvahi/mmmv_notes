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
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"

#==========================================================================

# The class Kibuvits_finite_sets is a namespace for functions that
# are meant for facilitating the use of indexes. In the
# context of the Kibuvits_finite_sets an index is an Array index,
# hash-table key, etc.
class Kibuvits_finite_sets
   def initialize
   end #initialize

   public

   # Returns A\B
   def difference(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_A
         kibuvits_typecheck bn, Hash, ht_B
         kibuvits_typecheck bn, Hash, ht_out
      end # if
      ht_A.each_key do |x|
         ht_out[x]=ht_A[x] if !ht_B.has_key? x
      end # loop
      return ht_out
   end # difference

   def Kibuvits_finite_sets.difference(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_finite_sets.instance.difference(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_finite_sets.difference(ht_A,ht_B)

   private
   def Kibuvits_finite_sets.test_difference
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_finite_sets.difference(ht_A,ht_B,ht_out=Hash.new)
      kibuvits_throw "test 1" if ht_out.keys.length!=1
      kibuvits_throw "test 2" if !ht_out.has_key? "aa"
      kibuvits_throw "test 3" if ht_out["aa"]!="aXX"
   end # Kibuvits_finite_sets.test_difference

   public

   def union(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_A
         kibuvits_typecheck bn, Hash, ht_B
         kibuvits_typecheck bn, Hash, ht_out
      end # if
      ht_A.each_key{|x| ht_out[x]=ht_A[x]}
      ht_B.each_key{|x| ht_out[x]=ht_B[x]}
      return ht_out
   end # union

   def Kibuvits_finite_sets.union(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_finite_sets.instance.union(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_finite_sets.union(ht_A,ht_B)

   private
   def Kibuvits_finite_sets.test_union
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_finite_sets.union(ht_A,ht_B)
      kibuvits_throw "test 1" if ht_out.keys.length!=3
      kibuvits_throw "test 2" if ht_out["aa"]!="aXX"
      kibuvits_throw "test 3" if ht_out["bb"]!="bXX"
      kibuvits_throw "test 4" if ht_out["cc"]!="cXX"
   end # Kibuvits_finite_sets.test_union

   public

   def symmetric_difference(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_A
         kibuvits_typecheck bn, Hash, ht_B
         kibuvits_typecheck bn, Hash, ht_out
      end # if
      ht_out=difference(ht_A,ht_B,ht_out)
      ht_out=difference(ht_B,ht_A,ht_out)
      return ht_out
   end # symmetric_difference

   def Kibuvits_finite_sets.symmetric_difference(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_finite_sets.instance.symmetric_difference(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_finite_sets.symmetric_difference(ht_A,ht_B)

   private
   def Kibuvits_finite_sets.test_symmetric_difference
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_finite_sets.symmetric_difference(ht_A,ht_B,ht_out=Hash.new)
      kibuvits_throw "test 1" if ht_out.keys.length!=2
      kibuvits_throw "test 2" if !ht_out.has_key? "aa"
      kibuvits_throw "test 3" if !ht_out.has_key? "cc"
      kibuvits_throw "test 4" if ht_out["aa"]!="aXX"
      kibuvits_throw "test 5" if ht_out["cc"]!="cXX"
   end # Kibuvits_finite_sets.test_symmetric_difference


   public

   def intersection(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_A
         kibuvits_typecheck bn, Hash, ht_B
         kibuvits_typecheck bn, Hash, ht_out
      end # if
      ht_A.each_key do |x|
         ht_out[x]=ht_A[x] if ht_B.has_key? x
      end #loop
      return ht_out
   end # intersection

   def Kibuvits_finite_sets.intersection(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_finite_sets.instance.intersection(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_finite_sets.intersection(ht_A,ht_B)

   private
   def Kibuvits_finite_sets.test_intersection
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_finite_sets.intersection(ht_A,ht_B,ht_out=Hash.new)
      kibuvits_throw "test 1" if ht_out.keys.length!=1
      kibuvits_throw "test 2" if !ht_out.has_key? "bb"
      kibuvits_throw "test 3" if ht_out["bb"]!="bXX"
   end # Kibuvits_finite_sets.test_intersection

   public
   include Singleton
   def Kibuvits_finite_sets.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_finite_sets.test_difference"
      kibuvits_testeval bn, "Kibuvits_finite_sets.test_union"
      kibuvits_testeval bn, "Kibuvits_finite_sets.test_symmetric_difference"
      kibuvits_testeval bn, "Kibuvits_finite_sets.test_intersection"
      return ar_msgs
   end # Kibuvits_finite_sets.selftest
end # class Kibuvits_finite_sets
#=========================================================================
