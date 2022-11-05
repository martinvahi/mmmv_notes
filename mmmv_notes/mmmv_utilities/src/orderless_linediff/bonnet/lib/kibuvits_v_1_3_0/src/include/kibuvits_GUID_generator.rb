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

#-----------------------------------------------------------------------

The February 28'th, 2010 version of the
http://en.wikipedia.org/wiki/Globally_Unique_Identifier
has been taken as a specification to this code, but the spec
has not been strictly followed.

=end
#==========================================================================

# This file is actually included by the kibuvits_boot.rb

require "monitor"
require "singleton"
#==========================================================================

class Kibuvits_GUID_generator

   def initialize
   end #initialize

   private
   def convert_2_GUID_format a_36_character_hexa_string
      # A modified version of a passage from the RFC 4122:
      #---passage--start--
      #
      #  The variant field determines the layout of the UUID.  That is,
      #  the interpretation of all other bits in the UUID depends
      #  on the setting of the bits in the variant field.  As such,
      #  it could more accurately be called a type field; we retain
      #  the original term for compatibility. The variant field
      #  consists of a variable number of the most significant bits
      #  of octet 8 of the UUID.
      #
      #  The following table lists the contents of the variant field, where
      #  the letter "x" indicates a "don't-care" value.
      #
      #  Msb0  Msb1  Msb2  Description
      #
      #   0     x     x    Reserved, NCS backward compatibility.
      #   1     0     x    The variant specified in this document.
      #   1     1     0    Reserved, Microsoft Corporation backward
      #                    compatibility
      #   1     1     1    Reserved for future definition.
      #
      #---passage--end----
      #
      #---RFC-4122-citation--start--
      #
      # To minimize confusion about bit assignments within octets, the UUID
      # record definition is defined only in terms of fields that are
      # integral numbers of octets.  The fields are presented with the most
      # significant one first.
      #
      #---RFC-4122-citation--end---
      #
      # _0_1_2_3 _4_5 _6_7 _8_9 __11__13__15   #== byte indices
      # oooooooo-oooo-Xooo-Yooo-oooooooooooo
      # 012345678901234567890123456789012345
      # _________9_________9_________9______
      #
      # X indicates the GUID version and is the most significant
      # nibble of byte 6, provided that the counting of bytes
      # starts from 0, not 1.
      #
      # The value of Y determines the variant and the Y designates the
      # most significant nibble of byte 8,
      # provided that the counting starts from 0.
      # For version 4 the Y must be in set {8,9,a,b}.
      #
      s=a_36_character_hexa_string
      s[8..8]='-'
      s[13..13]='-'
      s[14..14]='4' # The GUID spec version
      s[18..18]='-'
      s[19..19]=(rand(4)+8).to_s(16) # the variant with bits 10xx
      s[23..23]='-'
      return s
   end #convert_2_GUID_format

   public

   #Returns a string
   def generate_GUID
      t=Time.now
      #        3 characters    1 character
      s_guid=t.year.to_s(16)+t.month.to_s(16) # 3 digit year, 1 digit month
      s_guid=s_guid+"0" if t.day<16
      s_guid=s_guid+t.day.to_s(16)
      s_guid=s_guid+"0" if t.hour<16 # 60.to_s(16).length<=2
      s_guid=s_guid+t.hour.to_s(16)
      s_guid=s_guid+"0" if t.min<16
      s_guid=s_guid+t.min.to_s(16)
      s_guid=s_guid+"0" if t.sec<16
      s_guid=s_guid+t.sec.to_s(16)
      s_guid=s_guid+((t.usec*1.0)/1000).round.to_s(16)
      while s_guid.length<36 do
         s_guid<<rand(100000000).to_s(16)
      end # loop
      # The reason, why it is beneficial to place the
      # timestamp part of the GUID to the end of the GUID is
      # that the randomly generated digits have a
      # bigger variance than the timestamp digits have.
      # If the GUIDs are used as ID-s or file names,
      # then the bigger the variance of first digits of the string,
      # the less amount of digits search algorithms have to study to
      # exclude majority of irrelevant records from further inspection.
      s_1=s_guid[0..35].reverse
      s_guid=convert_2_GUID_format(s_1)
      return s_guid
   end #generate_GUID

   def Kibuvits_GUID_generator.generate_GUID
      s_guid=Kibuvits_GUID_generator.instance.generate_GUID
      return s_guid
   end #Kibuvits_GUID_generator.generate_GUID

   include Singleton
   def Kibuvits_GUID_generator.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(), "Kibuvits_GUID_generator.generate_GUID"
      return ar_msgs
   end # Kibuvits_GUID_generator.selftest

end # class Kibuvits_GUID_generator
#==========================================================================
class Kibuvits_wholenumberID_generator
   @@i=0
   def initialize
   end # initialize

   # This method is thread safe.
   def generate
      i_out=0
      mx=Mutex.new
      mx.synchronize do
         i_out=@@i
         @@i=@@i+1
      end # synchronize
      return i_out
   end # generate

   def Kibuvits_wholenumberID_generator.generate
      i_out=Kibuvits_wholenumberID_generator.instance.generate
      return i_out
   end # Kibuvits_wholenumberID_generator.generate

   private
   def Kibuvits_wholenumberID_generator.test1
      x=Kibuvits_wholenumberID_generator.generate
      x=Kibuvits_wholenumberID_generator.generate
      kibuvits_throw "test 1, x=="+x.to_s if x==0
      y=Kibuvits_wholenumberID_generator.generate
      kibuvits_throw "test 2, x==y=="+x.to_s if x==y
   end # Kibuvits_wholenumberID_generator.test1
   public
   include Singleton
   def Kibuvits_wholenumberID_generator.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(), "Kibuvits_wholenumberID_generator.test1"
      return ar_msgs
   end # Kibuvits_wholenumberID_generator.selftest
end # class Kibuvits_wholenumberID_generator
#==========================================================================
# Sample code:
#puts Kibuvits_GUID_generator.generate_GUID
#puts Kibuvits_wholenumberID_generator.generate.to_s

#==========================================================================

