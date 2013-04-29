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

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
require  KIBUVITS_HOME+"/src/include/bonnet/kibuvits_os_codelets.rb"

#==========================================================================
# It's used for placing console arguments to a hashtable.
class Kibuvits_argv_parser

   public
   def initialize
   end #initialize

   private

   def init_ht_args ht_grammar
      ht_args=Hash.new
      ht_grammar.each_pair do |key,value|
         if KIBUVITS_b_DEBUG
            bn=binding()
            kibuvits_typecheck bn, Fixnum, value
            kibuvits_typecheck bn, String, key
         end # if
         kibuvits_throw 'key==""' if key==""
         rgx=/^[-][\w\d]*/
         if rgx.match(key)==nil
            kibuvits_throw 'The ht_grammar key(=='+key+") doesn't match a regex."
         end # if
         kibuvits_throw "ht_grammar["+key+"]=="+value.to_s+" < (-1)" if value<(-1)
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
         ar1=Kibuvits_str.bisect(s_arg,"=")
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
         kibuvits_throw "Console variable name not declared. var_name=="+
         var_name.to_s+'. error 1'
      end # if
      kibuvits_throw "ar_values==nil, error 2" if ar_values==nil
      i_n_left2read=ht_opmem['i_n_left2read']
      kibuvits_throw "i_n_left2read==nil, error 3" if i_n_left2read==nil
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
         kibuvits_throw 'Console argument happens to be an empty string.'+
         ' As the ARGV never contains empty strings, or at least it '+
         'ought not to contain them, the fault is either in this code '+
         'or somewhere else. The fault can be somewhere outside the '+
         'code of the Kibuvits_argv_parser, because it is possible to '+
         'assemble an ARGV substitute and feed it into the '+
         'Kibuvits_argv_parser.'
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
   def run ht_grammar, argv, msgcs
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_grammar
         kibuvits_typecheck bn, Array, argv
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      kibuvits_throw "ht_grammar is empty." unless 0<ht_grammar.keys.length
      ht_args=init_ht_args ht_grammar
      return ht_args if msgcs.b_failure
      msgc=Kibuvits_msgc.new
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

   def Kibuvits_argv_parser.run(ht_grammar,argv,msgcs)
      ht_args=Kibuvits_argv_parser.instance.run(
      ht_grammar,argv,msgcs)
      return ht_args
   end # Kibuvits_argv_parser.run



   def normalize_parsing_result_verify_ar_synonyms(
      ar_synonyms, s_target,msgcs)
      x=ar_synonyms.uniq
      if msgcs!=nil
         if KIBUVITS_b_DEBUG
            #puts "\nx=="+Kibuvits_str.array2xseparated_list(x)+
            #"\nar_synonyms=="+
            #Kibuvits_str.array2xseparated_list(ar_synonyms)+"\n"+
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
      s_duplicates=Kibuvits_str.array2xseparated_list(ar_duplicates)
      kibuvits_throw "ar_synonyms.uniq.length=="+x.length.to_s+
      "!=ar_synonyms.length=="+ar_synonyms.length.to_s+
      " for ht_normalization_specification['"+s_target+"']. "+
      "The duplicates are: "+s_duplicates+". "
   end # normalize_parsing_result_verify_ar_synonyms

   def normalize_parsing_result_verify_ar_args_elem_type(
      ar_args, s_target, b_ht_args)
      ar_args.each do |x|
         if x.class!=String
            if b_ht_args
               kibuvits_throw "The array that is stored to "+
               "ht_args['"+s_target+"'] had a non-string element "+
               "with the value of "+x.to_s+" ."
            else
               kibuvits_throw "The array that is stored to "+
               "ht_normalization_specification['"+
               s_target+"'] had a non-string element "+
               "with the value of "+x.to_s+" ."
            end # if
         end # if
      end # loop
   end # normalize_parsing_result_verify_ar_args_elem_type

   public

   # The ht_args is the Kibuvits_argv_parser.run output.
   #
   # The idea behind the Kibuvits_argv_parser.normalize_parsing_result
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
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Hash, ht_normalization_specification
         kibuvits_typecheck bn, Hash, ht_args
         kibuvits_typecheck bn, [Kibuvits_msgc_stack,NilClass],msgcs
      end # if
      ht_spec=ht_normalization_specification
      if ht_spec.length==0
         kibuvits_throw "ht_normalization_specification.length==0 does "+
         "not make sense."
      end # if
      ar_converged=nil
      ar_args=nil
      b_ar_synonyms_contains_s_target=false
      x=nil
      ht_spec.each_pair do |s_target,ar_synonyms| # == |key,value|
         if !ht_args.has_key? s_target
            kibuvits_throw "ht_args does not have a key of \""+s_target+
            "\", but the key is present in the "+
            "ht_normalization_specification."
         end # if
         if ar_synonyms.class!=Array
            kibuvits_throw "ht_normalization_specification['"+s_target+
            "'].class!=Array ."
         end # if
         if s_target.class!=String
            kibuvits_throw "ht_normalization_specification keys are "+
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
               kibuvits_throw "ht_normalization_specification['"+s_target+"']"+
               " contains element \""+s_synonym+"\", which is "+
               "not among the keys of the ht_args. "
            end # if
            if s_synonym.class!=String
               kibuvits_throw "s_synonym.class=="+s_synonym.class.to_s+
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
               kibuvits_throw "A key of the ht_normalization_specification, "+
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

   def Kibuvits_argv_parser.normalize_parsing_result(
      ht_normalization_specification, ht_args, msgcs=nil)
      Kibuvits_argv_parser.instance.normalize_parsing_result(
      ht_normalization_specification, ht_args,msgcs)
   end # Kibuvits_argv_parser.normalize_parsing_result

   def verify_parsed_input_verification_step(s_arg,i_count,ht_args,
      msgcs, b_assume_args_to_be_all_compulsory=false)
      bn=nil
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck(bn, String, s_arg,
         "The s_arg is a key of the ht_grammar.")
         kibuvits_typecheck(bn, Fixnum, i_count,
         "The i_count==ht_grammar['"+s_arg+"'].")
         kibuvits_typecheck(bn, Hash, ht_args)
      end # if
      if !ht_args.has_key? s_arg
         kibuvits_throw "ht_args does not have a key that equals with \""+
         s_arg+"\"."
      end # if
      # The msgcs instance passed the typecheck in the parent function.
      ar_args=ht_args[s_arg]
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck(bn, [Array,NilClass], ar_args,
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
      if KIBUVITS_b_DEBUG
         bn=binding();
         kibuvits_typecheck bn, Hash, ht_grammar
         kibuvits_typecheck bn, Hash, ht_args
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ht_grammar.each_pair do |s_arg,i_count|
         verify_parsed_input_verification_step(s_arg,i_count,
         ht_args,msgcs,false)
         break if msgcs.b_failure
      end # loop
   end # verify_parsed_input

   def  Kibuvits_argv_parser.verify_parsed_input(ht_grammar, ht_args, msgcs)
      Kibuvits_argv_parser.instance.verify_parsed_input(ht_grammar,ht_args,msgcs)
   end # Kibuvits_argv_parser.verify_parsed_input


   def verify_compulsory_input(s_or_ar_console_arg_name,
      ht_grammar,ht_args,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding();
         kibuvits_typecheck bn, [String,Array], s_or_ar_console_arg_name
         kibuvits_typecheck bn, Hash, ht_grammar
         kibuvits_typecheck bn, Hash, ht_args
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ar_compulsory_args=Kibuvits_ix.normalize2array(
      s_or_ar_console_arg_name)
      i_count=nil
      ar_compulsory_args.each do |s_arg|
         if !ht_grammar.has_key? s_arg
            kibuvits_throw "ht_grammar does not have a key that equals "+
            "with \""+s_arg.to_s+"\"."
         end # if
         i_count=ht_grammar[s_arg]
         verify_parsed_input_verification_step(s_arg,i_count,
         ht_args,msgcs,true)
         break if msgcs.b_failure
      end # loop
   end # verify_compulsory_input

   def Kibuvits_argv_parser.verify_compulsory_input(s_or_ar_console_arg_name,
      ht_grammar,ht_args,msgcs)
      Kibuvits_argv_parser.instance.verify_compulsory_input(
      s_or_ar_console_arg_name, ht_grammar,ht_args,msgcs)
   end # Kibuvits_argv_parser.verify_compulsory_input

   include Singleton

end # class Kibuvits_argv_parser

#==========================================================================
