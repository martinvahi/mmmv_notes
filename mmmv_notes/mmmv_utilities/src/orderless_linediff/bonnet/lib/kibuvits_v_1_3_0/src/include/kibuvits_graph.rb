#!/usr/bin/env ruby 
#==========================================================================
=begin

 Copyright 2012, martin.vahi@softf1.com that has an
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
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_boot.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_GUID_generator.rb"
else
   require  "kibuvits_boot.rb"
   require  "kibuvits_GUID_generator.rb"
end # if

#==========================================================================

# A useful hint:
#
#     Hyperedges (http://urls.softf1.com/a1/krl/frag3/ )
#     can be implemented by using a vertex in place of
#     a hyperedge and furnishing all vertices with
#     a type parameter that distinguishes plain vertices
#     from hyperedge vertices.
#
# The current implementation uses only directed edges. The edge
# records are stored in vertices that connect to the arrow
# tail side of an edge.
#
class Kibuvits_graph_vertex
   # The specification, where hyperedges, edges in general,
   # were instances of a separate class, is considered unpractical to the
   # point of being flawed, because after the completion of vertex and
   # edge class that conform with that kind of a specification, it turned
   # out that the client code is far more complex than it
   # could be with the implementation that has the comment that
   # You are just reading.

   @@ar_lc_modes=[$kibuvits_lc_any, $kibuvits_lc_outbound, $kibuvits_lc_inbound]

   attr_reader :s_id

   # Data that is attached to this vertex.
   attr_reader :ht_vertex_records

   # key   --- outbound vertex ID
   # value --- a hashtable, Hash instance
   #
   # The current implementation uses only directed edges. The edge
   # records are stored in vertices that connect to the arrow
   # tail side of an edge.
   attr_reader :ht_edge_records

   # key   --- vertex ID
   # value --- vertex
   # An inbound vertex is a vertex that is connected to
   # the current vertex by a directed edge so that
   # the directed edge leaves the inbound vertex and
   # arrives to the current vertex.
   #
   # Due to consistency reasons the content of this
   # hashtable must not be modified by
   attr_reader :ht_inbound_vertices

   # key   --- vertex ID
   # value --- vertex
   # An outbound vertex is a vertex that is connected to
   # the current vertex by a directed edge so that
   # the directed edge leaves the current vertex and
   # arrives to the outbound vertex.
   #
   # The edge records of the outbound vertices are held
   # in the current vertex.
   attr_reader :ht_outbound_vertices


   # key   --- vertex ID
   # value --- vertex
   # It duplicates the conjunction of
   # the ht_inbound_vertices and the ht_outbound_vertices, but
   # its useful for efficiency.
   attr_reader :ht_all_vertices

   # The @s_connections_state_ID is a GUID that is
   # changed every time any vertices are added or removed
   # from the graph. It simplifies the code of graph-crawling spiders
   # that want to find out, wether any vertices have been added or removed
   # after the last time the spider visited the vertex.
   attr_reader :s_connections_state_ID

   #--------------------------------------------------------------------------

   def initialize b_threadsafe=true
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [FalseClass,TrueClass],b_threadsafe
      end # if
      @s_id=Kibuvits_GUID_generator.generate_GUID.freeze
      @ht_vertex_records=Hash.new
      @ht_edge_records=Hash.new
      @ht_inbound_vertices=Hash.new
      @ht_outbound_vertices=Hash.new
      @ht_all_vertices=Hash.new
      @s_connections_state_ID=Kibuvits_GUID_generator.generate_GUID
      @b_threadsafe=b_threadsafe
      @mx=nil
      @mx=Monitor.new if b_threadsafe
   end # initialize

   # s_mode is from the set {"any","inbound","outbound"}
   def connected?(ob_vertex,s_mode=$kibuvits_lc_any)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_vertex
         kibuvits_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # if
      b_out=false
      case s_mode
      when $kibuvits_lc_any
         b_out=@ht_all_vertices.has_key?(ob_vertex.s_id)
      when $kibuvits_lc_outbound
         b_out=@ht_outbound_vertices.has_key?(ob_vertex.s_id)
      when $kibuvits_lc_inbound
         b_out=@ht_inbound_vertices.has_key?(ob_vertex.s_id)
      else
         bn=binding()
         kibuvits_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # case s_mode
      return b_out
   end # connected

   # http://mathworld.wolfram.com/VertexDegree.html
   #
   # The current implementation returns 0, if the
   # vertex is connected only to itself.
   def i_degree(s_mode=$kibuvits_lc_any)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # if
      i_out=0
      case s_mode
      when $kibuvits_lc_any
         if @b_threadsafe
            @mx.synchronize do
               i_out=@ht_outbound_vertices.length+
               @ht_inbound_vertices.length
               i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
               i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
            end # block
         else
            i_out=@ht_outbound_vertices.length+
            @ht_inbound_vertices.length
            i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
            i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
         end # if
      when $kibuvits_lc_outbound
         if @b_threadsafe
            @mx.synchronize do
               i_out=@ht_outbound_vertices.length
               i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
            end # block
         else
            i_out=@ht_outbound_vertices.length
            i_out=i_out-1 if @ht_outbound_vertices.has_key? @s_id
         end # if
      when $kibuvits_lc_inbound
         if @b_threadsafe
            @mx.synchronize do
               i_out=@ht_inbound_vertices.length
               i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
            end # block
         else
            i_out=@ht_inbound_vertices.length
            i_out=i_out-1 if @ht_inbound_vertices.has_key? @s_id
         end # if
      else
         bn=binding()
         kibuvits_assert_is_among_values(bn,@@ar_lc_modes,s_mode)
      end # case s_mode
      return i_out
   end # i_degree

   #--------------------------------------------------------------------------

   private

   # It's "semi-lockless" in stead of "lockless", because
   # it conditionally calls the connect_.... of the ob_vertex
   # and the connect_.... uses the ob_vertex local mutex
   # according to the ob_vertex instantiation parameter, the b_threadsafe.
   def connect_outbound_vertex_semilockless(ob_vertex)
      s_vx_id=ob_vertex.s_id
      if @ht_outbound_vertices.has_key? s_vx_id
         kibuvits_throw("\n\nA vertex with an ID of "+@s_id+
         " already has an outbound\nvertex with   an ID of "+
         ob_vertex.s_id+"\n\n")
      end # if
      @ht_outbound_vertices[s_vx_id]=ob_vertex
      @ht_edge_records[s_vx_id]=Hash.new
      # There can be 2 directed edges between 2 vertices.
      if !@ht_all_vertices.has_key? s_vx_id
         @ht_all_vertices[s_vx_id]=ob_vertex
      end # if
      if !ob_vertex.ht_inbound_vertices.has_key? @s_id
         ob_vertex.connect_inbound_vertex(self)
      end # if
      @s_connections_state_ID=Kibuvits_GUID_generator.generate_GUID
   end # connect_outbound_vertex_semilockless

   # Comment resides next to the connect_outbound_vertex_semilockless(...).
   def connect_inbound_vertex_semilockless(ob_vertex)
      s_vx_id=ob_vertex.s_id
      if @ht_inbound_vertices.has_key? s_vx_id
         kibuvits_throw("\n\nA vertex with an ID of "+@s_id+
         " already has an inbound\nvertex with   an ID of "+
         ob_vertex.s_id+"\n\n")
      end # if
      @ht_inbound_vertices[s_vx_id]=ob_vertex
      # There can be 2 directed edges between 2 vertices.
      if !@ht_all_vertices.has_key? s_vx_id
         @ht_all_vertices[s_vx_id]=ob_vertex
      end # if
      if !ob_vertex.ht_outbound_vertices.has_key? @s_id
         ob_vertex.connect_outbound_vertex(self)
      end # if
      @s_connections_state_ID=Kibuvits_GUID_generator.generate_GUID
   end # connect_inbound_vertex_semilockless

   #--------------------------------------------------------------------------

   public

   # It's OK for a vertex to be connected to itself, however,
   # this method will throw on an attempt to add the same directed
   # edge more than once.
   def connect_outbound_vertex(ob_vertex)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_vertex
      end # if KIBUVITS_b_DEBUG
      if @b_threadsafe
         @mx.synchronize do
            connect_outbound_vertex_semilockless(ob_vertex)
         end # block
      else
         connect_outbound_vertex_semilockless(ob_vertex)
      end # if
   end # connect_outbound_vertex

   # It's OK for a vertex to be connected to itself, however,
   # this method will throw on an attempt to add the same directed
   # edge more than once.
   def connect_inbound_vertex(ob_vertex)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_vertex
      end # if KIBUVITS_b_DEBUG
      if @b_threadsafe
         @mx.synchronize do
            connect_inbound_vertex_semilockless(ob_vertex)
         end # block
      else
         connect_inbound_vertex_semilockless(ob_vertex)
      end # if
   end # connect_inbound_vertex

   #--------------------------------------------------------------------------

   private

   # Comment resides next to the connect_outbound_vertex_semilockless(...).
   def disconnect_vertex_semilockless(ob_vertex)
      s_vx_id=ob_vertex.s_id
      if @ht_inbound_vertices.has_key? s_vx_id
         @ht_inbound_vertices.delete(s_vx_id)
      end # if
      if @ht_outbound_vertices.has_key? s_vx_id
         @ht_outbound_vertices.delete(s_vx_id)
         @ht_edge_records.delete(s_vx_id)
      end # if
      if @ht_all_vertices.has_key? s_vx_id
         @ht_all_vertices.delete(s_vx_id)
      end # if
      if ob_vertex.ht_all_vertices.has_key? @s_id
         ob_vertex.disconnect_vertex(self)
      end # if
   end # disconnect_vertex_semilockless

   def disconnect_all_vertices_semilockless
      ar=@ht_all_vertices.values
      ar.each do |ob_vertex|
         ob_vertex.disconnect_vertex(self)
      end # loop
   end # disconnect_all_vertices_semilockless

   public

   def disconnect_vertex(ob_vertex)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Kibuvits_graph_vertex, ob_vertex
      end # if KIBUVITS_b_DEBUG
      if @b_threadsafe
         @mx.synchronize do
            disconnect_vertex_semilockless(ob_vertex)
         end # block
      else
         disconnect_vertex_semilockless(ob_vertex)
      end # if
   end # disconnect_vertex


   def disconnect_all_vertices
      if @b_threadsafe
         @mx.synchronize do
            disconnect_all_vertices_semilockless()
         end # block
      else
         disconnect_all_vertices_semilockless()
      end # if
   end # disconnect_all_vertices

   #--------------------------------------------------------------------------

end # class Kibuvits_graph_vertex

#==========================================================================
