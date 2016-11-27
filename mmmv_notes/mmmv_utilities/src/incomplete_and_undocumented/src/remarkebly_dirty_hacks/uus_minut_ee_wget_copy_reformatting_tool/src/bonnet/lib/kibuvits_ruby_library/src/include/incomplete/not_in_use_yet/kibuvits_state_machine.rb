#!/usr/bin/env ruby
#=========================================================================
=begin

 If the Kibuvits_state_machine is seen as a special type of container,
 then the only compulsory elements of it are states, which are
 instances that have a publicly readable state_name attribute.

 The Kibuvits_state_machine always contains a state called "zero",
 which has stub functions defined as its default state entry function
 and default state exit function. The state "zero" is considered part
 of every state cluster.

 The rest is explained by code examples that reside in this
 file, after the definition of the class Kibuvits_state_machine.

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

class Kibuvits_sate_machine_funcwrapper

	private
	def public_method_exists

	end # public_method_exists


	public

   # The reason, why one holds a reference to the instance
   # within the funcwrapper is to stay conservative within the
   # use of language features. The idea is that the most common syntax
   # and the most common features of the programming language get tested
   # better and are also changed less frequently, which entails that
   # by being conservative one lessens the probability of running
   # into language implementation bugs or needs to do language change
   # initiated refactoring.
   def initialize instance, s_public_method_name
	   thorow "Nil received." if instance==nil
	   @inst=instance
   end

   def func
   end
end # Kibuvits_sate_machine_funcwrapper

class Kibuvits_state_machine
   attr_reader :current_state, :state_machine_name
   def initialize state_machine_name
      @state_machine_name=state_machine_name
      @ht_states=Hash.new
      @ht_clusters=Hash.new
      @ht_state_default_entry_funcs=Hash.new
      @ht_state_default_exit_funcs=Hash.new
      @ht_state_transition_funcs=Hash.new
      @ht_cluster_default_entry_funcs=Hash.new
      @ht_cluster_default_exit_funcs=Hash.new
      @ht_cluster_transition_funcs=Hash.new
      @b_OK_2_perform_cluster_update=false
   end # initialize

   private
   def transition_htkey destinatin_name, orgigin_name
      s=orgigin_name+'_();_'+destinatin_name
      return s
   end # transition_htkey

   public
   def insert_state state_name, cluster_name=''
      @ht_states[state_name]=state_name
      @ht_clusters[cluster_name]=cluster_name if cluster_name!=''
   end # insert_state

   def insert_state_default_entry_func state_name, funcwrapper_instance
      kibuvits_throw 'func missing' if !funcwrapper_instance.respond_to? 'func'
      @ht_state_default_entry_funcs[state_name]=funcwrapper_instance
   end # insert_state_default_entry_func

   def insert_state_default_exit_func state_name, funcwrapper_instance
      kibuvits_throw 'func missing' if !funcwrapper_instance.respond_to? 'func'
      @ht_state_default_exit_funcs[state_name]=funcwrapper_instance
   end # insert_state_default_exit_func

   def insert_state_transition_func(destination_state_name,
      origin_state_name, funcwrapper_instance)
      kibuvits_throw 'func missing' if !funcwrapper_instance.respond_to? 'func'
      key=self.transition_htkey(destination_state_name,origin_state_name)
      if funcwrapper_instance.respond_to? 'register_state_machine'
         funcwrapper_instance.register_state_machine(self)
      end # if
      @ht_state_transition_funcs[key]=funcwrapper_instance
   end # insert_state_transition_func

   def insert_cluster_default_entry_func cluster_name, funcwrapper_instance
      kibuvits_throw 'func missing' if !funcwrapper_instance.respond_to? 'func'
      @ht_cluster_default_entry_funcs[cluster_name]=funcwrapper_instance
   end # insert_cluster_default_entry_func

   def insert_cluster_default_exit_func cluster_name, funcwrapper_instance
      kibuvits_throw 'func missing' if !funcwrapper_instance.respond_to? 'func'
      @ht_cluster_default_exit_funcs[cluster_name]=funcwrapper_instance
   end # insert_cluster_default_exit_func

   def insert_cluster_transition_func(destination_cluster_name,
      origin_cluster_name, funcwrapper_instance)
      kibuvits_throw 'func missing' if !funcwrapper_instance.respond_to? 'func'
      key=self.transition_htkey(destination_cluster_name,
      origin_cluster_name)
      @ht_cluster_transition_funcs[key]=funcwrapper_instance
   end # insert_cluster_transition_func
   #-----------------------------------
   # This mehtod is meant to be called only from within
   # a state transaction function.
   def exec_cluster_update
      kibuvits_throw 'Not authorized yet!' if !@b_OK_2_perform_cluster_update
   end # exec_cluster_update
   #-----------------------------------
   #-----------------------------------
   public
   def change_state_2 destination_state_name, origin_state_name
      synchronize
      key=self.transition_htkey(destination_state_name,origin_state_name)
      if @ht_state_transition_funcs.include? key
         funcwrapper=@ht_state_transition_funcs[key]
         funcwrapper.func()
      else
         if !@ht_state_default_exit_funcs.include? origin_state_name
            kibuvits_throw 'There\'s no transition function present '+
            'for a transition from state '+origin_state_name+' to state '+
            destination_state_name+'and there\'s no default exit '+
            'function for state '+origin_state_name+'.'
         end # if
         if !@ht_state_default_entry_funcs.include? destination_state_name
            kibuvits_throw 'There\'s no transition function '+
            'present for a transition from state '+origin_state_name+
            ' to state '+destination_state_name+'and there\'s no default '+
            'entry function for state '+destination_state_name+'.'
         end # if
         fncwr_exit=@ht_state_default_exit_funcs[origin_state_name]
         fncwr_exit.func()
         @b_OK_2_perform_cluster_update=true
         self.exec_cluster_update()
         @b_OK_2_perform_cluster_update=false
         fncwr_entry=@ht_state_default_entry_funcs[destination_state_name]
         fncwr_entry.func()
      end # if
   end #change_state_2


end # class Kibuvits_state_machine


#=========================================================================
# Usage example and test code (in one):

#-----------------------------------------------------------------------
class State_transition_function_wrapper  #optional

   attr_reader :destination_state_name, :origin_state_name

   def initialize destination_state_name, origin_state_name
      @destination_state_name=destination_state_name
      @origin_state_name=origin_state_name
   end # initialize

   def state_transition
   end # state_transition

end # class State_transition_function_wrapper
#-----------------------------------------------------------------------


#-----------------------------------------------------------------------
