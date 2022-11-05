#!/usr/bin/env ruby
#==========================================================================
# This file is in public domain and is
# related to a blog post that resides at
# http://martin.softf1.com/g/yellow_soap_opera_blog/uniformly-distributed-random-numbers-and-random-bitstreams
#
# Author: martin.vahi@softf1.com that has an
# Estonian personal identification code of 38108050020.
#--------------------------------------------------------------------------

def s_test_rundom_number_generator(i_sample_size)
   i_0=0
   i_1=0
   i_just_in_case=nil
   i_sample_size.times do
      i_just_in_case=Random.rand(2)
      if 1<i_just_in_case
         # According to
         # http://www.ruby-doc.org/core-2.0.0/Random.html#method-i-rand
         # the Random.rand(x)<x, but
         # one does not want a documentation flaw to skew this test.
         raise Exception.new("\n i_just_in_case=="+i_just_in_case.to_s)
      end # if
      if i_just_in_case<1
         i_0=i_0+1
      else
         i_1=i_1+1
      end # if
   end # loop
   s_out="\nTest results: i_0=="+i_0.to_s+"   i_1=="+i_1.to_s+"\n"+
   "              i_0/i_1 ~ "+(i_0.to_f/i_1.to_f).round(5).to_s+"\n\n"
   return s_out
end # s_test_rundom_number_generator

def i_gen_number(i_max_n_of_bits)
   if i_max_n_of_bits<1
      raise Exception.new(
      "i_max_n_of_bits == "+i_max_n_of_bits.to_s+" < 1")
   end # if
   s_0=""
   i_max_n_of_bits.times do
      s_0<<(Random.rand(2).to_s)
   end # if
   i_out=s_0.to_i(2)
   return i_out
end # i_gen_number

def s_histogram_2_str(ar_hist)
   s_out="\nHistogram:\n\n"+"    | "
   ar_hist.size.times do |i_ix|
      s_out<<(ar_hist[i_ix].to_s+" | ")
   end # loop
   return s_out
end # s_histogram_2_str

def ar_gen_data(i_number_of_numbers, i_max_n_of_bits_in_a_single_number)
   ar_data=Array.new
   i_number_of_numbers.times do
      ar_data<<i_gen_number(i_max_n_of_bits_in_a_single_number)
   end # loop
   return ar_data
end # ar_gen_data

# There will be 2^i_histogram_columns_number_parameter
# number of histogram columns. The
# i_histogram_columns_number_parameter has to be
# smaller than or equal to the i_max_n_of_bits_in_a_single_number
# because otherwise the number of histogram
# columns wold exceed the maximum value of the
# numbers that are subject to counting.
#
# To allow the histogram to fit a text screen, the
# maximum number of histogram columns should be
# roughly smaller than 40, because the "standard"
# text screen width is 80 characters. Given that
# the number that describes a
# histogram height takes more than 2 characters, 16 columns
# might be a practical maximum. 2^4=16. Therefore,
# it is suggested that
#
#     i_histogram_columns_number_parameter <= 4
#
def ar_gen_hisgogram(ar_data, b_ar_data_is_sorted,
   i_max_n_of_bits_in_a_single_number,
   i_histogram_columns_number_parameter)
   if i_histogram_columns_number_parameter<0
      raise Exception.new(
      "Requirement: \n"+
      "    0 <= i_histogram_columns_number_parameter ")
   end # if
   if (i_max_n_of_bits_in_a_single_number < i_histogram_columns_number_parameter)
      raise Exception.new(
      "Requirement: \n"+
      "    i_histogram_columns_number_parameter <= i_max_n_of_bits_in_a_single_number ")
   end # if
   if (i_max_n_of_bits_in_a_single_number < 1)
      raise Exception.new(
      "Requirement: \n"+
      "    1 <= i_max_n_of_bits_in_a_single_number ")
   end # if
   #----------
   # A 1-column histogram is useless.
   return if i_histogram_columns_number_parameter==0
   i_n_of_hist_columns=2**i_histogram_columns_number_parameter
   #----------
   # The histogram structure
   ar_hist=Array.new(i_n_of_hist_columns,0)
   i_column_width=2**(
   i_max_n_of_bits_in_a_single_number-i_histogram_columns_number_parameter)
   # Sample case: i_column_width==1, i_max_n_of_bits_in_a_single_number==1
   i_cursor=(-1)
   ar_hist_column_max=Array.new(i_n_of_hist_columns,42) # 42 the classics
   i_n_of_hist_columns.times do |i_column|
      i_cursor=i_cursor+i_column_width
      ar_hist_column_max[i_column]=i_cursor
   end # loop
   #----------
   # Data 2 histogram
   ar_data.sort! if !b_ar_data_is_sorted
   i_ar_data_len=ar_data.size
   i_data=nil
   i_column=0
   i_column_max=ar_hist_column_max[i_column]
   i_hist_height=0
   i_ar_data_len.times do |i_ix|
      i_data=ar_data[i_ix]
      if i_data<=i_column_max
         i_hist_height=i_hist_height+1
      else
         ar_hist[i_column]=i_hist_height
         i_hist_height=0
         i_column=i_column+1
         i_column_max=ar_hist_column_max[i_column]
      end # if
   end # loop
   ar_hist[i_column]=i_hist_height
   return ar_hist
end # ar_gen_hisgogram

def print_params_t1(i_number_of_numbers,i_max_n_of_bits_in_a_single_number,
   i_histogram_columns_number_parameter)
   s_0="\n                     i_number_of_numbers=="+
   i_number_of_numbers.to_s+
   "\n      i_max_n_of_bits_in_a_single_number=="+
   i_max_n_of_bits_in_a_single_number.to_s+"\n"+
   "    i_histogram_columns_number_parameter=="+
   i_histogram_columns_number_parameter.to_s+"\n\n"
   puts s_0
end # print_params_t1

#--------------------------------------------------------------------------

puts "\n"+("-"*60)+"\nExperiment stage 0:\n"
Random::srand()
puts s_test_rundom_number_generator((10**6)*2)

#--------------------------------------------------------------------------

puts "\n"+("-"*60)+"\nExperiment stage 1:\n"

i_number_of_numbers=1024*1024*3
i_max_n_of_bits_in_a_single_number=16
i_histogram_columns_number_parameter=3

ar_data=ar_gen_data(i_number_of_numbers,
i_max_n_of_bits_in_a_single_number)

ar_hist=ar_gen_hisgogram(ar_data,false,
i_max_n_of_bits_in_a_single_number,
i_histogram_columns_number_parameter)

print_params_t1(i_number_of_numbers,i_max_n_of_bits_in_a_single_number,
i_histogram_columns_number_parameter)

puts s_histogram_2_str(ar_hist)

#--------------------------------------------------------------------------

puts "\n"+("-"*60)+"\nExperiment stage 2:\n"

i_histogram_columns_number_parameter=i_max_n_of_bits_in_a_single_number

print_params_t1(i_number_of_numbers,i_max_n_of_bits_in_a_single_number,
i_histogram_columns_number_parameter)

ar_hist=ar_gen_hisgogram(ar_data,true,
i_max_n_of_bits_in_a_single_number,
i_histogram_columns_number_parameter)

i_ix_max=(2**i_histogram_columns_number_parameter)-1 # i_ix_min == 0
puts "  ar_hist[0] == "+ar_hist[0].to_s
i_1=i_histogram_columns_number_parameter-1
if 0<=i_1
   i_00=2**(i_1-1)
   if 0<=i_00
      puts "  ar_hist["+i_00.to_s+"] == "+ar_hist[i_00].to_s
   end # if
   i_0=2**i_1
   puts "  ar_hist["+i_0.to_s+"] == "+ar_hist[i_0].to_s
   i_0=i_0+i_00
   if i_0<i_ix_max
      puts "  ar_hist["+i_0.to_s+"] == "+ar_hist[i_0].to_s
   end # if
end # if
puts "  ar_hist["+i_ix_max.to_s+"] == "+ar_hist[i_ix_max].to_s+"\n\n"

#==========================================================================
