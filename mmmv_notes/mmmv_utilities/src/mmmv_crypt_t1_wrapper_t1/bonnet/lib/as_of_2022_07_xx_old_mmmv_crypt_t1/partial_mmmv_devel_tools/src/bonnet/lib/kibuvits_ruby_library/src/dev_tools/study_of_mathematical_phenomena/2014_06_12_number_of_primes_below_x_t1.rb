#!/usr/bin/env ruby
#==========================================================================
=begin
  This file is in public domain.
  Author: martin.vahi@softf1.com that has an
  Estonian personal identification code of 38108050020.

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

The output of this script:
------citation--start---------------
n_of_primes == 100000
   i_number == 1299709
   fd_ratio == 0.07694029971324351
------citation--end-----------------


=end
#==========================================================================

require "prime"

def fd_n_of_primes_per_number(n_of_primes)
   ar=Prime.take(n_of_primes)
   i_number=ar.last
   fd_number=i_number.to_r
   fd_ratio=(n_of_primes.to_r/fd_number).to_f
   return i_number,fd_ratio
end # fd_n_of_primes_per_number

n_of_primes=10000
i_number,fd_ratio=fd_n_of_primes_per_number(n_of_primes)
puts("\n")
puts("n_of_primes == "+n_of_primes.to_s)
puts("   i_number == "+i_number.to_s)
puts("   fd_ratio == "+fd_ratio.to_s)
puts("\n")


#==========================================================================
