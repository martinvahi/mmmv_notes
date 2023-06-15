#!/usr/bin/env ruby
#==========================================================================
=begin
 Initial author: Martin.Vahi@softf1.com
 This file is in the public domain, except the 
 Kibuvits Ruby Library parts, which are under the BSD license.
 The following line is a spdx.org license label line:
 SPDX-License-Identifier: BSD-3-Clause-Clear

---------------------------------------------------------------------------
 Tested with ("ruby -v")

 ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]

 on ("uname -a")

 Linux terminal01 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux

---------------------------------------------------------------------------

 Copyright 2019, Martin.Vahi@softf1.com that has an
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
#--------------------------------------------------------------------------
# Ruby language version related normalization:
#--------------------------------------------------------------------------
# Most Ruby versions prior to Ruby version 3.2.0
# had that method. This code makes old code that
# worked with those older Ruby versions
# work with the Ruby version 3.2.0 .
if !defined? File.exists?
   def File.exists? x
      b=File.exist? x
      return b
   end # File.exists?
end # if
# Ruby 2.4.0 introduced a change, where
# classes Fixnum and Bignum were deprecated
# their use triggered a warning text to stderr
# and their common parent class, Integer,
# was expected to be used instead of them.
# Ruby version 2.7.2 removed the warning from the stderr.
# Ruby version 3.2.0 missed the classes, Fixnum and Bignum.
# The following 2 if-clauses keep the old code working.
if !defined? Fixnum
   Fixnum=Integer
end # if
if !defined? Bignum
   Bignum=Integer
end # if
#--------------------------------------------------------------------------
$s_doc_github_repos_2_clonescript_bash_t1_s=<<DESCRIPTION
#
# A video introduction to this script MIGHT be available from
#
#     https://longterm.softf1.com/documentation_fragments/2018/2018_12_18_GitHub_Clonescript_Generator_demo_01.webm
#     or
#     https://web.archive.org/web/20200310170413/https://longterm.softf1.com/documentation_fragments/2018/2018_12_18_GitHub_Clonescript_Generator_demo_01.webm
#
# It is an extra simplistic script that reads in
# the file named "repos" from the working directory and
# creates a file "clonescript.bash" to the working directory.
# The file "repos" is expected to contain lines like
#
#     "clone_url": "https://github.com/martinvahi/mmmv_devel_tools.git",
#
# and it is expected to be created by using the wget at
# the GitHub API like
#
#     wget https://api.github.com/users/martinvahi/repos
#
# but this Ruby script can do the wget part automatically, 
# if given the GitHub user account URL 
# as the 1. console argument. An example:
#
#     <file path to this script> https://github.com/martinvahi
#
# Optionally the espeak speech synthesis program is used 
# for some messages, provided that it is available on the PATH.
# The use of the speech synthesis can be turned off by setting the
#
#      @b_config_use_speech_synthesis=false
#
# at the constructor of the only class that has been 
# declared at this Ruby script.
#
#
# COMMAND_LINE_ARGS :== <GitHub user account URL> | HELP | TESTS | CLEAR_CMDS 
#              HELP :== "help" | "-?" | "-h"
#             TESTS :== "test_0" | "test_1" | TEST_2 | "test_3"
#            TEST_2 :== "test"   | "test_2"
#        CLEAR_CMDS :== CLEAR | DELETE_CLONINGSCRIPT | DELETE_REPOS
#
#             CLEAR :== "clear" | "cl" | "clean"  # deletes files "repos" 
#                                                 # and "cloningscript.bash"
#
#  DELETE_CLONINGSCRIPT :== "delete_cloningscript" | "clc"
#          DELETE_REPOS :== "delete_repos" | "clr"
#
#
# A similar, but much more advanced, project has been done by Jay Gabriels
#     http://www.jaygabriels.com/
# As of 2021_03_14 his project can be found from
#     https://github.com/gabrie30/ghorg
#
DESCRIPTION
#$s_doc_github_repos_2_clonescript_bash_t1_s.gsub!(/^[#]/," ") # because
# src formatter can't handle heredoc properly
#--------------------------------------------------------------------------
require "thread"

#------the--start--of--boilerplate-----------------------------------------
$kibuvits_lc_emptystring="".freeze
$kibuvits_lc_linebreak="\n".freeze
$kibuvits_lc_doublelinebreak="\n\n".freeze
$kibuvits_lc_rbrace_linebreak=");\n".freeze
$kibuvits_lc_mx_streamaccess=Monitor.new
KIBUVITS_b_DEBUG=true

#--------------------------------------------------------------------------
$kibuvits_var_b_running_selftests=false
$kibuvits_var_b_module_fileutils_loaded=false
#-------------

def kibuvits_write(x_in)
   $kibuvits_lc_mx_streamaccess.synchronize do
      # The "" is just for reducing the probability of
      # mysterious memory sharing related quirk-effects.
      #--------------
      # The classical version
      print $kibuvits_lc_emptystring+x_in.to_s
      #--------------
      # A more explicit version
      #$stdout.write(sprintf("s", x_in))
   end # synchronize
end # kibuvits_write
def kibuvits_writeln(x_in)
   $kibuvits_lc_mx_streamaccess.synchronize do
      # The "" is just for reducing the probability of
      # mysterious memory sharing related quirk-effects.
      puts $kibuvits_lc_emptystring+x_in.to_s
   end # synchronize
end # kibuvits_writeln

#--------------------------------------------------------------------------

def kibuvits_s_exception_2_stacktrace(e)
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
end # kibuvits_s_exception_2_stacktrace

# The a_binding is an optional parameter of type Binding.
#
# If the a_binding!=nil, then the exception is thrown
# in the scope that is referenced by the a_binding.
#
# The kibuvits_throw(...) does not depend on any
# other parts of the Kibuvits Ruby Library.
def kibuvits_throw(s_or_ob_exception,a_binding=nil)
   # Due to the lack of dependence on other
   # functions the implementation here is quite
   # verbose and duplicating, but that's the
   # compromise where elegant core API is favoured
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
   # contains the call to the kibuvits_throw(...), regardless
   # of the value of the a_binding, because the flaw that caused
   # verification failure resides in the scope, where the
   # call to the kibuvits_throw(...) was made.
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
      if KIBUVITS_b_DEBUG
         if !$kibuvits_var_b_running_selftests
            s_fp_mmmv_devel_tools_console_ui=ENV["MMMV_DEVEL_TOOLS_HOME"]+
            "/src/api/mmmv_devel_tools_console_ui.bash"
            if File.exists? s_fp_mmmv_devel_tools_console_ui
               s_0=` $MMMV_DEVEL_TOOLS_HOME/src/api/mmmv_devel_tools_console_ui.bash \
               get_config s_GUID_trace_errorstack_file_path `
               s_1=s_0.gsub(/[\n\r]/,$kibuvits_lc_emptystring)
               if File.exists? s_1
                  # A bit flawed, because sometimes the file has
                  # to be created, for example, after all caches
                  # have been erased, but this if-branch here is
                  # such a hack that one does not risk creating the file.
                  # The next is a crippled, checkless copy-paste from
                  # kibuvits_os.rb
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
      exc=Exception.new($kibuvits_lc_doublelinebreak+
      x_in+$kibuvits_lc_doublelinebreak)
   else # x_in.class is derived from or equal to the Exception.
      exc=x_in
   end # if
   #-------------------------------------
   # The following adds a stack trace to the exception message.
   # ar_stack_trace=exc.backtrace.reverse
   # s_lc_separ="--------------------"
   # s_lc_linebreak="\n"
   # s_msg=exc.to_s+s_lc_linebreak+kibuvits_s_exception_2_stacktrace(exc)
   # exc=Exception.new(s_msg)
   #-------------------------------------
   raise(exc) if a_binding==nil # stops a recursion.
   #-------------------------------------
   # The start of the "kibuvits_throw_in_scope".
   ar=[exc]
   s_script=$kibuvits_lc_kibuvits_set_var_in_scope_s1+
   ar.object_id.to_s+$kibuvits_lc_rbrace_linebreak+
   "kibuvits_throw_x_exc"+$kibuvits_lc_kibuvits_set_var_in_scope_s2+
   "kibuvits_throw(kibuvits_throw_x_exc)\n"
   eval(s_script,a_binding)
end # kibuvits_throw

#--------------------------------------------------------------------------
$kibuvits_lc_kibuvits_varname2varvalue_s1=($kibuvits_lc_emptystring+
"kibuvits_varname2varvalue_ar=ObjectSpace._id2ref(").freeze
$kibuvits_lc_kibuvits_varname2varvalue_s2=($kibuvits_lc_rbrace_linebreak+
"kibuvits_varname2varvalue_ar<<").freeze

# Returns the value that the variable :s_varname
# has within the scope that is being referenced by
# the a_binding. The ar_an_empty_array_for_reuse_only_for_speed
# is guaranteed to be empty after this function exits.
def kibuvits_varname2varvalue(a_binding, s_varname,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   s_script=$kibuvits_lc_kibuvits_varname2varvalue_s1+
   ar.object_id.to_s+$kibuvits_lc_kibuvits_varname2varvalue_s2+
   s_varname+$kibuvits_lc_linebreak
   eval(s_script,a_binding)
   kibuvits_throw("ar.size==0") if ar.size==0
   x=ar[0]
   # even the kibuvits_s_varvalue2varname_t1 depends on the emptiness of the ar
   ar.clear
   return x
end # kibuvits_varname2varvalue

#--------------------------------------------------------------------------

$kibuvits_lc_kibuvits_s_varvalue2varname_t1_script1=($kibuvits_lc_emptystring+
"s_varname=nil\n"+
"x=nil\n"+
"ar_tmp_for_speed=kibuvits_s_varvalue2varname_t1_tmp_ar\n"+ # an instance reuse speedhack
"local_variables.each do |s_varname_or_symbol|\n"+
"    s_varname=s_varname_or_symbol.to_s\n"+
"    x=kibuvits_varname2varvalue(binding(),s_varname,ar_tmp_for_speed)\n"+
"    if x.object_id==kibuvits_s_varvalue2varname_t1_tmp_i_objectid \n"+
"        kibuvits_s_varvalue2varname_t1_tmp_ar<<s_varname\n"+
"        break \n"+
"    end #if\n"+
"end #loop\n").freeze

$kibuvits_lc_kibuvits_s_varvalue2varname_t1_s1=($kibuvits_lc_emptystring+
"kibuvits_s_varvalue2varname_t1_tmp_ar=ObjectSpace._id2ref(").freeze

$kibuvits_lc_kibuvits_s_varvalue2varname_t1_s2=($kibuvits_lc_emptystring+
"kibuvits_s_varvalue2varname_t1_tmp_i_objectid=(").freeze

# Returns an empty string, if the variable could
# not be found from the scope. The
# ar_an_empty_array_for_reuse_only_for_speed is guaranteed
# to be empty after the exit of this function.
#
# Its tests are part of the tests of its wrapper, the
#
#     kibuvits_s_varvalue2varname_t2(...)
#
def kibuvits_s_varvalue2varname_t1(a_binding, ob_varvalue,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   s_script=$kibuvits_lc_kibuvits_s_varvalue2varname_t1_s1+
   ar.object_id.to_s+$kibuvits_lc_rbrace_linebreak+
   $kibuvits_lc_kibuvits_s_varvalue2varname_t1_s2+
   ob_varvalue.object_id.to_s+$kibuvits_lc_rbrace_linebreak+
   $kibuvits_lc_kibuvits_s_varvalue2varname_t1_script1 # instance reuse

   eval(s_script,a_binding)
   # Actually a scope may contain multiple variables
   # that reference the same instance, but due to
   # performance considerations this function here
   # is expected to stop the search right after it
   # has found one of the variables or searched the whole scope.
   i=ar.size
   if 1<i
      ar.clear # due to the possible speed related array reuse
      kibuvits_throw("1<ar.size=="+i.to_s)
   end # if
   s_varname=nil
   if ar.size==0
      # It's actually legitimate for the instance to
      # miss a variable, designating symbol, within the scope that
      # the a_binding references, because the instance
      # might have been referenced by an object id or by some
      # other way by using reflection or fed in like
      # kibuvits_s_varvalue2varname_t1(binding(), an_awesome_function())
      s_varname=$kibuvits_lc_emptystring
   else
      s_varname=ar[0]
      ar.clear
   end # if
   return s_varname
end # kibuvits_s_varvalue2varname_t1

#--------------------------------------------------------------------------

# The only purpose of this function is to package the
#
#     kibuvits_s_varvalue2varname_t1(...)
#
# together with some more common code that usually
# goes around the kibuvits_s_varvalue2varname_t1(...).
# That is to say, hopefully it makes the client code
# a bit more compact.
def kibuvits_s_varvalue2varname_t2(a_binding, ob_varvalue,
   s_output_if_varname_not_found_from_the_binding,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   s_varname_candidate=kibuvits_s_varvalue2varname_t1(
   a_binding, ob_varvalue,ar_an_empty_array_for_reuse_only_for_speed)
   s_varname=nil
   if s_varname_candidate.length==0
      s_varname=s_output_if_varname_not_found_from_the_binding
   else
      s_varname=s_varname_candidate
   end # if
   return s_varname
end # kibuvits_s_varvalue2varname_t2

#--------------------------------------------------------------------------

$kibuvits_lc_kibuvits_set_var_in_scope_s1=($kibuvits_lc_emptystring+
"kibuvits_set_var_in_scope_tmp_ar=ObjectSpace._id2ref(").freeze
$kibuvits_lc_kibuvits_set_var_in_scope_s2=($kibuvits_lc_emptystring+
"=kibuvits_set_var_in_scope_tmp_ar[0]\n").freeze

# The ar_an_empty_array_for_reuse_only_for_speed is guaranteed
# to be empty after the exit of this function.
def kibuvits_set_var_in_scope(a_binding, s_varname,x_varvalue,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   ar<<x_varvalue
   s_script=$kibuvits_lc_kibuvits_set_var_in_scope_s1+
   ar.object_id.to_s+$kibuvits_lc_rbrace_linebreak+
   s_varname+$kibuvits_lc_kibuvits_set_var_in_scope_s2
   eval(s_script,a_binding)
   ar.clear
end # kibuvits_set_var_in_scope


#--------------------------------------------------------------------------

# a_binding==Kernel.binding()
def kibuvits_typecheck(a_binding,
   expected_class_or_an_array_of_expected_classes,
   a_variable,s_msg_complement=nil)
   if KIBUVITS_b_DEBUG
      if a_binding.class!=Binding
         kibuvits_throw("\nThe class of the 1. argument of the "+
         "function kibuvits_typecheck,\n"+
         "the a_binding, is expected to be Binding, but the class of \n"+
         "the received value was "+a_binding.class.to_s+
         ".\na_binding.to_s=="+a_binding.to_s+"\n")
      end # if
      cl=s_msg_complement.class
      if (cl!=String)&&(cl!=NilClass)
         kibuvits_throw("\nThe class of the 3. argument of the "+
         "function kibuvits_typecheck,\n"+
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
         kibuvits_throw("\nThe class of the 2. argument of the "+
         "function kibuvits_typecheck,\n"+
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
      # kibuvits_typecheck(binding(),NiceClass, an_awesome_function())
      s_varname=kibuvits_s_varvalue2varname_t1(a_binding,
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
      kibuvits_set_var_in_scope(a_binding,
      "kibuvits_typecheck_s_msg",s,ar_tmp_for_speed)
      eval("kibuvits_throw(kibuvits_typecheck_s_msg)\n",a_binding)
   end # if
   return b_failure
end # kibuvits_typecheck

#--------------------------------------------------------------------------

# A boilerplate related comment:
# An explanation, why the watershed concatenation
# gives any speedup at all, MIGHT be avaliable from
# https://github.com/martinvahi/mmmv_notes/tree/master/mmmv_notes/phenomenon_scrutinization/string_concatenation
def kibuvits_s_concat_array_of_strings_watershed(ar_in)
   s_lc_emptystring=""
   if defined? KIBUVITS_b_DEBUG
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Array, ar_in
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
end # kibuvits_s_concat_array_of_strings_watershed


def kibuvits_s_concat_array_of_strings(ar_in)
   s_out=kibuvits_s_concat_array_of_strings_watershed(ar_in)
   return s_out;
end # kibuvits_s_concat_array_of_strings

#--------------------------------------------------------------------------

def str2file(s_a_string, s_fp)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String, s_a_string
      kibuvits_typecheck bn, String, s_fp
   end # if
   $kibuvits_lc_mx_streamaccess.synchronize do
      begin
         file=File.open(s_fp, "w")
         file.write(s_a_string)
         file.close
      rescue Exception =>err
         raise(Exception.new(
         "No comments. \n"+
         "s_a_string=="+s_a_string+"\n"+err.to_s+"\n\n"+
         "GUID='5ed7ad52-e5bf-4f2b-95d1-1201b0a127e7' \n"))
      end #
   end # synchronize
end # str2file


def file2str(s_file_path)
   s_out=$kibuvits_lc_emptystring
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String, s_file_path
   end # if

   $kibuvits_lc_mx_streamaccess.synchronize do
      # The idea here is to make the file2str easily copy-pastable to projects that
      # do not use the Kibuvits Ruby Library.
      s_fp=s_file_path
      ar_lines=Array.new
      begin
         File.open(s_fp) do |file|
            while line = file.gets
               ar_lines<<$kibuvits_lc_emptystring+line
            end # while
         end # Open-file region.
         s_out=kibuvits_s_concat_array_of_strings(ar_lines)
      rescue Exception =>err
         raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+
         s_file_path+
         "\n GUID='d48bbd23-5e03-4a1d-a8d1-1201b0a127e7'\n\n"))
      end #
   end # synchronize
   return s_out
end # file2str

#------the--end--of--boilerplate-------------------------------------------

class GitHub_repos_2_clonescript_bash_t1

   # According to tests with Ruby version 2.5.1p57
   # a Mutex-protected region can NOT be re-entered by the same thread and
   # a Monitor-protected region CAN be re-entered by the same thread.
   @@mx_speech_synthesis=Mutex.new  # static variable
   @@mx_repos_file_write=Mutex.new  # static variable

   def s_help_doc()
      if !defined? @b_s_help_doc_inited
         # Because src formatter can't handle heredoc properly.
         @s_help_doc_cache=$s_doc_github_repos_2_clonescript_bash_t1_s.gsub!(/^[#]/," ")
         @b_s_help_doc_inited=true
         @s_help_doc_cache.freeze
      end # if
      return @s_help_doc_cache
   end # s_help_doc

   def initialize
      # A nice thing about the constructor is that
      # it is guaranteed to have only a single thread
      # per instance entering it. This code depends on that assumption.
      @s_lc_2devnull=" 2> /dev/null ".freeze
      #------------------------------------------------------
      @b_use_speechless_throw_mode=true # a quirk to reduce code
      # If the previous line ==false,
      # then the next line may enter infinite recursion.
      @b_espeak_available=(!b_is_missing_from_the_path_01("espeak"))
      @b_use_speechless_throw_mode=false#regardless of the previous line outcome
      #-----------------
      @ar_argv=Array.new # allows override and autoassignment at test modes
      i_len=ARGV.size
      i_len.times{|i| @ar_argv<<ARGV[i]}
      #-----------------
      @ht_argv_help_options=Hash.new
      @ht_argv_help_options["-?"]=42
      @ht_argv_help_options["-h"]=42
      @ht_argv_help_options["h"]=42
      @ht_argv_help_options["?"]=42
      @ht_argv_help_options["--help"]=42
      @ht_argv_help_options["-help"]=42
      @ht_argv_help_options["help"]=42
      @ht_argv_help_options["--abi"]=42
      @ht_argv_help_options["-abi"]=42
      @ht_argv_help_options["abi"]=42
      @ht_argv_help_options["--apua"]=42
      @ht_argv_help_options["-apua"]=42
      @ht_argv_help_options["apua"]=42
      #----config---start------------------------------------
      @b_config_use_speech_synthesis=true
   end # initialize

   private

   def speak_if_possible(s_text,s_suffix_2_print_without_pronounciation="")
      cl_0=s_text.class
      if cl_0!=String
         @b_use_speechless_throw_mode=true # to break infinite recursion
         angervaks_throw("s_text.class=="+cl_0.to_s+"\n"+
         "GUID=='44cdf72f-30a8-4b56-83d1-1201b0a127e7'")
      end # if
      #--------
      cl_1=s_suffix_2_print_without_pronounciation.class
      if cl_1!=String
         @b_use_speechless_throw_mode=true # to break infinite recursion
         angervaks_throw("s_suffix_2_print_without_pronounciation.class=="+
         cl_1.to_s+"\n"+
         "GUID=='2d6dda42-4c16-49af-83d1-1201b0a127e7'")
      end # if
      #--------
      @@mx_speech_synthesis.synchronize{
         #--------
         puts(s_text+s_suffix_2_print_without_pronounciation+"\n")
         #----
         if @b_config_use_speech_synthesis
            if @b_espeak_available
               b_0=@b_use_speechless_throw_mode
               @b_use_speechless_throw_mode=true
               exc_angervaks_sh("nice -n2 espeak \""+
               s_text.gsub(/([\$^\/\\"';^%()\[\]\{\}|-]|[+]|[*])+/," ")+
               "\""+@s_lc_2devnull)
               @b_use_speechless_throw_mode=b_0
            end # if
         end # if
      } # synchronize
   end # speak_if_possible

   def angervaks_throw(s_in,s_optional_guid_candidate=nil)
      if !@b_use_speechless_throw_mode
         puts "\n"
         speak_if_possible("Failure. Script aborted.")
         puts "\n"
      end # if
      #----------------------------
      s_err="\n\n"+s_in+"\n"
      if s_optional_guid_candidate.class==String # !=NilClass
         s_err<<("GUID=='"+s_optional_guid_candidate+"'\n")
      end # if
      s_err<<"GUID=='c0ef8141-9d84-4510-92d1-1201b0a127e7'\n\n"
      #--------
      #raise(Exception.new(s_err))
      kibuvits_throw(s_err)
   end # angervaks_throw


   def exc_angervaks_sh(s_cmd)
      begin
         # Kernel.system(...) return values:
         #     true  on success, e.g. program returns 0 as execution status
         #     false on successfully started program that
         #              returns nonzero execution status
         #     nil   on command that could not be executed
         x_success=system(s_cmd)
         if x_success!=true
            angervaks_throw("Shell execution failed. \n"+
            "The command line was:\n"+s_cmd,
            "9fbda147-585c-42b4-a3d1-1201b0a127e7")
         end # if
      rescue Exception=>e
         angervaks_throw("Shell execution failed.\n"+
         "The command line was:\n"+s_cmd+"\n"+"e.to_s=="+e.to_s,
         "f8e20a43-2e1f-4ab5-94d1-1201b0a127e7")
      end # try-catch
   end # exc_angervaks_sh


   # The general idea:
   #
   #     bash -c "which <s_console_application_name>"
   #
   def b_is_missing_from_the_path_01(s_console_application_name)
      #------------------------
      s_0=s_console_application_name.gsub(/[\s\n\r\t]+/,"")
      if s_0.size!=s_console_application_name.size
         angervaks_throw("This function implementation does not allow \n"+
         "spaces or tabs at the console application name.\n"+
         "GUID=='2a3f25a1-65b9-419f-b8d1-1201b0a127e7'")
      end # if
      #------------------------
      b_missing_from_path=false
      begin
         exc_angervaks_sh("which "+s_console_application_name+
         " > /dev/null "+@s_lc_2devnull)
      rescue Exception=>e
         b_missing_from_path=true
      end # try-catch
      return b_missing_from_path
   end # b_is_missing_from_the_path_01


   # A nice test repository:
   #
   #     https://github.com/gnustep
   #
   def exc_s_wget_repos_if_needed(ht_opmem)
      s_out=nil
      s_fp_repos=ht_opmem["s_fp_repos"]
      if File.exists? s_fp_repos
         if File.directory? s_fp_repos
            angervaks_throw("The \n\n"+s_fp_repos+"\n\n"+
            "exists, but it is a folder. \n"+
            "It is expected to be a file.\n"+
            "GUID=='24c3c833-5d13-45b5-a1d1-1201b0a127e7'")
         end # if
         if File.symlink? s_fp_repos
            angervaks_throw("The \n\n"+s_fp_repos+"\n\n"+
            "exists, but it is a symlink. \n"+
            "It is expected to be a file.\n"+
            "GUID=='6dbee758-de30-4364-84d1-1201b0a127e7'")
         end # if
         if 1<@ar_argv.size
            angervaks_throw("The code of this script is flawed.\n"+
            "GUID=='0cf4b744-8d0b-41c2-83d1-1201b0a127e7'")
         end # if
         if @ar_argv.size==1
            #--------------------
            s_argv_0=@ar_argv[0].to_s
            rgx_0=/^http[s]?[:][\/]+[^\/]+/
            b_looks_like_an_url=false
            b_looks_like_an_url=true if s_argv_0.match(rgx_0)!=nil
            #--------------------
            s_err="The \n\n"+s_fp_repos+"\n\n"+
            "exists, but "
            if b_looks_like_an_url
               s_err<<"there seems to be an URL\n"
               s_err<<"given as the 1. command line argument.\n"
               s_err<<"To use a new version of the \n\n"+s_fp_repos+"\n\n"
               s_err<<"the old version of it must be explicitly deleted.\n"
            else
               s_err<<"there is also something nonconformant\n"
               s_err<<"given as the 1. command line argument.\n"
               s_err<<"May be the 1. command line argument.\n"
               s_err<<"should be a GitHub user account URL?\n"
            end # if
            angervaks_throw(s_err+
            "GUID=='63b2147e-6c34-4fd0-a6c1-1201b0a127e7'")
         end # if
         s_out=file2str(s_fp_repos)
         return s_out
      end # if
      #--------------------
      if @ar_argv.size==0
         angervaks_throw("The file \n\n"+s_fp_repos+"\n\n"+
         "is missing. It MIGHT be auto-created by \n"+
         "giving this Ruby script the GitHub user account URL \n"+
         "as its 1. command line argument. An example of a valid URL:\n"+
         "\n"+
         "    https://github.com/martinvahi \n"+
         "\n"+
         "GUID=='19b92029-24d4-459b-a2c1-1201b0a127e7'")
      end  # if
      #----------------------------------------------------------
      #     https://github.com/martinvahi
      #     -->
      #     wget https://api.github.com/users/martinvahi/repos
      s_account_url_candidate=@ar_argv[0].to_s
      rgx_0=/^http[s]?:[\/][\/]?github[.]com[\/]+[^\s\/]+[\/]*$/
      md=s_account_url_candidate.match(rgx_0)
      if md==nil
         angervaks_throw("The optional 1. console argument \n"+
         "is expected to be either missing or it is \n"+
         "expected to be a GitHub user account URL, but it was \n\n"+
         s_account_url_candidate+"\n"+
         "\n"+
         "A GitHub user account URL format example:\n"+
         "\n"+
         "    https://github.com/martinvahi\n"+
         "\n"+
         "GUID=='13ebf482-3c3d-4981-83c1-1201b0a127e7'")
      end # if
      s_account_url=s_account_url_candidate.sub(/[\/]+$/,"")
      s_0=s_account_url.reverse
      s_1=s_0[0..(s_0.index("/")-1)]
      s_username=s_1.reverse
      #----------------------------------------------------------
      # https://developer.github.com/v3/#pagination
      # archival copy: https://archive.is/WFRyR
      #
      # The counting of pages starts from 1.
      # The maximum number of records per page is 100. An example:
      #
      #     https://api.github.com/users/"+s_username+"/repos?per_page=100&page=1
      #
      # A related bug report: https://github.com/asciimoo/searx/issues/1470
      #
      #--------
      s_download_application="wget"
      if b_is_missing_from_the_path_01(s_download_application)
         s_download_application="curl"
         if b_is_missing_from_the_path_01(s_download_application)
            angervaks_throw("It seems that both of the programs, \n"+
            "the wget and the curl, are missing from the PATH.\n"+
            "Failed to auto-create the \n\n"+s_fp_repos+"\n\n"+
            "GUID=='58ff874f-5e83-4984-b4c1-1201b0a127e7'")
         end # if
      end # if
      #----------------------
      s_api_url_prefix="https://api.github.com/users/"+s_username+
      "/repos?per_page=40&page="
      func_s_download_cmd=lambda do |i_page_number|
         if KIBUVITS_b_DEBUG
            bn=binding()
            cl=i_page_number.class
            if (cl!=Integer) # A hack to remove Ruby warning about the old Fixnum class.
               if (cl!=Fixnum)
                  kibuvits_typecheck(bn,[Integer],i_page_number,
                  "GUID=='29eb8474-8707-44bb-bbc1-1201b0a127e7'")
               end # if
            end # if
         end # if
         if i_page_number<1
            # https://developer.github.com/v3/#pagination
            # archival copy: https://archive.is/WFRyR
            angervaks_throw("The code of this script is flawed.\n"+
            "Minimum valid page number ==1."+
            "GUID=='323d604f-de3a-4ab5-92c1-1201b0a127e7'")
         end # if
         cl=s_download_application.class
         if cl!=String
            angervaks_throw("The code of this script is flawed.\n"+
            "cl=="+cl.to_s+"\n"+
            "GUID=='5d949743-13b2-46cd-b4c1-1201b0a127e7'")
         end # if
         #--------
         s_cmd_out=""
         case s_download_application
         when "wget"
            s_cmd_out="nice -n5 wget '"+
            s_api_url_prefix+i_page_number.to_s+
            "' --output-document="+Dir.getwd()+"/repos "+@s_lc_2devnull
         when "curl"
            s_cmd_out="nice -n5 curl '"+s_api_url_prefix+i_page_number.to_s+
            "' > "+s_fp_repos+@s_lc_2devnull
         else
            angervaks_throw("The code of this script is flawed.\n"+
            "s_download_application=="+s_download_application+"\n"+
            "GUID=='70771a46-5180-4fc0-85c1-1201b0a127e7'")
         end # case s_download_application
         return s_cmd_out
      end # func_s_download_cmd
      #----------------------------------------------------------
      i_max_n_of_seconds_to_wait_4_the_thread=30
      rgx_err_no_json=/^[\s\n\r\t]*[^\s\n\r\t\[]/
      rgx_spaces_tabs_linebreaks=/[\n\s\t\r]+/
      rgx_2=/^[\n\r\s\t]*[\[]/ # The "[" at the start of the page
      rgx_3=/[\]][\n\r\s\t]*$/ # The "]" at the end of the page
      s_repos_tmp=nil
      @@mx_repos_file_write.synchronize{
         ob_thread_0=Thread.new{
            # This thread is just to save some time.
            # The idea is that while the text is being
            # spoken, the wget can work in the background,
            # saving about one second of wall time.
            speak_if_possible("Downloading info about repositories",
            ": "+s_account_url)
         }
         i_api_url_suffix_page_number=1
         s_download_cmd=nil
         ob_exception=nil
         b_download_more_pages=true
         b_first_iteration=true
         ar_s=Array.new
         s_0=nil
         s_1=nil
         s_2=nil
         s_lc_0="[]"
         ar_s<<"[\n"
         while b_download_more_pages do
            s_download_cmd=func_s_download_cmd.call(i_api_url_suffix_page_number)
            begin
               # GitHub user account URL can be incorrect,
               # among other reasons, why the download can fail.
               exc_angervaks_sh(s_download_cmd)
            rescue Exception=>e
               ob_exception=e
            end # try-catch
            if ob_exception!=nil
               ob_thread_0.join(i_max_n_of_seconds_to_wait_4_the_thread)
               angervaks_throw(ob_exception.to_s+
               "GUID=='1f631c44-08a7-462b-95c1-1201b0a127e7'")
            end # if
            #--------
            if File.exists? s_fp_repos
               s_repos_tmp=file2str(s_fp_repos)
               #--------
               s_2=s_repos_tmp.gsub(rgx_spaces_tabs_linebreaks,
               $kibuvits_lc_emptystring)
               if s_2.match(rgx_err_no_json)!=nil
                  ob_thread_0.join(i_max_n_of_seconds_to_wait_4_the_thread)
                  angervaks_throw("Something went wrong. The downloaded \n"+
                  "text fails to meet the expectations of this script.\n"+
                  "May be this script should be updated?\n"+
                  "GUID=='07d2531e-c149-4f11-81c1-1201b0a127e7'")
               end # if
               b_download_more_pages=false if s_2==s_lc_0
               #--------
               s_0=s_repos_tmp.sub(rgx_2,$kibuvits_lc_emptystring)
               s_1=s_0.sub(rgx_3,$kibuvits_lc_emptystring)
               if (!b_first_iteration) && b_download_more_pages
                  # The idea with the b_download_more_pages here is that
                  # the very last page equals with the "[]"
                  # after all of the spaces-tabs/linebreaks
                  # have been removed and with that page there should NOT
                  # be the extra ",".
                  ar_s<<",\n"
               end # if
               ar_s<<s_1 if b_download_more_pages
               File.delete(s_fp_repos)
               if File.exists? s_fp_repos
                  ob_thread_0.join(i_max_n_of_seconds_to_wait_4_the_thread)
                  angervaks_throw(
                  "Deletion of a temporary version of the file \n"+
                  s_fp_repos+"\n"+"failed.\n"+
                  "GUID=='d425ac92-6f7b-4647-b2c1-1201b0a127e7'")
               end # if
            else
               ob_thread_0.join(i_max_n_of_seconds_to_wait_4_the_thread)
               angervaks_throw("The code of this script is flawed.\n"+
               "The temporary version of the file \n"+s_fp_repos+"\n"+
               "is missing.\n"+
               "GUID=='3d3195cb-7b13-4766-a2c1-1201b0a127e7'")
            end # if
            #-------------------
            if b_first_iteration
               ob_thread_0.join(i_max_n_of_seconds_to_wait_4_the_thread)
               print "    JSON pages: "
               b_first_iteration=false
            end # if
            print i_api_url_suffix_page_number.to_s+" "
            i_api_url_suffix_page_number+=1
            #--------
         end # loop
         puts "\n\n" # cosmetics
         ar_s<<"\n]\n"
         s_repos_tmp=kibuvits_s_concat_array_of_strings(ar_s)
         str2file(s_repos_tmp,s_fp_repos)
      } # synchronize
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_repos_tmp
      end # if
      s_out=s_repos_tmp
      return s_out
   end # exc_s_wget_repos_if_needed


   def exc_verify_file_existence_01(ht_opmem)
      s_fp_repos=ht_opmem["s_fp_repos"]
      s_fp_clonescript=ht_opmem["s_fp_clonescript"]
      #--------
      s_repos=exc_s_wget_repos_if_needed(ht_opmem)
      ht_opmem["s_repos"]=s_repos
      if !File.exists? s_fp_repos
         angervaks_throw("The file \n\n"+s_fp_repos+"\n\n"+
         "is missing.\n"+
         "GUID=='5096d026-1cd4-48b9-85c1-1201b0a127e7'")
      end # if
      if File.exists? s_fp_clonescript
         angervaks_throw("The file \n"+s_fp_clonescript+
         "\n already exists.\n"+
         "GUID=='915f4e50-89d2-4f79-93c1-1201b0a127e7'")
      end # if
   end # exc_verify_file_existence_01


   def run_exc_parse_s_repos_01(ht_opmem)
      #-----------------------------------------------------------------------
      # TODO: swap the dumb regex based parsing to some proper JSON parsing
      # The JSON parsing will not be much more reliable than the
      # current dumb regex version, because if the
      # location of the field at the JSON tree changes, then
      # as long as the JSON is formatted the way it currently(2018_12_18)
      # is, the dumb regex version will likely be able to handle the
      # changed version, but the proper JSON version would
      # need to be updated to reflect the location change of the field.
      # If there's no added reliability benefit to the proper JSON version,
      # then the current implementation might as well just stay a while.
      #-----------------------------------------------------------------------
      s_repos=ht_opmem["s_repos"]
      s_fp_repos=ht_opmem["s_fp_repos"]
      #--------------------------------------------
      # "clone_url": "https://github.com/martinvahi/mmmv_devel_tools.git",
      rgx_0=/^[\s]+["]clone_url["][:].+$/
      rgx_1=/^[\s]+["]clone_url["][:] "/
      rgx_2=/["][,][\s]*$/
      ar_matches=s_repos.scan(rgx_0)
      ar_s_giturl=Array.new
      s_0=nil
      s_1=nil
      s_lc_0=""
      ar_matches.each do |s_match|
         s_0=s_match.sub(rgx_1,s_lc_0)
         if s_0==s_match
            angervaks_throw("repos file format mismatch.\n"+
            "File path:\n\n"+s_fp_repos+"\n\n"+
            "s_0=="+s_0+"\n"+
            "GUID=='d3a28db0-e055-47fb-aac1-1201b0a127e7'")
         end # if
         #--------
         s_1=s_0.sub(rgx_2,s_lc_0)
         if s_1==s_0
            angervaks_throw("repos file format mismatch.\n"+
            "File path:\n\n"+s_fp_repos+"\n\n"+
            "s_1=="+s_1+"\n"+
            "GUID=='42c3fa2e-16be-46d7-83c1-1201b0a127e7'")
         end # if
         ar_s_giturl<<s_1
      end # loop
      #--------
      ht_opmem["ar_s_giturl"]=ar_s_giturl
   end # run_exc_parse_s_repos_01

   def run_s_generate_clonescript(ht_opmem)
      ar_s_giturl=ht_opmem["ar_s_giturl"]
      s_0="#/usr/bin/env bash \n#"
      s_0<<("="*74+"\n")
      #--------
      func_s_precede_with_0_if_needed=lambda do |i|
         cl=i.class
         if (cl!=Integer)
            if (cl!=Fixnum) # to cope with some versions prior to Ruby 2.4.0
               angervaks_throw("GUID=='273c5bb2-9d3a-453d-b5b1-1201b0a127e7'")
            end # if
         end # if
         if i<0
            angervaks_throw("GUID=='8be6e035-96e9-4736-a1b1-1201b0a127e7'")
         end # if
         s_out=i.to_s
         s_out=("0"+i.to_s) if i<10
         return s_out
      end # func_s_precede_with_0_if_needed
      func_s_format_t1=lambda do |i|
         s_out=func_s_precede_with_0_if_needed.call(i)+"_"
         return s_out
      end # func_s_format_t1
      #----
      ob_time=Time.now
      s_0<<"#Script generation timestamp: "
      s_0<<(ob_time.year.to_s+"_")
      s_0<<func_s_format_t1.call(ob_time.month)
      s_0<<func_s_format_t1.call(ob_time.day)
      s_0<<func_s_format_t1.call(ob_time.hour)
      s_0<<func_s_format_t1.call(ob_time.min)
      s_0<<func_s_format_t1.call(ob_time.sec)
      s_0<<(ob_time.nsec.to_s+"\n#")
      s_0<<("-"*74+"\n\n")
      #--------
      s_lc_0="\n"
      s_prefix="nice -n15 git clone --recursive "
      ar_s_giturl.each do |s_giturl|
         s_0<<(s_prefix+s_giturl+s_lc_0)
      end # loop
      s_0<<"\n"
      s_0<<"sync; wait; sync; \n"
      #--------
      s_clonescript=s_0
      ht_opmem["s_clonescript"]=s_clonescript
   end # run_s_generate_clonescript


   def ht_run_init_opmem
      ht=Hash.new
      s_fp_wd=Dir.getwd
      ht["s_fp_wd"]=s_fp_wd
      ht["s_fp_repos"]=s_fp_wd+"/repos"
      ht["s_fp_clonescript"]=s_fp_wd+"/clonescript.bash"
      return ht
   end # ht_run_init_opmem


   def run_handle_some_of_the_command_line_args_and_exit_if_needed(ht_opmem)
      i_n_of_console_arguments=@ar_argv.size
      return if i_n_of_console_arguments==0
      if i_n_of_console_arguments!=1
         angervaks_throw("At most 1 command line argument is accepted.\n"+
         "The optional 1. command line argument \n"+
         "should be either a GitHub user account URL or \n"+
         "\"help\" without the quotation marks.\n"+
         "GUID=='500d1543-bba3-4eda-81b1-1201b0a127e7'")
      end # if
      s_argv_0=@ar_argv[0].to_s
      if @ht_argv_help_options.has_key? s_argv_0
         puts s_help_doc()
         exit(0)
      end # if
      #-----------------------------------------
      s_fp_repos=ht_opmem["s_fp_repos"]
      s_fp_clonescript=ht_opmem["s_fp_clonescript"]
      #--------
      func_del_file_if_exists=lambda do |s_fp|
         if File.exists? s_fp
            if File.directory? s_fp
               angervaks_throw("Directory found, but a file expected.\n"+
               "s_fp==\n"+
               s_fp+"\n"+
               "GUID=='9264dedc-5fe2-4deb-bbb1-1201b0a127e7'")
            end # if
            File.delete s_fp
            if File.exists? s_fp
               angervaks_throw("File deletion failed.\n"+
               "s_fp==\n"+
               s_fp+"\n"+
               "GUID=='46355f10-c039-4e0c-b2b1-1201b0a127e7'")
            end # if
         end # if
      end # func_del_file_if_exists
      func_del_clonescript_if_exists=lambda do
         func_del_file_if_exists.call(s_fp_clonescript)
      end # func_del_clonescript_if_exists
      func_del_repos_if_exists=lambda do
         func_del_file_if_exists.call(s_fp_repos)
      end # func_del_repos_if_exists
      #-----------------------------------------
      if (s_argv_0=="t0") || (s_argv_0=="test_0")
         # A test case, where there is, probably, 0 repositories.
         # As of 2019_03_08 it does not have any repositories.
         @ar_argv[0]="https://github.com/augustdeez"
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
      end # if
      if (s_argv_0=="t1") || (s_argv_0=="test_1")
         # A test case, where there is, probably, 1 repository.
         # As of 2019_03_08 it has only one repositories.
         @ar_argv[0]="https://github.com/siddarth9"
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
      end # if
      if (s_argv_0=="t2") || (s_argv_0=="test_2") || (s_argv_0=="test") || (s_argv_0=="t")
         @ar_argv[0]="https://github.com/martinvahi"
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
      end # if
      if (s_argv_0=="t3") || (s_argv_0=="test_3")
         # A test case, where there is, probably, 82 repositories.
         # As of 2019_03_08 it has 82 repositories.
         @ar_argv[0]="https://github.com/gnustep"
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
      end # if
      if (s_argv_0=="clear") || (s_argv_0=="cl") || (s_argv_0=="clean") || (s_argv_0=="c")
         func_del_repos_if_exists.call
         func_del_clonescript_if_exists.call
         exit(0)
      end # if
      if (s_argv_0=="delete_cloningscript") || (s_argv_0=="clc")
         func_del_clonescript_if_exists.call
         exit(0)
      end # if
      if (s_argv_0=="delete_repos") || (s_argv_0=="clr")
         func_del_repos_if_exists.call
         exit(0)
      end # if
   end # run_handle_some_of_the_command_line_args_and_exit_if_needed

   public

   def run
      ht_opmem=ht_run_init_opmem
      run_handle_some_of_the_command_line_args_and_exit_if_needed(ht_opmem)
      puts "\n"
      #------------------------------------
      s_fp_repos=ht_opmem["s_fp_repos"]
      #--------
      # (File.exists? <path to an existing folder>) == true
      b_old_repos_missing=!(File.exists?(s_fp_repos))
      ht_opmem["b_old_repos_missing"]=b_old_repos_missing
      #----
      exc_verify_file_existence_01(ht_opmem)
      #s_repos=IO.read(s_fp_repos)
      s_repos=ht_opmem["s_repos"]
      #--------
      run_exc_parse_s_repos_01(ht_opmem)
      run_s_generate_clonescript(ht_opmem)
      #--------
      s_fp_clonescript=ht_opmem["s_fp_clonescript"]
      s_clonescript=ht_opmem["s_clonescript"]
      #puts s_clonescript
      IO.write(s_fp_clonescript,s_clonescript)
      if !File.exists? s_fp_clonescript
         angervaks_throw("The file \n"+s_fp_clonescript+
         "\n does not exists.\n"+
         "GUID=='f1fbdf8e-4827-4d98-8ab1-1201b0a127e7'")
      end # if
      File.chmod(0700,s_fp_clonescript)
      if b_old_repos_missing
         # It's in if-clause to retain manual chmod changes.
         File.chmod(0600,s_fp_repos)
      end # if
      if !File.exists? s_fp_clonescript
         angervaks_throw("The file \n"+s_fp_clonescript+
         "\n does not exists.\n"+
         "GUID=='19a69e62-47ca-4646-b2b1-1201b0a127e7'")
      end # if
      speak_if_possible("Cloning script generated.")
      #------------------------------------
      puts "\n"
   end # run

end # class GitHub_repos_2_clonescript_bash_t1

GitHub_repos_2_clonescript_bash_t1.new.run
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="3e8d0935-3551-45eb-83d1-1201b0a127e7"
#==========================================================================
