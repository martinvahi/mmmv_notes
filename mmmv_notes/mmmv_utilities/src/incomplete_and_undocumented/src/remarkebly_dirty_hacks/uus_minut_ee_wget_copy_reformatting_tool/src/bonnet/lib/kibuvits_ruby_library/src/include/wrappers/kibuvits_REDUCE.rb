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

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"

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
class Kibuvits_REDUCE

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
         @b_REDUCE_available_cache=Kibuvits_shell.b_available_on_path("reduce")
      else
         if !@b_REDUCE_available_cache
            @b_REDUCE_available_cache=Kibuvits_shell.b_available_on_path(
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
      s_0=s_stdout.gsub(@s_lc_endoffileread_t1,$kibuvits_lc_emptystring)
      # Error conditions tend to have more stars than 3
      s_1=s_0.gsub(/[*]/,$kibuvits_lc_emptystring)
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
   # kibuvits_shell.rb.
   #
   def s_run_by_source(s_reduce_source,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_reduce_source
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID=='a3e4b843-5435-4785-82d7-538051311fd7'")
      end # if
      if !b_REDUCE_available()
         s_default_msg="REDUCE Computer Algebra System "+
         "is missing from the PATH."
         s_message_id="REDUCE_missing_from_PATH_t1"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "29604cc1-4245-4edb-91d7-538051311fd7")
         return $kibuvits_lc_emptystring
      end # if
      s_fp_source=Kibuvits_os_codelets.generate_tmp_file_absolute_path()
      s_fp_reduce_output=Kibuvits_os_codelets.generate_tmp_file_absolute_path()
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
      s_reduce_src_updated=kibuvits_s_concat_array_of_strings(ar_s)
      #--------
      s_out=$kibuvits_lc_emptystring
      begin
         str2file(s_reduce_src_updated,s_fp_source)
         cmd=@s_lc_run_reduce+s_fp_source
         ht_stdstreams=kibuvits_sh(cmd)
         #----------------
         # REDUCE writes some errors to stdout without
         # writing anything to the stderr.
         s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
         b_err_by_stdout=b_REDUCE_stdout_contains_an_error_message(s_stdout)
         b_err_by_stderr=Kibuvits_shell.b_stderr_has_content_t1(ht_stdstreams)
         if b_err_by_stdout||b_err_by_stderr
            s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
            s_default_msg="The Bash command line \n"+cmd+
            "\nwrote the following to the "
            if b_err_by_stderr
               s_default_msg<<"stderr:\n"
               s_default_msg<<s_stderr+$kibuvits_lc_doublelinebreak
            end # if
            if b_err_by_stdout
               s_default_msg<<"stdout:\n"
               s_default_msg<<s_stdout+$kibuvits_lc_doublelinebreak
            end # if
            s_default_msg<<"\n\nGUID=='2656d836-4784-410c-b2d7-538051311fd7'"
            s_message_id="REDUCE_run_failed_t1"
            b_failure=true
            msgcs.cre(s_default_msg,s_message_id,b_failure,
            "41738203-74b2-4024-94d7-538051311fd7")
            msgc=msgcs.last
            msgc.x_data=ht_stdstreams
         end # if
      rescue Exception => e
         s_default_msg="Something went wrong.\n\n"+e.to_s+
         "\n\nGUID=='8488f917-3513-4df2-82d7-538051311fd7'"
         s_message_id="REDUCE_run_failed_t2"
         b_failure=true
         msgcs.cre(s_default_msg,s_message_id,b_failure,
         "58f5c44d-221b-4581-95d7-538051311fd7")
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


   def Kibuvits_REDUCE.s_run_by_source(s_reduce_source,msgcs)
      s_out=Kibuvits_REDUCE.instance.s_run_by_source(s_reduce_source,msgcs)
      return s_out
   end # Kibuvits_REDUCE.s_run_by_source


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
      ar_eq=Kibuvits_str.normalize_s2ar_t1(
      s_or_ar_equations_in_reduce_format,s_separator)
      ar_var=Kibuvits_str.normalize_s2ar_t1(
      s_or_ar_variables_to_be_expressed,s_separator)
      #----
      s_separator=",\n"
      s_eq=Kibuvits_str.array2xseparated_list(ar_eq,s_separator)
      s_var=Kibuvits_str.array2xseparated_list(ar_var,s_separator)
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
      s_out=kibuvits_s_concat_array_of_strings(ar_s)
      return s_out
   end # ht_solve_system_of_equations_t1_assemble_REDUCE_source


   def ht_solve_system_of_equations_t1_parse_reduce_output(
      s_reduce_output,msgcs)
      s_0=s_reduce_output.gsub(/[$]$/,$kibuvits_lc_emptystring)
      ht_out=Kibuvits_configfileparser_t1.ht_parse_configstring(s_0,msgcs)
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
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [String,Array], s_or_ar_equations_in_reduce_format
         kibuvits_typecheck bn, [String,Array], s_or_ar_variables_to_be_expressed
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         msgcs.assert_lack_of_failures(
         "GUID=='4b1dbc62-c0fa-491d-a5d7-538051311fd7'")
         if s_or_ar_equations_in_reduce_format.class==Array
            kibuvits_assert_ar_elements_typecheck_if_is_array(bn,String,
            s_or_ar_equations_in_reduce_format,
            "GUID=='4bee7822-ee87-4585-b3d7-538051311fd7'")
         end # if
         if s_or_ar_variables_to_be_expressed.class==Array
            kibuvits_assert_ar_elements_typecheck_if_is_array(bn,String,
            s_or_ar_variables_to_be_expressed,
            "GUID=='137c031c-5a55-41b7-b1d7-538051311fd7'")
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


   def Kibuvits_REDUCE.ht_solve_system_of_equations_t1(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed,msgcs)
      ht_out=Kibuvits_REDUCE.instance.ht_solve_system_of_equations_t1(
      s_or_ar_equations_in_reduce_format,s_or_ar_variables_to_be_expressed,msgcs)
      return ht_out
   end # Kibuvits_REDUCE.ht_solve_system_of_equations_t1

   #--------------------------------------------------------------------------


   public
   include Singleton

end # class Kibuvits_REDUCE

#==========================================================================
