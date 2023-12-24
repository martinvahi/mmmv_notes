#!/usr/bin/env ruby
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#--------------------------------------------------------------------------
require 'pathname'
ob_pth=Pathname.new(__FILE__).realpath.parent
require(ob_pth.to_s+"/2022_09_24_mmmv_ruby_boilerplate_t4.rb")
ob_pth=nil;

#--------------------------------------------------------------------------

ar_s=["aa","bb","cc"]
s=kibuvits_krl171bt4_s_concat_array_of_strings(ar_s)
puts s
puts kibuvits_krl171bt4_factorial(4).to_s
puts Kibuvits_krl171bt4_rng.i_random_t1(42).to_s
puts kibuvits_krl171bt4_hash_plaice_t1("abcc")

#-------------------------------
s_cleartext="aa"
s_normalized=Kibuvits_krl171bt4_cleartext_length_normalization.s_normalize_t1(
s_cleartext,42) # 42 is too short for real data
puts "\nNormalized text:\n"+s_normalized+"\n\n"
s_denormalized=Kibuvits_krl171bt4_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
s_normalized,$kibuvits_krl171bt4_msgc_stack)
puts "denormalized text:\n"+s_denormalized+"\n\n"
#-------------------------------
s=Kibuvits_krl171bt4_cg.fill_form([],"")
#-------------------------------
s_php_array_variable_name="arht_uuu"
ar_or_ht_x=Hash.new
ar_or_ht_x["ee"]=44
ar_or_ht_x[55]="ihii"
ar_or_ht_x[57]=4.5
s_x=Kibuvits_krl171bt4_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
ar_or_ht_x)
#-------------------------------
ob_arcursor=Kibuvits_krl171bt4_arraycursor_t1.new
ob_arcursor.reset(["aa","bb","cc"])
if ob_arcursor.inc()!="aa"
   raise(Exception.new("GUID=='445752d5-8b1e-4582-9858-f0d2308196e7'"))
end # if
if ob_arcursor.inc()!="bb"
   raise(Exception.new("GUID=='4ff6a092-1749-4fdd-b518-f0d2308196e7'"))
end # if
ob_arcursor.reset([])
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='957c458e-b510-4cd8-b558-f0d2308196e7'"))
end # if
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='23bdd824-b382-4722-a038-f0d2308196e7'"))
end # if
if ob_arcursor.dec()!=nil
   raise(Exception.new("GUID=='11e998c5-af8b-4b4d-af18-f0d2308196e7'"))
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
