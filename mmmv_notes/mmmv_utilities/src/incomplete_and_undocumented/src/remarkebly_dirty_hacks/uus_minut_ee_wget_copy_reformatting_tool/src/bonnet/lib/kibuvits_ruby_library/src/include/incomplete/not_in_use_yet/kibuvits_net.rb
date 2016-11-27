#!/usr/bin/env ruby
#=========================================================================

if !defined? KIBUVITS_HOME
   x=ENV['KIBUVITS_HOME']
   KIBUVITS_HOME=x if (x!=nil and x!="")
end # if

require "monitor"
if defined? KIBUVITS_HOME
   require  KIBUVITS_HOME+"/src/include/kibuvits_msgc.rb"
   require  KIBUVITS_HOME+"/src/include/kibuvits_str.rb"
else
   require  "kibuvits_msgc.rb"
   require  "kibuvits_str.rb"
end # if
require "singleton"

require "net/http"
#==========================================================================

# The class Kibuvits_net is a namespace for functions that
# deal with filesystem related activities, EXCEPT the IO, which
# is considered to be more general and depends on the filesystem.
class Kibuvits_net
   @@lc_s_slash="/"
   @@cache=Hash.new
   def initialize
   end #initialize
   public

   def download_http(ar_s_urls_or_s_url)
      kibuvits_typecheck binding(), [String,Array], ar_s_urls_or_s_url
      ar_in_whole=Kibuvits_ix.normalize2array(ar_s_urls_or_s_url)
      ar_in=Array.new
      i_len=ar_in_whole.length
      i_len.times do |i|
         s_url=ar_in_whole[i]
         ar_in<<s_url.gsub(/^http[:]\/\//,"")
      end # loop
      ht_responses=Hash.new
      resp=nil
      s_left=nil
      s_right=nil
      ar=nil
      i_len.times do |i|
         s_url=ar_in[i]
         kibuvits_writeln s_url
         ar=Kibuvits_str.ar_bisect(s_url,@@lc_s_slash)
         s_left=ar[0]
         s_right=ar[1]
         next if (s_left.length==0)||(s_right.length==0)
         begin
            Net::HTTP.start(s_left) do |http|
               resp = http.get(@@lc_s_slash+s_right)
               ht_responses[ar_in_whole[i]]=resp
            end # Net::HTTP
         rescue
         end # rescue
      end # loop
      return ht_responses
   end # array2path

   def Kibuvits_net.download_http(ar_s_urls_or_s_url)
      ht_responses=Kibuvits_net.instance.download_http(ar_s_urls_or_s_url)
      return ht_responses
   end # Kibuvits_net.download_http

   private

   def Kibuvits_net.test_download_http
      if !kibuvits_block_throws{ Kibuvits_net.download_http(42)}
         kibuvits_throw "test 1"
      end # if
   end # Kibuvits_net.test_download_http

   public
   include Singleton
   def Kibuvits_net.selftest
      ar_msgs=Array.new
      kibuvits_testeval binding(), "Kibuvits_net.test_download_http"
      return ar_msgs
   end # Kibuvits_net.selftest

end # class Kibuvits_net

#==========================================================================
#ar=Kibuvits_net.selftest
#ar.each{|s| kibuvits_writeln s}
