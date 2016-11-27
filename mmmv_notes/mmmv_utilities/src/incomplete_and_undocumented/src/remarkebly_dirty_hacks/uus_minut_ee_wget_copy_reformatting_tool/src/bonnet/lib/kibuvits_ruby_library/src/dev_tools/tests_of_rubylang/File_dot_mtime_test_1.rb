#!/usr/bin/env ruby
#===============================================================

def str2file(s_a_string, s_fp)
   begin
      file=File.open(s_fp, "w")
      file.write(s_a_string)
      file.close
   rescue Exception =>err
      raise "No comments. GUID='50b06922-3b23-45cc-9010-300030a1aed7' \n"+
      "s_a_string=="+s_a_string+"\n"+err.to_s+"\n\n"
   end #
end # str2file


def run_test_case
   s_fp="/tmp/its_ok_to_delete_this_file.txt"
   s_file_content="Welcome to the bug-gy paradise!"
   s_mtime_1=42
   s_mtime_2=42
   begin
      str2file(s_file_content,s_fp)
      s_mtime_1=File.mtime(s_fp).to_s
      puts("\n    File.mtime=="+s_mtime_1.to_s)
      sleep(2) # In seconds. File modification timestamps have 1s resolution.
      str2file(s_file_content+"\nA new line.",s_fp)
      s_mtime_2=File.mtime(s_fp).to_s
      puts("    File.mtime=="+s_mtime_2.to_s)
      File.delete(s_fp) if File.exists? s_fp
      if s_mtime_1==s_mtime_2
         puts "\nFlaw exists."
      else
         puts "\nFlaw does NOT exists."
      end # if
      puts "\n\n"
   rescue Exception =>err
      File.delete(s_fp) if File.exists? s_fp
      puts "Exception: err=="+err.to_s
   end #
end # run_test_case

run_test_case()



