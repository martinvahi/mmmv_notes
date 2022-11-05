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

#require  KIBUVITS_HOME+"/src/include/kibuvits_coords.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_fs.rb"
require  KIBUVITS_HOME+"/src/include/kibuvits_shell.rb"

#==========================================================================

class Kibuvits_data_transfer

   def initialize
   end #initialize

   #----------------------------------------------------------------------

   # Equivalent to
   #     cp -f -R $s_fp_origin $s_fp_destination_folder/
   def exc_rsync_t1(s_fp_destination_folder,s_fp_origin)
      if !File.exists? s_fp_origin
         kibuvits_throw("\nFile or folder \n"+s_fp_origin+
         "\ndoes not exist. GUID='fc2ecf31-c527-4edf-b4b1-3040b0307dd7'\n")
      end # if
      s_output_message_language=$kibuvits_lc_English
      b_throw=true;
      #----------
      s_spec="writable,is_directory"
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(s_fp_destination_folder,s_spec)
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language, b_throw)
      #----------
      s_spec="readable,is_directory"
      ht_filesystemtest_failures=Kibuvits_fs.verify_access(s_fp_origin,s_spec)
      Kibuvits_fs.exit_if_any_of_the_filesystem_tests_failed(ht_filesystemtest_failures,
      s_output_message_language, b_throw)
      #----------
      s_fp_dest=Pathname.new(s_fp_destination_folder).realpath.to_s
      s_fp_dest=s_fp_dest.gsub(/[\/]+/,$kibuvits_lc_slash)
      s_fp_dest.sub!(/[\/]+$/,$kibuvits_lc_emptystring)

      s_orig=Pathname.new(s_fp_origin).realpath.to_s
      s_orig=s_orig.gsub(/[\/]+/,$kibuvits_lc_slash)
      s_orig.sub!(/[\/]+$/,$kibuvits_lc_emptystring)
      #----------
      if s_orig==s_fp_dest
         kibuvits_throw("\n s_orig == s_fp_dest = \""+s_fp_dest +
         "\"\n but the rsync does not throw on that."+
         "\n GUID='ae32e238-2e4b-4cdc-84b1-3040b0307dd7'\n")
      end # if
      #----------
      cmd="nice -n2 rsync -avz --delete "+s_orig+
      ($kibuvits_lc_space+s_fp_dest +" ;")
      ht_stdstreams=kibuvits_sh(cmd)
      s_stdout=ht_stdstreams[$kibuvits_lc_s_stdout]
      s_stderr=ht_stdstreams[$kibuvits_lc_s_stderr]
      if 10<s_stdout.length
         if s_stdout.match(" speedup is ")==nil
            kibuvits_throw("\ncmd=\""+cmd+
            "\"\n s_stdout=\""+s_stdout+"\""+
            "\n GUID='da88c041-aede-4eaa-92b1-3040b0307dd7'\n")
         end # if
      end # if
      if 0<s_stderr.length
         kibuvits_throw("\ncmd=\""+cmd+
         "\"\n s_stderr=\""+s_stderr+"\""+
         "\n GUID='3210bf22-b567-4f24-a2b1-3040b0307dd7'\n")
      end # if
   end # exc_rsync_t1

   def Kibuvits_data_transfer.exc_rsync_t1(s_fp_destination_folder,s_fp_origin)
      Kibuvits_data_transfer.instance.exc_rsync_t1(s_fp_destination_folder,s_fp_origin)
   end # Kibuvits_data_transfer.exc_rsync_t1

   #----------------------------------------------------------------------

   public
   include Singleton

end # class Kibuvits_data_transfer

#==========================================================================
