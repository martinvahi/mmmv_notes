#!/usr/bin/env bash 
#==========================================================================

if [ "$GEM_HOME" == "" ]; then
        echo ""
        echo "The environment variable GEM_HOME is not set, but "
        echo "it must be set or this script will not run (properly)."
        echo ""
        echo "The GEM_HOME is a standard Ruby environment variable, "
        echo "which means that it's documented online."
        echo ""
        exit;
fi

echo "Installing ..."

gem install rake

