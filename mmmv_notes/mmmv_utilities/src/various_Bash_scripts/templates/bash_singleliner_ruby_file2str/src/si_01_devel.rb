#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
#
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#--------------------------------------------------------------------------

def file2str(s_file_path) ;
   s_out="" ;
   s_fp=s_file_path ;
   begin ;
      File.open(s_fp) do |file| ;
         while s_line = file.gets; s_out<<s_line ; end ;
      end ;
   rescue Exception =>err ;
      raise(Exception.new("\n"+err.to_s+"\n\ns_file_path=="+s_file_path+ "\n GUID='4e09b717-3c8c-48c3-9112-e1c1413195e7'\n\n")) ;
   end ;
   return s_out ;
end ;

s=file2str("./data.txt")
puts s

#==========================================================================
