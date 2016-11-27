#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2014, martin.vahi@softf1.com that has an
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
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"

#==========================================================================

# The "cg" in the name of the class Kibuvits_cg_html_t1
# stands for "code generation".
class Kibuvits_cg_html_t1

   def initialize
   end # initialize

   def s_place_2_table_t1(i_number_of_columns,ar_cell_content_html,
      s_table_tag_attributes=$kibuvits_lc_emptystring,
      s_cell_tag_attributes=$kibuvits_lc_emptystring)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, Fixnum, i_number_of_columns
         kibuvits_typecheck bn, Array, ar_cell_content_html
         kibuvits_typecheck bn, String, s_table_tag_attributes
         kibuvits_typecheck bn, String, s_cell_tag_attributes
         kibuvits_assert_is_smaller_than_or_equal_to(bn,
         1, i_number_of_columns,
         "\n GUID='3cedaa82-aada-4c1d-8995-b2e171211ed7'\n\n")
      end # if
      i_len=ar_cell_content_html.size
      ar_cells_0=nil
      i_0=i_len%i_number_of_columns
      i_1=nil
      i_n_of_cells=i_len+i_0
      i_n_of_rows=i_n_of_cells/i_number_of_columns # == Fixnum
      if i_0==0
         ar_cells_0=ar_cell_content_html
      else
         # A bit dirty due to the extra copying, but makes code simpler.
         # An alternative to the copying would be an if-clause in a loop.
         ar_cells_0=[]+ar_cell_content_html
         i_0.times{ar_cells_0<<$kibuvits_lc_emptystring}
      end # if
      #---------
      ar_s=Array.new
      ar_s<<"\n<table "+s_table_tag_attributes+" >"
      #---------
      s_lc_td_start=nil
      if 0<s_cell_tag_attributes.length
         s_lc_td_start=("<td "+s_cell_tag_attributes+" >").freeze
      else
         s_lc_td_start="<td>".freeze
      end # if
      s_lc_td_end="</td>".freeze
      s_lc_tr_start="\n    <tr>".freeze
      s_lc_tr_end="\n    </tr>".freeze
      #---------
      ix_elem=0
      i_n_of_rows.times do |i_row|
         ar_s<<s_lc_tr_start
         i_number_of_columns.times do |i_column|
            ar_s<<s_lc_td_start
            ar_s<<ar_cells_0[ix_elem]
            ar_s<<s_lc_td_end
            ix_elem=ix_elem+1
         end # loop
         ar_s<<s_lc_tr_end
      end # loop
      ar_s<<"\n</table>\n"
      s_out=kibuvits_s_concat_array_of_strings(ar_s)
   end # s_place_2_table_t1

   def Kibuvits_cg_html_t1.s_place_2_table_t1(i_number_of_columns,ar_cell_content_html,
      s_table_tag_attributes=$kibuvits_lc_emptystring,
      s_cell_tag_attributes=$kibuvits_lc_emptystring)
      s_out=Kibuvits_cg_html_t1.instance.s_place_2_table_t1(
      i_number_of_columns,ar_cell_content_html,
      s_table_tag_attributes,s_cell_tag_attributes)
      return s_out
   end # Kibuvits_cg_html_t1.s_place_2_table_t1

   include Singleton
end # class Kibuvits_cg_html_t1

#=========================================================================

