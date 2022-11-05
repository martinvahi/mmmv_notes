#!/usr/bin/env ruby
=begin
 Copyright 2010, martin.vahi@softf1.com that has an
 Estonian personal identification code of 38108050020.

 This file is licensed under the BSD license:
 http://www.opensource.org/licenses/bsd-license.php
=end
#==========================================================================
#--- start of a distracting hack to keep this example working -------------
if !defined? KIBUVITS_HOME
   require 'pathname'
   ob_pth_0=Pathname.new(__FILE__).realpath
   require(ob_pth_0.parent.parent.parent.parent.to_s+
   "/src/include/kibuvits_boot.rb")
end # if
require  KIBUVITS_HOME+"/src/include/kibuvits_all.rb"
#----------end of the distracting hack ------------------------------------

require  KIBUVITS_HOME+'/src/include/kibuvits_GUID_generator.rb'

puts Kibuvits_GUID_generator.generate_GUID # And that's it. :-)

