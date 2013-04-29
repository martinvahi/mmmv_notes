#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2013, martin.vahi@softf1.com that has an
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
#=========================================================================

if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   ob_pth_1=ob_pth_0.parent.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_coords.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"

#==========================================================================

# Command-line utilities used from the ImageMagic package:
# identify,  convert
class Kibuvits_ImageMagick

   def initialize
      @ar_img_file_globstrings=["*.jpeg","*.JPEG","*.jpg","*.JPG"]
      @ar_img_file_globstrings.concat(["*.eps","*.EPS","*.gif","*.GIF"])
      @ar_img_file_globstrings.concat(["*.png","*.PNG","*.bmp","*.BMP"])
      @ar_img_file_globstrings.concat(["*.pnm","*.PNM","*.cur","*.CUR"])
      @ar_img_file_globstrings.concat(["*.icon","*.ICON","*.dng","*.DNG"])
      @ar_img_file_globstrings.concat(["*.miff","*.MIFF","*.palm","*.PALM"])
      @ar_img_file_globstrings.concat(["*.jp2","*.JP2","*.sun","*.SUN"])
      @ar_img_file_globstrings.concat(["*.xpm","*.XPM","*.xbm","*.XBM"])
      @ar_img_file_globstrings.concat(["*.tiff","*.TIFF","*.vicar","*.VICAR"])
   end #initialize

   private

   public

   #-----------------------------------------------------------------------

   # The content of the ht_out will not be cleared, but it will be
   # overwritten. The ht_out exists for instance reuse.
   #
   # Keys of the output hashtable: b_is_imagefile, i_width, i_height, s_fp
   #
   # If b_is_imagefile==false, then i_width and i_heigth may be undefined
   # or have sone unspecified values.
   #
   def ht_image_info(s_image_file_full_path, ht_out=Hash.new)
      bn=binding()
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck bn, String, s_image_file_full_path
         kibuvits_typecheck bn, Hash, ht_out
         ht_stdstreams=sh("which identify ")
         s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
         if s_stdout.length==0
            kibuvits_throw("\nThe ImageMagick command line tool, \"identify\", "+
            "is not at the PATH.\nGUID=='1233bde1-6a77-40d3-b27e-63c230114dd7'\n")
         end # if
      end # if
      s_language=$kibuvits_lc_English
      kibuvits_assert_string_min_length(bn,s_image_file_full_path,3,
      "\nGUID=='13a86523-3d0f-4e30-b37e-63c230114dd7'\n")

      s_spec="is_file,readable"
      ht_failures=Kibuvits_fs.verify_access(s_image_file_full_path,s_spec)
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures,
      s_language,b_throw=true)
      s_message_id="file_access"
      if ht_failures.length!=0
         s_err_msg=Kibuvits_fs.access_verification_results_to_string(
         ht_failures,s_language)+"\nGUID=='5ebdd362-23a1-4d86-927e-63c230114dd7'\n"
         kibuvits_throw(s_err_msg)
      end # if

      s_fp=Pathname.new(s_image_file_full_path).realpath.to_s
      ht_out[$kibuvits_lc_s_fp]=s_fp

      s_fp_cmd=Kibuvits_str.s_escape_for_bash_t1(s_fp)
      ht_stdstreams=sh("identify "+s_fp_cmd)
      s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
      s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]

      ht_out[$kibuvits_lc_b_is_imagefile]=true
      if (s_stderr.match("no decode delegate"))!=nil
         ht_out[$kibuvits_lc_b_is_imagefile]=false
         return ht_out
      end # if

      if 0<s_stderr.length
         s_err_msg="\ns_stderr=="+s_stderr+
         "\nGUID=='e0baf04d-c47b-411d-917e-63c230114dd7'\n"
         kibuvits_throw(s_err_msg)
      end # if

      # Sample output:
      #./uhuu.bmp BMP 3264x2448 3264x2448+0+0 8-bit DirectClass 23.97MB 0.040u 0:00.050
      rgx_size=/[\s][\d]+x[\d]+[\s]/
      md=s_stdout.match(rgx_size)
      if md==nil
         s_err_msg="\nmd==nil\nGUID=='374dea71-627e-4cd4-817e-63c230114dd7'\n"
         kibuvits_throw(s_err_msg)
      end # if

      s_size_haystack=md[0] # " 3264x2448 "
      i_0=s_size_haystack.index("x")
      # http://longterm.softf1.com/specifications/array_indexing_by_separators/
      ixs_high=i_0
      ixs_low=1
      if ixs_high<=ixs_low
         s_err_msg="ixs_high == "+ixs_high.to_s+" <= ixs_low == "+ixs_low.to_s+
         "\nGUID=='4a9e0c94-63be-4f61-a27e-63c230114dd7'\n"
         kibuvits_throw(s_err_msg)
      end # if
      s_width=s_size_haystack[ixs_low,(ixs_high-1)]
      ht_out[$kibuvits_lc_i_width]=s_width.to_i

      ixs_low=i_0+1 # +1 due to the "x"
      ixs_high=s_size_haystack.length-1 # -1 due to the ending space
      if ixs_high<=ixs_low
         s_err_msg="ixs_high == "+ixs_high.to_s+" <= ixs_low == "+ixs_low.to_s+
         "\nGUID=='04ccce38-8dde-442e-b27e-63c230114dd7'\n"
         kibuvits_throw(s_err_msg)
      end # if
      s_height=s_size_haystack[ixs_low,(ixs_high-1)]
      ht_out[$kibuvits_lc_i_height]=s_height.to_i
      return ht_out
   end # ht_image_info

   def Kibuvits_ImageMagick.ht_image_info(s_image_file_full_path,ht_out=Hash.new)
      ht_out=Kibuvits_ImageMagick.instance.ht_image_info(
      s_image_file_full_path,ht_out)
      return ht_out
   end # Kibuvits_ImageMagick.ht_image_info(s_image_file_full_path)

   #-----------------------------------------------------------------------

   # The writable output folder must exist before this method is
   # is called.
   def apply_width_and_height_limits(i_max_width,i_max_height,
      s_output_folder_full_path,s_input_folder_full_path,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, [Fixnum,Bignum], i_max_width
         kibuvits_typecheck bn, [Fixnum,Bignum], i_max_height
         kibuvits_typecheck bn, String, s_output_folder_full_path
         kibuvits_typecheck bn, String, s_input_folder_full_path
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs

         ht_stdstreams=sh("which convert ")
         s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
         if s_stdout.length==0
            kibuvits_throw("\nThe ImageMagick command line tool, \"convert\", "+
            "is not at the PATH.\nGUID=='3034821a-3cf7-43ad-816e-63c230114dd7'\n")
         end # if
      end # if
      s_language=$kibuvits_lc_English

      s_spec="is_directory,writable"
      ht_failures=Kibuvits_fs.verify_access(s_output_folder_full_path,s_spec)
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures,
      s_language,b_throw=true)
      s_message_id="file_access"
      if ht_failures.length!=0
         s_err_msg=Kibuvits_fs.access_verification_results_to_string(
         ht_failures,s_language)+"\n\n"
         s_location_marker_GUID="3b86ba51-4091-4bd4-827e-63c230114dd7"
         b_failure=true
         s_default_language=$kibuvits_lc_English
         msgcs.cre(s_err_msg,s_message_id,b_failure,s_default_language,
         s_location_marker_GUID)
         return
      end # if

      s_spec="is_directory,readable"
      ht_failures=Kibuvits_fs.verify_access(s_input_folder_full_path,s_spec)
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_failures,
      s_language,b_throw=true)
      s_message_id="file_access"
      if ht_failures.length!=0
         s_err_msg=Kibuvits_fs.access_verification_results_to_string(
         ht_failures,s_language)+"\n\n"
         s_location_marker_GUID="87063146-f9d7-4a39-a37e-63c230114dd7"
         b_failure=true
         s_default_language=$kibuvits_lc_English
         msgcs.cre(s_err_msg,s_message_id,b_failure,s_default_language,
         s_location_marker_GUID)
         return
      end # if

      # The Pathname part is for normalization. The path
      # prefix must be normalized to make sure that the string
      # replacement works (properly).
      ob_pth_in=Pathname.new(s_input_folder_full_path).realpath
      s_fp_infolder=ob_pth_in.to_s
      b_return_long_paths=true
      ar_fp_in=Kibuvits_fs.ar_glob_recursively_t1(s_fp_infolder,
      @ar_img_file_globstrings, b_return_long_paths)

      ob_pth_out=Pathname.new(s_output_folder_full_path).realpath
      s_fp_outfolder=ob_pth_out.to_s

      s_fp_in_corrected=nil
      s_fp_in_corrected_cmdv=nil
      s_fp_out=nil
      s_fp_out_cmdv=nil
      s_fp_out_parent=nil
      s_fp_out_parent_cmdv=nil
      ht_info=Hash.new
      s_default_language=$kibuvits_lc_English
      i_width=nil
      i_height=nil
      i_width_new=nil
      i_height_new=nil
      b_scale_by_width=nil
      b_scaled=nil
      cmd=nil
      ht_stdstreams=nil
      s_stderr=nil
      ar_fp_in.each do |s_fp_in|
         if KIBUVITS_b_DEBUG
            if File.directory? s_fp_in
               kibuvits_throw("\nThe code is flawed. The recursive globbing "+
               "should never return folder paths. "+
               "\nGUID=='326ab534-f27c-4b00-816e-63c230114dd7'\n")
            end # if
         end # if
         if !File.readable? s_fp_in
            s_err_msg="\n\""+s_fp_in+"\"\nis a file, but it is not readable.\n"
            s_location_marker_GUID="32f56982-1b9b-4d85-a37e-63c230114dd7"
            b_failure=true
            msgcs.cre(s_err_msg,s_message_id,b_failure,s_default_language,
            s_location_marker_GUID)
            return
         end # if
         s_fp_in_corrected=Pathname.new(s_fp_in).realpath.to_s
         ht_image_info(s_fp_in_corrected, ht_info)
         if ht_info[$kibuvits_lc_b_is_imagefile]!=true
            s_err_msg="\nFile with a path of \n"+s_fp_in_corrected+
            "\n is not an image file.\n"
            s_location_marker_GUID="4953a7b2-6e14-4b1d-8a7e-63c230114dd7"
            b_failure=true
            s_message_id="file_type"
            msgcs.cre(s_err_msg,s_message_id,b_failure,s_default_language,
            s_location_marker_GUID)
            return
         end # if

         b_scaled=false
         i_width_new=ht_info[$kibuvits_lc_i_width]
         i_height_new=ht_info[$kibuvits_lc_i_height]
         if i_max_width<i_width_new
            b_scale_by_width=true
            i_width_new,i_height_new=Kibuvits_coords.i_i_scale_rectangle(
            i_width_new,i_height_new, i_max_width,b_scale_by_width)
            b_scaled=true
         end # if
         if i_max_height<i_height_new
            b_scale_by_width=false
            i_width_new,i_height_new=Kibuvits_coords.i_i_scale_rectangle(
            i_width_new,i_height_new,i_max_height,b_scale_by_width)
            b_scaled=true
         end # if

         s_fp_out=s_fp_in_corrected.sub(s_fp_infolder,s_fp_outfolder)
         s_fp_out_cmdv=Kibuvits_str.s_escape_for_bash_t1(s_fp_out)
         s_fp_in_corrected_cmdv=Kibuvits_str.s_escape_for_bash_t1(s_fp_in_corrected)

         s_fp_out_parent=Pathname.new(s_fp_out).parent.to_s
         if !File.exists? s_fp_out_parent
            s_fp_out_parent_cmdv=Kibuvits_str.s_escape_for_bash_t1(s_fp_out_parent)
            cmd="mkdir -p "+s_fp_out_parent_cmdv+$kibuvits_lc_spacesemicolon
            ht_stdstreams=sh(cmd)
            s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
            if 0<s_stderr.length
               kibuvits_throw("\ns_stderr=="+s_stderr+
               "\ncmd=="+cmd+
               "\nGUID=='e7090559-8894-471a-936e-63c230114dd7'\n")
            end # if
         end # if

         if b_scaled
            cmd="convert "+s_fp_in_corrected_cmdv+" -adaptive-resize "+
            i_width_new.to_s+"x"+i_height_new.to_s+"! "+
            s_fp_out_cmdv+$kibuvits_lc_spacesemicolon
         else
            cmd="cp -f "+s_fp_in_corrected_cmdv+
            $kibuvits_lc_space+s_fp_out_cmdv+$kibuvits_lc_spacesemicolon
         end # if
         ht_stdstreams=sh(cmd)
         s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
         if 0<s_stderr.length
            kibuvits_throw("\ns_stderr=="+s_stderr+
            "\ncmd=="+cmd+
            "\ns_fp_in_corrected_cmdv=="+s_fp_in_corrected_cmdv.to_s+
            "\ns_fp_out_cmdv=="+s_fp_out_cmdv.to_s+
            "\nGUID=='1308a823-bdd0-4fa0-936e-63c230114dd7'\n")
         end # if
      end # loop
   end # apply_width_and_height_limits


   def Kibuvits_ImageMagick.apply_width_and_height_limits(
      i_max_width,i_max_height,s_output_folder_full_path,
      s_input_folder_full_path,msgcs)
      Kibuvits_ImageMagick.instance.apply_width_and_height_limits(
      i_max_width,i_max_height,s_output_folder_full_path,
      s_input_folder_full_path,msgcs)
   end # Kibuvits_ImageMagick.apply_width_and_height_limits


   public
   include Singleton

end # class Kibuvits_ImageMagick

#==========================================================================
