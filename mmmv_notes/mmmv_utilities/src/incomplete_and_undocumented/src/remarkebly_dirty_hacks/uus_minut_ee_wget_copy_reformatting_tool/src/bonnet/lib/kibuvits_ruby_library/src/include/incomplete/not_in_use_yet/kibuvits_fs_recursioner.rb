#!/usr/bin/env ruby
#==========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
else
   require  "kibuvits_msgc.rb"
end # if
#==========================================================================

class Kibuvits_fs_recursioner

   private

   def paths_collector ar_in
      b_is_folder=nil
      s_1=nil
      s_2=nil
      ar_in.each do |s_path_candidate|
         if KIBUVITS_b_DEBUG
            kibuvits_typecheck binding(), String, s_path_candidate
         end # if
         s_1=s_path_candidate.gsub(/[\n\r]/,"")
         next if  s_1.length==0
         b_is_folder=File.directory? s_1
         @ar_in_elem_b_is_folder<<b_is_folder
         s_2=Kibuvits_os_codelets.convert_file_path_2_unix_format(s_1)
         @ar_paths_in_unix_format<<s_2
         # POOLELI: muuta see Dir abil rekursiivseks
         raise "Subject to completion."
      end # loop
   end # paths_collector

   public
   def initialize ar_or_s_full_path_2_file_or_folder
      ar_in=Kibuvits_ix.normalize2array(ar_or_s_full_path_2_file_or_folder)
      @ar_in_elem_b_is_folder=Array.new
      @ar_paths_in_unix_format=Array.new
      paths_collector(ar_in)
   end #initialize

   def each_file
      b_is_folder=nil
      s_path=nil
      @ar_paths_in_unix_format.size.times do |i|
         next if @ar_in_elem_b_is_folder[i]
         s_path=@ar_paths_in_unix_format[i]
         yield(s_path)
      end # loop
   end # each_file

   def each_folder
      b_is_folder=nil
      s_path=nil
      @ar_paths_in_unix_format.size.times do |i|
         next if !@ar_in_elem_b_is_folder[i]
         s_path=@ar_paths_in_unix_format[i]
         yield(s_path)
      end # loop
   end # each_folder

   # It's the same as the each_folder
   def each_directory
      # The dumb copy-paste is just to avoid the
      # blocks related "magic" and experimentation
      b_is_folder=nil
      s_path=nil
      @ar_paths_in_unix_format.size.times do |i|
         next if !@ar_in_elem_b_is_folder[i]
         s_path=@ar_paths_in_unix_format[i]
         yield(s_path)
      end # loop
   end # each_directory

   def each_path
      s_path=nil
      @ar_paths_in_unix_format.size.times do |i|
         s_path=@ar_paths_in_unix_format[i]
         yield(s_path)
      end # loop
   end # each_path

   private
   def Kibuvits_fs_recursioner.test_normalize2array
      #x=Kibuvits_fs_recursioner.normalize2array("hi")
      #kibuvits_throw "test 1" if x.length!=1
      #x=Kibuvits_fs_recursioner.normalize2array(nil)
      #kibuvits_throw "test 2" if x.length!=1
   end # Kibuvits_fs_recursioner.test_normalize2array

   public
   include Singleton
   def Kibuvits_fs_recursioner.selftest
      ar_msgs=Array.new
      bn=binding()
      #kibuvits_testeval bn, "Kibuvits_fs_recursioner.test_sar"
      return ar_msgs
   end # Kibuvits_fs_recursioner.selftest
end # class Kibuvits_fs_recursioner

#==========================================================================
