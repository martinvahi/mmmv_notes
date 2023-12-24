#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
#==========================================================================
# This Ruby code here is a dirty hack that happens to work.
# Mostly written down in a hurry as a note to myself, an idea sketch.
#
# Tested on ("uname -a")
#
# Linux hoidla01 4.19.0-10-amd64 #1 SMP Debian 4.19.132-1 (2020-07-24) x86_64 GNU/Linux
#
# With "ruby -v"
#
# ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
#
#--------------------------------------------------------------------------
require "pathname"

ob_pth=Pathname.new(__FILE__).realpath.parent
s_0=ob_pth.to_s+"/lib/2022_09_24_mmmv_ruby_boilerplate_t4/2022_09_24_mmmv_ruby_boilerplate_t4.rb"
require s_0
ob_pth_1=ob_pth.parent
$s_fp_bash_functions=ob_pth_1.to_s+"/mmmv_bash_boilerplate_t4.bash"
ob_pth=nil;
#--------------------------------------------------------------------------

class List_functions_and_throw_on_function_duplicates

   def initialize
   end # initialize

   private

   def ar_raw_list(s_fp_bash_functions)
      s_bash=kibuvits_krl171bt4_file2str(s_fp_bash_functions)
      #--------
      #ar_0=s_bash.scan(/^func_[^(]+[(]/) # works with a more primitive regex
      rgx_0=/^[ \n\t\r]*func_[^(]+[(]/
      rgx_1=/^[ \n\t\r]+/
      ar_0=Array.new
      md=nil
      s_0=nil
      s_bash.each_line do |s_line|
         md=s_line.match(rgx_0) # MatchData or nil
         if md!=nil
            s_0=(md[0]).sub(rgx_1,$kibuvits_krl171bt4_lc_emptystring)
            ar_0<<s_0
         end # if
      end # loop
      #puts ar_0.to_s
      #--------
      ar_1=Array.new
      #ar_0.each{|s_fn| ar_1<<(s_fn[0..(-4)])}
      ar_0.each{|s_fn| ar_1<<(s_fn[0..(-2)])}
      #puts ar_1.to_s
      #--------
      ar_out=ar_1
      return ar_out
   end # ar_raw_list

   def ar_find_duplicates(ar_in)
      ar_duplicates=Array.new
      ht=Hash.new
      i_ar_in_len=ar_in.size
      s_fn=nil
      i_ar_in_len.times do |ix|
         s_fn=ar_in[ix]
         if ht.has_key? s_fn
            ar_duplicates<<s_fn
         else
            ht[s_fn]=42
         end # if
      end # loop
      return ar_duplicates
   end # ar_find_duplicates


   def exc_exit_if_duplicates_exist(ar_raw)
      #--------
      ar_duplicates=ar_find_duplicates(ar_raw)
      i_ar_duplicates=ar_duplicates.size
      return if i_ar_duplicates==0
      #--------
      ar_duplicates.sort!
      s_list=""
      s_fn=nil
      i_ar_duplicates.times do |ix|
         s_fn=ar_duplicates[ix]
         s_list<<(s_fn+"\n")
      end # loop
      #--------
      kibuvits_krl171bt4_throw("\nThe list of duplicated functions:\n"+s_list+"\n")
   end # exc_exit_if_duplicates_exist

   def s_assemble_function_list_t1(ar_raw)
      #---------------------
      ar_sorted=[]+ar_raw
      ar_sorted.sort!
      #---------------------
      ar_s=Array.new
      s_fn=nil
      i_ar_sorted_len=ar_sorted.size
      i_ar_sorted_len.times do |ix|
         s_fn=ar_sorted[ix]
         ar_s<<(s_fn+"\n")
      end # loop
      #---------------------
      s_out=kibuvits_krl171bt4_s_concat_array_of_strings(ar_s)
      return s_out
   end # s_assemble_function_list_t1

   public

   def run
      #---------------------
      ar_raw=ar_raw_list($s_fp_bash_functions)
      exc_exit_if_duplicates_exist(ar_raw)
      s_function_list=s_assemble_function_list_t1(ar_raw)
      puts s_function_list
      #---------------------
   end # run

end # class List_functions_and_throw_on_function_duplicates
#--------------------------------------------------------------------------
List_functions_and_throw_on_function_duplicates.new.run

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="3e467f49-d663-49ed-8120-7241405137e7"
#==========================================================================
