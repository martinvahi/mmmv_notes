#!/bin/bash


#-----logmessagefiles--existence--verification--start----
B_LOGMESSAGES_FOLDER_EXISTS="false"
#------
if [ -e ./individual_log_entries ]; then
if [ -d ./individual_log_entries ]; then
    B_LOGMESSAGES_FOLDER_EXISTS="true"
fi
else
    B_LOGMESSAGES_FOLDER_EXISTS="false"
fi
#------
if [ "$B_LOGMESSAGES_FOLDER_EXISTS" == "false" ]; then
    mkdir -p ./individual_log_entries 
    if [ -e ./individual_log_entries ]; then
    if [ -d ./individual_log_entries ]; then
        B_LOGMESSAGES_FOLDER_EXISTS="true"
    fi
    else
        B_LOGMESSAGES_FOLDER_EXISTS="false"
        echo ""
        echo "It seems that the folder ./individual_log_entries "
        echo "does not exist. "
        echo "pwd==`pwd`"
        echo ""
        exit;
    fi
fi
#-----logmessagefiles--existence--verification--end------



PHP_SCRIPT="
        \$s_path_lib_sirel=realpath('./../../');
        if(exec('uname -n ;')=='2ikeselaulja') {
        	\$s_path_lib_sirel='/home/zornilemma/Projektid/progremise_infrastruktuur/teeke/sirel/sirel/src';
        } // if
        require_once(\$s_path_lib_sirel.'/sirel_core.php');
"

PHP_SCRIPT="$PHP_SCRIPT sirelSiteConfig::\$log_folder='$PWD'; "
PHP_SCRIPT="$PHP_SCRIPT \$s=sirelLogger::to_s(); "
PHP_SCRIPT="$PHP_SCRIPT print(str_replace('<br/>','    ',\$s)); "

php5 -r "$PHP_SCRIPT" ;


