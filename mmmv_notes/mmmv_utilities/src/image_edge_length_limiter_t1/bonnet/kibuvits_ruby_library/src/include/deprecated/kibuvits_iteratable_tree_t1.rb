#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright (c) 2009, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.
 All rights reserved.

 Redistribution and use in source and binary forms, with or
 without modification, are permitted provided that the following
 conditions are met:

 * Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer
   in the documentation and/or other materials provided with the
   distribution.
 * Neither the name of the Martin Vahi nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
 CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
 BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

=end
#==========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

#==========================================================================


# It allows one to assemble a tree structure and then to iterate
# recursively through it. The iteration can be done by calling
# method "next()" at the root node or by using a "each_node"
# iteration loop at the root node. In terms of design patterns,
# one can see it as a mixture of the "Composite Design Pattern"
# and the "Iterator Design Pattern".
#
# The Kibuvits_iterable_tree_t1_node is a special case.
# For general graphs thare are classes Kibuvits_graph_vertex
# and Kibuvits_graph_hyperedge.
class Kibuvits_iterable_tree_t1_node
   attr_accessor :data_record, :name, :root_node

   # the @next_node is used only in the root node instance
   attr_accessor :parent_node, :next_node, :children

   def initialize
      @root_node=self
      @next_node=self
      @parent_node=self
      @name="nameless"
      @children=Array.new
      @iteration_index=0
   end # initialize

   def add_child(a_child_node)
      a_child_node.parent_node=self
      a_child_node.root_node=@root_node
      @children << a_child_node
   end # add_child

   def each_node(&iteration_loop)
      reset_the_iteration_state
      yield @root_node.next_node
      x=@root_node.next
      while @root_node.next_node!=@root_node do
         yield @root_node.next_node
         x=@root_node.next
      end # loop
   end # each_node()

   # A Java iterator-style next(). If it is called on the root node,
   # it iterates through the entire tree recursively. It returns
   # a node instance.
   def next
      x=@root_node.next_node.next_from_node_instance
      @root_node.next_node=x
      return x
   end # next

   def reset_the_iteration_state
      while @root_node.next_node!=@root_node do
         @root_node.next
      end # loop
   end # reset_the_iteration_state

   protected
   def next_from_node_instance
      answer=""
      if (@children.length-1) < @iteration_index
         @iteration_index=0
         if @root_node==self
            answer=self
         else
            answer=@parent_node.next_from_node_instance
         end # if
      else
         answer=@children[@iteration_index]
         @iteration_index+=1
      end # if
      return answer
   end # next_from_node_instance()

end # class Kibuvits_iterable_tree_t1_node

#=========================================================================
# Sample code:

# def create_a_demo_tree
# 	a=Kibuvits_iterable_tree_t1_node.new
# 	b=Kibuvits_iterable_tree_t1_node.new
# 	c=Kibuvits_iterable_tree_t1_node.new
# 	d=Kibuvits_iterable_tree_t1_node.new
# 	e=Kibuvits_iterable_tree_t1_node.new
# 	a.add_child(b)
# 	a.add_child(d)
# 	b.add_child(c)
# 	b.add_child(e)
# 	a.name="A"
# 	b.name="B"
# 	c.name="C"
# 	d.name="D"
# 	e.name="E"
# 	return a
# end # create_a_demo_tree
#
# tree=create_a_demo_tree
# puts "\n\n--------- Node names by \"each_node\" loop: -----------\n"
# tree.each_node {|a_node| print a_node.name}
# puts "\n\n--------- Node names by a Java Iterator-like loop: -----------\n"
# 9.times { x=tree.next; print x.name }
# puts "\n\n-- Node names by Java Iterator-like loop after iteration reset: --\n"
# tree.reset_the_iteration_state
# 5.times { x=tree.next; print x.name }
# puts "\n\nThe end of story. Thanks for watching. :) \n\n"
#=========================================================================

