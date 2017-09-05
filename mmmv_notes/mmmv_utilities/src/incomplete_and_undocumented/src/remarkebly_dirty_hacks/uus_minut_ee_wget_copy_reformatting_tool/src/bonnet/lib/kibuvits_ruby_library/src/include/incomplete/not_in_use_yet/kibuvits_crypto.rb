#!/usr/bin/env ruby
#==========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

# The "included" const. has to be befor the "require" clauses
# to be available, when the code within the require clauses probes for it.
KIBUVITS_SZR_INCLUDED=true

require "monitor"
if defined? KIBUVITS_HOME
   if !(defined? KIBUVITS_MSGC_INCLUDED)
      require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   end # if
   #require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
else
   require  "kibuvits_boot.rb"
   if !(defined? KIBUVITS_MSGC_INCLUDED)
      require  "kibuvits_msgc.rb"
   end # if
   #require  "kibuvits_ProgFTE.rb"
   require  "kibuvits_str.rb"
end # if

require "singleton"
#==========================================================================


class Kibuvits_crypto
   @@s_version="ProgFTE:ht_p:1" # a free-style string without any structure

   def initialize
   end #initialize

   private

   #--------------------------------------------------------------------------

   # Requirements:
   # 2<=m,  0<=a<m, 0<=b<m
   #
   # If f(x)=txor(x,b,m) then the reverce function of f(x) is f(x) itself.
   #
   # The theory and proofs are currently available only in estonian
   # and reside in KIBUVITS_HOME/../doc/theory/TXOR_theory_only_in_Estonian.txt
   def txor(i_a,i_b,i_m)
      # TXOR(a,b,m)=((b-a+m) mod m) where a,b,m are integers.
      i_out=(i_b-i_a+i_m)%m
      return i_out
   end # txor

   #--------------------------------------------------------------------------

   def txor_vernam(s_a_or_ar_a_codepoints, s_b_or_ar_b_codepoints, i_m)
      # POOLELI
      # "abba".codepoints annab Integer tyypi isenditega massiivi.
   end # txor_vernam

   #--------------------------------------------------------------------------


   private
   def Kibuvits_crypto.test_txor_vernam
      #x=Kibuvits_crypto.test_deserialize("hi")
      #kibuvits_throw "test 1" if x.length!=1
   end # Kibuvits_crypto.test_txor_vernam

   public
   include Singleton
   def Kibuvits_crypto.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_crypto.test_txor_vernam"
      #kibuvits_testeval bn, "Kibuvits_crypto.test_deserialize"
      return ar_msgs
   end # Kibuvits_crypto.selftest
end # class Kibuvits_crypto

#==========================================================================
#kibuvits_writeln Kibuvits_crypto.selftest.to_s

