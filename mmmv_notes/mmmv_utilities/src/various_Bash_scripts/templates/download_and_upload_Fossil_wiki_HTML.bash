#!/usr/bin/env bash
#==========================================================================
# Initial author of this file: Martin.Vahi@softf1.com
# This file is in public domain.
# The following line is a spdx.org license label line:
# SPDX-License-Identifier: 0BSD
#
# As primitive as this script is, it actually works with 
# Fossil version 2.18, because the Fossil outputs a
# useful error message.
#--------------------------------------------------------------------------

S_FP_FOSSILREPOSITORY="/full/path/to/a.fossilrepository"

#--------------------------------------------------------------------------
if [ "$3" != "" ]; then
    fossil wiki --repository=$S_FP_FOSSILREPOSITORY "$1" "$2" "$3"
else
    if [ "$2" != "" ]; then
        fossil wiki --repository=$S_FP_FOSSILREPOSITORY "$1" "$2"
    else
        if [ "$1" != "" ]; then
            fossil wiki --repository=$S_FP_FOSSILREPOSITORY "$1"
        else
            fossil wiki --repository=$S_FP_FOSSILREPOSITORY 
        fi
    fi
fi
#--------------------------------------------------------------------------
#
# Usage examples:
#
#     fossil wiki --repository=$S_FP_FOSSILREPOSITORY list
#     # prints a list of all wiki page names to console
#
#     fossil wiki --repository=$S_FP_FOSSILREPOSITORY \
#         export "Wiki page name" > can_be_edited_with_a_proper_IDE.html
#
#     fossil wiki --repository=$S_FP_FOSSILREPOSITORY \
#         commit can_be_edited_with_a_proper_IDE.html "Wiki page name"
#     # uploads a new HTML to the "Wiki page name".
#
#--------------------------------------------------------------------------
# S_VERSION_OF_THIS_FILE="ec19d859-4b1b-4059-81d2-90e2f06127e7"
#==========================================================================
