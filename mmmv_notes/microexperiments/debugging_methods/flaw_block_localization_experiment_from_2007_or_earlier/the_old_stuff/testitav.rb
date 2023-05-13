#!/usr/bin/env ruby
#=========================================================================
test_id=7
if 1 <= ARGV.length
	test_id=ARGV[0].to_i
	end # if

def ihaa (test_id)
if test_id==7
### region_A, region_B
### region_C
	puts "test 7 ihaa"
	end # if
if test_id==8
### region_F, region_A, region_G
	puts "test 8 ihaa"
	throw "l2bikukkumine"
	end # if
if test_id==99
### region_F 
	puts "test 99 ihaa"
	end # if
if test_id==9
### region_A 
	puts "test 99 ihaa"
	end # if
end # ihaa

ihaa test_id
