#!/usr/bin/env ruby
#==========================================================================
=begin
 Copyright 2012, martin.vahi@softf1.com that has an
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
#==========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/wrappers/kibuvits_ImageMagick.rb"
#==========================================================================

class Kibuvits_ImageMagick_selftests
   @@s_fp_datadir=KIBUVITS_HOME+"/src/dev_tools/selftests"+
   "/data_for_selftests/kibuvits_ImageMagick_selftests"

   def initialize
   end #initialize

   private

   #-----------------------------------------------------------------------

   def Kibuvits_ImageMagick_selftests.test_1
      s_fp_x=@@s_fp_datadir+"/uhuu.bmp"
      if kibuvits_block_throws{Kibuvits_ImageMagick.ht_image_info(s_fp_x)}
         kibuvits_throw "test 1, GUID='8046491b-a64b-4624-83de-a0b241014dd7'"
      end # if

      s_fp_x=@@s_fp_datadir+"/x.bash"
      if kibuvits_block_throws{Kibuvits_ImageMagick.ht_image_info(s_fp_x)}
         # It must not throw on non-image files, i.e. it's OK
         # for non-image files to be fed to the
         # Kibuvits_ImageMagick.ht_image_info
         kibuvits_throw "test 2, GUID='f0da7b58-8d8e-40e5-84de-a0b241014dd7'"
      end # if

      s_fp_x=@@s_fp_datadir+"/this_file_does_not_exist.txt"
      if !kibuvits_block_throws{Kibuvits_ImageMagick.ht_image_info(s_fp_x)}
         kibuvits_throw "test 3, GUID='64232e3c-d815-4d2c-82de-a0b241014dd7'"
      end # if

      s_fp_x=@@s_fp_datadir+"/x.bash"
      ht_info=Kibuvits_ImageMagick.ht_image_info(s_fp_x)
      if ht_info[$kibuvits_lc_b_is_imagefile]!=false
         kibuvits_throw "test 4, GUID='8fa3795f-c730-4bcd-85de-a0b241014dd7'"
      end # if

      s_fp_x=@@s_fp_datadir+"/uhuu.bmp"
      ht_info=Kibuvits_ImageMagick.ht_image_info(s_fp_x)
      if ht_info[$kibuvits_lc_b_is_imagefile]!=true
         kibuvits_throw "test 4a, GUID='29764812-1e00-4de4-b5de-a0b241014dd7'"
      end # if
      if ht_info[$kibuvits_lc_i_width]!=3264
         kibuvits_throw "test 4b, GUID='1a7af3ef-d8a2-4b3f-b1de-a0b241014dd7'"
      end # if
      if ht_info[$kibuvits_lc_i_height]!=2448
         kibuvits_throw "test 4c, ht_info[$kibuvits_lc_i_height]=="+
         ht_info[$kibuvits_lc_i_height].to_s+
         "\nGUID='819a5e46-c303-4f0c-82de-a0b241014dd7'"
      end # if
   end # Kibuvits_ImageMagick_selftests.test_1

   #-----------------------------------------------------------------------

   public
   def Kibuvits_ImageMagick_selftests.selftest
      ar_msgs=Array.new
      #--------
      if !KIBUVITS_b_DEBUG
         b_available_on_path=Kibuvits_shell.b_available_on_path("convert")
         return ar_msgs if !b_available_on_path
      end # if
      #--------
      bn=binding()
      kibuvits_testeval bn, "Kibuvits_ImageMagick_selftests.test_1"
      return ar_msgs
   end # Kibuvits_ImageMagick_selftests.selftest

end # class Kibuvits_ImageMagick_selftests

#==========================================================================

