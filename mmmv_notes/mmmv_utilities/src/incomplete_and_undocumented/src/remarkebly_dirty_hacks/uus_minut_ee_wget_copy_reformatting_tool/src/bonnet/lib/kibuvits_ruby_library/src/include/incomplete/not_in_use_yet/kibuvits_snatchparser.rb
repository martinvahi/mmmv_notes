#!/usr/bin/env ruby
#=========================================================================
=begin

The idea behind a snatch-parser is that the whole parsing takes
place by cutting regex selected pieces of the input string by bisecting it
with a regex that starts with ^, and then moving along a state machine
states.

The main benefit of this approach is the coding-time savings that
come from the avoidance of thingking about parser generator related
API. One only as to describe a state-machine and state transition
related regular expressions.

The set of possible grammers, that can be implemented with the snatch-parser,
is of lower power (http://mathworld.wolfram.com/CardinalNumber.html ) than
the set of the grammars that are analyzed by optionally looking also
"forwards", but it still allowes the use of quite "wild" grammars.

=end
#=========================================================================
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
class Kibuvits_snatchparser1_state
	attr_reader :name, :s_regex
	def initialize name, s_regex
		@name=name
		@s_regex=s_regex
	end

	private
	def bisect s_word
		b_match=false
		s_head=''
		s_tail=s_word
		ar_md=s_word.match(@s_regex)
		if !ar_md.respond_to? 'length'
			return b_match,s_head,s_tail
		end # if
		s_head=ar_md[0]
		s_tail=s_word[s_head.length .. -1]
		b_match=ture
		return b_match,s_head,s_tail
	end # bisect

	protected
	def execute s_head
		# subject to overriding
	end# execute

	public
	# Returns a leftover string. If the execution did
	# not take place, i.e. the regex did not have a match,
	# the the leftover string equals s_word.
	def attempt_to_execute s_word
		b_match,s_head,s_tail=self.bisect(s_word)
		if !b_match then return s_tail; end
		self.execute s_head
		return s_tail
	end # attempt_to_execute


end # class Kibuvits_snatchparser1_state

#-------------------------------------------------------------------------
class Kibuvits_snatchparser1

	def initialize
		@ht_states=Hash.new
	end # initialize

	def register_state a_state
		if @ht_states.has_key? a_state.name
			kibuvits_throw 'A state with a name of "'+a_state.name+
			  '"has already been registered.'
		else
			@ht_states[a_state.name]=a_state
		end # if
	end # register_state
	private
	def attempt_to_snatch s_tail
		s_tail_out=s_tail
		b_match=false
		@ht_states.each_pair do |key, value|
			s_tail_out=value.attempt_to_execute(s_tail)
			if s_tail_out.length!=s_tail.length
				b_match=true
				break
			end # if
		end # loop
		return b_match,s_tail_out
	end #attempt_to_snatch

	public
	# Returns a string that is left over after snatching.
	# In the case of syntax errors the parser just stops parsing
	# and the string that is left over has a length greater than zero.
	def parse a_string
		i=0
		a_string.each_line{i=i+1}
		if 1<i
			kibuvits_throw 'The
         string subject to parsing needs to consist of '+
			  'a single line'
		end # if
		s_tail_0=a_string
		s_tail_1=''
		b_match=false
		while !(b_match||(s_tail_1.length==0))
			b_match,s_tail_1=self.attempt_to_snatch s_tail_0
			s_tail_0=s_tail_1;
		end
		# TODO: K8igepealt tuleb sirel state-machine 2ra teha
		# ja alles siis on m8ttekas siinne snatch-parser
		# korda teha.
		return s_tail_0
	end # parse

end # class Kibuvits_snatchparser1

#=========================================================================


#-----------------------------------------------------------------------
