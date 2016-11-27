#!/usr/bin/env ruby
#==========================================================================

if !defined? KIBUVITS_HOME
	x=ENV['KIBUVITS_HOME']
	KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
	require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
else
	require  "kibuvits_boot.rb"
end # if
#==========================================================================
# An X-dimensional "matrix" that has various operations defined for
# it. By default it is infinite in size and sparse, however it does
# have a tag for describing its dimensions for cases like matrix
# multiplication. Internal memory management has been abstracted away.
class Kibuvits_XD_image

	public
	def initialize default_pixel_value
		@default_pixel_value=default_pixel_value
	end #initialize

	private


	public


	# Returns an array of arrays, where bits are represented as boolean values.
	def xor kibuvits_xd_image
	end # run

	# 
	def xor! kibuvits_xd_image
	end # run

	private

	def Kibuvits_XD_image.test_singleline

	end # Kibuvits_XD_image.test_singleline

	public
	def Kibuvits_XD_image.selftest
		ar_msgs=Array.new
		#kibuvits_testeval binding(), "Kibuvits_XD_image.test_singleline"
		return ar_msgs
	end # Kibuvits_XD_image.selftest
end # class Kibuvits_XD_image

#==========================================================================


