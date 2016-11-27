#!/usr/bin/env ruby
#==========================================================================
=begin
  This file is in public domain.
  Author: martin.vahi@softf1.com that has an
  Estonian personal identification code of 38108050020.

  In Ruby there is a built in function for factorization

      Prime.prime_division(44)

  but in PHP and JavaScript there is none. The purpose
  of this code is to be a manually translated blueprint
  of a custom factorization function.
  

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

require  KIBUVITS_HOME+"/src/include/numerics/kibuvits_numerics_set_0.rb"


class Kibuvits_experiment_factorization_by_gcd_t1

   def initialize
      @ar_primes_1k=Prime.take(1000)
      @i_prod_0_100=Kibuvits_numerics_set_0.i_product_of_primes_t1(0,100)
   end # initialize

   #------------------
   def i_prod(ix_a,ix_b)
      i_out=@ar_primes_1k[ix_a]*@ar_primes_1k[ix_b]
      return i_out
   end # i_prod

   def ht_factorize_t1(n)
      ix=0
      ht_factors=Hash.new
      i_prime=nil
      i_left_0=n
      b_go_on=true
      while b_go_on
         i_prime=@ar_primes_1k[ix]
         if (i_left_0%i_prime)==0
            i_left_0=i_left_0/i_prime
            ht_factors[i_prime]=0 if !ht_factors.has_key? i_prime
            ht_factors[i_prime]=ht_factors[i_prime]+1
         else
            ix=ix+1
         end # if
         b_go_on=false if ((i_left_0==1)||(1000<=ix))
      end # loop
      return ht_factors
   end # ht_factorize_t1

   def run_test_1
      n=i_prod(i_prod(4,6),44)*3*3 # 11*17=187
      puts ht_factorize_t1(n).to_s
   end # run_test_1

   def run
      puts "\nTest_1 start\n"
      run_test_1()
      puts "\nTest_1 end\n"
   end # run

end # class Kibuvits_experiment_factorization_by_gcd_t1

ob_experiment=Kibuvits_experiment_factorization_by_gcd_t1.new

ob_experiment.run
puts("\n")
puts("\n")


#==========================================================================
