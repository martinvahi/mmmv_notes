#!/usr/bin/env ruby 
#==========================================================================

require "pathname"
require "singleton"

if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
else
   require  "kibuvits_str.rb"
end # if

#--------------------------------------------------------------------------

class Kibuvits_deprecated_str
   #-----------------------------------------------------------------------
   private

   def configstylestr_2_ht_collect_var(ht_opmem)
      ht_out=ht_opmem['ht_out']
      ht_out[ht_opmem['s_varname']]=ht_opmem['s_varvalue']
      ht_opmem['s_varvalue']=""
   end # configstylestr_2_ht_collect_var

   def configstylestr_2_ht_azl_heredoc(ht_opmem)
      s_line=ht_opmem['s_line']
      s_entag=ht_opmem['s_heredoc_endtag']
      if s_line.index(s_entag)==nil
         # It modifies the instance that resides in the hashtable.
         ht_opmem['s_varvalue']<<(s_line+$kibuvits_lc_linebreak)
         return
      end # if
      s_varvalue=ht_opmem['s_varvalue']
      # The next line gets rid of the very last linebreak in the s_varvalue.
      s_varvalue=Kibuvits_ix.sar(s_varvalue,0,(s_varvalue.length-1))
      ht_opmem['s_varvalue']=s_varvalue
      configstylestr_2_ht_collect_var ht_opmem
      ht_opmem['b_in_heredoc']=false
   end # configstylestr_2_ht_azl_heredoc

   # Answer of false means only, that the line is defenately not a
   # proper comment line.
   def configstylestr_2_ht_azl_nonheredoc_line_is_a_comment_line(s_line)
      b_out=true
      i_n_equals_signs=Kibuvits_str.count_substrings(s_line,$kibuvits_lc_equalssign)
      return b_out if i_n_equals_signs==0
      i_n_commented_equals_signs=Kibuvits_str.count_substrings(s_line,"\\=")
      return b_out if i_n_commented_equals_signs==i_n_equals_signs
      b_out=false
      return b_out
   end # configstylestr_2_ht_azl_nonheredoc_line_is_a_comment_line

   def configstylestr_2_ht_azl_nonheredoc(ht_opmem)
      s_line=ht_opmem['s_line']
      if KIBUVITS_b_DEBUG
         if s_line.index($kibuvits_lc_linebreak)!=nil
            kibuvits_throw "s_line contains a linebreak, s_line=="+s_line
         end # if
      end # if
      # The \= is used in comments and it can appear in the
      # value part of the non-heredoc assignment line.
      # The = can also appear in the
      # value part of the non-heredoc assignment line.
      if configstylestr_2_ht_azl_nonheredoc_line_is_a_comment_line(s_line)
         return
      end # if
      msgcs=ht_opmem['msgcs']
      # If we are here, then that means that the s_line has at least
      # one equals sign that is an assignment equals sign.
      #
      # Possible versions:
      # ^[=]
      # ^whatever_that_does_not_contain_an_assignmet_equals_sign [=] whatever_that_might_even_contain_assignment_equals_signs
      s_l=$kibuvits_lc_space+s_line # to match the ^[=] with ^[^\\][=]
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
      s_left_with_equals_sign,s_right=Kibuvits_ix.bisect_at_sindex(s_line,
      (i_assignment_equals_sign_one_leftwards+1))
      s_left,s_right_with_equals_sign=Kibuvits_ix.bisect_at_sindex(s_line,
      i_assignment_equals_sign_one_leftwards)
      s_left=Kibuvits_str.trim(s_left)
      s_right=Kibuvits_str.trim(s_right)
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
      if (s_left.gsub(/[\s\t]+/,$kibuvits_lc_emptystring).length)!=(s_left.length)
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
         configstylestr_2_ht_collect_var ht_opmem
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
      s_right_noralized=s_right.gsub(/([\s]|[\t])+/,$kibuvits_lc_space)

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
         configstylestr_2_ht_collect_var ht_opmem
         return
      end # if

      i_n_of_spaces=Kibuvits_str.count_substrings(s_right_noralized,$kibuvits_lc_space)
      if i_n_of_spaces==0
         ht_opmem['b_in_heredoc']=true
         ht_opmem['s_heredoc_endtag']=ht_opmem['s_hredoc_end_tag_default']
         return
      end # if
      if i_n_of_spaces==1
         i_space_ix=s_right_noralized.index($kibuvits_lc_space)
         s_irrelevant,s_heredoc_endtag=Kibuvits_ix.bisect_at_sindex(
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
   end # configstylestr_2_ht_azl_nonheredoc

   def configstylestr_2_ht_create_ht_opmem(msgcs)
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
   end # configstylestr_2_ht_create_ht_opmem


   public
   # A word of warning is that unlike configurations utilities,
   # i.e. settings dialogs, configurations files do not check the
   # consistency of the configuration and do not assist the user.
   # For example, in the case of a configurations dialog, it's possible
   # to change the content of one menu based on the selection of the other.
   #
   # Configurations string format example:
   #
   #-the-start-of-the-configstylestr_2_ht-usage-example-DO-NOT-CHANGE-THIS-LINE
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
   # selftests. The configstylestr_2_ht selftest code extracts it
   # from the KRL ruby file, where the configstylestr_2_ht is defined.
   #
   #-the-end---of-the-configstylestr_2_ht-usage-example-DO-NOT-CHANGE-THIS-LINE
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
   def configstylestr_2_ht(s_a_config_file_style_string,
      msgcs=Kibuvits_msgc_stack.new)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_a_config_file_style_string
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      s_in=Kibuvits_str.normalise_linebreaks(s_a_config_file_style_string)
      ht_opmem=configstylestr_2_ht_create_ht_opmem msgcs
      s_in.each_line do |s_line_with_optional_linebreak_character|
         s_line=Kibuvits_str.clip_tail_by_str(
         s_line_with_optional_linebreak_character,$kibuvits_lc_linebreak)
         ht_opmem['s_line']=s_line
         if ht_opmem['b_in_heredoc']
            configstylestr_2_ht_azl_heredoc ht_opmem
         else
            configstylestr_2_ht_azl_nonheredoc ht_opmem
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
   end # configstylestr_2_ht

   def Kibuvits_deprecated_str.configstylestr_2_ht(s_a_config_file_style_string,
      msgcs=Kibuvits_msgc_stack.new)
      ht_out=Kibuvits_deprecated_str.instance.configstylestr_2_ht(
      s_a_config_file_style_string,msgcs)
      return ht_out
   end # Kibuvits_deprecated_str.configstylestr_2_ht

   #-----------------------------------------------------------------------
   include Singleton

end # class Kibuvits_deprecated_str
