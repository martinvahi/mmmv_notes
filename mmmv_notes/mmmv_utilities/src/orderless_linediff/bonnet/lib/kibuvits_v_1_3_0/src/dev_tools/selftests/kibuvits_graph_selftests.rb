#!/opt/ruby/bin/ruby -Ku
#=========================================================================
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
#=========================================================================
if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_graph.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_graph_oper_t1.rb"
else
   require  "kibuvits_graph.rb"
   require  "kibuvits_graph_oper_t1.rb"
end # if
require "singleton"
#==========================================================================


class Kibuvits_graph_selftests

   def initialize
   end #initialize

   #--------------------------------------------------------------------------
   private

   def Kibuvits_graph_selftests.test_1
      vx_1=Kibuvits_graph_vertex.new
      vx_2=Kibuvits_graph_vertex.new
      vx_3=Kibuvits_graph_vertex.new
      #-----------
      kibuvits_throw "test 1" if vx_1.i_degree!=0
      kibuvits_throw "test 2" if vx_2.i_degree!=0
      vx_1.connect_inbound_vertex(vx_2)
      vx_1.connect_outbound_vertex(vx_2)
      kibuvits_throw "test 3" if vx_1.i_degree!=2
      kibuvits_throw "test 4" if vx_2.i_degree!=2
      vx_1.disconnect_all_vertices
      kibuvits_throw "test 5" if vx_1.i_degree!=0
      kibuvits_throw "test 6" if vx_2.i_degree!=0
      #-----------
      vx_4=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_1)
      kibuvits_throw "test 7" if vx_1.i_degree!=1
      kibuvits_throw "test 8" if vx_4.i_degree!=1
      vx_5=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_1)
      kibuvits_throw "test 9" if vx_1.i_degree!=2
      vx_6=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_1)
      kibuvits_throw "test 10" if vx_1.i_degree!=3
      kibuvits_throw "test 11" if vx_4.i_degree!=1
      kibuvits_throw "test 12" if vx_5.i_degree!=1
      kibuvits_throw "test 13" if vx_6.i_degree!=1
      #-----------
      vx_7=Kibuvits_graph_oper_t1.add_inbound_leaf_t1(vx_1)
      kibuvits_throw "test 14" if vx_1.i_degree!=4
      kibuvits_throw "test 15" if vx_7.i_degree!=1
      vx_8=Kibuvits_graph_oper_t1.add_inbound_leaf_t1(vx_1)
      kibuvits_throw "test 16" if vx_1.i_degree!=5
      vx_9=Kibuvits_graph_oper_t1.add_inbound_leaf_t1(vx_1)
      kibuvits_throw "test 17" if vx_1.i_degree!=6
      kibuvits_throw "test 18" if vx_7.i_degree!=1
      kibuvits_throw "test 19" if vx_8.i_degree!=1
      kibuvits_throw "test 20" if vx_9.i_degree!=1
   end # Kibuvits_graph_selftests.test_1

   #--------------------------------------------------------------------------

   def Kibuvits_graph_selftests.test_Kibuvits_graph_vertex_operators
      vx_1=Kibuvits_graph_vertex.new
   end # Kibuvits_graph_selftests.test_Kibuvits_graph_vertex_operators

   #--------------------------------------------------------------------------

   # http://urls.softf1.com/a1/krl/frag6/
   def Kibuvits_graph_selftests.assemble_testgraph_t1
      vx_A=Kibuvits_graph_vertex.new
      #  A --- B,C,D
      #  B --- E,F
      #  C --- G,H
      vx_B=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_A)
      vx_C=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_A)
      vx_D=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_A)

      vx_E=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_B)
      vx_F=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_B)

      vx_G=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_C)
      vx_H=Kibuvits_graph_oper_t1.add_outbound_leaf_t1(vx_C)

      vx_A.ht_vertex_records[$kibuvits_lc_name]="AA"
      vx_B.ht_vertex_records[$kibuvits_lc_name]="BB"
      vx_C.ht_vertex_records[$kibuvits_lc_name]="CC"
      vx_D.ht_vertex_records[$kibuvits_lc_name]="DD"
      vx_E.ht_vertex_records[$kibuvits_lc_name]="EE"
      vx_F.ht_vertex_records[$kibuvits_lc_name]="FF"
      vx_G.ht_vertex_records[$kibuvits_lc_name]="GG"
      vx_H.ht_vertex_records[$kibuvits_lc_name]="HH"
      return vx_A,vx_F
   end # Kibuvits_graph_selftests.assemble_testgraph_t1

   public
=begin
   def Kibuvits_graph_selftests.test_spiders_1
      msgcs=Kibuvits_msgc_stack.new
      vx_A,vx_F=Kibuvits_graph_selftests.assemble_testgraph_t1()

      spider=Kibuvits_graph_crawler_depthfirst_t1.new(msgcs)
      def spider.b_pause_crawling(ob_vx_new_location)
         b_out=false
         b_out=true if ob_vx_new_location.s_id==@ob_vx_location.s_id
         return b_out
      end # spider.b_pause_crawling
      spider.reset(vx_F)
      spider.crawl()
      spider.reset(vx_A)
      spider.crawl()
   end # Kibuvits_graph_selftests.test_spiders_1
# POOLELI
=end

   #--------------------------------------------------------------------------
   public
   include Singleton

   def Kibuvits_graph_selftests.selftest
      ar_msgs=Array.new
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_graph_selftests.test_1"
      kibuvits_testeval bn, "Kibuvits_graph_selftests.test_Kibuvits_graph_vertex_operators"
      #kibuvits_testeval bn, "Kibuvits_graph_selftests.test_spiders_1"
      return ar_msgs
   end # Kibuvits_graph_selftests.selftest

end # class Kibuvits_graph_selftests

#=========================================================================
#Kibuvits_graph_selftests.selftest
#puts Kibuvits_graph_selftests.test_spiders_1.to_s

