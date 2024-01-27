#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
require 'pathname'
ob_pth=Pathname.new(__FILE__).realpath.parent
$s_fp_tests_main_script_parent_folder=ob_pth.to_s
ob_pth=nil;
require($s_fp_tests_main_script_parent_folder+"/2024_01_27_mmmv_ruby_boilerplate_t6.rb")

#--------------------------------------------------------------------------

ar_s=["aa","bb","cc"]
s=kibuvits_krl171bt5_s_concat_array_of_strings(ar_s)
puts s
puts kibuvits_krl171bt5_factorial(4).to_s
puts Kibuvits_krl171bt5_rng.i_random_t1(42).to_s
puts kibuvits_krl171bt5_hash_plaice_t1("abcc")

#-------------------------------
s_cleartext="aa"
s_normalized=Kibuvits_krl171bt5_cleartext_length_normalization.s_normalize_t1(
s_cleartext,42) # 42 is too short for real data
puts "\nNormalized text:\n"+s_normalized+"\n\n"
s_denormalized=Kibuvits_krl171bt5_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
s_normalized,$kibuvits_krl171bt5_msgc_stack)
puts "denormalized text:\n"+s_denormalized+"\n\n"
#-------------------------------
s=Kibuvits_krl171bt5_cg.fill_form([],"")
#-------------------------------
s_php_array_variable_name="arht_uuu"
ar_or_ht_x=Hash.new
ar_or_ht_x["ee"]=44
ar_or_ht_x[55]="ihii"
ar_or_ht_x[57]=4.5
s_x=Kibuvits_krl171bt5_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
ar_or_ht_x)
#-------------------------------
ob_arcursor=Kibuvits_krl171bt5_arraycursor_t1.new
ob_arcursor.reset(["aa","bb","cc"])
if ob_arcursor.inc()!="aa"
   raise(Exception.new("GUID=='38a0771d-c7ea-4a47-b438-d0d240b118e7'"))
end # if
if ob_arcursor.inc()!="bb"
   raise(Exception.new("GUID=='573b7071-90dd-4b93-af38-d0d240b118e7'"))
end # if
ob_arcursor.reset([])
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='26bd981b-258d-47c7-8138-d0d240b118e7'"))
end # if
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='46ef1053-8d59-4b28-9538-d0d240b118e7'"))
end # if
if ob_arcursor.dec()!=nil
   raise(Exception.new("GUID=='dc0cb85e-477b-4bcb-9438-d0d240b118e7'"))
end # if
#-------------------------------
s_fp_test=$s_fp_tests_main_script_parent_folder+"/tests/kibuvits_krl171bt5_histogram_t1_tests.rb"
if !File.exist? s_fp_test
   raise(Exception.new("GUID=='54239d35-3d1e-4e41-a138-d0d240b118e7'"))
else
    require(s_fp_test)
end # if
#-------------------------------
#ht_dependency_relations=Hash.new
#ht_dependency_relations["Micky"]=["Donald","Pluto"]
#ht_dependency_relations["Swan"]=[]
#ht_dependency_relations["Horse"]=["Mule"]
#ht_dependency_relations["Frog"]=nil
#ht_dependency_relations["Butterfly"]="Beetle"
#==========================================================================
# S_VERSION_OF_THIS_FILE="02431c15-61b4-4e81-b438-d0d240b118e7"
#==========================================================================
