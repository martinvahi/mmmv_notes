#!/usr/bin/env ruby
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#--------------------------------------------------------------------------
require 'pathname'
ob_pth=Pathname.new(__FILE__).realpath.parent
require(ob_pth.to_s+"/mmmv_ruby_boilerplate_t2.rb")
ob_pth=nil;

#--------------------------------------------------------------------------
ar_s=["aa","bb","cc"]
s=kibuvits_krl171bt2_s_concat_array_of_strings(ar_s)
puts s
puts kibuvits_krl171bt2_factorial(4).to_s
puts Kibuvits_krl171bt2_rng.i_random_t1(42).to_s
puts kibuvits_krl171bt2_hash_plaice_t1("abcc")

#-------------------------------
s_cleartext="aa"
s_normalized=Kibuvits_krl171bt2_cleartext_length_normalization.s_normalize_t1(
s_cleartext,42) # 42 is too short for real data
puts "\nNormalized text:\n"+s_normalized+"\n\n"
s_denormalized=Kibuvits_krl171bt2_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
s_normalized,$kibuvits_krl171bt2_msgc_stack)
puts "denormalized text:\n"+s_denormalized+"\n\n"
#-------------------------------
s=Kibuvits_krl171bt2_cg.fill_form([],"")
#-------------------------------
s_php_array_variable_name="arht_uuu"
ar_or_ht_x=Hash.new
ar_or_ht_x["ee"]=44
ar_or_ht_x[55]="ihii"
ar_or_ht_x[57]=4.5
s_x=Kibuvits_krl171bt2_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
ar_or_ht_x)
#-------------------------------
ob_arcursor=Kibuvits_krl171bt2_arraycursor_t1.new
ob_arcursor.reset(["aa","bb","cc"])
if ob_arcursor.inc()!="aa"
   raise(Exception.new("GUID=='1c11661c-3683-4f5e-8273-5393209176e7'"))
end # if
if ob_arcursor.inc()!="bb"
   raise(Exception.new("GUID=='ec5c8323-06cb-4b20-8473-5393209176e7'"))
end # if
ob_arcursor.reset([])
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='88ccea1f-e89e-43da-a273-5393209176e7'"))
end # if
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='5ba5ac16-457d-4e71-8473-5393209176e7'"))
end # if
if ob_arcursor.dec()!=nil
   raise(Exception.new("GUID=='b0986b4d-fca5-4c56-b573-5393209176e7'"))
end # if
#-------------------------------
#ht_dependency_relations=Hash.new
#ht_dependency_relations["Micky"]=["Donald","Pluto"]
#ht_dependency_relations["Swan"]=[]
#ht_dependency_relations["Horse"]=["Mule"]
#ht_dependency_relations["Frog"]=nil
#ht_dependency_relations["Butterfly"]="Beetle"
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="5aa01e21-111c-45d3-b273-5393209176e7"
#==========================================================================
