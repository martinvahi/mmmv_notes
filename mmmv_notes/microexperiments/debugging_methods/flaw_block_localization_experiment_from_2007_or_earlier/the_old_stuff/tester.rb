#!/usr/bin/env ruby
#--------------------------------------------------------------------
=begin
	This file is in public domain.
        SPDX-License-Identifier: 0BSD
	Author of the relatively awful and really old code in 
        this file from year 2007 or earlier: Martin.Vahi@softf1.com
=end
#--------------------------------------------------------------------
require ENV["PWD"].to_s + "/testscript_parser.rb"
include SpectrumbasedDiagnosis
#--------------------------------------------------------------------
SpectrumbasedDiagnosis.execute_autotest( ENV["PWD"].to_s + "/testitav.rb",
	"Ruby")
#--------------------------------------------------------------------

