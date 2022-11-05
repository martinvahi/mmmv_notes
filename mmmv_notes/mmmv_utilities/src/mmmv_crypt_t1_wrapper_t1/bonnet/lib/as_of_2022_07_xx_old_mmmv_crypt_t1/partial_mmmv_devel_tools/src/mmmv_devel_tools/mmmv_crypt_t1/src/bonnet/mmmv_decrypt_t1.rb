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

class  Mmmv_decrypt_t1

   def initialize
   end # initialize

   def s_doc
      s_out=$kibuvits_lc_emptystring+
      "  first argument: path to key file \n"+
      " second argument: path to ciphertext file\n"+
      "  third argument: path to cleartext  file \n\n"
      return s_out
   end # s_doc

   private

   def exit_if_filenameargs_fail
      ht_failures=Kibuvits_fs.verify_access(ARGV[0],"is_file,readable")
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures)
      ht_failures=Kibuvits_fs.verify_access(ARGV[1],"is_file,readable")
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures)
      if File.exists? ARGV[2]
         ht_failures=Kibuvits_fs.verify_access(ARGV[2],"is_file,writable")
         Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures)
      end # if
   end # exit_if_filenameargs_fail

   public

   def run
      i_0=ARGV.size
      if i_0==0
         kibuvits_writeln(s_doc())
         exit
      else
         kibuvits_throw(s_doc()) if i_0!=3
      end # if
      exit_if_filenameargs_fail()
      msgcs=Kibuvits_msgc_stack.new
      #------------
      s_key=file2str(ARGV[0])
      ht_key=Kibuvits_cryptcodec_txor_t1.ht_deserialize_key(s_key)
      #------------
      # For this application a ciphertext is always in a form of a textfile.
      s_ciphertext_with_doubleheader=file2str(ARGV[1])
      #------------
      s_header2_data,s_ciphertext_with_header=Kibuvits_str.s_s_bisect_by_header_t1(
      s_ciphertext_with_doubleheader,msgcs)
      msgcs.assert_lack_of_failures(
      "GUID='8056df23-16f9-439f-a31a-106050e1ced7'")
      ht_header2=Kibuvits_ProgFTE.to_ht(s_header2_data)
      s_cleartext_armoured=nil
      s_cryptocodec_type=ht_header2["s_cryptocodec_type"]
      case s_cryptocodec_type
      when "kibuvits_wearlevelling_t1"
         s_cleartext_armoured=Kibuvits_cryptcodec_txor_t1.s_decrypt_wearlevelling_t1(
         s_ciphertext_with_header,ht_key,msgcs)
      else
         kibuvits_throw("The cryptocodec type \""+s_cryptocodec_type+
         "\" is not yet supported.\n"+
         "Supported cryptocodecs: \"kibuvits_wearlevelling_t1\"."+
         "\n GUID='e7b2b330-3fa5-46c0-831a-106050e1ced7'\n\n")
      end # case s_cryptocodec_type
      #------------
      s_armouring_type=ht_header2["s_armouring_type"]
      s_fp_cleartext=ARGV[2]
      s_fp_cleartext_normalized=s_fp_cleartext.gsub(/[\/]+/,$kibuvits_lc_slash)
      case s_armouring_type
      when "bytestream_armour_t1"
         if msgcs.b_failure
            # The file might not be a text file and
            # therefore, there is no way to come out
            # of this situation cleanly. It's better
            # to throw, should the decryption application
            # be used as a sub-component of some other software.
            msgcs.assert_lack_of_failures(
            "GUID='23494547-88ba-4ea3-b41a-106050e1ced7'")
         end # if
         kibuvits_str2file_by_dearmour_t1(
         s_cleartext_armoured,s_fp_cleartext_normalized)
      when "text_armour_t1" # cleartext is pure Unicode
         if msgcs.b_failure
            # It's safer to throw, should the decryption application
            # be used as a sub-component of some other software.
            # However, it is possible to "fail" a bit
            # more gracefully by offering partially decrypted
            # text as part of the exception message.
            # A subpart of an e-mail that was intended to
            # be read by a human is better than nothing.
            msgc=msgcs.last
            if msgc.s_message_id==Kibuvits_cleartext_length_normalization.s_failure_id_checksum_failure_t1
               s_err=msgc.to_s+$kibuvits_lc_linebreak+
               "GUID='301af9b3-f9b1-4a4c-a71a-106050e1ced7'\n"+
               "-"*30+$kibuvits_lc_doublelinebreak+s_cleartext_armoured
               kibuvits_throw(s_err)
            else
               msgcs.assert_lack_of_failures(
               "GUID='353b0012-fc67-4d23-bb1a-106050e1ced7'")
            end # if
         end # if
         str2file(s_cleartext_armoured,s_fp_cleartext_normalized)
      else
         kibuvits_throw("The armouring type \""+s_armouring_type+
         "\" is not yet supported.\n"+
         "Supported armouring types: \"text_armour_t1\",\n"+
         "                           \"bytestream_armour_t1\"."+
         "\n GUID='2d45575b-b689-4cef-841a-106050e1ced7'\n\n")
      end # case s_armouring_type
   end # run

end # class Mmmv_decrypt_t1

Mmmv_decrypt_t1.new.run

#==========================================================================
