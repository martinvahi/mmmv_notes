#!/usr/bin/env ruby2.3
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain, except the 
# Kibuvits Ruby Library (KRL) parts, which are under the BSD license.
#
# This file consists of 3 parts:
#     1) bolierplate in the form of an old version of the Kibuvits Ruby Library
#     2) data in the form of a Ruby code and;
#     3) the code that uses the data and outputs the result to console.
#
# The main function resides at the end of this file and
# it does NOT take any command line parameters, because all of the
# data is in this file. Functionality wise there are 2 conversion options:
#
#     "doc|jpeg|foo" --> "[dD][oO][cC]|[jJ][pP][eE][gG]|[fF][oO][oO]
#     # and its reverse,
#     "[dD][oO][cC]|[jJ][pP][eE][gG]|[fF][oO][oO]" --> "doc|jpeg|foo"
#
# Due to the "Fixnum --> Integer" change in Ruby 2.4.0 this file
# requires something older than Ruby 2.4.0. It has been tested only with
#
#     "ruby 2.3.3p222 (2016-11-21) [x86_64-linux-gnu]"
#
# You may want to search for the string "data_declaration_start" and
# skip reading the code that resides upwards of that string.
#
# As of 2020_10 the
#
#     https://www.regextester.com/
#
# is a useful tool for testing out the JavaScript regexes.
#
#==========================================================================
# A lot of code has been just copy-pasted from the
# Kibuvits Ruby Library (hereafter: KRL) and slightly modified.
# Think of it as boilerplate. You may want to look for a string
# "KRL_based_boilerplate_end" to navigate to the end of that boilerplate.
#--------------------KRL_based_boilerplate_start---------------------------

#=====================kibuvits_krl171_GUID_generator_rb_start=====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_GUID_generator_rb_end".
#==========================================================================
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

http://longterm.softf1.com/specifications/third_party/ietf/www_ietf_org_rfc4122_GUID_spec.txt

=end
#==========================================================================

# This file is actually included by the kibuvits_krl171_boot.rb

require "monitor"
require "singleton"
#==========================================================================

class Kibuvits_krl171_GUID_generator

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

   def Kibuvits_krl171_GUID_generator.generate_GUID
      s_guid=Kibuvits_krl171_GUID_generator.instance.generate_GUID
      return s_guid
   end #Kibuvits_krl171_GUID_generator.generate_GUID

   include Singleton
   def Kibuvits_krl171_GUID_generator.selftest
      ar_msgs=Array.new
      kibuvits_krl171_testeval binding(), "Kibuvits_krl171_GUID_generator.generate_GUID"
      return ar_msgs
   end # Kibuvits_krl171_GUID_generator.selftest

end # class Kibuvits_krl171_GUID_generator
#==========================================================================
class Kibuvits_krl171_wholenumberID_generator
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

   def Kibuvits_krl171_wholenumberID_generator.generate
      i_out=Kibuvits_krl171_wholenumberID_generator.instance.generate
      return i_out
   end # Kibuvits_krl171_wholenumberID_generator.generate

   private
   def Kibuvits_krl171_wholenumberID_generator.test1
      x=Kibuvits_krl171_wholenumberID_generator.generate
      x=Kibuvits_krl171_wholenumberID_generator.generate
      kibuvits_krl171_throw "test 1, x=="+x.to_s if x==0
      y=Kibuvits_krl171_wholenumberID_generator.generate
      kibuvits_krl171_throw "test 2, x==y=="+x.to_s if x==y
   end # Kibuvits_krl171_wholenumberID_generator.test1
   public
   include Singleton
   def Kibuvits_krl171_wholenumberID_generator.selftest
      ar_msgs=Array.new
      kibuvits_krl171_testeval binding(), "Kibuvits_krl171_wholenumberID_generator.test1"
      return ar_msgs
   end # Kibuvits_krl171_wholenumberID_generator.selftest
end # class Kibuvits_krl171_wholenumberID_generator
#==========================================================================
# Sample code:
#kibuvits_krl171_writeln Kibuvits_krl171_GUID_generator.generate_GUID
#kibuvits_krl171_writeln Kibuvits_krl171_wholenumberID_generator.generate.to_s

#=====================kibuvits_krl171_GUID_generator_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_GUID_generator_rb_start".
#==========================================================================

#=====================kibuvits_krl171_boot_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_boot_rb_end".
#==========================================================================
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
# Common initialization stuff:

require 'pathname'

if !defined? KIBUVITS_krl171_HOME
   ob_pth=Pathname.new(__FILE__).realpath.parent.parent.parent
   KIBUVITS_krl171_HOME=ob_pth.to_s.freeze
   ob_pth=nil;
end # if

KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE=true if !defined? KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE

# The difference between the APPLICATION_STARTERRUBYFILE_PWD and the
# working directory is that if a script that uses the Kibuvits Ruby Library
# has a path of /tmp/explanation/x.rb and it s called by:
# cd /opt; ruby /tmp/explanation/x.rb ;
# then the Dir.pwd=="/opt" and the
# APPLICATION_STARTERRUBYFILE_PWD=="/tmp/explanation"
#
APPLICATION_STARTERRUBYFILE_PWD=Pathname.new($0).realpath.parent.to_s if not defined? APPLICATION_STARTERRUBYFILE_PWD

require "monitor"
require "singleton"
require "time"
#require KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_GUID_generator.rb"
# The point behind the KIBUVITS_krl171_s_PROCESS_ID is that
# different subprocesses might want to communicate
# with each-other, but there might be different
# instances of the applications that create the
# sub-processes and one may want to distinguish
# between the application instances. One of the
# benefits of storing the extended process id to an
# environment variables in stead of other mechanisms
# is that environment variables are usable regardless of
# whether the  subprocesses are written in Ruby or
# some other programming language.
if !defined? KIBUVITS_krl171_s_PROCESS_ID
   x=ENV['KIBUVITS_krl171_S_PROCESS_ID']
   if (x!=nil and x!="")
      KIBUVITS_krl171_s_PROCESS_ID=x
   else
      # The Operating system process ID-s tend to cycle.
      # If the code that uses the KIBUVITS_krl171_s_PROCESS_ID
      # does not erase temporary files, which might actually be quite
      # challenging, given that it's not that easy to elegantly
      # automatically determine, which of the sub-processes is the last one,
      # then there might be collisions with the use of the temporary files,
      # global hash entries, etc., unless the process ID-s are
      # something like the Globally Unique Identifiers.
      KIBUVITS_krl171_s_PROCESS_ID="pid_"+$$.to_s+"_"+
      Kibuvits_krl171_GUID_generator.generate_GUID
      ENV['KIBUVITS_krl171_S_PROCESS_ID']=KIBUVITS_krl171_s_PROCESS_ID
   end # if
end # if
#==========================================================================
# Manually updatable:

# The Ruby gem infrastructure requires a version that consists
# of only numbers and dots. For library forking related
# version checks there is another constant: KIBUVITS_krl171_s_VERSION.
KIBUVITS_krl171_s_NUMERICAL_VERSION="1.7.1" if !defined? KIBUVITS_krl171_s_NUMERICAL_VERSION

# The reason, why the version does not consist of only
# numbers and points is that every application is
# expected to fork the library. The forking is compulsory,
# or at least practical, because the API of the
# library is allowed to change between different versions.
#
# Besides, it's a matter of pop-culture to give names to versions.
# Debian Linux developers do it all the time and even the MacOS
# and Windows have non-numerical versions, for example
# "Windows 95","Windows NT","Windows XP","Windows Vista","Windows 7",
# etc.
if !defined? KIBUVITS_krl171_s_VERSION
   KIBUVITS_krl171_s_VERSION="kibuvits_krl171_"+KIBUVITS_krl171_s_NUMERICAL_VERSION.to_s
end # if

# For security reasons it doesn't make sense to use the
# all-readable system default temporary folder for temporary
# files. By default the KRL uses the system temporary folder,
# but if the constant KIBUVITS_krl171_TEMPORARY_FOLDER is set, the
# value given by the KIBUVITS_krl171_TMP_FOLDER_PATH is used instead.
# By the Kibuvits Ruby Library "spec" the applications that
# use the KRL are left an opportunity to overwrite it or
# self-declare it.
# KIBUVITS_krl171_TMP_FOLDER_PATH=ENV['HOME'].to_s+"/tmp"

KIBUVITS_krl171_b_DEBUG=true if !defined? KIBUVITS_krl171_b_DEBUG
#KIBUVITS_krl171_b_DEBUG=false if !defined? KIBUVITS_krl171_b_DEBUG

#--------------------------------------------------------------------------
$kibuvits_krl171_lc_emptystring="".freeze
$kibuvits_krl171_lc_space=" ".freeze
$kibuvits_krl171_lc_8_spaces="        ".freeze
$kibuvits_krl171_lc_linebreak="\n".freeze
$kibuvits_krl171_lc_doublelinebreak="\n\n".freeze
$kibuvits_krl171_lc_rbrace_linebreak=");\n".freeze
$kibuvits_krl171_lc_dollarsign="$".freeze
$kibuvits_krl171_lc_powersign="^".freeze
$kibuvits_krl171_lc_dot=".".freeze
$kibuvits_krl171_lc_comma=",".freeze
$kibuvits_krl171_lc_colon=":".freeze
$kibuvits_krl171_lc_semicolon=";".freeze
$kibuvits_krl171_lc_spacesemicolon=" ;".freeze
$kibuvits_krl171_lc_at="@".freeze

$kibuvits_krl171_lc_lbrace="(".freeze
$kibuvits_krl171_lc_rbrace=")".freeze
$kibuvits_krl171_lc_lsqbrace="[".freeze
$kibuvits_krl171_lc_rsqbrace="]".freeze
$kibuvits_krl171_lc_lschevron="<".freeze
$kibuvits_krl171_lc_rschevron=">".freeze

$kibuvits_krl171_lc_questionmark="?".freeze
$kibuvits_krl171_lc_star="*".freeze
$kibuvits_krl171_lc_plus="+".freeze
$kibuvits_krl171_lc_minus="-".freeze
$kibuvits_krl171_lc_minusminus="--".freeze
$kibuvits_krl171_lc_pillar="|".freeze
$kibuvits_krl171_lc_slash="/".freeze
$kibuvits_krl171_lc_dotslash="./".freeze
$kibuvits_krl171_lc_dotstar=".*".freeze
$kibuvits_krl171_lc_slashslash="//".freeze
$kibuvits_krl171_lc_slashstar="/*".freeze
$kibuvits_krl171_lc_backslash="\\".freeze
$kibuvits_krl171_lc_4backslashes="\\\\\\\\".freeze
$kibuvits_krl171_lc_underscore="_".freeze
$kibuvits_krl171_lc_doublequote="\"".freeze
$kibuvits_krl171_lc_singlequote="'".freeze
$kibuvits_krl171_lc_equalssign="=".freeze

$kibuvits_krl171_lc_ar="ar".freeze
$kibuvits_krl171_lc_s_id="s_id".freeze
$kibuvits_krl171_lc_i_m="i_m".freeze

$kibuvits_krl171_lc_escapedspace="\\ ".freeze

$kibuvits_krl171_lc_kibuvits_krl171_ostype_unixlike="kibuvits_krl171_ostype_unixlike".freeze
$kibuvits_krl171_lc_kibuvits_krl171_ostype_java="kibuvits_krl171_ostype_java".freeze # JRuby
$kibuvits_krl171_lc_kibuvits_krl171_ostype_windows="kibuvits_krl171_ostype_windows".freeze

$kibuvits_krl171_lc_s_version="s_version".freeze
$kibuvits_krl171_lc_s_type="s_type".freeze
$kibuvits_krl171_lc_s_serialized="s_serialized".freeze
$kibuvits_krl171_lc_s_ht_szr_progfte="s_ht_szr_progfte".freeze
$kibuvits_krl171_lc_szrtype_ht_p="szrtype_ht_p".freeze
$kibuvits_krl171_lc_szrtype_instance="szrtype_instance".freeze
$kibuvits_krl171_lc_si_number_of_elements="si_number_of_elements".freeze
$s_lc_i_kibuvits_krl171_ar_ix_1="i_kibuvits_krl171_ar_ix_1".freeze
$kibuvits_krl171_lc_b_failure="b_failure".freeze
$kibuvits_krl171_lc_undetermined="undetermined".freeze

$kibuvits_krl171_lc_boolean="boolean".freeze
$kibuvits_krl171_lc_sb_true="t".freeze
$kibuvits_krl171_lc_sb_false="f".freeze

#--------------------------
$kibuvits_krl171_lc_timestamp="timestamp".freeze
$kibuvits_krl171_lc_year="year".freeze
$kibuvits_krl171_lc_month="month".freeze
$kibuvits_krl171_lc_day="day".freeze
$kibuvits_krl171_lc_hour="hour".freeze
$kibuvits_krl171_lc_minute="minute".freeze
$kibuvits_krl171_lc_second="second".freeze
$kibuvits_krl171_lc_nanosecond="nanosecond".freeze

$kibuvits_krl171_lc_mm_i_n_of_seconds="--i_n_of_seconds".freeze
$kibuvits_krl171_lc_mm_i_n_of_minutes="--i_n_of_minutes".freeze
$kibuvits_krl171_lc_mm_i_n_of_hours="--i_n_of_hours".freeze
$kibuvits_krl171_lc_mm_i_n_of_days="--i_n_of_days".freeze
$kibuvits_krl171_lc_mm_i_interval_in_seconds="--i_interval_in_seconds".freeze
$kibuvits_krl171_lc_mm_s_bash_command="--s_bash_command".freeze
#--------------------------

$kibuvits_krl171_lc_longitude="longitude".freeze
$kibuvits_krl171_lc_latitude="latitude".freeze
$kibuvits_krl171_lc_name="name".freeze
$kibuvits_krl171_lc_any="any".freeze
$kibuvits_krl171_lc_outbound="outbound".freeze
$kibuvits_krl171_lc_inbound="inbound".freeze
$kibuvits_krl171_lc_default="default".freeze
$kibuvits_krl171_lc_ob_vx_first_entry="ob_vx_first_entry".freeze
$kibuvits_krl171_lc_i_vxix="i_vxix".freeze
$kibuvits_krl171_lc_i_width="i_width".freeze
$kibuvits_krl171_lc_i_height="i_height".freeze

$kibuvits_krl171_lc_b_is_imagefile="b_is_imagefile".freeze
$kibuvits_krl171_lc_s_fp="s_fp".freeze

$kibuvits_krl171_lc_ht_p="ht_p".freeze
$kibuvits_krl171_lc_ht_szr="ht_szr".freeze
$kibuvits_krl171_lc_msgcs="msgcs".freeze
$kibuvits_krl171_lc_Ruby_serialize_="Ruby_serialize_".freeze
$kibuvits_krl171_lc_Ruby_deserialize_="Ruby_deserialize_".freeze
$kibuvits_krl171_lc_Ruby_serialize_szrtype_instance="Ruby_serialize_szrtype_instance".freeze
$kibuvits_krl171_lc_Ruby_deserialize_szrtype_instance="Ruby_deserialize_szrtype_instance".freeze

$kibuvits_krl171_lc_PHP_serialize_="PHP_serialize_".freeze
$kibuvits_krl171_lc_PHP_deserialize_="PHP_deserialize_".freeze
$kibuvits_krl171_lc_JavaScript_serialize_="JavaScript_serialize_".freeze
$kibuvits_krl171_lc_JavaScript_deserialize_="JavaScript_deserialize_".freeze
#$kibuvits_krl171_lc_Perl_serialize_="Perl_serialize_".freeze
#$kibuvits_krl171_lc_Perl_deserialize_="Perl_deserialize_".freeze

$kibuvits_krl171_lc_uk="uk".freeze # The "uk" stands for United Kingdom.
$kibuvits_krl171_lc_et="et".freeze # The "et" stands for Estonian.

$kibuvits_krl171_lc_English="English".freeze
$kibuvits_krl171_lc_Estonian="Estonian".freeze

$kibuvits_krl171_lc_s_stdout="s_stdout".freeze
$kibuvits_krl171_lc_s_stderr="s_stderr".freeze

$kibuvits_krl171_lc_s_localhost="localhost".freeze
$kibuvits_krl171_lc_s_cleartext="s_cleartext".freeze
$kibuvits_krl171_lc_s_ciphertext="s_ciphertext".freeze
$kibuvits_krl171_lc_s_checksum_hash="s_checksum_hash".freeze
$kibuvits_krl171_lc_s_pseudorandom_charstream="s_pseudorandom_charstream".freeze
$kibuvits_krl171_lc_s_format_version="s_format_version".freeze

$kibuvits_krl171_lc_s_Array="Array".freeze
$kibuvits_krl171_lc_s_Hash="Hash".freeze
$kibuvits_krl171_lc_s_String="String".freeze
$kibuvits_krl171_lc_s_Symbol="Symbol".freeze
$kibuvits_krl171_lc_s_Method="Method".freeze
$kibuvits_krl171_lc_s_Binding="Binding".freeze
$kibuvits_krl171_lc_s_Integer="Integer".freeze
$kibuvits_krl171_lc_s_Float="Float".freeze
$kibuvits_krl171_lc_s_Rational="Rational".freeze
$kibuvits_krl171_lc_s_TrueClass="TrueClass".freeze
$kibuvits_krl171_lc_s_FalseClass="FalseClass".freeze

$kibuvits_krl171_lc_s_default_mode="s_default_mode".freeze
$kibuvits_krl171_lc_s_mode="s_mode".freeze
$kibuvits_krl171_lc_s_mode_inactive="s_mode_inactive".freeze
$kibuvits_krl171_lc_s_mode_active="s_mode_active".freeze
$kibuvits_krl171_lc_s_mode_inactive_due_to_undetermined_reason="s_mode_inactive_due_to_undetermined_reason".freeze
$kibuvits_krl171_lc_s_status="s_status".freeze
$kibuvits_krl171_lc_s_mode_throw="s_mode_throw".freeze
$kibuvits_krl171_lc_s_mode_exit="s_mode_exit".freeze
$kibuvits_krl171_lc_s_mode_return_msg="s_mode_return_msg".freeze

$kibuvits_krl171_lc_s_missing="missing".freeze
$kibuvits_krl171_lc_s_b_dependencies_are_met="b_dependencies_are_met".freeze

$kibuvits_krl171_lc_ar_opmem_0="ar_opmem_0".freeze
$kibuvits_krl171_lc_ar_opmem_1="ar_opmem_1".freeze
$kibuvits_krl171_lc_b_data_in_ar_opmem_0="b_data_in_ar_opmem_0".freeze
$kibuvits_krl171_lc_ar_opmem_raw="ar_opmem_raw".freeze
$kibuvits_krl171_lc_ix_ar_x_in_cursor="ar_x_in_cursor".freeze

$kibuvits_krl171_lc_slash_index_html="/index.html".freeze
$kibuvits_krl171_lc_slash_index_php="/index.php".freeze
#--------------------------------------------------------------------------
$kibuvits_krl171_lc_GUID_regex_core_t1="[^-\s]{8}[-][^-\s]{4}[-][^-\s]{4}[-][^-\s]{4}[-][^-\s]{12}".freeze
s_0="[']"
$kibuvits_krl171_lc_GUID_regex_single_quotes_t1=(s_0+$kibuvits_krl171_lc_GUID_regex_core_t1+s_0).freeze
s_0="[\"]"
$kibuvits_krl171_lc_GUID_regex_double_quotes_t1=(s_0+$kibuvits_krl171_lc_GUID_regex_core_t1+s_0).freeze
s_0=nil
#--------------------------------------------------------------------------
$kibuvits_krl171_lc_emptyarray=Array.new.freeze

# Comments reside at the comments section of the
# http://ruby-doc.org/core-2.0/Mutex.html
# The short answer: class Mutex instances are not re-entrant, but
# class Monitor instances are re-entrant.
$kibuvits_krl171_lc_mx_streamaccess=Monitor.new
#--------------------------------------------------------------------------
$kibuvits_krl171_s_language=$kibuvits_krl171_lc_uk # application level i18n setting.
x=ENV["KIBUVITS_krl171_LANGUAGE"]
$kibuvits_krl171_s_language=x if (x!=nil and x!="")
#--------------------------------------------------------------------------

if !defined? KIBUVITS_krl171_s_CMD_RUBY
   kibuvits_krl171_tmpvar_s_rbpath=`which ruby`
   kibuvits_krl171_tmpvar_s_rbpath.sub!(/[\n\r]$/,"")
   kibuvits_krl171_tmpvar_s_rbpath=Pathname.new(kibuvits_krl171_tmpvar_s_rbpath).realpath.parent.to_s
   KIBUVITS_krl171_s_CMD_RUBY="cd "<<kibuvits_krl171_tmpvar_s_rbpath<<" ; ruby -Ku "
end # if
#--------------------------------------------------------------------------
$kibuvits_krl171_var_b_running_selftests=false
$kibuvits_krl171_var_b_module_fileutils_loaded=false
#--------------------------------------------------------------------------

def kibuvits_krl171_write(x_in)
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      # The "" is just for reducing the probability of
      # mysterious memory sharing related quirk-effects.
      #--------------
      # The classical version
      print $kibuvits_krl171_lc_emptystring+x_in.to_s
      #--------------
      # A more explicit version
      #$stdout.write(sprintf("s", x_in))
   end # synchronize
end # kibuvits_krl171_write
def kibuvits_krl171_writeln(x_in)
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      # The "" is just for reducing the probability of
      # mysterious memory sharing related quirk-effects.
      puts $kibuvits_krl171_lc_emptystring+x_in.to_s
   end # synchronize
end # kibuvits_krl171_writeln

#--------------------------------------------------------------------------

def kibuvits_krl171_s_exception_2_stacktrace(e)
   if (e.class.kind_of? Exception)
      exc=Exception.new("e.class=="+e.class.to_s+
      ", but Exception or any of its descendants was expected.")
      raise(exc)
   end # if
   ar_stack_trace=e.backtrace.reverse
   s_lc_separ="--------------------"
   s_lc_linebreak="\n"
   s_stacktrace=""+s_lc_separ
   ar_stack_trace.each do |s_line|
      s_stacktrace=s_stacktrace+s_lc_linebreak+s_line
   end # loop
   s_stacktrace=s_stacktrace+s_lc_linebreak+s_lc_separ+s_lc_linebreak
   return s_stacktrace
end # kibuvits_krl171_s_exception_2_stacktrace

# The a_binding is an optional parameter of type Binding.
#
# If the a_binding!=nil, then the exception is thrown
# in the scope that is referenced by the a_binding.
#
# The kibuvits_krl171_throw(...) does not depend on any
# other parts of the Kibuvits Ruby Library.
def kibuvits_krl171_throw(s_or_ob_exception,a_binding=nil)
   # Due to the lack of dependence on other
   # functions the implementation here is quite
   # verbose and duplicating, but that's the
   # compromise where elegant core API is favored
   # over an elegant core API implementation.
   #
   # A reminder: the keywords catch and throw have
   # a nonstandard semantics in Ruby.
   #-------------------------------------------------
   x_in=s_or_ob_exception
   #-------------------------------------------------
   # Typecheck of the s_or_ob_exception
   b_input_verification_failed=false
   s_msg=nil
   # The classes String and Exception both have the to_s method.
   # The input verification should throw within the scope that
   # contains the call to the kibuvits_krl171_throw(...), regardless
   # of the value of the a_binding, because the flaw that caused
   # verification failure resides in the scope, where the
   # call to the kibuvits_krl171_throw(...) was made.
   if !(x_in.respond_to? "to_s")
      b_input_verification_failed=true
      s_msg=" (s_or_ob_exception.respond_to? \"to_s\")==false\n"
   else
      begin
         s_msg=x_in.to_s
      rescue Exception => e
         b_input_verification_failed=true
         s_msg=" s_or_ob_exception.to_s() could not be executed. \n"
      end # rescue
   end # if
   b_raise=false
   if b_input_verification_failed
      s_msg=s_msg+" s_or_ob_exception.class=="+x_in.class.to_s+"\n"
      b_raise=true
   end # if
   if !b_raise
      if x_in.class!=String
         if !(x_in.kind_of? Exception)
            s_msg=" s_or_ob_exception.class=="+x_in.class.to_s+
            ", but it is expected to be of class String or Exception or "+
            "derived from the class Exception.\n"
            b_raise=true
         end # if
      end # if
   end # if
   if !b_raise
      if a_binding.class!=NilClass
         if a_binding.class!=Binding
            s_msg=" a_binding.class=="+a_binding.class.to_s+
            ", but it is expected to be of class NilClass or Binding.\n"
            b_raise=true
         end # if
      end # if
   end # if
   if b_raise
      if KIBUVITS_krl171_b_DEBUG
         if !$kibuvits_krl171_var_b_running_selftests
            s_fp_mmmv_devel_tools_info=ENV["MMMV_DEVEL_TOOLS_HOME"]+
            "/src/api/mmmv_devel_tools_info.bash"
            if File.exists? s_fp_mmmv_devel_tools_info
               s_0=` $MMMV_DEVEL_TOOLS_HOME/src/api/mmmv_devel_tools_info.bash \
               get_config s_GUID_trace_errorstack_file_path `
               s_1=s_0.gsub(/[\n\r]/,$kibuvits_krl171_lc_emptystring)
               if File.exists? s_1
                  # A bit flawed, because sometimes the file has
                  # to be created, for example, after all caches
                  # have been erased, but this if-branch here is
                  # such a hack that one does not risk creating the file.
                  # The next is a crippled, checkless copy-paste from
                  # kibuvits_krl171_io.rb
                  s_fp=s_1
                  file=File.open(s_fp, "w")
                  file.write(s_msg)
                  file.close
               end # if
            end # if
         end # if
      end # if
      raise(Exception.new(s_msg))
   end # if
   #-------------------------------------------------
   exc=nil
   if x_in.class==String
      exc=Exception.new($kibuvits_krl171_lc_doublelinebreak+
      x_in+$kibuvits_krl171_lc_doublelinebreak)
   else # x_in.class is derived from or equal to the Exception.
      exc=x_in
   end # if
   #-------------------------------------
   # The following adds a stack trace to the exception message.
   # ar_stack_trace=exc.backtrace.reverse
   # s_lc_separ="--------------------"
   # s_lc_linebreak="\n"
   # s_msg=exc.to_s+s_lc_linebreak+kibuvits_krl171_s_exception_2_stacktrace(exc)
   # exc=Exception.new(s_msg)
   #-------------------------------------
   raise(exc) if a_binding==nil # stops a recursion.
   #-------------------------------------
   # The start of the "kibuvits_krl171_throw_in_scope".
   ar=[exc]
   s_script=$kibuvits_krl171_lc_kibuvits_krl171_set_var_in_scope_s1+
   ar.object_id.to_s+$kibuvits_krl171_lc_rbrace_linebreak+
   "kibuvits_krl171_throw_x_exc"+$kibuvits_krl171_lc_kibuvits_krl171_set_var_in_scope_s2+
   "kibuvits_krl171_throw(kibuvits_krl171_throw_x_exc)\n"
   eval(s_script,a_binding)
end # kibuvits_krl171_throw

#--------------------------------------------------------------------------
$kibuvits_krl171_lc_kibuvits_krl171_varname2varvalue_s1=($kibuvits_krl171_lc_emptystring+
"kibuvits_krl171_varname2varvalue_ar=ObjectSpace._id2ref(").freeze
$kibuvits_krl171_lc_kibuvits_krl171_varname2varvalue_s2=($kibuvits_krl171_lc_rbrace_linebreak+
"kibuvits_krl171_varname2varvalue_ar<<").freeze

# Returns the value that the variable :s_varname
# has within the scope that is being referenced by
# the a_binding. The ar_an_empty_array_for_reuse_only_for_speed
# is guaranteed to be empty after this function exits.
def kibuvits_krl171_varname2varvalue(a_binding, s_varname,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_krl171_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   s_script=$kibuvits_krl171_lc_kibuvits_krl171_varname2varvalue_s1+
   ar.object_id.to_s+$kibuvits_krl171_lc_kibuvits_krl171_varname2varvalue_s2+
   s_varname+$kibuvits_krl171_lc_linebreak
   eval(s_script,a_binding)
   kibuvits_krl171_throw("ar.size==0") if ar.size==0
   x=ar[0]
   # even the kibuvits_krl171_s_varvalue2varname depends on the emptiness of the ar
   ar.clear
   return x
end # kibuvits_krl171_varname2varvalue

#--------------------------------------------------------------------------

$kibuvits_krl171_lc_kibuvits_krl171_s_varvalue2varname_script1=($kibuvits_krl171_lc_emptystring+
"s_varname=nil\n"+
"x=nil\n"+
"ar_tmp_for_speed=kibuvits_krl171_s_varvalue2varname_tmp_ar\n"+ # an instance reuse speedhack
"local_variables.each do |s_varname_or_symbol|\n"+
"    s_varname=s_varname_or_symbol.to_s\n"+
"    x=kibuvits_krl171_varname2varvalue(binding(),s_varname,ar_tmp_for_speed)\n"+
"    if x.object_id==kibuvits_krl171_s_varvalue2varname_tmp_i_objectid \n"+
"        kibuvits_krl171_s_varvalue2varname_tmp_ar<<s_varname\n"+
"        break \n"+
"    end #if\n"+
"end #loop\n").freeze

$kibuvits_krl171_lc_kibuvits_krl171_s_varvalue2varname_s1=($kibuvits_krl171_lc_emptystring+
"kibuvits_krl171_s_varvalue2varname_tmp_ar=ObjectSpace._id2ref(").freeze

$kibuvits_krl171_lc_kibuvits_krl171_s_varvalue2varname_s2=($kibuvits_krl171_lc_emptystring+
"kibuvits_krl171_s_varvalue2varname_tmp_i_objectid=(").freeze

# Returns an empty string, if the variable could
# not be found from the scope. The
# ar_an_empty_array_for_reuse_only_for_speed is guaranteed
# to be empty after the exit of this function.
def kibuvits_krl171_s_varvalue2varname(a_binding, ob_varvalue,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_krl171_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   s_script=$kibuvits_krl171_lc_kibuvits_krl171_s_varvalue2varname_s1+
   ar.object_id.to_s+$kibuvits_krl171_lc_rbrace_linebreak+
   $kibuvits_krl171_lc_kibuvits_krl171_s_varvalue2varname_s2+
   ob_varvalue.object_id.to_s+$kibuvits_krl171_lc_rbrace_linebreak+
   $kibuvits_krl171_lc_kibuvits_krl171_s_varvalue2varname_script1 # instance reuse

   eval(s_script,a_binding)
   # Actually a scope may contain multiple variables
   # that reference the same instance, but due to
   # performance considerations this function here
   # is expected to stop the search right after it
   # has found one of the variables or searched the whole scope.
   i=ar.size
   if 1<i
      ar.clear # due to the possible speed related array reuse
      kibuvits_krl171_throw("1<ar.size=="+i.to_s)
   end # if
   s_varname=nil
   if ar.size==0
      # It's actually legitimate for the instance to
      # miss a variable, designating symbol, within the scope that
      # the a_binding references, because the instance
      # might have been referenced by an object id or by some
      # other way by using reflection or fed in like
      # kibuvits_krl171_s_varvalue2varname(binding(), an_awesome_function())
      s_varname=$kibuvits_krl171_lc_emptystring
   else
      s_varname=ar[0]
      ar.clear
   end # if
   return s_varname
end # kibuvits_krl171_s_varvalue2varname

#--------------------------------------------------------------------------
$kibuvits_krl171_lc_kibuvits_krl171_set_var_in_scope_s1=($kibuvits_krl171_lc_emptystring+
"kibuvits_krl171_set_var_in_scope_tmp_ar=ObjectSpace._id2ref(").freeze
$kibuvits_krl171_lc_kibuvits_krl171_set_var_in_scope_s2=($kibuvits_krl171_lc_emptystring+
"=kibuvits_krl171_set_var_in_scope_tmp_ar[0]\n").freeze

# The ar_an_empty_array_for_reuse_only_for_speed is guaranteed
# to be empty after the exit of this function.
def kibuvits_krl171_set_var_in_scope(a_binding, s_varname,x_varvalue,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_krl171_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   ar<<x_varvalue
   s_script=$kibuvits_krl171_lc_kibuvits_krl171_set_var_in_scope_s1+
   ar.object_id.to_s+$kibuvits_krl171_lc_rbrace_linebreak+
   s_varname+$kibuvits_krl171_lc_kibuvits_krl171_set_var_in_scope_s2
   eval(s_script,a_binding)
   ar.clear
end # kibuvits_krl171_set_var_in_scope


#--------------------------------------------------------------------------

# a_binding==Kernel.binding()
def kibuvits_krl171_typecheck(a_binding,expected_class_or_an_array_of_expected_classes,
   a_variable,s_msg_complement=nil)
   if KIBUVITS_krl171_b_DEBUG
      if a_binding.class!=Binding
         kibuvits_krl171_throw("\nThe class of the 1. argument of the "+
         "function kibuvits_krl171_typecheck,\n"+
         "the a_binding, is expected to be Binding, but the class of \n"+
         "the received value was "+a_binding.class.to_s+
         ".\na_binding.to_s=="+a_binding.to_s+"\n")
      end # if
      cl=s_msg_complement.class
      if (cl!=String)&&(cl!=NilClass)
         kibuvits_krl171_throw("\nThe class of the 3. argument of the "+
         "function kibuvits_krl171_typecheck,\n"+
         "the s_msg_complement, is expected to be either String or NilClass,\n"+
         "but the class of the received value was "+cl.to_s+
         ".\ns_msg_complement.to_s=="+s_msg_complement.to_s+"\n")
      end # if
   end # if
   xcorar=expected_class_or_an_array_of_expected_classes
   b_failure=true
   if xcorar.class==Class
      b_failure=(a_variable.class!=xcorar)
   else
      if xcorar.class==Array
         xcorar.each do |an_expected_class|
            if a_variable.class==an_expected_class
               b_failure=false
               break
            end # if
         end # loop
      else
         kibuvits_krl171_throw("\nThe class of the 2. argument of the "+
         "function kibuvits_krl171_typecheck,\n"+
         "the expected_class_or_an_array_of_expected_classes,\n"+
         "is expected to be either Class or Array, but the class of \n"+
         "the received value was "+xcorar.class.to_s+
         ".\nexpected_class_or_an_array_of_expected_classes.to_s=="+
         expected_class_or_an_array_of_expected_classes.to_s+"\n")
      end # if
   end # if
   if b_failure
      # Speed-optimizing exception throwing speeds up selftests,
      # i.e. I'm not that big of a moron as it might seem at first glance. :-D
      ar_tmp_for_speed=Array.new
      # It's actually legitimate for the value of the a_variable to
      # miss a variable, designating symbol, within the scope that
      # the a_binding references, because the value of the a_variable
      # might have been referenced by an object id or by some
      # other way by using reflection or fed in here like
      # kibuvits_krl171_typecheck(binding(),NiceClass, an_awesome_function())
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,
      a_variable,ar_tmp_for_speed)
      s=nil
      if 0<s_varname.length
         s="\n"+s_varname+".class=="+a_variable.class.to_s+
         ", but the "+s_varname+" is expected \nto be of "
      else
         s="\nFound class "+a_variable.class.to_s+", but expected "
      end # if
      if xcorar.class==Class
         s=s+"class "+ xcorar.to_s+".\n"
      else
         s_cls="one of the following classes:\n"
         b_comma_needed=false
         xcorar.each do |an_expected_class|
            s_cls=s_cls+", " if b_comma_needed
            b_comma_needed=true
            s_cls=s_cls+an_expected_class.to_s
         end # loop
         s=s+s_cls+".\n"
      end # if
      s=s+s_msg_complement+"\n" if s_msg_complement.class==String
      kibuvits_krl171_set_var_in_scope(a_binding,
      "kibuvits_krl171_typecheck_s_msg",s,ar_tmp_for_speed)
      eval("kibuvits_krl171_throw(kibuvits_krl171_typecheck_s_msg)\n",a_binding)
   end # if
   return b_failure
end # kibuvits_krl171_typecheck

def kibuvits_krl171_typecheck_ar_content(a_binding,expected_class_or_an_array_of_expected_classes,
   ar_verifiable_values,s_msg_complement=nil)
   bn=binding()
   if KIBUVITS_krl171_b_DEBUG
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, [Class,Array], expected_class_or_an_array_of_expected_classes
      kibuvits_krl171_typecheck bn, Array, ar_verifiable_values
      kibuvits_krl171_typecheck bn, [NilClass,String], s_msg_complement
      if expected_class_or_an_array_of_expected_classes.class==Array
         expected_class_or_an_array_of_expected_classes.each do |cl_candidate|
            bn_1=binding()
            kibuvits_krl171_typecheck bn_1, Class, cl_candidate
         end # loop
      end # if
   end # if
   ar_cl=expected_class_or_an_array_of_expected_classes
   if expected_class_or_an_array_of_expected_classes.class==Class
      ar_cl=[expected_class_or_an_array_of_expected_classes]
   end # if
   b_throw=false
   x_value=nil
   ar_verifiable_values.each do |x_verifiable|
      b_throw=true
      x_value=x_verifiable
      ar_cl.each do |cl_allowed|
         if x_verifiable.class==cl_allowed
            b_throw=false
            break
         end # if
      end # loop
      break if b_throw
   end # loop
   if b_throw
      kibuvits_krl171_typecheck(a_binding,expected_class_or_an_array_of_expected_classes,
      x_value,s_msg_complement)
   end # if
   b_failure=b_throw
   return b_failure
end # kibuvits_krl171_typecheck_ar_content

#--------------------------------------------------------------------------

# Returns false if any of the x_key_candidate_or_ar_of_key_candidates
# elements is missing from the ht.keys
def b_kibuvits_krl171_ht_has_keys(x_key_candidate_or_ar_of_key_candidates,ht)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Hash,ht
      kibuvits_krl171_typecheck bn, [Array,String],x_key_candidate_or_ar_of_key_candidates
   end # if
   b_out=true
   if x_key_candidate_or_ar_of_key_candidates.class==Array
      x_key_candidate_or_ar_of_key_candidates.each do |x_key_candidate|
         if !ht.has_key? x_key_candidate
            b_out=false
            break
         end # if
      end # loop
   else
      b_out=ht.has_key? x_key_candidate_or_ar_of_key_candidates
   end # if
   return b_out
end # b_kibuvits_krl171_ht_has_keys

# This function has a limitation that if a
# single array is expected to be the key of the
# hashtable, then it has to be wrapped into an
# array. That is to say:
#
#  Wrong: kibuvits_krl171_assert_ht_has_keys(binging(),ht,array_as_a_key_candidate)
#
#  Correct: kibuvits_krl171_assert_ht_has_keys(binging(),ht,[array_as_a_key_candidate])
#
def kibuvits_krl171_assert_ht_has_keys(a_binding,ht,
   x_key_candidate_or_ar_of_key_candidates,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      # The typechecks are within the KIBUVITS_krl171_b_DEBUG
      # block due to a fact that sometimes one might
      # want to use the assert clause even, if the
      # debug mode has been switched off.
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, Hash,ht
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   x_missing_keys=nil
   if x_key_candidate_or_ar_of_key_candidates.class==Array
      x_key_candidate_or_ar_of_key_candidates.each do |x_key_candidate|
         if !ht.has_key? x_key_candidate
            x_missing_keys=Array.new if x_missing_keys.class!=Array
            x_missing_keys<<x_key_candidate
         end # if
      end # loop
   else
      return if ht.has_key? x_key_candidate_or_ar_of_key_candidates
      x_missing_keys=[x_key_candidate_or_ar_of_key_candidates]
   end # if
   return if x_missing_keys.class==NilClass
   # It's actually legitimate for the instance to
   # miss a variable, designating symbol, within the scope that
   # the a_binding references, because the instance
   # might have been referenced by an object id or by some
   # other way by using reflection or fed in like
   # kibuvits_krl171_assert_ht_keys_and(binding(), an_awesome_function(),"a_key_candidate")
   #
   # Speed-optimizing exception throwing speeds up selftests, though, I
   # understand that due to string instantiation alone the single array instantiation
   # in this method is totally irrelevant, marginal. :-D
   ar_tmp_for_speed=Array.new
   s_ht_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ht,ar_tmp_for_speed)
   msg=nil
   if s_ht_varname.length==0
      msg="\nThe hashtable is missing the following keys:\n"
   else
      msg="\nThe hashtable, "+s_ht_varname+", is missing the following keys:\n"
   end # if
   b_comma_needed=false
   s_1=", "
   s_2=nil
   x_missing_keys.each  do |x_key|
      if b_comma_needed
         s_2=s_1+x_key.to_s # to use shorter temporary strings
         msg=msg+s_2
      else
         msg=msg+x_key.to_s
         b_comma_needed=true
      end # if
   end # loop
   msg=msg+$kibuvits_krl171_lc_linebreak
   if s_optional_error_message_suffix.class==String
      s_2=s_optional_error_message_suffix+$kibuvits_krl171_lc_linebreak
      msg=msg+s_2
   end # if
   kibuvits_krl171_set_var_in_scope(a_binding,
   "kibuvits_krl171_assert_ht_has_keys_s_msg",msg,ar_tmp_for_speed)
   eval("kibuvits_krl171_throw(kibuvits_krl171_assert_ht_has_keys_s_msg)\n",a_binding)
end # kibuvits_krl171_assert_ht_has_keys

#--------------------------------------------------------------------------
# The keys and values must all be of class String.
# Usage example:
#
# ht=Hash.new
# ht["hi"]="there"
# ht["welcome"]="to heaven"
# ht["nice"]="day"
# ht["whatever"]="other string value"
#
# a_binding=binding()
#
# # A single compulsory key-value pair:
# kibuvits_krl171_assert_ht_has_keyvaluepairs_s(a_binding,ht,["hi","there"])
#
# # Multiple compulsory key-value pairs:
# kibuvits_krl171_assert_ht_has_keyvaluepairs_s(a_binding,ht,
# [["hi","there"],["nice","day"]])
#
def kibuvits_krl171_assert_ht_has_keyvaluepairs_s(a_binding,ht,
   ar_keyvaluepair_or_ar_keyvaluepairs,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      # The typechecks are within the KIBUVITS_krl171_b_DEBUG
      # block due to a fact that sometimes one might
      # want to use the assert clause even, if the
      # debug mode has been switched off.
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, Hash,ht
      kibuvits_krl171_typecheck bn, Array,ar_keyvaluepair_or_ar_keyvaluepairs
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if ar_keyvaluepair_or_ar_keyvaluepairs.size==0
         kibuvits_krl171_throw("ar_keyvaluepair_or_ar_keyvaluepairs.size==0\n")
      end # if
      x_keyvaluepair_or_key=ar_keyvaluepair_or_ar_keyvaluepairs[0]
      kibuvits_krl171_typecheck bn, [String,Array],x_keyvaluepair_or_key
   else
      if ar_keyvaluepair_or_ar_keyvaluepairs.size==0
         # I know that it duplicates the debug branch,
         # but I can not refactor it out of here.
         kibuvits_krl171_throw("ar_keyvaluepair_or_ar_keyvaluepairs.size==0\n")
      end # if
   end # if
   ar_keyvaluepairs=nil
   if (ar_keyvaluepair_or_ar_keyvaluepairs[0]).class==Array
      ar_keyvaluepairs=ar_keyvaluepair_or_ar_keyvaluepairs
   else
      ar_keyvaluepairs=[ar_keyvaluepair_or_ar_keyvaluepairs]
   end # if
   s_key=nil
   s_value=nil
   x_key_is_missing=nil
   if KIBUVITS_krl171_b_DEBUG
      ar_keyvaluepairs.each do |ar_keyvaluepair|
         bn=binding()
         kibuvits_krl171_typecheck bn, Array,ar_keyvaluepair
         if ar_keyvaluepair.size!=2
            kibuvits_krl171_throw("2!=ar_keyvaluepair.size=="+
            ar_keyvaluepair.size.to_s)
         end # if
         s_key=ar_keyvaluepair[0]
         s_value=ar_keyvaluepair[1]
         kibuvits_krl171_typecheck bn, String,s_key
         kibuvits_krl171_typecheck bn, String,s_value
         if !ht.has_key? s_key
            x_key_is_missing=true
            break
         end # if
         if ht[s_key]!=s_value
            x_key_is_missing=false
            break
         end # if
      end # loop
   else
      ar_keyvaluepairs.each do |ar_keyvaluepair|
         s_key=ar_keyvaluepair[0]
         s_value=ar_keyvaluepair[1]
         if !ht.has_key? s_key
            x_key_is_missing=true
            break
         end # if
         if ht[s_key]!=s_value
            x_key_is_missing=false
            break
         end # if
      end # loop
   end # if
   return if x_key_is_missing.class==NilClass
   ar_tmp_for_speed=Array.new
   s_ht_name=kibuvits_krl171_s_varvalue2varname(a_binding,ht,ar_tmp_for_speed)
   msg=nil
   if x_key_is_missing==true
      if 0<s_ht_name.length
         msg="The hashtable, "+s_ht_name+
         ", is missing a key named \""+s_key+"\"."
      else
         msg="The hashtable is missing a key named \""+s_key+"\"."
      end # if
   else # x_key_is_missing==false
      if 0<s_ht_name.length
         msg=s_ht_name+"[\""+s_key+"\"]=="+ht[s_key]+"!="+s_value
      else
         msg="<a hashtable>[\""+s_key+"\"]=="+ht[s_key]+"!="+s_value
      end # if
   end # if
   msg=msg+$kibuvits_krl171_lc_linebreak
   kibuvits_krl171_set_var_in_scope(a_binding,
   "kibuvits_krl171_assert_ht_has_keyvaluepairs_s_msg",msg,ar_tmp_for_speed)
   eval("kibuvits_krl171_throw(kibuvits_krl171_assert_ht_has_keyvaluepairs_s_msg)\n",
   a_binding)
end # kibuvits_krl171_assert_ht_has_keyvaluepairs_s

#--------------------------------------------------------------------------

def kibuvits_krl171_get_binding_wrapper_instance_class(bn_caller_binding)
   ar=Array.new()
   i_ar_id=ar.object_id
   s_tmpvarname1="kibuvits_krl171_get_binding_wrapper_instance_classtmpvar1"
   s_tmpvarname2="kibuvits_krl171_get_binding_wrapper_instance_classtmpvar2"
   s_script=s_tmpvarname1+"=self.class\n"+
   s_tmpvarname2+"=ObjectSpace._id2ref("+i_ar_id.to_s+")\n"+
   s_tmpvarname2+"<<"+s_tmpvarname1+"\n"+
   s_tmpvarname1+"=nil\n"+
   s_tmpvarname2+"=nil\n"
   begin
      eval(s_script,bn_caller_binding)
   rescue Exception => e
      kibuvits_krl171_throw ("\n\nOne of the possible causes of the "+
      "exception here is that one tried to get a class "+
      "of a static method. The workaround is that only "+
      "instances, which can be singletons, are analyzed. "+
      "There's also the limitation that one can not use the "+
      "Kibuvits_krl171_msgc_stack and Kibuvits_krl171_msgc instances "+
      "in functions that are not wrapped into some instance.\n\n"+
      "The caught exception message is:\n\n"+
      e.to_s+$kibuvits_krl171_lc_doublelinebreak)
   end # rescue
   cl_out=ar[0]
   ar.clear
   return cl_out
end # kibuvits_krl171_get_binding_wrapper_instance_class

#--------------------------------------------------------------------------

def kibuvits_krl171_assert_string_min_length(a_binding,s_in,i_min_length,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, String, s_in
      kibuvits_krl171_typecheck bn, Integer, i_min_length
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if i_min_length<0
         kibuvits_krl171_throw("i_min_length == "+i_min_length.to_s+" < 0");
      end # if
   end # if
   i_len=s_in.length
   if i_len<i_min_length
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,s_in)
      s_varname="<a string>" if s_varname.length==0
      kibuvits_krl171_throw(s_varname+".length=="+i_len.to_s+", but the "+
      "minimum allowed string length is "+i_min_length.to_s+".",a_binding)
   end # if
end # kibuvits_krl171_assert_string_min_length

#--------------------------------------------------------------------------

def kibuvits_krl171_assert_array_min_length(a_binding,ar_in,i_min_length,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, Array, ar_in
      kibuvits_krl171_typecheck bn, Integer, i_min_length
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if i_min_length<0
         kibuvits_krl171_throw("i_min_length == "+i_min_length.to_s+" < 0");
      end # if
   end # if
   i_len=ar_in.size
   if i_len<i_min_length
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ar_in)
      s_varname="<an array>" if s_varname.length==0
      kibuvits_krl171_throw(s_varname+".size=="+i_len.to_s+", but the "+
      "minimum allowed array length is "+i_min_length.to_s+".",a_binding)
   end # if
end # kibuvits_krl171_assert_array_min_length

#--------------------------------------------------------------------------

# It's tested as part of the
# kibuvits_krl171_assert_does_not_contain_common_special_characters_t1
def kibuvits_krl171_b_contains_common_special_characters_t1(s_in)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String, s_in
   end # if
   i_0=s_in.length
   return false if i_0==0
   s_1=s_in.gsub(/[\t\s\n\r;:|,.$<>+\-%*~\/\[\](){}\\^'"]/,$kibuvits_krl171_lc_emptystring)
   return true if s_1.length!=i_0
   return false
end # kibuvits_krl171_b_contains_common_special_characters_t1

def kibuvits_krl171_b_not_suitable_for_a_varname_t1(s_in)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String, s_in
   end # if
   i_0=s_in.length
   return true if i_0==0
   return true if kibuvits_krl171_b_contains_common_special_characters_t1(s_in)
   s_1=s_in.gsub(/^[\d]/,$kibuvits_krl171_lc_emptystring)
   return true if s_in.length!=s_1.length
   return false
end # kibuvits_krl171_b_not_suitable_for_a_varname_t1

def kibuvits_krl171_assert_ok_to_be_a_varname_t1(a_binding,s_in,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, String, s_in
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   if kibuvits_krl171_b_not_suitable_for_a_varname_t1(s_in)
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,s_in)
      kibuvits_krl171_throw("\n"+s_varname+"==\""+s_in.to_s+
      "\" is not suitable for a variable name. \n",a_binding)
   end # if
end # kibuvits_krl171_assert_ok_to_be_a_varname_t1

#--------------------------------------------------------------------------

def kibuvits_krl171_assert_arrayix(a_binding,ar,
   i_array_index_candidate_or_array_of_array_index_candidates,
   s_optional_error_message_suffix=nil)
   x_candidates=i_array_index_candidate_or_array_of_array_index_candidates
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, Array,ar
      kibuvits_krl171_typecheck bn, [Integer,Array],i_array_index_candidate_or_array_of_array_index_candidates
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if x_candidates.class==Array
         if x_candidates.size==0
            kibuvits_krl171_throw("The array of candidate indices is empty.")
         end # if
         x_candidates.each do |x|
            bn=binding()
            kibuvits_krl171_typecheck bn,Integer,x
         end # loop
      end # if
   end # if
   ar_candidates=x_candidates
   ar_candidates=[x_candidates] if x_candidates.class==Integer
   i_cand_sindex_max=ar_candidates.size # array separator index, min==0
   i_number_of_candidates=i_cand_sindex_max # ==(i_cand_sindex_max-0)
   if i_number_of_candidates==0
      kibuvits_krl171_throw("The array of candidate indices is empty.")
   end # if
   i_max_valid_ix=ar.size-1
   i_candidate=nil
   #------
   func_suffix=lambda do |s_or_nil_suffix|
      x_out=nil
      if s_or_nil_suffix!=nil
         x_out=$kibuvits_krl171_lc_linebreak+s_or_nil_suffix.to_s
      else
         x_out=$kibuvits_krl171_lc_emptystring
      end # if
      return x_out
   end # func_suffix
   #------
   i_number_of_candidates.times do |i|
      i_candidate=ar_candidates[i]
      if i_candidate<0
         s_suffix=func_suffix.call(s_optional_error_message_suffix)
         if i_number_of_candidates==1
            kibuvits_krl171_throw("<array index candidate>"+
            " == "+i_candidate.to_s+" < 0 "+s_suffix,a_binding)
         else
            kibuvits_krl171_throw("Array index candidate #"+i.to_s+
            " == "+i_candidate.to_s+" < 0 "+s_suffix,a_binding)
         end # if
      end # if
      if i_max_valid_ix<i_candidate
         s_suffix=func_suffix.call(s_optional_error_message_suffix)
         kibuvits_krl171_throw("Maximum valid index is "+
         i_max_valid_ix.to_s+" < "+i_candidate.to_s+
         " == <index candidate>"+s_suffix,a_binding)
      end # if
   end # loop
end # kibuvits_krl171_assert_arrayix


# http://longterm.softf1.com/specifications/array_indexing_by_separators/
def kibuvits_krl171_assert_arrayixs(a_binding,ar,
   i_array_sindex_candidate_or_array_of_array_sindex_candidates,
   s_optional_error_message_suffix=nil)
   x_candidates=i_array_sindex_candidate_or_array_of_array_sindex_candidates
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, Array,ar
      kibuvits_krl171_typecheck bn, [Integer,Array],i_array_sindex_candidate_or_array_of_array_sindex_candidates
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if x_candidates.class==Array
         if x_candidates.size==0
            kibuvits_krl171_throw("The array of candidate sindices is empty.")
         end # if
         x_candidates.each do |x|
            bn=binding()
            kibuvits_krl171_typecheck bn,Integer,x
         end # loop
      end # if
   end # if
   ar_candidates=x_candidates
   ar_candidates=[x_candidates] if x_candidates.class==Integer
   i_cand_sindex_max=ar_candidates.size # array separator index, min==0
   i_number_of_candidates=i_cand_sindex_max # ==(i_cand_sindex_max-0)
   if i_number_of_candidates==0
      kibuvits_krl171_throw("The array of candidate sindices is empty.")
   end # if
   i_max_valid_ixs=ar.size
   i_candidate=nil
   #------
   func_suffix=lambda do |s_or_nil_suffix|
      x_out=nil
      if s_or_nil_suffix!=nil
         x_out=$kibuvits_krl171_lc_linebreak+s_or_nil_suffix.to_s
      else
         x_out=$kibuvits_krl171_lc_emptystring
      end # if
      return x_out
   end # func_suffix
   #------
   i_number_of_candidates.times do |i|
      i_candidate=ar_candidates[i]
      if i_candidate<0
         s_suffix=func_suffix.call(s_optional_error_message_suffix)
         if i_number_of_candidates==1
            kibuvits_krl171_throw("<array sindex candidate>"+
            " == "+i_candidate.to_s+" < 0 "+s_suffix,a_binding)
         else
            kibuvits_krl171_throw("Array sindex candidate #"+i.to_s+
            " == "+i_candidate.to_s+" < 0 "+s_suffix,a_binding)
         end # if
      end # if
      if i_max_valid_ixs<i_candidate
         s_suffix=func_suffix.call(s_optional_error_message_suffix)
         kibuvits_krl171_throw("Maximum valid sindex is "+
         i_max_valid_ixs.to_s+" < "+i_candidate.to_s+
         " == <sindex candidate>"+s_suffix,a_binding)
      end # if
   end # loop
end # kibuvits_krl171_assert_arrayixs

#--------------------------------------------------------------------------

def kibuvits_krl171_assert_ht_container_version(a_binding,ht_container,s_expected_version,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, Hash,ht_container
      kibuvits_krl171_typecheck bn, String,s_expected_version
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   if !(ht_container.has_key? $kibuvits_krl171_lc_s_version)
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding, ht_container)
      msg=nil
      if 0<s_varname.length
         msg="The "+s_varname+" is missing the key, \""
      else
         msg="The ht_container is missing the key, \""
      end # if
      msg=msg+$kibuvits_krl171_lc_s_version+"\", that refers to the version number."
      if s_optional_error_message_suffix!=nil
         msg=msg+("\n"+s_optional_error_message_suffix)
      end # if
      kibuvits_krl171_throw(msg,a_binding)
   end # if
   s_version=ht_container[$kibuvits_krl171_lc_s_version]
   if s_version!=s_expected_version
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ht_container)
      msg=nil
      if 0<s_varname.length
         msg=s_varname+"[\""+$kibuvits_krl171_lc_s_version+"\"]==\""+s_version+"\", but \""+
         s_expected_version+"\" was expected."
      else
         msg="ht_container[\""+$kibuvits_krl171_lc_s_version+"\"]==\""+s_version+"\", but \""+
         s_expected_version+"\" was expected."
      end # if
      if s_optional_error_message_suffix!=nil
         msg=msg+("\n"+s_optional_error_message_suffix)
      end # if
      kibuvits_krl171_throw(msg,a_binding)
   end # if
end # kibuvits_krl171_assert_ht_container_version

#--------------------------------------------------------------------------
# If the width of a class name prefix can match that of the
# class name, then the assertion is considered met and
# no exceptions are thrown.
def kibuvits_krl171_assert_class_name_prefix(a_binding,ob,
   x_class_name_prefix_as_string_or_class,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, [String,Class],x_class_name_prefix_as_string_or_class
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   s_prefix=nil
   if x_class_name_prefix_as_string_or_class.class==Class
      s_prefix=x_class_name_prefix_as_string_or_class.to_s
   else
      s_prefix=x_class_name_prefix_as_string_or_class
      kibuvits_krl171_assert_string_min_length(a_binding,s_prefix,1)
   end # if
   s_cl=ob.class.to_s
   rgx=Regexp.new($kibuvits_krl171_lc_powersign+s_prefix+$kibuvits_krl171_lc_dotstar)
   md=rgx.match(s_cl)
   if md==nil
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
      s_varname="<an object>" if s_varname.length==0
      msg=s_varname+".class.to_s==\""+s_cl+"\", but the "+
      "requested class name prefix is \""+s_prefix+"\". "
      if s_optional_error_message_suffix.class==String
         msg=msg+s_optional_error_message_suffix
      end # if
      kibuvits_krl171_throw(msg,a_binding)
   end # if
end # kibuvits_krl171_assert_class_name_prefix

#--------------------------------------------------------------------------

def kibuvits_krl171_assert_responds_2_method(a_binding,ob,
   x_method_name_or_method_or_symbol,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding,a_binding
      kibuvits_krl171_typecheck bn, [String,Method,Symbol],x_method_name_or_method_or_symbol
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   sym_x=nil
   s_clname=x_method_name_or_method_or_symbol.class.to_s
   case s_clname
   when $kibuvits_krl171_lc_s_String
      bn=binding()
      kibuvits_krl171_assert_string_min_length(bn,x_method_name_or_method_or_symbol,1)
      sym_x=x_method_name_or_method_or_symbol.to_sym
   when $kibuvits_krl171_lc_s_Method
      sym_x=x_method_name_or_method_or_symbol.name
   when $kibuvits_krl171_lc_s_Symbol
      sym_x=x_method_name_or_method_or_symbol
   else
      kibuvits_krl171_throw("There's a flaw. 26022333-bfa5-44a8-8c02-03e150913cd7")
   end # case x_method_name_or_method_or_symbol.class
   if !ob.respond_to? sym_x
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
      s_varname="<an object>" if s_varname.length==0
      msg=s_varname+" is expected to have a method named \""+
      sym_x.to_s+"\", but it does not have it. "
      if s_optional_error_message_suffix.class==String
         msg=msg+s_optional_error_message_suffix
      end # if
      kibuvits_krl171_throw(msg,a_binding)
   end # if
end # kibuvits_krl171_assert_responds_2_method

#--------------------------------------------------------------------------

def kibuvits_krl171_impl_class_inheritance_assertion_funcs_t1(a_binding,ob,
   cl_or_s_class,b_classes_may_equal,s_optional_error_message_suffix)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, [Class,String], cl_or_s_class
      kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_classes_may_equal
      kibuvits_krl171_typecheck bn, [NilClass,String], s_optional_error_message_suffix
   end # if
   cl=cl_or_s_class
   b_throw=false
   begin
      if cl_or_s_class.class==String
         cl=Kernel.const_get(cl_or_s_class)
      else
         # This branch is useful, if the KIBUVITS_krl171_b_DEBUG branch is not entered.
         cl.class # throws, if it ==  <nonexisting class>.class
      end # if
   rescue Exception => e
      b_throw=true
   end # rescue
   if b_throw
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
      s_varname="<an object>" if s_varname.length==0
      msg=s_varname+" is expected to be of class "+cl_or_s_class+
      ", but the Ruby source that describes "+
      "a class with that name has not been loaded. "
      if s_optional_error_message_suffix.class==String
         msg=msg+s_optional_error_message_suffix
      end # if
      kibuvits_krl171_throw(msg,a_binding)
   end # if

   if b_classes_may_equal
      if ob.class!=cl
         if !(ob.kind_of?(cl))
            s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
            s_varname="<an object>" if s_varname.length==0
            s_cl_name=cl_or_s_class.to_s
            msg=s_varname+".class is expected to be derived from the class "+
            s_cl_name+ ", but the "+s_varname+".class=="+ob.class.to_s+$kibuvits_krl171_lc_space
            if s_optional_error_message_suffix.class==String
               msg=msg+s_optional_error_message_suffix
            end # if
            kibuvits_krl171_throw(msg,a_binding)
         end # if
      end # if
   else
      if ob.class==cl
         s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
         s_varname="<an object>" if s_varname.length==0
         s_cl_name=cl_or_s_class.to_s
         msg=s_varname+".class is expected to differ from class "+
         s_cl_name+", but the "+s_varname+".class=="+
         ob.class.to_s+$kibuvits_krl171_lc_space
         if s_optional_error_message_suffix.class==String
            msg=msg+s_optional_error_message_suffix
         end # if
         kibuvits_krl171_throw(msg,a_binding)
      else
         if !(ob.kind_of?(cl))
            s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
            s_varname="<an object>" if s_varname.length==0
            s_cl_name=cl_or_s_class.to_s
            msg=s_varname+".class is expected to be derived from the class "+
            s_cl_name+ ", but the "+s_varname+".class=="+ob.class.to_s+$kibuvits_krl171_lc_space
            if s_optional_error_message_suffix.class==String
               msg=msg+s_optional_error_message_suffix
            end # if
            kibuvits_krl171_throw(msg,a_binding)
         end # if
      end # if
   end # if
end # kibuvits_krl171_impl_class_inheritance_assertion_funcs_t1

def kibuvits_krl171_assert_is_inherited_from_or_equals_with_class(a_binding,ob,
   cl_or_s_class,s_optional_error_message_suffix=nil)
   kibuvits_krl171_impl_class_inheritance_assertion_funcs_t1(
   a_binding,ob,cl_or_s_class,true,s_optional_error_message_suffix)
end # kibuvits_krl171_assert_is_inherited_from_or_equals_with_class

def kibuvits_krl171_assert_is_inherited_from_and_does_not_equal_with_class(a_binding,ob,
   cl_or_s_class,s_optional_error_message_suffix=nil)
   kibuvits_krl171_impl_class_inheritance_assertion_funcs_t1(
   a_binding,ob,cl_or_s_class,false,s_optional_error_message_suffix)
end # kibuvits_krl171_assert_is_inherited_from_and_does_not_equal_with_class

#--------------------------------------------------------------------------

# If the ob_or_ar_or_ht is an Array or a hashtable(Hash),then the ob is
# compared with the content of the Array or the values of the hashtable.
def kibuvits_krl171_assert_is_among_values(a_binding,ob_or_ar_or_ht,
   ob,s_optional_error_message_suffix=nil)
   ar_values=nil
   if ob_or_ar_or_ht.class==Array
      ar_values=ob_or_ar_or_ht
   else
      if ob_or_ar_or_ht.class==Hash
         ar_values=ob_or_ar_or_ht.values
      else
         ar_values=[ob_or_ar_or_ht]
      end # if
   end # if
   b_throw=true
   ar_values.each do |x_value|
      if ob==x_value
         b_throw=false
         break
      end # if
   end # loop
   if b_throw
      b_list_assembleable=true
      ar_values.each do |x_value|
         cl=x_value.class
         if (cl!=String)&&(cl!=Integer)&&(cl!=Rational)&&(cl!=Bignum)
            b_list_assembleable=false
            break
         end # if
      end # loop
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ob)
      s_varname="<an object>" if s_varname.length==0
      msg=$kibuvits_krl171_lc_doublelinebreak+s_varname+
      " does not have a value that is among the set of valid values. \n"+
      s_varname+"=="+ob.to_s
      if b_list_assembleable
         b_nonfirst=false
         s_list=$kibuvits_krl171_lc_emptystring
         ar_values.each do |x_value|
            s_list=s_list+", " if b_nonfirst
            b_nonfirst=true
            s_list=s_list+x_value.to_s
         end # loop
         msg=msg+"\nList of valid values: "+s_list+".\n"
      end # if
      if s_optional_error_message_suffix.class==String
         msg=msg+"\n"+s_optional_error_message_suffix
      end # if
      msg=msg+$kibuvits_krl171_lc_doublelinebreak
      kibuvits_krl171_throw(msg,a_binding)
   end # if
end # kibuvits_krl171_assert_is_among_values

#--------------------------------------------------------------------------

def kibuvits_krl171_assert_is_smaller_than_or_equal_to(a_binding,
   i_or_fd_or_ar_or_i_or_fd, i_or_fd_or_ar_of_i_or_fd_upper_bounds,
   s_optional_error_message_suffix=nil)
   # TODO: create additional methods
   #       assert_monotonic_increase_t1(ar_series_in),
   #       assert_monotonic_decrease_t1(ar_series_in)
   ar_allowed_classes=[Integer,Bignum,Float,Rational]
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      ar_x=(ar_allowed_classes+[Array])
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, ar_x, i_or_fd_or_ar_or_i_or_fd
      kibuvits_krl171_typecheck bn, ar_x, i_or_fd_or_ar_of_i_or_fd_upper_bounds
      kibuvits_krl171_typecheck bn, [NilClass,String], s_optional_error_message_suffix
   end # if

   ar_values=nil
   if i_or_fd_or_ar_or_i_or_fd.class==Array
      ar_values=i_or_fd_or_ar_or_i_or_fd
   else
      ar_values=[i_or_fd_or_ar_or_i_or_fd]
   end # if

   ar_upper_bounds=nil
   if i_or_fd_or_ar_of_i_or_fd_upper_bounds.class==Array
      ar_upper_bounds=i_or_fd_or_ar_of_i_or_fd_upper_bounds
   else
      ar_upper_bounds=[i_or_fd_or_ar_of_i_or_fd_upper_bounds]
   end # if

   #------------------------------------------------------------
   # If the types in the array are wrong, then it's
   # probable that the values of those elements, that have
   # a correct type, are also wrong. It's better to
   # throw before doing any calculations with the faulty
   # values and throw at some other, more distant, place.
   # That explains the existence of this, extra, typechecking loop.
   s_suffix="\nGUID='9edbd033-631d-4274-a4e6-c2c2f051a4e7'"
   if s_optional_error_message_suffix!=nil
      s_suffix=(s_suffix+$kibuvits_krl171_lc_linebreak)+s_optional_error_message_suffix
   end # if
   s_optional_error_message_suffix
   ar_values.each do |x_value|
      kibuvits_krl171_typecheck(a_binding,ar_allowed_classes,x_value,s_suffix)
   end # loop
   #---------------------
   s_suffix="\nGUID='4ccf7fb6-d2f2-4204-8496-c2c2f051a4e7'"
   if s_optional_error_message_suffix!=nil
      s_suffix=(s_suffix+$kibuvits_krl171_lc_linebreak)+s_optional_error_message_suffix
   end # if
   s_optional_error_message_suffix
   ar_upper_bounds.each do |x_value|
      kibuvits_krl171_typecheck(a_binding,ar_allowed_classes,x_value,s_suffix)
   end # loop
   #------------------------------------------------------------
   b_throw=false
   x_elem=nil
   x_upper_bound_0=nil
   ar_values.each do |x_value|
      ar_upper_bounds.each do |x_upper_bound|
         if x_upper_bound<x_value
            x_upper_bound_0=x_upper_bound
            x_elem=x_value
            b_throw=true
            break
         end # if
      end # loop
      break if b_throw
   end # loop
   if b_throw
      s_0=" == "
      s_varname_1=kibuvits_krl171_s_varvalue2varname(a_binding,x_upper_bound_0)
      if s_varname_1.length==0 # Includes a case, where a numeric constant is an input
         # Emtpystring.
      else
         s_varname_1<<s_0
      end # if
      s_varname_2=kibuvits_krl171_s_varvalue2varname(a_binding,x_elem)
      if s_varname_2.length==0 # Includes a case, where a numeric constant is an input
         # Emtpystring.
      else
         s_varname_2<<s_0
      end # if
      msg=$kibuvits_krl171_lc_doublelinebreak+s_varname_1+x_upper_bound_0.to_s+
      " < " + s_varname_2 + x_elem.to_s+
      "\nGUID='a6ea3d61-e610-48f3-8336-c2c2f051a4e7'"
      if s_optional_error_message_suffix.class==String
         msg=msg+"\n"+s_optional_error_message_suffix
      end # if
      msg=msg+$kibuvits_krl171_lc_doublelinebreak
      kibuvits_krl171_throw(msg,a_binding)
   end # if
end # kibuvits_krl171_assert_is_smaller_than_or_equal_to

#--------------------------------------------------------------------------

def kibuvits_krl171_b_not_a_whole_number_t1(x_in)
   cl=x_in.class
   return false if cl==Integer
   return false if cl==Bignum
   if cl==String
      return true if x_in.length==0
      s_0=x_in.sub(/^[-]?[\d]+$/,$kibuvits_krl171_lc_emptystring)
      return false if s_0.length==0
      return true
   end # if
   if (cl==Float)||(cl==Rational)
      fd_0=x_in.abs
      fd_1=fd_0-(fd_0.floor)
      b_out=(fd_1!=0)
      return b_out
   end # if
   return true
end # kibuvits_krl171_b_not_a_whole_number_t1

#--------------------------------------------------------------------------

$kibuvits_krl171_lc_kibuvits_krl171_eval_t1_s1=($kibuvits_krl171_lc_emptystring+
"ar_in=ObjectSpace._id2ref(").freeze
$kibuvits_krl171_lc_kibuvits_krl171_eval_t1_s2=($kibuvits_krl171_lc_emptystring+
"ar_out=ObjectSpace._id2ref(").freeze

# If the ar_in!=nil, then it is sent to the scope of the
# s_script. The s_script is expected to
# place its output to an array named ar_out.
#
# Both, the ar_in and the ar_out are
# allocated outside of the scope of the
# s_script, that is to say, the s_script
# must not reinstantiate the ar_in and ar_out.
#
# The kibuvits_krl171_eval_t1(...) returns the ar_out.
def kibuvits_krl171_eval_t1(s_script, ar_in=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String,s_script
      kibuvits_krl171_typecheck bn, [NilClass,Array],ar_in
      rgx_ar_in=/([\s]|^|[;])ar_in[\s]*=[\s]*(\[|Array[.])/
      # Actually the rgx_ar_in does not
      # cover cases like ar_in<<x
      # ar_in[i]=x; ar_in.clear;  etc.
      if s_script.match(rgx_ar_in)!=nil
         kibuvits_krl171_throw("The s_script seems to contain "+
         "something like ar_in=Array.new or ar_in=[] or something "+
         "similar. To avoid side-effects the ar_in must "+
         "not be modified within the s_script.")
      end # if
      rgx_ar_out=/([\s]|^|[;])ar_out[\s]*=[\s]*(\[|Array[.])/
      if s_script.match(rgx_ar_out)!=nil
         kibuvits_krl171_throw("The s_script seems to contain "+
         "something like ar_out=Array.new or ar_out=[] or something "+
         "similar. The ar_out must not be reinstantiated within "+
         "the s_script, because the ar_out instance is used for "+
         "retrieving the ar_out content from the s_script scope.")
      end # if
   end # if
   ar_out=Array.new
   s_scr=nil
   if ar_in!=nil
      s_scr=$kibuvits_krl171_lc_kibuvits_krl171_eval_t1_s1+
      (ar_in.object_id.to_s+$kibuvits_krl171_lc_rbrace_linebreak)
   else
      s_scr=$kibuvits_krl171_lc_emptystring
   end # if
   s_scr=s_scr+($kibuvits_krl171_lc_kibuvits_krl171_eval_t1_s2+
   (ar_out.object_id.to_s+$kibuvits_krl171_lc_rbrace_linebreak))
   s_scr=s_scr+s_script
   eval(s_scr)
   return ar_out
end # kibuvits_krl171_eval_t1


#--------------------------------------------------------------------------

def kibuvits_krl171_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments,&block)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, [Symbol,String],x_method_name_or_symbol

      # The ar_method_arguments must not be nil, because otherwise
      # one could call just ob.send(:methodname_as_symbol,block),
      # which is considerably faster than this function here.
      kibuvits_krl171_typecheck bn, Array,ar_method_arguments
      kibuvits_krl171_typecheck bn, [NilClass,Proc],block
   end # if
   x_sym=x_method_name_or_symbol
   x_sym=x_sym.to_sym if x_sym.class==String
   ar_args=ar_method_arguments
   i_len=ar_args.size
   x_out=nil
   # The case-clauses are due to speed optimization.
   if block==nil
      case i_len
      when 0
         x_out=ob.send(x_sym)
      when 1
         x_out=ob.send(x_sym,ar_args[0])
      when 2
         x_out=ob.send(x_sym,ar_args[0],ar_args[1])
      when 3
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2])
      when 4
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3])
      when 5
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],ar_args[4])
      when 6
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],ar_args[4],ar_args[5])
      when 7
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],ar_args[4],ar_args[5],ar_args[6])
      else
         ar_in=[ob,x_sym,ar_args]
         s_script="ob=ar_in[0];x_sym=ar_in[1];ar_args=ar_in[2];"+
         "x_out=ob.send(x_sym"
         s_lc_1=",ar_args["
         i_len.times do |i|
            s_script=s_script+(s_lc_1+(i.to_s+$kibuvits_krl171_lc_rsqbrace))
         end # loop
         s_script=s_script+($kibuvits_krl171_lc_rbrace+"; ar_out<<x_out")
         ar_out=kibuvits_krl171_eval_t1(s_script, ar_in)
         x_out=ar_out[0]
      end # case i_len
   else
      case i_len
      when 0
         x_out=ob.send(x_sym,&block)
      when 1
         x_out=ob.send(x_sym,ar_args[0],&block)
      when 2
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],&block)
      when 3
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],&block)
      when 4
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],&block)
      when 5
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],ar_args[4],&block)
      when 6
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],ar_args[4],ar_args[5],&block)
      when 7
         x_out=ob.send(x_sym,ar_args[0],ar_args[1],ar_args[2],
         ar_args[3],ar_args[4],ar_args[5],ar_args[6],&block)
      else
         ar_in=[ob,x_sym,ar_args,block]
         s_script=$kibuvits_krl171_lc_emptystring+
         "ob=ar_in[0];x_sym=ar_in[1];ar_args=ar_in[2];block=ar_in[3];"+
         "x_out=ob.send(x_sym"
         s_lc_1=",ar_args["
         i_len.times do |i|
            s_script=s_script+(s_lc_1+(i.to_s+$kibuvits_krl171_lc_rsqbrace))
         end # loop
         s_script=s_script+(",&block); ar_out<<x_out")
         ar_out=kibuvits_krl171_eval_t1(s_script, ar_in)
         x_out=ar_out[0]
      end # case i_len
   end # if
   return x_out
end # kibuvits_krl171_call_by_ar_of_args

#--------------------------------------------------------------------------
#
# i_bitlen in_Set{256,384,512}
#
def kibuvits_krl171_s_hash_t1(s_in,i_bitlen=512)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String,s_in
      kibuvits_krl171_typecheck bn, [Integer,Bignum],i_bitlen
      ar=[256,384,512]
      kibuvits_krl171_assert_is_among_values(bn,ar,i_bitlen)
   end # if
   if !defined? $kibuvits_krl171_func_s_hash_b_module_digest_loaded
      require "digest"
      $kibuvits_krl171_func_s_hash_b_module_digest_loaded=true
   end # if
   ob_hashfunc=Digest::SHA2.new(i_bitlen)
   s_out=ob_hashfunc.hexdigest(s_in)
   return s_out
end # kibuvits_krl171_s_hash_t1


#--------------------------------------------------------------------------

# If the ob_or_ar is not of type Array, then it does not
# apply any tests and exits without throwing any exceptions.
#
def kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(a_binding,
   expected_class_or_an_array_of_expected_classes,
   ob,s_optional_error_message_suffix=nil)
   #----------
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, [Class,Array], expected_class_or_an_array_of_expected_classes
      kibuvits_krl171_typecheck bn, [NilClass,String], s_optional_error_message_suffix
   end # if
   #----------
   ar_exp_classes=nil
   if expected_class_or_an_array_of_expected_classes.class==Array
      ar_exp_classes=expected_class_or_an_array_of_expected_classes
   else
      ar_exp_classes=[expected_class_or_an_array_of_expected_classes]
   end # if
   if KIBUVITS_krl171_b_DEBUG
      if ar_exp_classes.size==0
         msg="ar_exp_classes.size==0\n"+
         "GUID='6c919332-d81f-4c7e-8345-c2c2f051a4e7'"
         kibuvits_krl171_throw(msg)
      end # if
      bn_1=nil
      ar_exp_classes.each do |x_class_candidate|
         bn_1=binding()
         kibuvits_krl171_typecheck bn_1, Class, x_class_candidate
      end # loop
   end # if
   #----------
   return if ob.class!=Array
   ar_ob_elems=ob
   #----------
   cl=nil
   ar_ob_elems.each do |x_elem|
      cl=x_elem.class
      kibuvits_krl171_assert_is_among_values(a_binding,ar_exp_classes,
      cl,s_optional_error_message_suffix)
   end # loop
end # kibuvits_krl171_assert_ar_elements_typecheck_if_is_array

#--------------------------------------------------------------------------

@kibuvits_krl171_b_class_defined_cache_ht_objects=nil

def kibuvits_krl171_b_class_defined_helperfunc_update_ht_objects
   ht_objects=Hash.new
   ObjectSpace.each_object do |ob|
      if ob.class==Class
         ht_objects[ob.to_s]=ob
      end # if
   end # loop
   @kibuvits_krl171_b_class_defined_cache_ht_objects=ht_objects
end # kibuvits_krl171_b_class_defined_helperfunc_update_ht_objects

def kibuvits_krl171_b_class_defined?(s_or_sym_or_cl_class_name)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, [Symbol,String,Class], s_or_sym_or_cl_class_name
   end # if
   s_class_name_in=s_or_sym_or_cl_class_name.to_s
   if @kibuvits_krl171_b_class_defined_cache_ht_objects==nil
      kibuvits_krl171_b_class_defined_helperfunc_update_ht_objects()
   else
      # The list of defined classes can grow between the calls
      # to the kibuvits_krl171_b_class_defined?
      if !@kibuvits_krl171_b_class_defined_cache_ht_objects.has_key? s_class_name_in
         kibuvits_krl171_b_class_defined_helperfunc_update_ht_objects()
      end # if
   end # if
   b_out=@kibuvits_krl171_b_class_defined_cache_ht_objects.has_key?(s_class_name_in)
   return b_out
end # kibuvits_krl171_b_class_defined

# Throws, if the class is not defined.
def kibuvits_krl171_exc_class_name_2_cl(s_or_sym_or_cl_class_name)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, [Symbol,String,Class], s_or_sym_or_cl_class_name
   end # if
   s_class_name_in=s_or_sym_or_cl_class_name.to_s
   if @kibuvits_krl171_b_class_defined_cache_ht_objects==nil
      kibuvits_krl171_b_class_defined_helperfunc_update_ht_objects()
   end # if
   if !kibuvits_krl171_b_class_defined? s_class_name_in
      kibuvits_krl171_throw("\nClass named \""+
      s_class_name_in+"\" has not been loaded.\n"+
      "There does exist a possibility that if the current exception \n"+
      "were not thrown, it might be loaded after the \n"+
      "call to the function kibuvits_krl171_exc_class_name_2_cl(...).\n")
   end # if
   cl_out=@kibuvits_krl171_b_class_defined_cache_ht_objects[s_class_name_in]
   return cl_out
end # kibuvits_krl171_exc_class_name_2_cl

#--------------------------------------------------------------------------

# A similar function:
#
#     kibuvits_krl171_assert_ok_to_be_a_varname_t1(...)
#
def kibuvits_krl171_assert_does_not_contain_common_special_characters_t1(a_binding,s_in,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Binding, a_binding
      kibuvits_krl171_typecheck bn, String, s_in
      kibuvits_krl171_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   if kibuvits_krl171_b_contains_common_special_characters_t1(s_in)
      s_varname=kibuvits_krl171_s_varvalue2varname(a_binding,s_in)
      kibuvits_krl171_throw("\n"+s_varname+"==\""+s_in.to_s+
      "\"\ncontains at least one character that "+
      "is commonly used as a special character. \n",a_binding)
   end # if
end # kibuvits_krl171_assert_does_not_contain_common_special_characters_t1

#--------------------------------------------------------------------------

#def kibuvits_krl171_s_file_permissions_t1(s_fp)
#   if KIBUVITS_krl171_b_DEBUG
#      s_suffix="\nGUID='389210e3-ae00-4695-91e4-c2c2f051a4e7'"
#      bn=binding()
#      kibuvits_krl171_typecheck(bn,String,s_fp,s_suffix)
#      s_suffix="\nGUID='346f7a10-2b7c-4690-9284-c2c2f051a4e7'"
#      kibuvits_krl171_assert_string_min_length(bn,s_fp,1,s_suffix)
#   end # if
#
#   s_out=File.stat(s_fp).mode.to_s(8)[(-4)..(-1)]
#end # kibuvits_krl171_s_file_permissions_t1

#=========---KRL-selftests-infrastructure-start---=========================

# The .selftest methods depend on this function. This function is
# located here because the other 2 alternatives are more verbose.
# First alternative would be to "require" it in every .selftest method,
# which is redundant and the other alternative would be to "require"
# it from another file in here, which seems uselessly costly and verbose.
def kibuvits_krl171_testeval(a_binding,teststring)
   s_script="begin\n"+
   teststring+"\n"+
   "rescue Exception => e\n"+
   "    ar_msgs<<\""+teststring+": \\n\"+e.to_s\n"+
   "end # rescue\n"
   eval(s_script,a_binding)
end #kibuvits_krl171_testeval

# Returns a boolean value.
def kibuvits_krl171_block_throws
   answer=false;
   begin
      yield
   rescue Exception => e
      answer=true
   end # rescue
   return answer
end # kibuvits_krl171_block_throws

#=========---KRL-selftests-infrastructure-end-----=========================


#=====================kibuvits_krl171_boot_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_boot_rb_start".
#==========================================================================

#=====================kibuvits_krl171_ProgFTE_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_ProgFTE_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2009, martin.vahi@softf1.com that has an
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

------------------------------------------------------------------------

http://longterm.softf1.com/specifications/progfte/

The public API here resides at class Kibuvits_krl171_ProFTE. 

=end
#==========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE=false if !defined? KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE

#==========================================================================

# Implements the very first and fundamentally flawed ProgFTE specification,
# the ProgFTE_v0
class Kibuvits_krl171_ProgFTE_v0

   def initialize
      @b_kibuvits_krl171_bootfile_run=KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
   end #initialize


   def Kibuvits_krl171_ProgFTE_v0.selftest_failure(a,b)
      exc=Exception.new(a.to_s+b.to_s)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_throw(exc)
      else raise(exc)
      end # if
   end # Kibuvits_krl171_ProgFTE_v0.selftest_failure

   private

   # It's copy-pasted from the Kibuvits_krl171_str. The testing
   # code of it resides also there. The
   # dumb duplication is to eliminate the dependency.
   #
   # It returns an array of 2 elements. If the separator is not
   # found, the array[0]==input_string and array[1]=="".
   #
   # The ar_output is for array instance reuse and is expected
   # to increase speed a tiny bit at "snatching".
   def bisect(input_string, separator_string,ar_output=Array.new(2,""))
      i_separator_stringlen=separator_string.length
      if i_separator_stringlen==0
         exc=Exception.new("separator_string==\"\"")
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      ar=ar_output
      i=input_string.index(separator_string)
      if(i==nil)
         ar[0]=input_string
         ar[1]=""
         return ar;
      end # if
      if i==0
         ar[0]=""
      else
         ar[0]=input_string[0..(i-1)]
      end # if
      i_input_stringlen=input_string.length
      if (i+i_separator_stringlen)==i_input_stringlen
         ar[1]=""
      else
         ar[1]=input_string[(i+i_separator_stringlen)..(-1)]
      end # if
      return ar
   end # bisect

   # Returns an array of strings that contains only the snatched string pieces.
   def snatch_n_times_t1(haystack_string, separator_string,n)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_krl171_typecheck bn, String, haystack_string
         kibuvits_krl171_typecheck bn, String, separator_string
         kibuvits_krl171_typecheck bn, Fixnum, n
      end # if
      if(separator_string=="")
         exc=Exception.new("\nThe separator string had a "+
         "value of \"\", but empty strings are not "+
         "allowed to be used as separator strings.");
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      s_hay=haystack_string
      if s_hay.length==0
         exc=Exception.new("haystack_string.length==0")
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      # It's a bit vague, whether '' is also present at the
      # very end and very start of the string or only between
      # characters. That's why there's a limitation, that the
      # separator_string may not equal with the ''.
      if separator_string.length==0
         exc=Exception.new("separator_string.length==0")
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      s_hay=""+haystack_string
      ar=Array.new
      ar1=Array.new(2,"")
      n.times do |i|
         ar1=bisect(s_hay,separator_string,ar1)
         ar<<ar1[0]
         s_hay=ar1[1]
         if (s_hay=='') and ((i+1)<n)
            exc=Exception.new("Expected number of separators is "+n.to_s+
            ", but the haystack_string contained only "+(i+1).to_s+
            "separator strings.")
            if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
               kibuvits_krl171_throw(exc)
            else
               raise(exc)
            end # if
         end # if
      end # loop
      return ar;
   end # snatch_n_times_t1

   public
   def ht_to_s(a_hashtable)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_typecheck binding(), Hash, a_hashtable
      end # if
      s=""
      a_hashtable.keys.each do |a_key|
         s=s+a_key.to_s
         s=s+(a_hashtable[a_key].to_s) # Ruby 1.9. bug workaround
      end # loop
      return s;
   end # ht_to_s

   def Kibuvits_krl171_ProgFTE_v0.ht_to_s(a_hashtable)
      s=Kibuvits_krl171_ProgFTE_v0.instance.ht_to_s(a_hashtable)
      return s;
   end # Kibuvits_krl171_ProgFTE_v0.ht_to_s

   def create_nonexisting_needle(haystack_string)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_typecheck binding(), String, haystack_string
      end # if
      n=0
      s_needle='^0'
      while haystack_string.include? s_needle do
         n=n+1;
         s_needle='^'+n.to_s
      end # loop
      return s_needle
   end # create_nonexisting_needle

   def Kibuvits_krl171_ProgFTE_v0.create_nonexisting_needle(haystack_string)
      s_needle=Kibuvits_krl171_ProgFTE_v0.instance.create_nonexisting_needle(
      haystack_string)
      return s_needle
   end # Kibuvits_krl171_ProgFTE_v0.create_nonexisting_needle

   public
   def from_ht(a_hashtable)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_typecheck binding(), Hash, a_hashtable
      end # if
      ht=a_hashtable
      s_subst=create_nonexisting_needle(self.ht_to_s(ht))
      s_progfte=''+ht.size.to_s+'|||'+s_subst+'|||'
      s_key=''; s_value=''; # for a possible, slight, speed improvement
      ht.keys.each do |key|
         a_key=key.to_s # Ruby 1.9 bug workaround
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_krl171_typecheck binding(), String, a_key
         end # if
         s_key=a_key.gsub('|',s_subst)
         s_value=(ht[a_key]).to_s
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            kibuvits_krl171_typecheck binding(), String, s_value
         end # if
         s_value=s_value.gsub('|',s_subst)
         s_progfte=s_progfte+s_key+'|||'+s_value+'|||'
      end # loop
      return s_progfte
   end # from_ht

   def Kibuvits_krl171_ProgFTE_v0.from_ht(a_hashtable)
      s_progfte=Kibuvits_krl171_ProgFTE_v0.instance.from_ht(a_hashtable)
      return s_progfte
   end # Kibuvits_krl171_ProgFTE_v0.from_ht

   public
   def to_ht(a_string)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_typecheck binding(), String, a_string
      end # if
      ar=bisect(a_string,'|||')
      tf='Kibuvits_krl171_ProgFTE_v0.to_ht'
      Kibuvits_krl171_ProgFTE_v0.selftest_failure(tf,1) if ar[1]==""
      n=Integer(ar[0])
      s_subst=''
      err_no=2
      ht=Hash.new
      begin
         ar1=bisect(ar[1],'|||')
         s_subst=ar1[0]
         err_no=3
         Kibuvits_krl171_ProgFTE_v0.selftest_failure(tf,err_no) if s_subst==''
         err_no=4
         # ar1[1]=='', if n==0 and it's legal in here
         ar=snatch_n_times_t1(ar1[1],'|||',n*2) if 0<n
         err_no=5
         n.times do |x|
            key=ar[x*2].gsub(s_subst,'|')
            value=(ar[x*2+1]).gsub(s_subst,'|')
            ht[key]=value
         end # loop
      rescue Exception => e
         Kibuvits_krl171_ProgFTE_v0.selftest_failure(tf.to_s+e.to_s,err_no)
      end # try-catch
      return ht
   end # to_ht

   def Kibuvits_krl171_ProgFTE_v0.to_ht(a_string)
      ht=Kibuvits_krl171_ProgFTE_v0.instance.to_ht(a_string)
      return ht
   end # Kibuvits_krl171_ProgFTE_v0.to_ht

   public
   include Singleton

end #class Kibuvits_krl171_ProgFTE_v0

#--------------------------------------------------------------------------

class Kibuvits_krl171_ProgFTE_v1

   def initialize
      @lc_s_pillar="|".freeze
      @lc_s_v1__pillar_format_mode_0_pillar="v1|0|".freeze
      @lc_s_const_1="|0||0||".freeze
      @lc_s_emptystring="".freeze
   end #initialize

   def kibuvits_krl171_progfte_throw(msg)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_throw(msg)
      else
         throw(Exception.new(msg))
      end # if
   end # kibuvits_krl171_progfte_throw


   def Kibuvits_krl171_ProgFTE_v1.kibuvits_krl171_progfte_throw(msg)
      Kibuvits_krl171_ProgFTE_v1.instance.kibuvits_krl171_progfte_throw(msg)
   end # Kibuvits_krl171_ProgFTE_v1.selftest_failure

   #--------------------------------------------------------------------------

   private

   def kibuvits_krl171_progfte_kibuvits_krl171_s_concat_array_of_strings_watershed(ar_in)
      if defined? KIBUVITS_krl171_b_DEBUG
         if KIBUVITS_krl171_b_DEBUG
            bn=binding()
            kibuvits_krl171_typecheck bn, Array, ar_in
         end # if
      end # if
      i_n=ar_in.size
      if i_n<3
         if i_n==2
            s_out=ar_in[0]+ar_in[1]
            return s_out
         else
            if i_n==1
               # For the sake of consistency one
               # wants to make sure that the returned
               # string instance always differs from those
               # that are within the ar_in.
               s_out=@lc_s_emptystring+ar_in[0]
               return s_out
            else # i_n==0
               s_out=@lc_s_emptystring
               return s_out
            end # if
         end # if
      end # if
      s_out=@lc_s_emptystring # needs to be inited to the ""

      # The classic part for testing and playing.
      # ar_in.size.times{|i| s_out=s_out+ar_in[i]}
      # return s_out

      # In its essence the rest of the code here implements
      # a tail-recursive version of this function. The idea is that
      #
      # s_out='something_very_long'.'short_string_1'.short_string_2'
      # uses a temporary string of length
      # 'something_very_long'.'short_string_1'
      # but
      # s_out='something_very_long'.('short_string_1'.short_string_2')
      # uses a much more CPU-cache friendly temporary string of length
      # 'short_string_1'.short_string_2'
      #
      # Believe it or not, but as of January 2012 the speed difference
      # in PHP can be at least about 20% and in Ruby about 50%.
      # Please do not take my word on it. Try it out yourself by
      # modifying this function and assembling strings of length
      # 10000 from single characters.
      #
      # This here is probably not the most optimal solution, because
      # within the more optimal solution the the order of
      # "concatenation glue placements" depends on the lengths
      # of the tokens/strings, but as the analysis and "gluing queue"
      # assembly also has a computational cost, the version
      # here is almost always more optimal than the totally
      # naive version.
      ar_1=ar_in
      b_ar_1_equals_ar_in=true # to avoid modifying the received Array
      ar_2=Array.new
      b_take_from_ar_1=true
      b_not_ready=true
      i_reminder=nil
      i_loop=nil
      i_ar_in_len=nil
      i_ar_out_len=0 # code after the while loop needs a number
      s_1=nil
      s_2=nil
      s_3=nil
      i_2=nil
      while b_not_ready
         # The next if-statement is to avoid copying temporary
         # strings between the ar_1 and the ar_2.
         if b_take_from_ar_1
            i_ar_in_len=ar_1.size
            i_reminder=i_ar_in_len%2
            i_loop=(i_ar_in_len-i_reminder)/2
            i_loop.times do |i|
               i_2=i*2
               s_1=ar_1[i_2]
               s_2=ar_1[i_2+1]
               s_3=s_1+s_2
               ar_2<<s_3
            end # loop
            if i_reminder==1
               s_3=ar_1[i_ar_in_len-1]
               ar_2<<s_3
            end # if
            i_ar_out_len=ar_2.size
            if 1<i_ar_out_len
               if b_ar_1_equals_ar_in
                  ar_1=Array.new
                  b_ar_1_equals_ar_in=false
               else
                  ar_1.clear
               end # if
            else
               b_not_ready=false
            end # if
         else # b_take_from_ar_1==false
            i_ar_in_len=ar_2.size
            i_reminder=i_ar_in_len%2
            i_loop=(i_ar_in_len-i_reminder)/2
            i_loop.times do |i|
               i_2=i*2
               s_1=ar_2[i_2]
               s_2=ar_2[i_2+1]
               s_3=s_1+s_2
               ar_1<<s_3
            end # loop
            if i_reminder==1
               s_3=ar_2[i_ar_in_len-1]
               ar_1<<s_3
            end # if
            i_ar_out_len=ar_1.size
            if 1<i_ar_out_len
               ar_2.clear
            else
               b_not_ready=false
            end # if
         end # if
         b_take_from_ar_1=!b_take_from_ar_1
      end # loop
      if i_ar_out_len==1
         if b_take_from_ar_1
            s_out=ar_1[0]
         else
            s_out=ar_2[0]
         end # if
      else
         # The s_out has been inited to "".
         if 0<i_ar_out_len
            raise Exception.new("This function is flawed.")
         end # if
      end # if
      return s_out
   end # kibuvits_krl171_progfte_kibuvits_krl171_s_concat_array_of_strings_watershed

   def kibuvits_krl171_progfte_s_concat_array_of_strings(ar_in)
      s_out=kibuvits_krl171_progfte_kibuvits_krl171_s_concat_array_of_strings_watershed(ar_in)
      return s_out
   end # kibuvits_krl171_progfte_s_concat_array_of_strings(ar_in)

   public

   def Kibuvits_krl171_ProgFTE_v1.kibuvits_krl171_progfte_s_concat_array_of_strings(ar_in)
      s_out=Kibuvits_krl171_ProgFTE_v1.instance.kibuvits_krl171_progfte_s_concat_array_of_strings(ar_in)
      return s_out
   end # kibuvits_krl171_progfte_s_concat_array_of_strings(ar_in)

   private

   # That includes all points, minus signs, etc.
   def i_number_of_characters(x_in)
      i_out=x_in.to_s.length
      return i_out
   end # i_number_of_characters

   # That's the <stringrecord> part in the ProgFTE_v1 spec,
   # http://longterm.softf1.com/specifications/progfte/
   def append_stringrecord(ar_s,s_in)
      ar_s<<s_in.length.to_s
      ar_s<<@lc_s_pillar
      ar_s<<s_in
      ar_s<<@lc_s_pillar
   end # append_stringrecord

   def append_header_format_mode_0(ar_s,ht_in)
      # The very first key-value pair always exists and
      # it is reserved for the metadata.
      s_n_of_pairs=(ht_in.size+1).to_s
      #-----------------------------------------
      # v1|0|<number_of_key-value_pairs>|0||0||
      #-----------------------------------------
      ar_s<<@lc_s_v1__pillar_format_mode_0_pillar
      ar_s<<s_n_of_pairs
      ar_s<<@lc_s_const_1
   end # append_header_format_mode_0

   public

   def from_ht(ht_in)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_in
      end # if
      ar_s=Array.new
      append_header_format_mode_0(ar_s,ht_in)
      ht_in.each do |s_key,s_value|
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            if KIBUVITS_krl171_b_DEBUG
               bn=binding()
               kibuvits_krl171_typecheck bn, String, s_key
               kibuvits_krl171_typecheck bn, String, s_value
            end # if
         end # if
         append_stringrecord(ar_s,s_key)
         append_stringrecord(ar_s,s_value)
      end # loop
      s_progfte=kibuvits_krl171_progfte_s_concat_array_of_strings(ar_s)
      ar_s.clear # May be it helps the garbage collector a bit.
      return s_progfte
   end # from_ht

   def Kibuvits_krl171_ProgFTE_v1.from_ht(a_hashtable)
      s_progfte=Kibuvits_krl171_ProgFTE_v1.instance.from_ht(a_hashtable)
      return s_progfte
   end # Kibuvits_krl171_ProgFTE_v1.from_ht

   private

   def i_i_read_intpillar(s_in,ixs_low,rgx_int_pillar)
      md=s_in.match(rgx_int_pillar,ixs_low)
      if md==nil
         msg="\nEither The ProgFTE string candidate does not conform to "+
         "the ProgFTE_v1 specification or the code is faulty. \n"+
         "Reading of a token /[\d]+[|]/ failed.\n"+
         "GUID='6909ef2c-6c43-4237-b524-c2c2f051a4e7'\n"+
         "ixs_low=="+ixs_low.to_s+
         "\ns_in=="+s_in+"\n"
         kibuvits_krl171_progfte_throw(msg)
      end # if
      s_int=(md[0])[0..(-2)]
      ixs_low=ixs_low+s_int.length+1 # +1 is due to the [|]
      i_out=s_int.to_i
      return i_out, ixs_low
   end # i_i_read_intpillar

   def i_s_parse_stringrecord(s_progfte,ixs_low,rgx_int_pillar)
      # <stringrecord>  ::=  <si_string_length>[|].*[|]
      i_len, ixs_low=i_i_read_intpillar(s_progfte,ixs_low,rgx_int_pillar)
      s_out=@lc_s_emptystring
      if 0<i_len
         i_highminusone=ixs_low+i_len-1
         s_out=s_progfte[ixs_low..i_highminusone]
      end # if
      ixs_low=ixs_low+i_len+1 # +1 is due to the [|]
      return ixs_low, s_out
   end # i_s_parse_stringrecord

   def i_parse_keyvalue_pair(ht_in,s_progfte,ixs_low,rgx_int_pillar)
      ixs_1=ixs_low
      ixs_1, s_key=i_s_parse_stringrecord(s_progfte,ixs_1,rgx_int_pillar)
      ixs_1, s_value=i_s_parse_stringrecord(s_progfte,ixs_1,rgx_int_pillar)
      ht_in[s_key]=s_value
      return ixs_1
   end # i_parse_keyvalue_pair

   def ht_parse_header(s_progfte_v1_candidate,ht_opmem)
      rgx_int_pillar=ht_opmem["rgx_int_pillar"]
      s_in=s_progfte_v1_candidate
      # http://longterm.softf1.com/specifications/progfte/
      # v<ProgFTE_format_version>[|]<ProgFTE_format_mode>[|]<number_of_key-value_pairs>[|](<key-value_pair>)+
      md=s_in.match(/^v[\d]+[|][\d]+[|][\d]+[|]/)
      if md==nil
         msg="\nThe ProgFTE string candidate does not conform to "+
         "the ProgFTE_v1 specification.\n"+
         "GUID='498e39f1-06d7-433b-83c3-c2c2f051a4e7'\n"+
         "s_progfte_v1_candidate=="+s_progfte_v1_candidate+"\n"
         kibuvits_krl171_progfte_throw(msg)
      end # if
      ht_header=Hash.new
      s_header=md[0]
      # v1|<ProgFTE_format_mode>|
      # 012
      ixs_low=3
      i_format_mode, ixs_low=i_i_read_intpillar(s_header,ixs_low,rgx_int_pillar)
      ht_header["i_format_mode"]=i_format_mode
      i_n_of_pairs, ixs_low=i_i_read_intpillar(s_header,ixs_low,rgx_int_pillar)
      ht_header["i_n_of_pairs"]=i_n_of_pairs

      ht=Hash.new
      ixs_low=i_parse_keyvalue_pair(ht,s_in,ixs_low,rgx_int_pillar)
      s_metadata=ht[@lc_s_emptystring]
      if s_metadata==nil
         msg="\nThe ProgFTE string candidate does not conform to "+
         "the ProgFTE_v1 specification.\n"+
         "According to the ProgFTE_v1 specification the "+
         "very first key-value pair is reserved for encoding related\n"+
         "metadata and its key must be an empty string, but "+
         "extraction of the metadata from the very first key-value pair failed.\n"+
         "GUID='61c92bba-5234-4b19-b663-c2c2f051a4e7'\n"+
         "ixs_low=="+ixs_low.to_s+
         "\ns_progfte_v1_candidate=="+s_progfte_v1_candidate+"\n"
         kibuvits_krl171_progfte_throw(msg)
      end # if
      ht_header["s_metadata"]=s_metadata
      ht_opmem["ixs_low"]=ixs_low
      ht_opmem["ht_header"]=ht_header
      return ht_header
   end # ht_parse_header

   public
   def to_ht(s_progfte)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         kibuvits_krl171_typecheck binding(), String, s_progfte
      end # if
      rgx_int_pillar=/[\d]+[|]/ # widely used, but can not be global due to thread safety
      ht_opmem=Hash.new
      ht_opmem["rgx_int_pillar"]=rgx_int_pillar
      ht_header=ht_parse_header(s_progfte,ht_opmem)
      ixs_low=ht_opmem["ixs_low"]
      ht_out=Hash.new
      begin
         i_n_of_pairs=ht_header["i_n_of_pairs"]-1 # -1 is due to the metadata keyvalue pair
         i_n_of_pairs.times do
            ixs_low=i_parse_keyvalue_pair(ht_out,s_progfte,ixs_low,rgx_int_pillar)
         end # loop
      rescue Exception => e
      end # try-catch
      return ht_out
   end # to_ht

   def Kibuvits_krl171_ProgFTE_v1.to_ht(s_progfte)
      ht=Kibuvits_krl171_ProgFTE_v1.instance.to_ht(s_progfte)
      return ht
   end # Kibuvits_krl171_ProgFTE_v1.to_ht

   public
   include Singleton

end #class Kibuvits_krl171_ProgFTE_v1


#--------------------------------------------------------------------------
# The ProgFTE is a text format for serializing hashtables that
# contain only strings and use only strings for keys. The
# ProgFTE stands for Programmer Friendly text Exchange.
#
# Specifications reside at:
# http://longterm.softf1.com/specifications/progfte/
#
# This implementation has a full support for ProgFTE_v0 and ProgFTE_v1
class Kibuvits_krl171_ProgFTE

   def initialize
   end #initialize

   private
   def kibuvits_krl171_progfte_throw(msg)
      Kibuvits_krl171_ProgFTE_v1.kibuvits_krl171_progfte_throw(msg)
   end # kibuvits_krl171_progfte_throw

   public
   def from_ht(ht_in, i_specification_version=1)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_in
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_specification_version
         kibuvits_krl171_assert_is_among_values(bn,[0,1],i_specification_version)
      end # if
      s_progfte=nil
      if(i_specification_version==1)
         s_progfte=Kibuvits_krl171_ProgFTE_v1.from_ht(ht_in)
      else
         if(i_specification_version==0)
            s_progfte=Kibuvits_krl171_ProgFTE_v0.from_ht(ht_in)
         else
            msg="\nThis implementation does not yet support the ProgFTE_v"+
            i_specification_version.to_s
            "\n GUID='47b8d023-c75b-491c-b103-c2c2f051a4e7'\n"
            kibuvits_krl171_progfte_throw(msg)
         end # if
      end # if
      return s_progfte;
   end # from_ht

   def Kibuvits_krl171_ProgFTE.from_ht(ht_in, i_specification_version=1)
      s_progfte=Kibuvits_krl171_ProgFTE.instance.from_ht(ht_in,i_specification_version)
      return s_progfte;
   end # Kibuvits_krl171_ProgFTE.from_ht

   public
   def to_ht(s_in)
      if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_assert_string_min_length(bn,s_in,3,
         " GUID='4b66083b-4a2f-4d27-84a2-c2c2f051a4e7'\n")
      end # if
      ht_out=nil
      begin
         md=s_in.match(/^v[\d]+[|]/)
         if md!=nil
            if md[0]=="v1|"
               ht_out=Kibuvits_krl171_ProgFTE_v1.to_ht(s_in)
            else
               if md[0]=="v0|"
                  msg="\nStrings that conform to version 0 of the "+
                  "ProgFTE format specification \n"+
                  "start with a digit, not a character.\n"
                  "GUID='ffec831e-02fe-4c10-a342-c2c2f051a4e7'\n"+
                  "s_in=="+s_in+"\n"
                  kibuvits_krl171_progfte_throw(msg)
               else
                  msg="\nThis implementation does not yet "+
                  "support the ProgFTE_v"+md[0][1..-1]+
                  "\n GUID='ba0ad045-8012-4ec1-ace1-c2c2f051a4e7'\n"+
                  "s_in=="+s_in+"\n"
                  kibuvits_krl171_progfte_throw(msg)
               end # if
            end # if
         else
            md=s_in.match(/^[\d]+[|]/)
            if md==nil
               msg="\nProgFTE string candidate does not conform to any "+
               "ProgFTE specification, where \nthe format version "+
               "is greater than 0, but the ProgFTE string "+
               "candidate does not \nconform to ProgFTE_v0 either.\n "+
               "GUID='3a8b5519-2595-42b2-b381-c2c2f051a4e7'\n"+
               "s_in=="+s_in+"\n"
               kibuvits_krl171_progfte_throw(msg)
            end # if
            ht_out=Kibuvits_krl171_ProgFTE_v0.to_ht(s_in)
         end # if
      rescue Exception => e
         msg="\nProgFTE string candidate deserialization failed. \n"+
         "GUID='1b5eb619-4389-472d-b121-c2c2f051a4e7'\n"+e.to_s+"\n"
         kibuvits_krl171_progfte_throw(msg)
      end # try-catch
      return ht_out
   end # to_ht

   def Kibuvits_krl171_ProgFTE.to_ht(s_in)
      ht_out=Kibuvits_krl171_ProgFTE.instance.to_ht(s_in)
      return ht_out
   end # Kibuvits_krl171_ProgFTE.to_ht

   public
   include Singleton

end #class Kibuvits_krl171_ProgFTE

#==========================================================================
# Sample code:
#    ht=Hash.new
#    ht['Welcome']='to hell'
#    ht['with XML']='we all go'
#    s_progfte=Kibuvits_krl171_ProgFTE.from_ht(ht)
#    ht.clear
#    ht2=Kibuvits_krl171_ProgFTE.to_ht(s_progfte)
#    kibuvits_krl171_writeln ht2['Welcome']
#    kibuvits_krl171_writeln ht2['with XML']

#=====================kibuvits_krl171_ProgFTE_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_ProgFTE_rb_start".
#==========================================================================

#=====================kibuvits_krl171_msgc_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_msgc_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

# The "included" const. has to be before the "require" clauses
# to be available, when the code within the require clauses probes for it.
KIBUVITS_krl171_MSGC_INCLUDED=true if !defined? KIBUVITS_krl171_MSGC_INCLUDED

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_GUID_generator.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ProgFTE.rb"

#==========================================================================
# msgc stands for "msg container", where "msg" stands for "message".
#
# Messages, including error messages, are often just strings,
# often written only in one language, usually English. The Kibuvits_krl171_msgc is
# meant to bundle different language versions of the messages
# together and it also bundles a message code with the strings, thus
# simplifying the implementation of message specific control flow.
#
# If a message in a given language is not available, a default
# version is returned. The Kibuvits_krl171_msgc is meant to be used in
# conjunction with the Kibuvits_krl171_msgc_stack.
class Kibuvits_krl171_msgc
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


   def initialize(s_default_msg=$kibuvits_krl171_lc_emptystring,s_message_id="message code not set",
      b_failure=true,s_default_language=$kibuvits_krl171_lc_English,
      s_location_marker_GUID=$kibuvits_krl171_lc_emptystring)
      @fdr_instantiation_timestamp=Time.now.to_r
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_default_msg
         kibuvits_krl171_typecheck bn, String, s_message_id
         kibuvits_krl171_typecheck bn, [TrueClass, FalseClass], b_failure
         kibuvits_krl171_typecheck bn, String, s_default_language
         kibuvits_krl171_assert_string_min_length(bn,s_default_language,2,
         "\nGUID='d4291e39-8727-424c-81c0-c2c2f051a4e7'")
      end # if
      @s_instance_id="msgc_"+Kibuvits_krl171_wholenumberID_generator.generate.to_s+"_"+
      Kibuvits_krl171_GUID_generator.generate_GUID
      @s_default_language=$kibuvits_krl171_lc_emptystring+s_default_language
      @ht_msgs=Hash.new
      @ht_msgs[@s_default_language]=($kibuvits_krl171_lc_emptystring+
      s_default_msg).freeze
      @s_message_id=s_message_id.freeze
      @b_failure=b_failure
      @mx=Mutex.new
      @ob_instantiation_time=Time.now
      @x_data=nil

      @s_location_marker_GUID=s_location_marker_GUID.freeze
      if @s_location_marker_GUID!=$kibuvits_krl171_lc_emptystring
         rgx=Regexp.new($kibuvits_krl171_lc_GUID_regex_core_t1)
         md_candidate=@s_location_marker_GUID.match(rgx)
         if md_candidate==nil
            kibuvits_krl171_throw("\nThe s_location_marker_GUID(=="+
            s_location_marker_GUID+")\nis not a GUID."+
            "\nCurrent exception location GUID=='7859dfa4-6b93-449d-9290-c2c2f051a4e7'\n\n");
         end # if
      end # if
   end #initialize

   public

   def b_failure=(b_value)
      bn=binding()
      kibuvits_krl171_typecheck bn, [TrueClass, FalseClass], b_value
      @mx.synchronize do
         break if @b_failure==b_value
         @b_failure=b_value
      end # synchronize
   end # b_failure=

   def to_s(s_language=nil)
      # The "s_language=nil" in the input parameters list is due to the
      # Kibuvits_krl171_msgc_stack to_s implementation
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), [NilClass,String], s_language
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
      return $kibuvits_krl171_lc_emptystring+s # The "" is to avoid s.downcase!
   end # to_s

   #-----------------------------------------------------------------------

   # Throws, if self.b_failure==true
   def assert_lack_of_failures(s_optional_error_message_suffix=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [NilClass,String], s_optional_error_message_suffix
      end # if
      if b_failure
         s_msg=$kibuvits_krl171_lc_linebreak+to_s()+$kibuvits_krl171_lc_linebreak
         if s_optional_error_message_suffix.class==String
            s_msg<<(s_optional_error_message_suffix+$kibuvits_krl171_lc_linebreak)
         end # if
         kibuvits_krl171_throw(s_msg)
      end # if
   end # assert_lack_of_failures

   #-----------------------------------------------------------------------

   def [](s_language)
      s=self.to_s s_language
      return s
   end # []


   def []=(s_language, s_message)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_language
         kibuvits_krl171_typecheck bn, String, s_message
      end # if
      @ht_msgs[$kibuvits_krl171_lc_emptystring+s_language]=$kibuvits_krl171_lc_emptystring+
      s_message # The "" is to avoid s.downcase!
      return nil
   end # []=

   #-----------------------------------------------------------------------

   # Creates a new Kibuvits_krl171_msgc instance that has the same message values and
   # s_message_id value, but a different s_instance_id.
   #
   # To clone a Kibuvits_krl171_msgc instance so that the s_instance_id of a
   # clone matches that of the original, one should serialize the original
   # and then instantiate the clone by using deserialization.
   def clone
      x_out=Kibuvits_krl171_msgc.new(@ht_msgs[@s_default_language],
      @s_message_id, @b_failure, @s_default_language)
      @ht_msgs.each_pair {|s_language,s_msg| x_out[s_language]=s_msg}
      x_out.instance_variable_set(:@x_data,@x_data)
      return x_out
   end # clone

   #-----------------------------------------------------------------------

   def s_message_id
      s_out=$kibuvits_krl171_lc_emptystring+@s_message_id
      return s_out
   end # s_message_id

   def s_message_id=(s_whatever_string)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_whatever_string
      end # if
      @s_message_id=$kibuvits_krl171_lc_emptystring+s_whatever_string
      return nil
   end # s_message_id

   #-----------------------------------------------------------------------

   def x_data
      x_out=nil
      if @x_data.class==String
         x_out=$kibuvits_krl171_lc_emptystring+@x_data
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
         ht["x_data"]=$kibuvits_krl171_lc_emptystring
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
         s_ht_msgs_progfte=Kibuvits_krl171_ProgFTE.from_ht(@ht_msgs)
      end # synchronize
      ht["s_ht_msgs_progfte"]=s_ht_msgs_progfte
      s_instance_progfte=Kibuvits_krl171_ProgFTE.from_ht(ht)
      ht_container=Hash.new
      ht_container[$kibuvits_krl171_lc_s_version]=@@s_version
      ht_container[$kibuvits_krl171_lc_s_type]="Kibuvits_krl171_msgc"
      ht_container[$kibuvits_krl171_lc_s_serialized]=s_instance_progfte
      s_progfte=Kibuvits_krl171_ProgFTE.from_ht(ht_container)
      return s_progfte
   end # s_serialize

   #-----------------------------------------------------------------------

   private

   # Returns a Kibuvits_krl171_msgc instance
   def ob_deserialize(s_progfte)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String,s_progfte
      end # if
      ht_container=Kibuvits_krl171_ProgFTE.to_ht(s_progfte)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         $kibuvits_krl171_lc_s_serialized=$kibuvits_krl171_lc_s_serialized.freeze
         kibuvits_krl171_assert_ht_has_keys(bn,ht_container,
         [$kibuvits_krl171_lc_s_version,$kibuvits_krl171_lc_s_type,$kibuvits_krl171_lc_s_serialized])
      end # if
      s_version=ht_container[$kibuvits_krl171_lc_s_version]
      if s_version!=@@s_version
         kibuvits_krl171_throw("s_version=="+s_version.to_s+
         ", but \""+@@s_version+"\" is expected.")
      end # if
      s_type=ht_container[$kibuvits_krl171_lc_s_type]
      if s_type!="Kibuvits_krl171_msgc"
         kibuvits_krl171_throw("s_type=="+s_type.to_s+", but "+
         "\"Kibuvits_krl171_msgc\" is expected.")
      end # if
      s_serialized=ht_container[$kibuvits_krl171_lc_s_serialized]
      ht=Kibuvits_krl171_ProgFTE.to_ht(s_serialized)
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
         if kibuvits_krl171_b_class_defined? x_data_class
            if x_data_class=="String"
               x_data=s_x_data_serialized
            else
               cl=kibuvits_krl171_exc_class_name_2_cl(x_data_class)
               if cl.respond_to? "ob_deserialize"
                  x_data=cl.ob_deserialize
               else
                  if KIBUVITS_krl171_b_DEBUG
                     kibuvits_krl171_throw("Deserialization of an "+
                     "instance of the "+self.class.to_s+" failed, because the class "+
                     x_data_class +" is defined, but it does not have a method named "+
                     "ob_deserialize.\n"+
                     "GUID='46508cd8-5536-49bf-a460-c2c2f051a4e7'\n\n")
                  end # if
               end # if
            end # if
         else
            if KIBUVITS_krl171_b_DEBUG
               kibuvits_krl171_throw("During the deserialization of an "+
               "instance of the "+self.class.to_s+" the serialized version lists "+
               x_data_class +" as the class of the field \"x_data\", but "+
               "the current application instance does not have a class with that "+
               "name defined.\n"+
               "GUID='5e21a5fb-e6f0-45c8-b430-c2c2f051a4e7'\n\n")
            end # if
         end # if
      end # if
      msgc.instance_variable_set(:@x_data,x_data)
      #-------------
      msgc.instance_variable_set(:@s_default_language,ht["s_default_language"])
      ht_msgs=Kibuvits_krl171_ProgFTE.to_ht(ht["s_ht_msgs_progfte"])
      msgc.instance_variable_set(:@ht_msgs,ht_msgs)
      return msgc
   end # ob_deserialize

   public

   def Kibuvits_krl171_msgc.ob_deserialize(s_progfte)
      msgc=Kibuvits_krl171_msgc.new
      msgc.send(:ob_deserialize,s_progfte)
      return msgc
   end # Kibuvits_krl171_msgc.ob_deserialize

   #-----------------------------------------------------------------------

   private

   # Only to be used as a private method and with care
   # taken to make sure that the returned hashtable instance, nor
   # its elements, are modified.
   #
   # The implementation of the
   # Kibuvits_krl171_msgc_stack.insert_originedited_msgc_or_msgcs
   # explains the use of this method.
   def get_ht_instance_ids
      ht=@@lc_ht_empty_and_frozen
      return ht # There are no sub-instances within the msgc
   end # get_ht_instance_ids

end # class Kibuvits_krl171_msgc

#--------------------------------------------------------------------------
# The Kibuvits_krl171_msgc_stack partly mimics an Array that accepts only
# elements that are of type Kibuvits_krl171_msgc.
class Kibuvits_krl171_msgc_stack

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
      @s_instance_id="msgcs_"+Kibuvits_krl171_wholenumberID_generator.generate.to_s+"_"+
      Kibuvits_krl171_GUID_generator.generate_GUID
      @mx=Mutex.new
      @ob_instantiation_time=Time.now
   end #initialize

   # b_failure of the stack is a disjunction of its elements'
   # b_failure fields.
   def b_failure
      # The reason, why it's a recursive method
      # in stead of an instance variable is that the
      # Kibuvits_krl171_msgc instances that reside within some
      # Kibuvits_krl171_msgc_stack instance that is an element of
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
   # Kibuvits_krl171_msgc_stack.insert_originedited_msgc_or_msgcs
   # explains the use of this method.
   def get_ht_instance_ids
      return @ht_element_ids
   end # get_ht_instance_ids

   def insert_originedited_msgc_or_msgcs(msgc_or_msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Kibuvits_krl171_msgc,Kibuvits_krl171_msgc_stack], msgc_or_msgcs
      end # if
      s_instance_id=msgc_or_msgcs.s_instance_id
      @mx.synchronize do
         # Actually the checks here covers all of the cyclic dependencies and subbranches.
         if @ht_element_ids.has_key? s_instance_id
            kibuvits_krl171_throw("The Kibuvits_krl171_msgc_stack accepts each element only once, but "+
            "there is an attempt to insert an instance with an ID of "+
            s_instance_id+" more than once. ")
         end # if
         @ht_element_ids[s_instance_id]=s_instance_id
         # The ht_instance_ids_in=msgc_or_msgcs.send(:get_ht_instance_ids)
         # is used in stead of the
         # msgc_or_msgcs.get_ht_instance_ids() due to the fact that the
         # get_ht_instance_ids is an implementation specific method,
         # i.e. a private method, and it's also private within
         # the Kibuvits_krl171_msgc, which != self.class in this scope.
         ht_instance_ids_in=msgc_or_msgcs.send(:get_ht_instance_ids)
         ht_instance_ids_in.each_value do |s_subinstance_id|
            if @ht_element_ids.has_key? s_subinstance_id
               kibuvits_krl171_throw("The Kibuvits_krl171_msgc_stack with an instance ID of "+
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
      kibuvits_krl171_typecheck bn, [Kibuvits_krl171_msgc,Kibuvits_krl171_msgc_stack], msgc_or_msgcs
      insert_originedited_msgc_or_msgcs(msgc_or_msgcs)
   end # <<

   def push(msgc_or_msgcs)
      self << msgc_or_msgcs
   end # push(msgc_or_msgcs)


   # Adds a Kibuvits_krl171_msgc instance to the stack. Arguments match with
   # the Kibuvits_krl171_msgc constructor arguments.
   def cre(s_default_msg=$kibuvits_krl171_lc_emptystring,
      s_message_id="message code not set",
      b_failure=true,s_location_marker_GUID=$kibuvits_krl171_lc_emptystring,
      s_default_language=$kibuvits_krl171_lc_English)
      msgc=Kibuvits_krl171_msgc.new(s_default_msg,s_message_id,b_failure,
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
            ht_elem_container[$kibuvits_krl171_lc_s_type]=msgc_or_msgcs.class.to_s
            ht_elem_container[$kibuvits_krl171_lc_s_serialized]=msgc_or_msgcs.s_serialize
            ht_elems[i.to_s]=Kibuvits_krl171_ProgFTE.from_ht(ht_elem_container)
            ht_elem_container.clear
         end # loop
      end # synchronize
      ht_elems["si_number_of_elements"]=i_number_of_elements.to_s
      ht_instance=Hash.new
      ht_instance["s_ht_elems_progfte"]=Kibuvits_krl171_ProgFTE.from_ht(ht_elems)
      ht_instance["sfdr_instantiation_timestamp"]=@fdr_instantiation_timestamp.to_s
      ht_instance["s_instance_id"]=@s_instance_id
      ht_instance["s_ht_element_ids_progfte"]=Kibuvits_krl171_ProgFTE.from_ht(@ht_element_ids)
      ht_container=Hash.new
      ht_container[$kibuvits_krl171_lc_s_version]=@@s_version
      ht_container[$kibuvits_krl171_lc_s_type]="Kibuvits_krl171_msgc_stack"
      ht_container[$kibuvits_krl171_lc_s_serialized]=Kibuvits_krl171_ProgFTE.from_ht(ht_instance)
      s_progfte=Kibuvits_krl171_ProgFTE.from_ht(ht_container)
      return s_progfte
   end # s_serialize

   #-----------------------------------------------------------------------

   private

   # Returns a Kibuvits_krl171_msgc_stack instance
   def ob_deserialize(s_progfte)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_progfte
      end # if
      lc_s_Kibuvits_krl171_msgc="Kibuvits_krl171_msgc".freeze
      lc_s_Kibuvits_krl171_msgc_stack="Kibuvits_krl171_msgc_stack".freeze
      ht_container=Kibuvits_krl171_ProgFTE.to_ht(s_progfte)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ht_has_keys(bn,ht_container,
         [$kibuvits_krl171_lc_s_version,$kibuvits_krl171_lc_s_type,$kibuvits_krl171_lc_s_serialized])
      end # if
      s_version=ht_container[$kibuvits_krl171_lc_s_version]
      if s_version!=@@s_version
         kibuvits_krl171_throw("s_version=="+s_version.to_s+
         ", but \""+@@s_version+"\" is expected.")
      end # if
      s_type=ht_container[$kibuvits_krl171_lc_s_type]
      if s_type!=lc_s_Kibuvits_krl171_msgc_stack
         kibuvits_krl171_throw("s_type=="+s_type.to_s+", but "+
         "\"Kibuvits_krl171_msgc_stack\" is expected.")
      end # if
      s_serialized=ht_container[$kibuvits_krl171_lc_s_serialized]
      ht_instance=Kibuvits_krl171_ProgFTE.to_ht(s_serialized)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ht_has_keys(bn,ht_instance,
         ["s_ht_elems_progfte","sfdr_instantiation_timestamp","s_instance_id","s_ht_element_ids_progfte"])
      end # if

      ht_elems=Kibuvits_krl171_ProgFTE.to_ht(ht_instance["s_ht_elems_progfte"])
      fdr_instantiation_timestamp=ht_instance["sfdr_instantiation_timestamp"].to_r
      s_instance_id=ht_instance["s_instance_id"]
      ht_element_ids=Kibuvits_krl171_ProgFTE.to_ht(ht_instance["s_ht_element_ids_progfte"])

      i_number_of_elements=ht_elems["si_number_of_elements"].to_i
      ar_elements=Array.new
      ht_elem_container=nil
      msgc_or_msgcs=nil
      s_type=nil
      s_serialized=nil
      s_elem_instance_id=nil
      i_number_of_elements.times do |i|
         ht_elem_container=Kibuvits_krl171_ProgFTE.to_ht(ht_elems[i.to_s])
         s_type=ht_elem_container[$kibuvits_krl171_lc_s_type]
         s_serialized=ht_elem_container[$kibuvits_krl171_lc_s_serialized]
         if s_type==lc_s_Kibuvits_krl171_msgc
            msgc_or_msgcs=Kibuvits_krl171_msgc.ob_deserialize(s_serialized)
         else
            if s_type==lc_s_Kibuvits_krl171_msgc_stack
               msgc_or_msgcs=Kibuvits_krl171_msgc_stack.ob_deserialize(s_serialized)
            else
               kibuvits_krl171_throw("s_type=="+s_type.to_s+", but "+
               "the only valid values are \"Kibuvits_krl171_msgc\" "+
               "and \"Kibuvits_krl171_msgc_stack\".")
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
      # TODO: One can optimize, refactor, the class Kibuvits_krl171_msgc_stack
      #       so that the content of the stack is left to serialized
      #       state until the first occurrence of stack content reading
      #       or writing. This also gives savings at the reserialization
      #       of the deserialized instance. The same thing with the
      #       class Kibuvits_krl171_msgc.
   end # ob_deserialize

   public

   def Kibuvits_krl171_msgc_stack.ob_deserialize(s_progfte)
      msgcs=Kibuvits_krl171_msgc_stack.new
      msgcs.send(:ob_deserialize,s_progfte)
      return msgcs
   end # Kibuvits_krl171_msgc_stack.ob_deserialize

   #-----------------------------------------------------------------------

   def to_s(s_language=nil)
      kibuvits_krl171_typecheck binding(), [NilClass,String], s_language
      s_0=$kibuvits_krl171_lc_emptystring
      s_1=nil
      b_prefix_with_linebreak=false
      rgx_1=/[\n\r]+$/
      @mx.synchronize do
         @ar_elements.each do |msgc_or_msgcs|
            # The braces is to use smaller temporary strings, which
            # are better than longer ones in terms of CPU cache misses.
            if b_prefix_with_linebreak
               s_0=s_0+($kibuvits_krl171_lc_linebreak+
               msgc_or_msgcs.to_s(s_language).sub(rgx_1,$kibuvits_krl171_lc_emptystring))
            else
               s_0=s_0+(
               msgc_or_msgcs.to_s(s_language).sub(rgx_1,$kibuvits_krl171_lc_emptystring))
               b_prefix_with_linebreak=true
            end # if
         end # loop
      end # synchronize
      # "".each_line{|x| kibuvits_krl171_writeln("["+x.sub(/[\n\r]$/,"")+"]")} outputs only "", not "[]"
      # "hi\nthere".each_line{|x| kibuvits_krl171_writeln("["+x.sub(/[\n\r]$/,"")+"]")} outputs "[hi]\n[there]\n"
      s_1=$kibuvits_krl171_lc_emptystring
      s_lc_spaces=$kibuvits_krl171_lc_space*2
      rgx_2=/([\s]|[\n\r])+$/
      s_0.each_line do |s_line|
         if 0<((s_line.sub(rgx_2,$kibuvits_krl171_lc_emptystring)).length)
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
      s_1<<$kibuvits_krl171_lc_doublelinebreak
      return s_1
   end # to_s

   #-----------------------------------------------------------------------

   # Throws, if self.b_failure()==true
   def assert_lack_of_failures(s_optional_error_message_suffix=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [NilClass,String], s_optional_error_message_suffix
      end # if
      if b_failure
         s_msg=$kibuvits_krl171_lc_linebreak+to_s()+$kibuvits_krl171_lc_linebreak
         if s_optional_error_message_suffix.class==String
            s_msg<<(s_optional_error_message_suffix+$kibuvits_krl171_lc_linebreak)
         end # if
         kibuvits_krl171_throw(s_msg)
      end # if
   end # assert_lack_of_failures

   #-----------------------------------------------------------------------

   def [](i_index)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Fixnum, i_index
         kibuvits_krl171_assert_arrayix(bn,@ar_elements,i_index)
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

end # class Kibuvits_krl171_msgc_stack

if !defined? $kibuvits_krl171_msgc_stack
   $kibuvits_krl171_msgc_stack=Kibuvits_krl171_msgc_stack.new
end # if

#=====================kibuvits_krl171_msgc_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_msgc_rb_start".
#==========================================================================

#=====================kibuvits_krl171_ix_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_ix_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"

#==========================================================================

# The class Kibuvits_krl171_ix is a namespace for functions that
# are meant for facilitating the use of indexes. In the
# context of the Kibuvits_krl171_ix an index is an Array index,
# hash-table key, etc.
class Kibuvits_krl171_ix
   def initialize
   end #initialize

   #-----------------------------------------------------------------------
   private

   # "sar" stands for sub-array. The i_low and i_high
   # are separator-indices.
   def sar_for_strings(s_hay, i_low, i_high)
      # Verification and tests are assumed to be done earlier.
      x_out=""
      i_x_outlen=i_high-i_low
      return x_out if i_x_outlen==0
      x_out=s_hay[i_low..(i_high-1)]
      return x_out
   end # sar_for_strings

   # "sar" stands for sub-array. The i_low and i_high
   # are separator-indices.
   def sar_for_arrays(ar_hay, i_low, i_high)
      # Verification and tests are assumed to be done earlier.
      i_x_outlen=i_high-i_low
      x_out=ar_hay.slice(i_low,i_x_outlen)
      return x_out
   end # sar_for_arrays

   public

   # An explanation by an example:
   #
   #  Array indices:       0   1   2   3   4
   #               array=["H","e","l","l","o"]
   #  Separator indices: 0   1   2   3   4   5
   #
   #
   #                  0   1   2
   # Kibuvits_krl171_ix.sar(["H","e"],0,0)==[]         # 0-0=0
   # Kibuvits_krl171_ix.sar(["H","e"],0,1)==["H"]      # 1-0=1
   # Kibuvits_krl171_ix.sar(["H","e"],1,1)==[]         # 1-1=0
   # Kibuvits_krl171_ix.sar(["H","e"],1,2)==["e"]      # 2-1=1
   # Kibuvits_krl171_ix.sar(["H","e"],2,2)==[]         # 2-2=0
   # Kibuvits_krl171_ix.sar(["H","e"],0,2)==["H","e"]  # 2-0=2
   # Kibuvits_krl171_ix.sar(["H","e"],2,2)==[]         # 2-2=0
   #
   # Kibuvits_krl171_ix([],0,0)==[]          # 0-0=0
   #
   # "sar" stands for sub-array.
   def sar(haystack,i_lower_separator_index, i_higher_separator_index)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Fixnum, i_lower_separator_index
         kibuvits_krl171_typecheck bn, Fixnum, i_higher_separator_index
      end # if
      i_low=i_lower_separator_index
      i_high=i_higher_separator_index
      if i_high<i_low
         kibuvits_krl171_throw "i_higher_separator_index=="+i_high.to_s+
         " < i_lower_separator_index=="+i_low.to_s
      end # if
      kibuvits_krl171_throw "i_lower_separator_index=="+i_low.to_s+" < 0" if i_low<0
      if haystack.length<i_high
         kibuvits_krl171_throw "haystack.length=="+haystack.length.to_s+
         " < i_higher_separator_index=="+i_high.to_s
      end # if
      cl_name=haystack.class.to_s
      case cl_name
      when 'String'
         x_out=sar_for_strings(haystack, i_low, i_high)
         return x_out
      when 'Array'
         x_out=sar_for_arrays(haystack, i_low, i_high)
         return x_out
      else
      end # case
      x_out=haystack.class.new
      i=i_low
      while i<i_high  do
         x_out<<haystack[i].clone
         i=i+1
      end
      return x_out
   end # sar

   # "sar" stands for sub-array.
   def Kibuvits_krl171_ix.sar(haystack, i_lower_separator_index,
      i_higher_separator_index)
      x_out=Kibuvits_krl171_ix.instance.sar(haystack,i_lower_separator_index,
      i_higher_separator_index)
      return x_out
   end # Kibuvits_krl171_ix.sar

   #-----------------------------------------------------------------------
   private

   def bisect_at_sindex_for_strings s_string, i_sindex
      i_slen=s_string.length
      s_left=""
      s_right=""
      return s_left,s_right if i_slen==0
      s_left=s_string[0..(i_sindex-1)] if 0<i_sindex
      s_right=s_string[i_sindex..(-1)] if i_sindex<i_slen # if is for speed
      return s_left,s_right
   end # bisect_at_sindex_for_strings

   def bisect_at_sindex_for_ar ar_hay, i_sindex
      i_arlen=ar_hay.length
      return [],[] if i_arlen==0
      ar_left=ar_hay.slice(0,i_sindex)
      ar_right=ar_hay.slice(i_sindex,(i_arlen-i_sindex))
      return ar_left, ar_right
   end # bisect_at_sindex_for_ar

   public

   #  Array indices:       0   1   2   3   4
   #               array=["H","e","l","l","o"]
   #  Separator indices: 0   1   2   3   4   5
   #
   def bisect_at_sindex(haystack,i_sindex, b_force_element_cloning=false)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Fixnum, i_sindex
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_force_element_cloning
      end # if
      kibuvits_krl171_throw "i_sindex=="+i_sindex.to_s+" < 0" if i_sindex<0
      i_hlen=haystack.length
      if i_hlen<i_sindex
         kibuvits_krl171_throw "haystack.length=="+i_hlen.to_s+" < i_sindex=="+i_sindex.to_s
      end # if
      cl_name=haystack.class.to_s
      case cl_name
      when 'String'
         x_left,x_right=bisect_at_sindex_for_strings(haystack,
         i_sindex)
         return x_left,x_right
      when 'Array'
         if !b_force_element_cloning
            x_left,x_right=bisect_at_sindex_for_ar(haystack,i_sindex)
            return x_left,x_right
         end # if
      else
      end # case
      x_left=haystack.class.new
      x_right=haystack.class.new
      i_hlen=haystack.length
      i=0
      if b_force_element_cloning
         while i<i_sindex do
            x_left<<haystack[i].clone
            i=i+1
         end # loop
         while i<i_hlen do
            x_right<<haystack[i].clone
            i=i+1
         end # loop
      else
         while i<i_sindex do
            x_left<<haystack[i]
            i=i+1
         end # loop
         while i<i_hlen do
            x_right<<haystack[i]
            i=i+1
         end # loop
      end # if
      return x_left,x_right
   end # bisect_at_sindex

   def Kibuvits_krl171_ix.bisect_at_sindex(haystack,i_sindex,
      b_force_element_cloning=false)
      x_left,x_right=Kibuvits_krl171_ix.instance.bisect_at_sindex(haystack,i_sindex,
      b_force_element_cloning)
      return x_left,x_right
   end # Kibuvits_krl171_ix.bisect_at_sindex

   #-----------------------------------------------------------------------
   private

   def normalize2array_searchstring(x_that_is_not_an_array)
      cl=x_that_is_not_an_array.class
      s_out=(cl.to_s+$kibuvits_krl171_lc_underscore)+x_that_is_not_an_array.to_s
      return s_out
   end # normalize2array_searchstring

   public

   def normalize2array_insert_2_ht(ht_values_that_result_an_empty_array,
      x_that_is_not_an_array)
      s_key=normalize2array_searchstring(x_that_is_not_an_array)
      ht_values_that_result_an_empty_array[s_key]=42
   end # normalize2array_insert_2_ht

   def Kibuvits_krl171_ix.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,x_that_is_not_an_array)
      Kibuvits_krl171_ix.instance.normalize2array_insert_2_ht(
      ht_values_that_result_an_empty_array,x_that_is_not_an_array)
   end # Kibuvits_krl171_ix.normalize2array_insert_2_ht

   # If the ht_values_that_result_an_empty_array!=nil,
   # then the entries to it must be inserted by using
   #
   # normalize2array_insert_2_ht(
   #         ht_values_that_result_an_empty_array,<the value>)
   #
   # To normalize a commaseparated string to an array of strings,
   #
   #     Kibuvits_krl171_str.normalize_str_2_array_of_s_t1(...)
   #
   # should be used.
   def normalize2array(x_array_or_something_else,
      ht_values_that_result_an_empty_array=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [NilClass,Hash], ht_values_that_result_an_empty_array
      end # if
      cl=x_array_or_something_else.class
      return x_array_or_something_else if cl==Array
      ht_vls_for_empty=ht_values_that_result_an_empty_array
      ar_out=nil
      if ht_vls_for_empty==nil
         ar_out=[x_array_or_something_else]
      else
         s=normalize2array_searchstring(x_array_or_something_else)
         if ht_vls_for_empty.has_key? s
            ar_out=Array.new
         else
            ar_out=[x_array_or_something_else]
         end # if
      end # if
      return ar_out
   end # normalize2array

   def Kibuvits_krl171_ix.normalize2array(x_array_or_something_else,
      ht_values_that_result_an_empty_array=nil)
      ar_out=Kibuvits_krl171_ix.instance.normalize2array(
      x_array_or_something_else,
      ht_values_that_result_an_empty_array)
      return ar_out
   end # Kibuvits_krl171_ix.normalize2array

   #-----------------------------------------------------------------------

   # The func_returns_true_if_element_is_part_of_output is fed
   # 2 arguments: x_key, x_value. For arrays the x_key is an index.
   #
   # If the ar_or_ht_in is an array, then the
   # output will also be an array. Otherwise the output will be
   # a hashtable.
   def x_filter_t1(ar_or_ht_in,func_returns_true_if_element_is_part_of_output)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array,Hash],ar_or_ht_in
         kibuvits_krl171_typecheck bn, Proc,func_returns_true_if_element_is_part_of_output
      end # if
      x_out=nil
      cl=ar_or_ht_in.class
      b_add_2_output=nil
      if cl==Array
         ar_in=ar_or_ht_in
         ar_out=Array.new
         i_ar_in_len=ar_in.size
         x_value=nil
         i_ar_in_len.times do |ix|
            x_value=ar_in[ix]
            b_add_2_output=func_returns_true_if_element_is_part_of_output.call(
            ix,x_value)
            ar_out<<x_value if b_add_2_output
         end # loop
         return ar_out
      else # cl==Hash
         ht_in=ar_or_ht_in
         ht_out=Hash.new
         ht_in.each_pair do |x_key, x_value|
            b_add_2_output=func_returns_true_if_element_is_part_of_output.call(
            x_key,x_value)
            ht_out[x_key]=x_vaoue if b_add_2_output
         end # loop
         return ht_out
      end # if
      kibuvits_krl171_throw("There's a flaw. \n"+
      "GUID='0ec61533-6a46-4677-b410-c2c2f051a4e7'\n\n")
   end # x_filter_t1

   def Kibuvits_krl171_ix.x_filter_t1(ar_or_ht_in,func_returns_true_if_element_is_part_of_output)
      x_out=Kibuvits_krl171_ix.instance.x_filter_t1(
      ar_or_ht_in,func_returns_true_if_element_is_part_of_output)
      return x_out
   end # Kibuvits_krl171_ix.x_filter_t1

   #-----------------------------------------------------------------------

   # Explanation by example:
   # ht_1=Hash.new
   # ht_2=Hash.new
   #
   # ht_1["a"]="aaa1"
   # ht_1["c"]="ccc1"
   #
   # ht_2["a"]="aaa2"
   # ht_2["b"]="bbb2"
   #
   # ar_1_2=[ht_1,ht_2]
   # ar_2_1=[ht_2,ht_1]
   #
   # ht_merged_1_2=ht_merge_by_overriding_t1(ar_1_2)
   # ht_merged_2_1=ht_merge_by_overriding_t1(ar_2_1)
   #
   # #---------------|-------------
   # # ht_merged_1_2 | ht_merged_2_1
   # #---------------|-------------
   # #  a=="aaa2"    | a=="aaa1"
   # #  b=="bbb2"    | b=="bbb2"
   # #  c=="ccc1"    | c=="ccc1"
   # #---------------|-------------
   def ht_merge_by_overriding_t1(ar_hashtables)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array,ar_hashtables
         ar_hashtables.each do |ht_candidate|
            bn=binding()
            kibuvits_krl171_typecheck bn, Hash, ht_candidate
         end # loop
      end # if
      ht_out=Hash.new
      ar_hashtables.each do |ht|
         ht.each_key do |key|
            ht_out[key]=ht[key]
         end # loop
      end # loop
      return ht_out
   end # ht_merge_by_overriding_t1

   def Kibuvits_krl171_ix.ht_merge_by_overriding_t1(ar_hashtables)
      ar_out=Kibuvits_krl171_ix.instance.ht_merge_by_overriding_t1(
      ar_hashtables)
      return ar_out
   end # Kibuvits_krl171_ix.ht_merge_by_overriding_t1

   #-----------------------------------------------------------------------

   # This function is a generalisation of the
   # kibuvits_krl171_s_concat_array_of_strings(...), which is
   # a memory access paterns based speed optimization of
   # the 2-liner:
   #
   #     s_sum=""
   #     ar_strings.size.times{|ix| s_sum=s_sum+ar_strings[ix]}
   #
   # and yes, in the case of huge strings and arrays with
   # lots of elements the speed improvement can be 50%.
   #
   # The x_identity_element is defined by the following formula:
   #
   #  (  func_operator_that_might_be_noncommutative.call(ar_in[ix],x_identity_element)==
   #   ==func_operator_that_might_be_noncommutative.call(x_identity_element,ar_in[ix])==
   #   ==ar_in[ix] ) === true
   #
   # -----demo--code---start-----
   #
   #     require "prime"
   #     func_oper_star=lambda do |x_a,x_b|
   #        x_out=x_a*x_b
   #        return x_out
   #     end # func_oper_star
   #     i_n_of_primes=100000
   #     ar_x=Prime.take(i_n_of_primes)
   #     #----
   #     ob_start_1=Time.new
   #     x_0=Kibuvits_krl171_ix.x_apply_binary_operator_t1(x_identity_element,ar_x,func_oper_star)
   #     ob_end_1=Time.new
   #     ob_duration_1=ob_end_1-ob_start_1
   #     #----
   #     x_0=1
   #     ob_start_2=Time.new
   #     i_n_of_primes.times do |ix|
   #        x_0=x_0*ar_x[ix]
   #     end # loop
   #     ob_end_2=Time.new
   #     ob_duration_2=ob_end_2-ob_start_2
   #     #--------------
   #     puts "elephant_1 ob_duration_1=="+ob_duration_1.to_s
   #     puts "elephant_2 ob_duration_2=="+ob_duration_2.to_s
   #
   # -----demo--code---end-------
   #
   # The console output of the demo code:
   #
   #     elephant_1 ob_duration_1==0.245117211
   #     elephant_2 ob_duration_2==28.308270365
   #
   # Yes, speed improvement is over 300% (three hundred) percent!
   #
   def x_apply_binary_operator_t1(x_identity_element,ar_in,
      func_operator_that_might_be_noncommutative)
      # There is no point of reading this code, because
      # it is a slightly edited version of the
      # kibuvits_krl171_s_concat_array_of_strings(...) core.
      # The comments and explanations are mostly there.
      if defined? KIBUVITS_krl171_b_DEBUG
         if KIBUVITS_krl171_b_DEBUG
            bn=binding()
            kibuvits_krl171_typecheck bn, Array, ar_in
            kibuvits_krl171_typecheck bn, Proc, func_operator_that_might_be_noncommutative
         end # if
      end # if
      func_oper=func_operator_that_might_be_noncommutative
      i_n=ar_in.size
      if i_n<3
         if i_n==2
            x_out=func_oper.call(ar_in[0],ar_in[1])
            return x_out
         else
            if i_n==1
               # For the sake of consistency one
               # wants to make sure that the returned
               # string instance always differs from those
               # that are within the ar_in.
               x_out=func_oper.call(x_identity_element,ar_in[0])
               return x_out
            else # i_n==0
               x_out=x_identity_element
               return x_out
            end # if
         end # if
      end # if
      x_out=x_identity_element # needs to be inited to the x_identity_element
      ar_1=ar_in
      b_ar_1_equals_ar_in=true # to avoid modifying the received Array
      ar_2=Array.new
      b_take_from_ar_1=true
      b_not_ready=true
      i_reminder=nil
      i_loop=nil
      i_ar_in_len=nil
      i_ar_out_len=0 # code after the while loop needs a number
      x_1=nil
      x_2=nil
      x_3=nil
      i_2=nil
      while b_not_ready
         # The next if-statement is to avoid copying temporary
         # strings between the ar_1 and the ar_2.
         if b_take_from_ar_1
            i_ar_in_len=ar_1.size
            i_reminder=i_ar_in_len%2
            i_loop=(i_ar_in_len-i_reminder)/2
            i_loop.times do |i|
               i_2=i*2
               x_1=ar_1[i_2]
               x_2=ar_1[i_2+1]
               x_3=func_oper.call(x_1,x_2)
               ar_2<<x_3
            end # loop
            if i_reminder==1
               x_3=ar_1[i_ar_in_len-1]
               ar_2<<x_3
            end # if
            i_ar_out_len=ar_2.size
            if 1<i_ar_out_len
               if b_ar_1_equals_ar_in
                  ar_1=Array.new
                  b_ar_1_equals_ar_in=false
               else
                  ar_1.clear
               end # if
            else
               b_not_ready=false
            end # if
         else # b_take_from_ar_1==false
            i_ar_in_len=ar_2.size
            i_reminder=i_ar_in_len%2
            i_loop=(i_ar_in_len-i_reminder)/2
            i_loop.times do |i|
               i_2=i*2
               x_1=ar_2[i_2]
               x_2=ar_2[i_2+1]
               x_3=func_oper.call(x_1,x_2)
               ar_1<<x_3
            end # loop
            if i_reminder==1
               x_3=ar_2[i_ar_in_len-1]
               ar_1<<x_3
            end # if
            i_ar_out_len=ar_1.size
            if 1<i_ar_out_len
               ar_2.clear
            else
               b_not_ready=false
            end # if
         end # if
         b_take_from_ar_1=!b_take_from_ar_1
      end # loop
      if i_ar_out_len==1
         if b_take_from_ar_1
            x_out=ar_1[0]
         else
            x_out=ar_2[0]
         end # if
      else
         # The x_out has been inited to "".
         if 0<i_ar_out_len
            raise Exception.new("This function is flawed."+
            "\n GUID='0a714c52-7238-4a30-a5ef-c2c2f051a4e7'\n\n")
         end # if
      end # if
      return x_out
   end # x_apply_binary_operator_t1

   def Kibuvits_krl171_ix.x_apply_binary_operator_t1(x_identity_element,ar_in,
      func_operator_that_might_be_noncommutative)
      x_out=Kibuvits_krl171_ix.instance.x_apply_binary_operator_t1(
      x_identity_element,ar_in,func_operator_that_might_be_noncommutative)
      return x_out
   end # Kibuvits_krl171_ix.x_apply_binary_operator_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_ix
#=====================kibuvits_krl171_ix_rb_end===================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_ix_rb_start".
#==========================================================================

#=============kibuvits_krl171_str_concat_array_of_strings_rb_start================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_str_concat_array_of_strings_rb_end".
#==========================================================================
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

---------------------------------------------------------------------------

To facilitate the exporting of the string concatenation code 
from the Kibuvits Ruby Library (KRL) to other projects,
this file is totally selfcontained.

Its selftests reside within the KRL.

=end
#==========================================================================

def kibuvits_krl171_s_concat_array_of_strings_plain(ar_in)
   n=ar_in.size
   if defined? KIBUVITS_krl171_b_DEBUG
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array, ar_in
         s=nil
         n.times do |i|
            bn=binding()
            s=ar_in[i]
            kibuvits_krl171_typecheck bn, String, s
         end # loop
      end # if
   end # if
   s_out="";
   n.times{|i| s_out<<ar_in[i]}
   return s_out;
end # kibuvits_krl171_s_concat_array_of_strings_plain

#--------------------------------------------------------------------------

# This is the main implementation of the
# Kibuvits Ruby Library watershed concatenation algorithm, but
#
# Kibuvits_krl171_ix.x_apply_binary_operator_t1(...)
#
# is a commentless, general, copy of it.
def kibuvits_krl171_s_concat_array_of_strings_watershed(ar_in)
   s_lc_emptystring=""
   if defined? KIBUVITS_krl171_b_DEBUG
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array, ar_in
      end # if
   end # if
   i_n=ar_in.size
   if i_n<3
      if i_n==2
         s_out=ar_in[0]+ar_in[1]
         return s_out
      else
         if i_n==1
            # For the sake of consistency one
            # wants to make sure that the returned
            # string instance always differs from those
            # that are within the ar_in.
            s_out=s_lc_emptystring+ar_in[0]
            return s_out
         else # i_n==0
            s_out=s_lc_emptystring
            return s_out
         end # if
      end # if
   end # if
   s_out=s_lc_emptystring # needs to be inited to the ""

   # The classic part for testing and playing.
   # ar_in.size.times{|i| s_out=s_out+ar_in[i]}
   # return s_out

   # In its essence the rest of the code here implements
   # a tail-recursive version of this function. The idea is that
   #
   # s_out='something_very_long'.'short_string_1'.short_string_2'
   # uses a temporary string of length
   # 'something_very_long'.'short_string_1'
   # but
   # s_out='something_very_long'.('short_string_1'.short_string_2')
   # uses a much more CPU-cache friendly temporary string of length
   # 'short_string_1'.short_string_2'
   #
   # Believe it or not, but as of January 2012 the speed difference
   # in PHP can be at least about 20% and in Ruby about 50%.
   # Please do not take my word on it. Try it out yourself by
   # modifying this function and assembling strings of length
   # 10000 from single characters.
   #
   # This here is probably not the most optimal solution, because
   # within the more optimal solution the the order of
   # "concatenation glue placements" depends on the lengths
   # of the tokens/strings, but as the analysis and "gluing queue"
   # assembly also has a computational cost, the version
   # here is almost always more optimal than the totally
   # naive version.
   ar_1=ar_in
   b_ar_1_equals_ar_in=true # to avoid modifying the received Array
   ar_2=Array.new
   b_take_from_ar_1=true
   b_not_ready=true
   i_reminder=nil
   i_loop=nil
   i_ar_in_len=nil
   i_ar_out_len=0 # code after the while loop needs a number
   s_1=nil
   s_2=nil
   s_3=nil
   i_2=nil
   while b_not_ready
      # The next if-statement is to avoid copying temporary
      # strings between the ar_1 and the ar_2.
      if b_take_from_ar_1
         i_ar_in_len=ar_1.size
         i_reminder=i_ar_in_len%2
         i_loop=(i_ar_in_len-i_reminder)/2
         i_loop.times do |i|
            i_2=i*2
            s_1=ar_1[i_2]
            s_2=ar_1[i_2+1]
            s_3=s_1+s_2
            ar_2<<s_3
         end # loop
         if i_reminder==1
            s_3=ar_1[i_ar_in_len-1]
            ar_2<<s_3
         end # if
         i_ar_out_len=ar_2.size
         if 1<i_ar_out_len
            if b_ar_1_equals_ar_in
               ar_1=Array.new
               b_ar_1_equals_ar_in=false
            else
               ar_1.clear
            end # if
         else
            b_not_ready=false
         end # if
      else # b_take_from_ar_1==false
         i_ar_in_len=ar_2.size
         i_reminder=i_ar_in_len%2
         i_loop=(i_ar_in_len-i_reminder)/2
         i_loop.times do |i|
            i_2=i*2
            s_1=ar_2[i_2]
            s_2=ar_2[i_2+1]
            s_3=s_1+s_2
            ar_1<<s_3
         end # loop
         if i_reminder==1
            s_3=ar_2[i_ar_in_len-1]
            ar_1<<s_3
         end # if
         i_ar_out_len=ar_1.size
         if 1<i_ar_out_len
            ar_2.clear
         else
            b_not_ready=false
         end # if
      end # if
      b_take_from_ar_1=!b_take_from_ar_1
   end # loop
   if i_ar_out_len==1
      if b_take_from_ar_1
         s_out=ar_1[0]
      else
         s_out=ar_2[0]
      end # if
   else
      # The s_out has been inited to "".
      if 0<i_ar_out_len
         raise Exception.new("This function is flawed.")
      end # if
   end # if
   return s_out
end # kibuvits_krl171_s_concat_array_of_strings_watershed

#--------------------------------------------------------------------------

# Reference to the version of string
# concatenation function that is "usually" the fastest.
def kibuvits_krl171_s_concat_array_of_strings(ar_in)
   # In the most frequent cases the time taken by the
   # kibuvits_krl171_s_concat_array_of_strings_plain is  about 75% of the
   # time taken by the kibuvits_krl171_s_concat_array_of_strings_watershed.
   # In its core mutable strings are "immutable", because they
   # have to be stretched, reallocated, from time to time like variable
   # length arrays/vectors. If the ar_in contains "huge enough" strings, then
   # it might happen that with the "huge enough" strings the
   # kibuvits_krl171_s_concat_array_of_strings_watershed
   # takes less time than the plain version. As both of the functions
   # are pretty fast in terms of the absolute amount of time,
   # the watershed version is a more reliable choise.
   #
   s_out=kibuvits_krl171_s_concat_array_of_strings_watershed(ar_in)
   #s_out=kibuvits_krl171_s_concat_array_of_strings_plain(ar_in)
   return s_out;
end # kibuvits_krl171_s_concat_array_of_strings

#=========================================================================
# Demo code:
#ar=["\n","Hello"," ","Watershed"," ","Concatenated"," ","World","!","\n\n"];
#s=kibuvits_krl171_s_concat_array_of_strings(ar);
#puts(s);
#=============kibuvits_krl171_str_concat_array_of_strings_rb_end==================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_str_concat_array_of_strings_rb_start".
#==========================================================================

#=====================kibuvits_krl171_str_rb_start================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_str_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ix.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str_concat_array_of_strings.rb"

#==========================================================================

class Kibuvits_krl171_str
   attr_reader :i_unicode_maximum_codepoint

   @@cache=Hash.new
   @@mx_cache=Mutex.new

   def initialize
      # As of 2011 the valid range of Unicode points is U0000 to x2=U10FFFF
      # x2 = 16^5+15*16^3+15*16^2+15*16+15 = 1114111 ;
      @i_unicode_maximum_codepoint=1114111
      @b_kibuvits_krl171_bootfile_run=(defined? KIBUVITS_krl171_s_VERSION)
   end # initialize

   public

   #-----------------------------------------------------------------------

   # For ab, bb, ba it checks that there does not exist
   # any pairs, where one element is equal to or substring
   # of the other. It also checks that no element is
   # a substring of the pair concatenation. For example,
   # a pair (ab,ba) has concatenations abba, baab, and the
   # abba contains the element bb as its substring.
   def verify_noninclusion(array_of_strings)
      b_inclusion_present=false
      msg="Inclusions not found."
      ar_str=array_of_strings
      ht=Hash.new
      ar_str.each do |s_1|
         if ht.has_key?(s_1)
            b_inclusion_present=true
            msg="String \""+s_1+"\" is within the array more than once."
            return b_inclusion_present,msg
         end # if
      end # if
      # All of the pixels of a width*height sized image can
      # be encoded to a single array that has width*height elements.
      # The array index determines the X and Y of the pixel.
      # The pixel coordinates are pairs. The width of a square
      # equals its height. :-)
      i_side=ar_str.length
      s_1=""
      s_2=""
      s_concat=""
      s_elem=""
      i_side.times do |y|
         s_2=ar_str[y]
         i_side.times do |x|
            next if x==y
            s_1=ar_str[x]
            if (s_1.index(s_2)!=nil)
               b_inclusion_present=true
               msg="\""+s_1+"\" includes \""+s_2+"\""
               break
            end # if
            if (s_2.index(s_1)!=nil)
               b_inclusion_present=true
               msg="\""+s_2+"\" includes \""+s_1+"\""
               break
            end # if
            # abba+bball=abbABBAll, which contains abba twice, but
            # it is not a problem, because if the first abba is
            # removed, the second one also breaks.
            s_concat=s_1+s_2
            i_side.times do |i_elem|
               next if (i_elem==x)||(i_elem==y)
               s_elem=ar_str[i_elem]
               if (s_concat.index(s_elem)!=nil)
                  b_inclusion_present=true
                  msg="Concatenation \""+s_concat+"\" includes \""+
                  s_elem+"\""
                  break
               end # if
            end # loop
            break if b_inclusion_present
            s_concat=s_2+s_1
            i_side.times do |i_elem|
               next if (i_elem==x)||(i_elem==y)
               s_elem=ar_str[i_elem]
               if (s_concat.index(s_elem)!=nil)
                  b_inclusion_present=true
                  msg="Concatenation \""+s_concat+"\" includes \""+
                  s_elem+"\""
                  break
               end # if
            end # loop
            break if b_inclusion_present
         end # loop
         break if b_inclusion_present
      end # loop
      return b_inclusion_present,msg
   end # verify_noninclusion

   def Kibuvits_krl171_str.verify_noninclusion(array_of_strings)
      b_inclusion_present,msg=Kibuvits_krl171_str.instance.verify_noninclusion(
      array_of_strings)
      return b_inclusion_present,msg
   end # Kibuvits_krl171_str.verify_noninclusion

   #-----------------------------------------------------------------------

   private

   # It should be part of the pick_extraction_step, but
   # due to light speed optimization, it's not even called from there.
   def pick_extraction_step_input_verification(
      s_start, s_end, haystack, ht, s_block_substitution, s_new_ht_key)
      kibuvits_krl171_throw "s_start.length==0" if s_start.length==0
      kibuvits_krl171_throw "s_end.length==0" if s_end.length==0
      kibuvits_krl171_throw "s_block_substitution.length==0" if s_block_substitution.length==0
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), Hash, ht
      end # if
      ar=Array.new
      ar<<s_start
      ar<<s_end
      ar<<s_block_substitution
      b_inclusion_present,msg=Kibuvits_krl171_str.verify_noninclusion ar
      ar.clear
      if b_inclusion_present
         kibuvits_krl171_throw "Inclusion present. msg=="+msg
      end # if
   end # pick_extraction_step_input_verification

   def pick_extraction_step(s_start, s_end, haystack, ht,
      s_block_substitution, s_new_ht_key)
      msg="ok";
      s_hay=haystack
      i_start=s_hay.index s_start
      if i_start==nil
         msg="done"
         msg="err_missing_start_or_multiple_end" if (s_hay.index s_end)!=nil
         return msg, s_hay
      end # if
      i_end=s_hay.index s_end
      if i_end==nil
         msg="err_missing_end"
         return msg, s_hay
      end # if
      s_left=""
      s_left=s_hay[0..(i_start-1)] if 0<i_start
      i_e2=i_end-1+s_end.length
      s_middle=s_hay[i_start..i_e2]
      s_right=""
      s_right=s_hay[(i_e2+1)..-1] if i_e2<(s_hay.length-1)
      kibuvits_krl171_throw "i_e2=="+i_e2.to_s if (s_hay.length-1)<i_e2
      s_hay=s_left+s_block_substitution+s_right
      s_block_content=""
      if((s_start.length+s_end.length)<s_middle.length)
         s_block_content=s_middle[(s_start.length)..((-1)-s_end.length)]
      end # if
      if (s_block_content.index s_start)!=nil
         msg="err_multiple_start";
         return msg, s_hay
      end # if
      ht[s_new_ht_key]=s_block_content
      return msg, s_hay
   end # pick_extraction_step

   public

   # Replaces each block that starts with s_start and ends with s_end,
   # with a Globally Unique Identifier (GUID). It does not guarantee
   # that the text before and after the s_start and s_end won't "blend in"
   # with the GUID like "para"+"dise"+"diseases"="paradise"+"dise+"ases"
   # or "under"+"stand"+"standpoint"="understand"+"stand"+"point"
   # The blocks are gathered
   # to a hashtable and prior to storing the blocks to the hashtable,
   # the s_start and s_end are removed from the block. The GUIDs are
   # used as hashtable keys.
   def pick_by_instance(s_start,s_end,s_haystack,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_start
         kibuvits_krl171_typecheck bn, String, s_end
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      # TODO: refactor the msg out of here and use the Kibuvits_krl171_msgc_stack
      # instead.
      ht_out=Hash.new
      s_hay=s_haystack
      b_failure=false
      msg="ok"
      s_block_substitution=Kibuvits_krl171_GUID_generator.generate_GUID # for inclusion tests
      s_new_ht_key=""
      pick_extraction_step_input_verification(
      s_start, s_end, s_hay, ht_out, s_block_substitution, s_new_ht_key)
      while msg=="ok"
         s_block_substitution=Kibuvits_krl171_GUID_generator.generate_GUID
         s_new_ht_key=s_block_substitution
         msg, s_hay=pick_extraction_step(s_start, s_end,
         s_hay, ht_out,s_block_substitution,s_new_ht_key)
      end # loop
      msgcs.cre msg if msg!="done"
      return s_hay,ht_out
   end # pick_by_instance

   def Kibuvits_krl171_str.pick_by_instance(s_start,s_end,s_haystack,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      s_hay,ht_out=Kibuvits_krl171_str.instance.pick_by_instance(
      s_start,s_end,s_haystack,msgcs)
      return s_hay,ht_out
   end # Kibuvits_krl171_str.pick_by_instance

   #-----------------------------------------------------------------------

   #	def Kibuvits_krl171_str.pick_by_type(
   #			s_start, s_end, haystack, ht, s_block_substitution)
   #   # May be this method/function is not even necessary?
   #		s_hay=haystack
   #		b_failure=false
   #		msg="ok"
   #		s_new_ht_key=""
   #		pick_extraction_step_input_verification(
   #			s_start, s_end, s_hay, ht, s_block_substitution, s_new_ht_key)
   #        while msg=="ok"
   #			s_new_ht_key=Kibuvits_krl171_GUID_generator.generate_GUID
   #			msg, s_hay=pick_extraction_step(s_start, s_end,
   #				s_hay, ht,s_block_substitution,s_new_ht_key)
   #		end # loop
   #		b_failure=true if msg!="done"
   #		return b_failure,s_hay,msg
   #	end # Kibuvits_krl171_str.pick_by_type

   #-----------------------------------------------------------------------

   private

   def Kibuvits_krl171_str.wholenumber_ASCII_2_whonenumber_Unicode_init1
      return if (@@cache.has_key? 'whncses')
      @@mx_cache.synchronize do
         break if (@@cache.has_key? 'whncses')
         whncses=Hash.new
         whncses[0x80]=0x20AC
         whncses[0x81]=0x81
         whncses[0x82]=0x201A
         whncses[0x83]=0x192
         whncses[0x84]=0x201E
         whncses[0x85]=0x2026
         whncses[0x86]=0x2020
         whncses[0x87]=0x2021
         whncses[0x88]=0x2C6
         whncses[0x89]=0x2030
         whncses[0x8A]=0x160
         whncses[0x8B]=0x2039
         whncses[0x8C]=0x152
         whncses[0x8D]=0x8D
         whncses[0x8E]=0x17D
         whncses[0x8F]=0x8F
         whncses[0x90]=0x90
         whncses[0x91]=0x2018
         whncses[0x92]=0x2019
         whncses[0x93]=0x201C
         whncses[0x94]=0x201D
         whncses[0x95]=0x2022
         whncses[0x96]=0x2013
         whncses[0x97]=0x2014
         whncses[0x98]=0x2DC
         whncses[0x99]=0x2122
         whncses[0x9A]=0x161
         whncses[0x9B]=0x203A
         whncses[0x9C]=0x153
         whncses[0x9D]=0x9D
         whncses[0x9E]=0x17E
         whncses[0x9F]=0x178
         @@cache['whncses']=whncses
      end # synchronize
   end # Kibuvits_krl171_str.wholenumber_ASCII_2_whonenumber_Unicode_init1

   public

   # According to http://www.alanwood.net/demos/ansi.html
   # there exist codepoints, where the integer representation of an
   # ASCII character does not match with the character's integer
   # representation in the Unicode.
   def wholenumber_ASCII_2_whonenumber_Unicode(i_ascii)
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), Fixnum, i_ascii
      end # if
      b_failure=false
      msg="ASCII 2 Unicode conversion succeeded."
      i_out=0
      if (i_ascii<32)||(0xFF<i_ascii)
         if (i_ascii==0xA)||(i_ascii==0xD) # "\n" and "\r"
            i_out=i_ascii
            return b_failure, i_out, msg
         end # end
         msg="ASCII 2 Unicode conversion failed. i_ascii=="+i_ascii.to_s(16)
         b_failure=true
         return b_failure, i_out, msg
      end # end
      if (i_ascii<=0x7f)||(0xA0<=i_ascii)
         i_out=i_ascii
         return b_failure, i_out, msg
      end # if
      Kibuvits_krl171_str.wholenumber_ASCII_2_whonenumber_Unicode_init1
      whncses=@@cache['whncses']
      if whncses.has_key? i_ascii
         i_out=0+whncses[i_ascii]
         return b_failure, i_out, msg
      end # if
      b_failure=true
      msg="ASCII 2 Unicode conversion failed. i_ascii=="+i_ascii.to_s(16)
      return b_failure, i_out, msg
   end # wholenumber_ASCII_2_whonenumber_Unicode

   def Kibuvits_krl171_str.wholenumber_ASCII_2_whonenumber_Unicode(i_ascii)
      b_failure, i_out, msg=Kibuvits_krl171_str.instance.wholenumber_ASCII_2_whonenumber_Unicode(
      i_ascii)
      return b_failure, i_out, msg
   end # Kibuvits_krl171_str.wholenumber_ASCII_2_whonenumber_Unicode

   #-----------------------------------------------------------------------

   # It modifies the input array.
   def Kibuvits_krl171_str.sort_by_length(array_of_strings, longest_strings_first=true)
      if longest_strings_first
         array_of_strings.sort!{|a,b| b.length<=>a.length}
      else
         array_of_strings.sort!{|a,b| a.length<=>b.length}
      end # if
      return nil
   end # Kibuvits_krl171_str.sort_by_length

   #-----------------------------------------------------------------------

   # ribboncut("YY","xxYYmmmmYY")->["xx","mmmm",""]
   # ribboncut("YY","YYxxYYmmmm")->["","xx","mmmm"]
   # ribboncut("YY","YY")->["",""]
   # ribboncut("YY","YYYY")->["","",""]
   # ribboncut("YY","xxx")->["xxx"]
   #
   # One can think of a ribbon cutting ceremony, where a piece of cut
   # out of a ribbon.
   def ribboncut(s_needle, s_haystack)
      kibuvits_krl171_throw 's_needle==""' if s_needle==""
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_needle
         kibuvits_krl171_typecheck bn, String, s_haystack
      end # if
      ar_out=Array.new
      if !s_haystack.include? s_needle
         ar_out<<""+s_haystack
         return ar_out
      end # if
      if s_haystack==s_needle
         ar_out<<""
         ar_out<<""
         return ar_out
      end # if
      # YYxxxYYmmmmYY    xxxYYYYmmmm
      # 0123456789012    01234567890
      # STR::=(NEEDLE|TOKEN)
      ix_str_low=0
      ix_str_high=nil
      ix_str_start_candidate=0
      ix_hay_max=s_haystack.length-1
      i_needle_len=s_needle.length
      ix_needle_low=nil
      s1=""
      while true
         ix_needle_low=s_haystack.index(s_needle,ix_str_start_candidate)
         if ix_needle_low==nil
            s1=""
            if ix_str_start_candidate<=ix_hay_max
               s1=s_haystack[ix_str_start_candidate..(-1)]
            end # if
            ar_out<<s1
            break
         end # if
         ix_str_start_candidate=ix_needle_low+i_needle_len
         ix_str_high=ix_needle_low-1
         s1=""
         if ix_str_low<=ix_str_high
            s1=s_haystack[ix_str_low..ix_str_high]
            s1="" if s1==s_needle
         end # if
         ar_out<<s1
         ix_str_low=ix_str_start_candidate
      end # loop
      return ar_out
   end # ribboncut

   def Kibuvits_krl171_str.ribboncut(s_needle, s_haystack)
      ar_out=Kibuvits_krl171_str.instance.ribboncut s_needle, s_haystack
      return ar_out
   end # Kibuvits_krl171_str.ribboncut

   #-----------------------------------------------------------------------

   private

   def batchreplace_csnps_needle_is_key(ht_needles)
      ar_subst_needle_pairs=Array.new
      ar_pair1=nil
      ht_needles.each_pair do |key,s_subst|
         kibuvits_krl171_throw '<needle string>==""' if key==""
         kibuvits_krl171_throw '<substitution string>==""' if s_subst==""
         ar_pair1=[s_subst,key]
         ar_subst_needle_pairs<<ar_pair1
      end # loop
      return ar_subst_needle_pairs
   end #batchreplace_csnps_needle_is_key

   def batchreplace_csnps_subst_is_key(ht_needles)
      ar_subst_needle_pairs=Array.new
      ar_pair1=nil
      ht_needles.each_pair do |key,ar_value|
         kibuvits_krl171_throw '<substitution string>==""' if key==""
         ar_value.each do |s_needle|
            kibuvits_krl171_throw 's_needle==""' if s_needle==""
            ar_pair1=[key,s_needle]
            ar_subst_needle_pairs<<ar_pair1
         end # loop
      end # loop
      return ar_subst_needle_pairs
   end #batchreplace_csnps_subst_is_key


   def batchreplace_step(ar_piece,ar_subst_needle)
      s_hay=ar_piece[0]
      s_rightmost_subst=ar_piece[1]
      s_subst=ar_subst_needle[0]
      s_needle=ar_subst_needle[1]
      ar_pieces2=Array.new
      ar=Kibuvits_krl171_str.ribboncut s_needle, s_hay
      n=ar.length-1
      n.times {|i| ar_pieces2<<[ar[i],s_subst]}
      ar_pieces2<<[ar[n],s_rightmost_subst]
      return ar_pieces2
   end # batchreplace_step

   public

   # Makes it possible to replace all of the needle strings within
   # the haystack string with a substitution string that
   # contains at least one of the needle strings as one of its substrings.
   #
   # It's also useful, when at least one of the needle strings contains
   # at least one other needle string as its substring. For example,
   # if "cat" and "mouse" were to be switched in a sentence like
   # "A cat and a mouse met.", doing the replacements sequentially,
   # "cat"->"mouse" and "mouse"->"cat", would give
   # "A cat and a cat met." in stead of the correct version,
   # "A mouse and a cat met."
   #
   # By combining multiple substitutions into a single, "atomic",
   # operation, one can treat the needle strings of multiple
   # substitutions as a whole, single, set.
   #
   # A a few additional examples, where it is difficult to do properly
   # with plain substitutions:
   # needle-substitutionstring pairs:
   #         ("cat","Casanova")
   #         ("nova","catastrophe")
   # haystack: "A cat saw a nova."
   # Correct substitution result, as given by the Kibuvits_krl171_str.s_batchreplace:
   #           "A Casanova saw a catastrophe."
   # Incorrect versions as gained by sequential substitutions:
   #           "A Casacatastrophe saw a catastrophe."
   #           "A Casanova saw a Casanovaastrophe."
   #
   # if b_needle_is_key==true
   #     ht_needles[<needle string>]==<substitution string>
   # else
   #     ht_needles[<substitution string>]==<array of needle strings>
   def s_batchreplace(ht_needles, s_haystack, b_needle_is_key=true)
      # The idea is that "i" in the "Sci-Fi idea" can be replaced
      # with "X" by decomposing the haystack to ar=["Sc","-F"," ","dea"]
      # and treating each of the elements, except the last one, as
      # <a string><substitution string>. The substitution string always stays
      # at the right side, even if the <a string> is decomposed recursively.
      #
      # If the <substitution string> were temporarily replaced with a
      # Globally Unique Identifier (GUID) and concatenated to the <a string>,
      # then there might be difficulties separating the two because in
      # some very rare cases it would be like
      # "aaXXmm"+"XXmmXX"="aaXXmmXXmmXX"="aa"+"XXmmXX"+"mmXX".
      # That's why the <a string> and the <substitution string> are kept
      # as a pair during the processing.
      #
      ar_subst_needle_pairs=nil
      if b_needle_is_key
         ar_subst_needle_pairs=batchreplace_csnps_needle_is_key(
         ht_needles)
      else
         ar_subst_needle_pairs=batchreplace_csnps_subst_is_key(
         ht_needles)
      end # if
      # One wants to replace the longest needles first. So they're
      # placed to the smallest indices of the array.
      # The idea is that for a haystack like "A cat saw a caterpillar",
      # one wants to remove the "caterpillar" from the sentence before
      # the "cat", because by removing the "cat" first one would break
      # the "caterpillar". Strings that have the same length, can't
      # possibly be eachothers' substrings without equaling with eachother.
      ar_subst_needle_pairs.sort!{|a,b| b[1].length<=>a[1].length}
      ar_pieces=Array.new
      ar_piece=[s_haystack, nil]
      ar_pieces<<ar_piece
      ar_subst_needle=$kibuvits_krl171_lc_emptystring
      ar_piece=nil
      ar_pieces2=Array.new
      ar_subst_needle_pairs.length.times do |i|
         ar_subst_needle=ar_subst_needle_pairs[i]
         ar_pieces.length.times do |ii|
            ar_piece=ar_pieces[ii]
            ar_pieces2=ar_pieces2+
            batchreplace_step(ar_piece, ar_subst_needle)
         end # loop
         ar_pieces.clear # May be it facilitates memory reuse.
         ar_pieces=ar_pieces2
         ar_pieces2=Array.new
      end # loop
      n=ar_pieces.length-1
      ar_s=Array.new
      n.times do |i|
         ar_piece=ar_pieces[i]
         ar_s<<ar_piece[0]
         ar_s<<ar_piece[1]
      end # loop
      ar_s<<(ar_pieces[n])[0]
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      #s_out.force_encoding("utf-8")
      return s_out
   end # s_batchreplace

   def Kibuvits_krl171_str.s_batchreplace(ht_needles, s_haystack, b_needle_is_key=true)
      s_out=Kibuvits_krl171_str.instance.s_batchreplace(ht_needles,s_haystack,
      b_needle_is_key)
      return s_out
   end # Kibuvits_krl171_str.s_batchreplace

   #-----------------------------------------------------------------------

   # The core idea is that if stripes of multiple
   # colors are painted side by side and a paint
   # roller is rolled across the stripes, so that the
   # path of the paint roller intersects the stripes, then the
   # paint roller can be used for painting a repeating
   # pattern of the stripes at some other place.
   #
   # If the s_or_rgx_needle is a string, then it is
   # used as a searchstring, not as a regular expression constructor
   # parameter.
   #
   # The substitution string can be supplied by a function
   # that takes an iteration index, starting from 0, as a
   # parameter. An example, how to crate a 3-stripe provider:
   #
   def s_paintrollerreplace(s_or_rgx_needle_id_est_stripe_placeholder,
      s_or_ar_of_substitution_strings_or_a_function_ie_stripes, s_haystack)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Regexp,String], s_or_rgx_needle_id_est_stripe_placeholder
         kibuvits_krl171_typecheck bn, [Proc,Array,String], s_or_ar_of_substitution_strings_or_a_function_ie_stripes
         kibuvits_krl171_typecheck bn, String, s_haystack
      end # if
      #-------
      rgx_needle=s_or_rgx_needle_id_est_stripe_placeholder
      cl=rgx_needle.class
      if cl==String
         rgx_needle=Regexp.new(s_or_rgx_needle_id_est_stripe_placeholder)
         cl=Regexp
      end # if
      if cl!=Regexp
         kibuvits_krl171_throw("rgx_needle.class=="+cl.to_s+
         "\n GUID='32f0ddec-ebf8-4198-b3cf-c2c2f051a4e7'\n\n")
      end # if
      #-------
      func_paintroller=s_or_ar_of_substitution_strings_or_a_function_ie_stripes
      cl=func_paintroller.class
      if cl==String
         func_paintroller=[func_paintroller]
         cl=Array
      end # if
      ar_stripes=nil
      if cl==Array
         ar_stripes=func_paintroller
         func_paintroller=lambda do |i_n|
            i_sz=ar_stripes.size
            if KIBUVITS_krl171_b_DEBUG
               if i_n<0
                  kibuvits_krl171_throw("i_n == "+i_n.to_s+" < 0 "+
                  "\n GUID='0ce72445-66ed-4ae1-849f-c2c2f051a4e7'\n\n")
               end # if
               if i_sz<1
                  kibuvits_krl171_throw("ar_stripes.size == "+i_sz.to_s+" < 1 "+
                  "\n GUID='d2f50041-6e35-4348-959e-c2c2f051a4e7'\n\n")
               end # if
            end # if
            i_ix=i_n%i_sz
            x_out=ar_stripes[i_ix]
            if KIBUVITS_krl171_b_DEBUG
               if x_out.class!=String # to avoid the string instantiation
                  bn=binding()
                  msg="i_n=="+i_n.to_s+" i_sz=="+i_sz.to_s+" i_ix=="+i_ix.to_s+
                  "\n GUID='0a90a78b-1b17-4df7-956e-c2c2f051a4e7'\n\n"
                  kibuvits_krl171_typecheck bn, String, x_out, msg
               end # if
            end # if
            return x_out
         end # func
         cl=Proc
      end # if
      if KIBUVITS_krl171_b_DEBUG
         if cl!=Proc
            kibuvits_krl171_throw("func_paintroller.class=="+cl.to_s+
            "\n GUID='045cbd58-dcbc-4523-a13e-c2c2f051a4e7'\n\n")
         end # if
         if !func_paintroller.lambda?
            # There are 2 different types of Proc instances:
            # plain Ruby blocks and the ones that are created with the
            # lambda keyword.
            kibuvits_krl171_throw("func_paintroller.lambda? != true"+
            "\n GUID='a88c8f23-fb4c-4e97-b10e-c2c2f051a4e7'\n\n")
         end # if
      end # if
      #-------
      s_hay=s_haystack
      ar_s=Array.new
      md=nil
      ar_pair_and_speedhack=Array.new(2,$kibuvits_krl171_lc_emptystring)
      s_left=nil
      s_right=nil
      ix_paintroller=0
      while true
         md=s_hay.match(rgx_needle)
         break if md==nil
         # At this line the separator always exists in the s_hay.
         ar_pair_and_speedhack=ar_bisect(s_hay,md[0],ar_pair_and_speedhack)
         s_left=ar_pair_and_speedhack[0]
         s_right=ar_pair_and_speedhack[1]
         if s_left==$kibuvits_krl171_lc_emptystring
            ar_s<<func_paintroller.call(ix_paintroller)
            s_hay=s_right
         else
            ar_s<<s_left
            ar_s<<func_paintroller.call(ix_paintroller)
            s_hay=s_right
            break if s_right==$kibuvits_krl171_lc_emptystring
         end # if
         ix_paintroller=ix_paintroller+1
      end # loop
      ar_s<<s_hay
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_out
   end # s_paintrollerreplace

   def Kibuvits_krl171_str.s_paintrollerreplace(s_or_rgx_needle_id_est_stripe_placeholder,
      s_or_ar_of_substitution_strings_or_a_function_ie_stripes, s_haystack)
      s_out=Kibuvits_krl171_str.instance.s_paintrollerreplace(
      s_or_rgx_needle_id_est_stripe_placeholder,
      s_or_ar_of_substitution_strings_or_a_function_ie_stripes, s_haystack)
      return s_out
   end # Kibuvits_krl171_str.s_paintrollerreplace

   #-----------------------------------------------------------------------
   public

   # A citation from http://en.wikipedia.org/wiki/Newline
   # (visit date: January 2010)
   #
   # The Unicode standard defines a large number of characters that
   # conforming applications should recognize as line terminators: [2]
   #
   #  LF:    Line Feed, U+000A
   #  CR:    Carriage Return, U+000D
   #  CR+LF: CR (U+000D) followed by LF (U+000A)
   #  NEL:   Next Line, U+0085
   #  FF:    Form Feed, U+000C
   #  LS:    Line Separator, U+2028
   #  PS:    Paragraph Separator, U+2029
   #
   # The ruby 1.8 string operations do not support Unicode code-points
   # properly
   # (http://blog.grayproductions.net/articles/bytes_and_characters_in_ruby_18 ),
   # TODO: this method is subject to completion after one can fully
   # move to ruby 1.9
   def get_array_of_linebreaks(b_ok_to_be_immutable=false)
      if (@@cache.has_key? 'ar_linebreaks')
         ar_linebreaks_immutable=@@cache['ar_linebreaks']
         ar_linebreaks=ar_linebreaks_immutable
         if !b_ok_to_be_immutable
            ar_linebreaks=Array.new
            ar_linebreaks_immutable.each{|x| ar_linebreaks<<""+x}
         end # if
         return ar_linebreaks
      end # if
      @@mx_cache.synchronize do
         break if (@@cache.has_key? 'ar_linebreaks')
         ar_linebreaks_immutable=["\r\n","\n","\r"]
         ar_linebreaks_immutable.freeze
         @@cache['ar_linebreaks']=ar_linebreaks_immutable
      end # synchronize
      ar_linebreaks_immutable=@@cache['ar_linebreaks']
      ar_linebreaks=ar_linebreaks_immutable
      if !b_ok_to_be_immutable
         ar_linebreaks=Array.new
         ar_linebreaks_immutable.each{|x| ar_linebreaks<<""+x}
      end # if
      return ar_linebreaks
   end # get_array_of_linebreaks

   def Kibuvits_krl171_str.get_array_of_linebreaks(b_ok_to_be_immutable=false)
      ar_linebreaks=Kibuvits_krl171_str.instance.get_array_of_linebreaks(
      b_ok_to_be_immutable)
      return ar_linebreaks
   end # Kibuvits_krl171_str.get_array_of_linebreaks

   #-----------------------------------------------------------------------

   def normalise_linebreaks(s,substitution_string=$kibuvits_krl171_lc_linebreak)
      s_subst=substitution_string
      ar_special_cases=Kibuvits_krl171_str.get_array_of_linebreaks true
      ht_needles=Hash.new
      ht_needles[s_subst]=ar_special_cases
      s_hay=s
      s_out=Kibuvits_krl171_str.s_batchreplace ht_needles, s_hay, false
      return s_out
   end # normalise_linebreaks

   def Kibuvits_krl171_str.normalise_linebreaks(s,substitution_string=$kibuvits_krl171_lc_linebreak)
      s_out=Kibuvits_krl171_str.instance.normalise_linebreaks(s,substitution_string)
      return s_out
   end # Kibuvits_krl171_str.normalise_linebreaks

   #-----------------------------------------------------------------------

   # It returns an array of 2 elements. If the separator is not
   # found, the array[0]==input_string and array[1]=="".
   #
   # The ar_output is for array instance reuse and is expected
   # to increase speed a tiny bit at "snatching".
   def ar_bisect(input_string,separator_string,ar_output=Array.new(2,$kibuvits_krl171_lc_emptystring))
      # If one updates this code, then one should also copy-paste
      # an updated version of this method to the the ProgFTE implementation.
      # The idea behind such an arrangement is that the ProgFTE implementation
      # is not allowed to have any dependencies other than the library booting code.
      #
      # TODO: Optimize it to use smaller temporary string instances. For example,
      #       in stead of "a|b|c|d"->("a", "b|c|d"->("b","c|d"->("c","d")))
      #       one should: "a|b|c|d"->("a|b"->("a","d"),"c|d"->("c","d"))
      i_separator_stringlen=separator_string.length
      if i_separator_stringlen==0
         exc=Exception.new("separator_string==\"\"")
         if @b_kibuvits_krl171_bootfile_run
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      ar=ar_output
      i=input_string.index(separator_string)
      if(i==nil)
         ar[0]=input_string
         ar[1]=$kibuvits_krl171_lc_emptystring
         return ar;
      end # if
      if i==0
         ar[0]=$kibuvits_krl171_lc_emptystring
      else
         ar[0]=input_string[0..(i-1)]
      end # if
      i_input_stringlen=input_string.length
      if (i+i_separator_stringlen)==i_input_stringlen
         ar[1]=$kibuvits_krl171_lc_emptystring
      else
         ar[1]=input_string[(i+i_separator_stringlen)..(-1)]
      end # if
      return ar
   end # ar_bisect

   def Kibuvits_krl171_str.ar_bisect(input_string, separator_string,
      ar_output=Array.new(2,""))
      ar=Kibuvits_krl171_str.instance.ar_bisect(input_string,separator_string,
      ar_output)
      return ar
   end # Kibuvits_krl171_str.ar_bisect

   #-----------------------------------------------------------------------

   # Returns an array of strings that contains only the snatched string pieces.
   def snatch_n_times_t1(s_haystack,s_separator,n)
      # If one updates this code, then one should also copy-paste
      # an updated version of this method to the the ProgFTE implementation.
      # The idea behind such an arrangement is that the ProgFTE implementation
      # is not allowed to have any dependencies other than the library booting code.
      if @b_kibuvits_krl171_bootfile_run
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, String, s_separator
         kibuvits_krl171_typecheck bn, Fixnum, n
      end # if
      if(s_separator=="")
         exc=Exception.new("\nThe separator string had a "+
         "value of \"\", but empty strings are not "+
         "allowed to be used as separator strings.\n"+
         "GUID='51888937-707b-493b-b2dd-c2c2f051a4e7'\n\n")
         if @b_kibuvits_krl171_bootfile_run
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      s_hay=s_haystack
      if s_hay.length==0
         exc=Exception.new("s_haystack.length==0 \n"+
         "GUID='4a58b05d-7ef0-460f-a1ad-c2c2f051a4e7'\n\n")
         if @b_kibuvits_krl171_bootfile_run
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      # It's a bit vague, whether '' is also present at the
      # very end and very start of the string or only between
      # characters. That's why there's a limitation, that the
      # s_separator may not equal with the ''.
      if s_separator.length==0
         exc=Exception.new("s_separator.length==0\n"+
         "GUID='81e1fd15-77d6-41de-b37d-c2c2f051a4e7'\n\n")
         if @b_kibuvits_krl171_bootfile_run
            kibuvits_krl171_throw(exc)
         else
            raise(exc)
         end # if
      end # if
      s_hay=""+s_haystack
      ar=Array.new
      ar1=Array.new(2,"")
      n.times do |i|
         ar1=ar_bisect(s_hay,s_separator,ar1)
         ar<<ar1[0]
         s_hay=ar1[1]
         if (s_hay=='') and ((i+1)<n)
            exc=Exception.new("Expected number of separators is "+n.to_s+
            ", but the s_haystack contained only "+(i+1).to_s+
            "separator strings.\n"+
            "GUID='fea59d34-238e-41ec-824d-c2c2f051a4e7'\n\n")
            if @b_kibuvits_krl171_bootfile_run
               kibuvits_krl171_throw(exc)
            else
               raise(exc)
            end # if
         end # if
      end # loop
      return ar;
   end # snatch_n_times_t1

   def Kibuvits_krl171_str.snatch_n_times_t1(s_haystack, s_separator,n)
      ar_out=Kibuvits_krl171_str.instance.snatch_n_times_t1(s_haystack, s_separator,n)
      return ar_out
   end # Kibuvits_krl171_str.snatch_n_times_t1

   #-----------------------------------------------------------------------

   # Header is in a form:
   #  header_data_length_in_decimaldigits|header_data|therest_of_the_string
   #
   # Throws, if the header is not found.
   # Returns a pair, (s_left, s_right), where
   #
   #  s_left == header_data
   # s_right == therest_of_the_string
   #
   # The header_data and the therest_of_the_string
   # can be empty strings.
   #
   # An example:
   #
   #     s_in=="11|abc abc abc|the rest of the text"
   #
   #     s_left,s_right=s_s_bisect_by_header_t1(s_in)
   #
   #      s_left=="abc abc abc"
   #     s_right=="the rest of the text"
   #
   # The header based architecture is useful, when working with
   # files that do not fit into available RAM.
   def s_s_bisect_by_header_t1(s_in,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='6b575552-fc78-4bd0-911d-c2c2f051a4e7'")
      end # if
      s_left=$kibuvits_krl171_lc_emptystring
      s_right=$kibuvits_krl171_lc_emptystring
      rgx=/^[\d]+[|]/
      md=s_in.match(rgx)
      if md==nil
         s_default_msg="Header data length is missing."
         s_message_id="data_fault_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "87374f3b-df3f-4150-83b6-c2c2f051a4e7")
         return s_left,s_right
      end # if
      i_len_s_in=s_in.length # s_in=="10|heder_data|therestofblabla"
      s_0=md[0] # "10|"
      i_len_header_data=(s_0[0..(-2)]).to_i # "10".to_i
      i_len_s_0=s_0.length
      if (i_len_s_in-i_len_s_0-i_len_header_data-1)<0
         # It's OK for the therestofblabla to be an empty string.
         s_default_msg="\nFlawed header. i_len_header_data =="+
         i_len_header_data.to_s+
         "\ncontradicts with s_in.length == "+i_len_s_in.to_s
         s_message_id="data_fault_t2"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "8cea8130-5b3e-468a-9266-c2c2f051a4e7")
         return s_left,s_right
      end # if
      # Due to the regular expression, rgx, 2<=i_len_s_0
      s_1=s_in[i_len_s_0..(-1)] # "heder_data|therestofblabla"
      # It's OK for the header_data to be an empty string.
      ixs_low=0
      ixs_high=i_len_header_data
      s_left=Kibuvits_krl171_ix.sar(s_1,ixs_low,ixs_high)
      # However, the header might not exist, if the
      # s_1=="heder_data_therestofblabla"
      if s_1[i_len_header_data..i_len_header_data]!=$kibuvits_krl171_lc_pillar
         s_default_msg="\nFlawed header, i.e. the header is considered\n"+
         "to be missing, because the header data block is \n"+
         "not followed by a \"pillar character\" (\"|\"). \n"+
         "\n GUID='cd4d343d-46f6-4487-a4fc-c2c2f051a4e7'\n\n"
         s_message_id="data_fault_t3"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "c87fad11-4f64-409c-8275-c2c2f051a4e7")
         return s_left,s_right
      end # if
      # In Ruby "x"[1..(-1)]==""
      #         "x"[2..(-1)]==nil
      s_right=s_1[(i_len_header_data+1)..(-1)] # +1 due to the "|"
      return s_left,s_right
   end # s_s_bisect_by_header_t1

   def Kibuvits_krl171_str.s_s_bisect_by_header_t1(s_in,msgcs)
      s_left,s_right=Kibuvits_krl171_str.instance.s_s_bisect_by_header_t1(
      s_in,msgcs)
      return s_left,s_right
   end # Kibuvits_krl171_str.s_s_bisect_by_header_t1

   #-----------------------------------------------------------------------
   public

   def i_count_substrings(s_haystack,s_or_rgx_needle)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, [String,Regexp], s_or_rgx_needle
      end # if
      #----
      i_out=nil
      if s_or_rgx_needle.class==String
         i_s_or_rgx_needlelen=s_or_rgx_needle.length
         if i_s_or_rgx_needlelen==0
            kibuvits_krl171_throw("s_or_rgx_needle.class==String is OK, but \n"+
            "s_or_rgx_needle.length==0 is not acceptable, because \n"+
            "every string contains an infinite number of emptystrings.\n"+
            "GUID='1f7ded18-6660-4a1a-94cc-c2c2f051a4e7'\n\n")
         end # if
         # This if-branch is probably redundant, because
         # the onel-liner at the else part does a pretty
         # good job, but the solution in this branch
         # is more straightforward and therefore seems
         # to be more robust, because there's no need
         # to make an thoroughly untested/maybe-properly-untestable
         # assumption about the String.scan(...).
         i_s_haystack=s_haystack.length
         i=s_haystack.gsub(s_or_rgx_needle,$kibuvits_krl171_lc_emptystring).length
         return 0 if i==i_s_haystack
         i_out=(i_s_haystack-i)/i_s_or_rgx_needlelen # It all stays in Fixnum domain.
      else # s_or_rgx_needle.class==Regexp
         # Credits go to the Jon Kern at
         # http://stackoverflow.com/questions/5305638/stringcount-options
         i_out=s_haystack.scan(s_or_rgx_needle).count
      end # if
      return i_out
   end # i_count_substrings

   def Kibuvits_krl171_str.i_count_substrings(s_haystack,s_or_rgx_needle)
      i_out=Kibuvits_krl171_str.instance.i_count_substrings s_haystack, s_or_rgx_needle
      return i_out
   end # Kibuvits_krl171_str.i_count_substrings

   #-----------------------------------------------------------------------
   public

   # It mimics the PHP explode function, but it's not a one to one copy of it.
   # Practically, it converts the s_haystack to an array
   # and uses the s_needle as a separator at repetitive bisection.
   def ar_explode(s_haystack, s_needle)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, String, s_needle
      end # if
      i_s_haystack=s_haystack.length
      return [""] if i_s_haystack==0
      i_s_needlelen=s_needle.length
      if i_s_needlelen==0
         ar_out=Array.new
         i_s_haystack.times{|i| ar_out<<s_haystack[i..i]}
         return ar_out
      end # if
      return [s_haystack] if i_s_haystack<i_s_needlelen
      ar_out=Array.new
      i_needlecount=Kibuvits_krl171_str.i_count_substrings(s_haystack, s_needle)
      s_hay=s_haystack+s_needle
      ar_out=Kibuvits_krl171_str.snatch_n_times_t1(s_hay,s_needle,(i_needlecount+1))
      return ar_out
   end # ar_explode

   def Kibuvits_krl171_str.ar_explode(s_haystack, s_needle)
      ar_out=Kibuvits_krl171_str.instance.ar_explode s_haystack, s_needle
      return ar_out
   end # Kibuvits_krl171_str.ar_explode

   #-----------------------------------------------------------------------
   public

   # Part of the same group of methods with
   #
   #     commaseparated_list_2_ht_t1(...)
   #
   # A member of the reverse of this group of methods is
   #
   #     array2xseparated_list(...)
   #
   # A thing to remember is that some
   # text needs more advanced parsing:  "elephant, giraffe" , "horse", "cow"
   #
   def commaseparated_list_2_ar_t1(s_haystack,s_separator=",")
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, String, s_separator
      end # if
      ar=ar_explode(s_haystack,s_separator)
      ar_out=Array.new
      i_ar_len=ar.size
      s_piece=nil
      s=nil
      i_ar_len.times do |ix|
         s_piece=ar[ix]
         s=trim(s_piece)
         ar_out<<s if 0<s.length
      end # loop
      return ar_out
   end # commaseparated_list_2_ar_t1


   def Kibuvits_krl171_str.commaseparated_list_2_ar_t1(s_haystack,s_separator=",")
      ar_out=Kibuvits_krl171_str.instance.commaseparated_list_2_ar_t1(
      s_haystack,s_separator)
      return ar_out
   end # Kibuvits_krl171_str.commaseparated_list_2_ar_t1


   # Part of the same group of methods with
   #
   #     commaseparated_list_2_ar_t1(...)
   #
   # A member of the reverse of this group of methods is
   #
   #     array2xseparated_list(...)
   #
   def commaseparated_list_2_ht_t1(s_haystack,s_separator=",")
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, String, s_separator
      end # if
      ar=commaseparated_list_2_ar_t1(s_haystack,s_separator)
      ht_out=Hash.new
      i_ar_len=ar.size
      s_piece=nil
      i_ar_len.times do |ix|
         s_piece=ar[ix]
         ht_out[s_piece]=ix
      end # loop
      return ht_out
   end # commaseparated_list_2_ht_t1

   def Kibuvits_krl171_str.commaseparated_list_2_ht_t1(s_haystack,s_separator=",")
      ht_out=Kibuvits_krl171_str.instance.commaseparated_list_2_ht_t1(
      s_haystack,s_separator)
      return ht_out
   end # Kibuvits_krl171_str.commaseparated_list_2_ht_t1


   #-----------------------------------------------------------------------

   def normalize_s2ar_t1(s_or_ar_of_s,s_separator=",")
      cl_0=s_or_ar_of_s.class
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Array], s_or_ar_of_s
         kibuvits_krl171_typecheck bn, String, s_separator
         if cl_0==Array
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,String,
            s_or_ar_of_s,"GUID=='58798cf1-f22d-4433-949c-c2c2f051a4e7'")
         end # if
      end # if
      ar_out=nil
      if cl_0==String
         ar_out=Kibuvits_krl171_str.commaseparated_list_2_ar_t1(
         s_or_ar_of_s,s_separator)
      else
         if cl_0==Array
            ar_out=s_or_ar_of_s
         else
            kibuvits_krl171_throw("s_or_ar_of_s.class=="+cl_0.to_s+
            ",\nbut it is expected to be either String or Array.\n"+
            "GUID='4e6a7334-41f8-4efb-a16c-c2c2f051a4e7'\n\n")
         end # if
      end # if
      return ar_out
   end # normalize_s2ar_t1


   def Kibuvits_krl171_str.normalize_s2ar_t1(s_or_ar_of_s,s_separator=",")
      ar_out=Kibuvits_krl171_str.instance.normalize_s2ar_t1(
      s_or_ar_of_s,s_separator)
      return ar_out
   end # Kibuvits_krl171_str.normalize_s2ar_t1

   #-----------------------------------------------------------------------

   public

   def character_is_escapable(s_character,
      s_characters_that_are_excluded_from_the_list_of_escapables="")
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_character
      end # if
      if s_character.length!=1
         kibuvits_krl171_throw "s_character==\""+s_character+"\", "+"s_character.length!=1"
      end # if
      s_xc=s_characters_that_are_excluded_from_the_list_of_escapables
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_xc
      end # if
      b=false
      if !s_xc.include? s_character
         s_escapables="\"'\n\r\t\\"
         b=s_escapables.include? s_character
      end # if
      return b
   end # character_is_escapable

   def Kibuvits_krl171_str.character_is_escapable(s_character,
      s_characters_that_are_excluded_from_the_list_of_escapables="")
      b=Kibuvits_krl171_str.instance.character_is_escapable(s_character,
      s_characters_that_are_excluded_from_the_list_of_escapables)
      return b
   end # Kibuvits_krl171_str.character_is_escapable

   #-----------------------------------------------------------------------

   def s_escape_spaces_t1(s_in)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
      end # if
      rgx_0=/ / # must not be /[\s]/, because the /[\s]/ escapes the "\n".
      s_out=s_in.gsub(rgx_0,$kibuvits_krl171_lc_escapedspace)
      return s_out
   end # s_escape_spaces_t1

   def Kibuvits_krl171_str.s_escape_spaces_t1(s_in)
      s_out=Kibuvits_krl171_str.instance.s_escape_spaces_t1(s_in)
      return s_out
   end # Kibuvits_krl171_str.s_escape_spaces_t1

   def s_escape_for_bash_t1(s_in)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
      end # if
      s_0=s_in
      s_1=s_0.gsub(/[\\]/,$kibuvits_krl171_lc_4backslashes) # "\" -> "\\"
      # must not be /[\s]/, because the /[\s]/ escapes the "\n".
      s_0=s_1.gsub(/ /,$kibuvits_krl171_lc_escapedspace)
      s_1=s_0.gsub(/[\[]/,"\\[")
      s_0=s_1.gsub(/[{]/,"\\{")
      s_1=s_0.gsub(/[(]/,"\\(")
      s_0=s_1.gsub(/[)]/,"\\)")
      s_1=s_0.gsub(/[\t]/,"\\\t")
      s_0=s_1.gsub(/[\$]/,"\\$")
      s_1=s_0.gsub(/[|]/,"\\|")
      s_0=s_1.gsub(/[>]/,"\\>")
      s_1=s_0.gsub(/[<]/,"\\<")
      s_0=s_1.gsub(/["]/,"\\\"")
      s_1=s_0.gsub(/[']/,"\\\\'")
      s_0=s_1.gsub(/[`]/,"\\\\`")
      s_1=s_0.gsub(/[&]/,"\\\\&")
      s_0=s_1.gsub(/[;]/,"\\\\;")
      s_1=s_0.gsub(/[.]/,"\\.")
      s_out=s_1
      return s_out
   end # s_escape_for_bash_t1

   def Kibuvits_krl171_str.s_escape_for_bash_t1(s_in)
      s_out=Kibuvits_krl171_str.instance.s_escape_for_bash_t1(s_in)
      return s_out
   end # Kibuvits_krl171_str.s_escape_for_bash_t1

   #-----------------------------------------------------------------------
   public

   def index_is_outside_of_the_string(a_string,index)
      # TODO: Move this method to Kibuvits_krl171_ix and make it also work
      # with arrays and alike.
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, a_string
         kibuvits_krl171_typecheck bn, Fixnum, index
      end # if
      b=((index<0)||(a_string.length-1)<index)
      return b
   end # index_is_outside_of_the_string

   def Kibuvits_krl171_str.index_is_outside_of_the_string(a_string,index)
      b=Kibuvits_krl171_str.instance.index_is_outside_of_the_string a_string, index
      return b
   end # Kibuvits_krl171_str.index_is_outside_of_the_string

   #-----------------------------------------------------------------------
   public

   # Explanation by an example:
   # count_character_repetition("aXXaXXX",1)==2
   #                             0123456
   # count_character_repetition("aXXaXXX",4)==3
   #                             0123456
   # count_character_repetition("aXXaXXX",3)==1
   #                             0123456
   # count_character_repetition("aXXaXXX",6)==1
   #                             0123456
   def count_character_repetition(a_string,index_of_the_character)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, a_string
         kibuvits_krl171_typecheck bn, Fixnum, index_of_the_character
      end # if
      i_ix=index_of_the_character
      i_smax=a_string.length-1
      if Kibuvits_krl171_str.index_is_outside_of_the_string(a_string,i_ix)
         kibuvits_krl171_throw "index_of_the_character=="+i_ix.to_s+" is outside of "+
         "string a_string==\""+a_string+"\".\n"+
         "GUID='56e2a230-079a-42ad-813c-c2c2f051a4e7'\n\n"
      end # if
      s_char=a_string[i_ix..i_ix]
      i_count=0
      if Kibuvits_krl171_str.character_is_escapable(s_char)
         i_iix=i_ix
         while i_iix<=i_smax
            break if a_string[i_iix..i_iix]!=s_char
            i_iix=i_iix+1
         end # loop
         i_count=i_iix-i_ix
      else
         s_hay=a_string[i_ix..(-1)]
         rg=Regexp.new("["+s_char+"]+")
         md=rg.match(s_hay)
         kibuvits_krl171_throw "md==nil" if md==nil
         i_count=md[0].length
      end # if
      kibuvits_krl171_throw "i_count=="+i_count.to_s+"<1" if i_count<1
      return i_count
   end # count_character_repetition

   def Kibuvits_krl171_str.count_character_repetition(a_string,index_of_the_character)
      i_count=Kibuvits_krl171_str.instance.count_character_repetition(a_string,
      index_of_the_character)
      return i_count
   end # Kibuvits_krl171_str.count_character_repetition

   #-----------------------------------------------------------------------
   public

   # The idea is that in "\n" and "\\\n" the n is escaped, but in
   # "\\n" and "\\\\\\n" the n is not escaped.
   def character_is_escaped(a_string,index_of_the_character)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, a_string
         kibuvits_krl171_typecheck bn, Fixnum, index_of_the_character
      end # if
      i_ix=index_of_the_character
      if Kibuvits_krl171_str.index_is_outside_of_the_string(a_string,i_ix)
         kibuvits_krl171_throw "index_of_the_character=="+i_ix.to_s+" is outside of "+
         "string a_string==\""+a_string+"\"."
      end # if
      return false if i_ix==0
      i_prfx=i_ix-1
      return false if a_string[i_prfx..i_prfx]!="\\"
      s_az=(a_string[0..i_prfx]).reverse
      i_count=Kibuvits_krl171_str.count_character_repetition(s_az, 0)
      b_is_escaped=((i_count%2)==1)
      return b_is_escaped
   end # character_is_escaped

   def Kibuvits_krl171_str.character_is_escaped(a_string,index_of_the_character)
      b_is_escaped=Kibuvits_krl171_str.instance.character_is_escaped(a_string,
      index_of_the_character)
      return b_is_escaped
   end # Kibuvits_krl171_str.character_is_escaped

   #-----------------------------------------------------------------------
   public

   def clip_tail_by_str(s_haystack,s_needle)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, String, s_needle
      end # if
      i_sh_len=s_haystack.length
      i_sn_len=s_needle.length
      s_hay=s_haystack+$kibuvits_krl171_lc_emptystring # to return a different instance
      return s_hay if (i_sh_len<i_sn_len)||(i_sn_len==0)
      if i_sh_len==i_sn_len
         if s_hay==s_needle
            return $kibuvits_krl171_lc_emptystring
         else
            # For speed only. There's no point of re-comparing.
            return s_hay
         end # if
      end # if
      if s_hay[(i_sh_len-i_sn_len)..(-1)]==s_needle
         return s_hay[0..(i_sh_len-i_sn_len-1)]
      end # if
      return s_hay
   end # clip_tail_by_str

   def Kibuvits_krl171_str.clip_tail_by_str(s_haystack,s_needle)
      s_hay=Kibuvits_krl171_str.instance.clip_tail_by_str(s_haystack,s_needle)
      return s_hay
   end # Kibuvits_krl171_str.clip_tail_by_str

   #-----------------------------------------------------------------------
   public

   # Removes spaces, line breaks and tabs from the start and end of the string.
   def trim(s_string)
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), String, s_string
      end # if
      rgx=/^[\s\t\r\n]+/
      s_out=s_string.gsub(rgx,$kibuvits_krl171_lc_emptystring)
      s_out=s_out.reverse.gsub(rgx,$kibuvits_krl171_lc_emptystring).reverse
      return s_out
   end # trim

   def Kibuvits_krl171_str.trim(s_string)
      s_out=Kibuvits_krl171_str.instance.trim s_string
      return s_out
   end # Kibuvits_krl171_str.trim


   # The point behind this method is that if the array
   # has zero elements, the output is an empty string,
   # but there should not be any commas after the very last element.
   #
   # A member of the reverse of this group of methods is
   #
   #     commaseparated_list_2_ar_t1(...)
   #
   def array2xseparated_list(ar,s_separator=", ",
      s_left_brace=$kibuvits_krl171_lc_emptystring,
      s_right_brace=$kibuvits_krl171_lc_emptystring)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array, ar
         kibuvits_krl171_typecheck bn, String, s_separator
         kibuvits_krl171_typecheck bn, String, s_left_brace
         kibuvits_krl171_typecheck bn, String, s_right_brace
      end # if
      s_out="" # not $kibuvits_krl171_lc_emptystring to allow the << operator to work later
      return s_out if ar.length==0
      b_at_least_one_element_is_already_in_the_list=false
      ar_s=Array.new
      if s_left_brace==$kibuvits_krl171_lc_emptystring
         if s_right_brace==$kibuvits_krl171_lc_emptystring
            ar.each do |s_x|
               if b_at_least_one_element_is_already_in_the_list
                  ar_s<<s_separator
               else
                  b_at_least_one_element_is_already_in_the_list=true
               end # if
               ar_s<<s_x.to_s
            end # end
         else # only right bracket is present
            ar.each do |s_x|
               if b_at_least_one_element_is_already_in_the_list
                  ar_s<<s_separator
               else
                  b_at_least_one_element_is_already_in_the_list=true
               end # if
               ar_s<<s_x.to_s
               ar_s<<s_right_brace
            end # end
         end # if
      else
         if s_right_brace==$kibuvits_krl171_lc_emptystring
            ar.each do |s_x|
               if b_at_least_one_element_is_already_in_the_list
                  ar_s<<s_separator
               else
                  b_at_least_one_element_is_already_in_the_list=true
               end # if
               ar_s<<s_left_brace
               ar_s<<s_x.to_s
            end # end
         else # both braces are present
            ar.each do |s_x|
               if b_at_least_one_element_is_already_in_the_list
                  ar_s<<s_separator
               else
                  b_at_least_one_element_is_already_in_the_list=true
               end # if
               ar_s<<s_left_brace
               ar_s<<s_x.to_s
               ar_s<<s_right_brace
            end # end
         end # if
      end # if
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_out
   end # array2xseparated_list

   def Kibuvits_krl171_str.array2xseparated_list(ar,s_separator=", ",
      s_left_brace=$kibuvits_krl171_lc_emptystring,
      s_right_brace=$kibuvits_krl171_lc_emptystring)
      s_out=Kibuvits_krl171_str.instance.array2xseparated_list(
      ar,s_separator,s_left_brace,s_right_brace)
      return s_out
   end # Kibuvits_krl171_str.array2xseparated_list

   #-----------------------------------------------------------------------
   public

   # Returns a string. In many, but not all, cases it
   # doesn't stop the infinite recursion, if there's a
   # condition that a hashtable is an element of oneself
   # or an element of one of its elements.
   #
   # This method is useful for generating console output during debugging.
   def ht2str(ht, s_pair_prefix="",s_separator=$kibuvits_krl171_lc_linebreak)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht
         kibuvits_krl171_typecheck bn, String, s_separator
      end # if
      s_out=""
      i_max_len=0
      i=nil
      ht.each_key do |a_key|
         i=a_key.to_s.length
         i_max_len=i if i_max_len<i
      end # loop
      s_x=""
      cl=nil
      b_first_line=true
      s_child_prefix=s_pair_prefix+"  "
      s_key=nil
      ht.each_pair do |a_key,a_value|
         s_out=s_out+s_separator if !b_first_line
         b_first_line=false
         cl=a_value.class.to_s
         s_key=a_key.to_s
         s_key=(" "*(i_max_len-s_key.length))+s_key
         case cl
         when "Array"
            s_x="["+Kibuvits_krl171_str.array2xseparated_list(a_value)+"]"
            s_out=s_out+s_pair_prefix+s_key+"="+s_x
         when "Hash"
            s_x=Kibuvits_krl171_str.ht2str(a_value,
            " "*(i_max_len+1)+s_child_prefix)
            s_out=s_out+s_key+"=Hash\n"+s_x
         when "NilClass"
            s_out=s_out+s_pair_prefix+s_key+"=nil"
         else
            s_x=a_value.to_s
            s_out=s_out+s_pair_prefix+s_key+"="+s_x
         end
      end # loop
      return s_out
   end # ht2str

   def Kibuvits_krl171_str.ht2str(ht, s_pair_prefix="",s_separator=$kibuvits_krl171_lc_linebreak)
      s=Kibuvits_krl171_str.instance.ht2str(ht,s_pair_prefix,s_separator)
      return s
   end # Kibuvits_krl171_str.ht2str

   #-----------------------------------------------------------------------

   # If the ar_speedoptimization_prefixes_as_regexps.class==Array
   # and
   # ar_speedoptimization_prefixes_as_regexps.size==0
   # and
   # ar_or_s_prefix!="" and ar_or_s_prefix.size!=0
   # then the ar_speedoptimization_prefixes_as_regexps
   # is filled with regular expression objects that
   # have been generated from the ar_or_s_prefix.
   #
   # If the ar_speedoptimization_prefixes_as_regexps.class==Array
   # and
   # 0 < ar_speedoptimization_prefixes_as_regexps.size
   # then
   # the content of the ar_or_s_prefix is ignored.
   #
   # Empty string is considered to be the prefix of all
   # strings, including an empty string.
   #
   # The elements of the ar_speedoptimization_prefixes_as_regexps
   # must not be created or edited outside of this function.
   def b_has_prefix(ar_or_s_prefix, s_haystack,
      ar_speedoptimization_prefixes_as_regexps=[])
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Array], ar_or_s_prefix
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, Array, ar_speedoptimization_prefixes_as_regexps

         if ar_or_s_prefix.class==Array
            kibuvits_krl171_typecheck_ar_content(bn,String,
            ar_or_s_prefix,
            "\nGUID='72401009-3d40-4b30-920c-c2c2f051a4e7'\n\n")
         end # if
         kibuvits_krl171_typecheck_ar_content(bn,Regexp,
         ar_speedoptimization_prefixes_as_regexps,
         "\nGUID='aae5d241-05a4-4132-a2db-c2c2f051a4e7'\n\n")
      end # if
      ar_rgx=ar_speedoptimization_prefixes_as_regexps
      if ar_rgx.size==0
         rgx=nil
         ar_prefixes=Kibuvits_krl171_ix.normalize2array(ar_or_s_prefix).uniq
         ar_prefixes.each do |s_prefix|
            if s_prefix==$kibuvits_krl171_lc_emptystring
               # There is no point of studying the
               # other prefixes, if the empty string
               # is considered to be a prefix of all strings.
               ar_rgx=[/^/]
               break
            end # if
            rgx=Regexp.new($kibuvits_krl171_lc_powersign+s_prefix)
            ar_rgx<<rgx
         end # loop
      end # if
      b_out=false
      if ar_rgx.size==1
         if ar_rgx[0].to_s==/^/.to_s
            # An empty string is considered to be a prefix of all strings.
            b_out=true
            return b_out
         end # if
      end # if
      s_0=nil
      i_len_s_haystack=s_haystack.length
      return b_out if i_len_s_haystack==0 # speed hack
      ar_rgx.each do |rgx|
         s_0=s_haystack.sub(rgx,$kibuvits_krl171_lc_emptystring)
         if s_0.length!=i_len_s_haystack
            b_out=true
            break
         end # if
      end # loop
      return b_out
   end # b_has_prefix


   def Kibuvits_krl171_str.b_has_prefix(ar_or_s_prefix, s_haystack,
      ar_speedoptimization_prefixes_as_regexps=[])
      b_out=Kibuvits_krl171_str.instance.b_has_prefix(ar_or_s_prefix, s_haystack,
      ar_speedoptimization_prefixes_as_regexps)
      return b_out
   end # Kibuvits_krl171_str.b_has_prefix

   #-----------------------------------------------------------------------
   public

   # The b_s_text_has_been_normalized_to_use_unix_line_breaks exists
   # only because the line-break normalization can be expensive, specially
   # if it is called very often, for example, during the processing of
   # a "big" set of "small" strings.
   def surround_lines(s_line_prefix,s_text,s_line_suffix,
      b_s_text_has_been_normalized_to_use_unix_line_breaks=false)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_line_prefix
         kibuvits_krl171_typecheck bn, String, s_text
         kibuvits_krl171_typecheck bn, String, s_line_suffix
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_s_text_has_been_normalized_to_use_unix_line_breaks
      end # if
      s_in=s_text
      if !b_s_text_has_been_normalized_to_use_unix_line_breaks
         s_in=Kibuvits_krl171_str.normalise_linebreaks(s_text, $kibuvits_krl171_lc_linebreak)
      end # if
      s_out=""
      s_cropped=nil
      b_nonfirst=false
      s_in.each_line do |s_line|
         s_out=s_out+$kibuvits_krl171_lc_linebreak if b_nonfirst
         b_nonfirst=true
         s_cropped=clip_tail_by_str(s_line, $kibuvits_krl171_lc_linebreak)
         s_out=s_out+s_line_prefix+s_cropped+s_line_suffix
      end # loop
      return s_out
   end # surround_lines

   def Kibuvits_krl171_str.surround_lines(s_line_prefix,s_text,s_line_suffix,
      b_s_text_has_been_normalized_to_use_unix_line_breaks=false)
      s_out=Kibuvits_krl171_str.instance.surround_lines(
      s_line_prefix,s_text,s_line_suffix,
      b_s_text_has_been_normalized_to_use_unix_line_breaks)
      return s_out
   end #Kibuvits_krl171_str.surround_lines

   #-----------------------------------------------------------------------
   public

   # The elements of the array "ar" do not have to
   # be strings, because prior to comparison their to_s
   # methods are called. If the output array
   # contains anything at all, the output array will consists
   # of the references to the original array elements.
   #
   # If b_output_is_a_hashtable==false, the output is an array.
   # If b_output_is_a_hashtable==true, the output is a hashtable, where
   # the output is in the role of keys. The values are set to 42.
   def filter_array(condition_in_a_form_of_aregex_or_a_string, ar,
      b_condition_is_true_for_the_output_elements=true,
      b_output_is_a_hashtable=false)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Regexp], condition_in_a_form_of_aregex_or_a_string
         kibuvits_krl171_typecheck bn, Array, ar
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_condition_is_true_for_the_output_elements
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_output_is_a_hashtable
      end # if
      md=nil
      rgx=condition_in_a_form_of_aregex_or_a_string
      if condition_in_a_form_of_aregex_or_a_string.class==String
         rgx=Regexp.compile(condition_in_a_form_of_aregex_or_a_string)
      end # if
      x_out=nil
      if b_output_is_a_hashtable # The branches are to keep if out of the loop.
         ht_out=Hash.new
         i_42=42 # One Fixnum instance per whole ht_out.
         if b_condition_is_true_for_the_output_elements
            ar.each do |x|
               ht_out[x]=i_42 if rgx.match(x.to_s)!=nil
            end # loop
         else
            ar.each do |x|
               ht_out[x]=i_42 if rgx.match(x.to_s)==nil
            end # loop
         end # if
         x_out=ht_out
      else
         ar_out=Array.new
         i_arlen=ar.length # To guarantee the order, which is useful for testing.
         if b_condition_is_true_for_the_output_elements
            i_arlen.times do |i|
               x=ar[i]
               if rgx.match(x.to_s)!=nil
                  ar_out<<x
               end # if
            end # loop
         else
            i_arlen.times do |i|
               x=ar[i]
               if rgx.match(x.to_s)==nil
                  ar_out<<x
               end # if
            end # loop
         end # if
         x_out=ar_out
      end # if b_output_is_a_hashtable
      return x_out
   end # filter_array

   def Kibuvits_krl171_str.filter_array(condition_in_a_form_of_aregex_or_a_string, ar,
      b_condition_is_true_for_the_output_elements=true,
      b_output_is_a_hashtable=false)
      ar_out=Kibuvits_krl171_str.instance.filter_array(
      condition_in_a_form_of_aregex_or_a_string,
      ar, b_condition_is_true_for_the_output_elements,
      b_output_is_a_hashtable)
      return ar_out
   end # Kibuvits_krl171_str.filter_array

   #-----------------------------------------------------------------------
   private

   def verify_s_is_within_domain_check(s_to_test,ar_domain)
      b_verification_failed=true
      ar_domain.each do |s|
         kibuvits_krl171_throw "s.class=="+s.class.to_s if s.class!=String
         if s==s_to_test
            b_verification_failed=false
            break
         end # if
      end # loop
      return b_verification_failed
   end # verify_s_is_within_domain_check

   public

   # The s_actio_on_verification_failure has the following domain:
   # {"note_in_msgcs","throw","print_and_exit","exit"}
   def verify_s_is_within_domain(s_to_test,s_or_ar_of_domain_elements,
      msgcs,s_action_on_verification_failure="note_in_msgcs",
      s_language_to_use_for_printing=$kibuvits_krl171_lc_English)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_to_test
         kibuvits_krl171_typecheck bn, [Array,String], s_or_ar_of_domain_elements
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         kibuvits_krl171_typecheck bn, String, s_action_on_verification_failure
         kibuvits_krl171_typecheck bn, String, s_language_to_use_for_printing
      end # if
      s_cache_key='verify_s_is_within_domain_actions'
      ht_action_domain=nil
      if !@@cache.has_key? s_cache_key
         ht_action_domain=Hash.new
         i=42
         ht_action_domain["note_in_msgcs"]=i
         ht_action_domain["throw"]=i
         ht_action_domain["print_and_exit"]=i
         ht_action_domain["exit"]=i
         @@cache[s_cache_key]=ht_action_domain
      else
         ht_action_domain=@@cache[s_cache_key]
      end # if
      if !ht_action_domain.has_key? s_action_on_verification_failure
         s="s_action_on_verification_failure==\""+
         s_action_on_verification_failure+"\", but supported values are: "
         ar=Array.new
         ht_action_domain.each_key{|x| ar<<x}
         s=s+array2xseparated_list(ar)
         kibuvits_krl171_throw s
      end # if
      ar_domain=Kibuvits_krl171_ix.normalize2array(s_or_ar_of_domain_elements)
      b_verification_failed=verify_s_is_within_domain_check(s_to_test,ar_domain)
      return if !b_verification_failed
      s_domain=array2xseparated_list(ar_domain)
      s_msg_en="s_to_test==\""+s_to_test+"\", but it is expected to be \n"+
      "one of the following: "+s_domain+" ."
      s_msg_ee="s_to_test==\""+s_to_test+"\", kuid ta peaks omama \n"+
      "ühte järgnevaist väärtustest: "+s_domain+" ."
      msgcs.cre(s_msg_en,1.to_s)
      msgcs.last[$kibuvits_krl171_lc_Estonian]=s_msg_ee
      case s_action_on_verification_failure
      when "throw"
         kibuvits_krl171_throw msgcs.to_s(s_language_to_use_for_printing)
      when "note_in_msgcs"
         # One does nothing.
      when "print_and_exit"
         kibuvits_krl171_writeln msgcs.to_s(s_language_to_use_for_printing)
         exit
      when "exit"
         exit
      else
         kibuvits_krl171_throw "s_action_on_verification_failure=="+s_action_on_verification_failure.to_s
      end # case
   end # verify_s_is_within_domain

   def Kibuvits_krl171_str.verify_s_is_within_domain(s_to_test,s_or_ar_of_domain_elements,
      msgcs,s_action_on_verification_failure="note_in_msgcs",
      s_language_to_use_for_printing=$kibuvits_krl171_lc_English)
      Kibuvits_krl171_str.instance.verify_s_is_within_domain(
      s_to_test,s_or_ar_of_domain_elements, msgcs,
      s_action_on_verification_failure,s_language_to_use_for_printing)
   end # Kibuvits_krl171_str.verify_s_is_within_domain

   #-----------------------------------------------------------------------
   public

   def str2strliteral(s_in,s_quotation_mark=$kibuvits_krl171_lc_doublequote,
      b_escape_quotation_marks=true, b_escape_backslashes=true,
      s_concatenation_mark="+")
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_typecheck bn, String, s_quotation_mark
         kibuvits_krl171_typecheck bn, [FalseClass,TrueClass], b_escape_quotation_marks
         kibuvits_krl171_typecheck bn, [FalseClass,TrueClass], b_escape_backslashes
         kibuvits_krl171_typecheck bn, String, s_concatenation_mark
      end # if
      s=s_in
      s=s.gsub("\\","\\\\\\\\") if b_escape_backslashes
      s=s.gsub(s_quotation_mark,"\\"+s_quotation_mark) if b_escape_quotation_marks
      s_out=""
      b_nonfirst=false
      s_tmp=nil
      s_separator=s_concatenation_mark+$kibuvits_krl171_lc_linebreak
      s.each_line do |s_line|
         s_out=s_out+s_separator if b_nonfirst
         s_tmp=Kibuvits_krl171_str.clip_tail_by_str(s_line,$kibuvits_krl171_lc_linebreak)
         s_tmp=s_quotation_mark+s_tmp+s_quotation_mark
         s_out=s_out+s_tmp
         b_nonfirst=true
      end # loop
      return s_out
   end # str2strliteral

   def Kibuvits_krl171_str.str2strliteral(s_in,s_quotation_mark=$kibuvits_krl171_lc_doublequote,
      b_escape_quotation_marks=true, b_escape_backslashes=true,
      s_concatenation_mark="+")
      s_out=Kibuvits_krl171_str.instance.str2strliteral(s_in,s_quotation_mark,
      b_escape_quotation_marks,b_escape_backslashes,s_concatenation_mark)
      return s_out
   end # Kibuvits_krl171_str.str2strliteral

   #-----------------------------------------------------------------------
   public

   # Returns true, if the s_candidate contains at least one linebreak,
   # space or tabulation character.
   def str_contains_spacestabslinebreaks(s_candidate)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_candidate
      end # if
      s=normalise_linebreaks(s_candidate)
      i_len1=s.length
      s=s.gsub(/[\s\t\n]/,"")
      i_len2=s.length
      b_out=(i_len1!=i_len2)
      return b_out;
   end # str_contains_spacestabslinebreaks

   def Kibuvits_krl171_str.str_contains_spacestabslinebreaks(s_candidate)
      b_out=Kibuvits_krl171_str.instance.str_contains_spacestabslinebreaks(
      s_candidate)
      return b_out
   end # Kibuvits_krl171_str.str_contains_spacestabslinebreaks

   #-----------------------------------------------------------------------
   public

   def datestring_for_fs_prefix(dt)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Time, dt
      end # if
      s_out=$kibuvits_krl171_lc_emptystring
      i=dt.month
      s=i.to_s
      s="0"+s if i<10
      s_out=(dt.year.to_s+$kibuvits_krl171_lc_underscore)+(s+$kibuvits_krl171_lc_underscore)
      i=dt.day
      s=i.to_s
      s="0"+s if i<10
      s_out=s_out+s
      return s_out
   end # datestring_for_fs_prefix

   def Kibuvits_krl171_str.datestring_for_fs_prefix(dt)
      s_out=Kibuvits_krl171_str.instance.datestring_for_fs_prefix(dt)
      return s_out
   end # Kibuvits_krl171_str.datestring_for_fs_prefix(dt)

   #-----------------------------------------------------------------------
   public

   # It converts a Unicode codepoint to a single character string.
   #
   # It's partly derived from a Unicode utility written by David Flangan:
   # http://www.davidflanagan.com/2007/08/index.html#000136
   def s_i2unicode(i_codepoint)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Fixnum, i_codepoint
      end # if
      if (i_codepoint<0)||(@i_unicode_maximum_codepoint<i_codepoint)
         raise("i_codepoint=="+i_codepoint.to_s+
         ", but the valid range is 0 to "+@i_unicode_maximum_codepoint.to_s)
      end # end
      s_out=[i_codepoint].pack("U")
      return s_out
   end # s_i2unicode

   def Kibuvits_krl171_str.s_i2unicode(i_codepoint)
      s_out=Kibuvits_krl171_str.instance.s_i2unicode(i_codepoint)
      return s_out
   end # Kibuvits_krl171_str.s_i2unicode

   #-----------------------------------------------------------------------

   # Returns substring of the s_haystack. The output does not contain
   # the s_start and s_end, i.e. the s_start and s_end have been "trimmed"
   # away. The output may be an empty string. It's OK for the bounds
   # to reside at separate lines, but they both have to exist.
   #
   def s_get_substring_by_bounds(s_haystack,s_start,s_end,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_haystack
         kibuvits_krl171_typecheck bn, String, s_start
         kibuvits_krl171_typecheck bn, String, s_end
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         kibuvits_krl171_assert_string_min_length(bn,s_start,1)
         kibuvits_krl171_assert_string_min_length(bn,s_end,1)
         msgcs.assert_lack_of_failures(
         "GUID='13d3bb74-fbba-4a62-93ab-c2c2f051a4e7'")
      end # if
      s_out=""
      i_start=s_haystack.index(s_start)
      if i_start==nil
         s_message_id="s_get_substring_by_bounds_err_0"
         s_msg_en="The start bound, s_start==\""+s_start+
         "\", is missing from the haystack."
         s_msg_ee="Algust markeeriv sõne, s_start==\""+
         s_start+"\", on uuritavast tekstist puudu."
         msgcs.cre(s_msg_en,s_message_id,true)
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_msg_ee
         return s_out;
      end # if
      i_end=s_haystack.index(s_end)
      if i_end==nil
         s_message_id="s_get_substring_by_bounds_err_1"
         s_msg_en="The end bound, s_end==\""+s_end+
         "\", is missing from the haystack."
         s_msg_ee="Lõppu markeeriv sõne, s_end==\""+
         s_end+"\", on uuritavast tekstist puudu."
         msgcs.cre(s_msg_en,s_message_id,true)
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_msg_ee
         return s_out;
      end # if
      if i_end<=i_start
         s_message_id="s_get_substring_by_bounds_err_3"
         s_msg_en="The end bound ,i_end=="+i_end.to_s+
         ", s_end==\""+s_end+
         "\", resided at a lower index than the start bound, s_start=\""+
         s_start+"\", i_start=="+i_start.to_s+"."
         s_msg_ee="Lõppu markeeriv sõne, s_end==\""+s_end+
         "\", asus madalamal indeksil, i_end=="+i_end.to_s+
         ", kui algust markeeriv sõne, i_start=="+s_start.to_s+"."
         msgcs.cre(s_msg_en,s_message_id,true)
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_msg_ee
         return s_out;
      end # if
      s_out=s_haystack[(i_start+s_start.length)..(i_end-1)]
      return s_out
   end # s_get_substring_by_bounds


   def Kibuvits_krl171_str.s_get_substring_by_bounds(s_haystack,s_start,s_end,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      s_out=Kibuvits_krl171_str.instance.s_get_substring_by_bounds(
      s_haystack,s_start,s_end,msgcs)
      return s_out
   end # Kibuvits_krl171_str.s_get_substring_by_bounds

   #-----------------------------------------------------------------------

   # Precedes the i_in.to_s with zeros ("0") so that the
   # i_minimum_amount_of_digits<=s_out.length .
   def s_to_s_with_assured_amount_of_digits_t1(i_minimum_amount_of_digits,
      i_positive_whole_number)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Fixnum, i_minimum_amount_of_digits
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_positive_whole_number
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         1, i_minimum_amount_of_digits,
         "GUID='580c6b12-e61e-4356-b37b-c2c2f051a4e7'")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_positive_whole_number,
         "GUID='037a2d1b-1024-463a-b24b-c2c2f051a4e7'")
      end # if
      s_0=i_positive_whole_number.to_s
      i_0=i_minimum_amount_of_digits-s_0.length
      s_0=("0"*i_0)+s_0 if 0<i_0
      return s_0
   end # s_to_s_with_assured_amount_of_digits_t1

   def Kibuvits_krl171_str.s_to_s_with_assured_amount_of_digits_t1(
      i_minimum_amount_of_digits, i_positive_whole_number)
      s_out=Kibuvits_krl171_str.instance.s_to_s_with_assured_amount_of_digits_t1(
      i_minimum_amount_of_digits, i_positive_whole_number)
      return s_out
   end # Kibuvits_krl171_str.s_to_s_with_assured_amount_of_digits_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_str

#==========================================================================
# Samples:
# TODO: fix the next example
#s_haystack="ABBCDDD"
#s_0=Kibuvits_krl171_str.s_get_substring_by_bounds(s_haystack,"A","CD")
#kibuvits_krl171_writeln s_0
#=====================kibuvits_krl171_str_rb_end==================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_str_rb_start".
#==========================================================================

#=====================kibuvits_krl171_io_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_io_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2009, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str_concat_array_of_strings.rb"
end # if

#==========================================================================

# For string output, the kibuvits_krl171_writeln and kibuvits_krl171_write
# are defined in the kibuvits_krl171_boot.rb
# WARNING: it's not that well tested.
def kibuvits_krl171_write_to_stdout data
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      # It's like the kibuvits_krl171_writeln, but without the
      an_io=STDOUT.reopen($stdout)
      an_io.write data
      an_io.flush
      an_io.close
   end # synchronize
end # kibuvits_krl171_write_to_stdout

#--------------------------------------------------------------------------
def str2file(s_a_string, s_fp)
   if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_a_string
         kibuvits_krl171_typecheck bn, String, s_fp
      end # if
   end # if
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      begin
         file=File.open(s_fp, "w")
         file.write(s_a_string)
         file.close
      rescue Exception =>err
         raise "No comments. GUID='1170b34c-f540-4031-851b-c2c2f051a4e7' \n"+
         "s_a_string=="+s_a_string+"\n"+err.to_s+"\n\n"
      end #
   end # synchronize
end # str2file

#--------------------------------------------------------------------------

# It's actually a copy of a TESTED version of
# kibuvits_krl171_s_concat_array_of_strings
# and this copy here is made to avoid making the
# kibuvits_krl171_io.rb to depend on the kibuvits_krl171_str.rb
def kibuvits_krl171_hack_to_break_circular_dependency_between_io_and_str_kibuvits_krl171_s_concat_array_of_strings(ar_in)
   n=ar_in.size
   if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array, ar_in
         s=nil
         n.times do |i|
            bn=binding()
            s=ar_in[i]
            kibuvits_krl171_typecheck bn, String, s
         end # loop
      end # if
   end # if
   s_out="";
   n.times{|i| s_out<<ar_in[i]}
   return s_out;
end # kibuvits_krl171_hack_to_break_circular_dependency_between_io_and_str_kibuvits_krl171_s_concat_array_of_strings


def file2str(s_file_path)
   s_out=$kibuvits_krl171_lc_emptystring
   if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path
      end # if
   end # if
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      # The idea here is to make the file2str easily copy-pastable to projects that
      # do not use the Kibuvits Ruby Library.
      s_fp=s_file_path
      ar_lines=Array.new
      begin
         File.open(s_fp) do |file|
            while line = file.gets
               ar_lines<<$kibuvits_krl171_lc_emptystring+line
            end # while
         end # Open-file region.
         if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
            s_out=kibuvits_krl171_s_concat_array_of_strings(ar_lines)
         else
            s_out=kibuvits_krl171_hack_to_break_circular_dependency_between_io_and_str_kibuvits_krl171_s_concat_array_of_strings(ar_lines)
         end # if
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='2227e755-2293-4a02-a1ea-c2c2f051a4e7'\n\n"))
      end #
   end # synchronize
   return s_out
end # file2str

#--------------------------------------------------------------------------

def kibuvits_krl171_ar_i_2_file_t1(ar_i,s_file_path)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Array, ar_i
      kibuvits_krl171_typecheck bn, String, s_file_path
   end # if
   # Credits for the Array.pack solution go to:
   # http://stackoverflow.com/questions/941856/write-binary-file-in-ruby
   x_binary_string=ar_i.pack("C*") # 8 bit unsigned integer
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      begin
         File.open(s_file_path,"wb") do |file|
            file.write(x_binary_string)
         end # Open-file region.
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='7df1bf1c-58af-473a-92ba-c2c2f051a4e7'\n\n"))
      end #
   end # synchronize
end # kibuvits_krl171_ar_i_2_file_t1

def kibuvits_krl171_file_2_ar_i_t1(s_file_path)
   ar_out=Array.new
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String, s_file_path
   end # if
   s_fp=s_file_path
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      begin
         File.open(s_fp) do |file|
            file.each_byte do |i_byte|
               ar_out<<i_byte
            end # loop
         end # Open-file region.
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='b927c2d4-7ed9-45f1-a48a-c2c2f051a4e7'\n\n"))
      end #
   end # synchronize
   return ar_out
end # kibuvits_krl171_file_2_ar_i_t1

#--------------------------------------------------------------------------

# All of the numbers in the ar_i must be in range [0,255]
def kibuvits_krl171_s_armour_t1(ar_i)
   i_len_ar_i=ar_i.size
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, Array, ar_i
      x_i=nil
      i_len_ar_i.times do |i|
         bn1=binding()
         x_i=ar_i[i]
         kibuvits_krl171_typecheck bn1, Fixnum, x_i
         if x_i<0
            kibuvits_krl171_throw("x_i == "+x_i.to_s+" < 0 "+
            "\n GUID='856b4448-f56d-467b-945a-c2c2f051a4e7'\n\n")
         end # if
         if 255<x_i
            kibuvits_krl171_throw(" 255 < x_i == "+x_i.to_s+
            "\n GUID='498519c8-1a8f-4cd1-b12a-c2c2f051a4e7'\n\n")
         end # if
      end # loop
   end # if
   s_out=$kibuvits_krl171_lc_emptystring
   # The range [A000,A48C]_hex has been chosen simply
   # because it covers a whole byte, [0,FF]_hex
   # and has an interesting language name, Yi,
   #
   # http://en.wikipedia.org/wiki/Yi_people
   # http://www.unicode.org/charts/PDF/UA000.pdf
   #
   # This way every byte can be represented by
   # a single existing Unicode character without
   # any branching, jumping, over/around Unicode "holes",
   # unassigned Unicode code points.
   #
   # A single byte is armoured as 2 byte Unicode
   # character, but this approach saves data
   # volume at later steps.
   #
   # For example, 255_base_10 is armoured to
   # 2 characters in hex, the FF_base_16, but
   # it is a single character, if armoured to Yi.
   # If the Yi characters are encrypted,
   # character-by-charcter and the number of
   # characters that the encryption function
   # returns is at least double the input data volume of the
   # encryption function, then minimizing
   # the amount of characters at armouring
   # step yields a considerable winning.
   ar_s=Array.new
   s_0=nil
   x_i=nil
   i_zero="A000".to_i(16)
   i_len_ar_i.times do |i|
      x_i=i_zero+ar_i[i]
      s_0="".concat(x_i)
      ar_s<<s_0
   end # loop
   s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
   return s_out
end #  kibuvits_krl171_s_armour_t1

def kibuvits_krl171_ar_i_dearmour_t1(s_armoured)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String, s_armoured
   end # if
   ar_out=Array.new
   ar_unicode=s_armoured.codepoints
   i_len=ar_unicode.size
   return ar_out if i_len==0
   i_zero="A000".to_i(16)
   i_x=nil
   if KIBUVITS_krl171_b_DEBUG
      i_len.times do |ix|
         i_x=ar_unicode[ix]-i_zero
         if i_x<0
            kibuvits_krl171_throw("i_x == "+i_x.to_s+" < 0 "+
            "\n GUID='d833745e-ff3d-46ab-91f9-c2c2f051a4e7'\n\n")
         end # if
         if 255<i_x
            kibuvits_krl171_throw(" 255 < i_x == "+i_x.to_s+
            "\n GUID='efb33e23-7215-48da-92c9-c2c2f051a4e7'\n\n")
         end # if
         ar_out<<i_x
      end # loop
   else
      i_len.times do |ix|
         i_x=ar_unicode[ix]-i_zero
         ar_out<<i_x
      end # loop
   end # if
   return ar_out
end # kibuvits_krl171_ar_i_dearmour_t1

#--------------------------------------------------------------------------

# Reads in any file, byte-by-byte, converts
# the bytes to Unicode characters and returns the
# series of characters as a single string.
def kibuvits_krl171_file2str_by_armour_t1(s_file_path)
   s_out=$kibuvits_krl171_lc_emptystring
   if KIBUVITS_krl171_RUBY_LIBRARY_IS_AVAILABLE
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path
      end # if
   end # if
   ar_i=kibuvits_krl171_file_2_ar_i_t1(s_file_path)
   s_out=kibuvits_krl171_s_armour_t1(ar_i)
   return s_out
end # kibuvits_krl171_file2str_by_armour_t1

# The string must conform to the format
# of the kibuvits_krl171_s_armour_t1(...)
def kibuvits_krl171_str2file_by_dearmour_t1(s_armoured,s_file_path)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      kibuvits_krl171_typecheck bn, String, s_armoured
      kibuvits_krl171_typecheck bn, String, s_file_path
   end # if
   ar_i=kibuvits_krl171_ar_i_dearmour_t1(s_armoured)
   kibuvits_krl171_ar_i_2_file_t1(ar_i,s_file_path)
end # kibuvits_krl171_str2file_by_dearmour_t1

#--------------------------------------------------------------------------

# The main purpose of this method is to encapsulate the console
# reading code, because there's just too many unanswered questions about
# the console reading.
def read_a_line_from_console
   s_out=nil
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      # The IO.gets() treats console arguments as if they would have
      # been  as user input for a query. For some weird reason,
      # the current solution works.
      s_out=""+$stdin.gets
   end # synchronize
   return s_out
end # read_a_line_from_console

def write_2_console a_string
   $kibuvits_krl171_lc_mx_streamaccess.synchronize do
      # The "" is just for reducing the probability of
      # mysterious memory sharing related quirk-effects.
      $stdout.write ""+a_string.to_s
   end # synchronize
end # write_2_console

def writeln_2_console a_string,
   i_number_of_prefixing_linebreaks=0,
   i_number_of_suffixing_linebreaks=1
   s=("\n"*i_number_of_prefixing_linebreaks)+a_string.to_s+
   ("\n"*i_number_of_suffixing_linebreaks)
   write_2_console s
end # write_2_console

class Kibuvits_krl171_io
   @@cache=Hash.new
   def initialize
   end #initialize

   #-----------------------------------------------------------------------

   def create_empty_ht_stdstreams
      ht_stdstreams=Hash.new
      ht_stdstreams[$kibuvits_krl171_lc_s_stdout]=$kibuvits_krl171_lc_emptystring
      ht_stdstreams[$kibuvits_krl171_lc_s_stderr]=$kibuvits_krl171_lc_emptystring
      return ht_stdstreams
   end # create_empty_ht_stdstreams

   def Kibuvits_krl171_io.create_empty_ht_stdstreams
      ht_stdstreams=Kibuvits_krl171_io.instance.create_empty_ht_stdstreams
      return ht_stdstreams
   end # Kibuvits_krl171_io.create_empty_ht_stdstreams

   #-----------------------------------------------------------------------

   # A computer might have multiple network
   # cards, like WiFi card, mobile internet USB-stick, etc.
   #
   # If only loop-back interfaces are found, a random
   # "localhost" loop-back IP-addrss is returned.
   #
   # Action priorities:
   #
   #     highest_priority) Return a non-loop-back IPv4 address
   #       lower_priority) Return a non-loop-back IPv6 address
   #       lower_priority) Return a loop-back IPv4 address
   #       lower_priority) Return a loop-back IPv6 address
   #      lowest_priority) Throw an exception
   #
   # The reason, why IPv4 is preferred to IPv6 is
   # that IPv6 addresses are assigned to interfaces
   # on LAN even, when the actual internet connection
   # is available only through an IPv4 address.
   #
   # On the other hand, just like NAT almost solved the
   # IPv4 address space problem by mapping
   # LANipAddress:whateverport1_to_WANipAddress:someport2
   # it is possible to increase the number of end-point
   # addresses even further by adding a software layer, like
   # ApplicationName_LANipAddress:whateverport1, where the
   # ApplicationName might depict a multiplexer/demultiplexer.
   # That is to say, the IPv4 addresses are likely
   # to go a pretty long way.
   def s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      if !defined? $kibuvits_krl171_inclusionconstannt_kibuvits_krl171_io_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
         # The interpreter is sometimes picky, if real
         # Ruby constants are  in a function.
         require "socket"
         $kibuvits_krl171_inclusionconstannt_kibuvits_krl171_io_s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected=true
      end # if
      ar_doable=Array.new(5,false) # actions by priority
      #ar_doable[4]=true # throw, if all else fails, outcommented due to a hack
      ar_data=Array.new(5,nil)
      # Credits go to to:
      # http://stackoverflow.com/questions/5029427/ruby-get-local-ip-nix
      ar_addrinfo=Socket.ip_address_list
      ar_addrinfo.each do |ob_addrinfo|
         if ob_addrinfo.ipv6?
            next if ob_addrinfo.ipv6_multicast?
            if ob_addrinfo.ipv6_loopback?
               ar_doable[3]=true
               ar_data[3]=ob_addrinfo.ip_address
               next
            end # if
            next if ar_doable[1]
            ar_doable[1]=true
            ar_data[1]=ob_addrinfo.ip_address
         else
            if ob_addrinfo.ipv4?
               next if ob_addrinfo.ipv4_multicast?
               if ob_addrinfo.ipv4_loopback?
                  ar_doable[2]=true
                  ar_data[2]=ob_addrinfo.ip_address
                  next
               end # if
               next if ar_doable[0]
               ar_doable[0]=true
               ar_data[0]=ob_addrinfo.ip_address
            else
               kibuvits_krl171_throw("ob_addrinfo.to_s=="+ob_addrinfo.to_s+
               "\n GUID='f1d350e9-3bef-4077-a199-c2c2f051a4e7'\n\n")
            end # if
         end # if
      end # loop
      i_n=ar_doable.size-1 # The last option is throwing.
      i_n.times do |i_ix|
         if ar_doable[i_ix]
            s_out=ar_data[i_ix]
            return s_out
         end # if
      end # loop
      kibuvits_krl171_throw("ar_addrinfo.to_s=="+ar_addrinfo.to_s+
      "\n GUID='d870bd20-d5f7-483a-9169-c2c2f051a4e7'\n\n")
   end # s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected

   def Kibuvits_krl171_io.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      s_out=Kibuvits_krl171_io.instance.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
      return s_out
   end # Kibuvits_krl171_io.s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected


   # Returns "127.0.0.1" or "::1", depending on the
   # value of the s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected()
   def s_localhost_IP_address
      if !defined? @s_localhost_IP_address_cache
         s_ip_address=s_one_of_the_public_IP_addresses_or_a_loopback_if_unconnected
         s_0=nil
         if (s_ip_address.gsub(/[\d]/,$kibuvits_krl171_lc_emptystring)).length==3
            s_0="127.0.0.1"
         else
            if s_ip_address==$kibuvits_krl171_lc_s_localhost
               kibuvits_krl171_throw("s_ip_addresss == \"localhost\", \n"+
               "but it should be an IP-address.\n"+
               "GUID='18cd44bd-7159-4e4c-a239-c2c2f051a4e7'\n\n")
            end # if
            s_0="::1" # IPv6 version of the loop-back interface
         end # if
         @s_localhost_IP_address_cache=s_0.freeze
      end # if
      s_out=@s_localhost_IP_address_cache
      return s_out
   end # s_localhost_IP_address

   def Kibuvits_krl171_io.s_localhost_IP_address
      s_out=Kibuvits_krl171_io.instance.s_localhost_IP_address
      return s_out
   end # Kibuvits_krl171_io.s_localhost_IP_address

   #-----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_krl171_io
#=====================kibuvits_krl171_io_rb_end===================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_io_rb_start".
#==========================================================================

#=====================kibuvits_krl171_os_codelets_rb_start========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_os_codelets_rb_end".
#==========================================================================
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
if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_io.rb"

#==========================================================================

# It's just a namespace for various operating system specific,
# relatively small, subroutines.
class Kibuvits_krl171_os_codelets
   @@cache=Hash.new
   attr_accessor :s_xx

   def initialize
      #@mx=Mutex.new
   end # initialize

   #-----------------------------------------------------------------------
   def get_os_type
      s_key='os_type'
      if @@cache.has_key? s_key
         s_out=""+@@cache[s_key]
         return s_out
      end # if
      s=RUBY_PLATFORM
      s_out='not_determined'
      if 	s.include? 'linux'
         s_out=$kibuvits_krl171_lc_kibuvits_krl171_ostype_unixlike
      elsif 	s.include? 'bsd' # on DesktopBSD it's "i386-freebsd7"
         s_out=$kibuvits_krl171_lc_kibuvits_krl171_ostype_unixlike
      elsif (s.include? 'win')||(s.include? 'mingw')
         s_out=$kibuvits_krl171_lc_kibuvits_krl171_ostype_windows
      elsif 	s.include? 'java' # JRuby
         s_out=$kibuvits_krl171_lc_kibuvits_krl171_ostype_java
         if system("ver")
            s_out=$kibuvits_krl171_lc_kibuvits_krl171_ostype_windows
         else
            s_fp="/tmp/"+generate_tmp_file_name()
            if system("uname")
               if system("uname > s_fp")
                  if File.exists? s_fp
                     s=file2str(s_fp)
                     File.delete s_fp
                     if s.include? "CYGWIN"
                        s_out=$kibuvits_krl171_lc_kibuvits_krl171_ostype_windows
                     end # if
                  end # if
               end # if
               File.delete s_fp if File.exists? s_fp
            end # if
         end # if
      else
         kibuvits_krl171_throw 'RUBY_PLATFORM=='+RUBY_PLATFORM+
         ' is not supported by this library.'
      end # elsif
      # There's no point of synchronizing it, because all
      # threads will insert a same result.

      @@cache[s_key]=$kibuvits_krl171_lc_emptystring+s_out
      return s_out
   end # get_os_type

   def Kibuvits_krl171_os_codelets.get_os_type
      s_out=Kibuvits_krl171_os_codelets.instance.get_os_type
      return s_out
   end # Kibuvits_krl171_os_codelets.get_os_type

   def Kibuvits_krl171_os_codelets.test_get_os_type
      Kibuvits_krl171_os_codelets.get_os_type
   end # Kibuvits_krl171_os_codelets.test_get_os_type

   #-----------------------------------------------------------------------
   def ht_path_2_os_type_check_for_Windows_compatibility(ht_out,s_in,
      rgx_common1,msgcs)
      if /[\/]/.match(s_in,0)!=nil
         # some invalid paths:
         # "abcd/hi.exe" a Linux path style
         return
      end # if
      s_lc_ostype="kibuvits_krl171_ostype_windows"
      if /^[\w][\w\d_]*:/.match(s_in)!=nil
         # "X:"
         # "C:\\xx\\yy"
         # "ScoobyDoo:\\xx\\yy"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if /[\\]/.match(s_in)!=nil
         # ".\\"
         # ".\\xx\\yy"
         # ".\\..\\"
         # ".\\..\\zz\\gg.txt"
         # ".\\..\\zz\\..\\ff\\ll.txt"
         # "..\\..\\"
         # "..\\..\\zz"
         # "xx\\"
         # "xx\\yy"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if /^[%][\w][\w\d_]*[%]/.match(s_in)!=nil
         # "%windir%\\yy"
         # "%windir%\\..\\"
         # "%windir%"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if rgx_common1.match(s_in)!=nil  # rgx_common1==/^[\w][\w\d _.]*$/
         # "hallo"
         # "hallo.txt"
         # "awesome.tar.gz"
         # "awesome......."
         # "awesome... .. .."
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
   end #  ht_path_2_os_type_check_for_Windows_compatibility

   def ht_path_2_os_type_check_for_Linux_compatibility(ht_out,s_in,
      rgx_common1,msgcs)

      if /[\\]/.match(s_in,0)!=nil
         # some invalid paths:
         # "abcd\\hi.exe" a Windows path style
         return
      end # if
      s_lc_ostype="kibuvits_krl171_ostype_unixlike"
      if /[\/]/.match(s_in,0)!=nil
         # "/"
         # "/hi.txt"
         # "/abcd"
         # "/abcd/"
         # "/abcd/hi.exe"
         # "/abcd/../hi.exe"
         # "/abcd/../tmp/"
         # "/abcd/../tmp/hi.exe"

         # "./xxx"
         # "./gg.txt"
         # "./x/"
         # "./../../../nice.txt"
         # "./../abc/../nice.txt"

         # "../"
         # "../../../"
         # "../x/"

         # "abcd/hi.exe"
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if
      if rgx_common1.match(s_in,0)!=nil  # rgx_common1==/^[\w][\w\d _.]*$/
         # "hallo"
         # "hallo.txt"
         # "awesome.tar.gz"
         # "awesome......."
         # "awesome... .. .."
         ht_out[s_lc_ostype]=s_lc_ostype
         return
      end # if

   end #  ht_path_2_os_type_check_for_Linux_compatibility

   def s_normalize_Linux_path(s_path_in,msgcs)
      #msgcs=Kibuvits_krl171_msgc_stack.new)
      s_out=s_path_in
   end # s_normalize_Linux_path

   public
   # Returns a hashtable, where the keys match
   # with their corresponding values and the keys are the operating
   # system types that use the format of the s_file_path_subject_to_analyze
   #
   # Example of a file path that is accepted by unix-like
   # operating systems and the windows:
   # ----verbatim--start----
   #    nice_filename.txt
   # ----verbatim--end------
   # It does not throw on the s_file_path_subject_to_analyze verification
   # failures.
   def ht_path_2_os_type(s_file_path_subject_to_analyze, msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path_subject_to_analyze
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      s_in=s_file_path_subject_to_analyze
      if s_in.length==0
         s_default_msg="s_file_path_subject_to_analyze.length==0"
         i_message_code=1
         b_failure=true
         s_default_language=$kibuvits_krl171_lc_English
         msgc=Kibuvits_krl171_msgc.new(s_default_msg,i_message_code,b_failure,s_default_language)
         msgcs << msgc
         return
      end # if
      if (s_in.include? "/")&&(s_in.include? "\\")
         s_default_msg="The file/folder path contains both, "+
         "Windows and Unix path characters, i.e. "+
         "slashes and backslashes. s_file_path_subject_to_analyze=="+
         s_file_path_subject_to_analyze
         i_message_code=2
         b_failure=true
         s_default_language=$Ekibuvits_krl171_lc_English
         msgc=Kibuvits_krl171_msgc.new(s_default_msg,i_message_code,b_failure,s_default_language)
         msgc[$kibuvits_krl171_lc_Estonian]="Faili või kataloogi rada sisaldab nii Unix'i kui "+
         "Windowsi raja spetsiifilisi eraldusmärke."
         msgcs << msgc
         return
      end # if
      if /([.]{3})|([?])/.match(s_in,0)!=nil
         # some invalid paths:
         # "abcd/.../hi.exe"
         # "abcd/hi?.exe"
         s_default_msg="The file/folder path contained either 3 dots "+
         "or a question mark. The current specification of "+
         "this method considers that sort of paths to be invalid."
         s_file_path_subject_to_analyze
         i_message_code=3
         b_failure=true
         s_default_language=$kibuvits_krl171_lc_English
         msgc=Kibuvits_krl171_msgc.new(s_default_msg,i_message_code,b_failure,s_default_language)
         msgc[$kibuvits_krl171_lc_Estonian]="Faili või kataloogi rada sisaldab kas "+
         "kolme järjestikust punkti või küsimärki. Selle meetodi praeguse "+
         "spetsifikatsiooni järgi loetakse seda sorti faili/kataloogi rajad vigaseks."
         msgcs << msgc
         return
      end # if
      ht_out=Hash.new
      rgx_common1=/^[\w][\w\d _.]*$/
      ht_path_2_os_type_check_for_Windows_compatibility(ht_out,s_in,
      rgx_common1,msgcs)
      return if msgcs.b_failure
      ht_path_2_os_type_check_for_Linux_compatibility(ht_out,s_in,
      rgx_common1,msgcs)
      return ht_out
   end # ht_path_2_os_type

   def Kibuvits_krl171_os_codelets.ht_path_2_os_type(s_file_path_subject_to_analyze,msgcs)
      ht_out=Kibuvits_krl171_os_codelets.instance.ht_path_2_os_type(s_file_path_subject_to_analyze,msgcs)
      return ht_out
   end # Kibuvits_krl171_os_codelets.ht_path_2_os_type

   #-----------------------------------------------------------------------
   def get_tmp_folder_path
      s_system_name=self.get_os_type()
      s_out=''
      if defined? KIBUVITS_krl171_TMP_FOLDER_PATH
         s_out=KIBUVITS_krl171_TMP_FOLDER_PATH
      elsif s_system_name=='kibuvits_krl171_ostype_unixlike'
         s_out='/tmp'
      elsif s_system_name=='kibuvits_krl171_ostype_windows'
         #s_out=ENV['TEMP']
         #kibuvits_krl171_throw "ENV['TEMP']==nil" if s_out==nil
         # If cygwin or something alike is used, then the
         # cygwin uses the Linux file paths, i.e. /c/blabla, but
         # the ENV['TEMP'] gives c:/blablabla  and that breaks things.
         # the solution:
         s_out=KIBUVITS_krl171_HOME+"/src/include/bonnet/tmp"
         # There's nothing lost with that, because KRL relies on
         # unix tools anyway, which means that on Windows the KRL runs
         # on cygwin or something similar.
      elsif s_system_name=="kibuvits_krl171_ostype_java"
         s_out=KIBUVITS_krl171_HOME+"/src/include/bonnet/tmp"
      else
         kibuvits_krl171_throw 'System "'+s_system_name+'" is not supported.'
      end # elsif
      return s_out
   end # get_tmp_folder_path

   def Kibuvits_krl171_os_codelets.get_tmp_folder_path
      s_out=Kibuvits_krl171_os_codelets.instance.get_tmp_folder_path
      return s_out
   end # Kibuvits_krl171_os_codelets.get_tmp_folder_path

   #-----------------------------------------------------------------------
   def convert_file_path_2_unix_format(s_file_path, msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ht_ostypes=self.ht_path_2_os_type(s_file_path,msgcs)
      return "" if msgcs.b_failure
      return ""+s_file_path if ht_ostypes.has_key? "kibuvits_krl171_ostype_unixlike"
      # TODO: add various tests that analyze the path,i.e.
      # forbidden characters, whether the path goes higher than
      # the root, etc.
      s_pt=s_file_path.sub(":\\","/")
      i_len_diff=(s_file_path.length-s_pt.length)
      if 1<i_len_diff
         # There can be at most one ":\" in the path, like
         # C:\plapla
         kibuvits_krl171_throw "\""+s_file_path+"\" is not a file path."
         # TODO: add checks
      end # if
      s_pt=s_pt.gsub("\\","/")
      s_pt="/"+s_pt if i_len_diff==1
      s_pt=s_pt.gsub(/[\/]+/,"/")
      return s_pt
   end #convert_file_path_2_unix_format

   def Kibuvits_krl171_os_codelets.convert_file_path_2_unix_format(s_file_path,msgcs)
      s_p=Kibuvits_krl171_os_codelets.instance.convert_file_path_2_unix_format(
      s_file_path,msgcs)
      return s_p
   end # Kibuvits_krl171_os_codelets.convert_file_path_2_unix_format

   #-----------------------------------------------------------------------
   public

   # "/C/Program\ Files" -> "C:\\Program\ Files"
   def convert_file_path_2_windows_format(s_file_path,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ht_ostypes=self.ht_path_2_os_type(s_file_path,msgcs)
      return "" if msgcs.b_failure
      return ""+s_file_path if ht_ostypes.has_key? "kibuvits_krl171_ostype_windows"
      # TODO: add various tests that analyze the path,i.e.
      # forbidden characters, whether the path goes higher than
      # the root, etc.
      return s_file_path if s_file_path.length==0
      s_backslash="\\"
      s_p=s_file_path.gsub("/",s_backslash)
      s_p=s_p.gsub(/[\\]+/,s_backslash)
      s_char0=s_p[0..0]
      if (s_char0!=s_backslash)&&(s_char0!=".")
         s_p=s_backslash+s_p
      end # if
      return "" if s_p.length==1
      return s_p if s_p[0..0]=="."
      s_p=s_p[1..(-1)]
      s_clbsl=":\\"
      return s_p if s_p.include? s_clbsl
      ar=Kibuvits_krl171_str.ar_bisect(s_p, s_backslash)
      s_p=ar[0]+s_clbsl+ar[1]
      return s_p
   end #convert_file_path_2_windows_format

   def Kibuvits_krl171_os_codelets.convert_file_path_2_windows_format(s_file_path,msgcs)
      s_p=Kibuvits_krl171_os_codelets.instance.convert_file_path_2_windows_format(
      s_file_path,msgcs)
      return s_p
   end # Kibuvits_krl171_os_codelets.convert_file_path_2_windows_format

   #-----------------------------------------------------------------------
   public

   # This method is DEPRECATED. One should always use UNIX paths.
   # It will be deleted after it has been refactored out from
   # the rest of the library.
   def convert_file_path_2_os_specific_format(s_file_path,msgcs)
      # TODO: throw it out after the resto of the library has been refactored.
      s_out=""+s_file_path
      return s_out
   end # convert_file_path_2_os_specific_format

   # This method is DEPRECATED. One should always use UNIX paths.
   # It will be deleted after it has been refactored out from
   # the rest of the library.
   def Kibuvits_krl171_os_codelets.convert_file_path_2_os_specific_format(s_file_path,msgcs)
      s_out=Kibuvits_krl171_os_codelets.instance.convert_file_path_2_os_specific_format(
      s_file_path,msgcs)
      return s_out
   end # Kibuvits_krl171_os_codelets.convert_file_path_2_os_specific_format

   #-----------------------------------------------------------------------
   public

   def generate_tmp_file_name(s_file_name_prefix="tmp_file_",
      s_file_name_suffix="e.txt") # 'e' is a [^\d]
      s=s_file_name_prefix+(Time.new.to_s).gsub!(/[\s;.\\\/:+]/,"_")
      # 2147483647==2^(32-1)-1, i.e. 0 included
      s=s+'r'+Kernel.rand(2147483647).to_s
      s=s+'r'+Kernel.rand(2147483647).to_s
      s=s+'r'+Kernel.rand(2147483647).to_s+s_file_name_suffix
      return s
   end # generate_tmp_file_name

   def Kibuvits_krl171_os_codelets.generate_tmp_file_name(
      s_file_name_prefix="tmp_file_",
      s_file_name_suffix="e.txt") # 'e' is a [^\d]
      s_out=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_name(
      s_file_name_prefix,s_file_name_suffix)
      return s_out
   end # Kibuvits_krl171_os_codelets.generate_tmp_file_name

   #-----------------------------------------------------------------------
   def generate_tmp_file_absolute_path(s_file_name_prefix="tmp_file_",
      msgcs=nil, s_file_name_suffix="e.txt") # 'e' is a [^\d]
      # TODO: refactor the msgcs part here
      #interpret_msgcs_var(msgcs,b_msgcs_received)
      s_fp0=get_tmp_folder_path+"/"+generate_tmp_file_name(
      s_file_name_prefix,s_file_name_suffix)
      #interpret_msgcs_var(msgcs,b_msgcs_received)
      return s_fp0
   end # generate_tmp_file_absolute_path

   def Kibuvits_krl171_os_codelets.generate_tmp_file_absolute_path(
      s_file_name_prefix="tmp_file_",
      s_file_name_suffix="e.txt") # 'e' is a [^\d]
      s_out=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path(
      s_file_name_prefix,nil,s_file_name_suffix)
      return s_out
   end # Kibuvits_krl171_os_codelets.generate_tmp_file_absolute_path

   #-----------------------------------------------------------------------
   include Singleton
   def Kibuvits_krl171_os_codelets.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_krl171_testeval bn, "Kibuvits_krl171_os_codelets.test_get_os_type"
      return ar_msgs
   end # Kibuvits_krl171_os_codelets.selftest

end # class Kibuvits_krl171_os_codelets
#==========================================================================
# Sample code:
#kibuvits_krl171_writeln Kibuvits_krl171_os_codelets.instance.generate_tmp_file_name()
#kibuvits_krl171_writeln Kibuvits_krl171_os_codelets.instance.get_os_type
#kibuvits_krl171_writeln Kibuvits_krl171_os_codelets.instance.get_tmp_folder_path
#=====================kibuvits_krl171_os_codelets_rb_end==========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_os_codelets_rb_start".
#==========================================================================

#=====================kibuvits_krl171_shell_rb_start==============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_shell_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2009, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_SHELL_RB_INCLUDED
   KIBUVITS_krl171_SHELL_RB_INCLUDED=true

   if !defined? KIBUVITS_krl171_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
      #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
   end # if

   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_io.rb"
   #require  KIBUVITS_krl171_HOME+"/src/include/bonnet/kibuvits_krl171_os_codelets.rb"
   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
end # if

#==========================================================================

# It's a sub-function of the function sh
def kibuvits_krl171_sh_unix(s_shell_script)
   if KIBUVITS_krl171_b_DEBUG
      kibuvits_krl171_typecheck binding(), String, s_shell_script
   end # if
   s_fp_script_0=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stdout=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path
   s_fp_stderr=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path
   #------------
   b_throw_if_not_found=true
   s_fp_bash=Kibuvits_krl171_shell.s_exc_system_specific_path_by_caching_t1(
   "bash", b_throw_if_not_found)
   #------------
   str2file(s_shell_script,s_fp_script_0)
   str2file($kibuvits_krl171_lc_emptystring,s_fp_stdout)
   str2file($kibuvits_krl171_lc_emptystring,s_fp_stderr)
   cmd=s_fp_bash+$kibuvits_krl171_lc_space+s_fp_script_0+" 1>"+s_fp_stdout+" 2>"+s_fp_stderr+" ;"
   ht_stdstreams=Kibuvits_krl171_io.create_empty_ht_stdstreams
   begin
      # Kernel.system return values:
      #     true  on success, e.g. program returns 0 as execution status
      #     false on successfully started program that
      #              returns nonzero execution status
      #     nil   on command that could not be executed
      x_success=system(cmd)

      # An alternative version that needs improvement:
      #
      #     x_success=nil
      #     IO.popen(cmd) {x_success=true }
      #
   rescue Exception=>e
      File.delete(s_fp_script_0)
      File.delete(s_fp_stdout)
      File.delete(s_fp_stderr)
      kibuvits_krl171_throw e.message.to_s
   end # try-catch
   s_stdout=Kibuvits_krl171_str.normalise_linebreaks(
   file2str(s_fp_stdout),$kibuvits_krl171_lc_linebreak)
   s_stderr=Kibuvits_krl171_str.normalise_linebreaks(
   file2str(s_fp_stderr),$kibuvits_krl171_lc_linebreak)
   File.delete(s_fp_script_0) if File.exists? s_fp_script_0
   File.delete(s_fp_stdout) if File.exists? s_fp_stdout
   File.delete(s_fp_stderr) if File.exists? s_fp_stderr
   ht_stdstreams[$kibuvits_krl171_lc_s_stdout]=s_stdout
   ht_stdstreams[$kibuvits_krl171_lc_s_stderr]=s_stderr
   return ht_stdstreams
end # kibuvits_krl171_sh_unix


$kibuvits_krl171_lc_mx_sh=Mutex.new


# Writes a script to a file and executes it in Bash. Returns a hashtable with
# keys "s_stdout" and "s_stderr". The values that are pointed by the keys
# are always strings.
#
# The line breaks within the s_stdout, s_stderr have been normalized
# to the "\n". In case of Windows the 2 header lines and the footer line
# have been removed from the s_stdout.
def kibuvits_krl171_sh(s_shell_script)
   if KIBUVITS_krl171_b_DEBUG
      kibuvits_krl171_typecheck binding(), String, s_shell_script
   end # if
   s_ostype=Kibuvits_krl171_os_codelets.instance.get_os_type
   ht_stdstreams=nil
   $kibuvits_krl171_lc_mx_sh.synchronize do
      case s_ostype
      when "kibuvits_krl171_ostype_unixlike"
         ht_stdstreams=kibuvits_krl171_sh_unix(s_shell_script)
      else
         # Some of the cases, where it happens:
         # "kibuvits_krl171_ostype_java", "kibuvits_krl171_ostype_windows"
         kibuvits_krl171_throw("Operating system with the "+
         "Kibuvits Ruby Library operating system type \""+
         s_ostype+"\" is not supported by this function.")
      end # case
   end # synchronize
   return ht_stdstreams
end # kibuvits_krl171_sh

#--------------------------------------------------------------------------

# The same as the kibuvits_krl171_sh(...), except that it
# prints the output streams, if there's any output.
def kibuvits_krl171_sh_writeln2console_t1(s_shell_script)
   ht_stdstreams=sh(s_shell_script)
   s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
   s_stderr=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]
   kibuvits_krl171_writeln s_stdout if 0<s_stdout.length
   if 0<s_stderr.length
      kibuvits_krl171_writeln $kibuvits_krl171_lc_linebreak+s_stderr+$kibuvits_krl171_lc_linebreak
   end # if
   return ht_stdstreams
end # kibuvits_krl171_sh_writeln2console_t1

#--------------------------------------------------------------------------

class Kibuvits_krl171_shell

   def initialize
      @s_lc_which="which ".freeze
      @s_lc_1="[/]".freeze
   end # initialize

   #-----------------------------------------------------------------------

   private

   # Returns an empty string, if not found.
   # It's also used in
   #
   #     b_available_on_path(...)
   #
   def s_exc_system_specific_path_by_caching_t1_look_from_system(s_program_name)
      s_fp="/usr/bin/env"
      if !File.exist? s_fp
         kibuvits_krl171_throw("The file "+ s_fp+" does not exist."+
         "\nGUID='487a7730-b125-481d-8409-c2c2f051a4e7'")
      end # if
      s_fp_stdout=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path
      s_fp_stderr=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path
      cmd="which "+s_program_name+" 1>"+s_fp_stdout+" 2>"+s_fp_stderr+" ;"
      x_success=nil
      begin
         # Kernel.system(...) return values:
         #     true  on success, e.g. program returns 0 as execution status
         #     false on successfully started program that
         #              returns nonzero execution status
         #     nil   on command that could not be executed
         x_success=system(cmd)
      rescue Exception=>e
         File.delete(s_fp_stdout)
         File.delete(s_fp_stderr)
         kibuvits_krl171_throw e.message.to_s
      end # try-catch
      s_stdout=$kibuvits_krl171_lc_emptystring
      if x_success==true
         s_stdout=file2str(s_fp_stdout).gsub(/[\n\r]/,$kibuvits_krl171_lc_emptystring)
      end # if
      File.delete(s_fp_stdout) if File.exist? s_fp_stdout
      File.delete(s_fp_stderr) if File.exist? s_fp_stderr
      return s_stdout
   end # s_exc_system_specific_path_by_caching_t1_look_from_system

   public

   # A pooling wrapper to the /usr/bin/env
   #
   # If the s_program_name is found on PATH,
   # returns the full path of the s_program_name
   #
   # If the s_program_name is NOT found on PATH,
   # returns an empty string or throws an exception.
   def s_exc_system_specific_path_by_caching_t1(s_program_name,b_throw_if_not_found=true)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         i_min_length=2 # May be it should be 1?
         # The i_min_length can be changed to 1, after problems emerge.
         kibuvits_krl171_assert_string_min_length(bn,s_program_name,i_min_length,
         "GUID='b047a233-bf68-4c07-b2d8-c2c2f051a4e7'")
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_throw_if_not_found
      end # if
      if !defined? @ht_s_exc_system_specific_path_by_caching_t1_cache
         @ht_s_exc_system_specific_path_by_caching_t1_cache=Hash.new
      end # if
      #---------------
      # s_fp is a string in stead of nil to match the
      # s_exc_system_specific_path_by_caching_t1_look_from_system output format.
      s_fp=$kibuvits_krl171_lc_emptystring
      if @ht_s_exc_system_specific_path_by_caching_t1_cache.has_key? s_program_name
         s_fp=@ht_s_exc_system_specific_path_by_caching_t1_cache[s_program_name]
      else
         s_fp=s_exc_system_specific_path_by_caching_t1_look_from_system(s_program_name)
         if 0<s_fp.length
            @ht_s_exc_system_specific_path_by_caching_t1_cache[s_program_name]=s_fp.freeze
         end # if
      end # if
      #---------------
      if s_fp.length==0
         if b_throw_if_not_found
            kibuvits_krl171_throw("Program \""+ s_program_name+
            "\" could not be found on the PATH."+
            "\nGUID='1464f245-4a27-43f1-b798-c2c2f051a4e7'")
         end # if
      end # if
      return s_fp
   end # s_exc_system_specific_path_by_caching_t1


   def Kibuvits_krl171_shell.s_exc_system_specific_path_by_caching_t1(
      s_program_name,b_throw_if_not_found=true)
      s_out=Kibuvits_krl171_shell.instance.s_exc_system_specific_path_by_caching_t1(
      s_program_name,b_throw_if_not_found)
      return s_out
   end # Kibuvits_krl171_shell.s_exc_system_specific_path_by_caching_t1

   #-----------------------------------------------------------------------

   # Returns boolean true, if the script or binary named
   # valueof(s_executable_name) is available on the path.
   #
   # The semantics of it is that it always studies
   # the PATH and does not cache the results.
   def b_available_on_path(s_program_name) # like "which", "grep", "vim", etc.
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_program_name
      end # if
      b_out=false
      s_fp=s_exc_system_specific_path_by_caching_t1_look_from_system(s_program_name)
      b_out=true if 0<s_fp.length
      return b_out
   end # b_available_on_path

   def Kibuvits_krl171_shell.b_available_on_path(s_program_name)
      b_out=Kibuvits_krl171_shell.instance.b_available_on_path(s_program_name)
      return b_out
   end # Kibuvits_krl171_shell.b_available_on_path

   #-----------------------------------------------------------------------

   def b_stderr_has_content_t1(ht_stdstreams)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_stdstreams
         kibuvits_krl171_assert_ht_has_keys(bn,ht_stdstreams,
         [$kibuvits_krl171_lc_s_stderr,$kibuvits_krl171_lc_s_stdout],
         "\nGUID='0d1aee35-e725-472c-b368-c2c2f051a4e7'")
      end # if
      s_err=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]
      if s_err.class!=String
         # s_err==nil, if the key is missing from the hashtable and
         # there is a flaw somewhere, if s_err is a number or
         # some custom instance, etc.
         kibuvits_krl171_throw("The ht_stdstreams does not seem to have the "+
         "right content. \nGUID='56cfdb12-0edc-423a-9238-c2c2f051a4e7'")
      end # if
      return false if s_err.length==0
      return true
   end # b_stderr_has_content_t1

   def Kibuvits_krl171_shell.b_stderr_has_content_t1(ht_stdstreams)
      b_out=Kibuvits_krl171_shell.instance.b_stderr_has_content_t1(ht_stdstreams)
      return b_out
   end # Kibuvits_krl171_shell.b_stderr_has_content_t1


   def throw_if_stderr_has_content_t1(ht_stdstreams,
      s_optional_error_message_suffix=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_stdstreams
         kibuvits_krl171_typecheck bn, [NilClass,String], s_optional_error_message_suffix
         kibuvits_krl171_assert_ht_has_keys(bn,ht_stdstreams,
         [$kibuvits_krl171_lc_s_stderr,$kibuvits_krl171_lc_s_stdout],
         "\nGUID='04c1531b-498b-4486-8308-c2c2f051a4e7'")
      end # if
      return if !b_stderr_has_content_t1(ht_stdstreams)
      s_msg=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]+$kibuvits_krl171_lc_linebreak
      if s_optional_error_message_suffix!=nil
         s_msg=s_msg+s_optional_error_message_suffix+$kibuvits_krl171_lc_linebreak
      end # if
      kibuvits_krl171_throw(s_msg)
   end # throw_if_stderr_has_content_t1

   def Kibuvits_krl171_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
      s_optional_error_message_suffix=nil)
      Kibuvits_krl171_shell.instance.throw_if_stderr_has_content_t1(
      ht_stdstreams,s_optional_error_message_suffix)
   end # Kibuvits_krl171_shell.throw_if_stderr_has_content_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_shell

#==========================================================================
# puts kibuvits_krl171_sh("whoami")["s_stdout"]
#=====================kibuvits_krl171_shell_rb_end================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_shell_rb_start".
#==========================================================================

#=====================kibuvits_krl171_refl_rb_start===============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_refl_rb_end".
#==========================================================================
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
#=========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"

#==========================================================================

# The class Kibuvits_krl171_refl is a namespace for reflection related functions
class Kibuvits_krl171_refl
   @@lc_empty_array=[]
   @@lc_s_public="public"
   @@lc_s_any="any"
   @@lc_rbrace_linebreak=")\n"
   @@lc_rgx_spacetablinebreak=/[\s\t\n\r]/
   @@lc_mx_rgx_spacetablinebreak=Mutex.new
   @@lc_s_kibuvits_krl171_refl_cache_of_class="@@kibuvits_krl171_refl_cache_of_class"
   @@lc_s_b_public_static_methods_in_instance_metods_namespace="b_public_static_methods_in_instance_metods_namespace"
   @@lc_s_kibuvits_krl171_refl_get_eigenclass="kibuvits_krl171_refl_get_eigenclass"
   def initialize
      @b_YAML_lib_not_loaded=true
   end #initialize
   private
   def get_methods_by_name_get_ar_method_names ob,s_method_type, msgcs
      ar_method_names=Array.new
      case s_method_type
      when "private"
         ar_method_names=ob.private_methods
      when "singleton"
         ar_method_names=ob.singleton_methods
      when "public"
         ar_method_names=ob.public_methods
      when "protected"
         ar_method_names=ob.protected_methods
      when "any"
         ar_method_names=ar_method_names+ob.private_methods
         ar_method_names=ar_method_names+ob.singleton_methods
         ar_method_names=ar_method_names+ob.public_methods
         ar_method_names=ar_method_names+ob.protected_methods
      else
         ar=["any","private","protected","public","singleton"]
         s_list_of_valid_values=Kibuvits_krl171_str.array2xseparated_list(ar)
         msgcs.cre "Method type \""+s_method_type+"\" is not supported. "+
         "Supported values are: "+s_list_of_valid_values+".",1.to_s
         msgcs.last[$kibuvits_krl171_lc_Estonian]="Meetodi tüüp \""+s_method_type+
         "\" ei ole toetatud. Toetatud väätused on: "+
         s_list_of_valid_values+"."
      end # case
      return ar_method_names
   end # get_methods_by_name_get_ar_method_names

   public

   # Returns a hash table, where the method names are keys.
   # The values are set to 42.
   # The domain of the s_method_type is:
   # {"any","public","protected","private","singleton"}
   #
   # In order to get class methods, one should just feed the
   # class in as the ob. For example, if one wants to get
   # a list of all static public methods of class String, one should
   # call: get_methods_by_name(/.+/, String, "public", msgcs)
   def get_methods_by_name(rgx_or_s, ob, s_method_type, msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Regexp], rgx_or_s
         kibuvits_krl171_typecheck bn, String, s_method_type
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ht_out=Hash.new
      ar_method_names=get_methods_by_name_get_ar_method_names(ob,s_method_type,msgcs)
      return ht_out if msgcs.b_failure
      rgx=rgx_or_s
      rgx=Regexp.compile(rgx_or_s) if rgx_or_s.class==String
      i_42=42
      md=nil
      ar_method_names.each do |s_method_name|
         md=rgx.match(s_method_name)
         ht_out[s_method_name]=i_42 if md!=nil
      end # loop
      return ht_out
   end # Kibuvits_krl171_refl.get_methods_by_name

   def Kibuvits_krl171_refl.get_methods_by_name(rgx_or_s, ob, s_method_type, msgcs)
      x=Kibuvits_krl171_refl.instance.get_methods_by_name(
      rgx_or_s, ob, s_method_type, msgcs)
      return x
   end # Kibuvits_krl171_refl.get_methods_by_name


   public

   # The idea is that one does not want to pollute the binding
   # that is being studied. So, in stead of creating a new, temporary,
   # variable, one sends the acquired values away by using a function,
   # which uses a new, temporary, binding, for the temporary stuff.
   def get_local_variables_from_binding_helper_func1(
      ar_variable_names, i_array_instance_object_id)
      ar=ObjectSpace._id2ref(i_array_instance_object_id)
      ar.concat(ar_variable_names)
   end # get_local_variables_from_binding_helper_func1

   def Kibuvits_krl171_refl.get_local_variables_from_binding_helper_func1(
      ar_variable_names, i_array_instance_object_id)
      Kibuvits_krl171_refl.instance.get_local_variables_from_binding_helper_func1(
      ar_variable_names, i_array_instance_object_id)
   end # Kibuvits_krl171_refl.get_local_variables_from_binding_helper_func1

   def get_local_variables_from_binding_helper_func2(
      i_ht_instance_id, i_key_string_instance_id, ob)
      ht=ObjectSpace._id2ref(i_ht_instance_id)
      ht[ObjectSpace._id2ref(i_key_string_instance_id)]=ob
   end # get_local_variables_from_binding_helper_func2

   def Kibuvits_krl171_refl.get_local_variables_from_binding_helper_func2(
      i_ht_instance_id, i_key_string_instance_id, ob)
      Kibuvits_krl171_refl.instance.get_local_variables_from_binding_helper_func2(
      i_ht_instance_id, i_key_string_instance_id, ob)
   end # Kibuvits_krl171_refl.get_local_variables_from_binding_helper_func2

   # Returns a hashtable, where the keys are variable names and values
   # are references to the instances. If b_return_only_variable_names==true,
   # only the hashtable keys will depict the variables and the values of the
   # hashtable are set to some nonsense.
   def get_local_variables_from_binding(bn_in, b_return_only_variable_names=false)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Binding], bn_in
      end # if
      # The mehtod local_variables() returns variable
      # names in the case of the Ruby 1.8 and Symbol
      # instances in the case of the Ruby 1.9
      ar_varnames_or_symbol=Array.new
      s_script="Kibuvits_krl171_refl."+
      "get_local_variables_from_binding_helper_func1(local_variables(),"+
      ar_varnames_or_symbol.object_id.to_s+@@lc_rbrace_linebreak
      eval(s_script,bn_in)
      ar_varnames=Array.new
      ar_varnames_or_symbol.each do |s_or_sym|
         ar_varnames<<s_or_sym.to_s
      end # loop
      ht_out=Hash.new
      if b_return_only_variable_names
         i=42
         ar_varnames.each{|s_varname| ht_out[s_varname]=i}
         return ht_out
      end # if
      s_script_prefix="Kibuvits_krl171_refl.get_local_variables_from_binding_helper_func2("+
      ht_out.object_id.to_s+$kibuvits_krl171_lc_comma
      ar_varnames.each do |s_varname|
         s_script=s_script_prefix+s_varname.object_id.to_s+
         $kibuvits_krl171_lc_comma+s_varname+@@lc_rbrace_linebreak
         eval(s_script,bn_in)
      end # loop
      return ht_out
   end # get_local_variables_from_binding

   def Kibuvits_krl171_refl.get_local_variables_from_binding(bn_in,
      b_return_only_variable_names=false)
      ht_out=Kibuvits_krl171_refl.instance.get_local_variables_from_binding(
      bn_in,b_return_only_variable_names)
      return ht_out
   end # Kibuvits_krl171_refl.get_local_variables_from_binding


   # Returns a hashtable. If the ar_classes_or_a_class is an
   # empty array, all of the local variables are collected.
   def get_instances_from_binding_by_class(bn_in,ar_classes_or_a_class=@@lc_empty_array)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Binding, bn_in
         kibuvits_krl171_typecheck bn, [Class,Array], ar_classes_or_a_class
      end # if
      ht_alllocal=get_local_variables_from_binding(bn_in)
      ar_classes=Kibuvits_krl171_ix.normalize2array(ar_classes_or_a_class)
      ht_classes=Hash.new
      ar_classes.each{|cl| ht_classes[cl.to_s]=cl}
      ht_out=Hash.new
      ht_alllocal.each_pair do |a_key,a_value|
         if ht_classes.has_key? a_value.class.to_s
            ht_out[a_key]=a_value
         end # if
      end # loop
      return ht_out
   end # get_instances_from_binding_by_class

   def Kibuvits_krl171_refl.get_instances_from_binding_by_class(bn_in,
      ar_classes_or_a_class=@@lc_empty_array)
      ht_out=Kibuvits_krl171_refl.instance.get_instances_from_binding_by_class(
      bn_in,ar_classes_or_a_class)
      return ht_out
   end # Kibuvits_krl171_refl.get_instances_from_binding_by_class(


   # Returns a Symbol instance
   def str2sym(s)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String],s
      end # if
      kibuvits_krl171_throw "s.length==0" if s.length==0
      s1=nil
      if @@lc_mx_rgx_spacetablinebreak.locked?
         rgx=/[\s\t\n\r]/
         s1=s.gsub(rgx,$kibuvits_krl171_lc_emptystring)
      else
         @@lc_mx_rgx_spacetablinebreak.synchronize{
            s1=s.gsub(@@lc_rgx_spacetablinebreak,$kibuvits_krl171_lc_emptystring)
         }
      end # if
      kibuvits_krl171_throw "'"+s+"' contains spaces or tabs or linebreaks."  if s.length!=s1.length
      sym_out=nil
      eval("sym_out=:"+s,binding())
      return sym_out
   end # str2sym

   def Kibuvits_krl171_refl.str2sym(s)
      sym_out=Kibuvits_krl171_refl.instance.str2sym(s)
      return sym_out
   end # Kibuvits_krl171_refl.str2sym(s)


   def get_kibuvits_krl171_refl_cache_from_class_of(ob)
      cl=ob.class
      kibuvits_krl171_throw "ob.class==Class" if cl==Class
      if cl.class_variable_defined? @@lc_s_kibuvits_krl171_refl_cache_of_class
         ht_out=cl.send(:class_variable_get,@@lc_s_kibuvits_krl171_refl_cache_of_class)
         return ht_out
      end # if
      ht_out=Hash.new
      cl.send(:class_variable_set,@@lc_s_kibuvits_krl171_refl_cache_of_class,ht_out)
      return ht_out
   end # get_kibuvits_krl171_refl_cache_from_class_of

   def Kibuvits_krl171_refl.get_kibuvits_krl171_refl_cache_from_class_of(ob)
      Kibuvits_krl171_refl.instance.get_kibuvits_krl171_refl_cache_from_class_of(ob)
   end # Kibuvits_krl171_refl.get_kibuvits_krl171_refl_cache_from_class_of(ob)


=begin
   public

   def get_eigenclass(ob)
      kibuvits_krl171_throw "This mehtod is untested and incomplete"
      b_getter_present=ob.send(:respond_to?,@@lc_s_kibuvits_krl171_refl_get_eigenclass)
      if !b_getter_present
         class << ob
            def kibuvits_krl171_refl_get_eigenclass
               return self
            end # kibuvits_krl171_refl_get_eigenclass
         end
      end # if
      cl=ob.send(:kibuvits_krl171_refl_get_eigenclass)
      return cl
   end # get_eigenclass

   def Kibuvits_krl171_refl.get_eigenclass(ob)
      cl=Kibuvits_krl171_refl.instance.get_eigenclass(ob)
      return cl
   end # Kibuvits_krl171_refl.get_eigenclass

=end
   public

   #
   # For some reason, probably garbage collection, the
   # set_vars_2_binding does not work.
   #
   #   def set_vars_2_binding(bn_in,ht_vars)
   # if KIBUVITS_krl171_b_DEBUG
   #      bn=binding()
   #      kibuvits_krl171_typecheck bn, Binding, bn_in
   #      kibuvits_krl171_typecheck bn, Hash, ht_vars
   # end # if
   #      s_script=""
   #      s_tmp1="=ObjectSpace._id2ref("
   #      ht_vars.each_pair do |s_varname,x_var|
   #         s_script=s_script+s_varname+s_tmp1+
   #         x_var.object_id.to_s+@@lc_rbrace_linebreak
   #      end # loop
   #      eval(s_script,bn_in)
   #   end # set_vars_2_binding
   #
   #   def Kibuvits_krl171_refl.set_vars_2_binding(bn_in,ht_vars)
   #      Kibuvits_krl171_refl.instance.set_vars_2_binding(bn_in,ht_vars)
   #   end # Kibuvits_krl171_refl.set_vars_2_binding
   #

   public

   # The case of the Ruby if there's a class method, then it is
   # not possible to access it through a syntax that looks as if it
   # were an instance method. For example, the following code will NOT
   # work:
   #----verbatim--start--
   #    class X
   #        def initialize
   #        end
   #        def X.hi
   #            kibuvits_krl171_writeln "Hi there!"
   #        end
   #    end # class X
   #    X.new.hi
   #----verbatim--end----
   #
   # But the following code does work:
   #
   #----verbatim--start--
   # ob=X.new
   # Kibuvits_krl171_refl.cp_all_public_static_methods_2_instance_methods_namespace(ob)
   # ob.hi
   #----verbatim--end----
   #
   # It does not override instance methods.
=begin
   def cp_all_public_static_methods_2_instance_methods_namespace(ob,msgcs)
      kibuvits_krl171_throw "This mehtod is untested and incomplete"
      if KIBUVITS_krl171_b_DEBUG
       bn=binding()
       kibuvits_krl171_typecheck bn, [Kibuvits_krl171_msgc_stack], msgcs
      end # if
      cl=ob.class
      kibuvits_krl171_throw "ob.class==Class" if cl==Class
      ht_cache_on_class=get_kibuvits_krl171_refl_cache_from_class_of(ob)
      b_copy=false
      if ht_cache_on_class.has_key? @@lc_s_b_public_static_methods_in_instance_metods_namespace
         b_copy=!ht_cache_on_class[@@lc_s_b_public_static_methods_in_instance_metods_namespace]
      end # if
      return if !b_copy
      rgx=/.+/
      ar_static_methods=get_methods_by_name(rgx,cl,@@lc_s_public,msgcs)
      ar_instance_methods=get_methods_by_name(rgx,cl,@@lc_s_any,msgcs)
      ht_instance_methods=Hash.new
      ar_instance_methods.each do |s_method_name|
         ht_instance_methods[s_method_name]=$kibuvits_krl171_lc_emptystring
      end # loop
      ht_static_metohds_2_copy=Hash.new
      ar_static_methods.each do |s_method_name|
         if !ht_instance_methods.has_key? s_method_name
            ht_static_metohds_2_copy[s_method_name]=$kibuvits_krl171_lc_emptystring
         end # if
      end # loop

      ht_static_metohds_2_copy.each_key do |s_method_name|
         sym=str2sym(s_method_name)
         cl.send(:define_method,sym){|ff| kibuvits_krl171_writeln ff.to_s}
      end # loop
      ht_cache_on_class[lc_s_b_public_static_methods_in_instance_metods_namespace]=true
   end # cp_all_public_static_methods_2_instance_methods_namespace
=end

   include Singleton

end # class Kibuvits_krl171_refl
#==========================================================================

#rgx=/clea./
#ob="This is a string object"
#s_method_type="public"
#msgcs=Kibuvits_krl171_msgc_stack.new
#ht=Kibuvits_krl171_refl.get_methods_by_name(rgx,ob,s_method_type,msgcs)
#=====================kibuvits_krl171_refl_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_refl_rb_start".
#==========================================================================

#=====================kibuvits_krl171_rake_rb_start===============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_rake_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"

#==========================================================================

# It's a namespace for Ruby Rake related code.
class Kibuvits_krl171_rake

   def initialize
   end #initialize

   def s_list_tasks(s_language=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [NilClass,String], s_language
      end # if
      ar_task_names=Array.new
      Rake.application.tasks.each {|x_task| ar_task_names<<x_task.to_s}
      ar_task_names.sort!
      s_lang=s_language
      if (s_language==nil)
         s_lang=$kibuvits_krl171_lc_English
      end # if
      s_1="xxxxxxxxxxxxxxxx".gsub!("x",$kibuvits_krl171_lc_space) # to make spaces visible
      s_out=""
      case s_lang
      when $kibuvits_krl171_lc_Estonian
         s_out="\n\nDeklareeritud Rake funktsioonid:\n\n"
      when $kibuvits_krl171_lc_English
         # OK, but exec in a separate block
      else
         if KIBUVITS_krl171_b_DEBUG
            kibuvits_krl171_throw("s_language=="+s_language+
            " not supported by this function."+
            "\nGUID='ef613019-efbe-4fee-92d7-c2c2f051a4e7'")
         else
            s_lang=$kibuvits_krl171_lc_English
         end # if
      end # case s_language
      if s_lang==$kibuvits_krl171_lc_English
         s_out="\n\nDeclared Rake functions:\n\n"
      end # if
      ar_task_names.each do |s_task_name|
         if s_task_name!=$kibuvits_krl171_lc_default
            s_out=s_out+s_1+(s_task_name.to_s+$kibuvits_krl171_lc_linebreak)
         end # if
      end # loop
      s_out=s_out+$kibuvits_krl171_lc_doublelinebreak
      return s_out
   end # s_list_tasks

   def Kibuvits_krl171_rake.s_list_tasks(s_language=nil)
      s_out=Kibuvits_krl171_rake.instance.s_list_tasks(s_language)
      return s_out
   end # Kibuvits_krl171_rake.s_list_tasks

   #-----------------------------------------------------------------------
   include Singleton
end # class Kibuvits_krl171_rake
#=====================kibuvits_krl171_rake_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_rake_rb_start".
#==========================================================================

#=====================kibuvits_krl171_keyboard_rb_start===========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_keyboard_rb_end".
#===========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2013, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HTOPER_RB_INCLUDED
   KIBUVITS_krl171_HTOPER_RB_INCLUDED=true

   if !defined? KIBUVITS_krl171_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
      #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
   end # if

   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
end # if

#--------------------------------------------------------------------------

# The Curses stdlib will mess things up to the point that
# You will curse in Your thoughts. That's why the
# require "courses" # must not be uncommented.
# For those, who still have a great temptation to use the
# Curses library, the following link migth be appealing:
# http://stackoverflow.com/questions/7297753/how-to-capture-a-key-press-in-ruby

#==========================================================================

class Kibuvits_krl171_keyboard

   def initialize
=begin
      raise(new.Exception("This class is totally flawed, becuase the "+
      "gets uses stdin, which is tied to the main thread and "+
      "as long as there's no way to get clean keyboard presses "+
      "without the whole stdin stuff (the stdin is global by nature, "+
      "with all the classicla glory of globals) then threads can not "+
      "capture keyboard events independent of eachother."+
      "\nGUID=='cbcfa65e-76cd-4432-92a7-c2c2f051a4e7')\n\n"))
=end
   end # initialize

   #--------------------------------------------------------------------------

   # ht_str2func keys are strings and values are Ruby lambda functions.
   #
   # Whenever a string that is a key of the ht_str2func is
   # entered during the running of the thread, the function that
   # is associated with the key, is run.
   #
   # Returns a dormant thred that can be started by using Thread.run
   #
   # WARNING: the current version blocks all file access and console feedback
   def ob_thread_gets_t1(ht_str2func)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_str2func
         ht_str2func.each_pair do |x_key,x_value|
            bn_1=binding()
            kibuvits_krl171_typecheck bn_1, String, x_key
            kibuvits_krl171_typecheck bn_1, Proc, x_value
         end # loop
      end # if
      ob_thread=Thread.new do
         s_cmd=nil
         ob_func=nil
         rgx_1=/[\n]/
         loop do
            $kibuvits_krl171_lc_mx_streamaccess.synchronize do
               s_cmd=STDIN.gets
            end # synchronize
            s_cmd.gsub!(rgx_1,$kibuvits_krl171_lc_emptystring)
            if ht_str2func.has_key? s_cmd
               ob_func=ht_str2func[s_cmd]
               ob_func.call
            end # if
         end # loop
      end # thread
      return ob_thread
   end # ob_thread_gets_t1

   def Kibuvits_krl171_keyboard.ob_thread_gets_t1(ht_str2func)
      ob_thread=Kibuvits_krl171_keyboard.instance.ob_thread_gets_t1(ht_str2func)
      return ob_thread
   end # Kibuvits_krl171_keyboard.ob_thread_gets_t1

   #------------------------------------------------------------------------
   public
   include Singleton
end # class Kibuvits_krl171_keyboard
#=====================kibuvits_krl171_keyboard_rb_end=============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_keyboard_rb_start".
#==========================================================================

#=====================kibuvits_krl171_IDstamp_registry_t1_rb_start================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_IDstamp_registry_t1_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_GUID_generator.rb"

#==========================================================================

# The idea is that there's a set of ID-name-ID-value pairs , i.e. a
# registry of ID-s, and one writes the ID-values out into the wild.
# The wilderness might be a set of documents, communication packets,
# communication sessions, etc.
#
# The question that the instances of the Kibuvits_krl171_IDstamp_registry_t1 help to answer is:
# Has an ID in the registry or in the wild chanted
# after the event, where the ID got copied from the registry to the wild?
#
# ID-s are usually assembled by concating Globally Unique Identifiers with
# some other strings and postprocessing the resultant string.
class Kibuvits_krl171_IDstamp_registry_t1

   attr_reader :s_default_ID_prefix

   #-----------------------------------------------------------------------

   # The s_default_ID_prefix must adhere to the rules of variable names.
   def initialize(s_default_ID_prefix="x",
      b_nil_from_wilderness_differs_from_registry_entries=false)
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_default_ID_prefix
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_nil_from_wilderness_differs_from_registry_entries
      end # if
      kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_default_ID_prefix)
      @s_default_ID_prefix=($kibuvits_krl171_lc_emptystring+s_default_ID_prefix).freeze
      @b_nil_from_wilderness_differs_from_registry_entries=b_nil_from_wilderness_differs_from_registry_entries
      @ht_registry=Hash.new
      @ht_prefixes=Hash.new
   end # initialize

   # ID-s can have heir private prefixes that override the default ID prefix.
   # ID-s, including their prefixes, must adhere to the rules of variable names.
   def set_ID_prefix(s_id_name,s_id_prefix)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_prefix)
      end # if
      @ht_prefixes[s_id_name]=($kibuvits_krl171_lc_emptystring+s_id_prefix).freeze
   end # set_ID_prefix

   def s_get_ID_prefix(s_id_name)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      s_out=@s_default_ID_prefix
      s_out=@ht_prefixes[s_id_name] if @ht_prefixes.has_key? s_id_name
      return s_out
   end # s_get_ID_prefix

   #-----------------------------------------------------------------------
   private

   def generate_ID(s_id_name,s_value_that_the_new_id_must_differ_from=$kibuvits_krl171_lc_underscore)
      s_out=nil
      s_initial=s_value_that_the_new_id_must_differ_from
      b_go_on=true
      while b_go_on
         s_out=s_get_ID_prefix(s_id_name)+Kibuvits_krl171_GUID_generator.generate_GUID()
         s_out.gsub!($kibuvits_krl171_lc_minus,$kibuvits_krl171_lc_underscore)
         b_go_on=false if s_initial!=s_out
      end # loop
      return s_out
   end # generate_ID

   #-----------------------------------------------------------------------
   public

   # ID-s must adhere to the rules of variable names.
   def set(s_id_name,s_id)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id)
      end # if
      @ht_registry[s_id_name]=($kibuvits_krl171_lc_emptystring+s_id).freeze
   end # set

   # Generates a new value for the ID in the registry.
   def reset(s_id_name)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      s_id_registry=nil
      if @ht_registry.has_key? s_id_name
         s_id_registry=@ht_registry[s_id_name]
      else
         s_id_registry=$kibuvits_krl171_lc_underscore
      end # if
      @ht_registry[s_id_name]=(generate_ID(s_id_name,s_id_registry)).freeze
   end # reset

   def s_get(s_id_name)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
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
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_wild
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      b_out=true
      if !@ht_registry.has_key? s_id_name
         # nil from registry and <whatever_value_from_the_wild> always differ.
         s_id_wild=$kibuvits_krl171_lc_underscore
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
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, Hash, ht_wild
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_name)
      end # if
      if !ht_wild.has_key? s_id_name
         kibuvits_krl171_throw("\n\nht_wild is missing the key \""+s_id_name+
         "\nGUID='c23ec742-2a0c-40f3-b477-c2c2f051a4e7'\n\n")
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
         kibuvits_krl171_throw("\n\nht_wild does contain the key \""+s_id_name+
         ", but it is not paired with a string.\n"+
         "s_id_wild.class=="+cl.to_s+
         "\ns_id_wild=="+s_id_wild.to_s+
         "\nGUID='4d89d0ac-a98a-4d7a-b147-c2c2f051a4e7'\n\n")
      end # if
      kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_id_wild) if KIBUVITS_krl171_b_DEBUG
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

end # class Kibuvits_krl171_IDstamp_registry_t1
#=====================kibuvits_krl171_IDstamp_registry_t1_rb_end==================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_IDstamp_registry_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_i18n_msgs_t1_rb_start=======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_i18n_msgs_t1_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_I18N_MSGS_T1_RB_INCLUDED
   KIBUVITS_krl171_I18N_MSGS_T1_RB_INCLUDED=true

   if !defined? KIBUVITS_krl171_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
      #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
   end # if

   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
end # if

#==========================================================================

# The class Kibuvits_krl171_i18n_msgs_t1 is a namespace for
# functions that are assemble human language specific strings.
# In the old fachioned terms: this file here is a language file.
class Kibuvits_krl171_i18n_msgs_t1
   def initialize
   end # initialize
   #-----------------------------------------------------------------------

   # The s_file_candidate_type is expected to hold
   # the File.ftype(...) output.
   #
   # It returns a human language analogue to the official,
   # english, eversion.
   def s_filetype_to_humanlanguage_t1(s_language,
      s_path_to_the_file_candidate,s_file_candidate_type)
      s_out=nil
      case s_language
      when $kibuvits_krl171_lc_et
         case s_file_candidate_type
         when "directory"
            s_out="kataloog"
         when "fifo"
            s_out="järjekord (fifo)"
         when "link"
            s_out="link"
         when "characterSpecial"
            s_out="jada-seadme-fail"
         when "blockSpecial"
            s_out="blokk-seadme-fail"
         when "unknown"
            s_out="klassifitseerumatu"
         else
            kibuvits_krl171_throw("s_file_candidate_type.to_s==\""+
            s_file_candidate_type.to_s+"\", but that value is "+
            "not supported by this method.")
         end # case s_file_candidate_type
      else # probably s_language=="uk"
         s_out=$kibuvits_krl171_lc_emptystring+s_file_candidate_type
      end # case s_language
      return s_out
   end # s_filetype_to_humanlanguage_t1

   def Kibuvits_krl171_i18n_msgs_t1.s_filetype_to_humanlanguage_t1(s_language,
      s_path_to_the_file_candidate,s_file_candidate_type)
      s_out=Kibuvits_krl171_i18n_msgs_t1.instance.s_filetype_to_humanlanguage_t1(
      s_language,s_path_to_the_file_candidate,s_file_candidate_type)
      return s_out
   end # Kibuvits_krl171_i18n_msgs_t1.s_filetype_to_humanlanguage_t1

   #-----------------------------------------------------------------------

   def s_msg_regular_file_exists_but_it_is_not_readable_t1(s_language,s_file_path)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_language
         kibuvits_krl171_typecheck bn, String, s_file_path
      end # if
      s_out=nil
      case s_language
      when $kibuvits_krl171_lc_et
         s_out="\nOperatsioonisüsteemi kontekstis tavapärane fail, \""+
         s_file_path+"\",\nleidub, kuid ta ei ole failisüsteemi juurdepääsuõiguste järgi loetav.\n\n"
      else # probably s_language=="uk"
         s_out="\nIn the contenxt of an operating system the regular file, \""+
         s_file_path+"\",\nexists, but it is not readable by the file system access rights.\n\n"
      end # case s_language
      return s_out
   end # s_msg_regular_file_exists_but_it_is_not_readable_t1

   def Kibuvits_krl171_i18n_msgs_t1.s_msg_regular_file_exists_but_it_is_not_readable_t1(
      s_language,s_file_path)
      s_out=Kibuvits_krl171_i18n_msgs_t1.instance.s_msg_regular_file_exists_but_it_is_not_readable_t1(
      s_language,s_file_path)
      return s_out
   end # Kibuvits_krl171_i18n_msgs_t1.s_msg_regular_file_exists_but_it_is_not_readable_t1

   #-----------------------------------------------------------------------

   def s_msg_method_is_missing_t1(s_language,ob,s_method_name,a_binding=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_language
         kibuvits_krl171_typecheck bn, String, s_method_name
         kibuvits_krl171_typecheck bn, [NilClass,Binding], a_binding
         bn_1=bn
         bn_1=a_binding if a_binding!=nil
         kibuvits_krl171_assert_string_min_length(bn_1,s_language,1)
         kibuvits_krl171_assert_string_min_length(bn_1,s_method_name,1)
      end # if
      s_ob_varname=$kibuvits_krl171_lc_emptystring
      if a_binding!=nil
         s_ob_varname=kibuvits_krl171_s_varvalue2varname(a_binding, ob)
      end # if
      s_out=nil
      case s_language
      when $kibuvits_krl171_lc_et
         if s_ob_varname.length==0
            s_out="\nIsendil puudus meetod nimega \""+
            s_method_name+"\".\n\n"
         else
            s_out="\nIsendil, millele viitab muutuja nimega \""+
            s_ob_varname+"\" puudus meetod nimega \""+
            s_method_name+"\".\n\n"
         end # if
      else # probably s_language=="uk"
         if s_ob_varname.length==0
            s_out="\nThe instance is missing a method named \""+
            s_method_name+"\".\n\n"
         else
            s_out="\nThe instance that is held by a variable named \""+
            s_ob_varname+"\" is missing a method named \""+
            s_method_name+"\".\n\n"
         end # if
      end # case s_language
      return s_out
   end # s_msg_method_is_missing_t1

   def Kibuvits_krl171_i18n_msgs_t1.s_msg_method_is_missing_t1(s_language,ob,
      s_method_name,a_binding=nil)
      s_out=Kibuvits_krl171_i18n_msgs_t1.instance.s_msg_method_is_missing_t1(
      s_language,ob,s_method_name,a_binding)
      return s_out
   end # Kibuvits_krl171_i18n_msgs_t1.s_msg_method_is_missing_t1

   #-----------------------------------------------------------------------

   def s_msg_negative_value_not_allowed_t1(s_language,s_x_var_name,x_var)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_language
         kibuvits_krl171_typecheck bn, String, s_x_var_name
         kibuvits_krl171_typecheck bn, [Fixnum,Float,Bignum,Rational], x_var
         if (0<=x_var)
            kibuvits_krl171_throw("x_var == "+x_var.to_s+
            "\nis expected to be negative."+
            "\nGUID=='aa6ea15d-8020-4ec7-8507-c2c2f051a4e7'")
         end # if
      end # if
      s_0=$kibuvits_krl171_lc_emptystring+
      s_x_var_name+" == "+x_var.to_s+" < 0"
      s_out=nil
      case s_language
      when $kibuvits_krl171_lc_et
         s_out=s_0+",\nkuid negatiivne väärtus pole muutujale "+
         s_x_var_name+" lubatud.\n\n"
      else # probably s_language=="uk"
         s_out=s_0+",\nbut the "+s_x_var_name+" must not be negative.\n\n"
      end # case s_language
      return s_out
   end # s_msg_negative_value_not_allowed_t1

   def Kibuvits_krl171_i18n_msgs_t1.s_msg_negative_value_not_allowed_t1(
      s_language,s_x_var_name,x_var)
      s_out=Kibuvits_krl171_i18n_msgs_t1.instance.s_msg_negative_value_not_allowed_t1(
      s_language,s_x_var_name,x_var)
      return s_out
   end # Kibuvits_krl171_i18n_msgs_t1.s_msg_negative_value_not_allowed_t1

   #-----------------------------------------------------------------------
   include Singleton
end # class Kibuvits_krl171_i18n_msgs_t1
#=====================kibuvits_krl171_i18n_msgs_t1_rb_end=========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_i18n_msgs_t1_rb_start".
#==========================================================================


#=====================kibuvits_krl171_htoper_t1_start=============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_htoper_t1_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HTOPER_RB_INCLUDED
   KIBUVITS_krl171_HTOPER_RB_INCLUDED=true

   if !defined? KIBUVITS_krl171_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
      #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
   end # if

   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
end # if

#==========================================================================

# The class Kibuvits_krl171_htoper_t1 is a namespace for general, simplistic,
# functions that read their operands from hashtables or store the
# result to hashtables. The methods of the Kibuvits_krl171_htoper_t1 somewhat
# resemble operands that operate on hashtable values. The main idea is
# to abstract away the fetching of values from hashtables and the
# storing of computation results back to the hashtables.
class Kibuvits_krl171_htoper_t1
   def initialize
   end # initialize

   #--------------------------------------------------------------------------

   # Returns the value that is returned from the &block
   # by the ruby block analogue of the ruby function return(...),
   # the next(...).
   #
   #        def demo_for_storing_values_back_to_the_hashtable
   #           ht=Hash.new
   #           ht['aa']=42
   #           ht['bb']=74
   #           ht['cc']=2
   #           ht['ht']=ht
   #           x=Kibuvits_krl171_htoper_t1.run_in_htspace(ht) do |bb,aa,ht|
   #              ht['cc']=aa+bb
   #           end # block
   #           raise Exception.new("x=="+x.to_s) if ht['cc']!=116
   #        end # demo_for_storing_values_back_to_the_hashtable
   #
   # May be one could figure out, how to improve the
   # implementation of the run_in_htspace(...) so that
   # the block in the demo_for_storing_values_back_to_the_hashtable()
   # would look like:
   #
   #              cc=aa+bb
   #
   # but the solution shown in the current version of the
   # demo_for_storing_values_back_to_the_hashtable(...)
   # seems to be more robust in terms of future changes in the
   # Ruby language implementation.
   #
   def run_in_htspace(ht,a_binding=nil,&block)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash,ht
         kibuvits_krl171_typecheck bn, Proc,block
         kibuvits_krl171_typecheck bn, [NilClass,Binding],a_binding
      end # if
      ar_of_ar=block.parameters
      s_block_arg_name=nil
      ar_block_arg_names=Array.new
      i_nfr=ar_of_ar.size
      if KIBUVITS_krl171_b_DEBUG
         i_nfr.times do |i|
            s_block_arg_name=(ar_of_ar[i])[1].to_s
            if !ht.has_key? s_block_arg_name
               b_ht_varkname_available=false
               s_ht_varname=nil
               if a_binding!=nil
                  s_ht_varname=kibuvits_krl171_s_varvalue2varname(a_binding,ht)
                  if s_ht_varname.size!=0
                     b_ht_varkname_available=true
                  end # if
               end # if
               if b_ht_varkname_available
                  kibuvits_krl171_throw("The hashtable named \""+s_ht_varname+
                  "\" does not contain a key named \""+s_block_arg_name+"\".")
               else
                  kibuvits_krl171_throw("The hashtable "+
                  "does not contain a key named \""+s_block_arg_name+"\".")
               end # if
            end # if
            ar_block_arg_names<<s_block_arg_name
         end # loop
      else
         i_nfr.times do |i|
            s_block_arg_name=(ar_of_ar[i])[1].to_s
            ar_block_arg_names<<s_block_arg_name
         end # loop
      end # if
      ar_method_arguments=Array.new
      i_nfr.times do |i|
         s_block_arg_name=ar_block_arg_names[i]
         ar_method_arguments<<ht[s_block_arg_name]
      end # loop
      x_out=kibuvits_krl171_call_by_ar_of_args(block,:call,ar_method_arguments)
      return x_out
   end # run_in_htspace

   def Kibuvits_krl171_htoper_t1.run_in_htspace(ht,a_binding=nil,&block)
      x_out=Kibuvits_krl171_htoper_t1.instance.run_in_htspace(ht,a_binding,&block)
      return x_out
   end # Kibuvits_krl171_htoper_t1.run_in_htspace

   #--------------------------------------------------------------------------

   # ht[s_key]=ht[s_key]+x_value_to_add
   #
   # The ht[s_key] must have the + operator/method defined
   # for the type of the x_value_to_add and the key, s_key,
   # must be present in the hashtable.
   #
   # Returns the version of the instance of ht[s_key] that
   # exists after performing the operation.
   def plus(ht,s_key,x_value_to_add,a_binding=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash,ht
         kibuvits_krl171_typecheck bn, String,s_key
         kibuvits_krl171_typecheck bn, [NilClass,Binding],a_binding
         if a_binding!=nil
            kibuvits_krl171_assert_ht_has_keys(a_binding,ht,s_key)
         else
            kibuvits_krl171_assert_ht_has_keys(bn,ht,s_key)
         end # if
      end # if DEBUG
      a=ht[s_key]
      x_sum=a+x_value_to_add
      ht[s_key]=x_sum
      return x_sum
   end # plus

   def Kibuvits_krl171_htoper_t1.plus(ht,s_key,x_value_to_add,a_binding=nil)
      x_sum=Kibuvits_krl171_htoper_t1.instance.plus(ht,s_key,x_value_to_add,a_binding)
      return x_sum
   end # Kibuvits_krl171_htoper_t1.plus

   #--------------------------------------------------------------------------

   # A sparse variables are inspired by sparce matrices.
   # A semi-sparse variable is a variable that is instantiated and
   # inited to the default value at the very first read access.
   def x_getset_semisparse_var(ht,s_varname,x_var_default_value)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash,ht
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_varname)
      end # if DEBUG
      x_out=nil
      if ht.has_key? s_varname
         x_out=ht[s_varname]
      else
         x_out=x_var_default_value
         ht[s_varname]=x_var_default_value
      end # if
      return x_out
   end # x_getset_semisparse_var

   def Kibuvits_krl171_htoper_t1.x_getset_semisparse_var(ht,s_varname,x_var_default_value)
      x_out=Kibuvits_krl171_htoper_t1.instance.x_getset_semisparse_var(
      ht,s_varname,x_var_default_value)
      return x_out
   end # Kibuvits_krl171_htoper_t1.x_getset_semisparse_var

   #--------------------------------------------------------------------------


   # Copies all ht keys to a binding context so that
   # each key-value pair will form a variable-value pair in the binding.
   #
   # All keys of the ht must be strings.
   #
   #  # Needs to be dormant till the ruby-lang.org flaw #8438 gets fixed.
   #
   #def ht2binding(ob_binding,ht)
   #if KIBUVITS_krl171_b_DEBUG
   #bn=binding()
   #kibuvits_krl171_typecheck bn, Binding, ob_binding
   #kibuvits_krl171_typecheck bn, Hash, ht
   #ht.each_key do |x_key|
   #bn_1=binding()
   #kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn_1,x_key)
   #end # loop
   #end # if DEBUG
   #ar_for_speed=Array.new
   #ht.each_pair do |s_key,x_value|
   #kibuvits_krl171_set_var_in_scope(ob_binding,s_key,x_value,ar_for_speed)
   #end # loop
   #end # ht2binding
   #
   #def Kibuvits_krl171_htoper_t1.ht2binding(ob_binding,ht)
   #Kibuvits_krl171_htoper_t1.instance.ht2binding(ob_binding,ht)
   #end # Kibuvits_krl171_htoper_t1.ht2binding

   #--------------------------------------------------------------------------

   # Creates a new Hash instance that contains the same instances
   # that the ht_orig has.
   def ht_clone_with_shared_references(ht_orig)
      ht_out=Hash.new
      ht_orig.each_pair{|x_key,x_value| ht_out[x_key]=x_value}
      return ht_out
   end # ht_clone_with_shared_references

   def Kibuvits_krl171_htoper_t1.ht_clone_with_shared_references(ht_orig)
      ht_out=Kibuvits_krl171_htoper_t1.instance.ht_clone_with_shared_references(ht_orig)
      return ht_out
   end # Kibuvits_krl171_htoper_t1.ht_clone_with_shared_references

   #--------------------------------------------------------------------------

   # If the ht_in has s_key, then new key candidates are
   # generated by counting from N=1. The key candidate will
   # have a form of
   #
   #     s_numeration="0"*<something>+N.to_s
   #     s_candidate=s_numeration+"_"+s_key
   #
   # where i_minimum_amount_of_digits<=s_numeration.length
   def insert_to_ht_without_overwriting_any_key_t1(
      ht_in,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_in
         kibuvits_krl171_typecheck bn, String, s_key
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_all_keys_will_contain_numeration_rpefix
         kibuvits_krl171_typecheck bn, Fixnum, i_minimum_amount_of_digits
         kibuvits_krl171_typecheck bn, String, s_suffix_of_the_prefix
      end # if
      if !b_all_keys_will_contain_numeration_rpefix
         if !ht_in.has_key? s_key
            ht_in[s_key]=x_value
            return
         end # if
      end # if
      func_s_gen_key_candidate=lambda do |i_in|
         s_enum=Kibuvits_krl171_str.s_to_s_with_assured_amount_of_digits_t1(
         i_minimum_amount_of_digits, i_in)
         s_out=s_enum+s_suffix_of_the_prefix+s_key
         return s_out
      end # func_s_gen_key_candidate
      i_enum=0
      s_key_candidate=func_s_gen_key_candidate.call(i_enum)
      while ht_in.has_key? s_key_candidate
         i_enum=i_enum+1
         s_key_candidate=func_s_gen_key_candidate.call(i_enum)
      end # loop
      ht_in[s_key_candidate]=x_value
   end # insert_to_ht_without_overwriting_any_key_t1


   def Kibuvits_krl171_htoper_t1.insert_to_ht_without_overwriting_any_key_t1(
      ht_in,s_key,x_value, b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits, s_suffix_of_the_prefix)
      Kibuvits_krl171_htoper_t1.instance.insert_to_ht_without_overwriting_any_key_t1(
      ht_in,s_key,x_value,b_all_keys_will_contain_numeration_rpefix,
      i_minimum_amount_of_digits,s_suffix_of_the_prefix)
   end # Kibuvits_krl171_htoper_t1.insert_to_ht_without_overwriting_any_key_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_htoper_t1

#=====================kibuvits_krl171_htoper_t1_end===============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_htoper_t1_start".
#==========================================================================

#=====================kibuvits_krl171_gstatement_rb_start=========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_gstatement_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_refl.rb"

#==========================================================================

# The Kibuvits_krl171_gstatement instances represents an
# EBNF style statement like MY_GSTATEMENT_TYPE:==MOUSE MOUSEJUMP* CAT?
#
# The Kibuvits_krl171_gstatement acts as a container for other
# instances of the Kibuvits_krl171_gstatement. The overall idea
# behind the Kibuvits_krl171_gstatement is that if all of the
# terms and terminals at the right side of the :== are represented
# by elements that reside inside the Kibuvits_krl171_gstatement based
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
class Kibuvits_krl171_gstatement
   attr_reader :name, :s_spec
   attr_accessor :s_prefix, :s_suffix # for code generation simplification

   private
   @@lc_s_claim_to_be_a_gstatement_42_7="claim_to_be_a_gstatement_42_7"
   @@lc_space=$kibuvits_krl171_lc_space
   @@lc_ceqeq=":=="
   @@lc_emptystring=$kibuvits_krl171_lc_emptystring
   @@lc_lbrace=$kibuvits_krl171_lc_lbrace
   @@lc_rbrace=$kibuvits_krl171_lc_rbrace
   @@lc_questionmark=$kibuvits_krl171_lc_questionmark
   @@lc_star=$kibuvits_krl171_lc_star
   @@lc_plus=$kibuvits_krl171_lc_plus
   @@lc_pillar=$kibuvits_krl171_lc_pillar
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
         kibuvits_krl171_throw "\nFaulty specification. "+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_2)!=nil
         kibuvits_krl171_throw "\nEither one of the operators, {?,*,+,|}, is \n"+
         "at the start of the right side of the equation or \n"+
         "the | operator is at the end of the equation.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_3)!=nil
         kibuvits_krl171_throw "\nDue to a implementationspecific limitation the \n"+
         "use of any of the operators, {?,*,+,|}, outside of braces\n"+
         "is not allowed.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_4)!=nil
         kibuvits_krl171_throw "\nCases like \"Abb Bcc | Cdd\" are not supported.\n"+
         "s_specification_in_EBNF==\""+s_spec+"\n"
      end # if
      if s_spec.match(@@rgx_for_verification_5)!=nil
         kibuvits_krl171_throw "\nCases like \"Abb | Bcc Cdd\" are not supported.\n"+
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
      s_right=Kibuvits_krl171_str.trim(s_right)

      # "A B?"              -> "A B?"
      # "A (B+ |C) E F(G) " -> "A  (B+ |C) E F (G) "
      # ..........................A...........A......
      # "A|B|C*"            -> "A|B|C*"
      s_right=s_right.gsub(@@rgx_lbrace," (")

      # "A B?"                -> "A B?"
      # "A  (B+ |C) E F (G) " -> "A  (B+ |C) E F (G)"
      # ...................X...........................
      # "A|B|C*"              -> "A|B|C*"
      s_right=Kibuvits_krl171_str.trim(s_right)


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
      ar=Kibuvits_krl171_str.ar_explode(s_right,@@lc_lbrace)
      # ar[0]=="", because for sctring like "(blabla)" and
      # a separator like "(" the bisection takes place at the
      # first character. It's just according to the explode spec.

      if ar.length==1 # It's not for debug.
         kibuvits_krl171_throw "\nThe code of this class is broken. Sorry. ar.length=="+
         ar.length.to_s+"\n"
      end # if
      s=nil
      (ar.length-1).times do |i|
         s=ar[i+1]
         kibuvits_krl171_throw "s=="+s.to_s if s.length<2 # It should at least have the ")".
         kibuvits_krl171_throw "s=="+s.to_s if s[(-1)..(-1)]!=@@lc_rbrace
         ar_out<<s[0..(-2)]
      end # loop
      return ar_out;
   end # get_array_of_level1_components

   def level2_spec_partial_verification s_level2_spec
      if s_level2_spec.match(@@rgx_or_at_startofline)!=nil
         kibuvits_krl171_throw "\nPlacing the operator | at the start of "+
         "a subexpression does not make sense.\n"+
         "subexpression=="+s_level2_spec+"\n"
      end # if
      if s_level2_spec.match(@@rgx_or_at_endofline)!=nil
         kibuvits_krl171_throw "\nPlacing the operator | at the end of "+
         "a subexpression does not make sense.\n"+
         "subexpression=="+s_level2_spec+"\n"
      end # if
      if s_level2_spec.match(@@rgx_two_ors)!=nil
         kibuvits_krl171_throw "\nPlacing more than one | operator "+
         "between 2 terminals or terms is not supported.\n"+
         "subexpression=="+s_level2_spec+"\n"
      end # if
      if s_level2_spec.length==0
         kibuvits_krl171_throw "\nThe code of this class is broken. "+
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
         kibuvits_krl171_throw "\nEach of the terminal/term names can be used \n"+
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
      ar=Kibuvits_krl171_str.ar_explode(s_level2_spec,@@lc_pillar)

      ht_level2=@ar_level1[i_level1_index]
      ht_level2[@@lc_b_complete]=false
      ht_level2_index=Hash.new
      ht_level2[@@lc_ht_level2_index]=ht_level2_index
      ar.each do |s_level3_spec|
         initialize_single_level3_component(s_level3_spec,ht_level2)
      end # loop
   end # initialize_single_level2_component

   def parse_specification s_spec
      ar=Kibuvits_krl171_str.ar_bisect(s_spec,@@lc_ceqeq)
      s_left=Kibuvits_krl171_str.trim(ar[0])
      s_right=Kibuvits_krl171_str.trim(ar[1])
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
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_specification_in_EBNF
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
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
   # the tested instance is not a Kibuvits_krl171_gstatement istance.
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
         # it at the Kibuvits_krl171_refl.get_methods_by_name either.
         # One just waits for the Ruby itself to stabilize to something.
         ht_method_names_or_symbols=Kibuvits_krl171_refl.get_methods_by_name(
         @@lc_s_claim_to_be_a_gstatement_42_7,ob,"protected",@msgcs)
         kibuvits_krl171_throw @msgcs.to_s if @msgcs.b_failure
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
            kibuvits_krl171_throw "x_gstatement, which is of class \""+
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

end # class Kibuvits_krl171_gstatement

#=========================================================================
#msgcs=Kibuvits_krl171_msgc_stack.new
#s_spec="UU:==A (B+ |C)E F(G)"
#gst=Kibuvits_krl171_gstatement.new(s_spec,msgcs)
#=====================kibuvits_krl171_gstatement_rb_end===========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_gstatement_rb_start".
#==========================================================================

#=====================kibuvits_krl171_graph_rb_start==============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_graph_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_GUID_generator.rb"

#==========================================================================

# A useful hint:
#
#     Hyperedges (http://urls.softf1.com/a1/krl/frag3/ )
#     can be implemented by using a vertex in place of
#     a hyperedge and furnishing all vertices with
#     a type parameter that distinguishes plain vertices
#     from hyperedge vertices.
#
# The current implementation uses only directed edges. The edge
# records are stored in vertices that connect to the arrow
# tail side of an edge.
#
class Kibuvits_krl171_graph_vertex
   # The specification, where hyperedges, edges in general,
   # were instances of a separate class, is considered unpractical to the
   # point of being flawed, because after the completion of vertex and
   # edge class that conform with that kind of a specification, it turned
   # out that the client code is far more complex than it
   # could be with the implementation that has the comment that
   # You are just reading.

   @@ar_lc_modes=[$kibuvits_krl171_lc_any, $kibuvits_krl171_lc_outbound, $kibuvits_krl171_lc_inbound]

   attr_reader :s_id

   # Data that is attached to this vertex.
   attr_reader :ht_vertex_records

   # key   --- outbound vertex ID
   # value --- a hashtable, Hash instance
   #
   # The current implementation uses only directed edges. The edge
   # records are stored in vertices that connect to the arrow
   # tail side of an edge.
   attr_reader :ht_edge_records

   # key   --- vertex ID
   # value --- vertex
   # An inbound vertex is a vertex that is connected to
   # the current vertex by a directed edge so that
   # the directed edge leaves the inbound vertex and
   # arrives to the current vertex.
   #
   # Due to consistency reasons the content of this
   # hashtable must not be modified by
   attr_reader :ht_inbound_vertices

   # key   --- vertex ID
   # value --- vertex
   # An outbound vertex is a vertex that is connected to
   # the current vertex by a directed edge so that
   # the directed edge leaves the current vertex and
   # arrives to the outbound vertex.
   #
   # The edge records of the outbound vertices are held
   # in the current vertex.
   attr_reader :ht_outbound_vertices


   # key   --- vertex ID
   # value --- vertex
   # It duplicates the conjunction of
   # the ht_inbound_vertices and the ht_outbound_vertices, but
   # its useful for efficiency.
   attr_reader :ht_all_vertices

   # The @s_connections_state_ID is a GUID that is
   # changed every time any vertices are added or removed
   # from the graph. It simplifies the code of graph-crawling spiders
   # that want to find out, wether any vertices have been added or removed
   # after the last time the spider visited the vertex.
   attr_reader :s_connections_state_ID

   #--------------------------------------------------------------------------

   def initialize b_threadsafe=true
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [FalseClass,TrueClass],b_threadsafe
      end # if
      @s_id=Kibuvits_krl171_GUID_generator.generate_GUID.freeze
      @ht_vertex_records=Hash.new
      @ht_edge_records=Hash.new
      @ht_inbound_vertices=Hash.new
      @ht_outbound_vertices=Hash.new
      @ht_all_vertices=Hash.new
      @s_connections_state_ID=Kibuvits_krl171_GUID_generator.generate_GUID
      @b_threadsafe=b_threadsafe
      @mx=nil
      @mx=Monitor.new if b_threadsafe
   end # initialize

   # s_mode is from the set {"any","inbound","outbound"}
   def connected?(ob_vertex,s_mode=$kibuvits_krl171_lc_any)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_vertex
         kibuvits_krl171_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # if
      b_out=false
      case s_mode
      when $kibuvits_krl171_lc_any
         b_out=@ht_all_vertices.has_key?(ob_vertex.s_id)
      when $kibuvits_krl171_lc_outbound
         b_out=@ht_outbound_vertices.has_key?(ob_vertex.s_id)
      when $kibuvits_krl171_lc_inbound
         b_out=@ht_inbound_vertices.has_key?(ob_vertex.s_id)
      else
         bn=binding()
         kibuvits_krl171_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # case s_mode
      return b_out
   end # connected

   # http://mathworld.wolfram.com/VertexDegree.html
   #
   # The current implementation returns 0, if the
   # vertex is connected only to itself.
   def i_degree(s_mode=$kibuvits_krl171_lc_any)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # if
      i_out=0
      case s_mode
      when $kibuvits_krl171_lc_any
         if @b_threadsafe
            @mx.synchronize do
               i_out=@ht_outbound_vertices.length+
               @ht_inbound_vertices.length
               i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
               i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
            end # block
         else
            i_out=@ht_outbound_vertices.length+
            @ht_inbound_vertices.length
            i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
            i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
         end # if
      when $kibuvits_krl171_lc_outbound
         if @b_threadsafe
            @mx.synchronize do
               i_out=@ht_outbound_vertices.length
               i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
            end # block
         else
            i_out=@ht_outbound_vertices.length
            i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
         end # if
      when $kibuvits_krl171_lc_inbound
         if @b_threadsafe
            @mx.synchronize do
               i_out=@ht_inbound_vertices.length
               i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
            end # block
         else
            i_out=@ht_inbound_vertices.length
            i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
         end # if
      else
         bn=binding()
         kibuvits_krl171_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # case s_mode
      return i_out
   end # i_degree

   #--------------------------------------------------------------------------

   private

   # It's "semi-lockless" in stead of "lockless", because
   # it conditionally calls the connect_.... of the ob_vertex
   # and the connect_.... uses the ob_vertex local mutex
   # according to the ob_vertex instantiation parameter, the b_threadsafe.
   def connect_outbound_vertex_semilockless(ob_vertex)
      s_vx_id=ob_vertex.s_id
      if @ht_outbound_vertices.has_key? s_vx_id
         kibuvits_krl171_throw("\n\nA vertex with an ID of "+@s_id+
         " already has an outbound\nvertex with   an ID of "+
         ob_vertex.s_id+"\n\n")
      end # if
      @ht_outbound_vertices[s_vx_id]=ob_vertex
      @ht_edge_records[s_vx_id]=Hash.new
      # There can be 2 directed edges between 2 vertices.
      if !@ht_all_vertices.has_key? s_vx_id
         @ht_all_vertices[s_vx_id]=ob_vertex
      end # if
      if !ob_vertex.ht_inbound_vertices.has_key? @s_id
         ob_vertex.connect_inbound_vertex(self)
      end # if
      @s_connections_state_ID=Kibuvits_krl171_GUID_generator.generate_GUID
   end # connect_outbound_vertex_semilockless

   # Comment resides next to the connect_outbound_vertex_semilockless(...).
   def connect_inbound_vertex_semilockless(ob_vertex)
      s_vx_id=ob_vertex.s_id
      if @ht_inbound_vertices.has_key? s_vx_id
         kibuvits_krl171_throw("\n\nA vertex with an ID of "+@s_id+
         " already has an inbound\nvertex with   an ID of "+
         ob_vertex.s_id+"\n\n")
      end # if
      @ht_inbound_vertices[s_vx_id]=ob_vertex
      # There can be 2 directed edges between 2 vertices.
      if !@ht_all_vertices.has_key? s_vx_id
         @ht_all_vertices[s_vx_id]=ob_vertex
      end # if
      if !ob_vertex.ht_outbound_vertices.has_key? @s_id
         ob_vertex.connect_outbound_vertex(self)
      end # if
      @s_connections_state_ID=Kibuvits_krl171_GUID_generator.generate_GUID
   end # connect_inbound_vertex_semilockless

   #--------------------------------------------------------------------------

   public

   # It's OK for a vertex to be connected to itself, however,
   # this method will throw on an attempt to add the same directed
   # edge more than once.
   def connect_outbound_vertex(ob_vertex)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_vertex
      end # if KIBUVITS_krl171_b_DEBUG
      if @b_threadsafe
         @mx.synchronize do
            connect_outbound_vertex_semilockless(ob_vertex)
         end # block
      else
         connect_outbound_vertex_semilockless(ob_vertex)
      end # if
   end # connect_outbound_vertex

   # It's OK for a vertex to be connected to itself, however,
   # this method will throw on an attempt to add the same directed
   # edge more than once.
   def connect_inbound_vertex(ob_vertex)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_vertex
      end # if KIBUVITS_krl171_b_DEBUG
      if @b_threadsafe
         @mx.synchronize do
            connect_inbound_vertex_semilockless(ob_vertex)
         end # block
      else
         connect_inbound_vertex_semilockless(ob_vertex)
      end # if
   end # connect_inbound_vertex

   #--------------------------------------------------------------------------

   private

   # Comment resides next to the connect_outbound_vertex_semilockless(...).
   def disconnect_vertex_semilockless(ob_vertex)
      s_vx_id=ob_vertex.s_id
      if @ht_inbound_vertices.has_key? s_vx_id
         @ht_inbound_vertices.delete(s_vx_id)
      end # if
      if @ht_outbound_vertices.has_key? s_vx_id
         @ht_outbound_vertices.delete(s_vx_id)
         @ht_edge_records.delete(s_vx_id)
      end # if
      if @ht_all_vertices.has_key? s_vx_id
         @ht_all_vertices.delete(s_vx_id)
      end # if
      if ob_vertex.ht_all_vertices.has_key? @s_id
         ob_vertex.disconnect_vertex(self)
      end # if
   end # disconnect_vertex_semilockless

   def disconnect_all_vertices_semilockless
      ar=@ht_all_vertices.values
      ar.each do |ob_vertex|
         ob_vertex.disconnect_vertex(self)
      end # loop
   end # disconnect_all_vertices_semilockless

   public

   def disconnect_vertex(ob_vertex)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_vertex
      end # if KIBUVITS_krl171_b_DEBUG
      if @b_threadsafe
         @mx.synchronize do
            disconnect_vertex_semilockless(ob_vertex)
         end # block
      else
         disconnect_vertex_semilockless(ob_vertex)
      end # if
   end # disconnect_vertex


   def disconnect_all_vertices
      if @b_threadsafe
         @mx.synchronize do
            disconnect_all_vertices_semilockless()
         end # block
      else
         disconnect_all_vertices_semilockless()
      end # if
   end # disconnect_all_vertices

   #-----------------------------------------------------------------------

end # class Kibuvits_krl171_graph_vertex
#=====================kibuvits_krl171_graph_rb_end================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_graph_rb_start".
#==========================================================================

#=====================kibuvits_krl171_arraycursor_t1_rb_start=====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_arraycursor_t1_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#==========================================================================

# The Array.new.each {|array_element| do_something(array_element)} iterates
# over all elements of the array, but instances of this class allow
# to pause the iteration cycle and implement the "overflow" mechanism.
# For example, if ar[ar.size] is reached, it returns ar[0].
#
# It allows to iterate to both directions, like {0,1,2,3} and {3,2,1,0}.
class Kibuvits_krl171_arraycursor_t1

   attr_reader :ar_core

   #-----------------------------------------------------------------------

   def reset(ar_core)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array,ar_core
      end # if KIBUVITS_krl171_b_DEBUG
      # As the @ar_core is a reference, code outside might call
      # Array.clear(). and that might cause the cursor position
      # to become obsolete.
      if @b_threadsafe
         @mx.synchronize do
            @ar_core=ar_core
            @i_ar_core_expected_lenght=@ar_core.size
            # The indexing scheme:
            # http://longterm.softf1.com/specifications/array_indexing_by_separators/
            @ixs_low=0
            @ixs_high=0
            @ixs_high=1 if 0<@i_ar_core_expected_lenght
            @b_inited=true
         end # block
      else
         @ar_core=ar_core
         @i_ar_core_expected_lenght=@ar_core.size
         # The indexing scheme:
         # http://longterm.softf1.com/specifications/array_indexing_by_separators/
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
            @ar_core=$kibuvits_krl171_lc_emptyarray
         end # block
      else
         @b_inited=false
         @ar_core=$kibuvits_krl171_lc_emptyarray
      end # if
   end # clear

   def initialize(b_threadsafe=true)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass],b_threadsafe
      end # if KIBUVITS_krl171_b_DEBUG
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
   # ob_cursor=Kibuvits_krl171_arraycursor_t1.new
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
         kibuvits_krl171_throw("\n\nThe "+s_0+" instance has not been associated with "+
         "an array.\n"+s_0+" instances can be "+
         "associeated with an array by using metod reset(ar)."+
         "\nGUID='71664859-0fdd-4823-a3d6-c2c2f051a4e7'\n\n")
      end # if
      if @i_ar_core_expected_lenght!=i_ar_len
         @b_inited=false # Should the exception be caught by some sloppy developer.
         kibuvits_krl171_throw("\n\nThe length of the array instance that "+
         "has been declared by using the method reset(ar)\n"+
         "has been changed from "+@i_ar_core_expected_lenght.to_s+
         " to "+i_ar_len.to_s+".\n"+
         "\nGUID='b3041727-fbf1-468a-b3a6-c2c2f051a4e7'\n\n")
      end # if
      if KIBUVITS_krl171_b_DEBUG
         if 0<i_ar_len
            if @ixs_low==@ixs_high
               kibuvits_krl171_throw("\n\n@ixs_low == "+@ixs_low.to_s+
               " == @ixs_high == "+@ixs_high.to_s+
               "\nGUID='8eb45830-f63d-4b44-9176-c2c2f051a4e7'\n\n")
            end # if
         end # if
      end # if KIBUVITS_krl171_b_DEBUG
      return true if i_ar_len==0
      return false
   end # b_conditions_met_for_returning_nil_for_both_inc_and_dec

   def inc_sindices(i_ar_len)
      if KIBUVITS_krl171_b_DEBUG
         if i_ar_len==0
            kibuvits_krl171_throw("\n\ni_ar_len == 0, which is contradictory here.\n"+
            "\nGUID='b7b96d48-be44-4054-9446-c2c2f051a4e7'\n\n")
         end # if
      end # if KIBUVITS_krl171_b_DEBUG
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
      if KIBUVITS_krl171_b_DEBUG
         if i_ar_len==0
            kibuvits_krl171_throw("\n\ni_ar_len == 0, which is contradictory here.\n"+
            "\nGUID='db190921-ce57-4a07-9516-c2c2f051a4e7'\n\n")
         end # if
      end # if KIBUVITS_krl171_b_DEBUG
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

end # class Kibuvits_krl171_arraycursor_t1
#=====================kibuvits_krl171_arraycursor_t1_rb_end=======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_arraycursor_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_graph_oper_t1_rb_start======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_graph_oper_t1_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
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
#==========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_htoper_t1.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_graph.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_IDstamp_registry_t1.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_arraycursor_t1.rb"

#==========================================================================
# A base class for graph navigation agents.
# http://urls.softf1.com/a1/krl/frag5/
#
# A general idea is that each spider reads and writes its own, crawling-session specific
# and instance specific, "silk-trace" records to graph vertices.
class Kibuvits_krl171_spider_t1

   # The @s_crawling_session_ID is for distinguishing different crawling journies that
   # start from the same @ob_vx_start_location.
   # It's updated/changed within the reset method. The reason, why the @s_crawling_session_ID
   # is of type string in stead of a Fixnum is that that way it's easy to
   # generate non-colliding values to it, which in turn allowes a graph
   # to be crawled simultaniously by multiple, independent, spiders.
   attr_reader :ob_vx_location, :ob_vx_start_location, :s_crawling_session_ID

   attr_reader :s_id # a spider ID

   # If the i_trajectory_maximum_recording_length==(-1), then
   # the length of the queue of visited vertex ids
   # is not artificially limited. If the
   # (-1) < i_trajectory_maximum_recording_length, then
   # the i_trajectory_maximum_recording_length must be greater than
   # zero, because at least some a backtracking implementations depend on a
   # fact that the the recorded trajectory has a maximum lenght of at least 1.
   #
   # If the i_visited_vertex_cache_maximum_size==(-1), then
   # the size of the visited vertex cahce is not limited.
   # If the i_visited_vertex_cache_maximum_size==0,
   # then the visited vertices are not placed to the cache.
   #
   def initialize(msgcs, i_trajectory_maximum_recording_length=1,
      i_visited_vertex_cache_maximum_size=(-1))
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         kibuvits_krl171_typecheck bn, Fixnum, i_trajectory_maximum_recording_length
         kibuvits_krl171_typecheck bn, Fixnum, i_visited_vertex_cache_maximum_size
         if i_trajectory_maximum_recording_length<(-1)
            kibuvits_krl171_throw("\ni_trajectory_maximum_recording_length=="+
            i_trajectory_maximum_recording_length.to_s+" < (-1) \n",bn)
         else
            if i_trajectory_maximum_recording_length==0
               kibuvits_krl171_throw("\ni_trajectory_maximum_recording_length=="+
               i_trajectory_maximum_recording_length.to_s+" \n",bn)
            end # if
         end # if
         if i_visited_vertex_cache_maximum_size<(-1)
            kibuvits_krl171_throw("\ni_visited_vertex_cache_maximum_size=="+
            i_visited_vertex_cache_maximum_size.to_s+" < (-1) \n",bn)
         end # if
      end # if KIBUVITS_krl171_b_DEBUG
      @i_trajectory_maximum_recording_length=i_trajectory_maximum_recording_length
      @ar_trajectory=Array.new
      # key   --- vetex ID
      # value --- vetex
      @ht_trajectory_vx=Hash.new
      # key   --- vetex ID
      # value --- number of vertices that have the given ID and
      #           that are part of the trajctory.
      @ht_trajectory_count=Hash.new

      # key   --- vetex ID
      # value --- vetex
      @ht_visited_vertex_cache=Hash.new
      @ar_visited_vertex_cache=Array.new # a queue of vertex ID-s
      @i_visited_vertex_cache_maximum_size=i_visited_vertex_cache_maximum_size

      # It's the vertex, where the spider currently resides.
      @ob_vx_location=nil
      @ob_vx_start_location=nil

      @mx=Monitor.new

      @s_id=Kibuvits_krl171_GUID_generator.generate_GUID.gsub(
      $kibuvits_krl171_lc_minus,$kibuvits_krl171_lc_underscore).freeze
      @s_spiderspecific_varname_prefix=("Kibuvits_krl171_spider_t1_instance_"+
      @s_id+$kibuvits_krl171_lc_underscore).freeze
      @ob_IDregistry=Kibuvits_krl171_IDstamp_registry_t1.new(@s_spiderspecific_varname_prefix)

      @instance_lc_s_crawling_session_ID=(@s_spiderspecific_varname_prefix+
      "s_crawling_session_ID").freeze
      @s_crawling_session_ID=@ob_IDregistry.s_get(
      @instance_lc_s_crawling_session_ID)

      # Each spiders might arrive to a vertex after the value of the
      # Kibuvits_krl171_graph_vertex.s_connections_state_ID has changed.
      @instance_lc_s_vx_connections_state_ID=(@s_spiderspecific_varname_prefix+
      "s_vx_connections_state_ID").freeze
   end # initialize

   protected

   # It's a hook that is meant to be optionally overridden.
   # It's called from the reset().
   def implementation_specific_reset
   end # implementation_specific_reset

   # It's a hook that is called from the method crawl(...),
   # and that's also, where its output details reside.
   #
   # It must return 2 values at once:
   # ob_vertex_where_the_spider_must_jump_during_this_iteration, b_pause_crawling
   #
   # If the iteration does not change the location, then the value of the
   # ob_vertex_where_the_spider_must_jump_during_this_iteration must equal with the
   # value of the @ob_vx_location and the b_pause_crawling must equal with true.
   #
   # Crawling does not necessarily have to involve searching.
   # Search result store is expected to be implemented within
   # the class that is derived from the Kibuvits_krl171_spider_t1.
   #
   def choose_next_vertex_and_determine_whether_to_pause()
      # Hint 2: http://urls.softf1.com/a1/krl/frag3/
      kibuvits_krl171_throw("This method is expected to be overridden.")
   end # choose_next_vertex_and_determine_whether_to_pause

   public

   # The spider will have the location of ob_start_location_vertex.
   # All caches are emptied.
   def reset(ob_start_location_vertex)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_start_location_vertex
      end # if KIBUVITS_krl171_b_DEBUG
      @mx.synchronize do
         implementation_specific_reset()
         @ht_visited_vertex_cache.clear
         @ar_visited_vertex_cache.clear
         @ar_trajectory.clear
         @ht_trajectory_vx.clear
         @ht_trajectory_count.clear
         @ob_vx_location=ob_start_location_vertex
         @ob_vx_start_location=ob_start_location_vertex

         @ob_IDregistry.reset(@instance_lc_s_crawling_session_ID)
         @s_crawling_session_ID=@ob_IDregistry.s_get(
         @instance_lc_s_crawling_session_ID)
      end # block
   end # reset

   # Returns nil, if the location is not set.
   def x_location_vertex
      return @ob_vx_location
   end # x_location_vertex

   private

   # The main difference between the trajectory and a plain
   # visited vertex cache is that a trajectory can contain
   # a single vertex multiple times, but the visited vertex cache
   # contains each vertex at most once.
   def update_cahe_and_trajectory(ob_vx_new_location)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_vx_new_location
      end # if KIBUVITS_krl171_b_DEBUG
      s_vx_id=ob_vx_new_location.s_id
      return if s_vx_id==@ob_vx_location.s_id
      if !@ht_visited_vertex_cache.has_key? s_vx_id
         if @i_visited_vertex_cache_maximum_size==(-1)
            @ht_visited_vertex_cache[s_vx_id]=ob_vx_new_location
            @ar_visited_vertex_cache<<ob_vx_new_location
         else
            if 0<@i_visited_vertex_cache_maximum_size
               if @ar_visited_vertex_cache.size==@i_visited_vertex_cache_maximum_size
                  ob_vx=@ar_visited_vertex_cache[0]
                  @ar_visited_vertex_cache.delete_at(0)
                  s_ob_vx_id=ob_vx.s_id
                  @ht_visited_vertex_cache.delete(s_ob_vx_id)
               end # if
               @ht_visited_vertex_cache[s_vx_id]=ob_vx_new_location
               @ar_visited_vertex_cache<<ob_vx_new_location
            else # @i_visited_vertex_cache_maximum_size==0
               # No caching.
            end # if
         end # if
      end # if

      if @i_trajectory_maximum_recording_length==(-1)
         @ar_trajectory<<ob_vx_new_location
         if !@ht_trajectory_vx.has_key? s_vx_id
            @ht_trajectory_vx[s_vx_id]=ob_vx_new_location
            @ht_trajectory_count[s_vx_id]=1
         else
            i_0=@ht_trajectory_count[s_vx_id]
            @ht_trajectory_count[s_vx_id]=i_0+1
         end # if
      else
         if 0<@i_trajectory_maximum_recording_length
            if @ar_trajectory.size==@i_trajectory_maximum_recording_length
               ob_old_vx=@ar_trajectory[0]
               @ar_trajectory.delete_at(0)
               s_ob_old_vx_id=ob_old_vx.s_id
               i_0=@ht_trajectory_count[s_ob_old_vx_id]
               i_0=i_0-1
               @ht_trajectory_count[s_ob_old_vx_id]=i_0
               if i_0==0
                  if s_ob_old_vx_id!=s_vx_id
                     @ht_trajectory_count.delete(s_ob_old_vx_id)
                     @ht_trajectory_vx.delete(s_ob_old_vx_id)
                  end # if
               end # if
            end # if
            @ar_trajectory<<ob_vx_new_location
            if @ht_trajectory_vx.has_key? s_vx_id
               i_0=@ht_trajectory_count[s_vx_id]
               i_0=i_0+1
            else
               @ht_trajectory_vx[s_vx_id]=ob_vx_new_location
               i_0=1
            end # if
            @ht_trajectory_count[s_vx_id]=i_0
         else # @i_trajectory_maximum_recording_length==0
            # Backtracking mechanisms need the trajectory max length to
            # be at least 1.
            kibuvits_krl171_throw("\n\n@i_trajectory_maximum_recording_length==0\n"+
            "GUID='a4628448-5729-4ae2-85e5-c2c2f051a4e7'\n\n")
         end # if
      end # if
   end # update_cahe_and_trajectory

   public

   # It will throw, if the location of the spider is not set.
   # The location of the spider can be set by using the
   # method reset(...).
   #
   # Spider implementations must oberride the method
   # choose_next_vertex_and_determine_whether_to_pause().
   #
   # Crawling is an activity, where spiders move from
   # vertex to vertex and read-write their own, spiderspecific and
   # crawling-session-specific or even crawling algorithm specific
   # records into vertices. It can be viewed as if the spiders
   # were leaving their own, personal, crawling-session specific,
   # siltk-trace behind and they take crawling decisions according
   # to the slik-traces that they find. The current implementation
   # does not erase the silktrace.
   def crawl
      if @ob_vx_location==nil
         kibuvits_krl171_throw("\n\nThe location of the spider has not bee set.\n"+
         "The location can be set by using the method reset(...)\n\n")
      end # if
      b_pause_crawling=false
      ob_next_vertex=nil
      @mx.synchronize do
         while !b_pause_crawling
            ob_vx_new_location, b_pause_crawling=choose_next_vertex_and_determine_whether_to_pause()
            if KIBUVITS_krl171_b_DEBUG
               # This verification block is here due to the fact that
               # the choose_next_vertex_and_determine_whether_to_pause() is overridden.
               bn=binding()
               kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_pause_crawling
               kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex, ob_vx_new_location
            end # if KIBUVITS_krl171_b_DEBUG
            update_cahe_and_trajectory(ob_vx_new_location)
         end # loop
      end # block
   end # crawl

end # Kibuvits_krl171_spider_t1

#--------------------------------------------------------------------------

# The acronym "oper" stands for "operations".
class Kibuvits_krl171_graph_oper_t1

   def initialize
   end # initialize

   #-----------------------------------------------------------------------

   # Creates a vertex, connects the new vertex to the ob_parent_vertex so
   # that the new vertex is an outbound vertex for the ob_parent_vertex.
   #
   # It's the operation that is used for counting the number of edges
   # in a tree of N nodes, i.e.
   #     http://urls.softf1.com/a1/krl/frag1/
   #
   # Returns the new leaf.
   def add_outbound_leaf_t1(ob_parent_vertex,b_thradsafe_leaf=true)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex,ob_parent_vertex
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass],b_thradsafe_leaf
      end # if KIBUVITS_krl171_b_DEBUG
      vx_leaf=Kibuvits_krl171_graph_vertex.new(b_thradsafe_leaf)
      ob_parent_vertex.connect_outbound_vertex(vx_leaf)
      return vx_leaf
   end # add_outbound_leaf_t1

   def Kibuvits_krl171_graph_oper_t1.add_outbound_leaf_t1(ob_parent_vertex,
      b_thradsafe_leaf=true)
      vx_leaf=Kibuvits_krl171_graph_oper_t1.instance.add_outbound_leaf_t1(
      ob_parent_vertex, b_thradsafe_leaf)
      return vx_leaf
   end # Kibuvits_krl171_graph_oper_t1.add_outbound_leaf_t1

   # Creates a vertex, connects the new vertex to the ob_parent_vertex so
   # that the new vertex is an inbound vertex for the ob_parent_vertex.
   #
   # It's the operation that is used for counting the number of edges
   # in a tree of N nodes, i.e.
   #     http://urls.softf1.com/a1/krl/frag1/
   #
   # Returns the new leaf.
   def add_inbound_leaf_t1(ob_parent_vertex,b_thradsafe_leaf=true)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_graph_vertex,ob_parent_vertex
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass],b_thradsafe_leaf
      end # if KIBUVITS_krl171_b_DEBUG
      vx_leaf=Kibuvits_krl171_graph_vertex.new(b_thradsafe_leaf)
      ob_parent_vertex.connect_inbound_vertex(vx_leaf)
      return vx_leaf
   end # add_inbound_leaf_t1

   def Kibuvits_krl171_graph_oper_t1.add_inbound_leaf_t1(ob_parent_vertex,
      b_thradsafe_leaf=true)
      vx_leaf=Kibuvits_krl171_graph_oper_t1.instance.add_inbound_leaf_t1(
      ob_parent_vertex, b_thradsafe_leaf)
      return vx_leaf
   end # Kibuvits_krl171_graph_oper_t1.add_inbound_leaf_t1

   #-----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_krl171_graph_oper_t1
#=====================kibuvits_krl171_graph_oper_t1_rb_end========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_graph_oper_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_fs_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_fs_rb_end".
#==========================================================================
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
#=========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/bonnet/kibuvits_krl171_os_codelets.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_io.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ProgFTE.rb"

# The "fileutils" gem/library MUST NOT BE USED, because
# it does not come precompiled with the Ruby distribution
# and its installation requires operating system specific
# compilation, which  prevents parts of the the KRL from running
# on Windows and JRuby. JRuby is necessary for using KRL
# form Java. The JRuby is used for running IDE addons/plugins
# and for using the KRL text processing routines for custom
# Java applications.

#==========================================================================

# The class Kibuvits_krl171_fs is a namespace for functions that
# deal with filesystem related activities, EXCEPT the IO, which
# is considered to be more general and depends on the filesystem.
class Kibuvits_krl171_fs
   @@cache=Hash.new
   def initialize
   end #initialize

   private

   def verify_access_create_flagset
      ht_out=Hash.new
      ht_out['exists']=false
      ht_out['does_not_exist']=false
      ht_out['is_directory']=false
      ht_out['is_file']=false
      ht_out['readable']=false
      ht_out['writable']=false
      ht_out['deletable']=false
      ht_out['executable']=false
      ht_out['not_readable']=false
      ht_out['not_writable']=false
      ht_out['not_deletable']=false
      ht_out['not_executable']=false
      return ht_out
   end # verify_access_create_flagset

   def verify_access_spec2ht s_checks_specification
      # It should not throw with command specifications of
      # ",,,writable", "writable,,readable",
      # "writable,readable,,,,", etc. On the other hand,
      # it must kibuvits_krl171_throw with a command specification of ",,,,,".
      s_1=s_checks_specification.gsub(/[\s]+/,$kibuvits_krl171_lc_emptystring)
      s_2=s_1.gsub(/[,]+/,$kibuvits_krl171_lc_comma).sub(/^[,]/,$kibuvits_krl171_lc_emptystring)
      s_1=s_2.sub(/[,]$/,$kibuvits_krl171_lc_emptystring)
      if s_1.length==0
         kibuvits_krl171_throw "\nThe Kibuvits_krl171_fs.verify_access did not "+
         " a valid checks specification. s_checks_specification=="+
         s_checks_specification+" \n"
      end # if

      ar=Kibuvits_krl171_str.ar_explode s_1, $kibuvits_krl171_lc_comma
      ar_cmds=[]
      ar.each{|s| ar_cmds<<Kibuvits_krl171_str.trim(s)}
      ht_out=verify_access_create_flagset
      ar_cmds.each do |s_cmd|
         if ht_out.has_key? s_cmd
            ht_out[s_cmd]=true
         else
            kibuvits_krl171_throw "The Kibuvits_krl171_fs.verify_access does not "+
            "have a command of \""+s_cmd+"\"."
         end # if
      end # loop
      if ht_out['exists']&&ht_out['does_not_exist']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"exists\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['is_directory']&&ht_out['is_file']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"is_directory\" and \"is_file\" contradict."
      end # if
      if ht_out['readable']&&ht_out['not_readable']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"readable\" and \"not_readable\" contradict."
      end # if
      if ht_out['writable']&&ht_out['not_writable']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"writable\" and \"not_writable\" contradict."
      end # if
      #----------------------------
      if ht_out['deletable']&&ht_out['not_deletable']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"deletable\" and \"not_deletable\" contradict."
      end # if
      if ht_out['deletable']&&ht_out['does_not_exist']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"deletable\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['deletable']&&ht_out['not_writable']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"deletable\" and \"not_writable\" contradict."
      end # if
      #----------------------------
      if ht_out['executable']&&ht_out['not_executable']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"executable\" and \"not_executable\" contradict."
      end # if
      #-----the-start-of-policy-based-conflict-checks--
      if ht_out['readable']&&ht_out['does_not_exist']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"readable\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['writable']&&ht_out['does_not_exist']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"writable\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['executable']&&ht_out['does_not_exist']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"executable\" and \"does_not_exist\" contradict."
      end # if
      #---------change-of-group--
      if ht_out['is_directory']&&ht_out['does_not_exist']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"is_directory\" and \"does_not_exist\" contradict."
      end # if
      if ht_out['does_not_exist']&&ht_out['is_file']
         kibuvits_krl171_throw "Kibuvits_krl171_fs.verify_access commands "+
         "\"does_not_exist\" and \"is_file\" contradict."
      end # if
      return ht_out
   end # verify_access_spec2ht

   def verify_access_register_failure(ht_out,s_file_path_candidate,
      s_command, msgc)
      ht_desc=Hash.new
      ht_desc['command']=s_command
      ht_desc['msgc']=msgc
      ar_of_ht_descs=nil
      if ht_out.has_key? s_file_path_candidate
         ar_of_ht_descs=ht_out[s_file_path_candidate]
      else
         ar_of_ht_descs=Array.new
         ht_out[s_file_path_candidate]=ar_of_ht_descs
      end # if
      ar_of_ht_descs<<ht_desc
   end # verify_access_register_failure


   # Edits the ht_out.
   def verify_access_verification_step(s_file_path_candidate,
      ht_cmds, ht_out)
      b_is_directory=nil;
      s_en=nil;
      s_ee=nil;
      $kibuvits_krl171_lc_mx_streamaccess.synchronize do
         if File.exists?(s_file_path_candidate)
            b_is_directory=File.directory?(s_file_path_candidate)
            s_en="File "
            s_ee="Fail "
            if b_is_directory
               s_en="Folder "
               s_ee="Kataloog "
            end # if
         end # if
         ht_cmds.each_pair do |s_cmd,b_value|
            if b_value
               if s_cmd=="not_deletable"
                  # It's possible to delete only files that exist.
                  # If a file or folder does not exist, then it is
                  # not deletable.
                  if File.exists?(s_file_path_candidate)
                     if File.writable?(s_file_path_candidate)
                        s_parent=Pathname.new(s_file_path_candidate).parent.to_s
                        # The idea is that it is not possible to
                        # to delete the root folder.
                        if (s_parent!=s_file_path_candidate)
                           if File.writable?(s_parent)
                              msgc=Kibuvits_krl171_msgc.new
                              msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                              s_file_path_candidate+"\"\nis deletable,"
                              msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                              s_file_path_candidate+"\"\non kustutatav."
                              verify_access_register_failure(
                              ht_out, s_file_path_candidate, s_cmd, msgc)
                              return
                           end # if
                        end # if
                     end # if File.writable?
                  end # if File.exists?
               end # if s_cmd
            end # if b_value
         end # loop

         b_existence_forbidden=ht_cmds['does_not_exist']
         if b_existence_forbidden
            if File.exists?(s_file_path_candidate)
               b_is_directory=File.directory?(s_file_path_candidate)
               msgc=Kibuvits_krl171_msgc.new
               s_en="File "
               s_en="Directory " if b_is_directory
               msgc[$kibuvits_krl171_lc_English]=s_en+"with a path of\n\""+s_file_path_candidate+
               "\"\nis required to be missing, but it exists."
               s_ee="Fail "
               s_ee="Kataloog " if b_is_directory
               msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \""+s_file_path_candidate+
               "\" eksisteerib, kuid nõutud on tema puudumine."
               verify_access_register_failure(ht_out,
               s_file_path_candidate, 'does_not_exist', msgc)
            end # if
            return
         end # if

         # It's not possible to check for writability
         # of files that do not exist, etc.
         b_existence_required=ht_cmds['exists']
         b_existence_required=b_existence_required||(ht_cmds['is_directory'])
         b_existence_required=b_existence_required||(ht_cmds['is_file'])
         b_existence_required=b_existence_required||(ht_cmds['readable'])
         b_existence_required=b_existence_required||(ht_cmds['writable'])
         b_existence_required=b_existence_required||(ht_cmds['deletable'])
         b_existence_required=b_existence_required||(ht_cmds['executable'])
         if b_existence_required
            if !File.exists?(s_file_path_candidate)
               msgc=Kibuvits_krl171_msgc.new
               msgc[$kibuvits_krl171_lc_English]="File or folder with a path of\n\""+
               s_file_path_candidate+"\"\ndoes not exist."
               msgc[$kibuvits_krl171_lc_Estonian]="Faili ega kataloogi rajaga \""+
               s_file_path_candidate+"\" ei eksisteeri."
               verify_access_register_failure(ht_out,
               s_file_path_candidate, 'exists', msgc)
               return
            end # if
         end # if
         if File.exists?(s_file_path_candidate)
            ht_cmds.each_pair do |s_cmd,b_value|
               if b_value
                  case s_cmd
                  when "is_directory"
                     if !b_is_directory
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]="\""+s_file_path_candidate+
                        "\" is a file, but a folder is required."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \""+s_file_path_candidate+
                        "\" on fail, kuid nõutud on kataloog."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "is_file"
                     if b_is_directory
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]="\""+s_file_path_candidate+
                        "\" is a folder, but a file is required."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \""+s_file_path_candidate+
                        "\" on kataloog, kuid nõutud on fail."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "readable"
                     if !File.readable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not readable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole loetav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "not_readable"
                     if File.readable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis readable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\non loetav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "writable"
                     if !File.writable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not writable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "not_writable"
                     if File.writable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis writable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\non kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "deletable"
                     # It's possible to delete only files that exist.
                     if !File.writable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not deletable, because it is not writable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole kustutatav, sest see ei ole kirjutatav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                     s_parent=Pathname.new(s_file_path_candidate).parent.to_s
                     if (s_parent!=s_file_path_candidate)
                        # It could be that the s_file_path_candidate equals with "/".
                        # The Pathname.new("/").parent.to_s=="/".
                        # The if-statement, that contains this comment,
                        # exists only to avoid a duplicate error message.
                        if !File.writable?(s_parent)
                           msgc=Kibuvits_krl171_msgc.new
                           msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                           s_file_path_candidate+"\"\nis not deletable, because its parent folder is not writable."
                           msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                           s_file_path_candidate+"\"\nei ole kustutatav, sest seda sisaldav kataloog ei ole kirjutatav."
                           verify_access_register_failure(
                           ht_out, s_file_path_candidate, s_cmd, msgc)
                        end # if
                     end # if
                  when "executable"
                     if !File.executable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis not executable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\nei ole jookstav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  when "not_executable"
                     if File.executable?(s_file_path_candidate)
                        msgc=Kibuvits_krl171_msgc.new
                        msgc[$kibuvits_krl171_lc_English]=s_en+"with the path of\n\""+
                        s_file_path_candidate+"\"\nis executable."
                        msgc[$kibuvits_krl171_lc_Estonian]=s_ee+" rajaga \n\""+
                        s_file_path_candidate+"\"\non jookstav."
                        verify_access_register_failure(
                        ht_out, s_file_path_candidate, s_cmd, msgc)
                     end # if
                  else
                  end # case
               end # if b_value
            end # loop
         end # if File.exists?(s_file_path_candidate)
      end # synchronize
   end # verify_access_verification_step


   public
   # The s_checks_specification is a commaseparated list of the following
   # flagstrings, but in a way that no conflicting flagstrings reside in
   # the list:
   #
   # exists, does_not_exist, is_directory, is_file,
   #     readable,     writable, executable,     deletable
   # not_readable, not_writable, not_executable
   #
   # An example of a conflicting set is "does_not_exist,writable", because
   # a non-existing file can not possibly be be writable. However,
   # a commandset of "exists,writable" is considered non-conflicting and
   # equivalent to a commandset of "writable", because a folder or a file
   # must exist to be writable.
   #
   # For the sake of helping the software developer to detect
   # logic mistakes, or just plain coding mistakes, a commandset
   # of "does_not_exist,not_readable" is considered to be conflicting, even
   # though it is not conflicting in the real world sense.
   #
   # The Kibuvits_krl171_fs.verify_access returns a hashtable. Schematic explanation
   # of the returnable hashtable:
   #
   # ht_filesystemtest_failures
   #   |
   #   +-1--n--    key: file path candidate
   #             value: ar
   #                    |
   #                    *--ht
   #                        |
   #                        +-key('command')-- <the Kibuvits_krl171_fs.verify_access check command>
   #                        +-key('msgc')-- <An instance of the Kibuvits_krl171_msgc with b_failure==true>
   #
   #
   # The keys of the hashtable are the file path
   # candidates, in which case at least one of the check commands
   # failed. The values of the hashtable are arrays of hashtables, where
   # ht['command']==<the Kibuvits_krl171_fs.verify_access check command>
   # ht['msgc']==<An instance of the Kibuvits_krl171_msgc>.
   # The b_failure flag of the msgc is set to true.
   #
   # If all verifications passed, the hashtable length==0.
   def verify_access(arry_of_file_paths_or_a_file_path_string,
      s_checks_specification,msgcs=Kibuvits_krl171_msgc_stack.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array,String], arry_of_file_paths_or_a_file_path_string
         kibuvits_krl171_typecheck bn, String, s_checks_specification
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ar_path_candidates=arry_of_file_paths_or_a_file_path_string
      if ar_path_candidates.class==String
         x=ar_path_candidates.length
         kibuvits_krl171_throw("String paths can not be empty strings.")if x==0
         ar_path_candidates=[ar_path_candidates]
      else
         ar_path_candidates.each do |s_file_path_candidate|
            x=s_file_path_candidate.length
            kibuvits_krl171_throw("String paths can not be empty strings.")if x==0
         end # loop
      end # if
      ht_cmds=verify_access_spec2ht(s_checks_specification)
      ht_filesystemtest_failures=Hash.new
      ar_path_candidates.each do |s_file_path_candidate|
         verify_access_verification_step(s_file_path_candidate,
         ht_cmds, ht_filesystemtest_failures)
      end # loop
      #-----------------
      msgc=nil
      ht_filesystemtest_failures.each_pair do |s_fp_candidate, ar_one_ht_per_failed_command|
         ar_one_ht_per_failed_command.each do |ht_failed_command|
            msgc=ht_failed_command["msgc"]
            msgcs << msgc
         end # loop
      end # loop
      return ht_filesystemtest_failures
   end # verify_access

   def Kibuvits_krl171_fs.verify_access(arry_of_file_paths_or_a_file_path_string,
      s_checks_specification,msgcs=Kibuvits_krl171_msgc_stack.new)
      ht_filesystemtest_failures=Kibuvits_krl171_fs.instance.verify_access(
      arry_of_file_paths_or_a_file_path_string,s_checks_specification,msgcs)
      return ht_filesystemtest_failures
   end # Kibuvits_krl171_fs.verify_access

   #-----------------------------------------------------------------------

   # The format of the ht_failures matches with the output of the
   # Kibuvits_krl171_fs.test_verify_access.
   def access_verification_results_to_string(ht_failures,
      s_language=$kibuvits_krl171_lc_English)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_failures
         kibuvits_krl171_typecheck bn, String, s_language
      end # if
      s_out=""
      if ht_failures.length==0
         case s_language
         when $kibuvits_krl171_lc_Estonian
            s_out="\nFailisüsteemiga seonduvad testid läbiti edukalt.\n"
         else
            s_out="\nFilesystem related verifications passed.\n"
         end # case
         return s_out
      end # if
      case s_language
      when $kibuvits_krl171_lc_Estonian
         s_out="\nVähemalt osad failisüsteemiga seonduvatest "+
         "testidest põrusid.\n"
      else
         s_out="\nAt least some of the filesystem related tests failed. \n"
      end # case
      ht_failures.each_value do |ar_failures|
         ar_failures.each do |ht_failure|
            s_out=s_out+"\n"+(ht_failure['msgc'])[s_language]+"\n"
         end #loop
      end #loop
      return s_out
   end # access_verification_results_to_string

   def Kibuvits_krl171_fs.access_verification_results_to_string(ht_failures,
      s_language=$kibuvits_krl171_lc_English)
      s_out=Kibuvits_krl171_fs.instance.access_verification_results_to_string(
      ht_failures, s_language)
      return s_out
   end # Kibuvits_krl171_fs.access_verification_results_to_string

   #-----------------------------------------------------------------------

   def exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language=$kibuvits_krl171_lc_English,
      b_throw=false,s_optional_error_message_suffix=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_filesystemtest_failures
         kibuvits_krl171_typecheck bn, String, s_output_message_language
      end # if
      return if ht_filesystemtest_failures.length==0
      s_msg=Kibuvits_krl171_fs.access_verification_results_to_string(
      ht_filesystemtest_failures, s_output_message_language)
      s_msg=s_msg+$kibuvits_krl171_lc_linebreak
      if s_optional_error_message_suffix!=nil
         s_msg=s_msg+$kibuvits_krl171_lc_linebreak+
         s_optional_error_message_suffix+$kibuvits_krl171_lc_linebreak
      end # if
      if b_throw
         kibuvits_krl171_throw(s_msg)
      else
         kibuvits_krl171_writeln s_msg
         exit
      end # if
   end # exit_if_any_of_the_filesystem_tests_failed

   def Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures,s_output_message_language=$kibuvits_krl171_lc_English,
      b_throw=false,s_optional_error_message_suffix=nil)
      Kibuvits_krl171_fs.instance.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures, s_output_message_language,b_throw,
      s_optional_error_message_suffix)
   end # Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed

   #-----------------------------------------------------------------------

   # This method will probably go through heavy refactoring.
   # It's probably wise to place it to a separate file, because
   # it's seldom needed and will probably take up relatively huge amount
   # of memory due to all of the information that is added about
   # the different file formats.
   def file_extension_2_file_type s_file_extension
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_extension
      end # if
      s_key='file_extension_2_file_type_ht_of_relations'
      ht_relations=nil
      if @@cache.has_key? s_key
         ht_relations=@@cache[s_key]
      else
         ht_relations=Hash.new
         ht_relations['rb']='Ruby'
         ht_relations['js']='JavaScript'
         ht_relations['exe']='Windows Executable'
         ht_relations['out']='Linux Executable'
         ht_relations['txt']='Text'
         ht_relations['h']='C Header'
         ht_relations['hpp']='C++ Header'
         ht_relations['c']='C Nonheader'
         ht_relations['cpp']='C++ Nonheader'
         ht_relations['dll']='Windows DLL'
         ht_relations['so']='Linux Binary Library'
         ht_relations['conf']='Configuration file'
         ht_relations['am']='GNU Automake Source'
         ht_relations['py']='Python'
         ht_relations['java']='Java'
         ht_relations['class']='Java Virtual Machine'
         ht_relations['scala']='Scala'
         ht_relations['hs']='Haskell'
         ht_relations['htm']='HTML'
         ht_relations['html']='HTML'
         ht_relations['php']='PHP'
         ht_relations['bat']='Windows Batch'
         ht_relations['xml']='XML'
         ht_relations['json']='JSON'
         ht_relations['yaml']='YAML'
         ht_relations['hdf']='Hierarchical data Format'# http://www.hdfgroup.org/
         ht_relations['hdf5']='Hierarchical data Format 5'
         ht_relations['hdf4']='Hierarchical data Format 4'
         ht_relations['script']='Acapella' # From PerkinElmer's Estonian/German department.
         ht_relations['css']='Cascading Style Sheet'
         ht_relations['jpeg']='Joint Photographic Experts Group'
         ht_relations['jpg']='Joint Photographic Experts Group'
         ht_relations['png']='Portable Network Graphics'
         ht_relations['bmp']='Windows Bitmap'
         ht_relations['ico']='Windows Icon'
         ht_relations['svg']='Scalable Vector Graphics'
         ht_relations['xcf']='GIMP Image'
         ht_relations['tar']='Tape Archive'
         ht_relations['gz']='GNU zip'
         ht_relations['tgz']='GNU zip Compressed tape Archive'
         # TODO: continue the list with bzip2, zip, pdf, doc,odf, etc.
         # This whole thing probably has to be refactored for
         # type classification, like document formats, compression
         # formats, image formats, software sources, binaries, etc.
      end # if
      s_out=$kibuvits_krl171_lc_undetermined
      if ht_relations.has_key? s_file_extension.downcase
         s_out=ht_relations[s_file_extension]
      end # if
      return s_out
   end # file_extension_2_file_type

   #-----------------------------------------------------------------------

   # An empty array corresponds to a path to the root, i.e. "/".
   #
   # If the s_force_ostype==nil, then the operating system
   # type, i.e. file paths style, is determined by OS detection.
   # Some of the possible s_operating_system_type values are
   # held by the globals $kibuvits_krl171_lc_kibuvits_krl171_ostype_unixlike and
   # $kibuvits_krl171_lc_kibuvits_krl171_ostype_windows
   def path2array s_path,s_operating_system_type=nil
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), String, s_path
      end # if
      ar=nil
      s_ostype=s_operating_system_type
      s_ostype=Kibuvits_krl171_os_codelets.get_os_type if s_ostype==nil
      case s_ostype
      when $kibuvits_krl171_lc_kibuvits_krl171_ostype_unixlike
         ar=Kibuvits_krl171_str.ar_explode(s_path,$kibuvits_krl171_lc_slash)
      when $kibuvits_krl171_lc_kibuvits_krl171_ostype_windows
         ar=Kibuvits_krl171_str.ar_explode(s_path,$kibuvits_krl171_lc_backslash)
      else
         kibuvits_krl171_throw("Ostype \""+s_ostype+
         "\" is not yet supported by this method.")
      end # case s_ostype

      # The explosion has side effects: "/x/" is converted to
      # ["","x",""]. The loop below is for compensating them.
      ar_out=Array.new
      i_len=ar.length
      i_max=i_len-1
      i_len.times do |i|
         if i==0
            ar_out<<ar[i] if ar[i]!=""
            next
         end # if
         if i==i_max
            ar_out<<ar[i] if ar[i]!=""
            break # might as well be "next"
         end # if
         if ar[i].length==0
            kibuvits_krl171_throw "Empty strings can not be file or "+
            "folder names."
         end # if
         ar_out<<ar[i]
      end # loop
      return ar_out
   end # path2array

   def Kibuvits_krl171_fs.path2array(s_path,s_operating_system_type=nil)
      ar_out=Kibuvits_krl171_fs.instance.path2array(s_path,s_operating_system_type)
      return ar_out
   end # Kibuvits_krl171_fs.path2array

   #-----------------------------------------------------------------------

   def array2path ar
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), Array, ar
      end # if
      s_p=Kibuvits_krl171_str.array2xseparated_list(ar,$kibuvits_krl171_lc_slash)
      # ["xx",""]      --> "xx/"
      # ["xx","","yy"] --> "xx//yy"
      s_tmp=s_p+$kibuvits_krl171_lc_slash # creates a double-slash from "/xx/".
      i1=s_tmp.length
      i2=s_tmp.gsub(/[\/]+/,$kibuvits_krl171_lc_slash).length
      if i1!=i2
         kibuvits_krl171_throw "Array contained an empty string, which violates "+
         "the array-encoded path specification. ar==["+
         $kibuvits_krl171_lc_slash+Kibuvits_krl171_str.array2xseparated_list(ar,", ")+"]."
      end # if
      # Due to a Ruby quirk the next line works also, if s_p==""
      s_p=$kibuvits_krl171_lc_slash+s_p if s_p[0..0]!="."
      return s_p
   end # array2path

   def Kibuvits_krl171_fs.array2path ar
      s_p=Kibuvits_krl171_fs.instance.array2path(ar)
      return s_p
   end # Kibuvits_krl171_fs.array2path

   #-----------------------------------------------------------------------

   private

   # The rgx_slash is fed in for speed, because this func is in a loop.
   def array2folders_verify_folder_name_candidate_t1 s_folder_name0, rgx_slash
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), String, s_folder_name0
      end # if
      if Kibuvits_krl171_str.str_contains_spacestabslinebreaks(s_folder_name0)
         kibuvits_krl171_throw "Folder name, '"+s_folder_name0+
         "', contained a space or a tab."
      end # if
      s_folder_name1=s_folder_name0.gsub(rgx_slash,$kibuvits_krl171_lc_emptystring)
      if s_folder_name0.length!=s_folder_name1.length
         kibuvits_krl171_throw "Folder name, '"+s_folder_name0+
         "', contained a slash. For the sake of unambiguity "+
         "the slashes are not allowed."
      end # if
      if s_folder_name1.length==0
         # For some reason the error message is something other than the one here.
         kibuvits_krl171_throw "Folder name is not allowed to be an empty string, "+
         " nor is it allowed to consist of only spaces and tabs."
      end # if
   end # array2folders_verify_folder_name_candidate_t1

   public

   # If s_path2folder=='/home/xxx'
   # and ar_folder_names==["aa","bb"]
   # then this method will be equivalent to:
   # "mkdir /home/xxx/aa;"
   # "mkdir /home/xxx/aa/bb;"
   def array2folders_sequential(s_path2folder,ar_folder_names)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String], s_path2folder
         kibuvits_krl171_typecheck bn, [Array], ar_folder_names
      end # if
      s_base_unix=s_path2folder
      ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(
      s_base_unix,"is_directory,writable")
      exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures)
      i_len=ar_folder_names.length
      s_folder_name0=nil
      s_folder_name1=nil
      s_left=s_base_unix.reverse.gsub(/^[\/]/,$kibuvits_krl171_lc_emptystring).reverse
      rgx_slash=/\//
      $kibuvits_krl171_lc_mx_streamaccess.synchronize do
         i_len.times do |i|
            s_folder_name0=ar_folder_names[i]
            array2folders_verify_folder_name_candidate_t1 s_folder_name0, rgx_slash
            s_left=s_left+$kibuvits_krl171_lc_slash+s_folder_name0
            s_folder_name1=s_left
            Dir.mkdir(s_folder_name1) if !File.exists? s_folder_name1
            ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(
            s_folder_name1,"is_directory,writable")
            exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures)
         end # loop
      end # synchronize
   end # array2folders_sequential

   def Kibuvits_krl171_fs.array2folders_sequential(s_path2folder,ar)
      Kibuvits_krl171_fs.instance.array2folders_sequential(s_path2folder,ar)
   end # Kibuvits_krl171_fs.array2folders_sequential

   #-----------------------------------------------------------------------

   # Reads in the files as strings and concatenates
   # them in the order as the file paths appear in the
   # ar_file_paths
   def s_concat_files(ar_file_paths)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array], ar_file_paths
         ar_file_paths.each do |s_file_path|
            bn=binding()
            kibuvits_krl171_typecheck bn, String, s_file_path
            ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(
            s_file_path,"is_file,readable")
            exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
            s_output_message_language=$kibuvits_krl171_lc_English,b_throw=false)
         end # loop
      end # if
      ar_s=Array.new
      ar_file_paths.each do |s_file_path|
         ar_s<<file2str(s_file_path)
      end # loop
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_out
   end # s_concat_files

   def Kibuvits_krl171_fs.s_concat_files(ar_file_paths)
      s_out=Kibuvits_krl171_fs.instance.s_concat_files(ar_file_paths)
      return s_out
   end # Kibuvits_krl171_fs.s_concat_files

   #-----------------------------------------------------------------------

   #
   # The idea is that if the process rights owner
   # is the owner of the file, then the result will be
   # 0700, but if the file has been made writable to
   # the group of the file owner and the chmod-er is
   # not the owner but someone from the group of the
   # owner, then the access rights would be 0770 and
   # if everybody has been given the right to write to
   # the file or folder, then the access rights would
   # be 0777.
   #
   # The motive behind such a graceful access rights
   # modification is that, if a folder with a lot of private
   # data were to be deleted, then the delete operation
   # can take considerable amount of time.
   # In that case the temporary chmod(0777) might reveal the
   # private data to users that otherwise would be
   # banned from accessing it.
   #
   # However, if the file or folder has the access rights of 0777 or 0770,
   # and the process access rights are that of the file owner's,
   # then it will not chmod the access rights to the 0700.
   # The rationale is that if a file or folder
   # has been made  to everyone, then there's no
   # point of denying access to it.
   #
   def chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array,String], ar_or_s_file_or_folder_path
      end # if
      ar_fp=Kibuvits_krl171_ix.normalize2array(ar_or_s_file_or_folder_path)
      $kibuvits_krl171_lc_mx_streamaccess.synchronize do
         ar_fp.each do |s_fp|
            if !File.exists? s_fp
               kibuvits_krl171_throw("The file or folder \n"+s_fp+
               "\ndoes not exist. GUID='202c23bf-b951-4bf3-93b5-c2c2f051a4e7'\n")
            end # if
            if (File.writable? s_fp)&&(File.readable? s_fp)&&(File.executable? s_fp)
               if File.directory? s_fp
                  ar=Dir.glob(s_fp+$kibuvits_krl171_lc_slashstar)
                  chmod_recursive_secure_7(ar)
               end # if
               return
            end # if
            # If the owner of the current process is not the
            # owner of the file and the file had previously
            # a permission of 0770, then "chmod 0700 filename"
            # would lock the user out.
            File.chmod(0777,s_fp) # access  must contain 4 digits, or a flaw is introduced
            if (File.writable? s_fp)&&(File.readable? s_fp)&&(File.executable? s_fp)
               if File.directory? s_fp
                  ar=Dir.glob(s_fp+$kibuvits_krl171_lc_slashstar)
                  chmod_recursive_secure_7(ar)
               end # if
               return
            end # if
            s_1="The file "
            s_1="The folder " if File.directory? s_fp
            kibuvits_krl171_throw(s_1+",\n"+s_fp+
            "\nexists, but its access rights could not be changed to 7 for \n"+
            "the owner of the current process. GUID='56bc3523-7390-4dc5-a185-c2c2f051a4e7'")
         end # loop
      end # synchronize
   end # chmod_recursive_secure_7

   def Kibuvits_krl171_fs.chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
      Kibuvits_krl171_fs.instance.chmod_recursive_secure_7(ar_or_s_file_or_folder_path)
   end # Kibuvits_krl171_fs.chmod_recursive_secure_7

   #-----------------------------------------------------------------------

   private

   def impl_rm_fr_part_1(ar_or_s_file_or_folder_path)
      ar_paths_in=Kibuvits_krl171_ix.normalize2array(ar_or_s_file_or_folder_path)
      ar_paths_in.each do |s_fp|
         if File.directory? s_fp
            ar=Dir.glob(s_fp+$kibuvits_krl171_lc_slashstar)
            impl_rm_fr_part_1(ar)
            Dir.rmdir(s_fp)
         else
            File.delete(s_fp)
         end # if
         if File.exists? s_fp
            s_1="file\n"
            s_1="folder\n" if File.directory? s_fp
            kibuvits_krl171_throw("There exists some sort of a flaw, because the "+s_1+"\n"+s_fp+
            "\ncould not be deleted despite the fact that recursive chmod-ding \n"+
            "takes, or at least should take, place before the recursive deletion.\n"+
            "GUID='c1d90d5d-0587-4535-8355-c2c2f051a4e7'\n")
         end # if
      end # loop
   end # impl_rm_fr_part_1

   public
   # The same as the classical
   # rm -fr folder_or_file_path
   #
   # If the root folder or file is not
   # deletable, it throws, but if the folder
   # is deletable, it will override the file
   # access permissions of the folder content.
   #
   # the root folder or file is considered not deletable,
   # if its parent folder is not writable.
   #
   # It does not throw, if the root folder or file
   # does not exist, regardless of  the parent
   # folder of the root folder or file exists or is writable.
   def rm_fr(ar_or_s_file_or_folder_path)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Array], ar_or_s_file_or_folder_path
         if ar_or_s_file_or_folder_path.class==Array
            ar_or_s_file_or_folder_path.each do |x_path_candidate|
               bn=binding()
               kibuvits_krl171_typecheck bn, String,x_path_candidate
            end # loop
         end # if
      end # if
      ar_paths_in=Kibuvits_krl171_ix.normalize2array(ar_or_s_file_or_folder_path)
      ob_pth=nil
      s_parent_path=nil
      $kibuvits_krl171_lc_mx_streamaccess.synchronize do
         ar_paths_in.each do |s_file_or_folder_path|
            next if !File.exists? s_file_or_folder_path
            ob_pth=Pathname.new(s_file_or_folder_path)
            s_parent_path=ob_pth.dirname.to_s
            # Here the (File.exists? s_parent_path)==true
            # because every existing file or folder that
            # is not the "/"  has an existing parent
            # and the Pathname.new("/").to_s=="/"
            if !File.writable? s_parent_path
               kibuvits_krl171_throw("Folder \n"+s_parent_path+
               "\nis not writable. GUID='212fea5b-6f12-426f-8325-c2c2f051a4e7'\n")
            end # if
            s_fp=s_file_or_folder_path
            chmod_recursive_secure_7(s_fp) # throws, if the chmod-ding fails
            impl_rm_fr_part_1(s_file_or_folder_path)
         end # loop
      end # synchronize
   end # rm_fr

   def Kibuvits_krl171_fs.rm_fr(ar_or_s_file_or_folder_path)
      Kibuvits_krl171_fs.instance.rm_fr(ar_or_s_file_or_folder_path)
   end # Kibuvits_krl171_fs.rm_fr

   #----------------------------------------------------------------------
   def b_not_suitable_to_be_a_file_path_t1(s_path_candidate,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String,s_path_candidate
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack,msgcs
      end # if
      i_0=s_path_candidate.length
      s_1=s_path_candidate.gsub(/[\n\r]/,$kibuvits_krl171_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", but file paths are not allowed to contain line breaks.\n"
         s_message_id="1"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei saa sisaldada reavahetusi.\n"
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_default_msg
         return true
      end # if
      s_1=s_path_candidate.gsub(/^[\t\s]/,$kibuvits_krl171_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", but file paths are not allowed to start with spaces or tabs.\n"
         s_message_id="2"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei saa alata tühikute ning tabulatsioonimärkidega.\n"
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_default_msg
         return true
      end # if
      s_1=s_path_candidate.gsub(/[\t\s]$/,$kibuvits_krl171_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", but file paths are not allowed to end with spaces or tabs.\n"
         s_message_id="3"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei saa lõppeda tühikute ning tabulatsioonimärkidega.\n"
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_default_msg
         return true
      end # if
      # In Linux "//hi////there///" is equivalent to "/hi/there/ and hence legal.
      # The "/////////////////" is equivalent to "/" and hence also legal.
      s_1=s_path_candidate.gsub(/(^[.]{3})|([\/][.]{3})/,$kibuvits_krl171_lc_emptystring)
      i_1=s_1.length
      if i_0!=i_1
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\",\n but file paths are not allowed to contain three "+
         "sequential dots at the \nstart of the path or right after a slash.\n"
         s_message_id="4"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         s_default_msg="\ns_path_candidate==\""+s_path_candidate+
         "\", kuid failirajad ei või sisaldada kolme järjestikust punkti .\n"+
         "failiraja alguses või vahetult pärast kaldkriipsu.\n"
         msgcs.last[$kibuvits_krl171_lc_Estonian]=s_default_msg
         return true
      end # if
      return false
   end # b_not_suitable_to_be_a_file_path_t1

   def Kibuvits_krl171_fs.b_not_suitable_to_be_a_file_path_t1(s_path_candidate,msgcs)
      b_out=Kibuvits_krl171_fs.instance.b_not_suitable_to_be_a_file_path_t1(
      s_path_candidate,msgcs)
      return b_out
   end # Kibuvits_krl171_fs.b_not_suitable_to_be_a_file_path_t1

   #----------------------------------------------------------------------

   # It only works with Linux paths and it does not check for
   # file/folder existence, i.e. its output is derived by
   # performing string operations.
   # def s_normalize_path_t1(s_path_candidate,msgcs)
   # if KIBUVITS_krl171_b_DEBUG
   # bn=binding()
   # kibuvits_krl171_typecheck bn, String,s_path_candidate
   # kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack,msgcs
   # end # if
   # TODO: complete it
   # end # s_normalize_path_t1
   # def Kibuvits_krl171_fs.s_normalize_path_t1(s_path_candidate,msgcs)
   # end # Kibuvits_krl171_fs.s_normalize_path_t1

   #----------------------------------------------------------------------
   private

   def b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_of_strings,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Array,ar_of_strings
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack,msgcs
      end # if
      ar_of_strings.each do |x_candidate|
         if b_not_suitable_to_be_a_file_path_t1(x_candidate,msgcs)
            s_default_msg="\n\""+x_candidate.to_s+
            "\",\n is not considered to be suitable for a "+
            "file or folder base name. \n"+
            "GUID='83947726-97d4-4b82-81f4-c2c2f051a4e7'\n\n"
            #s_message_id="throw_1"
            #b_failure=false
            #msgcs.cre(s_default_msg,s_message_id,b_failure)
            #msgcs.last[$kibuvits_krl171_lc_Estonian]="\n"+x_candidate.to_s+
            #", omab väärtust, mis ei sobi faili nimeks.\n"
            kibuvits_krl171_throw(s_default_msg)
         end # if
         # Control flow will reach here only, if the
         # x_candidate.length!=0. Points are legal in file names
         # like "awesome.txt"
         #    i_0=x_candidate.length
         #    s_1=x_candidate.gsub(/[\\\/]/,$kibuvits_krl171_lc_emptystring)
         #    i_1=s_1.length
         #    if  i_0!=i_1
         #    s_default_msg="\n\""+x_candidate.to_s+
         #    "\",\n is not considered to be suitable for a "+
         #    "file or folder base name. \n"+
         #    "GUID='4fbe0adc-8aaa-4869-84c4-c2c2f051a4e7'\n\n"
         #s_message_id="throw_1"
         #b_failure=false
         #msgcs.cre(s_default_msg,s_message_id,b_failure)
         #msgcs.last[$kibuvits_krl171_lc_Estonian]="\n"+x_candidate.to_s+
         #", omab väärtust, mis ei sobi faili nimeks.\n"
         #    kibuvits_krl171_throw(s_default_msg)
         #    end # if
      end # loop
   end # b_env_not_set_or_has_improper_path_t1_exc_verif1

   def b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
      s_environment_variable_name,s_env_value,s_path,msgcs)
      b_missing=false
      $kibuvits_krl171_lc_mx_streamaccess.synchronize do
         if !File.exists? s_path
            s_default_msg="\nThe environment variable, "+
            s_environment_variable_name+"==\""+s_env_value+
            "\",\n has a wrong value, because a file or a folder "+
            "with the path of \n"+s_path+"\n does not esist.\n"
            s_message_id="4"
            b_failure=false
            msgcs.cre(s_default_msg,s_message_id,b_failure)
            msgcs.last[$kibuvits_krl171_lc_Estonian]="\nKeskkonnamuutuja, "+
            s_environment_variable_name+"==\""+s_env_value+
            "\"\n, omab vale väärtust, sest faili ega kataloogi rajaga\n"+
            s_path+"\n ei eksisteeri.\n"
            b_missing=true
         end # if
      end # synchronize
      return b_missing
   end # b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist


   public

   # The  variable that is referenced by the
   # s_environment_variable_name is tested to have a value of a
   # full path to an existing folder or a file.
   #
   # If the environment variable references a file, then
   # the files and folders that are listed in the
   # s_or_ar_file_names  and the s_or_ar_folder_names
   # are searched from the same folder that contains the file.
   #
   # If the environment variable references a folder, then
   # the files and folders that are listed in the
   # s_or_ar_file_names  and the s_or_ar_folder_names
   # are searched from the folder that is referenced by the
   # environment variable.
   #
   # If the s_or_ar_file_names and/or the s_or_ar_folder_names differ
   # from an empty array, then they are expected to depict either basenames or
   # relative paths relative to the folder that is searched.
   #
   # If "true" is returned, then a Kibuvits_krl171_msgc instance is added to
   # the msgcs. The Kibuvits_krl171_msgc instance has its b_failure value set to "false".
   def b_env_not_set_or_has_improper_path_t1(s_environment_variable_name,
      msgcs=Kibuvits_krl171_msgc_stack.new,
      s_or_ar_file_names=$kibuvits_krl171_lc_emptyarray,
      s_or_ar_folder_names=$kibuvits_krl171_lc_emptyarray)
      bn=binding() # Is in use also outside of the DEBUG block.
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String,s_environment_variable_name
         kibuvits_krl171_typecheck bn, [Array,String],s_or_ar_file_names
         kibuvits_krl171_typecheck bn, [Array,String],s_or_ar_folder_names
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack,msgcs
         if s_or_ar_file_names.class==Array
            ar=s_or_ar_file_names
            ar.each do |x_candidate|
               bn_1=binding()
               kibuvits_krl171_typecheck bn_1, String,x_candidate
            end # loop
         end # if
         if s_or_ar_folder_names.class==Array
            ar=s_or_ar_folder_names
            ar.each do |x_candidate|
               bn_1=binding()
               kibuvits_krl171_typecheck bn_1, String,x_candidate
            end # loop
         end # if
      end # if KIBUVITS_krl171_b_DEBUG
      s_or_ar_file_names=[] if s_or_ar_file_names.class==NilClass
      s_or_ar_folder_names=[] if s_or_ar_file_names.class==NilClass
      ar_file_names=Kibuvits_krl171_ix.normalize2array(s_or_ar_file_names)
      ar_folder_names=Kibuvits_krl171_ix.normalize2array(s_or_ar_folder_names)

      kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_environment_variable_name)
      x_env_value=ENV[s_environment_variable_name]
      if (x_env_value==nil)||(x_env_value==$kibuvits_krl171_lc_emptystring)
         s_default_msg="\nThe environment variable, "+s_environment_variable_name+
         ", does not exist or it has an empty string as its value.\n"
         s_message_id="1"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         msgcs.last[$kibuvits_krl171_lc_Estonian]="\nKeskkonnamuutuja, "+s_environment_variable_name+
         ", ei eksisteeri või talle on omistatud väärtuseks tühi sõne.\n"
         return true
      end # if
      if b_not_suitable_to_be_a_file_path_t1(x_env_value,msgcs)
         s_default_msg="\nThe environment variable, "+s_environment_variable_name+
         ", does not have a value that \nis considered to be "+
         "suitable to be a file path.\n"
         s_message_id="2"
         b_failure=false
         msgcs.cre(s_default_msg,s_message_id,b_failure)
         msgcs.last[$kibuvits_krl171_lc_Estonian]="\nKeskkonnamuutuja, "+s_environment_variable_name+
         ", omab väärtust, mis ei sobi faili rajaks.\n"
         return true
      end # if
      b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_file_names,msgcs)
      b_env_not_set_or_has_improper_path_t1_exc_verif1(ar_folder_names,msgcs)
      s_env_value=x_env_value
      $kibuvits_krl171_lc_mx_streamaccess.synchronize do
         if !File.exists? s_env_value
            s_default_msg="\nThe file or folder that the environment variable, "+
            s_environment_variable_name+", references does not exist.\n"
            s_message_id="3"
            b_failure=false
            msgcs.cre(s_default_msg,s_message_id,b_failure)
            msgcs.last[$kibuvits_krl171_lc_Estonian]="\nKeskkonnamuutuja, "+s_environment_variable_name+
            ", poolt viidatud fail või kataloog ei eksisteeri.\n"
            return true
         end # if
         rgx_multislash=/[\/]+/
         s_folder_path_1=s_env_value.gsub(rgx_multislash,$kibuvits_krl171_lc_slash)
         if s_folder_path_1!=$kibuvits_krl171_lc_slash
            if File.file?(s_env_value)
               ob_fp=Pathname.new(s_env_value).realpath.parent
               s_folder_path_1=ob_fp.to_s
            end # if
         end # if
         s_folder_path_1=(s_folder_path_1+"/").gsub(rgx_multislash,$kibuvits_krl171_lc_slash)
         s_path=nil
         b_0=nil
         ar_file_names.each do |s_basename|
            # TODO:  filter the s_path through Kibuvits_krl171_fs.s_normalize_path_t1
            s_path=s_folder_path_1+s_basename
            b_0=b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
            s_environment_variable_name,s_env_value,s_path,msgcs)
            return true if b_0
            if !File.file? s_path
               s_default_msg="\nThe environment variable, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\",\n is suspected to have a wrong value, because "+
               "a file with the path of \n"+s_path+
               "\n does not esist, but a folder with the same path does exist.\n"
               s_message_id="5"
               b_failure=false
               msgcs.cre(s_default_msg,s_message_id,b_failure)
               msgcs.last[$kibuvits_krl171_lc_Estonian]="\nKeskkonnamuutuja, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\"\n, korral kahtlustatakse vale väärtust, sest faili rajaga\n"+
               s_path+"\n ei eksisteeri, kuid sama rajaga kataloog eksisteerib.\n"
               return true
            end # if
         end # loop
         ar_folder_names.each do |s_basename|
            s_path=s_folder_path_1+s_basename
            # TODO:  filter the s_path through Kibuvits_krl171_fs.s_normalize_path_t1
            b_0=b_env_not_set_or_has_improper_path_t1_fileorfolderDOESNOTexist(
            s_environment_variable_name,s_env_value,s_path,msgcs)
            return true if b_0
            if File.file? s_path
               s_default_msg="\nThe environment variable, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\",\n is suspected to have a wrong value, because "+
               "a folder with the path of \n"+s_path+
               "\n does not esist, but a file with the same path does exist.\n"
               s_message_id="6"
               b_failure=false
               msgcs.cre(s_default_msg,s_message_id,b_failure)
               msgcs.last[$kibuvits_krl171_lc_Estonian]="\nKeskkonnamuutuja, "+
               s_environment_variable_name+"==\""+s_env_value+
               "\"\n, korral kahtlustatakse vale väärtust, sest kataloogi rajaga\n"+
               s_path+"\n ei eksisteeri, kuid sama rajaga fail eksisteerib.\n"
               return true
            end # if
         end # loop
      end # synchronize
      return false
   end # b_env_not_set_or_has_improper_path_t1

   def Kibuvits_krl171_fs.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name, msgcs=Kibuvits_krl171_msgc_stack.new,
      s_or_ar_file_names=$kibuvits_krl171_lc_emptyarray,
      s_or_ar_folder_names=$kibuvits_krl171_lc_emptyarray)
      b_out=Kibuvits_krl171_fs.instance.b_env_not_set_or_has_improper_path_t1(
      s_environment_variable_name,msgcs,s_or_ar_file_names,s_or_ar_folder_names )
      return b_out
   end # Kibuvits_krl171_fs.b_env_not_set_or_has_improper_path_t1

   #----------------------------------------------------------------------

   private

   def exc_ar_glob_x_verifications_t1(bn,
      ar_or_s_fp_directory,ar_or_s_glob_string,b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      kibuvits_krl171_typecheck bn, [String,Array], ar_or_s_fp_directory
      kibuvits_krl171_typecheck bn, [String,Array], ar_or_s_glob_string
      kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_return_long_paths
      kibuvits_krl171_typecheck bn, [String,Array,Proc], ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
      kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_return_globbing_results

      if ar_or_s_fp_directory.class==Array
         ar_or_s_fp_directory.each do |s_fp_folder|
            kibuvits_krl171_assert_string_min_length(bn,s_fp_folder,1)
         end # loop
      else
         kibuvits_krl171_assert_string_min_length(bn,ar_or_s_fp_directory,1)
      end # if

      if ar_or_s_glob_string.class==Array
         ar_or_s_glob_string.each do |s_globstring|
            kibuvits_krl171_assert_string_min_length(bn,s_globstring,1)
         end # loop
      else
         kibuvits_krl171_assert_string_min_length(bn,ar_or_s_glob_string,1)
      end # if

      cl_0=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class
      if cl_0==Array
         ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.each do |s_fp_folder|
            kibuvits_krl171_assert_string_min_length(bn,s_fp_folder,1)
         end # loop
      else
         if cl_0==String
            kibuvits_krl171_assert_string_min_length(bn,
            ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,1)
         else
            if cl_0==Proc
               func_0=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
               ar_params=func_0.parameters
               i_ar_params_len=ar_params.size
               if i_ar_params_len!=1
                  kibuvits_krl171_throw("The "+
                  "ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function \n"+
                  "is of class "+cl_0.to_s+
                  "and the number of its parameters == "+i_ar_params_len.to_s+", but \n"+
                  "it is required to have exactly 1 parameter that is "+
                  "of type String and depicts a full path of a file or a folder.\n"+
                  "GUID='2baa642a-e7ef-48c3-a194-c2c2f051a4e7'\n")
               end # if
               ar_paramdesc=ar_params[0]
               if ar_paramdesc[0]!=:req
                  kibuvits_krl171_throw("The first parameter of the function that "+
                  "is referenced by the \n"+
                  "ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function \n"+
                  "is expected to be parameter that does not have a default value.\n"+
                  "GUID='0bafb038-23f9-4196-8564-c2c2f051a4e7'\n")
               end # if
            else
               kibuvits_krl171_throw("The code of this function is faulty. \n"+
               "The previous typechecks "+
               "should have thrown before the control flow reaches this line.\n"+
               "ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class == "+
               cl_0.to_s+$kibuvits_krl171_lc_linebreak+
               "GUID='5531ab34-fa37-445a-8334-c2c2f051a4e7'\n")
            end # if
         end # if
      end # if
   end # exc_ar_glob_x_verifications_t1

   public

   # Folder paths have to be full paths.
   # Throws, if the folder does not exist or is not readable.
   #
   # It temporarily changes the working directory to the s_fp_directory.
   #
   # If the
   #
   #     ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
   #
   # is a function, e.g. of class Proc, then it must accept exactly one
   # parameter that is a full path of a file or a folder.
   # The function must return false, except if the file or folder
   # is expected to be excluded from the output of the
   # ar_glob_locally_t1. In pseudocode:
   #
   #     b_ignore_file_or_folder=func_return_true_if_ignored.call(s_fp)
   #
   # The "b_ignore_file_or_folder" must be either of class TrueType or
   # class FalseType.
   #
   # The path that is fed to the "func_return_true_if_ignored" might
   # point to a nonexistent file or folder. It's up to the
   # implementer of the "func_return_true_if_ignored" to decide,
   # whether it modifies or deletes an existing file or folder
   # or creates a new instance of a nonexistent file or folder.
   # The "func_return_true_if_ignored" might receive the
   # same file or folder path more than once during a
   # single call to the ar_glob_locally_t1.
   #
   # Paths that point to a nonexistent file or folder right
   # after a call to the "func_return_true_if_ignored"
   # are omitted from the output of the ar_glob_locally_t1.
   # Root folders, the the content of the ar_or_s_fp_directory,
   # are not added to the output regardless of the
   # value of the "func_return_true_if_ignored".
   #
   # If the "func_return_true_if_ignored" returns "false" on a folder,
   # then that folder is not descended into. The
   # "func_return_true_if_ignored" might be used for carrying out
   # application specific operations with the paths that the
   # "func_return_true_if_ignored" got called with.
   #
   # The
   #
   #     b_return_globbing_results
   #
   # makes it possible to iterate over the elements that are
   # selected by the ar_or_s_glob_string without allocating
   # memory for returning a list of the file/folder paths.
   def ar_glob_locally_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      #-----------------
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         exc_ar_glob_x_verifications_t1(bn,ar_or_s_fp_directory,
         ar_or_s_glob_string,b_return_long_paths,
         ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
         b_return_globbing_results)
         #--------------------
         ar_globstrings=Kibuvits_krl171_ix.normalize2array(ar_or_s_glob_string)
         rgx_0=/^ +/
         rgx_1=/^[\/][*]?/
         rgx_2=/^[\s\t\n\r]+/
         s_0=nil
         s_1=nil
         i_len_0=nil
         i_len_1=nil
         ar_globstrings.each do |s_globstring|
            s_0=s_globstring.gsub(rgx_0,$kibuvits_krl171_lc_emptystring)
            i_len_0=s_0.length
            if s_globstring.gsub(rgx_2,$kibuvits_krl171_lc_emptystring).length==0
               kibuvits_krl171_throw("There's a flaw.\n"+
               "s_globstring consists of only spaces or tabs or line breaks.\n"+
               "GUID='592607e1-740b-4f5d-8304-c2c2f051a4e7'\n")
            end # if
            s_1=s_0.gsub(rgx_1,$kibuvits_krl171_lc_emptystring)
            i_len_1=s_1.length
            if i_len_1!=i_len_0
               kibuvits_krl171_throw("There's a flaw.\n"+
               " s_globstring==\""+s_globstring+"\", but if it \n"+
               "is fed to the Dir.glob(...), then it globs the root folder. \n"+
               "GUID='95e56d47-0481-4dbc-92d3-c2c2f051a4e7'\n")
            end # if
         end # loop
      end # if
      #----------------
      ar_fp_folder=Kibuvits_krl171_ix.normalize2array(ar_or_s_fp_directory)
      ar_globstrings=Kibuvits_krl171_ix.normalize2array(ar_or_s_glob_string)
      #----------------
      func_b_ignore=nil
      ar_fp_ignorables=nil
      b_ignore_by_func=false
      b_ignore_by_func=true if ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function.class==Proc
      if b_ignore_by_func
         func_b_ignore=ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function
      else
         ar_fp_ignorables=Kibuvits_krl171_ix.normalize2array(
         ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function)
      end # if
      #----------------
      ht_test_failures=verify_access(ar_fp_folder,"readable,is_directory")
      s_output_message_language=$kibuvits_krl171_lc_English
      b_throw=true
      exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw)
      #----------------
      ar_out=Array.new
      s_fp_wd_orig=Dir.getwd
      begin
         ar_1=nil
         ar_2=Array.new
         s_fp_0=$kibuvits_krl171_lc_emptystring
         s_fp_1=$kibuvits_krl171_lc_emptystring
         rgx_slashplus=/[\/]+/ # can't cache due to threading
         b_ignore_file_or_folder=nil
         ar_speedhack_1=[]
         ar_fp_folder.each do |s_fp_folder|
            if b_ignore_by_func
               # This call to the func_b_ignore(...) might delete the
               # s_fp_folder or change its content regardless of
               # whether the s_fp_folder points to a file or a folder.
               b_ignore_file_or_folder=func_b_ignore.call(s_fp_folder)
               next if !File.exist? s_fp_folder
            else
               b_ignore_file_or_folder=Kibuvits_krl171_str.b_has_prefix(
               ar_fp_ignorables, s_fp_folder, ar_speedhack_1)
            end # if
            next if b_ignore_file_or_folder
            #-------
            s_fp_0=s_fp_folder+$kibuvits_krl171_lc_slash
            Dir.chdir(s_fp_wd_orig) # should there be some mess with relative paths
            Dir.chdir(s_fp_folder)  # at this line
            # A glob string can be "/*", which might
            # be interpreted as the root folder.
            ar_globstrings.each do |s_globstring|
               ar_1=Dir.glob(s_globstring)
               # Separate loops are used to
               # place some if-clauses outside of a loop.
               if b_return_long_paths
                  if b_ignore_by_func
                     ar_1.each do |s_fname|
                        s_fp_1=(s_fp_0+s_fname).gsub(rgx_slashplus,$kibuvits_krl171_lc_slash)
                        # This call to the func_b_ignore(...) might delete the
                        # s_fname or change its content regardless of
                        # whether the s_fname points to a file or a folder.
                        b_ignore_file_or_folder=func_b_ignore.call(s_fp_1)
                        next if !File.exist? s_fname
                        next if b_ignore_file_or_folder
                        ar_2<<s_fp_1 if b_return_globbing_results
                     end # loop
                  else # ignore by array
                     ar_1.each do |s_fname|
                        s_fp_1=(s_fp_0+s_fname).gsub(rgx_slashplus,$kibuvits_krl171_lc_slash)
                        b_ignore_file_or_folder=Kibuvits_krl171_str.b_has_prefix(
                        ar_fp_ignorables, s_fp_1, ar_speedhack_1)
                        next if b_ignore_file_or_folder
                        ar_2<<s_fp_1 if b_return_globbing_results
                     end # loop
                  end # if
               else # relative paths
                  if b_ignore_by_func
                     ar_1.each do |s_fname|
                        s_fp_1=(s_fp_0+s_fname).gsub(rgx_slashplus,$kibuvits_krl171_lc_slash)
                        # This call to the func_b_ignore(...) might delete the
                        # s_fname or change its content regardless of
                        # whether the s_fname points to a file or a folder.
                        b_ignore_file_or_folder=func_b_ignore.call(s_fp_1)
                        next if !File.exist? s_fname
                        next if b_ignore_file_or_folder
                        ar_2<<s_fname if b_return_globbing_results
                     end # loop
                  else # ignore by array
                     ar_1.each do |s_fname|
                        b_ignore_file_or_folder=Kibuvits_krl171_str.b_has_prefix(
                        ar_fp_ignorables, s_fname, ar_speedhack_1)
                        next if b_ignore_file_or_folder
                        ar_2<<s_fname if b_return_globbing_results
                     end # loop
                  end # if
               end # if
               ar_out.concat(ar_2)
               ar_2.clear
            end # loop
         end # loop
         Dir.chdir(s_fp_wd_orig)
      rescue Exception => e
         # The idea is that may be the
         # client code catches the exception
         # and does something stupid that
         # is harmless only, if the working
         # directory has not been altered.
         Dir.chdir(s_fp_wd_orig)
         kibuvits_krl171_throw(e)
      end # rescue
      return ar_out
   end # ar_glob_locally_t1


   def Kibuvits_krl171_fs.ar_glob_locally_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths=true,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function=[],
      b_return_globbing_results=true)
      ar_out=Kibuvits_krl171_fs.instance.ar_glob_locally_t1(ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      return ar_out
   end # Kibuvits_krl171_fs.ar_glob_locally_t1

   #----------------------------------------------------------------------

   private

   def exc_ar_glob_recursively_t1_input_verification(bn,
      ar_or_s_fp_directory,ar_or_s_glob_string,
      regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
      b_return_long_paths, ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      #-------------
      exc_ar_glob_x_verifications_t1(bn,ar_or_s_fp_directory,
      ar_or_s_glob_string,b_return_long_paths,
      ar_or_s_path_prefixes_of_ignorable_folders_and_files_or_a_function,
      b_return_globbing_results)
      #----
      # The filter-regex is not verified within the
      # exc_ar_glob_x_verifications_t1, because
      # it is specific to the recursive version of
      # the glob function. If the ar_glob_locally_t1(...)
      # receives a single root folder for globbing, it
      # allocates space for everything anyways and the
      # filter parameter is not added to the
      # ar_glob_locally_t1(...) to keep the ar_glob_locally_t1(...)
      # API simpler. It's an intentional tradeoff, where
      # simplicity is preferred to the special-case speed increase.
      kibuvits_krl171_typecheck bn, [Regexp,Array,Proc],regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output
      cl=regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output.class
      if cl==Array
         kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,Proc,
         regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output,
         "GUID='1d06cf25-bb5e-48d4-8da3-c2c2f051a4e7'")
      else
         if cl==Proc
            x_0=regex_or_ar_of_regex_or_func_that_returns_true_on_paths_that_will_be_part_of_output.call(
            $kibuvits_krl171_lc_linebreak)
            bn_1=binding()
            kibuvits_krl171_typecheck bn_1, [TrueClass,FalseClass],x_0
         end # if
      end # if
      s_output_message_language=$kibuvits_krl171_lc_English
      b_throw=true
      s_optional_error_message_suffix="GUID='1546b24a-05b1-4c25-8563-c2c2f051a4e7'"
      ht_test_failures=verify_access(ar_or_s_fp_directory,"readable,is_directory")
      exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw,s_optional_error_message_suffix)
   end # exc_ar_glob_recursively_t1_input_verification

   public

   #----------------------------------------------------------------------

   # Searches all folders listed in the ar_or_s_fp_directory.
   # Only the file paths that have a match with at least one of the
   # regexes are included at the output.
   def ar_glob_recursively_t2(ar_or_s_fp_directory,ar_or_rgx_file_path_regexes)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array,String],ar_or_s_fp_directory
         kibuvits_krl171_typecheck bn, [Array,Regexp],ar_or_rgx_file_path_regexes
         kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,Regexp,
         ar_or_s_fp_directory,
         "GUID='75b4ad41-ead0-4f6a-b533-c2c2f051a4e7'\n")
         if ar_or_s_fp_directory.class==Array
            ar_fp_root_folder_candidates=ar_or_s_fp_directory
            ht_failures=verify_access(ar_fp_root_folder_candidates,"is_directory,readable")
            #----
            s_output_message_language=$kibuvits_krl171_lc_English,
            b_throw=true,
            exit_if_any_of_the_filesystem_tests_failed(
            ht_failures,s_output_message_language,b_throw,
            "GUID='19adf094-dce4-4d87-b403-c2c2f051a4e7'\n")
         end # if
      end # if
      ar_fp_root_folders=Kibuvits_krl171_ix.normalize2array(ar_or_s_fp_directory)
      ar_rgx=Kibuvits_krl171_ix.normalize2array(ar_or_rgx_file_path_regexes)


      func_keep_in_output=lambda do |x_key,x_value|
      end # func_keep_in_output

      Kibuvits_krl171_ix.x_filter_t1(ar_or_ht_in,func_returns_true_if_element_is_part_of_output)
      raise(Exception.new("Pooleli, "+
      "GUID='118c7635-4f3b-4f17-b1d2-c2c2f051a4e7'\n"))
   end # ar_glob_recursively_t2

   def Kibuvits_krl171_fs.ar_glob_recursively_t2(ar_or_s_fp_directory,ar_or_rgx_file_path_regexes)
      ar_out=Kibuvits_krl171_fs.instance.ar_glob_recursively_t2(
      ar_or_s_fp_directory,ar_or_rgx_file_path_regexes)
      return ar_out
   end # Kibuvits_krl171_fs.ar_glob_recursively_t2

   #----------------------------------------------------------------------

   public

   include Singleton

end # class Kibuvits_krl171_fs
#=====================kibuvits_krl171_fs_rb_end===================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_fs_rb_start".
#==========================================================================

#=====================kibuvits_krl171_formula_rb_start============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_formula_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_GUID_generator.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ix.rb"
#require "bigdecimal"

#==========================================================================

# The class Kibuvits_krl171_formula exists mainly for duck typing.
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
# form the source of the Kibuvits_krl171_formula.create_formulicle
class Kibuvits_krl171_formula
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
      @s_id=Kibuvits_krl171_GUID_generator.generate_GUID();
      @s_formulicles_set_name=nil
   end #initialize

   private

   public

   # There are no type restrictions set to the elements of the ar.
   # For example, the elements might be matrices, Kibuvits_krl171_formula
   # instances, etc., but a recommendation is to use BigDecimal
   # instances in stead of Float and Fixnum instances, because
   # that avoids Fixnum related truncation and Float related
   # rounding errors.
   def create_formulicle(s_name, ar)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_name
         kibuvits_krl171_typecheck bn, Array, ar
      end # if
      kibuvits_krl171_throw 's_name.length==0' if s_name.length==0
      @ht[@@lc_s_formulicle_name+s_name]=s_name
      @ht[@@lc_ar_formulicle_elements+s_name]=ar
   end # create_formulicle

   def delete_formulicle(s_name)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_name
      end # if
      Hash.new.delete(@@lc_s_formulicle_name+s_name)
      Hash.new.delete(@@lc_ar_formulicle_elements+s_name)
   end # delete_formulicle

   # Deletes all formulicles.
   #
   # This function exists just in case one changes the
   # specification of the Kibuvits_krl171_formula later.
   def clear
      @ht.clear
   end # clear

   #----------start-of-convenience-methods----------------------------

   def create_fraction(ar_or_x_numerator, ar_or_x_denominator)
      # If the single element at the numerator array is itself an
      # array, then one has to wrapt it to the fraction array outside
      # of this function, because the following 2 lines are not capable
      # of distinquishing the 2 cases.
      ar_numerator=Kibuvits_krl171_ix.normalize2array(ar_or_x_numerator)
      ar_denominator=Kibuvits_krl171_ix.normalize2array(ar_or_x_denominator)
      kibuvits_krl171_throw "ar_numerator.size==0" if ar_numerator.size==0
      kibuvits_krl171_throw "ar_denominator.size==0" if ar_denominator.size==0

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
   def Kibuvits_krl171_formula.test_1
      ob_formula_1=Kibuvits_krl171_formula.new
      ob_formula_1.create_fraction(BigDecimal(4.to_s),BigDecimal(5.to_s))
      ob_formula_1.delete_formulicle(@@lc_s_denominator)
   end # Kibuvits_krl171_formula.test_1

   public
   def Kibuvits_krl171_formula.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_krl171_testeval bn, "Kibuvits_krl171_formula.test_1"
      return ar_msgs
   end # Kibuvits_krl171_formula.selftest

end # class Kibuvits_krl171_formula
#=====================kibuvits_krl171_formula_rb_end==============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_formula_rb_start".
#==========================================================================

#=====================kibuvits_krl171_finite_sets_rb_start========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_finite_sets_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"

#==========================================================================

# The class Kibuvits_krl171_finite_sets is a namespace for functions that
# are meant for facilitating the use of indexes. In the
# context of the Kibuvits_krl171_finite_sets an index is an Array index,
# hash-table key, etc.
class Kibuvits_krl171_finite_sets
   def initialize
   end #initialize

   public

   # Returns A\B
   def difference(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_A
         kibuvits_krl171_typecheck bn, Hash, ht_B
         kibuvits_krl171_typecheck bn, Hash, ht_out
      end # if
      ht_A.each_key do |x|
         ht_out[x]=ht_A[x] if !ht_B.has_key? x
      end # loop
      return ht_out
   end # difference

   def Kibuvits_krl171_finite_sets.difference(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_krl171_finite_sets.instance.difference(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_krl171_finite_sets.difference(ht_A,ht_B)

   private
   def Kibuvits_krl171_finite_sets.test_difference
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_krl171_finite_sets.difference(ht_A,ht_B,ht_out=Hash.new)
      kibuvits_krl171_throw "test 1" if ht_out.keys.length!=1
      kibuvits_krl171_throw "test 2" if !ht_out.has_key? "aa"
      kibuvits_krl171_throw "test 3" if ht_out["aa"]!="aXX"
   end # Kibuvits_krl171_finite_sets.test_difference

   public

   def union(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_A
         kibuvits_krl171_typecheck bn, Hash, ht_B
         kibuvits_krl171_typecheck bn, Hash, ht_out
      end # if
      ht_A.each_key{|x| ht_out[x]=ht_A[x]}
      ht_B.each_key{|x| ht_out[x]=ht_B[x]}
      return ht_out
   end # union

   def Kibuvits_krl171_finite_sets.union(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_krl171_finite_sets.instance.union(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_krl171_finite_sets.union(ht_A,ht_B)

   private
   def Kibuvits_krl171_finite_sets.test_union
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_krl171_finite_sets.union(ht_A,ht_B)
      kibuvits_krl171_throw "test 1" if ht_out.keys.length!=3
      kibuvits_krl171_throw "test 2" if ht_out["aa"]!="aXX"
      kibuvits_krl171_throw "test 3" if ht_out["bb"]!="bXX"
      kibuvits_krl171_throw "test 4" if ht_out["cc"]!="cXX"
   end # Kibuvits_krl171_finite_sets.test_union

   public

   def symmetric_difference(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_A
         kibuvits_krl171_typecheck bn, Hash, ht_B
         kibuvits_krl171_typecheck bn, Hash, ht_out
      end # if
      ht_out=difference(ht_A,ht_B,ht_out)
      ht_out=difference(ht_B,ht_A,ht_out)
      return ht_out
   end # symmetric_difference

   def Kibuvits_krl171_finite_sets.symmetric_difference(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_krl171_finite_sets.instance.symmetric_difference(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_krl171_finite_sets.symmetric_difference(ht_A,ht_B)

   private
   def Kibuvits_krl171_finite_sets.test_symmetric_difference
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_krl171_finite_sets.symmetric_difference(ht_A,ht_B,ht_out=Hash.new)
      kibuvits_krl171_throw "test 1" if ht_out.keys.length!=2
      kibuvits_krl171_throw "test 2" if !ht_out.has_key? "aa"
      kibuvits_krl171_throw "test 3" if !ht_out.has_key? "cc"
      kibuvits_krl171_throw "test 4" if ht_out["aa"]!="aXX"
      kibuvits_krl171_throw "test 5" if ht_out["cc"]!="cXX"
   end # Kibuvits_krl171_finite_sets.test_symmetric_difference


   public

   def intersection(ht_A,ht_B,ht_out=Hash.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_A
         kibuvits_krl171_typecheck bn, Hash, ht_B
         kibuvits_krl171_typecheck bn, Hash, ht_out
      end # if
      ht_A.each_key do |x|
         ht_out[x]=ht_A[x] if ht_B.has_key? x
      end #loop
      return ht_out
   end # intersection

   def Kibuvits_krl171_finite_sets.intersection(ht_A,ht_B,ht_out=Hash.new)
      ht_out=Kibuvits_krl171_finite_sets.instance.intersection(ht_A,ht_B,ht_out)
      return ht_out
   end # Kibuvits_krl171_finite_sets.intersection(ht_A,ht_B)

   private
   def Kibuvits_krl171_finite_sets.test_intersection
      ht_A=Hash.new
      ht_B=Hash.new
      ht_A["aa"]="aXX"
      ht_A["bb"]="bXX"
      ht_B["bb"]="bXX"
      ht_B["cc"]="cXX"
      ht_out=Kibuvits_krl171_finite_sets.intersection(ht_A,ht_B,ht_out=Hash.new)
      kibuvits_krl171_throw "test 1" if ht_out.keys.length!=1
      kibuvits_krl171_throw "test 2" if !ht_out.has_key? "bb"
      kibuvits_krl171_throw "test 3" if ht_out["bb"]!="bXX"
   end # Kibuvits_krl171_finite_sets.test_intersection

   public
   include Singleton
   def Kibuvits_krl171_finite_sets.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_krl171_testeval bn, "Kibuvits_krl171_finite_sets.test_difference"
      kibuvits_krl171_testeval bn, "Kibuvits_krl171_finite_sets.test_union"
      kibuvits_krl171_testeval bn, "Kibuvits_krl171_finite_sets.test_symmetric_difference"
      kibuvits_krl171_testeval bn, "Kibuvits_krl171_finite_sets.test_intersection"
      return ar_msgs
   end # Kibuvits_krl171_finite_sets.selftest
end # class Kibuvits_krl171_finite_sets
#=====================kibuvits_krl171_finite_sets_rb_end==========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_finite_sets_rb_start".
#==========================================================================

#=====================kibuvits_krl171_file_intelligence_rb_start==================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_file_intelligence_rb_end".
#==========================================================================
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
#=========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_fs.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_shell.rb"

#==========================================================================

# The class Kibuvits_krl171_file_intelligence is for various
# meta-data like cases, like inferring file format by
# its extension, etc.
class Kibuvits_krl171_file_intelligence

   def initialize
   end # initialize

   # Returns a string.
   def file_language_by_file_extension(s_file_path,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ar_tokens=Kibuvits_krl171_str.ar_bisect(s_file_path.reverse, '.')
      s_file_extension=ar_tokens[0].reverse.downcase
      s_file_language=$kibuvits_krl171_lc_undetermined
      case s_file_extension
      when "js"
         s_file_language="JavaScript"
      when "rb"
         s_file_language="Ruby"
      when "py"
         s_file_language="Python"
      when "php"
         s_file_language="PHP"
      when "h"
         s_file_language="C"
      when "hpp"
         s_file_language="C++"
      when "cs"
         s_file_language="C#"
      when "c"
         s_file_language="C"
      when "cpp"
         s_file_language="C++"
      when "hs"
         s_file_language="Haskell"
      when "java"
         s_file_language="Java"
      when "scala"
         s_file_language="Scala"
      when "bash"
         s_file_language="Bash"
      when "reduce"
         s_file_language="REDUCE"
      when "html"
         s_file_language="HTML"
      when "xml"
         s_file_language="XML"
      when "htaccess"
         s_file_language="htaccess"
      else
         msgcs.cre "Either the file extension is not supported or "+
         "the file extension extraction failed.\n"+
         "File extension candidate is: "+s_file_extension, 1.to_s
         msgcs.last[$kibuvits_krl171_lc_Estonian]="Faililaiend on kas toetamata või ei õnnestunud "+
         "faililaiendit eraldada. \n"+
         "Faililaiendi kandidaat on:"+s_file_extension
      end # case
      return s_file_language
   end # file_language_by_file_extension

   def Kibuvits_krl171_file_intelligence.file_language_by_file_extension(
      s_file_path, msgcs)
      s_file_language=Kibuvits_krl171_file_intelligence.instance.file_language_by_file_extension(
      s_file_path, msgcs)
      return s_file_language
   end # Kibuvits_krl171_file_intelligence.file_language_by_file_extension

   #--------------------------------------------------------------------------

   def exm_b_files_have_bitwise_equal_content_t1(s_fp_file_1,s_fp_file_2,
      msgcs=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_fp_file_1
         kibuvits_krl171_typecheck bn, String, s_fp_file_2
         kibuvits_krl171_typecheck bn, [NilClass,Kibuvits_krl171_msgc_stack], msgcs
      end # if
      #----------------
      b_throw_on_failure=true
      if msgcs.class==Kibuvits_krl171_msgc_stack
         b_throw_on_failure=false
      else
         msgcs=Kibuvits_krl171_msgc_stack.new
      end # if
      #----------------
      rgx=/[\/]+/
      s_fp_1=s_fp_file_1.gsub(rgx,$kibuvits_krl171_lc_slash)
      s_fp_2=s_fp_file_2.gsub(rgx,$kibuvits_krl171_lc_slash)
      #----------------
      ht_test_failures=Kibuvits_krl171_fs.verify_access([s_fp_1,s_fp_1],
      "readable,is_file")
      s_output_message_language=$kibuvits_krl171_lc_English
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw_on_failure,msgcs)
      return false if msgcs.b_failure
      #----------------
      i_size_1=File.size(s_fp_1)
      i_size_2=File.size(s_fp_2)
      return false if i_size_1!=i_size_2 # more frequent than
      return true if s_fp_1==s_fp_2      # this line
      #--------------
      cmd="diff --brief "+s_fp_1+$kibuvits_krl171_lc_space+s_fp_2
      ht_stdstreams=kibuvits_krl171_sh(cmd)
      Kibuvits_krl171_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
      "GUID='bc960331-8e37-4231-b3a2-c2c2f051a4e7'\n")
      s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
      return false if 0<s_stdout.length
      return true
   end # exm_b_files_have_bitwise_equal_content_t1

   def Kibuvits_krl171_file_intelligence.exm_b_files_have_bitwise_equal_content_t1(
      s_fp_file_1,s_fp_file_2,msgcs=nil)
      b_out=Kibuvits_krl171_file_intelligence.instance.exm_b_files_have_bitwise_equal_content_t1(
      s_fp_file_1,s_fp_file_2,msgcs)
      return b_out
   end # Kibuvits_krl171_file_intelligence.exm_b_files_have_bitwise_equal_content_t1

   #--------------------------------------------------------------------------

   private

   # Returns destination file or folder path or the path
   # of an existing, older, back-up file, if
   # one of the older back-up files has the same
   # content as the original. The current version
   # always forces folders to be re-backed up, because
   # the FileUtils.compare_file does not work with folders.
   #
   # TODO: Fix the exm_s_create_backup_copy_t1_create_s_fp_dest
   # so that it will not force folders to be recursively
   # backed up if the content of the backup equals with the
   # original.
   def exm_s_create_backup_copy_t1_create_s_fp_dest(
      s_fp_dest_parent_folder,s_backup_prefix,
      s_fp_file_or_folder,b_throw_on_failure,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         # A bit of an overkill, but helps to locate problems.
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_fp_dest_parent_folder
         kibuvits_krl171_typecheck bn, String, s_backup_prefix
         kibuvits_krl171_typecheck bn, String, s_fp_file_or_folder
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_throw_on_failure
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ar=Kibuvits_krl171_str.ar_bisect(s_fp_file_or_folder.reverse,$kibuvits_krl171_lc_slash)
      s_fp_forf_name=ar[0].reverse
      i_backup_version=0
      #----------------
      s_token_0=(s_fp_dest_parent_folder+$kibuvits_krl171_lc_slash).gsub(
      /[\/]+/,$kibuvits_krl171_lc_slash)
      s_token_1=s_fp_forf_name
      s_token_2_version=$kibuvits_krl171_lc_underscore+s_backup_prefix+i_backup_version.to_s
      s_token_3_dot_file_extension_if_file=$kibuvits_krl171_lc_emptystring
      if !File.directory? s_fp_file_or_folder
         # Supposedly does not match links to folders.
         md=s_fp_forf_name.match(/[.][^.]+$/)
         if md!=nil
            s_dot_file_ext=md[0]
            s_token_1=s_fp_forf_name[0..(-1-s_dot_file_ext.length)]
            s_token_3_dot_file_extension_if_file=s_dot_file_ext
         end # if
      end # if
      s_fp_dest_candidate_0=nil
      s_fp_dest_candidate_1=s_token_0+s_token_1+
      s_token_2_version+s_token_3_dot_file_extension_if_file
      while File.exist? s_fp_dest_candidate_1
         s_fp_dest_candidate_0=s_fp_dest_candidate_1
         i_backup_version=i_backup_version+1
         s_token_2_version=$kibuvits_krl171_lc_underscore+
         s_backup_prefix+i_backup_version.to_s
         s_fp_dest_candidate_1=s_token_0+s_token_1+
         s_token_2_version+s_token_3_dot_file_extension_if_file
      end # loop
      if !$kibuvits_krl171_var_b_module_fileutils_loaded
         # It's OK to load them more than once, so no need for Mutexes.
         # It just seems to be a corner case, where performance
         # has probably not been very well tested, i.e.
         # usually people do not have loops that try to reload a
         # module thousands of times. Hence this if-clause here.
         require "fileutils"
         $kibuvits_krl171_var_b_module_fileutils_loaded=true
      end # if
      return s_fp_dest_candidate_1 if s_fp_dest_candidate_0==nil
      return s_fp_dest_candidate_1 if File.directory? s_fp_file_or_folder
      b_old_backup_is_the_same_as_the_original=FileUtils.compare_file(
      s_fp_dest_candidate_0,s_fp_file_or_folder)
      if b_old_backup_is_the_same_as_the_original
         s_fp_dest_candidate_1=s_fp_dest_candidate_0
      end # if
      return s_fp_dest_candidate_1
   end # exm_s_create_backup_copy_t1_create_s_fp_dest

   public

   # Throws or returns with flaw description, if the destination
   # folder of the backup copy is not writable or the "cp -fr " fails.
   #
   # If the s_fp_backup_destination_folder==".", then the backup
   # copy is placed to the same folder, where the original resides.
   #
   # File extensions are retained. Non-file-extension part of
   # the file or folder name is suffixed with <"_"+s_backup_prefix><integer>.
   #
   # If the creation of the backup copy suceeded, returns
   # the full path of the backup copy. Otherwise returns an empty string.
   def exm_s_create_backup_copy_t1(
      s_fp_file_or_folder,s_fp_backup_destination_folder=$kibuvits_krl171_lc_dot,
      msgcs=nil,s_backup_prefix="old_v")
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_fp_file_or_folder
         kibuvits_krl171_typecheck bn, String, s_fp_backup_destination_folder
         kibuvits_krl171_typecheck bn, [NilClass,Kibuvits_krl171_msgc_stack], msgcs
         kibuvits_krl171_typecheck bn, String, s_backup_prefix
         if msgcs.class==Kibuvits_krl171_msgc_stack
            if msgcs.b_failure
               kibuvits_krl171_throw("msgcs.b_failure==true\n"+
               "GUID='b2d8d359-121e-403c-a282-c2c2f051a4e7'\n")
            end # if
         end # if
      end # if
      kibuvits_krl171_assert_does_not_contain_common_special_characters_t1(
      bn,s_backup_prefix)
      b_throw_on_failure=true
      if msgcs.class==Kibuvits_krl171_msgc_stack
         b_throw_on_failure=false
      else
         msgcs=Kibuvits_krl171_msgc_stack.new
      end # if
      #-----------------------
      # TODO: consider refactoring the next check to a separate function
      rgx_0=/[\/]$/
      if s_fp_file_or_folder.match(rgx_0)
         msg="s_fp_file_or_folder == \n"+s_fp_file_or_folder+
         "\nbut the file or folder name is not allowed to end with a slash\n"
         if b_throw_on_failure
            kibuvits_krl171_throw(msg+
            "GUID='1f1a6744-382e-411f-a552-c2c2f051a4e7'\n")
         else
            s_default_msg=msg
            s_message_id="e_0"
            b_failure=true
            s_location_marker_GUID="52aa9755-b705-4c57-9415-c2c2f051a4e7"
            msgcs.cre(s_default_msg,s_message_id,
            b_failure,s_location_marker_GUID)
            return $kibuvits_krl171_lc_emptystring
         end # if
      end # if
      #-----------------------
      Kibuvits_krl171_fs.verify_access(s_fp_file_or_folder,"readable",msgcs)
      if msgcs.b_failure
         kibuvits_krl171_throw(msgcs.to_s+$kibuvits_krl171_lc_linebreak+
         "GUID='71c7694d-b567-4797-b532-c2c2f051a4e7'\n")
      end # if
      s_fp_dest_parent_folder=nil
      if s_fp_backup_destination_folder==$kibuvits_krl171_lc_dot
         s_fp=nil
         begin
            s_fp=Pathname.new(s_fp_file_or_folder).realpath.parent.to_s
         rescue Exception => e
            # It might be that the file or folder does
            # not exist and if that's the case, the "realpath"
            # part of the s_fp=... line throws.
            if b_throw_on_failure
               kibuvits_krl171_throw(e.to_s+$kibuvits_krl171_lc_linebreak+
               "GUID='28ef54f1-85d9-41d5-84e1-c2c2f051a4e7'\n")
            else
               s_default_msg=e.to_s
               s_message_id="e_1"
               b_failure=true
               s_location_marker_GUID="16baf455-8386-4dee-95b4-c2c2f051a4e7"
               msgcs.cre(s_default_msg,s_message_id,
               b_failure,s_location_marker_GUID)
               return $kibuvits_krl171_lc_emptystring
            end # if
         end # rescue
         Kibuvits_krl171_fs.verify_access(s_fp,"is_directory,writable",msgcs)
         if msgcs.b_failure
            if b_throw_on_failure
               kibuvits_krl171_throw(msgcs.to_s+$kibuvits_krl171_lc_linebreak+
               "GUID='40e4e750-2c0b-47c8-82b1-c2c2f051a4e7'\n")
            else
               return $kibuvits_krl171_lc_emptystring
            end # if
         end # if
         s_fp_dest_parent_folder=s_fp
      else # s_fp_backup_destination_folder != $kibuvits_krl171_lc_dot
         Kibuvits_krl171_fs.verify_access(s_fp_backup_destination_folder,
         "is_directory,writable",msgcs)
         if msgcs.b_failure
            if b_throw_on_failure
               kibuvits_krl171_throw(msgcs.to_s+$kibuvits_krl171_lc_linebreak+
               "GUID='1c7e16e9-a516-4166-a581-c2c2f051a4e7'\n")
            else
               return $kibuvits_krl171_lc_emptystring
            end # if
         end # if
         s_fp_dest_parent_folder=s_fp_backup_destination_folder
      end # if
      #-----------------------
      s_fp_backup_copy=exm_s_create_backup_copy_t1_create_s_fp_dest(
      s_fp_dest_parent_folder,s_backup_prefix,
      s_fp_file_or_folder,b_throw_on_failure,msgcs)
      #----
      if msgcs.b_failure
         if b_throw_on_failure
            kibuvits_krl171_throw(msgcs.to_s+$kibuvits_krl171_lc_linebreak+
            "GUID='1d75b2ed-435e-488f-8151-c2c2f051a4e7'\n")
         else
            return $kibuvits_krl171_lc_emptystring
         end # if
      end # if
      #-----------------------
      return s_fp_backup_copy if File.exists? s_fp_backup_copy
      cmd=("cp -f -R "+s_fp_file_or_folder)+($kibuvits_krl171_lc_space+s_fp_backup_copy)
      ht_stdstreams=kibuvits_krl171_sh(cmd)
      s_stderr=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]
      if 0<s_stderr.length
         if b_throw_on_failure
            Kibuvits_krl171_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
            "GUID='1f70b251-c6b1-4b1b-8311-c2c2f051a4e7'\n")
         else
            s_default_msg=s_stderr
            s_message_id="e_2"
            b_failure=true
            s_location_marker_GUID="b3e1fc30-4620-45cd-9454-c2c2f051a4e7"
            msgcs.cre(s_default_msg,s_message_id,
            b_failure,s_location_marker_GUID)
            return $kibuvits_krl171_lc_emptystring
         end # if
      end # if
      return s_fp_backup_copy
   end # exm_s_create_backup_copy_t1

   def Kibuvits_krl171_file_intelligence.exm_s_create_backup_copy_t1(
      s_fp_file_or_folder,s_fp_backup_destination_folder=$kibuvits_krl171_lc_dot,
      msgcs=nil,s_backup_prefix="old_v")
      s_fp_backup_copy=Kibuvits_krl171_file_intelligence.instance.exm_s_create_backup_copy_t1(
      s_fp_file_or_folder,s_fp_backup_destination_folder,
      msgcs,s_backup_prefix)
      return s_fp_backup_copy
   end # Kibuvits_krl171_file_intelligence.exm_s_create_backup_copy_t1

   #----------------------------------------------------------------------

   private

   def s_get_MIME_type_impl_unix(s_fp)
      if !defined? @s_lc_s_get_MIME_type_const_1
         # The "file --mime-type " works on boty, Linux and FreeBSD.
         @s_lc_s_get_MIME_type_const_1="file --mime-type ".freeze
      end # if
      s_fp_normalized=s_fp.gsub(/[\/]+/,$kibuvits_krl171_lc_slash)
      cmd=@s_lc_s_get_MIME_type_const_1+s_fp_normalized
      ht_stdstreams=kibuvits_krl171_sh(cmd)
      Kibuvits_krl171_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
      "GUID='4e9ea84e-8079-434f-a3e0-c2c2f051a4e7'\n")
      s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
      #----------------
      # Command
      #
      #     file --mime-type ./uu.txt
      #
      # returns:
      #
      #     startofline./uu.txt: blablamimetype
      #
      s_0=s_stdout[(s_fp_normalized.length+2)..(-1)]
      s_out=s_0.gsub(/[\s\t\n\r]+$/,$kibuvits_krl171_lc_emptystring)
      return s_out
   end # s_get_MIME_type_impl_unix

   public

   # Text files that have application format
   # specific content have different MIME types.
   # For example, the MIME type of a Ruby source
   # file differs from a MIME type of a text
   # file that contains armoured GNU Privacy Guard message.
   def s_get_MIME_type(s_fp)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String,s_fp
         #--------
         ht_test_failures=Kibuvits_krl171_fs.verify_access(s_fp,"readable")
         s_output_message_language=$kibuvits_krl171_lc_English
         b_throw=true
         Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
         s_output_message_language,b_throw,
         "GUID='23c1c35a-0ee9-42fb-95b0-c2c2f051a4e7'")
      end # if
      s_ostype=Kibuvits_krl171_os_codelets.get_os_type
      s_out=nil
      if s_ostype==$kibuvits_krl171_lc_kibuvits_krl171_ostype_unixlike
         s_out=s_get_MIME_type_impl_unix(s_fp)
      else
         kibuvits_krl171_throw("Operating system type \n\""+
         s_ostype+"\" is not yet supported by this function.\n"+
         "GUID='216cd133-16ea-41e7-8180-c2c2f051a4e7'")
      end # if
      return s_out
   end # s_get_MIME_type


   def Kibuvits_krl171_file_intelligence.s_get_MIME_type(s_fp)
      s_out=Kibuvits_krl171_file_intelligence.instance.s_get_MIME_type(s_fp)
      return s_out
   end # Kibuvits_krl171_file_intelligence.s_get_MIME_type

   #--------------------------------------------------------------------------

   # Returns true only, if it is certain that the MIME type, s_mimetype,
   # refers to a binary file format. Otherwise returns false.
   #
   # The s_mimetype might be acquired by using the s_get_MIME_type(...).
   #
   def b_mimetype_certainly_refers_to_a_binary_format_t1(s_mimetype)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String,s_mimetype
         #--------
         i_len_orig=s_mimetype.length
         i_len_modif=s_mimetype.sub(/[\/]/,$kibuvits_krl171_lc_emptystring).length
         if i_len_orig==i_len_modif
            kibuvits_krl171_throw("s_mimetype == "+s_mimetype+
            "\nis not a MIME type, because it does not contain the \n"+
            "slash character (\"/\").\n"+
            "GUID='5c400e43-cff5-4a0c-b350-c2c2f051a4e7'\n\n")
         end # if
         #--------
      end # if
      ht_yes=nil
      if !defined? @ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1
         @ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1=Hash.new
         ht_yes=@ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1
         #------------------
         # http://www.freeformatter.com/mime-types-list.html
         #------------------
         ht_yes["image/jpeg"]=42
         ht_yes["image/gif"]=42
         ht_yes["image/png"]=42
         ht_yes["image/bmp"]=42
         ht_yes["image/x-ms-bmp"]=42
         ht_yes["image/webp"]=42
         ht_yes["image/tiff"]=42
         ht_yes["application/octet-stream"]=42 # BMP image files and LibreOffice odb files.
         ht_yes["image/x-icon"]=42
         ht_yes["image/x-xcf"]=42 # Gimp files
         ht_yes["image/x-pcx"]=42
         ht_yes["image/x-rgb"]=42
         ht_yes["image/x-xbitmap"]=42
         ht_yes["image/x-xpixmap"]=42
         ht_yes["image/prs.btif"]=42
         ht_yes["image/x-xwindowdump"]=42
         ht_yes["image/x-portable-pixmap"]=42
         ht_yes["image/x-portable-graymap"]=42
         ht_yes["image/x-portable-anymap"]=42
         ht_yes["image/x-portable-bitmap"]=42
         ht_yes["image/x-pict"]=42
         ht_yes["image/x-cmu-raster"]=42
         ht_yes["image/vnd.dxf"]=42 # AutoCad?
         ht_yes["image/vnd.wap.wbmp"]=42
         ht_yes["image/vnd.djvu"]=42
         ht_yes["image/vnd.dwg"]=42
         ht_yes["image/vnd.fujixerox.edmics-mmr"]=42
         ht_yes["image/vnd.fujixerox.edmics-rlc"]=42
         ht_yes["image/vnd.xiff"]=42
         ht_yes["image/vnd.fastbidsheet"]=42
         ht_yes["image/vnd.fpx"]=42
         ht_yes["image/vnd.net-fpx"]=42
         ht_yes["image/vnd.adobe.photoshop"]=42
         ht_yes["image/vnd.dece.graphic"]=42
         #-----
         # According to the
         #
         #     http://longterm.softf1.com/specifications/third_party/MIDI_file_format/Standard_MIDI_file_format_spec_1_1_by_David_Back.pdf
         #
         # the MIDI file format is a binary format.
         ht_yes["audio/midi"]=42
         #-----
         ht_yes["audio/basic"]=42  # Sun audio file
         ht_yes["audio/x-wav"]=42
         ht_yes["audio/adpcm"]=42
         ht_yes["audio/x-aac"]=42
         ht_yes["audio/x-aiff"]=42
         ht_yes["audio/vnd.dece.audio"]=42
         ht_yes["audio/x-pn-realaudio"]=42
         ht_yes["audio/mp4"]=42
         ht_yes["audio/mpeg"]=42
         ht_yes["audio/webm"]=42
         ht_yes["audio/ogg"]=42
         ht_yes["application/ogg"]=42
         ht_yes["audio/vnd.dece.audio"]=42
         ht_yes["audio/x-ms-wma"]=42
         #-----
         ht_yes["video/mp4"]=42
         ht_yes["application/mp4"]=42
         ht_yes["video/ogg"]=42
         ht_yes["video/webm"]=42
         ht_yes["video/jpm"]=42
         ht_yes["video/jpeg"]=42
         ht_yes["video/mpeg"]=42
         ht_yes["video/mj2"]=42
         ht_yes["video/x-ms-wm"]=42    # Microsoft
         ht_yes["video/x-ms-wmv"]=42   # Microsoft
         ht_yes["video/x-msvideo"]=42  # avi format
         ht_yes["video/h264"]=42
         ht_yes["video/h263"]=42
         ht_yes["video/h261"]=42
         ht_yes["video/x-flv"]=42  # Flash
         ht_yes["video/x-f4v"]=42  # Flash
         ht_yes["video/3gpp"]=42
         ht_yes["video/3gpp2"]=42
         ht_yes["video/vnd.dece.hd"]=42
         ht_yes["video/vnd.dece.mobile"]=42
         ht_yes["video/vnd.dece.pd"]=42
         ht_yes["video/vnd.dece.sd"]=42
         ht_yes["video/vnd.dece.video"]=42
         ht_yes["video/vnd.uvvu.mp4"]=42
         ht_yes["application/x-dvi"]=42
         ht_yes["video/vnd.fvt"]=42
         ht_yes["video/x-fli"]=42
         ht_yes["video/x-m4v"]=42
         ht_yes["video/quicktime"]=42
         ht_yes["video/x-sgi-movie"]=42
         #-----
         # Fonts
         ht_yes["application/x-font-ttf"]=42
         ht_yes["application/x-font-otf"]=42
         ht_yes["application/x-font-bdf"]=42
         ht_yes["application/x-font-woff"]=42 # Web Open Font Format
         ht_yes["application/x-font-pcf"]=42
         ht_yes["application/font-tdpfr"]=42
         ht_yes["application/x-font-type1"]=42        # PostScript Fonts
         ht_yes["application/x-font-ghostscript"]=42
         ht_yes["application/x-font-linux-psf"]=42
         ht_yes["application/x-font-snf"]=42
         ht_yes[""]=42
         #-----
         ht_yes["application/x-tar"]=42
         ht_yes["application/x-gzip"]=42
         ht_yes["application/zip"]=42
         ht_yes["application/x-bzip2"]=42
         ht_yes["application/x-xz"]=42
         ht_yes["application/x-7z-compressed"]=42
         #-----
         ht_yes["application/pdf"]=42
         ht_yes["application/x-hdf"]=42 # The HDF
         ht_yes["application/x-debian-package"]=42
         #------------------
         # LibreOffice formats:
         ht_yes["application/vnd.oasis.opendocument.graphics"]=42
         ht_yes["application/vnd.oasis.opendocument.spreadsheet"]=42
         ht_yes["application/vnd.oasis.opendocument.formula"]=42
         ht_yes["application/vnd.oasis.opendocument.text"]=42
         ht_yes["application/vnd.oasis.opendocument.presentation"]=42
         #------------------
         # Microsoft:
         ht_yes["application/msword"]=42
         ht_yes["application/vnd.ms-powerpoint"]=42
         ht_yes["application/x-mswrite"]=42 # Microsoft Wordpad
         ht_yes["application/x-msaccess"]=42
         #------------------
         ht_yes["application/x-executable"]=42
         #------------------
         #ht_yes[""]=42
         ht_yes.freeze
      else
         ht_yes=@ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1
      end # if
      b_out=ht_yes.has_key? s_mimetype
      return b_out
   end # b_mimetype_certainly_refers_to_a_binary_format_t1


   def Kibuvits_krl171_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1(s_mimetype)
      b_out=Kibuvits_krl171_file_intelligence.instance.b_mimetype_certainly_refers_to_a_binary_format_t1(s_mimetype)
      return b_out
   end # Kibuvits_krl171_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_file_intelligence
#=====================kibuvits_krl171_file_intelligence_rb_end====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_file_intelligence_rb_start".
#==========================================================================


#=====================kibuvits_krl171_eval_rb_start===============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_eval_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/bonnet/kibuvits_krl171_os_codelets.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_shell.rb"

#==========================================================================
# It's meant to be only a base class for bridges.
# No instances of it should ever be created.
class Kibuvits_krl171_eval_bridge
   def initialize
      @s_scriptfile_extension="_is_meant_to_be_set_in_sibling_classes"
      @s_bridge_name="<bridge name not set. GUID=="+
      "'c0d3fe5e-b0cf-4e83-9520-c2c2f051a4e7'>"
   end #initialize

   # It's a hook for modifying the s_script prior to writing
   # it to the script file. For example, one can add
   # language specific start and end tags with it. It's meant
   # to be overridden, but its not compulsory to override it.
   def create_scriptfile_string s_script
      return s_script
   end # create_scriptfile_string

   def create_scriptfile s_script
      s_sc=create_scriptfile_string s_script
      s_fp=Kibuvits_krl171_os_codelets.instance.generate_tmp_file_absolute_path()
      s_fp=s_fp.gsub(".txt","_")+"."+@s_scriptfile_extension
      str2file(s_sc,s_fp)
      return s_fp
   end # create_scriptfile

   # It is expected to return a string.
   def create_console_command s_script_file_path
      kibuvits_krl171_throw "This method is meant to be overridden."
   end # create_console_command

   def installed
      kibuvits_krl171_throw "This method is meant to be overridden."
   end # installed

   def run s_script, msgcs
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_script
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ht_stdstreams=nil
      s_fp=""
      begin
         s_fp=create_scriptfile s_script
         cmd=create_console_command s_fp
         ht_stdstreams=kibuvits_krl171_sh(cmd)
      rescue Exception => e
         msgcs.cre "Something went wrong within the "+
         "Kibuvits to "+@s_bridge_name+" bridge. The error message: "+
         e.message.to_s,3.to_s
         msgcs.last['Estonian']="Midagi läks Kibuvits teegi "+
         @s_bridge_name+" sillal valesti. Veateade: "+e.message.to_s
         ht_stdstreams=Kibuvits_krl171_io.create_empty_ht_stdstreams
      end # try-catch
      File.delete(s_fp) if File.exists? s_fp
      return ht_stdstreams
   end # run
end # class Kibuvits_krl171_eval_bridge
#==========================================================================
class Kibuvits_krl171_eval_bridge_PHP5 < Kibuvits_krl171_eval_bridge
   def initialize
      @s_scriptfile_extension="php"
      @s_bridge_name="PHP5"
      # TODO: port this class to Windows.
      if Kibuvits_krl171_os_codelets.instance.get_os_type!="kibuvits_krl171_ostype_unixlike"
         kibuvits_krl171_throw "Only unixlike operatingsystems supported."
      end # if
   end #initialize

   private
   def fix_start_end_tags s_script
      s_out=s_script
      regex=/[\s]*<[?][\s]*php[\s]/
      match_data=regex.match(s_script)
      if match_data==nil
         s_out="<?php \n"+s_script+" \n?>\n"
      end # if
      return s_out
   end # fix_start_end_tags

   public

   def create_scriptfile_string s_script
      s_out=fix_start_end_tags s_script
      return s_out
   end # create_scriptfile_string

   def create_console_command s_script_file_path
      #No ";" for corss-OS compatibility.
      cmd="php5 --file "+s_script_file_path+" "
      return cmd
   end # create_console_command

   def installed
      cmd="php5 -version "
      ht_stdstreams=kibuvits_krl171_sh(cmd)
      s_stdout=ht_stdstreams['s_stdout']
      b_installed=false
      b_installed=true if s_stdout.include? "Zend"
      return b_installed
   end # installed

end # class Kibuvits_krl171_eval_bridge_PHP5
#==========================================================================
# The ruby eval has been wrapped to this class for
# API unification purposes and it also serves the purpose
# of being an interpreter class source example.
class Kibuvits_krl171_eval_bridge_Ruby < Kibuvits_krl171_eval_bridge
   def initialize
      @s_scriptfile_extension="rb"
      @s_bridge_name="Ruby"
   end #initialize

   def create_console_command s_script_file_path
      #No ";" for corss-OS compatibility.
      cmd="ruby -Ku "+s_script_file_path+" "
      return cmd
   end # create_console_command

   def installed
      return true
   end #installed

end # class Kibuvits_krl171_eval_bridge_Ruby
#==========================================================================
class Kibuvits_krl171_eval
   def initialize
      @ht_bridges=Hash.new
      @ht_installed=Hash.new
   end #initialize

   # Returns a boolean value.
   def language_is_supported s_language
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), String, s_language
      end # if
      s_lang=s_language.downcase
      b_is_supported=true
      case s_lang
      when "php5"
         if !@ht_bridges.has_key?("php5")
            @ht_bridges["php5"]=Kibuvits_krl171_eval_bridge_PHP5.new
            @ht_installed[s_lang]=@ht_bridges[s_lang].installed
         end # if
      when "ruby"
         if !@ht_bridges.has_key?("ruby")
            @ht_bridges["ruby"]=Kibuvits_krl171_eval_bridge_Ruby.new
            @ht_installed[s_lang]=@ht_bridges[s_lang].installed
         end # if
      else
         b_is_supported=false
      end
      return b_is_supported
   end # language_is_supported


   def run s_script,s_language,msgcs
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_script
         kibuvits_krl171_typecheck bn, String, s_language
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      s_lang=s_language.downcase
      if !language_is_supported s_lang
         s_ostype=Kibuvits_krl171_os_codelets.instance.get_os_type
         msgcs.cre "The library does not yet support language \""+
         s_language+"\" on operationg system \""+s_ostype+"\".",1.to_s
         msgcs.last['Estonian']="Keel \""+s_language+"\" ei ole "+
         "veel teegi poolt operatsioonisüsteemil "+
         "nimega \""+s_ostype+"\" toetatud."
         ht_stdstreams=Kibuvits_krl171_io.create_empty_ht_stdstreams
         return ht_stdstreams
      end # if
      return ht_stdstreams if msgcs.b_failure
      if !@ht_installed[s_lang]
         msgcs.cre "Language \""+s_language+"\" is supported by "+
         "the library, but it is not yet installed.",2.to_s
         msgcs.last['Estonian']="Keel \""+s_language+"\" on "+
         "küll teegi poolt toetatud, kuid seda ei ole veel "+
         "installeeritud."
         ht_stdstreams=Kibuvits_krl171_io.create_empty_ht_stdstreams
         return ht_stdstreams
      end # if
      ht_stdstreams=@ht_bridges[s_lang].run s_script,msgcs
      return ht_stdstreams
   end # run

   def Kibuvits_krl171_eval.run s_script,s_language,msgcs
      ht_stdstreams=Kibuvits_krl171_eval.instance.run s_script,s_language,msgcs
      return ht_stdstreams
   end # Kibuvits_krl171_eval.run

   #-----------------------------------------------------------------------
   public
   include Singleton
end # class Kibuvits_krl171_eval
#=====================kibuvits_krl171_eval_rb_end=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_eval_rb_start".
#==========================================================================

#=================kibuvits_krl171_dependencymetrics_t1_rb_start===================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_dependencymetrics_t1_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_DEPENDENCYMETRICS_T1_RB_INCLUDED
   KIBUVITS_krl171_DEPENDENCYMETRICS_T1_RB_INCLUDED=true

   if !defined? KIBUVITS_krl171_HOME
      require 'pathname'
      ob_pth_0=Pathname.new(__FILE__).realpath
      ob_pth_1=ob_pth_0.parent.parent.parent
      s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
      #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
      ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
   end # if

   #require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
end # if

#==========================================================================

# The class Kibuvits_krl171_dependencymetrics_t1 is a namespace for methods
# that provide answers about a instances that have their
# dependency graph described and acessible according to
# the specification that the Kibuvits_krl171_dependencymetrics_t1
# is designed to use. The specification is described by the
# following example:
#
# The dependencies graph is described in the format of a hashtable:
#
# ht_dependency_relations=Hash.new
# ht_dependency_relations["Micky"]=["Donald","Pluto"]
# ht_dependency_relations["Swan"]=[]
# ht_dependency_relations["Horse"]=["Mule"]
# ht_dependency_relations["Frog"]=nil
# ht_dependency_relations["Butterfly"]="Beetle"
#
# Part of the semantics of the ht_dependency_relations content is that
# the dependencies are considered to be met, if the
# following boolean expression has the value of true:
#
#                       ( <Micky> OR <Donald> OR <Pluto> ) AND
#                   AND   <Swan> AND
#                   AND ( <Horse> OR <Mule> ) AND
#                   AND   <Frog> AND
#                   AND ( <Butterfly> OR <Beetle> )
#
# The chevrons denote a function that
# returns a boolean value.
#
# The other part of the semantics of the ht_dependency_relations
# is that the order of the names in the arrays is
# important, because the replacement dependencies
# are searched by starting from the smallest
# index. For example, in the case of the illustration,
# if the Pluto is available and the Donald
# is available, but the Micky is not available, then
# the Donald is used, because its index in the
# array is smaller than that of the Pluto.
#
# The previous, boolean, example was equivalent to a situation,
# where the dependency fulfillment has only 2 values,
#       "met"  ,  "unmet",
# i.e.  "yes"  ,   "no",
# i.e.    1   and   0,
# i.e. "true"  ,  "false
# and the fulfillment threshold equals one.
#
# A generalized version of that is that there is a range of
# floating point numbers, [0,n], where 1<=n, and the question, whether
# all dependencies have been met, is equivalent to a question:
# do all of the dependencies have their availability value
# equal to or greater than the threshold?
#
# For example, in the case of the classical, boolean,
# version, the n==1, i.e. the range of floating point numbers
# is [0,1], and all dependencies are considered to be met, if
# all of the dependencies have their availability value
# "greater than" or "equal to" one. That is to say, in the
# case of the boolean version the threshold equals 1 .
#
# If the ht_dependency_relations does not contain any keys,
# then all dependencies are considered to be met and the
# threshold is considered to be reached.
#
class Kibuvits_krl171_dependencymetrics_t1
   def initialize
   end # initialize

   private
   def verify_ht_dependency_relations_format(s_dependent_object_name,
      ht_dependency_relations)
      bn=binding()
      kibuvits_krl171_assert_string_min_length(bn,s_dependent_object_name,1)
      kibuvits_krl171_typecheck bn, Hash, ht_dependency_relations
      bn=nil
      s_clname=nil
      ht_dependency_relations.each_pair do |s_key,x_value|
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_key
         kibuvits_krl171_assert_string_min_length(bn,s_key,1)
         s_clname=x_value.class.to_s
         case s_clname
         when "String"
            # Any string is OK. An empty string
            # indicates that the dependency s_key
            # does not have any substitutes.
         when "Array"
            # An empty array indicates that the dependency s_key
            # does not have any substitutes.
            x_value.each do |s_key_substitute_name|
               bn_1=binding()
               kibuvits_krl171_typecheck bn_1, String, s_key_substitute_name
               kibuvits_krl171_assert_string_min_length(bn_1,
               s_key_substitute_name,1)
            end # loop
         when "NilClass"
            # x_value==nil indicates that the dependency s_key
            # does not have any substitutes.
         else
            kibuvits_krl171_throw("ht_dependency_relations[\""+s_key+"\"].class=="+
            s_clname+", which is not supported in this role."+
            "\nGUID=='46e770d5-7ccf-43c7-b9ff-c2c2f051a4e7'")
         end # case x_value.class
      end # loop
      if ht_dependency_relations.has_key? s_dependent_object_name
         kibuvits_krl171_throw("ht_dependency_relations.has_key?("+
         "s_dependent_object_name)==true, "+
         "s_dependent_object_name=="+s_dependent_object_name+
         "\nGUID=='44390264-89f4-4b1c-a3cf-c2c2f051a4e7'")
      end # if
   end # verify_ht_dependency_relations_format


   private

   def fd_get_availability(ht_objects,s_ob_name,sym_avail,
      ht_cycle_detection_opmem,fd_threshold)
      ob=ht_objects[s_ob_name]
      if ob==nil
         fd_out=0.to_r
         return fd_out;
      end # if
      if !ob.respond_to? sym_avail
         kibuvits_krl171_throw("Object with the name "+s_ob_name+
         " exist, but it does not have a public method called "+sym_avail.to_s+
         "\nGUID='b9895537-dad8-409b-b49f-c2c2f051a4e7'.")
      end # if
      if ht_cycle_detection_opmem.has_key? s_ob_name
         # This if-clause here has to be before the
         # ob.method(sym_avail).call(ht_cycle_detection_opmem)
         # because then it stops the infinite loop that ocurrs, when
         # A depends on B depends on C depends on A.
         fd_out=0.to_r
         return fd_out;
      end # if
      x=ob.method(sym_avail).call(ht_cycle_detection_opmem,fd_threshold)
      bn=binding()
      kibuvits_krl171_typecheck bn, [TrueClass,FalseClass,Float,Fixnum,Bignum,Rational], x
      fd_out=x
      if x.class==TrueClass
         fd_out=1
      else
         fd_out=0 if x.class==FalseClass
      end # if
      fd_out=fd_out.to_r
      return fd_out;
   end # fd_get_availability

   def ht_calculate_row(s_dependent_object_name,ht_row,
      ht_objects,sym_avail,ht_cycle_detection_opmem,fd_threshold)
      ar_ht_row_keys=ht_row.keys
      if KIBUVITS_krl171_b_DEBUG
         i_n_of_keys=ar_ht_row_keys.length
         if i_n_of_keys!=1
            kibuvits_krl171_throw("i_n_of_keys=="+i_n_of_keys.to_s+
            "\nGUID='047c3342-f26e-47b7-923f-c2c2f051a4e7'.")
         end # if
      end # if
      s_ix0_ob_name=ar_ht_row_keys[0]
      ht_out=Hash[s_ix0_ob_name,s_ix0_ob_name]
      fd_out=fd_get_availability(ht_objects,s_ix0_ob_name,sym_avail,
      ht_cycle_detection_opmem,fd_threshold)
      return ht_out if fd_threshold<=fd_out
      x_substs=ht_row[s_ix0_ob_name]
      return ht_out if x_substs==nil
      return ht_out if x_substs==""
      cl_x_substs=x_substs.class
      if cl_x_substs==String
         x_substs=[x_substs]
      else
         if cl_x_substs!=Array
            kibuvits_krl171_throw("cl_x_substs=="+cl_x_substs.to_s+
            "\nGUID='7e29b436-817e-48dd-b50f-c2c2f051a4e7'.")
         end # if
      end # if
      ar_subst=x_substs
      return ht_out if ar_subst.length==0
      # If none of the objects reach the threshold,
      # the ix_fd_out equals with the index of the object
      # that has the maximum threshold within this row.
      ix_fd_out=(-1) # === s_ix0_ob_name
      fd_ob_availability=nil
      s_ob_name=nil
      i_ar_subst_len=ar_subst.length
      i_ar_subst_len.times do |ix|
         s_ob_name=ar_subst[ix]
         fd_ob_availability=fd_get_availability(ht_objects,s_ob_name,sym_avail,
         ht_cycle_detection_opmem,fd_threshold)
         if fd_threshold<=fd_ob_availability
            ix_fd_out=ix
            break;
         end # if
         if fd_out<fd_ob_availability
            fd_out=fd_ob_availability
            ix_fd_out=ix
         end # if
      end # loop
      return ht_out if ix_fd_out==(-1)
      ht_out[s_ix0_ob_name]=ar_subst[ix_fd_out]
      return ht_out
   end # ht_calculate_row

   public

   #
   # Returns 2 parameters:
   #
   # ht_dependencies --- The keys match with the keys of the
   #                     ht_dependency_relations, except when the
   #                     ht_dependency_relations has at least one key and the
   #                     ht_cycle_detection_opmem contains the s_dependent_object_name
   #                     as one of its keys. The values are the names of the
   #                     dependencies that got selected.
   #
   #            fd_x --- Availability, which is of a floating point number type.
   #                     fd_x equals with the maximum threshold that
   #                     the availability of all of the selected objects
   #                     is equal to or greater, regardless of wether
   #                     fd_x is greater than or equal to the fd_threshold.
   #
   #  If the ht_cycle_detection_opmem does contain the s_dependent_object_name
   #  as one of its keys, then the ht_dependencies will be an empty hashtable.
   #
   # The fd_threshold must be greater than or equal to 0.
   #
   # The ht_objects has object names as keys and the objects as values.
   # The objects in the ht_objects must have a
   # method that corresponds to the s_or_sym_method.
   #
   # If the s_or_sym_method returns boolean values, then the
   # boolean values are interpreted so that the boolean true equals
   # 1 and the boolean false equals 0. The method that is
   # denoted by the s_or_sym_method must accept exactly two
   # parameters, which must be optional. First of the parameters is
   # of type Hash and optionally has a name of ht_cycle_detection_opmem.
   # The second of the parameters is the fd_threshold. The keys
   # of the ht_cycle_detection_opmem are object names and the
   # values of the ht_cycle_detection_opmem  are the objects.
   #
   # Cyclic dependencies ARE allowed, but if the availability
   # of the ht_objects[s_dependent_object_name] is determined
   # by its own availability, then the fd_x==0.
   # Due to the substitutions within the ht_dependency_relations
   # the existance of cyclic dependencies is dynamic, determined
   # at runtime. The cyclic paths that consist of more than
   # 2 nodes are detected by using the ht_cycle_detection_opmem.
   #
   # If the ht_objects[s_dependent_object_name] does not
   # depend on any of the other instances that are listed
   # in the ht_objects, i.e. if the
   # ht_dependency_relations.keys.size==0, then the
   # ar_get_availability_value(...) returns
   # ht_objects[s_dependent_object_name].method(s_or_sym_method).call
   #
   # The fd_threshold is related to substitutions.
   # For example, if
   #
   #     ht_dependency_relations=Hash["ob_2", ["ob_3","ob_4"] ]
   #
   # and
   #
   #     fd_threshold==60
   #
   # and
   #
   #     ht_objects["ob_2"].method(s_or_sym_method).call == 42
   #     ht_objects["ob_3"].method(s_or_sym_method).call == 73
   #     ht_objects["ob_4"].method(s_or_sym_method).call == 99
   #
   # i.e.
   #     "ob_2" => ["ob_3","ob_4"]
   #       42         73     99
   #
   # then the fd_x==73 , because 42 is smaller than the fd_threshold,
   # but the first substitution, the ht_objects["ob_2"], has an availability
   # value of 73 and 60<=73 . The reason, why the availability value of the
   # ht_objects["ob_3"] is used in stead of the availability value of the
   # ht_objects["ob_4"], is that the substitution order is determined by the
   # array indices, not availability values.
   #
   # Some code examples, illustrations, reside
   # within the Kibuvits_krl171_dependencymetrics_t1 selftests.
   #
   # It's OK for the ht_objects to miss some of the keys that
   # are represented within the ht_dependency_relations either as keys or
   # parts of the ht_dependency_relations values. The availability of instances
   # that are not represented within the ht_objects, is considered 0 (zero).
   #
   def fd_ht_get_availability(s_dependent_object_name,
      ht_dependency_relations,ht_objects,s_or_sym_method,
      ht_cycle_detection_opmem=Hash.new,fd_threshold=1)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_dependent_object_name
         kibuvits_krl171_typecheck bn, Hash, ht_dependency_relations
         verify_ht_dependency_relations_format(s_dependent_object_name,
         ht_dependency_relations)
         kibuvits_krl171_typecheck bn, Hash, ht_objects
         kibuvits_krl171_typecheck bn, [Symbol,String], s_or_sym_method
         if s_or_sym_method.class==String
            kibuvits_krl171_assert_string_min_length(bn,s_or_sym_method,1)
         end # if
         if ht_objects.size==0
            kibuvits_krl171_throw("ht_objects.size==0, but the ht_objects \n"+
            "must contain at least the dependent object."+
            ".\nGUID='21387820-3806-4b5c-a2ce-c2c2f051a4e7'.")
         end # if
         sym_avail=s_or_sym_method
         sym_avail=s_or_sym_method.to_sym if s_or_sym_method.class==String
         i_par_len=nil
         ht_objects.each_pair do |s_ob_name,ob|
            if !ob.respond_to? sym_avail
               kibuvits_krl171_throw("Object with the name "+s_ob_name+
               "  does not have a public method called "+sym_avail.to_s+
               "\nGUID='249b6548-2c2d-41a1-b29e-c2c2f051a4e7'.")
            else
               i_par_len=ob.method(sym_avail).parameters.length
               if i_par_len!=2
                  kibuvits_krl171_throw("Object with the name "+s_ob_name+
                  "  does have a public method called "+sym_avail.to_s+
                  ",\nbut the number of parameters of that method equals "+i_par_len.to_s+
                  ".\nGUID='17b34092-712a-4c1b-926e-c2c2f051a4e7'.")
               end # if
            end # if
         end # loop
         kibuvits_krl171_typecheck bn, Hash, ht_cycle_detection_opmem
         kibuvits_krl171_typecheck bn, [Float,Fixnum,Bignum,Rational], fd_threshold
         i_1=ht_dependency_relations.object_id
         i_2=ht_objects.object_id
         i_3=ht_cycle_detection_opmem.object_id
         if i_par_len!=2
            kibuvits_krl171_throw("Object with the name "+s_ob_name+
            "  does have a public method called "+sym_avail.to_s+
            ",\nbut the number of parameters of that method equals "+i_par_len.to_s+
            ".\nGUID='16feac2d-8b19-4be5-b33e-c2c2f051a4e7'.")
         end # if
      end # if KIBUVITS_krl171_b_DEBUG
      ht_out=Hash.new
      if fd_threshold<0
         kibuvits_krl171_throw("fd_threshold=="+fd_threshold.to_s+" < 0"+
         "\nGUID='872f2321-704d-404a-910e-c2c2f051a4e7'.")
      end # if
      if ht_dependency_relations.keys.size==0 # dependencies do not exist
         fd_out=fd_threshold
         return fd_out, ht_out
      end # if
      fd_out=0.to_r
      if ht_cycle_detection_opmem.has_key? s_dependent_object_name
         return fd_out, ht_out
      end # if
      if !ht_objects.has_key? s_dependent_object_name
         # There's no cycle, but according to the spec of this method
         # objects that are missing from the ht_objects are
         # considered to be un-available.
         return fd_out, ht_out
      end # if
      ht_cycle_detection_opmem[s_dependent_object_name]=ht_objects[s_dependent_object_name]
      fd_threshold=fd_threshold.to_r
      sym_avail=s_or_sym_method
      sym_avail=s_or_sym_method.to_sym if s_or_sym_method.class==String
      fd_out=(-1)
      ar_ht_dependency_relations_keys=ht_dependency_relations.keys
      if ar_ht_dependency_relations_keys.length==0
         fd_out=fd_get_availability(ht_objects,s_dependent_object_name,
         sym_avail,ht_cycle_detection_opmem,fd_threshold)
         ht_cycle_detection_opmem.delete(s_dependent_object_name)
         return fd_out, ht_out
      else
         ht_row=Hash.new
         ht_out_row=nil
         s_1=nil
         ht_dependency_relations.each_pair do |s_key,x_substs|
            ht_row[s_key]=x_substs
            ht_out_row=ht_calculate_row(s_dependent_object_name,ht_row,
            ht_objects,sym_avail,ht_cycle_detection_opmem,fd_threshold)
            s_1=ht_out_row.keys[0]
            if KIBUVITS_krl171_b_DEBUG
               if s_1!=s_key
                  kibuvits_krl171_throw("s_1=="+s_1.to_s+",  s_key=="+s_key.to_s+
                  "\nGUID='a331c94e-a0b1-4781-a2dd-c2c2f051a4e7'.")
               end # if
            end # if
            ht_out[s_1]=ht_out_row[s_1]
            ht_row.clear
         end # loop
      end # if
      ar_subst_names=ht_out.values
      s_1=ar_subst_names[0] # guaranteed to have at least one element here
      fd_out=fd_get_availability(ht_objects,s_1,sym_avail,
      ht_cycle_detection_opmem,fd_threshold)
      fd_ob_availability=nil
      ar_subst_names.each do |s_ob_name|
         if s_ob_name==s_dependent_object_name
            fd_out=0
            break
         end # if
         fd_ob_availability=fd_get_availability(ht_objects,s_ob_name,sym_avail,
         ht_cycle_detection_opmem,fd_threshold)
         fd_out=fd_ob_availability if fd_ob_availability<fd_out
      end # loop
      if fd_out<0
         kibuvits_krl171_throw("fd_out=="+fd_out.to_s+" < 0 "+
         "\nGUID='79689943-548e-48fe-a4ad-c2c2f051a4e7'.")
      end # if
      ht_cycle_detection_opmem.delete(s_dependent_object_name)
      return fd_out, ht_out
   end # fd_ht_get_availability

   def Kibuvits_krl171_dependencymetrics_t1.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method, ht_cycle_detection_opmem=Hash.new, fd_threshold=1.0)

      fd_x,ht_dependencies=Kibuvits_krl171_dependencymetrics_t1.instance.fd_ht_get_availability(
      s_dependent_object_name,ht_dependency_relations,ht_objects,
      s_or_sym_method, ht_cycle_detection_opmem, fd_threshold)

      return fd_x,ht_dependencies
   end # Kibuvits_krl171_dependencymetrics_t1.fd_ht_get_availability

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_dependencymetrics_t1
#=================kibuvits_krl171_dependencymetrics_t1_rb_end=====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_dependencymetrics_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_coords_rb_start=============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_coords_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ix.rb"

#==========================================================================

# The class Kibuvits_krl171_coords is a namespace for coordinate
# conversion/calculation related code.
class Kibuvits_krl171_coords

   def initialize
   end # initialize

   # The material at the following address was really helpful:
   # http://geographyworldonline.com/tutorial/instructions.html
   #
   # This function returns 2 whole numbers, i_x, i_y, where
   # 0<=i_x<=(i_world_map_width-1)
   # 0<=i_y<=(i_world_map_height-1)
   def x_latitude_and_longitude_2_world_map_x_y_t1(fd_latitude,fd_longitude,
      i_world_map_width,i_world_map_height)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Rational,Float,Bignum], fd_latitude
         kibuvits_krl171_typecheck bn, [Fixnum,Rational,Float,Bignum], fd_longitude
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_world_map_width
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_world_map_height
      end # if KIBUVITS_krl171_b_DEBUG
      if (90<fd_latitude)
         msg="90< fd_latitude=="+fd_latitude.to_s
         kibuvits_krl171_throw(msg)
      end # if
      if (180<fd_longitude)
         msg="180 < fd_longitude=="+fd_longitude.to_s
         kibuvits_krl171_throw(msg)
      end # if
      if (fd_latitude<(-90))
         msg="fd_latitude=="+fd_latitude.to_s+" < (-90) "
         kibuvits_krl171_throw(msg)
      end # if
      if (fd_longitude<(-180))
         msg="fd_longitude=="+fd_longitude.to_s+" < (-180) "
         kibuvits_krl171_throw(msg)
      end # if

      if (i_world_map_width<1)
         msg="i_world_map_width=="+i_world_map_width.to_s+" < 1 "
         kibuvits_krl171_throw(msg)
      end # if
      if (i_world_map_height<1)
         msg="i_world_map_height=="+i_world_map_height.to_s+" < 1 "
         kibuvits_krl171_throw(msg)
      end # if

      fd_lat=fd_latitude.to_r # North-wards, [-90,90]
      fd_long=fd_longitude.to_r # East-wards [-180,180]
      # The North pole and "East pole" (from England) are with
      # positive values. The general idea of the calculations:
      # http://urls.softf1.com/a1/krl/frag2/
      fd_r=(i_world_map_height*1.0)/2
      fd_sin_alpha=Math.sin(fd_lat)
      #fd_cos_alpha=Math.cos(fd_lat)
      #fd_r2=fd_r*fd_cos_alpha
      fd_h2=fd_r*fd_sin_alpha
      i_y=(fd_r-fd_h2).to_f.round(0)
      fd_w2=(i_world_map_width*1.0)/2
      fd_2=fd_long/180.0
      i_x=(fd_w2+(fd_2*fd_w2)).to_f.round(0)

      i_x=i_world_map_width-1 if (i_world_map_width-1)<i_x
      i_y=i_world_map_height-1 if (i_world_map_height-1)<i_y
      i_x=0 if i_x<0
      i_y=0 if i_y<0
      return i_x,i_y
   end # x_latitude_and_longitude_2_world_map_x_y_t1


   def Kibuvits_krl171_coords.x_latitude_and_longitude_2_world_map_x_y_t1(
      fd_latitude,fd_longitude,i_world_map_width,i_world_map_height)
      i_x,i_y=Kibuvits_krl171_coords.instance.x_latitude_and_longitude_2_world_map_x_y_t1(
      fd_latitude,fd_longitude,i_world_map_width,i_world_map_height)
      return i_x,i_y
   end # Kibuvits_krl171_coords.x_latitude_and_longitude_2_world_map_x_y_t1

   #----------------------------------------------------------------------

   def i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_initial_width
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_initial_height
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_new_edge_length
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_scale_by_width
      end # if
      kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
      1,[i_initial_width,i_initial_height,i_new_edge_length],
      "\nGUID=='5d4e083d-3bef-485e-b17d-c2c2f051a4e7'\n")

      i_width_out=i_initial_width
      i_height_out=i_initial_height
      if b_scale_by_width
         if i_initial_width==i_new_edge_length
            return i_width_out,i_height_out
         end # if
      else
         if i_initial_height==i_new_edge_length
            return i_width_out,i_height_out
         end # if
      end # if

      # To keep the calculations that take place after the
      # call to this function more effective, the output of
      # this function is partly enforced to be in Fixnum format.
      fd_width_0=nil
      fd_height_0=nil
      fd_width_1=nil
      fd_height_1=nil
      fd_len_new=nil
      fd_ref=640000.0
      b_use_Float=false
      if (i_initial_width<fd_ref)&&(i_initial_height<fd_ref)&&(i_new_edge_length<fd_ref)
         fd_width_0=i_initial_width.to_f
         fd_height_0=i_initial_height.to_f
         fd_len_new=i_new_edge_length.to_f
         b_use_Float=true
      else
         fd_width_0=i_initial_width.to_r
         fd_height_0=i_initial_height.to_r
         fd_len_new=i_new_edge_length.to_r
      end # if

      if b_scale_by_width
         fd_new_dev_old=fd_len_new/fd_width_0
         fd_width_1=fd_len_new
         fd_height_1=fd_height_0*fd_new_dev_old
      else
         fd_new_dev_old=fd_len_new/fd_height_0
         fd_width_1=fd_width_0*fd_new_dev_old
         fd_height_1=fd_len_new
      end # if
      i_width_out=fd_width_1.round.to_i
      i_height_out=fd_height_1.round.to_i

      i_width_out=1 if i_width_out==0
      i_height_out=1 if i_height_out==0
      return i_width_out,i_height_out
   end # i_i_scale_rectangle

   def Kibuvits_krl171_coords.i_i_scale_rectangle(i_initial_width,i_initial_height,
      i_new_edge_length,b_scale_by_width)
      i_width_out,i_height_out=Kibuvits_krl171_coords.instance.i_i_scale_rectangle(
      i_initial_width,i_initial_height,i_new_edge_length,b_scale_by_width)
      return i_width_out,i_height_out
   end # Kibuvits_krl171_coords.i_i_scale_rectangle

   #----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_krl171_coords
#=====================kibuvits_krl171_coords_rb_end===============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_coords_rb_start".
#==========================================================================

#=====================kibuvits_krl171_comments_detector_rb_start==================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_comments_detector_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
#require KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ix.rb"

#==========================================================================

class Kibuvits_krl171_comments_detector
   private
   def init_multiliner_ht
      @ht_multiliner=Hash.new

      ht_cpp=Hash.new
      ht_cpp[@lc_start_tag]="/*"
      ht_cpp[@lc_end_tag]="*/"
      ar_cpp=[ht_cpp]

      @ht_multiliner["c"]=ar_cpp
      @ht_multiliner["c++"]=ar_cpp
      @ht_multiliner["c#"]=ar_cpp

      ht_haskell1=Hash.new
      ht_haskell1[@lc_start_tag]="{-"
      ht_haskell1[@lc_end_tag]="-}"
      ar_haskell=[ht_haskell1]
      @ht_multiliner["haskell"]=ar_haskell

      @ht_multiliner["java"]=ar_cpp
      @ht_multiliner["javascript"]=ar_cpp
      @ht_multiliner["php"]=ar_cpp

      ht_ruby1=Hash.new
      ht_ruby1[@lc_start_tag]="=begin"
      ht_ruby1[@lc_end_tag]="=end"
      ar_ruby=[ht_ruby1]
      @ht_multiliner["ruby"]=ar_ruby

      ht_python1=Hash.new
      ht_python1[@lc_start_tag]="'''"
      ht_python1[@lc_end_tag]=ht_python1[@lc_start_tag]
      ar_python=[ht_python1]
      #----
      ht_python2=Hash.new
      ht_python2[@lc_start_tag]="\"\"\""
      ht_python2[@lc_end_tag]=ht_python2[@lc_start_tag]
      ar_python<<ht_python2
      @ht_multiliner["python"]=ar_python

      ht_bash1=Hash.new
      ht_bash1[@lc_start_tag]=": << 'A_BASH_HEREDOCHACK_TAG'"
      ht_bash1[@lc_end_tag]="A_BASH_HEREDOCHACK_TAG"
      ar_ruby=[ht_bash1]
      # The bash heredoc tags have to be at the
      # start of the line like the Ruby heredoc tags.
      #
      # Credits for the Bash heredoc hack go to
      # http://unix.stackexchange.com/questions/37411/multiline-shell-script-comments-how-does-this-work
      @ht_multiliner["bash"]=ar_ruby

      ht_xml1=Hash.new
      ht_xml1[@lc_start_tag]="<!--"
      ht_xml1[@lc_end_tag]="-->"
      ar_xml=[ht_xml1]
      @ht_multiliner["xml"]=ar_xml
      @ht_multiliner["html"]=ar_xml

      ht_reduce_1=Hash.new
      ht_reduce_1[@lc_start_tag]="COMMENT"
      ht_reduce_1[@lc_end_tag]=";"
      ht_reduce_2=Hash.new
      ht_reduce_2[@lc_start_tag]="COMMENT"
      ht_reduce_2[@lc_end_tag]="$"
      ar_reduce=[ht_reduce_1,ht_reduce_2] # TODO: read the code and verify that it works as expected
      @ht_multiliner["reduce"]=ar_reduce # The REDUCE Computer Algebra System


      ht_htaccess=Hash.new
      ht_htaccess[@lc_start_tag]="===HACK===ThE_htaccess_does_noT_hAvE_muLtIliNe_comMenTs_START==="
      ht_htaccess[@lc_end_tag]="===HACK===ThE_htaccess_does_noT_hAvE_muLtIliNe_comMenTs_END==="
      ar_htaccess=[ht_htaccess]
      @ht_multiliner["htaccess"]=ar_htaccess

      ht_testlanguage_for_selftests_1=Hash.new
      ht_testlanguage_for_selftests_1[@lc_start_tag]="\"y"
      ht_testlanguage_for_selftests_1[@lc_end_tag]="\"z"
      @ht_multiliner["testlanguage_for_selftests_1"]=[ht_testlanguage_for_selftests_1]
   end # init_multiliner_ht


   def init_singleliner_ht
      @ht_singleliner=Hash.new

      ht_cpp=Hash.new
      ht_cpp[@lc_start_tag]="//"
      ht_cpp[@lc_end_tag]=$kibuvits_krl171_lc_emptystring
      ar_cpp_liner=[ht_cpp]

      ht_bash=Hash.new
      ht_bash[@lc_start_tag]="#"
      ht_bash[@lc_end_tag]=$kibuvits_krl171_lc_emptystring
      ar_bash_liner=[ht_bash]

      ht_haskell=Hash.new
      ht_haskell[@lc_start_tag]="--"
      ht_haskell[@lc_end_tag]=$kibuvits_krl171_lc_emptystring
      ar_haskell_liner=[ht_haskell]

      ht_batch=Hash.new
      ht_batch[@lc_start_tag]=" rem " # The Windows bat files.
      ht_batch[@lc_end_tag]=$kibuvits_krl171_lc_emptystring
      ar_batch_liner=[ht_batch]

      ht_reduce=Hash.new
      ht_reduce[@lc_start_tag]="%"
      ht_reduce[@lc_end_tag]=$kibuvits_krl171_lc_emptystring
      ar_reduce_liner=[ht_reduce] # The REDUCE Computer Algebra System

      @ht_singleliner["haskell"]=ar_haskell_liner
      @ht_singleliner["ruby"]=ar_bash_liner
      @ht_singleliner["python"]=ar_bash_liner
      @ht_singleliner["bash"]=ar_bash_liner
      @ht_singleliner["batch"]=ar_batch_liner
      @ht_singleliner["c++"]=ar_cpp_liner
      @ht_singleliner["c#"]=ar_cpp_liner
      @ht_singleliner["c"]=ar_cpp_liner
      @ht_singleliner["html"]=ar_cpp_liner # hack to support HTML at Renessaator
      @ht_singleliner["php"]=ar_cpp_liner
      @ht_singleliner["javascript"]=ar_cpp_liner
      @ht_singleliner["java"]=ar_cpp_liner
      @ht_singleliner["reduce"]=ar_reduce_liner # The REDUCE Computer Algebra System
      @ht_singleliner["htaccess"]=ar_bash_liner

      ht_testlanguage_for_selftests_1=Hash.new
      ht_testlanguage_for_selftests_1[@lc_start_tag]="\"\""
      ht_testlanguage_for_selftests_1[@lc_end_tag]=$kibuvits_krl171_lc_emptystring
      @ht_singleliner["testlanguage_for_selftests_1"]=[ht_testlanguage_for_selftests_1]

      # @ht_singleliner["xml"]=[] # XML and HTML do not have single-liner comment tags.
   end # init_singleliner_ht

   def init_stringmarks_ht
      @ht_stringmarks=Hash.new

      ht_cpp1=Hash.new
      ht_cpp1[@lc_start_tag]="\""
      ht_cpp1[@lc_end_tag]="\""
      ar_cpp=[ht_cpp1]

      ht_php1=Hash.new
      ht_php1[@lc_start_tag]="\""
      ht_php1[@lc_end_tag]="\""
      ht_php2=Hash.new
      ht_php2[@lc_start_tag]="'"
      ht_php2[@lc_end_tag]="'"
      ar_php=[ht_php1, ht_php2]

      @ht_stringmarks["c"]=ar_cpp
      @ht_stringmarks["c++"]=ar_cpp
      @ht_stringmarks["c#"]=ar_cpp
      @ht_stringmarks["bash"]=ar_php
      @ht_stringmarks["batch"]=ar_cpp
      @ht_stringmarks["haskell"]=ar_cpp

      # Java has the character type: char a='b';
      # With the ar_cpp the problems might occur, if the Java
      # code contains something like: char a='"';
      @ht_stringmarks["java"]=ar_php

      @ht_stringmarks["javascript"]=ar_php
      @ht_stringmarks["php"]=ar_php
      @ht_stringmarks["ruby"]=ar_php
      @ht_stringmarks["xml"]=ar_php
      @ht_stringmarks["html"]=ar_php

      # TODO: The REDUCE Computer Algebra System has some really
      # weird rules for strinc escaping. In REDUCE one
      # writes """" stead of  the "\"" , i.e. (") is used
      # in stead of the (\) for escaping. One must update the source
      # to make it work properly.
      @ht_stringmarks["reduce"]=ar_cpp

      @ht_stringmarks["htaccess"]=ar_php

      ht_testlanguage_for_selftests_1=Hash.new
      ht_testlanguage_for_selftests_1[@lc_start_tag]="'"
      ht_testlanguage_for_selftests_1[@lc_end_tag]="\"xx"
      @ht_stringmarks["testlanguage_for_selftests_1"]=[ht_testlanguage_for_selftests_1]
   end # init_stringmarks_ht

   # The use of the local constant instances allows one to reduce memory
   # consumption and avoid repetitive string instantiation.
   # One way, how the amount of memory is saved is by letting the ht_comment
   # instances share their key instances and some of their value instances.
   def init_local_constants
      @lc_start_tag='start_tag'
      @lc_end_tag='end_tag'
      @lc_start_column='start_column'
      @lc_end_column='end_column'
      @lc_only_tabs_and_spaces_before_comment='only_tabs_and_spaces_before_comment'
      @lc_comment='comment'

      @lc_state_in_string=1
      @lc_state_in_search=2
      @lc_state_in_singleliner=3
      @lc_state_in_multiliner=4
      @lc_s_lang='s_lang'
      @lc_state='state'
      @lc_ar_out='ar_out'
      @lc_msgcs='msgc'
      @lc_cursor_index='cursor_index'
      @lc_s_line='s_line'
      @lc_type='type'
      @lc_line_number='line_number'
      @lc_start_line_number='start_line_number'
      @lc_end_line_number='end_line_number'
      @lc_singleliner='singleliner'
      @lc_multiliner='multiliner'
      @lc_ht_comment='ht_comment'

      @lc_ht_stringmark='ht_stringmark'
      @lc_ht_singleliner='ht_singleliner'
      @lc_ht_multiliner='ht_multiliner'
      @lc_ht_tag='ht_tag'
      @lc_ix='ix'
      @lc_ar_ix='ar_ix'
      @lc_ar_ht='ar_ht'
      @lc_ht_comment_keys='ht_comment_keys'
      @lc_ht_comment_tags='ht_comment_tags'
   end # init_local_constants

   def debug_state2str i_state
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), Fixnum, i_state
      end # if
      s_out=$kibuvits_krl171_lc_emptystring
      case i_state
      when 1
         s_out="in_string"
      when 2
         s_out="in_search"
      when 3
         s_out="in_singleliner"
      when 4
         s_out="in_multiliner"
      else
         kibuvits_krl171_throw "i_state=="+i_state.to_s
      end
      return s_out
   end # debug_state2str

   public
   def initialize
      init_local_constants
      init_multiliner_ht
      init_singleliner_ht
      init_stringmarks_ht
      @ht_tags=Hash.new
      @ht_tags[@lc_ht_stringmark]=@ht_stringmarks
      @ht_tags[@lc_ht_singleliner]=@ht_singleliner
      @ht_tags[@lc_ht_multiliner]=@ht_multiliner
      @rgx_nonspacestabs=Regexp.new("[^\s\t]")
   end #initialize

   private
   def create_ht_comment ht_opmem
      # The idea behind the ht_comment_keys is that
      # by using a separate set of hashtable key strings with
      # every Kibuvits_krl171_comments_detector.run call,
      # the manipulation of the instances that were
      # output by one of the calls tho the Kibuvits_krl171_comments_detector.run
      # does not influence the output of other calls to the
      # Kibuvits_krl171_comments_detector.run.
      #
      # If the ht_comment instances share the instances that are
      # used as the hashtable keys, then there's probably
      # also a considerable memory saving. The assumption
      # is that every call to the Kibuvits_krl171_comments_detector.run
      # produces a "lot" of ht_comment instances that
      # each has more than one key. Such a detailed
      # ht_comment content is used for comfort.
      ht_comment_keys=ht_opmem[@lc_ht_comment_keys]
      ht_comment=Hash.new
      ht_comment[ht_comment_keys[@lc_comment]]=$kibuvits_krl171_lc_emptystring # due to the + operator
      ht_comment[ht_comment_keys[@lc_end_column]]=nil
      ht_comment[ht_comment_keys[@lc_end_line_number]]=nil
      ht_comment[ht_comment_keys[@lc_end_tag]]=nil
      ht_comment[ht_comment_keys[@lc_only_tabs_and_spaces_before_comment]]=nil
      ht_comment[ht_comment_keys[@lc_start_column]]=nil
      ht_comment[ht_comment_keys[@lc_start_line_number]]=nil
      ht_comment[ht_comment_keys[@lc_start_tag]]=nil
      ht_comment[ht_comment_keys[@lc_type]]=nil
      ht_opmem[@lc_ht_comment]=ht_comment
   end # create_ht_comment


   def al_get_smallest_start_index_per_tagtype s_tagselector, ht_opmem
      s_line=ht_opmem[@lc_s_line]
      s_lang=ht_opmem[@lc_s_lang]
      cursor_index=ht_opmem[@lc_cursor_index]
      ar_tags=(@ht_tags[s_tagselector])[s_lang]
      ar_ix=ht_opmem[@lc_ar_ix]
      ar_ix.clear
      x=nil
      ar_tags.each do |ht_tag|
         x=s_line.index(ht_tag[@lc_start_tag], cursor_index)
         ar_ix << [x, ht_tag] if x!=nil
      end # loop
      ar_ix.sort! { |a, b| a[0]<=>b[0] }
      ht_container=ht_opmem[s_tagselector]
      if 0<ar_ix.length
         ht_container[@lc_ix]=(ar_ix[0])[0]
         ht_container[@lc_ht_tag]=(ar_ix[0])[1]
      else
         ht_container[@lc_ix]=s_line.length # == <loop exit condition>
         ht_container[@lc_ht_tag]=nil
      end # if
   end # al_get_smallest_start_index_per_tagtype

   def al_get_smallest_start_index ht_opmem
      al_get_smallest_start_index_per_tagtype @lc_ht_stringmark, ht_opmem
      al_get_smallest_start_index_per_tagtype @lc_ht_singleliner, ht_opmem
      al_get_smallest_start_index_per_tagtype @lc_ht_multiliner, ht_opmem
      ar_ht=ht_opmem[@lc_ar_ht]
      ar_ht.sort! { |a, b| a[@lc_ix]<=>b[@lc_ix] }
   end # al_get_smallest_start_index

   def get_current_ht_tag ht_opmem
      ht_container=(ht_opmem[@lc_ar_ht])[0]
      kibuvits_krl171_throw "ar_ht[0]==nil" if  ht_container==nil
      ht_tag=ht_container[@lc_ht_tag]
      kibuvits_krl171_throw "ht_tag==nil" if  ht_tag==nil
      return ht_tag
   end # get_current_ht_tag


   def al_state_in_search ht_opmem
      al_get_smallest_start_index ht_opmem
      ht_container=(ht_opmem[@lc_ar_ht])[0]
      #s_type=ht_container[@lc_type]
      s_line=ht_opmem[@lc_s_line]
      s_line_length=s_line.length
      if ht_container[@lc_ix]==s_line_length # == <no start tags found>
         ht_opmem[@lc_cursor_index]=s_line_length
         return
      end # if
      ix=ht_container[@lc_ix]
      s_start_tag=(ht_container[@lc_ht_tag])[@lc_start_tag]
      ht_opmem[@lc_cursor_index]=ix+s_start_tag.length
      if s_line_length<ht_opmem[@lc_cursor_index]
         kibuvits_krl171_throw "\ns_line_length=="+s_line_length.to_s+" < cursor_index=="+
         ht_opmem[@lc_cursor_index].to_s+" line_number=="+
         ht_opmem[@lc_line_number].to_s+" start_tag==\""+
         s_start_tag+"\"\nline==\""+s_line+"\"\n"
      end # if
      s_tag_type=ht_container[@lc_type]
      case s_tag_type
      when @lc_ht_stringmark
         ht_opmem[@lc_state]=@lc_state_in_string
      when @lc_ht_singleliner
         ht_opmem[@lc_state]=@lc_state_in_singleliner
      when @lc_ht_multiliner
         ht_opmem[@lc_state]=@lc_state_in_multiliner # j2rg
      else
         kibuvits_krl171_throw "al_state_in_search err1"
      end # case
   end # al_state_in_search

   #-----------------------------------------------

   def al_state_in_string ht_opmem
      ht_tag=get_current_ht_tag ht_opmem
      s_line=ht_opmem[@lc_s_line]
      cursor_index=ht_opmem[@lc_cursor_index]
      s_end_tag=ht_tag[@lc_end_tag]
      s_start_tag=ht_tag[@lc_start_tag]
      msgcs=ht_opmem[@lc_msgcs]
      if KIBUVITS_krl171_b_DEBUG
         if s_start_tag.include? "\\"
            msgcs.cre("A string start tag is not allowed to contain "+
            "the escape character. start_tag==\""+s_start_tag+"\".",3.to_s)
         end # if
      end # if
      x=s_line.index(s_end_tag, cursor_index)
      if x!=nil
         # A sample case that the following code is also expected
         # to work with is where the end tag is "nono" and the s_line
         # from curson_index onwards is "nonono" and
         # s_line[(cursor_index-1)..(cursor_index-1)]=="\". This
         # escapes the first "n" in the "nonono", leaving "onono" as
         # the part of the s_line that might contain the end tag.
         s_end_tag_chr0=s_end_tag[0..0]
         b_end_tag_schr0_is_escapable=Kibuvits_krl171_str.character_is_escapable(
         s_end_tag_chr0)
         if (!b_end_tag_schr0_is_escapable)||(x==cursor_index)
            # The x==cursor_index marks an empty string. The empty
            # string case can be illustrated by an '-quoted string
            # like ''.
            ht_opmem[@lc_cursor_index]=x+s_end_tag.length
            ht_opmem[@lc_state]=@lc_state_in_search
         else
            if Kibuvits_krl171_str.character_is_escaped(s_line,x)
               ht_opmem[@lc_cursor_index]=x+1
            else
               ht_opmem[@lc_cursor_index]=x+s_end_tag.length
               ht_opmem[@lc_state]=@lc_state_in_search
            end # if
         end # if
      else
         ht_opmem[@lc_cursor_index]=s_line.length # line analyzing loop exit
      end # if
   end # al_state_in_string

   def consists_of_only_tabs_and_spaces_t1 s_left, s_start_tag
      i_s_leftlen=s_left.length
      i_s_start_taglen=s_start_tag.length
      kibuvits_krl171_throw "s_start_tag.length==0" if i_s_start_taglen==0
      if i_s_leftlen<i_s_start_taglen
         kibuvits_krl171_throw "s_left.length=="+i_s_leftlen.to_s+"<s_start_tag.length=="+
         i_s_start_taglen.to_s
      end # if
      if i_s_start_taglen<i_s_leftlen # most common case
         s_cl=Kibuvits_krl171_str.clip_tail_by_str(s_left,s_start_tag)
         if i_s_leftlen<=s_cl.length
            kibuvits_krl171_throw "Tail clipping by s_start_tag(=="+s_start_tag+
            ") did not occur. s_cl==("+s_cl+")."
         end # if
         md=@rgx_nonspacestabs.match(s_cl)
         b_out=(md==nil)
         return b_out
      end # if
      if s_left!=s_start_tag
         kibuvits_krl171_throw "\ns_left.length==s_start_tag.length=="+i_s_leftlen.to_s+
         " , but s_left==("+s_left+")!=s_start_tag==("+s_start_tag+").\n"
      end # if
      return true # "" consists of only at most spaces and tabs
   end # consists_of_only_tabs_and_spaces_t1

   def al_state_in_singleliner ht_opmem
      ht_comment=ht_opmem[@lc_ht_comment]
      ht_comment_keys=ht_opmem[@lc_ht_comment_keys]
      ht_container=(ht_opmem[@lc_ar_ht])[0]
      i_cursor_index=ht_opmem[@lc_cursor_index] # resides after the start tag
      s_line=ht_opmem[@lc_s_line]
      i_line_number=ht_opmem[@lc_line_number]
      ht_comment_tags=ht_opmem[@lc_ht_comment_tags]
      ar_out=ht_opmem[@lc_ar_out]

      ht_tag=ht_container[@lc_ht_tag]
      s_start_tag=ht_tag[@lc_start_tag] # == <singleliner comment mark>
      s_end_tag=ht_tag[@lc_end_tag]
      s_left,s_right=Kibuvits_krl171_ix.bisect_at_sindex s_line, i_cursor_index
      b1=consists_of_only_tabs_and_spaces_t1 s_left, s_start_tag
      i_s_linelen=s_line.length

      ht_comment[ht_comment_keys[@lc_comment]]=s_right
      ht_comment[ht_comment_keys[@lc_end_column]]=i_s_linelen
      ht_comment[ht_comment_keys[@lc_end_line_number]]=i_line_number
      ht_comment[ht_comment_keys[@lc_end_tag]]=ht_comment_tags[s_end_tag]
      ht_comment[ht_comment_keys[@lc_only_tabs_and_spaces_before_comment]]=b1
      ht_comment[ht_comment_keys[@lc_start_column]]=i_cursor_index
      ht_comment[ht_comment_keys[@lc_start_line_number]]=i_line_number
      ht_comment[ht_comment_keys[@lc_start_tag]]=ht_comment_tags[s_start_tag]
      ht_comment[ht_comment_keys[@lc_type]]=ht_comment_keys[@lc_singleliner]

      ar_out << ht_comment
      create_ht_comment ht_opmem
      ht_opmem[@lc_cursor_index]=i_s_linelen # == <the end of line>
      ht_opmem[@lc_state]=@lc_state_in_search
   end # al_state_in_singleliner

   #-----------------------------------------------

   def al_state_in_multiliner_search_for_end_of_comment ht_opmem
      ht_comment=ht_opmem[@lc_ht_comment]
      ht_comment_keys=ht_opmem[@lc_ht_comment_keys]
      i_cursor_index=ht_opmem[@lc_cursor_index]
      s_line=ht_opmem[@lc_s_line]
      i_line_number=ht_opmem[@lc_line_number]

      i_s_linelen=s_line.length
      s_end_tag=ht_comment[@lc_end_tag]
      i_s_end_taglen=s_end_tag.length
      kibuvits_krl171_throw "s_end_tag.length<1" if i_s_end_taglen<1
      s_left,s_right=Kibuvits_krl171_ix.bisect_at_sindex s_line, i_cursor_index
      i_ix=s_right.index(s_end_tag)
      if i_ix==nil
         ht_opmem[@lc_cursor_index]=i_s_linelen # == <the end of line>
         ht_comment[ht_comment_keys[@lc_comment]]=ht_comment[@lc_comment]+
         s_right+"\n"
      else
         ht_comment[ht_comment_keys[@lc_comment]]=ht_comment[@lc_comment]+
         Kibuvits_krl171_ix.sar(s_right,0,i_ix)
         ht_comment[ht_comment_keys[@lc_end_column]]=i_cursor_index+i_ix
         ht_comment[ht_comment_keys[@lc_end_line_number]]=i_line_number
         ht_opmem[@lc_cursor_index]=i_cursor_index+i_ix+i_s_end_taglen

         ar_out=ht_opmem[@lc_ar_out]
         ar_out << ht_comment
         create_ht_comment ht_opmem
         ht_opmem[@lc_state]=@lc_state_in_search
      end # if
   end # al_state_in_multiliner_search_for_end_of_comment

   def al_state_in_multiliner_mark_comment_start ht_opmem
      ht_comment=ht_opmem[@lc_ht_comment]
      ht_comment_keys=ht_opmem[@lc_ht_comment_keys]
      ht_container=(ht_opmem[@lc_ar_ht])[0]
      i_cursor_index=ht_opmem[@lc_cursor_index] # resides after the start tag
      s_line=ht_opmem[@lc_s_line]
      i_line_number=ht_opmem[@lc_line_number]
      ht_comment_tags=ht_opmem[@lc_ht_comment_tags]

      ht_tag=ht_container[@lc_ht_tag]
      s_start_tag=ht_tag[@lc_start_tag] # == <multiliner start mark>
      s_end_tag=ht_tag[@lc_end_tag]
      kibuvits_krl171_throw "s_start_tag.length<1" if s_start_tag.length<1
      kibuvits_krl171_throw "s_end_tag.length<1" if s_end_tag.length<1
      s_left,s_right=Kibuvits_krl171_ix.bisect_at_sindex s_line, i_cursor_index
      b1=consists_of_only_tabs_and_spaces_t1 s_left, s_start_tag
      i_s_linelen=s_line.length

      ht_comment[ht_comment_keys[@lc_end_tag]]=ht_comment_tags[s_end_tag]
      ht_comment[ht_comment_keys[@lc_only_tabs_and_spaces_before_comment]]=b1
      ht_comment[ht_comment_keys[@lc_start_column]]=i_cursor_index
      ht_comment[ht_comment_keys[@lc_start_line_number]]=i_line_number
      ht_comment[ht_comment_keys[@lc_start_tag]]=ht_comment_tags[s_start_tag]
      ht_comment[ht_comment_keys[@lc_type]]=ht_comment_keys[@lc_multiliner]
   end # al_state_in_multiliner_mark_comment_start

   def al_state_in_multiliner ht_opmem
      ht_comment=ht_opmem[@lc_ht_comment]
      if ht_comment[@lc_start_tag]==nil
         al_state_in_multiliner_mark_comment_start ht_opmem
         al_state_in_multiliner_search_for_end_of_comment ht_opmem
      else
         al_state_in_multiliner_search_for_end_of_comment ht_opmem
      end # if
   end # al_state_in_multiliner

   #-----------------------------------------------

   def analyze_line ht_opmem
      state=nil
      s_line=ht_opmem[@lc_s_line]
      s_line_length=s_line.length
      msgcs=ht_opmem[@lc_msgcs]
      while ht_opmem[@lc_cursor_index]<s_line_length
         state=ht_opmem[@lc_state]
         case state
         when @lc_state_in_string
            al_state_in_string ht_opmem
         when @lc_state_in_search
            al_state_in_search ht_opmem
         when @lc_state_in_singleliner
            al_state_in_singleliner ht_opmem
         when @lc_state_in_multiliner
            al_state_in_multiliner ht_opmem
         else
            kibuvits_krl171_throw "State not supported. state=="+state.to_s
         end # case
         return if msgcs.b_failure
         if ht_opmem[@lc_state]==@lc_state_in_singleliner
            # The next line is for single-liner comments
            # that are empty strings.
            al_state_in_singleliner(ht_opmem)
         end # if
      end # loop
      state=ht_opmem[@lc_state]
      if state==@lc_state_in_singleliner
         kibuvits_krl171_throw "state_in_singleliner, "+
         'GUID=="f7db7056-1108-4766-a1f3-c2c2f051a4e7" '
      end # if
      if state==@lc_state_in_string
         ht_opmem[@lc_state]=@lc_state_in_search
         ht_container=(ht_opmem[@lc_ar_ht])[0]
         s="\nIn analyze_line the line ended in the "+
         "state @lc_state_in_string \n"+
         'GUID=="d4177f29-972a-4c68-9293-c2c2f051a4e7", '+
         'line_number=='+(ht_opmem[@lc_line_number]).to_s+
         ",\nstring start token =="+
         ((ht_container[@lc_ht_tag])[@lc_start_tag]).to_s+
         "\ns_line==("+s_line+")\n"
         msgcs.cre s,4.to_s
         msgcs.last.b_failure=false
      end # if
   end # analyze_line

   def create_ht_opmem_ht_comment_tags ht_opmem,ht_xliner
      ht_comment_tags=ht_opmem[@lc_ht_comment_tags]
      ht_xliner.each_key do |s_lang|
         ar_of_ht=ht_xliner[s_lang]
         ar_of_ht.each do |ht_startend|
            x=$kibuvits_krl171_lc_emptystring+ht_startend[@lc_start_tag]
            ht_comment_tags[x]=x
            x=$kibuvits_krl171_lc_emptystring+ht_startend[@lc_end_tag]
            ht_comment_tags[x]=x
         end # loop
      end # loop
   end # create_ht_opmem_ht_comment_tags

   def create_ht_opmem s_lang, msgcs, ar_out
      ht_opmem=Hash.new
      ht_opmem[@lc_s_lang]=s_lang
      ht_opmem[@lc_state]=@lc_state_in_search
      ht_opmem[@lc_ar_out]=ar_out
      ht_opmem[@lc_msgcs]=msgcs
      ht_opmem[@lc_line_number]=0

      ar_ix=Array.new
      ht_opmem[@lc_ar_ix]=ar_ix

      ht_stringmark=Hash.new
      ht_stringmark[@lc_type]=@lc_ht_stringmark
      ht_opmem[@lc_ht_stringmark]=ht_stringmark
      ht_singleliner=Hash.new
      ht_singleliner[@lc_type]=@lc_ht_singleliner
      ht_opmem[@lc_ht_singleliner]=ht_singleliner
      ht_multiliner=Hash.new
      ht_multiliner[@lc_type]=@lc_ht_multiliner
      ht_opmem[@lc_ht_multiliner]=ht_multiliner
      ar_ht=[ht_stringmark, ht_singleliner, ht_multiliner]
      ht_opmem[@lc_ar_ht]=ar_ht

      ht_comment_keys=Hash.new
      ht_comment_keys[@lc_type]=$kibuvits_krl171_lc_emptystring+@lc_type
      ht_comment_keys[@lc_start_line_number]=$kibuvits_krl171_lc_emptystring+@lc_start_line_number
      ht_comment_keys[@lc_end_line_number]=$kibuvits_krl171_lc_emptystring+@lc_end_line_number
      ht_comment_keys[@lc_start_column]=$kibuvits_krl171_lc_emptystring+@lc_start_column
      ht_comment_keys[@lc_end_column]=$kibuvits_krl171_lc_emptystring+@lc_end_column
      ht_comment_keys[@lc_start_tag]=$kibuvits_krl171_lc_emptystring+@lc_start_tag
      ht_comment_keys[@lc_end_tag]=$kibuvits_krl171_lc_emptystring+@lc_end_tag
      ht_comment_keys[@lc_only_tabs_and_spaces_before_comment]=$kibuvits_krl171_lc_emptystring+
      @lc_only_tabs_and_spaces_before_comment
      ht_comment_keys[@lc_singleliner]=$kibuvits_krl171_lc_emptystring+@lc_singleliner
      ht_comment_keys[@lc_multiliner]=$kibuvits_krl171_lc_emptystring+@lc_multiliner
      ht_comment_keys[@lc_comment]=$kibuvits_krl171_lc_emptystring+@lc_comment
      ht_opmem[@lc_ht_comment_keys]=ht_comment_keys

      ht_comment_tags=Hash.new
      ht_opmem[@lc_ht_comment_tags]=ht_comment_tags
      create_ht_opmem_ht_comment_tags ht_opmem,@ht_multiliner
      create_ht_opmem_ht_comment_tags ht_opmem,@ht_singleliner

      create_ht_comment(ht_opmem)
      return ht_opmem
   end # create_ht_opmem

   #=======================================================================
   # Memory map for a second screen:
   # Legend: HT--hash-table, AR--array, K--key, V--value, KV--key and value
   #         I<integer>--element index
   #=======================================================================
   #
   # ht_comment.K|comment.V|<a string>
   # ht_comment.K|end_column.V|{x: x in Z and (-1)<=x}
   # ht_comment.K|end_line_number.V|{x: x in Z and  0<=x}
   # ht_comment.K|end_tag.V|<a string>
   # ht_comment.K|only_tabs_and_spaces_before_comment.V|(true|false)
   # ht_comment.K|start_column.V|{x: x in Z and (-1)<=x}
   # ht_comment.K|start_line_number.V|{x: x in Z and  0<=x}
   # ht_comment.K|start_tag.V|<a string>
   # ht_comment.K|type.V|("multiliner"|"singleliner")
   #
   # ht_opmem.KV|ar_ht.ht_multiliner.K|ht_tag
   #                                .K|ix
   #                                .K|type.V|ht_multiliner
   #                  .ht_singleliner.KV|ht_tag
   #                                 .K|ix
   #                                 .K|type.V|ht_singleliner
   #                  .ht_stringmark.K|ht_tag
   #                                .K|ix
   #                                .K|type.V|ht_stringmark
   # ht_opmem.K|ar_ix.I*|AR.I1|ht_tag
   #                       .I0|x
   # ht_opmem.K|ar_out
   # ht_opmem.K|cursor_index
   # ht_opmem.K|line_number
   # ht_opmem.K|msgcs
   # ht_opmem.K|s_lang
   # ht_opmem.K|s_line
   # ht_opmem.K|state
   # ht_opmem.KV|ht_comment_keys.K|comment
   #                            .K|end_column
   #                            .K|end_line_number
   #                            .K|end_tag
   #                            .K|multiliner.V|"multiliner"
   #                            .K|only_tabs_and_spaces_before_comment
   #                            .K|singleliner.V|"singleliner"
   #                            .K|start_column
   #                            .K|start_line_number
   #                            .K|start_tag
   #                            .K|type.V|("singleliner"|"multiliner")
   # ht_opmem.KV|ht_comment_tags.K|end_tag
   #                            .K|start_tag
   # ht_opmem.KV|ht_multiliner.K|ht_tag
   #                          .K|ix
   #                          .K|type.V|ht_multiliner
   #         .KV|ht_singleliner.KV|ht_tag
   #                           .K|ix
   #                           .K|type.V|ht_singleliner
   #         .KV|ht_stringmark.K|ht_tag
   #                          .K|ix
   #                          .K|type.V|ht_stringmark
   #
   # ht_tags.KV|ht_multiliner.K|<language>.V|ar_tags.I*|ht_tag.K|end_tag
   #                                                          .K|start_tag
   #        .KV|ht_singleliner.K|<language>.V|ar_tags.I*|ht_tag.K|end_tag
   #                                                           .K|start_tag
   #        .KV|ht_stringmark.K|<language>.V|ar_tags.I*|ht_tag.K|end_tag
   #                                                          .K|start_tag
   #
   #=======================================================================

   public

   # It returns an array of hashtables, ar_hts, where:
   #
   # ht_comment['type'] inSet {"singleliner","multiliner"}
   # ht_comment['start_line_number'] inSet {x: x in Z and  0<=x}
   # ht_comment['end_line_number'] inSet {x: x in Z and  0<=x}
   # ht_comment['start_column'] inSet {x: x in Z and (-1)<=x}
   # ht_comment['end_column'] inSet {x: x in Z and (-1)<=x}
   # ht_comment['start_tag'] is always a string and equals "" if no tag exists
   # ht_comment['end_tag'] is always a string and equals "" if no tag exists
   # ht_comment['only_tabs_and_spaces_before_comment'] inSet {true, false}
   #
   # The start_column includes the very first character of the comment tag.
   # The end_column is the index of the very last character of the comment tag.
   #
   # It's a thread-safe and nonblocking implementation.
   def run s_language, s_script, msgcs=Kibuvits_krl171_msgc_stack.new
      s_lang0=Kibuvits_krl171_str.normalise_linebreaks s_language, "<a_linebreak>"
      s_lang=s_lang0.downcase
      ar_out=Array.new
      if !@ht_stringmarks.has_key? s_lang
         msgcs.cre("Language \""+s_lang0+"\" is not supported.",1.to_s)
         msgcs.last['Estonian']='Keel "'+s_lang0+'" ei ole toetatud.'
         return ar_out
      end # if
      s_scr=Kibuvits_krl171_str.normalise_linebreaks s_script, "\n"
      ht_opmem=create_ht_opmem s_lang, msgcs, ar_out
      i_line_number=0
      s_nl="\n"
      s_scr.each_line do |s_line|
         ht_opmem[@lc_s_line]=Kibuvits_krl171_str.clip_tail_by_str s_line,s_nl
         ht_opmem[@lc_cursor_index]=0 # has to be 0 for analyze_line(...)
         i_line_number=i_line_number+1
         ht_opmem[@lc_line_number]=i_line_number
         analyze_line(ht_opmem)
         if msgcs.b_failure
            ar_out.clear
            return ar_out
         end # if
      end # loop
      state=ht_opmem[@lc_state]
      if state==@lc_state_in_multiliner
         ar_out.clear
         msgcs.cre("Multiline comment misses a closing token.",2.to_s)
         msgcs.last['Estonian']="Mitmerealise kommentaari "+
         "lõpetus-sõne puudub."
         return ar_out
      end # if
      return ar_out
   end # run


   def Kibuvits_krl171_comments_detector.run(s_language, s_script,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      ar_out=Kibuvits_krl171_comments_detector.instance.run(
      s_language,s_script,msgcs)
      return ar_out
   end # Kibuvits_krl171_comments_detector.run

   # Returns an array of strings
   def ar_get_singleliner_comment_start_tags(s_language, msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_language
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      s_out=$kibuvits_krl171_lc_undetermined
      s_lang=s_language.downcase
      if !@ht_singleliner.has_key? s_lang
         ar_s_langs=Array.new
         @ht_singleliner.each_key{|s_suplang| ar_s_langs<<s_suplang}
         s_list_of_supported_languages=Kibuvits_krl171_str.array2xseparated_list(
         ar_s_langs,s_separator=", ")
         msgcs.cre "Language \""+s_language+"\" is not supported. "+
         "The supported languages are: "+
         s_list_of_supported_languages+".",5.to_s
         msgcs.last['Estonian']="Keel nimega \""+s_language+
         "\" ei ole toetatud. Toetatud keelteks on: "+
         s_list_of_supported_languages+"."
         return s_out
      end # if
      ar_out=Array.new
      ar_tags=@ht_singleliner[s_lang]
      ar_tags.each do |ht_tag|
         ar_out<<($kibuvits_krl171_lc_emptystring+ht_tag[@lc_start_tag])
      end # loop
      return ar_out
   end # ar_get_singleliner_comment_start_tags


   def Kibuvits_krl171_comments_detector.ar_get_singleliner_comment_start_tags(
      s_language,msgcs)
      ar_out=Kibuvits_krl171_comments_detector.instance.ar_get_singleliner_comment_start_tags(
      s_language,msgcs)
      return ar_out
   end # Kibuvits_krl171_comments_detector.ar_get_singleliner_comment_start_tags


   def sl2ml_is_collectable ht_comment, i_last_collected_oneliner_line_number
      b_out=ht_comment[@lc_only_tabs_and_spaces_before_comment]
      b_out=b_out&&(ht_comment[@lc_type]==@lc_singleliner)
      if i_last_collected_oneliner_line_number!=(-2)
         x=ht_comment[@lc_start_line_number]-1
         b_out=b_out&&(x==i_last_collected_oneliner_line_number)
      end # if
      return b_out
   end # sl2ml_is_collectable

   def  extract_commenttexts_by_convert_blocks_of_singleliners2multiliner(
      ar_comments)
      ar_out=Array.new
      ar_commentslen=ar_comments.length
      return ar_out if ar_commentslen==0
      b_collecting_mode=false
      s_collected=nil
      # -2 is used in stead of -1 to make this function more reliable to
      # line number counting assertion changes. -1 will not do, if the
      # first line is considered to be with index 0.
      i_last_collected_oneliner_line_number=(-2)
      ar_commentslen.times do |i|
         ht_comment=ar_comments[i]
         if sl2ml_is_collectable(ht_comment, i_last_collected_oneliner_line_number)
            b_collecting_mode=true
            if s_collected==nil
               s_collected=$kibuvits_krl171_lc_emptystring
            else
               s_collected=s_collected+"\n"
            end # if
            s_collected=s_collected+ht_comment[@lc_comment]
            i_last_collected_oneliner_line_number=0+
            ht_comment[@lc_start_line_number]
            next
         end # if
         if b_collecting_mode
            ar_out<<s_collected
            s_collected=nil
            b_collecting_mode=false
            i_last_collected_oneliner_line_number=(-2)
         end # if
         ar_out<<ht_comment[@lc_comment]
      end # loop
      ar_out<<s_collected if b_collecting_mode
      return ar_out
   end # extract_commenttexts_by_convert_blocks_of_singleliners2multiliner

   public
   def extract_commentstrings(ar_comments,
      b_convert_blocks_of_singleliners2multiliner=true)
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck binding(), Array, ar_comments
      end # if
      if b_convert_blocks_of_singleliners2multiliner
         ar_out=extract_commenttexts_by_convert_blocks_of_singleliners2multiliner(
         ar_comments)
         return ar_out
      end # if
      ar_out=Array.new
      ar_commentslen=ar_comments.length
      ar_commentslen.times do |i|
         ht_comment=ar_comments[i]
         ar_out<<ht_comment[@lc_comment]
      end # loop
      return ar_out
   end # extract_commentstrings

   def  Kibuvits_krl171_comments_detector.extract_commentstrings(ar_comments,
      b_convert_blocks_of_singleliners2multiliner=true)
      ar_out=Kibuvits_krl171_comments_detector.instance.extract_commentstrings(
      ar_comments,b_convert_blocks_of_singleliners2multiliner)
      return ar_out
   end # Kibuvits_krl171_comments_detector.convert_blocks_of_singleliners2multiliner

   include Singleton

end # class Kibuvits_krl171_comments_detector
#=====================kibuvits_krl171_comments_detector_rb_end====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_comments_detector_rb_start".
#==========================================================================

#=====================kibuvits_krl171_argv_parser_rb_start========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_argv_parser_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/bonnet/kibuvits_krl171_os_codelets.rb"

#==========================================================================
# It's used for placing console arguments to a hashtable.
class Kibuvits_krl171_argv_parser

   public
   def initialize
   end #initialize

   private

   def init_ht_args ht_grammar
      ht_args=Hash.new
      ht_grammar.each_pair do |key,value|
         if KIBUVITS_krl171_b_DEBUG
            bn=binding()
            kibuvits_krl171_typecheck bn, Fixnum, value
            kibuvits_krl171_typecheck bn, String, key
         end # if
         kibuvits_krl171_throw 'key==""' if key==""
         rgx=/^[-][\w\d]*/
         if rgx.match(key)==nil
            kibuvits_krl171_throw 'The ht_grammar key(=='+key+") doesn't match a regex."
         end # if
         kibuvits_krl171_throw "ht_grammar["+key+"]=="+value.to_s+" < (-1)" if value<(-1)
         ht_args[key]=nil
      end # loop
      return ht_args
   end # init_ht_args

   def bisect_s_arg s_arg,ht_opmem
      ar_s_arg_split=ht_opmem['ar_s_arg_split']
      rgx=/^[-][\w\d]*/
      if rgx.match(s_arg)==nil
         ar_s_arg_split[0]=nil
         ar_s_arg_split[1]=s_arg
      else
         ar1=Kibuvits_krl171_str.ar_bisect(s_arg,"=")
         ar_s_arg_split[0]=ar1[0]
         ar_s_arg_split[1]=nil
         ar_s_arg_split[1]=ar1[1] if ar1[1]!=""
      end # if
   end # bisect_s_arg

   def console_var_2_results ht_opmem
      var_name=ht_opmem['var_name']
      ht_args=ht_opmem['ht_args']
      ht_grammar=ht_opmem['ht_grammar']
      ar_values=ht_opmem['ar_values']
      i_expected=ht_grammar[var_name]
      if ar_values.length<i_expected # infinity==(-1)<0
         msgc=ht_opmem['msgc']
         msgc.s_message_id=4.to_s
         msgc.b_failure=true
         msgc['English']='Console argument "'+var_name+
         '" is declared to hold a vector that has '+i_expected.to_s+
         ' coordinates, but it was assigned a vector that has '+
         ar_values.length.to_s+' coordinates.'
         msgc['Estonian']='Deklaratsiooni kohaselt peaks '+
         'konsooliargument "'+var_name+'" omama väärtuseks '+
         'vektorit, millel on '+i_expected.to_s+
         ' koordinaati, kuid talle omistati väärtuseks vektor, '+
         'millel on '+ar_values.length.to_s+' koordinaati.'
         ht_opmem['var_name']=nil
         return
      end # if
      ht_args[var_name]=ar_values
   end # console_var_2_results

   def read_console_var_declaration ht_opmem
      ar_s_arg_split=ht_opmem['ar_s_arg_split']
      return if ar_s_arg_split[0]==nil
      var_name=ht_opmem['var_name']
      ht_args=ht_opmem['ht_args']
      ht_grammar=ht_opmem['ht_grammar']
      msgc=ht_opmem['msgc']
      if var_name!=nil
         console_var_2_results ht_opmem
         return if msgc.b_failure
      end # if
      ht_opmem['ar_values']=Array.new
      var_name=ar_s_arg_split[0]
      ht_opmem['var_name']=nil
      if !ht_grammar.has_key? var_name
         msgc.s_message_id=1.to_s
         msgc.b_failure=true
         msgc['English']=var_name+' is not declared within the ht_grammar.'
         msgc['Estonian']=var_name+' ei ole paisktabelis ht_grammar '+
         'deklareeritud.'
         return
      end # if
      if (ht_args[var_name]).class==Array
         msgc.s_message_id=5.to_s
         msgc.b_failure=true
         msgc['English']='Console variable "'+var_name+
         '" has been delcared more than once.'
         msgc['Estonian']='Konsoolimuutuja "'+var_name+
         '" on deklareeritud rohkem kui üks kord.'
         return
      end # if
      ht_opmem['var_name']=var_name
      ht_opmem['i_n_left2read']=ht_grammar[var_name]
   end # read_console_var_declaration

   def read_console_var_value ht_opmem
      ar_s_arg_split=ht_opmem['ar_s_arg_split']
      return if ar_s_arg_split[1]==nil
      var_name=ht_opmem['var_name']
      ar_values=ht_opmem['ar_values']
      ht_grammar=ht_opmem['ht_grammar']
      msgc=ht_opmem['msgc']
      if var_name==nil
         msgc.s_message_id=2.to_s
         msgc.b_failure=true
         msgc['English']='Console variable declaration is missing.'
         msgc['Estonian']='Konsoolimuutuja deklaratsioon puudub.'
         return
      end # if
      if !ht_grammar.has_key? var_name
         kibuvits_krl171_throw "Console variable name not declared. var_name=="+
         var_name.to_s+'. error 1'
      end # if
      kibuvits_krl171_throw "ar_values==nil, error 2" if ar_values==nil
      i_n_left2read=ht_opmem['i_n_left2read']
      kibuvits_krl171_throw "i_n_left2read==nil, error 3" if i_n_left2read==nil
      if i_n_left2read==0
         msgc.s_message_id=3.to_s
         msgc.b_failure=true
         i_expected=ht_grammar[var_name]
         msgc['English']='Console argument "'+var_name+
         '" is declared to hold a vector with '+i_expected.to_s+
         ' coordinates, but it was assigned a vector that has more '+
         'coordinates.'
         msgc['Estonian']='Deklaratsiooni kohaselt peaks '+
         'konsooliargument "'+var_name+'" omama väärtuseks '+
         'vektorit, millel on '+i_expected.to_s+' koordinaati, '+
         'kuid talle omistati suurema koordinaatide arvuga vektor.'
         return
      end # if
      ht_opmem['i_n_left2read']=i_n_left2read-1 if 0<i_n_left2read # the (-1)
      s_value=ar_s_arg_split[1]
      rgx2=/^[\\][-]/
      s_value=s_value[1..(-1)] if rgx2.match(s_value)!=nil
      ar_values<<s_value
   end # read_console_var_value

   def parse_step s_arg,ht_opmem
      bisect_s_arg s_arg,ht_opmem
      read_console_var_declaration ht_opmem
      return if ht_opmem['msgc'].b_failure
      read_console_var_value ht_opmem
   end # parse_step

   def verify_s_arg s_arg,ht_opmem
      msgc=ht_opmem['msgc']
      if s_arg.class!=String
         msgc.s_message_id=6.to_s
         msgc.b_failure=true
         msgc['English']='Console argument class is not String. '+
         's_arg.class=='+s_arg.class.to_s
         msgc['Estonian']='Konsooliargumendi klass ei ole String. '+
         's_arg.class=='+s_arg.class.to_s
         return
      end # if
      if s_arg==""
         kibuvits_krl171_throw 'Console argument happens to be an empty string.'+
         ' As the ARGV never contains empty strings, or at least it '+
         'ought not to contain them, the fault is either in this code '+
         'or somewhere else. The fault can be somewhere outside the '+
         'code of the Kibuvits_krl171_argv_parser, because it is possible to '+
         'assemble an ARGV substitute and feed it into the '+
         'Kibuvits_krl171_argv_parser.'
      end # if
   end # verify_s_arg


   public

   # The key of the ht_grammar is expected to be a
   # string that matches a regex of ^[-][\w\d-]*
   # For example, "--file-name", "-f", "-o", "-42" and "-x" match that regex.
   #
   # The values of the ht_grammar are expected to be an integers that
   # are within a set that is an union of natural numbers and {-1,0}
   # The value that is greater than or equal to 0 indicates the
   # number of expected arguments after the argument specification.
   # For example, ht_grammar["--file-name"]=1 means that exactly one
   # console argument is expected after the "--file-name".
   # (-1) indicates infinity. For example, ht_grammar["--file-names"]=(-1)
   # means that at least one file name is expected right after
   # the "--file-name"
   #
   # The parsing considers the string that succeeds the equals sign ("=")
   # as one of the console arguments. So for ht_grammar["-f"]=1 the
   # "-f hi_there.txt" and "-f=hi_there.txt" are both valid.
   #
   # If the ht_grammar["--great"]=4 and there is no "--great" within the
   # console args, no exception is thrown and "--great" is marked
   # as nil in the output hashtable.
   #
   # The returned hashtable, ht_args, is a copy of the input ht_grammar,
   # except that each of the values is either nil or an array.
   #
   # TODO: Add mode (-2), like the (-1), to this method and
   # the rest of the related meothds. The (-2) would represent the
   # "zero or more" option.
   #
   # TODO: If "--help" and "--abi" have the same meaning, then
   # the implementation should forbid them to be defined simultaniously.
   # It should not be allowed to write "myapp -? --help --abi", not to
   # mention "myapp --file ./foo --sisendfail ./bar "
   #
   def run ht_grammar, argv, msgcs
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_grammar
         kibuvits_krl171_typecheck bn, Array, argv
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      kibuvits_krl171_throw "ht_grammar is empty." unless 0<ht_grammar.keys.length
      ht_args=init_ht_args ht_grammar
      return ht_args if msgcs.b_failure
      msgc=Kibuvits_krl171_msgc.new
      msgc.b_failure=false
      msgcs<<msgc
      if argv.length==0# == <no arguments given>
         s="argv.length==0"
         msgc['English']=s
         msgc['Estonian']=s
         return ht_args
      end # if
      ht_opmem=Hash.new
      ht_opmem['var_name']=nil
      ht_opmem['ar_values']=nil
      ht_opmem['i_n_left2read']=nil
      ht_opmem['ht_grammar']=ht_grammar
      ht_opmem['ar_s_arg_split']=["",""]
      ht_opmem['ht_args']=ht_args
      ht_opmem['msgc']=msgc
      s_arg=""
      (argv.length).times do |i|
         s_arg=argv[i]
         verify_s_arg s_arg,ht_opmem
         break if msgcs.b_failure
         parse_step s_arg,ht_opmem
         break if msgcs.b_failure
      end # loop
      console_var_2_results ht_opmem unless msgcs.b_failure
      return ht_args
   end # run

   def Kibuvits_krl171_argv_parser.run(ht_grammar,argv,msgcs)
      ht_args=Kibuvits_krl171_argv_parser.instance.run(
      ht_grammar,argv,msgcs)
      return ht_args
   end # Kibuvits_krl171_argv_parser.run



   def normalize_parsing_result_verify_ar_synonyms(
      ar_synonyms, s_target,msgcs)
      x=ar_synonyms.uniq
      if msgcs!=nil
         if KIBUVITS_krl171_b_DEBUG
            #kibuvits_krl171_writeln "\nx=="+Kibuvits_krl171_str.array2xseparated_list(x)+
            #"\nar_synonyms=="+
            #Kibuvits_krl171_str.array2xseparated_list(ar_synonyms)+"\n"+
            #"s_target=="+s_target+"\n"
         end # if
      end # if
      return if x.length==ar_synonyms.length
      ht_duplicates=Hash.new
      ar_synonyms.each do |s_synonym|
         if !ht_duplicates.has_key? s_synonym
            ht_duplicates[s_synonym]=1
         else
            ht_duplicates[s_synonym]=1+ht_duplicates[s_synonym]
         end # if
      end # loop
      ar_duplicates=Array.new
      ht_duplicates.each_pair do |a_key,a_value|
         ar_duplicates<<a_key if 1<a_value
      end # loop
      s_duplicates=Kibuvits_krl171_str.array2xseparated_list(ar_duplicates)
      kibuvits_krl171_throw "ar_synonyms.uniq.length=="+x.length.to_s+
      "!=ar_synonyms.length=="+ar_synonyms.length.to_s+
      " for ht_normalization_specification['"+s_target+"']. "+
      "The duplicates are: "+s_duplicates+". "
   end # normalize_parsing_result_verify_ar_synonyms

   def normalize_parsing_result_verify_ar_args_elem_type(
      ar_args, s_target, b_ht_args)
      ar_args.each do |x|
         if x.class!=String
            if b_ht_args
               kibuvits_krl171_throw "The array that is stored to "+
               "ht_args['"+s_target+"'] had a non-string element "+
               "with the value of "+x.to_s+" ."
            else
               kibuvits_krl171_throw "The array that is stored to "+
               "ht_normalization_specification['"+
               s_target+"'] had a non-string element "+
               "with the value of "+x.to_s+" ."
            end # if
         end # if
      end # loop
   end # normalize_parsing_result_verify_ar_args_elem_type

   public

   # The ht_args is the Kibuvits_krl171_argv_parser.run output.
   #
   # The idea behind the Kibuvits_krl171_argv_parser.normalize_parsing_result
   # is that if there are multiple console arguments that actually are
   # synonyms, for example, "-f", "--file", "--files", then to simplify
   # the code that has to act upon the console arguments, it makes
   # sense to converge the values. For example, in the case of the
   # "-f", "--file", "--files" one might want to collect all of the
   # file paths to a single array that resides in one certain location
   # in the ht_args, let's say next to "--file". In that case, the
   # ht_normalization_specification has "--file" as its key and
   # an array of its synonyms as the value that corresponds to the
   # "--file": ["-f","--files"].
   #
   # It's OK to place the keys of the  ht_normalization_specification
   # to the array of values, but it won't change anything, because
   # a thing x is considered to be its own synonym.
   #
   # Since the normalizing changes the ht_args content,
   # the numbers of the console arguments should be verified prior to
   # normalization.
   def normalize_parsing_result(ht_normalization_specification, ht_args,
      msgcs=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht_normalization_specification
         kibuvits_krl171_typecheck bn, Hash, ht_args
         kibuvits_krl171_typecheck bn, [Kibuvits_krl171_msgc_stack,NilClass],msgcs
      end # if
      ht_spec=ht_normalization_specification
      if ht_spec.length==0
         kibuvits_krl171_throw "ht_normalization_specification.length==0 does "+
         "not make sense."
      end # if
      ar_converged=nil
      ar_args=nil
      b_ar_synonyms_contains_s_target=false
      x=nil
      ht_spec.each_pair do |s_target,ar_synonyms| # == |key,value|
         if !ht_args.has_key? s_target
            kibuvits_krl171_throw "ht_args does not have a key of \""+s_target+
            "\", but the key is present in the "+
            "ht_normalization_specification."
         end # if
         if ar_synonyms.class!=Array
            kibuvits_krl171_throw "ht_normalization_specification['"+s_target+
            "'].class!=Array ."
         end # if
         if s_target.class!=String
            kibuvits_krl171_throw "ht_normalization_specification keys are "+
            "expected to be strings, but a value of type "+
            s_target.class.to_s+" was found.\ns_target=="+
            s_target.to_s
         end # if
         normalize_parsing_result_verify_ar_synonyms(
         ar_synonyms,s_target,msgcs)
         ar_converged=nil
         ar_synonyms.each do |s_synonym|
            b_ar_synonyms_contains_s_target=true if s_synonym==s_target
            if !ht_args.has_key? s_synonym
               kibuvits_krl171_throw "ht_normalization_specification['"+s_target+"']"+
               " contains element \""+s_synonym+"\", which is "+
               "not among the keys of the ht_args. "
            end # if
            if s_synonym.class!=String
               kibuvits_krl171_throw "s_synonym.class=="+s_synonym.class.to_s+
               ", but String is expected.\ns_synonym=="+s_synonym.to_s
            end # if
            ar_args=ht_args[s_synonym]
            if ar_args!=nil
               normalize_parsing_result_verify_ar_synonyms(
               ar_args,s_target,msgcs)
               normalize_parsing_result_verify_ar_args_elem_type(
               ar_args, s_target, true)
               ar_converged=Array.new if ar_converged==nil
               ar_converged=ar_converged+ar_args
            end # if
         end # loop
         if !b_ar_synonyms_contains_s_target
            if !ht_args.has_key? s_target
               kibuvits_krl171_throw "A key of the ht_normalization_specification, "+
               "'"+s_target+"', is not among the keys of the ht_args. "
            end # if
            ar_args=ht_args[s_target]
            if ar_args!=nil
               normalize_parsing_result_verify_ar_synonyms(
               ar_args,s_target,msgcs)
               normalize_parsing_result_verify_ar_args_elem_type(
               ar_args, s_target, false)
               ar_converged=Array.new if ar_converged==nil
               ar_converged=ar_converged+ar_args
            end # if
         end # if
         ar_converged=ar_converged.uniq if ar_converged!=nil
         ht_args[s_target]=ar_converged
      end # loop
   end # normalize_parsing_result

   def Kibuvits_krl171_argv_parser.normalize_parsing_result(
      ht_normalization_specification, ht_args, msgcs=nil)
      Kibuvits_krl171_argv_parser.instance.normalize_parsing_result(
      ht_normalization_specification, ht_args,msgcs)
   end # Kibuvits_krl171_argv_parser.normalize_parsing_result

   def verify_parsed_input_verification_step(s_arg,i_count,ht_args,
      msgcs, b_assume_args_to_be_all_compulsory=false)
      bn=nil
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck(bn, String, s_arg,
         "The s_arg is a key of the ht_grammar.")
         kibuvits_krl171_typecheck(bn, Fixnum, i_count,
         "The i_count==ht_grammar['"+s_arg+"'].")
         kibuvits_krl171_typecheck(bn, Hash, ht_args)
      end # if
      if !ht_args.has_key? s_arg
         kibuvits_krl171_throw "ht_args does not have a key that equals with \""+
         s_arg+"\"."
      end # if
      # The msgcs instance passed the typecheck in the parent function.
      ar_args=ht_args[s_arg]
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck(bn, [Array,NilClass], ar_args,
         "The ar_args is the value of ht_args['"+s_arg+"'].")
      end # if
      if b_assume_args_to_be_all_compulsory
         if ar_args==nil # == <console argument is missing>
            msgcs.cre "Console argument "+s_arg+
            " is compulsory, but it is missing.", 4.to_s
            msgcs.last['Estonian']="Konsooliargument nimega "+s_arg+
            " on kohustuslik, kuid puudub."
            return
         end # if
      end # if
      # One assumes that console arguments are voluntary, except
      # that when they are given, they must have the right
      # number of values.
      return if ar_args==nil # == <console argument is missing>
      i_ar_argslen=ar_args.length
      case i_count
      when 0
         if i_ar_argslen!=0
            msgcs.cre "Console argument "+s_arg+" was given "+
            i_ar_argslen.to_s+"values, but it is required to "+
            "be given at most 0 values.", 1.to_s
            msgcs.last['Estonian']="Konsooliargumendile nimega "+s_arg+
            "anti "+i_ar_argslen.to_s+" väärtust, kuid on "+
            "nõutud, et talle antakse maksimaalselt 0 väärtust."
            return
         end # if
      when (-1)
         if i_ar_argslen<1
            msgcs.cre "Console argument "+s_arg+" was given "+
            "0 values, but it is required to "+
            "be given at least one value.", 2.to_s
            msgcs.last['Estonian']="Konsooliargumendile nimega "+s_arg+
            "anti 0 väärtust, kuid on õutud, et "+
            "talle antakse vähemalt üks väärtus."
            return
         end # if
      else
         if i_ar_argslen!=i_count
            msgcs.cre "Console argument "+s_arg+" was given "+
            i_ar_argslen.to_s+"values, but it is required to "+
            "be given at "+i_count.to_s+" values.", 3.to_s
            msgcs.last['Estonian']="Konsooliargumendile nimega "+s_arg+
            "anti "+i_ar_argslen.to_s+" väärtust, kuid on õutud, et "+
            "talle antakse "+i_count.to_s+" väärtust."
            return
         end # if
      end # case
   end # verify_parsed_input_verification_step

   public

   # Checks whether the values of the ht_args comply with the
   # ht_grammar. In case of miscompliance, outputs an error to the
   # magcs
   def  verify_parsed_input(ht_grammar, ht_args, msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding();
         kibuvits_krl171_typecheck bn, Hash, ht_grammar
         kibuvits_krl171_typecheck bn, Hash, ht_args
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ht_grammar.each_pair do |s_arg,i_count|
         verify_parsed_input_verification_step(s_arg,i_count,
         ht_args,msgcs,false)
         break if msgcs.b_failure
      end # loop
   end # verify_parsed_input

   def  Kibuvits_krl171_argv_parser.verify_parsed_input(ht_grammar, ht_args, msgcs)
      Kibuvits_krl171_argv_parser.instance.verify_parsed_input(ht_grammar,ht_args,msgcs)
   end # Kibuvits_krl171_argv_parser.verify_parsed_input


   def verify_compulsory_input(s_or_ar_console_arg_name,
      ht_grammar,ht_args,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding();
         kibuvits_krl171_typecheck bn, [String,Array], s_or_ar_console_arg_name
         kibuvits_krl171_typecheck bn, Hash, ht_grammar
         kibuvits_krl171_typecheck bn, Hash, ht_args
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      ar_compulsory_args=Kibuvits_krl171_ix.normalize2array(
      s_or_ar_console_arg_name)
      i_count=nil
      ar_compulsory_args.each do |s_arg|
         if !ht_grammar.has_key? s_arg
            kibuvits_krl171_throw "ht_grammar does not have a key that equals "+
            "with \""+s_arg.to_s+"\"."
         end # if
         i_count=ht_grammar[s_arg]
         verify_parsed_input_verification_step(s_arg,i_count,
         ht_args,msgcs,true)
         break if msgcs.b_failure
      end # loop
   end # verify_compulsory_input

   def Kibuvits_krl171_argv_parser.verify_compulsory_input(s_or_ar_console_arg_name,
      ht_grammar,ht_args,msgcs)
      Kibuvits_krl171_argv_parser.instance.verify_compulsory_input(
      s_or_ar_console_arg_name, ht_grammar,ht_args,msgcs)
   end # Kibuvits_krl171_argv_parser.verify_compulsory_input

   include Singleton

end # class Kibuvits_krl171_argv_parser
#=====================kibuvits_krl171_argv_parser_rb_end==========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_argv_parser_rb_start".
#==========================================================================

#=====================kibuvits_krl171_apparch_specific_rb_start===================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_apparch_specific_rb_end".
#==========================================================================
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_shell.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ix.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_file_intelligence.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_comments_detector.rb"

#==========================================================================

# The class Kibuvits_krl171_apparch_specific is a namespace for
# code fragmetns that are somewhat specific to
# an application architecture, but as the architectures are
# shared by more than one application, it saves time by
# writing them only once in stead of rewriting the parts
# in every application.
class Kibuvits_krl171_apparch_specific
   def initialize
   end #initialize

   # Makes a copy of a file that is pointed by the
   # s_template_file_path and executes
   # a block that gets 1 block argument: s_tmp_file_path
   def xof_run_bloc_on_a_copy_of_a_template(
      s_template_file_path, s_temporary_folder_path,
      b_delete_temporary_file=true)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_template_file_path
         kibuvits_krl171_typecheck bn, String, s_temporary_folder_path
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_delete_temporary_file
      end # if
      ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(
      s_template_file_path,'is_file,readable')
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures)

      ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(
      s_temporary_folder_path,'is_directory,writable')
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures)

      s_tmp_file_path=s_temporary_folder_path+"/subject_to_removal_"+
      Kibuvits_krl171_GUID_generator.generate_GUID+".txt"

      # The next line works also on binary files, which is important.
      kibuvits_krl171_sh("cp "+s_template_file_path+" "+s_tmp_file_path)
      b_exception_in_block=false
      s_xs_msg=""
      begin
         yield(s_tmp_file_path)
      rescue Exception => e
         b_exception_in_block=true
         s_xs_msg=e.message
      end # end
      if b_delete_temporary_file
         File.delete(s_tmp_file_path) if File.exists? s_tmp_file_path
      end # if
      kibuvits_krl171_throw s_xs_msg if b_exception_in_block
   end # xof_run_bloc_on_a_copy_of_a_template,

   def Kibuvits_krl171_apparch_specific.xof_run_bloc_on_a_copy_of_a_template(
      s_template_file_path, s_temporary_folder_path,
      b_delete_temporary_file=true,&a_block)
      Kibuvits_krl171_apparch_specific.instance.xof_run_bloc_on_a_copy_of_a_template(
      s_template_file_path, s_temporary_folder_path,
      b_delete_temporary_file,&a_block)
   end # Kibuvits_krl171_apparch_specific.xof_run_bloc_on_a_copy_of_a_template

   #-----------------------------------------------------------------------

   # Explanation by examples:
   #
   # "nice_v42.css" -> 42
   # "nice_v99.awesomeextension" -> 99
   # "nice_v69.tar.bz_v23.jar" -> 23
   # "nice_v.css" -> nil
   # "nice_47.css" -> nil
   # "nice_v72.contains a space" -> nil
   # "nice_v-72.js" -> nil
   # "nice_vX82.js" -> nil
   #
   # The file does not have to exist.
   # Returns an integer or nil.
   def x_file_path_2_version_t1(s_file_path_or_name)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_file_path_or_name
      end # if
      rgx_1=/_v[\d]+[.][^.\s]+$/
      md=s_file_path_or_name.match(rgx_1)
      return nil if md==nil
      s_1=md[0]
      i_1=s_1.index($kibuvits_krl171_lc_dot)
      # _v427.css
      # 012345
      i_old_version=s_1[2..(i_1-1)].to_i
      return  i_old_version
   end # x_file_path_2_version_t1

   def Kibuvits_krl171_apparch_specific.x_file_path_2_version_t1(s_file_path_or_name)
      x=Kibuvits_krl171_apparch_specific.instance.x_file_path_2_version_t1(s_file_path_or_name)
      return x
   end # Kibuvits_krl171_apparch_specific.x_file_path_2_version_t1

   #-----------------------------------------------------------------------

   private

   # The rgx_1 is meant to be the same as the one uncommented here.
   # Its a param to avoid reinit of the regex.
   def impl_x_old_path_2_new_path_t1(s_old_path,i_new_version,rgx_1)
      #rgx_1=/_v[\d]+[.][^.\s]+$/
      md=s_old_path.match(rgx_1)
      return nil if md==nil
      s_1=md[0]
      i_1=s_1.index($kibuvits_krl171_lc_dot)
      # _v427.css
      # 012345
      s_2=s_1[(i_1+1)..(-1)]
      s_1=("_v"+i_new_version.to_s)+($kibuvits_krl171_lc_dot+s_2)
      s_new_path=s_old_path.sub(rgx_1,s_1)
      return s_new_path
   end # impl_x_old_path_2_new_path_t1


   public

   # It does not return anything.
   # If modifications to the file names or file content
   # have been applied, then the msgcs.b_failure==false.
   #
   # If the msgcs.b_failure==true, then the
   # msgcs.last has the following values:
   #
   #     if msgcs.last.s_message_id=="Kibuvits_krl171_apparch_specific_wrong_filesystem_access_or_wrong_element_type"
   #        msgcs.last.x_data=<Output of the Kibuvits_krl171_fs.verify_access.>
   #     end # if
   #     if msgcs.last.s_message_id=="Kibuvits_krl171_apparch_specific_malformed_paths"
   #        msgcs.last.x_data=<An Array that contains at least one .>
   #     end # if
   #
   # This function is inspired by the fact that CSS and JavaScript
   # files get cached by the browser and to force the
   # browser to download a new version of the CSS and JavaScript
   # files, the file names have to change. One way to
   # implement the chane is to name the files like
   # nicenameprefix_v42.css  and someothernicename_v69.js and then
   # to increment the 42->42, 69->70 .
   #
   def update_file_version_t1(
      ar_or_s_renamable_file_paths,
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files,
      i_new_version,msgcs=Kibuvits_krl171_msgc_stack.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array,String], ar_or_s_renamable_file_paths
         kibuvits_krl171_typecheck bn, [Array,String], ar_or_s_file_paths_of_files_that_reference_the_renamable_files
         kibuvits_krl171_typecheck bn, Fixnum,i_new_version
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack,msgcs
      end # if
      if i_new_version<0
         kibuvits_krl171_throw "i_new_version == "+i_new_version.to_s+" < 0"
      end # if
      kibuvits_krl171_throw "msgcs.b_failure==true" if msgcs.b_failure
      ar_renamables=Kibuvits_krl171_ix.normalize2array(
      ar_or_s_renamable_file_paths)
      ar_rewritables=Kibuvits_krl171_ix.normalize2array(
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files)
      if KIBUVITS_krl171_b_DEBUG
         ar_renamables.each do |x|
            bn=binding()
            kibuvits_krl171_typecheck bn, String, x
         end # loop
         ar_rewritables.each do |x|
            bn=binding()
            kibuvits_krl171_typecheck bn, String, x
         end # loop
      end # if
      ht_fschecks=nil
      ar_renamables.each do |s_fp|
         ht_fschecks=Kibuvits_krl171_fs.verify_access(s_fp,"is_file,deletable")
         break if ht_fschecks.size!=0
      end # loop
      if ht_fschecks.size!=0
         msgcs.cre(s_default_msg="At least one of the renamable file candidates "+
         "has wrong filesystem access rigths or is a folder.",
         s_message_id="Kibuvits_krl171_apparch_specific_wrong_filesystem_access_or_wrong_element_type",
         b_failure=true)
         msgcs.last.x_data=ht_fschecks
         return
      end # if
      ar_rewritables.each do |s_fp|
         ht_fschecks=Kibuvits_krl171_fs.verify_access(s_fp,"is_file,writable")
         break if ht_fschecks.size!=0
      end # loop
      if ht_fschecks.size!=0
         msgcs.cre(s_default_msg="At least one of the editable file candidates "+
         "has wrong filesystem access rigths or is a folder.",
         s_message_id="Kibuvits_krl171_apparch_specific_wrong_filesystem_access_or_wrong_element_type",
         b_failure=true)
         msgcs.last.x_data=ht_fschecks
         return
      end # if
      ht_old_path_2_new_path=Hash.new
      rgx_1_for_tmp_caching=/_v[\d]+[.][^.\s]+$/
      x_new_path_candidate=nil
      ar_renamables.each do |s_old_path|
         x_new_path_candidate=impl_x_old_path_2_new_path_t1(s_old_path,
         i_new_version,rgx_1_for_tmp_caching)
         if x_new_path_candidate==nil
            msgcs.cre(s_default_msg="At least one of the renamable file candidates "+
            "has a name that does not meet the specification of this function.",
            s_message_id="Kibuvits_krl171_apparch_specific_malformed_paths", b_failure=true)
            msgcs.last.x_data=[s_old_path]
            return
         end # if
         ht_old_path_2_new_path[s_old_path]=x_new_path_candidate
      end # loop
      # Over here, we're clear to go all the way. :-)
      ar_editables=[]+ar_rewritables
      ht_old_fn_2_new_fn=Hash.new
      s_old_file_name=nil
      s_new_file_name=nil
      ht_old_path_2_new_path.each_pair do |s_old_path,s_new_path|
         s_old_file_name=Pathname.new(s_old_path).basename.to_s
         s_new_file_name=Pathname.new(s_new_path).basename.to_s
         ht_old_fn_2_new_fn[s_old_file_name]=s_new_file_name
         File.rename(s_old_path,s_new_path)
         ar_editables<<s_new_path
      end # loop
      s_content=nil
      ar_editables.each do |s_file_path|
         s_content=file2str(s_file_path)
         s_content=Kibuvits_krl171_str.s_batchreplace(ht_old_fn_2_new_fn, s_content)
         str2file(s_content,s_file_path)
      end # loop
   end # update_file_version_t1


   def Kibuvits_krl171_apparch_specific.update_file_version_t1(
      ar_or_s_renamable_file_paths,
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files,
      i_new_version,msgcs=Kibuvits_krl171_msgc_stack.new)
      Kibuvits_krl171_apparch_specific.instance.update_file_version_t1(
      ar_or_s_renamable_file_paths,
      ar_or_s_file_paths_of_files_that_reference_the_renamable_files,
      i_new_version,msgcs)
   end # Kibuvits_krl171_apparch_specific.update_file_version_t1(

   #-----------------------------------------------------------------------

   # Throws, if the s_or_ar_environment_variable_names depicts
   # an environment variable that has not been added to the
   # tests or the string that is an environment variable name candidate
   # does not qualify to be a variable name.
   def b_softf1_com_envs_NOT_OK(s_or_ar_environment_variable_names,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Array], s_or_ar_environment_variable_names
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack,msgcs
      end # if
      ar_env_names=Kibuvits_krl171_ix.normalize2array(s_or_ar_environment_variable_names)
      bn_1=nil
      ar_file_names=nil
      ar_folder_names=nil
      b_x=false
      ar_env_names.each do |s_env_name|
         bn_1=binding()
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn_1,s_env_name)
         case s_env_name
         when "KIBUVITS_krl171_HOME"
            ar_file_names=["src/include/kibuvits_krl171_boot.rb","src/include/kibuvits_krl171_all.rb"]
            ar_folder_names=["src/include","src/dev_tools/selftests"]
            b_x=Kibuvits_krl171_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         when "SIREL_HOME"
            ar_file_names=["README.md","src/src/sirel_core.php","src/src/sirel.php"]
            ar_folder_names=["src/src/bonnet","src/src/lib/spyc"]
            b_x=Kibuvits_krl171_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         when "RAUDROHI_HOME"
            s_0="src/deployables/third_party/fonts/gnu_org/freefont/2011/"+
            "with_raudrhoi_specific_modifications/"+
            "raudrohi_thirdpartyspecificversion_1_FreeMono.ttf"
            ar_file_names=["README.md","src/dev_tools/Rakefile","src/devel/raudrohi_base.js","src/devel/raudrohi_core.js",s_0]
            ar_folder_names=["src/dev_tools/javascript_language_tests"]
            b_x=Kibuvits_krl171_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         when "MMMV_DEVEL_TOOLS_HOME"
            ar_file_names=["README.md","src/etc/mmmv_devel_tools_default_configuration.rb"]
            ar_folder_names=["src/mmmv_devel_tools","src/bonnet","src/etc","src/api"]
            b_x=Kibuvits_krl171_fs.b_env_not_set_or_has_improper_path_t1(
            s_env_name,msgcs,ar_file_names,ar_folder_names)
            return true if b_x
            next
         else
            msg="\nEnvironment variable named "+s_env_name+
            " is not yet supported by this function.\n"
            kibuvits_krl171_throw(msg)
         end # case s_env_name
      end # loop
      return false
   end # b_softf1_com_envs_NOT_OK

   def Kibuvits_krl171_apparch_specific.b_softf1_com_envs_NOT_OK(
      s_or_ar_environment_variable_names,msgcs)
      b_out=Kibuvits_krl171_apparch_specific.instance.b_softf1_com_envs_NOT_OK(
      s_or_ar_environment_variable_names,msgcs)
      return b_out
   end # Kibuvits_krl171_apparch_specific.b_softf1_com_envs_NOT_OK

   #-----------------------------------------------------------------------

   # Files will not be modified.
   # The text that is read from comment string files
   # is converted to a block of single-liner-comments.
   #
   # The single-liner comment start string is determined
   # by the file extension of the s_fp_src.
   #
   # Returns a string.
   def s_prefix_a_source_file_with_comment_texts_t1(
      s_fp_src,s_fp_or_ar_fp_comment_strings,msgcs)
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_fp_src
         kibuvits_krl171_typecheck bn, [Array,String], s_fp_or_ar_fp_comment_strings
         kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(
         bn,String,s_fp_or_ar_fp_comment_strings)
      end # if
      #--------
      ar_fp=[s_fp_src]
      if s_fp_or_ar_fp_comment_strings.class==Array
         ar_fp=ar_fp+s_fp_or_ar_fp_comment_strings
      else
         ar_fp<<s_fp_or_ar_fp_comment_strings
      end # if
      ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(
      ar_fp,'is_file,readable')
      s_output_message_language=$kibuvits_krl171_lc_English
      b_throw=true
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures,s_output_message_language,b_throw)
      #--------
      ar_fp_comment_strings=Kibuvits_krl171_ix.normalize2array(
      s_fp_or_ar_fp_comment_strings)
      ar_s_comment_strings=Array.new
      s_comment=nil
      ar_fp_comment_strings.each do |s_fp|
         s_comment=file2str(s_fp)
         ar_s_comment_strings<<s_comment
      end # loop
      #--------
      s_lang_name=Kibuvits_krl171_file_intelligence.file_language_by_file_extension(
      s_fp_src,msgcs)
      msgcs.assert_lack_of_failures("GUID='325cd5c3-57a2-42ad-ab4d-c2c2f051a4e7'")
      ar_s_singleliner_prefixes=Kibuvits_krl171_comments_detector.ar_get_singleliner_comment_start_tags(
      s_lang_name,msgcs)
      msgcs.assert_lack_of_failures("GUID='59f19377-7e15-4a63-831d-c2c2f051a4e7'")
      kibuvits_krl171_assert_array_min_length(bn,ar_s_singleliner_prefixes,1,
      "GUID='190827cd-8a59-4e46-b9ec-c2c2f051a4e7'")
      s_singleliner_prefix=ar_s_singleliner_prefixes[0]+$kibuvits_krl171_lc_space
      #--------
      s_sl_prefix=s_singleliner_prefix+$kibuvits_krl171_lc_space
      s_sl_prefix_lb_0=s_singleliner_prefix+$kibuvits_krl171_lc_linebreak
      s_sl_prefix_lb_1=s_singleliner_prefix+"="*(75-s_singleliner_prefix.length)+$kibuvits_krl171_lc_linebreak
      s_sl_prefix_lb_2=s_sl_prefix_lb_0+s_sl_prefix_lb_1+s_sl_prefix_lb_0
      ar_s_comment_strings_1=Array.new
      ar_lines=nil
      ar_s_comment_strings.each do |s_comment|
         ar_lines=Array.new
         s_comment.each_line do |s_line|
            ar_lines<<(s_sl_prefix+s_line)
         end # loop
         ar_lines<<s_sl_prefix_lb_2
         ar_s_comment_strings_1<<kibuvits_krl171_s_concat_array_of_strings(ar_lines)
      end # loop
      #--------
      # The content of the file with the
      # path of the s_fp_src is not a comment string, but
      # it's more efficient to reuse the ar_s_comment_strings_1 instance.
      ar_s_comment_strings_1<<(file2str(s_fp_src))
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s_comment_strings_1)
      return s_out
   end # prefix_a_source_file_with_comment_text_t1

   def Kibuvits_krl171_apparch_specific.s_prefix_a_source_file_with_comment_texts_t1(
      s_fp_src,s_fp_or_ar_fp_comment_strings,msgcs)
      s_out=Kibuvits_krl171_apparch_specific.instance.s_prefix_a_source_file_with_comment_texts_t1(
      s_fp_src,s_fp_or_ar_fp_comment_strings,msgcs)
      return s_out
   end # Kibuvits_krl171_apparch_specific.s_prefix_a_source_file_with_comment_texts_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_apparch_specific
#=====================kibuvits_krl171_apparch_specific_rb_end=====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_apparch_specific_rb_start".
#==========================================================================

#=====================kibuvits_krl171_configfileparser_t1_rb_start================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_configfileparser_t1_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"

#--------------------------------------------------------------------------

class Kibuvits_krl171_configfileparser_t1
   #-----------------------------------------------------------------------
   private

   def ht_parse_configstring_collect_var(ht_opmem)
      ht_out=ht_opmem['ht_out']
      ht_out[ht_opmem['s_varname']]=ht_opmem['s_varvalue']
      ht_opmem['s_varvalue']=""
   end # ht_parse_configstring_collect_var

   def ht_parse_configstring_azl_heredoc(ht_opmem)
      s_line=ht_opmem['s_line']
      s_entag=ht_opmem['s_heredoc_endtag']
      if s_line.index(s_entag)==nil
         # It modifies the instance that resides in the hashtable.
         ht_opmem['s_varvalue']<<(s_line+$kibuvits_krl171_lc_linebreak)
         return
      end # if
      s_varvalue=ht_opmem['s_varvalue']
      # The next line gets rid of the very last line break in the s_varvalue.
      s_varvalue=Kibuvits_krl171_ix.sar(s_varvalue,0,(s_varvalue.length-1))
      ht_opmem['s_varvalue']=s_varvalue
      ht_parse_configstring_collect_var ht_opmem
      ht_opmem['b_in_heredoc']=false
   end # ht_parse_configstring_azl_heredoc

   # Answer of false means only, that the line is definitely not a
   # proper comment line.
   def ht_parse_configstring_azl_nonheredoc_line_is_a_comment_line(s_line)
      b_out=true
      i_n_equals_signs=Kibuvits_krl171_str.i_count_substrings(s_line,$kibuvits_krl171_lc_equalssign)
      return b_out if i_n_equals_signs==0
      i_n_commented_equals_signs=Kibuvits_krl171_str.i_count_substrings(s_line,"\\=")
      return b_out if i_n_commented_equals_signs==i_n_equals_signs
      b_out=false
      return b_out
   end # ht_parse_configstring_azl_nonheredoc_line_is_a_comment_line

   def ht_parse_configstring_azl_nonheredoc(ht_opmem)
      s_line=ht_opmem['s_line']
      if KIBUVITS_krl171_b_DEBUG
         if s_line.index($kibuvits_krl171_lc_linebreak)!=nil
            kibuvits_krl171_throw "s_line contains a line break, s_line=="+s_line
         end # if
      end # if
      # The \= is used in comments and it can appear in the
      # value part of the non-heredoc assignment line.
      # The = can also appear in the
      # value part of the non-heredoc assignment line.
      if ht_parse_configstring_azl_nonheredoc_line_is_a_comment_line(s_line)
         return
      end # if
      msgcs=ht_opmem['msgcs']
      # If we are here, then that means that the s_line has at least
      # one equals sign that is an assignment equals sign.
      #
      # Possible versions:
      # ^[=]
      # ^whatever_that_does_not_contain_an_assignmet_equals_sign [=] whatever_that_might_even_contain_assignment_equals_signs
      s_l=$kibuvits_krl171_lc_space+s_line # to match the ^[=] with ^[^\\][=]
      i_assignment_equals_sign_one_leftwards=s_l.index(/[^\\]=/)
      i_comments_equals_sign=s_l.index(/[\\]=/)
      if i_comments_equals_sign!=nil
         if i_comments_equals_sign<i_assignment_equals_sign_one_leftwards
            msgcs.cre "A nonheredoc line is not allowed "+
            "to have \"\\=\" to the left of the [^\\]= .\n"+
            "s_line==\""+s_line+"\".",10.to_s
            msgcs.last['Estonian']="Tsitaatsõne "+
            "koosseisu mitte kuuluval real ei või asuda sõne "+
            "\"\\=\" sõnest [^\\]= vasakul. \n"
            "s_line==\""+s_line+"\"."
            return
         end # if
      end # if
      # At this line all possible comments equals signs, if they exist,
      # reside to the right of the leftmost assignment equals sign.
      #
      #     |_|=|x|=|x
      #     0 1 2 3 4
      #
      #       |=|x|=|x
      #       0 1 2 3
      #
      s_left_with_equals_sign,s_right=Kibuvits_krl171_ix.bisect_at_sindex(s_line,
      (i_assignment_equals_sign_one_leftwards+1))
      s_left,s_right_with_equals_sign=Kibuvits_krl171_ix.bisect_at_sindex(s_line,
      i_assignment_equals_sign_one_leftwards)
      s_left=Kibuvits_krl171_str.trim(s_left)
      s_right=Kibuvits_krl171_str.trim(s_right)
      if s_left.length==0
         msgcs.cre "A nonheredoc line is not allowed "+
         "to have \"=\" as the first "+
         "character that differs from spaces and tabs. "+
         "s_line==\""+s_line+"\".",3.to_s
         msgcs.last['Estonian']="Tsitaatsõne "+
         "koosseisu mitte kuuluva rea esimene mitte-tühikust ning "+
         "mitte-tabulatsioonimärgist tähemärk ei või olla \"=\". "+
         "s_line==\""+s_line+"\"."
         return
      end # if
      if (s_left.gsub(/[\s\t]+/,$kibuvits_krl171_lc_emptystring).length)!=(s_left.length)
         msgcs.cre "Variable names are not allowed to contain "+
         "spaces and tabs."+
         "s_line==\""+s_line+"\".",4.to_s
         msgcs.last['Estonian']="Muutujate nimed "+
         "ei või sisaldada tühikuid ja tabulatsioonimärke. "+
         "s_line==\""+s_line+"\"."
         return
      end # if
      ht_out=ht_opmem["ht_out"]
      if ht_out.has_key? s_left
         msgcs.cre"Variable named \""+s_left+"\" has been "+
         "declared more than once. "+
         "s_line==\""+s_line+"\".",5.to_s
         msgcs.last['Estonian']="Muutujate nimega \""+s_left+
         "\" on deklareeritud rohkem kui üks kord. "+
         "s_line==\""+s_line+"\"."
         return
      end # if
      ht_opmem['s_varname']=s_left

      if s_right.length==0
         msgcs.cre "There is only an empty strings or "+
         "spaces and tabs after the \"=\" character "+
         "in a nonheredoc string. "+
         "s_line==\""+s_line+"\".",6.to_s
         msgcs.last['Estonian']="Tsitaatsõne "+
         "koosseisu mitte kuuluva rea \"=\" märgi järgi on kas "+
         "tühi sõne või ainult tühikud ning tabulatsioonimärgid. "+
         "s_line==\""+s_line+"\"."
         return
      end # if

      rgx_1=/HEREDOC/
      if s_right.index(rgx_1)==nil
         ht_opmem['s_varvalue']=s_right
         ht_parse_configstring_collect_var ht_opmem
         return
      end # if
      # The s_right got trimmed earlier in this function.
      rgx_2=/.HEREDOC/
      if s_right.index(rgx_2)!=nil
         # s_right=="This sentence contains the word HEREDOC"
         msgcs.cre "Only spaces and tabs are allowed to be "+
         "present between the assignment equals sign and the HEREDOC "+
         "start tag.\n"+
         "s_line==\""+s_line+"\".",12.to_s
         msgcs.last['Estonian']="Omistusvõrdusmärgi ja Tsitaatsõne "+
         "algustunnuse vahel\n"+
         "tohib olla vaid tühikuid ning tabulatsioonimärke. \n"+
         "s_line==\""+s_line+"\"."
         return
      end # if
      # If there are 2 words that form a trimmed string, then
      # there is only a single gap, in this case, a single space character,
      # between them. "word1 word2", "word1 word2 word3".
      s_right_noralized=s_right.gsub(/([\s]|[\t])+/,$kibuvits_krl171_lc_space)

      # There are also faulty cases like
      #     x=HEREDOC42
      #         Spooky ghost
      #     HEREDOC_END
      #
      #     x=HEREDOC42 the_custom_end
      #         Spooky ghost
      #     the_custom_end
      #
      # but for the time being one just defines it so that the
      # x will have the value of HEREDOC42 and the rest of the
      # 2 lines will be comments.
      rgx_3=/HEREDOC[^\s]/
      if s_right_noralized.index(rgx_3)!=nil
         ht_opmem['b_in_heredoc']=false
         ht_opmem['s_varvalue']=s_right
         ht_parse_configstring_collect_var ht_opmem
         return
      end # if

      i_n_of_spaces=Kibuvits_krl171_str.i_count_substrings(s_right_noralized,$kibuvits_krl171_lc_space)
      if i_n_of_spaces==0
         ht_opmem['b_in_heredoc']=true
         ht_opmem['s_heredoc_endtag']=ht_opmem['s_hredoc_end_tag_default']
         return
      end # if
      if i_n_of_spaces==1
         i_space_ix=s_right_noralized.index($kibuvits_krl171_lc_space)
         s_irrelevant,s_heredoc_endtag=Kibuvits_krl171_ix.bisect_at_sindex(
         s_right_noralized,(i_space_ix+1)) # The +1 is for removing the space character.
         ht_opmem['b_in_heredoc']=true
         ht_opmem['s_heredoc_endtag']=s_heredoc_endtag
         return
      end # if
      # Here 1<i_n_of_spaces
      msgcs.cre "Heredoc end tag may not contain "+
      "spaces and tabs. "+
      "s_line==\""+s_line+"\".",8.to_s
      msgcs.last['Estonian']="Tsitaatsõne lõputunnus ei või "+
      "sisaldada tühikuid ning tabulatsioonimärke. "+
      "s_line==\""+s_line+"\"."
   end # ht_parse_configstring_azl_nonheredoc

   def ht_parse_configstring_create_ht_opmem(msgcs)
      ht_opmem=Hash.new
      ht_opmem['s_line']=""
      ht_opmem['b_in_heredoc']=false
      s_hredoc_end_tag_default="HEREDOC_END"
      ht_opmem['s_hredoc_end_tag_default']=s_hredoc_end_tag_default
      ht_opmem['s_hredoc_end_tag']=s_hredoc_end_tag_default
      ht_opmem['s_varname']=""
      ht_opmem['s_varvalue']=""
      ht_opmem['ht_out']=Hash.new
      ht_opmem['msgcs']=msgcs
      return ht_opmem
   end # ht_parse_configstring_create_ht_opmem


   public
   # A word of warning is that unlike configurations utilities,
   # i.e. settings dialogs, configurations files do not check the
   # consistency of the configuration and do not assist the user.
   # For example, in the case of a configurations dialog, it's possible
   # to change the content of one menu based on the selection of the other.
   #
   # Configurations string format example:
   #
   #-the-start-of-the-ht_parse_configstring-usage-example-DO-NOT-CHANGE-THIS-LINE
   # i_error_code=500
   # s_formal_explanation=HEREDOC
   #          Internal Error. The server encountered an unexpected condition
   #          which prevented it from fulfilling the request.
   # HEREDOC_END
   #
   # s_true_explanation=HEREDOC
   #
   #          The reason, why this software does not work the way
   #          You expected it to work, is that the developers obeyed their
   #          boss in stead of using their own heads.
   #
   #          Be prepared that in the future You'll get the same kind of
   #          quality from those developers, because they are willing to
   #          do a lousy job just to avoid getting dismissed. Probably
   #          they are going to keep on doing that till their retirement.
   #
   # HEREDOC_END
   #
   # Anything that is not part of heredoc and is not part of the
   # traditional assignment expression, is a comment. Equals signs
   # within comments must be escaped like \=
   #
   #     This\= 42 is a comment line.
   #     This0 = is an assignment line.
   #     This1 = is an assignment line that contains  = within its value.
   #     This2 = is an assignment line that contains \= within its value.
   #
   # demovar=HEREDOC Spooky
   #     The default heredoc end tag is the HEREDOC_END, but
   #     by declaring a custom, temporary, heredoc end tag it
   #     is possible to use the HEREDOC_END within the heredoc text.
   # Spooky
   #
   # demovar2=HEREDOC
   #     The heredoc format allows to use the keyword HEREDOC as
   #     part of the value. The reason, why the name of the variable
   #     here is demovar2 in stead of just demovar is that the
   #     variable demovar has been declared in the previous demo bloc
   #     and no variable is allowed to be declared more than once.
   # HEREDOC_END
   #
   # wow=HEREDOC42
   #     This line is not part of the heredoc, because
   #     HEREDOC42 is not a keyword. This line is just a comment.
   # HEREDOC_END
   #
   # wow2=HEREDOC
   #     HEREDOC is usually a keyword, but it is not a keyword,
   #     if it resides in the value part of the heredoc.
   # HEREDOC_END
   #
   # If the HEREDOC is not to the right of an unescaped equals sign,
   # then it is not interpreted as a key-word and is part of a comment.
   #
   # Actually this very same string string fragment is part of the
   # selftests. The ht_parse_configstring selftest code extracts it
   # from the KRL ruby file, where the ht_parse_configstring is defined.
   #
   #-the-end---of-the-ht_parse_configstring-usage-example-DO-NOT-CHANGE-THIS-LINE
   #
   # The motive behind such a comment-sign-free configurations file
   # format is that usually parameter explanation comments have
   # more characters than parameter declarations themselves and
   # by making declarations "special" and comments "common", the "average"
   # amount of compulsory boiler-plate characters decreases.
   # Some of the credits go to the authors of the YAML specification,
   # because the YAML files are truly human friendly, if compared to
   # the JSON and the dinosaur of structured text formats, the XML.
   #
   # The recommended file extension of text files that are
   # in the format of the Kibuvits_krl171_configfileparser_t1 is "txt_krlconfig_t1".
   # An example:
   #
   #     my_preferences.txt_krlconfig_t1
   #
   def ht_parse_configstring(s_a_config_file_style_string,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_a_config_file_style_string
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
      end # if
      s_in=Kibuvits_krl171_str.normalise_linebreaks(s_a_config_file_style_string)
      ht_opmem=ht_parse_configstring_create_ht_opmem(msgcs)
      s_in.each_line do |s_line_with_optional_linebreak_character|
         s_line=Kibuvits_krl171_str.clip_tail_by_str(
         s_line_with_optional_linebreak_character,$kibuvits_krl171_lc_linebreak)
         ht_opmem['s_line']=s_line
         if ht_opmem['b_in_heredoc']
            ht_parse_configstring_azl_heredoc(ht_opmem)
         else
            ht_parse_configstring_azl_nonheredoc(ht_opmem)
         end # if
         break if msgcs.b_failure
      end # loop
      ht_out=ht_opmem['ht_out']
      if ht_opmem['b_in_heredoc']
         s_varname=ht_opmem['s_varname'].to_s
         msgcs.cre "Heredoc for variable named \""+
         s_varname+"\" is incomplete.",9.to_s
         msgcs.last['Estonian']="Tsitaatsõne, mille muutuja "+
         "nimi on \""+s_varname+"\" on ilma tsitaatsõne lõpetustunnuseta."
      end # if
      if msgcs.b_failure
         ht_out=Hash.new # == clear
         return ht_out
      end # if
      return ht_out
   end # ht_parse_configstring


   def Kibuvits_krl171_configfileparser_t1.ht_parse_configstring(s_a_config_file_style_string,
      msgcs=Kibuvits_krl171_msgc_stack.new)
      ht_out=Kibuvits_krl171_configfileparser_t1.instance.ht_parse_configstring(
      s_a_config_file_style_string,msgcs)
      return ht_out
   end # Kibuvits_krl171_configfileparser_t1.ht_parse_configstring

   #-----------------------------------------------------------------------
   include Singleton

end # class Kibuvits_krl171_configfileparser_t1
#=====================kibuvits_krl171_configfileparser_t1_rb_end==================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_configfileparser_t1_rb_start".
#==========================================================================


#=====================kibuvits_krl171_cg_rb_start=================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cg_rb_end".
#==========================================================================
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
#=========================================================================

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"

#==========================================================================

# The "cg" in the name of the class Kibuvits_krl171_cg
# stands for "code generation".
class Kibuvits_krl171_cg
   private
   @@lc_blstp="[CODEGENERATION_BLANK_"# blstp==="blank search string prefix"
   @@lc_blstp_guid="[CODEGENERATION_BLANK_GUID_"

   # The @@lc_ar_blsts exists only for speed. Its initialization relies
   # on this class being a singleton.
   @@lc_ar_blsts=[]

   public
   def initialize
      @@lc_ar_blsts<<@@lc_blstp+"0]"
      @@lc_ar_blsts<<@@lc_blstp+"1]"
      @@lc_ar_blsts<<@@lc_blstp+"2]"
      @@lc_ar_blsts<<@@lc_blstp+"3]"
   end #initialize

   private

   # It practically counts the number of differnet
   # guid needles from the s_form.
   def fill_form_guids_get_ht_needles(s_form, s_prefix)
      ht_needles=Hash.new
      s_needle=nil
      i=0
      while true
         s_needle=s_prefix+i.to_s+$kibuvits_krl171_lc_rsqbrace
         break if !s_form.include? s_needle
         ht_needles[s_needle]=Kibuvits_krl171_GUID_generator.generate_GUID
         i=i+1
      end # loop
      return ht_needles
   end # fill_form_guids_get_ht_needles


   def fill_form_guids s_form, s_guid_searchstring_prefix
      s_prefix=@@lc_blstp_guid
      if s_guid_searchstring_prefix!=nil
         s_prefix=s_guid_searchstring_prefix
      end # if
      ht_needles=fill_form_guids_get_ht_needles(s_form, s_prefix)
      s_out=Kibuvits_krl171_str.s_batchreplace(ht_needles,s_form)
      return s_out
   end # fill_form_guids

   public
   def fill_form(ar_or_s_blank_value,s_form,
      s_searchstring_prefix=nil,
      s_guid_searchstring_prefix=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Array,String], ar_or_s_blank_value
         kibuvits_krl171_typecheck bn, String, s_form
         kibuvits_krl171_typecheck bn, [NilClass,String], s_searchstring_prefix
         kibuvits_krl171_typecheck bn, [NilClass,String], s_guid_searchstring_prefix
      end # if
      s_out=$kibuvits_krl171_lc_emptystring+s_form
      return s_out if s_out.length==0
      s_out=fill_form_guids(s_out,s_guid_searchstring_prefix)
      ar_blank_values=Kibuvits_krl171_ix.normalize2array(ar_or_s_blank_value)
      # The order of the blank values in the ar_blank_values is important.
      i_len=ar_blank_values.length
      return s_out if i_len==0
      return s_out if (i_len==1)&&(ar_blank_values[0].length==0)
      s_blst=nil
      b=(s_searchstring_prefix==nil)&&(i_len<=@@lc_ar_blsts.length)
      ht_needles=Hash.new
      s_blank_value=nil
      if b
         i_len.times do |i|
            s_blst=@@lc_ar_blsts[i]
            s_blank_value=ar_blank_values[i]
            # The next line is a quick hack for Kibuvits_krl171_str.s_batchreplace bug workaround.
            s_blank_value=$kibuvits_krl171_lc_space if s_blank_value==$kibuvits_krl171_lc_emptystring
            ht_needles[s_blst]=s_blank_value
         end # loop
      else
         s_prefix=@@lc_blstp
         s_prefix=s_searchstring_prefix if s_searchstring_prefix!=nil
         i_len.times do |i|
            s_blst=s_prefix+i.to_s+$kibuvits_krl171_lc_rsqbrace
            ht_needles[s_blst]=ar_blank_values[i]
         end # loop
      end #
      s_out=Kibuvits_krl171_str.s_batchreplace(ht_needles,s_out)
      return s_out
   end # fill_form

   def Kibuvits_krl171_cg.fill_form(ar_or_s_blank_value,s_form,
      s_searchstring_prefix=nil,
      s_guid_searchstring_prefix=nil)
      s_out=Kibuvits_krl171_cg.instance.fill_form(ar_or_s_blank_value,s_form,
      s_searchstring_prefix, s_guid_searchstring_prefix)
      return s_out
   end # Kibuvits_krl171_cg.fill_form


   public

   @s_form_func_tables_exist_entry=""+
   "			$b=$b&&($this->db_->table_exists([CODEGENERATION_BLANK_0]));\n"



   # The idea is that a list like:
   #
   #  List_header
   #     elem1
   #     elem2
   #     ...
   #  List_footer
   #
   # can be seen as:
   #
   #  List_header
   #     [CODEGENERATION_BLANK_0]
   #  List_footer
   #
   # where each of the elements is given by a form that also has
   # a blank naemed  [CODEGENERATION_BLANK_0].
   def assemble_list_by_forms(s_list_form,s_list_element_form,
      s_or_ar_of_element_form_blank_values)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_list_form
         kibuvits_krl171_typecheck bn, String, s_list_element_form
         kibuvits_krl171_typecheck bn, [Array,String], s_or_ar_of_element_form_blank_values
      end # if
      ar=Kibuvits_krl171_ix.normalize2array(s_or_ar_of_element_form_blank_values)
      s_list=""
      s=nil
      s_element_form_blank=nil
      i_arlen=ar.length
      i_arlen.times do |i|
         s_element_form_blank=ar[i]
         s=Kibuvits_krl171_cg.fill_form(s_element_form_blank,s_list_element_form)
         s_list=s_list+s
      end # loop
      s_out=Kibuvits_krl171_cg.fill_form(s_list,s_list_form)
      return s_out
   end # assemble_list_by_forms

   def Kibuvits_krl171_cg.assemble_list_by_forms(s_list_form,s_list_element_form,
      s_or_ar_of_element_form_blank_values)
      s_out=Kibuvits_krl171_cg.instance.assemble_list_by_forms(
      s_list_form,s_list_element_form,s_or_ar_of_element_form_blank_values)
      return s_out
   end # Kibuvits_krl171_cg.assemble_list_by_forms


   public
   def get_standard_warning_msg(s_singleliner_comment_start,
      s_code_generation_region_name="")
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_singleliner_comment_start
         kibuvits_krl171_typecheck bn, String, s_code_generation_region_name
      end # if
      s_out=$kibuvits_krl171_lc_8_spaces+s_singleliner_comment_start+
      " WARNING: This function resides in an autogeneration region.\n"
      if s_code_generation_region_name!=""
         s_out=s_out+$kibuvits_krl171_lc_8_spaces+s_singleliner_comment_start+
         " This code has been autogenerated by: "+
         s_code_generation_region_name+" \n"
      end # if
      return s_out
   end # get_standard_warning_msg

   def Kibuvits_krl171_cg.get_standard_warning_msg(s_singleliner_comment_start,
      s_code_generation_region_name="")
      s_out=Kibuvits_krl171_cg.instance.get_standard_warning_msg(
      s_singleliner_comment_start, s_code_generation_region_name)
      return s_out
   end # Kibuvits_krl171_cg.get_standard_warning_msg

   include Singleton
end # class Kibuvits_krl171_cg
#==========================================================================
#s=Kibuvits_krl171_cg.fill_form([],"")
#=====================kibuvits_krl171_cg_rb_end===================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cg_rb_start".
#==========================================================================

#=====================kibuvits_krl171_cg_php_t1_rb_start==========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cg_php_t1_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"

#==========================================================================

# The "cg" in the name of the class Kibuvits_krl171_cg_php_t1
# stands for "code generation".
class Kibuvits_krl171_cg_php_t1

   def initialize
      @s_lc_escapedsinglequote="\\'".freeze
   end #initialize

   #-----------------------------------------------------------------------

   private

   def s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_elem,rgx_0)
      if x_elem.class==String
         s_elem=($kibuvits_krl171_lc_singlequote+
         x_elem.gsub(rgx_0,@s_lc_escapedsinglequote)+$kibuvits_krl171_lc_singlequote)
         ar_s<<s_elem
      else # Fixnum or Float
         ar_s<<x_elem.to_s
      end # if
   end # s_ar_or_ht_2php_t1_x_elem_2_ar_s


   def s_ar_or_ht_2php_t1_array(s_corrected_php_array_variable_name,
      ar_of_numbers_or_strings,i_row_length)
      #----------
      i_len=ar_of_numbers_or_strings.size
      b_nonfirst=false
      ar_s=Array.new
      ar_s<<s_corrected_php_array_variable_name
      ar_s<<"=array("
      #----------
      x_elem=nil
      rgx_0=/[']/
      i_len.times do |ix|
         if b_nonfirst
            ar_s<<$kibuvits_krl171_lc_comma
         else
            b_nonfirst=true
         end # if
         ar_s<<($kibuvits_krl171_lc_linebreak+"   ") if ((ix%i_row_length)==0) && (0<ix)
         x_elem=ar_of_numbers_or_strings[ix]
         s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_elem,rgx_0)
      end # loop
      #----------
      ar_s<<");"
      ar_s<<$kibuvits_krl171_lc_linebreak
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_out
   end # s_ar_or_ht_2php_t1_array


   public

   # The elements/keys/values of the ar_or_ht_of_numbers_or_strings can
   # are allowd to be a mixture of types String, Fixnum, Float.
   def s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_of_numbers_or_strings,i_row_length=7)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_php_array_variable_name
         kibuvits_krl171_typecheck bn, [Array,Hash], ar_or_ht_of_numbers_or_strings
         kibuvits_krl171_typecheck bn, Fixnum, i_row_length
         #----
         s_varname=s_php_array_variable_name.sub(/^[$]/,$kibuvits_krl171_lc_emptystring)
         kibuvits_krl171_assert_ok_to_be_a_varname_t1(bn,s_varname,
         "GUID='3064e1c3-00ae-490f-b1ac-c2c2f051a4e7'\n")
         #----
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn, 1, i_row_length,
         "GUID='5c13a615-277a-4c55-947c-c2c2f051a4e7'\n")
         ar_cl=[Fixnum,Float,String]
         if ar_or_ht_of_numbers_or_strings.class==Array
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,
            ar_cl,ar_or_ht_of_numbers_or_strings,
            "GUID='f9f7ac3d-70a3-42fa-a24c-c2c2f051a4e7'\n")
         else # ar_or_ht_of_numbers_or_strings.class==Hash
            ar_keys=ar_or_ht_of_numbers_or_strings.keys
            ar_values=ar_or_ht_of_numbers_or_strings.values
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,
            ar_cl,ar_keys, "GUID='d570c845-6f39-4224-b21c-c2c2f051a4e7'\n")
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,
            ar_cl,ar_values, "GUID='99a7ae18-e1aa-4f6b-b5eb-c2c2f051a4e7'\n")
         end # if
      end # if
      #----------
      s_corrected_php_array_variable_name=$kibuvits_krl171_lc_dollarsign+
      s_php_array_variable_name.sub(/^[$]/,$kibuvits_krl171_lc_emptystring)
      s_out=nil
      if ar_or_ht_of_numbers_or_strings.class==Array
         ar_in=ar_or_ht_of_numbers_or_strings
         s_out=s_ar_or_ht_2php_t1_array(s_corrected_php_array_variable_name,
         ar_in,i_row_length)
      else # ar_or_ht_of_numbers_or_strings.class==Hash
         ar_s=Array.new
         ar_s<<s_corrected_php_array_variable_name
         ar_s<<"=array();\n"
         ht_in=ar_or_ht_of_numbers_or_strings
         rgx_0=/[']/
         s_elem=nil
         lc_s_0=(s_corrected_php_array_variable_name+"[").freeze
         lc_s_1="]=".freeze
         lc_s_2=($kibuvits_krl171_lc_semicolon+" ").freeze
         ix=0
         ht_in.each_pair do |x_key,x_value|
            ar_s<<$kibuvits_krl171_lc_linebreak+"   " if ((ix%i_row_length)==0) && (0<ix)
            ar_s<<lc_s_0
            s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_key,rgx_0)
            ar_s<<lc_s_1
            s_ar_or_ht_2php_t1_x_elem_2_ar_s(ar_s,x_value,rgx_0)
            ar_s<<lc_s_2
            ix=ix+1
         end # loop
         ar_s<<$kibuvits_krl171_lc_linebreak
         s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      end # if
      return s_out
   end # s_ar_or_ht_2php_t1


   def Kibuvits_krl171_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
      ar_or_ht_of_numbers_or_strings,i_row_length=7)
      s_out=Kibuvits_krl171_cg_php_t1.instance.s_ar_or_ht_2php_t1(
      s_php_array_variable_name,ar_or_ht_of_numbers_or_strings,i_row_length)
      return s_out
   end # Kibuvits_krl171_cg_php_t1.s_ar_or_ht_2php_t1

   #-----------------------------------------------------------------------

   def s_var(a_binding,x_ruby_variable,i_row_length=7)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         ar_types=[Fixnum,Float,String,TrueClass,FalseClass,Hash,Array]
         kibuvits_krl171_typecheck bn, Binding, a_binding
         kibuvits_krl171_typecheck bn, ar_types, x_ruby_variable
         kibuvits_krl171_typecheck bn, Fixnum, i_row_length
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn, 1, i_row_length,
         "GUID='51260f14-df53-4734-8dab-c2c2f051a4e7'\n")
      end # if
      s_variable_name=kibuvits_krl171_s_varvalue2varname(a_binding,x_ruby_variable)
      s_out=nil
      s_cl=x_ruby_variable.class.to_s
      case s_cl
      when "Fixnum"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s+";\n"
      when "Float"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s+";\n"
      when "String"
         s_out="$"+s_variable_name+"='"+x_ruby_variable+"';\n"
      when "Hash"
         s_out=s_ar_or_ht_2php_t1(s_variable_name,x_ruby_variable,i_row_length)
      when "Array"
         s_out=s_ar_or_ht_2php_t1(s_variable_name,x_ruby_variable,i_row_length)
      when "TrueClass"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s.upcase+";\n"
      when "FalseClass"
         s_out="$"+s_variable_name+"="+x_ruby_variable.to_s.upcase+";\n"
      when "NilClass" # a bit risky?
         # Not reached due to entry tests, but here in a role of a comment.
         s_out="$"+s_variable_name+"=NULL;\n"
      else
         kibuvits_krl171_throw("s_cl == "+s_cl+
         ", which is not yet supported by this method."+
         "\n GUID='e640deaf-c47f-44d4-827b-c2c2f051a4e7'\n\n")
      end # case s_cl
      return s_out
   end # s_var(a_binding,x_ruby_variable)

   def Kibuvits_krl171_cg_php_t1.s_var(a_binding,x_ruby_variable,i_row_length=7)
      s_out=Kibuvits_krl171_cg_php_t1.instance.s_var(
      a_binding,x_ruby_variable,i_row_length)
      return s_out
   end # Kibuvits_krl171_cg_php_t1.s_var(a_binding,x_ruby_variable)

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_cg_php_t1

#=========================================================================

# s_php_array_variable_name="arht_uuu"
# ar_or_ht_x=Hash.new
# ar_or_ht_x["ee"]=44
# ar_or_ht_x[55]="ihii"
# ar_or_ht_x[57]=4.5
# s_x=Kibuvits_krl171_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
# ar_or_ht_x)
#=====================kibuvits_krl171_cg_php_t1_rb_end============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cg_php_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_cg_html_t1_rb_start=========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cg_html_t1_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str.rb"

#==========================================================================

# The "cg" in the name of the class Kibuvits_krl171_cg_html_t1
# stands for "code generation".
class Kibuvits_krl171_cg_html_t1

   def initialize
   end # initialize

   def s_place_2_table_t1(i_number_of_columns,ar_cell_content_html,
      s_table_tag_attributes=$kibuvits_krl171_lc_emptystring,
      s_cell_tag_attributes=$kibuvits_krl171_lc_emptystring)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Fixnum, i_number_of_columns
         kibuvits_krl171_typecheck bn, Array, ar_cell_content_html
         kibuvits_krl171_typecheck bn, String, s_table_tag_attributes
         kibuvits_krl171_typecheck bn, String, s_cell_tag_attributes
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         1, i_number_of_columns,
         "\n GUID='a857202f-75a0-4cf1-954b-c2c2f051a4e7'\n\n")
      end # if
      i_len=ar_cell_content_html.size
      ar_cells_0=nil
      i_0=i_len%i_number_of_columns
      i_1=nil
      i_n_of_cells=i_len+i_0
      i_n_of_rows=i_n_of_cells/i_number_of_columns # == Fixnum
      if i_0==0
         ar_cells_0=ar_cell_content_html
      else
         # A bit dirty due to the extra copying, but makes code simpler.
         # An alternative to the copying would be an if-clause in a loop.
         ar_cells_0=[]+ar_cell_content_html
         i_0.times{ar_cells_0<<$kibuvits_krl171_lc_emptystring}
      end # if
      #---------
      ar_s=Array.new
      ar_s<<"\n<table "+s_table_tag_attributes+" >"
      #---------
      s_lc_td_start=nil
      if 0<s_cell_tag_attributes.length
         s_lc_td_start=("<td "+s_cell_tag_attributes+" >").freeze
      else
         s_lc_td_start="<td>".freeze
      end # if
      s_lc_td_end="</td>".freeze
      s_lc_tr_start="\n    <tr>".freeze
      s_lc_tr_end="\n    </tr>".freeze
      #---------
      ix_elem=0
      i_n_of_rows.times do |i_row|
         ar_s<<s_lc_tr_start
         i_number_of_columns.times do |i_column|
            ar_s<<s_lc_td_start
            ar_s<<ar_cells_0[ix_elem]
            ar_s<<s_lc_td_end
            ix_elem=ix_elem+1
         end # loop
         ar_s<<s_lc_tr_end
      end # loop
      ar_s<<"\n</table>\n"
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
   end # s_place_2_table_t1

   def Kibuvits_krl171_cg_html_t1.s_place_2_table_t1(i_number_of_columns,ar_cell_content_html,
      s_table_tag_attributes=$kibuvits_krl171_lc_emptystring,
      s_cell_tag_attributes=$kibuvits_krl171_lc_emptystring)
      s_out=Kibuvits_krl171_cg_html_t1.instance.s_place_2_table_t1(
      i_number_of_columns,ar_cell_content_html,
      s_table_tag_attributes,s_cell_tag_attributes)
      return s_out
   end # Kibuvits_krl171_cg_html_t1.s_place_2_table_t1

   include Singleton
end # class Kibuvits_krl171_cg_html_t1
#=====================kibuvits_krl171_cg_html_t1_rb_end===========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cg_html_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_numerics_set_0_rb_start=====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_numerics_set_0_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ix.rb"
require "prime"

#==========================================================================


class Kibuvits_krl171_numerics_set_0

   def initialize
   end # initialize

   #-----------------------------------------------------------------------

   # ixs_low and ixs_high are sindexes
   # http://longterm.softf1.com/specifications/array_indexing_by_separators/
   # of an array that is created by Prime.take(i_number_of_primes)
   #
   # This function here is pretty expensive.
   def i_product_of_primes_t1(ixs_low,ixs_high)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, ixs_low,"\n GUID='8cb94f50-3647-4bd0-a11b-c2c2f051a4e7'\n\n")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         ixs_low, ixs_high,"\n GUID='f74dc13c-99e5-4abf-95ea-c2c2f051a4e7'\n\n")
         kibuvits_krl171_typecheck bn, Fixnum, ixs_low
         kibuvits_krl171_typecheck bn, Fixnum, ixs_high
      end # if
      x_identity_element=1
      x_identity_element if ixs_low==ixs_high
      ar_primes=Prime.take(ixs_high)
      ar_factors=Kibuvits_krl171_ix.sar(ar_primes,ixs_low,ixs_high)
      func_star=lambda do |x_a,x_b|
         x_out=x_a*x_b
         return x_out
      end # func_star
      i_out=Kibuvits_krl171_ix.x_apply_binary_operator_t1(
      x_identity_element,ar_factors,func_star)
      return i_out
   end # i_product_of_primes_t1

   def Kibuvits_krl171_numerics_set_0.i_product_of_primes_t1(ixs_low,ixs_high)
      i_out=Kibuvits_krl171_numerics_set_0.instance.i_product_of_primes_t1(ixs_low,ixs_high)
      return i_out
   end # Kibuvits_krl171_numerics_set_0.i_product_of_primes_t1

   #-----------------------------------------------------------------------

   # Calculates the factorial of i_n .
   #
   # For shorter code it is recommended to use
   # the kibuvits_krl171_factorial(...) in stead of calling i
   # this function directly.
   #
   def i_factorial_t1(i_n)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         # Allowing the i_n to be a Bignum is a bit crazy in 2014,
         # but may be in the future that might not be that crazy.
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_n
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,0,i_n,
         "\n GUID='465abdd9-a894-48ae-82ba-c2c2f051a4e7'\n\n")
      end # if
      i_out=1 # factorial(0)==1
      return i_out if i_n==0
      func_star=lambda do |x_a,x_b|
         x_out=x_a*x_b
         return x_out
      end # func_star
      ar_n=Array.new
      # For i_n==2, the ar_n==[0,1,2], ar_n.size==3 .
      # To avoid multiplication with 0, ar_n[0]==1 .
      # Therefore, for i_n==2, ar_n==[1,2] .
      i_n.times{|i| ar_n<<(i+1)} # i starts from 0
      x_identity_element=1
      i_out=Kibuvits_krl171_ix.x_apply_binary_operator_t1(
      x_identity_element,ar_n,func_star)
      return i_out
   end # i_factorial_t1

   def Kibuvits_krl171_numerics_set_0.i_factorial_t1(i_n)
      i_out=Kibuvits_krl171_numerics_set_0.instance.i_factorial_t1(i_n)
      return i_out
   end # Kibuvits_krl171_numerics_set_0.i_factorial_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_numerics_set_0

def kibuvits_krl171_factorial(i_n)
   i_out=Kibuvits_krl171_numerics_set_0.i_factorial_t1(i_n)
   return i_out
end # kibuvits_krl171_factorial

def kibuvits_krl171_combinatorical_variation(i_superset_size,i_subset_size)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      # Allowing the i_n to be a Bignum is a bit crazy, but it's not wrong.
      kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_superset_size
      kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_subset_size
      kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,0,i_subset_size,
      "\n GUID='1bcd4222-df1d-491f-838a-c2c2f051a4e7'\n\n")
      kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,i_subset_size,i_superset_size,
      "\n GUID='3f908fa1-7d73-45e1-815a-c2c2f051a4e7'\n\n")
   end # if
   i_0=kibuvits_krl171_factorial(i_superset_size)
   i_1=kibuvits_krl171_factorial(i_superset_size-i_subset_size)
   i_var=i_0/i_1
   return i_var
end # kibuvits_krl171_combinatorical_variation

def kibuvits_krl171_combination(i_superset_size,i_subset_size)
   if KIBUVITS_krl171_b_DEBUG
      bn=binding()
      # Allowing the i_n to be a Bignum is a bit crazy, but it's not wrong.
      kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_superset_size
      kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_subset_size
      kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,0,i_subset_size,
      "\n GUID='dbf17b40-38da-4137-b11a-c2c2f051a4e7'\n\n")
      kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,i_subset_size,i_superset_size,
      "\n GUID='716b924c-350f-4822-83e9-c2c2f051a4e7'\n\n")
   end # if
   i_var=kibuvits_krl171_combinatorical_variation(
   i_superset_size,i_subset_size)
   i_c=i_var/kibuvits_krl171_factorial(i_subset_size)
   return i_c
end # kibuvits_krl171_combination
#=====================kibuvits_krl171_numerics_set_0_rb_end=======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_numerics_set_0_rb_start".
#==========================================================================

#=====================kibuvits_krl171_rng_rb_start================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_rng_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if


#==========================================================================

# "rng" stands for "random number generator".
#
# There is a rumor that sometimes the standard random generators
# are so bad that their output ends up being on some "high dimensional"
# (how high is high?) hyperplane.
#
#     http://youtu.be/FoKxzorQIhU?t=30m54s
#
# TODO: Think of some recursive and iteration based
#       functions that generate nice pseudorandom
#       sequences. Their values should be bounded
#       like it is the case with the sin(x).
#       Study, how the currently available versions have been
#       implemented.
#
class Kibuvits_krl171_rng

   private

   def ob_gen_instance_of_class_random_t1
      ob_t=Time.now
      i_usec=ob_t.usec
      i_0=(ob_t.to_i.to_s<<i_usec.to_s).to_i
      i_00=(Random.new_seed.to_s<<i_0.to_s).to_i
      if (i_usec%3)==0
         i_00=i_00+i_usec
      else
         i_00=i_00+(i_usec/2+1) if (i_usec%2)==0
      end # if
      i_rand_ps=(`ps -A`).length
      @i_rand_whoami=(`whoami`).length if !defined? @i_rand_whoami
      i_rand_whoami_ps=@i_rand_whoami+i_rand_ps
      ob_random=Random.new(i_00+i_rand_whoami_ps)
      #-----------
      i_0=0
      3.times do
         # TODO replace this sloop with something smarter.
         i_0=i_0+ob_random.rand(900)
         i_0=i_0*(1+ob_random.rand(900))
      end # loop
      i_n_of_loops=(i_0+i_00+i_rand_whoami_ps)%200
      i_0=42
      i_n_of_loops.times do # scrolls the sequence to a semi-random position
         i_0=i_0+ob_random.rand(200)
      end # loop
      @ob_gen_instance_of_class_random_t1_optimization_blocker_1=i_0
      #-----------
      return ob_random
   end # ob_gen_instance_of_class_random_t1

   public

   def initialize
      @i_rand_whoami=(`whoami`).length
      @i_rand_impl_1_ob_random=ob_gen_instance_of_class_random_t1()
      #---------
      @i_rand_impl_1_i_rand_ps=(`ps -A`).length
      @i_rand_impl_1_callcount_ob_random=0
      @i_rand_impl_1_callcount_i_rand_ps=0
      @ob_gen_instance_of_class_random_t1_optimization_blocker_1=42
      #--------------
      @i_random_fast_t1_ob_random=ob_gen_instance_of_class_random_t1()
   end # initialize

   private


   # Output will be in the range of [0,i_max]
   # min(i_max)== 0
   def i_rand_impl_1(i_max,i_n_of_calls_between_the_renewal_of_ob_random,
      i_n_of_calls_between_the_renewal_of_i_rand_ps)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_max
         kibuvits_krl171_typecheck bn, [Fixnum], i_n_of_calls_between_the_renewal_of_ob_random
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_n_of_calls_between_the_renewal_of_i_rand_ps
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_max,"\n GUID='1119c394-8c41-4881-9bb9-c2c2f051a4e7'\n\n")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_n_of_calls_between_the_renewal_of_ob_random,
         "\n GUID='02a5b1b6-b76d-4e9a-9489-c2c2f051a4e7'\n\n")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_n_of_calls_between_the_renewal_of_i_rand_ps,
         "\n GUID='1ffcdbeb-7888-4311-8459-c2c2f051a4e7'\n\n")
      end # if
      #----------------------
      if i_n_of_calls_between_the_renewal_of_ob_random<=@i_rand_impl_1_callcount_ob_random
         @i_rand_impl_1_callcount_ob_random=0
         @i_rand_impl_1_ob_random=ob_gen_instance_of_class_random_t1()
      else
         @i_rand_impl_1_callcount_ob_random=@i_rand_impl_1_callcount_ob_random+1
      end # if
      ob_random=@i_rand_impl_1_ob_random
      #----------------------
      if 0<i_n_of_calls_between_the_renewal_of_i_rand_ps
         if i_n_of_calls_between_the_renewal_of_i_rand_ps<=@i_rand_impl_1_callcount_i_rand_ps
            @i_rand_impl_1_callcount_i_rand_ps=0
            @i_rand_impl_1_i_rand_ps=(`ps -A`).length
         else
            @i_rand_impl_1_callcount_i_rand_ps=@i_rand_impl_1_callcount_i_rand_ps+1
         end # if
      end # if
      i_rand_ps=@i_rand_impl_1_i_rand_ps
      i_rand_whoami_ps=@i_rand_whoami+i_rand_ps
      #----------------------
      i_max_plus_one=i_max+1 # because ( max(Random.rand(n)) == (n-1) )
      i_0=0
      3.times {i_0=i_0+ob_random.rand(i_max_plus_one)}
      ob_t=Time.now
      i_usec=ob_t.usec
      i_0=i_0+(i_usec+i_rand_whoami_ps)
      i_out=i_0%i_max_plus_one
      return i_out
   end # i_rand_impl_1


   public

   # Returns a whole number in range [0,i_max]
   # min(i_max)== 0
   def i_random_t1(i_max)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_max
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_max,"\n GUID='bdfbd12b-9962-49f0-b429-c2c2f051a4e7'\n\n")
      end # if
      ob_random=@i_rand_impl_1_ob_random
      i_0=ob_random.rand(100)
      i_1=ob_random.rand(300)
      i_out=i_rand_impl_1(i_max,(300+i_0),(3013+i_1))
      return i_out
   end # i_random_t1

   def Kibuvits_krl171_rng.i_random_t1(i_max)
      i_out=Kibuvits_krl171_rng.instance.i_random_t1(i_max)
      return i_out
   end # Kibuvits_krl171_rng.i_random_t1

   #-----------------------------------------------------------------------

   # Returns a whole number in range [0,i_max]
   # min(i_max)== 1
   def i_random_fast_t1(i_max)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_max
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_max,"\n GUID='30272b63-3cf7-4465-acf8-c2c2f051a4e7'\n\n")
      end # if
      i_out=@i_random_fast_t1_ob_random.rand(i_max+1)
      return i_out
   end # i_random_fast_t1

   def Kibuvits_krl171_rng.i_random_fast_t1(i_max)
      i_out=Kibuvits_krl171_rng.instance.i_random_fast_t1(i_max)
      return i_out
   end # Kibuvits_krl171_rng.i_random_fast_t1

   #-----------------------------------------------------------------------
   include Singleton

end # class Kibuvits_krl171_rng

#=========================================================================
#puts "A random number: "+Kibuvits_krl171_rng.i_random_t1(10).to_s

#=====================kibuvits_krl171_rng_rb_end==================================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_rng_rb_start".
#==========================================================================

#=====================kibuvits_krl171_security_core_rb_start======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_security_core_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_str_concat_array_of_strings.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/security/kibuvits_krl171_rng.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_msgc.rb"

#==========================================================================

class Kibuvits_krl171_security_core

   def initialize
      @mx_ar_s_set_of_alphabets_t1_datainit=Mutex.new
   end # initialize

   # The s_mmmv_checksum_t1 is not a classical hash function, because
   # its goal is not to hide the string that its output has
   # been derived from. There does exist a goal to make it
   # difficult to construct colliding input pairs.
   #
   # The core of the algorithm is based on the idea that
   # it is computationally expensive to pack a fixed size bag
   # as tightly as possible by using a set of fixed size objects.
   #
   # http://longterm.softf1.com/2013/specification_drafts/checksum_idea_t2/
   #
   # The s_mmmv_checksum_t1 might be used as a weak hash function
   # in situations, where PHP hash function implementation
   # does not support Unicode. JavaScript side might include
   # a timestamp with a few minute deadline and a salt value
   # to shorten the time window, where collisions must be found.
   def s_mmmv_checksum_t1(s_in,i_number_of_columns,i_m,ar_of_ar_speedhack=nil)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_typecheck bn, Fixnum, i_number_of_columns
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         1, i_number_of_columns)
         if ar_of_ar_speedhack.class==Array
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,
            Array,ar_of_ar_speedhack)
            if ar_of_ar_speedhack.size!=i_number_of_columns
               msg="ar_of_ar_speedhack.size=="+ar_of_ar_speedhack.size.to_s+
               " != i_number_of_columns=="+i_number_of_columns.to_s
               "GUID='d2ae8854-7dac-44c2-b2c8-c2c2f051a4e7'"
               kibuvits_krl171_throw(msg)
            end # if
         end # if
      end # if
      #---------
      ar_columns=nil
      if ar_of_ar_speedhack.class==Array
         ar_columns=ar_of_ar_speedhack
      else
         ar_columns=Array.new
         i_number_of_columns.times {ar_columns<<Array.new}
      end # if
      #---------
      i_len=nil
      i_0=nil
      s_0=nil
      ar_column=nil
      #---------
      i_s_len=s_in.length
      return $kibuvits_krl171_lc_emptystring if i_s_len==0
      i_s_max=i_s_len-1
      i_ix_s=0
      i_ix_column=0
      b_end_of_string_reached=false
      b_end_of_row_reached=false
      ar_codepoints=s_in.codepoints
      while true
         ar_column=ar_columns[i_ix_column]
         ar_column<<ar_codepoints[i_ix_s]
         #----
         i_ix_s=i_ix_s+1
         if i_s_max<i_ix_s
            i_ix_s=0
            b_end_of_string_reached=true
            break if b_end_of_row_reached
         end # if
         i_ix_column=i_ix_column+1
         if i_number_of_columns<=i_ix_column
            i_ix_column=0
            b_end_of_row_reached=true
            break if b_end_of_string_reached
         end # if
         #----
      end # loop
      ar_codepoints.clear
      #---------
      ar_xi_s=Array.new(i_number_of_columns,$kibuvits_krl171_lc_emptystring)
      b_not_first=false
      i_number_of_columns.times do |i|
         ar_column=ar_columns[i]
         i_len=ar_column.size
         i_0=0
         i_len.times do |ii|
            i_0=i_0+ar_column[ii]
         end # loop
         if b_not_first
            ar_xi_s[i]=$kibuvits_krl171_lc_underscore+(i_0%i_m).to_s
         else
            ar_xi_s[i]=(i_0%i_m).to_s
            b_not_first=true
         end # if
         ar_column.clear # to reuse the array in the ar_of_ar_speedhack
      end # loop
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_xi_s)
      return s_out
   end # s_mmmv_checksum_t1


   def Kibuvits_krl171_security_core.s_mmmv_checksum_t1(s_in,i_number_of_columns,i_m,
      ar_of_ar_speedhack=nil)
      s_out=Kibuvits_krl171_security_core.instance.s_mmmv_checksum_t1(s_in,i_number_of_columns,i_m,
      ar_of_ar_speedhack)
      return s_out
   end # Kibuvits_krl171_security_core.s_decrypt_wearlevelling_t1

   #-----------------------------------------------------------------------

   # Returns a frozen array of characters that
   # originate from various alphabets.
   #
   # It is a vital part of the plaice_t1 hashing algorithm.
   # Any changes in the alphabet changes the plaice_t1
   # hashing algorithm and that may render passwords invalid,
   # users locked out of information systems, etc.
   def ar_s_set_of_alphabets_t1
      if defined? @ar_s_set_of_alphabets_t1_ar_chars
         ar_out=@ar_s_set_of_alphabets_t1_ar_chars
         return ar_out
      end # if
      @mx_ar_s_set_of_alphabets_t1_datainit.synchronize do
         # If this thread was waiting for some other
         # thread to unlock this code region, then
         # by the time this thread enters the code
         # region, the previous thread has completed
         # assembly of the @ar_s_set_of_alphabets_t1_ar_chars
         if defined? @ar_s_set_of_alphabets_t1_ar_chars
            s_out=@ar_s_set_of_alphabets_t1_ar_chars
            return s_out
         end # if
         rgx=/./
         ar_chars_raw=Array.new
         ar_s=Array.new
         #------------------------
         ar_s.clear
         ar_s<<".,:;|_~/\\+-*^%=÷"
         ar_s<<"@#ʻ`?!\"'«»„”″"
         ar_s<<"¤$€₳฿₵¢₡₢₠$₫৳₯ €ƒ₣₲₴₭ℳ ₥ ₦₧ ₱₰£₹₨ ₪ ₸₮₩ ¥៛"
         ar_s<<"⁂❧◊※"
         #
         # The next comment line makes the caracter at the next line visible.
         #
         ar_s<<(("⁀\n\t\r"+"℠™©®℗")+("‰°†‡"+"()<>[]{}"))
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         # The memory-wasting "+" operator is used in stead
         # of the arrayinstance.concat!(other_array)
         # to implement a workaround to a Ruby system flaw that once existed.
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_s.clear
         ar_s<<"ąäáàǎâãåçčďęėéêěēģíìîīķļłņńñňóòôõöřúùüůūťšśžźżßýɤ̌ɤ̂ɤ́ɤ̀ɤɣ"
         ar_s<<"абвгдеёжзклмнопрстуфхцчшщъыьэюя"
         ar_s<<"àâæçéèêëîïôœùûÿ"
         ar_s<<"ʌɑɑ̃əə̃ɛʒʃʁd̥b̥ʰˀɡɡ̊ϥɔʋðøɐʉχɽŋkðɨɪʝçƆʕʔḥħḏẖçɟꜥⲙⲛⲡⲫϣϧⳉ"
         ar_s<<"ϩɥʐʂɕɻʊ̃ʊœ"
         ar_s<<"ⲧⲑϫϭⲕⲭⲇⲅⲃⲍ(ⲟ)ⲩⲗⲉⲓⲣ"
         ar_s<<"αβγδεζηθικλμνξοπρσςτυφχψω"
         ar_s<<"abcdefghijklmnoprstuvxyzw1234567890"
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_s.clear
         ar_s<<"∀∁∂∃∄∅∆∇∈∉∊∋∌∍∏∐∑−∓∔∕∖∗∘∙√∛∜∝∞∟∠∡∢∣∤∥∦∧∨∩∪∫∬∭∮∯"
         ar_s<<"∰∱∲∳∴∵∶∷∸∹∺∻∼∽∾∿≀≁≂≃≄≅≆≇≈≉≊≋≌≍≎≏≐≑≒≓≔≕≖≗≘≙≚≛≜≝≞≟"
         ar_s<<"≠≡≢≣≤≥≦≧≨≩≪≫≬≭≮≯≰≱≲≳≴≵≶≷≸≹≺≻≼≽≾≿⊀⊁⊂⊃⊄⊅⊆⊇⊈⊉⊊⊋⊌⊍⊎⊏"
         ar_s<<"⊐⊑⊒⊓⊔⊕⊖⊗⊘⊙⊚⊛⊜⊝⊞⊟⊠⊡⊢⊣⊤⊥⊦⊧⊨⊩⊪⊫⊬⊭⊮⊯⊰⊱⊲⊳⊴⊵⊶⊷⊸⊹⊺⊻⊼⊽⊾⊿"
         ar_s<<"⋀⋁⋂⋃⋄⋅⋆⋇⋈⋉⋊⋋⋌⋍⋎⋏⋐⋑⋒⋓⋔⋕⋖⋗⋘⋙⋚⋛⋜⋝⋞⋟⋠⋡⋢⋣⋤⋥⋦⋧⋨⋩⋪⋫⋬⋭⋮⋯"
         ar_s<<"⋰⋱⋲⋳⋴⋵⋶⋷⋸⋹⋺⋻⋼⋽⋾⋿"
         ar_s<<"⨀⨁⨂⨃⨄⨅⨆⨇⨈⨉⨊⨋⨌⨍⨎⨏⨐⨑⨒⨓⨔⨕⨖⨗⨘⨙⨚⨛⨜⨝⨞⨟⨠⨡⨢⨣⨤⨥⨦⨧⨨⨩⨪⨫⨬⨭⨮⨯"
         ar_s<<"⨰⨱⨲⨳⨴⨵⨶⨷⨸⨹⨺⨻⨼⨽⨾⨿⩀⩁⩂⩃⩄⩅⩆⩇⩈⩉⩊⩋⩌⩍⩎⩏⩐⩑⩒⩓⩔⩕⩖⩗⩘⩙⩚⩛⩜⩝⩞⩟"
         ar_s<<"⩠⩡⩢⩣⩤⩥⩦⩧⩨⩩⩪⩫⩬⩭⩮⩯⩰⩱⩲⩳⩴⩵⩶⩷⩸⩹⩺⩻⩼⩽⩾⩿⪀⪁⪂⪃⪄⪅⪆⪇⪈⪉⪊⪋⪌⪍⪎⪏"
         ar_s<<"⪐⪑⪒⪓⪔⪕⪖⪗⪘⪙⪚⪛⪜⪝⪞⪟⪠⪡⪢⪣⪤⪥⪦⪧⪨⪩⪪⪫⪬⪭⪮⪯⪰⪱⪲⪳⪴⪵⪶⪷⪸⪹⪺⪻⪼⪽⪾⪿"
         ar_s<<"⫀⫁⫂⫃⫄⫅⫆⫇⫈⫉⫊⫋⫌⫍⫎⫏⫐⫑⫒⫓⫔⫕⫖⫗⫘⫙⫚⫛⫝̸⫝⫞⫟⫠⫡⫢⫣⫤⫥⫦⫧⫨⫩⫪⫫⫬⫭⫮⫯"
         ar_s<<"⫰⫱⫲⫳⫴⫵⫶⫷⫸⫹⫺⫻⫼⫽⫾⫿"
         ar_s<<"⟀⟁⟂⟃⟄⟅⟆⟇⟈⟉⟊⟋⟌⟍⟎⟏⟐⟑⟒⟓⟔⟕⟖⟗⟘⟙⟚⟛⟜⟝⟞⟟⟠⟡⟢⟣⟤⟥⟦⟧⟨⟩⟪⟫⟬⟭⟮⟯"
         ar_s<<"⦀⦁⦂⦃⦄⦅⦆⦇⦈⦉⦊⦋⦌⦍⦎⦏⦐⦑⦒⦓⦔⦕⦖⦗⦘⦙⦚⦛⦜⦝⦞⦟⦠⦡⦢⦣⦤⦥⦦⦧⦨⦩⦪⦫⦬⦭⦮⦯"
         ar_s<<"⦰⦱⦲⦳⦴⦵⦶⦷⦸⦹⦺⦻⦼⦽⦾⦿⧀⧁⧂⧃⧄⧅⧆⧇⧈⧉⧊⧋⧌⧍⧎⧏⧐⧑⧒⧓⧔⧕⧖⧗⧘⧙⧚⧛⧜⧝⧞⧟"
         ar_s<<"⧠⧡⧢⧣⧤⧥⧦⧧⧨⧩⧪⧫⧬⧭⧮⧯⧰⧱⧲⧳⧴⧵⧶⧷⧸⧹⧺⧻⧼⧽⧾⧿℀℁ℂ℃℄℅℆ℇ℈℉ℊℋℌℍℎℏ"
         ar_s<<"ℐℑℒℓ℔ℕ№℗℘ℙℚℛℜℝ℞℟℠℡™℣ℤ℥Ω℧ℨ℩KÅℬℭ℮ℯℰℱℲℳℴℵℶℷℸℹ℺℻ℼℽℾℿ"
         ar_s<<"⅀⅁⅂⅃⅄ⅅⅆⅇⅈⅉ⅊⅋⅌⅍ⅎ⅏■□▢▣▤▥▦▧▨▩▪▫▬▭▮▯▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿"
         ar_s<<"◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟◠◡◢◣◤◥◦◧◨◩◪◫◬◭◮◯"
         ar_s<<"◰◱◲◳◴◵◶◷◸◹◺◻◼◽◾◿⬀⬁⬂⬃⬄⬅⬆⬇⬈⬉⬊⬋⬌⬍⬎⬏⬐⬑⬒⬓⬔⬕⬖⬗⬘⬙⬚⬛⬜⬝⬞⬟"
         ar_s<<"⬠⬡⬢⬣⬤⬥⬦⬧⬨⬩⬪⬫⬬⬭⬮⬯⬰⬱⬲⬳⬴⬵⬶⬷⬸⬹⬺⬻⬼⬽⬾⬿𝟐𝟑𝟒𝟓𝟔𝟕𝟖𝟗𝟘𝟙𝟚𝟛𝟜𝟝𝟞𝟟"
         ar_s<<"𝟠𝟡𝟢𝟣𝟤𝟥𝟦𝟧𝟨𝟩𝟪𝟫𝟬𝟭𝟮𝟯𝟰𝟱𝟲𝟳𝟴𝟵𝟶𝟷𝟸𝟹𝟺𝟻𝟼𝟽𝟾𝟿𝚰𝚱𝚲𝚳𝚴𝚵𝚶𝚷𝚸𝚹𝚺𝚻𝚼𝚽𝚾𝚿"
         ar_s<<"𝛀𝛁𝛂𝛃𝛄𝛅𝛆𝛇𝛈𝛉𝛊𝛋𝛌𝛍𝛎𝛏𝛐𝛑𝛒𝛓𝛔𝛕𝛖𝛗𝛘𝛙𝛚𝛛𝛜𝛝𝛞𝛟𝛠𝛡𝛢𝛣𝛤𝛥𝛦𝛧𝛨𝛩𝛪𝛫𝛬𝛭𝛮𝛯"
         ar_s<<"𝛰𝛱𝛲𝛳𝛴𝛵𝛶𝛷𝛸𝛹𝛺𝛻𝛼𝛽𝛾𝛿𝜀𝜁𝜂𝜃𝜄𝜅𝜆𝜇𝜈𝜉𝜊𝜋𝜌𝜍𝜎𝜏𝜐𝜑𝜒𝜓𝜔𝜕𝜖𝜗𝜘𝜙𝜚𝜛𝜜𝜝𝜞𝜟"
         ar_s<<"𝜠𝜡𝜢𝜣𝜤𝜥𝜦𝜧𝜨𝜩𝜪𝜫𝜬𝜭𝜮𝜯𝜰𝜱𝜲𝜳𝜴𝜵𝜶𝜷𝜸𝜹𝜺𝜻𝜼𝜽𝜾𝜿𝝀𝝁𝝂𝝃𝝄𝝅𝝆𝝇𝝈𝝉𝝊𝝋𝝌𝝍𝝎𝝏"
         ar_s<<"𝝐𝝑𝝒𝝓𝝔𝝕𝝖𝝗𝝘𝝙𝝚𝝛𝝜𝝝𝝞𝝟𝝠𝝡𝝢𝝣𝝤𝝥𝝦𝝧𝝨𝝩𝝪𝝫𝝬𝝭𝝮𝝯𝝰𝝱𝝲𝝳𝝴𝝵𝝶𝝷𝝸𝝹𝝺𝝻𝝼𝝽𝝾𝝿"
         ar_s<<"𝞀𝞁𝞂𝞃𝞄𝞅𝞆𝞇𝞈𝞉𝞊𝞋𝞌𝞍𝞎𝞏𝞐𝞑𝞒𝞓𝞔𝞕𝞖𝞗𝞘𝞙𝞚𝞛𝞜𝞝𝞞𝞟𝞠𝞡𝞢𝞣𝞤𝞥𝞦𝞧𝞨𝞩𝞪𝞫𝞬𝞭𝞮𝞯"
         ar_s<<"𝞰𝞱𝞲𝞳𝞴𝞵𝞶𝞷𝞸𝞹𝞺𝞻𝞼𝞽𝞾𝞿𝕠𝕡𝕢𝕣𝕤𝕥𝕦𝕧𝕨𝕩𝕪𝕫𝕬𝕭𝕮𝕯𝕰𝕱𝕲𝕳𝕴𝕵𝕶𝕷𝕸𝕹𝕺𝕻𝕼𝕽𝕾𝕿"
         ar_s<<"𝖀𝖁𝖂𝖃𝖄𝖅𝖆𝖇𝖈𝖉𝖊𝖋𝖌𝖍𝖎𝖏"
         ar_s<<"⭀⭁⭂⭃⭄⭅⭆⭇⭈⭉⭊⭋⭌⭐⭑⭒⭓⭔⭕⭖⭗⭘⭙𝔀𝔁𝔂𝔃𝔄𝔅𝔇𝔈𝔉𝔊𝔍𝔎𝔏"
         ar_s<<"𝔐𝔑𝔒𝔓𝔔𝔖𝔗𝔘𝔙𝔚𝔛𝔜𝔞𝔟𝟀𝟁𝟂𝟃𝟄𝟅𝟆𝟇𝟈𝟉𝟊𝟋𝟎𝟏"
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_s.clear
         ar_s<<"𓀀𓀁𓀂𓀃𓀄𓀅𓀆𓀇𓀈𓀉𓀊𓀋𓀌𓀍𓀎𓀏𓀐𓀑𓀒𓀓𓀔𓀕𓀖𓀗𓀘𓀙𓀚𓀛𓀜𓀝𓀞𓀟𓀠𓀡𓀢𓀣𓀤𓀥𓀦𓀧𓀨𓀩𓀪𓀫𓀬𓀭𓀮𓀯"
         ar_s<<"𓀰𓀱𓀲𓀳𓀴𓀵𓀶𓀷𓀸𓀹𓀺𓀻𓀼𓀽𓀾𓀿𓁀𓁁𓁂𓁃𓁄𓁅𓁆𓁇𓁈𓁉𓁊𓁋𓁌𓁍𓁎𓁏𓁐𓁑𓁒𓁓𓁔𓁕𓁖𓁗𓁘𓁙𓁚𓁛𓁜𓁝𓁞𓁟"
         ar_s<<"𓁠𓁡𓁢𓁣𓁤𓁥𓁦𓁧𓁨𓁩𓁪𓁫𓁬𓁭𓁮𓁯𓁰𓁱𓁲𓁳𓁴𓁵𓁶𓁷𓁸𓁹𓁺𓁻𓁼𓁽𓁾𓁿𓂀𓂁𓂂𓂃𓂄𓂅𓂆𓂇𓂈𓂉𓂊𓂋𓂌𓂍𓂎𓂏"
         ar_s<<"𓂐𓂑𓂒𓂓𓂔𓂕𓂖𓂗𓂘𓂙𓂚𓂛𓂜𓂝𓂞𓂟𓂠𓂡𓂢𓂣𓂤𓂥𓂦𓂧𓂨𓂩𓂪𓂫𓂬𓂭𓂮𓂯𓂰𓂱𓂲𓂳𓂴𓂵𓂶𓂷𓂸𓂹𓂺𓂻𓂼𓂽𓂾𓂿"
         ar_s<<"𓃀𓃁𓃂𓃃𓃄𓃅𓃆𓃇𓃈𓃉𓃊𓃋𓃌𓃍𓃎𓃏𓃐𓃑𓃒𓃓𓃔𓃕𓃖𓃗𓃘𓃙𓃚𓃛𓃜𓃝𓃞𓃟𓃠𓃡𓃢𓃣𓃤𓃥𓃦𓃧𓃨𓃩𓃪𓃫𓃬𓃭𓃮𓃯"
         ar_s<<"𓃰𓃱𓃲𓃳𓃴𓃵𓃶𓃷𓃸𓃹𓃺𓃻𓃼𓃽𓃾𓃿𓄀𓄁𓄂𓄃𓄄𓄅𓄆𓄇𓄈𓄉𓄊𓄋𓄌𓄍𓄎𓄏𓄐𓄑𓄒𓄓𓄔𓄕𓄖𓄗𓄘𓄙𓄚𓄛𓄜𓄝𓄞𓄟"
         ar_s<<"𓄠𓄡𓄢𓄣𓄤𓄥𓄦𓄧𓄨𓄩𓄪𓄫𓄬𓄭𓄮𓄯𓄰𓄱𓄲𓄳𓄴𓄵𓄶𓄷𓄸𓄹𓄺𓄻𓄼𓄽𓄾𓄿𓅀𓅁𓅂𓅃𓅄𓅅𓅆𓅇𓅈𓅉𓅊𓅋𓅌𓅍𓅎𓅏"
         ar_s<<"𓅐𓅑𓅒𓅓𓅔𓅕𓅖𓅗𓅘𓅙𓅚𓅛𓅜𓅝𓅞𓅟𓅠𓅡𓅢𓅣𓅤𓅥𓅦𓅧𓅨𓅩𓅪𓅫𓅬𓅭𓅮𓅯𓅰𓅱𓅲𓅳𓅴𓅵𓅶𓅷𓅸𓅹𓅺𓅻𓅼𓅽𓅾𓅿"
         ar_s<<"𓆀𓆁𓆂𓆃𓆄𓆅𓆆𓆇𓆈𓆉𓆊𓆋𓆌𓆍𓆎𓆏𓆐𓆑𓆒𓆓𓆔𓆕𓆖𓆗𓆘𓆙𓆚𓆛𓆜𓆝𓆞𓆟𓆠𓆡𓆢𓆣𓆤𓆥𓆦𓆧𓆨𓆩𓆪𓆫𓆬𓆭𓆮𓆯"
         ar_s<<"𓆰𓆱𓆲𓆳𓆴𓆵𓆶𓆷𓆸𓆹𓆺𓆻𓆼𓆽𓆾𓆿𓇀𓇁𓇂𓇃𓇄𓇅𓇆𓇇𓇈𓇉𓇊𓇋𓇌𓇍𓇎𓇏𓇐𓇑𓇒𓇓𓇔𓇕𓇖𓇗𓇘𓇙𓇚𓇛𓇜𓇝𓇞𓇟"
         ar_s<<"𓇠𓇡𓇢𓇣𓇤𓇥𓇦𓇧𓇨𓇩𓇪𓇫𓇬𓇭𓇮𓇯𓇰𓇱𓇲𓇳𓇴𓇵𓇶𓇷𓇸𓇹𓇺𓇻𓇼𓇽𓇾𓇿𓈀𓈁𓈂𓈃𓈄𓈅𓈆𓈇𓈈𓈉𓈊𓈋𓈌𓈍𓈎𓈏"
         ar_s<<"𓈐𓈑𓈒𓈓𓈔𓈕𓈖𓈗𓈘𓈙𓈚𓈛𓈜𓈝𓈞𓈟𓈠𓈡𓈢𓈣𓈤𓈥𓈦𓈧𓈨𓈩𓈪𓈫𓈬𓈭𓈮𓈯𓈰𓈱𓈲𓈳𓈴𓈵𓈶𓈷𓈸𓈹𓈺𓈻𓈼𓈽𓈾𓈿"
         ar_s<<"𓉀𓉁𓉂𓉃𓉄𓉅𓉆𓉇𓉈𓉉𓉊𓉋𓉌𓉍𓉎𓉏𓉐𓉑𓉒𓉓𓉔𓉕𓉖𓉗𓉘𓉙𓉚𓉛𓉜𓉝𓉞𓉟𓉠𓉡𓉢𓉣𓉤𓉥𓉦𓉧𓉨𓉩𓉪𓉫𓉬𓉭𓉮𓉯"
         ar_s<<"𓉰𓉱𓉲𓉳𓉴𓉵𓉶𓉷𓉸𓉹𓉺𓉻𓉼𓉽𓉾𓉿𓊀𓊁𓊂𓊃𓊄𓊅𓊆𓊇𓊈𓊉𓊊𓊋𓊌𓊍𓊎𓊏𓊐𓊑𓊒𓊓𓊔𓊕𓊖𓊗𓊘𓊙𓊚𓊛𓊜𓊝𓊞𓊟"
         ar_s<<"𓊠𓊡𓊢𓊣𓊤𓊥𓊦𓊧𓊨𓊩𓊪𓊫𓊬𓊭𓊮𓊯𓊰𓊱𓊲𓊳𓊴𓊵𓊶𓊷𓊸𓊹𓊺𓊻𓊼𓊽𓊾𓊿𓋀𓋁𓋂𓋃𓋄𓋅𓋆𓋇𓋈𓋉𓋊𓋋𓋌𓋍𓋎𓋏"
         ar_s<<"𓋐𓋑𓋒𓋓𓋔𓋕𓋖𓋗𓋘𓋙𓋚𓋛𓋜𓋝𓋞𓋟𓋠𓋡𓋢𓋣𓋤𓋥𓋦𓋧𓋨𓋩𓋪𓋫𓋬𓋭𓋮𓋯𓋰𓋱𓋲𓋳𓋴𓋵𓋶𓋷𓋸𓋹𓋺𓋻𓋼𓋽𓋾𓋿"
         ar_s<<"𓌀𓌁𓌂𓌃𓌄𓌅𓌆𓌇𓌈𓌉𓌊𓌋𓌌𓌍𓌎𓌏𓌐𓌑𓌒𓌓𓌔𓌕𓌖𓌗𓌘𓌙𓌚𓌛𓌜𓌝𓌞𓌟𓌠𓌡𓌢𓌣𓌤𓌥𓌦𓌧𓌨𓌩𓌪𓌫𓌬𓌭𓌮𓌯"
         ar_s<<"𓌰𓌱𓌲𓌳𓌴𓌵𓌶𓌷𓌸𓌹𓌺𓌻𓌼𓌽𓌾𓌿𓍀𓍁𓍂𓍃𓍄𓍅𓍆𓍇𓍈𓍉𓍊𓍋𓍌𓍍𓍎𓍏𓍐𓍑𓍒𓍓𓍔𓍕𓍖𓍗𓍘𓍙𓍚𓍛𓍜𓍝𓍞𓍟"
         ar_s<<"𓍠𓍡𓍢𓍣𓍤𓍥𓍦𓍧𓍨𓍩𓍪𓍫𓍬𓍭𓍮𓍯𓍰𓍱𓍲𓍳𓍴𓍵𓍶𓍷𓍸𓍹𓍺𓍻𓍼𓍽𓍾𓍿𓎀𓎁𓎂𓎃𓎄𓎅𓎆𓎇𓎈𓎉𓎊𓎋𓎌𓎍𓎎𓎏"
         ar_s<<"𓎐𓎑𓎒𓎓𓎔𓎕𓎖𓎗𓎘𓎙𓎚𓎛𓎜𓎝𓎞𓎟𓎠𓎡𓎢𓎣𓎤𓎥𓎦𓎧𓎨𓎩𓎪𓎫𓎬𓎭𓎮𓎯𓎰𓎱𓎲𓎳𓎴𓎵𓎶𓎷𓎸𓎹𓎺𓎻𓎼𓎽𓎾𓎿"
         ar_s<<"𓏀𓏁𓏂𓏃𓏄𓏅𓏆𓏇𓏈𓏉𓏊𓏋𓏌𓏍𓏎𓏏𓏐𓏑𓏒𓏓𓏔𓏕𓏖𓏗𓏘𓏙𓏚𓏛𓏜𓏝𓏞𓏟𓏠𓏡𓏢𓏣𓏤𓏥𓏦𓏧𓏨𓏩𓏪𓏫𓏬𓏭𓏮𓏯"
         ar_s<<"𓏰𓏱𓏲𓏳𓏴𓏵𓏶𓏷𓏸𓏹𓏺𓏻𓏼𓏽𓏾𓏿𓐀𓐁𓐂𓐃𓐄𓐅𓐆𓐇𓐈𓐉𓐊𓐋𓐌𓐍𓐎𓐏𓐐𓐑𓐒𓐓𓐔𓐕𓐖𓐗𓐘𓐙𓐚𓐛𓐜𓐝𓐞𓐟"
         ar_s<<"𓐠 𓐡𓐢𓐣𓐤𓐥𓐦𓐧𓐨𓐩𓐪𓐫𓐬𓐭𓐮"
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_s.clear
         # The Hebrew alphabet is incomplete, because the Vim,
         # the text editor, was not able to display some of the characters.
         s_0="אבגדהוזחטיךכלםמןנסעףפץצקרשתװױײ׳״".downcase
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_s.clear
         # The Arabic alphabet is incomplete, because the Vim,
         # the text editor, was not able to display some of the characters.
         ar_s<<"ؠءآأؤإئابةتثجحخدذرزسشصضطظعغػؼؽؾؿ٠١٢٣٤٥٦٧٨٩٪٫٬٭ٮٯ"
         ar_s<<"ڀځڂڃڄڅچڇڈډڊڋڌڍڎڏڐڑڒړڔڕږڗژڙښڛڜڝڞڟڠڡڢڣڤڥڦڧڨکڪګڬڭڮگ"
         ar_s<<"ڰڱڲڳڴڵڶڷڸڹںڻڼڽھڿۀہۂۃۄۅۆۇۈۉۊۋیۍێۏ۰۱۲۳۴۵۶۷۸۹ۺۻۼ۽۾ۿ"
         ar_s<<"ݐݑݒݓݔݕݖݗݘݙݚݛݜݝݞݟݠݡݢݣݤݥݦݧݨݩݪݫݬݭݮݯݰݱݲݳݴݵݶݷݸݹݺݻݼݽݾݿ"
         ar_s<<"ﭐﭑﭒﭓﭔﭕﭖﭗﭘﭙﭚﭛﭜﭝﭞﭟﭠﭡﭢﭣﭤﭥﭦﭧﭨﭩﭪﭫﭬﭭﭮﭯﭰﭱﭲﭳﭴﭵﭶﭷﭸﭹﭺﭻﭼﭽﭾﭿ"
         ar_s<<"ﮀﮁﮂﮃﮄﮅﮆﮇﮈﮉﮊﮋﮌﮍﮎﮏﮐﮑﮒﮓﮔﮕﮖﮗﮘﮙﮚﮛﮜﮝﮞﮟﮠﮡﮢﮣﮤﮥﮦﮧﮨﮩﮪﮫﮬﮭﮮﮯ"
         ar_s<<"ﮰﮱ﮲﮳﮴﮵﮶﮷﮸﮹﮺﮻﮼﮽﮾﮿ﯠﯡﯢﯣﯤﯥﯦﯧﯨﯩﯪﯫﯬﯭﯮﯯﯰﯱﯲﯳﯴﯵﯶﯷﯸﯹﯺﯻﯼﯽﯾﯿ"
         ar_s<<"ﰀﰁﰂﰃﰄﰅﰆﰇﰈﰉﰊﰋﰌﰍﰎﰏﰐﰑﰒﰓﰔﰕﰖﰗﰘﰙﰚﰛﰜﰝﰞﰟﰠﰡﰢﰣﰤﰥﰦﰧﰨﰩﰪﰫﰬﰭﰮﰯ"
         ar_s<<"ﰰﰱﰲﰳﰴﰵﰶﰷﰸﰹﰺﰻﰼﰽﰾﰿﱀﱁﱂﱃﱄﱅﱆﱇﱈﱉﱊﱋﱌﱍﱎﱏﱐﱑﱒﱓﱔﱕﱖﱗﱘﱙﱚﱛﱜﱝﱞﱟ"
         ar_s<<"ﱠﱡﱢﱣﱤﱥﱦﱧﱨﱩﱪﱫﱬﱭﱮﱯﱰﱱﱲﱳﱴﱵﱶﱷﱸﱹﱺﱻﱼﱽﱾﱿﲀﲁﲂﲃﲄﲅﲆﲇﲈﲉﲊﲋﲌﲍﲎﲏ"
         ar_s<<"ﲐﲑﲒﲓﲔﲕﲖﲗﲘﲙﲚﲛﲜﲝﲞﲟﲠﲡﲢﲣﲤﲥﲦﲧﲨﲩﲪﲫﲬﲭﲮﲯﲰﲱﲲﲳﲴﲵﲶﲷﲸﲹﲺﲻﲼﲽﲾﲿ"
         ar_s<<"ﳀﳁﳂﳃﳄﳅﳆﳇﳈﳉﳊﳋﳌﳍﳎﳏﳐﳑﳒﳓﳔﳕﳖﳗﳘﳙﳚﳛﳜﳝﳞﳟﳠﳡﳢﳣﳤﳥﳦﳧﳨﳩﳪﳫﳬﳭﳮﳯ"
         ar_s<<"ﳰﳱﳲﳳﳴﳵﳶﳷﳸﳹﳺﳻﳼﳽﳾﳿﴀﴁﴂﴃﴄﴅﴆﴇﴈﴉﴊﴋﴌﴍﴎﴏﴐﴑﴒﴓﴔﴕﴖﴗﴘﴙﴚﴛﴜﴝﴞﴟ"
         ar_s<<"ﴠﴡﴢﴣﴤﴥﴦﴧﴨﴩﴪﴫﴬﴭﴮﴯﴰﴱﴲﴳﴴﴵﴶﴷﴸﴹﴺﴻﴼﴽ﴾﴿ﵐﵑﵒﵓﵔﵕﵖﵗﵘﵙﵚﵛﵜﵝﵞﵟ"
         ar_s<<"ﵠﵡﵢﵣﵤﵥﵦﵧﵨﵩﵪﵫﵬﵭﵮﵯﵰﵱﵲﵳﵴﵵﵶﵷﵸﵹﵺﵻﵼﵽﵾﵿﶀﶁﶂﶃﶄﶅﶆﶇﶈﶉﶊﶋﶌﶍﶎﶏ"
         ar_s<<"ﶠﶡﶢﶣﶤﶥﶦﶧﶨﶩﶪﶫﶬﶭﶮﶯﶰﶱﶲﶳﶴﶵﶶﶷﶸﶹﶺﶻﶼﶽﶾﶿ"
         ar_s<<"ـفقكلمنهوىيۥۦ۩ۮۯېۑےۓ۔ە؇؈؉؊؋،؍؎؏؛؞؟"
         ar_s<<"ٱٲٳٴٵٶٷٸٹٺٻټٽپٿ﯀﯁ﯓﯔﯕﯖﯗﯘﯙﯚﯛﯜﯝﯞﯟﶒﶓﶔﶕﶖﶗﶘﶙﶚﶛﶜﶝﶞﶟ"
         ar_s<<"ﷀﷁﷂﷃﷄﷅﷆﷰﷱﷲﷳﷴﷵﷶ ﷸ ﷺﷻ"
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_s.clear
         # Copy-pasted from
         # http://www.rikai.com/library/kanjitables/kanji_codes.unicode.shtml
         #
         # The Japanese alphabet is incomplete, because the Vim,
         # and the KomodoEdit were not able to display some of the characters.
         #
         ar_s<<"＆？｀|{}～｟｠｡｢｣､･ｦｧｨｩｪｫｬｭｮｯ"
         ar_s<<"ｰｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏ"
         ar_s<<"ﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜﾝﾞﾟﾡﾢﾣﾤﾥﾦﾧﾨﾩﾪﾫﾬﾭﾮﾯ"
         ar_s<<"ﾰﾱﾲﾳﾴﾵﾶﾷﾸﾹﾺﾻﾼﾽﾾￂￃￄￅￆￇￊￋￌￍￎￏ"
         ar_s<<"ￒￓￔￕￖￗￚￛￜ￠￡￢￣￤￥￦￨￩￪￫￬￭￮"
         #------------
         # The code that was used for semiautomatic formatting:
         # s_fp_in=ENV["HOME"]+"/tmp/andmed.txt"
         # s_fp_out=ENV["HOME"]+"/tmp/jama.txt"
         # s_orig=file2str(s_fp_in).downcase
         # s_0=s_orig.gsub(/[\s\r\n\t\dabcdef]/,"")
         # ar_chars=s_0.scan(/./).uniq
         # ar_s=Array.new
         # s_lc_row_start=" ar_s<<\""
         # s_lc_row_end="\"\n"
         # i_column_max=20-1
         # i_0=0
         # ar_chars.each do |s_char|
         #    ar_s<<s_lc_row_start if i_0==0
         #    ar_s<<s_char
         #    i_0=i_0+1
         #    if i_column_max<i_0
         #       i_0=0
         #       ar_s<<s_lc_row_end
         #    end # if
         # end # loop
         # ar_s<<s_lc_row_end if i_0!=0
         # s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
         # str2file(s_out,s_fp_out)
         #-----semiautomatically--formatted-block--start
         ar_s<<"一丁丂七丄丅丆万丈三上下丌不与丏丐丑丒专"
         ar_s<<"且丕世丗丘丙业丛东丝丞丟丠両丢丣两严並丧"
         ar_s<<"丨丩个丫丬中丮丯丰丱串丳临丵丶丷丸丹为主"
         ar_s<<"丼丽举丿乀乁乂乃乄久乆乇么义乊之乌乍乎乏"
         ar_s<<"乐乑乒乓乔乕乖乗乘乙乚乛乜九乞也习乡乢乣"
         ar_s<<"乤乥书乧乨乩乪乫乬乭乮乯买乱乲乳乴乵乶乷"
         ar_s<<"乸乹乺乻乼乽乾乿亀亁亂亃亄亅了亇予争亊事"
         ar_s<<"二亍于亏亐云互亓五井亖亗亘亙亚些亜亝亞亟"
         ar_s<<"亠亡亢亣交亥亦产亨亩亪享京亭亮亯亰亱亲亳"
         ar_s<<"亴亵亶亷亸亹人亻亼亽亾亿什仁仂仃仄仅仆仇"
         ar_s<<"仈仉今介仌仍从仏仐仑仒仓仔仕他仗付仙仚仛"
         ar_s<<"仜仝仞仟仠仡仢代令以仦仧仨仩仪仫们仭仮仯"
         ar_s<<"仰仱仲仳仴仵件价仸仹仺任仼份仾仿伀企伂伃"
         ar_s<<"伄伅伆伇伈伉伊伋伌伍伎伏伐休伒伓伔伕伖众"
         ar_s<<"优伙会伛伜伝伞伟传伡伢伣伤伥伦伧伨伩伪伫"
         ar_s<<"伬伭伮伯估伱伲伳伴伵伶伷伸伹伺伻似伽伾伿"
         ar_s<<"佀佁佂佃佄佅但佇佈佉佊佋佌位低住佐佑佒体"
         ar_s<<"佔何佖佗佘余佚佛作佝佞佟你佡佢佣佤佥佦佧"
         ar_s<<"佨佩佪佫佬佭佮佯佰佱佲佳佴併佶佷佸佹佺佻"
         ar_s<<"佼佽佾使侀侁侂侃侄侅來侇侈侉侊例侌侍侎侏"
         ar_s<<"侐侑侒侓侔侕侖侗侘侙侚供侜依侞侟侠価侢侣"
         ar_s<<"侤侥侦侧侨侩侪侫侬侭侮侯侰侱侲侳侴侵侶侷"
         ar_s<<"侸侹侺侻侼侽侾便俀俁係促俄俅俆俇俈俉俊俋"
         ar_s<<"俌俍俎俏俐俑俒俓俔俕俖俗俘俙俚俛俜保俞俟"
         ar_s<<"俠信俢俣俤俥俦俧俨俩俪俫俬俭修俯俰俱俲俳"
         ar_s<<"俴俵俶俷俸俹俺俻俼俽俾俿倀倁倂倃倄倅倆倇"
         ar_s<<"倈倉倊個倌倍倎倏倐們倒倓倔倕倖倗倘候倚倛"
         ar_s<<"倜倝倞借倠倡倢倣値倥倦倧倨倩倪倫倬倭倮倯"
         ar_s<<"倰倱倲倳倴倵倶倷倸倹债倻值倽倾倿偀偁偂偃"
         ar_s<<"偄偅偆假偈偉偊偋偌偍偎偏偐偑偒偓偔偕偖偗"
         ar_s<<"偘偙做偛停偝偞偟偠偡偢偣偤健偦偧偨偩偪偫"
         ar_s<<"偬偭偮偯偰偱偲偳側偵偶偷偸偹偺偻偼偽偾偿"
         ar_s<<"傀傁傂傃傄傅傆傇傈傉傊傋傌傍傎傏傐傑傒傓"
         ar_s<<"傔傕傖傗傘備傚傛傜傝傞傟傠傡傢傣傤傥傦傧"
         ar_s<<"储傩傪傫催傭傮傯傰傱傲傳傴債傶傷傸傹傺傻"
         ar_s<<"傼傽傾傿僀僁僂僃僄僅僆僇僈僉僊僋僌働僎像"
         ar_s<<"僐僑僒僓僔僕僖僗僘僙僚僛僜僝僞僟僠僡僢僣"
         ar_s<<"僤僥僦僧僨僩僪僫僬僭僮僯僰僱僲僳僴僵僶僷"
         ar_s<<"僸價僺僻僼僽僾僿儀儁儂儃億儅儆儇儈儉儊儋"
         ar_s<<"儌儍儎儏儐儑儒儓儔儕儖儗儘儙儚儛儜儝儞償"
         ar_s<<"儠儡儢儣儤儥儦儧儨儩優儫儬儭儮儯儰儱儲儳"
         ar_s<<"儴儵儶儷儸儹儺儻儼儽儾儿兀允兂元兄充兆兇"
         ar_s<<"先光兊克兌免兎兏児兑兒兓兔兕兖兗兘兙党兛"
         ar_s<<"兜兝兞兟兠兡兢兣兤入兦內全兩兪八公六兮兯"
         ar_s<<"兰共兲关兴兵其具典兹兺养兼兽兾兿冀冁冂冃"
         ar_s<<"冄内円冇冈冉冊冋册再冎冏冐冑冒冓冔冕冖冗"
         ar_s<<"冘写冚军农冝冞冟冠冡冢冣冤冥冦冧冨冩冪冫"
         ar_s<<"冬冭冮冯冰冱冲决冴况冶冷冸冹冺冻冼冽冾冿"
         ar_s<<"净凁凂凃凄凅准凇凈凉凊凋凌凍凎减凐凑凒凓"
         ar_s<<"凔凕凖凗凘凙凚凛凜凝凞凟几凡凢凣凤凥処凧"
         ar_s<<"凨凩凪凫凬凭凮凯凰凱凲凳凴凵凶凷凸凹出击"
         ar_s<<"凼函凾凿刀刁刂刃刄刅分切刈刉刊刋刌刍刎刏"
         ar_s<<"刐刑划刓刔刕刖列刘则刚创刜初刞刟删刡刢刣"
         ar_s<<"判別刦刧刨利刪别刬刭刮刯到刱刲刳刴刵制刷"
         ar_s<<"券刹刺刻刼刽刾刿剀剁剂剃剄剅剆則剈剉削剋"
         ar_s<<"剌前剎剏剐剑剒剓剔剕剖剗剘剙剚剛剜剝剞剟"
         ar_s<<"剠剡剢剣剤剥剦剧剨剩剪剫剬剭剮副剰剱割剳"
         ar_s<<"剴創剶剷剸剹剺剻剼剽剾剿劀劁劂劃劄劅劆劇"
         ar_s<<"劈劉劊劋劌劍劎劏劐劑劒劓劔劕劖劗劘劙劚力"
         ar_s<<"劜劝办功加务劢劣劤劥劦劧动助努劫劬劭劮劯"
         ar_s<<"劰励劲劳労劵劶劷劸効劺劻劼劽劾势勀勁勂勃"
         ar_s<<"勄勅勆勇勈勉勊勋勌勍勎勏勐勑勒勓勔動勖勗"
         ar_s<<"勘務勚勛勜勝勞募勠勡勢勣勤勥勦勧勨勩勪勫"
         ar_s<<"勬勭勮勯勰勱勲勳勴勵勶勷勸勹勺勻勼勽勾勿"
         ar_s<<"匀匁匂匃匄包匆匇匈匉匊匋匌匍匎匏匐匑匒匓"
         ar_s<<"匔匕化北匘匙匚匛匜匝匞匟匠匡匢匣匤匥匦匧"
         ar_s<<"匨匩匪匫匬匭匮匯匰匱匲匳匴匵匶匷匸匹区医"
         ar_s<<"匼匽匾匿區十卂千卄卅卆升午卉半卋卌卍华协"
         ar_s<<"卐卑卒卓協单卖南単卙博卛卜卝卞卟占卡卢卣"
         ar_s<<"卤卥卦卧卨卩卪卫卬卭卮卯印危卲即却卵卶卷"
         ar_s<<"卸卹卺卻卼卽卾卿厀厁厂厃厄厅历厇厈厉厊压"
         ar_s<<"厌厍厎厏厐厑厒厓厔厕厖厗厘厙厚厛厜厝厞原"
         ar_s<<"厠厡厢厣厤厥厦厧厨厩厪厫厬厭厮厯厰厱厲厳"
         ar_s<<"厴厵厶厷厸厹厺去厼厽厾县叀叁参參叄叅叆叇"
         ar_s<<"又叉及友双反収叏叐发叒叓叔叕取受变叙叚叛"
         ar_s<<"叜叝叞叟叠叡叢口古句另叧叨叩只叫召叭叮可"
         ar_s<<"台叱史右叴叵叶号司叹叺叻叼叽叾叿吀吁吂吃"
         ar_s<<"各吅吆吇合吉吊吋同名后吏吐向吒吓吔吕吖吗"
         ar_s<<"吘吙吚君吜吝吞吟吠吡吢吣吤吥否吧吨吩吪含"
         ar_s<<"听吭吮启吰吱吲吳吴吵吶吷吸吹吺吻吼吽吾吿"
         ar_s<<"呀呁呂呃呄呅呆呇呈呉告呋呌呍呎呏呐呑呒呓"
         ar_s<<"呔呕呖呗员呙呚呛呜呝呞呟呠呡呢呣呤呥呦呧"
         ar_s<<"周呩呪呫呬呭呮呯呰呱呲味呴呵呶呷呸呹呺呻"
         ar_s<<"呼命呾呿咀咁咂咃咄咅咆咇咈咉咊咋和咍咎咏"
         ar_s<<"咐咑咒咓咔咕咖咗咘咙咚咛咜咝咞咟咠咡咢咣"
         ar_s<<"咤咥咦咧咨咩咪咫咬咭咮咯咰咱咲咳咴咵咶咷"
         ar_s<<"咸咹咺咻咼咽咾咿哀品哂哃哄哅哆哇哈哉哊哋"
         ar_s<<"哌响哎哏哐哑哒哓哔哕哖哗哘哙哚哛哜哝哞哟"
         ar_s<<"哠員哢哣哤哥哦哧哨哩哪哫哬哭哮哯哰哱哲哳"
         ar_s<<"哴哵哶哷哸哹哺哻哼哽哾哿唀唁唂唃唄唅唆唇"
         ar_s<<"唈唉唊唋唌唍唎唏唐唑唒唓唔唕唖唗唘唙唚唛"
         ar_s<<"唜唝唞唟唠唡唢唣唤唥唦唧唨唩唪唫唬唭售唯"
         ar_s<<"唰唱唲唳唴唵唶唷唸唹唺唻唼唽唾唿啀啁啂啃"
         ar_s<<"啄啅商啇啈啉啊啋啌啍啎問啐啑啒啓啔啕啖啗"
         ar_s<<"啘啙啚啛啜啝啞啟啠啡啢啣啤啥啦啧啨啩啪啫"
         ar_s<<"啬啭啮啯啰啱啲啳啴啵啶啷啸啹啺啻啼啽啾啿"
         ar_s<<"喀喁喂喃善喅喆喇喈喉喊喋喌喍喎喏喐喑喒喓"
         ar_s<<"喔喕喖喗喘喙喚喛喜喝喞喟喠喡喢喣喤喥喦喧"
         ar_s<<"喨喩喪喫喬喭單喯喰喱喲喳喴喵営喷喸喹喺喻"
         ar_s<<"喼喽喾喿嗀嗁嗂嗃嗄嗅嗆嗇嗈嗉嗊嗋嗌嗍嗎嗏"
         ar_s<<"嗐嗑嗒嗓嗔嗕嗖嗗嗘嗙嗚嗛嗜嗝嗞嗟嗠嗡嗢嗣"
         ar_s<<"嗤嗥嗦嗧嗨嗩嗪嗫嗬嗭嗮嗯嗰嗱嗲嗳嗴嗵嗶嗷"
         ar_s<<"嗸嗹嗺嗻嗼嗽嗾嗿嘀嘁嘂嘃嘄嘅嘆嘇嘈嘉嘊嘋"
         ar_s<<"嘌嘍嘎嘏嘐嘑嘒嘓嘔嘕嘖嘗嘘嘙嘚嘛嘜嘝嘞嘟"
         ar_s<<"嘠嘡嘢嘣嘤嘥嘦嘧嘨嘩嘪嘫嘬嘭嘮嘯嘰嘱嘲嘳"
         ar_s<<"嘴嘵嘶嘷嘸嘹嘺嘻嘼嘽嘾嘿噀噁噂噃噄噅噆噇"
         ar_s<<"噈噉噊噋噌噍噎噏噐噑噒噓噔噕噖噗噘噙噚噛"
         ar_s<<"噜噝噞噟噠噡噢噣噤噥噦噧器噩噪噫噬噭噮噯"
         ar_s<<"噰噱噲噳噴噵噶噷噸噹噺噻噼噽噾噿嚀嚁嚂嚃"
         ar_s<<"嚄嚅嚆嚇嚈嚉嚊嚋嚌嚍嚎嚏嚐嚑嚒嚓嚔嚕嚖嚗"
         ar_s<<"嚘嚙嚚嚛嚜嚝嚞嚟嚠嚡嚢嚣嚤嚥嚦嚧嚨嚩嚪嚫"
         ar_s<<"嚬嚭嚮嚯嚰嚱嚲嚳嚴嚵嚶嚷嚸嚹嚺嚻嚼嚽嚾嚿"
         ar_s<<"囀囁囂囃囄囅囆囇囈囉囊囋囌囍囎囏囐囑囒囓"
         ar_s<<"囔囕囖囗囘囙囚四囜囝回囟因囡团団囤囥囦囧"
         ar_s<<"囨囩囪囫囬园囮囯困囱囲図围囵囶囷囸囹固囻"
         ar_s<<"囼国图囿圀圁圂圃圄圅圆圇圈圉圊國圌圍圎圏"
         ar_s<<"圐圑園圓圔圕圖圗團圙圚圛圜圝圞土圠圡圢圣"
         ar_s<<"圤圥圦圧在圩圪圫圬圭圮圯地圱圲圳圴圵圶圷"
         ar_s<<"圸圹场圻圼圽圾圿址坁坂坃坄坅坆均坈坉坊坋"
         ar_s<<"坌坍坎坏坐坑坒坓坔坕坖块坘坙坚坛坜坝坞坟"
         ar_s<<"坠坡坢坣坤坥坦坧坨坩坪坫坬坭坮坯坰坱坲坳"
         ar_s<<"坴坵坶坷坸坹坺坻坼坽坾坿垀垁垂垃垄垅垆垇"
         ar_s<<"垈垉垊型垌垍垎垏垐垑垒垓垔垕垖垗垘垙垚垛"
         ar_s<<"垜垝垞垟垠垡垢垣垤垥垦垧垨垩垪垫垬垭垮垯"
         ar_s<<"垰垱垲垳垴垵垶垷垸垹垺垻垼垽垾垿埀埁埂埃"
         ar_s<<"埄埅埆埇埈埉埊埋埌埍城埏埐埑埒埓埔埕埖埗"
         ar_s<<"埘埙埚埛埜埝埞域埠埡埢埣埤埥埦埧埨埩埪埫"
         ar_s<<"埬埭埮埯埰埱埲埳埴埵埶執埸培基埻埼埽埾埿"
         ar_s<<"堀堁堂堃堄堅堆堇堈堉堊堋堌堍堎堏堐堑堒堓"
         ar_s<<"堔堕堖堗堘堙堚堛堜堝堞堟堠堡堢堣堤堥堦堧"
         ar_s<<"堨堩堪堫堬堭堮堯堰報堲堳場堵堶堷堸堹堺堻"
         ar_s<<"堼堽堾堿塀塁塂塃塄塅塆塇塈塉塊塋塌塍塎塏"
         ar_s<<"塐塑塒塓塔塕塖塗塘塙塚塛塜塝塞塟塠塡塢塣"
         ar_s<<"塤塥塦塧塨塩塪填塬塭塮塯塰塱塲塳塴塵塶塷"
         ar_s<<"塸塹塺塻塼塽塾塿墀墁墂境墄墅墆墇墈墉墊墋"
         ar_s<<"墌墍墎墏墐墑墒墓墔墕墖増墘墙墚墛墜墝增墟"
         ar_s<<"墠墡墢墣墤墥墦墧墨墩墪墫墬墭墮墯墰墱墲墳"
         ar_s<<"墴墵墶墷墸墹墺墻墼墽墾墿壀壁壂壃壄壅壆壇"
         ar_s<<"壈壉壊壋壌壍壎壏壐壑壒壓壔壕壖壗壘壙壚壛"
         ar_s<<"壜壝壞壟壠壡壢壣壤壥壦壧壨壩壪士壬壭壮壯"
         ar_s<<"声壱売壳壴壵壶壷壸壹壺壻壼壽壾壿夀夁夂夃"
         ar_s<<"处夅夆备夈変夊夋夌复夎夏夐夑夒夓夔夕外夗"
         ar_s<<"夘夙多夛夜夝夞够夠夡夢夣夤夥夦大夨天太夫"
         ar_s<<"夬夭央夯夰失夲夳头夵夶夷夸夹夺夻夼夽夾夿"
         ar_s<<"奀奁奂奃奄奅奆奇奈奉奊奋奌奍奎奏奐契奒奓"
         ar_s<<"奔奕奖套奘奙奚奛奜奝奞奟奠奡奢奣奤奥奦奧"
         ar_s<<"奨奩奪奫奬奭奮奯奰奱奲女奴奵奶奷奸她奺奻"
         ar_s<<"奼好奾奿妀妁如妃妄妅妆妇妈妉妊妋妌妍妎妏"
         ar_s<<"妐妑妒妓妔妕妖妗妘妙妚妛妜妝妞妟妠妡妢妣"
         ar_s<<"妤妥妦妧妨妩妪妫妬妭妮妯妰妱妲妳妴妵妶妷"
         ar_s<<"妸妹妺妻妼妽妾妿姀姁姂姃姄姅姆姇姈姉姊始"
         ar_s<<"姌姍姎姏姐姑姒姓委姕姖姗姘姙姚姛姜姝姞姟"
         ar_s<<"姠姡姢姣姤姥姦姧姨姩姪姫姬姭姮姯姰姱姲姳"
         ar_s<<"姴姵姶姷姸姹姺姻姼姽姾姿娀威娂娃娄娅娆娇"
         ar_s<<"娈娉娊娋娌娍娎娏娐娑娒娓娔娕娖娗娘娙娚娛"
         ar_s<<"娜娝娞娟娠娡娢娣娤娥娦娧娨娩娪娫娬娭娮娯"
         ar_s<<"娰娱娲娳娴娵娶娷娸娹娺娻娼娽娾娿婀婁婂婃"
         ar_s<<"婄婅婆婇婈婉婊婋婌婍婎婏婐婑婒婓婔婕婖婗"
         ar_s<<"婘婙婚婛婜婝婞婟婠婡婢婣婤婥婦婧婨婩婪婫"
         ar_s<<"婬婭婮婯婰婱婲婳婴婵婶婷婸婹婺婻婼婽婾婿"
         ar_s<<"媀媁媂媃媄媅媆媇媈媉媊媋媌媍媎媏媐媑媒媓"
         ar_s<<"媔媕媖媗媘媙媚媛媜媝媞媟媠媡媢媣媤媥媦媧"
         ar_s<<"媨媩媪媫媬媭媮媯媰媱媲媳媴媵媶媷媸媹媺媻"
         ar_s<<"媼媽媾媿嫀嫁嫂嫃嫄嫅嫆嫇嫈嫉嫊嫋嫌嫍嫎嫏"
         ar_s<<"嫐嫑嫒嫓嫔嫕嫖嫗嫘嫙嫚嫛嫜嫝嫞嫟嫠嫡嫢嫣"
         ar_s<<"嫤嫥嫦嫧嫨嫩嫪嫫嫬嫭嫮嫯嫰嫱嫲嫳嫴嫵嫶嫷"
         ar_s<<"嫸嫹嫺嫻嫼嫽嫾嫿嬀嬁嬂嬃嬄嬅嬆嬇嬈嬉嬊嬋"
         ar_s<<"嬌嬍嬎嬏嬐嬑嬒嬓嬔嬕嬖嬗嬘嬙嬚嬛嬜嬝嬞嬟"
         ar_s<<"嬠嬡嬢嬣嬤嬥嬦嬧嬨嬩嬪嬫嬬嬭嬮嬯嬰嬱嬲嬳"
         ar_s<<"嬴嬵嬶嬷嬸嬹嬺嬻嬼嬽嬾嬿孀孁孂孃孄孅孆孇"
         ar_s<<"孈孉孊孋孌孍孎孏子孑孒孓孔孕孖字存孙孚孛"
         ar_s<<"孜孝孞孟孠孡孢季孤孥学孧孨孩孪孫孬孭孮孯"
         ar_s<<"孰孱孲孳孴孵孶孷學孹孺孻孼孽孾孿宀宁宂它"
         ar_s<<"宄宅宆宇守安宊宋完宍宎宏宐宑宒宓宔宕宖宗"
         ar_s<<"官宙定宛宜宝实実宠审客宣室宥宦宧宨宩宪宫"
         ar_s<<"宬宭宮宯宰宱宲害宴宵家宷宸容宺宻宼宽宾宿"
         ar_s<<"寀寁寂寃寄寅密寇寈寉寊寋富寍寎寏寐寑寒寓"
         ar_s<<"寔寕寖寗寘寙寚寛寜寝寞察寠寡寢寣寤寥實寧"
         ar_s<<"寨審寪寫寬寭寮寯寰寱寲寳寴寵寶寷寸对寺寻"
         ar_s<<"导寽対寿尀封専尃射尅将將專尉尊尋尌對導小"
         ar_s<<"尐少尒尓尔尕尖尗尘尙尚尛尜尝尞尟尠尡尢尣"
         ar_s<<"尤尥尦尧尨尩尪尫尬尭尮尯尰就尲尳尴尵尶尷"
         ar_s<<"尸尹尺尻尼尽尾尿局屁层屃屄居屆屇屈屉届屋"
         ar_s<<"屌屍屎屏屐屑屒屓屔展屖屗屘屙屚屛屜屝属屟"
         ar_s<<"屠屡屢屣層履屦屧屨屩屪屫屬屭屮屯屰山屲屳"
         ar_s<<"屴屵屶屷屸屹屺屻屼屽屾屿岀岁岂岃岄岅岆岇"
         ar_s<<"岈岉岊岋岌岍岎岏岐岑岒岓岔岕岖岗岘岙岚岛"
         ar_s<<"岜岝岞岟岠岡岢岣岤岥岦岧岨岩岪岫岬岭岮岯"
         ar_s<<"岰岱岲岳岴岵岶岷岸岹岺岻岼岽岾岿峀峁峂峃"
         ar_s<<"峄峅峆峇峈峉峊峋峌峍峎峏峐峑峒峓峔峕峖峗"
         ar_s<<"峘峙峚峛峜峝峞峟峠峡峢峣峤峥峦峧峨峩峪峫"
         ar_s<<"峬峭峮峯峰峱峲峳峴峵島峷峸峹峺峻峼峽峾峿"
         ar_s<<"崀崁崂崃崄崅崆崇崈崉崊崋崌崍崎崏崐崑崒崓"
         ar_s<<"崔崕崖崗崘崙崚崛崜崝崞崟崠崡崢崣崤崥崦崧"
         ar_s<<"崨崩崪崫崬崭崮崯崰崱崲崳崴崵崶崷崸崹崺崻"
         ar_s<<"崼崽崾崿嵀嵁嵂嵃嵄嵅嵆嵇嵈嵉嵊嵋嵌嵍嵎嵏"
         ar_s<<"嵐嵑嵒嵓嵔嵕嵖嵗嵘嵙嵚嵛嵜嵝嵞嵟嵠嵡嵢嵣"
         ar_s<<"嵤嵥嵦嵧嵨嵩嵪嵫嵬嵭嵮嵯嵰嵱嵲嵳嵴嵵嵶嵷"
         ar_s<<"嵸嵹嵺嵻嵼嵽嵾嵿嶀嶁嶂嶃嶄嶅嶆嶇嶈嶉嶊嶋"
         ar_s<<"嶌嶍嶎嶏嶐嶑嶒嶓嶔嶕嶖嶗嶘嶙嶚嶛嶜嶝嶞嶟"
         ar_s<<"嶠嶡嶢嶣嶤嶥嶦嶧嶨嶩嶪嶫嶬嶭嶮嶯嶰嶱嶲嶳"
         ar_s<<"嶴嶵嶶嶷嶸嶹嶺嶻嶼嶽嶾嶿巀巁巂巃巄巅巆巇"
         ar_s<<"巈巉巊巋巌巍巎巏巐巑巒巓巔巕巖巗巘巙巚巛"
         ar_s<<"巜川州巟巠巡巢巣巤工左巧巨巩巪巫巬巭差巯"
         ar_s<<"巰己已巳巴巵巶巷巸巹巺巻巼巽巾巿帀币市布"
         ar_s<<"帄帅帆帇师帉帊帋希帍帎帏帐帑帒帓帔帕帖帗"
         ar_s<<"帘帙帚帛帜帝帞帟帠帡帢帣帤帥带帧帨帩帪師"
         ar_s<<"帬席帮帯帰帱帲帳帴帵帶帷常帹帺帻帼帽帾帿"
         ar_s<<"幀幁幂幃幄幅幆幇幈幉幊幋幌幍幎幏幐幑幒幓"
         ar_s<<"幔幕幖幗幘幙幚幛幜幝幞幟幠幡幢幣幤幥幦幧"
         ar_s<<"幨幩幪幫幬幭幮幯幰幱干平年幵并幷幸幹幺幻"
         ar_s<<"幼幽幾广庀庁庂広庄庅庆庇庈庉床庋庌庍庎序"
         ar_s<<"庐庑庒库应底庖店庘庙庚庛府庝庞废庠庡庢庣"
         ar_s<<"庤庥度座庨庩庪庫庬庭庮庯庰庱庲庳庴庵庶康"
         ar_s<<"庸庹庺庻庼庽庾庿廀廁廂廃廄廅廆廇廈廉廊廋"
         ar_s<<"廌廍廎廏廐廑廒廓廔廕廖廗廘廙廚廛廜廝廞廟"
         ar_s<<"廠廡廢廣廤廥廦廧廨廩廪廫廬廭廮廯廰廱廲廳"
         ar_s<<"廴廵延廷廸廹建廻廼廽廾廿开弁异弃弄弅弆弇"
         ar_s<<"弈弉弊弋弌弍弎式弐弑弒弓弔引弖弗弘弙弚弛"
         ar_s<<"弜弝弞弟张弡弢弣弤弥弦弧弨弩弪弫弬弭弮弯"
         ar_s<<"弰弱弲弳弴張弶強弸弹强弻弼弽弾弿彀彁彂彃"
         ar_s<<"彄彅彆彇彈彉彊彋彌彍彎彏彐彑归当彔录彖彗"
         ar_s<<"彘彙彚彛彜彝彞彟彠彡形彣彤彥彦彧彨彩彪彫"
         ar_s<<"彬彭彮彯彰影彲彳彴彵彶彷彸役彺彻彼彽彾彿"
         ar_s<<"往征徂徃径待徆徇很徉徊律後徍徎徏徐徑徒従"
         ar_s<<"徔徕徖得徘徙徚徛徜徝從徟徠御徢徣徤徥徦徧"
         ar_s<<"徨復循徫徬徭微徯徰徱徲徳徴徵徶德徸徹徺徻"
         ar_s<<"徼徽徾徿忀忁忂心忄必忆忇忈忉忊忋忌忍忎忏"
         ar_s<<"忐忑忒忓忔忕忖志忘忙忚忛応忝忞忟忠忡忢忣"
         ar_s<<"忤忥忦忧忨忩忪快忬忭忮忯忰忱忲忳忴念忶忷"
         ar_s<<"忸忹忺忻忼忽忾忿怀态怂怃怄怅怆怇怈怉怊怋"
         ar_s<<"怌怍怎怏怐怑怒怓怔怕怖怗怘怙怚怛怜思怞怟"
         ar_s<<"怠怡怢怣怤急怦性怨怩怪怫怬怭怮怯怰怱怲怳"
         ar_s<<"怴怵怶怷怸怹怺总怼怽怾怿恀恁恂恃恄恅恆恇"
         ar_s<<"恈恉恊恋恌恍恎恏恐恑恒恓恔恕恖恗恘恙恚恛"
         ar_s<<"恜恝恞恟恠恡恢恣恤恥恦恧恨恩恪恫恬恭恮息"
         ar_s<<"恰恱恲恳恴恵恶恷恸恹恺恻恼恽恾恿悀悁悂悃"
         ar_s<<"悄悅悆悇悈悉悊悋悌悍悎悏悐悑悒悓悔悕悖悗"
         ar_s<<"悘悙悚悛悜悝悞悟悠悡悢患悤悥悦悧您悩悪悫"
         ar_s<<"悬悭悮悯悰悱悲悳悴悵悶悷悸悹悺悻悼悽悾悿"
         ar_s<<"惀惁惂惃惄情惆惇惈惉惊惋惌惍惎惏惐惑惒惓"
         ar_s<<"惔惕惖惗惘惙惚惛惜惝惞惟惠惡惢惣惤惥惦惧"
         ar_s<<"惨惩惪惫惬惭惮惯惰惱惲想惴惵惶惷惸惹惺惻"
         ar_s<<"惼惽惾惿愀愁愂愃愄愅愆愇愈愉愊愋愌愍愎意"
         ar_s<<"愐愑愒愓愔愕愖愗愘愙愚愛愜愝愞感愠愡愢愣"
         ar_s<<"愤愥愦愧愨愩愪愫愬愭愮愯愰愱愲愳愴愵愶愷"
         ar_s<<"愸愹愺愻愼愽愾愿慀慁慂慃慄慅慆慇慈慉慊態"
         ar_s<<"慌慍慎慏慐慑慒慓慔慕慖慗慘慙慚慛慜慝慞慟"
         ar_s<<"慠慡慢慣慤慥慦慧慨慩慪慫慬慭慮慯慰慱慲慳"
         ar_s<<"慴慵慶慷慸慹慺慻慼慽慾慿憀憁憂憃憄憅憆憇"
         ar_s<<"憈憉憊憋憌憍憎憏憐憑憒憓憔憕憖憗憘憙憚憛"
         ar_s<<"憜憝憞憟憠憡憢憣憤憥憦憧憨憩憪憫憬憭憮憯"
         ar_s<<"憰憱憲憳憴憵憶憷憸憹憺憻憼憽憾憿懀懁懂懃"
         ar_s<<"懄懅懆懇懈應懊懋懌懍懎懏懐懑懒懓懔懕懖懗"
         ar_s<<"懘懙懚懛懜懝懞懟懠懡懢懣懤懥懦懧懨懩懪懫"
         ar_s<<"懬懭懮懯懰懱懲懳懴懵懶懷懸懹懺懻懼懽懾懿"
         ar_s<<"戀戁戂戃戄戅戆戇戈戉戊戋戌戍戎戏成我戒戓"
         ar_s<<"戔戕或戗战戙戚戛戜戝戞戟戠戡戢戣戤戥戦戧"
         ar_s<<"戨戩截戫戬戭戮戯戰戱戲戳戴戵戶户戸戹戺戻"
         ar_s<<"戼戽戾房所扁扂扃扄扅扆扇扈扉扊手扌才扎扏"
         ar_s<<"扐扑扒打扔払扖扗托扙扚扛扜扝扞扟扠扡扢扣"
         ar_s<<"扤扥扦执扨扩扪扫扬扭扮扯扰扱扲扳扴扵扶扷"
         ar_s<<"扸批扺扻扼扽找承技抁抂抃抄抅抆抇抈抉把抋"
         ar_s<<"抌抍抎抏抐抑抒抓抔投抖抗折抙抚抛抜抝択抟"
         ar_s<<"抠抡抢抣护报抦抧抨抩抪披抬抭抮抯抰抱抲抳"
         ar_s<<"抴抵抶抷抸抹抺抻押抽抾抿拀拁拂拃拄担拆拇"
         ar_s<<"拈拉拊拋拌拍拎拏拐拑拒拓拔拕拖拗拘拙拚招"
         ar_s<<"拜拝拞拟拠拡拢拣拤拥拦拧拨择拪拫括拭拮拯"
         ar_s<<"拰拱拲拳拴拵拶拷拸拹拺拻拼拽拾拿挀持挂挃"
         ar_s<<"挄挅挆指挈按挊挋挌挍挎挏挐挑挒挓挔挕挖挗"
         ar_s<<"挘挙挚挛挜挝挞挟挠挡挢挣挤挥挦挧挨挩挪挫"
         ar_s<<"挬挭挮振挰挱挲挳挴挵挶挷挸挹挺挻挼挽挾挿"
         ar_s<<"捀捁捂捃捄捅捆捇捈捉捊捋捌捍捎捏捐捑捒捓"
         ar_s<<"捔捕捖捗捘捙捚捛捜捝捞损捠捡换捣捤捥捦捧"
         ar_s<<"捨捩捪捫捬捭据捯捰捱捲捳捴捵捶捷捸捹捺捻"
         ar_s<<"捼捽捾捿掀掁掂掃掄掅掆掇授掉掊掋掌掍掎掏"
         ar_s<<"掐掑排掓掔掕掖掗掘掙掚掛掜掝掞掟掠採探掣"
         ar_s<<"掤接掦控推掩措掫掬掭掮掯掰掱掲掳掴掵掶掷"
         ar_s<<"掸掹掺掻掼掽掾掿揀揁揂揃揄揅揆揇揈揉揊揋"
         ar_s<<"揌揍揎描提揑插揓揔揕揖揗揘揙揚換揜揝揞揟"
         ar_s<<"揠握揢揣揤揥揦揧揨揩揪揫揬揭揮揯揰揱揲揳"
         ar_s<<"援揵揶揷揸揹揺揻揼揽揾揿搀搁搂搃搄搅搆搇"
         ar_s<<"搈搉搊搋搌損搎搏搐搑搒搓搔搕搖搗搘搙搚搛"
         ar_s<<"搜搝搞搟搠搡搢搣搤搥搦搧搨搩搪搫搬搭搮搯"
         ar_s<<"搰搱搲搳搴搵搶搷搸搹携搻搼搽搾搿摀摁摂摃"
         ar_s<<"摄摅摆摇摈摉摊摋摌摍摎摏摐摑摒摓摔摕摖摗"
         ar_s<<"摘摙摚摛摜摝摞摟摠摡摢摣摤摥摦摧摨摩摪摫"
         ar_s<<"摬摭摮摯摰摱摲摳摴摵摶摷摸摹摺摻摼摽摾摿"
         ar_s<<"撀撁撂撃撄撅撆撇撈撉撊撋撌撍撎撏撐撑撒撓"
         ar_s<<"撔撕撖撗撘撙撚撛撜撝撞撟撠撡撢撣撤撥撦撧"
         ar_s<<"撨撩撪撫撬播撮撯撰撱撲撳撴撵撶撷撸撹撺撻"
         ar_s<<"撼撽撾撿擀擁擂擃擄擅擆擇擈擉擊擋擌操擎擏"
         ar_s<<"擐擑擒擓擔擕擖擗擘擙據擛擜擝擞擟擠擡擢擣"
         ar_s<<"擤擥擦擧擨擩擪擫擬擭擮擯擰擱擲擳擴擵擶擷"
         ar_s<<"擸擹擺擻擼擽擾擿攀攁攂攃攄攅攆攇攈攉攊攋"
         ar_s<<"攌攍攎攏攐攑攒攓攔攕攖攗攘攙攚攛攜攝攞攟"
         ar_s<<"攠攡攢攣攤攥攦攧攨攩攪攫攬攭攮支攰攱攲攳"
         ar_s<<"攴攵收攷攸改攺攻攼攽放政敀敁敂敃敄故敆敇"
         ar_s<<"效敉敊敋敌敍敎敏敐救敒敓敔敕敖敗敘教敚敛"
         ar_s<<"敜敝敞敟敠敡敢散敤敥敦敧敨敩敪敫敬敭敮敯"
         ar_s<<"数敱敲敳整敵敶敷數敹敺敻敼敽敾敿斀斁斂斃"
         ar_s<<"斄斅斆文斈斉斊斋斌斍斎斏斐斑斒斓斔斕斖斗"
         ar_s<<"斘料斚斛斜斝斞斟斠斡斢斣斤斥斦斧斨斩斪斫"
         ar_s<<"斬断斮斯新斱斲斳斴斵斶斷斸方斺斻於施斾斿"
         ar_s<<"旀旁旂旃旄旅旆旇旈旉旊旋旌旍旎族旐旑旒旓"
         ar_s<<"旔旕旖旗旘旙旚旛旜旝旞旟无旡既旣旤日旦旧"
         ar_s<<"旨早旪旫旬旭旮旯旰旱旲旳旴旵时旷旸旹旺旻"
         ar_s<<"旼旽旾旿昀昁昂昃昄昅昆昇昈昉昊昋昌昍明昏"
         ar_s<<"昐昑昒易昔昕昖昗昘昙昚昛昜昝昞星映昡昢昣"
         ar_s<<"昤春昦昧昨昩昪昫昬昭昮是昰昱昲昳昴昵昶昷"
         ar_s<<"昸昹昺昻昼昽显昿晀晁時晃晄晅晆晇晈晉晊晋"
         ar_s<<"晌晍晎晏晐晑晒晓晔晕晖晗晘晙晚晛晜晝晞晟"
         ar_s<<"晠晡晢晣晤晥晦晧晨晩晪晫晬晭普景晰晱晲晳"
         ar_s<<"晴晵晶晷晸晹智晻晼晽晾晿暀暁暂暃暄暅暆暇"
         ar_s<<"暈暉暊暋暌暍暎暏暐暑暒暓暔暕暖暗暘暙暚暛"
         ar_s<<"暜暝暞暟暠暡暢暣暤暥暦暧暨暩暪暫暬暭暮暯"
         ar_s<<"暰暱暲暳暴暵暶暷暸暹暺暻暼暽暾暿曀曁曂曃"
         ar_s<<"曄曅曆曇曈曉曊曋曌曍曎曏曐曑曒曓曔曕曖曗"
         ar_s<<"曘曙曚曛曜曝曞曟曠曡曢曣曤曥曦曧曨曩曪曫"
         ar_s<<"曬曭曮曯曰曱曲曳更曵曶曷書曹曺曻曼曽曾替"
         ar_s<<"最朁朂會朄朅朆朇月有朊朋朌服朎朏朐朑朒朓"
         ar_s<<"朔朕朖朗朘朙朚望朜朝朞期朠朡朢朣朤朥朦朧"
         ar_s<<"木朩未末本札朮术朰朱朲朳朴朵朶朷朸朹机朻"
         ar_s<<"朼朽朾朿杀杁杂权杄杅杆杇杈杉杊杋杌杍李杏"
         ar_s<<"材村杒杓杔杕杖杗杘杙杚杛杜杝杞束杠条杢杣"
         ar_s<<"杤来杦杧杨杩杪杫杬杭杮杯杰東杲杳杴杵杶杷"
         ar_s<<"杸杹杺杻杼杽松板枀极枂枃构枅枆枇枈枉枊枋"
         ar_s<<"枌枍枎枏析枑枒枓枔枕枖林枘枙枚枛果枝枞枟"
         ar_s<<"枠枡枢枣枤枥枦枧枨枩枪枫枬枭枮枯枰枱枲枳"
         ar_s<<"枴枵架枷枸枹枺枻枼枽枾枿柀柁柂柃柄柅柆柇"
         ar_s<<"柈柉柊柋柌柍柎柏某柑柒染柔柕柖柗柘柙柚柛"
         ar_s<<"柜柝柞柟柠柡柢柣柤查柦柧柨柩柪柫柬柭柮柯"
         ar_s<<"柰柱柲柳柴柵柶柷柸柹柺査柼柽柾柿栀栁栂栃"
         ar_s<<"栄栅栆标栈栉栊栋栌栍栎栏栐树栒栓栔栕栖栗"
         ar_s<<"栘栙栚栛栜栝栞栟栠校栢栣栤栥栦栧栨栩株栫"
         ar_s<<"栬栭栮栯栰栱栲栳栴栵栶样核根栺栻格栽栾栿"
         ar_s<<"桀桁桂桃桄桅框桇案桉桊桋桌桍桎桏桐桑桒桓"
         ar_s<<"桔桕桖桗桘桙桚桛桜桝桞桟桠桡桢档桤桥桦桧"
         ar_s<<"桨桩桪桫桬桭桮桯桰桱桲桳桴桵桶桷桸桹桺桻"
         ar_s<<"桼桽桾桿梀梁梂梃梄梅梆梇梈梉梊梋梌梍梎梏"
         ar_s<<"梐梑梒梓梔梕梖梗梘梙梚梛梜條梞梟梠梡梢梣"
         ar_s<<"梤梥梦梧梨梩梪梫梬梭梮梯械梱梲梳梴梵梶梷"
         ar_s<<"梸梹梺梻梼梽梾梿检棁棂棃棄棅棆棇棈棉棊棋"
         ar_s<<"棌棍棎棏棐棑棒棓棔棕棖棗棘棙棚棛棜棝棞棟"
         ar_s<<"棠棡棢棣棤棥棦棧棨棩棪棫棬棭森棯棰棱棲棳"
         ar_s<<"棴棵棶棷棸棹棺棻棼棽棾棿椀椁椂椃椄椅椆椇"
         ar_s<<"椈椉椊椋椌植椎椏椐椑椒椓椔椕椖椗椘椙椚椛"
         ar_s<<"検椝椞椟椠椡椢椣椤椥椦椧椨椩椪椫椬椭椮椯"
         ar_s<<"椰椱椲椳椴椵椶椷椸椹椺椻椼椽椾椿楀楁楂楃"
         ar_s<<"楄楅楆楇楈楉楊楋楌楍楎楏楐楑楒楓楔楕楖楗"
         ar_s<<"楘楙楚楛楜楝楞楟楠楡楢楣楤楥楦楧楨楩楪楫"
         ar_s<<"楬業楮楯楰楱楲楳楴極楶楷楸楹楺楻楼楽楾楿"
         ar_s<<"榀榁概榃榄榅榆榇榈榉榊榋榌榍榎榏榐榑榒榓"
         ar_s<<"榔榕榖榗榘榙榚榛榜榝榞榟榠榡榢榣榤榥榦榧"
         ar_s<<"榨榩榪榫榬榭榮榯榰榱榲榳榴榵榶榷榸榹榺榻"
         ar_s<<"榼榽榾榿槀槁槂槃槄槅槆槇槈槉槊構槌槍槎槏"
         ar_s<<"槐槑槒槓槔槕槖槗様槙槚槛槜槝槞槟槠槡槢槣"
         ar_s<<"槤槥槦槧槨槩槪槫槬槭槮槯槰槱槲槳槴槵槶槷"
         ar_s<<"槸槹槺槻槼槽槾槿樀樁樂樃樄樅樆樇樈樉樊樋"
         ar_s<<"樌樍樎樏樐樑樒樓樔樕樖樗樘標樚樛樜樝樞樟"
         ar_s<<"樠模樢樣樤樥樦樧樨権横樫樬樭樮樯樰樱樲樳"
         ar_s<<"樴樵樶樷樸樹樺樻樼樽樾樿橀橁橂橃橄橅橆橇"
         ar_s<<"橈橉橊橋橌橍橎橏橐橑橒橓橔橕橖橗橘橙橚橛"
         ar_s<<"橜橝橞機橠橡橢橣橤橥橦橧橨橩橪橫橬橭橮橯"
         ar_s<<"橰橱橲橳橴橵橶橷橸橹橺橻橼橽橾橿檀檁檂檃"
         ar_s<<"檄檅檆檇檈檉檊檋檌檍檎檏檐檑檒檓檔檕檖檗"
         ar_s<<"檘檙檚檛檜檝檞檟檠檡檢檣檤檥檦檧檨檩檪檫"
         ar_s<<"檬檭檮檯檰檱檲檳檴檵檶檷檸檹檺檻檼檽檾檿"
         ar_s<<"櫀櫁櫂櫃櫄櫅櫆櫇櫈櫉櫊櫋櫌櫍櫎櫏櫐櫑櫒櫓"
         ar_s<<"櫔櫕櫖櫗櫘櫙櫚櫛櫜櫝櫞櫟櫠櫡櫢櫣櫤櫥櫦櫧"
         ar_s<<"櫨櫩櫪櫫櫬櫭櫮櫯櫰櫱櫲櫳櫴櫵櫶櫷櫸櫹櫺櫻"
         ar_s<<"櫼櫽櫾櫿欀欁欂欃欄欅欆欇欈欉權欋欌欍欎欏"
         ar_s<<"欐欑欒欓欔欕欖欗欘欙欚欛欜欝欞欟欠次欢欣"
         ar_s<<"欤欥欦欧欨欩欪欫欬欭欮欯欰欱欲欳欴欵欶欷"
         ar_s<<"欸欹欺欻欼欽款欿歀歁歂歃歄歅歆歇歈歉歊歋"
         ar_s<<"歌歍歎歏歐歑歒歓歔歕歖歗歘歙歚歛歜歝歞歟"
         ar_s<<"歠歡止正此步武歧歨歩歪歫歬歭歮歯歰歱歲歳"
         ar_s<<"歴歵歶歷歸歹歺死歼歽歾歿殀殁殂殃殄殅殆殇"
         ar_s<<"殈殉殊残殌殍殎殏殐殑殒殓殔殕殖殗殘殙殚殛"
         ar_s<<"殜殝殞殟殠殡殢殣殤殥殦殧殨殩殪殫殬殭殮殯"
         ar_s<<"殰殱殲殳殴段殶殷殸殹殺殻殼殽殾殿毀毁毂毃"
         ar_s<<"毄毅毆毇毈毉毊毋毌母毎每毐毑毒毓比毕毖毗"
         ar_s<<"毘毙毚毛毜毝毞毟毠毡毢毣毤毥毦毧毨毩毪毫"
         ar_s<<"毬毭毮毯毰毱毲毳毴毵毶毷毸毹毺毻毼毽毾毿"
         ar_s<<"氀氁氂氃氄氅氆氇氈氉氊氋氌氍氎氏氐民氒氓"
         ar_s<<"气氕氖気氘氙氚氛氜氝氞氟氠氡氢氣氤氥氦氧"
         ar_s<<"氨氩氪氫氬氭氮氯氰氱氲氳水氵氶氷永氹氺氻"
         ar_s<<"氼氽氾氿汀汁求汃汄汅汆汇汈汉汊汋汌汍汎汏"
         ar_s<<"汐汑汒汓汔汕汖汗汘汙汚汛汜汝汞江池污汢汣"
         ar_s<<"汤汥汦汧汨汩汪汫汬汭汮汯汰汱汲汳汴汵汶汷"
         ar_s<<"汸汹決汻汼汽汾汿沀沁沂沃沄沅沆沇沈沉沊沋"
         ar_s<<"沌沍沎沏沐沑沒沓沔沕沖沗沘沙沚沛沜沝沞沟"
         ar_s<<"沠没沢沣沤沥沦沧沨沩沪沫沬沭沮沯沰沱沲河"
         ar_s<<"沴沵沶沷沸油沺治沼沽沾沿泀況泂泃泄泅泆泇"
         ar_s<<"泈泉泊泋泌泍泎泏泐泑泒泓泔法泖泗泘泙泚泛"
         ar_s<<"泜泝泞泟泠泡波泣泤泥泦泧注泩泪泫泬泭泮泯"
         ar_s<<"泰泱泲泳泴泵泶泷泸泹泺泻泼泽泾泿洀洁洂洃"
         ar_s<<"洄洅洆洇洈洉洊洋洌洍洎洏洐洑洒洓洔洕洖洗"
         ar_s<<"洘洙洚洛洜洝洞洟洠洡洢洣洤津洦洧洨洩洪洫"
         ar_s<<"洬洭洮洯洰洱洲洳洴洵洶洷洸洹洺活洼洽派洿"
         ar_s<<"浀流浂浃浄浅浆浇浈浉浊测浌浍济浏浐浑浒浓"
         ar_s<<"浔浕浖浗浘浙浚浛浜浝浞浟浠浡浢浣浤浥浦浧"
         ar_s<<"浨浩浪浫浬浭浮浯浰浱浲浳浴浵浶海浸浹浺浻"
         ar_s<<"浼浽浾浿涀涁涂涃涄涅涆涇消涉涊涋涌涍涎涏"
         ar_s<<"涐涑涒涓涔涕涖涗涘涙涚涛涜涝涞涟涠涡涢涣"
         ar_s<<"涤涥润涧涨涩涪涫涬涭涮涯涰涱液涳涴涵涶涷"
         ar_s<<"涸涹涺涻涼涽涾涿淀淁淂淃淄淅淆淇淈淉淊淋"
         ar_s<<"淌淍淎淏淐淑淒淓淔淕淖淗淘淙淚淛淜淝淞淟"
         ar_s<<"淠淡淢淣淤淥淦淧淨淩淪淫淬淭淮淯淰深淲淳"
         ar_s<<"淴淵淶混淸淹淺添淼淽淾淿渀渁渂渃渄清渆渇"
         ar_s<<"済渉渊渋渌渍渎渏渐渑渒渓渔渕渖渗渘渙渚減"
         ar_s<<"渜渝渞渟渠渡渢渣渤渥渦渧渨温渪渫測渭渮港"
         ar_s<<"渰渱渲渳渴渵渶渷游渹渺渻渼渽渾渿湀湁湂湃"
         ar_s<<"湄湅湆湇湈湉湊湋湌湍湎湏湐湑湒湓湔湕湖湗"
         ar_s<<"湘湙湚湛湜湝湞湟湠湡湢湣湤湥湦湧湨湩湪湫"
         ar_s<<"湬湭湮湯湰湱湲湳湴湵湶湷湸湹湺湻湼湽湾湿"
         ar_s<<"満溁溂溃溄溅溆溇溈溉溊溋溌溍溎溏源溑溒溓"
         ar_s<<"溔溕準溗溘溙溚溛溜溝溞溟溠溡溢溣溤溥溦溧"
         ar_s<<"溨溩溪溫溬溭溮溯溰溱溲溳溴溵溶溷溸溹溺溻"
         ar_s<<"溼溽溾溿滀滁滂滃滄滅滆滇滈滉滊滋滌滍滎滏"
         ar_s<<"滐滑滒滓滔滕滖滗滘滙滚滛滜滝滞滟滠满滢滣"
         ar_s<<"滤滥滦滧滨滩滪滫滬滭滮滯滰滱滲滳滴滵滶滷"
         ar_s<<"滸滹滺滻滼滽滾滿漀漁漂漃漄漅漆漇漈漉漊漋"
         ar_s<<"漌漍漎漏漐漑漒漓演漕漖漗漘漙漚漛漜漝漞漟"
         ar_s<<"漠漡漢漣漤漥漦漧漨漩漪漫漬漭漮漯漰漱漲漳"
         ar_s<<"漴漵漶漷漸漹漺漻漼漽漾漿潀潁潂潃潄潅潆潇"
         ar_s<<"潈潉潊潋潌潍潎潏潐潑潒潓潔潕潖潗潘潙潚潛"
         ar_s<<"潜潝潞潟潠潡潢潣潤潥潦潧潨潩潪潫潬潭潮潯"
         ar_s<<"潰潱潲潳潴潵潶潷潸潹潺潻潼潽潾潿澀澁澂澃"
         ar_s<<"澄澅澆澇澈澉澊澋澌澍澎澏澐澑澒澓澔澕澖澗"
         ar_s<<"澘澙澚澛澜澝澞澟澠澡澢澣澤澥澦澧澨澩澪澫"
         ar_s<<"澬澭澮澯澰澱澲澳澴澵澶澷澸澹澺澻澼澽澾澿"
         ar_s<<"激濁濂濃濄濅濆濇濈濉濊濋濌濍濎濏濐濑濒濓"
         ar_s<<"濔濕濖濗濘濙濚濛濜濝濞濟濠濡濢濣濤濥濦濧"
         ar_s<<"濨濩濪濫濬濭濮濯濰濱濲濳濴濵濶濷濸濹濺濻"
         ar_s<<"濼濽濾濿瀀瀁瀂瀃瀄瀅瀆瀇瀈瀉瀊瀋瀌瀍瀎瀏"
         ar_s<<"瀐瀑瀒瀓瀔瀕瀖瀗瀘瀙瀚瀛瀜瀝瀞瀟瀠瀡瀢瀣"
         ar_s<<"瀤瀥瀦瀧瀨瀩瀪瀫瀬瀭瀮瀯瀰瀱瀲瀳瀴瀵瀶瀷"
         ar_s<<"瀸瀹瀺瀻瀼瀽瀾瀿灀灁灂灃灄灅灆灇灈灉灊灋"
         ar_s<<"灌灍灎灏灐灑灒灓灔灕灖灗灘灙灚灛灜灝灞灟"
         ar_s<<"灠灡灢灣灤灥灦灧灨灩灪火灬灭灮灯灰灱灲灳"
         ar_s<<"灴灵灶灷灸灹灺灻灼災灾灿炀炁炂炃炄炅炆炇"
         ar_s<<"炈炉炊炋炌炍炎炏炐炑炒炓炔炕炖炗炘炙炚炛"
         ar_s<<"炜炝炞炟炠炡炢炣炤炥炦炧炨炩炪炫炬炭炮炯"
         ar_s<<"炰炱炲炳炴炵炶炷炸点為炻炼炽炾炿烀烁烂烃"
         ar_s<<"烄烅烆烇烈烉烊烋烌烍烎烏烐烑烒烓烔烕烖烗"
         ar_s<<"烘烙烚烛烜烝烞烟烠烡烢烣烤烥烦烧烨烩烪烫"
         ar_s<<"烬热烮烯烰烱烲烳烴烵烶烷烸烹烺烻烼烽烾烿"
         ar_s<<"焀焁焂焃焄焅焆焇焈焉焊焋焌焍焎焏焐焑焒焓"
         ar_s<<"焔焕焖焗焘焙焚焛焜焝焞焟焠無焢焣焤焥焦焧"
         ar_s<<"焨焩焪焫焬焭焮焯焰焱焲焳焴焵然焷焸焹焺焻"
         ar_s<<"焼焽焾焿煀煁煂煃煄煅煆煇煈煉煊煋煌煍煎煏"
         ar_s<<"煐煑煒煓煔煕煖煗煘煙煚煛煜煝煞煟煠煡煢煣"
         ar_s<<"煤煥煦照煨煩煪煫煬煭煮煯煰煱煲煳煴煵煶煷"
         ar_s<<"煸煹煺煻煼煽煾煿熀熁熂熃熄熅熆熇熈熉熊熋"
         ar_s<<"熌熍熎熏熐熑熒熓熔熕熖熗熘熙熚熛熜熝熞熟"
         ar_s<<"熠熡熢熣熤熥熦熧熨熩熪熫熬熭熮熯熰熱熲熳"
         ar_s<<"熴熵熶熷熸熹熺熻熼熽熾熿燀燁燂燃燄燅燆燇"
         ar_s<<"燈燉燊燋燌燍燎燏燐燑燒燓燔燕燖燗燘燙燚燛"
         ar_s<<"燜燝燞營燠燡燢燣燤燥燦燧燨燩燪燫燬燭燮燯"
         ar_s<<"燰燱燲燳燴燵燶燷燸燹燺燻燼燽燾燿爀爁爂爃"
         ar_s<<"爄爅爆爇爈爉爊爋爌爍爎爏爐爑爒爓爔爕爖爗"
         ar_s<<"爘爙爚爛爜爝爞爟爠爡爢爣爤爥爦爧爨爩爪爫"
         ar_s<<"爬爭爮爯爰爱爲爳爴爵父爷爸爹爺爻爼爽爾爿"
         ar_s<<"牀牁牂牃牄牅牆片版牉牊牋牌牍牎牏牐牑牒牓"
         ar_s<<"牔牕牖牗牘牙牚牛牜牝牞牟牠牡牢牣牤牥牦牧"
         ar_s<<"牨物牪牫牬牭牮牯牰牱牲牳牴牵牶牷牸特牺牻"
         ar_s<<"牼牽牾牿犀犁犂犃犄犅犆犇犈犉犊犋犌犍犎犏"
         ar_s<<"犐犑犒犓犔犕犖犗犘犙犚犛犜犝犞犟犠犡犢犣"
         ar_s<<"犤犥犦犧犨犩犪犫犬犭犮犯犰犱犲犳犴犵状犷"
         ar_s<<"犸犹犺犻犼犽犾犿狀狁狂狃狄狅狆狇狈狉狊狋"
         ar_s<<"狌狍狎狏狐狑狒狓狔狕狖狗狘狙狚狛狜狝狞狟"
         ar_s<<"狠狡狢狣狤狥狦狧狨狩狪狫独狭狮狯狰狱狲狳"
         ar_s<<"狴狵狶狷狸狹狺狻狼狽狾狿猀猁猂猃猄猅猆猇"
         ar_s<<"猈猉猊猋猌猍猎猏猐猑猒猓猔猕猖猗猘猙猚猛"
         ar_s<<"猜猝猞猟猠猡猢猣猤猥猦猧猨猩猪猫猬猭献猯"
         ar_s<<"猰猱猲猳猴猵猶猷猸猹猺猻猼猽猾猿獀獁獂獃"
         ar_s<<"獄獅獆獇獈獉獊獋獌獍獎獏獐獑獒獓獔獕獖獗"
         ar_s<<"獘獙獚獛獜獝獞獟獠獡獢獣獤獥獦獧獨獩獪獫"
         ar_s<<"獬獭獮獯獰獱獲獳獴獵獶獷獸獹獺獻獼獽獾獿"
         ar_s<<"玀玁玂玃玄玅玆率玈玉玊王玌玍玎玏玐玑玒玓"
         ar_s<<"玔玕玖玗玘玙玚玛玜玝玞玟玠玡玢玣玤玥玦玧"
         ar_s<<"玨玩玪玫玬玭玮环现玱玲玳玴玵玶玷玸玹玺玻"
         ar_s<<"玼玽玾玿珀珁珂珃珄珅珆珇珈珉珊珋珌珍珎珏"
         ar_s<<"珐珑珒珓珔珕珖珗珘珙珚珛珜珝珞珟珠珡珢珣"
         ar_s<<"珤珥珦珧珨珩珪珫珬班珮珯珰珱珲珳珴珵珶珷"
         ar_s<<"珸珹珺珻珼珽現珿琀琁琂球琄琅理琇琈琉琊琋"
         ar_s<<"琌琍琎琏琐琑琒琓琔琕琖琗琘琙琚琛琜琝琞琟"
         ar_s<<"琠琡琢琣琤琥琦琧琨琩琪琫琬琭琮琯琰琱琲琳"
         ar_s<<"琴琵琶琷琸琹琺琻琼琽琾琿瑀瑁瑂瑃瑄瑅瑆瑇"
         ar_s<<"瑈瑉瑊瑋瑌瑍瑎瑏瑐瑑瑒瑓瑔瑕瑖瑗瑘瑙瑚瑛"
         ar_s<<"瑜瑝瑞瑟瑠瑡瑢瑣瑤瑥瑦瑧瑨瑩瑪瑫瑬瑭瑮瑯"
         ar_s<<"瑰瑱瑲瑳瑴瑵瑶瑷瑸瑹瑺瑻瑼瑽瑾瑿璀璁璂璃"
         ar_s<<"璄璅璆璇璈璉璊璋璌璍璎璏璐璑璒璓璔璕璖璗"
         ar_s<<"璘璙璚璛璜璝璞璟璠璡璢璣璤璥璦璧璨璩璪璫"
         ar_s<<"璬璭璮璯環璱璲璳璴璵璶璷璸璹璺璻璼璽璾璿"
         ar_s<<"瓀瓁瓂瓃瓄瓅瓆瓇瓈瓉瓊瓋瓌瓍瓎瓏瓐瓑瓒瓓"
         ar_s<<"瓔瓕瓖瓗瓘瓙瓚瓛瓜瓝瓞瓟瓠瓡瓢瓣瓤瓥瓦瓧"
         ar_s<<"瓨瓩瓪瓫瓬瓭瓮瓯瓰瓱瓲瓳瓴瓵瓶瓷瓸瓹瓺瓻"
         ar_s<<"瓼瓽瓾瓿甀甁甂甃甄甅甆甇甈甉甊甋甌甍甎甏"
         ar_s<<"甐甑甒甓甔甕甖甗甘甙甚甛甜甝甞生甠甡產産"
         ar_s<<"甤甥甦甧用甩甪甫甬甭甮甯田由甲申甴电甶男"
         ar_s<<"甸甹町画甼甽甾甿畀畁畂畃畄畅畆畇畈畉畊畋"
         ar_s<<"界畍畎畏畐畑畒畓畔畕畖畗畘留畚畛畜畝畞畟"
         ar_s<<"畠畡畢畣畤略畦畧畨畩番畫畬畭畮畯異畱畲畳"
         ar_s<<"畴畵當畷畸畹畺畻畼畽畾畿疀疁疂疃疄疅疆疇"
         ar_s<<"疈疉疊疋疌疍疎疏疐疑疒疓疔疕疖疗疘疙疚疛"
         ar_s<<"疜疝疞疟疠疡疢疣疤疥疦疧疨疩疪疫疬疭疮疯"
         ar_s<<"疰疱疲疳疴疵疶疷疸疹疺疻疼疽疾疿痀痁痂痃"
         ar_s<<"痄病痆症痈痉痊痋痌痍痎痏痐痑痒痓痔痕痖痗"
         ar_s<<"痘痙痚痛痜痝痞痟痠痡痢痣痤痥痦痧痨痩痪痫"
         ar_s<<"痬痭痮痯痰痱痲痳痴痵痶痷痸痹痺痻痼痽痾痿"
         ar_s<<"瘀瘁瘂瘃瘄瘅瘆瘇瘈瘉瘊瘋瘌瘍瘎瘏瘐瘑瘒瘓"
         ar_s<<"瘔瘕瘖瘗瘘瘙瘚瘛瘜瘝瘞瘟瘠瘡瘢瘣瘤瘥瘦瘧"
         ar_s<<"瘨瘩瘪瘫瘬瘭瘮瘯瘰瘱瘲瘳瘴瘵瘶瘷瘸瘹瘺瘻"
         ar_s<<"瘼瘽瘾瘿癀癁療癃癄癅癆癇癈癉癊癋癌癍癎癏"
         ar_s<<"癐癑癒癓癔癕癖癗癘癙癚癛癜癝癞癟癠癡癢癣"
         ar_s<<"癤癥癦癧癨癩癪癫癬癭癮癯癰癱癲癳癴癵癶癷"
         ar_s<<"癸癹発登發白百癿皀皁皂皃的皅皆皇皈皉皊皋"
         ar_s<<"皌皍皎皏皐皑皒皓皔皕皖皗皘皙皚皛皜皝皞皟"
         ar_s<<"皠皡皢皣皤皥皦皧皨皩皪皫皬皭皮皯皰皱皲皳"
         ar_s<<"皴皵皶皷皸皹皺皻皼皽皾皿盀盁盂盃盄盅盆盇"
         ar_s<<"盈盉益盋盌盍盎盏盐监盒盓盔盕盖盗盘盙盚盛"
         ar_s<<"盜盝盞盟盠盡盢監盤盥盦盧盨盩盪盫盬盭目盯"
         ar_s<<"盰盱盲盳直盵盶盷相盹盺盻盼盽盾盿眀省眂眃"
         ar_s<<"眄眅眆眇眈眉眊看県眍眎眏眐眑眒眓眔眕眖眗"
         ar_s<<"眘眙眚眛眜眝眞真眠眡眢眣眤眥眦眧眨眩眪眫"
         ar_s<<"眬眭眮眯眰眱眲眳眴眵眶眷眸眹眺眻眼眽眾眿"
         ar_s<<"着睁睂睃睄睅睆睇睈睉睊睋睌睍睎睏睐睑睒睓"
         ar_s<<"睔睕睖睗睘睙睚睛睜睝睞睟睠睡睢督睤睥睦睧"
         ar_s<<"睨睩睪睫睬睭睮睯睰睱睲睳睴睵睶睷睸睹睺睻"
         ar_s<<"睼睽睾睿瞀瞁瞂瞃瞄瞅瞆瞇瞈瞉瞊瞋瞌瞍瞎瞏"
         ar_s<<"瞐瞑瞒瞓瞔瞕瞖瞗瞘瞙瞚瞛瞜瞝瞞瞟瞠瞡瞢瞣"
         ar_s<<"瞤瞥瞦瞧瞨瞩瞪瞫瞬瞭瞮瞯瞰瞱瞲瞳瞴瞵瞶瞷"
         ar_s<<"瞸瞹瞺瞻瞼瞽瞾瞿矀矁矂矃矄矅矆矇矈矉矊矋"
         ar_s<<"矌矍矎矏矐矑矒矓矔矕矖矗矘矙矚矛矜矝矞矟"
         ar_s<<"矠矡矢矣矤知矦矧矨矩矪矫矬短矮矯矰矱矲石"
         ar_s<<"矴矵矶矷矸矹矺矻矼矽矾矿砀码砂砃砄砅砆砇"
         ar_s<<"砈砉砊砋砌砍砎砏砐砑砒砓研砕砖砗砘砙砚砛"
         ar_s<<"砜砝砞砟砠砡砢砣砤砥砦砧砨砩砪砫砬砭砮砯"
         ar_s<<"砰砱砲砳破砵砶砷砸砹砺砻砼砽砾砿础硁硂硃"
         ar_s<<"硄硅硆硇硈硉硊硋硌硍硎硏硐硑硒硓硔硕硖硗"
         ar_s<<"硘硙硚硛硜硝硞硟硠硡硢硣硤硥硦硧硨硩硪硫"
         ar_s<<"硬硭确硯硰硱硲硳硴硵硶硷硸硹硺硻硼硽硾硿"
         ar_s<<"碀碁碂碃碄碅碆碇碈碉碊碋碌碍碎碏碐碑碒碓"
         ar_s<<"碔碕碖碗碘碙碚碛碜碝碞碟碠碡碢碣碤碥碦碧"
         ar_s<<"碨碩碪碫碬碭碮碯碰碱碲碳碴碵碶碷碸碹確碻"
         ar_s<<"碼碽碾碿磀磁磂磃磄磅磆磇磈磉磊磋磌磍磎磏"
         ar_s<<"磐磑磒磓磔磕磖磗磘磙磚磛磜磝磞磟磠磡磢磣"
         ar_s<<"磤磥磦磧磨磩磪磫磬磭磮磯磰磱磲磳磴磵磶磷"
         ar_s<<"磸磹磺磻磼磽磾磿礀礁礂礃礄礅礆礇礈礉礊礋"
         ar_s<<"礌礍礎礏礐礑礒礓礔礕礖礗礘礙礚礛礜礝礞礟"
         ar_s<<"礠礡礢礣礤礥礦礧礨礩礪礫礬礭礮礯礰礱礲礳"
         ar_s<<"礴礵礶礷礸礹示礻礼礽社礿祀祁祂祃祄祅祆祇"
         ar_s<<"祈祉祊祋祌祍祎祏祐祑祒祓祔祕祖祗祘祙祚祛"
         ar_s<<"祜祝神祟祠祡祢祣祤祥祦祧票祩祪祫祬祭祮祯"
         ar_s<<"祰祱祲祳祴祵祶祷祸祹祺祻祼祽祾祿禀禁禂禃"
         ar_s<<"禄禅禆禇禈禉禊禋禌禍禎福禐禑禒禓禔禕禖禗"
         ar_s<<"禘禙禚禛禜禝禞禟禠禡禢禣禤禥禦禧禨禩禪禫"
         ar_s<<"禬禭禮禯禰禱禲禳禴禵禶禷禸禹禺离禼禽禾禿"
         ar_s<<"秀私秂秃秄秅秆秇秈秉秊秋秌种秎秏秐科秒秓"
         ar_s<<"秔秕秖秗秘秙秚秛秜秝秞租秠秡秢秣秤秥秦秧"
         ar_s<<"秨秩秪秫秬秭秮积称秱秲秳秴秵秶秷秸秹秺移"
         ar_s<<"秼秽秾秿稀稁稂稃稄稅稆稇稈稉稊程稌稍税稏"
         ar_s<<"稐稑稒稓稔稕稖稗稘稙稚稛稜稝稞稟稠稡稢稣"
         ar_s<<"稤稥稦稧稨稩稪稫稬稭種稯稰稱稲稳稴稵稶稷"
         ar_s<<"稸稹稺稻稼稽稾稿穀穁穂穃穄穅穆穇穈穉穊穋"
         ar_s<<"穌積穎穏穐穑穒穓穔穕穖穗穘穙穚穛穜穝穞穟"
         ar_s<<"穠穡穢穣穤穥穦穧穨穩穪穫穬穭穮穯穰穱穲穳"
         ar_s<<"穴穵究穷穸穹空穻穼穽穾穿窀突窂窃窄窅窆窇"
         ar_s<<"窈窉窊窋窌窍窎窏窐窑窒窓窔窕窖窗窘窙窚窛"
         ar_s<<"窜窝窞窟窠窡窢窣窤窥窦窧窨窩窪窫窬窭窮窯"
         ar_s<<"窰窱窲窳窴窵窶窷窸窹窺窻窼窽窾窿竀竁竂竃"
         ar_s<<"竄竅竆竇竈竉竊立竌竍竎竏竐竑竒竓竔竕竖竗"
         ar_s<<"竘站竚竛竜竝竞竟章竡竢竣竤童竦竧竨竩竪竫"
         ar_s<<"竬竭竮端竰竱竲竳竴竵競竷竸竹竺竻竼竽竾竿"
         ar_s<<"笀笁笂笃笄笅笆笇笈笉笊笋笌笍笎笏笐笑笒笓"
         ar_s<<"笔笕笖笗笘笙笚笛笜笝笞笟笠笡笢笣笤笥符笧"
         ar_s<<"笨笩笪笫第笭笮笯笰笱笲笳笴笵笶笷笸笹笺笻"
         ar_s<<"笼笽笾笿筀筁筂筃筄筅筆筇筈等筊筋筌筍筎筏"
         ar_s<<"筐筑筒筓答筕策筗筘筙筚筛筜筝筞筟筠筡筢筣"
         ar_s<<"筤筥筦筧筨筩筪筫筬筭筮筯筰筱筲筳筴筵筶筷"
         ar_s<<"筸筹筺筻筼筽签筿简箁箂箃箄箅箆箇箈箉箊箋"
         ar_s<<"箌箍箎箏箐箑箒箓箔箕箖算箘箙箚箛箜箝箞箟"
         ar_s<<"箠管箢箣箤箥箦箧箨箩箪箫箬箭箮箯箰箱箲箳"
         ar_s<<"箴箵箶箷箸箹箺箻箼箽箾箿節篁篂篃範篅篆篇"
         ar_s<<"篈築篊篋篌篍篎篏篐篑篒篓篔篕篖篗篘篙篚篛"
         ar_s<<"篜篝篞篟篠篡篢篣篤篥篦篧篨篩篪篫篬篭篮篯"
         ar_s<<"篰篱篲篳篴篵篶篷篸篹篺篻篼篽篾篿簀簁簂簃"
         ar_s<<"簄簅簆簇簈簉簊簋簌簍簎簏簐簑簒簓簔簕簖簗"
         ar_s<<"簘簙簚簛簜簝簞簟簠簡簢簣簤簥簦簧簨簩簪簫"
         ar_s<<"簬簭簮簯簰簱簲簳簴簵簶簷簸簹簺簻簼簽簾簿"
         ar_s<<"籀籁籂籃籄籅籆籇籈籉籊籋籌籍籎籏籐籑籒籓"
         ar_s<<"籔籕籖籗籘籙籚籛籜籝籞籟籠籡籢籣籤籥籦籧"
         ar_s<<"籨籩籪籫籬籭籮籯籰籱籲米籴籵籶籷籸籹籺类"
         ar_s<<"籼籽籾籿粀粁粂粃粄粅粆粇粈粉粊粋粌粍粎粏"
         ar_s<<"粐粑粒粓粔粕粖粗粘粙粚粛粜粝粞粟粠粡粢粣"
         ar_s<<"粤粥粦粧粨粩粪粫粬粭粮粯粰粱粲粳粴粵粶粷"
         ar_s<<"粸粹粺粻粼粽精粿糀糁糂糃糄糅糆糇糈糉糊糋"
         ar_s<<"糌糍糎糏糐糑糒糓糔糕糖糗糘糙糚糛糜糝糞糟"
         ar_s<<"糠糡糢糣糤糥糦糧糨糩糪糫糬糭糮糯糰糱糲糳"
         ar_s<<"糴糵糶糷糸糹糺系糼糽糾糿紀紁紂紃約紅紆紇"
         ar_s<<"紈紉紊紋紌納紎紏紐紑紒紓純紕紖紗紘紙級紛"
         ar_s<<"紜紝紞紟素紡索紣紤紥紦紧紨紩紪紫紬紭紮累"
         ar_s<<"細紱紲紳紴紵紶紷紸紹紺紻紼紽紾紿絀絁終絃"
         ar_s<<"組絅絆絇絈絉絊絋経絍絎絏結絑絒絓絔絕絖絗"
         ar_s<<"絘絙絚絛絜絝絞絟絠絡絢絣絤絥給絧絨絩絪絫"
         ar_s<<"絬絭絮絯絰統絲絳絴絵絶絷絸絹絺絻絼絽絾絿"
         ar_s<<"綀綁綂綃綄綅綆綇綈綉綊綋綌綍綎綏綐綑綒經"
         ar_s<<"綔綕綖綗綘継続綛綜綝綞綟綠綡綢綣綤綥綦綧"
         ar_s<<"綨綩綪綫綬維綮綯綰綱網綳綴綵綶綷綸綹綺綻"
         ar_s<<"綼綽綾綿緀緁緂緃緄緅緆緇緈緉緊緋緌緍緎総"
         ar_s<<"緐緑緒緓緔緕緖緗緘緙線緛緜緝緞緟締緡緢緣"
         ar_s<<"緤緥緦緧編緩緪緫緬緭緮緯緰緱緲緳練緵緶緷"
         ar_s<<"緸緹緺緻緼緽緾緿縀縁縂縃縄縅縆縇縈縉縊縋"
         ar_s<<"縌縍縎縏縐縑縒縓縔縕縖縗縘縙縚縛縜縝縞縟"
         ar_s<<"縠縡縢縣縤縥縦縧縨縩縪縫縬縭縮縯縰縱縲縳"
         ar_s<<"縴縵縶縷縸縹縺縻縼總績縿繀繁繂繃繄繅繆繇"
         ar_s<<"繈繉繊繋繌繍繎繏繐繑繒繓織繕繖繗繘繙繚繛"
         ar_s<<"繜繝繞繟繠繡繢繣繤繥繦繧繨繩繪繫繬繭繮繯"
         ar_s<<"繰繱繲繳繴繵繶繷繸繹繺繻繼繽繾繿纀纁纂纃"
         ar_s<<"纄纅纆纇纈纉纊纋續纍纎纏纐纑纒纓纔纕纖纗"
         ar_s<<"纘纙纚纛纜纝纞纟纠纡红纣纤纥约级纨纩纪纫"
         ar_s<<"纬纭纮纯纰纱纲纳纴纵纶纷纸纹纺纻纼纽纾线"
         ar_s<<"绀绁绂练组绅细织终绉绊绋绌绍绎经绐绑绒结"
         ar_s<<"绔绕绖绗绘给绚绛络绝绞统绠绡绢绣绤绥绦继"
         ar_s<<"绨绩绪绫绬续绮绯绰绱绲绳维绵绶绷绸绹绺绻"
         ar_s<<"综绽绾绿缀缁缂缃缄缅缆缇缈缉缊缋缌缍缎缏"
         ar_s<<"缐缑缒缓缔缕编缗缘缙缚缛缜缝缞缟缠缡缢缣"
         ar_s<<"缤缥缦缧缨缩缪缫缬缭缮缯缰缱缲缳缴缵缶缷"
         ar_s<<"缸缹缺缻缼缽缾缿罀罁罂罃罄罅罆罇罈罉罊罋"
         ar_s<<"罌罍罎罏罐网罒罓罔罕罖罗罘罙罚罛罜罝罞罟"
         ar_s<<"罠罡罢罣罤罥罦罧罨罩罪罫罬罭置罯罰罱署罳"
         ar_s<<"罴罵罶罷罸罹罺罻罼罽罾罿羀羁羂羃羄羅羆羇"
         ar_s<<"羈羉羊羋羌羍美羏羐羑羒羓羔羕羖羗羘羙羚羛"
         ar_s<<"羜羝羞羟羠羡羢羣群羥羦羧羨義羪羫羬羭羮羯"
         ar_s<<"羰羱羲羳羴羵羶羷羸羹羺羻羼羽羾羿翀翁翂翃"
         ar_s<<"翄翅翆翇翈翉翊翋翌翍翎翏翐翑習翓翔翕翖翗"
         ar_s<<"翘翙翚翛翜翝翞翟翠翡翢翣翤翥翦翧翨翩翪翫"
         ar_s<<"翬翭翮翯翰翱翲翳翴翵翶翷翸翹翺翻翼翽翾翿"
         ar_s<<"耀老耂考耄者耆耇耈耉耊耋而耍耎耏耐耑耒耓"
         ar_s<<"耔耕耖耗耘耙耚耛耜耝耞耟耠耡耢耣耤耥耦耧"
         ar_s<<"耨耩耪耫耬耭耮耯耰耱耲耳耴耵耶耷耸耹耺耻"
         ar_s<<"耼耽耾耿聀聁聂聃聄聅聆聇聈聉聊聋职聍聎聏"
         ar_s<<"聐聑聒聓联聕聖聗聘聙聚聛聜聝聞聟聠聡聢聣"
         ar_s<<"聤聥聦聧聨聩聪聫聬聭聮聯聰聱聲聳聴聵聶職"
         ar_s<<"聸聹聺聻聼聽聾聿肀肁肂肃肄肅肆肇肈肉肊肋"
         ar_s<<"肌肍肎肏肐肑肒肓肔肕肖肗肘肙肚肛肜肝肞肟"
         ar_s<<"肠股肢肣肤肥肦肧肨肩肪肫肬肭肮肯肰肱育肳"
         ar_s<<"肴肵肶肷肸肹肺肻肼肽肾肿胀胁胂胃胄胅胆胇"
         ar_s<<"胈胉胊胋背胍胎胏胐胑胒胓胔胕胖胗胘胙胚胛"
         ar_s<<"胜胝胞胟胠胡胢胣胤胥胦胧胨胩胪胫胬胭胮胯"
         ar_s<<"胰胱胲胳胴胵胶胷胸胹胺胻胼能胾胿脀脁脂脃"
         ar_s<<"脄脅脆脇脈脉脊脋脌脍脎脏脐脑脒脓脔脕脖脗"
         ar_s<<"脘脙脚脛脜脝脞脟脠脡脢脣脤脥脦脧脨脩脪脫"
         ar_s<<"脬脭脮脯脰脱脲脳脴脵脶脷脸脹脺脻脼脽脾脿"
         ar_s<<"腀腁腂腃腄腅腆腇腈腉腊腋腌腍腎腏腐腑腒腓"
         ar_s<<"腔腕腖腗腘腙腚腛腜腝腞腟腠腡腢腣腤腥腦腧"
         ar_s<<"腨腩腪腫腬腭腮腯腰腱腲腳腴腵腶腷腸腹腺腻"
         ar_s<<"腼腽腾腿膀膁膂膃膄膅膆膇膈膉膊膋膌膍膎膏"
         ar_s<<"膐膑膒膓膔膕膖膗膘膙膚膛膜膝膞膟膠膡膢膣"
         ar_s<<"膤膥膦膧膨膩膪膫膬膭膮膯膰膱膲膳膴膵膶膷"
         ar_s<<"膸膹膺膻膼膽膾膿臀臁臂臃臄臅臆臇臈臉臊臋"
         ar_s<<"臌臍臎臏臐臑臒臓臔臕臖臗臘臙臚臛臜臝臞臟"
         ar_s<<"臠臡臢臣臤臥臦臧臨臩自臫臬臭臮臯臰臱臲至"
         ar_s<<"致臵臶臷臸臹臺臻臼臽臾臿舀舁舂舃舄舅舆與"
         ar_s<<"興舉舊舋舌舍舎舏舐舑舒舓舔舕舖舗舘舙舚舛"
         ar_s<<"舜舝舞舟舠舡舢舣舤舥舦舧舨舩航舫般舭舮舯"
         ar_s<<"舰舱舲舳舴舵舶舷舸船舺舻舼舽舾舿艀艁艂艃"
         ar_s<<"艄艅艆艇艈艉艊艋艌艍艎艏艐艑艒艓艔艕艖艗"
         ar_s<<"艘艙艚艛艜艝艞艟艠艡艢艣艤艥艦艧艨艩艪艫"
         ar_s<<"艬艭艮良艰艱色艳艴艵艶艷艸艹艺艻艼艽艾艿"
         ar_s<<"芀芁节芃芄芅芆芇芈芉芊芋芌芍芎芏芐芑芒芓"
         ar_s<<"芔芕芖芗芘芙芚芛芜芝芞芟芠芡芢芣芤芥芦芧"
         ar_s<<"芨芩芪芫芬芭芮芯芰花芲芳芴芵芶芷芸芹芺芻"
         ar_s<<"芼芽芾芿苀苁苂苃苄苅苆苇苈苉苊苋苌苍苎苏"
         ar_s<<"苐苑苒苓苔苕苖苗苘苙苚苛苜苝苞苟苠苡苢苣"
         ar_s<<"苤若苦苧苨苩苪苫苬苭苮苯苰英苲苳苴苵苶苷"
         ar_s<<"苸苹苺苻苼苽苾苿茀茁茂范茄茅茆茇茈茉茊茋"
         ar_s<<"茌茍茎茏茐茑茒茓茔茕茖茗茘茙茚茛茜茝茞茟"
         ar_s<<"茠茡茢茣茤茥茦茧茨茩茪茫茬茭茮茯茰茱茲茳"
         ar_s<<"茴茵茶茷茸茹茺茻茼茽茾茿荀荁荂荃荄荅荆荇"
         ar_s<<"荈草荊荋荌荍荎荏荐荑荒荓荔荕荖荗荘荙荚荛"
         ar_s<<"荜荝荞荟荠荡荢荣荤荥荦荧荨荩荪荫荬荭荮药"
         ar_s<<"荰荱荲荳荴荵荶荷荸荹荺荻荼荽荾荿莀莁莂莃"
         ar_s<<"莄莅莆莇莈莉莊莋莌莍莎莏莐莑莒莓莔莕莖莗"
         ar_s<<"莘莙莚莛莜莝莞莟莠莡莢莣莤莥莦莧莨莩莪莫"
         ar_s<<"莬莭莮莯莰莱莲莳莴莵莶获莸莹莺莻莼莽莾莿"
         ar_s<<"菀菁菂菃菄菅菆菇菈菉菊菋菌菍菎菏菐菑菒菓"
         ar_s<<"菔菕菖菗菘菙菚菛菜菝菞菟菠菡菢菣菤菥菦菧"
         ar_s<<"菨菩菪菫菬菭菮華菰菱菲菳菴菵菶菷菸菹菺菻"
         ar_s<<"菼菽菾菿萀萁萂萃萄萅萆萇萈萉萊萋萌萍萎萏"
         ar_s<<"萐萑萒萓萔萕萖萗萘萙萚萛萜萝萞萟萠萡萢萣"
         ar_s<<"萤营萦萧萨萩萪萫萬萭萮萯萰萱萲萳萴萵萶萷"
         ar_s<<"萸萹萺萻萼落萾萿葀葁葂葃葄葅葆葇葈葉葊葋"
         ar_s<<"葌葍葎葏葐葑葒葓葔葕葖著葘葙葚葛葜葝葞葟"
         ar_s<<"葠葡葢董葤葥葦葧葨葩葪葫葬葭葮葯葰葱葲葳"
         ar_s<<"葴葵葶葷葸葹葺葻葼葽葾葿蒀蒁蒂蒃蒄蒅蒆蒇"
         ar_s<<"蒈蒉蒊蒋蒌蒍蒎蒏蒐蒑蒒蒓蒔蒕蒖蒗蒘蒙蒚蒛"
         ar_s<<"蒜蒝蒞蒟蒠蒡蒢蒣蒤蒥蒦蒧蒨蒩蒪蒫蒬蒭蒮蒯"
         ar_s<<"蒰蒱蒲蒳蒴蒵蒶蒷蒸蒹蒺蒻蒼蒽蒾蒿蓀蓁蓂蓃"
         ar_s<<"蓄蓅蓆蓇蓈蓉蓊蓋蓌蓍蓎蓏蓐蓑蓒蓓蓔蓕蓖蓗"
         ar_s<<"蓘蓙蓚蓛蓜蓝蓞蓟蓠蓡蓢蓣蓤蓥蓦蓧蓨蓩蓪蓫"
         ar_s<<"蓬蓭蓮蓯蓰蓱蓲蓳蓴蓵蓶蓷蓸蓹蓺蓻蓼蓽蓾蓿"
         ar_s<<"蔀蔁蔂蔃蔄蔅蔆蔇蔈蔉蔊蔋蔌蔍蔎蔏蔐蔑蔒蔓"
         ar_s<<"蔔蔕蔖蔗蔘蔙蔚蔛蔜蔝蔞蔟蔠蔡蔢蔣蔤蔥蔦蔧"
         ar_s<<"蔨蔩蔪蔫蔬蔭蔮蔯蔰蔱蔲蔳蔴蔵蔶蔷蔸蔹蔺蔻"
         ar_s<<"蔼蔽蔾蔿蕀蕁蕂蕃蕄蕅蕆蕇蕈蕉蕊蕋蕌蕍蕎蕏"
         ar_s<<"蕐蕑蕒蕓蕔蕕蕖蕗蕘蕙蕚蕛蕜蕝蕞蕟蕠蕡蕢蕣"
         ar_s<<"蕤蕥蕦蕧蕨蕩蕪蕫蕬蕭蕮蕯蕰蕱蕲蕳蕴蕵蕶蕷"
         ar_s<<"蕸蕹蕺蕻蕼蕽蕾蕿薀薁薂薃薄薅薆薇薈薉薊薋"
         ar_s<<"薌薍薎薏薐薑薒薓薔薕薖薗薘薙薚薛薜薝薞薟"
         ar_s<<"薠薡薢薣薤薥薦薧薨薩薪薫薬薭薮薯薰薱薲薳"
         ar_s<<"薴薵薶薷薸薹薺薻薼薽薾薿藀藁藂藃藄藅藆藇"
         ar_s<<"藈藉藊藋藌藍藎藏藐藑藒藓藔藕藖藗藘藙藚藛"
         ar_s<<"藜藝藞藟藠藡藢藣藤藥藦藧藨藩藪藫藬藭藮藯"
         ar_s<<"藰藱藲藳藴藵藶藷藸藹藺藻藼藽藾藿蘀蘁蘂蘃"
         ar_s<<"蘄蘅蘆蘇蘈蘉蘊蘋蘌蘍蘎蘏蘐蘑蘒蘓蘔蘕蘖蘗"
         ar_s<<"蘘蘙蘚蘛蘜蘝蘞蘟蘠蘡蘢蘣蘤蘥蘦蘧蘨蘩蘪蘫"
         ar_s<<"蘬蘭蘮蘯蘰蘱蘲蘳蘴蘵蘶蘷蘸蘹蘺蘻蘼蘽蘾蘿"
         ar_s<<"虀虁虂虃虄虅虆虇虈虉虊虋虌虍虎虏虐虑虒虓"
         ar_s<<"虔處虖虗虘虙虚虛虜虝虞號虠虡虢虣虤虥虦虧"
         ar_s<<"虨虩虪虫虬虭虮虯虰虱虲虳虴虵虶虷虸虹虺虻"
         ar_s<<"虼虽虾虿蚀蚁蚂蚃蚄蚅蚆蚇蚈蚉蚊蚋蚌蚍蚎蚏"
         ar_s<<"蚐蚑蚒蚓蚔蚕蚖蚗蚘蚙蚚蚛蚜蚝蚞蚟蚠蚡蚢蚣"
         ar_s<<"蚤蚥蚦蚧蚨蚩蚪蚫蚬蚭蚮蚯蚰蚱蚲蚳蚴蚵蚶蚷"
         ar_s<<"蚸蚹蚺蚻蚼蚽蚾蚿蛀蛁蛂蛃蛄蛅蛆蛇蛈蛉蛊蛋"
         ar_s<<"蛌蛍蛎蛏蛐蛑蛒蛓蛔蛕蛖蛗蛘蛙蛚蛛蛜蛝蛞蛟"
         ar_s<<"蛠蛡蛢蛣蛤蛥蛦蛧蛨蛩蛪蛫蛬蛭蛮蛯蛰蛱蛲蛳"
         ar_s<<"蛴蛵蛶蛷蛸蛹蛺蛻蛼蛽蛾蛿蜀蜁蜂蜃蜄蜅蜆蜇"
         ar_s<<"蜈蜉蜊蜋蜌蜍蜎蜏蜐蜑蜒蜓蜔蜕蜖蜗蜘蜙蜚蜛"
         ar_s<<"蜜蜝蜞蜟蜠蜡蜢蜣蜤蜥蜦蜧蜨蜩蜪蜫蜬蜭蜮蜯"
         ar_s<<"蜰蜱蜲蜳蜴蜵蜶蜷蜸蜹蜺蜻蜼蜽蜾蜿蝀蝁蝂蝃"
         ar_s<<"蝄蝅蝆蝇蝈蝉蝊蝋蝌蝍蝎蝏蝐蝑蝒蝓蝔蝕蝖蝗"
         ar_s<<"蝘蝙蝚蝛蝜蝝蝞蝟蝠蝡蝢蝣蝤蝥蝦蝧蝨蝩蝪蝫"
         ar_s<<"蝬蝭蝮蝯蝰蝱蝲蝳蝴蝵蝶蝷蝸蝹蝺蝻蝼蝽蝾蝿"
         ar_s<<"螀螁螂螃螄螅螆螇螈螉螊螋螌融螎螏螐螑螒螓"
         ar_s<<"螔螕螖螗螘螙螚螛螜螝螞螟螠螡螢螣螤螥螦螧"
         ar_s<<"螨螩螪螫螬螭螮螯螰螱螲螳螴螵螶螷螸螹螺螻"
         ar_s<<"螼螽螾螿蟀蟁蟂蟃蟄蟅蟆蟇蟈蟉蟊蟋蟌蟍蟎蟏"
         ar_s<<"蟐蟑蟒蟓蟔蟕蟖蟗蟘蟙蟚蟛蟜蟝蟞蟟蟠蟡蟢蟣"
         ar_s<<"蟤蟥蟦蟧蟨蟩蟪蟫蟬蟭蟮蟯蟰蟱蟲蟳蟴蟵蟶蟷"
         ar_s<<"蟸蟹蟺蟻蟼蟽蟾蟿蠀蠁蠂蠃蠄蠅蠆蠇蠈蠉蠊蠋"
         ar_s<<"蠌蠍蠎蠏蠐蠑蠒蠓蠔蠕蠖蠗蠘蠙蠚蠛蠜蠝蠞蠟"
         ar_s<<"蠠蠡蠢蠣蠤蠥蠦蠧蠨蠩蠪蠫蠬蠭蠮蠯蠰蠱蠲蠳"
         ar_s<<"蠴蠵蠶蠷蠸蠹蠺蠻蠼蠽蠾蠿血衁衂衃衄衅衆衇"
         ar_s<<"衈衉衊衋行衍衎衏衐衑衒術衔衕衖街衘衙衚衛"
         ar_s<<"衜衝衞衟衠衡衢衣衤补衦衧表衩衪衫衬衭衮衯"
         ar_s<<"衰衱衲衳衴衵衶衷衸衹衺衻衼衽衾衿袀袁袂袃"
         ar_s<<"袄袅袆袇袈袉袊袋袌袍袎袏袐袑袒袓袔袕袖袗"
         ar_s<<"袘袙袚袛袜袝袞袟袠袡袢袣袤袥袦袧袨袩袪被"
         ar_s<<"袬袭袮袯袰袱袲袳袴袵袶袷袸袹袺袻袼袽袾袿"
         ar_s<<"裀裁裂裃裄装裆裇裈裉裊裋裌裍裎裏裐裑裒裓"
         ar_s<<"裔裕裖裗裘裙裚裛補裝裞裟裠裡裢裣裤裥裦裧"
         ar_s<<"裨裩裪裫裬裭裮裯裰裱裲裳裴裵裶裷裸裹裺裻"
         ar_s<<"裼製裾裿褀褁褂褃褄褅褆複褈褉褊褋褌褍褎褏"
         ar_s<<"褐褑褒褓褔褕褖褗褘褙褚褛褜褝褞褟褠褡褢褣"
         ar_s<<"褤褥褦褧褨褩褪褫褬褭褮褯褰褱褲褳褴褵褶褷"
         ar_s<<"褸褹褺褻褼褽褾褿襀襁襂襃襄襅襆襇襈襉襊襋"
         ar_s<<"襌襍襎襏襐襑襒襓襔襕襖襗襘襙襚襛襜襝襞襟"
         ar_s<<"襠襡襢襣襤襥襦襧襨襩襪襫襬襭襮襯襰襱襲襳"
         ar_s<<"襴襵襶襷襸襹襺襻襼襽襾西覀要覂覃覄覅覆覇"
         ar_s<<"覈覉覊見覌覍覎規覐覑覒覓覔覕視覗覘覙覚覛"
         ar_s<<"覜覝覞覟覠覡覢覣覤覥覦覧覨覩親覫覬覭覮覯"
         ar_s<<"覰覱覲観覴覵覶覷覸覹覺覻覼覽覾覿觀见观觃"
         ar_s<<"规觅视觇览觉觊觋觌觍觎觏觐觑角觓觔觕觖觗"
         ar_s<<"觘觙觚觛觜觝觞觟觠觡觢解觤觥触觧觨觩觪觫"
         ar_s<<"觬觭觮觯觰觱觲觳觴觵觶觷觸觹觺觻觼觽觾觿"
         ar_s<<"言訁訂訃訄訅訆訇計訉訊訋訌訍討訏訐訑訒訓"
         ar_s<<"訔訕訖託記訙訚訛訜訝訞訟訠訡訢訣訤訥訦訧"
         ar_s<<"訨訩訪訫訬設訮訯訰許訲訳訴訵訶訷訸訹診註"
         ar_s<<"証訽訾訿詀詁詂詃詄詅詆詇詈詉詊詋詌詍詎詏"
         ar_s<<"詐詑詒詓詔評詖詗詘詙詚詛詜詝詞詟詠詡詢詣"
         ar_s<<"詤詥試詧詨詩詪詫詬詭詮詯詰話該詳詴詵詶詷"
         ar_s<<"詸詹詺詻詼詽詾詿誀誁誂誃誄誅誆誇誈誉誊誋"
         ar_s<<"誌認誎誏誐誑誒誓誔誕誖誗誘誙誚誛誜誝語誟"
         ar_s<<"誠誡誢誣誤誥誦誧誨誩說誫説読誮誯誰誱課誳"
         ar_s<<"誴誵誶誷誸誹誺誻誼誽誾調諀諁諂諃諄諅諆談"
         ar_s<<"諈諉諊請諌諍諎諏諐諑諒諓諔諕論諗諘諙諚諛"
         ar_s<<"諜諝諞諟諠諡諢諣諤諥諦諧諨諩諪諫諬諭諮諯"
         ar_s<<"諰諱諲諳諴諵諶諷諸諹諺諻諼諽諾諿謀謁謂謃"
         ar_s<<"謄謅謆謇謈謉謊謋謌謍謎謏謐謑謒謓謔謕謖謗"
         ar_s<<"謘謙謚講謜謝謞謟謠謡謢謣謤謥謦謧謨謩謪謫"
         ar_s<<"謬謭謮謯謰謱謲謳謴謵謶謷謸謹謺謻謼謽謾謿"
         ar_s<<"譀譁譂譃譄譅譆譇譈證譊譋譌譍譎譏譐譑譒譓"
         ar_s<<"譔譕譖譗識譙譚譛譜譝譞譟譠譡譢譣譤譥警譧"
         ar_s<<"譨譩譪譫譬譭譮譯議譱譲譳譴譵譶護譸譹譺譻"
         ar_s<<"譼譽譾譿讀讁讂讃讄讅讆讇讈讉變讋讌讍讎讏"
         ar_s<<"讐讑讒讓讔讕讖讗讘讙讚讛讜讝讞讟讠计订讣"
         ar_s<<"认讥讦讧讨让讪讫讬训议讯记讱讲讳讴讵讶讷"
         ar_s<<"许讹论讻讼讽设访诀证诂诃评诅识诇诈诉诊诋"
         ar_s<<"诌词诎诏诐译诒诓诔试诖诗诘诙诚诛诜话诞诟"
         ar_s<<"诠诡询诣诤该详诧诨诩诪诫诬语诮误诰诱诲诳"
         ar_s<<"说诵诶请诸诹诺读诼诽课诿谀谁谂调谄谅谆谇"
         ar_s<<"谈谉谊谋谌谍谎谏谐谑谒谓谔谕谖谗谘谙谚谛"
         ar_s<<"谜谝谞谟谠谡谢谣谤谥谦谧谨谩谪谫谬谭谮谯"
         ar_s<<"谰谱谲谳谴谵谶谷谸谹谺谻谼谽谾谿豀豁豂豃"
         ar_s<<"豄豅豆豇豈豉豊豋豌豍豎豏豐豑豒豓豔豕豖豗"
         ar_s<<"豘豙豚豛豜豝豞豟豠象豢豣豤豥豦豧豨豩豪豫"
         ar_s<<"豬豭豮豯豰豱豲豳豴豵豶豷豸豹豺豻豼豽豾豿"
         ar_s<<"貀貁貂貃貄貅貆貇貈貉貊貋貌貍貎貏貐貑貒貓"
         ar_s<<"貔貕貖貗貘貙貚貛貜貝貞貟負財貢貣貤貥貦貧"
         ar_s<<"貨販貪貫責貭貮貯貰貱貲貳貴貵貶買貸貹貺費"
         ar_s<<"貼貽貾貿賀賁賂賃賄賅賆資賈賉賊賋賌賍賎賏"
         ar_s<<"賐賑賒賓賔賕賖賗賘賙賚賛賜賝賞賟賠賡賢賣"
         ar_s<<"賤賥賦賧賨賩質賫賬賭賮賯賰賱賲賳賴賵賶賷"
         ar_s<<"賸賹賺賻購賽賾賿贀贁贂贃贄贅贆贇贈贉贊贋"
         ar_s<<"贌贍贎贏贐贑贒贓贔贕贖贗贘贙贚贛贜贝贞负"
         ar_s<<"贠贡财责贤败账货质贩贪贫贬购贮贯贰贱贲贳"
         ar_s<<"贴贵贶贷贸费贺贻贼贽贾贿赀赁赂赃资赅赆赇"
         ar_s<<"赈赉赊赋赌赍赎赏赐赑赒赓赔赕赖赗赘赙赚赛"
         ar_s<<"赜赝赞赟赠赡赢赣赤赥赦赧赨赩赪赫赬赭赮赯"
         ar_s<<"走赱赲赳赴赵赶起赸赹赺赻赼赽赾赿趀趁趂趃"
         ar_s<<"趄超趆趇趈趉越趋趌趍趎趏趐趑趒趓趔趕趖趗"
         ar_s<<"趘趙趚趛趜趝趞趟趠趡趢趣趤趥趦趧趨趩趪趫"
         ar_s<<"趬趭趮趯趰趱趲足趴趵趶趷趸趹趺趻趼趽趾趿"
         ar_s<<"跀跁跂跃跄跅跆跇跈跉跊跋跌跍跎跏跐跑跒跓"
         ar_s<<"跔跕跖跗跘跙跚跛跜距跞跟跠跡跢跣跤跥跦跧"
         ar_s<<"跨跩跪跫跬跭跮路跰跱跲跳跴践跶跷跸跹跺跻"
         ar_s<<"跼跽跾跿踀踁踂踃踄踅踆踇踈踉踊踋踌踍踎踏"
         ar_s<<"踐踑踒踓踔踕踖踗踘踙踚踛踜踝踞踟踠踡踢踣"
         ar_s<<"踤踥踦踧踨踩踪踫踬踭踮踯踰踱踲踳踴踵踶踷"
         ar_s<<"踸踹踺踻踼踽踾踿蹀蹁蹂蹃蹄蹅蹆蹇蹈蹉蹊蹋"
         ar_s<<"蹌蹍蹎蹏蹐蹑蹒蹓蹔蹕蹖蹗蹘蹙蹚蹛蹜蹝蹞蹟"
         ar_s<<"蹠蹡蹢蹣蹤蹥蹦蹧蹨蹩蹪蹫蹬蹭蹮蹯蹰蹱蹲蹳"
         ar_s<<"蹴蹵蹶蹷蹸蹹蹺蹻蹼蹽蹾蹿躀躁躂躃躄躅躆躇"
         ar_s<<"躈躉躊躋躌躍躎躏躐躑躒躓躔躕躖躗躘躙躚躛"
         ar_s<<"躜躝躞躟躠躡躢躣躤躥躦躧躨躩躪身躬躭躮躯"
         ar_s<<"躰躱躲躳躴躵躶躷躸躹躺躻躼躽躾躿軀軁軂軃"
         ar_s<<"軄軅軆軇軈軉車軋軌軍軎軏軐軑軒軓軔軕軖軗"
         ar_s<<"軘軙軚軛軜軝軞軟軠軡転軣軤軥軦軧軨軩軪軫"
         ar_s<<"軬軭軮軯軰軱軲軳軴軵軶軷軸軹軺軻軼軽軾軿"
         ar_s<<"輀輁輂較輄輅輆輇輈載輊輋輌輍輎輏輐輑輒輓"
         ar_s<<"輔輕輖輗輘輙輚輛輜輝輞輟輠輡輢輣輤輥輦輧"
         ar_s<<"輨輩輪輫輬輭輮輯輰輱輲輳輴輵輶輷輸輹輺輻"
         ar_s<<"輼輽輾輿轀轁轂轃轄轅轆轇轈轉轊轋轌轍轎轏"
         ar_s<<"轐轑轒轓轔轕轖轗轘轙轚轛轜轝轞轟轠轡轢轣"
         ar_s<<"轤轥车轧轨轩轪轫转轭轮软轰轱轲轳轴轵轶轷"
         ar_s<<"轸轹轺轻轼载轾轿辀辁辂较辄辅辆辇辈辉辊辋"
         ar_s<<"辌辍辎辏辐辑辒输辔辕辖辗辘辙辚辛辜辝辞辟"
         ar_s<<"辠辡辢辣辤辥辦辧辨辩辪辫辬辭辮辯辰辱農辳"
         ar_s<<"辴辵辶辷辸边辺辻込辽达辿迀迁迂迃迄迅迆过"
         ar_s<<"迈迉迊迋迌迍迎迏运近迒迓返迕迖迗还这迚进"
         ar_s<<"远违连迟迠迡迢迣迤迥迦迧迨迩迪迫迬迭迮迯"
         ar_s<<"述迱迲迳迴迵迶迷迸迹迺迻迼追迾迿退送适逃"
         ar_s<<"逄逅逆逇逈选逊逋逌逍逎透逐逑递逓途逕逖逗"
         ar_s<<"逘這通逛逜逝逞速造逡逢連逤逥逦逧逨逩逪逫"
         ar_s<<"逬逭逮逯逰週進逳逴逵逶逷逸逹逺逻逼逽逾逿"
         ar_s<<"遀遁遂遃遄遅遆遇遈遉遊運遌遍過遏遐遑遒道"
         ar_s<<"達違遖遗遘遙遚遛遜遝遞遟遠遡遢遣遤遥遦遧"
         ar_s<<"遨適遪遫遬遭遮遯遰遱遲遳遴遵遶遷選遹遺遻"
         ar_s<<"遼遽遾避邀邁邂邃還邅邆邇邈邉邊邋邌邍邎邏"
         ar_s<<"邐邑邒邓邔邕邖邗邘邙邚邛邜邝邞邟邠邡邢那"
         ar_s<<"邤邥邦邧邨邩邪邫邬邭邮邯邰邱邲邳邴邵邶邷"
         ar_s<<"邸邹邺邻邼邽邾邿郀郁郂郃郄郅郆郇郈郉郊郋"
         ar_s<<"郌郍郎郏郐郑郒郓郔郕郖郗郘郙郚郛郜郝郞郟"
         ar_s<<"郠郡郢郣郤郥郦郧部郩郪郫郬郭郮郯郰郱郲郳"
         ar_s<<"郴郵郶郷郸郹郺郻郼都郾郿鄀鄁鄂鄃鄄鄅鄆鄇"
         ar_s<<"鄈鄉鄊鄋鄌鄍鄎鄏鄐鄑鄒鄓鄔鄕鄖鄗鄘鄙鄚鄛"
         ar_s<<"鄜鄝鄞鄟鄠鄡鄢鄣鄤鄥鄦鄧鄨鄩鄪鄫鄬鄭鄮鄯"
         ar_s<<"鄰鄱鄲鄳鄴鄵鄶鄷鄸鄹鄺鄻鄼鄽鄾鄿酀酁酂酃"
         ar_s<<"酄酅酆酇酈酉酊酋酌配酎酏酐酑酒酓酔酕酖酗"
         ar_s<<"酘酙酚酛酜酝酞酟酠酡酢酣酤酥酦酧酨酩酪酫"
         ar_s<<"酬酭酮酯酰酱酲酳酴酵酶酷酸酹酺酻酼酽酾酿"
         ar_s<<"醀醁醂醃醄醅醆醇醈醉醊醋醌醍醎醏醐醑醒醓"
         ar_s<<"醔醕醖醗醘醙醚醛醜醝醞醟醠醡醢醣醤醥醦醧"
         ar_s<<"醨醩醪醫醬醭醮醯醰醱醲醳醴醵醶醷醸醹醺醻"
         ar_s<<"醼醽醾醿釀釁釂釃釄釅釆采釈釉释釋里重野量"
         ar_s<<"釐金釒釓釔釕釖釗釘釙釚釛釜針釞釟釠釡釢釣"
         ar_s<<"釤釥釦釧釨釩釪釫釬釭釮釯釰釱釲釳釴釵釶釷"
         ar_s<<"釸釹釺釻釼釽釾釿鈀鈁鈂鈃鈄鈅鈆鈇鈈鈉鈊鈋"
         ar_s<<"鈌鈍鈎鈏鈐鈑鈒鈓鈔鈕鈖鈗鈘鈙鈚鈛鈜鈝鈞鈟"
         ar_s<<"鈠鈡鈢鈣鈤鈥鈦鈧鈨鈩鈪鈫鈬鈭鈮鈯鈰鈱鈲鈳"
         ar_s<<"鈴鈵鈶鈷鈸鈹鈺鈻鈼鈽鈾鈿鉀鉁鉂鉃鉄鉅鉆鉇"
         ar_s<<"鉈鉉鉊鉋鉌鉍鉎鉏鉐鉑鉒鉓鉔鉕鉖鉗鉘鉙鉚鉛"
         ar_s<<"鉜鉝鉞鉟鉠鉡鉢鉣鉤鉥鉦鉧鉨鉩鉪鉫鉬鉭鉮鉯"
         ar_s<<"鉰鉱鉲鉳鉴鉵鉶鉷鉸鉹鉺鉻鉼鉽鉾鉿銀銁銂銃"
         ar_s<<"銄銅銆銇銈銉銊銋銌銍銎銏銐銑銒銓銔銕銖銗"
         ar_s<<"銘銙銚銛銜銝銞銟銠銡銢銣銤銥銦銧銨銩銪銫"
         ar_s<<"銬銭銮銯銰銱銲銳銴銵銶銷銸銹銺銻銼銽銾銿"
         ar_s<<"鋀鋁鋂鋃鋄鋅鋆鋇鋈鋉鋊鋋鋌鋍鋎鋏鋐鋑鋒鋓"
         ar_s<<"鋔鋕鋖鋗鋘鋙鋚鋛鋜鋝鋞鋟鋠鋡鋢鋣鋤鋥鋦鋧"
         ar_s<<"鋨鋩鋪鋫鋬鋭鋮鋯鋰鋱鋲鋳鋴鋵鋶鋷鋸鋹鋺鋻"
         ar_s<<"鋼鋽鋾鋿錀錁錂錃錄錅錆錇錈錉錊錋錌錍錎錏"
         ar_s<<"錐錑錒錓錔錕錖錗錘錙錚錛錜錝錞錟錠錡錢錣"
         ar_s<<"錤錥錦錧錨錩錪錫錬錭錮錯錰錱録錳錴錵錶錷"
         ar_s<<"錸錹錺錻錼錽錾錿鍀鍁鍂鍃鍄鍅鍆鍇鍈鍉鍊鍋"
         ar_s<<"鍌鍍鍎鍏鍐鍑鍒鍓鍔鍕鍖鍗鍘鍙鍚鍛鍜鍝鍞鍟"
         ar_s<<"鍠鍡鍢鍣鍤鍥鍦鍧鍨鍩鍪鍫鍬鍭鍮鍯鍰鍱鍲鍳"
         ar_s<<"鍴鍵鍶鍷鍸鍹鍺鍻鍼鍽鍾鍿鎀鎁鎂鎃鎄鎅鎆鎇"
         ar_s<<"鎈鎉鎊鎋鎌鎍鎎鎏鎐鎑鎒鎓鎔鎕鎖鎗鎘鎙鎚鎛"
         ar_s<<"鎜鎝鎞鎟鎠鎡鎢鎣鎤鎥鎦鎧鎨鎩鎪鎫鎬鎭鎮鎯"
         ar_s<<"鎰鎱鎲鎳鎴鎵鎶鎷鎸鎹鎺鎻鎼鎽鎾鎿鏀鏁鏂鏃"
         ar_s<<"鏄鏅鏆鏇鏈鏉鏊鏋鏌鏍鏎鏏鏐鏑鏒鏓鏔鏕鏖鏗"
         ar_s<<"鏘鏙鏚鏛鏜鏝鏞鏟鏠鏡鏢鏣鏤鏥鏦鏧鏨鏩鏪鏫"
         ar_s<<"鏬鏭鏮鏯鏰鏱鏲鏳鏴鏵鏶鏷鏸鏹鏺鏻鏼鏽鏾鏿"
         ar_s<<"鐀鐁鐂鐃鐄鐅鐆鐇鐈鐉鐊鐋鐌鐍鐎鐏鐐鐑鐒鐓"
         ar_s<<"鐔鐕鐖鐗鐘鐙鐚鐛鐜鐝鐞鐟鐠鐡鐢鐣鐤鐥鐦鐧"
         ar_s<<"鐨鐩鐪鐫鐬鐭鐮鐯鐰鐱鐲鐳鐴鐵鐶鐷鐸鐹鐺鐻"
         ar_s<<"鐼鐽鐾鐿鑀鑁鑂鑃鑄鑅鑆鑇鑈鑉鑊鑋鑌鑍鑎鑏"
         ar_s<<"鑐鑑鑒鑓鑔鑕鑖鑗鑘鑙鑚鑛鑜鑝鑞鑟鑠鑡鑢鑣"
         ar_s<<"鑤鑥鑦鑧鑨鑩鑪鑫鑬鑭鑮鑯鑰鑱鑲鑳鑴鑵鑶鑷"
         ar_s<<"鑸鑹鑺鑻鑼鑽鑾鑿钀钁钂钃钄钅钆钇针钉钊钋"
         ar_s<<"钌钍钎钏钐钑钒钓钔钕钖钗钘钙钚钛钜钝钞钟"
         ar_s<<"钠钡钢钣钤钥钦钧钨钩钪钫钬钭钮钯钰钱钲钳"
         ar_s<<"钴钵钶钷钸钹钺钻钼钽钾钿铀铁铂铃铄铅铆铇"
         ar_s<<"铈铉铊铋铌铍铎铏铐铑铒铓铔铕铖铗铘铙铚铛"
         ar_s<<"铜铝铞铟铠铡铢铣铤铥铦铧铨铩铪铫铬铭铮铯"
         ar_s<<"铰铱铲铳铴铵银铷铸铹铺铻铼铽链铿销锁锂锃"
         ar_s<<"锄锅锆锇锈锉锊锋锌锍锎锏锐锑锒锓锔锕锖锗"
         ar_s<<"锘错锚锛锜锝锞锟锠锡锢锣锤锥锦锧锨锩锪锫"
         ar_s<<"锬锭键锯锰锱锲锳锴锵锶锷锸锹锺锻锼锽锾锿"
         ar_s<<"镀镁镂镃镄镅镆镇镈镉镊镋镌镍镎镏镐镑镒镓"
         ar_s<<"镔镕镖镗镘镙镚镛镜镝镞镟镠镡镢镣镤镥镦镧"
         ar_s<<"镨镩镪镫镬镭镮镯镰镱镲镳镴镵镶長镸镹镺镻"
         ar_s<<"镼镽镾长門閁閂閃閄閅閆閇閈閉閊開閌閍閎閏"
         ar_s<<"閐閑閒間閔閕閖閗閘閙閚閛閜閝閞閟閠閡関閣"
         ar_s<<"閤閥閦閧閨閩閪閫閬閭閮閯閰閱閲閳閴閵閶閷"
         ar_s<<"閸閹閺閻閼閽閾閿闀闁闂闃闄闅闆闇闈闉闊闋"
         ar_s<<"闌闍闎闏闐闑闒闓闔闕闖闗闘闙闚闛關闝闞闟"
         ar_s<<"闠闡闢闣闤闥闦闧门闩闪闫闬闭问闯闰闱闲闳"
         ar_s<<"间闵闶闷闸闹闺闻闼闽闾闿阀阁阂阃阄阅阆阇"
         ar_s<<"阈阉阊阋阌阍阎阏阐阑阒阓阔阕阖阗阘阙阚阛"
         ar_s<<"阜阝阞队阠阡阢阣阤阥阦阧阨阩阪阫阬阭阮阯"
         ar_s<<"阰阱防阳阴阵阶阷阸阹阺阻阼阽阾阿陀陁陂陃"
         ar_s<<"附际陆陇陈陉陊陋陌降陎陏限陑陒陓陔陕陖陗"
         ar_s<<"陘陙陚陛陜陝陞陟陠陡院陣除陥陦陧陨险陪陫"
         ar_s<<"陬陭陮陯陰陱陲陳陴陵陶陷陸陹険陻陼陽陾陿"
         ar_s<<"隀隁隂隃隄隅隆隇隈隉隊隋隌隍階随隐隑隒隓"
         ar_s<<"隔隕隖隗隘隙隚際障隝隞隟隠隡隢隣隤隥隦隧"
         ar_s<<"隨隩險隫隬隭隮隯隰隱隲隳隴隵隶隷隸隹隺隻"
         ar_s<<"隼隽难隿雀雁雂雃雄雅集雇雈雉雊雋雌雍雎雏"
         ar_s<<"雐雑雒雓雔雕雖雗雘雙雚雛雜雝雞雟雠雡離難"
         ar_s<<"雤雥雦雧雨雩雪雫雬雭雮雯雰雱雲雳雴雵零雷"
         ar_s<<"雸雹雺電雼雽雾雿需霁霂霃霄霅霆震霈霉霊霋"
         ar_s<<"霌霍霎霏霐霑霒霓霔霕霖霗霘霙霚霛霜霝霞霟"
         ar_s<<"霠霡霢霣霤霥霦霧霨霩霪霫霬霭霮霯霰霱露霳"
         ar_s<<"霴霵霶霷霸霹霺霻霼霽霾霿靀靁靂靃靄靅靆靇"
         ar_s<<"靈靉靊靋靌靍靎靏靐靑青靓靔靕靖靗靘静靚靛"
         ar_s<<"靜靝非靟靠靡面靣靤靥靦靧靨革靪靫靬靭靮靯"
         ar_s<<"靰靱靲靳靴靵靶靷靸靹靺靻靼靽靾靿鞀鞁鞂鞃"
         ar_s<<"鞄鞅鞆鞇鞈鞉鞊鞋鞌鞍鞎鞏鞐鞑鞒鞓鞔鞕鞖鞗"
         ar_s<<"鞘鞙鞚鞛鞜鞝鞞鞟鞠鞡鞢鞣鞤鞥鞦鞧鞨鞩鞪鞫"
         ar_s<<"鞬鞭鞮鞯鞰鞱鞲鞳鞴鞵鞶鞷鞸鞹鞺鞻鞼鞽鞾鞿"
         ar_s<<"韀韁韂韃韄韅韆韇韈韉韊韋韌韍韎韏韐韑韒韓"
         ar_s<<"韔韕韖韗韘韙韚韛韜韝韞韟韠韡韢韣韤韥韦韧"
         ar_s<<"韨韩韪韫韬韭韮韯韰韱韲音韴韵韶韷韸韹韺韻"
         ar_s<<"韼韽韾響頀頁頂頃頄項順頇須頉頊頋頌頍頎頏"
         ar_s<<"預頑頒頓頔頕頖頗領頙頚頛頜頝頞頟頠頡頢頣"
         ar_s<<"頤頥頦頧頨頩頪頫頬頭頮頯頰頱頲頳頴頵頶頷"
         ar_s<<"頸頹頺頻頼頽頾頿顀顁顂顃顄顅顆顇顈顉顊顋"
         ar_s<<"題額顎顏顐顑顒顓顔顕顖顗願顙顚顛顜顝類顟"
         ar_s<<"顠顡顢顣顤顥顦顧顨顩顪顫顬顭顮顯顰顱顲顳"
         ar_s<<"顴页顶顷顸项顺须顼顽顾顿颀颁颂颃预颅领颇"
         ar_s<<"颈颉颊颋颌颍颎颏颐频颒颓颔颕颖颗题颙颚颛"
         ar_s<<"颜额颞颟颠颡颢颣颤颥颦颧風颩颪颫颬颭颮颯"
         ar_s<<"颰颱颲颳颴颵颶颷颸颹颺颻颼颽颾颿飀飁飂飃"
         ar_s<<"飄飅飆飇飈飉飊飋飌飍风飏飐飑飒飓飔飕飖飗"
         ar_s<<"飘飙飚飛飜飝飞食飠飡飢飣飤飥飦飧飨飩飪飫"
         ar_s<<"飬飭飮飯飰飱飲飳飴飵飶飷飸飹飺飻飼飽飾飿"
         ar_s<<"餀餁餂餃餄餅餆餇餈餉養餋餌餍餎餏餐餑餒餓"
         ar_s<<"餔餕餖餗餘餙餚餛餜餝餞餟餠餡餢餣餤餥餦餧"
         ar_s<<"館餩餪餫餬餭餮餯餰餱餲餳餴餵餶餷餸餹餺餻"
         ar_s<<"餼餽餾餿饀饁饂饃饄饅饆饇饈饉饊饋饌饍饎饏"
         ar_s<<"饐饑饒饓饔饕饖饗饘饙饚饛饜饝饞饟饠饡饢饣"
         ar_s<<"饤饥饦饧饨饩饪饫饬饭饮饯饰饱饲饳饴饵饶饷"
         ar_s<<"饸饹饺饻饼饽饾饿馀馁馂馃馄馅馆馇馈馉馊馋"
         ar_s<<"馌馍馎馏馐馑馒馓馔馕首馗馘香馚馛馜馝馞馟"
         ar_s<<"馠馡馢馣馤馥馦馧馨馩馪馫馬馭馮馯馰馱馲馳"
         ar_s<<"馴馵馶馷馸馹馺馻馼馽馾馿駀駁駂駃駄駅駆駇"
         ar_s<<"駈駉駊駋駌駍駎駏駐駑駒駓駔駕駖駗駘駙駚駛"
         ar_s<<"駜駝駞駟駠駡駢駣駤駥駦駧駨駩駪駫駬駭駮駯"
         ar_s<<"駰駱駲駳駴駵駶駷駸駹駺駻駼駽駾駿騀騁騂騃"
         ar_s<<"騄騅騆騇騈騉騊騋騌騍騎騏騐騑騒験騔騕騖騗"
         ar_s<<"騘騙騚騛騜騝騞騟騠騡騢騣騤騥騦騧騨騩騪騫"
         ar_s<<"騬騭騮騯騰騱騲騳騴騵騶騷騸騹騺騻騼騽騾騿"
         ar_s<<"驀驁驂驃驄驅驆驇驈驉驊驋驌驍驎驏驐驑驒驓"
         ar_s<<"驔驕驖驗驘驙驚驛驜驝驞驟驠驡驢驣驤驥驦驧"
         ar_s<<"驨驩驪驫马驭驮驯驰驱驲驳驴驵驶驷驸驹驺驻"
         ar_s<<"驼驽驾驿骀骁骂骃骄骅骆骇骈骉骊骋验骍骎骏"
         ar_s<<"骐骑骒骓骔骕骖骗骘骙骚骛骜骝骞骟骠骡骢骣"
         ar_s<<"骤骥骦骧骨骩骪骫骬骭骮骯骰骱骲骳骴骵骶骷"
         ar_s<<"骸骹骺骻骼骽骾骿髀髁髂髃髄髅髆髇髈髉髊髋"
         ar_s<<"髌髍髎髏髐髑髒髓體髕髖髗高髙髚髛髜髝髞髟"
         ar_s<<"髠髡髢髣髤髥髦髧髨髩髪髫髬髭髮髯髰髱髲髳"
         ar_s<<"髴髵髶髷髸髹髺髻髼髽髾髿鬀鬁鬂鬃鬄鬅鬆鬇"
         ar_s<<"鬈鬉鬊鬋鬌鬍鬎鬏鬐鬑鬒鬓鬔鬕鬖鬗鬘鬙鬚鬛"
         ar_s<<"鬜鬝鬞鬟鬠鬡鬢鬣鬤鬥鬦鬧鬨鬩鬪鬫鬬鬭鬮鬯"
         ar_s<<"鬰鬱鬲鬳鬴鬵鬶鬷鬸鬹鬺鬻鬼鬽鬾鬿魀魁魂魃"
         ar_s<<"魄魅魆魇魈魉魊魋魌魍魎魏魐魑魒魓魔魕魖魗"
         ar_s<<"魘魙魚魛魜魝魞魟魠魡魢魣魤魥魦魧魨魩魪魫"
         ar_s<<"魬魭魮魯魰魱魲魳魴魵魶魷魸魹魺魻魼魽魾魿"
         ar_s<<"鮀鮁鮂鮃鮄鮅鮆鮇鮈鮉鮊鮋鮌鮍鮎鮏鮐鮑鮒鮓"
         ar_s<<"鮔鮕鮖鮗鮘鮙鮚鮛鮜鮝鮞鮟鮠鮡鮢鮣鮤鮥鮦鮧"
         ar_s<<"鮨鮩鮪鮫鮬鮭鮮鮯鮰鮱鮲鮳鮴鮵鮶鮷鮸鮹鮺鮻"
         ar_s<<"鮼鮽鮾鮿鯀鯁鯂鯃鯄鯅鯆鯇鯈鯉鯊鯋鯌鯍鯎鯏"
         ar_s<<"鯐鯑鯒鯓鯔鯕鯖鯗鯘鯙鯚鯛鯜鯝鯞鯟鯠鯡鯢鯣"
         ar_s<<"鯤鯥鯦鯧鯨鯩鯪鯫鯬鯭鯮鯯鯰鯱鯲鯳鯴鯵鯶鯷"
         ar_s<<"鯸鯹鯺鯻鯼鯽鯾鯿鰀鰁鰂鰃鰄鰅鰆鰇鰈鰉鰊鰋"
         ar_s<<"鰌鰍鰎鰏鰐鰑鰒鰓鰔鰕鰖鰗鰘鰙鰚鰛鰜鰝鰞鰟"
         ar_s<<"鰠鰡鰢鰣鰤鰥鰦鰧鰨鰩鰪鰫鰬鰭鰮鰯鰰鰱鰲鰳"
         ar_s<<"鰴鰵鰶鰷鰸鰹鰺鰻鰼鰽鰾鰿鱀鱁鱂鱃鱄鱅鱆鱇"
         ar_s<<"鱈鱉鱊鱋鱌鱍鱎鱏鱐鱑鱒鱓鱔鱕鱖鱗鱘鱙鱚鱛"
         ar_s<<"鱜鱝鱞鱟鱠鱡鱢鱣鱤鱥鱦鱧鱨鱩鱪鱫鱬鱭鱮鱯"
         ar_s<<"鱰鱱鱲鱳鱴鱵鱶鱷鱸鱹鱺鱻鱼鱽鱾鱿鲀鲁鲂鲃"
         ar_s<<"鲄鲅鲆鲇鲈鲉鲊鲋鲌鲍鲎鲏鲐鲑鲒鲓鲔鲕鲖鲗"
         ar_s<<"鲘鲙鲚鲛鲜鲝鲞鲟鲠鲡鲢鲣鲤鲥鲦鲧鲨鲩鲪鲫"
         ar_s<<"鲬鲭鲮鲯鲰鲱鲲鲳鲴鲵鲶鲷鲸鲹鲺鲻鲼鲽鲾鲿"
         ar_s<<"鳀鳁鳂鳃鳄鳅鳆鳇鳈鳉鳊鳋鳌鳍鳎鳏鳐鳑鳒鳓"
         ar_s<<"鳔鳕鳖鳗鳘鳙鳚鳛鳜鳝鳞鳟鳠鳡鳢鳣鳤鳥鳦鳧"
         ar_s<<"鳨鳩鳪鳫鳬鳭鳮鳯鳰鳱鳲鳳鳴鳵鳶鳷鳸鳹鳺鳻"
         ar_s<<"鳼鳽鳾鳿鴀鴁鴂鴃鴄鴅鴆鴇鴈鴉鴊鴋鴌鴍鴎鴏"
         ar_s<<"鴐鴑鴒鴓鴔鴕鴖鴗鴘鴙鴚鴛鴜鴝鴞鴟鴠鴡鴢鴣"
         ar_s<<"鴤鴥鴦鴧鴨鴩鴪鴫鴬鴭鴮鴯鴰鴱鴲鴳鴴鴵鴶鴷"
         ar_s<<"鴸鴹鴺鴻鴼鴽鴾鴿鵀鵁鵂鵃鵄鵅鵆鵇鵈鵉鵊鵋"
         ar_s<<"鵌鵍鵎鵏鵐鵑鵒鵓鵔鵕鵖鵗鵘鵙鵚鵛鵜鵝鵞鵟"
         ar_s<<"鵠鵡鵢鵣鵤鵥鵦鵧鵨鵩鵪鵫鵬鵭鵮鵯鵰鵱鵲鵳"
         ar_s<<"鵴鵵鵶鵷鵸鵹鵺鵻鵼鵽鵾鵿鶀鶁鶂鶃鶄鶅鶆鶇"
         ar_s<<"鶈鶉鶊鶋鶌鶍鶎鶏鶐鶑鶒鶓鶔鶕鶖鶗鶘鶙鶚鶛"
         ar_s<<"鶜鶝鶞鶟鶠鶡鶢鶣鶤鶥鶦鶧鶨鶩鶪鶫鶬鶭鶮鶯"
         ar_s<<"鶰鶱鶲鶳鶴鶵鶶鶷鶸鶹鶺鶻鶼鶽鶾鶿鷀鷁鷂鷃"
         ar_s<<"鷄鷅鷆鷇鷈鷉鷊鷋鷌鷍鷎鷏鷐鷑鷒鷓鷔鷕鷖鷗"
         ar_s<<"鷘鷙鷚鷛鷜鷝鷞鷟鷠鷡鷢鷣鷤鷥鷦鷧鷨鷩鷪鷫"
         ar_s<<"鷬鷭鷮鷯鷰鷱鷲鷳鷴鷵鷶鷷鷸鷹鷺鷻鷼鷽鷾鷿"
         ar_s<<"鸀鸁鸂鸃鸄鸅鸆鸇鸈鸉鸊鸋鸌鸍鸎鸏鸐鸑鸒鸓"
         ar_s<<"鸔鸕鸖鸗鸘鸙鸚鸛鸜鸝鸞鸟鸠鸡鸢鸣鸤鸥鸦鸧"
         ar_s<<"鸨鸩鸪鸫鸬鸭鸮鸯鸰鸱鸲鸳鸴鸵鸶鸷鸸鸹鸺鸻"
         ar_s<<"鸼鸽鸾鸿鹀鹁鹂鹃鹄鹅鹆鹇鹈鹉鹊鹋鹌鹍鹎鹏"
         ar_s<<"鹐鹑鹒鹓鹔鹕鹖鹗鹘鹙鹚鹛鹜鹝鹞鹟鹠鹡鹢鹣"
         ar_s<<"鹤鹥鹦鹧鹨鹩鹪鹫鹬鹭鹮鹯鹰鹱鹲鹳鹴鹵鹶鹷"
         ar_s<<"鹸鹹鹺鹻鹼鹽鹾鹿麀麁麂麃麄麅麆麇麈麉麊麋"
         ar_s<<"麌麍麎麏麐麑麒麓麔麕麖麗麘麙麚麛麜麝麞麟"
         ar_s<<"麠麡麢麣麤麥麦麧麨麩麪麫麬麭麮麯麰麱麲麳"
         ar_s<<"麴麵麶麷麸麹麺麻麼麽麾麿黀黁黂黃黄黅黆黇"
         ar_s<<"黈黉黊黋黌黍黎黏黐黑黒黓黔黕黖黗默黙黚黛"
         ar_s<<"黜黝點黟黠黡黢黣黤黥黦黧黨黩黪黫黬黭黮黯"
         ar_s<<"黰黱黲黳黴黵黶黷黸黹黺黻黼黽黾黿鼀鼁鼂鼃"
         ar_s<<"鼄鼅鼆鼇鼈鼉鼊鼋鼌鼍鼎鼏鼐鼑鼒鼓鼔鼕鼖鼗"
         ar_s<<"鼘鼙鼚鼛鼜鼝鼞鼟鼠鼡鼢鼣鼤鼥鼦鼧鼨鼩鼪鼫"
         ar_s<<"鼬鼭鼮鼯鼰鼱鼲鼳鼴鼵鼶鼷鼸鼹鼺鼻鼼鼽鼾鼿"
         ar_s<<"齀齁齂齃齄齅齆齇齈齉齊齋齌齍齎齏齐齑齒齓"
         ar_s<<"齔齕齖齗齘齙齚齛齜齝齞齟齠齡齢齣齤齥齦齧"
         ar_s<<"齨齩齪齫齬齭齮齯齰齱齲齳齴齵齶齷齸齹齺齻"
         ar_s<<"齼齽齾齿龀龁龂龃龄龅龆龇龈龉龊龋龌龍龎龏"
         ar_s<<"龐龑龒龓龔龕龖龗龘龙龚龛龜龝龞龟龠龡龢龣"
         ar_s<<"龤龥龦龧龨龩龪龫龬龭龮龯㐀㐁㐂㐃㐄㐅㐆㐇"
         ar_s<<"㐈㐉㐊㐋㐌㐍㐎㐏㐐㐑㐒㐓㐔㐕㐖㐗㐘㐙㐚㐛"
         ar_s<<"㐜㐝㐞㐟㐠㐡㐢㐣㐤㐥㐦㐧㐨㐩㐪㐫㐬㐭㐮㐯"
         ar_s<<"㐰㐱㐲㐳㐴㐵㐶㐷㐸㐹㐺㐻㐼㐽㐾㐿㑀㑁㑂㑃"
         ar_s<<"㑄㑅㑆㑇㑈㑉㑊㑋㑌㑍㑎㑏㑐㑑㑒㑓㑔㑕㑖㑗"
         ar_s<<"㑘㑙㑚㑛㑜㑝㑞㑟㑠㑡㑢㑣㑤㑥㑦㑧㑨㑩㑪㑫"
         ar_s<<"㑬㑭㑮㑯㑰㑱㑲㑳㑴㑵㑶㑷㑸㑹㑺㑻㑼㑽㑾㑿"
         ar_s<<"㒀㒁㒂㒃㒄㒅㒆㒇㒈㒉㒊㒋㒌㒍㒎㒏㒐㒑㒒㒓"
         ar_s<<"㒔㒕㒖㒗㒘㒙㒚㒛㒜㒝㒞㒟㒠㒡㒢㒣㒤㒥㒦㒧"
         ar_s<<"㒨㒩㒪㒫㒬㒭㒮㒯㒰㒱㒲㒳㒴㒵㒶㒷㒸㒹㒺㒻"
         ar_s<<"㒼㒽㒾㒿㓀㓁㓂㓃㓄㓅㓆㓇㓈㓉㓊㓋㓌㓍㓎㓏"
         ar_s<<"㓐㓑㓒㓓㓔㓕㓖㓗㓘㓙㓚㓛㓜㓝㓞㓟㓠㓡㓢㓣"
         ar_s<<"㓤㓥㓦㓧㓨㓩㓪㓫㓬㓭㓮㓯㓰㓱㓲㓳㓴㓵㓶㓷"
         ar_s<<"㓸㓹㓺㓻㓼㓽㓾㓿㔀㔁㔂㔃㔄㔅㔆㔇㔈㔉㔊㔋"
         ar_s<<"㔌㔍㔎㔏㔐㔑㔒㔓㔔㔕㔖㔗㔘㔙㔚㔛㔜㔝㔞㔟"
         ar_s<<"㔠㔡㔢㔣㔤㔥㔦㔧㔨㔩㔪㔫㔬㔭㔮㔯㔰㔱㔲㔳"
         ar_s<<"㔴㔵㔶㔷㔸㔹㔺㔻㔼㔽㔾㔿㕀㕁㕂㕃㕄㕅㕆㕇"
         ar_s<<"㕈㕉㕊㕋㕌㕍㕎㕏㕐㕑㕒㕓㕔㕕㕖㕗㕘㕙㕚㕛"
         ar_s<<"㕜㕝㕞㕟㕠㕡㕢㕣㕤㕥㕦㕧㕨㕩㕪㕫㕬㕭㕮㕯"
         ar_s<<"㕰㕱㕲㕳㕴㕵㕶㕷㕸㕹㕺㕻㕼㕽㕾㕿㖀㖁㖂㖃"
         ar_s<<"㖄㖅㖆㖇㖈㖉㖊㖋㖌㖍㖎㖏㖐㖑㖒㖓㖔㖕㖖㖗"
         ar_s<<"㖘㖙㖚㖛㖜㖝㖞㖟㖠㖡㖢㖣㖤㖥㖦㖧㖨㖩㖪㖫"
         ar_s<<"㖬㖭㖮㖯㖰㖱㖲㖳㖴㖵㖶㖷㖸㖹㖺㖻㖼㖽㖾㖿"
         ar_s<<"㗀㗁㗂㗃㗄㗅㗆㗇㗈㗉㗊㗋㗌㗍㗎㗏㗐㗑㗒㗓"
         ar_s<<"㗔㗕㗖㗗㗘㗙㗚㗛㗜㗝㗞㗟㗠㗡㗢㗣㗤㗥㗦㗧"
         ar_s<<"㗨㗩㗪㗫㗬㗭㗮㗯㗰㗱㗲㗳㗴㗵㗶㗷㗸㗹㗺㗻"
         ar_s<<"㗼㗽㗾㗿㘀㘁㘂㘃㘄㘅㘆㘇㘈㘉㘊㘋㘌㘍㘎㘏"
         ar_s<<"㘐㘑㘒㘓㘔㘕㘖㘗㘘㘙㘚㘛㘜㘝㘞㘟㘠㘡㘢㘣"
         ar_s<<"㘤㘥㘦㘧㘨㘩㘪㘫㘬㘭㘮㘯㘰㘱㘲㘳㘴㘵㘶㘷"
         ar_s<<"㘸㘹㘺㘻㘼㘽㘾㘿㙀㙁㙂㙃㙄㙅㙆㙇㙈㙉㙊㙋"
         ar_s<<"㙌㙍㙎㙏㙐㙑㙒㙓㙔㙕㙖㙗㙘㙙㙚㙛㙜㙝㙞㙟"
         ar_s<<"㙠㙡㙢㙣㙤㙥㙦㙧㙨㙩㙪㙫㙬㙭㙮㙯㙰㙱㙲㙳"
         ar_s<<"㙴㙵㙶㙷㙸㙹㙺㙻㙼㙽㙾㙿㚀㚁㚂㚃㚄㚅㚆㚇"
         ar_s<<"㚈㚉㚊㚋㚌㚍㚎㚏㚐㚑㚒㚓㚔㚕㚖㚗㚘㚙㚚㚛"
         ar_s<<"㚜㚝㚞㚟㚠㚡㚢㚣㚤㚥㚦㚧㚨㚩㚪㚫㚬㚭㚮㚯"
         ar_s<<"㚰㚱㚲㚳㚴㚵㚶㚷㚸㚹㚺㚻㚼㚽㚾㚿㛀㛁㛂㛃"
         ar_s<<"㛄㛅㛆㛇㛈㛉㛊㛋㛌㛍㛎㛏㛐㛑㛒㛓㛔㛕㛖㛗"
         ar_s<<"㛘㛙㛚㛛㛜㛝㛞㛟㛠㛡㛢㛣㛤㛥㛦㛧㛨㛩㛪㛫"
         ar_s<<"㛬㛭㛮㛯㛰㛱㛲㛳㛴㛵㛶㛷㛸㛹㛺㛻㛼㛽㛾㛿"
         ar_s<<"㜀㜁㜂㜃㜄㜅㜆㜇㜈㜉㜊㜋㜌㜍㜎㜏㜐㜑㜒㜓"
         ar_s<<"㜔㜕㜖㜗㜘㜙㜚㜛㜜㜝㜞㜟㜠㜡㜢㜣㜤㜥㜦㜧"
         ar_s<<"㜨㜩㜪㜫㜬㜭㜮㜯㜰㜱㜲㜳㜴㜵㜶㜷㜸㜹㜺㜻"
         ar_s<<"㜼㜽㜾㜿㝀㝁㝂㝃㝄㝅㝆㝇㝈㝉㝊㝋㝌㝍㝎㝏"
         ar_s<<"㝐㝑㝒㝓㝔㝕㝖㝗㝘㝙㝚㝛㝜㝝㝞㝟㝠㝡㝢㝣"
         ar_s<<"㝤㝥㝦㝧㝨㝩㝪㝫㝬㝭㝮㝯㝰㝱㝲㝳㝴㝵㝶㝷"
         ar_s<<"㝸㝹㝺㝻㝼㝽㝾㝿㞀㞁㞂㞃㞄㞅㞆㞇㞈㞉㞊㞋"
         ar_s<<"㞌㞍㞎㞏㞐㞑㞒㞓㞔㞕㞖㞗㞘㞙㞚㞛㞜㞝㞞㞟"
         ar_s<<"㞠㞡㞢㞣㞤㞥㞦㞧㞨㞩㞪㞫㞬㞭㞮㞯㞰㞱㞲㞳"
         ar_s<<"㞴㞵㞶㞷㞸㞹㞺㞻㞼㞽㞾㞿㟀㟁㟂㟃㟄㟅㟆㟇"
         ar_s<<"㟈㟉㟊㟋㟌㟍㟎㟏㟐㟑㟒㟓㟔㟕㟖㟗㟘㟙㟚㟛"
         ar_s<<"㟜㟝㟞㟟㟠㟡㟢㟣㟤㟥㟦㟧㟨㟩㟪㟫㟬㟭㟮㟯"
         ar_s<<"㟰㟱㟲㟳㟴㟵㟶㟷㟸㟹㟺㟻㟼㟽㟾㟿㠀㠁㠂㠃"
         ar_s<<"㠄㠅㠆㠇㠈㠉㠊㠋㠌㠍㠎㠏㠐㠑㠒㠓㠔㠕㠖㠗"
         ar_s<<"㠘㠙㠚㠛㠜㠝㠞㠟㠠㠡㠢㠣㠤㠥㠦㠧㠨㠩㠪㠫"
         ar_s<<"㠬㠭㠮㠯㠰㠱㠲㠳㠴㠵㠶㠷㠸㠹㠺㠻㠼㠽㠾㠿"
         ar_s<<"㡀㡁㡂㡃㡄㡅㡆㡇㡈㡉㡊㡋㡌㡍㡎㡏㡐㡑㡒㡓"
         ar_s<<"㡔㡕㡖㡗㡘㡙㡚㡛㡜㡝㡞㡟㡠㡡㡢㡣㡤㡥㡦㡧"
         ar_s<<"㡨㡩㡪㡫㡬㡭㡮㡯㡰㡱㡲㡳㡴㡵㡶㡷㡸㡹㡺㡻"
         ar_s<<"㡼㡽㡾㡿㢀㢁㢂㢃㢄㢅㢆㢇㢈㢉㢊㢋㢌㢍㢎㢏"
         ar_s<<"㢐㢑㢒㢓㢔㢕㢖㢗㢘㢙㢚㢛㢜㢝㢞㢟㢠㢡㢢㢣"
         ar_s<<"㢤㢥㢦㢧㢨㢩㢪㢫㢬㢭㢮㢯㢰㢱㢲㢳㢴㢵㢶㢷"
         ar_s<<"㢸㢹㢺㢻㢼㢽㢾㢿㣀㣁㣂㣃㣄㣅㣆㣇㣈㣉㣊㣋"
         ar_s<<"㣌㣍㣎㣏㣐㣑㣒㣓㣔㣕㣖㣗㣘㣙㣚㣛㣜㣝㣞㣟"
         ar_s<<"㣠㣡㣢㣣㣤㣥㣦㣧㣨㣩㣪㣫㣬㣭㣮㣯㣰㣱㣲㣳"
         ar_s<<"㣴㣵㣶㣷㣸㣹㣺㣻㣼㣽㣾㣿㤀㤁㤂㤃㤄㤅㤆㤇"
         ar_s<<"㤈㤉㤊㤋㤌㤍㤎㤏㤐㤑㤒㤓㤔㤕㤖㤗㤘㤙㤚㤛"
         ar_s<<"㤜㤝㤞㤟㤠㤡㤢㤣㤤㤥㤦㤧㤨㤩㤪㤫㤬㤭㤮㤯"
         ar_s<<"㤰㤱㤲㤳㤴㤵㤶㤷㤸㤹㤺㤻㤼㤽㤾㤿㥀㥁㥂㥃"
         ar_s<<"㥄㥅㥆㥇㥈㥉㥊㥋㥌㥍㥎㥏㥐㥑㥒㥓㥔㥕㥖㥗"
         ar_s<<"㥘㥙㥚㥛㥜㥝㥞㥟㥠㥡㥢㥣㥤㥥㥦㥧㥨㥩㥪㥫"
         ar_s<<"㥬㥭㥮㥯㥰㥱㥲㥳㥴㥵㥶㥷㥸㥹㥺㥻㥼㥽㥾㥿"
         ar_s<<"㦀㦁㦂㦃㦄㦅㦆㦇㦈㦉㦊㦋㦌㦍㦎㦏㦐㦑㦒㦓"
         ar_s<<"㦔㦕㦖㦗㦘㦙㦚㦛㦜㦝㦞㦟㦠㦡㦢㦣㦤㦥㦦㦧"
         ar_s<<"㦨㦩㦪㦫㦬㦭㦮㦯㦰㦱㦲㦳㦴㦵㦶㦷㦸㦹㦺㦻"
         ar_s<<"㦼㦽㦾㦿㧀㧁㧂㧃㧄㧅㧆㧇㧈㧉㧊㧋㧌㧍㧎㧏"
         ar_s<<"㧐㧑㧒㧓㧔㧕㧖㧗㧘㧙㧚㧛㧜㧝㧞㧟㧠㧡㧢㧣"
         ar_s<<"㧤㧥㧦㧧㧨㧩㧪㧫㧬㧭㧮㧯㧰㧱㧲㧳㧴㧵㧶㧷"
         ar_s<<"㧸㧹㧺㧻㧼㧽㧾㧿㨀㨁㨂㨃㨄㨅㨆㨇㨈㨉㨊㨋"
         ar_s<<"㨌㨍㨎㨏㨐㨑㨒㨓㨔㨕㨖㨗㨘㨙㨚㨛㨜㨝㨞㨟"
         ar_s<<"㨠㨡㨢㨣㨤㨥㨦㨧㨨㨩㨪㨫㨬㨭㨮㨯㨰㨱㨲㨳"
         ar_s<<"㨴㨵㨶㨷㨸㨹㨺㨻㨼㨽㨾㨿㩀㩁㩂㩃㩄㩅㩆㩇"
         ar_s<<"㩈㩉㩊㩋㩌㩍㩎㩏㩐㩑㩒㩓㩔㩕㩖㩗㩘㩙㩚㩛"
         ar_s<<"㩜㩝㩞㩟㩠㩡㩢㩣㩤㩥㩦㩧㩨㩩㩪㩫㩬㩭㩮㩯"
         ar_s<<"㩰㩱㩲㩳㩴㩵㩶㩷㩸㩹㩺㩻㩼㩽㩾㩿㪀㪁㪂㪃"
         ar_s<<"㪄㪅㪆㪇㪈㪉㪊㪋㪌㪍㪎㪏㪐㪑㪒㪓㪔㪕㪖㪗"
         ar_s<<"㪘㪙㪚㪛㪜㪝㪞㪟㪠㪡㪢㪣㪤㪥㪦㪧㪨㪩㪪㪫"
         ar_s<<"㪬㪭㪮㪯㪰㪱㪲㪳㪴㪵㪶㪷㪸㪹㪺㪻㪼㪽㪾㪿"
         ar_s<<"㫀㫁㫂㫃㫄㫅㫆㫇㫈㫉㫊㫋㫌㫍㫎㫏㫐㫑㫒㫓"
         ar_s<<"㫔㫕㫖㫗㫘㫙㫚㫛㫜㫝㫞㫟㫠㫡㫢㫣㫤㫥㫦㫧"
         ar_s<<"㫨㫩㫪㫫㫬㫭㫮㫯㫰㫱㫲㫳㫴㫵㫶㫷㫸㫹㫺㫻"
         ar_s<<"㫼㫽㫾㫿㬀㬁㬂㬃㬄㬅㬆㬇㬈㬉㬊㬋㬌㬍㬎㬏"
         ar_s<<"㬐㬑㬒㬓㬔㬕㬖㬗㬘㬙㬚㬛㬜㬝㬞㬟㬠㬡㬢㬣"
         ar_s<<"㬤㬥㬦㬧㬨㬩㬪㬫㬬㬭㬮㬯㬰㬱㬲㬳㬴㬵㬶㬷"
         ar_s<<"㬸㬹㬺㬻㬼㬽㬾㬿㭀㭁㭂㭃㭄㭅㭆㭇㭈㭉㭊㭋"
         ar_s<<"㭌㭍㭎㭏㭐㭑㭒㭓㭔㭕㭖㭗㭘㭙㭚㭛㭜㭝㭞㭟"
         ar_s<<"㭠㭡㭢㭣㭤㭥㭦㭧㭨㭩㭪㭫㭬㭭㭮㭯㭰㭱㭲㭳"
         ar_s<<"㭴㭵㭶㭷㭸㭹㭺㭻㭼㭽㭾㭿㮀㮁㮂㮃㮄㮅㮆㮇"
         ar_s<<"㮈㮉㮊㮋㮌㮍㮎㮏㮐㮑㮒㮓㮔㮕㮖㮗㮘㮙㮚㮛"
         ar_s<<"㮜㮝㮞㮟㮠㮡㮢㮣㮤㮥㮦㮧㮨㮩㮪㮫㮬㮭㮮㮯"
         ar_s<<"㮰㮱㮲㮳㮴㮵㮶㮷㮸㮹㮺㮻㮼㮽㮾㮿㯀㯁㯂㯃"
         ar_s<<"㯄㯅㯆㯇㯈㯉㯊㯋㯌㯍㯎㯏㯐㯑㯒㯓㯔㯕㯖㯗"
         ar_s<<"㯘㯙㯚㯛㯜㯝㯞㯟㯠㯡㯢㯣㯤㯥㯦㯧㯨㯩㯪㯫"
         ar_s<<"㯬㯭㯮㯯㯰㯱㯲㯳㯴㯵㯶㯷㯸㯹㯺㯻㯼㯽㯾㯿"
         ar_s<<"㰀㰁㰂㰃㰄㰅㰆㰇㰈㰉㰊㰋㰌㰍㰎㰏㰐㰑㰒㰓"
         ar_s<<"㰔㰕㰖㰗㰘㰙㰚㰛㰜㰝㰞㰟㰠㰡㰢㰣㰤㰥㰦㰧"
         ar_s<<"㰨㰩㰪㰫㰬㰭㰮㰯㰰㰱㰲㰳㰴㰵㰶㰷㰸㰹㰺㰻"
         ar_s<<"㰼㰽㰾㰿㱀㱁㱂㱃㱄㱅㱆㱇㱈㱉㱊㱋㱌㱍㱎㱏"
         ar_s<<"㱐㱑㱒㱓㱔㱕㱖㱗㱘㱙㱚㱛㱜㱝㱞㱟㱠㱡㱢㱣"
         ar_s<<"㱤㱥㱦㱧㱨㱩㱪㱫㱬㱭㱮㱯㱰㱱㱲㱳㱴㱵㱶㱷"
         ar_s<<"㱸㱹㱺㱻㱼㱽㱾㱿㲀㲁㲂㲃㲄㲅㲆㲇㲈㲉㲊㲋"
         ar_s<<"㲌㲍㲎㲏㲐㲑㲒㲓㲔㲕㲖㲗㲘㲙㲚㲛㲜㲝㲞㲟"
         ar_s<<"㲠㲡㲢㲣㲤㲥㲦㲧㲨㲩㲪㲫㲬㲭㲮㲯㲰㲱㲲㲳"
         ar_s<<"㲴㲵㲶㲷㲸㲹㲺㲻㲼㲽㲾㲿㳀㳁㳂㳃㳄㳅㳆㳇"
         ar_s<<"㳈㳉㳊㳋㳌㳍㳎㳏㳐㳑㳒㳓㳔㳕㳖㳗㳘㳙㳚㳛"
         ar_s<<"㳜㳝㳞㳟㳠㳡㳢㳣㳤㳥㳦㳧㳨㳩㳪㳫㳬㳭㳮㳯"
         ar_s<<"㳰㳱㳲㳳㳴㳵㳶㳷㳸㳹㳺㳻㳼㳽㳾㳿㴀㴁㴂㴃"
         ar_s<<"㴄㴅㴆㴇㴈㴉㴊㴋㴌㴍㴎㴏㴐㴑㴒㴓㴔㴕㴖㴗"
         ar_s<<"㴘㴙㴚㴛㴜㴝㴞㴟㴠㴡㴢㴣㴤㴥㴦㴧㴨㴩㴪㴫"
         ar_s<<"㴬㴭㴮㴯㴰㴱㴲㴳㴴㴵㴶㴷㴸㴹㴺㴻㴼㴽㴾㴿"
         ar_s<<"㵀㵁㵂㵃㵄㵅㵆㵇㵈㵉㵊㵋㵌㵍㵎㵏㵐㵑㵒㵓"
         ar_s<<"㵔㵕㵖㵗㵘㵙㵚㵛㵜㵝㵞㵟㵠㵡㵢㵣㵤㵥㵦㵧"
         ar_s<<"㵨㵩㵪㵫㵬㵭㵮㵯㵰㵱㵲㵳㵴㵵㵶㵷㵸㵹㵺㵻"
         ar_s<<"㵼㵽㵾㵿㶀㶁㶂㶃㶄㶅㶆㶇㶈㶉㶊㶋㶌㶍㶎㶏"
         ar_s<<"㶐㶑㶒㶓㶔㶕㶖㶗㶘㶙㶚㶛㶜㶝㶞㶟㶠㶡㶢㶣"
         ar_s<<"㶤㶥㶦㶧㶨㶩㶪㶫㶬㶭㶮㶯㶰㶱㶲㶳㶴㶵㶶㶷"
         ar_s<<"㶸㶹㶺㶻㶼㶽㶾㶿㷀㷁㷂㷃㷄㷅㷆㷇㷈㷉㷊㷋"
         ar_s<<"㷌㷍㷎㷏㷐㷑㷒㷓㷔㷕㷖㷗㷘㷙㷚㷛㷜㷝㷞㷟"
         ar_s<<"㷠㷡㷢㷣㷤㷥㷦㷧㷨㷩㷪㷫㷬㷭㷮㷯㷰㷱㷲㷳"
         ar_s<<"㷴㷵㷶㷷㷸㷹㷺㷻㷼㷽㷾㷿㸀㸁㸂㸃㸄㸅㸆㸇"
         ar_s<<"㸈㸉㸊㸋㸌㸍㸎㸏㸐㸑㸒㸓㸔㸕㸖㸗㸘㸙㸚㸛"
         ar_s<<"㸜㸝㸞㸟㸠㸡㸢㸣㸤㸥㸦㸧㸨㸩㸪㸫㸬㸭㸮㸯"
         ar_s<<"㸰㸱㸲㸳㸴㸵㸶㸷㸸㸹㸺㸻㸼㸽㸾㸿㹀㹁㹂㹃"
         ar_s<<"㹄㹅㹆㹇㹈㹉㹊㹋㹌㹍㹎㹏㹐㹑㹒㹓㹔㹕㹖㹗"
         ar_s<<"㹘㹙㹚㹛㹜㹝㹞㹟㹠㹡㹢㹣㹤㹥㹦㹧㹨㹩㹪㹫"
         ar_s<<"㹬㹭㹮㹯㹰㹱㹲㹳㹴㹵㹶㹷㹸㹹㹺㹻㹼㹽㹾㹿"
         ar_s<<"㺀㺁㺂㺃㺄㺅㺆㺇㺈㺉㺊㺋㺌㺍㺎㺏㺐㺑㺒㺓"
         ar_s<<"㺔㺕㺖㺗㺘㺙㺚㺛㺜㺝㺞㺟㺠㺡㺢㺣㺤㺥㺦㺧"
         ar_s<<"㺨㺩㺪㺫㺬㺭㺮㺯㺰㺱㺲㺳㺴㺵㺶㺷㺸㺹㺺㺻"
         ar_s<<"㺼㺽㺾㺿㻀㻁㻂㻃㻄㻅㻆㻇㻈㻉㻊㻋㻌㻍㻎㻏"
         ar_s<<"㻐㻑㻒㻓㻔㻕㻖㻗㻘㻙㻚㻛㻜㻝㻞㻟㻠㻡㻢㻣"
         ar_s<<"㻤㻥㻦㻧㻨㻩㻪㻫㻬㻭㻮㻯㻰㻱㻲㻳㻴㻵㻶㻷"
         ar_s<<"㻸㻹㻺㻻㻼㻽㻾㻿㼀㼁㼂㼃㼄㼅㼆㼇㼈㼉㼊㼋"
         ar_s<<"㼌㼍㼎㼏㼐㼑㼒㼓㼔㼕㼖㼗㼘㼙㼚㼛㼜㼝㼞㼟"
         ar_s<<"㼠㼡㼢㼣㼤㼥㼦㼧㼨㼩㼪㼫㼬㼭㼮㼯㼰㼱㼲㼳"
         ar_s<<"㼴㼵㼶㼷㼸㼹㼺㼻㼼㼽㼾㼿㽀㽁㽂㽃㽄㽅㽆㽇"
         ar_s<<"㽈㽉㽊㽋㽌㽍㽎㽏㽐㽑㽒㽓㽔㽕㽖㽗㽘㽙㽚㽛"
         ar_s<<"㽜㽝㽞㽟㽠㽡㽢㽣㽤㽥㽦㽧㽨㽩㽪㽫㽬㽭㽮㽯"
         ar_s<<"㽰㽱㽲㽳㽴㽵㽶㽷㽸㽹㽺㽻㽼㽽㽾㽿㾀㾁㾂㾃"
         ar_s<<"㾄㾅㾆㾇㾈㾉㾊㾋㾌㾍㾎㾏㾐㾑㾒㾓㾔㾕㾖㾗"
         ar_s<<"㾘㾙㾚㾛㾜㾝㾞㾟㾠㾡㾢㾣㾤㾥㾦㾧㾨㾩㾪㾫"
         ar_s<<"㾬㾭㾮㾯㾰㾱㾲㾳㾴㾵㾶㾷㾸㾹㾺㾻㾼㾽㾾㾿"
         ar_s<<"㿀㿁㿂㿃㿄㿅㿆㿇㿈㿉㿊㿋㿌㿍㿎㿏㿐㿑㿒㿓"
         ar_s<<"㿔㿕㿖㿗㿘㿙㿚㿛㿜㿝㿞㿟㿠㿡㿢㿣㿤㿥㿦㿧"
         ar_s<<"㿨㿩㿪㿫㿬㿭㿮㿯㿰㿱㿲㿳㿴㿵㿶㿷㿸㿹㿺㿻"
         ar_s<<"㿼㿽㿾㿿䀀䀁䀂䀃䀄䀅䀆䀇䀈䀉䀊䀋䀌䀍䀎䀏"
         ar_s<<"䀐䀑䀒䀓䀔䀕䀖䀗䀘䀙䀚䀛䀜䀝䀞䀟䀠䀡䀢䀣"
         ar_s<<"䀤䀥䀦䀧䀨䀩䀪䀫䀬䀭䀮䀯䀰䀱䀲䀳䀴䀵䀶䀷"
         ar_s<<"䀸䀹䀺䀻䀼䀽䀾䀿䁀䁁䁂䁃䁄䁅䁆䁇䁈䁉䁊䁋"
         ar_s<<"䁌䁍䁎䁏䁐䁑䁒䁓䁔䁕䁖䁗䁘䁙䁚䁛䁜䁝䁞䁟"
         ar_s<<"䁠䁡䁢䁣䁤䁥䁦䁧䁨䁩䁪䁫䁬䁭䁮䁯䁰䁱䁲䁳"
         ar_s<<"䁴䁵䁶䁷䁸䁹䁺䁻䁼䁽䁾䁿䂀䂁䂂䂃䂄䂅䂆䂇"
         ar_s<<"䂈䂉䂊䂋䂌䂍䂎䂏䂐䂑䂒䂓䂔䂕䂖䂗䂘䂙䂚䂛"
         ar_s<<"䂜䂝䂞䂟䂠䂡䂢䂣䂤䂥䂦䂧䂨䂩䂪䂫䂬䂭䂮䂯"
         ar_s<<"䂰䂱䂲䂳䂴䂵䂶䂷䂸䂹䂺䂻䂼䂽䂾䂿䃀䃁䃂䃃"
         ar_s<<"䃄䃅䃆䃇䃈䃉䃊䃋䃌䃍䃎䃏䃐䃑䃒䃓䃔䃕䃖䃗"
         ar_s<<"䃘䃙䃚䃛䃜䃝䃞䃟䃠䃡䃢䃣䃤䃥䃦䃧䃨䃩䃪䃫"
         ar_s<<"䃬䃭䃮䃯䃰䃱䃲䃳䃴䃵䃶䃷䃸䃹䃺䃻䃼䃽䃾䃿"
         ar_s<<"䄀䄁䄂䄃䄄䄅䄆䄇䄈䄉䄊䄋䄌䄍䄎䄏䄐䄑䄒䄓"
         ar_s<<"䄔䄕䄖䄗䄘䄙䄚䄛䄜䄝䄞䄟䄠䄡䄢䄣䄤䄥䄦䄧"
         ar_s<<"䄨䄩䄪䄫䄬䄭䄮䄯䄰䄱䄲䄳䄴䄵䄶䄷䄸䄹䄺䄻"
         ar_s<<"䄼䄽䄾䄿䅀䅁䅂䅃䅄䅅䅆䅇䅈䅉䅊䅋䅌䅍䅎䅏"
         ar_s<<"䅐䅑䅒䅓䅔䅕䅖䅗䅘䅙䅚䅛䅜䅝䅞䅟䅠䅡䅢䅣"
         ar_s<<"䅤䅥䅦䅧䅨䅩䅪䅫䅬䅭䅮䅯䅰䅱䅲䅳䅴䅵䅶䅷"
         ar_s<<"䅸䅹䅺䅻䅼䅽䅾䅿䆀䆁䆂䆃䆄䆅䆆䆇䆈䆉䆊䆋"
         ar_s<<"䆌䆍䆎䆏䆐䆑䆒䆓䆔䆕䆖䆗䆘䆙䆚䆛䆜䆝䆞䆟"
         ar_s<<"䆠䆡䆢䆣䆤䆥䆦䆧䆨䆩䆪䆫䆬䆭䆮䆯䆰䆱䆲䆳"
         ar_s<<"䆴䆵䆶䆷䆸䆹䆺䆻䆼䆽䆾䆿䇀䇁䇂䇃䇄䇅䇆䇇"
         ar_s<<"䇈䇉䇊䇋䇌䇍䇎䇏䇐䇑䇒䇓䇔䇕䇖䇗䇘䇙䇚䇛"
         ar_s<<"䇜䇝䇞䇟䇠䇡䇢䇣䇤䇥䇦䇧䇨䇩䇪䇫䇬䇭䇮䇯"
         ar_s<<"䇰䇱䇲䇳䇴䇵䇶䇷䇸䇹䇺䇻䇼䇽䇾䇿䈀䈁䈂䈃"
         ar_s<<"䈄䈅䈆䈇䈈䈉䈊䈋䈌䈍䈎䈏䈐䈑䈒䈓䈔䈕䈖䈗"
         ar_s<<"䈘䈙䈚䈛䈜䈝䈞䈟䈠䈡䈢䈣䈤䈥䈦䈧䈨䈩䈪䈫"
         ar_s<<"䈬䈭䈮䈯䈰䈱䈲䈳䈴䈵䈶䈷䈸䈹䈺䈻䈼䈽䈾䈿"
         ar_s<<"䉀䉁䉂䉃䉄䉅䉆䉇䉈䉉䉊䉋䉌䉍䉎䉏䉐䉑䉒䉓"
         ar_s<<"䉔䉕䉖䉗䉘䉙䉚䉛䉜䉝䉞䉟䉠䉡䉢䉣䉤䉥䉦䉧"
         ar_s<<"䉨䉩䉪䉫䉬䉭䉮䉯䉰䉱䉲䉳䉴䉵䉶䉷䉸䉹䉺䉻"
         ar_s<<"䉼䉽䉾䉿䊀䊁䊂䊃䊄䊅䊆䊇䊈䊉䊊䊋䊌䊍䊎䊏"
         ar_s<<"䊐䊑䊒䊓䊔䊕䊖䊗䊘䊙䊚䊛䊜䊝䊞䊟䊠䊡䊢䊣"
         ar_s<<"䊤䊥䊦䊧䊨䊩䊪䊫䊬䊭䊮䊯䊰䊱䊲䊳䊴䊵䊶䊷"
         ar_s<<"䊸䊹䊺䊻䊼䊽䊾䊿䋀䋁䋂䋃䋄䋅䋆䋇䋈䋉䋊䋋"
         ar_s<<"䋌䋍䋎䋏䋐䋑䋒䋓䋔䋕䋖䋗䋘䋙䋚䋛䋜䋝䋞䋟"
         ar_s<<"䋠䋡䋢䋣䋤䋥䋦䋧䋨䋩䋪䋫䋬䋭䋮䋯䋰䋱䋲䋳"
         ar_s<<"䋴䋵䋶䋷䋸䋹䋺䋻䋼䋽䋾䋿䌀䌁䌂䌃䌄䌅䌆䌇"
         ar_s<<"䌈䌉䌊䌋䌌䌍䌎䌏䌐䌑䌒䌓䌔䌕䌖䌗䌘䌙䌚䌛"
         ar_s<<"䌜䌝䌞䌟䌠䌡䌢䌣䌤䌥䌦䌧䌨䌩䌪䌫䌬䌭䌮䌯"
         ar_s<<"䌰䌱䌲䌳䌴䌵䌶䌷䌸䌹䌺䌻䌼䌽䌾䌿䍀䍁䍂䍃"
         ar_s<<"䍄䍅䍆䍇䍈䍉䍊䍋䍌䍍䍎䍏䍐䍑䍒䍓䍔䍕䍖䍗"
         ar_s<<"䍘䍙䍚䍛䍜䍝䍞䍟䍠䍡䍢䍣䍤䍥䍦䍧䍨䍩䍪䍫"
         ar_s<<"䍬䍭䍮䍯䍰䍱䍲䍳䍴䍵䍶䍷䍸䍹䍺䍻䍼䍽䍾䍿"
         ar_s<<"䎀䎁䎂䎃䎄䎅䎆䎇䎈䎉䎊䎋䎌䎍䎎䎏䎐䎑䎒䎓"
         ar_s<<"䎔䎕䎖䎗䎘䎙䎚䎛䎜䎝䎞䎟䎠䎡䎢䎣䎤䎥䎦䎧"
         ar_s<<"䎨䎩䎪䎫䎬䎭䎮䎯䎰䎱䎲䎳䎴䎵䎶䎷䎸䎹䎺䎻"
         ar_s<<"䎼䎽䎾䎿䏀䏁䏂䏃䏄䏅䏆䏇䏈䏉䏊䏋䏌䏍䏎䏏"
         ar_s<<"䏐䏑䏒䏓䏔䏕䏖䏗䏘䏙䏚䏛䏜䏝䏞䏟䏠䏡䏢䏣"
         ar_s<<"䏤䏥䏦䏧䏨䏩䏪䏫䏬䏭䏮䏯䏰䏱䏲䏳䏴䏵䏶䏷"
         ar_s<<"䏸䏹䏺䏻䏼䏽䏾䏿䐀䐁䐂䐃䐄䐅䐆䐇䐈䐉䐊䐋"
         ar_s<<"䐌䐍䐎䐏䐐䐑䐒䐓䐔䐕䐖䐗䐘䐙䐚䐛䐜䐝䐞䐟"
         ar_s<<"䐠䐡䐢䐣䐤䐥䐦䐧䐨䐩䐪䐫䐬䐭䐮䐯䐰䐱䐲䐳"
         ar_s<<"䐴䐵䐶䐷䐸䐹䐺䐻䐼䐽䐾䐿䑀䑁䑂䑃䑄䑅䑆䑇"
         ar_s<<"䑈䑉䑊䑋䑌䑍䑎䑏䑐䑑䑒䑓䑔䑕䑖䑗䑘䑙䑚䑛"
         ar_s<<"䑜䑝䑞䑟䑠䑡䑢䑣䑤䑥䑦䑧䑨䑩䑪䑫䑬䑭䑮䑯"
         ar_s<<"䑰䑱䑲䑳䑴䑵䑶䑷䑸䑹䑺䑻䑼䑽䑾䑿䒀䒁䒂䒃"
         ar_s<<"䒄䒅䒆䒇䒈䒉䒊䒋䒌䒍䒎䒏䒐䒑䒒䒓䒔䒕䒖䒗"
         ar_s<<"䒘䒙䒚䒛䒜䒝䒞䒟䒠䒡䒢䒣䒤䒥䒦䒧䒨䒩䒪䒫"
         ar_s<<"䒬䒭䒮䒯䒰䒱䒲䒳䒴䒵䒶䒷䒸䒹䒺䒻䒼䒽䒾䒿"
         ar_s<<"䓀䓁䓂䓃䓄䓅䓆䓇䓈䓉䓊䓋䓌䓍䓎䓏䓐䓑䓒䓓"
         ar_s<<"䓔䓕䓖䓗䓘䓙䓚䓛䓜䓝䓞䓟䓠䓡䓢䓣䓤䓥䓦䓧"
         ar_s<<"䓨䓩䓪䓫䓬䓭䓮䓯䓰䓱䓲䓳䓴䓵䓶䓷䓸䓹䓺䓻"
         ar_s<<"䓼䓽䓾䓿䔀䔁䔂䔃䔄䔅䔆䔇䔈䔉䔊䔋䔌䔍䔎䔏"
         ar_s<<"䔐䔑䔒䔓䔔䔕䔖䔗䔘䔙䔚䔛䔜䔝䔞䔟䔠䔡䔢䔣"
         ar_s<<"䔤䔥䔦䔧䔨䔩䔪䔫䔬䔭䔮䔯䔰䔱䔲䔳䔴䔵䔶䔷"
         ar_s<<"䔸䔹䔺䔻䔼䔽䔾䔿䕀䕁䕂䕃䕄䕅䕆䕇䕈䕉䕊䕋"
         ar_s<<"䕌䕍䕎䕏䕐䕑䕒䕓䕔䕕䕖䕗䕘䕙䕚䕛䕜䕝䕞䕟"
         ar_s<<"䕠䕡䕢䕣䕤䕥䕦䕧䕨䕩䕪䕫䕬䕭䕮䕯䕰䕱䕲䕳"
         ar_s<<"䕴䕵䕶䕷䕸䕹䕺䕻䕼䕽䕾䕿䖀䖁䖂䖃䖄䖅䖆䖇"
         ar_s<<"䖈䖉䖊䖋䖌䖍䖎䖏䖐䖑䖒䖓䖔䖕䖖䖗䖘䖙䖚䖛"
         ar_s<<"䖜䖝䖞䖟䖠䖡䖢䖣䖤䖥䖦䖧䖨䖩䖪䖫䖬䖭䖮䖯"
         ar_s<<"䖰䖱䖲䖳䖴䖵䖶䖷䖸䖹䖺䖻䖼䖽䖾䖿䗀䗁䗂䗃"
         ar_s<<"䗄䗅䗆䗇䗈䗉䗊䗋䗌䗍䗎䗏䗐䗑䗒䗓䗔䗕䗖䗗"
         ar_s<<"䗘䗙䗚䗛䗜䗝䗞䗟䗠䗡䗢䗣䗤䗥䗦䗧䗨䗩䗪䗫"
         ar_s<<"䗬䗭䗮䗯䗰䗱䗲䗳䗴䗵䗶䗷䗸䗹䗺䗻䗼䗽䗾䗿"
         ar_s<<"䘀䘁䘂䘃䘄䘅䘆䘇䘈䘉䘊䘋䘌䘍䘎䘏䘐䘑䘒䘓"
         ar_s<<"䘔䘕䘖䘗䘘䘙䘚䘛䘜䘝䘞䘟䘠䘡䘢䘣䘤䘥䘦䘧"
         ar_s<<"䘨䘩䘪䘫䘬䘭䘮䘯䘰䘱䘲䘳䘴䘵䘶䘷䘸䘹䘺䘻"
         ar_s<<"䘼䘽䘾䘿䙀䙁䙂䙃䙄䙅䙆䙇䙈䙉䙊䙋䙌䙍䙎䙏"
         ar_s<<"䙐䙑䙒䙓䙔䙕䙖䙗䙘䙙䙚䙛䙜䙝䙞䙟䙠䙡䙢䙣"
         ar_s<<"䙤䙥䙦䙧䙨䙩䙪䙫䙬䙭䙮䙯䙰䙱䙲䙳䙴䙵䙶䙷"
         ar_s<<"䙸䙹䙺䙻䙼䙽䙾䙿䚀䚁䚂䚃䚄䚅䚆䚇䚈䚉䚊䚋"
         ar_s<<"䚌䚍䚎䚏䚐䚑䚒䚓䚔䚕䚖䚗䚘䚙䚚䚛䚜䚝䚞䚟"
         ar_s<<"䚠䚡䚢䚣䚤䚥䚦䚧䚨䚩䚪䚫䚬䚭䚮䚯䚰䚱䚲䚳"
         ar_s<<"䚴䚵䚶䚷䚸䚹䚺䚻䚼䚽䚾䚿䛀䛁䛂䛃䛄䛅䛆䛇"
         ar_s<<"䛈䛉䛊䛋䛌䛍䛎䛏䛐䛑䛒䛓䛔䛕䛖䛗䛘䛙䛚䛛"
         ar_s<<"䛜䛝䛞䛟䛠䛡䛢䛣䛤䛥䛦䛧䛨䛩䛪䛫䛬䛭䛮䛯"
         ar_s<<"䛰䛱䛲䛳䛴䛵䛶䛷䛸䛹䛺䛻䛼䛽䛾䛿䜀䜁䜂䜃"
         ar_s<<"䜄䜅䜆䜇䜈䜉䜊䜋䜌䜍䜎䜏䜐䜑䜒䜓䜔䜕䜖䜗"
         ar_s<<"䜘䜙䜚䜛䜜䜝䜞䜟䜠䜡䜢䜣䜤䜥䜦䜧䜨䜩䜪䜫"
         ar_s<<"䜬䜭䜮䜯䜰䜱䜲䜳䜴䜵䜶䜷䜸䜹䜺䜻䜼䜽䜾䜿"
         ar_s<<"䝀䝁䝂䝃䝄䝅䝆䝇䝈䝉䝊䝋䝌䝍䝎䝏䝐䝑䝒䝓"
         ar_s<<"䝔䝕䝖䝗䝘䝙䝚䝛䝜䝝䝞䝟䝠䝡䝢䝣䝤䝥䝦䝧"
         ar_s<<"䝨䝩䝪䝫䝬䝭䝮䝯䝰䝱䝲䝳䝴䝵䝶䝷䝸䝹䝺䝻"
         ar_s<<"䝼䝽䝾䝿䞀䞁䞂䞃䞄䞅䞆䞇䞈䞉䞊䞋䞌䞍䞎䞏"
         ar_s<<"䞐䞑䞒䞓䞔䞕䞖䞗䞘䞙䞚䞛䞜䞝䞞䞟䞠䞡䞢䞣"
         ar_s<<"䞤䞥䞦䞧䞨䞩䞪䞫䞬䞭䞮䞯䞰䞱䞲䞳䞴䞵䞶䞷"
         ar_s<<"䞸䞹䞺䞻䞼䞽䞾䞿䟀䟁䟂䟃䟄䟅䟆䟇䟈䟉䟊䟋"
         ar_s<<"䟌䟍䟎䟏䟐䟑䟒䟓䟔䟕䟖䟗䟘䟙䟚䟛䟜䟝䟞䟟"
         ar_s<<"䟠䟡䟢䟣䟤䟥䟦䟧䟨䟩䟪䟫䟬䟭䟮䟯䟰䟱䟲䟳"
         ar_s<<"䟴䟵䟶䟷䟸䟹䟺䟻䟼䟽䟾䟿䠀䠁䠂䠃䠄䠅䠆䠇"
         ar_s<<"䠈䠉䠊䠋䠌䠍䠎䠏䠐䠑䠒䠓䠔䠕䠖䠗䠘䠙䠚䠛"
         ar_s<<"䠜䠝䠞䠟䠠䠡䠢䠣䠤䠥䠦䠧䠨䠩䠪䠫䠬䠭䠮䠯"
         ar_s<<"䠰䠱䠲䠳䠴䠵䠶䠷䠸䠹䠺䠻䠼䠽䠾䠿䡀䡁䡂䡃"
         ar_s<<"䡄䡅䡆䡇䡈䡉䡊䡋䡌䡍䡎䡏䡐䡑䡒䡓䡔䡕䡖䡗"
         ar_s<<"䡘䡙䡚䡛䡜䡝䡞䡟䡠䡡䡢䡣䡤䡥䡦䡧䡨䡩䡪䡫"
         ar_s<<"䡬䡭䡮䡯䡰䡱䡲䡳䡴䡵䡶䡷䡸䡹䡺䡻䡼䡽䡾䡿"
         ar_s<<"䢀䢁䢂䢃䢄䢅䢆䢇䢈䢉䢊䢋䢌䢍䢎䢏䢐䢑䢒䢓"
         ar_s<<"䢔䢕䢖䢗䢘䢙䢚䢛䢜䢝䢞䢟䢠䢡䢢䢣䢤䢥䢦䢧"
         ar_s<<"䢨䢩䢪䢫䢬䢭䢮䢯䢰䢱䢲䢳䢴䢵䢶䢷䢸䢹䢺䢻"
         ar_s<<"䢼䢽䢾䢿䣀䣁䣂䣃䣄䣅䣆䣇䣈䣉䣊䣋䣌䣍䣎䣏"
         ar_s<<"䣐䣑䣒䣓䣔䣕䣖䣗䣘䣙䣚䣛䣜䣝䣞䣟䣠䣡䣢䣣"
         ar_s<<"䣤䣥䣦䣧䣨䣩䣪䣫䣬䣭䣮䣯䣰䣱䣲䣳䣴䣵䣶䣷"
         ar_s<<"䣸䣹䣺䣻䣼䣽䣾䣿䤀䤁䤂䤃䤄䤅䤆䤇䤈䤉䤊䤋"
         ar_s<<"䤌䤍䤎䤏䤐䤑䤒䤓䤔䤕䤖䤗䤘䤙䤚䤛䤜䤝䤞䤟"
         ar_s<<"䤠䤡䤢䤣䤤䤥䤦䤧䤨䤩䤪䤫䤬䤭䤮䤯䤰䤱䤲䤳"
         ar_s<<"䤴䤵䤶䤷䤸䤹䤺䤻䤼䤽䤾䤿䥀䥁䥂䥃䥄䥅䥆䥇"
         ar_s<<"䥈䥉䥊䥋䥌䥍䥎䥏䥐䥑䥒䥓䥔䥕䥖䥗䥘䥙䥚䥛"
         ar_s<<"䥜䥝䥞䥟䥠䥡䥢䥣䥤䥥䥦䥧䥨䥩䥪䥫䥬䥭䥮䥯"
         ar_s<<"䥰䥱䥲䥳䥴䥵䥶䥷䥸䥹䥺䥻䥼䥽䥾䥿䦀䦁䦂䦃"
         ar_s<<"䦄䦅䦆䦇䦈䦉䦊䦋䦌䦍䦎䦏䦐䦑䦒䦓䦔䦕䦖䦗"
         ar_s<<"䦘䦙䦚䦛䦜䦝䦞䦟䦠䦡䦢䦣䦤䦥䦦䦧䦨䦩䦪䦫"
         ar_s<<"䦬䦭䦮䦯䦰䦱䦲䦳䦴䦵䦶䦷䦸䦹䦺䦻䦼䦽䦾䦿"
         ar_s<<"䧀䧁䧂䧃䧄䧅䧆䧇䧈䧉䧊䧋䧌䧍䧎䧏䧐䧑䧒䧓"
         ar_s<<"䧔䧕䧖䧗䧘䧙䧚䧛䧜䧝䧞䧟䧠䧡䧢䧣䧤䧥䧦䧧"
         ar_s<<"䧨䧩䧪䧫䧬䧭䧮䧯䧰䧱䧲䧳䧴䧵䧶䧷䧸䧹䧺䧻"
         ar_s<<"䧼䧽䧾䧿䨀䨁䨂䨃䨄䨅䨆䨇䨈䨉䨊䨋䨌䨍䨎䨏"
         ar_s<<"䨐䨑䨒䨓䨔䨕䨖䨗䨘䨙䨚䨛䨜䨝䨞䨟䨠䨡䨢䨣"
         ar_s<<"䨤䨥䨦䨧䨨䨩䨪䨫䨬䨭䨮䨯䨰䨱䨲䨳䨴䨵䨶䨷"
         ar_s<<"䨸䨹䨺䨻䨼䨽䨾䨿䩀䩁䩂䩃䩄䩅䩆䩇䩈䩉䩊䩋"
         ar_s<<"䩌䩍䩎䩏䩐䩑䩒䩓䩔䩕䩖䩗䩘䩙䩚䩛䩜䩝䩞䩟"
         ar_s<<"䩠䩡䩢䩣䩤䩥䩦䩧䩨䩩䩪䩫䩬䩭䩮䩯䩰䩱䩲䩳"
         ar_s<<"䩴䩵䩶䩷䩸䩹䩺䩻䩼䩽䩾䩿䪀䪁䪂䪃䪄䪅䪆䪇"
         ar_s<<"䪈䪉䪊䪋䪌䪍䪎䪏䪐䪑䪒䪓䪔䪕䪖䪗䪘䪙䪚䪛"
         ar_s<<"䪜䪝䪞䪟䪠䪡䪢䪣䪤䪥䪦䪧䪨䪩䪪䪫䪬䪭䪮䪯"
         ar_s<<"䪰䪱䪲䪳䪴䪵䪶䪷䪸䪹䪺䪻䪼䪽䪾䪿䫀䫁䫂䫃"
         ar_s<<"䫄䫅䫆䫇䫈䫉䫊䫋䫌䫍䫎䫏䫐䫑䫒䫓䫔䫕䫖䫗"
         ar_s<<"䫘䫙䫚䫛䫜䫝䫞䫟䫠䫡䫢䫣䫤䫥䫦䫧䫨䫩䫪䫫"
         ar_s<<"䫬䫭䫮䫯䫰䫱䫲䫳䫴䫵䫶䫷䫸䫹䫺䫻䫼䫽䫾䫿"
         ar_s<<"䬀䬁䬂䬃䬄䬅䬆䬇䬈䬉䬊䬋䬌䬍䬎䬏䬐䬑䬒䬓"
         ar_s<<"䬔䬕䬖䬗䬘䬙䬚䬛䬜䬝䬞䬟䬠䬡䬢䬣䬤䬥䬦䬧"
         ar_s<<"䬨䬩䬪䬫䬬䬭䬮䬯䬰䬱䬲䬳䬴䬵䬶䬷䬸䬹䬺䬻"
         ar_s<<"䬼䬽䬾䬿䭀䭁䭂䭃䭄䭅䭆䭇䭈䭉䭊䭋䭌䭍䭎䭏"
         ar_s<<"䭐䭑䭒䭓䭔䭕䭖䭗䭘䭙䭚䭛䭜䭝䭞䭟䭠䭡䭢䭣"
         ar_s<<"䭤䭥䭦䭧䭨䭩䭪䭫䭬䭭䭮䭯䭰䭱䭲䭳䭴䭵䭶䭷"
         ar_s<<"䭸䭹䭺䭻䭼䭽䭾䭿䮀䮁䮂䮃䮄䮅䮆䮇䮈䮉䮊䮋"
         ar_s<<"䮌䮍䮎䮏䮐䮑䮒䮓䮔䮕䮖䮗䮘䮙䮚䮛䮜䮝䮞䮟"
         ar_s<<"䮠䮡䮢䮣䮤䮥䮦䮧䮨䮩䮪䮫䮬䮭䮮䮯䮰䮱䮲䮳"
         ar_s<<"䮴䮵䮶䮷䮸䮹䮺䮻䮼䮽䮾䮿䯀䯁䯂䯃䯄䯅䯆䯇"
         ar_s<<"䯈䯉䯊䯋䯌䯍䯎䯏䯐䯑䯒䯓䯔䯕䯖䯗䯘䯙䯚䯛"
         ar_s<<"䯜䯝䯞䯟䯠䯡䯢䯣䯤䯥䯦䯧䯨䯩䯪䯫䯬䯭䯮䯯"
         ar_s<<"䯰䯱䯲䯳䯴䯵䯶䯷䯸䯹䯺䯻䯼䯽䯾䯿䰀䰁䰂䰃"
         ar_s<<"䰄䰅䰆䰇䰈䰉䰊䰋䰌䰍䰎䰏䰐䰑䰒䰓䰔䰕䰖䰗"
         ar_s<<"䰘䰙䰚䰛䰜䰝䰞䰟䰠䰡䰢䰣䰤䰥䰦䰧䰨䰩䰪䰫"
         ar_s<<"䰬䰭䰮䰯䰰䰱䰲䰳䰴䰵䰶䰷䰸䰹䰺䰻䰼䰽䰾䰿"
         ar_s<<"䱀䱁䱂䱃䱄䱅䱆䱇䱈䱉䱊䱋䱌䱍䱎䱏䱐䱑䱒䱓"
         ar_s<<"䱔䱕䱖䱗䱘䱙䱚䱛䱜䱝䱞䱟䱠䱡䱢䱣䱤䱥䱦䱧"
         ar_s<<"䱨䱩䱪䱫䱬䱭䱮䱯䱰䱱䱲䱳䱴䱵䱶䱷䱸䱹䱺䱻"
         ar_s<<"䱼䱽䱾䱿䲀䲁䲂䲃䲄䲅䲆䲇䲈䲉䲊䲋䲌䲍䲎䲏"
         ar_s<<"䲐䲑䲒䲓䲔䲕䲖䲗䲘䲙䲚䲛䲜䲝䲞䲟䲠䲡䲢䲣"
         ar_s<<"䲤䲥䲦䲧䲨䲩䲪䲫䲬䲭䲮䲯䲰䲱䲲䲳䲴䲵䲶䲷"
         ar_s<<"䲸䲹䲺䲻䲼䲽䲾䲿䳀䳁䳂䳃䳄䳅䳆䳇䳈䳉䳊䳋"
         ar_s<<"䳌䳍䳎䳏䳐䳑䳒䳓䳔䳕䳖䳗䳘䳙䳚䳛䳜䳝䳞䳟"
         ar_s<<"䳠䳡䳢䳣䳤䳥䳦䳧䳨䳩䳪䳫䳬䳭䳮䳯䳰䳱䳲䳳"
         ar_s<<"䳴䳵䳶䳷䳸䳹䳺䳻䳼䳽䳾䳿䴀䴁䴂䴃䴄䴅䴆䴇"
         ar_s<<"䴈䴉䴊䴋䴌䴍䴎䴏䴐䴑䴒䴓䴔䴕䴖䴗䴘䴙䴚䴛"
         ar_s<<"䴜䴝䴞䴟䴠䴡䴢䴣䴤䴥䴦䴧䴨䴩䴪䴫䴬䴭䴮䴯"
         ar_s<<"䴰䴱䴲䴳䴴䴵䴶䴷䴸䴹䴺䴻䴼䴽䴾䴿䵀䵁䵂䵃"
         ar_s<<"䵄䵅䵆䵇䵈䵉䵊䵋䵌䵍䵎䵏䵐䵑䵒䵓䵔䵕䵖䵗"
         ar_s<<"䵘䵙䵚䵛䵜䵝䵞䵟䵠䵡䵢䵣䵤䵥䵦䵧䵨䵩䵪䵫"
         ar_s<<"䵬䵭䵮䵯䵰䵱䵲䵳䵴䵵䵶䵷䵸䵹䵺䵻䵼䵽䵾䵿"
         ar_s<<"䶀䶁䶂䶃䶄䶅䶆䶇䶈䶉䶊䶋䶌䶍䶎䶏䶐䶑䶒䶓"
         ar_s<<"䶔䶕䶖䶗䶘䶙䶚䶛䶜䶝䶞䶟䶠䶡䶢䶣䶤䶥䶦䶧"
         ar_s<<"䶨䶩䶪䶫䶬䶭䶮䶯䶰䶱䶲䶳䶴䶵䶶䶷䶸䶹䶺䶻"
         ar_s<<"䶼䶽䶾䶿゠ァアィイゥウェエォオカガキギク"
         ar_s<<"グケゲコゴサザシジスズセゼソゾタダチヂッ"
         ar_s<<"ツヅテデトドナニヌネノハバパヒビピフブプ"
         ar_s<<"ヘベペホボポマミムメモャヤュユョヨラリル"
         ar_s<<"レロヮワヰヱヲンヴヵヶヷヸヹヺ・ーヽヾヿ"
         ar_s<<"぀ぁあぃいぅうぇえぉおかがきぎくぐけげこ"
         ar_s<<"ごさざしじすずせぜそぞただちぢっつづてで"
         ar_s<<"とどなにぬねのはばぱひびぴふぶぷへべぺほ"
         ar_s<<"ぼぽまみむめもゃやゅゆょよらりるれろゎわ"
         ar_s<<"ゐゑをんゔゕゖ゗゘゙゚゛゜ゝゞゟ　、。〃"
         ar_s<<"〄々〆〇〈〉《》「」『』【】〒〓〔〕〖〗"
         ar_s<<"〘〙〚〛〜〝〞〟〠〡〢〣〤〥〦〧〨〩〪〫"
         ar_s<<"〭〮〯〬〰〱〲〳〴〵〶〷〸〹〺〻〼〽〾〿"
         #-----semiautomatically--formatted-block--end
         s_0=kibuvits_krl171_s_concat_array_of_strings(ar_s).upcase
         s_1=s_0.downcase
         ar_chars_raw=ar_chars_raw+(s_0+s_1).scan(rgx)
         #------------------------
         ar_chars_raw.uniq! # expensive due to data set size
         #---------------------------
         # The freezing of characters in the alphabet avoids
         # memory allocation at random charstream generation.
         # The next loop will probably allocate more memory
         # than would usually be done at random charstream generation,
         # but it makes applications more robust, fault proof.
         # The freezing targets methods String.upcase, String.downcase, etc.
         i_ar_chars_raw_len=ar_chars_raw.size
         ar_chars_raw_frozen=Array.new(i_ar_chars_raw_len,$kibuvits_krl171_lc_emptystring)
         i_ar_chars_raw_len.times do |ix|
            ar_chars_raw_frozen[ix]=ar_chars_raw[ix].freeze
         end # loop
         ar_chars_raw.clear
         #---------------------------
         @ar_s_set_of_alphabets_t1_ar_chars=ar_chars_raw_frozen.freeze
      end # synchronize
      ar_out=@ar_s_set_of_alphabets_t1_ar_chars
      return ar_out
   end # ar_s_set_of_alphabets_t1

   def Kibuvits_krl171_security_core.ar_s_set_of_alphabets_t1
      ar_out=Kibuvits_krl171_security_core.instance.ar_s_set_of_alphabets_t1
      return ar_out
   end # Kibuvits_krl171_security_core.ar_s_set_of_alphabets_t1

   #-----------------------------------------------------------------------

   # If string of random characters is needed, then it is
   # recommended to concatenate the characters like that:
   #
   #     s_charstream=kibuvits_krl171_s_concat_array_of_strings(ar_array_of_characters)
   #
   def ar_random_charstream_t1(i_lenght_or_output_array=1,b_fast_in_stead_of_thorough=true)
      cl=i_lenght_or_output_array.class
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Array,Bignum], i_lenght_or_output_array
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_fast_in_stead_of_thorough
         if cl==Array
            i_ar_lenght=i_lenght_or_output_array.size
            kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
            0, i_ar_lenght,"\n GUID='b9f75d18-96e7-49de-8198-c2c2f051a4e7'\n\n")
         else
            kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
            0, i_lenght_or_output_array,
            "\n GUID='43a9e87d-ace0-47c2-8468-c2c2f051a4e7'\n\n")
         end # if
      end # if
      #----------
      ar_out=nil
      i_len=nil
      if cl==Array
         ar_out=i_lenght_or_output_array
         i_len=ar_out.size
         return ar_out if i_len==0
      else
         i_len=i_lenght_or_output_array
         return [] if i_len==0
         ar_out=Array.new(i_len,42)
      end # if
      #----------
      ar_alphabet=ar_s_set_of_alphabets_t1()
      i_max_index_in_ar_alphabet=ar_alphabet.size-1
      ix_char=nil
      if (b_fast_in_stead_of_thorough)
         i_len.times do |ix|
            ix_char=Kibuvits_krl171_rng.i_random_fast_t1(i_max_index_in_ar_alphabet)
            ar_out[ix]=ar_alphabet[ix_char]
         end # loop
      else
         i_len.times do |ix|
            ix_char=Kibuvits_krl171_rng.i_random_t1(i_max_index_in_ar_alphabet)
            ar_out[ix]=ar_alphabet[ix_char]
         end # loop
      end # if
      return ar_out
   end # ar_random_charstream_t1


   def Kibuvits_krl171_security_core.ar_random_charstream_t1(
      i_lenght_or_output_array=1,b_fast_in_stead_of_thorough=true)
      ar_out=Kibuvits_krl171_security_core.instance.ar_random_charstream_t1(
      i_lenght_or_output_array,b_fast_in_stead_of_thorough)
   end  # Kibuvits_krl171_security_core.ar_random_charstream_t1


   #-----------------------------------------------------------------------

   # Returns a frozen hashtable, where keys are integers and
   # values are integers. The lowest index of the characters in the
   # alphabet is considered to be 0.
   # For any kind of substitution to make sense,
   # the alphabet must consist of at least 2 characters, e.g.
   # the minimum value of the i_alphabet_length is 2.
   #
   # The func_gen receives 1 parameter: an alphabet character index.
   # The func_gen will called with all values between
   # [0,(i_alphabet_length-1)]. The func_gen is expected to
   # return nil or an empty array or an array of arrays, were
   # each of the the element-arrays has exactly 2 elements:
   # 2 integers, of which  the first one is used as
   # a key in the output hashtable and the second one is used as the
   # value that corresponds to the key.
   #
   # If func_gen.call(ix) returns nil or an empty array,
   # then that iteration does not edit
   # the output hashtable and
   # the loop moves on to the next iteration.
   # The  nil and <empty array> allow the assembly of
   # an output hashtable that mimics a sparse table.
   #
   # Any of the integers within the the key-value pairs
   # that the func_gen returns is allowed to be greater
   # than the maximum index of the alphabet or smaller than
   # zero, because they are placed to the output
   # hashtable according to the following formula:
   #
   #     i_normalized=((i_in mod i_alphabet_length)+
   #                  + i_alphabet_length) mod i_alphabet_length)
   #
   def ht_gen_substitution_box_t1(func_gen,i_alphabet_length)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Proc, func_gen
         kibuvits_krl171_typecheck bn, Fixnum, i_alphabet_length
         #-----------
         ar_params=func_gen.parameters
         i_ar_params_len=ar_params.size
         if i_ar_params_len!=1
            kibuvits_krl171_throw("i_ar_params_len == "+
            i_ar_params_len.to_s+" != 1\n"+
            "GUID='525f7f3e-8885-405f-b438-c2c2f051a4e7'\n")
         end # if
         ar_paramdesc=ar_params[0]
         if ar_paramdesc[0]!=:req
            kibuvits_krl171_throw("ar_paramdesc[0]=="+ar_paramdesc[0].to_s+
            "GUID='287d9a91-1c63-442a-a4f7-c2c2f051a4e7'\n")
         end # if
         #-----------
         i_alphabet_max_index=i_alphabet_length-1
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,1,i_alphabet_max_index,
         "GUID='125ff04f-a3e7-4b3d-a1c7-c2c2f051a4e7'\n")
         #-----------
         i_0=20
         i_0=i_alphabet_length if i_alphabet_length<i_0
         func_test=lambda do |ix|
            bn_1=binding()
            x_func_gen=func_gen.call(ix)
            kibuvits_krl171_typecheck bn_1, [Array,NilClass], x_func_gen
            if x_func_gen.class==Array # zero or more key-value pairs
               return if x_func_gen.size==0
               ar_keyvalue_pair=x_func_gen[0]
               i_ar_keyvalue_pair_len=ar_keyvalue_pair.size
               if i_ar_keyvalue_pair_len!=2
                  kibuvits_krl171_throw("i_ar_keyvalue_pair_len == "+
                  i_ar_keyvalue_pair_len.to_s+" != 2 \n"+
                  "GUID='b9b0ff15-9f16-4781-a297-c2c2f051a4e7'\n")
               end # if
               i_key=ar_keyvalue_pair[0]
               i_value=ar_keyvalue_pair[1]
               kibuvits_krl171_typecheck bn_1, Fixnum, i_key
               kibuvits_krl171_typecheck bn_1, Fixnum, i_value
            end # if
         end # func_test
         i_0.times{|ix| func_test.call(ix)}
         func_test.call(i_alphabet_length-1)
      end # if
      ht=Hash.new
      x_by_func_gen=nil
      ar_keyvaluepairs=nil
      i_ar_keyvaluepairs_len=nil
      i_key=nil
      i_value=nil
      func_normalize=lambda do |ix|
         # The Ruby implementation makes sure that
         # the reminder is always a positive number, e.g.
         # in Ruby (-1)%3 == 2
         i_normalized=ix%i_alphabet_length
         return i_normalized
      end # func_normalize
      i_alphabet_length.times do |ix_origin|
         x_by_func_gen=func_gen.call(ix_origin)
         next if x_by_func_gen==nil
         ar_keyvaluepairs=x_by_func_gen
         i_ar_keyvaluepairs_len=ar_keyvaluepairs.size
         next if i_ar_keyvaluepairs_len==0
         ar_keyvaluepairs.each do |ar_keyvaluepair|
            i_key=func_normalize.call(ar_keyvaluepair[0])
            i_value=func_normalize.call(ar_keyvaluepair[1])
            ht[i_key]=i_value
         end # loop
      end # loop
      ht_out=ht.freeze
      return ht_out
   end # ht_gen_substitution_box_t1

   def Kibuvits_krl171_security_core.ht_gen_substitution_box_t1(
      func_gen,i_alphabet_length)
      ht_out=Kibuvits_krl171_security_core.instance.ht_gen_substitution_box_t1(
      func_gen,i_alphabet_length)
      return ht_out
   end # Kibuvits_krl171_security_core.ht_gen_substitution_box_t1

   #-----------------------------------------------------------------------

   # Offers a rough estimate. 2010<=i_year
   def i_nsa_cpu_cycles_per_second_t1(i_year=2150)
      bn=binding()
      kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_year if KIBUVITS_krl171_b_DEBUG
      kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,2014,i_year,
      "GUID='67f18d19-4359-4128-9177-c2c2f051a4e7'\n")
      #------------------
      # According to
      # http://www.theguardian.com/world/2014/feb/12/utah-lawmaker-nsa-data-centre-water-supply
      # The main data-center requires 1,7*10^6*gallons of water daily
      # to cool the data-center down.
      # i_litres_per_gallon=3.7854118 # U.S.
      i_litres_per_gallon=4.546 # UK
      fd_water_gallons_per_day=(1.7).to_r*(10**6)
      fd_water_gallons_per_second=fd_water_gallons_per_day/(24*3600)
      fd_water_litres_per_second=fd_water_gallons_per_second*i_litres_per_gallon
      fd_water_kg_per_second=fd_water_litres_per_second*1
      # They probably will not import the water in ice form
      # and should they use standard materials for
      # building steam infrastructure, then the best that they can
      # get their hands on is probably equipment that is used for
      # nuclear submarines. The temperature of
      # steam in nuclear reactors is about 315C.
      #
      #i_chem_water_molar_mass=2+16 # H2O
      #fd_water_mol_per_second=(fd_water_kg_per_second*1000)/i_chem_water_molar_mass
      #
      # According to
      # http://www.engineeringtoolbox.com/water-thermal-properties-d_162.html
      #
      #
      fd_water_jouls_per_kg_liquid_per_1c=4.2*(10**3) # roughly
      fd_water_jouls_per_kg_from_0c_liquid_to_100c=fd_water_jouls_per_kg_liquid_per_1c*100
      fd_water_jouls_per_kg_evaporation=2270*(10**3) # roughly
      fd_water_jouls_per_kg_vapour_per_1c=2.0*(10**3) # roughly
      #------
      fd_water_jouls_per_kg_0c_liquid_to_315c=fd_water_jouls_per_kg_from_0c_liquid_to_100c+
      fd_water_jouls_per_kg_evaporation+
      (315-100)*fd_water_jouls_per_kg_vapour_per_1c
      #------------------
      fd_jouls_per_second_2014=fd_water_jouls_per_kg_0c_liquid_to_315c*
      fd_water_kg_per_second
      # According to the http://www.adapteva.com/introduction/
      # The 2014 best technology gives roughly
      # 2W per 64 cores that are 1GHz each
      i_cpu_operations_per_second_per_watt_2014=(1*(10**9)*64.to_r/2).floor # 2W
      i_nsa_cpu_operations_per_second_2014=fd_jouls_per_second_2014/
      i_cpu_operations_per_second_per_watt_2014
      #------------------
      # Applying the "worst" case scenario of the Moore's law,
      # the doubling in every 2 years:
      i_2n=2**(((i_year-2014).to_r/2).floor+1)
      i_nsa_cpu_operations_per_second_i_year=i_nsa_cpu_operations_per_second_2014+
      i_nsa_cpu_operations_per_second_2014*i_2n
      # There are probably more than one data centers and
      # some computing resource is rented from Amazon, etc.
      i_out=i_nsa_cpu_operations_per_second_i_year.floor*2
      return i_out
   end # i_nsa_cpu_cycles_per_second_t1

   def Kibuvits_krl171_security_core.i_nsa_cpu_cycles_per_second_t1(i_year=2150)
      i_out=Kibuvits_krl171_security_core.instance.i_nsa_cpu_cycles_per_second_t1(i_year)
      return i_out
   end # Kibuvits_krl171_security_core.i_nsa_cpu_cycles_per_second_t1(i_year)

   #-----------------------------------------------------------------------

   # http://longterm.softf1.com/specifications/txor/
   #
   # TXOR(aa,bb,m)=((bb-aa+m) mod m)
   # Prerequisites:
   #     2≤m
   #     0≤aa<m
   #     0≤bb<m
   #
   # The bb must always be in the role of a key
   #     ciphertext = TXOR(cleartext,key,m)
   #     cleartext = TXOR(ciphertext,key,m)
   #
   def txor(i_cleartext_or_chiphertext,i_key,i_m)
      aa=i_cleartext_or_chiphertext
      bb=i_key
      m=i_m
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck(bn, [Fixnum,Bignum], i_cleartext_or_chiphertext,
         "GUID='49c0073e-177b-4f0d-8147-c2c2f051a4e7'")
         kibuvits_krl171_typecheck(bn, [Fixnum,Bignum], i_key,
         "GUID='2cf73c23-6cb2-4d68-8317-c2c2f051a4e7'")
         kibuvits_krl171_typecheck(bn, [Fixnum,Bignum], i_m,
         "GUID='dfd74850-5549-4c28-b5d6-c2c2f051a4e7'")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,2,m)
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,0,aa)
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,0,bb)
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,(aa+1),m)
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,(bb+1),m)
      end # if
      i_out=((bb-aa+m)%m)
      return i_out
   end # txor

   def Kibuvits_krl171_security_core.txor(i_cleartext_or_chiphertext,i_key,i_m)
      i_out=Kibuvits_krl171_security_core.instance.txor(
      i_cleartext_or_chiphertext,i_key,i_m)
      return i_out
   end # Kibuvits_krl171_security_core.txor

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_security_core
#=====================kibuvits_krl171_security_core_rb_end========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_security_core_rb_start".
#==========================================================================

#=====================kibuvits_krl171_hash_plaice_t1_rb_start=====================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_hash_plaice_t1_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/security/kibuvits_krl171_security_core.rb"

#==========================================================================

#
# http://longterm.softf1.com/specifications/hash_functions/plaice_hash_function/
#
# It's selftests are part of the Kibuvits_krl171_security_core selftests.
#
class Kibuvits_krl171_hash_plaice_t1

   def initialize
      @mx_ar_of_ht_substitution_boxes_t1_datainit=Mutex.new
      #---------
      # Actual alphabets are all at least as long as the
      # Kibuvits_krl171_security_core.ar_s_set_of_alphabets_t1()
      @ar_s_set_of_alphabets_t1=Kibuvits_krl171_security_core.ar_s_set_of_alphabets_t1()
      @i_ar_s_set_of_alphabets_t1_len=@ar_s_set_of_alphabets_t1.size
      #---------------
      # The variables that contain string "_algorithm_constant_"
      # in their names, must be transferred to the PHP and JavaScript sources.
      s="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      @s_algorithm_constant_arabic_digits_and_english_alphabet=("0123456789"+s+
      s.downcase).freeze
      @i_algorithm_constant_prime_t1=397
      @s_algorithm_constant_version="v_plaice_t1_e".freeze
      #---------
      @lc_s_ar_i_s_in="ar_i_s_in".freeze
      @lc_s_i_len_alphabet="i_len_alphabet".freeze
      @lc_s_blockoper_scatter_t1_ar_index_templates="blockoper_scatter_t1_ar_index_templates".freeze
   end # initialize

   #-----------------------------------------------------------------------

   private

   def ht_substitution_box_t1
      func_substbox=lambda do |ix|
         # The i_interval has to be small enough to fit
         # more than once into the 26 character Latin alphabet.
         # Otherwise many of the real-life texts might
         # not get shuffled "enough".
         i_interval=5
         i_mod_0=ix%i_interval
         return nil if i_mod_0!=0
         i_mod_1=ix%(5*i_interval)
         return nil if (i_mod_1==0) # to break the regularity a bit
         ar_keyvaluepairs=Array.new
         ix_1=ix+3
         ar_keyvaluepairs<<[ix,ix_1]
         ar_keyvaluepairs<<[ix_1,ix]
         return ar_keyvaluepairs
      end # func_substbox
      ht_out=Kibuvits_krl171_security_core.ht_gen_substitution_box_t1(
      func_substbox,@i_ar_s_set_of_alphabets_t1_len)
      return ht_out
   end #  ht_substitution_box_t1

   # The Kibuvits_krl171_security_core_doc.new.doc_study_n_of_necessary_collisions_t1()
   #
   # explains this substitution box.
   # For short: 32 rounds and a batch of 8
   def ht_substitution_box_t2
      func_substbox=lambda do |ix|
         i_delta_1=4 # XcccXccc ... {X,3c}
         i_delta_2=8*i_delta_1+5
         i_mod_d2=ix%i_delta_2
         return nil if i_mod_d2!=0
         #-----------
         i_delta_3=i_delta_2*5
         i_mod_d3=ix%i_delta_3
         return nil if (i_mod_d3==0) # to break the regularity a bit
         #-----------
         ar_keyvaluepairs=Array.new
         8.times do |ii|
            ar_keyvaluepairs<<[(ix+ii*i_delta_1),ix]
         end # loop
         #-----------
         return ar_keyvaluepairs
      end # func_substbox
      ht_out=Kibuvits_krl171_security_core.ht_gen_substitution_box_t1(
      func_substbox,@i_ar_s_set_of_alphabets_t1_len)
      return ht_out
   end #  ht_substitution_box_t2

   def ht_substitution_box_t3
      func_substbox=lambda do |ix|
         i_interval=37
         i_mod_0=ix%i_interval
         return nil if i_mod_0!=0
         i_mod_1=ix%(11*i_interval)
         return nil if (i_mod_1==0) # to break the regularity a bit
         ar_keyvaluepairs=Array.new
         ix_0=ix-1  # even
         ix_1=ix+29 # odd
         ar_keyvaluepairs<<[ix_0,ix_1]
         ar_keyvaluepairs<<[ix_1,ix_0]
         return ar_keyvaluepairs
      end # func_substbox
      ht_out=Kibuvits_krl171_security_core.ht_gen_substitution_box_t1(
      func_substbox,@i_ar_s_set_of_alphabets_t1_len)
      return ht_out
   end #  ht_substitution_box_t3


   public

   # The substitution boxes are stored to an
   # array, because this way code generation
   # scripts that transfer the substitution
   # boxes to other languages, for example, PHP and JavaScript,
   # do not need to be edited, when the number
   # of substitution boxes changes.
   def ar_of_ht_substitution_boxes_t1
      if defined? @ar_of_ht_substitution_boxes_t1_cache
         ar_out=@ar_of_ht_substitution_boxes_t1_cache
         return ar_out
      end # if
      @mx_ar_of_ht_substitution_boxes_t1_datainit.synchronize do
         if defined? @ar_of_ht_substitution_boxes_t1_cache
            ar_out=@ar_of_ht_substitution_boxes_t1_cache
            return ar_out
         end # if
         ar_substboxes=Array.new
         ar_substboxes<<ht_substitution_box_t1()
         ar_substboxes<<ht_substitution_box_t2()
         ar_substboxes<<ht_substitution_box_t3()
         @ar_of_ht_substitution_boxes_t1_cache=ar_substboxes.freeze
      end # synchronize
      ar_out=@ar_of_ht_substitution_boxes_t1_cache
      return ar_out
   end # ar_of_ht_substitution_boxes_t1

   def Kibuvits_krl171_hash_plaice_t1.ar_of_ht_substitution_boxes_t1
      ar_out=Kibuvits_krl171_hash_plaice_t1.instance.ar_of_ht_substitution_boxes_t1
      return ar_out
   end # Kibuvits_krl171_hash_plaice_t1.ar_of_ht_substitution_boxes_t1

   #-----------------------------------------------------------------------

   private

   # The returned array might be longer than the i_headerless_hash_length.
   def ar_gen_ar_opmem(ht_opmem)
      ar_s_in=ht_opmem["ar_s_in"]
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      ht_alphabet_char2ix=ht_opmem["ht_alphabet_char2ix"]
      i_headerless_hash_length=ht_opmem["i_headerless_hash_length"]
      #---------------------
      # In an effort to make the hash algorithm
      # more sensitive to its input, the blocks are
      # extracted from the input character stream by
      # introducing a shift. An example:
      #
      #     s_in == "abcdefgh"
      #
      #     opmem data blocks:
      #         "abc"
      #         "def"
      #         "ghA".downcase  # end of s_in, shift introduced
      #         "bcd"           # shifted
      #         "efg"           # shifted
      #         "hAb".downcase  # end of s_in, another shift introduced
      #
      i_s_in_len=ar_s_in.size
      i_opmem_length=i_headerless_hash_length
      i_mod_s_in=i_s_in_len%2
      i_mod_opmem=i_opmem_length%2
      i_opmem_length=i_opmem_length+1 if i_mod_s_in==i_mod_opmem
      #------------
      ar_opmem=Array.new(i_opmem_length,42)
      ix_ar_opmem=0
      s_char=nil
      i_char=nil
      while (ix_ar_opmem<i_opmem_length) && (ix_ar_opmem<i_s_in_len)
         s_char=ar_s_in[ix_ar_opmem]
         i_char=ht_alphabet_char2ix[s_char]
         ar_opmem[ix_ar_opmem]=i_char
         ix_ar_opmem=ix_ar_opmem+1
      end # while
      # The code would be correct even, if the
      # content of the next if-clause were not
      # wrapped by the if-clause, but it saves
      # some CPU-cycles.
      if ix_ar_opmem<i_opmem_length
         #-------------
         # To increase the probability that the
         #
         #     (i_len_alphabet mod i_delta)!=0
         #
         # the i_delta should be some "big" prime number.
         # If the
         #
         #     (i_len_alphabet mod i_delta)!=0
         #
         # then there will likely be a similar shifting
         # phenomena that the i_opmem_length was tuned to achieve.
         # On the other hand, the i_delta should not be
         # "too big", because the alphabet might contain
         # only a few thousand characters.
         #
         # If the
         #
         #     (i_len_alphabet mod i_delta)==0
         #
         # then the only
         #
         #     i_len_alphabet div i_delta
         #
         # characters are are available for padding
         # the ar_opmem.
         #
         i_delta=@i_algorithm_constant_prime_t1 # a "big", but "not too big", prime number
         i_char=(i_char+i_delta)%i_len_alphabet
         if KIBUVITS_krl171_b_DEBUG
            bn=binding()
            kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
            (i_delta+1),i_len_alphabet, "There's a flaw in the code.\n"+
            "GUID='41fe4858-d1fe-4064-85a6-c2c2f051a4e7'\n\n")
         end # if
         while ix_ar_opmem<i_opmem_length
            i_char=(i_char+i_delta)%i_len_alphabet
            ar_opmem[ix_ar_opmem]=i_char
            ix_ar_opmem=ix_ar_opmem+1
         end # while
      end # if
      return ar_opmem
   end # ar_gen_ar_opmem(i_hash_length)

   #-----------------------------------------------------------------------

   def read_2_ar_opmem_raw(ht_opmem)
      ar_opmem_raw=ht_opmem[$kibuvits_krl171_lc_ar_opmem_raw]
      ar_i_s_in=ht_opmem[@lc_s_ar_i_s_in]
      #---------------------
      # The ix_ar_x_in_cursor points to the first character
      # of the next iteration. The general idea is that
      # the s_in might be shorter than the ar_opmem or, generally,
      #
      #     (s_in.lenght mod ar_opmem.size) != 0
      #
      # and the s_in is cycled through, character by character.
      #
      ix_ar_x_in_cursor=0
      if ht_opmem.has_key? $kibuvits_krl171_lc_ix_ar_x_in_cursor
         ix_ar_x_in_cursor=ht_opmem[$kibuvits_krl171_lc_ix_ar_x_in_cursor]
      end # if
      #---------------------
      i_opmem_length=ar_opmem_raw.size
      i_s_in_len=ar_i_s_in.size
      #---------------------
      #    ABCDE
      #       A
      #    01234
      #---------------------
      ix=0
      i_char=nil
      if KIBUVITS_krl171_b_DEBUG
         i_char=nil
         bn=binding()
         while ix<i_opmem_length
            i_char=ar_i_s_in[ix_ar_x_in_cursor]
            #---------
            if i_char.class!=Fixnum
               # The if-clause wrapping current comment
               # is code bloat, but it's for speed, because
               # otherwise the error message string should
               # be assembled at every call to the typecheck.
               kibuvits_krl171_typecheck(bn, Fixnum, i_char,
               "\n ix_ar_x_in_cursor=="+ix_ar_x_in_cursor.to_s+
               "\nGUID='f093a330-f26e-41a7-9276-c2c2f051a4e7'")
            end # if
            #---------
            ar_opmem_raw[ix]=i_char
            ix_ar_x_in_cursor=ix_ar_x_in_cursor+1
            ix_ar_x_in_cursor=0 if ix_ar_x_in_cursor==i_s_in_len
            ix=ix+1
         end # while
      else
         while ix<i_opmem_length
            i_char=ar_i_s_in[ix_ar_x_in_cursor]
            ar_opmem_raw[ix]=i_char
            ix_ar_x_in_cursor=ix_ar_x_in_cursor+1
            ix_ar_x_in_cursor=0 if ix_ar_x_in_cursor==i_s_in_len
            ix=ix+1
         end # while
      end # if
      #---------------------
      ht_opmem[$kibuvits_krl171_lc_ix_ar_x_in_cursor]=ix_ar_x_in_cursor
   end # read_2_ar_opmem_raw

   #-----------------------------------------------------------------------

   def blockoper_apply_substitution_box(ht_opmem,i_substitution_box_index)
      ar_substboxes=ar_of_ht_substitution_boxes_t1()
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_assert_arrayix(bn,ar_substboxes,i_substitution_box_index,
         "GUID='19852d19-d31a-4a3b-a146-c2c2f051a4e7'\n")
      end # if
      ht_substbox=ar_substboxes[i_substitution_box_index]
      #-----------
      ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]
      ar_opmem_1=ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]
      ar_orig=nil
      ar_dest=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ar_opmem_0
         ar_dest=ar_opmem_1
      else
         ar_orig=ar_opmem_1
         ar_dest=ar_opmem_0
      end # if
      i_opmem_length=ar_opmem_0.size
      #-----------
      i_char_old=nil
      i_char_new=nil
      ix=0
      while ix<i_opmem_length
         i_char_old=ar_orig[ix]
         if ht_substbox.has_key? i_char_old
            i_char_new=ht_substbox[i_char_old]
         else
            i_char_new=i_char_old
         end # if
         ar_dest[ix]=i_char_new
         ix=ix+1
      end # loop
      #-----------
      b_data_in_ar_opmem_0=(!b_data_in_ar_opmem_0)
      ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]=b_data_in_ar_opmem_0
   end # blockoper_apply_substitution_box


   def blockoper_txor_raw_and_opmem(ht_opmem)
      ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]
      ar_opmem_1=ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]
      ar_opmem_raw=ht_opmem[$kibuvits_krl171_lc_ar_opmem_raw]
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      ar_orig=nil
      ar_dest=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ar_opmem_0
         ar_dest=ar_opmem_1
      else
         ar_orig=ar_opmem_1
         ar_dest=ar_opmem_0
      end # if
      i_opmem_length=ar_opmem_0.size
      #-----------
      i_char_old=nil
      i_char_new=nil
      i_char_raw=nil
      ix=0
      while ix<i_opmem_length
         i_char_old=ar_orig[ix]
         # The ar_opmem_raw has the same length as
         # the ar_opmem_0 and ar_opmem_1.
         i_char_raw=ar_opmem_raw[ix]
         i_char_new=Kibuvits_krl171_security_core.txor(
         i_char_old,i_char_raw,i_len_alphabet)
         ar_dest[ix]=i_char_new
         ix=ix+1
      end # loop
      #-----------
      b_data_in_ar_opmem_0=(!b_data_in_ar_opmem_0)
      ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]=b_data_in_ar_opmem_0
   end # blockoper_txor_raw_and_opmem


   # Its purpose is to make sure that every character
   # in the opmem block influences all the rest of the
   # characters in the opmem block.
   def blockoper_txor_opmemwize_t1(ht_opmem)
      ar_orig=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]
      else
         ar_orig=ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]
      end # if
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      i_opmem_length=ar_orig.size
      #-----------
      i_char_old=nil
      i_char_new=nil
      i_char_leftside=nil
      ix=1 # array indices start from 0
      while ix<i_opmem_length
         i_char_leftside=ar_orig[ix-1]
         i_char_old=ar_orig[ix]
         i_char_new=Kibuvits_krl171_security_core.txor(
         i_char_leftside,i_char_old,i_len_alphabet)
         ar_orig[ix]=i_char_new
         ix=ix+1
      end # loop
      # The next if-clause rotates over the top,
      # back to the beginning, i.e. from the
      # greatest index to the smallest index, the index 0.
      if 1<i_opmem_length
         ix_last=i_opmem_length-1
         i_char_leftside=ar_orig[ix_last] # actually the rightmost
         i_char_old=ar_orig[0]            # this time the leftmost
         i_char_new=Kibuvits_krl171_security_core.txor(
         i_char_leftside,i_char_old,i_len_alphabet)
         ar_orig[0]=i_char_new
      end # if
   end # blockoper_txor_opmemwize_t1


   def blockoper_swap_t1(ht_opmem)
      ar_orig=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]
      else
         ar_orig=ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]
      end # if
      i_opmem_length=ar_orig.size
      #-----------
      i_char_leftside=nil
      i_char_rightside=nil
      ix_rightside=nil
      ix=5 # array indices start from 0
      while ix<i_opmem_length
         i_char_leftside=ar_orig[ix]
         ix_rightside=(ix+3)%i_opmem_length
         i_char_rightside=ar_orig[ix_rightside]
         ar_orig[ix_rightside]=i_char_leftside
         ar_orig[ix]=i_char_rightside
         ix=ix+5
      end # loop
   end #  blockoper_swap_t1(ht_opmem)

   # The purpose of this operation is to distribute
   # opmem characters to the whole alphabet, even, if
   # all of the opmem characters are equal. It's harder
   # to conduct cryptanalysis, if the distribution of
   # the output hash characters is uniform regardless of
   # the distribution of the input characters.
   #
   # It also lessens the likelihood that collision based substitution
   # boxes converge the process to a "local minimum" like state.
   def blockoper_scatter_t1(ht_opmem)
      ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]
      ar_opmem_1=ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]
      i_len_alphabet=ht_opmem[@lc_s_i_len_alphabet]
      ar_orig=nil
      ar_dest=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_orig=ar_opmem_0
         ar_dest=ar_opmem_1
      else
         ar_orig=ar_opmem_1
         ar_dest=ar_opmem_0
      end # if
      i_opmem_length=ar_opmem_0.size
      #-----------
      i_template=nil
      ar_index_templates=nil
      if !ht_opmem.has_key? @lc_s_blockoper_scatter_t1_ar_index_templates
         ar_index_templates=Array.new(i_opmem_length,42)
         i_delta=i_len_alphabet.div(i_opmem_length)+1
         ix=0
         i_template=0
         while ix<i_opmem_length
            ar_index_templates[ix]=i_template
            i_template=(i_template+i_delta)%i_len_alphabet
            ix=ix+1
         end # loop
         ht_opmem[@lc_s_blockoper_scatter_t1_ar_index_templates]=ar_index_templates
      else
         ar_index_templates=ht_opmem[@lc_s_blockoper_scatter_t1_ar_index_templates]
      end # if
      #-----------
      i_char_old=nil
      i_char_new=nil
      ix=0
      while ix<i_opmem_length
         i_char_old=ar_orig[ix]
         i_template=ar_index_templates[ix]
         i_char_new=(i_char_old+i_template)%i_len_alphabet
         ar_dest[ix]=i_char_new
         ix=ix+1
      end # loop
      #-----------
      b_data_in_ar_opmem_0=(!b_data_in_ar_opmem_0)
      ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]=b_data_in_ar_opmem_0
   end # blockoper_scatter_t1

   #-----------------------------------------------------------------------

   def gather_the_hash_string_from_data_structures(ht_opmem)
      i_minimum_n_of_rounds=ht_opmem["i_minimum_n_of_rounds"]
      i_headerless_hash_length=ht_opmem["i_headerless_hash_length"]
      ht_alphabet_ix2char=ht_opmem["ht_alphabet_ix2char"]
      #--------------
      ar_s=[@s_algorithm_constant_version+$kibuvits_krl171_lc_colon]
      ar_s<<(i_minimum_n_of_rounds.to_s+$kibuvits_krl171_lc_pillar)
      ar_ix_hash=nil
      b_data_in_ar_opmem_0=ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]
      if b_data_in_ar_opmem_0
         ar_ix_hash=ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]
      else
         ar_ix_hash=ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]
      end # if
      ix=0
      i_char=nil
      while ix<i_headerless_hash_length
         i_char=ar_ix_hash[ix]
         s_char=ht_alphabet_ix2char[i_char]
         ar_s<<s_char
         ix=ix+1
      end # loop
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_out
   end # gather_the_hash_string_from_data_structures

   #-----------------------------------------------------------------------

   public

   # General explanation resides at
   #
   # http://longterm.softf1.com/specifications/hash_functions/plaice_hash_function/
   #
   # A few references to inspirations:
   # http://www.cs.technion.ac.il/~biham/Reports/Tiger/
   # http://www.cs.technion.ac.il/~orrd/SHAvite-3/
   #
   #
   # A few ideas, how to increase the computational expense of
   # deriving the input string from the hash function output:
   #
   # idea_1) Mimic classical, cryptographically strong,
   #         hash functions that use XOR, except that
   #         in stead of using the bitwise XOR, TXOR is used.
   #         http://longterm.softf1.com/specifications/txor/
   #
   # idea_2) Substitution boxes that collide some of the
   #         elements in their domain.
   #         (offers more "originals" for the hash function
   #          output, therefore increases the likelihood of
   #          collisions, but makes it harder to derive exact
   #          input from the output);
   #
   # idea_3) A whole, cyclic, maze of data flows that
   #         have been constructed from idea_1 and idea_2.
   #         The maze might have the shape of a square that
   #         has been recursively divided to smaller squares by
   #         horizontal and vertical bisections. Cross-sections
   #         of lines form graph nodes.
   #
   # idea_5) Colliding probability of
   #         broken_hash_algorithm_1 and
   #         broken_hash_algorithm_2 can be decreased
   #         by conjunction:
   #
   #         far_more_secure_hash_function(s_data) =
   #             = broken_hash_algorithm_1(s_data).concat(
   #               broken_hash_algorithm_2(s_data))
   #
   # idea_6) To make sure that input strings
   #         "cal", "call" and  "wall"
   #         produce different hashes, the hash
   #         has to contain the whole alphabet
   #         and something has to be done with
   #         character counts. To hide the original
   #         message, the original message has to be
   #         extended with characters that are not
   #         in the original message. To hide
   #         Names and number of sentences in the
   #         original message, all characters should
   #         be downcased. On the other hand,
   #         "Wall" and "wall" should produce
   #         different hash values.
   #
   #
   # The unit of the i_headerless_hash_length is "number of characters"
   # and it must be at least 1. Hash format:
   #
   #     <header>|<headerless hash of length i_headerless_hash_length>
   #
   # The <header> does not contain the character "|".
   # Header format: <protocol name and version>:<i_minimum_n_of_rounds>
   #
   # The 300 characters per headerless hash is roughly 300*14b~4200b
   # The 30  characters per headerless hash is roughly  30*14b~ 420b
   # Approximately 7 (seven) characters should be enough to
   # hide the s_in from the NSA for 20 years, prior to the year 2150.
   # For security reasons the minimum value for the i_minimum_n_of_rounds
   # should be 40, but for file checksums it can be 1.
   # The i_minimum_n_of_rounds is part of the parameters only
   # to make it possible to increase the strength of the
   # hash, should the extra number of rounds be enough to
   # compensate design vulnerabilities.
   #
   # In addition to byte endianness CPU-s vary in
   # bit endianness (order of bits in a byte).
   #
   #     http://en.wikipedia.org/wiki/Bit_numbering
   #
   # The conversion of bitstream to text is a complex
   # problem and this hash function has been designed to AVIOID
   # solving that problem in cases, where the conversion
   # has been already performed by programming language stdlib.
   # It is discouraged to use this function for calculating
   # file checksums, because other, bitstream oriented,
   # hash function implementations are a lot faster than
   # the implementation of this hash function.
   def generate(s_in,i_headerless_hash_length=30,
      i_minimum_n_of_rounds=40)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_typecheck bn, Fixnum, i_headerless_hash_length
         kibuvits_krl171_typecheck bn, Fixnum, i_minimum_n_of_rounds
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,1,
         i_headerless_hash_length,
         "GUID='54104335-78d4-4823-9116-c2c2f051a4e7'\n")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,1,
         i_minimum_n_of_rounds,
         "GUID='4ad9053a-87e6-4f0e-a2e5-c2c2f051a4e7'\n")
      end # if
      #---------------
      # The next step is essential for making sure
      # that strings that have different lengths, but
      # consist all of same characters, have different hashes.
      # Without it the strings "ttt" and "tttttt" will
      # have the same hash, provided that the
      # i_headerless_hash_length has a value greater than
      # both of the strings. The @s_algorithm_constant_arabic_digits_and_english_alphabet
      # is just an extra measure.
      s_in=(@s_algorithm_constant_arabic_digits_and_english_alphabet+s_in.length.to_s)+s_in
      # A simplistic countermeasure to the "length extension attack" resides
      # near the "rounds" loop.
      #---------------
      ht_opmem=Hash.new
      ht_opmem["i_headerless_hash_length"]=i_headerless_hash_length
      ht_opmem["i_minimum_n_of_rounds"]=i_minimum_n_of_rounds
      #-------------------------------
      # The
      #     "ab\nc".scan(/./)
      # gives
      #     ["a","b","c"]
      # but the
      #     "ab\nc".scan(/.|[\n\r\s\t]/)
      # gives
      #     ["a","b","\n","c"]
      #
      ar_s_in=s_in.scan(/.|[\n\r\s\t]/).freeze
      #---------------
      ht_opmem["ar_s_in"]=ar_s_in
      ar_0=ar_s_in.uniq
      ar_s_alphabet=(ar_0+@ar_s_set_of_alphabets_t1).uniq.freeze
      i_len_alphabet=ar_s_alphabet.size
      ht_alphabet_char2ix=Hash.new # starts from 0
      ht_alphabet_ix2char=Hash.new
      s_char=nil
      # Worst case scenario is that every character
      # of the s_in is a separate character.
      # 1 giga-character, where in average 1 character
      # is approximately 2B, has a size of 2GB. 2G fits
      # perfectly in the range of the 4B int. This means that
      # due to practical speed considerations the ix
      # will never exit the 4B int range.
      i_len_alphabet.times do |ix|
         s_char=ar_s_alphabet[ix]
         ht_alphabet_char2ix[s_char]=ix
         ht_alphabet_ix2char[ix]=s_char
      end # loop
      ht_opmem["ht_alphabet_char2ix"]=ht_alphabet_char2ix
      ht_opmem["ht_alphabet_ix2char"]=ht_alphabet_ix2char
      #---------------
      ht_opmem[@lc_s_i_len_alphabet]=i_len_alphabet
      ar_opmem_0=ar_gen_ar_opmem(ht_opmem)
      i_opmem_length=ar_opmem_0.size
      ht_opmem[$kibuvits_krl171_lc_ar_opmem_0]=ar_opmem_0
      ht_opmem[$kibuvits_krl171_lc_b_data_in_ar_opmem_0]=true
      ar_opmem_1=Array.new(i_opmem_length,42) # speed hack
      ht_opmem[$kibuvits_krl171_lc_ar_opmem_1]=ar_opmem_1
      ar_opmem_raw=Array.new(i_opmem_length,42)
      ht_opmem[$kibuvits_krl171_lc_ar_opmem_raw]=ar_opmem_raw
      #---------------
      i_s_in_len=s_in.length
      ar_i_s_in=Array.new(i_s_in_len,42)
      s_in_char=nil
      i_s_in_char=nil
      i_s_in_len.times do |ix|
         s_in_char=ar_s_in[ix]
         i_s_in_char=ht_alphabet_char2ix[s_in_char]
         if i_s_in_char==nil
            kibuvits_krl171_throw("\nCharacter \""+s_in_char+
            "\" is missing from the \n"+
            "alphabet that this hash function uses.\n"+
            "The character is missing ONLY because the \n"+
            "hash algorithm implementation is flawed.\n"+
            "GUID='1c409150-8db4-4026-84b5-c2c2f051a4e7'\n\n")
            # That situation can actually happen in real life.
            # Hopefully the exception text allows somewhat
            # gradual degradation by trying to give the end
            # users a temporary semi-workaround in the form
            # of a chance to avoid the character in the input text.
         end # if
         ar_i_s_in[ix]=i_s_in_char
      end # loop
      ar_i_s_in=ar_i_s_in.freeze
      ht_opmem[@lc_s_ar_i_s_in]=ar_i_s_in
      #---------------
      # Characters are read from the s_in and inserted to the
      # hashing operation by a call to a pair of functions:
      #
      #  read_2_ar_opmem_raw(ht_opmem)
      #  blockoper_txor_raw_and_opmem(ht_opmem)
      #
      # To make sure that all characters of the
      # s_in are inserted to the hashing operation,
      # the number of rounds might have to be increased.
      #
      i_n_blocks_per_round=5 # read manually from the rounds loop
      i_n_chars_per_round=i_n_blocks_per_round*i_opmem_length  # i_opmem_length==<block size>
      i_n_chars_taken_to_account=i_minimum_n_of_rounds*i_n_chars_per_round
      i_n_rounds_adjusted=nil
      if i_n_chars_taken_to_account<i_s_in_len
         i_chars_omitted=i_s_in_len-i_n_chars_taken_to_account
         i_rounds_to_add=i_chars_omitted.div(i_n_chars_per_round)+1
         # The "+1" was to compensate a situation, where
         #
         # i_chars_omitted.div(i_n_chars_per_round)*i_n_chars_per_round < i_chars_omitted
         #
         i_n_rounds_adjusted=i_minimum_n_of_rounds+i_rounds_to_add
      else
         i_n_rounds_adjusted=i_minimum_n_of_rounds
      end # if
      #---------------
      # If I (martin.vahi@softf1.com) understand the
      # idea behind a "length extension attack" correctly, (a BIG IF), then
      # the idea behind the "length extension attack" is that the
      # tail part of the s_hashable_string=secret+publicly_known_message
      # is changed by unrolling the hash function from the
      # input datastream tail to somewhere in the middle, replacing the
      # tail and then rolling the hash function back on the tail, the new tail,
      # again.
      # https://en.wikipedia.org/wiki/Length_extension_attack
      # https://github.com/bwall/HashPump
      # https://github.com/iagox86/hash_extender
      #
      # The scheme of the simplistic countermeasure here
      # is that in stead of calculating
      #
      #     s_in=s_secret+s_publicly_known_text
      #     or
      #     s_in=s_publicly_known_text+s_secret
      #     hash(s_in)
      #
      # the countermeasure tries to make sure that
      # "roughly" the following is calculated:
      #
      #     hash(s_secret+s_publicly_known_text+s_secret)
      #
      # A way to do that, approximately, "roughly", is to
      # re-read the start of the
      #
      #     s_in=s_secret+s_publicly_known_text
      #
      # The case, where the "s_secret" is part of the tail, i.e.
      #
      #     s_in=s_publicly_known_text+s_secret
      #
      # is covered by the fact that the tail part, the s_secret part,
      # is fed to the hash algorithm at the very end.
      # So, here it goes, with a semirandom constant of 10% equiv 0.1:
      i_antimeasure_rounds=(i_s_in_len.to_f*0.1/i_n_chars_per_round).round
      i_antimeasure_rounds=i_antimeasure_rounds+1 # also covers the i_antimeasure_rounds==0
      i_n_rounds_adjusted=i_n_rounds_adjusted+i_antimeasure_rounds
      #---------------
      # There is no need to call the
      #
      # blockoper_txor_raw_and_opmem(...)
      #
      # prior to this loop, because the first
      # reading of raw data has been performed
      # within ar_gen_ar_opmem(...)
      i_n_rounds_adjusted.times do |i_round|
         blockoper_scatter_t1(ht_opmem)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_apply_substitution_box(ht_opmem,0)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_apply_substitution_box(ht_opmem,1) # "8-collider"
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_txor_opmemwize_t1(ht_opmem)
         blockoper_swap_t1(ht_opmem)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
         #---------
         blockoper_apply_substitution_box(ht_opmem,2)
         read_2_ar_opmem_raw(ht_opmem)
         blockoper_txor_raw_and_opmem(ht_opmem)
      end # loop
      #---------------
      # Improve the hash algorithm by adding a loop here,
      # where the Prüfer Code is generated from part
      # of the output of the previous loop, may be the
      # very first character code. The tree as a graph
      # is "sorted" and the nodes of the tree are
      # the substitution boxes and other operations
      # that modify the ht_opmem content.
      #---------------
      s_out=gather_the_hash_string_from_data_structures(ht_opmem)
      return s_out
   end # generate

   # This method has a wrapper: kibuvits_krl171_hash_plaice_t1(...)
   def Kibuvits_krl171_hash_plaice_t1.generate(s_in,
      i_headerless_hash_length=30,i_minimum_n_of_rounds=40)
      s_out=Kibuvits_krl171_hash_plaice_t1.instance.generate(
      s_in,i_headerless_hash_length,i_minimum_n_of_rounds)
      return s_out
   end # Kibuvits_krl171_hash_plaice_t1.generate

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_hash_plaice_t1

def kibuvits_krl171_hash_plaice_t1(s_in,
   i_headerless_hash_length=30,i_minimum_n_of_rounds=40)
   s_out=Kibuvits_krl171_hash_plaice_t1.generate(
   s_in,i_headerless_hash_length,i_minimum_n_of_rounds)
   return s_out
end # kibuvits_krl171_hash_plaice_t1

#=========================================================================
# puts kibuvits_krl171_hash_plaice_t1("abcc")
#=====================kibuvits_krl171_hash_plaice_t1_rb_end=======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_hash_plaice_t1_rb_start".
#==========================================================================

#===============kibuvits_krl171_cleartext_length_normalization_rb_start===========
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cleartext_length_normalization_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/security/kibuvits_krl171_hash_plaice_t1.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_ProgFTE.rb"

#==========================================================================


# The idea is that cryptotext length should not
# reveal cleartext length.
#
# http://longterm.softf1.com/2014/codedoc/cleartext_length_t1/
#

class Kibuvits_krl171_cleartext_length_normalization
   @@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1=10000
   @@s_format_version_t1="Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1.v2".freeze
   @@s_failure_id_checksum_failure_t1="text_length_denormalization_checksum_failure_t1".freeze

   def initialize
      @s_lc_s_charstream_1="s_charstream_1".freeze
      @s_lc_s_charstream_2="s_charstream_2".freeze
      @s_lc_s_charstream_3="s_charstream_3".freeze
      #------
      @ar_of_key_candidates=Array.new
      @ar_of_key_candidates<<$kibuvits_krl171_lc_s_format_version
      @ar_of_key_candidates<<@s_lc_s_charstream_1
      @ar_of_key_candidates<<@s_lc_s_charstream_2
      @ar_of_key_candidates<<@s_lc_s_charstream_3
      @ar_of_key_candidates<<$kibuvits_krl171_lc_s_checksum_hash
      @ar_of_key_candidates.freeze
   end # initialize

   #-----------------------------------------------------------------------

   def i_val_t2(i_in)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_in
      end # if
      i_out=(i_in.to_r/3).floor*2
      return i_out
   end # i_val_t2

   def Kibuvits_krl171_cleartext_length_normalization.i_val_t2(i_in)
      i_out=Kibuvits_krl171_cleartext_length_normalization.instance.i_val_t2(i_in)
      return i_out
   end # Kibuvits_krl171_cleartext_length_normalization.i_val_t2

   #-----------------------------------------------------------------------

   private

   def s_gen_charstream(i_charstream_len,b_use_fast_random)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_charstream_len
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_use_fast_random
      end # if
      ar_charstream=Kibuvits_krl171_security_core.ar_random_charstream_t1(
      i_charstream_len,b_use_fast_random)
      s_charstream=kibuvits_krl171_s_concat_array_of_strings(ar_charstream)
      ar_charstream.clear # may be it helps a little
      return s_charstream
   end # s_gen_charstream

   #-----------------------------------------------------------------------

   public

   # This function mainly exists to wrap the
   # hash calculation parameters.
   # Normalization and de-normalization must
   # both use the same hashing algorithm with
   # the same parameters.
   #
   # It's public to facilitate testing.
   def s_calc_checksum_hash_t1(s_in)
      i_headerless_hash_length=8
      # The hash implementation will probably
      # increase the number of rounds anyways.
      i_minimum_n_of_rounds=1
      s_out=kibuvits_krl171_hash_plaice_t1(s_in,
      i_headerless_hash_length,i_minimum_n_of_rounds)
      return s_out
   end # s_calc_checksum_hash_t1

   def Kibuvits_krl171_cleartext_length_normalization.s_calc_checksum_hash_t1(s_in)
      s_out=Kibuvits_krl171_cleartext_length_normalization.instance.s_calc_checksum_hash_t1(s_in)
      return s_out
   end # Kibuvits_krl171_cleartext_length_normalization.s_calc_checksum_hash_t1

   #-----------------------------------------------------------------------

   # Returns a ProgFTE_v1 string. The s_in
   # should be extracted from the ProgFTE by using
   # s_normalize_t1_extract_cleartext(s_normalized_text)
   #
   def s_normalize_t1(s_in,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=@@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1,
      b_use_fast_random=false,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=i_val_t2(
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts))
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_estimated_median_of_lengths_of_nonnormalized_cleartexts
         kibuvits_krl171_typecheck bn, [TrueClass,FalseClass], b_use_fast_random
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum],i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='7ff3c655-6f6a-4a76-8575-c2c2f051a4e7'\n\n")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='9945763c-c691-493c-a245-c2c2f051a4e7'\n\n")
      end # if
      #---------
      i_normalized_cleartext_len_min=i_estimated_median_of_lengths_of_nonnormalized_cleartexts+
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
      i_charstream_len_sum=i_normalized_cleartext_len_min
      i_len_s_in=s_in.length
      if i_len_s_in<i_normalized_cleartext_len_min
         i_charstream_len_sum=i_normalized_cleartext_len_min-i_len_s_in
      end # if
      i_randdelta_max=2*i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
      if 0<i_randdelta_max # It's OK for the standard deviation to be 0. Series of constants are like that.
         if b_use_fast_random
            i_charstream_len_sum=i_charstream_len_sum+Kibuvits_krl171_rng.i_random_fast_t1(i_randdelta_max)
         else
            i_charstream_len_sum=i_charstream_len_sum+Kibuvits_krl171_rng.i_random_t1(i_randdelta_max)
         end # if
      end # if
      #---------
      i_charstream_len_1=0
      i_charstream_len_3=0
      if 0<i_charstream_len_sum
         i_max=i_charstream_len_sum-1
         if b_use_fast_random
            i_charstream_len_1=Kibuvits_krl171_rng.i_random_fast_t1(i_max)
         else
            i_charstream_len_1=Kibuvits_krl171_rng.i_random_t1(i_max)
         end # if
      end # if
      i_charstream_len_3=i_charstream_len_sum-i_charstream_len_1
      #------------------------------
      # The idea is that the s_in should be "anywhere"
      # within the normalized string. The solution:
      # <randomcharstream_with_random_length><s_in><randomcharstream_with_random_length>
      ht=Hash.new
      ht[$kibuvits_krl171_lc_s_format_version]=@@s_format_version_t1
      ht[@s_lc_s_charstream_1]=s_gen_charstream(i_charstream_len_1,b_use_fast_random)
      ht[$kibuvits_krl171_lc_s_checksum_hash]=s_calc_checksum_hash_t1(s_in)
      ht[@s_lc_s_charstream_2]=s_in
      ht[@s_lc_s_charstream_3]=s_gen_charstream(
      i_charstream_len_3,b_use_fast_random)
      #---------
      s_progfte=Kibuvits_krl171_ProgFTE.from_ht(ht)
      #---------
      # To mitigate the situation, where ProgFTE
      # header characters and the very last "|"
      # reveal information about the key that encrypts them,
      # a random length random charstream prefix and suffix are used.
      i_max=400+(0.01*i_estimated_median_of_lengths_of_nonnormalized_cleartexts.to_f).round
      i_charstream_prefix_len=0
      rgx_for_func=/[v\d|\n\r\s]/
      func_gen_prefix_or_suffix_charstream=lambda do
         if b_use_fast_random
            i_charstream_prefix_len=Kibuvits_krl171_rng.i_random_fast_t1(i_max)
         else
            i_charstream_prefix_len=Kibuvits_krl171_rng.i_random_t1(i_max)
         end # if
         #---------
         # The "v" and digits are removed from the prefix to allow
         # ProgFTE format version detection to detect that the
         # s_normalized is not in ProgFTE_v0 nor in ProgFTE_v1
         # The pillar is removed from the charstreams to allow the
         # charstreams to be stripped from the prefix and suffix of
         # ProgFTE string.
         #
         # What regards to the efficiency of this solution,
         # then that depends on, how string reversal has been
         # implemented in ruby. As of 2014_12 on a 3GHz machine
         # a 10 million character string is reversed in
         # a fraction of a second.
         #
         s_charstream=s_gen_charstream(i_charstream_prefix_len,
         b_use_fast_random).gsub(rgx_for_func,$kibuvits_krl171_lc_emptystring)
         return s_charstream
      end # func_gen_prefix_or_suffix_charstream
      #---------
      s_prefix=func_gen_prefix_or_suffix_charstream.call()
      s_prefix<<$kibuvits_krl171_lc_pillar
      s_suffix=func_gen_prefix_or_suffix_charstream.call()
      s_normalized=s_prefix+s_progfte
      s_normalized<<s_suffix # faster than "+", if the Ruby.String preallocation covers s_suffix.length
      return s_normalized
   end # s_normalize_t1

   def Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1(s_in,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=@@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1,
      b_use_fast_random=false,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=Kibuvits_krl171_cleartext_length_normalization.i_val_t2(
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts))

      s_out=Kibuvits_krl171_cleartext_length_normalization.instance.s_normalize_t1(s_in,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts,b_use_fast_random,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts)
      return s_out
   end # Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1

   #-----------------------------------------------------------------------

   private

   # A bit short for a separate method, but keeps code organized.
   def s_normalize_t1_extract_cleartext_add_x_data_2_msgc(ht,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         #msgcs.assert_lack_of_failures("GUID='24af5c28-d918-4b1b-a515-c2c2f051a4e7'")
      end # if
      msgc=msgcs.last
      msgc.x_data=ht
   end # s_normalize_t1_extract_cleartext_add_x_data_2_msgc

   def s_verify_cleartext_integrity(ht,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, Hash, ht
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures("GUID='08bcca5a-34e9-42b7-b3e4-c2c2f051a4e7'")
      end # if
      s_cleartext=ht[@s_lc_s_charstream_2]
      s_hash_orig=ht[$kibuvits_krl171_lc_s_checksum_hash]
      s_hash_calc=s_calc_checksum_hash_t1(s_cleartext)
      if s_hash_orig!=s_hash_calc
         s_default_msg="The hash of the cleartext within the "+
         "normalized text (==\n"+s_hash_orig+"\n) "+
         "differs from the hash that is calculated from the de-normalized text(==\n"+
         s_hash_calc+"\n).\n"
         s_message_id=@@s_failure_id_checksum_failure_t1
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "34da434f-5756-48bb-9133-c2c2f051a4e7")
         s_normalize_t1_extract_cleartext_add_x_data_2_msgc(ht,msgcs)
      end # if
      return s_cleartext
   end # s_verify_cleartext_integrity


   public

   # The s_in is expected to be the output of the s_normalize_t1(...)
   def s_normalize_t1_extract_cleartext(s_in,msgcs)
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_in
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='89611958-b028-48c1-b2b4-c2c2f051a4e7'")
      end # if
      #-------
      ix_0=s_in.index($kibuvits_krl171_lc_pillar)        # "xx|abc|yyy".index("|") == 2
      s_progfte_plus_suffix=s_in[(ix_0+1)..(-1)]  #    "abc|yyy"
      s_0=s_progfte_plus_suffix.reverse           #    "yyy|cba"
      ix_0=s_0.index($kibuvits_krl171_lc_pillar)         #    "yyy|cba".index("|") == 3
      s_progfte=s_0[(ix_0)..(-1)].reverse         #    "abc|"
      #-------
      ht=Kibuvits_krl171_ProgFTE.to_ht(s_progfte)
      kibuvits_krl171_assert_ht_has_keys(bn,ht,@ar_of_key_candidates,
      "GUID='59a70fd3-2370-46ae-b584-c2c2f051a4e7'")
      s_format_version=ht[$kibuvits_krl171_lc_s_format_version]
      if s_format_version!=@@s_format_version_t1
         s_default_msg="The s_format_version == "+s_format_version+
         "\nbut "+@@s_format_version_t1+" is expected.\n"
         s_message_id="text_length_denormalization_failure_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "314e5c72-31ad-4592-b4d2-c2c2f051a4e7")
         s_normalize_t1_extract_cleartext_add_x_data_2_msgc(ht,msgcs)
      end # if
      s_out=s_verify_cleartext_integrity(ht,msgcs)
      return s_out
   end # s_normalize_t1_extract_cleartext


   def Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_in,msgcs)
      s_out=Kibuvits_krl171_cleartext_length_normalization.instance.s_normalize_t1_extract_cleartext(
      s_in,msgcs)
      return s_out
   end # Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1_extract_cleartext

   #-----------------------------------------------------------------------

   def Kibuvits_krl171_cleartext_length_normalization.i_const_t1
      i_out=@@i_estimated_median_of_lengths_of_nonnormalized_cleartexts_t1
      return i_out
   end # Kibuvits_krl171_cleartext_length_normalization.i_const_t1

   #-----------------------------------------------------------------------

   include Singleton

end # class Kibuvits_krl171_cleartext_length_normalization

#=========================================================================

# s_cleartext="aa"
# s_normalized=Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1(
# s_cleartext,42) # 42 is too short for real data
# puts "\nNormalized text:\n"+s_normalized+"\n\n"
# s_denormalized=Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
# s_normalized,$kibuvits_krl171_msgc_stack)
# puts "denormalized text:\n"+s_denormalized+"\n\n"
#===============kibuvits_krl171_cleartext_length_normalization_rb_end=============
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cleartext_length_normalization_rb_start".
#==========================================================================

#=====================kibuvits_krl171_cryptcodec_txor_t1_rb_start=================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cryptcodec_txor_t1_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_GUID_generator.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/security/kibuvits_krl171_cleartext_length_normalization.rb"

#==========================================================================

class Kibuvits_krl171_cryptcodec_txor_t1
   @@i_n_of_datasalt_digits=7
   @@i_key_param_max_number_of_bytes_per_character=7

   def initialize
      @s_key_type_t1="kibuvits_krl171_series_of_whole_numbers_t2"
      @s_lc_s_key_type="s_key_type"
      @s_lc_i_n_of_datasalt_digits="i_n_of_datasalt_digits".freeze
      @s_lc_i_saltfree_data_max="i_saltfree_data_max".freeze
      @s_cryptocodec_type_t1="kibuvits_krl171_wearlevelling_t1d"
      @s_lc_s_key_id="s_key_id"
   end # initialize

   private

   # http://longterm.softf1.com/specifications/txor/
   def txor(aa,bb,m)
      i_out=((bb-aa+m)%m)
      return i_out
   end # txor(aa,bb,m)

   def txor_encrypt(i_cleartext,i_key,i_m)
      i_out=txor(i_cleartext,i_key,i_m)
      return i_out
   end # txor_encrypt

   def txor_decrypt(i_ciphertext,i_key,i_m)
      i_out=txor(i_ciphertext,i_key,i_m)
      return i_out
   end # txor_decrypt

   public

   def ht_generate_key_t1(i_key_length,
      i_max_number_of_bytes_per_character=@@i_key_param_max_number_of_bytes_per_character)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_key_length
         kibuvits_krl171_typecheck bn, Fixnum, i_max_number_of_bytes_per_character
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         1, [i_key_length,i_max_number_of_bytes_per_character],
         "\n GUID='7185ca1d-8a18-4785-8334-c2c2f051a4e7'")
      end # if
      ht_key=Hash.new
      ht_key[@s_lc_i_n_of_datasalt_digits]=@@i_n_of_datasalt_digits
      ht_key[@s_lc_s_key_id]=Kibuvits_krl171_GUID_generator.generate_GUID
      i_number_of_saltfree_values_max=2**(8*i_max_number_of_bytes_per_character)
      i_saltfree_data_max=i_number_of_saltfree_values_max-1
      ht_key[@s_lc_i_saltfree_data_max]=i_saltfree_data_max

      # The m is a term from the TXOR specification.
      # http://longterm.softf1.com/specifications/txor/
      i_m=i_number_of_saltfree_values_max*(10**@@i_n_of_datasalt_digits)+
      Kibuvits_krl171_rng.i_random_t1(10**4) # + random to counter rainbow table style attacks

      ht_key[$kibuvits_krl171_lc_i_m]=i_m
      ar=Array.new
      i_key_length.times{ar<<Kibuvits_krl171_rng.i_random_t1(i_m)}
      ht_key[$kibuvits_krl171_lc_ar]=ar
      ht_key[@s_lc_s_key_type]=@s_key_type_t1
      #----------
      # "mode_1" might be a mode, where the key
      # is being used as the traditional one-time pad,
      # where key characters are used up sequentially.
      #
      # "mode_2" is a one-time pad,
      # where key characters are chosen the way they are
      # chosen in mode_0.
      #
      # There might be other modes, that shift the
      # random selection target window among the array of
      # key characters.
      #
      # The thing to note is that decryption algorithm
      # does not depend on the key wearlevelling mode.
      ht_key["s_wearlevelling_mode"]="mode_0"
      #----------
      return ht_key
   end # ht_generate_key_t1

   def Kibuvits_krl171_cryptcodec_txor_t1.ht_generate_key_t1(i_key_length,
      i_max_number_of_bytes_per_character=@@i_key_param_max_number_of_bytes_per_character)
      ht_key=Kibuvits_krl171_cryptcodec_txor_t1.instance.ht_generate_key_t1(
      i_key_length,i_max_number_of_bytes_per_character)
      return ht_key
   end # Kibuvits_krl171_cryptcodec_txor_t1.ht_generate_key_t1

   #-----------------------------------------------------------------------

   private

   def exc_verify_t1(bn,ht_key)
      kibuvits_krl171_typecheck bn, Hash, ht_key
      kibuvits_krl171_assert_ht_has_keys(bn,ht_key, [@s_lc_s_key_id,$kibuvits_krl171_lc_ar,$kibuvits_krl171_lc_i_m],
      "\n GUID='35a88cc5-a9b3-4c37-b104-c2c2f051a4e7'")
      ar=ht_key[$kibuvits_krl171_lc_ar]
      kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,
      [Fixnum,Bignum], ar,
      "\n GUID='7e2ecb6a-e2a5-4d18-9fd3-c2c2f051a4e7'")
      s_key_type=ht_key[@s_lc_s_key_type]
      if s_key_type!=@s_key_type_t1
         kibuvits_krl171_throw("s_key_type == "+s_key_type+" != "+@s_key_type_t1+
         "\n GUID='74461c58-7ab0-4386-b1a3-c2c2f051a4e7'")
      end # if
   end # exc_verify_t1


   #-----------------------------------------------------------------------

   public

   # http://longterm.softf1.com/specifications/progfte/
   def s_serialize_key(ht_key)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         exc_verify_t1(bn,ht_key)
      end # if
      ht=Hash.new
      ht_key.each_pair do |s_key,x_value|
         if s_key==$kibuvits_krl171_lc_ar
            ar_s=Array.new
            i_len=x_value.size
            b_not_first=false
            i_len.times do |ii|
               if b_not_first
                  ar_s<<$kibuvits_krl171_lc_pillar
               else
                  b_not_first=true
               end # if
               ar_s<<x_value[ii].to_s(16) # primitive data compression
            end # loop
            ht[$kibuvits_krl171_lc_ar]=kibuvits_krl171_s_concat_array_of_strings(ar_s)
         else
            ht[s_key]=x_value.to_s
         end # if
      end # loop
      ht[@s_lc_i_n_of_datasalt_digits]=ht_key[@s_lc_i_n_of_datasalt_digits].to_s
      ht[@s_lc_i_saltfree_data_max]=ht_key[@s_lc_i_saltfree_data_max].to_s
      s_out=Kibuvits_krl171_ProgFTE.from_ht(ht)
      return s_out
   end # s_serialize_key

   def Kibuvits_krl171_cryptcodec_txor_t1.s_serialize_key(ht_key)
      s_out=Kibuvits_krl171_cryptcodec_txor_t1.instance.s_serialize_key(ht_key)
      return s_out
   end # Kibuvits_krl171_cryptcodec_txor_t1.s_serialize_key

   #-----------------------------------------------------------------------

   def ht_deserialize_key(s_progfte)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_progfte
      end # if
      ht_out=Kibuvits_krl171_ProgFTE.to_ht(s_progfte)
      s_ar=ht_out[$kibuvits_krl171_lc_ar]
      ar_of_s=s_ar.split($kibuvits_krl171_lc_pillar)
      i_len=ar_of_s.size
      ar=Array.new
      i_len.times{|i| ar<<ar_of_s[i].to_i(16)}
      ht_out[$kibuvits_krl171_lc_ar]=ar
      ht_out[$kibuvits_krl171_lc_i_m]=ht_out[$kibuvits_krl171_lc_i_m].to_i
      ht_out[@s_lc_i_n_of_datasalt_digits]=ht_out[@s_lc_i_n_of_datasalt_digits].to_i
      ht_out[@s_lc_i_saltfree_data_max]=ht_out[@s_lc_i_saltfree_data_max].to_i
      return ht_out
   end # ht_deserialize_key

   def Kibuvits_krl171_cryptcodec_txor_t1.ht_deserialize_key(s_progfte)
      ht_out=Kibuvits_krl171_cryptcodec_txor_t1.instance.ht_deserialize_key(s_progfte)
      return ht_out
   end # Kibuvits_krl171_cryptcodec_txor_t1.ht_deserialize_key

   #-----------------------------------------------------------------------

   private

   def s_datasalt_t1(i_n_of_datasalt_digits,i_cleartext)
      s_out=""
      if i_cleartext!=0
         i_n_of_datasalt_digits.times{s_out<<Kibuvits_krl171_rng.i_random_fast_t1(9).to_s}
         return s_out
      end # if
      # <data><datasalt>
      # if data=="0" then the most significant digit of the
      # datasalt must not be 0, because otherwise
      #
      #     (00<the_rest_of_the_datasalt>).to_i
      #
      # will not have the specified amount of datasalt digits.
      #
      # Example of the failure:
      #
      #     data="0"   i_n_of_datasalt_digits=3 s_datasalt="042"
      #
      #     ("0"+"042").to_i="0042".to_i=42
      #
      i_n=i_n_of_datasalt_digits-1
      s_out<<(Kibuvits_krl171_rng.i_random_fast_t1(8)+1).to_s
      i_n.times{s_out<<Kibuvits_krl171_rng.i_random_fast_t1(9).to_s}
      return s_out
   end # s_datasalt_t1


   # The
   # ar_concat_all_strings_in_here_to_get_headerless_ciphertext is a speedhack.
   # If it weren't for the speedhack, the concatenation
   # of the elements of the
   # ar_concat_all_strings_in_here_to_get_headerless_ciphertext
   # would reside at the end of this function and the return
   # value would equal with the headerless ciphertext of the s_cleartext.
   # The end of this function shows an outcommented demo and
   # explains the return value.
   def ar_encrypt_wearlevelling_t1_core(s_cleartext,ht_key,
      ar_concat_all_strings_in_here_to_get_headerless_ciphertext=Array.new)
      ar_s=ar_concat_all_strings_in_here_to_get_headerless_ciphertext
      ar_unicode=s_cleartext.codepoints
      i_ar_unicode_len=ar_unicode.size
      i_m=ht_key[$kibuvits_krl171_lc_i_m]
      i_n_of_datasalt_digits=ht_key[@s_lc_i_n_of_datasalt_digits]
      i_saltfree_data_max=ht_key[@s_lc_i_saltfree_data_max]
      if i_saltfree_data_max<100
         # Encoding depends the availability of at least 1 digit
         # that can have any value between 0 and 9. The 100 is
         # taken with a small surplus, but the i_m is
         # determined in the key generation function, where
         # 1B i.e. 8b is minimum amount of data bits.
         # The 2 digits are related to the encoding of
         # the 1 packet in the quartet.
         kibuvits_krl171_throw("i_saltfree_data_max == "+i_saltfree_data_max.to_s+" < 100 "+
         "\n GUID='39c9ff4c-843e-4ade-a373-c2c2f051a4e7'")
      end # if
      ar_key=ht_key[$kibuvits_krl171_lc_ar]
      i_ar_key_len=ar_key.size
      if i_ar_key_len==0
         kibuvits_krl171_throw("GUID='0068f322-38e8-48c7-a543-c2c2f051a4e7'")
      end # if
      i_ar_key_ix_max=i_ar_key_len-1
      func_encrypt_0=lambda do |i_cleartext|
         # Cycling the key by incrementing the index
         # can lead to a situation, where the same
         # region of the key (same indexes of ar_key)
         # will encrypt some standard, publicly known,
         # header of the cleartext. To avoid revealing
         # the key by "painting/revealing parts of it" with a
         # standard header, the loop that calls this
         # lambda func_encrypt_0tion uses the classical trick, where
         # a candy/coin is placed under one of three upside-down
         # cups, except that instead of shuffling the cups,
         # http://www.youtube.com/watch?v=AZZi1SA90Io
         # the location of the candy/coin is written
         # under a 4. cup that has a known index within the quartet.
         # The other 2 cups will "hide" noise, randomly
         # generated data.
         # The hopping in memory does ignore
         # the locality based speed-optimization method,
         # but the excuse here is security and with flash
         # memories only the CPU cache is lost.
         #
         # The 3 cup solution also helps to secure the
         # secret a bit, when all of the cleartext characters
         # are the same.
         ix=Kibuvits_krl171_rng.i_random_fast_t1(i_ar_key_ix_max) # TODO: implement wearlevelling modes
         i_key=ar_key[ix]
         s_lambda_0=(i_cleartext.to_s<<s_datasalt_t1(i_n_of_datasalt_digits,i_cleartext))
         i_ciphertext=txor_encrypt(s_lambda_0.to_i,i_key,i_m)
         s_lambda_0=i_ciphertext.to_s(16) # primitive data compression
         s_ciphertext=ix.to_s+$kibuvits_krl171_lc_colon+s_lambda_0
         return s_ciphertext
      end # func_encrypt_0
      i_unicode=nil
      s_packet_real=nil
      s_packet_location=nil
      s_packet_hoax=nil
      i_location=nil
      i_location_masked=nil
      b_not_first=false
      ar_quartet=Array.new(4)
      s_0=nil
      i_ar_unicode_len.times do |i|
         if b_not_first
            # The meaning of the pillar here is that
            # it is a separator between packets,
            # not a bound of the packet at the tail or head of a packet.
            ar_s<<$kibuvits_krl171_lc_pillar
         else
            ar_s<<$kibuvits_krl171_lc_linebreak
            b_not_first=true
         end # if
         #-------
         # Introduction to the trickery here resides at
         # a comment of the lambda func_encrypt_0tion that is designated
         # by the variable func_encrypt_0 .
         i_location=Kibuvits_krl171_rng.i_random_fast_t1(2)+1
         # Index 0 of the ar_quartet is for storing the i_location,
         # which is converted to i_location_masked, which
         # has its least significant digit encoded like that
         #
         #           1== 0,1,2,3
         #           2== 4,5,6
         #           3== 7,8,9
         #
         s_0=Kibuvits_krl171_rng.i_random_fast_t1(i_saltfree_data_max).to_s
         s_0=s_0[0..(-2)]
         # s_0 can be "", because "7"[0..(-2)]==""
         case i_location
         when 1
            i_location_masked=(s_0+Kibuvits_krl171_rng.i_random_fast_t1(3).to_s).to_i
         when 2
            i_location_masked=(s_0+(Kibuvits_krl171_rng.i_random_fast_t1(2)+4).to_s).to_i
         when 3
            i_location_masked=(s_0+(Kibuvits_krl171_rng.i_random_fast_t1(2)+7).to_s).to_i
         else
            kibuvits_krl171_throw("GUID='293c8a54-8094-41b5-9503-c2c2f051a4e7'")
         end # case i_location
         #-------
         s_packet_location=((i*4).to_s+$kibuvits_krl171_lc_equalssign)
         ar_s<<(s_packet_location+func_encrypt_0.call(i_location_masked))
         #-------
         ar_s<<$kibuvits_krl171_lc_pillar
         i_unicode=ar_unicode[i]
         if i_location==1
            s_packet_real=((i*4+1).to_s+$kibuvits_krl171_lc_equalssign)
            ar_s<<(s_packet_real+func_encrypt_0.call(i_unicode))
         else
            s_packet_hoax=((i*4+1).to_s+$kibuvits_krl171_lc_equalssign)
            ar_s<<(s_packet_hoax+func_encrypt_0.call(Kibuvits_krl171_rng.i_random_fast_t1(i_saltfree_data_max)))
         end # if
         ar_s<<$kibuvits_krl171_lc_pillar
         if i_location==2
            s_packet_real=((i*4+2).to_s+$kibuvits_krl171_lc_equalssign)
            ar_s<<(s_packet_real+func_encrypt_0.call(i_unicode))
         else
            s_packet_hoax=((i*4+2).to_s+$kibuvits_krl171_lc_equalssign)
            ar_s<<(s_packet_hoax+func_encrypt_0.call(Kibuvits_krl171_rng.i_random_fast_t1(i_saltfree_data_max)))
         end # if
         ar_s<<$kibuvits_krl171_lc_pillar
         if i_location==3
            s_packet_real=((i*4+3).to_s+$kibuvits_krl171_lc_equalssign)
            ar_s<<(s_packet_real+func_encrypt_0.call(i_unicode))
         else
            s_packet_hoax=((i*4+3).to_s+$kibuvits_krl171_lc_equalssign)
            ar_s<<(s_packet_hoax+func_encrypt_0.call(Kibuvits_krl171_rng.i_random_fast_t1(i_saltfree_data_max)))
         end # if
         #-------------
         # Some text editors and e-mail clients are flawed,
         # their developers have been sloppy, in a way that they
         # the text editors and e-mail clients can not handle a
         # 1MiB text file that consists of a single line.
         # Hence the line-breaks here.
         ar_s<<$kibuvits_krl171_lc_linebreak
         # There's also an extra line-break at the very start
         # of the ar_s.
         #-------------
      end # loop

      # s_headerless_ciphertext=kibuvits_krl171_s_concat_array_of_strings(
      #     ar_concat_all_strings_in_here_to_get_headerless_ciphertext)
      #
      # return s_headerless_ciphertext # the general idea
      #
      return ar_concat_all_strings_in_here_to_get_headerless_ciphertext # speedhack
   end # ar_encrypt_wearlevelling_t1_core

   #-----------------------------------------------------------------------

   def s_decrypt_wearlevelling_t1_core(s_ciphertext,ht_key,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_ciphertext
         exc_verify_t1(bn,ht_key)
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='d34b7240-d902-43c4-85d2-c2c2f051a4e7'")
      end # if
      #--------------
      s_cleartext=$kibuvits_krl171_lc_equalssign
      s_ciphertext.gsub!($kibuvits_krl171_lc_linebreak,$kibuvits_krl171_lc_emptystring)
      ar_s_packets=s_ciphertext.split($kibuvits_krl171_lc_pillar)
      i_ar_s_packets_len=ar_s_packets.size
      if i_ar_s_packets_len%4!=0
         kibuvits_krl171_throw("Packets are required to form quartets."+
         "\n GUID='7591fe89-e9ac-44cd-84a2-c2c2f051a4e7'")
      end # if
      s_packet=nil
      s_packet_0=nil
      i_m=ht_key[$kibuvits_krl171_lc_i_m]
      ar_key=ht_key[$kibuvits_krl171_lc_ar]
      i_n_of_datasalt_digits=ht_key[@s_lc_i_n_of_datasalt_digits]
      ar_0=nil
      func_decrypt_0=lambda do |s_packet| #s_packet=="<ar_key[ix]>:<ciphertext>"
         ar_0=s_packet.split($kibuvits_krl171_lc_colon)
         ix=ar_0[0].to_i
         i_ciphertext=ar_0[1].to_i(16) # string form is encoded in hex
         i_key=ar_key[ix]
         i_cleartext_1=txor_decrypt(i_ciphertext,i_key,i_m)
         s_lambda_0=i_cleartext_1.to_s
         s_lambda_0=s_lambda_0[0..(-1-i_n_of_datasalt_digits)]
         i_cleartext=s_lambda_0.to_i  # "".to_i==0
         return i_cleartext
      end # func_decrypt_0
      i_qt_ix=0 #quartet index
      i_data_ix=0
      i_0=nil
      i_lsd=nil # lsd === "least significant digit"
      s_char=nil
      ar_s=Array.new
      func_decrypt_1=lambda do |ii|
         s_packet_0=ar_s_packets[ii]
         ar_0=s_packet_0.split($kibuvits_krl171_lc_equalssign)
         if ar_0.size!=2
            kibuvits_krl171_throw("ar_0.size=="+ar_0.size.to_s+
            "\n GUID='2395a633-1107-4b1c-a172-c2c2f051a4e7'")
         end # if
         s_packet=ar_0[1]
         i_00=func_decrypt_0.call(s_packet)
         return i_00
      end # lambda
      i_ar_s_packets_len.times do |i|
         if i_qt_ix==0
            i_0=func_decrypt_1.call(i)
            s_i_lsd=i_0.to_s
            i_lsd=s_i_lsd[(-1)..(-1)].to_i
            # The least significant digit (i_lsd) can only
            # be between 0 and 9, which is one out of 10 values.
            # The 10 values are almost equally divided to
            # 3 regions. A region determines the cup, under which
            # the actual data resides.
            if i_lsd<4
               i_data_ix=1
            else
               if i_lsd<7
                  i_data_ix=2
               else
                  i_data_ix=3
               end # if
            end # if
         end # if
         if i_qt_ix==1
            if i_data_ix==1
               i_unicode=func_decrypt_1.call(i)
               s_char="".concat(i_unicode) # necessary, can't use a constant
               ar_s<<s_char
            end # if
         end # if
         if i_qt_ix==2
            if i_data_ix==2
               i_unicode=func_decrypt_1.call(i)
               s_char="".concat(i_unicode) # necessary, can't use a constant
               ar_s<<s_char
            end # if
         end # if
         if i_qt_ix==3
            if i_data_ix==3
               i_unicode=func_decrypt_1.call(i)
               s_char="".concat(i_unicode) # necessary, can't use a constant
               ar_s<<s_char
            end # if
         end # if
         i_qt_ix=i_qt_ix+1
         i_qt_ix=0 if 3<i_qt_ix
      end # loop
      s_cleartext=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_cleartext
   end # s_decrypt_wearlevelling_t1_core

   #-----------------------------------------------------------------------

   public

   # The client code must verify, that the
   # ht_key["s_key_type"]=="kibuvits_krl171_series_of_whole_numbers_t1"
   # Otherwise this method throws an exception.
   #
   # The s_prefix_of_the_output_string is a considerable
   # speed-hack that is based on the following scheme:
   #
   #     s_armouring_header=s_prefix_of_the_output_string
   #     s_output=s_armouring_header+s_ciphertext_with_its_own_header
   #
   # The speed increase comes from avoiding
   #
   #     s_output=s_something_quite_short+s_something_very_long
   #
   # by using the kibuvits_krl171_s_concat_array_of_strings(...)
   # and this is not a joke, because the "s_something_very_long"
   # contains the whole encrypted message and really can be
   # a considerably long temporary string, taking up
   # tens of megabytes of memory.
   #
   # This crypto-algorithm is probably not affected
   # by quantum computer based attacks, because
   # it does not rely on any kind of factorization,
   # nor does it explicitly rely on the lack of knowledge about
   # some function.
   #
   def s_encrypt_wearlevelling_t1(s_cleartext,ht_key,
      s_prefix_of_the_output_string=$kibuvits_krl171_lc_emptystring,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=Kibuvits_krl171_cleartext_length_normalization.i_const_t1,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=(
      (i_estimated_median_of_lengths_of_nonnormalized_cleartexts.to_r/3).floor*2))
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         exc_verify_t1(bn,ht_key)
         kibuvits_krl171_typecheck bn, String, s_cleartext
         kibuvits_krl171_typecheck bn, Hash, ht_key
         kibuvits_krl171_typecheck bn, String, s_prefix_of_the_output_string
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_estimated_median_of_lengths_of_nonnormalized_cleartexts
         kibuvits_krl171_typecheck bn, [Fixnum,Bignum], i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='3d4957b8-a0cf-48bb-8442-c2c2f051a4e7'\n\n")
         kibuvits_krl171_assert_is_smaller_than_or_equal_to(bn,
         0, i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts,
         "\n GUID='e3fbdc5d-cf98-461e-8112-c2c2f051a4e7'\n\n")
      end # if
      #-----
      s_key_type=ht_key[@s_lc_s_key_type]
      if s_key_type!=@s_key_type_t1
         # The throw is used here because this
         # condition indicates that the code that
         # calls this decryption function is flawed,
         # is missing a proper key type verification.
         kibuvits_krl171_throw("ht_key[\"s_key_type\"] == "+s_key_type+
         " != "+@s_key_type_t1+
         "\n GUID='16335029-a960-441e-b1e1-c2c2f051a4e7'")
      end # if
      #-----
      ar_s=[s_prefix_of_the_output_string]
      ht_header=Hash.new
      ht_header["s_cryptocodec_type"]=@s_cryptocodec_type_t1
      ht_header[@s_lc_s_key_id]=ht_key[@s_lc_s_key_id]
      s_header=Kibuvits_krl171_ProgFTE.from_ht(ht_header)
      ar_s<<(s_header.length.to_s+$kibuvits_krl171_lc_pillar)
      ar_s<<(s_header+$kibuvits_krl171_lc_pillar)
      #-----------------
      b_use_fast_random=false
      s_cleartext_normalized=Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1(
      s_cleartext,i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
      b_use_fast_random,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts)
      #-----------------
      ar_encrypt_wearlevelling_t1_core(s_cleartext_normalized,ht_key,ar_s)
      s_ciphertext_with_header=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_ciphertext_with_header
   end # s_encrypt_wearlevelling_t1


   def Kibuvits_krl171_cryptcodec_txor_t1.s_encrypt_wearlevelling_t1(s_cleartext,ht_key,
      s_prefix_of_the_output_string=$kibuvits_krl171_lc_emptystring,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts=Kibuvits_krl171_cleartext_length_normalization.i_const_t1,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts=(
      (i_estimated_median_of_lengths_of_nonnormalized_cleartexts.to_r/3).floor*2))
      s_out=Kibuvits_krl171_cryptcodec_txor_t1.instance.s_encrypt_wearlevelling_t1(
      s_cleartext,ht_key,s_prefix_of_the_output_string,
      i_estimated_median_of_lengths_of_nonnormalized_cleartexts,
      i_estimated_standard_deviation_of_lengths_of_nonnormalized_cleartexts)
      return s_out
   end # Kibuvits_krl171_cryptcodec_txor_t1.s_encrypt_wearlevelling_t1

   #-----------------------------------------------------------------------

   def s_decrypt_wearlevelling_t1(s_ciphertext_with_header,ht_key,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_ciphertext_with_header
         exc_verify_t1(bn,ht_key)
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID='b46e775b-3abc-42f4-81b1-c2c2f051a4e7'")
      end # if
      #--------------
      s_out=$kibuvits_krl171_lc_emptystring
      s_header_progfte,s_ciphertext=Kibuvits_krl171_str.s_s_bisect_by_header_t1(
      s_ciphertext_with_header,msgcs)
      return s_out if msgcs.b_failure
      #--------------
      ht=Kibuvits_krl171_ProgFTE.to_ht(s_header_progfte)
      s_cryptocodec_type=ht["s_cryptocodec_type"]
      if s_cryptocodec_type!=@s_cryptocodec_type_t1
         s_default_msg="s_cryptocodec_type == "+s_cryptocodec_type+
         " != "+@s_cryptocodec_type_t1
         s_message_id="cryptocodec_mismatch_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "3fbe1416-7dab-4ee4-a272-c2c2f051a4e7")
         return s_out
      end # if
      #-----
      s_key_type=ht_key[@s_lc_s_key_type]
      if s_key_type!=@s_key_type_t1
         # The throw is used here because this
         # condition indicates that the code that
         # calls this decryption function is probably,
         # but not necessarily, flawed. The existence of the
         # flaw is somewhat questionable, because
         # if only one type of cryptcodec is used, then
         # there's no point of verifying the key type.
         kibuvits_krl171_throw("ht_key[\"s_key_type\"] == "+s_key_type+
         " != "+@s_key_type_t1+
         "\n GUID='b1a9860c-4b05-4a97-af81-c2c2f051a4e7'")
      end # if
      #-----
      # The key ID verification has to be _after_ the
      # key type verification, because a key of wrong type
      # probably fails ID verification and if the ID verification
      # is before key type verification, the flaw that
      # causes the key type mismatch is not hinted.
      s_key_id_0=ht_key[@s_lc_s_key_id]
      s_key_id_1=ht[@s_lc_s_key_id]
      if s_key_id_0!=s_key_id_1
         s_default_msg="The ID of the key is == "+s_key_id_0+
         "\n, but the ciphertext has been encrypted with a "+
         "key that has an ID of \n"+s_key_id_1+
         $kibuvits_krl171_lc_doublelinebreak
         s_message_id="decrytion_key_mismatch_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "2d5ae435-7ccb-4408-9e12-c2c2f051a4e7")
         return s_out
      end # if
      ht.clear
      #--------------
      s_cleartext_normalized=s_decrypt_wearlevelling_t1_core(s_ciphertext,ht_key,msgcs)
      s_cleartext=Kibuvits_krl171_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
      s_cleartext_normalized,msgcs)
      s_out=s_cleartext
      return s_out
   end # s_decrypt_wearlevelling_t1

   def Kibuvits_krl171_cryptcodec_txor_t1.s_decrypt_wearlevelling_t1(s_ciphertext_with_header,ht_key,msgcs)
      s_out=Kibuvits_krl171_cryptcodec_txor_t1.instance.s_decrypt_wearlevelling_t1(
      s_ciphertext_with_header,ht_key,msgcs)
      return s_out
   end # Kibuvits_krl171_cryptcodec_txor_t1.s_decrypt_wearlevelling_t1

   #-----------------------------------------------------------------------
   include Singleton

end # class Kibuvits_krl171_cryptcodec_txor_t1
#=====================kibuvits_krl171_cryptcodec_txor_t1_rb_end===================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_cryptcodec_txor_t1_rb_start".
#==========================================================================

#=====================kibuvits_krl171_data_transfer_rb_start======================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_data_transfer_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_coords.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_fs.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_shell.rb"

#==========================================================================

class Kibuvits_krl171_data_transfer

   def initialize
   end #initialize

   #----------------------------------------------------------------------

   # Equivalent to
   #     cp -f -R $s_fp_origin $s_fp_destination_folder/
   def exc_rsync_t1(s_fp_destination_folder,s_fp_origin)
      if !File.exists? s_fp_origin
         kibuvits_krl171_throw("\nFile or folder \n"+s_fp_origin+
         "\ndoes not exist. GUID='af3ecd54-cc65-40bb-9351-c2c2f051a4e7'\n")
      end # if
      s_output_message_language=$kibuvits_krl171_lc_English
      b_throw=true;
      #----------
      s_spec="writable,is_directory"
      ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(s_fp_destination_folder,s_spec)
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language, b_throw)
      #----------
      s_spec="readable,is_directory"
      ht_filesystemtest_failures=Kibuvits_krl171_fs.verify_access(s_fp_origin,s_spec)
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language, b_throw)
      #----------
      s_fp_dest=Pathname.new(s_fp_destination_folder).realpath.to_s
      s_fp_dest=s_fp_dest.gsub(/[\/]+/,$kibuvits_krl171_lc_slash)
      s_fp_dest.sub!(/[\/]+$/,$kibuvits_krl171_lc_emptystring)

      s_orig=Pathname.new(s_fp_origin).realpath.to_s
      s_orig=s_orig.gsub(/[\/]+/,$kibuvits_krl171_lc_slash)
      s_orig.sub!(/[\/]+$/,$kibuvits_krl171_lc_emptystring)
      #----------
      if s_orig==s_fp_dest
         kibuvits_krl171_throw("\n s_orig == s_fp_dest = \""+s_fp_dest +
         "\"\n but the rsync does not throw on that."+
         "\n GUID='36faeb50-cff5-4129-b521-c2c2f051a4e7'\n")
      end # if
      #----------
      cmd="nice -n2 rsync -avz --delete "+s_orig+
      ($kibuvits_krl171_lc_space+s_fp_dest +" ;")
      ht_stdstreams=kibuvits_krl171_sh(cmd)
      s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
      s_stderr=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]
      if 10<s_stdout.length
         if s_stdout.match(" speedup is ")==nil
            kibuvits_krl171_throw("\ncmd=\""+cmd+
            "\"\n s_stdout=\""+s_stdout+"\""+
            "\n GUID='5684c516-d7db-47c3-81f0-c2c2f051a4e7'\n")
         end # if
      end # if
      if 0<s_stderr.length
         kibuvits_krl171_throw("\ncmd=\""+cmd+
         "\"\n s_stderr=\""+s_stderr+"\""+
         "\n GUID='0fed6d18-adfc-4ef6-93b0-c2c2f051a4e7'\n")
      end # if
   end # exc_rsync_t1

   def Kibuvits_krl171_data_transfer.exc_rsync_t1(s_fp_destination_folder,s_fp_origin)
      Kibuvits_krl171_data_transfer.instance.exc_rsync_t1(s_fp_destination_folder,s_fp_origin)
   end # Kibuvits_krl171_data_transfer.exc_rsync_t1

   #----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_krl171_data_transfer
#=====================kibuvits_krl171_data_transfer_rb_end========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_data_transfer_rb_start".
#==========================================================================

#=====================kibuvits_krl171_ImageMagick_rb_start========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_ImageMagick_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_coords.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_fs.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_shell.rb"

#==========================================================================

# Command-line utilities used from the ImageMagic package:
# identify,  convert
class Kibuvits_krl171_ImageMagick

   def initialize
      @ar_img_file_globstrings=["*.jpeg","*.JPEG","*.jpg","*.JPG"]
      @ar_img_file_globstrings.concat(["*.eps","*.EPS","*.gif","*.GIF"])
      @ar_img_file_globstrings.concat(["*.png","*.PNG","*.bmp","*.BMP"])
      @ar_img_file_globstrings.concat(["*.pnm","*.PNM","*.cur","*.CUR"])
      @ar_img_file_globstrings.concat(["*.icon","*.ICON","*.dng","*.DNG"])
      @ar_img_file_globstrings.concat(["*.miff","*.MIFF","*.palm","*.PALM"])
      @ar_img_file_globstrings.concat(["*.jp2","*.JP2","*.sun","*.SUN"])
      @ar_img_file_globstrings.concat(["*.xpm","*.XPM","*.xbm","*.XBM"])
      @ar_img_file_globstrings.concat(["*.tiff","*.TIFF","*.vicar","*.VICAR"])
   end #initialize

   private

   public

   #-----------------------------------------------------------------------

   # The content of the ht_out will not be cleared, but it will be
   # overwritten. The ht_out exists for instance reuse.
   #
   # Keys of the output hashtable: b_is_imagefile, i_width, i_height, s_fp
   #
   # If b_is_imagefile==false, then i_width and i_heigth may be undefined
   # or have sone unspecified values.
   #
   def ht_image_info(s_image_file_full_path, ht_out=Hash.new)
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn, String, s_image_file_full_path
         kibuvits_krl171_typecheck bn, Hash, ht_out
         ht_stdstreams=kibuvits_krl171_sh("which identify ")
         s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
         if s_stdout.length==0
            kibuvits_krl171_throw("\nThe ImageMagick command line tool, \"identify\", "+
            "is not at the PATH.\nGUID=='38af94e4-7391-45ac-9480-c2c2f051a4e7'\n")
         end # if
      end # if
      s_language=$kibuvits_krl171_lc_English
      kibuvits_krl171_assert_string_min_length(bn,s_image_file_full_path,3,
      "\nGUID=='9f4e023e-2867-4ea5-a550-c2c2f051a4e7'\n")

      s_spec="is_file,readable"
      ht_failures=Kibuvits_krl171_fs.verify_access(s_image_file_full_path,s_spec)
      Kibuvits_krl171_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures,
      s_language,b_throw=true)
      s_message_id="file_access"
      if ht_failures.length!=0
         s_err_msg=Kibuvits_krl171_fs.access_verification_results_to_string(
         ht_failures,s_language)+"\nGUID=='b6707c2d-7f08-4486-9520-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err_msg)
      end # if

      s_fp=Pathname.new(s_image_file_full_path).realpath.to_s
      ht_out[$kibuvits_krl171_lc_s_fp]=s_fp

      s_fp_cmd=Kibuvits_krl171_str.s_escape_for_bash_t1(s_fp)
      ht_stdstreams=kibuvits_krl171_sh("identify "+s_fp_cmd)
      s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
      s_stderr=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]

      ht_out[$kibuvits_krl171_lc_b_is_imagefile]=true
      if (s_stderr.match("no decode delegate"))!=nil
         ht_out[$kibuvits_krl171_lc_b_is_imagefile]=false
         return ht_out
      end # if

      if 0<s_stderr.length
         s_err_msg="\ns_stderr=="+s_stderr+
         "\nGUID=='238902f4-cc5a-40e1-9f2f-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err_msg)
      end # if

      # Sample output:
      #./uhuu.bmp BMP 3264x2448 3264x2448+0+0 8-bit DirectClass 23.97MB 0.040u 0:00.050
      rgx_size=/[\s][\d]+x[\d]+[\s]/
      md=s_stdout.match(rgx_size)
      if md==nil
         s_err_msg="\nmd==nil\nGUID=='ba225804-12a1-4788-892c-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err_msg)
      end # if

      s_size_haystack=md[0] # " 3264x2448 "
      i_0=s_size_haystack.index("x")
      # http://longterm.softf1.com/specifications/array_indexing_by_separators/
      ixs_high=i_0
      ixs_low=1
      if ixs_high<=ixs_low
         s_err_msg="ixs_high == "+ixs_high.to_s+" <= ixs_low == "+ixs_low.to_s+
         "\nGUID=='520319f1-9e7c-4b11-9929-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err_msg)
      end # if
      s_width=s_size_haystack[ixs_low,(ixs_high-1)]
      ht_out[$kibuvits_krl171_lc_i_width]=s_width.to_i

      ixs_low=i_0+1 # +1 due to the "x"
      ixs_high=s_size_haystack.length-1 # -1 due to the ending space
      if ixs_high<=ixs_low
         s_err_msg="ixs_high == "+ixs_high.to_s+" <= ixs_low == "+ixs_low.to_s+
         "\nGUID=='7e23ec8b-331e-4686-a926-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err_msg)
      end # if
      s_height=s_size_haystack[ixs_low,(ixs_high-1)]
      ht_out[$kibuvits_krl171_lc_i_height]=s_height.to_i
      return ht_out
   end # ht_image_info

   def Kibuvits_krl171_ImageMagick.ht_image_info(s_image_file_full_path,ht_out=Hash.new)
      ht_out=Kibuvits_krl171_ImageMagick.instance.ht_image_info(
      s_image_file_full_path,ht_out)
      return ht_out
   end # Kibuvits_krl171_ImageMagick.ht_image_info(s_image_file_full_path)

   #-----------------------------------------------------------------------

   public

   include Singleton

end # class Kibuvits_krl171_ImageMagick
#=====================kibuvits_krl171_ImageMagick_rb_end==========================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_ImageMagick_rb_start".
#==========================================================================

#=====================kibuvits_krl171_REDUCE_rb_start=============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_REDUCE_rb_end".
#==========================================================================
#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2015, martin.vahi@softf1.com that has an
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

if !defined? KIBUVITS_krl171_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_krl171_HOME_b_fs=ob_pth_1.to_s
   #require(s_KIBUVITS_krl171_HOME_b_fs+"/src/include/kibuvits_krl171_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_krl171_HOME_b_fs=nil
end # if

#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_fs.rb"
#require  KIBUVITS_krl171_HOME+"/src/include/kibuvits_krl171_shell.rb"

#==========================================================================

# Command-line utilities for interacting with
# the REDUCE Computer Algebra System
#
#     http://www.reduce-algebra.com/
#
# Copy of the REDUCE doc:
#
#     http://longterm.softf1.com/2014/2014_11_30_REDUCE_Computer_Algebra_System_doc_csl/
#
# There MIGHT be a copy of the REDUCE src at:
#
#     http://technology.softf1.com/software_by_third_parties/REDUCE_Computer_Algebra_System/
#
class Kibuvits_krl171_REDUCE

   def initialize
      @s_lc_run_reduce="`which reduce` ".freeze
      @s_lc_endoffileread_t1="*** End-of-file read".freeze
      #--------
      #    nat off;
      #    solve({x2+x1^4+1=44,x1+7=924},{x1,x2});
      @s_lc_solve_start_t1="off nat$\n a:=solve({\n".freeze
      @s_lc_solve_middle_t1="\n},{\n".freeze
      @s_lc_solve_end_t1=("\n})$\n"+
      "ialen:=(length a)$\n"+
      "%ialen;\n"+
      "if 0<ialen then begin \n"+
      "    b:=first a $\n % write b;\n"+
      "    foreach x in b do write x $\n"+
      "end else $"+
      "").freeze
      #--------
   end #initialize

   private

   # This function exists to cache results of the the slow
   # environment studying activity. It is a compromise
   # for speed by leaving things to crash at a time, when
   # the REDUCE disappears from PATH during the execution
   # of the code of this class.
   def b_REDUCE_available
      if !defined? @b_REDUCE_available_cache
         @b_REDUCE_available_cache=Kibuvits_krl171_shell.b_available_on_path("reduce")
      else
         if !@b_REDUCE_available_cache
            @b_REDUCE_available_cache=Kibuvits_krl171_shell.b_available_on_path(
            "reduce")
         end # if
      end # if
      return @b_REDUCE_available_cache
   end # b_REDUCE_available


   # REDUCE does not write all errors to stderr
   # In a normal situation the CSL version
   # of REDUCE outputs the following text:
   #
   # Reduce (Free CSL version), 15-Jan-15 ...
   # *** End-of-file read
   #
   def b_REDUCE_stdout_contains_an_error_message(s_stdout)
      s_0=s_stdout.gsub(@s_lc_endoffileread_t1,$kibuvits_krl171_lc_emptystring)
      # Error conditions tend to have more stars than 3
      s_1=s_0.gsub(/[*]/,$kibuvits_krl171_lc_emptystring)
      return true if s_1.length!=s_0.length
      return false
   end # b_REDUCE_stdout_contains_an_error_message


   public

   #-----------------------------------------------------------------------

   # Generates REDUCE source that has a structure of
   #
   #     out "<full path to a temporary file>"
   #     <the value of the s_reduce_source>
   #     shut "<full path to a temporary file>"
   #
   # writes the generated source to a temporary text-file and runs
   # REDUCE as a console application with the generated, temporary
   # REDUCE source file.
   #
   # After the REDUCE exits, the temporary files are deleted
   # and a string with the content of the temporary file
   # that captured the REDUCE output is returned.
   #
   # If REDUCE is not on PATH, an empty string is returned
   # and an error message is placed to the msgcs.
   #
   # If REDUCE produced anything to the stderr or crashes,
   # then a failure message is placed to msgcs and the
   # failure message is accompanied with the
   # ht_stdstreams that has its format defined in the
   # kibuvits_krl171_shell.rb.
   #
   def s_run_by_source(s_reduce_source,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, String, s_reduce_source
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID=='4cf48511-4a1c-4b5e-be53-c2c2f051a4e7'")
      end # if
      if !b_REDUCE_available()
         s_default_msg="REDUCE Computer Algebra System "+
         "is missing from the PATH."
         s_message_id="REDUCE_missing_from_PATH_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "31f0fe54-fbf7-4ab9-a4b1-c2c2f051a4e7")
         return $kibuvits_krl171_lc_emptystring
      end # if
      s_fp_source=Kibuvits_krl171_os_codelets.generate_tmp_file_absolute_path()
      s_fp_reduce_output=Kibuvits_krl171_os_codelets.generate_tmp_file_absolute_path()
      #--------
      ar_s=Array.new
      ar_s<<"out \""
      ar_s<<s_fp_reduce_output
      s_lc_0="\"$\n\n"
      ar_s<<s_lc_0
      ar_s<<s_reduce_source
      ar_s<<"\n\nshut \""
      ar_s<<s_fp_reduce_output
      ar_s<<s_lc_0
      s_reduce_src_updated=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      #--------
      s_out=$kibuvits_krl171_lc_emptystring
      begin
         str2file(s_reduce_src_updated,s_fp_source)
         cmd=@s_lc_run_reduce+s_fp_source
         ht_stdstreams=kibuvits_krl171_sh(cmd)
         #----------------
         # REDUCE writes some errors to stdout without
         # writing anything to the stderr.
         s_stdout=ht_stdstreams[$kibuvits_krl171_lc_s_stdout]
         b_err_by_stdout=b_REDUCE_stdout_contains_an_error_message(s_stdout)
         b_err_by_stderr=Kibuvits_krl171_shell.b_stderr_has_content_t1(ht_stdstreams)
         if b_err_by_stdout||b_err_by_stderr
            s_stderr=ht_stdstreams[$kibuvits_krl171_lc_s_stderr]
            s_default_msg="The Bash command line \n"+cmd+
            "\nwrote the following to the "
            if b_err_by_stderr
               s_default_msg<<"stderr:\n"
               s_default_msg<<s_stderr+$kibuvits_krl171_lc_doublelinebreak
            end # if
            if b_err_by_stdout
               s_default_msg<<"stdout:\n"
               s_default_msg<<s_stdout+$kibuvits_krl171_lc_doublelinebreak
            end # if
            s_default_msg<<"\n\nGUID=='6e5d3b85-5c08-466c-a550-c2c2f051a4e7'"
            s_message_id="REDUCE_run_failed_t1"
            b_failure=true
            msgcs.cre(s_default_msg,s_message_id,b_failure,
            "7bb2131f-c264-4a6b-9551-c2c2f051a4e7")
            msgc=msgcs.last
            msgc.x_data=ht_stdstreams
         end # if
      rescue Exception => e
         s_default_msg="Something went wrong.\n\n"+e.to_s+
         "\n\nGUID=='a201411c-20b3-452d-bffd-c2c2f051a4e7'"
         s_message_id="REDUCE_run_failed_t2"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "18392d67-b592-4937-83f0-c2c2f051a4e7")
      end # rescue
      File.delete s_fp_source if File.exists? s_fp_source
      if File.exists? s_fp_reduce_output
         if !msgcs.b_failure
            s_out=file2str(s_fp_reduce_output)
         end # if
         File.delete s_fp_reduce_output
      end # if
      return s_out
   end # s_run_by_source


   def Kibuvits_krl171_REDUCE.s_run_by_source(s_reduce_source,msgcs)
      s_out=Kibuvits_krl171_REDUCE.instance.s_run_by_source(s_reduce_source,msgcs)
      return s_out
   end # Kibuvits_krl171_REDUCE.s_run_by_source


   #--------------------------------------------------------------------------

   private

   def ht_solve_system_of_equations_t1_assemble_REDUCE_source(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed)
      #---------------
      # The normalization is to handle cases like
      #
      # fish, ,   , ,shark,whale, ,   ,,dolphin,,,,crab,jellyfish,,,
      #
      # (Please pay attention to the varying number of spaces
      #  between the commas)
      #
      # It could be done with regexes, but the solution with
      # regexes is method specific and this method here
      # is not called often enough to justify the hack, not
      # to mention the fact that the more general methods here
      # have elaborate selftests that the code with regexes
      # would not have.
      s_separator=","
      ar_eq=Kibuvits_krl171_str.normalize_s2ar_t1(
      s_or_ar_equations_in_reduce_format,s_separator)
      ar_var=Kibuvits_krl171_str.normalize_s2ar_t1(
      s_or_ar_variables_to_be_expressed,s_separator)
      #----
      s_separator=",\n"
      s_eq=Kibuvits_krl171_str.array2xseparated_list(ar_eq,s_separator)
      s_var=Kibuvits_krl171_str.array2xseparated_list(ar_var,s_separator)
      #---------------
      # REDUCE code format example:
      #
      #     off nat$
      #     solve({x2+x1^4+1=44,x1+7=924},{x1,x2})$
      #     b:=first a$
      #     foreach x in b do write x$
      #---------------
      ar_s=Array.new
      ar_s<<@s_lc_solve_start_t1 # "solve({\n"
      ar_s<<s_eq
      ar_s<<@s_lc_solve_middle_t1 # "\n},{\n"
      ar_s<<s_var
      ar_s<<@s_lc_solve_end_t1 # "\n})$\n"
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_s)
      return s_out
   end # ht_solve_system_of_equations_t1_assemble_REDUCE_source


   def ht_solve_system_of_equations_t1_parse_reduce_output(
      s_reduce_output,msgcs)
      s_0=s_reduce_output.gsub(/[$]$/,$kibuvits_krl171_lc_emptystring)
      ht_out=Kibuvits_krl171_configfileparser_t1.ht_parse_configstring(s_0,msgcs)
      return ht_out
   end # ht_solve_system_of_equations_t1_parse_reduce_output


   public

   # Uses the REDUCE "solve" command.
   # http://longterm.softf1.com/2014/2014_11_30_REDUCE_Computer_Algebra_System_doc_csl/r38_0150.html#r38_0179
   #
   # If the s_or_ar_equations_in_reduce_format is a string, then
   # it is expected to be the commaseparated list of equations
   # that the REDUCE solve command uses.
   #
   # An example of valid REDUCE code:
   #
   #     solve({x2+x1^4+1=44,x1+7=924},{x1,x2});
   #
   # The output hashtable can be empty, specially if the
   # s_or_ar_variables_to_be_expressed lists too few variables.
   # If the output hashtable is not empty, then the keys of the
   # hashtable are the variable names that were listed at the
   #
   #     s_or_ar_variables_to_be_expressed
   #
   # and the values of the hashtable contain formulaes that
   # can contian REDUCE specific values "root_of", "arbint", "arbcomplex".
   def ht_solve_system_of_equations_t1(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed,msgcs)
      if KIBUVITS_krl171_b_DEBUG
         bn=binding()
         kibuvits_krl171_typecheck bn, [String,Array], s_or_ar_equations_in_reduce_format
         kibuvits_krl171_typecheck bn, [String,Array], s_or_ar_variables_to_be_expressed
         kibuvits_krl171_typecheck bn, Kibuvits_krl171_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID=='4ec628a3-e071-4ed2-b72b-c2c2f051a4e7'")
         if s_or_ar_equations_in_reduce_format.class==Array
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,String,
            s_or_ar_equations_in_reduce_format,
            "GUID=='44895ae1-96d6-42e0-ac58-c2c2f051a4e7'")
         end # if
         if s_or_ar_variables_to_be_expressed.class==Array
            kibuvits_krl171_assert_ar_elements_typecheck_if_is_array(bn,String,
            s_or_ar_variables_to_be_expressed,
            "GUID=='c2f622e5-4832-4978-9736-c2c2f051a4e7'")
         end # if
      end # if
      s_reduce_source=ht_solve_system_of_equations_t1_assemble_REDUCE_source(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed)
      s_reduce_output=s_run_by_source(s_reduce_source,msgcs)
      return Hash.new if msgcs.b_failure
      ht_out=ht_solve_system_of_equations_t1_parse_reduce_output(
      s_reduce_output,msgcs)
      return ht_out
   end # ht_solve_system_of_equations_t1


   def Kibuvits_krl171_REDUCE.ht_solve_system_of_equations_t1(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed,msgcs)
      ht_out=Kibuvits_krl171_REDUCE.instance.ht_solve_system_of_equations_t1(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed,msgcs)
      return ht_out
   end # Kibuvits_krl171_REDUCE.ht_solve_system_of_equations_t1

   #--------------------------------------------------------------------------


   public
   include Singleton

end # class Kibuvits_krl171_REDUCE
#=====================kibuvits_krl171_REDUCE_rb_end===============================
# The start of the file inclusion can be found
# by looking for the string "kibuvits_krl171_REDUCE_rb_start".
#==========================================================================

#--------------------KRL_based_boilerplate_end-----------------------------
# You may look for a string "KRL_based_boilerplate_start"
# to naviate to the start of that boilerplate.
#--------------------------------------------------------------------------

# To make this code compact and self-contained,
# many practical tests have been omitted.
class File_extensions_2_JavaScript_regex_subpart_t1_implementation_0

   def initialize
   end # initialize

   #-----------------------------------------------------------------------

   public

   # "doc|jpeg|foo" --> "[dD][oO][cC]|[jJ][pP][eE][gG]|[fF][oO][oO]
   def s_extensions_2_regex_subpart(s_extensions)
      #--------------------------------------------------------------------
      bn=binding()
      kibuvits_krl171_typecheck bn,[String],s_extensions
      #--------------------------------------------------------------------
      s_in=s_extensions
      rgx_doubleor=/[|]{2}/
      rgx_or=/[|]{1}/
      #--------------------------------------------------------------------
      md=s_in.match(rgx_doubleor)
      if md!=nil
         s_err="\nThe \n"+s_in+
         "\ncontained \"||\", which is probably a mistake.\n"+
         "GUID='137be505-9840-43bd-8649-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err,bn)
      end # if
      s_0=("|"+s_in+"|").gsub(/[|]+/,"|") # "doc|jpeg|foo|" --> "|doc|jpeg|foo|"
      md=s_0.match(rgx_doubleor)
      if md!=nil
         s_err="\nThis code is flawed.\n"+
         "GUID='d21a8ab9-2afd-402b-8636-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err,bn)
      end # if
      #-------------
      if s_0.length==2 # s_0=="||"
         s_err="\n s_extensions==\""+s_extensions+"\"\n"+
         "GUID='3f1f63e5-4537-499f-ace3-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err,bn)
      end # if
      #-------------
      # "|doc|foo|" --> "doc|foo|"
      # "|h|" --> "h|"
      s_1=s_0[1..(-1)]
      #-------------
      # "doc|foo|" --> ["doc|","foo|"]
      # "h|"       --> ["h"]
      ar_0=s_1.scan(/[\w\d]+[|]/)
      #-------------
      # ["doc|","foo|"] --> ["doc","foo"]
      ar_1=Array.new
      s_ext_0=nil
      i_len_ar_0=ar_0.length
      i_len_ar_0.times do |ix|
         s_ext_0=(ar_0[ix])[0..(-2)]
         ar_1<<s_ext_0
      end # loop
      #--------------------------------------------------------------------
      # ["doc","foo"] --> ["[dD][oO][cC]", "[fF][oO][oO]"]
      #--------------------------------------------------------------------
      func_s_2_caseless_regex=lambda do |s_ext_in| # "foo" -> "[fF][oO][oO]"
         #-------------
         if KIBUVITS_krl171_b_DEBUG
            bn_0=binding()
            kibuvits_krl171_typecheck bn,[String],s_ext_in
         end # if
         i_len_s_ext_in=s_ext_in.length
         if i_len_s_ext_in==0
            kibuvits_krl171_throw("GUID='d1b012f7-b26e-4ed1-a530-c2c2f051a4e7'")
         end # if
         #-------------
         s_out=""
         s_char=nil
         i_len_s_ext_in.times do |ix| # starts to count from 0
            s_char=s_ext_in[ix..ix]
            s_out<<$kibuvits_krl171_lc_lsqbrace
            s_out<<s_char.downcase
            s_out<<s_char.upcase
            s_out<<$kibuvits_krl171_lc_rsqbrace
         end # loop
         return s_out
      end # func_s_2_caseless_regex
      #--------------------------------------------------------------------
      if ar_1.length!=i_len_ar_0
         kibuvits_krl171_throw("GUID='1a39f903-2599-4443-ad2c-c2c2f051a4e7'")
      end # if
      ar_2=Array.new
      s_ext=nil
      s_ext_rgx=nil
      b_nonfirst=false
      i_len_ar_0.times do |ix|
         ar_2<<$kibuvits_krl171_lc_pillar if b_nonfirst # to avoid ["h"] -> ["[hH]|"]
         s_ext=ar_1[ix]
         s_ext_rgx=func_s_2_caseless_regex.call(s_ext)
         ar_2<<s_ext_rgx
         b_nonfirst=true
      end # loop
      s_out=kibuvits_krl171_s_concat_array_of_strings(ar_2)
      return s_out
      #--------------------------------------------------------------------
   end # s_extensions_2_regex_subpart

   #-----------------------------------------------------------------------

   private

   def init_testdata_ht_testdata_pairs_01
      return if defined? @ht_testdata_pairs_01
      @ht_testdata_pairs_01=Hash.new
      ht=@ht_testdata_pairs_01
      ht[""]=""
      ht["a"]="[aA]"
      ht["aa"]="[aA][aA]"
      ht["ab"]="[aA][bB]"
      ht["ab|cd"]="[aA][bB]|[cC][dD]"
      ht["ab|cd|cd"]="[aA][bB]|[cC][dD]|[cC][dD]"
      ht["ab|cd|cd|ab"]="[aA][bB]|[cC][dD]|[cC][dD]|[aA][bB]"
   end # init_testdata_ht_testdata_pairs_01

   #-----------------------------------------------------------------------

   public

   def exc_run_tests_s_extensions_2_regex_subpart
      #--------------------------------------------------------------------
      func_run_passing_test=lambda do |s_in_extensions,s_out_expected|
         s=s_extensions_2_regex_subpart(s_in_extensions)
         if s!=s_out_expected
            kibuvits_krl171_throw("\nTest failed.\n"+
            "s_in_extensions=="+s_in_extensions+"\n"+
            "s=="+s+"\n"+
            "s_out_expected=="+s_out_expected+"\n"+
            "GUID='164b8073-dcf9-433d-a029-c2c2f051a4e7'\n")
         end # if
      end # func_run_passing_test
      #--------------------------------------------------------------------
      func_run_failing_test=lambda do |s_in_extensions|
         b=kibuvits_krl171_block_throws do
            s=s_extensions_2_regex_subpart(s_in_extensions)
         end # block
         if !b
            kibuvits_krl171_throw("\nTest failed. An exception was expected, \n"+
            "but no exception was thrown.\n"+
            "s_in_extensions=="+s_in_extensions+"\n"+
            "GUID='4e0ccce4-8571-4465-9d66-c2c2f051a4e7'\n")
         end # if
      end # func_run_failing_test
      #--------------------------------------------------------------------
      init_testdata_ht_testdata_pairs_01()
      ht=@ht_testdata_pairs_01
      ht.each_pair do |s_extensions,s_regex_subpart|
         func_run_passing_test.call(s_extensions,s_regex_subpart)
         func_run_passing_test.call(s_extensions+"|",s_regex_subpart)
         func_run_passing_test.call("|"+s_extensions,s_regex_subpart)
         if s_extensions!=$kibuvits_krl171_lc_emptystring
            func_run_passing_test.call("|"+s_extensions+"|",s_regex_subpart)
         end # if
      end # loop
      #--------------------------------------------------------------------
      func_run_failing_test.call("||")
      func_run_failing_test.call("||aa")
      func_run_failing_test.call("||aa||")
      func_run_failing_test.call("||aa|bb||")
      func_run_failing_test.call("|aa||bb|")
      func_run_failing_test.call("aa||bb")
      #--------------------------------------------------------------------
   end # exc_run_tests_s_extensions_2_regex_subpart

   #-----------------------------------------------------------------------

   # "[dD][oO][cC]|[jJ][pP][eE][gG]|[fF][oO][oO]" --> "doc|jpeg|foo"
   def s_regex_subpart_2_extensions(s_regex_subpart)
      bn=binding()
      if KIBUVITS_krl171_b_DEBUG
         kibuvits_krl171_typecheck bn,[String],s_regex_subpart
      end # if
      s_in=s_regex_subpart
      rgx_doubleor=/[|]{2}/
      md=s_in.match(rgx_doubleor)
      if md!=nil
         s_err="\nThe \n"+s_in+
         "\ncontained \"||\", which is a mistake.\n"+
         "GUID='453e75ed-f838-4267-9923-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err,bn)
      end # if
      #-------------
      # irb(main):016:0> puts s_2
      # [[a][bB][c]][11]
      # => nil
      # irb(main):017:0> rgx
      # => /[\[][\w]{2}[\]]/
      # irb(main):018:0> s_2.scan(rgx)
      # => ["[bB]", "[11]"]
      # irb(main):019:0>
      rgx_char_in_regex=/[\[][\w]{2}[\]]/ # also matches "[11]"
      ar_0=s_in.scan(rgx_char_in_regex) # "[aA][bB]|[cC]" -> ["[aA]","[bB]","[cC]"]
      i_ar_0_len=ar_0.length
      s_0=s_in.gsub($kibuvits_krl171_lc_pillar,$kibuvits_krl171_lc_emptystring) # "|||||[aA]w|[bB]|[cCd]" --> "[aA]w[bB][cCd]"
      if s_0.length != (i_ar_0_len)*4
         # like "[aA]w|[bB]" or "[aA]|[cCd]" or "[aA][e]" or "[aA][]"
         s_err="\nThe \n"+s_in+
         "\ndeviated from the expected format.\n"+
         "ar_0.to_s=="+ar_0.to_s+"\n"+
         "s_0=="+s_0+"\n"+
         "GUID='22ca0731-d725-4755-a240-c2c2f051a4e7'\n"
         kibuvits_krl171_throw(s_err,bn)
      end # if
      #--------------------------------------------------------------------
      rgx_1=/[\w\[\]]+[|]/
      s_1=("|"+s_in+$kibuvits_krl171_lc_pillar).gsub(/[|]+/,$kibuvits_krl171_lc_pillar) # "|[aA][bB]|[cC]|"
      s_2=$kibuvits_krl171_lc_emptystring
      s_2=s_1[1..(-1)] if 1 < s_1.length # the s_1 might be "|"
      ar_1=s_2.scan(rgx_1) # array of "[aA][bB]|"
      i_ar_1_len=ar_1.length
      s_char_regexform=nil
      s_char_0=nil
      s_char_1=nil
      s_char_0_dc=nil
      ar_ext=Array.new
      s_ext=nil
      ar_chars=nil
      i_ar_charS_len=0
      i_ar_1_len.times do |ix|
         s_ext=""
         s_0=ar_1[ix] # "[aA][bB]|"
         s_1=s_0[0..(-2)] # "[aA][bB]|" -> "[aA][bB]"
         ar_chars=s_1.scan(rgx_char_in_regex) # array of "[aA]"
         i_ar_charS_len=ar_chars.length
         i_ar_charS_len.times do |ix_1|
            s_char_regexform=ar_chars[ix_1] # "[aA]"
            s_char_0=s_char_regexform[1..1] # "[aA]" -> "a"
            s_char_1=s_char_regexform[2..2] # "[aA]" -> "A"
            if s_char_0 == s_char_1
               s_err="\nThe \n"+s_in+
               "\ndeviated from the expected format.\n"+
               "The case/capitalisation of letters has to vary, but \n"+
               "in the \""+s_char_regexform+"\" it does not.\n"+
               "GUID='2b71b922-4a9e-45c9-a34d-c2c2f051a4e7'\n"
               kibuvits_krl171_throw(s_err,bn)
            end # if
            s_char_0_dc=s_char_0.downcase
            if s_char_0_dc != s_char_1.downcase
               s_err="\nThe \n"+s_in+
               "\ndeviated from the expected format.\n"+
               "Only the capitalisation of letters in the \""+s_char_regexform+
               "\" is allowed to vary,\n"+
               "not the letters themselves.\n"+
               "GUID='57090464-b577-43e5-a25a-c2c2f051a4e7'\n"
               kibuvits_krl171_throw(s_err,bn)
            end # if
            s_ext=s_ext+s_char_0_dc
         end # loop
         ar_ext<<(s_ext+$kibuvits_krl171_lc_pillar)
      end # loop
      #--------------------------------------------------------------------
      s_0=kibuvits_krl171_s_concat_array_of_strings(ar_ext)
      s_out=s_0
      if 0 < s_0.length
         s_out=s_0[0..(-2)] if 0 < s_0.length # "jpeg|png|" -> "jpeg|png"
      end # if
      return s_out
   end # s_regex_subpart_2_extensions

   #-----------------------------------------------------------------------

   def exc_run_tests_s_regex_subpart_2_extensions
      #--------------------------------------------------------------------
      func_run_passing_test=lambda do |s_in,s_out_expected|
         s=s_regex_subpart_2_extensions(s_in)
         if s!=s_out_expected
            kibuvits_krl171_throw("\nTest failed.\n"+
            "s_in=="+s_in+"\n"+
            "s=="+s+"\n"+
            "s_out_expected=="+s_out_expected+"\n"+
            "GUID='69233b7c-38c0-4d80-9047-c2c2f051a4e7'\n")
         end # if
      end # func_run_passing_test
      #--------------------------------------------------------------------
      func_run_failing_test=lambda do |s_in|
         b=kibuvits_krl171_block_throws do
            s=s_regex_subpart_2_extensions(s_in)
         end # block
         if !b
            kibuvits_krl171_throw("\nTest failed. An exception was expected, \n"+
            "but no exception was thrown.\n"+
            "s_in=="+s_in+"\n"+
            "GUID='2ec63ca4-2326-405a-9214-c2c2f051a4e7'\n")
         end # if
      end # func_run_failing_test
      #--------------------------------------------------------------------
      init_testdata_ht_testdata_pairs_01()
      ht=@ht_testdata_pairs_01
      ht.each_pair do |s_extensions,s_regex_subpart|
         func_run_passing_test.call(s_regex_subpart,s_extensions)
         func_run_passing_test.call(s_regex_subpart+"|",s_extensions)
         func_run_passing_test.call("|"+s_regex_subpart,s_extensions)
         if s_regex_subpart!=$kibuvits_krl171_lc_emptystring
            func_run_passing_test.call("|"+s_regex_subpart+"|",s_extensions)
         end # if
      end # loop
      func_run_passing_test.call("[aA][Bb]","ab") # different order of case at regex subpart
      #--------------------------------------------------------------------
      ar=["[a]","[aa]","[AA]","[aB]","[aA][BB]","[aAc]","[aAa]","[aA][bB][]|[cC]","[]"]
      ar=ar+["||[aA]","aA","abc","ab|cd"]
      #-----rbeautify_rb--bug-workaround--start----
      # https://github.com/martinvahi/mmmv_patches/issues/1
      ar<<"[aA][bB][dD]|aA]"
      ar<<"[aA"
      ar<<"[aA|[bB]"
      #-----rbeautify_rb--bug-workaround--end------
      ar=ar+["[aA]||[bB]","[aA]|[bB]||","||[aA]","||[aA][bB]","aB"]
      ar.each{|s_in| func_run_failing_test.call(s_in)}
      #--------------------------------------------------------------------
      #puts(s_regex_subpart_2_extensions("[A]"))
   end # exc_run_tests_s_regex_subpart_2_extensions

   #-----------------------------------------------------------------------

   def exc_run_tests_circleconvert
      s_extensions_orig="doc|jpeg|foo|a"
      s_regex_subpart_orig="[dD][oO][cC]|[jJ][pP][eE][gG]|[fF][oO][oO]|[aA]"
      s_regex_subpart_gen=s_extensions_2_regex_subpart(s_extensions_orig)
      s_extensions_gen=s_regex_subpart_2_extensions(s_regex_subpart_gen)
      func_throw_exception=lambda do
         kibuvits_krl171_throw("Test failed.\n"+
         "\n"+
         "       s_extensions_orig=="+s_extensions_orig+"\n"+
         "       s_extensions_gen =="+s_extensions_gen+"\n"+
         "\n"+
         "    s_regex_subpart_orig=="+s_regex_subpart_orig+"\n"+
         "    s_regex_subpart_gen =="+s_regex_subpart_gen+"\n"+
         "\n"+
         "GUID='c59b047e-8364-4933-a652-c2c2f051a4e7'\n")
      end # func_throw_exception
      func_throw_exception.call() if s_extensions_gen!=s_extensions_orig
      func_throw_exception.call() if s_regex_subpart_gen!=s_regex_subpart_orig
   end # exc_run_tests_circleconvert

   #-----------------------------------------------------------------------

   def exc_run_all_tests
      exc_run_tests_s_extensions_2_regex_subpart()
      exc_run_tests_s_regex_subpart_2_extensions()
      exc_run_tests_circleconvert()
   end # exc_run_all_tests

end # File_extensions_2_JavaScript_regex_subpart_t1_implementation_0

#------------------------data_declaration_start----------------------------
main=lambda do  # a lambda to use closures
   ob=File_extensions_2_JavaScript_regex_subpart_t1_implementation_0.new
   ob.exc_run_all_tests()
end # main
main.call()

#==========================================================================
