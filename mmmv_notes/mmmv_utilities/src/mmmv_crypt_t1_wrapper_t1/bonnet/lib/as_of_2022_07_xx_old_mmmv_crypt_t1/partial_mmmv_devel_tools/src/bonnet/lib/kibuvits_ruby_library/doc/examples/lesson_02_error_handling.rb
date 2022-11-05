#!/usr/bin/env ruby
=begin
 Copyright 2010, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/bsd-license.php
=end
#==========================================================================
#--- start of a distracting hack to keep this example working -------------
if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   require(ob_pth_0.parent.parent.parent.to_s+"/src/include/kibuvits_boot.rb")
end # if
require  KIBUVITS_HOME+"/src/include/kibuvits_all.rb"
#----------end of the distracting hack ------------------------------------
=begin

   The ideology of the KRL is that if the KRL code itself
   is broken or the API is misused, then the KRL will crash
   by throwing an error, but if inproper data originates from some
   "user input", then the KRL does not throw an exception,
   but places an error container into a KRL specific
   stack of error containers.

   The error container is an instance of the Kibuvits_msgc
   and the stack of error containers is an instance of
   the Kibuvits_msgc_stack.

=end

a_stack=Kibuvits_msgc_stack.new
3.times do |i|
   a_stack<<Kibuvits_msgc.new("Message container number "+i.to_s)
end # loop

a_stack.each{|msgc| puts msgc.to_s} if false

message_container_at_index_1=a_stack[1]
message_container_at_index_2=a_stack.last

message_container_at_index_2['English']="A new message."

a_stack.each{|msgc| puts msgc.to_s} if false

a_stack.last['English']="A shorter way to edit the last "+
"message container instance."

a_stack.each{|msgc| puts msgc.to_s} if false

=begin
   A naming convention in the KRL is that a variable
   that references an instance of the message container class,
   the Kibuvits_msgc, has the name of "msgc" and a variable
   that references an instance of the message container
   stack class, the Kibuvits_msgc_stack, has a name of "msgcs".
=end

msgcs=a_stack
msgc=msgcs.last

=begin
   The error containers support multiple languages, but
   the default language is English.
=end

msgc['Estonian']="\"Tere\" means \"Hi\" in Estonian."
msgc['Klingon']="buy' ngop" # from http://www.kli.org/tlh/phrases.html
msgc['AlienHollywoodian']="Brrrrrr-Uiii"

if false
   puts msgc['English']
   puts msgc['Estonian']
   puts msgc['Klingon']
   puts msgc['AlienHollywoodian']
   puts msgc.to_s # The default language is English
end # if

=begin
   If the container does not contain a message in a requested
   language, the message in the default language is returned.
=end
puts msgc['This_language_is_missing_from_this_container'] if false


=begin
    The Kibuvits_msgc instances have a public field named
    b_failure. By default it is set to true.  The Kibuvits_msgc_stack
    has a readonly field named b_failure and that is true
    if the b_failure field of at least one of its elements has
    the value of true.

    The idea is that if the b_failure==false, the message is 
    some debug output, for example, a warning.
=end

msgcs.clear # Empties the stack.
3.times do
   msgc=Kibuvits_msgc.new
   msgc.b_failure=false
   msgcs<<msgc
end # loop

if false
   puts "\nAs all of the message containers have their "+
   "b_failure flags down,\nthe b_failure flag of the stack "+
   "has the value of "+msgcs.b_failure.to_s+"\n\n"
   msgcs[0].b_failure=true
   puts "By seting the flag of just one of the elements up,\n"+
   "the msgcs.b_failure=="+msgcs.b_failure.to_s+"\n\n"
   msgcs[0].b_failure=false
   puts "By taking the flag of the element down again, the \n"+
   "the msgcs.b_failure=="+msgcs.b_failure.to_s+"\n\n"
end # if

=begin
   The reason, why there is such a flag system built into the
   Kibuvits_msgc and the Kibuvits_msgc_stack is that sometimes
   one wants to get some debugging messages and data from some
   quite deep location within the call stack without triggering
   any of the data mismatch monitoring routines, but,
   at the same time, it's beneficial to see the order of events,
   which is visible if the debug entries and error containers
   reside in a single set, the stack.

   The Kibuvits_msgc instances' writable field named "s_data" is
   meant for passing debug data upwards during debugging.
   The field, s_data, is a string field due to serailization
   requirement. The serialization of the Kibuvits_msgc_stack is
   necessary for assembling a common Kibuvits_msgc_stack instance
   from multiple threas in an environment, where some of the treads 
   run on computers other than the one, where the
   Kibuvits_msgc_stack instance is assembled.
=end

msgcs.clear

=begin
   For automated checking and test code each of the
   Kibuvits_msgc instances has also a field named s_message_id.

   A more succinct way of creating a Kibuvits_msgc instance
   and adding it to the Kibuvits_msgc_stack, is like that:
=end

msgcs.cre "Our Error message in a succinkt manner. ", "42" #"42" is the error code.
msgcs.cre "Succinktly added message # 2. ", "hello7"

msgcs.each{|msgc| puts msgc.to_s+" "+msgc.s_message_id} if false

=begin
   If a single instance of the Kibuvits_msgc_stack is used within
   the whole application, then all of the error messages are gathered
   to a single error message stack. There's no need to return the
   Kibuvits_msgc_stack  instance, because it goes down by reference,
   which in turn keeps the API a bit more succinct.
=end

def func1 a,b,msgcs
   c=a+b
   if c<0
      msgcs.cre "Data out of domain.","code1"
      c=0
   end # if
   return c
end # func1

def func2 a,msgcs
   if a<1 # It's intentionally faulty for demo purposes. It should be "a<=1".
      msgcs.cre "Misfortunate value. a=="+a.to_s,1, "code2"
      return 0
   end # if
   c=func1 a,-2,msgcs
   return 0 if msgcs.b_failure # The func2 input verification was faulty
   c=c+10
   return c
end # func2


if false
   msgcs=Kibuvits_msgc_stack.new
   func2 2,msgcs
   puts "Check # 1: "+msgcs.last.to_s if msgcs.b_failure

   msgcs.clear
   func2 0,msgcs
   puts "Check # 2: "+msgcs.last.to_s if msgcs.b_failure
   msgcs.clear # To remove the element that has the b_failure flag set.

   msgcs.clear
   func2 1,msgcs
   puts "Check # 3: "+msgcs.last.to_s if msgcs.b_failure
   msgcs.clear # To remove the element that has the b_failure flag set.
end # if
#==========================================================================
