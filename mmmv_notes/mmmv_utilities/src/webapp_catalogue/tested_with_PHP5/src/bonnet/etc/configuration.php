<?php
//=========================================================================
// This file is in public domain.
//
// The following line is a spdx.org license label line:
// SPDX-License-Identifier: 0BSD
//=========================================================================

sirelSiteConfig::$various['i_web_catalogue_config_ls_depth']=21;

//-------------------------------------------------------------------------

// The regexes are fed to mb_ereg and their correct values are
// quite hellish to find. I recommend using the KomodoIDE regex
// experimentation tool for testing out the regexes.
$arht=array();
array_push($arht,'.+index.html');
array_push($arht,'.+index.php[^\d]'); # to exclude ./index.php5
array_push($arht,'.+demo.+.html');
array_push($arht,'.+demo.+.php');
array_push($arht,'.+hallo_world.*.html');
array_push($arht,'.+hallo_world.*.php');
//array_push($arht,'.+.html');
sirelSiteConfig::$various['arht_regexes_to_match_listed_paths']=$arht;

//-------------------------------------------------------------------------
$arht_skiplist=array();
// The values are not pushed to the array, becaouse due to efficiency reasons
// the code uses the PHP function array_key_exists(...)
$arht_skiplist['.git']=42;
$arht_skiplist['.hg']=42;
$arht_skiplist['.svn']=42;
$arht_skiplist['IDE']=42;
$arht_skiplist['SVN_hoidlad']=42;
$arht_skiplist['2012_11']=42;
$arht_skiplist['2012_12']=42;
$arht_skiplist['2013_03']=42;
$arht_skiplist['yui_3_0']=42;
$arht_skiplist['yui_3_3_0']=42;
$arht_skiplist['yui_3_9_0']=42;
$arht_skiplist['incomplete']=42;
$arht_skiplist['d0']=42;
$arht_skiplist['d1']=42;
$arht_skiplist['d2']=42;
$arht_skiplist['d3']=42;
$arht_skiplist['d4']=42;
$arht_skiplist['d5']=42;
$arht_skiplist['d6']=42;
$arht_skiplist['d7']=42;
$arht_skiplist['d8']=42;
$arht_skiplist['d9']=42;
$arht_skiplist['da']=42;
$arht_skiplist['db']=42;
$arht_skiplist['dc']=42;
$arht_skiplist['dd']=42;
$arht_skiplist['de']=42;
$arht_skiplist['df']=42;
sirelSiteConfig::$various['arht_folders_to_skip_from_search']=$arht_skiplist;

//-------------------------------------------------------------------------
$s_0='';
sirelSiteConfig::$various['s_html_body_prefix']=$s_0;

//-------------------------------------------------------------------------
$s_0='';
sirelSiteConfig::$various['s_html_body_suffix']=$s_0;

//=========================================================================
?>
