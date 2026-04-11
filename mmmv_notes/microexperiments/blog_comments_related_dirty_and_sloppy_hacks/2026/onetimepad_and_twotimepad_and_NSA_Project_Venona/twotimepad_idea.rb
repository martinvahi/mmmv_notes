#!/usr/bin/env ruby
#==========================================================================
=begin

Initial author of this file: Martin.Vahi@softf1.com
This file is in public domain.
The following line is a spdx.org license label line:
SPDX-License-Identifier: 0BSD
===========================================================================

Supposedly

   C1 = XOR(P1,K)
   C2 = XOR(P2,K)
   XOR(C1,C2) = XOR(P1,P2)

where C1,C2,P1,P2,K are boolean values.

This code intends to test that the

   XOR(C1,C2) = XOR(P1,P2)

holds for all 2^3=8 value combinations.
===========================================================================
=end

def func_k(b_p1,b_p2,b_k)
   b_c1=b_p1^b_k
   b_c2=b_p2^b_k
   b_c1_c2=b_c1^b_c2
   b_p1_p2=b_p1^b_p2
   if b_c1_c2 != b_p1_p2
      puts("")
      puts("\e[31mFound a mismatch!\e[39m")
      puts("")
      puts("    b_c1=="+b_c1.to_s)
      puts("    b_c2=="+b_c2.to_s)
      puts("    b_p1=="+b_p1.to_s)
      puts("    b_p2=="+b_p2.to_s)
      puts("    b_k=="+b_k.to_s)
      puts("")
   else
      printf("\e[32m.\e[39m")
   end # if
end  #func_k

def func_p2(b_p1,b_p2)
   func_k(b_p1,b_p2,true)
   func_k(b_p1,b_p2,false)
end  #func_p2

def func_p1(b_p1)
   func_p2(b_p1,true)
   func_p2(b_p1,false)
end  #func_p1

def main()
   puts("")
   func_p1(true)
   func_p1(false)
   puts("\n\n")
end # main
main

#==========================================================================
# S_VERSION_OF_THIS_FILE="3b484092-075f-4615-b3cf-d1d150b04ae7"
#==========================================================================
