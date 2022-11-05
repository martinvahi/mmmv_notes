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

if !defined? MMMV_CRYPT_T1_RB_INCLUDED
   MMMV_CRYPT_T1_RB_INCLUDED=true
   if !defined? MMMV_DEVEL_TOOLS_HOME
      require 'pathname'
      s_0=Pathname.new(__FILE__).realpath.parent.parent.parent.parent.parent.parent.to_s
      MMMV_DEVEL_TOOLS_HOME=s_0.freeze
   end # if

   require MMMV_DEVEL_TOOLS_HOME+"/src/bonnet/mmmv_devel_tools_initialization_t1.rb"

   require KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"
   require KIBUVITS_HOME+"/src/include/kibuvits_argv_parser.rb"
   require KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
   require KIBUVITS_HOME+"/src/include/security/kibuvits_cryptcodec_txor_t1.rb"
end # if

#==========================================================================

i_0=ARGV.size
if i_0!=2
   kibuvits_writeln("\nARGV.size == "+i_0.to_s+" != 2 "+
   "\n   first argument: key length "+
   "\n  second argument: path to a key file \n\n")
   exit
end # if
i_key_length=ARGV[0].to_s.to_i
if i_key_length<1
   kibuvits_writeln("Key length must be greater than or equal to 1.\n"+
   "Currently the 2. argument == "+ARGV[0].to_s)
   exit
end # if
ht_key=Kibuvits_cryptcodec_txor_t1.ht_generate_key_t1(i_key_length)
s_key=Kibuvits_cryptcodec_txor_t1.s_serialize_key(ht_key)
str2file(s_key,ARGV[1])

#==========================================================================

