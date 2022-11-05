#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
	x=ENV['KIBUVITS_HOME']
	KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
	require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
	require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
else
	require  "kibuvits_msgc.rb"
	require  "kibuvits_str.rb"
end # if
require "singleton"
#==========================================================================

# The Kibuvits_set is a "set", as known from mathematics.
# 
# If it's used as a fuzzy set, one can add
# the membership values as values to the
# ht_elements. Elements themselves are meant to be the keys of the
# ht_elements, because then it is computationally cheap to check,
# whether their membership is greater than zero.
#
# The ht_attrs is for handling partial order, etc.
#
# In general, the ideology behind this class, as simple as it
# its, is that one should not restrain its use, because one can
# not anticipate all possible "math tricks"
# (not even math PhDs can, because math evolves), but one should
# facilitate the creation of computationally cheap implementations.
class Kibuvits_set
	@@i42=42
	attr_reader :ht_attrs, :ht_elements
	attr_accessor :b_fuzzy
	def initialize
		@ht_attrs=Hash.new
		@ht_elements=Hash.new
		@b_fuzzy=false
	end #initialize
end # class Kibuvits_set


#==========================================================================
# The class Kibuvits_math_set is a namespace for functions that
# perform classic, non-fuzzy, set operations. Obviously it can not,
# possibly, cover they whole Set Theory. 
class Kibuvits_math_set
	def initialize
	end #initialize

	private
	def Kibuvits_math_set.symmetric_difference_fuzzy_fuzzy set1, set2
		set_out=Kibuvits_set.new
		set_out.b_fuzzy=true
		return set_out
	end # Kibuvits_math_set.symmetric_difference_fuzzy_fuzzy 

	def Kibuvits_math_set.symmetric_difference_fuzzy_nonfuzzy set_fz, set_plain
		set_out=Kibuvits_set.new
		set_out.b_fuzzy=true
		return set_out
	end # Kibuvits_math_set.symmetric_difference_fuzzy

	def Kibuvits_math_set.symmetric_difference_plain_plain set1, set2
		set_out=Kibuvits_set.new
		return set_out
	end # Kibuvits_math_set.symmetric_difference_plain_plain 

	public

	def Kibuvits_math_set.symmetric_difference set1, set2
		bn=binding()
		kibuvits_typecheck bn, Kibuvits_set, set1
		kibuvits_typecheck bn, Kibuvits_set, set2
		i=0 
		i=i+1 if set1.b_fuzzy # 00_2+01_2=01_2=1_10
		i=i+2 if set2.b_fuzzy # 01_2+10_2=11_2=3_10
		set_out=nil
		case i
		when 0
			set_out=Kibuvits_math_set.symmetric_difference_plain_plain(
				set1,set2)
		when 1
			set_out=Kibuvits_math_set.symmetric_difference_fuzzy_nonfuzzy(
				set1,set2)
		when 2
			set_out=Kibuvits_math_set.symmetric_difference_fuzzy_nonfuzzy(
				set2,set1)
		when 3
			set_out=Kibuvits_math_set.symmetric_difference_fuzzy_fuzzy(
				set1,set2)
		else
		end
		return set_out
	end # Kibuvits_math_set.symmetric_difference

	private
	def Kibuvits_math_set.test_symmetric_difference
		set1=Kibuvits_set.new
		if !kibuvits_block_throws{Kibuvits_math_set.symmetric_difference(42,set1)}
			kibuvits_throw "test 1"
		end # if
		if !kibuvits_block_throws{Kibuvits_math_set.symmetric_difference(set1,42)}
			kibuvits_throw "test 2"
		end # if
	end # Kibuvits_math_set.test_symmetric_difference
	
	public
	include Singleton
	def Kibuvits_math_set.selftest
		ar_msgs=Array.new
		#kibuvits_testeval binding(), "Kibuvits_math_set.test_symmetric_difference"
		return ar_msgs
	end # Kibuvits_math_set.selftest
end # Kibuvits_math_set

#==========================================================================
