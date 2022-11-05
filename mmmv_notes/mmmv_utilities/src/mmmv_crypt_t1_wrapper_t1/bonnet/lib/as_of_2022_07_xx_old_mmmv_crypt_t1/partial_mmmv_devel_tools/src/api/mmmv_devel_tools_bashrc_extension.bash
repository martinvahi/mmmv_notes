
XXX=$(cat<< 'txt1' #=======================================================

The idea is that if the ~/\.bashrc contains lines like

export MMMV_DEVEL_TOOLS_HOME=<a path to the ./../../> # ./src/bonnet/../../
source "$MMMV_DEVEL_TOOLS_HOME/src/api/mmmv_devel_tools_bashrc_extension.bash"

then all of the mmmv_devel_tools subproject executables are added to the 
PATH without writing them out manually to the ~/.bashrc every time the 
mmmv_devel_tools gets updated.

txt1
)#=========================================================================

if [ "$MMMV_DEVEL_TOOLS_HOME" == "" ]; then
        echo"" 
        echo"" 
        echo "Mandatory environment variable, MMMV_DEVEL_TOOLS_HOME, has not been set. "
        echo"" 
        echo"" 
        exit;
fi

MMMV_DEVEL_TOOLS_PATHS=""
RENESSAATOR_HOME="$MMMV_DEVEL_TOOLS_HOME/src/mmmv_devel_tools/renessaator"
BREAKDANCEMAKE_HOME="$MMMV_DEVEL_TOOLS_HOME/src/mmmv_devel_tools/breakdancemake"
UPGUID_HOME="$MMMV_DEVEL_TOOLS_HOME/src/mmmv_devel_tools/GUID_trace/src/UpGUID"
JUMPGUID_HOME="$MMMV_DEVEL_TOOLS_HOME/src/mmmv_devel_tools/GUID_trace/src/JumpGUID"
MMMV_CRYPT_T1_HOME="$MMMV_DEVEL_TOOLS_HOME/src/mmmv_devel_tools/mmmv_crypt_t1"
MMMV_BASH_SCRIPTS="$MMMV_DEVEL_TOOLS_HOME/src/mmmv_devel_tools/various_scripts/bash_scripts"


MMMV_DEVEL_TOOLS_PATHS="$MMMV_DEVEL_TOOLS_PATHS:$RENESSAATOR_HOME/src"
MMMV_DEVEL_TOOLS_PATHS="$MMMV_DEVEL_TOOLS_PATHS:$BREAKDANCEMAKE_HOME/src"
MMMV_DEVEL_TOOLS_PATHS="$MMMV_DEVEL_TOOLS_PATHS:$UPGUID_HOME/src"
MMMV_DEVEL_TOOLS_PATHS="$MMMV_DEVEL_TOOLS_PATHS:$JUMPGUID_HOME/src/devel/core"
MMMV_DEVEL_TOOLS_PATHS="$MMMV_DEVEL_TOOLS_PATHS:$MMMV_CRYPT_T1_HOME/src"
MMMV_DEVEL_TOOLS_PATHS="$MMMV_DEVEL_TOOLS_PATHS:$MMMV_BASH_SCRIPTS"

export PATH="$MMMV_DEVEL_TOOLS_PATHS:$PATH"
