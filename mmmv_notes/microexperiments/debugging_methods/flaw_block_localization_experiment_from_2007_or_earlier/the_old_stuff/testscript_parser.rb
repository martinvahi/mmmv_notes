#!/usr/bin/env ruby
#--------------------------------------------------------------------
=begin
	This file is in public domain.
        SPDX-License-Identifier: 0BSD
	Author of the relatively awful and really old code in 
        this file from year 2007 or earlier: Martin.Vahi@softf1.com

	Module SpectrumbasedDiagnosis implements a semi-automated
	debugging technique that has been developed in Delft University 
	of Technology, Embedded Systems Institute. The authors of the
	technique are: Peter Zoeteweij, Rui Abreu, Rob Golsteijn, 
	Arjan van Gemund. 

	The author and the original copyright holder of this code, 
	Martin Vahi, does NOT represent the aforementioned team 
	from the Delft University of Technology.
=end
#--------------------------------------------------------------------
require "rake"
module SpectrumbasedDiagnosis
#--------------------------------------------------------------------
class Parserengine_base

def initialize(special_comment, block_start, block_end, test_id_attr,
		autotest_scriptfile_path )
	@autotest_scriptfile_path=autotest_scriptfile_path
	@special_comment=special_comment
	@block_start=block_start
	@block_end=block_end
	@test_id_attr=test_id_attr
	@hashtable_of_readout=Hash.new
	@hashtable_of_readout.store("cmdline_executionstring_prefix",
		@autotest_scriptfile_path + " ")
end # initialize()

def extract_raw_block(file_content)
	output=""
	b=false
	file_content.each_line do |line|
		if line.include? @block_start then b=true; next; end
		break if line.include? @block_end
		if b then output+=line end 
		end # loop
	return output
end #extract_raw_block

def extract_test_number(a_line)
        s=a_line.gsub("\t","").gsub(" ","")
        id_attr=
        id_attr=@test_id_attr.gsub("\t","").gsub(" ","")
        i1=s.index(id_attr)
        if i1==nil
                throw "\nIt is expected that a spaceless and tabless " +
			"version of string\n" + a_line + 
			"\ncontains a spaceless and tabulationless " +
                        "version of string \"" + @test_id_attr + "\"\n," +
                        "but it does not meet that condition.\n"
                end # if
        s=s[(i1+id_attr.length)..(-1)]
        i1=s.index(/^[0-9]/)
        if i1==nil
                throw "\nIt is expected that a string \"" + @test_id_attr +
                        "\"\nis followed by digits, but a string\n" +
                        a_line + "\ncontains at least one such case, " +
                        "where this condition is not met.\n"
                end # if
        i2=s.index(/[^0-9]/)
        i2=-1 if i2==nil
        s=s[0..i2]
        return s.to_i
end #extract_test_number()


def extract_test_region_names(a_line)
	s=a_line.gsub("\n","").gsub(/\t/," ").gsub(@special_comment,"")
	s=s.gsub(","," ").squeeze(" ").strip
	region_names=s.split(" ")
	return region_names
end #extract_test_region_names()

def extract_ids(raw_block_string)
	testIDs_and_regions=Hash.new
	test_region_names=Array.new
	test_id=-1
	extracting_regions=false
	raw_block_string.each_line do |line|
		if line.include? @test_id_attr
			extracting_regions=true
			if 0 < test_region_names.length
				testIDs_and_regions.store(test_id,
					test_region_names)
				test_region_names=Array.new
				end # if	
			test_id=extract_test_number(line)
			next
			end # if
		if extracting_regions and (line.include? @special_comment)
			array1=extract_test_region_names(line)
			test_region_names=test_region_names + array1
		else 
			extracting_regions=false
			end # if
		end # loop
	if 0 < test_region_names.length
		testIDs_and_regions.store(test_id, test_region_names)
		end # if	
	return testIDs_and_regions
end #extract_ids

def read_file(full_path)
 	if full_path[0..0]!="/"
                raise "\n\n\"full_path2file\" had a value of:\n" +
                        full_path +
                        "\n but a full path is required instead.\n\n"
                end # if
        output=""
        File.open(full_path) do |file|
                while line = file.gets
                        output+=line
                        end # while
                end # Open-file region.
        return output
end #read_file

def create_additional_readout()
	return @hashtable_of_readout
end # create_additional_readout()

def parse()
	autotest_scriptfile_content=read_file(@autotest_scriptfile_path)
	str1=extract_raw_block(autotest_scriptfile_content)
	ids_and_regions=extract_ids(str1)
	hashtable_of_readout=create_additional_readout()
	return ids_and_regions, hashtable_of_readout
end #parse


# Adds a metohd to self.
def add_method(method_name, class_of_origin)
	if not defined? @new_methods_at_self
		@new_methods_at_self=Array.new
		end # if
	new_method="The local variable, new_method, will change its type."
	eval "new_method=class_of_origin.method(:" + method_name + ")"
	new_method_args=""
	new_method.arity.times {|i| new_method_args+="x" + i.to_s + ", "}
	if 0 < new_method_args.length
		new_method_args=new_method_args.reverse.sub(",","").reverse
		end # if
	method_id=@new_methods_at_self.length
	@new_methods_at_self << new_method
	command="def " + method_name + "(" + new_method_args + ")\n"+
		"@new_methods_at_self[" + method_id.to_s + "].call(" + 
		new_method_args + ") end" 
	eval command
end # add_method()

end # class Parserengine_base
#--------------------------------------------------------------------
class Parserengine_ruby < Parserengine_base
def initialize(autotest_scriptfile_path)
	super(special_comment="\#\#\#", block_start="def ihaa", 
		block_end="end # ihaa", test_id_attr="if test_id==",
		autotest_scriptfile_path=autotest_scriptfile_path )
end # initialize()
end # class Parserengine_ruby
#--------------------------------------------------------------------
class Parserengine_acapella< Parserengine_base
def initialize(autotest_scriptfile_path)
	super(special_comment="//CCC", block_start="proc TestDispatcher", 
		block_end="}// TestDispatcher()", test_id_attr="Set(ID=",
		autotest_scriptfile_path=autotest_scriptfile_path )
	
	@hashtable_of_readout.delete("cmdline_executionstring_prefix")
	@hashtable_of_readout.store("cmdline_executionstring_prefix",
		"imacro " + autotest_scriptfile_path + " -s TestID=")
end # initialize()
	
end # class Parserengine_acapella
#--------------------------------------------------------------------
class Testscript_parser
def initialize(autotest_scriptfile_path,
		language="described_within_autotest_script")
	@autotest_scriptfile_path=autotest_scriptfile_path
	@language=language.downcase
	testscript_languages=["described_within_autotest_script",
		"ruby", "acapella"] 
	if testscript_languages.include?@language
		if @language=="described_within_autotest_script"
			initialize_from_file(autotest_scriptfile_path)
		else
			eval("@engine=Parserengine_" + @language + 
				".new(\"" + autotest_scriptfile_path + 
				"\")") 
			#acquire_methods()
			end # if
	else
		throw Exception.new("\n Language \"" + language +
			"\" is not yet supported.")
		end # case
end # initialize()

def initialize_from_file(autotest_scriptfile_path)
	@autotest_scriptfile_path=autotest_scriptfile_path
	# Subject to later completion. The idea is that
	# this allows one to write a universal wrapper to
	# this whole program so that one can define the
	# block parameters and language in the autotest script file
	# and never to toutch the Ruby code again. One also needs
	# a class named Parserengine_universal.
	throw "This method has not yet been implemented."
end # initialize_from_file

def parse()
	ids_and_regions, hashtable_of_readout=@engine.parse
	return ids_and_regions, hashtable_of_readout
end #parse

private
# Adds a metohd to self.
def add_method(method_name, class_of_origin)
	if not defined? @new_methods_at_self
		@new_methods_at_self=Array.new
		end # if
	new_method="The local variable, new_method, will change its type."
	eval "new_method=class_of_origin.method(:" + method_name + ")"
	new_method_args=""
	new_method.arity.times {|i| new_method_args+="x" + i.to_s + ", "}
	if 0 < new_method_args.length
		new_method_args=new_method_args.reverse.sub(",","").reverse
		end # if
	method_id=@new_methods_at_self.length
	@new_methods_at_self << new_method
	command="def " + method_name + "(" + new_method_args + ")\n"+
		"@new_methods_at_self[" + method_id.to_s + "].call(" + 
		new_method_args + ") end" 
	eval command
end # add_method()

# # The acquire_methods() partly enforces an interface of the
# # language specific classes.
# def acquire_methods()
# 	["read_file", "extract_raw_block", "extract_ids", 
# 	"extract_test_number","create_additional_readout", 
# 	"extract_test_region_names"].each do |method_name| 
# 		add_method(method_name, @engine) 
# 		end # loop
# end # acquire_methods()

end # class Testscript_parser
#--------------------------------------------------------------------
class Testscript_executer
def initialize(testIDs_and_regions, hashtable_of_readout, 
		autotest_scriptfile_path)
	@hashtable_of_readout=hashtable_of_readout
	@testIDs_and_regions=testIDs_and_regions
	@autotest_scriptfile_path=autotest_scriptfile_path
end # initialize

def single_test_cmdline_string(key)
	s=@hashtable_of_readout.fetch("cmdline_executionstring_prefix")
	return s + key.to_s
end #single_test_cmdline_string()

def execute_tests()
	@test_successes=Hash.new
	@testIDs_and_regions.each do |key, array_of_regions|
		@test_successes.store(key, execute_a_single_test(
			single_test_cmdline_string(key)))
		end # loop
end # execute_tests()

# The execute_tests_v2 does not call one bash-command
# per test but uses an external execution loop and 
# reads the vector of successes and failures in from
# a text file. The text file is expected to contain only
# one row per test and the format of the row is as follows:
#
#       (failed   |succeeded)---[^ ]+
#
# An example:
#        failed   ---Test1         
#        succeeded---Test2         
#        failed   ---CrazyTest3
#        failed   ---input_validation
#        succeeded---Test69
#
# This can save a lot of time in cases, where
# the loading of the testable program is multiple seconds long 
# or the amount of tests is considerable.
def execute_tests_v2()
	@test_successes=Hash.new
	# POOLELI
	@testIDs_and_regions.each do |key, array_of_regions|
		@test_successes.store(key, execute_a_single_test(
			single_test_cmdline_string(key)))
		end # loop
end # execute_tests_v2()

def calculate_statistics()
	if(!defined? @test_successes)
		throw "\nThe tests have not been run yet by this " +
			"Testscript_executer instance.\n"
		end # if
	@statistics=Hash.new
	extract_test_region_names()
	@test_region_names.each do |region|
		a11=0.0; a10=0; a01=0; statistic=0.0; t=0
		@testIDs_and_regions.each do |key, array_of_regions|
			if array_of_regions.include? region # a1X
				if !@test_successes.fetch(key)==true 
					a11+=1 
				else a10+=1 end # if
			else # a0X
				a01+=1 if !@test_successes.fetch(key)
				end # if
			end # loop
		#puts "region=" + region + "  a11=" + a11.to_s +
		#	"  a10=" + a10.to_s + "  a01=" + a01.to_s
		statistic=(a11)/(a11+a10+a01) if 0 < a11
		@statistics.store(region, statistic)
		end # loop
	return @statistics
end # calculate_statistics()

def statistics_string_1()
	if !defined? @statistics
		throw "\nThe statistics have not been assembled " +
		"yet by this Testscript_executer instance.\n"
		end # if
	@statistics.sort
	statistics=Array.new
	regions=Array.new
	@statistics.each do |region, statistic|
		regions <<  region.clone
		statistics << 0.0 + statistic
		end # loop
	statistics,regions=mulsort_arrays(statistics, regions)
	s=""
	regions.length.times do |i|
		st=statistics[i].to_s; n=7
		st=st[0..(n-1)] if n < st.length
		rg=regions[i]; n=55
		rg=rg[0..(n-1)] if n < rg.length
		s+=rg + "      " + st + "\n"
		end # loop
	return s
end # statistics_string_1()

private 

# dirty hack
def mulsort_arrays(statistics, region_names)
	index=statistics.clone
	data=region_names.clone
	n=index.length
	n.times do 
	(n-1).times do |ii_|
		if index[(ii_)] < index[ii_+1] 
			tmp=data[ii_].clone
			data[ii_]=data[ii_+1].clone
			data[ii_+1]=tmp
			tmp_=index[ii_]
			index[ii_]=index[ii_+1]
			index[ii_+1]=tmp_
			end # if
		end # loop
		end # loop
	return index, data
end #mulsort_arrays() 

def extract_test_region_names()
	@test_region_names=Array.new
	@testIDs_and_regions.each_key do |key|
		@testIDs_and_regions.fetch(key).each do |test_region_name| 
			if !@test_region_names.include? test_region_name
				@test_region_names<< test_region_name
				end # if
			end # loop
		end # loop
	return @test_region_names
end # extract_test_region_names()

def execute_a_single_test(bashscript_string)
	run_sucessful=true
	begin 
		sh bashscript_string 
	rescue 
		run_sucessful=false 
		end # try-catch
	return run_sucessful
end # execute_a_single_test()

# Adds a metohd to self.
def add_method(method_name, class_of_origin)
	if not defined? @new_methods_at_self
		@new_methods_at_self=Array.new
		end # if
	new_method="The local variable, new_method, will change its type."
	eval "new_method=class_of_origin.method(:" + method_name + ")"
	new_method_args=""
	new_method.arity.times {|i| new_method_args+="x" + i.to_s + ", "}
	if 0 < new_method_args.length
		new_method_args=new_method_args.reverse.sub(",","").reverse
		end # if
	method_id=@new_methods_at_self.length
	@new_methods_at_self << new_method
	command="def " + method_name + "(" + new_method_args + ")\n"+
		"@new_methods_at_self[" + method_id.to_s + "].call(" + 
		new_method_args + ") end" 
	eval command
end # add_method()

end # class Testscript_executer
#--------------------------------------------------------------------
def execute_autotest(autotest_scriptfile_path, 
	autotest_script_language)
	parser=Testscript_parser.new(autotest_scriptfile_path,
		autotest_script_language)
	testIDs_and_regions, hashtable_of_readout=parser.parse
	executer=Testscript_executer.new(testIDs_and_regions,
		hashtable_of_readout, 
		autotest_scriptfile_path)
	executer.execute_tests
	executer.calculate_statistics
	puts "\n"
	puts "------- Spectrum-based Diagnoses Start ----------------\n"
	puts executer.statistics_string_1
	puts "------- Spectrum-based Diagnoses End ------------------"
	puts "\n"
end # execute_autotest()
#--------------------------------------------------------------------
end # module SpectrumbasedDiagnosis
#--------------------------------------------------------------------

