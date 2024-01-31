#!/usr/bin/env ruby
#==========================================================================
=begin
 Initial author of this file: Martin.Vahi@softf1.com
 This file is in public domain.

 The following line is a spdx.org license label line:
 SPDX-License-Identifier: BSD-3-Clause-Clear
=end
#==========================================================================
require 'pathname'
ob_pth=Pathname.new(__FILE__).realpath.parent
s_fp_dir=ob_pth.to_s
require(s_fp_dir+
"/lib/2023_02_26_mmmv_ruby_boilerplate_t5/2023_02_26_mmmv_ruby_boilerplate_t5.rb")
require(s_fp_dir+"/lib/Mmmv_histogram_t1.rb")
S_FP_FILE_SIZES_RB=s_fp_dir+"/sizes_in_bytes.rb"
ob_pth=nil;

#--------------------------------------------------------------------------

class Application_main
   #-----------------------------------------------------------------------

   def initialize
   end # initialize

   #-----------------------------------------------------------------------
   private

   def display_plot(ht_x2y)
      Gnuplot.open do |gp|
         Gnuplot::Plot.new( gp ) do |plot|

            plot.title  "wget'iga loodud kodulehekoopia failisuuruste jaotus"
            plot.xlabel "sagedus"
            plot.ylabel "failisuurus"

            ar_x=ht_x2y.keys
            ar_y=Array.new
            i_len=ar_x.size
            i_len.times do |ix|
               ar_y<<ht_x2y[ar_x[ix]]
            end # loop

            plot.data << Gnuplot::DataSet.new( [ar_x, ar_y] ) do |ds|
               ds.with = "linespoints"
               ds.notitle
            end
         end
      end
   end # display_plot

   #--------------------------------------------------------------------------

   def exc_verify_histogram_data_format_t1(ht_x_y_histogram_data)
      bn=binding()
      kibuvits_krl171bt4_typecheck bn, Hash, ht_x_y_histogram_data
      #--------
      ar_keys=ht_x_y_histogram_data.keys
      kibuvits_krl171bt4_assert_ar_elements_typecheck_if_is_array(bn,
      [Integer,Fixnum,Bignum],ar_keys,
      "GUID='4f085c49-ccbc-4bfa-815a-511151a018e7'")
      ar_keys.each do |x_i_candidate|
         kibuvits_krl171bt4_assert_is_smaller_than_or_equal_to(bn,
         0,x_i_candidate,
         "GUID='b1d27ca8-1958-4165-9c5a-511151a018e7'")
      end # loop
      #--------
      ar_values=ht_x_y_histogram_data.values
      kibuvits_krl171bt4_assert_ar_elements_typecheck_if_is_array(bn,
      [Integer,Fixnum,Bignum,Rational,Float],ar_values,
      "GUID='363d3045-2b44-4e3b-815a-511151a018e7'")
      ar_values.each do |x_i_or_fd_candidate|
         kibuvits_krl171bt4_assert_is_smaller_than_or_equal_to(bn,
         0,x_i_or_fd_candidate,
         "GUID='441b7617-5db0-4827-845a-511151a018e7'")
      end # loop
   end # exc_verify_histogram_data_format_t1

   #--------------------------------------------------------------------------

   def s_textplot_t1(i_number_of_numbered_buckets_in_histogram,ar_numbers_to_be_counted)
      if KIBUVITS_krl171bt4_b_DEBUG
         bn=binding()
         kibuvits_krl171bt4_typecheck bn, [Integer,Fixnum,Bignum], i_number_of_numbered_buckets_in_histogram
         kibuvits_krl171bt4_assert_is_smaller_than_or_equal_to(bn,
         1,i_number_of_numbered_buckets_in_histogram,
         "GUID='22cc371e-2ee7-4c26-945a-511151a018e7'")
         #--------
         kibuvits_krl171bt4_typecheck bn,Array,ar_numbers_to_be_counted
         kibuvits_krl171bt4_assert_ar_elements_typecheck_if_is_array(bn,
         [Integer,Fixnum,Bignum,Rational,Float],ar_numbers_to_be_counted,
         "GUID='5cacfa21-9a08-4f5e-825a-511151a018e7'")
         #--------
      end # if
      #----------------------------------------
      i_ar_data_len=ar_numbers_to_be_counted.size
      if i_ar_data_len==0
         ob_hist=Mmmv_histogram_t1.ht_create_initialized_1D_histogram(
         i_number_of_numbered_buckets_in_histogram)
         s_out=ob_hist.s_formatted_t1
         return s_out
      end # if
      #----------------------------------------
      i_or_fd_min=ar_numbers_to_be_counted[0]
      i_or_fd_max=ar_numbers_to_be_counted[0]
      ar_numbers_to_be_counted.each do |i_or_fd_number_to_be_counted|
         if i_or_fd_number_to_be_counted < i_or_fd_min
            i_or_fd_min=i_or_fd_number_to_be_counted
         end # if
         if i_or_fd_max < i_or_fd_number_to_be_counted
            i_or_fd_max=i_or_fd_number_to_be_counted
         end # if
      end # loop
      #----------------------------------------
      fd_min=i_or_fd_min.to_r
      fd_max=i_or_fd_max.to_r
      fd_approximate_bucket_width=(fd_max-fd_min)/i_number_of_numbered_buckets_in_histogram
      fd_delta_01=fd_approximate_bucket_width/200000
      fd_bucket_0_lowest_bound=fd_min-fd_delta_01
      fd_max_bucket_upper_bound=fd_max+fd_delta_01
      #----------------------------------------
      ob_hist=Mmmv_histogram_t1.ht_create_initialized_1D_histogram(
      i_number_of_numbered_buckets_in_histogram)
      i_bucket_number=nil
      ar_numbers_to_be_counted.each do |i_or_fd_number_to_be_counted|
         i_bucket_number=Mmmv_histogram_t1.ix_fd_to_bucket_t1(
         fd_bucket_0_lowest_bound,fd_max_bucket_upper_bound,
         i_number_of_numbered_buckets_in_histogram,
         i_or_fd_number_to_be_counted)
         ob_hist.increment_bucket_by_x(i_bucket_number,1)
      end # loop
      s_plot_core=ob_hist.s_formatted_t1
      #----------------------------------------
      s_out=""
      s_out<<$kibuvits_krl171bt4_lc_linebreak
      i_0=(fd_approximate_bucket_width/1024).round(1).to_i
      s_out<<"Approximate bucket widht: \e[33m"+i_0.to_s+ "\e[36mKiB \e[39m\n"
      s_out<<s_plot_core
      return s_out
   end # s_textplot_t1

   #--------------------------------------------------------------------------

   def ht_x_y_generate_plot_data(i_number_of_numbered_buckets_in_histogram,
      ar_file_sizes_in_bytes)
      if KIBUVITS_krl171bt4_b_DEBUG
         bn=binding()
         kibuvits_krl171bt4_typecheck bn, [Integer,Fixnum,Bignum], i_number_of_numbered_buckets_in_histogram
         kibuvits_krl171bt4_assert_is_smaller_than_or_equal_to(bn,
         1,i_number_of_numbered_buckets_in_histogram,
         "GUID='939a2b37-871c-4ab4-a55a-511151a018e7'")
      end # if
      ht=Hash.new # key is X, value is Y
      i_ar_sz_len=ar_sz.size
      puts "ihaa  i_ar_sz_len=="+i_ar_sz_len.to_s
      i_ar_sz_len.times do
      end # loop
      ht_out=ht
      return ht_out
   end # ht_x_y_generate_plot_data

   #--------------------------------------------------------------------------

   def ar_read_in_the_array_of_numbers()
      s_ruby_code=kibuvits_krl171bt4_file2str(S_FP_FILE_SIZES_RB)
      ar_sz=nil
      s_ruby_code<<"\n ar_sz=ar_sizes \n"
      bn=binding()
      kibuvits_krl171bt4_testeval(bn,s_ruby_code) # supposed to create ar_sizes
      if KIBUVITS_krl171bt4_b_DEBUG
         bn=binding()
         kibuvits_krl171bt4_typecheck bn, [Array], ar_sz
         kibuvits_krl171bt4_assert_ar_elements_typecheck_if_is_array(bn,
         [Integer,Fixnum,Bignum],ar_sz,
         "GUID='5ac4c275-81ec-4353-b45a-511151a018e7'")
      end # if
      return ar_sz
   end # ar_read_in_the_array_of_numbers()

   #--------------------------------------------------------------------------

   public

   def run
      #Mmmv_histogram_t1.demo_01()
      #Mmmv_histogram_t1.demo_02()
      ar_file_sizes_in_bytes=ar_read_in_the_array_of_numbers()
      #i_number_of_numbered_buckets_in_histogram=30
      i_number_of_numbered_buckets_in_histogram=282
      s_plot=s_textplot_t1(
      i_number_of_numbered_buckets_in_histogram,ar_file_sizes_in_bytes)
      #ht_plot_data=ht_x_y_generate_plot_data(
      #i_number_of_numbered_buckets_in_histogram,
      #ar_file_sizes_in_bytes)
      puts(s_plot)
      # display_plot(ht)
   end # run

end # class Application_main

Application_main.new.run
#==========================================================================
# S_VERSION_OF_THIS_FILE="4fa5c9ab-2839-49f9-b25a-511151a018e7"
#==========================================================================
