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

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_comments_detector.rb"

#==========================================================================

class Kibuvits_comments_detector_selftests

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_comments_detector_selftests.test_stringhandling
      msgcs=Kibuvits_msgc_stack.new

      msgcs.clear
      s_lang="ANonExistinGAlienProgrammingLanguageFromMars42"
      s_script=' bla-bla-bla-blurp'
      ar_out=Kibuvits_comments_detector.run s_lang,s_script,msgcs
      kibuvits_throw "test 1" if !msgcs.b_failure
      kibuvits_throw "test 2" if msgcs.last.s_message_id!="1"
      s_lang="ruby"
      s_script=' " "'
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run s_lang,s_script,msgcs
      kibuvits_throw "test 3" if msgcs.b_failure
      kibuvits_throw "test 4" if 0<ar_out.length

      msgcs=Kibuvits_msgc_stack.new
      s_script='" '
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 5" if msgcs.b_failure
      kibuvits_throw "test 6" if 0<ar_out.length
      kibuvits_throw "test 7" if msgcs.length!=1
      msgcs.clear
      s_script="''\n'''"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 8" if msgcs.b_failure
      kibuvits_throw "test 9" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 10 msgcs.length=="+x.to_s if x!=1
      msgcs.clear
      s_script="''\n"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 11" if msgcs.b_failure
      kibuvits_throw "test 12" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 13 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="''\n'' "
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 14" if msgcs.b_failure
      kibuvits_throw "test 15" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 16 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="\n\n\n"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 17" if msgcs.b_failure
      kibuvits_throw "test 18" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 19 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="\n''"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 20" if msgcs.b_failure
      kibuvits_throw "test 21" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 22 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="\n''\n"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 23" if msgcs.b_failure
      kibuvits_throw "test 24" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 25 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script=""
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 26" if msgcs.b_failure
      kibuvits_throw "test 27" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 28 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="\n'"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 29" if msgcs.b_failure
      kibuvits_throw "test 30" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 31 msgcs.length=="+x.to_s if x!=1
      msgcs.clear
      s_script="\n'\n'\n'\n'\n'"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 32" if msgcs.b_failure
      kibuvits_throw "test 33" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 34 msgcs.length=="+x.to_s if x!=5
      msgcs.clear
      s_script="'\\''"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 35" if msgcs.b_failure
      kibuvits_throw "test 36" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 37 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="\\''"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 38" if msgcs.b_failure
      kibuvits_throw "test 39" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 40 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="'\""
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 41" if msgcs.b_failure
      kibuvits_throw "test 42" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 43 msgcs.length=="+x.to_s if x!=1
      msgcs.clear
      s_script="\"'"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 44" if msgcs.b_failure
      kibuvits_throw "test 45" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 46 msgcs.length=="+x.to_s if x!=1
      msgcs.clear
      s_script="'# a comment sign in a string '"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 47" if msgcs.b_failure
      kibuvits_throw "test 48" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 49 msgcs.length=="+x.to_s if x!=0
      msgcs.clear
      s_script="'# a comment sign within an unfinished string "
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 50" if msgcs.b_failure
      kibuvits_throw "test 51" if 0<ar_out.length
      x=msgcs.length
      kibuvits_throw "test 52 msgcs.length=="+x.to_s if x!=1
   end # Kibuvits_comments_detector_selftests.test_stringhandling

   #-----------------------------------------------------------------------

   def Kibuvits_comments_detector_selftests.test_singleline
      msgcs=Kibuvits_msgc_stack.new
      s_lang="ruby"

      s_expected=' stuff "#" '
      s_script=' some code1 #'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 1" if msgcs.b_failure
      kibuvits_throw "test 2 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 3" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 4" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 5" if ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=' stuff "#" '
      s_script=' 	 #'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 6" if msgcs.b_failure
      kibuvits_throw "test 7 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 8" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 9" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 10" if !ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=' stuff "#" '
      s_script='#'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 11" if msgcs.b_failure
      kibuvits_throw "test 12 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 13" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 14" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 15" if !ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=' '
      s_script='#'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 16" if msgcs.b_failure
      kibuvits_throw "test 17 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 18" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 19" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 20" if !ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=''
      s_script=' #'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 21" if msgcs.b_failure
      kibuvits_throw "test 22 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 23" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 24" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 25" if !ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=''
      s_script='#'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 26" if msgcs.b_failure
      kibuvits_throw "test 27 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 28" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 29" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 30" if !ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=''
      s_script='wooow#'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 31" if msgcs.b_failure
      kibuvits_throw "test 32 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 33" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 34" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 35" if ht_comment["only_tabs_and_spaces_before_comment"]


      s_expected=' " "# " '
      s_script='wooow#'+s_expected
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 36" if msgcs.b_failure
      kibuvits_throw "test 37 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 38" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 39" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 40" if ht_comment["only_tabs_and_spaces_before_comment"]

      s_expected=''
      s_expected1='AB'
      s_script="#"+s_expected+"\n\"\\\"\"#"+s_expected1
      #                           0_1_2_34
      msgcs.clear
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 41" if msgcs.b_failure
      kibuvits_throw "test 42 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 43" if ar_out.length!=2
      ht_comment=ar_out[0]
      kibuvits_throw "test 44" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 45" if !ht_comment["only_tabs_and_spaces_before_comment"]
      kibuvits_throw "test 46" if ht_comment["start_line_number"]!=1
      kibuvits_throw "test 47" if ht_comment["end_line_number"]!=1
      kibuvits_throw "test 48" if ht_comment["start_column"]!=1
      kibuvits_throw "test 49" if ht_comment["end_column"]!=1
      kibuvits_throw "test 50" if ht_comment["start_tag"]!="#"
      kibuvits_throw "test 51" if ht_comment["end_tag"]!=""
      kibuvits_throw "test 52" if ht_comment["type"]!="singleliner"
      ht_comment=ar_out[1]
      kibuvits_throw "test 53" if ht_comment["comment"]!=s_expected1
      kibuvits_throw "test 54" if ht_comment["only_tabs_and_spaces_before_comment"]
      kibuvits_throw "test 55" if ht_comment["start_line_number"]!=2
      kibuvits_throw "test 56" if ht_comment["end_line_number"]!=2
      kibuvits_throw "test 57" if ht_comment["start_column"]!=5
      kibuvits_throw "test 58" if ht_comment["end_column"]!=7
      kibuvits_throw "test 59" if ht_comment["start_tag"]!="#"
      kibuvits_throw "test 60" if ht_comment["end_tag"]!=""
      kibuvits_throw "test 61" if ht_comment["type"]!="singleliner"

   end # Kibuvits_comments_detector_selftests.test_singleline

   #-----------------------------------------------------------------------

   def Kibuvits_comments_detector_selftests.test_multiline
      msgcs=Kibuvits_msgc_stack.new
      s_lang="c++"

      s_expected='Hi'
      s_script="/*"+s_expected+"*/"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 1" if msgcs.b_failure
      kibuvits_throw "test 2 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 3" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 4" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 5" if !ht_comment["only_tabs_and_spaces_before_comment"]
      kibuvits_throw "test 6" if ht_comment["start_line_number"]!=1
      kibuvits_throw "test 7" if ht_comment["end_line_number"]!=1
      kibuvits_throw "test 8" if ht_comment["start_column"]!=2
      kibuvits_throw "test 9" if ht_comment["end_column"]!=4
      kibuvits_throw "test 10" if ht_comment["start_tag"]!="/*"
      kibuvits_throw "test 11" if ht_comment["end_tag"]!="*/"
      kibuvits_throw "test 12" if ht_comment["type"]!="multiliner"

      msgcs.clear
      s_script="/*a\nb*/"
      s_expected="a\nb"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 13" if msgcs.b_failure
      kibuvits_throw "test 14 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 15" if ar_out.length!=1
      ht_comment=ar_out[0]
      kibuvits_throw "test 16" if ht_comment["comment"]!=s_expected
      kibuvits_throw "test 17" if !ht_comment["only_tabs_and_spaces_before_comment"]
      kibuvits_throw "test 18" if ht_comment["start_line_number"]!=1
      kibuvits_throw "test 19" if ht_comment["end_line_number"]!=2
      kibuvits_throw "test 20" if ht_comment["start_column"]!=2
      kibuvits_throw "test 21" if ht_comment["end_column"]!=1
      kibuvits_throw "test 22" if ht_comment["start_tag"]!="/*"
      kibuvits_throw "test 23" if ht_comment["end_tag"]!="*/"
      kibuvits_throw "test 24" if ht_comment["type"]!="multiliner"

      msgcs.clear
      s_script="ff/*a\nb*/ \" /*\"/*cde*/ "
      s_expected1="a\nb"
      s_expected2="cde"
      ar_out=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      kibuvits_throw "test 25" if msgcs.b_failure
      kibuvits_throw "test 26 msgcs.length=="+msgcs.length.to_s if msgcs.length!=0
      kibuvits_throw "test 27" if ar_out.length!=2
      ht_comment=ar_out[0]
      kibuvits_throw "test 28" if ht_comment["comment"]!=s_expected1
      kibuvits_throw "test 29" if ht_comment["only_tabs_and_spaces_before_comment"]
      kibuvits_throw "test 30" if ht_comment["start_line_number"]!=1
      kibuvits_throw "test 31" if ht_comment["end_line_number"]!=2
      kibuvits_throw "test 32" if ht_comment["start_column"]!=4
      kibuvits_throw "test 33" if ht_comment["end_column"]!=1
      kibuvits_throw "test 34" if ht_comment["start_tag"]!="/*"
      kibuvits_throw "test 35" if ht_comment["end_tag"]!="*/"
      kibuvits_throw "test 36" if ht_comment["type"]!="multiliner"
      ht_comment=ar_out[1]
      kibuvits_throw "test 37" if ht_comment["comment"]!=s_expected2
      kibuvits_throw "test 38" if ht_comment["only_tabs_and_spaces_before_comment"]
      kibuvits_throw "test 39" if ht_comment["start_line_number"]!=2
      kibuvits_throw "test 40" if ht_comment["end_line_number"]!=2
      kibuvits_throw "test 41" if ht_comment["start_column"]!=11
      kibuvits_throw "test 42" if ht_comment["end_column"]!=14
      kibuvits_throw "test 43" if ht_comment["start_tag"]!="/*"
      kibuvits_throw "test 44" if ht_comment["end_tag"]!="*/"
      kibuvits_throw "test 45" if ht_comment["type"]!="multiliner"
   end # Kibuvits_comments_detector_selftests.test_multiline

   #-----------------------------------------------------------------------

   def  Kibuvits_comments_detector_selftests.test_extract_commentstrings
      s_lang="c++"
      s_script=" //Ab\n//cde\n/*fgh\n*/"
      s_expected_comment="Ab\ncde"
      msgcs=Kibuvits_msgc_stack.new
      ar_comments=Kibuvits_comments_detector.run(s_lang,s_script,msgcs)
      ar_commentstrings=Kibuvits_comments_detector.extract_commentstrings(
      ar_comments,true)
      kibuvits_throw "test 1" if msgcs.b_failure
      kibuvits_throw "test 2" if ar_commentstrings.length!=2
      ar_lines=[]
      ar_commentstrings[0].each_line{|s_line| ar_lines<<s_line}
      kibuvits_throw "test 3" if ar_lines.length!=2
   end # Kibuvits_comments_detector_selftests.test_extract_commentstrings

   #-----------------------------------------------------------------------

   def Kibuvits_comments_detector_selftests.test_ar_get_singleliner_comment_start_tags
      msgcs=Kibuvits_msgc_stack.new
      if KIBUVITS_b_DEBUG
         if !kibuvits_block_throws{Kibuvits_comments_detector.ar_get_singleliner_comment_start_tags(42,msgcs)}
            kibuvits_throw "test 1"
         end # if
         if !kibuvits_block_throws{Kibuvits_comments_detector.ar_get_singleliner_comment_start_tags("ruby",42)}
            kibuvits_throw "test 2"
         end # if
      end # if
      ar_x_tags=Kibuvits_comments_detector.ar_get_singleliner_comment_start_tags("ruby",msgcs)
      s_tag=ar_x_tags[0]
      kibuvits_throw "test 3" if msgcs.b_failure
      kibuvits_throw "test 4" if s_tag!="#"
      ar_x_tags=Kibuvits_comments_detector.ar_get_singleliner_comment_start_tags("JavaScript",msgcs)
      s_tag=ar_x_tags[0]
      kibuvits_throw "test 5" if msgcs.b_failure
      kibuvits_throw "test 6" if s_tag!="//"
      ar_x_tags=Kibuvits_comments_detector.ar_get_singleliner_comment_start_tags(
      "ThisLanguageCanNotExist4_"+
      Kibuvits_GUID_generator.generate_GUID,msgcs)
      kibuvits_throw "test 7" if !msgcs.b_failure
      kibuvits_throw "test 8" if msgcs.last.s_message_id!="5"
   end # Kibuvits_comments_detector_selftests.test_ar_get_singleliner_comment_start_tags

   #-----------------------------------------------------------------------

   public
   def Kibuvits_comments_detector_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn,"Kibuvits_comments_detector_selftests.test_stringhandling"
      kibuvits_testeval bn,"Kibuvits_comments_detector_selftests.test_singleline"
      kibuvits_testeval bn,"Kibuvits_comments_detector_selftests.test_multiline"
      kibuvits_testeval bn,"Kibuvits_comments_detector_selftests.test_extract_commentstrings"
      kibuvits_testeval bn,"Kibuvits_comments_detector_selftests.test_ar_get_singleliner_comment_start_tags"
      return ar_msgs
   end # Kibuvits_comments_detector_selftests.selftest

end # class Kibuvits_comments_detector_selftests

#==========================================================================

