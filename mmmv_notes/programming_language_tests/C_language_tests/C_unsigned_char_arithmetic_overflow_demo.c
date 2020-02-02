/* Initial author: Martin.Vahi@softf1.com
   This file is in public domain.

   compilation:
       gcc ./C_unsigned_char_arithmetic_overflow_demo.c

   Tested on ("uname -a")

Linux linux-f26r 4.4.126-48-default #1 SMP Sat Apr 7 05:22:50 UTC 2018 (f24992c) x86_64 x86_64 x86_64 GNU/Linux

   with ("gcc -v")

Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/home/ts2_andmed/m_local/bin_p/Ada/v2019_05_17/bin/../libexec/gcc/x86_64-pc-linux-gnu/8.3.1/lto-wrapper
OFFLOAD_TARGET_NAMES=nvptx-none
Target: x86_64-pc-linux-gnu
Configured with: ../src/configure --enable-languages=ada,c,c++ --enable-dual-exceptions --enable-offload-targets=nvptx-none --enable-_cxa_atexit --enable-threads=posix --with-bugurl=URL:mailto:report@adacore.com --disable-nls --without-libiconv-prefix --disable-libstdcxx-pch --disable-libada --enable-checking=release --disable-multilib --with-mpfr=/it/sbx/a2c2/x86_64-linux/mpfr_stable-c/install --with-gmp=/it/sbx/a2c2/x86_64-linux/gmp_stable-c/install --with-mpc=/it/sbx/a2c2/x86_64-linux/mpc_stable-c/install --with-build-time-tools=/it/sbx/a2c2/x86_64-linux/gcc-c/build/buildtools/bin --prefix=/it/sbx/a2c2/x86_64-linux/gcc-c/pkg --build=x86_64-pc-linux-gnu
Thread model: posix
gcc version 8.3.1 20190518 (for GNAT Community 2019 20190517) (GCC) 
*/

#include <stdio.h>

void main() {
    unsigned char i_0=255;
    puts("");
    printf("At first: %u",i_0);
    i_0=i_0+1;
    puts("\n");
    printf("255 + 1 = %u",i_0);
    i_0=i_0-1;
    puts("\n");
    printf("0 - 1 = %u",i_0);
    puts("\n");
}

/*---console--output--citation--start-----

At first: 255

255 + 1 = 0

0 - 1 = 255

-----console--output--citation--end----*/

