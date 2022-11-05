
# The mmmv_devel_tools core reads this file in as text
# and runs it with eval.
if !defined? RAUDROHI_HOME
   RAUDROHI_HOME=ENV["RAUDROHI_HOME"]
end # if

def mmmv_devel_tools_default_configuration(ht_config)

   s_full_path_1="/tmp/single_source_file.fileextension"
   s_full_path_2="/tmp/single_source_file.fileextension"
   s_full_path_3="/tmp/awesome_project_folder"
   ar=[s_full_path_1,s_full_path_2,s_full_path_3]

   # One path per element.
   # The GUIDs that are found from the error stack will be
   # searched from files that reside in those folders.
   ht_config["ar_GUID_trace_folders_and_files_that_will_be_searched_for_GUIDs"]=[] # must be an Array

   # Will override the
   #
   #     ar_GUID_trace_folders_and_files_that_will_be_searched_for_GUIDs
   #
   # It's practically mandatory to use it for excluding
   # the scanning of dependencies that are created by third parites.
   ht_config["ar_GUID_trace_path_prefixes_of_ignorable_folders_and_files"]=[]

   ar_fns=["*.js","*.rb","*.php","*.java","*.cpp","*.c","*.h","*.hpp","*.py","*.bash"]
   ht_config["ar_GUID_trace_file_name_glob_patterns_according_to_Ruby_stdlib_class_Dir_method_glob"]=ar_fns


end # mmmv_devel_tools_default_configuration
