#!/usr/bin/env ruby
#==========================================================================
=begin
 Initial author: Martin.Vahi@softf1.com

 Copyright 2021, martin.vahi@softf1.com that has an
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

 The following line is a spdx.org license label line:
 SPDX-License-Identifier: BSD-3-Clause-Clear

---------------------------------------------------------------------------

 Tested with ("ruby -v")

 ruby 3.1.2p20 (2022-04-12 revision 4491bb740a) [x86_64-linux]

 on ("uname -a")

 Linux terminal01 6.1.0-12-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.1.52-1 (2023-09-07) x86_64 GNU/Linux

=end
#==========================================================================
require 'pathname'

if !defined? KIBUVITS_krl171bt5_HOME
   s_fp_krl=nil
   s_fp_lib_histogram=nil
   ob_pth=Pathname.new(__FILE__).realpath.parent.parent
   s_fp_0=ob_pth.to_s
   s_fp_krl=s_fp_0+"/2024_01_27_mmmv_ruby_boilerplate_t6.rb"
   require s_fp_krl
end # if

#==========================================================================

class Kibuvits_krl171bt5_histogram_t1_tests

   def initialize()
   end # initialize

   #-----------------------------------------------------------------------

   def s_test_01_bucket_selection_correctness(b_mode=true)
      ob_histogram=nil
      if b_mode
         ob_histogram=Kibuvits_krl171bt5_histogram_t1.new(0,3,3)
      else
         ob_histogram=Kibuvits_krl171bt5_histogram_t1.new(-3,0,3)
      end # if
      #----------------------------------------
      s_out=$kibuvits_krl171bt5_lc_linebreak+
      "@i_number_of_numbered_buckets == "+
      ob_histogram.i_number_of_numbered_buckets.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      $kibuvits_krl171bt5_lc_linebreak+
      "@fd_bucket_0_lowest_bound == "+
      ob_histogram.fd_bucket_0_lowest_bound.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      "@fd_max_bucket_upper_bound == "+
      ob_histogram.fd_max_bucket_upper_bound.to_s+
      $kibuvits_krl171bt5_lc_linebreak
      #----------------------------------------
      n_of_datapoints=100
      n_of_datapoints.times do
         ob_histogram.count(0)
         ob_histogram.count(1)
         ob_histogram.count(2)
      end # loop
      #----------------------------------------
      s_out<<ob_histogram.to_s()
      return s_out
      #----------------------------------------
   end # s_test_01_bucket_selection_correctness

   #-----------------------------------------------------------------------

   def s_test_02_scaling()
      ob_histogram=Kibuvits_krl171bt5_histogram_t1.new(-9,10,11)
      #----------------------------------------
      i_rand_max=2000
      i_rand_max_plus_1=i_rand_max+1
      n_of_datapoints=100*ob_histogram.i_number_of_numbered_buckets
      fd_range_lenght=ob_histogram.fd_max_bucket_upper_bound-ob_histogram.fd_bucket_0_lowest_bound
      fd_k_normialization=(fd_range_lenght/i_rand_max)
      fd_k_artificial_scaling=5.0
      fd_negative_shift=(i_rand_max*fd_k_normialization*fd_k_artificial_scaling-fd_range_lenght)/2
      #----------------------------------------
      s_out=$kibuvits_krl171bt5_lc_linebreak+
      "@i_number_of_numbered_buckets == "+
      ob_histogram.i_number_of_numbered_buckets.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      $kibuvits_krl171bt5_lc_linebreak+
      " @fd_bucket_0_lowest_bound == "+
      ob_histogram.fd_bucket_0_lowest_bound.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      "@fd_max_bucket_upper_bound == "+
      ob_histogram.fd_max_bucket_upper_bound.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      $kibuvits_krl171bt5_lc_linebreak+
      "fd_range_lenght == "+
      fd_range_lenght.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      "fd_k_normialization == "+
      fd_k_normialization.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      "fd_k_artificial_scaling == "+
      fd_k_artificial_scaling.to_s+
      $kibuvits_krl171bt5_lc_linebreak+
      "fd_negative_shift == "+
      fd_negative_shift.to_s+
      $kibuvits_krl171bt5_lc_linebreak
      #----------------------------------------
      fd_generated=nil
      n_of_datapoints.times do
         fd_generated=(fd_k_normialization*rand(i_rand_max_plus_1)*fd_k_artificial_scaling-fd_negative_shift)
         ob_histogram.count(fd_generated)
      end # loop
      s_out<<ob_histogram.to_s()
      #----------------------------------------
      ar_columns=ob_histogram.ar_get_histogram_column_heights
      s_out<<("ar_columns == \n"+ar_columns.to_s)
      s_out<<$kibuvits_krl171bt5_lc_doublelinebreak
      return s_out
      #----------------------------------------
   end # s_test_02_scaling

   #-----------------------------------------------------------------------

   def run_all_tests()
      puts(s_test_01_bucket_selection_correctness(true))
      puts(s_test_01_bucket_selection_correctness(false))
      puts(s_test_02_scaling())
   end # run_all_tests()

end # class Kibuvits_krl171bt5_histogram_t1_tests

#==========================================================================

ob_tests=Kibuvits_krl171bt5_histogram_t1_tests.new
puts(ob_tests.run_all_tests())

#puts(ob_tests.s_test_01_bucket_selection_correctness(true))
#puts(ob_tests.s_test_01_bucket_selection_correctness(false))
#puts(ob_tests.s_test_02_scaling())

#==========================================================================
# S_VERSION_OF_THIS_FILE="e151d131-759d-44df-b26e-200240b118e7"
#==========================================================================
