#!/usr/bin/env ruby
#==========================================================================
=begin
  This file is in public domain.
  Author: martin.vahi@softf1.com that has an
  Estonian personal identification code of 38108050020.

  If 0 represents 0 and 1 represents a whole number N, then
  the main test assembles a histogram of the factors
  of the N and normalizes it.

  The main test is run for a set of numbers and a set of histograms
  is printed to console.

  The motivation of this test is to get some sort of a hunch,
  what might be the average performance of different rational number
  simplification techniques.

  The end result on a single 3GHz CPU with approximate 
  memory consumption peak of 800MiB:

------citation--start---------------

hematical_phenomena$ time nice -n10 ./2014_05_xx_histogram_of_factors.rb 90000


For number N the buckets of the histogram are equal regions between 0 to N.
The content of the bucket is the number of factors of all numbers that 
are between 1 and N. For example, if N==20, then the bounds are from 0 to 20 
and the all factors of 1, and 2, and 3 and 4 and 5 and 6 and 7 and 8 etc.
are placed to the buckets that range from 0 to 20.

N==9000  |_26492|___807|___401|___257|___214|___102|___107|___100|____99|____99|
N==18000 |_54756|__1455|___734|___485|___396|___198|___189|___182|___197|___181|
N==27000 |_83554|__2074|__1075|___693|___570|___283|___267|___275|___275|___261|
N==36000 |112707|__2696|__1386|___865|___756|___361|___356|___355|___340|___348|
N==45000 |142085|__3289|__1691|__1082|___902|___446|___428|___435|___422|___429|
N==54000 |171638|__3914|__1989|__1265|__1072|___515|___522|___512|___489|___501|
N==63000 |201424|__4444|__2271|__1472|__1216|___609|___591|___583|___576|___572|
N==72000 |231285|__4982|__2595|__1665|__1376|___686|___662|___663|___642|___651|
N==81000 |261261|__5604|__2857|__1813|__1540|___753|___749|___729|___729|___719|
N==90000 |291352|__6141|__3142|__2010|__1702|___825|___820|___808|___797|___788|



real	4m20.801s
user	3m44.702s
sys	0m25.066s

------citation--end-----------------

=end
#==========================================================================

require "prime"

# Edits the content of the ar_histogram_buckets
def ar_gen_histogram_of_a_single_number(i_n,i_number_of_columns_in_the_histogram)
   ar_histogram_buckets=Array.new(i_number_of_columns_in_the_histogram,0)
   #---------------------------
   # If i_n is a prime, then
   # it will end up in the
   # ar_histogram_buckets[ar_histogram_buckets.size-1]
   fd_delta=(i_n.to_r)/i_number_of_columns_in_the_histogram
   # ...1|...2|...3| etc.
   ar_bucket_upper_bounds=Array.new(i_number_of_columns_in_the_histogram,0)
   fd_bound=0
   i_number_of_columns_in_the_histogram.times do |ix|
      fd_bound=fd_bound+fd_delta
      ar_bucket_upper_bounds[ix]=fd_bound
   end # loop
   #---------------------------
   ar_of_ar_factors=Array.new
   i_n.times do |i|
      ar_of_ar_factors=ar_of_ar_factors+Prime.prime_division(i+1) # ar of [<factor>, <the power of the factor>]
   end # loop
   # By default the ar_of_ar_factors is sorted so that
   # the smaller the index, the smaller the factor.
   i_len_factors=ar_of_ar_factors.size
   ar_factor=nil
   i_factor=nil
   i_factor_power=nil
   i_len_factors.times do |ix_factors|
      ar_factor=ar_of_ar_factors[ix_factors]
      i_factor=ar_factor[0]
      i_factor_power=ar_factor[1]
      i_number_of_columns_in_the_histogram.times do |ix_bucket|
         fd_bound=ar_bucket_upper_bounds[ix_bucket]
         if i_factor<=fd_bound
            ar_histogram_buckets[ix_bucket]=ar_histogram_buckets[ix_bucket]+
            i_factor_power
            break
         end # if

      end # loop
   end # loop
   return ar_bucket_upper_bounds,ar_histogram_buckets
end # ar_gen_histogram_of_a_single_number

def pad_with_string(s_modifyable,s_padding,i_x)
   s_modifyable<<s_padding if i_x<100000
   s_modifyable<<s_padding if i_x<10000
   s_modifyable<<s_padding if i_x<1000
   s_modifyable<<s_padding if i_x<100
   s_modifyable<<s_padding if i_x<10
end # pad_with_space



def s_gen_histogram(i_n,i_number_of_columns_in_the_histogram)
   s_out="N=="+i_n.to_s
   pad_with_string(s_out," ",i_n)
   ar_bucket_upper_bounds,ar_histogram_buckets=ar_gen_histogram_of_a_single_number(i_n,
   i_number_of_columns_in_the_histogram)
   #---------------------------
   i_column_height=nil
   s_out<<"|"
   i_number_of_columns_in_the_histogram.times do |ix|
      i_column_height=ar_histogram_buckets[ix]
      pad_with_string(s_out,"_",i_column_height)
      s_out<<i_column_height.to_s
      #s_out<<"("+ar_bucket_upper_bounds[ix].round.to_i.to_s+")"
      s_out<<"|"
   end # loop
   return s_out
end # s_gen_histogram


def s_gen_set_of_histograms(i_approxemate_number_of_histograms,
   i_max_number,i_number_of_columns_in_the_histogram)
   i_max_number_min=10
   if i_max_number<i_max_number_min
      raise(Exception.new("It's a proof of concept, a rough hack, so "+
      "many corner cases will not be even studied. i_max_number has to be "+
      "greater or equal with "+i_max_number_min.to_s))
   end # if
   i_delta=(i_max_number.to_r/i_approxemate_number_of_histograms).floor
   i_n_of_histsograms=i_approxemate_number_of_histograms
   if i_delta==0
      i_delta=1
      i_n_of_histsograms=1
   end # if
   ar_numbers=Array.new
   i_n=i_max_number
   i_n_of_histsograms.times do
      ar_numbers<<i_n
      i_n=i_n-i_delta
   end # loop
   ar_numbers=ar_numbers.reverse # to start from the smallest
   s_out="\n"
   i_ar_numbers_len=ar_numbers.size
   #----------
   i_ar_numbers_len.times do |ix|
      i_n=ar_numbers[ix]
      s_out<<(s_gen_histogram(i_n,i_number_of_columns_in_the_histogram)+"\n")
   end # loop
   s_out<<"\n\n"
   return s_out
end # s_gen_set_of_histograms

#--------------------------------------------------------------------------
i_approxemate_number_of_histograms=10
i_max_number=1000
i_number_of_columns_in_the_histogram=10
i_max_number=ARGV[0].to_i if ARGV.size!=0

puts "\n\n"
puts "For number N the buckets of the histogram are equal regions between 0 to N.\n"
puts "The content of the bucket is the number of factors of all numbers that "
puts "are between 1 and N. For example, if N==20, then the bounds are from 0 to 20 "
puts "and the all factors of 1, and 2, and 3 and 4 and 5 and 6 and 7 and 8 etc."
puts "are placed to the buckets that range from 0 to 20."

s_results=s_gen_set_of_histograms(i_approxemate_number_of_histograms,
i_max_number,i_number_of_columns_in_the_histogram)
puts(s_results)

#==========================================================================
