#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#==========================================================================

S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $S_FP_DIR/the_old_stuff
ruby tester.rb

#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="4d433065-3269-4c76-b82d-300241d057e7"
#==========================================================================
