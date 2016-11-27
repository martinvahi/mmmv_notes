#!/usr/bin/env ruby
=begin

 Copyright 2010, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/bsd-license.php

=end 
#==========================================================================
#--- start of a distracting hack to keep this example working -------------
if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   require(ob_pth_0.parent.parent.parent.to_s+"/src/include/kibuvits_boot.rb")
end # if
require  KIBUVITS_HOME+"/src/include/kibuvits_all.rb"
#----------end of the distracting hack ------------------------------------

# To save time on looking up the expected types of variables,
# the variables in the KRL have usually, but not always,
# type specific prefixes.

ar_therestofthename=Array.new
b_therestofthename=true # or false
bn_therestofthename=Kernel.binding()
cl_therestofthename=Class.new
dt_therestofthename=Time.new
ht_therestofthename=Hash.new
i_therestofthename=42 # Fixnum
ix_therestofthename=42 # A Fixnum that represents an index.
ixs_therestofthename=42 # A Fixnum that represents a separator index. http://urls.softf1.com/a1/krl/frag4_array_indexing_by_separators/
fd_therestofthename=1.61803398874989484820458683 # is of type Float, which is the rounded classical C++ float
fdr_therestofthename=73.to_r# Rational, which is the arbitrary precision rational number
fdx_therestofthename=73.to_r# Fixnum or Float or Rational
sfd_therestofthename=75.44.to_s# A string that depicts a Float
sfdr_therestofthename=77.to_r.to_s# A string that depicts a Rational
sfdx_therestofthename=73.to_s# A string that depicts a Fixnum or a Float or a Rational
rgx_therestofthename=/[a]+b/ # Regexp
md_therestofthename=rgx_therestofthename.match("aaabcdeaab") # MatchData
s_therestofthename="This is of type String"
sb_therestofthename="t" # A string that represents a boolean value of true.
sb_therestofthename="f" # A string that represents a boolean value of false.
si_therestofthename="-42" # A string that represents a whole number.
sixs_therestofthename="0" # A string that represents a separator index.
sym_therestofthename=:this_is_a_symbol # of class Symbol
@lc_therestofthename="Whatever type, but the lc stands for 'local constant'."
@lc_s_therestofthename="The type specification prefix follows the @lc_ prefix."

func_function_instance=lambda{puts "Hi!"} # A Proc instance
func_function_instance.call() # executes the function, prints "Hi!"

=begin
   Some variable names are reserved exclusively for referencing
   only instances of certain types, but variable names a,b,c,x,y,z
   are type-assumption-free.
=end

ar=Array.new
b=true # or false
bn=Kernel.binding()
cl=Class.new
dt=Time.utc(2000,1,21)
ht=Hash.new
i=42 # which is a whole number of class Fixnum
ix=42 # A Fixnum that represents an index.

# http://urls.softf1.com/a1/krl/frag4_array_indexing_by_separators/
ixs=42 # A Fixnum that represents a separator index.

fd=3.1415926535897932384626433 # which is of type Float
fdr=73.to_r
fdx=73.to_r # which is of type Fixnum or Float or Rational
sfd_for_serialization=4.7.to_s # A String that depicts a Float
sfdr_for_serialization=((4.to_r/"5/2".to_r)+2).to_s # A string that depicts a Rational
sfdx_for_serialization=4.to_r.to_s # A String that depicts Fixnum or Float or Rational
rgx=/[a]+b/ # or Regexp.compile("etc[.]")
md=rgx.match("aaabcdeaab") # MatchData, which can be nil, if the match is not found.
s=" is for String instances"
sb_wow='t'
sb_wiii='f'
si_serialized_whole_number="-2038"
sym_XXX=:a_nice_method_name

=begin
   Neither the prefixes nor the names of the variables
   imply that the variables do not hold the value of nil.

   Often the value of 42 is used as a "whatever whole number".
   That choice is purely for fun and has its influences from
   the names of projects like Scheme 84, Scheme 48, and the
   "Ultimate Answer to the Ultimate Question of Life,
   The Universe, and Everything".

   Functions with a name prefix of "exc_" 
   throw on inconsistent data or unsuitable state.
=end

def exc_function_example(s_fp)
   if !File.exist? s_fp
      kibuvits_throw("Functions that have a prefix of 'exc_'"+
      "in their name, throw on errors.")
   end # if
   s=file2str(s_fp)
   kibuvits_writeln(s)
end # exc_function_example

=begin
   Functions with a name prefix of "exm_" 
   throw on inconsistent data or unsuitable state only,
   if the Kibuvits_msgc_stack instance has not been provided.
   If the Kibuvits_msgc_stack instance has been provided,
   then the function writes the error to the 
   Kibuvits_msgc_stack instance and returns.
=end

def exm_function_example(s_fp,msgcs=nil)
   if !File.exist? s_fp
      s_msg="File with the path of \n"+s_fp+"\ndoes not exist."
      if msgcs.class==Kibuvits_msgc_stack
         msgcs.cre("\n\nA text in the msgcs: \n"+s_msg+"\n\n")
         return
      else
         kibuvits_throw(s_msg)
      end # if
   end # if
   s=file2str(s_fp)
   kibuvits_writeln(s)
end # exm_function_example

s_fp="/tmp/this_file_does_not_exist_444.txt"
#exm_function_example(s_fp)
msgcs=Kibuvits_msgc_stack.new
exm_function_example(s_fp,msgcs)
#kibuvits_writeln(msgcs.to_s) if msgcs.b_failure

#==========================================================================
