#!/usr/bin/env ruby
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#--------------------------------------------------------------------------
require "./mmmv_ruby_boilerplate_t1.rb"
include Mmmv_ruby_boilerplate_t1

#--------------------------------------------------------------------------

ar_s=["aa","bb","cc"]
s=kibuvits_s_concat_array_of_strings(ar_s)
puts s
puts kibuvits_factorial(4).to_s
puts Kibuvits_rng.i_random_t1(42).to_s
puts kibuvits_hash_plaice_t1("abcc")

#-------------------------------
s_cleartext="aa"
s_normalized=Kibuvits_cleartext_length_normalization.s_normalize_t1(
s_cleartext,42) # 42 is too short for real data
puts "\nNormalized text:\n"+s_normalized+"\n\n"
s_denormalized=Kibuvits_cleartext_length_normalization.s_normalize_t1_extract_cleartext(
s_normalized,$kibuvits_msgc_stack)
puts "denormalized text:\n"+s_denormalized+"\n\n"
#-------------------------------
s=Kibuvits_cg.fill_form([],"")
#-------------------------------
s_php_array_variable_name="arht_uuu"
ar_or_ht_x=Hash.new
ar_or_ht_x["ee"]=44
ar_or_ht_x[55]="ihii"
ar_or_ht_x[57]=4.5
s_x=Kibuvits_cg_php_t1.s_ar_or_ht_2php_t1(s_php_array_variable_name,
ar_or_ht_x)
#-------------------------------
ob_arcursor=Kibuvits_arraycursor_t1.new
ob_arcursor.reset(["aa","bb","cc"])
if ob_arcursor.inc()!="aa"
   raise(Exception.new("GUID=='8422473a-4011-4c3c-b42a-f19010d1a2e7'"))
end # if
if ob_arcursor.inc()!="bb"
   raise(Exception.new("GUID=='58202e25-9424-47d6-a25a-f19010d1a2e7'"))
end # if
ob_arcursor.reset([])
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='e2c9377c-3a3f-4f33-b82a-f19010d1a2e7'"))
end # if
if ob_arcursor.inc()!=nil
   raise(Exception.new("GUID=='1360b21d-0572-4555-a0ba-f19010d1a2e7'"))
end # if
if ob_arcursor.dec()!=nil
   raise(Exception.new("GUID=='15dcd180-2b3f-431e-bbca-f19010d1a2e7'"))
end # if
#-------------------------------
#ht_dependency_relations=Hash.new
#ht_dependency_relations["Micky"]=["Donald","Pluto"]
#ht_dependency_relations["Swan"]=[]
#ht_dependency_relations["Horse"]=["Mule"]
#ht_dependency_relations["Frog"]=nil
#ht_dependency_relations["Butterfly"]="Beetle"
#-------------------------------
s,b=Kibuvits_str.s_b_character_name_t1("(")
puts(s) if !b
#-------------------------------


#==========================================================================
