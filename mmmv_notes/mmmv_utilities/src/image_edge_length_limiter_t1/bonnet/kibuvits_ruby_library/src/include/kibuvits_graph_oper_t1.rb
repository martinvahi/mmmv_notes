#!/usr/bin/env ruby
#==========================================================================
=begin

 Copyright 2011, martin.vahi@softf1.com that has an
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
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_htoper.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_graph.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_IDstamp_registry_t1.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_arraycursor_t1.rb"

#==========================================================================
# A base class for graph navigation agents.
# http://urls.softf1.com/a1/krl/frag5/
#
# A general idea is that each spider reads and writes its own, crawling-session specific
# and instance specific, "silk-trace" records to graph vertices.
class Kibuvits_spider_t1

   # The @s_crawling_session_ID is for distinguishing different crawling journies that
   # start from the same @ob_vx_start_location.
   # It's updated/changed within the reset method. The reason, why the @s_crawling_session_ID
   # is of type string in stead of a Fixnum is that that way it's easy to
   # generate non-colliding values to it, which in turn allowes a graph
   # to be crawled simultaniously by multiple, independent, spiders.
   attr_reader :ob_vx_location, :ob_vx_start_location, :s_crawling_session_ID

   attr_reader :s_id # a spider ID

   # If the i_trajectory_maximum_recording_length==(-1), then
   # the length of the queue of visited vertex ids
   # is not artificially limited. If the
   # (-1) < i_trajectory_maximum_recording_length, then
   # the i_trajectory_maximum_recording_length must be greater than
   # zero, because at least some a backtracking implementations depend on a
   # fact that the the recorded trajectory has a maximum lenght of at least 1.
   #
   # If the i_visited_vertex_cache_maximum_size==(-1), then
   # the size of the visited vertex cahce is not limited.
   # If the i_visited_vertex_cache_maximum_size==0,
   # then the visited vertices are not placed to the cache.
   #
   def initialize(msgcs, i_trajectory_maximum_recording_length=1,
      i_visited_vertex_cache_maximum_size=(-1))
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
         kibuvits_typecheck bn, Fixnum, i_trajectory_maximum_recording_length
         kibuvits_typecheck bn, Fixnum, i_visited_vertex_cache_maximum_size
         if i_trajectory_maximum_recording_length<(-1)
            kibuvits_throw("\ni_trajectory_maximum_recording_length=="+
            i_trajectory_maximum_recording_length.to_s+" < (-1) \n",bn)
         else
            if i_trajectory_maximum_recording_length==0
               kibuvits_throw("\ni_trajectory_maximum_recording_length=="+
               i_trajectory_maximum_recording_length.to_s+" \n",bn)
            end # if
         end # if
         if i_visited_vertex_cache_maximum_size<(-1)
            kibuvits_throw("\ni_visited_vertex_cache_maximum_size=="+
            i_visited_vertex_cache_maximum_size.to_s+" < (-1) \n",bn)
         end # if
      end # if KIBUVITS_b_DEBUG
      @i_trajectory_maximum_recording_length=i_trajectory_maximum_recording_length
      @ar_trajectory=Array.new
      # key   --- vetex ID
      # value --- vetex
      @ht_trajectory_vx=Hash.new
      # key   --- vetex ID
      # value --- number of vertices that have the given ID and
      #           that are part of the trajctory.
      @ht_trajectory_count=Hash.new

      # key   --- vetex ID
      # value --- vetex
      @ht_visited_vertex_cache=Hash.new
      @ar_visited_vertex_cache=Array.new # a queue of vertex ID-s
      @i_visited_vertex_cache_maximum_size=i_visited_vertex_cache_maximum_size

      # It's the vertex, where the spider currently resides.
      @ob_vx_location=nil
      @ob_vx_start_location=nil

      @mx=Monitor.new

      @s_id=Kibuvits_GUID_generator.generate_GUID.gsub(
      $kibuvits_lc_minus,$kibuvits_lc_underscore).freeze
      @s_spiderspecific_varname_prefix=("Kibuvits_spider_t1_instance_"+
      @s_id+$kibuvits_lc_underscore).freeze
      @ob_IDregistry=Kibuvits_IDstamp_registry_t1.new(@s_spiderspecific_varname_prefix)

      @instance_lc_s_crawling_session_ID=(@s_spiderspecific_varname_prefix+
      "s_crawling_session_ID").freeze
      @s_crawling_session_ID=@ob_IDregistry.s_get(
      @instance_lc_s_crawling_session_ID)

      # Each spiders might arrive to a vertex after the value of the
      # Kibuvits_graph_vertex.s_connections_state_ID has changed.
      @instance_lc_s_vx_connections_state_ID=(@s_spiderspecific_varname_prefix+
      "s_vx_connections_state_ID").freeze
   end # initialize

   protected

   # It's a hook that is meant to be optionally overridden.
   # It's called from the reset().
   def implementation_specific_reset
   end # implementation_specific_reset

   # It's a hook that is called from the method crawl(...),
   # and that's also, where its output details reside.
   #
   # It must return 2 values at once:
   # ob_vertex_where_the_spider_must_jump_during_this_iteration, b_pause_crawling
   #
   # If the iteration does not change the location, then the value of the
   # ob_vertex_where_the_spider_must_jump_during_this_iteration must equal with the
   # value of the @ob_vx_location and the b_pause_crawling must equal with true.
   #
   # Crawling does not necessarily have to involve searching.
   # Search result store is expected to be implemented within
   # the class that is derived from the Kibuvits_spider_t1.
   #
   def choose_next_vertex_and_determine_whether_to_pause()
      # Hint 2: http://urls.softf1.com/a1/krl/frag3/
      kibuvits_throw("This method is expected to be overridden.")
   end # choose_next_vertex_and_determine_whether_to_pause

   public

   # The spider will have the location of ob_start_location_vertex.
   # All caches are emptied.
   def reset(ob_start_location_vertex)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_start_location_vertex
      end # if KIBUVITS_b_DEBUG
      @mx.synchronize do
         implementation_specific_reset()
         @ht_visited_vertex_cache.clear
         @ar_visited_vertex_cache.clear
         @ar_trajectory.clear
         @ht_trajectory_vx.clear
         @ht_trajectory_count.clear
         @ob_vx_location=ob_start_location_vertex
         @ob_vx_start_location=ob_start_location_vertex

         @ob_IDregistry.reset(@instance_lc_s_crawling_session_ID)
         @s_crawling_session_ID=@ob_IDregistry.s_get(
         @instance_lc_s_crawling_session_ID)
      end # block
   end # reset

   # Returns nil, if the location is not set.
   def x_location_vertex
      return @ob_vx_location
   end # x_location_vertex

   private

   # The main difference between the trajectory and a plain
   # visited vertex cache is that a trajectory can contain
   # a single vertex multiple times, but the visited vertex cache
   # contains each vertex at most once.
   def update_cahe_and_trajectory(ob_vx_new_location)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_vx_new_location
      end # if KIBUVITS_b_DEBUG
      s_vx_id=ob_vx_new_location.s_id
      return if s_vx_id==@ob_vx_location.s_id
      if !@ht_visited_vertex_cache.has_key? s_vx_id
         if @i_visited_vertex_cache_maximum_size==(-1)
            @ht_visited_vertex_cache[s_vx_id]=ob_vx_new_location
            @ar_visited_vertex_cache<<ob_vx_new_location
         else
            if 0<@i_visited_vertex_cache_maximum_size
               if @ar_visited_vertex_cache.size==@i_visited_vertex_cache_maximum_size
                  ob_vx=@ar_visited_vertex_cache[0]
                  @ar_visited_vertex_cache.delete_at(0)
                  s_ob_vx_id=ob_vx.s_id
                  @ht_visited_vertex_cache.delete(s_ob_vx_id)
               end # if
               @ht_visited_vertex_cache[s_vx_id]=ob_vx_new_location
               @ar_visited_vertex_cache<<ob_vx_new_location
            else # @i_visited_vertex_cache_maximum_size==0
               # No caching.
            end # if
         end # if
      end # if

      if @i_trajectory_maximum_recording_length==(-1)
         @ar_trajectory<<ob_vx_new_location
         if !@ht_trajectory_vx.has_key? s_vx_id
            @ht_trajectory_vx[s_vx_id]=ob_vx_new_location
            @ht_trajectory_count[s_vx_id]=1
         else
            i_0=@ht_trajectory_count[s_vx_id]
            @ht_trajectory_count[s_vx_id]=i_0+1
         end # if
      else
         if 0<@i_trajectory_maximum_recording_length
            if @ar_trajectory.size==@i_trajectory_maximum_recording_length
               ob_old_vx=@ar_trajectory[0]
               @ar_trajectory.delete_at(0)
               s_ob_old_vx_id=ob_old_vx.s_id
               i_0=@ht_trajectory_count[s_ob_old_vx_id]
               i_0=i_0-1
               @ht_trajectory_count[s_ob_old_vx_id]=i_0
               if i_0==0
                  if s_ob_old_vx_id!=s_vx_id
                     @ht_trajectory_count.delete(s_ob_old_vx_id)
                     @ht_trajectory_vx.delete(s_ob_old_vx_id)
                  end # if
               end # if
            end # if
            @ar_trajectory<<ob_vx_new_location
            if @ht_trajectory_vx.has_key? s_vx_id
               i_0=@ht_trajectory_count[s_vx_id]
               i_0=i_0+1
            else
               @ht_trajectory_vx[s_vx_id]=ob_vx_new_location
               i_0=1
            end # if
            @ht_trajectory_count[s_vx_id]=i_0
         else # @i_trajectory_maximum_recording_length==0
            # Backtracking mechanisms need the trajectory max length to
            # be at least 1.
            kibuvits_throw("\n\n@i_trajectory_maximum_recording_length==0\n"+
            "GUID='ef63f74f-7fc4-41cd-b104-80a06041bcd7'\n\n")
         end # if
      end # if
   end # update_cahe_and_trajectory

   public

   # It will throw, if the location of the spider is not set.
   # The location of the spider can be set by using the
   # method reset(...).
   #
   # Spider implementations must oberride the method
   # choose_next_vertex_and_determine_whether_to_pause().
   #
   # Crawling is an activity, where spiders move from
   # vertex to vertex and read-write their own, spiderspecific and
   # crawling-session-specific or even crawling algorithm specific
   # records into vertices. It can be viewed as if the spiders
   # were leaving their own, personal, crawling-session specific,
   # siltk-trace behind and they take crawling decisions according
   # to the slik-traces that they find. The current implementation
   # does not erase the silktrace.
   def crawl
      if @ob_vx_location==nil
         kibuvits_throw("\n\nThe location of the spider has not bee set.\n"+
         "The location can be set by using the method reset(...)\n\n")
      end # if
      b_pause_crawling=false
      ob_next_vertex=nil
      @mx.synchronize do
         while !b_pause_crawling
            ob_vx_new_location, b_pause_crawling=choose_next_vertex_and_determine_whether_to_pause()
            if KIBUVITS_b_DEBUG
               # This verification block is here due to the fact that
               # the choose_next_vertex_and_determine_whether_to_pause() is overridden.
               bn=binding()
               kibuvits_typecheck bn, [TrueClass,FalseClass], b_pause_crawling
               kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_vx_new_location
            end # if KIBUVITS_b_DEBUG
            update_cahe_and_trajectory(ob_vx_new_location)
         end # loop
      end # block
   end # crawl

end # Kibuvits_spider_t1

#--------------------------------------------------------------------------

=begin
class Kibuvits_graph_crawler_depthfirst_t1 < Kibuvits_spider_t1

   # The constructor arguments match with the base class
   # constructor arguments.
   def initialize(msgcs,i_trajectory_maximum_recording_length=1,
      i_visited_vertex_cache_maximum_size=(-1))
      super(msgcs,i_trajectory_maximum_recording_length,
      i_visited_vertex_cache_maximum_size)
      @instance_lc_ob_cursor=(@s_spiderspecific_varname_prefix+
      "cursor").freeze
      @instance_lc_vx_first_entry=(@s_spiderspecific_varname_prefix+
      "first_entry").freeze
   end # initialize

   # Return a boolean value.
   #
   # Pausing does not cause the Kibuvits_spider_t1 instance to be reset.
   def b_pause_crawling(ob_vx_new_location)
      # It's optionally overridden, but the default
      # implementation stops after all of the appropreate
      # edges have been searched.
      b_out=false
      b_out=true if ob_vx_new_location.s_id==@ob_vx_location.s_id
      return b_out
   end #b_pause_crawling

   #-----------------------------------------------------------------------
   private

   def set_vx_ar_cursor_2_zero(ht_vx_records)
      if ht_vx_records.has_key? @instance_lc_ob_cursor
         ob_cursor=ht_vx_records[@instance_lc_ob_cursor]
      else
         ob_cursor=Kibuvits_arraycursor_t1.new
         ht_vx_records[@instance_lc_ob_cursor]=ob_cursor
      end # if
      ar_core=ob_cursor.ar_core
      ob_cursor.reset(ar_core)
   end # set_vx_ar_cursor_2_zero

   def init_vx_records_if_not_inited(ob_vx)
      ht_vx_records=ob_vx.ht_vertex_records
      return if ht_vx_records.has_key? @instance_lc_s_crawling_session_ID
      @ob_IDregistry.b_xor_registry2wild(ht_vx_records,
      @instance_lc_s_crawling_session_ID)
      @ob_IDregistry.b_xor_wild2registry(ht_vx_records,
      @instance_lc_s_vx_connections_state_ID)
      if !ht_vx_records.has_key? @instance_lc_vx_first_entry
         ht_vx_records[@instance_lc_vx_first_entry]=ob_vx
      end # if
      ob_cursor=nil
      if ht_vx_records.has_key? @instance_lc_ob_cursor
         ob_cursor=ht_vx_records[@instance_lc_ob_cursor]
         ob_cursor.clear
      else
         ob_cursor=Kibuvits_arraycursor_t1.new
         ht_vx_records[@instance_lc_ob_cursor]=ob_cursor
      end # if
      ar_cursor_core=ob_vx.ht_all_vertices.values
      ob_cursor.reset(ar_cursor_core)
   end # init_vx_records_if_not_inited

   def choose_next_vertex
      ob_vx_new_location=@ob_vx_location # stay at the old place
      ht_vx_records=@ob_vx_location.ht_vertex_records
      init_vx_records_if_not_inited(@ob_vx_location) # For the start location.
      return ob_vx_new_location if ob_vx.i_degree()==0

      if @ob_IDregistry.reset(@instance_lc_s_crawling_session_ID)
         # POOLELI
      end # if
      return ob_vx_new_location
   end # choose_next_vertex

   #-----------------------------------------------------------------------
   protected

   def choose_next_vertex_and_determine_whether_to_pause
      #@instance_lc_s_crawling_session_ID
      #@instance_lc_s_vx_connections_state_ID
      ob_vx_new_location=choose_next_vertex()
      b_pause_crawling_var=b_pause_crawling(ob_vx_new_location)
      if KIBUVITS_b_DEBUG
         # This verification block is here due to the fact that
         # the b_pause_crawling() is overridden.
         bn=binding()
         kibuvits_typecheck bn, [TrueClass,FalseClass],b_pause_crawling_var
      end # if KIBUVITS_b_DEBUG
      return ob_vx_new_location, b_pause_crawling_var
   end # choose_next_vertex_and_determine_whether_to_pause

end # class Kibuvits_graph_crawler_depthfirst_t1
=end

#--------------------------------------------------------------------------

# The acronym "oper" stands for "operations".
class Kibuvits_graph_oper_t1

   def initialize
   end # initialize

   #-----------------------------------------------------------------------

   # Creates a vertex, connects the new vertex to the ob_parent_vertex so
   # that the new vertex is an outbound vertex for the ob_parent_vertex.
   #
   # It's the operation that is used for counting the number of edges
   # in a tree of N nodes, i.e.
   #     http://urls.softf1.com/a1/krl/frag1/
   #
   # Returns the new leaf.
   def add_outbound_leaf_t1(ob_parent_vertex,b_thradsafe_leaf=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex,ob_parent_vertex
         kibuvits_typecheck bn, [TrueClass,FalseClass],b_thradsafe_leaf
      end # if KIBUVITS_b_DEBUG
      vx_leaf=Kibuvits_graph_vertex.new(b_thradsafe_leaf)
      ob_parent_vertex.connect_outbound_vertex(vx_leaf)
      return vx_leaf
   end # add_outbound_leaf_t1

   def Kibuvits_graph_oper_t1.add_outbound_leaf_t1(ob_parent_vertex,
      b_thradsafe_leaf=true)
      vx_leaf=Kibuvits_graph_oper_t1.instance.add_outbound_leaf_t1(
      ob_parent_vertex, b_thradsafe_leaf)
      return vx_leaf
   end # Kibuvits_graph_oper_t1.add_outbound_leaf_t1

   # Creates a vertex, connects the new vertex to the ob_parent_vertex so
   # that the new vertex is an inbound vertex for the ob_parent_vertex.
   #
   # It's the operation that is used for counting the number of edges
   # in a tree of N nodes, i.e.
   #     http://urls.softf1.com/a1/krl/frag1/
   #
   # Returns the new leaf.
   def add_inbound_leaf_t1(ob_parent_vertex,b_thradsafe_leaf=true)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex,ob_parent_vertex
         kibuvits_typecheck bn, [TrueClass,FalseClass],b_thradsafe_leaf
      end # if KIBUVITS_b_DEBUG
      vx_leaf=Kibuvits_graph_vertex.new(b_thradsafe_leaf)
      ob_parent_vertex.connect_inbound_vertex(vx_leaf)
      return vx_leaf
   end # add_inbound_leaf_t1

   def Kibuvits_graph_oper_t1.add_inbound_leaf_t1(ob_parent_vertex,
      b_thradsafe_leaf=true)
      vx_leaf=Kibuvits_graph_oper_t1.instance.add_inbound_leaf_t1(
      ob_parent_vertex, b_thradsafe_leaf)
      return vx_leaf
   end # Kibuvits_graph_oper_t1.add_inbound_leaf_t1

   #-----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_graph_oper_t1

#==========================================================================

