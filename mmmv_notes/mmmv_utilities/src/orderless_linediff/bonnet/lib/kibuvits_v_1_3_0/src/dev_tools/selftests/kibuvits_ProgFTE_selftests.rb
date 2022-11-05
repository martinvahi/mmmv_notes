#!/opt/ruby/bin/ruby -Ku
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
   require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_ProgFTE.rb"
end # if
#==========================================================================

class Kibuvits_ProgFTE_selftests
   def initialize
   end #initialize

   private
   #-----------------------------------------------------------------------

   def Kibuvits_ProgFTE_selftests.test_1
      #
      # The ProgFTE  selftests are so obsolete, that one just
      # needs to rewrite them. Besides, the code is also pretty arhaic,
      # faulty by design, flawless in terms of following the design,
      # somewhat ugly by coding style.
      # So, really, the current state of affairs seems pretty
      # reasonable for the time being.
      #
      # The following is better than nothing:
      i_specification_version=0
      ht=Hash.new
      ht['Welcome']='to hell'
      ht['with XML']='we all go'
      s_progfte=Kibuvits_ProgFTE.from_ht(ht,i_specification_version)
      ht.clear
      ht2=Kibuvits_ProgFTE.to_ht(s_progfte)
      kibuvits_throw "test 1" if ht2['Welcome']!="to hell"
      kibuvits_throw "test 2" if ht2['with XML']!="we all go"
   end # Kibuvits_ProgFTE_selftests.test_1

   #-----------------------------------------------------------------------
   public
   def Kibuvits_ProgFTE_selftests.test_2
      # http://martin.softf1.com/g/n//a2/doc/progfte/index.html
      i_specification_version=1
      ht=Hash.new
      #---------------
      ht.clear
      s_progfte=Kibuvits_ProgFTE.from_ht(ht,i_specification_version)
      s_expected="v1|0|1|0||0||"
      kibuvits_throw "test 1" if s_progfte!=s_expected
      ht_x=Kibuvits_ProgFTE.to_ht(s_progfte)
      # The very fist key-value pair is for the metadata and should
      # not be added to the deserialization result.
      kibuvits_throw "test 1a" if ht_x.size!=0
      #---------------
      ht.clear
      ht['a']='aa'
      ht['b']='bb'
      ht['c']='cc'
      ht['d']='dd'
      ht['e']='ee'
      ht['f']='ff'
      ht['g']='gg'
      ht['h']='hh'
      ht['i']='ii'
      ht['j']='jj'
      s_progfte=Kibuvits_ProgFTE.from_ht(ht,i_specification_version)
      #---------------
      ht.clear
      ht['Welcome']='to hell'
      ht['with XML']='we all go'
      s_progfte=Kibuvits_ProgFTE.from_ht(ht,i_specification_version)
      ht.clear
      ht2=Kibuvits_ProgFTE.to_ht(s_progfte)
      kibuvits_throw "test 2" if ht2['Welcome']!="to hell"
      kibuvits_throw "test 3" if ht2['with XML']!="we all go"
   end # Kibuvits_ProgFTE_selftests.test_2

   #-----------------------------------------------------------------------

   public
   def Kibuvits_ProgFTE_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_ProgFTE_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_ProgFTE_selftests.test_2"
      return ar_msgs
   end # Kibuvits_ProgFTE_selftests.selftest

end # class Kibuvits_ProgFTE_selftests

#==========================================================================
#puts Kibuvits_ProgFTE_selftests.selftest.to_s

Kibuvits_ProgFTE_selftests.test_2
