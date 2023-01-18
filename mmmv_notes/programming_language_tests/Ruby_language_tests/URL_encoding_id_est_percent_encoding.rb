#!/usr/bin/env ruby
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
# Initial code example for this demo originates from
#     https://stackoverflow.com/questions/31318182/percent-encoding-in-ruby
#     archival copy: https://archive.vn/tVt5V
#
#--------------------------------------------------------------------------

def run_demo_lib_CGI(s_unencoded_0)
   require 'cgi' # assumes "gem install cgi", which builds native extentions.
   #--------
   s_encoded_cgi=CGI.escape(s_unencoded_0)
   #--------
   s_0=CGI.unescape(s_encoded_cgi)
   s_unencoded_cgi=s_0.encode('utf-8')
   #--------
   if s_unencoded_cgi!=s_unencoded_0
      raise(Exception.new("\nDecoding failed!\n"+
      "GUID=='6150f01a-1870-4219-ad46-6092612117e7'\n"))
   end
   puts("CGI library decoded:"+s_unencoded_cgi)
end # run_demo_lib_CGI

def run_demo_lib_URI(s_unencoded_0)
   require 'uri' # assumes "gem install uri"
   #--------
   s_encoded_uri=URI.encode_uri_component(s_unencoded_0)
   #--------
   s_0=URI.decode_uri_component(s_encoded_uri)
   s_unencoded_uri=s_0.encode('utf-8')
   #--------
   if s_unencoded_uri!=s_unencoded_0
      raise(Exception.new("\nDecoding failed!\n"+
      "GUID=='6b43be52-be46-4301-a246-6092612117e7'\n"))
   end
   puts("URI library decoded:"+s_unencoded_uri)
end # run_demo_lib_URI

s_unencoded_0="+;:äÄöÖüÜõÕ'\""
run_demo_lib_CGI(s_unencoded_0)
run_demo_lib_URI(s_unencoded_0)
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="26920c17-7b13-4215-8446-6092612117e7"
#==========================================================================
