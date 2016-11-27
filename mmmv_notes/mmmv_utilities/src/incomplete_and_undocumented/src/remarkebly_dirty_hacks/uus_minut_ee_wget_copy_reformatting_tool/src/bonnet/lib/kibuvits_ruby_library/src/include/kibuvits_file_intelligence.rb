#!/usr/bin/env ruby
#=========================================================================
=begin

 Copyright 2010, martin.vahi@softf1.com that has an
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
   ob_pth_1=ob_pth_0.parent.parent.parent
   s_KIBUVITS_HOME_b_fs=ob_pth_1.to_s
   require(s_KIBUVITS_HOME_b_fs+"/src/include/kibuvits_boot.rb")
   ob_pth_0=nil; ob_pth_1=nil; s_KIBUVITS_HOME_b_fs=nil
end # if

require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"

#==========================================================================

# The class Kibuvits_file_intelligence is for various
# meta-data like cases, like inferring file format by
# its extension, etc.
class Kibuvits_file_intelligence

   def initialize
   end # initialize

   # Returns a string.
   def file_language_by_file_extension(s_file_path,msgcs)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_file_path
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ar_tokens=Kibuvits_str.ar_bisect(s_file_path.reverse, '.')
      s_file_extension=ar_tokens[0].reverse.downcase
      s_file_language=$kibuvits_lc_undetermined
      case s_file_extension
      when "js"
         s_file_language="JavaScript"
      when "rb"
         s_file_language="Ruby"
      when "py"
         s_file_language="Python"
      when "php"
         s_file_language="PHP"
      when "h"
         s_file_language="C"
      when "hpp"
         s_file_language="C++"
      when "c"
         s_file_language="C"
      when "cpp"
         s_file_language="C++"
      when "hs"
         s_file_language="Haskell"
      when "java"
         s_file_language="Java"
      when "scala"
         s_file_language="Scala"
      when "bash"
         s_file_language="Bash"
      when "reduce"
         s_file_language="REDUCE"
      when "html"
         s_file_language="HTML"
      when "xml"
         s_file_language="XML"
      when "htaccess"
         s_file_language="htaccess"
      else
         msgcs.cre "Either the file extension is not supported or "+
         "the file extension extraction failed.\n"+
         "File extension candidate is: "+s_file_extension, 1.to_s
         msgcs.last[$kibuvits_lc_Estonian]="Faililaiend on kas toetamata või ei õnnestunud "+
         "faililaiendit eraldada. \n"+
         "Faililaiendi kandidaat on:"+s_file_extension
      end # case
      return s_file_language
   end # file_language_by_file_extension

   def Kibuvits_file_intelligence.file_language_by_file_extension(
      s_file_path, msgcs)
      s_file_language=Kibuvits_file_intelligence.instance.file_language_by_file_extension(
      s_file_path, msgcs)
      return s_file_language
   end # Kibuvits_file_intelligence.file_language_by_file_extension

   #--------------------------------------------------------------------------

   def exm_b_files_have_bitwise_equal_content_t1(s_fp_file_1,s_fp_file_2,
      msgcs=nil)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String, s_fp_file_1
         kibuvits_typecheck bn, String, s_fp_file_2
         kibuvits_typecheck bn, [NilClass,Kibuvits_msgc_stack], msgcs
      end # if
      #----------------
      b_throw_on_failure=true
      if msgcs.class==Kibuvits_msgc_stack
         b_throw_on_failure=false
      else
         msgcs=Kibuvits_msgc_stack.new
      end # if
      #----------------
      rgx=/[\/]+/
      s_fp_1=s_fp_file_1.gsub(rgx,$kibuvits_lc_slash)
      s_fp_2=s_fp_file_2.gsub(rgx,$kibuvits_lc_slash)
      #----------------
      ht_test_failures=Kibuvits_fs.verify_access([s_fp_1,s_fp_1],
      "readable,is_file")
      s_output_message_language=$kibuvits_lc_English
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
      s_output_message_language,b_throw_on_failure,msgcs)
      return false if msgcs.b_failure
      #----------------
      i_size_1=File.size(s_fp_1)
      i_size_2=File.size(s_fp_2)
      return false if i_size_1!=i_size_2 # more frequent than
      return true if s_fp_1==s_fp_2      # this line
      #--------------
      cmd="diff --brief "+s_fp_1+$kibuvits_lc_space+s_fp_2
      ht_stdstreams=kibuvits_sh(cmd)
      Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
      "GUID='b511848c-2116-4d08-abea-e1a190611fd7'\n")
      s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
      return false if 0<s_stdout.length
      return true
   end # exm_b_files_have_bitwise_equal_content_t1

   def Kibuvits_file_intelligence.exm_b_files_have_bitwise_equal_content_t1(
      s_fp_file_1,s_fp_file_2,msgcs=nil)
      b_out=Kibuvits_file_intelligence.instance.exm_b_files_have_bitwise_equal_content_t1(
      s_fp_file_1,s_fp_file_2,msgcs)
      return b_out
   end # Kibuvits_file_intelligence.exm_b_files_have_bitwise_equal_content_t1

   #--------------------------------------------------------------------------

   private

   # Returns destination file or folder path or the path
   # of an existing, older, back-up file, if
   # one of the older back-up files has the same
   # content as the original. The current version
   # always forces folders to be re-backed up, because
   # the FileUtils.compare_file does not work with folders.
   #
   # TODO: Fix the exm_s_create_backup_copy_t1_create_s_fp_dest
   # so that it will not force folders to be recursively
   # backed up if the content of the backup equals with the
   # original.
   def exm_s_create_backup_copy_t1_create_s_fp_dest(
      s_fp_dest_parent_folder,s_backup_prefix,
      s_fp_file_or_folder,b_throw_on_failure,msgcs)
      if KIBUVITS_b_DEBUG
         # A bit of an overkill, but helps to locate problems.
         bn=binding()
         kibuvits_typecheck bn, String, s_fp_dest_parent_folder
         kibuvits_typecheck bn, String, s_backup_prefix
         kibuvits_typecheck bn, String, s_fp_file_or_folder
         kibuvits_typecheck bn, [TrueClass,FalseClass], b_throw_on_failure
         kibuvits_typecheck bn, Kibuvits_msgc_stack, msgcs
      end # if
      ar=Kibuvits_str.ar_bisect(s_fp_file_or_folder.reverse,$kibuvits_lc_slash)
      s_fp_forf_name=ar[0].reverse
      i_backup_version=0
      #----------------
      s_token_0=(s_fp_dest_parent_folder+$kibuvits_lc_slash).gsub(
      /[\/]+/,$kibuvits_lc_slash)
      s_token_1=s_fp_forf_name
      s_token_2_version=$kibuvits_lc_underscore+s_backup_prefix+i_backup_version.to_s
      s_token_3_dot_file_extension_if_file=$kibuvits_lc_emptystring
      if !File.directory? s_fp_file_or_folder
         # Supposedly does not match links to folders.
         md=s_fp_forf_name.match(/[.][^.]+$/)
         if md!=nil
            s_dot_file_ext=md[0]
            s_token_1=s_fp_forf_name[0..(-1-s_dot_file_ext.length)]
            s_token_3_dot_file_extension_if_file=s_dot_file_ext
         end # if
      end # if
      s_fp_dest_candidate_0=nil
      s_fp_dest_candidate_1=s_token_0+s_token_1+
      s_token_2_version+s_token_3_dot_file_extension_if_file
      while File.exist? s_fp_dest_candidate_1
         s_fp_dest_candidate_0=s_fp_dest_candidate_1
         i_backup_version=i_backup_version+1
         s_token_2_version=$kibuvits_lc_underscore+
         s_backup_prefix+i_backup_version.to_s
         s_fp_dest_candidate_1=s_token_0+s_token_1+
         s_token_2_version+s_token_3_dot_file_extension_if_file
      end # loop
      if !$kibuvits_var_b_module_fileutils_loaded
         # It's OK to load them more than once, so no need for Mutexes.
         # It just seems to be a corner case, where performance
         # has probably not been very well tested, i.e.
         # usually people do not have loops that try to reload a
         # module thousands of times. Hence this if-clause here.
         require "fileutils"
         $kibuvits_var_b_module_fileutils_loaded=true
      end # if
      return s_fp_dest_candidate_1 if s_fp_dest_candidate_0==nil
      return s_fp_dest_candidate_1 if File.directory? s_fp_file_or_folder
      b_old_backup_is_the_same_as_the_original=FileUtils.compare_file(
      s_fp_dest_candidate_0,s_fp_file_or_folder)
      if b_old_backup_is_the_same_as_the_original
         s_fp_dest_candidate_1=s_fp_dest_candidate_0
      end # if
      return s_fp_dest_candidate_1
   end # exm_s_create_backup_copy_t1_create_s_fp_dest

   public

   # Throws or returns with flaw description, if the destination
   # folder of the backup copy is not writable or the "cp -fr " fails.
   #
   # If the s_fp_backup_destination_folder==".", then the backup
   # copy is placed to the same folder, where the original resides.
   #
   # File extensions are retained. Non-file-extension part of
   # the file or folder name is suffixed with <"_"+s_backup_prefix><integer>.
   #
   # If the creation of the backup copy suceeded, returns
   # the full path of the backup copy. Otherwise returns an empty string.
   def exm_s_create_backup_copy_t1(
      s_fp_file_or_folder,s_fp_backup_destination_folder=$kibuvits_lc_dot,
      msgcs=nil,s_backup_prefix="old_v")
      bn=binding()
      if KIBUVITS_b_DEBUG
         kibuvits_typecheck bn, String, s_fp_file_or_folder
         kibuvits_typecheck bn, String, s_fp_backup_destination_folder
         kibuvits_typecheck bn, [NilClass,Kibuvits_msgc_stack], msgcs
         kibuvits_typecheck bn, String, s_backup_prefix
         if msgcs.class==Kibuvits_msgc_stack
            if msgcs.b_failure
               kibuvits_throw("msgcs.b_failure==true\n"+
               "GUID='83298e18-1793-4500-84ea-e1a190611fd7'\n")
            end # if
         end # if
      end # if
      kibuvits_assert_does_not_contain_common_special_characters_t1(
      bn,s_backup_prefix)
      b_throw_on_failure=true
      if msgcs.class==Kibuvits_msgc_stack
         b_throw_on_failure=false
      else
         msgcs=Kibuvits_msgc_stack.new
      end # if
      #-----------------------
      # TODO: consider refactoring the next check to a separate function
      rgx_0=/[\/]$/
      if s_fp_file_or_folder.match(rgx_0)
         msg="s_fp_file_or_folder == \n"+s_fp_file_or_folder+
         "\nbut the file or folder name is not allowed to end with a slash\n"
         if b_throw_on_failure
            kibuvits_throw(msg+
            "GUID='1d44445f-463f-4599-a2ea-e1a190611fd7'\n")
         else
            s_default_msg=msg
            s_message_id="e_0"
            b_failure=true
            s_location_marker_GUID="3d53e505-502f-4649-a6ea-e1a190611fd7"
            msgcs.cre(s_default_msg,s_message_id,
            b_failure,s_location_marker_GUID)
            return $kibuvits_lc_emptystring
         end # if
      end # if
      #-----------------------
      Kibuvits_fs.verify_access(s_fp_file_or_folder,"readable",msgcs)
      if msgcs.b_failure
         kibuvits_throw(msgcs.to_s+$kibuvits_lc_linebreak+
         "GUID='6907893b-eb9c-4447-a5da-e1a190611fd7'\n")
      end # if
      s_fp_dest_parent_folder=nil
      if s_fp_backup_destination_folder==$kibuvits_lc_dot
         s_fp=nil
         begin
            s_fp=Pathname.new(s_fp_file_or_folder).realpath.parent.to_s
         rescue Exception => e
            # It might be that the file or folder does
            # not exist and if that's the case, the "realpath"
            # part of the s_fp=... line throws.
            if b_throw_on_failure
               kibuvits_throw(e.to_s+$kibuvits_lc_linebreak+
               "GUID='153f1243-5b13-4ba4-91da-e1a190611fd7'\n")
            else
               s_default_msg=e.to_s
               s_message_id="e_1"
               b_failure=true
               s_location_marker_GUID="f63d5f19-95d6-47a4-a2ea-e1a190611fd7"
               msgcs.cre(s_default_msg,s_message_id,
               b_failure,s_location_marker_GUID)
               return $kibuvits_lc_emptystring
            end # if
         end # rescue
         Kibuvits_fs.verify_access(s_fp,"is_directory,writable",msgcs)
         if msgcs.b_failure
            if b_throw_on_failure
               kibuvits_throw(msgcs.to_s+$kibuvits_lc_linebreak+
               "GUID='019f5610-fc4f-4ca0-81da-e1a190611fd7'\n")
            else
               return $kibuvits_lc_emptystring
            end # if
         end # if
         s_fp_dest_parent_folder=s_fp
      else # s_fp_backup_destination_folder != $kibuvits_lc_dot
         Kibuvits_fs.verify_access(s_fp_backup_destination_folder,
         "is_directory,writable",msgcs)
         if msgcs.b_failure
            if b_throw_on_failure
               kibuvits_throw(msgcs.to_s+$kibuvits_lc_linebreak+
               "GUID='92ab6615-7d7b-4743-a2da-e1a190611fd7'\n")
            else
               return $kibuvits_lc_emptystring
            end # if
         end # if
         s_fp_dest_parent_folder=s_fp_backup_destination_folder
      end # if
      #-----------------------
      s_fp_backup_copy=exm_s_create_backup_copy_t1_create_s_fp_dest(
      s_fp_dest_parent_folder,s_backup_prefix,
      s_fp_file_or_folder,b_throw_on_failure,msgcs)
      #----
      if msgcs.b_failure
         if b_throw_on_failure
            kibuvits_throw(msgcs.to_s+$kibuvits_lc_linebreak+
            "GUID='30e91938-7739-496c-b1da-e1a190611fd7'\n")
         else
            return $kibuvits_lc_emptystring
         end # if
      end # if
      #-----------------------
      return s_fp_backup_copy if File.exists? s_fp_backup_copy
      cmd=("cp -f -R "+s_fp_file_or_folder)+($kibuvits_lc_space+s_fp_backup_copy)
      ht_stdstreams=kibuvits_sh(cmd)
      s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
      if 0<s_stderr.length
         if b_throw_on_failure
            Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
            "GUID='17a76d61-390e-41fd-98da-e1a190611fd7'\n")
         else
            s_default_msg=s_stderr
            s_message_id="e_2"
            b_failure=true
            s_location_marker_GUID="a05fd03d-dc7b-4447-82da-e1a190611fd7"
            msgcs.cre(s_default_msg,s_message_id,
            b_failure,s_location_marker_GUID)
            return $kibuvits_lc_emptystring
         end # if
      end # if
      return s_fp_backup_copy
   end # exm_s_create_backup_copy_t1

   def Kibuvits_file_intelligence.exm_s_create_backup_copy_t1(
      s_fp_file_or_folder,s_fp_backup_destination_folder=$kibuvits_lc_dot,
      msgcs=nil,s_backup_prefix="old_v")
      s_fp_backup_copy=Kibuvits_file_intelligence.instance.exm_s_create_backup_copy_t1(
      s_fp_file_or_folder,s_fp_backup_destination_folder,
      msgcs,s_backup_prefix)
      return s_fp_backup_copy
   end # Kibuvits_file_intelligence.exm_s_create_backup_copy_t1

   #----------------------------------------------------------------------

   private

   def s_get_MIME_type_impl_unix(s_fp)
      if !defined? @s_lc_s_get_MIME_type_const_1
         # The "file --mime-type " works on boty, Linux and FreeBSD.
         @s_lc_s_get_MIME_type_const_1="file --mime-type ".freeze
      end # if
      s_fp_normalized=s_fp.gsub(/[\/]+/,$kibuvits_lc_slash)
      cmd=@s_lc_s_get_MIME_type_const_1+s_fp_normalized
      ht_stdstreams=kibuvits_sh(cmd)
      Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams,
      "GUID='8ee2e9d2-d2b4-4ff4-82da-e1a190611fd7'\n")
      s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
      #----------------
      # Command
      #
      #     file --mime-type ./uu.txt
      #
      # returns:
      #
      #     startofline./uu.txt: blablamimetype
      #
      s_0=s_stdout[(s_fp_normalized.length+2)..(-1)]
      s_out=s_0.gsub(/[\s\t\n\r]+$/,$kibuvits_lc_emptystring)
      return s_out
   end # s_get_MIME_type_impl_unix

   public

   # Text files that have application format
   # specific content have different MIME types.
   # For example, the MIME type of a Ruby source
   # file differs from a MIME type of a text
   # file that contains armoured GNU Privacy Guard message.
   def s_get_MIME_type(s_fp)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String,s_fp
         #--------
         ht_test_failures=Kibuvits_fs.verify_access(s_fp,"readable")
         s_output_message_language=$kibuvits_lc_English
         b_throw=true
         Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_test_failures,
         s_output_message_language,b_throw,
         "GUID='020d062e-43b7-4d00-84da-e1a190611fd7'")
      end # if
      s_ostype=Kibuvits_os_codelets.get_os_type
      s_out=nil
      if s_ostype==$kibuvits_lc_kibuvits_ostype_unixlike
         s_out=s_get_MIME_type_impl_unix(s_fp)
      else
         kibuvits_throw("Operating system type \n\""+
         s_ostype+"\" is not yet supported by this function.\n"+
         "GUID='7d60b23c-5522-4014-95da-e1a190611fd7'")
      end # if
      return s_out
   end # s_get_MIME_type


   def Kibuvits_file_intelligence.s_get_MIME_type(s_fp)
      s_out=Kibuvits_file_intelligence.instance.s_get_MIME_type(s_fp)
      return s_out
   end # Kibuvits_file_intelligence.s_get_MIME_type

   #--------------------------------------------------------------------------

   # Returns true only, if it is certain that the MIME type, s_mimetype,
   # refers to a binary file format. Otherwise returns false.
   #
   # The s_mimetype might be acquired by using the s_get_MIME_type(...).
   #
   def b_mimetype_certainly_refers_to_a_binary_format_t1(s_mimetype)
      if KIBUVITS_b_DEBUG
         bn=binding()
         kibuvits_typecheck bn, String,s_mimetype
         #--------
         i_len_orig=s_mimetype.length
         i_len_modif=s_mimetype.sub(/[\/]/,$kibuvits_lc_emptystring).length
         if i_len_orig==i_len_modif
            kibuvits_throw("s_mimetype == "+s_mimetype+
            "\nis not a MIME type, because it does not contain the \n"+
            "slash character (\"/\").\n"+
            "GUID='e0214f3b-8cfd-4a0f-b5da-e1a190611fd7'\n\n")
         end # if
         #--------
      end # if
      ht_yes=nil
      if !defined? @ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1
         @ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1=Hash.new
         ht_yes=@ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1
         #------------------
         # http://www.freeformatter.com/mime-types-list.html
         #------------------
         ht_yes["image/jpeg"]=42
         ht_yes["image/gif"]=42
         ht_yes["image/png"]=42
         ht_yes["image/bmp"]=42
         ht_yes["image/webp"]=42
         ht_yes["image/tiff"]=42
         ht_yes["application/octet-stream"]=42 # BMP image files and LibreOffice odb files.
         ht_yes["image/x-icon"]=42
         ht_yes["image/x-xcf"]=42 # Gimp files
         ht_yes["image/x-pcx"]=42
         ht_yes["image/x-rgb"]=42
         ht_yes["image/x-xbitmap"]=42
         ht_yes["image/x-xpixmap"]=42
         ht_yes["image/prs.btif"]=42
         ht_yes["image/x-xwindowdump"]=42
         ht_yes["image/x-portable-pixmap"]=42
         ht_yes["image/x-portable-graymap"]=42
         ht_yes["image/x-portable-anymap"]=42
         ht_yes["image/x-portable-bitmap"]=42
         ht_yes["image/x-pict"]=42
         ht_yes["image/x-cmu-raster"]=42
         ht_yes["image/vnd.dxf"]=42 # AutoCad?
         ht_yes["image/vnd.wap.wbmp"]=42
         ht_yes["image/vnd.djvu"]=42
         ht_yes["image/vnd.dwg"]=42
         ht_yes["image/vnd.fujixerox.edmics-mmr"]=42
         ht_yes["image/vnd.fujixerox.edmics-rlc"]=42
         ht_yes["image/vnd.xiff"]=42
         ht_yes["image/vnd.fastbidsheet"]=42
         ht_yes["image/vnd.fpx"]=42
         ht_yes["image/vnd.net-fpx"]=42
         ht_yes["image/vnd.adobe.photoshop"]=42
         ht_yes["image/vnd.dece.graphic"]=42
         #-----
         # According to the
         #
         #     http://longterm.softf1.com/specifications/third_party/MIDI_file_format/Standard_MIDI_file_format_spec_1_1_by_David_Back.pdf
         #
         # the MIDI file format is a binary format.
         ht_yes["audio/midi"]=42
         #-----
         ht_yes["audio/basic"]=42  # Sun audio file
         ht_yes["audio/x-wav"]=42
         ht_yes["audio/adpcm"]=42
         ht_yes["audio/x-aac"]=42
         ht_yes["audio/x-aiff"]=42
         ht_yes["audio/vnd.dece.audio"]=42
         ht_yes["audio/x-pn-realaudio"]=42
         ht_yes["audio/mp4"]=42
         ht_yes["audio/mpeg"]=42
         ht_yes["audio/webm"]=42
         ht_yes["audio/ogg"]=42
         ht_yes["application/ogg"]=42
         ht_yes["audio/vnd.dece.audio"]=42
         ht_yes["audio/x-ms-wma"]=42
         #-----
         ht_yes["video/mp4"]=42
         ht_yes["application/mp4"]=42
         ht_yes["video/ogg"]=42
         ht_yes["video/webm"]=42
         ht_yes["video/jpm"]=42
         ht_yes["video/jpeg"]=42
         ht_yes["video/mpeg"]=42
         ht_yes["video/mj2"]=42
         ht_yes["video/x-ms-wm"]=42    # Microsoft
         ht_yes["video/x-ms-wmv"]=42   # Microsoft
         ht_yes["video/x-msvideo"]=42  # avi format
         ht_yes["video/h264"]=42
         ht_yes["video/h263"]=42
         ht_yes["video/h261"]=42
         ht_yes["video/x-flv"]=42  # Flash
         ht_yes["video/x-f4v"]=42  # Flash
         ht_yes["video/3gpp"]=42
         ht_yes["video/3gpp2"]=42
         ht_yes["video/vnd.dece.hd"]=42
         ht_yes["video/vnd.dece.mobile"]=42
         ht_yes["video/vnd.dece.pd"]=42
         ht_yes["video/vnd.dece.sd"]=42
         ht_yes["video/vnd.dece.video"]=42
         ht_yes["video/vnd.uvvu.mp4"]=42
         ht_yes["application/x-dvi"]=42
         ht_yes["video/vnd.fvt"]=42
         ht_yes["video/x-fli"]=42
         ht_yes["video/x-m4v"]=42
         ht_yes["video/quicktime"]=42
         ht_yes["video/x-sgi-movie"]=42
         #-----
         # Fonts
         ht_yes["application/x-font-ttf"]=42
         ht_yes["application/x-font-otf"]=42
         ht_yes["application/x-font-bdf"]=42
         ht_yes["application/x-font-woff"]=42 # Web Open Font Format
         ht_yes["application/x-font-pcf"]=42
         ht_yes["application/font-tdpfr"]=42
         ht_yes["application/x-font-type1"]=42        # PostScript Fonts
         ht_yes["application/x-font-ghostscript"]=42
         ht_yes["application/x-font-linux-psf"]=42
         ht_yes["application/x-font-snf"]=42
         ht_yes[""]=42
         #-----
         ht_yes["application/x-tar"]=42
         ht_yes["application/x-gzip"]=42
         ht_yes["application/zip"]=42
         ht_yes["application/x-bzip2"]=42
         ht_yes["application/x-xz"]=42
         ht_yes["application/x-7z-compressed"]=42
         #-----
         ht_yes["application/pdf"]=42
         ht_yes["application/x-hdf"]=42 # The HDF
         ht_yes["application/x-debian-package"]=42
         #------------------
         # LibreOffice formats:
         ht_yes["application/vnd.oasis.opendocument.graphics"]=42
         ht_yes["application/vnd.oasis.opendocument.spreadsheet"]=42
         ht_yes["application/vnd.oasis.opendocument.formula"]=42
         ht_yes["application/vnd.oasis.opendocument.text"]=42
         ht_yes["application/vnd.oasis.opendocument.presentation"]=42
         #------------------
         # Microsoft:
         ht_yes["application/msword"]=42
         ht_yes["application/vnd.ms-powerpoint"]=42
         ht_yes["application/x-mswrite"]=42 # Microsoft Wordpad
         ht_yes["application/x-msaccess"]=42
         #------------------
         ht_yes["application/x-executable"]=42
         #------------------
         #ht_yes[""]=42
         ht_yes.freeze
      else
         ht_yes=@ht_yes_b_mimetype_certainly_refers_to_a_binary_format_t1
      end # if
      b_out=ht_yes.has_key? s_mimetype
      return b_out
   end # b_mimetype_certainly_refers_to_a_binary_format_t1


   def Kibuvits_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1(s_mimetype)
      b_out=Kibuvits_file_intelligence.instance.b_mimetype_certainly_refers_to_a_binary_format_t1(s_mimetype)
      return b_out
   end # Kibuvits_file_intelligence.b_mimetype_certainly_refers_to_a_binary_format_t1

   #--------------------------------------------------------------------------

   include Singleton

end # class Kibuvits_file_intelligence

#==========================================================================
