#!/usr/bin/env ruby
#==========================================================================
# Initial author: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================
require 'pathname'

ob_pth_0=Pathname.new(__FILE__).realpath
KIBUVITS_HOME=ob_pth_0.parent.to_s+"/bonnet/lib/kibuvits_ruby_library"

require(KIBUVITS_HOME+"/src/include/kibuvits_all.rb")

#--------------------------------------------------------------------------
# This code uses the old, outdated, Kibuvits Ruby Library (KRL) API.

class Muudan_uus_minut_ee_wget_koopiat_t1

   def initialize
      @b_inited_0=false
      @mx_0=Mutex.new
   end # initialize

   #-----------------------------------------------------------------------
   private

   def exc_s_get_folder_path_of_the_modyfiable_copy
      # Very lazy and rudimentary verification,
      # if it even deserves that kind of a ancy word at all.
      if ARGV.size==0
         raise Exception.new("\n\nARGV.size==0 ehk \n"+
         "palun lisada muudetava wget-koopia kataloogirada.\n\n")
      end # if
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(
      ARGV[0].to_s, "is_directory")
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures,
      s_output_message_language=$kibuvits_lc_English,
      b_throw=true,s_optional_error_message_suffix=nil)
      #--------
      s_fp=ARGV[0]
      ht_stdstreams=kibuvits_sh("chmod -f -R 0700 "+s_fp)
      Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams)
      return s_fp
   end # exc_s_get_folder_path_of_the_modyfiable_copy

   #-----------------------------------------------------------------------

   def exc_verify_html_file_access_t1(s_fp_or_ar_of_fp)
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(
      s_fp_or_ar_of_fp, "is_file,writable,readable")
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(
      ht_filesystemtest_failures,
      s_output_message_language=$kibuvits_lc_English,
      b_throw=true,s_optional_error_message_suffix=nil)
   end # exc_verify_html_file_access_t1(s_fp)

   #-----------------------------------------------------------------------

   # Returns a stirng, were there is one path per line
   # and no empty lines.
   def ar_create_list_of_file_paths()
      #--------
      s_fp_folder_to_modify=exc_s_get_folder_path_of_the_modyfiable_copy()
      ar_out=Array.new
      #--------
      s_fp_tmp=nil
      func_erase_tmp_file=lambda do
         if s_fp_tmp.class==String
            File.delete(s_fp_tmp) if File.exists? s_fp_tmp
         end # if
      end # func_erase_tmp_file
      #----
      s_0=nil
      begin
         s_fp_tmp=Kibuvits_os_codelets.generate_tmp_file_absolute_path();
         cmd="find "+s_fp_folder_to_modify+" -name '*index.html*' > "+s_fp_tmp
         ht_stdstreams=kibuvits_sh(cmd)
         Kibuvits_shell.throw_if_stderr_has_content_t1(ht_stdstreams)
         s_lines=file2str(s_fp_tmp).gsub(/^[\n\r]$/,$kibuvits_lc_emptystring)
         func_erase_tmp_file.call()
         #----
         rgx=/[\n\r]$/
         s_lines.each_line do |s_line|
            s_0=s_line.gsub(rgx,$kibuvits_lc_emptystring)
            ar_out<<s_0
         end # loop
         exc_verify_html_file_access_t1(ar_out)
      rescue Exception=>e
         func_erase_tmp_file.call()
         puts "\n\n"
         raise e
      end # rescue
      #--------
      return ar_out
   end # ar_create_list_of_file_paths

   #-----------------------------------------------------------------------

   # For the sake of simplicity it is designed for
   # a single-threaded application. The Mutex stuff
   # is just to keep the innefficient code working
   # correctly if shomeone, for whatever miraculous reason,
   # should ever want to make this hacky thing
   # work with multiple threads.
   def s_apply_modifications(s_file_content_in,
      s_output_mode,ht_file_rename_relations,ht_needle2subst)
      #--------
      s_out=nil
      @mx_0.synchronize do
         if !@b_inited_0
            @ar_rgx_0=Array.new
            @ar_s_subst_0=Array.new
            @ar_rgx_1=Array.new
            @ar_s_subst_1=Array.new
            #---------
            # index.html?p=2192 -> index.html%3Fp=2192
            #           ?p=                  %3Fp=
            #----
            rgx=/[?]p[=]/.freeze
            s_subst="%3Fp=".freeze
            @ar_rgx_0<<rgx
            @ar_s_subst_0<<s_subst
            #@ar_rgx_1<<rgx
            #@ar_s_subst_1<<s_subst
            #---------
            # #006699           -> #eeeeee
            #----
            rgx=/[#]006699/.freeze
            s_subst="#EEEEEE".freeze
            @ar_rgx_0<<rgx
            @ar_s_subst_0<<s_subst
            @ar_rgx_1<<rgx
            @ar_s_subst_1<<s_subst
            #---------
            if @ar_rgx_0.size!=@ar_s_subst_0.size
               raise Exception.new("Faulty code bah-3433")
            end # if
            if @ar_rgx_1.size!=@ar_s_subst_1.size
               raise Exception.new("Faulty code bah-32423")
            end # if
            #---------
            @b_inited_0=true
         end # if
         #---------
         ar_rgx=nil
         s_subst=nil
         s_new=s_file_content_in
         s_old=s_file_content_in
         if s_old==nil
            raise Exception.new("Faulty code bah-i34")
         end # if
         #----
         ar_rgx=nil
         ar_s_subst=nil
         func_apply_substitutions=lambda do
            i_len=ar_rgx.size
            i_len.times do |i| # starts to count from 0
               rgx=ar_rgx[i]
               s_subst=ar_s_subst[i]
               s_new=s_old.gsub(rgx,s_subst)
               s_old=s_new
            end # loop
         end # func_apply_substitutions
         case s_output_mode
         when "serverless"
            ar_rgx=@ar_rgx_0
            ar_s_subst=@ar_s_subst_0
            func_apply_substitutions.call()
         when "for_web_server"
            ar_rgx=@ar_rgx_1
            ar_s_subst=@ar_s_subst_1
            func_apply_substitutions.call()
            #--------
            # if b_needle_is_key==true
            #     ht_needles[<needle string>]==<substitution string>
            # else
            #     ht_needles[<substitution string>]==<array of needle strings>
            ht_needles=ht_needle2subst
            s_haystack=s_old
            b_needle_is_key=true
            s_new=Kibuvits_str.s_batchreplace(ht_needles,s_haystack,b_needle_is_key)
            s_old=s_new
         else
            raise(Exception.new("Faulty code bah-i34"+
            "s_output_mode=="+s_output_mode.to_s))
         end # case s_output_mode
         #----
         s_out=s_new
      end # synchronize
      return s_out
   end # s_apply_modifications

   #-----------------------------------------------------------------------

   def exc_s_determine_output_mode
      #--------
      s_output_mode="serverless"
      i_len=ARGV.size
      return s_output_mode if i_len==1
      raise Exception.new("Faulty code blah-43443.") if i_len==0 #dirty as hell
      ar_allowed_values=["serverless","for_web_server"]
      s_value=ARGV[1].to_s
      b_wrong_value=(!(ar_allowed_values.include? s_value))
      if (2<i_len)||b_wrong_value
         raise Exception.new(
         "\n\nLubatud on maksimaalselt 2 konsooliargumenti:\n"+
         "    1) rada muudetava sisuga kataloogile\n"+
         "    2) väljundireziim: {\"serverless\",\"for_web_server\"}\n\n")
      end # if
      s_output_mode=s_value
   end # exc_s_determine_output_mode

   #-----------------------------------------------------------------------


   def ht_create_file_rename_relations(ar_list_of_file_paths)
      #index.html?p=333 -> index_html_p_equals_333.html
      ar_originals=ar_list_of_file_paths
      ht_full_paths=Hash.new
      ht_needle2subst=Hash.new # key=<needle string> value=<subst. string>
      rgx_0=/index[.]html[?]p=[\d]+$/
      s_subst_00="index_html_p_equals".freeze
      s_subst_0=(s_subst_00+"_X.html").freeze
      s_subst_1=nil
      s_subst_1b=".html".freeze
      rgx_1=/[\d]+$/
      rgx_2=/_X[.]html$/
      s_0=nil
      s_1=nil
      i_0=nil
      md=nil
      s_needle=nil
      s_subst=nil
      ar_originals.each do |s_fp_orig|
         s_0=s_fp_orig.gsub(rgx_0,s_subst_0)
         next if s_0==s_fp_orig
         s_needle=s_fp_orig.match(rgx_0)[0].to_s
         md=s_fp_orig.match(rgx_1)
         raise Exception.new("Faulty code blah-2439.") if md==nil
         i_0=md[0].to_i
         s_subst_1=$kibuvits_lc_underscore+i_0.to_s+s_subst_1b
         s_1=s_0.gsub(rgx_2,s_subst_1)
         ht_full_paths[s_fp_orig]=s_1
         s_subst=s_subst_00+s_subst_1
         ht_needle2subst[s_needle]=s_subst
      end # loop
      return ht_full_paths,ht_needle2subst
   end # ht_create_file_rename_relations

   #-----------------------------------------------------------------------

   public

   def run
      ar_list_of_file_paths=ar_create_list_of_file_paths()
      # The file access of the files at the list
      # has been already verified during the list creation.
      s_output_mode=exc_s_determine_output_mode()
      ht_file_rename_relations=Hash.new # to avoid checking for nil
      ht_needle2subst=Hash.new # to avoid checking for nil
      if s_output_mode=="for_web_server"
         ht_file_rename_relations,ht_needle2subst=ht_create_file_rename_relations(
         ar_list_of_file_paths)
      end # if
      s_0=nil
      s_1=nil
      s_lc_utf8="utf-8"
      i_n_of_unmodified_files=0
      s_fp_new=nil
      ar_list_of_file_paths.each do |s_fp|
         s_0=file2str(s_fp).encode(s_lc_utf8)
         #--------
         next if s_0==nil
         # Sorry, that's the limit of this script.
         # The issue is that for some reason some
         # files have some weird encoding format.
         # The dirty workaround is to just leave them alone.
         #----
         if ht_file_rename_relations.has_key? s_fp
            # Creates a renamed version of the file
            # before the next "next-clause"
            s_fp_new=ht_file_rename_relations[s_fp]
            str2file(s_0,s_fp_new)
         end # if
         #----
         b_leave_the_file_alone=false
         begin
            s_1=s_apply_modifications(
            s_0,s_output_mode,ht_file_rename_relations,ht_needle2subst)
            # In the weird cases it triggers an exception that says something
            # about byte sequences not conforming to UTF-8 format, etc.
         rescue Exception=>e
            if e.to_s.match("invalid byte")==nil
               raise(Exception.new("Double-faulty code blah-23842. "+
               "e.to_s==\n"+e.to_s+"\n\n"))
            end # if
            # That's really dirty, but well,
            # I can not debug/fix the Ruby interpreter.
            b_leave_the_file_alone=true
            i_n_of_unmodified_files=i_n_of_unmodified_files+1
            puts "\nFile not modified:\n"+s_fp
         end # rescue
         next if b_leave_the_file_alone
         #--------
         if (s_1==nil)||(s_1==$kibuvits_lc_emptystring)
            raise Exception.new("Faulty code blah-123.")
         end # if
         #----
         str2file(s_1,s_fp)
         if ht_file_rename_relations.has_key? s_fp
            str2file(s_1,s_fp_new)
         end # if
      end # loop
      i_n_modified=ar_list_of_file_paths.size-i_n_of_unmodified_files
      puts"\n\nThe number of files modified: "+i_n_modified.to_s
      puts"\nThe number of files left unmodified: "+
      i_n_of_unmodified_files.to_s+"\n\n"
   end # run

end # class Muudan_uus_minut_ee_wget_koopiat_t1

#--------------------------------------------------------------------------
ob=Muudan_uus_minut_ee_wget_koopiat_t1.new
ob.run
#==========================================================================
