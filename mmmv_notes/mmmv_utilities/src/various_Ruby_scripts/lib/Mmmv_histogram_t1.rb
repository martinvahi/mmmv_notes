#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------
# Tested with ("ruby -v")
#
# ruby 3.0.1p64 (2021-04-05 revision 0fb782ee38) [x86_64-linux]
#
#  on ("uname -a")
#
# Linux terminal01 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux
#==========================================================================

require "singleton"

# A class for displaying results of small experiments on console.
class Mmmv_histogram_t1

   def initialize
      #----------------------------------------
      # The values of the
      @s_lc_more_than_max_bucket="more_than_max_bucket".freeze
      @s_lc_less_than_min_bucket="less_than_min_bucket".freeze
      # are explicitly in use at prototype-oriented style
      # instance method
      #
      #     set_0_to_all_buckets()
      #
      # which needs to be updated, if
      # the values are changed here.
      #----------------------------------------
      @lc_linebreak="\n"
   end # initialize

   # Returns a hashtable, where keys are bucket names and
   # values are numbers that have been initialized to 0.
   # The histogram has i_number_of_numbered_buckets+2 buckets.
   # Numbered buckets are labeled with
   #
   #    0 .. (i_number_of_numbered_buckets-1)
   #
   # The labels of the other 2 buckets are
   # determined  by instance variables
   #
   #     @s_lc_more_than_max_bucket
   #     @s_lc_less_than_min_bucket
   #
   def ht_create_initialized_1D_histogram(i_number_of_numbered_buckets=16)
      #----------------------------------------
      if i_number_of_numbered_buckets < 1
         raise(Exception.new(
         "\nGUID=='8689f726-9795-4573-b2fc-a020a0f137e7'\n"))
      end # if
      #----------------------------------------
      ht_histogram=Hash.new
      i_number_of_numbered_buckets.times do |i| # i==0 at first iteration
         ht_histogram[i]=0
      end # loop
      ht_histogram[@s_lc_more_than_max_bucket]=0
      ht_histogram[@s_lc_less_than_min_bucket]=0
      #----------------------------------------
      return ht_histogram
   end # ht_create_initialized_1D_histogram

   def Mmmv_histogram_t1.ht_create_initialized_1D_histogram(i_number_of_numbered_buckets=16)
      ht_out=Mmmv_histogram_t1.instance.ht_create_initialized_1D_histogram(
      i_number_of_numbered_buckets)
      return ht_out
   end # Mmmv_histogram_t1.ht_create_initialized_1D_histogram

   #-----------------------------------------------------------------------

   def i_number_of_buckets(ht_histogram)
      #----------------------------------------
      if ht_histogram.class != Hash
         raise(Exception.new(
         "\nGUID=='8dc5f159-754c-4a45-85fc-a020a0f137e7'\n"))
      end # if
      if !ht_histogram.has_key? @s_lc_more_than_max_bucket
         raise(Exception.new(
         "\nGUID=='cb71924e-aa23-4156-b5fc-a020a0f137e7'\n"))
      end # if
      if !ht_histogram.has_key? @s_lc_less_than_min_bucket
         raise(Exception.new(
         "\nGUID=='49bc9db0-d019-4bb7-94fc-a020a0f137e7'\n"))
      end # if
      #----------------------------------------
      ar_keys=ht_histogram.keys
      i_out=ar_keys.size
      return i_out
      #----------------------------------------
   end # i_number_of_buckets

   def Mmmv_histogram_t1.i_number_of_buckets(ht_histogram)
      i_out=Mmmv_histogram_t1.instance.i_number_of_buckets(ht_histogram)
      return i_out
   end # Mmmv_histogram_t1.i_number_of_buckets

   #-----------------------------------------------------------------------

   def s_formatted_t1(ht_histogram)
      #----------------------------------------
      if ht_histogram.class != Hash
         raise(Exception.new(
         "\nGUID=='4547af34-3b2c-488f-84fc-a020a0f137e7'\n"))
      end # if
      if !ht_histogram.has_key? @s_lc_more_than_max_bucket
         raise(Exception.new(
         "\nGUID=='34d31b21-bfc7-44c4-adfc-a020a0f137e7'\n"))
      end # if
      if !ht_histogram.has_key? @s_lc_less_than_min_bucket
         raise(Exception.new(
         "\nGUID=='2eea0497-095a-447c-85fc-a020a0f137e7'\n"))
      end # if
      #----------------------------------------
      s_0="Histogram Column Label"
      s_1=" | "
      s_2="Histogram Column Height"
      #--------
      i_s_0_len=s_0.size
      i_n_of_buckets=i_number_of_buckets(ht_histogram)
      i_n_of_numbered_buckets=i_n_of_buckets-2
      #--------
      s_out=""+@lc_linebreak
      s_out<<(s_0+s_1+s_2+@lc_linebreak)
      s_out<<(("-"*s_0.size)+s_1+"-"*s_2.size+@lc_linebreak)
      #----------------------------------------
      func_add_line_to_histogram_string=lambda do |s_bucket_name, s_bucket_value|
         # The reason, why the bucket value comes in as sting is that
         # the bucket value might also be a floating point number or a vector.
         i_n_of_spaces=(i_s_0_len-s_bucket_name.size)
         if i_n_of_spaces<0
            raise(Exception.new("GUID=='05988a43-ac79-4ff1-92fc-a020a0f137e7'"))
         end # if
         s_out<<((" "*i_n_of_spaces)+s_bucket_name+s_1+s_bucket_value+@lc_linebreak)
      end # func_add_line_to_histogram_string
      #----------------------------------------
      x_bucket_value=ht_histogram[@s_lc_less_than_min_bucket]
      s_bucket_value=x_bucket_value.to_s
      func_add_line_to_histogram_string.call(
      @s_lc_less_than_min_bucket,s_bucket_value)
      #----------
      i_n_of_numbered_buckets.times do |i| # i==0 at first iteration
         x_bucket_value=ht_histogram[i]
         s_bucket_value=x_bucket_value.to_s
         func_add_line_to_histogram_string.call(i.to_s, s_bucket_value)
      end # loop
      #----------
      x_bucket_value=ht_histogram[@s_lc_more_than_max_bucket]
      s_bucket_value=x_bucket_value.to_s
      func_add_line_to_histogram_string.call(
      @s_lc_more_than_max_bucket,s_bucket_value)
      #----------------------------------------
      s_line=("-"*(s_0.size+s_1.size+s_2.size)+@lc_linebreak)
      s_out<<s_line
      s_out<<@lc_linebreak
      #----------------------------------------
      return s_out
   end # s_formatted_t1

   #-----------------------------------------------------------------------

   def Mmmv_histogram_t1.s_formatted_t1(ht_histogram)
      s_out=Mmmv_histogram_t1.instance.s_formatted_t1(ht_histogram)
      return s_out
   end # Mmmv_histogram_t1.s_formatted_t1

   #-----------------------------------------------------------------------

   # The key-phrase is: prototype-based programming.
   # Adds methods
   #
   #     ht_histogram.increment_bucket_by_x(x_bucket_id,x_in)
   #     ht_histogram.decrement_bucket_by_x(x_bucket_id,x_in)
   #     ht_histogram.set_0_to_all_buckets()
   #
   def add_instance_methods_t1(ht_histogram)
      #----------------------------------------
      if ht_histogram.class != Hash
         raise(Exception.new(
         "\nGUID=='bf748017-3534-45cb-93fc-a020a0f137e7'\n"))
      end # if
      if !ht_histogram.has_key? @s_lc_more_than_max_bucket
         raise(Exception.new(
         "\nGUID=='2036b034-d2a8-4845-a5fc-a020a0f137e7'\n"))
      end # if
      if !ht_histogram.has_key? @s_lc_less_than_min_bucket
         raise(Exception.new(
         "\nGUID=='1c6e5b64-64a5-4569-a1fc-a020a0f137e7'\n"))
      end # if
      #----------------------------------------
      def ht_histogram.increment_bucket_by_x(x_bucket_id,x_in)
         ht_hist=self
         x_old=ht_hist[x_bucket_id]
         x_new=x_old+x_in # x_old might not be a whole number.
         ht_hist[x_bucket_id]=x_new
      end # ht_histogram.increment_bucket_by_x
      #----------------------------------------
      def ht_histogram.decrement_bucket_by_x(x_bucket_id,x_in)
         ht_hist=self
         x_old=ht_hist[x_bucket_id]
         x_new=x_old-x_in # x_old might not be a whole number.
         ht_hist[x_bucket_id]=x_new
      end # ht_histogram.decrement_bucket_by_x
      #----------------------------------------
      def ht_histogram.set_0_to_all_buckets()
         # The usefulness of this mehtod is mainly that
         # it facilitates hashtable instance reuse.
         # It's a speed-hack :-)
         # All buckets are set to 0 during
         # the histogram initialization anyway.
         #--------
         ht_hist=self
         ar_keys=ht_hist.keys
         i_n_of_numbered_buckets=ar_keys.size-2
         i_n_of_numbered_buckets.times do |ix|
            ht_hist[ix]=0
         end #loop
         ht_hist["more_than_max_bucket"]=0 # value of the @s_lc_more_than_max_bucket
         ht_hist["less_than_min_bucket"]=0 # value of the @s_lc_less_than_min_bucket
         #--------
      end # ht_histogram.set_0_to_all_buckets
      #----------------------------------------
   end # add_instance_methods_t1

   #-----------------------------------------------------------------------

   def Mmmv_histogram_t1.add_instance_methods_t1(ht_histogram)
      Mmmv_histogram_t1.instance.add_instance_methods_t1(
      ht_histogram)
   end # Mmmv_histogram_t1.add_instance_methods_t1

   #-----------------------------------------------------------------------

   def demo_01
      #----------------------------------------
      i_number_of_numbered_buckets=5+rand(10)
      ht_histogram=ht_create_initialized_1D_histogram(
      i_number_of_numbered_buckets)
      i_rand_max_plus_1=2000
      #----------------------------------------
      30.times do |i1|
         ht_histogram[@s_lc_less_than_min_bucket]=rand(i_rand_max_plus_1)
         i_number_of_numbered_buckets.times do |i_numbered_bucket|
            ht_histogram[i_numbered_bucket]=rand(i_rand_max_plus_1)
         end # loop
         ht_histogram[@s_lc_more_than_max_bucket]=rand(i_rand_max_plus_1)
      end # loop
      #----------------------------------------
      puts("\ni_number_of_numbered_buckets == "+i_number_of_numbered_buckets.to_s)
      s_histogram=s_formatted_t1(ht_histogram)
      puts(s_histogram)
      #----------------------------------------
      #ht_histogram
      #----------------------------------------
   end # demo_01

   def Mmmv_histogram_t1.demo_01()
      Mmmv_histogram_t1.instance.demo_01()
   end # Mmmv_histogram_t1.demo_01

   #-----------------------------------------------------------------------

   # It's a test for the reflection related code at
   # Mmmv_histogram_t1.add_bucket_incrementation_method_t1(...)
   def demo_02
      #----------------------------------------
      i_number_of_numbered_buckets=6
      ht_histogram_01=ht_create_initialized_1D_histogram(
      i_number_of_numbered_buckets)
      ht_histogram_02=ht_create_initialized_1D_histogram(
      i_number_of_numbered_buckets)
      #----------------------------------------
      # The task of the test is to find out, whether
      # the reflection code works at all from syntax point of view
      # and whether only the right histogram gets updated by the
      # bucket incrementation loop.
      add_instance_methods_t1(ht_histogram_01)
      add_instance_methods_t1(ht_histogram_02)
      ix=nil
      300.times do |i|
         ix=(i%i_number_of_numbered_buckets)
         ht_histogram_01.increment_bucket_by_x(ix,1)
         ht_histogram_02.decrement_bucket_by_x(ix,2)
      end # loop
      #----------------------------------------
      s_histogram_01=s_formatted_t1(ht_histogram_01)
      s_histogram_02=s_formatted_t1(ht_histogram_02)
      puts("Histogram 01:\n"+s_histogram_01)
      puts("Histogram 02:\n"+s_histogram_02)
      #--------
      ht_histogram_02.set_0_to_all_buckets()
      s_histogram_01=s_formatted_t1(ht_histogram_01)
      s_histogram_02=s_formatted_t1(ht_histogram_02)
      puts("Histogram 01 after zeroing Histogram 02:\n"+s_histogram_01)
      puts("Histogram 02 after zeroing:\n"+s_histogram_02)
      #----------------------------------------
   end  # demo_02

   def Mmmv_histogram_t1.demo_02()
      Mmmv_histogram_t1.instance.demo_02()
   end # Mmmv_histogram_t1.demo_02

   #-----------------------------------------------------------------------
   include Singleton
end # class Mmmv_histogram_t1

#Mmmv_histogram_t1.demo_01()
#Mmmv_histogram_t1.demo_02()

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="73340533-0472-4870-b5fc-a020a0f137e7"
#==========================================================================
