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
if !defined?(KIBUVITS_HOME)
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
   require KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require KIBUVITS_HOME+"/src/include/kibuvits_ix.rb"
else
   require "kibuvits_str.rb"
   require "kibuvits_msgc.rb"
   require "kibuvits_ix.rb"
end # if
require "singleton"
#==========================================================================

class Kibuvits_comments_detector
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

      ht_testlanguage_for_selftests_1=Hash.new
      ht_testlanguage_for_selftests_1[@lc_start_tag]="\"y"
      ht_testlanguage_for_selftests_1[@lc_end_tag]="\"z"
      @ht_multiliner["testlanguage_for_selftests_1"]=[ht_testlanguage_for_selftests_1]
   end # init_multiliner_ht


   def init_singleliner_ht
      @ht_singleliner=Hash.new

      ht_cpp=Hash.new
      ht_cpp[@lc_start_tag]="//"
      ht_cpp[@lc_end_tag]=$kibuvits_lc_emptystring
      ar_cpp_liner=[ht_cpp]

      ht_bash=Hash.new
      ht_bash[@lc_start_tag]="#"
      ht_bash[@lc_end_tag]=$kibuvits_lc_emptystring
      ar_bash_liner=[ht_bash]

      ht_haskell=Hash.new
      ht_haskell[@lc_start_tag]="--"
      ht_haskell[@lc_end_tag]=$kibuvits_lc_emptystring
      ar_haskell_liner=[ht_haskell]

      ht_batch=Hash.new
      ht_batch[@lc_start_tag]=" rem " # The Windows bat files.
      ht_batch[@lc_end_tag]=$kibuvits_lc_emptystring
      ar_batch_liner=[ht_batch]

      ht_reduce=Hash.new
      ht_reduce[@lc_start_tag]="%"
      ht_reduce[@lc_end_tag]=$kibuvits_lc_emptystring
      ar_reduce_liner=[ht_reduce] # The REDUCE Computer Algebra System

      @ht_singleliner["haskell"]=ar_haskell_liner
      @ht_singleliner["ruby"]=ar_bash_liner
      @ht_singleliner["bash"]=ar_bash_liner
      @ht_singleliner["batch"]=ar_batch_liner
      @ht_singleliner["c++"]=ar_cpp_liner
      @ht_singleliner["c#"]=ar_cpp_liner
      @ht_singleliner["c"]=ar_cpp_liner
      @ht_singleliner["php"]=ar_cpp_liner
      @ht_singleliner["javascript"]=ar_cpp_liner
      @ht_singleliner["java"]=ar_cpp_liner
      @ht_singleliner["reduce"]=ar_reduce_liner # The REDUCE Computer Algebra System

      ht_testlanguage_for_selftests_1=Hash.new
      ht_testlanguage_for_selftests_1[@lc_start_tag]="\"\""
      ht_testlanguage_for_selftests_1[@lc_end_tag]=$kibuvits_lc_emptystring
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
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), Fixnum, i_state
      end # if
      s_out=$kibuvits_lc_emptystring
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
         kibuvits_throw "i_state=="+i_state.to_s
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
      # every Kibuvits_comments_detector.run call,
      # the manipulation of the instances that were
      # output by one of the calls tho the Kibuvits_comments_detector.run
      # does not influence the output of other calls to the
      # Kibuvits_comments_detector.run.
      #
      # If the ht_comment instances share the instances that are
      # used as the hashtable keys, then there's probably
      # also a considerable memory saving. The assumption
      # is that every call to the Kibuvits_comments_detector.run
      # produces a "lot" of ht_comment instances that
      # each has more than one key. Such a detailed
      # ht_comment content is used for comfort.
      ht_comment_keys=ht_opmem[@lc_ht_comment_keys]
      ht_comment=Hash.new
      ht_comment[ht_comment_keys[@lc_comment]]=$kibuvits_lc_emptystring # due to the + operator
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
      kibuvits_throw "ar_ht[0]==nil" if  ht_container==nil
      ht_tag=ht_container[@lc_ht_tag]
      kibuvits_throw "ht_tag==nil" if  ht_tag==nil
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
         kibuvits_throw "\ns_line_length=="+s_line_length.to_s+" < cursor_index=="+
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
         kibuvits_throw "al_state_in_search err1"
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
      if KIBUVITS_b_DEBUG
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
         b_end_tag_schr0_is_escapable=Kibuvits_str.character_is_escapable(
         s_end_tag_chr0)
         if (!b_end_tag_schr0_is_escapable)||(x==cursor_index)
            # The x==cursor_index marks an empty string. The empty
            # string case can be illustrated by an '-quoted string
            # like ''.
            ht_opmem[@lc_cursor_index]=x+s_end_tag.length
            ht_opmem[@lc_state]=@lc_state_in_search
         else
            if Kibuvits_str.character_is_escaped(s_line,x)
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
      kibuvits_throw "s_start_tag.length==0" if i_s_start_taglen==0
      if i_s_leftlen<i_s_start_taglen
         kibuvits_throw "s_left.length=="+i_s_leftlen.to_s+"<s_start_tag.length=="+
         i_s_start_taglen.to_s
      end # if
      if i_s_start_taglen<i_s_leftlen # most common case
         s_cl=Kibuvits_str.clip_tail_by_str(s_left,s_start_tag)
         if i_s_leftlen<=s_cl.length
            kibuvits_throw "Tail clipping by s_start_tag(=="+s_start_tag+
            ") did not occur. s_cl==("+s_cl+")."
         end # if
         md=@rgx_nonspacestabs.match(s_cl)
         b_out=(md==nil)
         return b_out
      end # if
      if s_left!=s_start_tag
         kibuvits_throw "\ns_left.length==s_start_tag.length=="+i_s_leftlen.to_s+
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
      s_left,s_right=Kibuvits_ix.bisect_at_sindex s_line, i_cursor_index
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
      kibuvits_throw "s_end_tag.length<1" if i_s_end_taglen<1
      s_left,s_right=Kibuvits_ix.bisect_at_sindex s_line, i_cursor_index
      i_ix=s_right.index(s_end_tag)
      if i_ix==nil
         ht_opmem[@lc_cursor_index]=i_s_linelen # == <the end of line>
         ht_comment[ht_comment_keys[@lc_comment]]=ht_comment[@lc_comment]+
         s_right+"\n"
      else
         ht_comment[ht_comment_keys[@lc_comment]]=ht_comment[@lc_comment]+
         Kibuvits_ix.sar(s_right,0,i_ix)
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
      kibuvits_throw "s_start_tag.length<1" if s_start_tag.length<1
      kibuvits_throw "s_end_tag.length<1" if s_end_tag.length<1
      s_left,s_right=Kibuvits_ix.bisect_at_sindex s_line, i_cursor_index
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
            kibuvits_throw "State not supported. state=="+state.to_s
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
         kibuvits_throw "state_in_singleliner, "+
         'GUID=="7da90a00-1727-4301-2622-75a016615b4f" '
      end # if
      if state==@lc_state_in_string
         ht_opmem[@lc_state]=@lc_state_in_search
         if KIBUVITS_b_DEBUG
            ht_container=(ht_opmem[@lc_ar_ht])[0]
            s="\nIn analyze_line the line ended in the "+
            "state @lc_state_in_string \n"+
            'GUID=="4c578837-ea83-4106-3fd5-bda76534d4d8", '+
            'line_number=='+(ht_opmem[@lc_line_number]).to_s+
            ",\nstring start token =="+
            ((ht_container[@lc_ht_tag])[@lc_start_tag]).to_s+
            "\ns_line==("+s_line+")\n"
            msgcs.cre s,4.to_s
            msgcs.last.b_failure=false
         end # if
      end # if
   end # analyze_line

   def create_ht_opmem_ht_comment_tags ht_opmem,ht_xliner
      ht_comment_tags=ht_opmem[@lc_ht_comment_tags]
      ht_xliner.each_key do |s_lang|
         ar_of_ht=ht_xliner[s_lang]
         ar_of_ht.each do |ht_startend|
            x=$kibuvits_lc_emptystring+ht_startend[@lc_start_tag]
            ht_comment_tags[x]=x
            x=$kibuvits_lc_emptystring+ht_startend[@lc_end_tag]
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
      ht_comment_keys[@lc_type]=$kibuvits_lc_emptystring+@lc_type
      ht_comment_keys[@lc_start_line_number]=$kibuvits_lc_emptystring+@lc_start_line_number
      ht_comment_keys[@lc_end_line_number]=$kibuvits_lc_emptystring+@lc_end_line_number
      ht_comment_keys[@lc_start_column]=$kibuvits_lc_emptystring+@lc_start_column
      ht_comment_keys[@lc_end_column]=$kibuvits_lc_emptystring+@lc_end_column
      ht_comment_keys[@lc_start_tag]=$kibuvits_lc_emptystring+@lc_start_tag
      ht_comment_keys[@lc_end_tag]=$kibuvits_lc_emptystring+@lc_end_tag
      ht_comment_keys[@lc_only_tabs_and_spaces_before_comment]=$kibuvits_lc_emptystring+
      @lc_only_tabs_and_spaces_before_comment
      ht_comment_keys[@lc_singleliner]=$kibuvits_lc_emptystring+@lc_singleliner
      ht_comment_keys[@lc_multiliner]=$kibuvits_lc_emptystring+@lc_multiliner
      ht_comment_keys[@lc_comment]=$kibuvits_lc_emptystring+@lc_comment
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
   def run s_language, s_script, msgcs=Kibuvits_msgc_stack.new
      s_lang0=Kibuvits_str.normalise_linebreaks s_language, "<a_linebreak>"
      s_lang=s_lang0.downcase
      ar_out=Array.new
      if !@ht_stringmarks.has_key? s_lang
         msgcs.cre("Language \""+s_lang0+"\" is not supported.",1.to_s)
         msgcs.last['Estonian']='Keel "'+s_lang0+'" ei ole toetatud.'
         return ar_out
      end # if
      s_scr=Kibuvits_str.normalise_linebreaks s_script, "\n"
      ht_opmem=create_ht_opmem s_lang, msgcs, ar_out
      i_line_number=0
      s_nl="\n"
      s_scr.each_line do |s_line|
         ht_opmem[@lc_s_line]=Kibuvits_str.clip_tail_by_str s_line,s_nl
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


   def Kibuvits_comments_detector.run(s_language, s_script,
      msgcs=Kibuvits_msgc_stack.new)
      ar_out=Kibuvits_comments_detector.instance.run(
      s_language,s_script,msgcs)
      return ar_out
   end # Kibuvits_comments_detector.run

   # Returns a string.
   def get_singleliner_comment_start_tag s_language, msgcs
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_language
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      s_out="undetermined"
      s_lang=s_language.downcase
      if !@ht_singleliner.has_key? s_lang
         ar_s_langs=Array.new
         @ht_singleliner.each_key{|s_suplang| ar_s_langs<<s_suplang}
         s_list_of_supported_languages=Kibuvits_str.array2xseparated_list(
         ar_s_langs,s_separator=", ")
         msgcs.cre "Language \""+s_language+"\" is not supported. "+
         "The supported languages are: "+
         s_list_of_supported_languages+".",5.to_s
         msgcs.last['Estonian']="Keel nimega \""+s_language+
         "\" ei ole toetatud. Toetatud keelteks on: "+
         s_list_of_supported_languages+"."
         return s_out
      end # if
      ar_tags=@ht_singleliner[s_lang]
      ht_tag=ar_tags[0]
      s_out=$kibuvits_lc_emptystring+ht_tag[@lc_start_tag]
      return s_out
   end # get_singleliner_comment_start_tag

   def Kibuvits_comments_detector.get_singleliner_comment_start_tag(
      s_language,msgcs)
      s_out=Kibuvits_comments_detector.instance.get_singleliner_comment_start_tag(
      s_language,msgcs)
      return s_out
   end # Kibuvits_comments_detector.get_singleliner_comment_start_tag

   private
   def Kibuvits_comments_detector.test_get_singleliner_comment_start_tag
      msgcs=Kibuvits_msgc_stack.new
      if !kibuvits_block_throws{Kibuvits_comments_detector.get_singleliner_comment_start_tag(42,msgcs)}
         kibuvits_throw "test 1"
      end # if
      if !kibuvits_block_throws{Kibuvits_comments_detector.get_singleliner_comment_start_tag("ruby",42)}
         kibuvits_throw "test 2"
      end # if
      s_tag=Kibuvits_comments_detector.get_singleliner_comment_start_tag(
      "ruby",msgcs)
      kibuvits_throw "test 3" if msgcs.b_failure
      kibuvits_throw "test 4" if s_tag!="#"
      s_tag=Kibuvits_comments_detector.get_singleliner_comment_start_tag(
      "JavaScript",msgcs)
      kibuvits_throw "test 5" if msgcs.b_failure
      kibuvits_throw "test 6" if s_tag!="//"
      s_tag=Kibuvits_comments_detector.get_singleliner_comment_start_tag(
      "ThisLanguageCanNotExist4_"+
      Kibuvits_GUID_generator.generate_GUID,msgcs)
      kibuvits_throw "test 7" if !msgcs.b_failure
      kibuvits_throw "test 8" if msgcs.last.s_message_id!="5"
   end # Kibuvits_comments_detector.test_get_singleliner_comment_start_tag

   def Kibuvits_comments_detector.test_stringhandling
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
   end # Kibuvits_comments_detector.test1

   def Kibuvits_comments_detector.test_singleline
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

   end # Kibuvits_comments_detector.test_singleline

   def Kibuvits_comments_detector.test_multiline
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
   end # Kibuvits_comments_detector.test_multiline

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
               s_collected=$kibuvits_lc_emptystring
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
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck binding(), Array, ar_comments
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

   def  Kibuvits_comments_detector.extract_commentstrings(ar_comments,
      b_convert_blocks_of_singleliners2multiliner=true)
      ar_out=Kibuvits_comments_detector.instance.extract_commentstrings(
      ar_comments,b_convert_blocks_of_singleliners2multiliner)
      return ar_out
   end # Kibuvits_comments_detector.convert_blocks_of_singleliners2multiliner

   private
   def  Kibuvits_comments_detector.test_extract_commentstrings
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
   end # Kibuvits_comments_detector.test_extract_commentstrings

   public
   include Singleton
   def Kibuvits_comments_detector.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(),"Kibuvits_comments_detector.test_stringhandling"
      kibuvits_testeval binding(),"Kibuvits_comments_detector.test_singleline"
      kibuvits_testeval binding(),"Kibuvits_comments_detector.test_multiline"
      kibuvits_testeval binding(),"Kibuvits_comments_detector.test_extract_commentstrings"
      kibuvits_testeval binding(),"Kibuvits_comments_detector.test_get_singleliner_comment_start_tag"
      return ar_msgs
   end # Kibuvits_comments_detector.selftest
end # class Kibuvits_comments_detector

#==========================================================================
