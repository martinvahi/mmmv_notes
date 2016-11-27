#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
	x=ENV['KIBUVITS_HOME']
	KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
	require  KIBUVITS_HOME+"/src/include/kibuvits_ProgFTE.rb"
else
	require  "kibuvits_ProgFTE.rb"
end # if
#==========================================================================
=begin
The CRauth11 implements a an authentication scheme, where
the challenge is represented as a width*height table, where each of
the compartments contains an integer -99<=ii<=99 and the
response is an integer that is computed by using the
table. In its essence, the subject that wants to authenticate
oneself, has to act like a pin calculator. The weaknesses
of that authentication contain, but are not limited to, the ones
of a pin calculator.

Operations that are allowed for calculating a response,
have the following precedence:
        concatenation(|)
        multiplication(*)
        addition (+)
        subtraction(-)

The RCauth1.concatenation is defined as
=end
class RCauth1

	private
	def signum x
		return  0 if x==0
		return  1 if 0<x
		return -1 if x<0
	end # signum

	def abs x
		i=RCauth1.signum(x)*x
		return i
	end # abs

	def concatenation x1,x2
		s=RCauth1.abs(x1).to_s+RCauth1.abs(x2).to_s
		s='-'+s if signum(x1*x2)<0
		return s
	end # concatenation

=begin
The variables that denote a compartment, are encoded as v_x_y.
For example, in the case of a 4x4 table the variable names are:
           v_0_0  v_1_0  v_2_0  v_3_0
           v_0_1  v_1_1  v_2_1  v_3_1
           v_0_2  v_1_2  v_2_2  v_3_2
           v_0_3  v_1_3  v_2_3  v_3_3

The so called "password" is a function. The operands are
compartment variables and whole numbers. An example of the function
definition:

(v_1_1|v_2_3|v_3_3+5-v_0_1)|(v_1_2+v_3_1)-70

One of the main weaknesses of this authentication scheme is that
the position and movement of the eyes probably reveals, which of
the compartments within the table are used for calculating the
response. Some of the countermeasures to that weakness might be
inspired by poker champions.

The rest of the text downwards from here is just "raw" code.
Class RCauth1 usage example, i.e. sample code, can be found
at the end of this file.

=end



	@@b_formula_parser_initiated=false

	public
	def initialize width=4, height=4
		@width=width; @height=height;
	end

	def generate_challenge
		ht_challenge=Hash.new
		@height.times do |y|
			@width.times do |x|
				coords=''+x.to_s+'_'+y.to_s
				i=Kernel.rand(99)
				i=(-1)*i if 0.5<Kernel.rand(0)
				ht_challenge[coords]=i
			end
		end
		ht_challenge['width']=@width
		ht_challenge['height']=@height
		return ht_challenge
	end # generate_challenge

	# Retunrs an integer.
	def get_challenge_response ht_challenge, s_formulae

	end # get_challenge_response


	private


end # class RCauth1
#=========================================================================
rcauth=RCauth1.new
rcauth.generate_challenge


#-----------------------------------------------------------------------
