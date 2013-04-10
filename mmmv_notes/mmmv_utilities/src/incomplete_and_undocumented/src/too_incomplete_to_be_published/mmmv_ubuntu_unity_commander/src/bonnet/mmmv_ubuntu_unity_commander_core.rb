#!/usr/bin/ruby -Ku
#==========================================================================
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
#==========================================================================

#--------------------------------------------------------------------------

class Mmmv_ubuntu_unity_commander_core

   def initialize
   end # initialize

   def s_doc
      msg="\n\nThe Ubuntu Unity window maganger consists of \n"+
              "a single destop that contains multiple workspaces."+
      "\n"+
      "Command line syntax:\n"+
      "\n"+
      "( mmmv_ubuntu_unity_commander get_workspace_width                    ) |\n"+
      "( mmmv_ubuntu_unity_commander get_workspace_height                   ) |\n"+
      "( mmmv_ubuntu_unity_commander go     <desktop number, sarting from 1 ) |\n"

   end # s_doc

   def run
   end # run


end # class Mmmv_ubuntu_unity_commander_core

#--------------------------------------------------------------------------

ob_core=Mmmv_ubuntu_unity_commander_core.new
ob_core.run

#==========================================================================
