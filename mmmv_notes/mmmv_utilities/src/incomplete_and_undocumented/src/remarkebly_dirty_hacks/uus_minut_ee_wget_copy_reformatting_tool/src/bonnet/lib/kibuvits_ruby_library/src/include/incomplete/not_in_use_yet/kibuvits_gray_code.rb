#!/usr/bin/env ruby
#==========================================================================

if !defined? KIBUVITS_HOME
	x=ENV['KIBUVITS_HOME']
	KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
	require  KIBUVITS_HOME+"/src/include/kibuvits_XD_image.rb"
else
	require  "kibuvits_XD_image.rb"
end # if
require "singleton"
#==========================================================================
# http://en.wikipedia.org/wiki/Gray_code
# TODO: Subject to completion after the Kibuvits_XD_image has been completed.
class Kibuvits_gray_code

	public
	def initialize
	end #initialize

	private




	public

	# Returns an array of arrays, where bits are represented as boolean values.
	def generate i_number_of_bits
		kibuvits_typecheck binding(), Fixnum, i_number_of_bits
		if i_number_of_bits<=0
			kibuvits_throw "i_number_of_bits=="+i_number_of_bits.to_s+" <=0"
		end # if
		ar_vectors=Array.new
		return ar_vectors
	end # run

	def Kibuvits_gray_code.generate i_number_of_bits
		ar_vectors=Kibuvits_gray_code.instance.run(i_number_of_bits)
		return ar_vectors
	end # Kibuvits_gray_code.run
	private

	def Kibuvits_gray_code.test_singleline

	end # Kibuvits_gray_code.test_singleline

	public
	include Singleton
	def Kibuvits_gray_code.selftest
		ar_msgs=Array.new
		#kibuvits_testeval binding(), "Kibuvits_gray_code.test_singleline"
		return ar_msgs
	end # Kibuvits_gray_code.selftest
end # class Kibuvits_gray_code

#==========================================================================


