<?php
//=========================================================================
// Copyright martin.vahi@softf1.com that has an
// Estonian personal identification code of 38108050020.
// 
// This file is under the 
// http://www.opensource.org/licenses/BSD-3-Clause
// license.
//=========================================================================
// This file is for configuration data that is common for  
// development tools in sirel and the application that uses the sirel.
// The development tools themselves are not necessarily part of the 
// release version of the application. For example, at least some of 
// the tools, for example, the PHP shell, must be turned off in the 
// relase version of the application.
//-------------------------------------------------------------------------

sirelSiteConfig::$debug_PHP=True;
sirelSiteConfig::$debug_JavaScript=True;

sirelSiteConfig::$i_raudrohi_version=21;
sirelSiteConfig::$various['confighook_raudrohi_port']='YUI_3_0';
//sirelSiteConfig::$various['confighook_raudrohi_port']='YUI_3_3_0';
sirelSiteConfig::$use_content_delivery_networks_for_JavaScript_dependency_libs=True;
sirelSiteConfig::$file_path_2_kibuvits_home_folder=sirelSiteConfig::$various['s_path_lib_sirel'].
		'/src/lib/kibuvits_ruby_library/src';

//=========================================================================
?>
