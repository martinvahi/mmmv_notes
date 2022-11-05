#!/usr/bin/env ruby
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#--------------------------------------------------------------------------
require "./2022_01_04_mmmv_ruby_boilerplate_t3.rb"

#--------------------------------------------------------------------------

ar_s=["aa","bb","cc"]
s=kibuvits_krl171bt3_s_concat_array_of_strings(ar_s)
puts s
puts kibuvits_krl171bt3_factorial(4).to_s
puts Kibuvits_krl171bt3_rng.i_random_t1(42).to_s
puts kibuvits_krl171bt3_hash_plaice_t1("abcc")

#-------------------------------
s_cleartext="aa"
s_normalized=Kibuvits_krl171bt3_cleartext_length_normalization.s_normalize_t1(
s_cleartext,42) # 42 is too short for real data
puts "\nNormalized text:\n"+s_normalized+"\n\n"
s_denormalized=Kibuvits_krl171bt3_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
s_normalized,$kibuvits_krl171bt3_msgc_stack)
puts "denormalized text:\n"+s_denormalized+"\n\n"
#-------------------------------
s=Kibuvits_krl171bt3_cg.fill_form([],"")
#-------------------------------
s_php_array_variable_name="arht_uuu"
ar_or_ht_x=Hash.new
ar_or_ht_x["ee"]=44
ar_or_ht_x[55]="ihii"
ar_or_ht_x[57]=4.5
s_x=Kibuvits_krl171bt3_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
ar_or_ht_x)
#-------------------------------
ob_arcursor=Kibuvits_krl171bt3_arraycursor_t1.new
ob_arcursor.reset(["aa","bb","cc"])
if ob_arcursor.inc()!="aa"
   raise(Exception.new("GUID=='50f12d3c-f2c4-470e-b4c5-d180204016e7'"))
end # if
if ob_arcursor.inc()!="bb"
   raise(Exception.new("GUID=='febc8b36-197f-4d34-85c5-d180204016e7'"))
end # if
ob_arcursor.reset([])
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='a665ad1f-5346-48a7-95c5-d180204016e7'"))
end # if
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='44e7a3ec-2bd2-47a9-b2c5-d180204016e7'"))
end # if
if ob_arcursor.dec()!=nil
   raise(Exception.new("GUID=='14b79e81-f740-4d67-85c5-d180204016e7'"))
end # if
#-------------------------------
#ht_dependency_relations=Hash.new
#ht_dependency_relations["Micky"]=["Donald","Pluto"]
#ht_dependency_relations["Swan"]=[]
#ht_dependency_relations["Horse"]=["Mule"]
#ht_dependency_relations["Frog"]=nil
#ht_dependency_relations["Butterfly"]="Beetle"
#-------------------------------

#==========================================================================
