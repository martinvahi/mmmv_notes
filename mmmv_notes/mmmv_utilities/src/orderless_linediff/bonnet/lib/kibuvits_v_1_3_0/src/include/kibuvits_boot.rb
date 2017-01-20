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

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   if (x!=nil and x!="")
      KIBUVITS_HOME=x.to_s.freeze
   else
      KIBUVITS_HOME=Pathname.new(__FILE__).realpath.parent.parent.parent.to_s
   end # if
end # if

KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE=true if !defined? KIBUVITS_RUBY_LIBRARY_IS_AVAILABLE

# The difference between the APPLICATION_STARTERRUBYFILE_PWD and the
# working directory is that if a script that uses the Kibuvits Ruby Library
# has a path of /tmp/explanation/x.rb and it s called by:
# cd /opt; ruby /tmp/explanation/x.rb ;
# then the Dir.pwd=="/opt" and the
# APPLICATION_STARTERRUBYFILE_PWD=="/tmp/explanation"
#
APPLICATION_STARTERRUBYFILE_PWD=Pathname.new($0).realpath.parent.to_s if not defined? APPLICATION_STARTERRUBYFILE_PWD

require KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
# The point behind the KIBUVITS_s_PROCESS_ID is that
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
if !defined? KIBUVITS_s_PROCESS_ID
   x=ENV['KIBUVITS_S_PROCESS_ID']
   if (x!=nil and x!="")
      KIBUVITS_s_PROCESS_ID=x
   else
      # The Operating system process ID-s tend to cycle.
      # If the code that uses the KIBUVITS_s_PROCESS_ID
      # does not erase temporary files, which might actually be quite
      # challenging, given that it's not that easy to elegantly
      # automatically determine, which of the sub-processes is the last one,
      # then there might be collisions with the use of the temporary files,
      # global hash entries, etc., unless the process ID-s are
      # something like the Globally Unique Identifiers.
      KIBUVITS_s_PROCESS_ID="pid_"+$$.to_s+"_"+
      Kibuvits_GUID_generator.generate_GUID
      ENV['KIBUVITS_S_PROCESS_ID']=KIBUVITS_s_PROCESS_ID
   end # if
end # if
#==========================================================================
# Manually updatable:

# The Ruby gem infrastructure requires a version that consists
# of only numbers and dots. For library forking related
# version checks there is another constant: KIBUVITS_s_VERSION.
KIBUVITS_s_NUMERICAL_VERSION="1.3.0" if !defined? KIBUVITS_s_NUMERICAL_VERSION

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
KIBUVITS_s_VERSION="kibuvits_"+KIBUVITS_s_NUMERICAL_VERSION.to_s if !defined? KIBUVITS_s_VERSION

# For security reasons it doesn't make sense to use the
# all-readable system default temporary folder for temporary
# files. By default the KRL uses the system temporary folder,
# but if the constant KIBUVITS_TEMPORARY_FOLDER is set, the
# value given by the KIBUVITS_TMP_FOLDER_PATH is used instead.
# By the Kibuvits Ruby Library "spec" the applications that
# use the KRL are left an opportunity to overwrite it or
# self-declare it.
# KIBUVITS_TMP_FOLDER_PATH=ENV['HOME'].to_s+"/tmp"

KIBUVITS_b_DEBUG=true if !defined? KIBUVITS_b_DEBUG
#KIBUVITS_b_DEBUG=false if !defined? KIBUVITS_b_DEBUG

#--------------------------------------------------------------------------
$kibuvits_lc_emptystring="".freeze
$kibuvits_lc_space=" ".freeze
$kibuvits_lc_linebreak="\n".freeze
$kibuvits_lc_rbrace_linebreak=");\n".freeze
$kibuvits_lc_dollarsign="$".freeze
$kibuvits_lc_powersign="^".freeze
$kibuvits_lc_dot=".".freeze
$kibuvits_lc_comma=",".freeze
$kibuvits_lc_semicolon=";".freeze

$kibuvits_lc_lbrace="(".freeze
$kibuvits_lc_rbrace=")".freeze

$kibuvits_lc_lsqbrace="[".freeze
$kibuvits_lc_rsqbrace="]".freeze

$kibuvits_lc_questionmark="?".freeze
$kibuvits_lc_star="*".freeze
$kibuvits_lc_plus="+".freeze
$kibuvits_lc_minus="-".freeze
$kibuvits_lc_minusminus="--".freeze
$kibuvits_lc_pillar="|".freeze
$kibuvits_lc_slash="/".freeze
$kibuvits_lc_slashslash="//".freeze
$kibuvits_lc_slashstar="/*".freeze
$kibuvits_lc_backslash="\\".freeze
$kibuvits_lc_underscore="_".freeze
$kibuvits_lc_doublequote="\"".freeze
$kibuvits_lc_singlequote="'".freeze
$kibuvits_lc_equalssign="=".freeze

$kibuvits_lc_kibuvits_ostype_unixlike="kibuvits_ostype_unixlike".freeze
$kibuvits_lc_kibuvits_ostype_java="kibuvits_ostype_java".freeze # JRuby
$kibuvits_lc_kibuvits_ostype_windows="kibuvits_ostype_windows".freeze

$kibuvits_lc_s_version="s_version".freeze
$kibuvits_lc_s_type="s_type".freeze
$kibuvits_lc_s_serialized="s_serialized".freeze
$kibuvits_lc_s_ht_szr_progfte="s_ht_szr_progfte".freeze
$kibuvits_lc_szrtype_ht_p="szrtype_ht_p".freeze
$kibuvits_lc_szrtype_instance="szrtype_instance".freeze
$kibuvits_lc_si_number_of_elements="si_number_of_elements".freeze
$kibuvits_lc_b_failure="b_failure".freeze
$s_lc_i_kibuvits_ar_ix_1="i_kibuvits_ar_ix_1".freeze

$kibuvits_lc_boolean="boolean".freeze
$kibuvits_lc_sb_true="t".freeze
$kibuvits_lc_sb_false="f".freeze

$kibuvits_lc_timestamp="timestamp".freeze
$kibuvits_lc_year="year".freeze
$kibuvits_lc_month="month".freeze
$kibuvits_lc_day="day".freeze
$kibuvits_lc_hour="hour".freeze
$kibuvits_lc_minute="minute".freeze
$kibuvits_lc_second="second".freeze
$kibuvits_lc_nanosecond="nanosecond".freeze

$kibuvits_lc_longitude="longitude".freeze
$kibuvits_lc_latitude="latitude".freeze
$kibuvits_lc_name="name".freeze
$kibuvits_lc_any="any".freeze
$kibuvits_lc_outbound="outbound".freeze
$kibuvits_lc_inbound="inbound".freeze
$kibuvits_lc_ob_vx_first_entry="ob_vx_first_entry".freeze
$kibuvits_lc_i_vxix="i_vxix".freeze

$kibuvits_lc_ht_p="ht_p".freeze
$kibuvits_lc_ht_szr="ht_szr".freeze
$kibuvits_lc_msgcs="msgcs".freeze
$kibuvits_lc_Ruby_serialize_="Ruby_serialize_".freeze
$kibuvits_lc_Ruby_deserialize_="Ruby_deserialize_".freeze
$kibuvits_lc_Ruby_serialize_szrtype_instance="Ruby_serialize_szrtype_instance".freeze
$kibuvits_lc_Ruby_deserialize_szrtype_instance="Ruby_deserialize_szrtype_instance".freeze

$kibuvits_lc_PHP_serialize_="PHP_serialize_".freeze
$kibuvits_lc_PHP_deserialize_="PHP_deserialize_".freeze
$kibuvits_lc_JavaScript_serialize_="JavaScript_serialize_".freeze
$kibuvits_lc_JavaScript_deserialize_="JavaScript_deserialize_".freeze
#$kibuvits_lc_Perl_serialize_="Perl_serialize_".freeze
#$kibuvits_lc_Perl_deserialize_="Perl_deserialize_".freeze

$kibuvits_lc_uk="uk".freeze # The "uk" stands for United Kingdom.
$kibuvits_lc_et="et".freeze # The "et" stands for Estonian.

$kibuvits_lc_s_stdout="s_stdout".freeze
$kibuvits_lc_s_stderr="s_stderr".freeze

$kibuvits_lc_s_Array="Array".freeze
$kibuvits_lc_s_Hash="Hash".freeze
$kibuvits_lc_s_String="String".freeze
$kibuvits_lc_s_Symbol="Symbol".freeze
$kibuvits_lc_s_Method="Method".freeze
$kibuvits_lc_s_Binding="Binding".freeze
$kibuvits_lc_s_Fixnum="Fixnum".freeze
$kibuvits_lc_s_Float="Float".freeze
$kibuvits_lc_s_Rational="Rational".freeze
$kibuvits_lc_s_TrueClass="TrueClass".freeze
$kibuvits_lc_s_FalseClass="FalseClass".freeze

$kibuvits_lc_s_default_mode="s_default_mode".freeze
$kibuvits_lc_s_mode="s_mode".freeze
$kibuvits_lc_s_mode_inactive="s_mode_inactive".freeze
$kibuvits_lc_s_mode_active="s_mode_active".freeze
$kibuvits_lc_s_mode_inactive_due_to_undetermined_reason="s_mode_inactive_due_to_undetermined_reason".freeze
$kibuvits_lc_s_status="s_status".freeze
$kibuvits_lc_s_mode_throw="s_mode_throw".freeze
$kibuvits_lc_s_mode_exit="s_mode_exit".freeze
$kibuvits_lc_s_mode_return_msg="s_mode_return_msg".freeze
#--------------------------------------------------------------------------
$kibuvits_lc_emptyarray=Array.new.freeze

#--------------------------------------------------------------------------
$kibuvits_s_language=$kibuvits_lc_uk # application level i18n setting.
x=ENV["KIBUVITS_LANGUAGE"]
$kibuvits_s_language=x if (x!=nil and x!="")
#--------------------------------------------------------------------------

if !defined? KIBUVITS_s_CMD_RUBY
   kibuvits_tmpvar_s_rbpath=`which ruby`
   kibuvits_tmpvar_s_rbpath.sub!(/[\n\r]$/,"")
   kibuvits_tmpvar_s_rbpath=Pathname.new(kibuvits_tmpvar_s_rbpath).realpath.parent.to_s
   KIBUVITS_s_CMD_RUBY="cd "<<kibuvits_tmpvar_s_rbpath<<" ; ruby -Ku "
end # if

#--------------------------------------------------------------------------

def kibuvits_s_exception_2_stacktrace(e)
   if (e.class.kind_of? Exception)
      exc=Exception.new("e.class=="+e.class.to_s+
      ", but Exception or any of its decendents was expected.")
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
   if b_input_verification_failed
      s_msg=s_msg+" s_or_ob_exception.class=="+x_in.class.to_s+"\n"
      raise(Exception.new(s_msg))
   end # if
   if x_in.class!=String
      if !(x_in.kind_of? Exception)
         s_msg=" s_or_ob_exception.class=="+x_in.class.to_s+
         ", but it is expected to be of class String or Exception or "+
         "derived from the class Exception.\n"
         raise(Exception.new(s_msg))
      end # if
   end # if
   if a_binding.class!=NilClass
      if a_binding.class!=Binding
         s_msg=" a_binding.class=="+a_binding.class.to_s+
         ", but it is expected to be of class NilClass or Binding.\n"
         raise(Exception.new(s_msg))
      end # if
   end # if
   #-------------------------------------------------
   exc=nil
   if x_in.class==String
      exc=Exception.new(x_in)
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
   # even the kibuvits_s_varvalue2varname depends on the emptyness of the ar
   ar.clear
   return x
end # kibuvits_varname2varvalue

#--------------------------------------------------------------------------

$kibuvits_lc_kibuvits_s_varvalue2varname_script1=($kibuvits_lc_emptystring+
"s_varname=nil\n"+
"x=nil\n"+
"ar_tmp_for_speed=kibuvits_s_varvalue2varname_tmp_ar\n"+ # an instance reuse speedhack
"local_variables.each do |s_varname_or_symbol|\n"+
"    s_varname=s_varname_or_symbol.to_s\n"+
"    x=kibuvits_varname2varvalue(binding(),s_varname,ar_tmp_for_speed)\n"+
"    if x.object_id==kibuvits_s_varvalue2varname_tmp_i_objectid \n"+
"        kibuvits_s_varvalue2varname_tmp_ar<<s_varname\n"+
"        break \n"+
"    end #if\n"+
"end #loop\n").freeze

$kibuvits_lc_kibuvits_s_varvalue2varname_s1=($kibuvits_lc_emptystring+
"kibuvits_s_varvalue2varname_tmp_ar=ObjectSpace._id2ref(").freeze

$kibuvits_lc_kibuvits_s_varvalue2varname_s2=($kibuvits_lc_emptystring+
"kibuvits_s_varvalue2varname_tmp_i_objectid=(").freeze

# Returns an empty string, if the variable could
# not be found from the scope. The
# ar_an_empty_array_for_reuse_only_for_speed is guaranteed
# to be empty after the exit of this function.
def kibuvits_s_varvalue2varname(a_binding, ob_varvalue,
   ar_an_empty_array_for_reuse_only_for_speed=Array.new)
   # The use of the kibuvits_typecheck in here
   # would introduce a cyclic dependency.
   ar=ar_an_empty_array_for_reuse_only_for_speed
   s_script=$kibuvits_lc_kibuvits_s_varvalue2varname_s1+
   ar.object_id.to_s+$kibuvits_lc_rbrace_linebreak+
   $kibuvits_lc_kibuvits_s_varvalue2varname_s2+
   ob_varvalue.object_id.to_s+$kibuvits_lc_rbrace_linebreak+
   $kibuvits_lc_kibuvits_s_varvalue2varname_script1 # instance reuse

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
      # kibuvits_s_varvalue2varname(binding(), an_awesome_function())
      s_varname=$kibuvits_lc_emptystring
   else
      s_varname=ar[0]
      ar.clear
   end # if
   return s_varname
end # kibuvits_s_varvalue2varname

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
def kibuvits_typecheck(a_binding,expected_class_or_an_array_of_expected_classes,
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
      s_varname=kibuvits_s_varvalue2varname(a_binding,
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

def kibuvits_typecheck_ar_content(a_binding,expected_class_or_an_array_of_expected_classes,
   ar_verifiable_values,s_msg_complement=nil)
   bn=binding()
   if KIBUVITS_b_DEBUG
      kibuvits_typecheck bn, Binding, a_binding
      kibuvits_typecheck bn, [Class,Array], expected_class_or_an_array_of_expected_classes
      kibuvits_typecheck bn, Array, ar_verifiable_values
      kibuvits_typecheck bn, [NilClass,String], s_msg_complement
      if expected_class_or_an_array_of_expected_classes.class==Array
         expected_class_or_an_array_of_expected_classes.each do |cl_candidate|
            bn_1=binding()
            kibuvits_typecheck bn_1, Class, cl_candidate
         end # loop
      end # if
   end # if
   ar_cl=expected_class_or_an_array_of_expected_classes
   if expected_class_or_an_array_of_expected_classes.class==Class
      ar_cl=[expected_class_or_an_array_of_expected_classes]
   end # if
   b_throw=true
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
      kibuvits_typecheck(a_binding,expected_class_or_an_array_of_expected_classes,
      x_value,s_msg_complement)
   end # if
   b_failure=b_throw
   return b_failure
end # kibuvits_typecheck_ar_content

#--------------------------------------------------------------------------

# Returns false if any of the x_key_candidate_or_ar_of_key_candidates
# elements is missing from the ht.keys
def b_kibuvits_ht_has_keys(x_key_candidate_or_ar_of_key_candidates,ht)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Hash,ht
      kibuvits_typecheck bn, [Array,String],x_key_candidate_or_ar_of_key_candidates
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
end # b_kibuvits_ht_has_keys

# This function has a limitation that if a
# single array is expected to be the key of the
# hashtable, then it has to be wrapped into an
# array. That is to say:
#
#  Wrong: kibuvits_assert_ht_has_keys(binging(),ht,array_as_a_key_candidate)
#
#  Correct: kibuvits_assert_ht_has_keys(binging(),ht,[array_as_a_key_candidate])
#
def kibuvits_assert_ht_has_keys(a_binding,ht,
   x_key_candidate_or_ar_of_key_candidates,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      # The typechecks are within the KIBUVITS_b_DEBUG
      # block due to a fact that sometimes one might
      # want to use the assert clause even, if the
      # debug mode has been switched off.
      bn=binding()
      kibuvits_typecheck bn, Binding,a_binding
      kibuvits_typecheck bn, Hash,ht
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
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
   # kibuvits_assert_ht_keys_and(binding(), an_awesome_function(),"a_key_candidate")
   #
   # Speed-optimizing exception throwing speeds up selftests, though, I
   # understand that due to string instantiation alone the single array instantiation
   # in this method is totally irrelevant, marginal. :-D
   ar_tmp_for_speed=Array.new
   s_ht_varname=kibuvits_s_varvalue2varname(a_binding,ht,ar_tmp_for_speed)
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
   msg=msg+$kibuvits_lc_linebreak
   if s_optional_error_message_suffix.class==String
      s_2=s_optional_error_message_suffix+$kibuvits_lc_linebreak
      msg=msg+s_2
   end # if
   kibuvits_set_var_in_scope(a_binding,
   "kibuvits_assert_ht_has_keys_s_msg",msg,ar_tmp_for_speed)
   eval("kibuvits_throw(kibuvits_assert_ht_has_keys_s_msg)\n",a_binding)
end # kibuvits_assert_ht_has_keys

#--------------------------------------------------------------------------
# The keys and values must all be of class String.
# Usage example:
#
# ht=Hash.new
# ht["hi"]="there"
# ht["welcome"]="to heaven"
# ht["nice"]="day"
# ht["whatever"]="ohter string value"
#
# a_binding=binding()
#
# # A single compulsory key-value pair:
# kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht,["hi","there"])
#
# # Multiple compulsory key-value pairs:
# kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht,
# [["hi","there"],["nice","day"]])
#
def kibuvits_assert_ht_has_keyvaluepairs_s(a_binding,ht,
   ar_keyvaluepair_or_ar_keyvaluepairs,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      # The typechecks are within the KIBUVITS_b_DEBUG
      # block due to a fact that sometimes one might
      # want to use the assert clause even, if the
      # debug mode has been switched off.
      bn=binding()
      kibuvits_typecheck bn, Binding,a_binding
      kibuvits_typecheck bn, Hash,ht
      kibuvits_typecheck bn, Array,ar_keyvaluepair_or_ar_keyvaluepairs
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if ar_keyvaluepair_or_ar_keyvaluepairs.size==0
         kibuvits_throw("ar_keyvaluepair_or_ar_keyvaluepairs.size==0\n")
      end # if
      x_keyvaluepair_or_key=ar_keyvaluepair_or_ar_keyvaluepairs[0]
      kibuvits_typecheck bn, [String,Array],x_keyvaluepair_or_key
   else
      if ar_keyvaluepair_or_ar_keyvaluepairs.size==0
         # I know that it duplicates the debug branch,
         # but I can not refactor it out of here.
         kibuvits_throw("ar_keyvaluepair_or_ar_keyvaluepairs.size==0\n")
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
   if KIBUVITS_b_DEBUG
      ar_keyvaluepairs.each do |ar_keyvaluepair|
         bn=binding()
         kibuvits_typecheck bn, Array,ar_keyvaluepair
         if ar_keyvaluepair.size!=2
            kibuvits_throw("2!=ar_keyvaluepair.size=="+
            ar_keyvaluepair.size.to_s)
         end # if
         s_key=ar_keyvaluepair[0]
         s_value=ar_keyvaluepair[1]
         kibuvits_typecheck bn, String,s_key
         kibuvits_typecheck bn, String,s_value
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
   s_ht_name=kibuvits_s_varvalue2varname(a_binding,ht,ar_tmp_for_speed)
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
   msg=msg+$kibuvits_lc_linebreak
   kibuvits_set_var_in_scope(a_binding,
   "kibuvits_assert_ht_has_keyvaluepairs_s_msg",msg,ar_tmp_for_speed)
   eval("kibuvits_throw(kibuvits_assert_ht_has_keyvaluepairs_s_msg)\n",
   a_binding)
end # kibuvits_assert_ht_has_keyvaluepairs_s

#--------------------------------------------------------------------------

def kibuvits_get_binding_wrapper_instance_class(bn_caller_binding)
   ar=Array.new()
   i_ar_id=ar.object_id
   s_tmpvarname1="kibuvits_get_binding_wrapper_instance_classtmpvar1"
   s_tmpvarname2="kibuvits_get_binding_wrapper_instance_classtmpvar2"
   s_script=s_tmpvarname1+"=self.class\n"+
   s_tmpvarname2+"=ObjectSpace._id2ref("+i_ar_id.to_s+")\n"+
   s_tmpvarname2+"<<"+s_tmpvarname1+"\n"+
   s_tmpvarname1+"=nil\n"+
   s_tmpvarname2+"=nil\n"
   begin
      eval(s_script,bn_caller_binding)
   rescue Exception => e
      kibuvits_throw ("\n\nOne of the possible causes of the "+
      "exception here is that one tried to get a class "+
      "of a static method. The workaround is that only "+
      "instances, which can be singletons, are analyzed. "+
      "There's also the limitation that one can not use the "+
      "Kibuvits_msgc_stack and Kibuvits_msgc instances "+
      "in functions that are not wrapped into some instance.\n\n"+
      "The caught exception message is:\n\n"+e.to_s+"\n\n")
   end # rescue
   cl_out=ar[0]
   ar.clear
   return cl_out
end # kibuvits_get_binding_wrapper_instance_class

#--------------------------------------------------------------------------

def kibuvits_assert_string_min_length(a_binding,s_in,i_min_length,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding, a_binding
      kibuvits_typecheck bn, String, s_in
      kibuvits_typecheck bn, Fixnum, i_min_length
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if i_min_length<0
         kibuvits_throw("i_min_length == "+i_min_length.to_s+" < 0");
      end # if
   end # if
   i_len=s_in.length
   if i_len<i_min_length
      s_varname=kibuvits_s_varvalue2varname(a_binding,s_in)
      s_varname="<a string>" if s_varname.length==0
      kibuvits_throw(s_varname+".length=="+i_len.to_s+", but the "+
      "minimum allowed string length is "+i_min_length.to_s+".",a_binding)
   end # if
end # kibuvits_assert_string_min_length

#--------------------------------------------------------------------------
def kibuvits_b_not_suitable_for_a_varname_t1(s_in)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String, s_in
   end # if
   i_0=s_in.length
   return true if i_0==0
   s_1=s_in.gsub(/[\t\s\n\r;:|,.$<>+-\/\[\](){}\\]/,$kibuvits_lc_emptystring)
   return true if s_1.length!=i_0
   return false
end # kibuvits_b_not_suitable_for_a_varname_t1

def kibuvits_assert_ok_to_be_a_varname_t1(a_binding,s_in,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding, a_binding
      kibuvits_typecheck bn, String, s_in
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   if kibuvits_b_not_suitable_for_a_varname_t1(s_in)
      s_varname=kibuvits_s_varvalue2varname(a_binding,s_in)
      kibuvits_throw("\n"+s_varname+"==\""+s_in.to_s+
      "\" is not suitable for a variable name. \n",a_binding)
   end # if
end # kibuvits_assert_ok_to_be_a_varname_t1

#--------------------------------------------------------------------------

def kibuvits_assert_arrayix(a_binding,ar,
   i_array_index_candidate_or_array_of_array_index_candidates,
   s_optional_error_message_suffix=nil)
   x_candidates=i_array_index_candidate_or_array_of_array_index_candidates
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding,a_binding
      kibuvits_typecheck bn, Array,ar
      kibuvits_typecheck bn, [Fixnum,Array],i_array_index_candidate_or_array_of_array_index_candidates
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
      if x_candidates.class==Array
         if x_candidates.size==0
            kibuvits_throw("The array of candidate indices is empty.")
         end # if
         x_candidates.each do |x|
            bn=binding()
            kibuvits_typecheck bn,Fixnum,x
         end # loop
      end # if
   end # if
   ar_candidates=x_candidates
   ar_candidates=[x_candidates] if x_candidates.class==Fixnum
   i_cand_sindex_max=ar_candidates.size # array separator index, min==0
   i_number_of_candidates=i_cand_sindex_max # ==(i_cand_sindex_max-0)
   if i_number_of_candidates==0
      kibuvits_throw("The array of candidate indices is empty.")
   end # if
   i_max_valid_ix=ar.size-1
   i_candidate=nil
   i_number_of_candidates.times do |i|
      i_candidate=ar_candidates[i]
      if i_candidate<0
         if i_number_of_candidates==1
            kibuvits_throw("<array index candidate>"+
            " == "+i_candidate.to_s+" < 0 ",a_binding)
         else
            kibuvits_throw("Array index candidate #"+i.to_s+
            " == "+i_candidate.to_s+" < 0 ",a_binding)
         end # if
      end # if
      if i_max_valid_ix<i_candidate
         kibuvits_throw("Maximum valid index is "+
         i_max_valid_ix.to_s+" < "+i_candidate.to_s+
         " == <index candidate>",a_binding)
      end # if
   end # loop
end # kibuvits_assert_arrayix

#--------------------------------------------------------------------------

def kibuvits_assert_ht_container_version(a_binding,ht_container,s_expected_version,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding,a_binding
      kibuvits_typecheck bn, Hash,ht_container
      kibuvits_typecheck bn, String,s_expected_version
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   if !(ht_container.has_key? $kibuvits_lc_s_version)
      s_varname=kibuvits_s_varvalue2varname(a_binding, ht_container)
      msg=nil
      if 0<s_varname.length
         msg="The "+s_varname+" is missing the key, \""
      else
         msg="The ht_container is missing the key, \""
      end # if
      msg=msg+$kibuvits_lc_s_version+"\", that refers to the version number."
      if s_optional_error_message_suffix!=nil
         msg=msg+("\n"+s_optional_error_message_suffix)
      end # if
      kibuvits_throw(msg,a_binding)
   end # if
   s_version=ht_container[$kibuvits_lc_s_version]
   if s_version!=s_expected_version
      s_varname=kibuvits_s_varvalue2varname(a_binding,ht_container)
      msg=nil
      if 0<s_varname.length
         msg=s_varname+"[\""+$kibuvits_lc_s_version+"\"]==\""+s_version+"\", but \""+
         s_expected_version+"\" was expected."
      else
         msg="ht_container[\""+$kibuvits_lc_s_version+"\"]==\""+s_version+"\", but \""+
         s_expected_version+"\" was expected."
      end # if
      if s_optional_error_message_suffix!=nil
         msg=msg+("\n"+s_optional_error_message_suffix)
      end # if
      kibuvits_throw(msg,a_binding)
   end # if
end # kibuvits_assert_ht_container_version

#--------------------------------------------------------------------------
# If the width of a class name prefix can match that of the
# class name, then the assertion is considered met and
# no exceptions are thrown.
def kibuvits_assert_class_name_prefix(a_binding,ob,
   x_class_name_prefix_as_string_or_class,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding,a_binding
      kibuvits_typecheck bn, [String,Class],x_class_name_prefix_as_string_or_class
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   s_prefix=nil
   if x_class_name_prefix_as_string_or_class.class==Class
      s_prefix=x_class_name_prefix_as_string_or_class.to_s
   else
      s_prefix=x_class_name_prefix_as_string_or_class
      kibuvits_assert_string_min_length(a_binding,s_prefix,1)
   end # if
   s_cl=ob.class.to_s
   rgx=Regexp.new($kibuvits_lc_powersign+s_prefix)
   md=rgx.match(s_cl)
   if md==nil
      s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
      s_varname="<an objec>" if s_varname.length==0
      msg=s_varname+".class.to_s==\""+s_cl+"\", but the "+
      "requested class name prefix is \""+s_prefix+"\". "
      if s_optional_error_message_suffix.class==String
         msg=msg+s_optional_error_message_suffix
      end # if
      kibuvits_throw(msg,a_binding)
   end # if
end # kibuvits_assert_class_name_prefix

#--------------------------------------------------------------------------

def kibuvits_assert_responds_2_method(a_binding,ob,
   x_method_name_or_method_or_symbol,
   s_optional_error_message_suffix=nil)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding,a_binding
      kibuvits_typecheck bn, [String,Method,Symbol],x_method_name_or_method_or_symbol
      kibuvits_typecheck bn, [NilClass,String],s_optional_error_message_suffix
   end # if
   sym_x=nil
   s_clname=x_method_name_or_method_or_symbol.class.to_s
   case s_clname
   when $kibuvits_lc_s_String
      bn=binding()
      kibuvits_assert_string_min_length(bn,x_method_name_or_method_or_symbol,1)
      sym_x=x_method_name_or_method_or_symbol.to_sym
   when $kibuvits_lc_s_Method
      sym_x=x_method_name_or_method_or_symbol.name
   when $kibuvits_lc_s_Symbol
      sym_x=x_method_name_or_method_or_symbol
   else
      kibuvits_throw("There's a flaw. 26022333-bfa5-44a8-8c02-03e150913cd7")
   end # case x_method_name_or_method_or_symbol.class
   if !ob.respond_to? sym_x
      s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
      s_varname="<an objec>" if s_varname.length==0
      msg=s_varname+" is expected to have a method named \""+
      sym_x.to_s+"\", but it does not have it. "
      if s_optional_error_message_suffix.class==String
         msg=msg+s_optional_error_message_suffix
      end # if
      kibuvits_throw(msg,a_binding)
   end # if
end # kibuvits_assert_responds_2_method

#--------------------------------------------------------------------------

def kibuvits_impl_class_inheritance_assertion_funcs_t1(a_binding,ob,
   cl_or_s_class,b_classes_may_equal,s_optional_error_message_suffix)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, Binding, a_binding
      kibuvits_typecheck bn, [Class,String], cl_or_s_class
      kibuvits_typecheck bn, [TrueClass,FalseClass], b_classes_may_equal
      kibuvits_typecheck bn, [NilClass,String], s_optional_error_message_suffix
   end # if
   cl=cl_or_s_class
   b_throw=false
   begin
      if cl_or_s_class.class==String
         cl=Kernel.const_get(cl_or_s_class)
      else
         # This branch is useful, if the KIBUVITS_b_DEBUG branch is not entered.
         cl.class # throws, if it ==  <nonexisting class>.class
      end # if
   rescue Exception => e
      b_throw=true
   end # try-catch
   if b_throw
      s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
      s_varname="<an objec>" if s_varname.length==0
      msg=s_varname+" is expected to be of class "+cl_or_s_class+
      ", but the Ruby source that describes "+
      "a class with that name has not been loaded. "
      if s_optional_error_message_suffix.class==String
         msg=msg+s_optional_error_message_suffix
      end # if
      kibuvits_throw(msg,a_binding)
   end # if

   if b_classes_may_equal
      if ob.class!=cl
         if !(ob.kind_of?(cl))
            s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
            s_varname="<an objec>" if s_varname.length==0
            s_cl_name=cl_or_s_class.to_s
            msg=s_varname+".class is expected to be derived from the class "+
            s_cl_name+ ", but the "+s_varname+".class=="+ob.class.to_s+$kibuvits_lc_space
            if s_optional_error_message_suffix.class==String
               msg=msg+s_optional_error_message_suffix
            end # if
            kibuvits_throw(msg,a_binding)
         end # if
      end # if
   else
      if ob.class==cl
         s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
         s_varname="<an objec>" if s_varname.length==0
         s_cl_name=cl_or_s_class.to_s
         msg=s_varname+".class is expected to differ from class "+
         s_cl_name+", but the "+s_varname+".class=="+
         ob.class.to_s+$kibuvits_lc_space
         if s_optional_error_message_suffix.class==String
            msg=msg+s_optional_error_message_suffix
         end # if
         kibuvits_throw(msg,a_binding)
      else
         if !(ob.kind_of?(cl))
            s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
            s_varname="<an objec>" if s_varname.length==0
            s_cl_name=cl_or_s_class.to_s
            msg=s_varname+".class is expected to be derived from the class "+
            s_cl_name+ ", but the "+s_varname+".class=="+ob.class.to_s+$kibuvits_lc_space
            if s_optional_error_message_suffix.class==String
               msg=msg+s_optional_error_message_suffix
            end # if
            kibuvits_throw(msg,a_binding)
         end # if
      end # if
   end # if
end # kibuvits_impl_class_inheritance_assertion_funcs_t1

def kibuvits_assert_is_inherited_from_or_equals_with_class(a_binding,ob,
   cl_or_s_class,s_optional_error_message_suffix=nil)
   kibuvits_impl_class_inheritance_assertion_funcs_t1(
   a_binding,ob,cl_or_s_class,true,s_optional_error_message_suffix)
end # kibuvits_assert_is_inherited_from_or_equals_with_class

def kibuvits_assert_is_inherited_from_and_does_not_equal_with_class(a_binding,ob,
   cl_or_s_class,s_optional_error_message_suffix=nil)
   kibuvits_impl_class_inheritance_assertion_funcs_t1(
   a_binding,ob,cl_or_s_class,false,s_optional_error_message_suffix)
end # kibuvits_assert_is_inherited_from_and_does_not_equal_with_class

#--------------------------------------------------------------------------

# If the ob_or_ar_or_ht is an Array or a hashtable(Hash),then the ob is
# compared with the content of the Array or the values of the hashtable.
def kibuvits_assert_is_among_values(a_binding,ob_or_ar_or_ht,
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
         if (cl!=String)&&(cl!=Fixnum)&&(cl!=Rational)&&(cl!=Bignum)
            b_list_assembleable=false
            break
         end # if
      end # loop
      s_varname=kibuvits_s_varvalue2varname(a_binding,ob)
      s_varname="<an objec>" if s_varname.length==0
      msg="\n\n"+s_varname+
      " does not have a value that is among the set of valid values. \n"+
      s_varname+"=="+ob.to_s
      if b_list_assembleable
         b_nonfirst=false
         s_list=$kibuvits_lc_emptystring
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
      msg=msg+"\n\n"
      kibuvits_throw(msg,a_binding)
   end # if
end # kibuvits_assert_is_among_values

#--------------------------------------------------------------------------
$kibuvits_lc_kibuvits_eval_t1_s1=($kibuvits_lc_emptystring+
"ar_in=ObjectSpace._id2ref(").freeze
$kibuvits_lc_kibuvits_eval_t1_s2=($kibuvits_lc_emptystring+
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
# The kibuvits_eval_t1(...) returns the ar_out.
def kibuvits_eval_t1(s_script, ar_in=nil)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String,s_script
      kibuvits_typecheck bn, [NilClass,Array],ar_in
      rgx_ar_in=/([\s]|^|[;])ar_in[\s]*=[\s]*(\[|Array[.])/
      # Actually the rgx_ar_in does not
      # cover cases like ar_in<<x
      # ar_in[i]=x; ar_in.clear;  etc.
      if s_script.match(rgx_ar_in)!=nil
         kibuvits_throw("The s_script seems to contain "+
         "something like ar_in=Array.new or ar_in=[] or something "+
         "similar. To avoid side-effects the ar_in must "+
         "not be modified wihin the s_script.")
      end # if
      rgx_ar_out=/([\s]|^|[;])ar_out[\s]*=[\s]*(\[|Array[.])/
      if s_script.match(rgx_ar_out)!=nil
         kibuvits_throw("The s_script seems to contain "+
         "something like ar_out=Array.new or ar_out=[] or something "+
         "similar. The ar_out must not be reinstantiated within "+
         "the s_script, because the ar_out instance is used for "+
         "retrieving the ar_out content from the s_script scope.")
      end # if
   end # if
   ar_out=Array.new
   s_scr=nil
   if ar_in!=nil
      s_scr=$kibuvits_lc_kibuvits_eval_t1_s1+
      (ar_in.object_id.to_s+$kibuvits_lc_rbrace_linebreak)
   else
      s_scr=$kibuvits_lc_emptystring
   end # if
   s_scr=s_scr+($kibuvits_lc_kibuvits_eval_t1_s2+
   (ar_out.object_id.to_s+$kibuvits_lc_rbrace_linebreak))
   s_scr=s_scr+s_script
   eval(s_scr)
   return ar_out
end # kibuvits_eval_t1


#--------------------------------------------------------------------------

def kibuvits_call_by_ar_of_args(ob,x_method_name_or_symbol,ar_method_arguments,&block)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, [Symbol,String],x_method_name_or_symbol

      # The ar_method_arguments must not be nil, because otherwise
      # one could call just ob.send(:methodname_as_symbol,block),
      # which is considerably faster than this function here.
      kibuvits_typecheck bn, Array,ar_method_arguments
      kibuvits_typecheck bn, [NilClass,Proc],block
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
            s_script=s_script+(s_lc_1+(i.to_s+$kibuvits_lc_rsqbrace))
         end # loop
         s_script=s_script+($kibuvits_lc_rbrace+"; ar_out<<x_out")
         ar_out=kibuvits_eval_t1(s_script, ar_in)
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
         s_script=$kibuvits_lc_emptystring+
         "ob=ar_in[0];x_sym=ar_in[1];ar_args=ar_in[2];block=ar_in[3];"+
         "x_out=ob.send(x_sym"
         s_lc_1=",ar_args["
         i_len.times do |i|
            s_script=s_script+(s_lc_1+(i.to_s+$kibuvits_lc_rsqbrace))
         end # loop
         s_script=s_script+(",&block); ar_out<<x_out")
         ar_out=kibuvits_eval_t1(s_script, ar_in)
         x_out=ar_out[0]
      end # case i_len
   end # if
   return x_out
end # kibuvits_call_by_ar_of_args

#--------------------------------------------------------------------------

# An example:
#
# ob_func=kibuvits_dec_lambda do |x|
#     puts "Hello "+x.to_s+" !"
#     end # block
# ob_func.call("handsome")
#
def kibuvits_dec_lambda(&block)
   ob_block=block
   return ob_block
end # kibuvits_dec_lambda

#--------------------------------------------------------------------------
#
# i_bitlen in_Set{256,384,512}
#
def kibuvits_s_hash(s_in,i_bitlen=512)
   if KIBUVITS_b_DEBUG
      bn=binding()
      kibuvits_typecheck bn, String,s_in
      kibuvits_typecheck bn, [Fixnum,Bignum],i_bitlen
      ar=[256,384,512]
      kibuvits_assert_is_among_values(bn,ar,i_bitlen)
   end # if
   if !defined? $kibuvits_func_s_hash_b_module_digest_loaded
      require "digest"
      $kibuvits_func_s_hash_b_module_digest_loaded=true
   end # if
   ob_hashfunc=Digest::SHA2.new(i_bitlen)
   s_out=ob_hashfunc.hexdigest(s_in)
   return s_out
end # kibuvits_s_hash

#=========---KRL-selftests-infrastructure-start---=========================

# The .selftest methods depend on this function. This function is
# located here because the other 2 alternatives are more verbose.
# First alternative would be to "require" it in every .selftest method,
# which is redundant and the other alternative would be to "require"
# it from another file in here, which seems uselessly costly and verbose.
def kibuvits_testeval(a_binding,teststring)
   s_script="begin\n"+
   teststring+"\n"+
   "rescue Exception => e\n"+
   "    ar_msgs<<\""+teststring+": \\n\"+e.to_s\n"+
   "end # try-catch\n"
   eval(s_script,a_binding)
end #kibuvits_testeval

# Returns a boolean value.
def kibuvits_block_throws
   answer=false;
   begin
      yield
   rescue Exception => e
      answer=true
   end # try-catch
   return answer
end # kibuvits_block_throws

#=========---KRL-selftests-infrastructure-end-----=========================


#==========================================================================

