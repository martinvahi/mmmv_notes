#!/usr/bin/env bash 
#==========================================================================

export S_FP_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
MMMV_DEVEL_TOOLS_HOME="`cd $S_FP_DIR/../../;pwd`"
unset S_FP_DIR

`which ruby` $MMMV_DEVEL_TOOLS_HOME/src/bonnet/api_core/mmmv_devel_tools_info.rb $1 $2 $3 $4 $5 $6 $7

#==========================================================================

