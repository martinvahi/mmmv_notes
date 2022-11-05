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
   require KIBUVITS_HOME+"/src/include/kibuvits_file_intelligence.rb"
   require KIBUVITS_HOME+"/src/include/security/kibuvits_cryptcodec_txor_t1.rb"
end # if

#==========================================================================

class Mmmv_encrypt_t1

   def initialize
      @i_median_default=Kibuvits_cleartext_length_normalization.i_const_t1
   end # initialize

   def s_doc
      s_out=$kibuvits_lc_doublelinebreak+
      "   first argument: path to key file \n"+
      "  second argument: path to cleartext  file \n"+
      "   third argument: path to ciphertext file \n"+
      $kibuvits_lc_linebreak+
      "Optional:\n"+
      $kibuvits_lc_linebreak+
      "  fourth argument: estimated median of cleartext lengths \n"+
      "                          default:      "+@i_median_default.to_s+
      $kibuvits_lc_doublelinebreak+
      "   fifth argument: estimated standard deviation of cleartext lengths \n"+
      "                          default: calculated from the fifth argument \n"+
      "                                   func("+@i_median_default.to_s+") == "+
      Kibuvits_cleartext_length_normalization.i_val_t2(@i_median_default).to_s+
      $kibuvits_lc_doublelinebreak+
      "   sixth argument: armouring type {\"text_armour_t1\",\n"+
      "                                   \"bytestream_armour_t1\"},\n"+
      "                          default: \"bytestream_armour_t1\".\n"+
      $kibuvits_lc_doublelinebreak+
      "Encrypted files are about 100x (hundred times) the size of \n"+
      "their respective cleartext files. \n"+
      "\n"+
      "If \"bytestream_armour_t1\" is used, then bytes are \n"+
      "converted to letters of an artificial alphabet that consists \n"+
      "of 256 letters (a range of Unicode code points, where \n"+
      "all code points have a character assigned to it).\n"+
      "As bytes can have only 256 different values, which is \n"+
      "significantly less than the number of existing Unicode characters,\n"+
      "it is recommended that plain text files are encrypted \n"+
      "by using the \"text_armour_t1\", which omits the \n"+
      "byte to character conversion.\n"+
      $kibuvits_lc_doublelinebreak
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


   def exc_i_median
      s_median=$kibuvits_lc_emptystring
      i_median=nil
      if 3<ARGV.size
         s_median=$kibuvits_lc_emptystring+ARGV[3]
         s_median="0" if s_median=="-0" # To get a right type of error message.
         i_median=s_median.to_i
         b_throw_due_to_nonnumber=false
         if (0<s_median.length) && (i_median==0) # "hello".to_i==0
            b_throw_due_to_nonnumber=true if s_median!="0"
         end # if
         if b_throw_due_to_nonnumber
            kibuvits_throw("\nThe fourth argument == "+s_median.to_s+
            "\nThe estimated median of cleartext lengths \n"+
            "must be a whole number.\n"+
            "GUID='b610e631-efc5-420e-91e4-f0a070f1ced7'\n\n")
         end # if
         if i_median<0
            kibuvits_throw("The the estimated median of cleartext lengths \n"+
            "is expected to be greater than or equal to 0, but the 4. argument == "+
            i_median.to_s+
            "\nGUID='11e80941-040f-49c9-a1e4-f0a070f1ced7'\n\n")
         end # if
      else
         i_median=Kibuvits_cleartext_length_normalization.i_const_t1
      end # if
      return i_median
   end # exc_i_median


   def exc_i_standard_deviation(i_median)
      s_standard_deviation=$kibuvits_lc_emptystring
      i_standard_deviation=nil
      if 4<ARGV.size
         s_standard_deviation=$kibuvits_lc_emptystring+ARGV[4]
         s_standard_deviation="0" if s_standard_deviation=="-0" # To get a right type of error message.
         i_standard_deviation=s_standard_deviation.to_i
         b_throw_due_to_nonnumber=false
         if (0<s_standard_deviation.length) && (i_standard_deviation==0) # "hello".to_i==0
            b_throw_due_to_nonnumber=true if s_standard_deviation!="0"
         end # if
         if b_throw_due_to_nonnumber
            kibuvits_throw("\nThe fifth argument == "+s_standard_deviation.to_s+
            "\nThe estimated standard_deviation of cleartext lengths \n"+
            "must be a whole number.\n"+
            "GUID='50284b52-04a5-42d9-94e4-f0a070f1ced7'\n\n")
         end # if
         if i_standard_deviation<0
            kibuvits_throw("The the estimated standard_deviation of cleartext lengths \n"+
            "is expected to be greater than or equal to 0, but the 5. argument == "+
            i_standard_deviation.to_s+
            "\nGUID='4f88ee48-a383-48e5-b4e4-f0a070f1ced7'\n\n")
         end # if
      else
         i_standard_deviation=Kibuvits_cleartext_length_normalization.i_val_t2(i_median)
      end # if
      return i_standard_deviation
   end # exc_i_standard_deviation


   def exc_s_cleartext_armoured_and_s_armouring_type_text_armour_t1_verification(
      s_armouring_type,s_fp)
      #--------
      ht_test_failures=Kibuvits_fs.verify_access(s_fp,"readable,is_file")
      s_output_message_language=$kibuvits_lc_English
      b_throw=true
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw,
      "GUID='ed24a145-049e-49f2-b5e4-f0a070f1ced7'")
      #--------
      s_mimetype=Kibuvits_file_intelligence.s_get_MIME_type(s_fp)
      b_requires_armouring=Kibuvits_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1(
      s_mimetype)
      if b_requires_armouring
         # One solution might be to automatically switch
         # the armouring type in stead of throwing, but
         # there's a good chanse that the armouring requirement
         # change has been introduced by a flaw in the client program.
         # There might also be optimizations in place that depend
         # on the distinction between the "bytestream_armour_t1" and
         # the "text_armour_t1".
         kibuvits_throw("Armouring type \""+s_armouring_type+"\"\n, but\n"+
         "the MIME type of the file, \n"+s_fp+"\n\""+s_mimetype+
         "\", requires that the file is armoured like a binary file.\n"+
         "A workaround might be to switch from the \""+s_armouring_type+"\" \n"+
         "to the \"bytestream_armour_t1\".\n"+
         "GUID='bb0cb034-3087-4725-82d4-f0a070f1ced7'\n\n")
      end # if
   end # exc_s_cleartext_armoured_and_s_armouring_type_text_armour_t1_verification


   def exc_s_cleartext_armoured_and_s_armouring_type
      s_armouring_type="bytestream_armour_t1"
      # The strings in the ARGV are frozen.
      s_armouring_type=$kibuvits_lc_emptystring+ARGV[5] if 5<ARGV.size
      # The following 2 regexes are applied to avoid documenting,
      # whether the quotation marks are compulsory. It's just to
      # keep things simpler.
      s_armouring_type.sub!(/^"/,$kibuvits_lc_emptystring)
      s_armouring_type.sub!(/"$/,$kibuvits_lc_emptystring)
      s_cleartext_armoured=nil
      case s_armouring_type
      when "bytestream_armour_t1" # binary file
         s_cleartext_armoured=kibuvits_file2str_by_armour_t1(ARGV[1])
      when "text_armour_t1" # text file
         s_fp=ARGV[1]
         exc_s_cleartext_armoured_and_s_armouring_type_text_armour_t1_verification(
         s_armouring_type,s_fp)
         s_cleartext_armoured=file2str(s_fp)
      else
         kibuvits_throw("Armouring type \""+s_armouring_type+
         "\" is not yet supported.\n"+
         "Supported armouring types: \"text_armour_t1\",\n"+
         "                           \"bytestream_armour_t1\"."+
         "\n GUID='23efcfb1-ae74-440b-b3d4-f0a070f1ced7'\n\n")
      end # case s_armouring_type
      return s_cleartext_armoured,s_armouring_type
   end # exc_s_cleartext_armoured_and_s_armouring_type


   def exc_s_cryptocodec_type
      s_cryptocodec_type="kibuvits_wearlevelling_t1"
      # For later, when tere is more than one cyrpto algorithm to choose from:
      #s_cryptocodec_type=$kibuvits_lc_emptystring+ARGV[6] if 6<ARGV.size
      #s_cryptocodec_type.sub!(/^"/,$kibuvits_lc_emptystring)
      #s_cryptocodec_type.sub!(/"$/,$kibuvits_lc_emptystring)
      return s_cryptocodec_type
   end # exc_s_cryptocodec_type


   public

   def run
      i_0=ARGV.size
      if i_0<3
         if i_0==0
            kibuvits_writeln(s_doc())
            exit
         else
            kibuvits_throw("\nARGV.size == "+i_0.to_s+" < 3 "+
            s_doc()+"\n GUID='176ba561-3acb-42fc-95d4-f0a070f1ced7'\n\n")
         end # if
      end # if
      if 6<i_0
         kibuvits_throw("\n6 < ARGV.size == "+i_0.to_s+$kibuvits_lc_linebreak+
         s_doc()+"\n GUID='77806b23-0ec5-4d55-b1d4-f0a070f1ced7'\n\n")
      end # if
      #------------
      exit_if_filenameargs_fail()
      i_median=exc_i_median()
      i_standard_deviation=exc_i_standard_deviation(i_median)
      s_cleartext_armoured, s_armouring_type=exc_s_cleartext_armoured_and_s_armouring_type()
      s_cryptocodec_type=exc_s_cryptocodec_type()
      #------------
      s_key=file2str(ARGV[0])
      ht_key=Kibuvits_cryptcodec_txor_t1.ht_deserialize_key(s_key)
      #------------
      ht_header2=Hash.new
      ht_header2["s_armouring_type"]=s_armouring_type
      ht_header2["s_cryptocodec_type"]=s_cryptocodec_type
      s_header2_data=Kibuvits_ProgFTE.from_ht(ht_header2)
      s_header2=s_header2_data.length.to_s+$kibuvits_lc_pillar
      s_header2<<(s_header2_data+$kibuvits_lc_pillar)
      #------------
      s_ciphertext_with_doubleheader=nil
      case s_cryptocodec_type
      when "kibuvits_wearlevelling_t1"
         s_ciphertext_with_doubleheader=Kibuvits_cryptcodec_txor_t1.s_encrypt_wearlevelling_t1(
         s_cleartext_armoured,ht_key,s_header2,i_median,i_standard_deviation)
      else
         kibuvits_throw("Cryptocodec type \""+s_cryptocodec_type+
         "\" is not yet supported.\n"+
         "\n GUID='58f3b852-1be3-4432-83d4-f0a070f1ced7'\n\n")
      end # case s_cryptocodec_type
      #------------
      str2file(s_ciphertext_with_doubleheader,ARGV[2])
   end # run

end # class Mmmv_encrypt_t1

Mmmv_encrypt_t1.new.run

#==========================================================================
